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


  // CHANGE 2: Completely revamped fromJSON to handle all edge cases
  factory UserBusTicket.fromJSON(Map<String,dynamic> map){
    // STEP 1: Safely handle the bus data field
    // Initialize an empty map as fallback
    Map<String, dynamic> busData = {};

    // Only try to convert the bus data if it exists and is actually a Map
    // This prevents crashes when the data structure is unexpected
    if (map['bus data'] != null && map['bus data'] is Map) {
      busData = Map<String, dynamic>.from(map['bus data']);
    }

    // STEP 2: Create the UserBusTicket with null safety
    return UserBusTicket(
      // Handle all fields with null safety using ?? operator
        userTicketId: map['user ticket id'], // This can be null as per the model
        email: map['email'] ?? '', // Default to empty string if null
        data: AdminBusTicket.fromJSON(busData), // Use our safely prepared busData
        isPaid: map['isPaid'] ?? false, // Default to false if null
        seat: map['seat'] ?? 0 // Default to 0 if null
    );
  }
}
