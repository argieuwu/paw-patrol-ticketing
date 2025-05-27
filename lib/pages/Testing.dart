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

  Future<void> _showPaymentDialog(BuildContext context, AdminBusTicket ticket, int seat) async {

    // dapat 20php pataas ang price na ibutang bai kay dili mo dawat and  paymongo
    //og below baynte
    final amount = ticket.ticketPrice < 20 ? 20 : ticket.ticketPrice;

    final checkout = Checkout(
      amount: ticket.ticketPrice * 1000,
      item_description: "Bus ticket from ${ticket.destination[0]} to ${ticket.destination[1]}",
      name: "Bus Ticket",
      quantity: 1,
      description: "Payment for bus ticket - Seat #$seat",
    );

    try {
      final userCheckout = await CheckoutController().createCheckoutController(checkout.toJson());

      if (!mounted) return;

      //  payment dialog
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Payment Details'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Original Price: ₱${ticket.ticketPrice}'),
              if (ticket.ticketPrice < 20) ...[
              ],
              Text('Seat: #$seat'),
              Text('Route: ${ticket.destination[0]} → ${ticket.destination[1]}'),
              const SizedBox(height: 16),
              const Text('Payment URL:'),
              SelectableText(userCheckout.checkoutURL),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Close'),
            ),
            TextButton(
              onPressed: () async {
                // Create user ticket
                final userTicket = UserBusTicket.noID(
                  email: _auth.currentUser!.email ?? '',
                  data: ticket,
                  isPaid: false,
                  seat: seat,
                );

                // Upload ticket to database
                await _userTicketController.uploadUserTicket(userTicket, checkout, seat);

                if (!mounted) return;
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Ticket booked successfully! Please complete the payment.')),
                );
              },
              child: const Text('Confirm Booking'),
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

  Future<int?> showSeatPickerDialog(BuildContext context, AdminBusTicket ticket) async {
    final takenSeats = await _ticketService.getTakenSeats(ticket);
    int? selectedSeat;

    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Select a Seat'),
        content: SizedBox(
          width: double.maxFinite,
          child: GridView.builder(
            shrinkWrap: true,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4,
              childAspectRatio: 1,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
            ),
            itemCount: ticket.totalSeats,
            itemBuilder: (context, index) {
              final seatNumber = index + 1;
              final isTaken = takenSeats.contains(seatNumber);

              return ElevatedButton(
                onPressed: isTaken ? null : () {
                  selectedSeat = seatNumber;
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: isTaken ? Colors.grey : Colors.blue,
                ),
                child: Text('$seatNumber'),
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
        return Card(
          child: ListTile(
            title: Text('${ticket.destination[0]} → ${ticket.destination[1]}'),
            subtitle: Text(
              'Departure: ${ticket.departureTime.toString()}\n'
                  'Price: ₱${ticket.ticketPrice}\n'
                  'Aircon: ${ticket.isAircon ? "Yes" : "No"}',
            ),
            trailing: ElevatedButton(
              onPressed: () async {
                final selectedSeat = await showSeatPickerDialog(context, ticket);
                if (selectedSeat != null) {
                  await _showPaymentDialog(context, ticket, selectedSeat);
                }
              },
              child: const Text('Book Ticket'),
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
        title: const Text('Home'),
      ),
      body: Column(
        children: [
          Text('Available Bus Trip',
            style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold
            ),
          ),
          const SizedBox(height: 20),
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
                    .map((e) => AdminBusTicket.fromJSON(e.data() as Map<String, dynamic>))
                    .toList();

                final upcomingTickets = allTickets.where((ticket) {
                  return ticket.departureTime.isAfter(DateTime.now()) && !ticket.isCompleted;
                }).toList();

                return _buildRouteList(upcomingTickets);
              },
            ),
          ),
          const SizedBox(height: 40),

          Text('User Booked Tickets'),
          const SizedBox(height: 20),

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

                return ListView.builder(
                  itemCount: userTicketsList.length,
                  itemBuilder: (context, index) {
                    final userTicket = userTicketsList[index];
                    return Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Ticket ID: ${userTicket.userTicketId}'),
                            Text('From: ${userTicket.data.destination[0]}'),
                            Text('To: ${userTicket.data.destination[1]}'),
                            Text('Departure: ${userTicket.data.departureTime}'),
                            Text('Seat: ${userTicket.seat}'),
                            Text('Status: ${userTicket.isPaid ? 'Paid' : 'Unpaid'}'),
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
    );
  }
}
