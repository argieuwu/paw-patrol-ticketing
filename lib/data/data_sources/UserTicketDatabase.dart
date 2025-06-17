import 'package:capstone2/data/model/UsereBusTicket.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserTicketDatabase{
  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore db = FirebaseFirestore.instance;

  Future<void> uploadUserTicketToDatabase(Map<String,dynamic> ticket, Map<String,dynamic> apiTicket,int seat) async{
    DocumentReference reference = db.collection('user').doc(auth.currentUser!.uid).collection('tickets').doc(); // Never ever jud ni ma empty ning Uid
    ticket['user ticket id'] = reference.id;
    ticket['seat'] = seat;
    ticket.addAll(apiTicket);
    await reference.set(ticket);
  }
  
  Stream<QuerySnapshot> getUserTickets() {
    return db
        .collection('user')
        .doc(auth.currentUser!.uid)
        .collection('tickets')
        .snapshots();
  }

  Stream<QuerySnapshot> getCompletedUserTickets() {
    return db
        .collection('user')
        .doc(auth.currentUser!.uid)
        .collection('tickets')
        .where('bus data.data.isCompleted', isEqualTo: true)
        .snapshots();
  }

}