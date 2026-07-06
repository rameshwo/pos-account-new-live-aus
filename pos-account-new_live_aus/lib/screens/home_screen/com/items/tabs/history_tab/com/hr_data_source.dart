import 'package:flutter/material.dart';
import 'package:pos_account/constant/constant.dart';

enum HRStatus { Active, Inactive, Pending } //History report status
// HR - History Report

////// Data class.
class HRTableModel {
  HRTableModel({
    required this.date,
    required this.receiptNo,
    required this.status,
    required this.salesAmount,
    required this.tax,
    required this.tip,
    required this.payMethod,
  });
  final String date;
  final String receiptNo;
  final HRStatus status;
  final double salesAmount;
  final double tax;
  final double tip;
  final String payMethod;
}

////// Data source class for obtaining row data for PaginatedDataTable.
class HRDataSource extends DataTableSource {
  final List<HRTableModel> hrList;

  HRDataSource({
    required this.hrList,
  });

  @override
  DataRow? getRow(int index) {
    assert(index >= 0);
    if (index >= hrList.length) return null;
    final HRTableModel hReport = hrList[index];
    return DataRow.byIndex(
      index: index,
      cells: <DataCell>[
        DataCell(Text(hReport.date)),
        DataCell(Text(hReport.receiptNo)),
        DataCell(Container(
            width: 80,
            decoration: BoxDecoration(
                color: hReport.status.index == 0
                    ? Colors.green.withAlpha(50)
                    : hReport.status.index == 1
                        ? Colors.red.withAlpha(50)
                        : Colors.amber.withAlpha(50),
                borderRadius: BorderRadius.circular(5)),
            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            child: Text(
              hReport.status.name,
              style: TextStyle(
                color: hReport.status.index == 0
                    ? Colors.green.shade700
                    : hReport.status.index == 1
                        ? Colors.red.shade700
                        : Colors.amber.shade700,
                fontFamily: kFontFMedium,
              ),
              textAlign: TextAlign.center,
            ))),
        DataCell(Text(hReport.salesAmount.toStringAsFixed(1))),
        DataCell(Text(hReport.tax.toStringAsFixed(1))),
        DataCell(Text(hReport.tip.toStringAsFixed(1))),
        DataCell(Text(hReport.payMethod)),
      ],
    );
  }

  @override
  int get rowCount => hrList.length;

  @override
  bool get isRowCountApproximate => false;

  @override
  int get selectedRowCount => 0;
}
