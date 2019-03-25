import 'package:flutter/material.dart';
import 'package:nugget/src/blocs/counter_bloc.dart';
import 'package:nugget/src/resources/bloc_provider.dart';
import 'package:nugget/utils/app_colors.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  CounterBloc _bloc;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _bloc = BlocProvider.of<CounterBloc>(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [AppColors.PURPLE, AppColors.BLUE])),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  'You have pushed the button this many times:',
                ),
                StreamBuilder(
                    stream: _bloc.counter,
                    builder: (context, snapshot) {
                      return Text(
                        '${snapshot.data}',
                        style: Theme.of(context).textTheme.display1,
                      );
                    }),
                StreamBuilder(
                  stream: _bloc.entries,
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return Text('Keine Daten!');
                    } else if (snapshot.hasError) {
                      return Text(snapshot.error);
                    } else {
                      print('Entries Count: ${snapshot.data.documents.length}');
                      return Text(
                          'Daten vorhanden! ${snapshot.data.documents.length}');
                    }
                  },
                )
              ],
            ),
          ),
        ),
        floatingActionButton: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            FloatingActionButton(
              onPressed: _bloc.increment,
              tooltip: 'Increment',
              child: Icon(Icons.add),
            ),
            SizedBox(
              width: 10,
            ),
            FloatingActionButton(
              onPressed: _bloc.decrement,
              tooltip: 'Decrement',
              child: Icon(Icons.remove),
            ),
          ],
        ));
  }
}
