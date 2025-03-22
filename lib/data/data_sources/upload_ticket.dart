import 'package:capstone2/data/model/AdminBusTicket.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UploadTicket {
  final FirebaseFirestore db = FirebaseFirestore.instance;

  Future<void> upLoadTicket(AdminBusTicket ticket) async{
    // DocumentReference reference = await db.collection('admin').doc().set(ticket);
  }
}