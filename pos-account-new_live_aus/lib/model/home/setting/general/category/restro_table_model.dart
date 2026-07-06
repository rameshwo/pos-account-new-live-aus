import 'package:flutter/material.dart';

enum TableStatus { Active, Inactive, Yes, No, Completed, Pending, None }

StatusColor getStatusColor(TableStatus status) {
  if (status == TableStatus.Active ||
      status == TableStatus.Yes ||
      status == TableStatus.Completed)
    return StatusColor(
        backColor: Colors.green.withAlpha(50),
        textColor: Colors.green.shade700);
  else if (status == TableStatus.Inactive ||
      status == TableStatus.No ||
      status == TableStatus.Pending) {
    return StatusColor(
        backColor: Colors.red.withAlpha(50), textColor: Colors.red.shade700);
  } else {
    return StatusColor(
        backColor: Colors.amber.withAlpha(50),
        textColor: Colors.amber.shade700);
  }
}

class StatusColor {
  final Color backColor;
  final Color textColor;

  StatusColor({required this.backColor, required this.textColor});
}

////// Data class.
/////restro table data

class RTableData {
  RTableData({
    this.tableDataList = const [],
    required this.headerList,
    this.hasAction = true,
    this.showCheckBox = true,
    this.nameIndex = 0,
    // this.hasActionButton = false,
  });

  List<String> headerList;
  List<TableDataList> tableDataList;
  bool hasAction;
  // bool hasActionButton;
  bool showCheckBox;
  int nameIndex;
}

class TableDataList<T> {
  TableDataList({
    required this.id,
    required this.itemList,
    this.imgList,
    this.image,
    required this.statusList,
    this.actionWidget,
  });

  String id;
  List<T> itemList;
  List<String?>? imgList;
  String? image;
  List<TableStatus> statusList;
  List<Widget>? actionWidget;
  bool selected = false;
}
