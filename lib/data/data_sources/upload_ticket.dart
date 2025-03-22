import 'package:capstone2/data/model/AdminBusTicket.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UploadTicket {
  final FirebaseFirestore db = FirebaseFirestore.instance;

  Future<void> uploadTicketToDatabase(Map<String,dynamic> ticket) async{
    DocumentReference reference = db.collection('admin').doc();
    db.collection('admin').doc(reference.id).set(ticket);
  }
}