import 'package:capstone2/data/data_sources/UserTicketDatabase.dart';
import 'package:capstone2/data/model/UsereBusTicket.dart';
import 'package:flutter/cupertino.dart';

class UserTicketController{

  void uploadUserTicket(UserBusTicket ticket){
    try{
      UserTicketDatabase().uploadUserTicketToDatabase(ticket.toJSON());
    }
    catch(e){
      debugPrint('Uploading User data failed');
    }

  }
}