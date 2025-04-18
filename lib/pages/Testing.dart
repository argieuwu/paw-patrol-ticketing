import 'package:capstone2/data/model/UsereBusTicket.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:capstone2/data/controllers/AdminTicket_data_controller.dart';
import 'package:capstone2/data/controllers/UserTicket_data_controller.dart';
import 'package:capstone2/data/model/AdminBusTicket.dart';

class Testing extends StatefulWidget {
  const Testing({super.key});

  @override
  State<Testing> createState() => _TestingState();
}

class _TestingState extends State<Testing> {
  late Stream<QuerySnapshot> adminTickets;
  late Stream<QuerySnapshot> userTickets;

  @override
  void initState() {
    adminTickets = AdminTicketController().getTickets();
    userTickets = UserTicketController().getUserTickets();
    super.initState();
  }

  Future<int?> showSeatPickerDialog(BuildContext context, AdminBusTicket ticket) async {
    // Fetch all user tickets to check for booked seats
    final snapshot = await FirebaseFirestore.instance.collection('UserBusTickets').get();

    // Extract taken seats for the specific admin ticket
    final takenSeats = snapshot.docs
        .map((e) => UserBusTicket.fromJSON(e.data())) // Convert docs to UserBusTicket
        .where((userTicket) =>
    userTicket.data.destination[0] == ticket.destination[0] &&
        userTicket.data.destination[1] == ticket.destination[1] &&
        userTicket.data.departureTime == ticket.departureTime) // Ensure same trip
        .map((userTicket) => userTicket.seat) // Get booked seat numbers
        .toSet(); // Use a Set to ensure uniqueness

    return showDialog<int>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Choose a Seat'),
          content: SizedBox(
            width: double.maxFinite,
            child: GridView.builder(
              shrinkWrap: true,
              itemCount: ticket.totalSeats,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                mainAxisSpacing: 10,
                crossAxisSpacing: 10,
              ),
              itemBuilder: (context, index) {
                int seatNumber = index + 1; // Seat number starts from 1
                bool isTaken = takenSeats.contains(seatNumber); // Check if this seat is taken

                return ElevatedButton(
                  onPressed: isTaken
                      ? null // Disable button if seat is taken
                      : () {
                    Navigator.of(context).pop(seatNumber); // Select seat if not taken
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isTaken ? Colors.grey : Colors.blue,
                  ),
                  child: Text(
                    seatNumber.toString(),
                    style: TextStyle(
                      color: isTaken ? Colors.black54 : Colors.white,
                    ),
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Flexible(
          child: StreamBuilder(
            stream: adminTickets,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const CircularProgressIndicator();
              } else if (!snapshot.hasData || snapshot.data == null) {
                return const Text("Empty Data");
              }

              List<AdminBusTicket> tickets = snapshot.data!.docs.map(
                    (e) {
                  return AdminBusTicket.fromJSON(
                      e.data() as Map<String, dynamic>);
                },
              ).toList();

              return ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: tickets.length,
                itemBuilder: (BuildContext context, int index) {
                  final ticket = tickets[index];
                  return Card(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('Ticket #${index + 1}'),
                        Text('From: ${ticket.destination[0]}'),
                        Text('To: ${ticket.destination[1]}'),
                        Text('Departure: ${ticket.departureTime}'),
                        Text('Seats: ${ticket.totalSeats}'),
                        Text('Price: ₱${ticket.ticketPrice}'),
                        Text('Aircon: ${ticket.isAircon}'),

                        SizedBox(height: 20),
                        // DELETE
                        ElevatedButton(
                          onPressed: () {
                            AdminTicketController().deleteAdminTicket(ticket);
                          },
                          child: const Text('Delete'),
                        ),
                        SizedBox(height: 10),
                        // EDIT
                        ElevatedButton(
                          onPressed: () {},
                          child: const Text('Edit'),
                        ),
                        SizedBox(height: 10),
                        // BOOK TICKET
                        ElevatedButton(
                          onPressed: () async {
                            final selectedSeat = await showSeatPickerDialog(context, ticket);
                            if (selectedSeat != null) {
                              await UserTicketController().uploadUserTicket(
                                UserBusTicket.noID(
                                  email: FirebaseAuth.instance.currentUser!.email.toString(),
                                  data: ticket,
                                  isPaid: false,
                                  seat: selectedSeat,
                                ),
                              );
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('Seat #$selectedSeat booked successfully!')),
                              );
                            }
                          },
                          child: const Text('Book Ticket'),
                        ),
                      ],
                    ),
                  );
                },
              );
            },
          ),
        ),
        SizedBox(height: 40),

        // USER TICKETS SECTION
        Flexible(
          child: StreamBuilder(
            stream: userTickets,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const CircularProgressIndicator();
              } else if (!snapshot.hasData || snapshot.data == null) {
                return const Text("No Tickets Booked");
              }

              final userTicketsList = snapshot.data!.docs
                  .map((e) => UserBusTicket.fromJSON(e.data() as Map<String, dynamic>))
                  .toList();

              return ListView.builder(
                itemCount: userTicketsList.length,
                itemBuilder: (context, index) {
                  final userTicket = userTicketsList[index];
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Card(
                          child: Text(
                              'NAAS TICKET PAGE KENT'
                          )
                      ),
                    ],
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }
}
