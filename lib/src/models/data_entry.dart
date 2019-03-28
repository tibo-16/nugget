class DataEntry {
  final String _title;
  final double _value;
  final DateTime _date;
  final String _name;
  final String _docId;

  DataEntry(this._title, this._value, this._date, this._name, this._docId);

  String get title => _title;
  double get value => _value;
  DateTime get date => _date;
  String get name => _name;
  String get docId => _docId;
}
