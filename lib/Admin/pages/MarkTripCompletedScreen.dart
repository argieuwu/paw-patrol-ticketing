import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:capstone2/data/model/AdminBusTicket.dart';
import 'package:capstone2/data/controllers/AdminTicket_data_controller.dart';
import 'package:intl/intl.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:capstone2/res/app_style.dart'; // Assuming you have this for colors

class CompletedBusRoutesScreen extends StatelessWidget {
  const CompletedBusRoutesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppStyle.searchtab3, // light background color
      appBar: AppBar(
        backgroundColor: AppStyle.bgColor2,
        elevation: 2,
        title: Text(
          'Completed Bus Travels',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.bold,
            fontSize: 20,
            color: AppStyle.textColor3,
          ),
        ),
        centerTitle: true,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('admin').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final now = DateTime.now();
          final tickets = snapshot.data?.docs
                  .map((doc) => AdminBusTicket.fromJSON(
                      doc.data() as Map<String, dynamic>))
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

          if (completedTrips.isEmpty) {
            return Center(
              child: Text(
                'No completed bus travels.',
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  color: AppStyle.textColor,
                ),
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.symmetric(vertical: 12),
            itemCount: completedTrips.length,
            itemBuilder: (context, index) =>
                _buildTicketCard(context, completedTrips[index]),
          );
        },
      ),
    );
  }

  Widget _buildTicketCard(BuildContext context, AdminBusTicket ticket) {
    final formattedTime =
        DateFormat('yyyy-MM-dd – HH:mm').format(ticket.departureTime);

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Route: ${ticket.destination.join(" → ")}',
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppStyle.textColor2,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Departure: $formattedTime',
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      color: AppStyle.textColor,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Price: ₱${ticket.ticketPrice}',
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      color: AppStyle.textColor,
                    ),
                  ),
                  Text(
                    'Aircon: ${ticket.isAircon ? "Yes" : "No"}',
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      color: AppStyle.textColor,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      const Icon(Icons.check_circle,
                          color: Colors.green, size: 18),
                      const SizedBox(width: 6),
                      Text(
                        'Status: Completed',
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Colors.green[700],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            IconButton(
              icon: Container(
                decoration: BoxDecoration(
                  color: Colors.red.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                padding: const EdgeInsets.all(8),
                child: const Icon(Icons.delete, color: Colors.red),
              ),
              onPressed: () async {
                final confirm = await showDialog<bool>(
                  context: context,
                  builder: (ctx) => AlertDialog(
                    title: const Text('Delete Route'),
                    content: const Text(
                        'Are you sure you want to delete this completed route?'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(ctx, false),
                        child: const Text('Cancel'),
                      ),
                      TextButton(
                        onPressed: () => Navigator.pop(ctx, true),
                        child: const Text('Delete'),
                      ),
                    ],
                  ),
                );
                if (confirm == true) {
                  await AdminTicketController().deleteAdminTicket(ticket);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Completed route deleted')),
                  );
                }
              },
              tooltip: 'Delete route',
            ),
          ],
        ),
      ),
    );
  }
}
