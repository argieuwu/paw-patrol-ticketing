import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:capstone2/data/controllers/UserTicket_data_controller.dart';
import 'package:capstone2/data/model/UsereBusTicket.dart';

class BusHistoryPage extends StatelessWidget {
  const BusHistoryPage({super.key});

  Future<void> _confirmDelete(BuildContext context, String? ticketId) async {
    if (ticketId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Invalid ticket ID")),
      );
      return;
    }

    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Delete Ticket"),
        content: const Text("Are you sure you want to delete this ticket?"),
        actions: [
          TextButton(
            child: const Text("Cancel"),
            onPressed: () => Navigator.pop(context, false),
          ),
          TextButton(
            child: const Text("Delete", style: TextStyle(color: Colors.red)),
            onPressed: () => Navigator.pop(context, true),
          ),
        ],
      ),
    );

    if (confirm == true) {
      await UserTicketController().deleteUserTicket(ticketId);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Ticket deleted")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final Stream<QuerySnapshot> userTickets =
        UserTicketController().getUserTickets();

    return Scaffold(
      appBar: AppBar(title: const Text("Bus Ticket History")),
      body: StreamBuilder<QuerySnapshot>(
        stream: userTickets,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (!snapshot.hasData || snapshot.data == null) {
            return const Center(child: Text("No history found."));
          }

          final now = DateTime.now();
          final today = DateTime(now.year, now.month, now.day);

          final completedTickets = snapshot.data!.docs
              .map((e) {
                try {
                  return UserBusTicket.fromJSON(e);
                } catch (_) {
                  return null;
                }
              })
              .whereType<UserBusTicket>()
              .where((ticket) {
                final departure = ticket.data.departureTime;
                final departureDate = DateTime(
                  departure.year,
                  departure.month,
                  departure.day,
                );
                return departureDate.isBefore(today);
              })
              .toList();

          if (completedTickets.isEmpty) {
            return const Center(child: Text("No completed trips yet."));
          }

          return ListView.builder(
            itemCount: completedTickets.length,
            itemBuilder: (context, index) {
              final ticket = completedTickets[index];
              final busData = ticket.data;
              final departure = DateFormat('yyyy-MM-dd – HH:mm')
                  .format(busData.departureTime);

              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ListTile(
                  contentPadding: const EdgeInsets.all(16),
                  title: Text(
                    "${busData.destination[0]} → ${busData.destination[1]}",
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Departure: $departure"),
                      Text("Seat: ${ticket.seat}"),
                      Text("Plate Number: ${busData.plateNumber}"),
                      Text("Status: ${ticket.isPaid ? "Paid" : "Unpaid"}"),
                    ],
                  ),
                  trailing: ticket.userTicketId != null
                      ? IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          tooltip: 'Delete Ticket',
                          onPressed: () =>
                              _confirmDelete(context, ticket.userTicketId),
                        )
                      : null,
                ),
              );
            },
          );
        },
      ),
    );
  }
}
