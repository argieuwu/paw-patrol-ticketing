import 'package:capstone2/data/data_sources/UserTicketDatabase.dart';
import 'package:capstone2/data/model/UsereBusTicket.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class UserTicketController{

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
}