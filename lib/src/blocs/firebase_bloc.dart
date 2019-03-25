import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:nugget/src/resources/bloc_provider.dart';
import 'package:rxdart/rxdart.dart';

class FirebaseBloc implements BlocBase {
  Firestore _firestore = Firestore.instance;
  FirebaseAuth _auth = FirebaseAuth.instance;

  Observable<QuerySnapshot> get entries =>
      Observable(_firestore.collection('entries').snapshots());
  Observable<FirebaseUser> get user => Observable(_auth.onAuthStateChanged);

  create() {
    _firestore.collection('entries').add({'name': 'test'});
  }

  @override
  void dispose() {}
}
