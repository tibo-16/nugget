import 'package:flutter/material.dart';
import 'package:nugget/src/blocs/firebase_bloc.dart';
import 'package:nugget/src/resources/bloc_provider.dart';
import 'package:nugget/src/ui/home_page.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      debugShowCheckedModeBanner: false,
      home:
          BlocProvider<FirebaseBloc>(bloc: FirebaseBloc(), child: MyHomePage()),
    );
  }
}
