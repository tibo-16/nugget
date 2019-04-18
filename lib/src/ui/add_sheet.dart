import 'package:flutter/material.dart';

class AddSheet extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _AddSheetState();
}

class _AddSheetState extends State<AddSheet> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Text('Titel'),
        TextField(),
        Text('Betrag'),
        TextField(),
        Text('Kategorie'),
        FlatButton(
          child: Text('K'),
          color: Colors.red,
          onPressed: null,
        ),
        Text('Datum'),
        FlatButton(
          child: Text('D'),
          color: Colors.red,
          onPressed: null,
        ),
        FlatButton(child: Text('Save'), color: Colors.red, onPressed: null)
      ],
    );
  }
}
