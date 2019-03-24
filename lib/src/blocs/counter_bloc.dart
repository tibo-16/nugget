import 'package:nugget/src/resources/bloc_provider.dart';
import 'package:rxdart/rxdart.dart';

class CounterBloc implements BlocBase {
  BehaviorSubject _counter = BehaviorSubject.seeded(0);

  Observable get counter => _counter.stream;
  int get _current => _counter.value;

  increment() {
    _counter.sink.add(_current + 1);
  }

  decrement() {
    _counter.sink.add(_current - 1);
  }

  @override
  void dispose() {
    _counter.close();
  }
}
