// import 'dart:convert';
// import 'package:custom_searchable_dropdown/custom_searchable_dropdown.dart';
// import 'package:flutter/material.dart';
//
// void main() {
//   runApp(MyApp());
// }
//
// class MyApp extends StatelessWidget {
//   // This widget is the root of your application.
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Flutter Demo',
//       theme: ThemeData(
//         // This is the theme of your application.
//         primarySwatch: Colors.blue,
//         visualDensity: VisualDensity.adaptivePlatformDensity,
//       ),
//       home: MyHomePage(
//         title: 'Custom Searchable DropDown Demo',
//       ),
//     );
//   }
// }
//
// class MyHomePage extends StatefulWidget {
//   MyHomePage({Key? key, required this.title}) : super(key: key);
//
//   final String title;
//
//   @override
//   _MyHomePageState createState() => _MyHomePageState();
// }
//
// class _MyHomePageState extends State<MyHomePage> {
//   // Updated list with Indian Muslim names including Waseem
//   List listToSearch = [
//     {'name': 'Waseem', 'class': 12},
//     {'name': 'Ayaan', 'class': 9},
//     {'name': 'Zain', 'class': 7},
//     {'name': 'Noor', 'class': 6},
//     {'name': 'Sarah', 'class': 5},
//     {'name': 'Omar', 'class': 4},
//     {'name': 'Layla', 'class': 3},
//   ];
//
//   var selected;
//   late List selectedList;
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text(widget.title)),
//       body: Center(
//         child: Padding(
//           padding: const EdgeInsets.all(8.0),
//           child: ListView(
//             children: <Widget>[
//               SizedBox(height: 20),
//               Text('Menu Mode', style: TextStyle(fontWeight: FontWeight.bold)),
//               Padding(
//                 padding: const EdgeInsets.all(8.0),
//                 child: CustomSearchableDropDown(
//                   dropdownHintText: 'Search For Name Here... ',
//                   showLabelInMenu: true,
//                   initialValue: [
//                     {'parameter': 'name', 'value': 'Waseem'}
//                   ],
//                   dropdownItemStyle: TextStyle(color: Colors.grey),
//                   primaryColor: Colors.blue,
//                   menuMode: true,
//                   labelStyle: TextStyle(
//                       color: Colors.grey, fontWeight: FontWeight.bold),
//                   items: listToSearch,
//                   label: 'Select Name',
//                   prefixIcon: Icon(Icons.search),
//                   dropDownMenuItems:
//                       listToSearch.map((item) => item['name']).toList(),
//                   onChanged: (value) {
//                     if (value != null) {
//                       selected = value['class'].toString();
//                     } else {
//                       selected = null;
//                     }
//                   },
//                 ),
//               ),
//               SizedBox(height: 20),
//               Text('Select a value',
//                   style: TextStyle(fontWeight: FontWeight.bold)),
//               Padding(
//                 padding: const EdgeInsets.all(8.0),
//                 child: CustomSearchableDropDown(
//                   items: listToSearch,
//                   label: 'Select Name',
//                   decoration:
//                       BoxDecoration(border: Border.all(color: Colors.blue)),
//                   prefixIcon: Padding(
//                       padding: const EdgeInsets.all(0.0),
//                       child: Icon(Icons.search)),
//                   dropDownMenuItems:
//                       listToSearch.map((item) => item['name']).toList(),
//                   onChanged: (value) {
//                     if (value != null) {
//                       selected = value['class'].toString();
//                     } else {
//                       selected = null;
//                     }
//                   },
//                 ),
//               ),
//               Text('Multi Select',
//                   style: TextStyle(fontWeight: FontWeight.bold)),
//               Padding(
//                 padding: const EdgeInsets.all(8.0),
//                 child: CustomSearchableDropDown(
//                   items: listToSearch,
//                   label: 'Select Name',
//                   multiSelectTag: 'Names',
//                   decoration:
//                       BoxDecoration(border: Border.all(color: Colors.blue)),
//                   multiSelect: true,
//                   prefixIcon: Padding(
//                     padding: const EdgeInsets.all(0.0),
//                     child: Icon(Icons.search),
//                   ),
//                   dropDownMenuItems:
//                       listToSearch.map((item) => item['name']).toList(),
//                   onChanged: (value) {
//                     if (value != null) {
//                       selectedList = jsonDecode(value);
//                     } else {
//                       selectedList.clear();
//                     }
//                   },
//                 ),
//               ),
//               Text('Multi Select as Widget',
//                   style: TextStyle(fontWeight: FontWeight.bold)),
//               Padding(
//                 padding: const EdgeInsets.all(8.0),
//                 child: CustomSearchableDropDown(
//                   initialValue: [
//                     {'parameter': 'name', 'value': 'Waseem'},
//                     {'parameter': 'name', 'value': 'Akhtar'}
//                   ],
//                   items: listToSearch,
//                   label: 'Select Name',
//                   multiSelectTag: 'Names',
//                   multiSelectValuesAsWidget: true,
//                   decoration:
//                       BoxDecoration(border: Border.all(color: Colors.blue)),
//                   multiSelect: true,
//                   prefixIcon: Padding(
//                       padding: const EdgeInsets.all(0.0),
//                       child: Icon(Icons.search)),
//                   dropDownMenuItems:
//                       listToSearch.map((item) => item['name']).toList(),
//                   onChanged: (value) {
//                     print(value.toString());
//                     if (value != null) {
//                       selectedList = jsonDecode(value);
//                     } else {
//                       selectedList.clear();
//                     }
//                   },
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
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
  Map<String, dynamic> toMap() => {'name': name, 'class': studentClass};
  @override
  String toString() => name;
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

  // Sample data as a list of maps.
  List<Map<String, dynamic>> listToSearch = [
    {'name': 'Waseem', 'class': 12},
    {'name': 'Ayaan', 'class': 9},
    {'name': 'Zain', 'class': 7},
    {'name': 'Sarah', 'class': 5},
    {'name': 'Omar', 'class': 4},
    {'name': 'Layla', 'class': 3}
  ];

  late List<Student> studentList;

  @override
  void initState() {
    super.initState();
    // Convert maps to a list of Student objects.
    studentList = listToSearch.map((map) => Student.fromMap(map)).toList();
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
              menuMode: false,
              showLabelInMenu: false,
              initialValue: [studentList.first],
              dropdownItemStyle: TextStyle(color: Colors.grey),
              primaryColor: Colors.blue,
              items: studentList,
              prefixIcon: Icon(Icons.search),
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
              decoration: BoxDecoration(border: Border.all(color: Colors.blue)),
              prefixIcon: Padding(padding: const EdgeInsets.all(0.0), child: Icon(Icons.search)),
              displayItem: (Student student) => '${student.name} - Class ${student.studentClass}',
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
              decoration: BoxDecoration(border: Border.all(color: Colors.blue)),
              multiSelect: true,
              prefixIcon: Padding(padding: const EdgeInsets.all(0.0), child: Icon(Icons.search)),
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
              decoration: BoxDecoration(border: Border.all(color: Colors.blue)),
              multiSelect: true,
              prefixIcon: Padding(padding: const EdgeInsets.all(0.0), child: Icon(Icons.search)),
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
