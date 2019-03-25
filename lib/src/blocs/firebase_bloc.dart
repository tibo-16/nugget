import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:nugget/src/resources/bloc_provider.dart';
import 'package:nugget/utils/credentials.dart';
import 'package:rxdart/rxdart.dart';

class FirebaseBloc implements BlocBase {
  Firestore _firestore = Firestore.instance;
  FirebaseAuth _auth = FirebaseAuth.instance;

  Observable<FirebaseUser> user;
  Observable<QuerySnapshot> entries;

  FirebaseBloc() {
    user = Observable(_auth.onAuthStateChanged);

    entries = user.switchMap((FirebaseUser u) {
      if (u != null) {
        return Observable(_firestore.collection('entries').snapshots());
      } else {
        return Observable.just(null);
      }
    });
  }

  void login() {
    _auth.signInWithEmailAndPassword(
        email: Credentials.EMAIL, password: Credentials.PASSWORD);
  }

  void logout() {
    _auth.signOut();
  }

  @override
  void dispose() {
    logout();
  }
}
