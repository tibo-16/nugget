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
      appBar: AppBar(
        centerTitle: false,
        title: Text('Übersicht'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.person),
            color: Colors.white,
            onPressed: _bloc.signIn,
          ),
          IconButton(
            icon: Icon(Icons.directions_run),
            color: Colors.white,
            onPressed: _bloc.signOut,
          ),
        ],
        flexibleSpace: Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [AppColors.PURPLE, AppColors.BLUE])),
        ),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(40),
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: SizedBox(
              width: MediaQuery.of(context).size.width,
              height: 40,
              child: Stack(
                children: <Widget>[
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.25),
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      Expanded(
                        child: FlatButton(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(10),
                                  bottomLeft: Radius.circular(10))),
                          color: Colors.white70,
                          child: RichText(
                            text: TextSpan(children: [
                              TextSpan(
                                  text: 'Jenny: ',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black87)),
                              TextSpan(
                                  text: '120,50 €',
                                  style: TextStyle(color: Colors.black87))
                            ]),
                          ),
                          onPressed: () => print('jenny'),
                        ),
                      ),
                      Expanded(
                        child: FlatButton(
                          child: RichText(
                            text: TextSpan(children: [
                              TextSpan(
                                  text: 'Tobi: ',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black87)),
                              TextSpan(
                                  text: '120,50 €',
                                  style: TextStyle(color: Colors.black87))
                            ]),
                          ),
                          onPressed: () => print('tobi'),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
      body: StreamBuilder<List<DataEntry>>(
          stream: _bloc.allEntries,
          initialData: [],
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              print(snapshot.error);
              return Center(child: Text('Fehler!'));
            } else if (!snapshot.hasData) {
              return Center(child: Text('Keine Daten!'));
            } else {
              return ListView.builder(
                  itemCount: snapshot.data.length,
                  itemBuilder: (context, i) {
                    return Card(
                      child: ListTile(
                        title: Text(snapshot.data[i].title),
                        subtitle: Text(snapshot.data[i].date.toIso8601String()),
                        trailing: Text('${snapshot.data[i].value}'),
                        leading: Text(snapshot.data[i].name.substring(0, 1)),
                      ),
                    );
                  });
            }
          }),
    );
  }
}
