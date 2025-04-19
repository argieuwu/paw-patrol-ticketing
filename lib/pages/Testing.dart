import 'package:capstone2/data/services/TicketService.dart';
import 'package:flutter/material.dart';
import 'package:capstone2/data/model/UsereBusTicket.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
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
  final TicketService _ticketService = TicketService();

  @override
  void initState() {
    adminTickets = AdminTicketController().getTickets();
    userTickets = UserTicketController().getUserTickets();
    super.initState();
  }

  Future<int?> showSeatPickerDialog(BuildContext context, AdminBusTicket ticket) async {
    final takenSeats = await _ticketService.getTakenSeats(ticket);

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
                int seatNumber = index + 1;
                bool isTaken = takenSeats.contains(seatNumber);

                return ElevatedButton(
                  onPressed: isTaken ? null : () => Navigator.pop(context, seatNumber),
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

              List<AdminBusTicket> tickets = snapshot.data!.docs
                  .map((e) => AdminBusTicket.fromJSON(e.data() as Map<String, dynamic>))
                  .toList();

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
                        const SizedBox(height: 20),

                        ElevatedButton(
                          onPressed: () => AdminTicketController().deleteAdminTicket(ticket),
                          child: const Text('Delete'),
                        ),
                        const SizedBox(height: 10),

                        ElevatedButton(
                          onPressed: () {}, // Edit handler here
                          child: const Text('Edit'),
                        ),
                        const SizedBox(height: 10),

                        ElevatedButton(
                          onPressed: () async {
                            final selectedSeat = await showSeatPickerDialog(context, ticket);
                            if (selectedSeat != null) {
                              await _ticketService.bookTicket(ticket, selectedSeat);
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                    content: Text(
                                        'Seat #$selectedSeat booked successfully!'
                                    )
                                ),
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
        const SizedBox(height: 40),

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
                  .map((e) => UserBusTicket.fromJSON(e))
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
                          'Ticket from ${userTicket.data.destination[0]} '
                              'to ${userTicket.data.destination[1]}'
                              ' - Seat: ${userTicket.seat}'
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
