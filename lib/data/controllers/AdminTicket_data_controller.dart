import 'package:capstone2/data/data_sources/AdminTicketDatabase.dart';
import 'package:capstone2/data/model/AdminBusTicket.dart';
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

}