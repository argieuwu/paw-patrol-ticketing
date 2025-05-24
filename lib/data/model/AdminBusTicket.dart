import 'package:cloud_firestore/cloud_firestore.dart';

//bus ticket managed by an admin
class AdminBusTicket {
  final List<String> destination;   //start and end points of the trip
  final DateTime departureTime;  //a DateTime for when the bus departs or go.
  final int totalSeats;    // total number of seats on the bus.
  final int ticketPrice;   //tagpila ang ticket.
  final String? ticketId;   //unique Firestore document ID
  final bool isAircon;   //kung with aircon or wlay aircon ang bus
  final bool isCompleted;   //status sa bus kung humanag byahe or wla


  AdminBusTicket(
      {required this.ticketId,
      required this.destination,
      required this.departureTime,
      required this.totalSeats,
      required this.ticketPrice,
      required this.isAircon,
      this.isCompleted = false,
      });

  AdminBusTicket.noID(
      {this.ticketId,
      required this.destination,
      required this.departureTime,
      required this.totalSeats,
      required this.ticketPrice,
      required this.isAircon,
        this.isCompleted = false,
      });

  //gina converts  niya ang ticket object
  // 'destination, departureTime, totalSeats, ticketPrice, isAircon, isCompleted'
  // to JSON map pasa ma butang sa Firestore storage. Sulod sa 'data'.
  Map<String, dynamic> toJson() {
    return {
      "data": {
        "ticket id": ticketId,
        "destination": destination,
        "departure time": departureTime,
        "total seats": totalSeats,
        "ticket price": ticketPrice,
        "aircon": isAircon,
        "isCompleted": isCompleted,
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
        "aircon": isAircon,
        "isCompleted": isCompleted,

      }
    };
  }

  factory AdminBusTicket.fromJSON(Map<String, dynamic> json) {
    final data = json['data'] ?? json;

    return AdminBusTicket(
      ticketId: data['ticket id']?.toString() ?? '',
      destination: (data['destination'] != null && data['destination'] is List)
          ? List<String>.from(data['destination'])
          : ['', ''],
      departureTime: (data['departure time'] != null && data['departure time'] is Timestamp)
          ? (data['departure time'] as Timestamp).toDate()
          : DateTime.now(),
      totalSeats: data['total seats'] ?? 0,
      ticketPrice: data['ticket price'] ?? 0,
      isAircon: data['aircon'] ?? false,
      isCompleted: data['isCompleted'] ?? false,
    );
  }

}
