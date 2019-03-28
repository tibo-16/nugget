import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:nugget/utils/credentials.dart';

class FirebaseRepository {
  FirebaseAuth _auth = FirebaseAuth.instance;
  Firestore _firestore = Firestore.instance;

  bool get online => _auth.currentUser() != null;

  Stream<FirebaseUser> get authStream => _auth.onAuthStateChanged;

  void signIn() {
    _auth.signInWithEmailAndPassword(
        email: Credentials.EMAIL, password: Credentials.PASSWORD);
  }

  void signOut() {
    _auth.signOut();
  }

  Stream<QuerySnapshot> getEntriesStream(String name) {
    return _firestore
        .collection('users')
        .document(name)
        .collection('data')
        .orderBy('date', descending: true)
        .snapshots();
  }
}
