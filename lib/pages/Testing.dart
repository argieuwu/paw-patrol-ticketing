import 'package:capstone2/data/controllers/AdminTicket_data_controller.dart';
import 'package:capstone2/data/model/AdminBusTicket.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Testing extends StatefulWidget {
  const Testing({super.key});

  @override
  State<Testing> createState() => _TestingState();
}

class _TestingState extends State<Testing> {
  late Stream<QuerySnapshot> tickets;
  @override
  void initState() {
    tickets = AdminTicketController().getTickets();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return  StreamBuilder(
      stream: tickets,
      builder: (context, snapshot) {
        if(snapshot.connectionState == ConnectionState.waiting){
          return CircularProgressIndicator();
        }
        else if(!snapshot.hasData || snapshot.data == null){
          return Text("Error Data");
        }
        List<AdminBusTicket>? tickets = snapshot.data?.docs.map((e) {
          return AdminBusTicket.fromJSON(e.data() as Map<String,dynamic>);
        },).toList();
        return ListView(
          scrollDirection: Axis.horizontal,
          children: [
            Card(
              child: Center(
                child: Row(children: [
                  Text(tickets![0].destination[0])
                ],),
              ),
            ),],
        );
      },);
  }
}
