import 'package:nugget/src/resources/bloc_provider.dart';
import 'package:nugget/src/resources/firestore_provider.dart';
import 'package:rxdart/rxdart.dart';

class CounterBloc implements BlocBase {
  BehaviorSubject _counter = BehaviorSubject.seeded(0);
  FirestoreProvider _firestoreProvider = FirestoreProvider();

  Observable get counter => _counter.stream;
  int get _current => _counter.value;

  increment() {
    _counter.sink.add(_current + 1);
  }

  decrement() {
    _counter.sink.add(_current - 1);
  }

  Stream get entries => _firestoreProvider.getEntries();

  @override
  void dispose() {
    _counter.close();
  }
}
