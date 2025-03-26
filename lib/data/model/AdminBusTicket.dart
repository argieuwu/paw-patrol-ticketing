import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class AdminBusTicket {
  final List<String> destination;
  final DateTime departureTime;
  final int totalSeats;
  final int ticketPrice;

  AdminBusTicket(
      {required this.destination,
      required this.departureTime,
      required this.totalSeats,
      required this.ticketPrice});
  Map<String, dynamic> toJson() {
    return {
      "data": {
        "destination": destination,
        "departure time": departureTime,
        "total seats": totalSeats,
        "ticket price": ticketPrice
      }
    };
  }

  factory AdminBusTicket.fromJSON(Map<String, dynamic> map) {
    return AdminBusTicket(
        destination: [
          map['data']['destination'][0],
          map['data']['destination'][1]
        ],
        departureTime: (map['data']['departure time'] as Timestamp).toDate()  ,
        totalSeats: map['data']['total seats'],
        ticketPrice: map['data']['ticket price']);
  }
}
