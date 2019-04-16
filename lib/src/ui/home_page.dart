import 'package:flutter/material.dart';
import 'package:nugget/src/blocs/firebase_bloc.dart';
import 'package:nugget/src/models/data_entry.dart';
import 'package:nugget/src/models/filter.dart';
import 'package:nugget/src/resources/bloc_provider.dart';
import 'package:nugget/utils/app_colors.dart';
import 'package:nugget/utils/utils.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  FirebaseBloc _bloc;
  Filter _filter;

  @override
  void initState() {
    super.initState();

    _filter = Filter(isActive: false, isLeft: true);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _bloc = BlocProvider.of<FirebaseBloc>(context);
  }

  _setFilter({bool isLeft}) {
    bool isActive = _filter.isActive && _filter.isLeft == isLeft ? false : true;

    setState(() {
      _filter = Filter(isActive: isActive, isLeft: isLeft);
    });
  }

  Widget _buildFilter(AsyncSnapshot<List<DataEntry>> snapshot) {
    return PreferredSize(
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
              AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                alignment: Alignment(_filter.x, -1),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  width: (MediaQuery.of(context).size.width - 20) / 2,
                  decoration: BoxDecoration(
                    borderRadius: _filter.borderRadius,
                    color: Colors.white70.withOpacity(_filter.opacity),
                  ),
                ),
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Expanded(
                    child: FlatButton(
                      child: RichText(
                        text: TextSpan(children: [
                          TextSpan(
                              text: 'Jenny: ',
                              style: TextStyle(
                                  fontFamily: 'CaviarDreams',
                                  fontWeight: FontWeight.w700,
                                  fontSize: 15,
                                  color: Colors.black87)),
                          TextSpan(
                              text: Utils.formatValue(Utils.calculateSumForName(
                                  snapshot.data, 'Jenny')),
                              style: TextStyle(
                                  color: Colors.black87,
                                  fontWeight: FontWeight.bold))
                        ]),
                      ),
                      onPressed: () => _setFilter(isLeft: true),
                    ),
                  ),
                  Expanded(
                    child: FlatButton(
                      child: RichText(
                        text: TextSpan(children: [
                          TextSpan(
                              text: 'Tobi: ',
                              style: TextStyle(
                                  fontFamily: 'CaviarDreams',
                                  fontWeight: FontWeight.w700,
                                  fontSize: 15,
                                  color: Colors.black87)),
                          TextSpan(
                              text: Utils.formatValue(Utils.calculateSumForName(
                                  snapshot.data, 'Tobi')),
                              style: TextStyle(
                                  color: Colors.black87,
                                  fontWeight: FontWeight.bold))
                        ]),
                      ),
                      onPressed: () => _setFilter(isLeft: false),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBody(AsyncSnapshot<List<DataEntry>> snapshot) {
    List<DataEntry> listEntries = snapshot.data;

    if (listEntries != null && _filter.isActive) {
      listEntries =
          listEntries.where((entry) => entry.name == _filter.name).toList();
    }

    if (snapshot.hasError) {
      print(snapshot.error);
      return Center(child: Text('Fehler!'));
    } else if (!snapshot.hasData) {
      return Center(child: Text('Keine Daten!'));
    } else {
      return ListView.builder(
          itemCount: listEntries.length,
          itemBuilder: (context, i) {
            return Card(
              child: ListTile(
                title: Text(listEntries[i].title),
                subtitle: Text(
                  Utils.formatDate(listEntries[i].date),
                  style: TextStyle(letterSpacing: 0.5),
                ),
                trailing: Text(Utils.formatValue(listEntries[i].value)),
                leading:
                    Icon(Utils.getIconForCategory(listEntries[i].category)),
              ),
            );
          });
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<DataEntry>>(
        stream: _bloc.allEntries,
        initialData: [],
        builder: (context, snapshot) {
          return Scaffold(
              appBar: AppBar(
                centerTitle: false,
                title: Text(
                  'ÜBERSICHT',
                  style: TextStyle(
                      fontFamily: 'CaviarDreams', fontWeight: FontWeight.w700),
                ),
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
                bottom: _buildFilter(snapshot),
              ),
              body: _buildBody(snapshot));
        });
  }
}
