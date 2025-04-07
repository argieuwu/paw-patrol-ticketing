import 'package:capstone2/data/model/AdminBusTicket.dart';
import 'package:capstone2/data/model/UsereBusTicket.dart';
import 'package:flutter/material.dart';

class ViewBookingsPage extends StatelessWidget {
  final AdminBusTicket route;
  final List<UserBusTicket> bookings;

  const ViewBookingsPage({super.key, required this.route, required this.bookings});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Bookings"), backgroundColor: Colors.green),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Hero(
              tag: 'routeHero-${route.ticketId}',
              child: Material(
                color: Colors.transparent,
                child: Text(
                  'Bookings for ${route.destination[0]} → ${route.destination[1]}',
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: bookings.isEmpty
                  ? const Center(child: Text("No bookings for this route."))
                  : ListView.builder(
                itemCount: bookings.length,
                itemBuilder: (context, index) {
                  final booking = bookings[index];
                  return ListTile(
                    leading: const Icon(Icons.event_seat),
                    title: Text('Seat: ${booking.seat}'),
                    subtitle: Text('Email: ${booking.email}'),
                    trailing: Text('Paid: ₱${booking.isPaid ? route.ticketPrice : 0}'),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
