import 'dart:convert';

import 'package:custom_searchable_dropdown/custom_searchable_dropdown.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

///
/// MAIN APP
///
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Custom Searchable Dropdown Example',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: MyExamplePage(),
    );
  }
}

///
/// DATA MODEL
///
class Student {
  final String name;
  final int studentClass; // Renamed from 'class' since it's reserved.
  Student({required this.name, required this.studentClass});
  factory Student.fromMap(Map<String, dynamic> map) => Student(name: map['name'], studentClass: map['class'] as int);
  Map<String, dynamic> toJson() => {'name': name, 'age': studentClass};

  Map<String, dynamic> toMap() => {'name': name, 'class': studentClass};
  @override
  String toString() => name;
}

class NumberEntry {
  int value;

  NumberEntry(this.value);

  // Factory constructor to create a NumberEntry from a map (if needed in the future)
  factory NumberEntry.fromMap(Map<String, dynamic> map) {
    return NumberEntry(map['value']);
  }

  @override
  String toString() {
    return value.toString();
  }
}

///
/// EXAMPLE PAGE USING THE DROPDOWN
///
class MyExamplePage extends StatefulWidget {
  @override
  _MyExamplePageState createState() => _MyExamplePageState();
}

class _MyExamplePageState extends State<MyExamplePage> {
  String? selected;
  List<dynamic> selectedList = [];
  late List<NumberEntry> numberEntries;
  late List<Student> studentList;

  // Sample data as a array.

  List<int> data = [1, 85, 15, 41, 5, 415, 415, 4, 54, 41, 54, 88, 14, 8, 45, 15, 0, 141];

  // Sample data as a list of maps.
  List<Map<String, dynamic>> listToSearch = [
    {'name': 'Waseem', 'class': 12},
    {'name': 'Ayaan', 'class': 9},
    {'name': 'Zain', 'class': 7},
    {'name': 'Sarah', 'class': 5},
    {'name': 'Omar', 'class': 4},
    {'name': 'Layla', 'class': 3}
  ];

  @override
  void initState() {
    super.initState();
    // Convert maps to a list of Student objects.
    studentList = listToSearch.map((map) => Student.fromMap(map)).toList();
    // Initialize the numberEntries list using the data
    numberEntries = data.map((value) => NumberEntry(value)).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Custom Searchable Dropdown Example')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Column(
          spacing: 10,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Single-select with modal menu mode:
            CustomSearchableDropDown<Student>(
              dropdownHintText: 'Search For Name Here...',
              menuMode: true,
              showLabelInMenu: true,
              showClearButton: true,
              initialValue: [studentList.first],
              items: studentList,
              // Use a display callback to define how each Student is shown.
              displayItem: (Student student) => '${student.name}',
              onChanged: (value) => setState(() {
                // Since onChanged is dynamic, we check the type.
                if (value != null && value is Student) {
                  selected = value.studentClass.toString();
                } else {
                  selected = null;
                }
              }),
            ),
            // Inline single-select example:
            Text('Select a value', style: TextStyle(fontWeight: FontWeight.bold)),
            CustomSearchableDropDown<Student>(
              items: studentList,
              label: 'Select Student',
              showLabelInMenu: true,
              // prefixIcon: Padding(padding: const EdgeInsets.all(0.0), child: Icon(Icons.search)),
              displayItem: (Student student) => '${student.name} - Class ${student.studentClass}',
              onChanged: (value) => setState(() {
                if (value != null && value is Student) {
                  selected = value.studentClass.toString();
                } else {
                  selected = null;
                }
              }),
            ),
            Text('Select a Number', style: TextStyle(fontWeight: FontWeight.bold)),
            CustomSearchableDropDown<NumberEntry>(
              items: numberEntries,
              label: 'Select Number',
              displayItem: (NumberEntry numberEntries) => numberEntries.value.toString(),
              onChanged: (value) => setState(() {
                if (value != null && value is Student) {
                  selected = value.studentClass.toString();
                } else {
                  selected = null;
                }
              }),
            ),
            // Multi-select example:
            Text('Multi Select', style: TextStyle(fontWeight: FontWeight.bold)),
            CustomSearchableDropDown<Student>(
              items: studentList,
              label: 'Select Student',
              multiSelectTag: 'Students',
              multiSelect: true,
              displayItem: (Student student) => '${student.name} - Class ${student.studentClass}',
              onChanged: (value) => setState(() {
                // For multi-select, onChanged returns a JSON encoded list.
                if (value != null && value is String) {
                  selectedList = jsonDecode(value);
                } else {
                  selectedList.clear();
                }
              }),
            ),
            // Multi-select with values as widgets:
            Text('Multi Select as Widget', style: TextStyle(fontWeight: FontWeight.bold)),
            CustomSearchableDropDown<Student>(
              initialValue: [studentList.first, studentList[1]],
              items: studentList,
              label: 'Select Student',
              multiSelectTag: 'Students',
              multiSelectValuesAsWidget: true,
              multiSelect: true,
              displayItem: (Student student) => '${student.name} - Class ${student.studentClass}',
              onChanged: (value) => setState(() {
                if (value != null && value is String) {
                  print(value.toString());
                  selectedList = jsonDecode(value);
                } else {
                  selectedList.clear();
                }
              }),
            ),
          ],
        ),
      ),
    );
  }
}
