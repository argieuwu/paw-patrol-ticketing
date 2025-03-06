import 'package:flutter/material.dart';

class PaymentScreen extends StatelessWidget {
  final String busId;
  final List<String> selectedSeats;
  final double totalAmount; // Add this parameter

  const PaymentScreen({
    Key? key,
    required this.busId,
    required this.selectedSeats,
    required this.totalAmount, // Mark it as required
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Payment'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Bus ID: $busId', style: TextStyle(fontSize: 18)),
            SizedBox(height: 10),
            Text('Selected Seats: ${selectedSeats.join(', ')}',
                style: TextStyle(fontSize: 18)),
            SizedBox(height: 10),
            Text('Total Amount: ₱$totalAmount', // Display the total amount
                style: TextStyle(fontSize: 18)),
            SizedBox(height: 20),
            // Add payment options and logic here
            ElevatedButton(
              onPressed: () {
                // Process payment
              },
              child: Text('Proceed to Payment'),
            ),
          ],
        ),
      ),
    );
  }
}
