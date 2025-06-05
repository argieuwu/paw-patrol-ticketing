import 'package:capstone2/data/data_sources/AdminTicketDatabase.dart';
import 'package:capstone2/data/model/AdminBusTicket.dart';
import 'package:capstone2/data/model/UsereBusTicket.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class AdminTicketController {
  final AdminTicketDatabase ticketDatabase = AdminTicketDatabase();

  void uploadTicket(AdminBusTicket ticket){
    try{
      ticketDatabase.uploadTicketToDatabase(ticket.toJson());
    }
    catch(e){
      debugPrint("Error Controller upload : $e");
    }
  }

 // kwaon niya tanan ticket gikan sa AdminTicketDatabase
  Stream<QuerySnapshot> getTickets(){
    return ticketDatabase.getAllAdminTicket();
  }

  // delete ticket
  Future<void> deleteAdminTicket(AdminBusTicket ticket) async {
    ticketDatabase.deleteAdminTickets(ticket);
  }

  // update ticket
  Future<void> updatedAdminTicket(AdminBusTicket ticket) async{
    try{
      await ticketDatabase.updateAdminTicket(ticket);
    } catch(e){
      debugPrint("Error Controller update: $e");
    }
}

// update status sa ticket ya
  Future<void> updateTicketStatus(AdminBusTicket ticket, bool isCompleted) async {
    try {
      await ticketDatabase.updateTicketStatus(ticket.ticketId!, isCompleted);
    } catch (e) {
      debugPrint("Error updating ticket status: $e");
    }
  }

  //status sa bus kung Ready For Departure naba
  Future<void> updateReadyForDepartureStatus(String ticketId, bool isReadyForDeparture) async {
    try {
      await FirebaseFirestore.instance.collection('admin').doc(ticketId).update({
        'data.isReadyForDeparture': isReadyForDeparture
      });
    } catch (e) {
      debugPrint("Error updating ready for departure status: $e");
    }
  }


  //  update isCompleted status for all tickets based on departure time
 //For each ticket, checks if departureTime is before the current time and isCompleted is false.
  // If true, calls updateTicketStatus to mark the ticket as completed.
  Future<void> updateAllTicketStatuses() async {
    try {
      final now = DateTime.now();
      final snapshot = await FirebaseFirestore.instance.collection('admin').get();
      if (snapshot.docs.isEmpty) {
        debugPrint("No tickets found in admin collection");
        return;
      }
      for (var doc in snapshot.docs) {
        try {
          final ticket = AdminBusTicket.fromJSON(doc.data());
          if (ticket.departureTime.isBefore(now) && !ticket.isCompleted) {
            await updateTicketStatus(ticket, true);
          }
        } catch (e) {
          debugPrint("Error processing document ${doc.id}: $e");
        }
      }
    } catch (e) {
      debugPrint("Error updating all ticket statuses: $e");

    }
  }

  // fetch all user tickets for admin purposes
  //sa view bookings ni na use sa admin mga ser
  Future<List<UserBusTicket>> getAllUserTickets() async {
    try {
      final snapshot = await FirebaseFirestore.instance.collectionGroup('tickets').get();
      return snapshot.docs.map((doc) => UserBusTicket.fromJSON(doc)).toList();
    } catch (e) {
      debugPrint("Error fetching all user tickets: $e");
      return [];
    }
  }


}