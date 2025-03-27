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


  // Template ni tanan once i implement ninyo sa frontend

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
          return Text("Empty Data");
        }
        List<AdminBusTicket>? tickets = snapshot.data?.docs.map((e) {
          return AdminBusTicket.fromJSON(e.data() as Map<String,dynamic>);
        },).toList();
        return ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: tickets?.length,
          itemBuilder: (BuildContext context, int index) {
            return Column(
              spacing: 10,
              children: [
                Text(index.toString()),
                Text(tickets![index].destination[0]),
                Text(tickets[index].destination[1]),
                Text(tickets[index].departureTime.toString()),
                Text(tickets[index].totalSeats.toString()),
                Text(tickets[index].ticketPrice.toString()),
                Text(tickets[index].isAircon.toString()),
                ElevatedButton(onPressed: () {
                  AdminTicketController().deleteAdminTicket(tickets[index]);
                }, child: Text('Delete')),
                ElevatedButton(onPressed: () => null, child: Text('Edit'))
              ],
            );
          },
        );
      },);
  }
}
