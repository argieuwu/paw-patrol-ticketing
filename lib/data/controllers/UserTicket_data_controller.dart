import 'package:capstone2/data/data_sources/UserTicketDatabase.dart';
import 'package:capstone2/data/model/UsereBusTicket.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

class UserTicketController{
  final FirebaseAuth _auth = FirebaseAuth.instance;


  Future<void> uploadUserTicket(UserBusTicket ticket) async {
    try{
     await UserTicketDatabase().uploadUserTicketToDatabase(ticket.toJSON());
    }
    catch(e){
      debugPrint('Uploading User data failed: $e');
    }

  }
  Stream<QuerySnapshot> getUserTickets(){
    return UserTicketDatabase().getUserTickets();
  }

  Stream<QuerySnapshot> getCompletedUserTickets() {
    return UserTicketDatabase().getUserTickets();
  }

  Future<void> deleteUserTicket(String ticketId) async {
    try {
      await FirebaseFirestore.instance
          .collection('user')
          .doc(_auth.currentUser!.uid)
          .collection('tickets')
          .doc(ticketId)
          .delete();
    } catch (e) {
      debugPrint("Error deleting user ticket: $e");
    }
  }


}