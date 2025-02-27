# Custom Searchable Dropdown Widget

The **Custom Searchable Dropdown** widget allows users to search from a dynamic list of data. You can customize the dropdown to suit your needs, and it supports both multiple select and single select options. The widget’s `onChange` event returns the complete list or the index of the selected option.

---
## Platforms Supported

This widget has been successfully tested on the following platforms:
- iOS
- Android
- Chrome

---

## Examples

The following examples showcase how the widget works in different modes.

### Gallery

See code below.

### Gallery

| Example Name       | Image                                                                 |
| ------------------ | --------------------------------------------------------------------- |
| [Menu Mode](#Menu-Mode)      | ![Menu Mode](doc/images/menuMode.png)                              |
| [All DropDown](#All-DropDown) | ![All DropDown](doc/images/all.png)                                |
| [MultiSelect DropDown](#MultiSelect-DropDown) | ![MultiSelect DropDown](doc/images/multiSelect.png)  |

### Code

#### Plugin usage

Add to your `pubspec.yaml` in the `dependencies` section:
```
  custom_searchable_dropdown:
```

Get packages with command:
```
flutter packages get
```

Import:
```dart
import 'package:custom_searchable_dropdown/custom_searchable_dropdown.dart';
```


#### Menu Mode
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

#### Single Select
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
#### Multi Select
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
