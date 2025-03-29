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
    // Helper function to safely parse the destination field
    // This handles different possible data structures:
    // 1. If destination is a List -> convert directly to List<String>
    // 2. If destination is a Map with numeric keys -> convert to List
    // 3. If destination has unexpected format -> return empty list to prevent crashes
    List<String> parseDestination() {
      var dest = map['destination'];
      if (dest is List) {
        return List<String>.from(dest);
      } else if (dest is Map) {
        return [dest['0'] ?? '', dest['1'] ?? ''];
      }
      return ['', '']; // Default empty list if structure is unexpected
    }

    return AdminBusTicket(
      // Use the safe parsing function for destination
        destination: parseDestination(),
        // Check if departure_time is actually a Timestamp before converting
        // If not, use current time as fallback to prevent crashes
        departureTime: (map['departure time'] is Timestamp)
            ? (map['departure time'] as Timestamp).toDate()
            : DateTime.now(),
        // Add null checks with default values for all numeric fields
        totalSeats: map['total seats'] ?? 0,
        ticketPrice: map['ticket price'] ?? 0,
        ticketId: map['ticket id'],
        // Add null check for boolean with false as default
        isAircon: map['aircon'] ?? false);
  }
}
