import 'package:cloud_firestore/cloud_firestore.dart';

class DataEntry {
  final String _title;
  final double _value;
  final DateTime _date;
  final int _category;
  final String _name;
  String docId;

  DataEntry(this._title, this._value, this._date, this._category, this._name,
      this.docId);

  String get title => _title;
  double get value => _value;
  DateTime get date => _date;
  int get category => _category;
  String get name => _name;

  static List<DataEntry> mapToList(
      String name, List<DocumentSnapshot> docList) {
    if (docList == null || docList.isEmpty) return [];

    List<DataEntry> entryList = [];
    docList.forEach((document) {
      String title = document.data['title'];
      double value = document.data['value'].toDouble();
      Timestamp timestamp = document.data['date'];
      DateTime date =
          DateTime.fromMillisecondsSinceEpoch(timestamp.millisecondsSinceEpoch);
      int category = document.data['category'];

      entryList.add(
          DataEntry(title, value, date, category, name, document.documentID));
    });

    return entryList;
  }

  static Map<String, dynamic> toMap(DataEntry entry) {
    Map<String, dynamic> map = Map();

    map.putIfAbsent('title', () => entry.title);
    map.putIfAbsent('value', () => entry.value);
    map.putIfAbsent('category', () => entry.category);
    map.putIfAbsent('date', () => Timestamp.fromDate(entry.date));

    return map;
  }
}
