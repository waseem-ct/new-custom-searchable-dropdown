library custom_searchable_dropdown;

import 'dart:convert';
import 'dart:developer';

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
  final double? borderRadius;
  final Color? primaryColor;
  final Color? backgroundColor;
  final Color? dropdownBackgroundColor;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? menuPadding;
  final EdgeInsetsGeometry? menuMargin;
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
    this.menuMargin,
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
    this.borderRadius,
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
  final double _radius = 8.0.toDouble();
  final _primaryColor = Colors.black38;
  OutlineInputBorder _outlineBorder() =>
      OutlineInputBorder(borderRadius: BorderRadius.circular(widget.borderRadius ?? _radius), borderSide: BorderSide(color: widget.primaryColor ?? _primaryColor, width: 2));
  @override
  void initState() {
    super.initState();
    _menuController = AnimationController(duration: Duration(milliseconds: 300), vsync: this);
    try {
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
    } catch (e, stackTrace) {
      _handleError(e, stackTrace, 'Error during initialization');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Stack(
          children: [
            Container(
              padding: widget.padding ?? EdgeInsets.symmetric(vertical: 3.0, horizontal: 4),
              decoration: widget.decoration ?? BoxDecoration(borderRadius: BorderRadius.circular(_radius), border: Border.all(color: _primaryColor)),
              child: TextButton(
                style: TextButton.styleFrom(
                    padding: EdgeInsets.zero, backgroundColor: widget.backgroundColor, foregroundColor: widget.primaryColor ?? Colors.black, tapTargetSize: MaterialTapTargetSize.shrinkWrap),
                child: Row(
                  children: [
                    widget.prefixIcon ?? Container(),
                    Expanded(child: selectionStrategy.buildDisplay()),
                    Visibility(
                        visible: widget.showClearButton ?? false,
                        child: InkWell(
                            child: Icon(Icons.clear, color: _primaryColor.withValues(alpha: 0.5)),
                            onTap: () {
                              try {
                                selectionStrategy.clearSelection(this);
                                widget.onChanged(null);
                                setState(() {});
                              } catch (e, stackTrace) {
                                _handleError(e, stackTrace, 'Error clearing selection');
                              }
                            })),
                    widget.suffixIcon ?? Icon(Icons.arrow_drop_down, color: widget.primaryColor ?? _primaryColor.withValues(alpha: 0.7)),
                  ],
                ),
                onPressed: () {
                  try {
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
                  } catch (e, stackTrace) {
                    _handleError(e, stackTrace, 'Error showing menu or dialog');
                  }
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
    try {
      await showDialog(
        context: context,
        barrierDismissible: true,
        builder: (context) => StatefulBuilder(builder: (context, setState) => Material(color: Colors.transparent, child: mainScreen(setState))),
      ).then((valueFromDialog) => setState(() {}));
    } catch (e, stackTrace) {
      _handleError(e, stackTrace, 'Error showing dialog box');
    }
  }

  Widget mainScreen(Function setState) {
    return Container(
      padding: widget.menuPadding ?? EdgeInsets.all(0),
      margin: widget.menuMargin ?? EdgeInsets.all(widget.menuMode == true ? 0 : 15),
      decoration: BoxDecoration(color: widget.dropdownBackgroundColor ?? Colors.white, borderRadius: BorderRadius.circular(15)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Visibility(
            visible: (widget.showLabelInMenu ?? false) && widget.label != null,
            child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(widget.label.toString(), style: widget.labelStyle?.copyWith(color: widget.primaryColor ?? _primaryColor) ?? TextStyle(color: widget.primaryColor ?? _primaryColor))),
          ),
          Visibility(
            visible: widget.multiSelect ?? false,
            child: Row(
              children: [
                TextButton(
                  style: TextButton.styleFrom(foregroundColor: widget.primaryColor ?? Colors.black, tapTargetSize: MaterialTapTargetSize.shrinkWrap),
                  child: Text('Select All', style: widget.labelStyle?.copyWith(color: widget.primaryColor ?? _primaryColor) ?? TextStyle(color: widget.primaryColor ?? _primaryColor)),
                  onPressed: () => setState(() {
                    if (widget.multiSelect ?? false) {
                      (selectionStrategy as MultiSelectionStrategy<T>).selectedItems = List<String>.from(newDataList);
                    }
                  }),
                ),
                TextButton(
                  style: TextButton.styleFrom(foregroundColor: widget.primaryColor ?? Colors.black, tapTargetSize: MaterialTapTargetSize.shrinkWrap),
                  child: Text('Clear All', style: widget.labelStyle?.copyWith(color: widget.primaryColor ?? _primaryColor) ?? TextStyle(color: widget.primaryColor ?? _primaryColor)),
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
                child: Text('Close', style: widget.labelStyle?.copyWith(color: widget.primaryColor ?? _primaryColor) ?? TextStyle(color: widget.primaryColor ?? _primaryColor)),
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
                  child: Text('Done', style: widget.labelStyle?.copyWith(color: widget.primaryColor ?? _primaryColor) ?? TextStyle(color: widget.primaryColor ?? _primaryColor)),
                  onPressed: () => setState(() => selectionStrategy.onDone(this)),
                ),
              )
            ],
          )
        ],
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
              focusedBorder: _outlineBorder(),
              enabledBorder: _outlineBorder(),
              disabledBorder: _outlineBorder(),
              errorBorder: _outlineBorder(),
              focusedErrorBorder: _outlineBorder(),
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
                    Expanded(child: Text(newDataList[index], style: widget.dropdownItemStyle ?? TextStyle(color: Colors.grey, fontWeight: FontWeight.w500))),
                  ],
                ),
              ),
              onPressed: () {
                try {
                  selectionStrategy.onItemSelected(index, newDataList[index], this);
                  setState(() {});
                } catch (e, stackTrace) {
                  _handleError(e, stackTrace, 'Error selecting item');
                }
              },
            );
          },
        ),
      ),
    );
  }

  void onItemChanged(String value) => setState(() {
        try {
          if (widget.searchFn != null) {
            newDataList = mainDataListGroup.where((str) {
              int index = mainDataListGroup.indexOf(str);
              T item = widget.items[index];
              return widget.searchFn!(item, value);
            }).toList();
          } else {
            newDataList = mainDataListGroup.where((str) => str.toLowerCase().contains(value.toLowerCase())).toList();
          }
        } catch (e, stackTrace) {
          _handleError(e, stackTrace, 'Error filtering items');
        }
      });

  void _handleError(Object e, StackTrace stackTrace, String message) {
    log('$message: $e', stackTrace: stackTrace);
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('$message. Please try again later'), backgroundColor: Theme.of(context).colorScheme.error));
  }
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
    try {
      if (widget.initialIndex != null && widget.items.isNotEmpty) {
        selectedLabel = widget.displayItem != null ? widget.displayItem!(widget.items[widget.initialIndex!]) : widget.items[widget.initialIndex!].toString();
      }
      if (selectedLabel.isEmpty && widget.initialValue != null && widget.initialValue!.isNotEmpty && widget.items.isNotEmpty) {
        T initial = widget.initialValue![0];
        selectedLabel = widget.displayItem != null ? widget.displayItem!(initial) : initial.toString();
      }
    } catch (e, stackTrace) {
      _handleError(e, stackTrace, 'Error during initialization');
    }
  }

  @override
  Widget buildDisplay() {
    try {
      return Text(
        selectedLabel.isEmpty ? (widget.label ?? 'Select Value') : selectedLabel,
        textAlign: widget.labelAlign ?? TextAlign.start,
        style: widget.labelStyle?.copyWith(color: selectedLabel.isEmpty ? Colors.grey[600] : null) ?? TextStyle(color: selectedLabel.isEmpty ? Colors.grey[600] : Colors.grey[800]),
      );
    } catch (e, stackTrace) {
      _handleError(e, stackTrace, 'Error during widget display');
      return SizedBox.shrink();
    }
  }

  @override
  void onItemSelected(int index, String menuItem, _CustomSearchableDropDownState<T> state) {
    try {
      selectedLabel = menuItem;
      widget.onChanged(widget.items[index]);
      if (widget.menuMode ?? false) {
        state._menuController.reverse();
      } else {
        Navigator.pop(state.context);
      }
      state.setState(() {});
    } catch (e, stackTrace) {
      _handleError(e, stackTrace, 'Error when selecting an item');
    }
  }

  @override
  void clearSelection(_CustomSearchableDropDownState<T> state) {
    try {
      selectedLabel = '';
    } catch (e, stackTrace) {
      _handleError(e, stackTrace, 'Error clearing selection');
    }
  }

  @override
  bool isSelected(String menuItem) {
    try {
      return selectedLabel == menuItem;
    } catch (e, stackTrace) {
      _handleError(e, stackTrace, 'Error checking if item is selected');
      return false;
    }
  }

  @override
  void onDone(_CustomSearchableDropDownState<T> state) {
    /// Not used for single-select.
  }
  void _handleError(e, StackTrace stackTrace, String context) {
    log('$context: $e');
    log(stackTrace.toString());
  }
}

class MultiSelectionStrategy<T> implements DropDownSelectionStrategy<T> {
  final CustomSearchableDropDown<T> widget;
  List<String> selectedItems = [];

  MultiSelectionStrategy(this.widget);

  @override
  void initialize() {
    try {
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
    } catch (e, stackTrace) {
      ErrorHandler._handleError(e, stackTrace, 'Error during initialization');
    }
  }

  @override
  Widget buildDisplay() {
    try {
      if (selectedItems.isNotEmpty) {
        if (widget.multiSelectValuesAsWidget == true) {
          return Wrap(
            spacing: 4,
            runSpacing: 0,
            children: List.generate(selectedItems.length, (index) {
              return Chip(
                visualDensity: VisualDensity.compact,
                labelPadding: const EdgeInsets.symmetric(horizontal: 4, vertical: 0),
                padding: const EdgeInsets.symmetric(horizontal: 2),
                backgroundColor: widget.primaryColor ?? Colors.green,
                shape: ContinuousRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(widget.borderRadius ?? 8))),
                label: Text(selectedItems[index], style: widget.labelStyle ?? TextStyle(color: Colors.white, fontSize: 12)),
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
    } catch (e, stackTrace) {
      ErrorHandler._handleError(e, stackTrace, 'Error during widget display');
      return SizedBox.shrink();
    }
  }

  @override
  void onItemSelected(int index, String menuItem, _CustomSearchableDropDownState<T> state) {
    try {
      if (selectedItems.contains(menuItem)) {
        selectedItems.remove(menuItem);
      } else {
        selectedItems.add(menuItem);
      }
      state.setState(() {});
    } catch (e, stackTrace) {
      ErrorHandler._handleError(e, stackTrace, 'Error when selecting an item');
    }
  }

  @override
  void clearSelection(_CustomSearchableDropDownState<T> state) {
    try {
      selectedItems.clear();
    } catch (e, stackTrace) {
      ErrorHandler._handleError(e, stackTrace, 'Error clearing selection');
    }
  }

  @override
  bool isSelected(String menuItem) {
    try {
      return selectedItems.contains(menuItem);
    } catch (e, stackTrace) {
      ErrorHandler._handleError(e, stackTrace, 'Error checking if item is selected');
      return false;
    }
  }

  @override
  void onDone(_CustomSearchableDropDownState<T> state) {
    try {
      var sendList = [];
      for (int i = 0; i < state.menuData.length; i++) {
        if (selectedItems.contains(state.menuData[i])) {
          sendList.add(widget.items[i]);
        }
      }

      /// Attempt to encode to JSON
      widget.onChanged(jsonEncode(sendList));

      if (widget.menuMode ?? false) {
        state._menuController.reverse();
      } else {
        Navigator.pop(state.context);
      }
      state.setState(() {});
    } catch (e, stackTrace) {
      String errorMessage;
      if (e is JsonUnsupportedObjectError) {
        /// Prepare error message
        errorMessage = 'An error occurred while processing your selection. '
            'Unsupported object: ${e.unsupportedObject}\n'
            'Cause: ${e.cause}\n'
            'Partial result: ${e.partialResult ?? "None"}';

        /// Log error details
        log('JsonUnsupportedObjectError');
        log(e.toString());
        log(stackTrace.toString());

        /// Show detailed error message to user
        ErrorHandler._showErrorSnackBar(state.context, errorMessage);
      } else {
        /// Prepare generic error message
        errorMessage = 'An unexpected error occurred: ${e.toString()}';

        /// Log generic error
        log('Unexpected error');
        log(e.toString());
        log(stackTrace.toString());

        /// Handle other types of errors
        ErrorHandler._showErrorSnackBar(state.context, errorMessage);
      }
    }
  }
}

class ErrorHandler {
  /// Error handling function
  static void _handleError(e, StackTrace stackTrace, String context) {
    log('$context: $e');
    log(stackTrace.toString());
  }

  /// Show error snack bar function
  static void _showErrorSnackBar(BuildContext context, String message) {
    final snackBar = SnackBar(content: Text(message), backgroundColor: Colors.red);
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
