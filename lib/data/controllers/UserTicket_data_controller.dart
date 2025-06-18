import 'package:capstone2/data/api/ApiService.dart';
import 'package:capstone2/data/controllers/CheckoutController.dart';
import 'package:capstone2/data/data_sources/UserTicketDatabase.dart';
import 'package:capstone2/data/model/Checkout.dart';
import 'package:capstone2/data/model/UsereBusTicket.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

class UserTicketController{
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> uploadUserTicket(UserBusTicket ticket, Checkout userpost, int seat) async {
    try {
     final holder = await CheckoutController().createCheckoutController(userpost.toJson());
      await UserTicketDatabase().uploadUserTicketToDatabase(ticket.toJSON(),holder.toJSON(),seat);
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

  Future<void> autoUpdateController() async {
    final db = FirebaseFirestore.instance;
    final uid = FirebaseAuth.instance.currentUser!.uid;
    final apiService = Apiservice();


    final unpaidTickets = await UserTicketDatabase().autoUpdateUserTickets();

    for (final ticket in unpaidTickets) {
      final checkoutId = ticket['apiData']['id'];
      final userTicketId = ticket['user ticket id'];

      try {
        final checkout = await apiService.getCheckout(checkoutId);

        if (checkout.status == 'paid' || checkout.status == 'succeeded') {
          await db
              .collection('user')
              .doc(uid)
              .collection('tickets')
              .doc(userTicketId)
              .update({'isPaid': true});
        }
      } catch (e) {
        throw('Websocket Failed');
        debugPrint('Error updating ticket $userTicketId: $e');
      }
    }
  }
}