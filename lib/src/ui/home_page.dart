import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:nugget/src/blocs/firebase_bloc.dart';
import 'package:nugget/src/models/data_entry.dart';
import 'package:nugget/src/resources/bloc_provider.dart';
import 'package:nugget/utils/app_colors.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  FirebaseBloc _bloc;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _bloc = BlocProvider.of<FirebaseBloc>(context);
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
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              StreamBuilder(
                stream: _bloc.allEntries,
                builder: (context, AsyncSnapshot<List<DataEntry>> snapshot) {
                  if (snapshot.hasError) {
                    print(snapshot.error);
                    return Text('Fehler');
                  } else if (!snapshot.hasData) {
                    return Text('Keine Daten!');
                  } else {
                    print('Entries Count: ${snapshot.data.length}');
                    snapshot.data.forEach((entry) => print(entry.title));
                    return Text('Daten vorhanden: ${snapshot.data.length}');
                  }
                },
              ),
              StreamBuilder(
                stream: _bloc.user,
                builder: (context, AsyncSnapshot<FirebaseUser> snapshot) {
                  if (!snapshot.hasData) {
                    return Text('Kein User!');
                  }
                  return Text('User: ${snapshot.data.email}');
                },
              ),
              FlatButton(
                child: Text('Sign In'),
                onPressed: _bloc.signIn,
              ),
              FlatButton(
                child: Text('Sign Out'),
                onPressed: _bloc.signOut,
              )
            ],
          ),
        ),
      ),
    );
  }
}
