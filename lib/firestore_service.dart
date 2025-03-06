import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  static const String _paymongoSecretKey = 'YOUR_PAYMONGO_SECRET_KEY';
  static const String _paymongoBaseUrl = 'https://api.paymongo.com/v1';

  // Fetch available bus schedules in real-time
  Stream<QuerySnapshot> getBusSchedulesRealtime(String from, String to) {
    return _db
        .collection('bus_schedules')
        .where('departure', isEqualTo: from)
        .where('destination', isEqualTo: to)
        .snapshots();
  }

  // Reserve a seat in real-time
  Future<String> reserveSeat(
      String scheduleId, List<String> seatNumbers) async {
    final user = _auth.currentUser;
    if (user == null) return 'User not logged in';

    final docRef = _db.collection('bus_schedules').doc(scheduleId);
    final docSnapshot = await docRef.get();
    if (!docSnapshot.exists) return 'Bus schedule not found';

    List<dynamic> reservedSeats = docSnapshot.data()?['reservedSeats'] ?? [];
    for (var seat in seatNumbers) {
      if (reservedSeats.contains(seat)) return 'Seat $seat is already booked';
    }

    reservedSeats.addAll(seatNumbers);
    await docRef.update({'reservedSeats': reservedSeats});

    return 'Seats reserved successfully';
  }

  // Create PayMongo Payment Intent
  Future<String> createPaymentIntent(double amount) async {
    final url = Uri.parse('$_paymongoBaseUrl/payment_intents');
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization':
            'Basic ' + base64Encode(utf8.encode('$_paymongoSecretKey:')),
      },
      body: jsonEncode({
        'data': {
          'attributes': {
            'amount': (amount * 100).toInt(), // Convert to cents
            'currency': 'PHP',
            'payment_method_allowed': ['card', 'gcash', 'grab_pay'],
            'description': 'Bus Ticket Payment',
          }
        }
      }),
    );

    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      return responseData['data']['id'];
    } else {
      return 'Error creating payment intent: ${response.body}';
    }
  }

  // Process payment via PayMongo
  Future<String> processPayment(String scheduleId, List<String> seatNumbers,
      double amount, String paymentMethodId) async {
    final user = _auth.currentUser;
    if (user == null) return 'User not logged in';

    final paymentIntentId = await createPaymentIntent(amount);
    if (paymentIntentId.contains('Error')) return paymentIntentId;

    final url =
        Uri.parse('$_paymongoBaseUrl/payment_intents/$paymentIntentId/attach');
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization':
            'Basic ' + base64Encode(utf8.encode('$_paymongoSecretKey:')),
      },
      body: jsonEncode({
        'data': {
          'attributes': {
            'payment_method': paymentMethodId,
          }
        }
      }),
    );

    if (response.statusCode == 200) {
      await _db.collection('tickets').add({
        'userId': user.uid,
        'scheduleId': scheduleId,
        'seatNumbers': seatNumbers,
        'amount': amount,
        'status': 'paid',
        'timestamp': FieldValue.serverTimestamp(),
      });
      await generateQRCode(user.uid, scheduleId);
      return 'Payment successful, ticket booked';
    } else {
      return 'Payment failed: ${response.body}';
    }
  }

  // Generate QR Code after successful payment
  Future<void> generateQRCode(String userId, String scheduleId) async {
    String qrData = 'scan&go:$userId:$scheduleId';
    await _db.collection('tickets').add({'qrCode': qrData});
  }

  // Fetch seat availability for a bus
  Future<DocumentSnapshot> getSeatAvailability(String busId) {
    return _db.collection('bus_schedules').doc(busId).get();
  }
}
