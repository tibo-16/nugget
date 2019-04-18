import 'package:flutter/material.dart';
import 'package:nugget/src/models/data_entry.dart';
import 'package:nugget/src/models/filter.dart';
import 'package:nugget/utils/app_colors.dart';
import 'package:nugget/utils/utils.dart';

class AddSheet extends StatefulWidget {
  final Filter filter;
  final Function addEntry;
  final Function close;

  AddSheet(
      {@required this.filter, @required this.addEntry, @required this.close});

  @override
  State<StatefulWidget> createState() => _AddSheetState();
}

class _AddSheetState extends State<AddSheet> {
  TextEditingController titleController = TextEditingController();
  TextEditingController valueController = TextEditingController();
  int selectedCategory = -1;
  DateTime selectedDate = DateTime.now();
  bool saveEnabled = false;

  String get formattedDate {
    return '${Utils.getShortWeekDay(selectedDate.weekday)}, ${Utils.formatDate(selectedDate)}';
  }

  _hideKeyboard() => FocusScope.of(context).requestFocus(FocusNode());

  _selectCategory(int category) {
    _hideKeyboard();

    setState(() {
      selectedCategory = category;
    });

    _checkSave();
  }

  _changeDate() async {
    _hideKeyboard();

    DateTime pickedDate = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: selectedDate.subtract(Duration(days: 1000)),
        lastDate: selectedDate.add(Duration(days: 1000)));

    if (pickedDate != null) {
      setState(() {
        selectedDate = pickedDate;
      });
    }
  }

  _checkSave() {
    // Titel
    bool title = titleController.text.isNotEmpty;
    // Betrag
    bool value = valueController.text.isNotEmpty &&
        double.tryParse(valueController.text) != null;
    // Kategorie
    bool category = selectedCategory != -1;

    setState(() {
      saveEnabled = title && value && category;
    });
  }

  _save() {
    String name = widget.filter.name;
    String title = titleController.text;
    double value = double.tryParse(valueController.text);
    int category = selectedCategory;
    DateTime date = selectedDate;

    DataEntry newEntry = DataEntry(title, value, date, category, name, null);
    widget.addEntry(newEntry);
    widget.close();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _hideKeyboard,
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Text(
              'Titel',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
            ),
            TextField(
              controller: titleController,
              onChanged: (_) => _checkSave(),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 16.0),
              child: Text(
                'Betrag',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
              ),
            ),
            TextField(
              controller: valueController,
              onChanged: (_) => _checkSave(),
              keyboardType: TextInputType.numberWithOptions(decimal: true),
              decoration: InputDecoration(suffixText: '€'),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 16.0),
              child: Text(
                'Kategorie',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: List.generate(
                  5,
                  (i) => IconButton(
                      color:
                          selectedCategory == i ? AppColors.BLUE : Colors.grey,
                      icon: Icon(Utils.getIconForCategory(i + 1)),
                      highlightColor: Colors.transparent,
                      splashColor: Colors.transparent,
                      onPressed: () => _selectCategory(i))),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Text(
                'Datum',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
              ),
            ),
            InkWell(
              child: Container(
                height: 50,
                alignment: Alignment.centerLeft,
                decoration: BoxDecoration(
                    border: Border(
                        bottom: BorderSide(color: Colors.grey, width: 2))),
                child: Text(
                  formattedDate,
                  style: TextStyle(fontSize: 16, letterSpacing: 0.2),
                ),
              ),
              onTap: () => _changeDate(),
            ),
            Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: RaisedButton(
                    color: AppColors.PURPLE,
                    child: Text(
                      'SPEICHERN',
                      style: TextStyle(
                          fontFamily: 'CaviarDreams',
                          fontWeight: FontWeight.w700,
                          color: Colors.white),
                    ),
                    onPressed: saveEnabled ? _save : null,
                    highlightColor: Colors.transparent,
                    splashColor: Colors.transparent))
          ],
        ),
      ),
    );
  }
}
