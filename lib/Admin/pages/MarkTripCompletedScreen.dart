import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:capstone2/data/model/AdminBusTicket.dart';
import 'package:capstone2/data/controllers/AdminTicket_data_controller.dart';
import 'package:intl/intl.dart';

class CompletedBusRoutesScreen extends StatelessWidget {
  const CompletedBusRoutesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text(
              'Completed Bus Travels'
          ),
          ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('admin').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) return const Center(child: CircularProgressIndicator());
          if (snapshot.hasError) return Center(child: Text('Error: ${snapshot.error}'));

          final now = DateTime.now();
          final tickets = snapshot.data?.docs
              .map((doc) => AdminBusTicket.fromJSON(doc.data() as Map<String, dynamic>))
              .toList() ??
              [];

          // Update status for past trips and filter completed ones
          final completedTrips = <AdminBusTicket>[];
          for (var ticket in tickets) {
            if (ticket.departureTime.isBefore(now) && !ticket.isCompleted) {
              AdminTicketController().updateTicketStatus(ticket, true);
            }
            if (ticket.isCompleted || ticket.departureTime.isBefore(now)) {
              completedTrips.add(ticket);
            }
          }

          if (completedTrips.isEmpty) return const Center(child: Text('No completed bus travels.'));

          return ListView.builder(
            itemCount: completedTrips.length,
            itemBuilder: (context, index) => _buildTicketCard(context, completedTrips[index]),
          );
        },
      ),
    );
  }

  Widget _buildTicketCard(BuildContext context, AdminBusTicket ticket) {
    final formattedTime = DateFormat('yyyy-MM-dd – HH:mm').format(ticket.departureTime);

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        title: Text('Route: ${ticket.destination.join(" → ")}'),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 6),
            Text('Departure: $formattedTime'),
            const SizedBox(height: 6),
            Text('Price: ₱${ticket.ticketPrice}'),
            Text('Aircon: ${ticket.isAircon ? "Yes" : "No"}'),
            const SizedBox(height: 6),
            const Text('Status: ✅ Completed',
                style: TextStyle()),
          ],
        ),
        trailing: IconButton(
          icon: const Icon(Icons.delete, color: Colors.red),
          onPressed: () async {
            final confirm = await showDialog<bool>(
              context: context,
              builder: (ctx) => AlertDialog(
                title: const Text('Delete Route'),
                content: const Text('Are you sure you want to delete this completed route?'),
                actions: [
                  TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancel')),
                  TextButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('Delete')),
                ],
              ),
            );
            if (confirm == true) {
              await AdminTicketController().deleteAdminTicket(ticket);
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Completed route deleted')));
            }
          },
        ),
      ),
    );
  }
}