library custom_searchable_dropdown;

import 'dart:convert';

import 'package:flutter/material.dart';

///
/// CUSTOM SEARCHABLE DROPDOWN WIDGET (Generic)
///
typedef DisplayItemBuilder<T> = String Function(T item);
typedef SearchFunction<T> = bool Function(T item, String searchTerm);

class CustomSearchableDropDown<T> extends StatefulWidget {
  final List<T> items;
  final List? initialValue;
  final double? searchBarHeight;
  final Color? primaryColor;
  final Color? backgroundColor;
  final Color? dropdownBackgroundColor;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? menuPadding;
  final String? label;
  final String? dropdownHintText;
  final TextStyle? labelStyle;
  final TextStyle? dropdownItemStyle;
  final String? hint;
  final String? multiSelectTag;
  final int? initialIndex;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final bool? hideSearch;
  final bool? enabled;
  final bool? showClearButton;
  final bool? menuMode;
  final double? menuHeight;
  final bool? multiSelect;
  final bool? multiSelectValuesAsWidget;
  final bool? showLabelInMenu;
  final Decoration? decoration;
  final TextAlign? labelAlign;
  final ValueChanged<dynamic> onChanged;
  final DisplayItemBuilder<T>? displayItem;
  final SearchFunction<T>? searchFn;

  CustomSearchableDropDown({
    required this.items,
    required this.onChanged,
    this.label,
    this.initialValue,
    this.searchBarHeight = 50,
    this.primaryColor,
    this.backgroundColor,
    this.dropdownBackgroundColor,
    this.padding,
    this.menuPadding,
    this.labelStyle,
    this.dropdownItemStyle,
    this.hint,
    this.multiSelectTag,
    this.initialIndex,
    this.prefixIcon,
    this.suffixIcon,
    this.hideSearch = false,
    this.enabled,
    this.showClearButton,
    this.menuMode,
    this.menuHeight,
    this.multiSelect = false,
    this.multiSelectValuesAsWidget,
    this.showLabelInMenu,
    this.decoration,
    this.labelAlign,
    this.dropdownHintText,
    this.displayItem,
    this.searchFn,
  });

  @override
  _CustomSearchableDropDownState<T> createState() => _CustomSearchableDropDownState<T>();
}

class _CustomSearchableDropDownState<T> extends State<CustomSearchableDropDown<T>> with TickerProviderStateMixin {
  final TextEditingController searchC = TextEditingController();
  List<String> menuData = [];
  List<String> mainDataListGroup = [];
  List<String> newDataList = [];
  List<String> selectedValues = [];
  late AnimationController _menuController;
  late DropDownSelectionStrategy<T> selectionStrategy;

  @override
  void initState() {
    super.initState();
    _menuController = AnimationController(duration: Duration(milliseconds: 300), vsync: this);
    // Build menuData using displayItem or default to toString.
    menuData = widget.items.map((item) => widget.displayItem != null ? widget.displayItem!(item) : item.toString()).toList();
    mainDataListGroup = List.from(menuData);
    newDataList = List.from(menuData);
    if (widget.multiSelect ?? false) {
      selectionStrategy = MultiSelectionStrategy<T>(widget);
    } else {
      selectionStrategy = SingleSelectionStrategy<T>(widget);
    }
    selectionStrategy.initialize();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Stack(
          children: [
            Container(
              decoration: widget.decoration,
              child: TextButton(
                style: TextButton.styleFrom(backgroundColor: widget.backgroundColor, foregroundColor: widget.primaryColor ?? Colors.black, tapTargetSize: MaterialTapTargetSize.shrinkWrap),
                child: Padding(
                  padding: widget.padding ?? EdgeInsets.all(5.0),
                  child: Row(
                    children: [
                      widget.prefixIcon ?? Container(),
                      Expanded(child: selectionStrategy.buildDisplay()),
                      Visibility(
                          visible: widget.showClearButton ?? false,
                          child: TextButton(
                              style: TextButton.styleFrom(foregroundColor: widget.primaryColor ?? Colors.black),
                              child: Icon(Icons.clear),
                              onPressed: () {
                                selectionStrategy.clearSelection(this);
                                widget.onChanged(null);
                                setState(() {});
                              })),
                      widget.suffixIcon ?? Icon(Icons.arrow_drop_down, color: widget.primaryColor ?? Colors.black),
                    ],
                  ),
                ),
                onPressed: () {
                  if (widget.enabled ?? true) {
                    newDataList = List.from(mainDataListGroup);
                    searchC.clear();
                    if (widget.menuMode ?? false) {
                      if (_menuController.value != 1) {
                        _menuController.forward();
                      } else {
                        _menuController.reverse();
                      }
                    } else {
                      showDialogueBox(context);
                    }
                  }
                  setState(() {});
                },
              ),
            ),
            SizeTransition(sizeFactor: _menuController, child: searchBox(setState)),
          ],
        ),
        Visibility(visible: widget.menuMode ?? false, child: _showMenuMode()),
      ],
    );
  }

  Widget _showMenuMode() => SizeTransition(sizeFactor: _menuController, child: mainScreen(setState));

  Future<void> showDialogueBox(context) async {
    await showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) {
        return Padding(padding: widget.menuPadding ?? EdgeInsets.all(15), child: StatefulBuilder(builder: (context, setState) => Material(color: Colors.transparent, child: mainScreen(setState))));
      },
    ).then((valueFromDialog) => setState(() {}));
  }

  Widget mainScreen(Function setState) {
    return Padding(
      padding: widget.menuPadding ?? EdgeInsets.all(0),
      child: Container(
        color: widget.dropdownBackgroundColor ?? Colors.white,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Visibility(
              visible: (widget.showLabelInMenu ?? false) && widget.label != null,
              child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(widget.label.toString(), style: widget.labelStyle?.copyWith(color: widget.primaryColor ?? Colors.blue) ?? TextStyle(color: widget.primaryColor ?? Colors.blue))),
            ),
            Visibility(
              visible: widget.multiSelect ?? false,
              child: Row(
                children: [
                  TextButton(
                    style: TextButton.styleFrom(foregroundColor: widget.primaryColor ?? Colors.black, tapTargetSize: MaterialTapTargetSize.shrinkWrap),
                    child: Text('Select All', style: widget.labelStyle?.copyWith(color: widget.primaryColor ?? Colors.blue) ?? TextStyle(color: widget.primaryColor ?? Colors.blue)),
                    onPressed: () => setState(() {
                      if (widget.multiSelect ?? false) {
                        (selectionStrategy as MultiSelectionStrategy<T>).selectedItems = List<String>.from(newDataList);
                      }
                    }),
                  ),
                  TextButton(
                    style: TextButton.styleFrom(foregroundColor: widget.primaryColor ?? Colors.black, tapTargetSize: MaterialTapTargetSize.shrinkWrap),
                    child: Text('Clear All', style: widget.labelStyle?.copyWith(color: widget.primaryColor ?? Colors.blue) ?? TextStyle(color: widget.primaryColor ?? Colors.blue)),
                    onPressed: () => setState(() => selectionStrategy.clearSelection(this)),
                  ),
                ],
              ),
            ),
            Visibility(visible: !(widget.menuMode ?? false), child: searchBox(setState)),
            (widget.menuMode ?? false) ? SizedBox(height: widget.menuHeight ?? 150, child: mainList(setState)) : Expanded(child: mainList(setState)),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  style: TextButton.styleFrom(foregroundColor: widget.primaryColor ?? Colors.black, tapTargetSize: MaterialTapTargetSize.shrinkWrap),
                  child: Text('Close', style: widget.labelStyle?.copyWith(color: widget.primaryColor ?? Colors.blue) ?? TextStyle(color: widget.primaryColor ?? Colors.blue)),
                  onPressed: () => setState(() {
                    if (widget.menuMode ?? false) {
                      _menuController.reverse();
                    } else {
                      Navigator.pop(context);
                    }
                  }),
                ),
                Visibility(
                  visible: widget.multiSelect ?? false,
                  child: TextButton(
                    style: TextButton.styleFrom(foregroundColor: widget.primaryColor ?? Colors.black, tapTargetSize: MaterialTapTargetSize.shrinkWrap),
                    child: Text('Done', style: widget.labelStyle?.copyWith(color: widget.primaryColor ?? Colors.blue) ?? TextStyle(color: widget.primaryColor ?? Colors.blue)),
                    onPressed: () => setState(() => selectionStrategy.onDone(this)),
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget searchBox(Function setState) {
    return Visibility(
      visible: widget.hideSearch == null ? true : !widget.hideSearch!,
      child: SizedBox(
        height: widget.searchBarHeight,
        child: Padding(
          padding: EdgeInsets.all((widget.menuMode ?? false) ? 0.0 : 8.0),
          child: TextField(
            controller: searchC,
            decoration: InputDecoration(
              fillColor: Colors.white,
              filled: true,
              focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(5)), borderSide: BorderSide(color: widget.primaryColor ?? Colors.grey, width: 2)),
              enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(5)), borderSide: BorderSide(color: widget.primaryColor ?? Colors.grey, width: 2)),
              disabledBorder: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(5)), borderSide: BorderSide(color: widget.primaryColor ?? Colors.grey, width: 2)),
              errorBorder: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(5)), borderSide: BorderSide(color: widget.primaryColor ?? Colors.grey, width: 2)),
              focusedErrorBorder: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(5)), borderSide: BorderSide(color: widget.primaryColor ?? Colors.grey, width: 2)),
              suffixIcon: Icon(Icons.search, color: widget.primaryColor ?? Colors.black),
              contentPadding: EdgeInsets.all(8),
              hintText: widget.dropdownHintText ?? 'Search Here...',
              isDense: true,
            ),
            onChanged: (v) => setState(() => onItemChanged(v)),
          ),
        ),
      ),
    );
  }

  Widget mainList(Function setState) {
    return Scrollbar(
      child: Container(
        color: widget.dropdownBackgroundColor ?? Colors.white,
        child: ListView.builder(
          padding: EdgeInsets.zero,
          itemCount: newDataList.length,
          itemBuilder: (BuildContext context, int index) {
            return TextButton(
              style: TextButton.styleFrom(foregroundColor: widget.primaryColor ?? Colors.black, padding: EdgeInsets.all(8), tapTargetSize: MaterialTapTargetSize.shrinkWrap),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
                child: Row(
                  children: [
                    Visibility(
                      visible: widget.multiSelect ?? false,
                      child: SizedBox(
                        width: 24,
                        height: 24,
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(0, 0, 8, 0),
                          child: Checkbox(
                            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            value: widget.multiSelect ?? false ? selectionStrategy.isSelected(newDataList[index]) : false,
                            activeColor: Colors.green,
                            onChanged: (newValue) => setState(() => selectionStrategy.onItemSelected(index, newDataList[index], this)),
                          ),
                        ),
                      ),
                    ),
                    Expanded(child: Text(newDataList[index], style: widget.dropdownItemStyle ?? TextStyle(color: Colors.grey[700]))),
                  ],
                ),
              ),
              onPressed: () => setState(() => selectionStrategy.onItemSelected(index, newDataList[index], this)),
            );
          },
        ),
      ),
    );
  }

  void onItemChanged(String value) => setState(() {
        if (widget.searchFn != null) {
          newDataList = mainDataListGroup.where((str) {
            int index = mainDataListGroup.indexOf(str);
            T item = widget.items[index];
            return widget.searchFn!(item, value);
          }).toList();
        } else {
          newDataList = mainDataListGroup.where((str) => str.toLowerCase().contains(value.toLowerCase())).toList();
        }
      });
}

///
/// ----- Strategy Pattern for Selection Logic -----
///

abstract class DropDownSelectionStrategy<T> {
  void initialize();
  Widget buildDisplay();
  void onItemSelected(int index, String menuItem, _CustomSearchableDropDownState<T> state);
  void clearSelection(_CustomSearchableDropDownState<T> state);
  bool isSelected(String menuItem);
  void onDone(_CustomSearchableDropDownState<T> state);
}

class SingleSelectionStrategy<T> implements DropDownSelectionStrategy<T> {
  final CustomSearchableDropDown<T> widget;
  String selectedLabel = '';

  SingleSelectionStrategy(this.widget);

  @override
  void initialize() {
    if (widget.initialIndex != null && widget.items.isNotEmpty) {
      selectedLabel = widget.displayItem != null ? widget.displayItem!(widget.items[widget.initialIndex!]) : widget.items[widget.initialIndex!].toString();
    }
    if (selectedLabel.isEmpty && widget.initialValue != null && widget.initialValue!.isNotEmpty && widget.items.isNotEmpty) {
      T initial = widget.initialValue![0];
      selectedLabel = widget.displayItem != null ? widget.displayItem!(initial) : initial.toString();
    }
  }

  @override
  Widget buildDisplay() {
    return Text(
      selectedLabel.isEmpty ? (widget.label ?? 'Select Value') : selectedLabel,
      textAlign: widget.labelAlign ?? TextAlign.start,
      style: widget.labelStyle?.copyWith(color: selectedLabel.isEmpty ? Colors.grey[600] : null) ?? TextStyle(color: selectedLabel.isEmpty ? Colors.grey[600] : Colors.grey[800]),
    );
  }

  @override
  void onItemSelected(int index, String menuItem, _CustomSearchableDropDownState<T> state) {
    selectedLabel = menuItem;
    widget.onChanged(widget.items[index]);
    if (widget.menuMode ?? false) {
      state._menuController.reverse();
    } else {
      Navigator.pop(state.context);
    }
    state.setState(() {});
  }

  @override
  void clearSelection(_CustomSearchableDropDownState<T> state) => selectedLabel = '';

  @override
  bool isSelected(String menuItem) => selectedLabel == menuItem;

  @override
  void onDone(_CustomSearchableDropDownState<T> state) {
    // Not used for single-select.
  }
}

class MultiSelectionStrategy<T> implements DropDownSelectionStrategy<T> {
  final CustomSearchableDropDown<T> widget;
  List<String> selectedItems = [];

  MultiSelectionStrategy(this.widget);

  @override
  void initialize() {
    if (widget.initialValue != null && widget.items.isNotEmpty) {
      selectedItems.clear();
      for (int i = 0; i < widget.items.length; i++) {
        for (var initial in widget.initialValue!) {
          if (initial == widget.items[i]) {
            String display = widget.displayItem != null ? widget.displayItem!(widget.items[i]) : widget.items[i].toString();
            selectedItems.add(display);
          }
        }
      }
    }
  }

  @override
  Widget buildDisplay() {
    if (selectedItems.isNotEmpty) {
      if (widget.multiSelectValuesAsWidget == true) {
        return Wrap(
          children: List.generate(selectedItems.length, (index) {
            return Padding(
              padding: const EdgeInsets.fromLTRB(5, 3, 5, 3),
              child: Container(
                  decoration: BoxDecoration(color: widget.primaryColor ?? Colors.green, borderRadius: BorderRadius.all(Radius.circular(5.0))),
                  child: Padding(padding: const EdgeInsets.fromLTRB(5, 2, 5, 2), child: Text(selectedItems[index], style: widget.labelStyle ?? TextStyle(color: Colors.white, fontSize: 12)))),
            );
          }),
        );
      } else {
        return Text(
          selectedItems.length == 1
              ? (widget.multiSelectTag == null ? '${selectedItems.length} value selected' : '${selectedItems.length} ${widget.multiSelectTag!} selected')
              : (widget.multiSelectTag == null ? '${selectedItems.length} values selected' : '${selectedItems.length} ${widget.multiSelectTag!} selected'),
          style: widget.labelStyle ?? TextStyle(color: Colors.grey),
        );
      }
    } else {
      return Text(widget.label ?? 'Select Value', textAlign: widget.labelAlign ?? TextAlign.start, style: widget.labelStyle?.copyWith(color: Colors.grey[600]) ?? TextStyle(color: Colors.grey[600]));
    }
  }

  @override
  void onItemSelected(int index, String menuItem, _CustomSearchableDropDownState<T> state) {
    if (selectedItems.contains(menuItem)) {
      selectedItems.remove(menuItem);
    } else {
      selectedItems.add(menuItem);
    }
    state.setState(() {});
  }

  @override
  void clearSelection(_CustomSearchableDropDownState<T> state) => selectedItems.clear();

  @override
  bool isSelected(String menuItem) => selectedItems.contains(menuItem);

  @override
  void onDone(_CustomSearchableDropDownState<T> state) {
    var sendList = [];
    for (int i = 0; i < state.menuData.length; i++) {
      if (selectedItems.contains(state.menuData[i])) {
        sendList.add(widget.items[i]);
      }
    }
    widget.onChanged(jsonEncode(sendList));
    if (widget.menuMode ?? false) {
      state._menuController.reverse();
    } else {
      Navigator.pop(state.context);
    }
    state.setState(() {});
  }
}
