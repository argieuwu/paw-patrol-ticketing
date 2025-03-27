import 'package:capstone2/data/model/AdminBusTicket.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class AdminTicketDatabase {
  final FirebaseFirestore db = FirebaseFirestore.instance;

  Future<void> uploadTicketToDatabase(Map<String,dynamic> ticket) async {
    try{
      DocumentReference reference = db.collection('admin').doc();
      ticket['data']['ticket id'] = reference.id;
      await reference.set(ticket);
    }
    catch(e){
      debugPrint("Error uploading to database : $e");
    }
  }

  Stream<QuerySnapshot> getAllAdminTicket() {
       return db.collection('admin').snapshots();
  }

  Future<void> deleteAdminTickets(AdminBusTicket ticket) async{
    await db.collection('admin').doc(ticket.ticketId).delete();
  }
}