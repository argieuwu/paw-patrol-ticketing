import 'dart:developer';
import 'package:capstone2/data/controllers/UserTicket_data_controller.dart';
import 'package:capstone2/data/model/UsereBusTicket.dart';
import 'package:capstone2/res/app_style.dart';
import 'package:capstone2/screens/tickets/HistoryPage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TicketScreen extends StatelessWidget {
  const TicketScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final Stream<QuerySnapshot> userTickets = UserTicketController().getUserTickets();

    return Scaffold(
      backgroundColor: AppStyle.bgColor,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Tickets",
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.history, color: Colors.black),
                  tooltip: 'View History',
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => BusHistoryPage()),
                    );
                  },
                ),
              ],
            ),
            const SizedBox(height: 20),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: userTickets,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (!snapshot.hasData || snapshot.data == null) {
                    return const Center(child: Text("No tickets found"));
                  }

                  final now = DateTime.now();
                  final today = DateTime(now.year, now.month, now.day);

                  final tickets = snapshot.data!.docs.map((doc) {
                    try {
                      return UserBusTicket.fromJSON(doc);
                    } catch (err) {
                      log("Error parsing ticket: $err");
                      return null;
                    }
                  }).whereType<UserBusTicket>().where((ticket) {
                    final departure = ticket.data.departureTime;
                    final departureDate = DateTime(
                      departure.year,
                      departure.month,
                      departure.day,
                    );
                    return departureDate.isAtSameMomentAs(today) || departureDate.isAfter(today);
                  }).toList();

                  if (tickets.isEmpty) {
                    return const Center(child: Text("No booked tickets yet."));
                  }

                  return ListView.builder(
                    itemCount: tickets.length,
                    itemBuilder: (context, index) {
                      final userTicket = tickets[index];
                      final adminTicket = userTicket.data;
                      final departure = DateFormat('yyyy-MM-dd – HH:mm')
                          .format(adminTicket.departureTime);

                      return Card(
                        elevation: 4,
                        margin: const EdgeInsets.symmetric(vertical: 8),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Ticket ID: ${userTicket.userTicketId}"),
                              Text("Paid: ${userTicket.isPaid ? "Yes" : "No"}"),
                              Text("Seat No: ${userTicket.seat}"),
                              const Divider(),
                              Text("Route: ${adminTicket.destination[0]} → ${adminTicket.destination[1]}"),
                              Text("Departure: $departure"),
                              Text("Total Seats: ${adminTicket.totalSeats}"),
                              Text("Ticket Price: ₱${adminTicket.ticketPrice}"),
                              Text("Aircon: ${adminTicket.isAircon ? "Yes" : "No"}"),
                            ],
                          ),
                        ),
                      );
                    },
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
