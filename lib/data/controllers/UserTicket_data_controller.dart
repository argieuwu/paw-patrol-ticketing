import 'package:capstone2/data/data_sources/UserTicketDatabase.dart';
import 'package:capstone2/data/model/UsereBusTicket.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

class UserTicketController{
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> uploadUserTicket(UserBusTicket ticket) async {
    try {

      // Upload to User-level nested collection
      await UserTicketDatabase().uploadUserTicketToDatabase(ticket.toJSON());

      // Also upload to root-level collection for seat monitoring
      await FirebaseFirestore.instance.collection('UserBusTickets').add(ticket.toJSON());
    } catch (e) {
      print("Error uploading user ticket: $e");
    }
  }

  Stream<QuerySnapshot> getUserTickets(){
    return UserTicketDatabase().getUserTickets();
  }

  Stream<QuerySnapshot> getCompletedUserTickets() {
    return UserTicketDatabase().getCompletedUserTickets();
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