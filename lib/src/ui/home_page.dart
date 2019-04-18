import 'package:flutter/material.dart';
import 'package:nugget/src/blocs/firebase_bloc.dart';
import 'package:nugget/src/models/data_entry.dart';
import 'package:nugget/src/models/filter.dart';
import 'package:nugget/src/resources/bloc_provider.dart';
import 'package:nugget/src/ui/add_sheet.dart';
import 'package:nugget/utils/app_colors.dart';
import 'package:nugget/utils/utils.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage>
    with SingleTickerProviderStateMixin {
  FirebaseBloc _bloc;
  Filter _filter;
  Filter _savedFilter;

  TabController _controller;

  @override
  void initState() {
    super.initState();

    _filter = Filter(isActive: false, isLeft: true);
    _savedFilter = null;

    _controller = TabController(vsync: this, length: 2);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _bloc = BlocProvider.of<FirebaseBloc>(context);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  bool get isHome {
    return _controller.index == 0 ? true : false;
  }

  String get title {
    return isHome ? 'ÜBERSICHT' : 'NEUER EINTRAG';
  }

  _setFilter({bool isLeft}) {
    bool isActive = _filter.isActive && _filter.isLeft == isLeft ? false : true;

    // Überschreiben
    if (!isHome) {
      isActive = true;
    }

    setState(() {
      _filter.updateFields(isActive: isActive, isLeft: isLeft);
    });
  }

  _showHomePage() {
    _controller.animateTo(0);
    setState(() {
      _filter = _savedFilter;
    });
  }

  _showAddSheet() {
    _controller.animateTo(1);
    setState(() {
      _savedFilter = Filter.from(_filter);
      _filter.updateFields(isActive: true, isLeft: true);
    });
  }

  Future<bool> confirmDismiss(BuildContext context) {
    return showModalBottomSheet(
        context: context,
        builder: (context) {
          return SafeArea(
            bottom: true,
            child: Padding(
              padding:
                  const EdgeInsets.only(top: 16.0, left: 16.0, right: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  RaisedButton(
                    color: Colors.redAccent,
                    textColor: Colors.white,
                    child: Text(
                      'LÖSCHEN',
                      style: TextStyle(
                        fontFamily: 'CaviarDreams',
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    onPressed: () => Navigator.pop(context, true),
                  ),
                  RaisedButton(
                    color: Colors.grey.shade300,
                    textColor: Colors.black,
                    child: Text(
                      'NICHT LÖSCHEN',
                      style: TextStyle(
                        fontFamily: 'CaviarDreams',
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    onPressed: () => Navigator.pop(context, false),
                  ),
                ],
              ),
            ),
          );
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
                              text: 'Jenny',
                              style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 15,
                                  color: Colors.black87)),
                          TextSpan(
                              text: isHome
                                  ? ': ${Utils.formatValue(Utils.calculateSumForName(snapshot.data, 'Jenny'))}'
                                  : '',
                              style: TextStyle(
                                  color: Colors.black87,
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold))
                        ]),
                      ),
                      onPressed: () => _setFilter(isLeft: true),
                      highlightColor: Colors.transparent,
                      splashColor: Colors.transparent,
                    ),
                  ),
                  Expanded(
                    child: FlatButton(
                      child: RichText(
                        text: TextSpan(children: [
                          TextSpan(
                              text: 'Tobi',
                              style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 15,
                                  color: Colors.black87)),
                          TextSpan(
                              text: isHome
                                  ? ': ${Utils.formatValue(Utils.calculateSumForName(snapshot.data, 'Tobi'))}'
                                  : '',
                              style: TextStyle(
                                  color: Colors.black87,
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold))
                        ]),
                      ),
                      onPressed: () => _setFilter(isLeft: false),
                      highlightColor: Colors.transparent,
                      splashColor: Colors.transparent,
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
      return Center(
          child: Text(
        'Fehler!\nBitte neustarten!',
        textAlign: TextAlign.center,
        style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w400,
            color: Colors.grey.shade600),
      ));
    } else if (!snapshot.hasData) {
      return Center(
          child: Text(
        'Es wurden keine Daten gefunden!',
        textAlign: TextAlign.center,
        style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w400,
            color: Colors.grey.shade600),
      ));
    } else {
      if (listEntries.isEmpty) {
        return Center(
          child: Text(
            'Es sind noch\nkeine Einträge vorhanden!',
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: Colors.grey.shade600),
          ),
        );
      }

      return ListView.builder(
        itemCount: listEntries.length,
        itemBuilder: (context, i) {
          return Card(
            child: Dismissible(
              key: UniqueKey(),
              background: Container(
                padding: EdgeInsets.all(16),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: Text(listEntries[i].title,
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.redAccent,
                              fontSize: 16)),
                    ),
                    Icon(
                      Icons.delete_forever,
                      color: Colors.redAccent,
                    )
                  ],
                ),
              ),
              confirmDismiss: (_) => confirmDismiss(context),
              onDismissed: (_) {
                _bloc.delete(listEntries[i]);
              },
              child: ListTile(
                title: Text(listEntries[i].title),
                subtitle: Text(
                  '${Utils.getEmojiForName(listEntries[i].name)} - ${Utils.formatDate(listEntries[i].date)}',
                  style: TextStyle(letterSpacing: 0.5),
                ),
                trailing: Text(
                  Utils.formatValue(listEntries[i].value),
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                leading: Utils.getGradientIcon(
                    Utils.getIconForCategory(listEntries[i].category)),
              ),
            ),
            elevation: 2.0,
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<DataEntry>>(
        stream: _bloc.allEntries,
        initialData: [],
        builder: (context, snapshot) {
          return Scaffold(
              backgroundColor: Color.fromRGBO(245, 245, 245, 1.0),
              appBar: AppBar(
                centerTitle: false,
                title: Text(
                  title,
                  style: TextStyle(
                      fontFamily: 'CaviarDreams', fontWeight: FontWeight.w700),
                ),
                actions: <Widget>[
                  // IconButton(
                  //   icon: Icon(Icons.person),
                  //   color: Colors.white,
                  //   onPressed: _bloc.signIn,
                  // ),
                  // IconButton(
                  //   icon: Icon(Icons.directions_run),
                  //   color: Colors.white,
                  //   onPressed: _bloc.signOut,
                  // ),
                  IconButton(
                    icon: Icon(isHome ? Icons.add_circle_outline : Icons.close),
                    color: Colors.white,
                    onPressed: isHome ? _showAddSheet : _showHomePage,
                  )
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
              body: TabBarView(
                  controller: _controller,
                  physics: NeverScrollableScrollPhysics(),
                  children: <Widget>[
                    _buildBody(snapshot),
                    AddSheet(
                      filter: _filter,
                      addEntry: _bloc.add,
                      close: _showHomePage,
                    )
                  ]));
        });
  }
}
