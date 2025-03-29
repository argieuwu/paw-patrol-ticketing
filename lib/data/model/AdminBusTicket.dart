import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class AdminBusTicket {
  final List<String> destination;
  final DateTime departureTime;
  final int totalSeats;
  final int ticketPrice;
  final String? ticketId;
  final bool isAircon;

  AdminBusTicket(
      {required this.ticketId,
      required this.destination,
      required this.departureTime,
      required this.totalSeats,
      required this.ticketPrice,
      required this.isAircon});

  AdminBusTicket.noID(
      {this.ticketId,
      required this.destination,
      required this.departureTime,
      required this.totalSeats,
      required this.ticketPrice,
      required this.isAircon});

  Map<String, dynamic> toJson() {
    return {
      "data": {
        "destination": destination,
        "departure time": departureTime,
        "total seats": totalSeats,
        "ticket price": ticketPrice,
        "aircon": isAircon
      }
    };
  }

  Map<String, dynamic> toJsonID() {
    return {
      "data": {
        "ticket id" : ticketId,
        "destination": destination,
        "departure time": departureTime,
        "total seats": totalSeats,
        "ticket price": ticketPrice,
        "aircon": isAircon
      }
    };
  }

  factory AdminBusTicket.fromJSON(Map<String, dynamic> map) {
    return AdminBusTicket(
        destination: [
          map['data']['destination'][0],
          map['data']['destination'][1]
        ],
        departureTime: (map['data']['departure time'] as Timestamp).toDate(),
        totalSeats: map['data']['total seats'],
        ticketPrice: map['data']['ticket price'],
        ticketId: map['data']['ticket id'],
        isAircon: map['data']['aircon']);
  }
}
