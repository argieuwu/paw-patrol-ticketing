import 'package:capstone2/data/model/AdminBusTicket.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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
    return {
      'email': email,
      'bus data': data.toJson(),
      'isPaid': isPaid,
      'seat': seat
      // 'user ticket id': userTicketId
    };
  }
  // factory UserBusTicket.fromJSON(Map<String,dynamic> map){
  //  return UserBusTicket(
  //      userTicketId: map['user ticket id'],
  //      email: map['email'],
  //      data: map['bus data'],
  //      isPaid: map['isPaid'],
  //      seat: map['seat']);
  // }


  factory UserBusTicket.fromJSON(DocumentSnapshot doc) {
    final map = doc.data() as Map<String, dynamic>;

    Map<String, dynamic> busData = {};
    if (map['bus data'] != null && map['bus data'] is Map) {
      final outer = Map<String, dynamic>.from(map['bus data']);
      if (outer['data'] != null && outer['data'] is Map) {
        busData = Map<String, dynamic>.from(outer['data']);
      }
    }

    return UserBusTicket(
      userTicketId: doc.id,
      email: map['email'] ?? '',
      data: AdminBusTicket.fromJSON(busData),
      isPaid: map['isPaid'] ?? false,
      seat: map['seat'] ?? 0,
    );
  }


}
