import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:nugget/src/models/data_entry.dart';
import 'package:nugget/src/resources/bloc_provider.dart';
import 'package:nugget/utils/credentials.dart';
import 'package:rxdart/rxdart.dart';

class FirebaseBloc implements BlocBase {
  Firestore _firestore = Firestore.instance;
  FirebaseAuth _auth = FirebaseAuth.instance;

  Observable<FirebaseUser> user;
  Observable<List<DataEntry>> tobiEntries;
  Observable<List<DataEntry>> jennyEntries;
  Observable<List<DataEntry>> allEntries;

  FirebaseBloc() {
    // Check if user is logged in. If not, then login()
    if (_auth.currentUser() == null) signIn();

    // Observer for auth state
    user = Observable(_auth.onAuthStateChanged);

    tobiEntries = user.switchMap((FirebaseUser u) {
      if (u != null) {
        return _firestore
            .collection('users')
            .document('tobi')
            .collection('data')
            .orderBy('date', descending: true)
            .snapshots()
            .map((snap) => _mapToList('Tobi', snap.documents));
      } else {
        return Observable.just([]);
      }
    });

    jennyEntries = user.switchMap((FirebaseUser u) {
      if (u != null) {
        return _firestore
            .collection('users')
            .document('jenny')
            .collection('data')
            .orderBy('date', descending: true)
            .snapshots()
            .map((snap) => _mapToList('Jenny', snap.documents));
      } else {
        return Observable.just([]);
      }
    });

    allEntries = Observable.combineLatest2(
        tobiEntries,
        jennyEntries,
        (List<DataEntry> t, List<DataEntry> j) => List.from(t)
          ..addAll(j)
          ..sort((a, b) => b.date.compareTo(a.date)));
  }

  List<DataEntry> _mapToList(String name, List<DocumentSnapshot> docList) {
    if (docList == null || docList.isEmpty) return [];

    List<DataEntry> entryList = [];
    docList.forEach((document) {
      print(document.data['value']);

      String title = document.data['title'];
      double value = document.data['value'].toDouble();
      Timestamp timestamp = document.data['date'];
      DateTime date =
          DateTime.fromMillisecondsSinceEpoch(timestamp.millisecondsSinceEpoch);

      entryList.add(DataEntry(title, value, date, name, document.documentID));
    });

    return entryList;
  }

  void signIn() {
    _auth.signInWithEmailAndPassword(
        email: Credentials.EMAIL, password: Credentials.PASSWORD);
  }

  void signOut() {
    _auth.signOut();
  }

  @override
  void dispose() {}
}
