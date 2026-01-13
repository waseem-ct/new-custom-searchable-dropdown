library custom_searchable_dropdown;

import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';

class CustomSearchableDropDown extends StatefulWidget {
  final List items;
  final List? initialValue;
  final double? searchBarHeight;
  final double? minLeadingWidth;
  final Color? primaryColor;
  final Color? backgroundColor;
  final Color? dropdownBackgroundColor;
  final EdgeInsets? padding;
  final EdgeInsets? margin;
  final EdgeInsets? menuPadding;
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
  final String? itemOnDialogueBox;
  final Decoration? decoration;
  final List dropDownMenuItems;
  final TextAlign? labelAlign;
  final ValueChanged onChanged;

  // New properties for empty state
  final String? emptySearchText;
  final Widget? emptySearchWidget;

  const CustomSearchableDropDown({
    required this.items,
    required this.label,
    required this.onChanged,
    this.hint = '',
    this.initialValue,
    this.labelAlign,
    this.searchBarHeight,
    this.primaryColor,
    this.padding,
    this.margin,
    this.menuPadding,
    this.labelStyle,
    this.enabled,
    this.showClearButton,
    this.itemOnDialogueBox,
    required this.dropDownMenuItems,
    this.prefixIcon,
    this.suffixIcon,
    this.menuMode,
    this.menuHeight,
    this.initialIndex,
    this.multiSelect,
    this.multiSelectTag,
    this.multiSelectValuesAsWidget,
    this.hideSearch,
    this.decoration,
    this.showLabelInMenu,
    this.dropdownItemStyle,
    this.backgroundColor,
    this.dropdownBackgroundColor,
    this.dropdownHintText,
    this.emptySearchText,
    this.emptySearchWidget,
    this.minLeadingWidth,
  });

  @override
  _CustomSearchableDropDownState createState() => _CustomSearchableDropDownState();
}

class _CustomSearchableDropDownState extends State<CustomSearchableDropDown> with WidgetsBindingObserver, TickerProviderStateMixin {
  String onSelectLabel = '';
  List menuData = [];
  List newDataList = [];
  List selectedValues = [];
  List mainDataListGroup = [];
  late AnimationController _menuController;
  final searchC = TextEditingController();

  @override
  void initState() {
    super.initState();
    _menuController = AnimationController(duration: const Duration(milliseconds: 300), vsync: this);
    WidgetsBinding.instance.addPostFrameCallback((_) => _initializeSelection());
  }

  @override
  void didUpdateWidget(covariant CustomSearchableDropDown oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.items != widget.items || oldWidget.initialValue != widget.initialValue) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _initializeSelection());
    }
  }

  void _initializeSelection() {
    if (widget.items.isEmpty || widget.dropDownMenuItems.isEmpty) {
      onSelectLabel = '';
      selectedValues.clear();
      return;
    }
    if (widget.multiSelect ?? false) {
      selectedValues.clear();
      if (widget.initialValue != null && widget.initialValue!.isNotEmpty) {
        for (int i = 0; i < widget.items.length; i++) {
          for (int j = 0; j < widget.initialValue!.length; j++) {
            final param = widget.initialValue![j]['parameter'];
            final val = widget.initialValue![j]['value'];
            if (param != null && val != null) {
              if (val == widget.items[i][param]) {
                selectedValues.add('${widget.dropDownMenuItems[i]}-_-$i');
              }
            }
          }
        }
      }
      if (mounted) setState(() {});
      return;
    }
    if (onSelectLabel.isEmpty) {
      if (widget.initialValue != null && widget.initialValue!.isNotEmpty) {
        final param = widget.initialValue![0]['parameter'];
        final val = widget.initialValue![0]['value'];
        if (param != null && val != null) {
          for (int i = 0; i < widget.items.length; i++) {
            if (val == widget.items[i][param]) {
              onSelectLabel = widget.dropDownMenuItems[i].toString();
              break;
            }
          }
        }
      }
      if (mounted) setState(() {});
    }
  }
  @override
  void dispose() {
    _menuController.dispose(); // ✅ sabse pehle
    super.dispose();       // ✅ last me
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: widget.margin ?? const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Stack(
            children: [
              Material(
                shape: ContinuousRectangleBorder(borderRadius: BorderRadius.circular(15), side: BorderSide(color: widget.primaryColor ?? Colors.grey, width: 1)),
                color: widget.backgroundColor ?? Colors.white,
                child: ListTile(
                  dense: true,
                  visualDensity: VisualDensity.compact,
                  shape: ContinuousRectangleBorder(borderRadius: BorderRadius.circular(15), side: BorderSide(color: widget.primaryColor ?? Colors.grey, width: 1)),
                  contentPadding: widget.padding ?? const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                  tileColor: widget.backgroundColor ?? Colors.white,
                  leading: widget.prefixIcon ?? const SizedBox(),
                  minLeadingWidth: widget.minLeadingWidth ?? 0,
                  title: (() {
                    if (widget.multiSelect == true && selectedValues.isNotEmpty) {
                      if (widget.multiSelectValuesAsWidget == true) {
                        return Wrap(
                          spacing: 2,
                          children: selectedValues.map<Widget>((item) {
                            final label = item.split('-_-')[0];
                            return Chip(
                                padding: EdgeInsets.zero,
                                visualDensity: VisualDensity.compact,
                                backgroundColor: widget.primaryColor ?? Colors.green,
                                label: Text(label, style: widget.labelStyle?.copyWith(color: Colors.white) ?? const TextStyle(color: Colors.white, fontSize: 12)));
                          }).toList(),
                        );
                      } else {
                        final count = selectedValues.length;
                        final text = count == 1
                            ? (widget.multiSelectTag == null ? '$count value selected' : '$count ${widget.multiSelectTag} selected')
                            : (widget.multiSelectTag == null ? '$count values selected' : '$count ${widget.multiSelectTag} selected');
                        return Text(text, style: widget.labelStyle ?? TextStyle(color: Colors.grey[700]));
                      }
                    } else {
                      final displayLabel = (onSelectLabel.isEmpty) ? (widget.label ?? 'Select Value') : onSelectLabel;
                      final isPlaceholder = onSelectLabel.isEmpty;
                      return Text(displayLabel, maxLines: 1, style: widget.labelStyle ?? TextStyle(fontSize: 12, color: isPlaceholder ? Colors.grey[600] : Colors.black87));
                    }
                  })(),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (widget.showClearButton == true && selectedValues.isNotEmpty)
                        IconButton(
                          padding: EdgeInsets.zero,
                          icon: const Icon(Icons.clear),
                          color: widget.primaryColor ?? Colors.black,
                          onPressed: () {
                            widget.onChanged(null);
                            onSelectLabel = '';
                            selectedValues.clear();
                            setState(() {});
                          },
                        ),
                      widget.suffixIcon ?? Icon(Icons.arrow_drop_down, color: widget.primaryColor ?? Colors.black),
                    ],
                  ),
                  enabled: widget.enabled ?? true,
                  onTap: () {
                    if (widget.enabled == true || widget.enabled == null) {
                      menuData.clear();
                      if (widget.items.isNotEmpty) {
                        for (int i = 0; i < widget.dropDownMenuItems.length; i++) {
                          menuData.add('${widget.dropDownMenuItems[i]}-_-$i');
                        }
                        mainDataListGroup = menuData;
                        newDataList = mainDataListGroup;
                        searchC.clear();
                        if (widget.menuMode == true) {
                          if (_menuController.status != AnimationStatus.completed) {
                            _menuController.forward();
                          } else {
                            _menuController.reverse();
                          }
                        } else {
                          showDialogueBox(context);
                        }
                      }
                      setState(() {});
                    }
                  },
                ),
              ),
              SizeTransition(sizeFactor: _menuController, child: searchBox(setState))
            ],
          ),
          Visibility(visible: (widget.menuMode ?? false), child: _showMenuMode()),
        ],
      ),
    );
  }

  Widget _showMenuMode() => SizeTransition(sizeFactor: _menuController, child: mainScreen(setState));

  Future<void> showDialogueBox(context) async {
    await showDialog(
            context: context,
            barrierDismissible: true,
            builder: (dialogContext) => Dialog(insetPadding: const EdgeInsets.all(18), child: StatefulBuilder(builder: (context, localSetState) => mainScreen(localSetState))))
        .then((valueFromDialog) {});
  }

  // Updated mainScreen with proper height handling
  _mainScreenOld(setState) {
    return Container(
      height: widget.menuHeight,
      width: double.infinity,
      padding: widget.menuPadding ?? (widget.menuMode ?? false ? EdgeInsets.zero : const EdgeInsets.all(10)),
      decoration: widget.decoration ?? BoxDecoration(color: widget.dropdownBackgroundColor ?? Colors.white, borderRadius: BorderRadius.circular(10)),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.min, // Key: minimize column size
          children: [
            Visibility(
                visible: ((widget.showLabelInMenu ?? false) && widget.label != null),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    widget.label.toString(),
                    style: widget.labelStyle != null ? widget.labelStyle!.copyWith(color: widget.primaryColor ?? Colors.blue) : TextStyle(color: widget.primaryColor ?? Colors.blue),
                  ),
                )),
            Visibility(
                visible: widget.multiSelect ?? false,
                child: Row(
                  children: [
                    TextButton(
                      style: TextButton.styleFrom(foregroundColor: widget.primaryColor ?? Colors.black, tapTargetSize: MaterialTapTargetSize.shrinkWrap),
                      child: Text(
                        'Select All',
                        style: widget.labelStyle != null ? widget.labelStyle!.copyWith(color: widget.primaryColor ?? Colors.blue) : TextStyle(color: widget.primaryColor ?? Colors.blue),
                      ),
                      onPressed: () {
                        selectedValues.clear();
                        for (int i = 0; i < newDataList.length; i++) {
                          selectedValues.add(newDataList[i]);
                        }
                        setState(() {});
                      },
                    ),
                    TextButton(
                      style: TextButton.styleFrom(foregroundColor: widget.primaryColor ?? Colors.black, tapTargetSize: MaterialTapTargetSize.shrinkWrap),
                      child: Text(
                        'Clear All',
                        style: widget.labelStyle != null ? widget.labelStyle!.copyWith(color: widget.primaryColor ?? Colors.blue) : TextStyle(color: widget.primaryColor ?? Colors.blue),
                      ),
                      onPressed: () => setState(() => selectedValues.clear()),
                    ),
                  ],
                )),
            Visibility(visible: !(widget.menuMode ?? false), child: searchBox(setState)),
            (widget.menuMode ?? false) ? SizedBox(height: widget.menuHeight ?? 300, child: mainList(setState)) : Expanded(child: mainList(setState)),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  style: TextButton.styleFrom(foregroundColor: widget.primaryColor ?? Colors.black, tapTargetSize: MaterialTapTargetSize.shrinkWrap),
                  child: Text('Close',
                      style: widget.labelStyle != null ? widget.labelStyle!.copyWith(color: widget.primaryColor ?? Colors.blue) : TextStyle(color: widget.primaryColor ?? Colors.blue)),
                  onPressed: () {
                    if (widget.menuMode ?? false) {
                      _menuController.reverse();
                    } else {
                      Navigator.pop(context);
                    }
                    setState(() {});
                  },
                ),
                Visibility(
                  visible: (widget.multiSelect ?? false),
                  child: TextButton(
                    style: TextButton.styleFrom(foregroundColor: widget.primaryColor ?? Colors.black, tapTargetSize: MaterialTapTargetSize.shrinkWrap),
                    child: Text(
                      'Done',
                      style: widget.labelStyle != null ? widget.labelStyle!.copyWith(color: widget.primaryColor ?? Colors.blue) : TextStyle(color: widget.primaryColor ?? Colors.blue),
                    ),
                    onPressed: () {
                      var sendList = [];
                      for (int i = 0; i < menuData.length; i++) {
                        if (selectedValues.contains(menuData[i])) {
                          sendList.add(widget.items[i]);
                        }
                      }
                      widget.onChanged(jsonEncode(sendList));
                      if (widget.menuMode ?? false) {
                        _menuController.reverse();
                      } else {
                        Navigator.pop(context);
                      }
                      setState(() {});
                    },
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget mainScreen(StateSetter setState) {
    final isMulti = widget.multiSelect ?? false;

    return Container(
      width: double.infinity,
      padding: widget.menuPadding ?? ((widget.menuMode ?? false) ? EdgeInsets.zero : const EdgeInsets.all(10)),
      decoration: widget.decoration ??
          BoxDecoration(
            color: widget.dropdownBackgroundColor ?? Colors.white,
            borderRadius: BorderRadius.circular(10),
          ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildLabel(),
          if (isMulti) _buildMultiActions(setState),
          if (!(widget.menuMode ?? false)) searchBox(setState),
          SizedBox(height: _calculatedHeight(), child: mainList(setState)),
          if (isMulti) _buildFooterButtons(),
        ],
      ),
    );
  }

  Widget _buildLabel() {
    if (!(widget.showLabelInMenu ?? false) || widget.label == null) {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: const EdgeInsets.all(8),
      child: Text(widget.label!, style: widget.labelStyle?.copyWith(color: widget.primaryColor ?? Colors.blue) ?? TextStyle(color: widget.primaryColor ?? Colors.blue)),
    );
  }

  Widget _buildMultiActions(StateSetter setState) {
    return Row(
      children: [
        TextButton(
          onPressed: () => setState(() => selectedValues
            ..clear()
            ..addAll(newDataList)),
          child: const Text('Select All'),
        ),
        TextButton(onPressed: () => setState(selectedValues.clear), child: const Text('Clear All')),
      ],
    );
  }

  Widget _buildFooterButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        TextButton(onPressed: _closeMenu, child: const Text('Close')),
        TextButton(onPressed: _submitMultiSelect, child: const Text('Done')),
      ],
    );
  }

  void _closeMenu() => WidgetsBinding.instance.addPostFrameCallback((_) => widget.menuMode == true ? _menuController.reverse() : Navigator.pop(context));

  void _submitMultiSelect() {
    final sendList = <dynamic>[];
    for (int i = 0; i < menuData.length; i++) {
      if (selectedValues.contains(menuData[i])) {
        sendList.add(widget.items[i]);
      }
    }
    widget.onChanged(jsonEncode(sendList));
    _closeMenu();
  }

  double _calculatedHeight() {
    const itemHeight = 48.0;
    final maxHeight = widget.menuHeight ?? 300;
    final listHeight = newDataList.length * itemHeight;
    return listHeight > maxHeight ? maxHeight : listHeight;
  }

  // Updated searchBox with clear button
  searchBox(setState) {
    return Visibility(
      visible: widget.hideSearch == null ? true : !widget.hideSearch!,
      child: SizedBox(
        height: widget.searchBarHeight,
        child: TextField(
          controller: searchC,
          decoration: InputDecoration(
            fillColor: Colors.white,
            filled: true,
            focusedBorder: inputBorder(),
            enabledBorder: inputBorder(),
            disabledBorder: inputBorder(),
            errorBorder: inputBorder(),
            focusedErrorBorder: inputBorder(),
            prefixIcon: Icon(Icons.search, color: widget.primaryColor ?? Colors.black),
            // Added clear button that appears when there's text
            suffixIcon: searchC.text.isNotEmpty
                ? IconButton(
                    icon: Icon(Icons.clear, color: widget.primaryColor ?? Colors.black),
                    onPressed: () {
                      searchC.clear();
                      onItemChanged('');
                      setState(() {});
                    },
                  )
                : null,
            hintText: widget.dropdownHintText ?? 'Search Here...',
            isDense: true,
          ),
          onChanged: (v) {
            onItemChanged(v);
            setState(() {});
          },
        ),
      ),
    );
  }

  InputBorder inputBorder() => OutlineInputBorder(borderRadius: const BorderRadius.all(Radius.circular(5)), borderSide: BorderSide(color: widget.primaryColor ?? Colors.grey));

  // Updated mainList method
  Widget mainList(setState) {
    if (newDataList.isEmpty) {
      return _buildEmptyState(setState);
    } else {
      return Scrollbar(child: ListView.builder(shrinkWrap: true, itemCount: newDataList.length, itemBuilder: (context, int index) => _buildDropdownItem(index)));
    }
  }


  Widget _buildDropdownItem(int index) {
    final item = newDataList[index];
    final isSelected = selectedValues.contains(item);
    final label = item.split('-_-')[0];
    return ListTile(
      dense: true,
      visualDensity: VisualDensity.compact,
      //contentPadding: const EdgeInsets.only(left: 5),
      onTap: () {
        if (widget.multiSelect == true) {
          _toggleMultiSelect(item);
        } else {
          _handleSelection(index);
        }
      },
      leading: widget.multiSelect == true
          ? Icon(isSelected ? Icons.check_box_sharp : Icons.check_box_outline_blank_sharp, color: isSelected ? (widget.primaryColor ?? Colors.green) : null, size: 22)
          : null,
      title: Text(label, style: widget.dropdownItemStyle ?? TextStyle(color: Colors.grey[700])),
    );
  }
  void _toggleMultiSelect(String item) {
    setState(() {
      if (selectedValues.contains(item)) {
        selectedValues.remove(item);
      } else {
        selectedValues.add(item);
      }
    });
  }

  void _handleSelection(int index) {
    final item = newDataList[index];
    if (widget.multiSelect == true) {
      _toggleMultiSelect(item);
    } else {
      for (int i = 0; i < menuData.length; i++) {
        if (menuData[i] == item) {
          onSelectLabel = menuData[i].split('-_-')[0];
          widget.onChanged(widget.items[i]);
          break;
        }
      }
      if (widget.menuMode == true) {
        _menuController.reverse();
      } else {
        Navigator.pop(context);
      }
    }
  }

  // Build empty state widget
  Widget _buildEmptyState(setState) {
    if (widget.emptySearchWidget != null) {
      return widget.emptySearchWidget!;
    }
    return Center(
      child: Column(
        spacing: 10,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(widget.emptySearchText ?? 'No results found', style: TextStyle(color: Colors.grey[600], fontSize: 16), textAlign: TextAlign.center),
          Text('Try adjusting your search terms', style: TextStyle(color: Colors.grey[500], fontSize: 14), textAlign: TextAlign.center),
          IconButton(
            icon: Text("Clear Search", style: TextStyle(fontWeight: FontWeight.bold, color: widget.primaryColor ?? Colors.green)),
            onPressed: () {
              setState(() {
                searchC.clear();
                onItemChanged('');
              });
            },
          )
        ],
      ),
    );
  }

  onItemChanged(String value) => setState(() => newDataList = mainDataListGroup.where((string) => string.toLowerCase().contains(value.toLowerCase())).toList());
}
