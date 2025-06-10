import 'package:cloud_firestore/cloud_firestore.dart';

/// Represents a bus ticket managed by an admin.
class AdminBusTicket {
  final String? ticketId; // Unique Firestore document ID
  final List<String> destination; // Start and end points of the trip
  final DateTime departureTime; // Scheduled departure time
  final int totalSeats; // Total number of bus seats
  final int ticketPrice; // Ticket price
  final bool isAircon; // Whether the bus has aircon
  final bool isCompleted; // Whether the trip has been completed
  final String plateNumber; // Bus plate number
  final bool isReadyForDeparture; // Whether the bus is ready for departure
  final List<String>? takenSeats; // List of seat IDs/numbers that are taken
  final DateTime? arrivalTime; // Actual arrival time (optional)

  AdminBusTicket({
    required this.ticketId,
    required this.destination,
    required this.departureTime,
    required this.totalSeats,
    required this.ticketPrice,
    required this.isAircon,
    this.isCompleted = false,
    required this.plateNumber,
    this.isReadyForDeparture = false,
    this.takenSeats,
    this.arrivalTime,
  });

  AdminBusTicket.noID({
    this.ticketId,
    required this.destination,
    required this.departureTime,
    required this.totalSeats,
    required this.ticketPrice,
    required this.isAircon,
    this.isCompleted = false,
    required this.plateNumber,
    this.isReadyForDeparture = false,
    this.takenSeats,
    this.arrivalTime,
  });

  /// Converts the object to JSON for Firestore storage.
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
        "plateNumber": plateNumber,
        "isReadyForDeparture": isReadyForDeparture,
        "takenSeats": takenSeats ?? [],
        "arrivalTime": arrivalTime,
      }
    };
  }

  /// Converts the object to JSON including ID field (useful when updating).
  Map<String, dynamic> toJsonID() {
    return {
      "data": {
        "ticket id": ticketId,
        "destination": destination,
        "departure time": departureTime,
        "total seats": totalSeats,
        "ticket price": ticketPrice,
        "aircon": isAircon,
        "isCompleted": isCompleted,
        "plateNumber": plateNumber,
        "isReadyForDeparture": isReadyForDeparture,
        "takenSeats": takenSeats ?? [],
        "arrivalTime": arrivalTime,
      }
    };
  }

  /// Creates an AdminBusTicket from a Firestore document.
  factory AdminBusTicket.fromJSON(Map<String, dynamic> json) {
    final data = json['data'] ?? json;

    return AdminBusTicket(
      ticketId: data['ticket id']?.toString(),
      destination: (data['destination'] is List)
          ? List<String>.from(data['destination'])
          : <String>['', ''],
      departureTime: (data['departure time'] is Timestamp)
          ? (data['departure time'] as Timestamp).toDate()
          : DateTime.now(),
      totalSeats: data['total seats'] ?? 0,
      ticketPrice: data['ticket price'] ?? 0,
      isAircon: data['aircon'] ?? false,
      isCompleted: data['isCompleted'] ?? false,
      plateNumber: data['plateNumber'] ?? 'N/A',
      isReadyForDeparture: data['isReadyForDeparture'] ?? false,
      takenSeats: (data['takenSeats'] is List)
          ? List<String>.from(data['takenSeats'])
          : [],
      arrivalTime: (data['arrivalTime'] is Timestamp)
          ? (data['arrivalTime'] as Timestamp).toDate()
          : null,
    );
  }
}
