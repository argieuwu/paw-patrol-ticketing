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
    final Stream<QuerySnapshot> userTickets =
        UserTicketController().getUserTickets();

    return Scaffold(
      backgroundColor: AppStyle.bgColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Your Tickets",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.history, color: Colors.black),
                    tooltip: 'View History',
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const BusHistoryPage()),
                      );
                    },
                  ),
                ],
              ),
              const SizedBox(height: 10),
              // Ticket Tabs
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

                    final tickets = snapshot.data!.docs
                        .map((doc) {
                          try {
                            return UserBusTicket.fromJSON(doc);
                          } catch (err) {
                            log("Error parsing ticket: $err");
                            return null;
                          }
                        })
                        .whereType<UserBusTicket>()
                        .toList();

                    final ongoingTickets = tickets.where((ticket) {
                      final departure = ticket.data.departureTime;
                      final departureDate = DateTime(
                          departure.year, departure.month, departure.day);
                      return departureDate.isAtSameMomentAs(today) ||
                          departureDate.isAfter(today);
                    }).toList();

                    final completedTickets = tickets.where((ticket) {
                      final departure = ticket.data.departureTime;
                      final departureDate = DateTime(
                          departure.year, departure.month, departure.day);
                      return departureDate.isBefore(today);
                    }).toList();

                    return DefaultTabController(
                      length: 2,
                      child: Column(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.grey[200],
                            ),
                            child: const TabBar(
                              labelColor: Colors.blue,
                              unselectedLabelColor: Colors.black54,
                              indicatorColor: Colors.blue,
                              tabs: [
                                Tab(text: 'Ongoing'),
                                Tab(text: 'Completed'),
                              ],
                            ),
                          ),
                          const SizedBox(height: 10),
                          Expanded(
                            child: TabBarView(
                              children: [
                                _buildTicketList(ongoingTickets),
                                _buildTicketList(completedTickets),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTicketList(List<UserBusTicket> tickets) {
    if (tickets.isEmpty) {
      return const Center(child: Text("No tickets found"));
    }

    return ListView.builder(
      itemCount: tickets.length,
      itemBuilder: (context, index) {
        final userTicket = tickets[index];
        final adminTicket = userTicket.data;
        final departure = DateFormat('MMM d, yyyy – hh:mm a')
            .format(adminTicket.departureTime);

        return Card(
          elevation: 4,
          margin: const EdgeInsets.symmetric(vertical: 8),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        'Ticket #${userTicket.userTicketId}',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                        overflow: TextOverflow.ellipsis, // Truncate if needed
                      ),
                    ),
                    const SizedBox(width: 10),
                    Flexible(
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: userTicket.isPaid
                              ? Colors.green[100]
                              : Colors.orange[100],
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          userTicket.isPaid
                              ? 'Payment Successful'
                              : 'Payment Pending',
                          style: TextStyle(
                            color: userTicket.isPaid
                                ? Colors.green
                                : Colors.orange,
                            fontWeight: FontWeight.w600,
                            fontSize: 12,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 8),
                const Divider(),
                Text(
                    "Route: ${adminTicket.destination[0]} → ${adminTicket.destination[1]}"),
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
  }
}
