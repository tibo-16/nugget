import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:nugget/src/blocs/firebase_bloc.dart';
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
                stream: _bloc.entries,
                builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (!snapshot.hasData) {
                    return Text('Keine Daten!');
                  } else if (snapshot.hasError) {
                    return Text(snapshot.error);
                  } else {
                    print('Entries Count: ${snapshot.data.documents.length}');
                    snapshot.data.documents.forEach((doc) => print(doc.data['name']));
                    return Text('Daten vorhanden');
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
                child: Text('Login'),
                onPressed: _bloc.login,
              ),
              FlatButton(
                child: Text('Logout'),
                onPressed: _bloc.logout,
              )
            ],
          ),
        ),
      ),
    );
  }
}
