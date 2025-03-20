import 'package:flutter/material.dart';

class ViewBookingsScreen extends StatelessWidget {
  const ViewBookingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('View Bookings'),
        backgroundColor: Colors.blue,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: const [
          // Static demo bookings
          ListTile(
            title: Text('Passenger: John Doe'),
            subtitle: Text('Seat: 1A | Bus: Tagum - Davao | Paid: ₱200'),
          ),
          ListTile(
            title: Text('Passenger: Jane Smith'),
            subtitle: Text('Seat: 2B | Bus: Tagum - Davao | Paid: ₱200'),
          ),
          ListTile(
            title: Text('Passenger: Alex Cruz'),
            subtitle: Text('Seat: 3A | Bus: Davao - Tagum | Paid: ₱250'),
          ),
        ],
      ),
    );
  }
}