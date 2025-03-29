import 'package:capstone2/data/model/AdminBusTicket.dart';

class UserBusTicket {
  final String email;
  final AdminBusTicket data;
  final bool isPaid;
  final int seat;
  // final List<List<int>> seat; // PWEDE NI SIYA KUNG MAG MULTI DIMENTIONAL ARRAY MO NA SEATING PLAN
  final String? userTicketId;

  UserBusTicket(
      {required this.userTicketId,
      required this.email,
      required this.data,
      required this.isPaid,
      required this.seat});

  UserBusTicket.noID(
      {this.userTicketId,
      required this.email,
      required this.data,
      required this.isPaid,
      required this.seat});

  Map<String, dynamic> toJSON() {
    return {'email': email, 'bus data': data.toJson(), 'isPaid': isPaid, 'seat': seat};
  }
  factory UserBusTicket.fromJSON(Map<String,dynamic> map){
   return UserBusTicket(userTicketId: map['user ticket id'], email: map['email'], data: map['bus data'], isPaid: map['isPaid'], seat: map['seat']);
  }
}
