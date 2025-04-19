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
  Stream<QuerySnapshot> getTickets(){
    return ticketDatabase.getAllAdminTicket();
  }

  Future<void> deleteAdminTicket(AdminBusTicket ticket) async {
    ticketDatabase.deleteAdminTickets(ticket);
  }

  Future<void> updatedAdminTicket(AdminBusTicket ticket) async{
    try{
      await ticketDatabase.updateAdminTicket(ticket);
    } catch(e){
      debugPrint("Error Controller update: $e");
    }
}
  Future<void> updateTicketStatus(AdminBusTicket ticket, bool isCompleted) async {
    try {
      await ticketDatabase.updateTicketStatus(ticket.ticketId!, isCompleted);
    } catch (e) {
      debugPrint("Error updating ticket status: $e");
    }
  }

  // New method to update isCompleted status for all tickets based on departure time
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
      rethrow;
    }
  }

  // fetch all user tickets for admin purposes
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