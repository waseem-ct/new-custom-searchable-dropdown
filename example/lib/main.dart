import 'dart:convert';
import 'package:custom_searchable_dropdown/custom_searchable_dropdown.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(
        title: 'Custom Searchable DropDown Demo',
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  // Updated list with Indian Muslim names including Waseem
  List listToSearch = [
    {'name': 'Waseem', 'class': 12},
    {'name': 'Ayaan', 'class': 9},
    {'name': 'Zain', 'class': 7},
    {'name': 'Noor', 'class': 6},
    {'name': 'Sarah', 'class': 5},
    {'name': 'Omar', 'class': 4},
    {'name': 'Layla', 'class': 3},
  ];

  var selected;
  late List selectedList;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListView(
            children: <Widget>[
              SizedBox(height: 20),
              Text('Menu Mode', style: TextStyle(fontWeight: FontWeight.bold)),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: CustomSearchableDropDown(
                  dropdownHintText: 'Search For Name Here... ',
                  showLabelInMenu: true,
                  initialValue: [
                    {'parameter': 'name', 'value': 'Waseem'}
                  ],
                  dropdownItemStyle: TextStyle(color: Colors.red),
                  primaryColor: Colors.red,
                  menuMode: true,
                  labelStyle:
                      TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
                  items: listToSearch,
                  label: 'Select Name',
                  prefixIcon: Icon(Icons.search),
                  dropDownMenuItems:
                      listToSearch.map((item) => item['name']).toList(),
                  onChanged: (value) {
                    if (value != null) {
                      selected = value['class'].toString();
                    } else {
                      selected = null;
                    }
                  },
                ),
              ),
              SizedBox(height: 20),
              Text('Select a value',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: CustomSearchableDropDown(
                  items: listToSearch,
                  label: 'Select Name',
                  decoration:
                      BoxDecoration(border: Border.all(color: Colors.blue)),
                  prefixIcon: Padding(
                      padding: const EdgeInsets.all(0.0),
                      child: Icon(Icons.search)),
                  dropDownMenuItems:
                      listToSearch.map((item) => item['name']).toList(),
                  onChanged: (value) {
                    if (value != null) {
                      selected = value['class'].toString();
                    } else {
                      selected = null;
                    }
                  },
                ),
              ),
              Text('Multi Select',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: CustomSearchableDropDown(
                  items: listToSearch,
                  label: 'Select Name',
                  multiSelectTag: 'Names',
                  decoration:
                      BoxDecoration(border: Border.all(color: Colors.blue)),
                  multiSelect: true,
                  prefixIcon: Padding(
                    padding: const EdgeInsets.all(0.0),
                    child: Icon(Icons.search),
                  ),
                  dropDownMenuItems:
                      listToSearch.map((item) => item['name']).toList(),
                  onChanged: (value) {
                    if (value != null) {
                      selectedList = jsonDecode(value);
                    } else {
                      selectedList.clear();
                    }
                  },
                ),
              ),
              Text('Multi Select as Widget',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: CustomSearchableDropDown(
                  initialValue: [
                    {'parameter': 'name', 'value': 'Waseem'},
                    {'parameter': 'name', 'value': 'Akhtar'}
                  ],
                  items: listToSearch,
                  label: 'Select Name',
                  multiSelectTag: 'Names',
                  multiSelectValuesAsWidget: true,
                  decoration:
                      BoxDecoration(border: Border.all(color: Colors.blue)),
                  multiSelect: true,
                  prefixIcon: Padding(
                      padding: const EdgeInsets.all(0.0),
                      child: Icon(Icons.search)),
                  dropDownMenuItems:
                      listToSearch.map((item) => item['name']).toList(),
                  onChanged: (value) {
                    print(value.toString());
                    if (value != null) {
                      selectedList = jsonDecode(value);
                    } else {
                      selectedList.clear();
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
