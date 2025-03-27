import 'package:capstone2/data/model/AdminBusTicket.dart';

class UserBusTicket {
  final String email;
  final AdminBusTicket data;
  final bool isPaid;
  final List<List<int>> seat;

  UserBusTicket(
      {required this.email, required this.data, required this.isPaid, required this.seat});

  Map<String,dynamic> toJSON(){
    return {
      'email':email,
      'bus data': data,
      'isPaid':isPaid,
      'seat': seat
    };
  }
}

