const functions = require('firebase-functions');
const admin = require('firebase-admin');
const axios = require('axios');
const jwt = require('jsonwebtoken');

admin.initializeApp();

// Reserve Seats Function
exports.reserveSeats = functions.https.onCall(async (data, context) => {
  const { busId, selectedSeats } = data;

  if (!busId || !selectedSeats || selectedSeats.length === 0) {
    throw new functions.https.HttpsError('invalid-argument', 'Missing required fields');
  }

  const busRef = admin.firestore().collection('bus_routes').doc(busId);
  const busDoc = await busRef.get();

  if (!busDoc.exists) {
    throw new functions.https.HttpsError('not-found', 'Bus route not found');
  }

  const seats = busDoc.data().seats;

  // Check if selected seats are available
  for (const seat of selectedSeats) {
    if (seats[seat] !== 'available') {
      throw new functions.https.HttpsError('failed-precondition', `Seat ${seat} is not available`);
    }
  }

  // Update seat status to 'booked'
  const updates = {};
  for (const seat of selectedSeats) {
    updates[`seats.${seat}`] = 'booked';
  }

  await busRef.update(updates);

  return { success: true };
});

// Process Payment Function
exports.processPayment = functions.https.onCall(async (data, context) => {
  const { bookingId, amount, paymentMethod } = data;

  // Call Paymongo API to process payment
  try {
    const response = await axios.post('https://api.paymongo.com/v1/payments', {
      amount,
      currency: 'PHP',
      paymentMethod,
    }, {
      headers: {
        'Authorization': `Basic ${Buffer.from('YOUR_PAYMONGO_SECRET_KEY:').toString('base64')}`,
      },
    });

    // Update payment status in Firestore
    await admin.firestore().collection('payments').doc(bookingId).set({
      status: 'success',
      timestamp: admin.firestore.FieldValue.serverTimestamp(),
    });

    return { success: true, paymentId: response.data.id };
  } catch (error) {
    console.error('Payment failed:', error);
    await admin.firestore().collection('payments').doc(bookingId).set({
      status: 'failed',
      timestamp: admin.firestore.FieldValue.serverTimestamp(),
    });
    throw new functions.https.HttpsError('internal', 'Payment processing failed');
  }
});

// Generate QR Code Function
exports.generateQRCode = functions.https.onCall(async (data, context) => {
  const { busId, selectedSeats, userId } = data;

  const payload = {
    busId,
    selectedSeats,
    userId,
    timestamp: Date.now(),
  };

  const token = jwt.sign(payload, 'YOUR_SECRET_KEY', { expiresIn: '1h' });

  return { qrCodeData: token };
});