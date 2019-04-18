import 'package:firebase_auth/firebase_auth.dart';
import 'package:nugget/src/models/data_entry.dart';
import 'package:nugget/src/resources/bloc_provider.dart';
import 'package:nugget/src/resources/firebase_repository.dart';
import 'package:rxdart/rxdart.dart';

class FirebaseBloc implements BlocBase {
  FirebaseRepository _repo = FirebaseRepository();

  Observable<FirebaseUser> _user;
  Observable<List<DataEntry>> tobiEntries;
  Observable<List<DataEntry>> jennyEntries;
  Observable<List<DataEntry>> allEntries;

  FirebaseBloc() {
    // Check if user is logged in. If not, then login()
    _repo.signIn().then((_) {
      // Observer for auth state
      _user = Observable(_repo.authStream);

      // Alle Einträge von Tobi
      tobiEntries = _user.switchMap((FirebaseUser u) {
        if (u != null) {
          return _repo
              .getEntriesStream('tobi')
              .map((snap) => DataEntry.mapToList('Tobi', snap.documents));
        } else {
          return Observable.just([]);
        }
      });

      // Alle Einträge von Jenny
      jennyEntries = _user.switchMap((FirebaseUser u) {
        if (u != null) {
          return _repo
              .getEntriesStream('jenny')
              .map((snap) => DataEntry.mapToList('Jenny', snap.documents));
        } else {
          return Observable.just([]);
        }
      });

      // Alle Einträge
      allEntries = Observable.combineLatest2(
          tobiEntries,
          jennyEntries,
          (List<DataEntry> t, List<DataEntry> j) => List.from(t)
            ..addAll(j)
            ..sort((a, b) => b.date.compareTo(a.date)));
    });
  }

  Function get signIn => _repo.signIn;
  Function get signOut => _repo.signOut;

  Function get delete => _repo.deleteDocument;
  Function get add => _repo.addDocument;

  @override
  void dispose() {}
}
