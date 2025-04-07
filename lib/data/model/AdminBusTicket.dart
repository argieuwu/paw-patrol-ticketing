import 'package:cloud_firestore/cloud_firestore.dart';

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
        "ticket id": ticketId, //for update daw
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
    );
  }


}
