import 'package:flutter/material.dart';
import 'package:pos_account/ln.dart';
import 'package:pos_account/model/common/res_datum.dart';
import 'package:pos_account/model/home/setting/general/category/restro_table_model.dart';
import 'package:pos_account/model/home/setting/general/quick_note_res.dart';
import 'package:pos_account/model/ui_model/tablelist_model.dart';
import 'package:pos_account/repository/handler.dart';

class QuickNotePro extends ChangeNotifier {
  void get notify => notifyListeners();

  static List<String> get _headerList => [LN.name, LN.status, LN.action];

  final tableList =
      RTableData(headerList: _headerList, nameIndex: 0, showCheckBox: false);

  var tableData = <TLModel>[];

  void init() {
    tableList.headerList = _headerList;
    tableData = <TLModel>[
      TLModel(
        title: LN.name,
        tableCltr: TextEditingController(),
      ),
    ];
  }

  bool isActiveStatus = true;

  int pageNum = 1;
  bool loading = true;
  String quickNoteId = "";

  QuickNoteRes? getAllNotes;

  final searchCltr = TextEditingController();

  Future<void> getData({int page = 1}) async {
    pageNum = page;
    getAllNotes = await Handler.getAllNotes(
        page: page, searchKey: searchCltr.text.toLowerCase());
    if (getAllNotes?.data != null) {
      tableList.tableDataList = [];
      for (var e in getAllNotes!.data!) {
        tableList.tableDataList.add(TableDataList(
          id: e.id!,
          itemList: [e.name!],
          statusList: [
            (e.isActive != null && e.isActive!)
                ? TableStatus.Active
                : TableStatus.Inactive
          ],
        ));
      }
    }
    loading = false;
    notify;
  }

  Future<void> addUpData() async {
    loading = true;
    notify;
    final _data = SRDatum(
      id: quickNoteId,
      name: tableData[0].tableCltr.text,
      description: "",
      isActive: isActiveStatus,
    );
    final _status = await Handler.addUpNotes(quickNote: _data);
    if (_status ?? false) {
      // if (getAllNotes!.total! - (pageNum * 10) < 10) {
      //   getData(page: pageNum);
      // }
      clear();
    }
    loading = false;
    notify;
  }

  int countMultipleCatTypes = 0;

  Future<void> deleteNote({required List<SRDatum> dataList}) async {
    loading = true;
    notify;
    final status = await Handler.deleteNote(dataList: dataList);
    if (status != null && status) {
      for (var e in dataList) {
        tableList.tableDataList.removeWhere((f) => e.id == f.id);
      }
      notify;
    }
    loading = false;
    notify;
  }

  void clear() {
    quickNoteId = "";
    for (var e in tableData) {
      e.tableCltr.clear();
    }
    searchCltr.clear();
  }
}
