import 'package:capstone2/data/controllers/UserTicket_data_controller.dart';
import 'package:capstone2/data/model/UsereBusTicket.dart';
import 'package:capstone2/res/app_style.dart';
import 'package:capstone2/screens/tickets/HistoryPage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
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
                  Text(
                    "Your Booked Tickets",
                    style: GoogleFonts.poppins(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: AppStyle.textColor2,
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.history, color: AppStyle.textColor2),
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
              // Stream & Tabs
              Expanded(
                child: StreamBuilder<QuerySnapshot>(
                  stream: userTickets,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(
                        child: CircularProgressIndicator(
                          color: AppStyle.busrouteBG2Des,
                        ),
                      );
                    } else if (!snapshot.hasData || snapshot.data == null) {
                      return Center(
                        child: Text(
                          "No tickets found",
                          style: GoogleFonts.poppins(
                            color: AppStyle.textColor,
                          ),
                        ),
                      );
                    }

                    final now = DateTime.now();
                    final today = DateTime(now.year, now.month, now.day);

                    final tickets = snapshot.data!.docs
                        .map((doc) {
                          try {
                            return UserBusTicket.fromJSON(doc);
                          } catch (err) {
                            debugPrint("Error parsing ticket: $err");
                            return null;
                          }
                        })
                        .whereType<UserBusTicket>()
                        .toList();

                    final ongoingTickets = tickets.where((ticket) {
                      final date = ticket.data.departureTime;
                      final depDate = DateTime(date.year, date.month, date.day);
                      return depDate.isAtSameMomentAs(today) ||
                          depDate.isAfter(today);
                    }).toList();

                    final completedTickets = tickets.where((ticket) {
                      final date = ticket.data.departureTime;
                      final depDate = DateTime(date.year, date.month, date.day);
                      return depDate.isBefore(today);
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
      return Center(
        child: Text(
          "No tickets found",
          style: GoogleFonts.poppins(
            color: AppStyle.textColor,
          ),
        ),
      );
    }

    return ListView.builder(
      itemCount: tickets.length,
      itemBuilder: (context, index) {
        final ticket = tickets[index];
        final bus = ticket.data;
        final departure =
            DateFormat('MMM d, yyyy – hh:mm a').format(bus.departureTime);

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
                // Header Row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        'Ticket #${ticket.userTicketId}',
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: AppStyle.textColor2,
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: ticket.isPaid
                            ? Colors.green[100]
                            : Colors.orange[100],
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        ticket.isPaid
                            ? 'Payment Successful'
                            : 'Payment Pending',
                        style: GoogleFonts.poppins(
                          color: ticket.isPaid ? Colors.green : Colors.orange,
                          fontWeight: FontWeight.w600,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                const Divider(),
                const SizedBox(height: 8),
                // Ticket Details
                _buildTicketDetailRow(
                  Icons.directions_bus,
                  'Route: ${bus.destination[0]} → ${bus.destination[1]}',
                ),
                _buildTicketDetailRow(
                  Icons.event,
                  'Departure: $departure',
                ),
                _buildTicketDetailRow(
                  Icons.confirmation_number,
                  'Price: ₱${bus.ticketPrice}',
                ),
                _buildTicketDetailRow(
                  Icons.chair_alt,
                  'Seat No: ${ticket.seat}',
                ),
                _buildTicketDetailRow(
                  Icons.directions_bus_filled,
                  'Plate No: ${bus.plateNumber}',
                ),
                _buildTicketDetailRow(
                  Icons.ac_unit,
                  'Aircon: ${bus.isAircon ? "Yes" : "No"}',
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildTicketDetailRow(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(icon, size: 18, color: AppStyle.coolLightGray),
          const SizedBox(width: 8),
          Text(
            text,
            style: GoogleFonts.poppins(
              fontSize: 14,
              color: AppStyle.textColor,
            ),
          ),
        ],
      ),
    );
  }
}
