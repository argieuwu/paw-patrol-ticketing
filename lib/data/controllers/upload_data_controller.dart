import 'package:capstone2/data/data_sources/upload_ticket.dart';
import 'package:capstone2/data/model/AdminBusTicket.dart';
import 'package:flutter/cupertino.dart';

class UploadTicketController {
  final UploadTicket ticketDatabase = UploadTicket();

  void uploadTicket(AdminBusTicket ticket){
    try{
      ticketDatabase.uploadTicketToDatabase(ticket.toJson());
    }
    catch(e){
      debugPrint("Error Controller upload : $e");
    }
  }
}