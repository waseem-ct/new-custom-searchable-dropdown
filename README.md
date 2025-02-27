# Custom Searchable Dropdown Widget

[![Pub Version](https://img.shields.io/pub/v/custom_searchable_dropdown)](https://pub.dev/packages/custom_searchable_dropdown)
[![License: MIT](https://img.shields.io/badge/license-MIT-blue.svg)](https://github.com/amirr-dotcom/custom_searchable_dropdown/blob/main/LICENSE)

The **Custom Searchable Dropdown** widget allows users to search from a dynamic list of data. You can customize the dropdown to suit your needs, and it supports both multiple select and single select options. The widget’s `onChange` event returns the complete list or the index of the selected option.

---

## 📌 Features

✅ Searchable dropdown with instant filtering  
✅ Single and multi-select modes  
✅ Custom styling and theming support  
✅ Async data loading for large datasets  
✅ Works on mobile and web  
✅ Keyboard and touch navigation support  
✅ Support for custom UI widgets inside dropdown

---

## 🏗 Platforms Supported

This widget has been successfully tested on the following platforms:
- ✅ iOS
- ✅ Android
- ✅ Web (Chrome)

---

## 🎨 Examples

The following examples showcase how the widget works in different modes.

### 📌 Gallery

| Example Name       | Preview Image                                                           |
| ------------------ | --------------------------------------------------------------------- |
| [Menu Mode](#Menu-Mode)      | ![Menu Mode](doc/images/menuMode.png)                              |
| [All DropDown](#All-DropDown) | ![All DropDown](doc/images/all.png)                                |
| [MultiSelect DropDown](#MultiSelect-DropDown) | ![MultiSelect DropDown](doc/images/multiSelect.png)  |

---

## 🛠 Installation

Add this dependency to your `pubspec.yaml`:

```yaml
dependencies:
  custom_searchable_dropdown: latest_version

Get packages with command:
```
flutter packages get
```

Import:
```dart
import 'package:custom_searchable_dropdown/custom_searchable_dropdown.dart';
```

# 📝 Usage
---
#### 🎯 Basic Example
```dart
CustomSearchableDropDown(
items: ["Apple", "Banana", "Cherry", "Date"],
label: "Select a fruit",
onChanged: (value) {
print("Selected: $value");
},
);
```

#### 🏷 Menu Mode
```dart
    CustomSearchableDropDown(
                      dropdownHintText: 'Search For Name Here... ',
                      showLabelInMenu: true,
                      primaryColor: Colors.red,
                      menuMode: true,
                      labelStyle: TextStyle(
                        color: Colors.red,
                        fontWeight: FontWeight.bold
                      ),
                      items: listToSearch,
                      label: 'Select Name',
                      prefixIcon:  Padding(
                        padding: const EdgeInsets.all(0.0),
                        child: Icon(Icons.search),
                      ),
                      dropDownMenuItems: listToSearch?.map((item) {
                        return item['name'];
                      })?.toList() ??
                          [],
                      onChanged: (value){
                        if(value!=null)
                        {
                          selected = value['class'].toString();
                        }
                        else{
                          selected=null;
                        }
                      },
                    ),
```

#### 🎯 Single Select Mode
```dart
     CustomSearchableDropDown(
                     items: listToSearch,
                     label: 'Select Name',
                     decoration: BoxDecoration(
                         border: Border.all(
                             color: Colors.blue
                         )
                     ),
                     prefixIcon:  Padding(
                       padding: const EdgeInsets.all(0.0),
                       child: Icon(Icons.search),
                     ),
                     dropDownMenuItems: listToSearch?.map((item) {
                       return item['name'];
                     })?.toList() ??
                         [],
                     onChanged: (value){
                       if(value!=null)
                       {
                         selected = value['class'].toString();
                       }
                       else{
                         selected=null;
                       }
                     },
                   ),
```
####  Multi Select Mode
```dart
      CustomSearchableDropDown(
                      items: listToSearch,
                      label: 'Select Name',
                      multiSelectTag: 'Names',
                      decoration: BoxDecoration(
                          border: Border.all(
                              color: Colors.blue
                          )
                      ),
                      multiSelect: true,
                      prefixIcon:  Padding(
                        padding: const EdgeInsets.all(0.0),
                        child: Icon(Icons.search),
                      ),
                      dropDownMenuItems: listToSearch?.map((item) {
                        return item['name'];
                      })?.toList() ??
                          [],
                      onChanged: (value){
                        if(value!=null)
                        {
                          selectedList = jsonDecode(value);
                        }
                        else{
                          selectedList.clear();
                        }
                      },
                    ),
```

#### Multi Select as Widget
```dart
     CustomSearchableDropDown(
                  initialValue: [
                    {
                      'parameter': 'name',
                      'value': 'Sam',
                    },
                    {
                      'parameter': 'name',
                      'value': 'flutter',
                    },
                  ],
                  items: listToSearch,
                  label: 'Select Name',
                  multiSelectTag: 'Names',
                  multiSelectValuesAsWidget: true,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.blue
                    )
                  ),
                  multiSelect: true,
                  prefixIcon:  Padding(
                    padding: const EdgeInsets.all(0.0),
                    child: Icon(Icons.search),
                  ),
                  dropDownMenuItems: listToSearch?.map((item) {
                    return item['name'];
                  })?.toList() ??
                      [],
                  onChanged: (value){
                    print(value.toString());
                    if(value!=null)
                    {
                      selectedList = jsonDecode(value);
                    }
                    else{
                      selectedList.clear();
                    }
                  },
                ),"# csd" 



