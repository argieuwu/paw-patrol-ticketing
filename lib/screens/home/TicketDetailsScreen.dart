import 'package:capstone2/screens/home/paymentScreen.dart';
import 'package:capstone2/screens/home/widgets/SeatWidget.dart';
import 'package:flutter/material.dart';

class TicketDetailsScreen extends StatelessWidget {
  final String busId;
  final String departure;
  final String destination;
  final String departureTime;
  final String duration;
  final double price;
  final List<dynamic> seats;

  const TicketDetailsScreen({
    required this.busId,
    required this.departure,
    required this.destination,
    required this.departureTime,
    required this.duration,
    required this.price,
    required this.seats,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Ticket Details')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Departure: $departure'),
            Text('Destination: $destination'),
            Text('Departure Time: $departureTime'),
            Text('Duration: $duration'),
            Text('Price: ₱$price'),
            const SizedBox(height: 20),
            Text('Select Seats:', style: TextStyle(fontSize: 18)),
            Expanded(
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                ),
                itemCount: seats.length,
                itemBuilder: (context, index) {
                  final seat = seats[index];
                  var isSelected = null;
                  return SeatWidget(
                    seatNumber: seat['seat_number'],
                    isAvailable: seat['is_available'],
                    onSelected: (selected) {
                      // Handle seat selection
                    },
                    isSelected: isSelected,
                  );
                },
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PaymentScreen(
                      busId: busId,
                      selectedSeats: [], // Pass selected seats here
                      totalAmount: price,
                    ),
                  ),
                );
              },
              child: Text('Proceed to Payment'),
            ),
          ],
        ),
      ),
    );
  }
}
