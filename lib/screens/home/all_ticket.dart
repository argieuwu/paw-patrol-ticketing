import 'package:flutter/material.dart';

class TicketView extends StatelessWidget {
  final Map<String, dynamic> ticket;
  final VoidCallback onTap;

  const TicketView({required this.ticket, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.all(8),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 2,
              blurRadius: 5,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Departure: ${ticket['departure']}'),
            Text('Destination: ${ticket['destination']}'),
            Text('Departure Time: ${ticket['departure_time']}'),
            Text('Duration: ${ticket['duration']}'),
            Text('Price: ₱${ticket['price']}'),
          ],
        ),
      ),
    );
  }
}
