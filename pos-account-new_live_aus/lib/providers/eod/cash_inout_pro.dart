import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:oktoast/oktoast.dart';
import 'package:pos_account/ln.dart';
import 'package:pos_account/model/home/eod/all_cash_in_out.dart';
import 'package:pos_account/model/home/setting/general/category/restro_table_model.dart';
import 'package:pos_account/model/ui_model/tablelist_model.dart';
import 'package:pos_account/repository/handler.dart';
import 'package:pos_account/services/database/shared_pref.dart';

enum CashType { CashIn, CashOut }

class EodCashInOutPro extends ChangeNotifier {
  static List<String> get _headerList =>
      [LN.date, LN.users, LN.type, LN.amount, LN.notes, LN.action];
  void get notify => notifyListeners();

  bool loadCashInOut = true;

  final tableList = RTableData(
    headerList: _headerList,
    showCheckBox: false,
  );

  var tableData = <TLModel>[];

  String itemId = "";
  final dateCltr = TextEditingController();
  String? dateFormat;

  void _init() {
    tableList.headerList = _headerList;
    tableData = <TLModel>[
      TLModel(
        title: LN.amount,
        tableCltr: TextEditingController(),
        textInputType: TextInputType.number,
      ),
      TLModel(title: LN.notes, tableCltr: TextEditingController()),
    ];
  }

  void clear() {
    itemId = "";
    cashType = null;
    for (var e in tableData) {
      e.tableCltr.clear();
    }
  }

  String? curSym;

  Future<void> getDateFor() async {
    _init();
    curSym = await SharedPrefs.curSym;
    dateFormat = await SharedPrefs.dateFormat;
    dateCltr.text = DateFormat(dateFormat).format(DateTime.now());
  }

  AllCashInOut? allCashInOut;
  int pageIndex = 1;

  Future<void> getData({int page = 1}) async {
    pageIndex = page;
    allCashInOut = await Handler.getAllCashInOut(
      date: dateCltr.text,
      page: page,
    );
    setData();
    loadCashInOut = false;
    notify;
  }

  double totalCashIn = 0.0;
  double totalCashOut = 0.0;

  setData() {
    if (allCashInOut?.data != null) {
      tableList.tableDataList = [];
      totalCashIn = 0.0;
      totalCashOut = 0.0;
      for (final e in allCashInOut!.data!) {
        tableList.tableDataList.add(TableDataList(
          id: e.id ?? '',
          itemList: [
            e.date ?? '',
            e.user ?? '',
            e.type ?? '',
            (curSym ?? '') + (e.amount ?? ''),
            e.notes ?? ''
          ],
          statusList: [],
        ));
        if (e.type == CashType.CashIn.name) {
          totalCashIn = double.tryParse(e.amount ?? '') ?? 0.0;
        } else if (e.type == CashType.CashOut.name) {
          totalCashOut = double.tryParse(e.amount ?? '') ?? 0.0;
        }
      }
    }
  }

  CashType? cashType;

  Future<void> addUpData() async {
    if (cashType == null) {
      showToast("Please, choose Cash Type");
      return;
    }
    final req = CashInOutData(
      id: itemId,
      amount: tableData[0].tableCltr.text,
      notes: tableData[1].tableCltr.text,
      type: CashType.values.firstWhere((e) => e == cashType).name,
    );
    final status = await Handler.addUpCashInOut(req: req);
    if (status ?? false) {
      clear();
      getData(page: pageIndex);
    }
    notify;
  }

  Future<void> editData() async {
    if (itemId.isEmpty) return;
    final editData = await Handler.editCashInOut(id: itemId);
    if (editData != null) {
      tableData[0].tableCltr.text = editData.amount ?? '';
      tableData[1].tableCltr.text = editData.notes ?? '';
      if (editData.type != null &&
          CashType.values.any((e) => e.name == editData.type)) {
        cashType = CashType.values.firstWhere((e) => e.name == editData.type);
      }
      notify;
    }
  }
}
