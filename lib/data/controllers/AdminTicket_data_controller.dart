import 'package:capstone2/data/data_sources/AdminTicketDatabase.dart';
import 'package:capstone2/data/model/AdminBusTicket.dart';
import 'package:capstone2/data/model/UsereBusTicket.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class AdminTicketController {
  final AdminTicketDatabase ticketDatabase = AdminTicketDatabase();

  // Upload a ticket to Firestore
  void uploadTicket(AdminBusTicket ticket) {
    try {
      ticketDatabase.uploadTicketToDatabase(ticket.toJson());
    } catch (e) {
      debugPrint("Error Controller upload : $e");
    }
  }

  // Retrieve all admin tickets as a stream
  Stream<QuerySnapshot> getTickets() {
    return ticketDatabase.getAllAdminTicket();
  }

  // Delete a specific admin ticket
  Future<void> deleteAdminTicket(AdminBusTicket ticket) async {
    ticketDatabase.deleteAdminTickets(ticket);
  }

  // Update an existing ticket
  Future<void> updatedAdminTicket(AdminBusTicket ticket) async {
    try {
      await ticketDatabase.updateAdminTicket(ticket);
    } catch (e) {
      debugPrint("Error Controller update: $e");
    }
  }

  // Update isCompleted status of a specific ticket
  Future<void> updateTicketStatus(
      AdminBusTicket ticket, bool isCompleted) async {
    try {
      await ticketDatabase.updateTicketStatus(ticket.ticketId!, isCompleted);
    } catch (e) {
      debugPrint("Error updating ticket status: $e");
    }
  }

  // Update ready-for-departure status
  Future<void> updateReadyForDepartureStatus(
      String ticketId, bool isReadyForDeparture) async {
    try {
      await FirebaseFirestore.instance
          .collection('admin')
          .doc(ticketId)
          .update({'data.isReadyForDeparture': isReadyForDeparture});
    } catch (e) {
      debugPrint("Error updating ready for departure status: $e");
    }
  }

  // Update isCompleted status for all tickets based on departure time
  Future<void> updateAllTicketStatuses() async {
    try {
      final now = DateTime.now();
      final snapshot =
          await FirebaseFirestore.instance.collection('admin').get();

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

  // Fetch all user bookings (used by admin for viewing all bookings)
  Future<List<UserBusTicket>> getAllUserTickets() async {
    try {
      final snapshot =
          await FirebaseFirestore.instance.collectionGroup('tickets').get();
      return snapshot.docs.map((doc) => UserBusTicket.fromJSON(doc)).toList();
    } catch (e) {
      debugPrint("Error fetching all user tickets: $e");
      return [];
    }
  }
}
