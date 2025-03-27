import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserTicketDatabase{
  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore db = FirebaseFirestore.instance;

  Future<void> uploadUserTicketToDatabase(Map<String,dynamic> map) async{
    DocumentReference reference = db.collection('user').doc(auth.currentUser!.uid).collection('tickets').doc(); // Never ever jud ni ma empty ning Uid
    await reference.set(map);
  }
}