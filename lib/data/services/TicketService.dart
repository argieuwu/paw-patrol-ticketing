import 'package:capstone2/data/model/AdminBusTicket.dart';
import 'package:capstone2/data/model/UsereBusTicket.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

// handles ticket booking and seat management.
class TicketService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;


  // Return a Set of taken seat numbers.
  Future<Set<int>> getTakenSeats(AdminBusTicket ticket) async {
    //checking seat availability across all users for a specific bus trip
    final snapshot = await _firestore.collectionGroup('tickets').get();

    return snapshot.docs
        .map((e) => UserBusTicket.fromJSON(e))
        .where((userTicket) =>
    userTicket.data.destination[0] == ticket.destination[0] &&
        userTicket.data.destination[1] == ticket.destination[1] &&
        userTicket.data.departureTime == ticket.departureTime)
        .map((userTicket) => userTicket.seat)
        .toSet();
  }

  //Creates a new UserBusTicket.noID with the user email, the provided ticket,
  // isPaid: false, and the selected seat.
  Future<void> bookTicket(AdminBusTicket ticket, int seat) async {
    final userEmail = _auth.currentUser!.email.toString();
    final newTicket = UserBusTicket.noID(
      email: userEmail,
      data: ticket,
      isPaid: false,
      seat: seat,
    );

    await FirebaseFirestore.instance
        .collection('user')
        .doc(_auth.currentUser!.uid)
        .collection('tickets')
        .add(newTicket.toJSON());
  }
}
