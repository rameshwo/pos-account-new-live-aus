import 'package:flutter/material.dart';
import 'package:pos_account/constant/constant.dart';
import 'package:pos_account/ln.dart';
import 'hr_data_source.dart';

class HRDataTable extends StatefulWidget {
  const HRDataTable({super.key});

  @override
  State<HRDataTable> createState() => _HRDataTableState();
}

class _HRDataTableState extends State<HRDataTable> {
  int _rowsPerPage = 5;

  static final _headerList = [
    LN.date,
    '${LN.receiptNo}.',
    LN.status,
    LN.salesAmount,
    LN.tax,
    LN.tip,
    LN.paymentMethod,
  ];

  var hrTableList = hRTableListFinal;
  bool sortAscending = true;

  load() {
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Card(
        child: SizedBox(
      width: double.infinity,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8),
        child: PaginatedDataTable(
          // header: const Text('Nutrition'),
          rowsPerPage: _rowsPerPage,
          sortColumnIndex: 0,
          showCheckboxColumn: false,
          sortAscending: sortAscending,
          availableRowsPerPage: <int>[5, 10, 20],
          onRowsPerPageChanged: (int? value) {
            if (value != null) {
              _rowsPerPage = value;
              load();
            }
          },
          columns: List<DataColumn>.generate(
              _headerList.length,
              (index) => DataColumn(
                    label: Text(
                      _headerList[index],
                      style: TextStyle(
                        fontFamily: kFontFMedium,
                        fontStyle: FontStyle.normal,
                      ),
                    ),
                    onSort: (columnIndex, ascending) {
                      sortAscending = !sortAscending;
                      if (ascending)
                        hRTableListFinal
                            .sort((a, b) => a.date.compareTo(b.date));
                      else
                        hRTableListFinal
                            .sort((a, b) => b.date.compareTo(a.date));
                      load();
                    },
                  )),
          source: HRDataSource(hrList: hrTableList),
        ),
      ),
    ));
  }
}

final List<HRTableModel> hRTableListFinal = <HRTableModel>[
  HRTableModel(
    date: "06/14/2022",
    receiptNo: "0024",
    status: HRStatus.Active,
    salesAmount: 10,
    tax: 13,
    tip: 20,
    payMethod: "Online",
  ),
  HRTableModel(
    date: "06/16/2022",
    receiptNo: "0025",
    status: HRStatus.Inactive,
    salesAmount: 100,
    tax: 13,
    tip: 10,
    payMethod: LN.bank,
  ),
  HRTableModel(
    date: "06/18/2022",
    receiptNo: "0028",
    status: HRStatus.Active,
    salesAmount: 500.432,
    tax: 13.333333,
    tip: 32.3333,
    payMethod: "Ofline",
  ),
  HRTableModel(
    date: "06/14/2022",
    receiptNo: "0024",
    status: HRStatus.Active,
    salesAmount: 10,
    tax: 13,
    tip: 20,
    payMethod: "Online",
  ),
  HRTableModel(
    date: "06/16/2022",
    receiptNo: "0025",
    status: HRStatus.Inactive,
    salesAmount: 100,
    tax: 13,
    tip: 10,
    payMethod: LN.bank,
  ),
];
