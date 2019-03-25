import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreProvider {
  Firestore _firestore = Firestore.instance;

  Stream<QuerySnapshot> getEntries() {
    return _firestore.collection('entries').snapshots();
  }
}
