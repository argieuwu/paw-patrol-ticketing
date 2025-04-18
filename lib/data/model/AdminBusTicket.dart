import 'package:cloud_firestore/cloud_firestore.dart';

class AdminBusTicket {
  final List<String> destination;
  final DateTime departureTime;
  final int totalSeats;
  final int ticketPrice;
  final String? ticketId;
  final bool isAircon;
  final bool isCompleted; // Add this field


  AdminBusTicket(
      {required this.ticketId,
      required this.destination,
      required this.departureTime,
      required this.totalSeats,
      required this.ticketPrice,
      required this.isAircon,
      this.isCompleted = false, // Constructor should take this as well
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

  Map<String, dynamic> toJson() {
    return {
      "data": {
        "ticket id": ticketId, //for update daw
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
        "isCompleted": isCompleted, // Save the completed status

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
