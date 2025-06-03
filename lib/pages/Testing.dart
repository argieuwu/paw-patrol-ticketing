import 'package:capstone2/data/services/TicketService.dart';
import 'package:flutter/material.dart';
import 'package:capstone2/data/model/UsereBusTicket.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:capstone2/data/controllers/AdminTicket_data_controller.dart';
import 'package:capstone2/data/controllers/UserTicket_data_controller.dart';
import 'package:capstone2/data/model/AdminBusTicket.dart';
import 'package:capstone2/data/model/Checkout.dart';
import 'package:capstone2/data/controllers/CheckoutController.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:url_launcher/url_launcher.dart';

class Testing extends StatefulWidget {
  const Testing({super.key});

  @override
  State<Testing> createState() => _TestingState();
}

class _TestingState extends State<Testing> {
  late Stream<QuerySnapshot> adminTickets;
  late Stream<QuerySnapshot> userTickets;
  final TicketService _ticketService = TicketService();
  final UserTicketController _userTicketController = UserTicketController();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void initState() {
    adminTickets = AdminTicketController().getTickets();
    userTickets = UserTicketController().getUserTickets();
    super.initState();
  }

  Future<void> _showPaymentDialog(
      BuildContext context, AdminBusTicket ticket, int seat) async {
    final amount = ticket.ticketPrice < 20 ? 20 : ticket.ticketPrice;

    final checkout = Checkout(
      amount: ticket.ticketPrice * 1000,
      item_description:
          "Bus ticket from ${ticket.destination[0]} to ${ticket.destination[1]}",
      name: "Bus Ticket",
      quantity: 1,
      description: "Payment for bus ticket - Seat #$seat",
    );

    try {
      final userCheckout = await CheckoutController()
          .createCheckoutController(checkout.toJson());

      if (!mounted) return;

      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Payment Details'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Original Price: ₱${ticket.ticketPrice}'),
              Text('Seat: #$seat'),
              Text(
                  'Route: ${ticket.destination[0]} → ${ticket.destination[1]}'),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Close'),
            ),
            ElevatedButton(
              onPressed: () async {
                final userTicket = UserBusTicket.noID(
                  email: _auth.currentUser!.email ?? '',
                  data: ticket,
                  isPaid: false,
                  seat: seat,
                );

                await _userTicketController.uploadUserTicket(
                    userTicket, checkout, seat);

                if (!mounted) return;
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                      content: Text(
                          'Ticket booked successfully! Please complete the payment.')),
                );
              },
              child: const Text('Confirm Booking'),
            ),
            OutlinedButton(
              onPressed: () async {
                final url = Uri.parse(userCheckout.checkoutURL);
                if (await canLaunchUrl(url)) {
                  await launchUrl(url, mode: LaunchMode.externalApplication);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text(
                            'Something went wrong. Please try again later.')),
                  );
                }
              },
              child: const Text('Proceed to Payment'),
            ),
          ],
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error creating payment: $e')),
      );
    }
  }

  Future<int?> showSeatPickerDialog(
      BuildContext context, AdminBusTicket ticket) async {
    final takenSeats = await _ticketService.getTakenSeats(ticket);
    int? selectedSeat;

    const seatsPerRow = 4;
    const totalSeats = 20;
    final totalRows = (totalSeats / seatsPerRow).ceil();

    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Select a Seat'),
        content: SizedBox(
          width: double.maxFinite,
          child: GridView.builder(
            shrinkWrap: true,
            itemCount: totalRows * 5,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 5,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
            ),
            itemBuilder: (context, index) {
              final col = index % 5;

              if (col == 2) return const SizedBox.shrink();

              final row = index ~/ 5;
              final seatInRow = col > 2 ? col - 1 : col;
              final seatNumber = row * seatsPerRow + seatInRow + 1;

              if (seatNumber > totalSeats) return const SizedBox.shrink();

              final isTaken = takenSeats.contains(seatNumber);
              final isSelected = selectedSeat == seatNumber;

              Color seatColor;
              if (isTaken) {
                seatColor = Colors.indigo[900]!;
              } else if (isSelected) {
                seatColor = Colors.pinkAccent;
              } else {
                seatColor = Colors.grey[300]!;
              }

              return GestureDetector(
                onTap: isTaken
                    ? null
                    : () {
                        selectedSeat = seatNumber;
                        Navigator.pop(context, selectedSeat);
                      },
                child: Container(
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: seatColor,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    '$seatNumber',
                    style: TextStyle(
                      color: isTaken ? Colors.white : Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );

    return selectedSeat;
  }

  Widget _buildRouteList(List<AdminBusTicket> tickets) {
    return ListView.builder(
      itemCount: tickets.length,
      itemBuilder: (context, index) {
        final ticket = tickets[index];
        final isPastDeparture = ticket.departureTime.isBefore(DateTime.now());
        return Card(
          margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${ticket.destination[0]} → ${ticket.destination[1]}',
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text('Departure: ${ticket.departureTime}'),
                const SizedBox(height: 12),

                // Conditional button or label
                Align(
                  alignment: Alignment.centerRight,
                  child: isPastDeparture
                      ? Container(
                          padding: const EdgeInsets.symmetric(
                              vertical: 8, horizontal: 12),
                          decoration: BoxDecoration(
                            color: Colors.orange.shade100,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Text(
                            'Ready for Departure',
                            style: TextStyle(
                              color: Colors.deepOrange,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        )
                      : ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          onPressed: () async {
                            final selectedSeat =
                                await showSeatPickerDialog(context, ticket);
                            if (selectedSeat != null) {
                              await _showPaymentDialog(
                                  context, ticket, selectedSeat);
                            }
                          },
                          child: const Text('Book Ticket'),
                        ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildUserTicketList(List<UserBusTicket> tickets) {
    return ListView.builder(
      itemCount: tickets.length,
      itemBuilder: (context, index) {
        final userTicket = tickets[index];
        return Card(
          elevation: 3,
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Ticket #${userTicket.userTicketId}',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                Text('From: ${userTicket.data.destination[0]}'),
                Text('To: ${userTicket.data.destination[1]}'),
                Text('Departure: ${userTicket.data.departureTime}'),
                Text('Seat: ${userTicket.seat}'),
                Text(
                  'Status: ${userTicket.isPaid ? 'Paid' : 'Unpaid'}',
                  style: TextStyle(
                      color: userTicket.isPaid ? Colors.green : Colors.red,
                      fontWeight: FontWeight.w500),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Scan & Go'),
        centerTitle: true,
        backgroundColor: Colors.blue[700],
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          const SizedBox(height: 16),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              'Available Bus Trips',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: StreamBuilder(
              stream: adminTickets,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (!snapshot.hasData || snapshot.data == null) {
                  return const Center(child: Text("No routes available"));
                }

                final allTickets = snapshot.data!.docs
                    .map((e) => AdminBusTicket.fromJSON(
                        e.data() as Map<String, dynamic>))
                    .toList();

                final upcomingTickets = allTickets.where((ticket) {
                  return ticket.departureTime.isAfter(DateTime.now()) &&
                      !ticket.isCompleted;
                }).toList();

                return _buildRouteList(upcomingTickets);
              },
            ),
          ),
          const Divider(thickness: 1),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Text(
              'Your Booked Tickets',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: StreamBuilder(
              stream: userTickets,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (!snapshot.hasData || snapshot.data == null) {
                  return const Center(child: Text("No Tickets Booked"));
                }

                final userTicketsList = snapshot.data!.docs
                    .map((e) => UserBusTicket.fromJSON(e))
                    .toList();

                return _buildUserTicketList(userTicketsList);
              },
            ),
          ),
        ],
      ),
    );
  }
}
