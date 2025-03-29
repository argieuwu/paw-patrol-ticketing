import 'dart:developer';

import 'package:capstone2/data/controllers/AdminTicket_data_controller.dart';
import 'package:capstone2/data/controllers/UserTicket_data_controller.dart';
import 'package:capstone2/data/model/AdminBusTicket.dart';
import 'package:capstone2/data/model/UsereBusTicket.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Testing extends StatefulWidget {
  const Testing({super.key});

  @override
  State<Testing> createState() => _TestingState();
}

class _TestingState extends State<Testing> {
  // Template ni tanan once i implement ninyo sa frontend

  late Stream<QuerySnapshot> adminTickets;
  late Stream<QuerySnapshot> userTickets;

  @override
  void initState() {
    adminTickets = AdminTicketController().getTickets();
    userTickets = UserTicketController().getUserTickets();
    super.initState();
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
                return CircularProgressIndicator();
              } else if (!snapshot.hasData || snapshot.data == null) {
                return Text("Empty Data");
              }
              List<AdminBusTicket>? tickets = snapshot.data!.docs.map(
                (e) {
                  return AdminBusTicket.fromJSON(
                      e.data() as Map<String, dynamic>);
                },
              ).toList();
              return ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: tickets.length,
                itemBuilder: (BuildContext context, int index) {
                  return Card(
                    child: Column(
                      spacing: 10,
                      children: [
                        Text(index.toString()),
                        Text(tickets[index].destination[0]),
                        Text(tickets[index].destination[1]),
                        Text(tickets[index].departureTime.toString()),
                        Text(tickets[index].totalSeats.toString()),
                        Text(tickets[index].ticketPrice.toString()),
                        Text(tickets[index].isAircon.toString()),
                        //DELETE ADMIN TICKETS
                        ElevatedButton(
                            onPressed: () {
                              AdminTicketController()
                                  .deleteAdminTicket(tickets[index]);
                            },
                            child: Text('Delete')),
                        // EDIT ADMIN TICKETS
                        ElevatedButton(
                            onPressed: () => null, child: Text('Edit')),
                        // ADD SELECTED ADMIN TICKETS TO USER TICKETS
                        ElevatedButton(
                            onPressed: () => UserTicketController()
                                .uploadUserTicket(UserBusTicket.noID(email: FirebaseAuth.instance.currentUser!.email.toString(), data: tickets[index], isPaid: false, seat: 4)),
                            child: Text('Add to user tickets'))
                      ],
                    ),
                  );
                },
              );
            },
          ),
        ),
        Flexible(
            child: StreamBuilder(
          stream: userTickets,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator();
            } else if (!snapshot.hasData || snapshot.data == null) {
              return Text("Empty Data");
            }



            List<UserBusTicket>? tickets = snapshot.data!.docs.map(
              (e) {
                //TODO what the fuck is this error
                log(AdminBusTicket.fromJSON(e.get('bus data')).totalSeats.toString());
                return UserBusTicket.fromJSON(
                    e.data() as Map<String, dynamic>);
              },
            ).toList();
            return ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: tickets.length,
              itemBuilder: (BuildContext context, int index) {
                // AdminBusTicket adminTickets = AdminBusTicket.fromJSON(tickets[index].data.toJson());
                return Card(
                  child: Column(
                    spacing: 10,
                    children: [
                    Text(tickets[index].email),
                      Text('is Paid : ${tickets[index].isPaid.toString()}'),
                      Text(tickets[index].seat.toString()),
                      Text(tickets[index].userTicketId.toString()),
                      // Text(adminTickets.destination[0]),
                      // Text(adminTickets.destination[1]),
                      // Text(adminTickets.departureTime.toString()),
                      // Text(adminTickets.totalSeats.toString()),
                      // Text(adminTickets.ticketPrice.toString()),
                      // Text(adminTickets.isAircon.toString()),
                  ]
                  ),
                );
              },
            );
          },
        ))
      ],
    );
  }
}
