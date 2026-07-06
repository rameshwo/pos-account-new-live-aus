import 'package:flutter/material.dart';
import 'package:pos_account/ln.dart';
import 'package:pos_account/model/common/res_datum.dart';
import 'package:pos_account/model/home/setting/general/category/restro_table_model.dart';
import 'package:pos_account/model/home/setting/general/table_lay/table_lay.dart';
import 'package:pos_account/model/home/setting/general/table_loc/all_table_loc.dart';
import 'package:pos_account/model/home/setting/table_layout/layout_design_model.dart';
import 'package:pos_account/model/ui_model/tablelist_model.dart';
import 'package:pos_account/repository/handler.dart';

// all table location provider
class AllTableLocPro extends ChangeNotifier {
  static List<String> get _headerList => [LN.name, LN.status, LN.action];
  AllTableLocationModel? _getAllData; // get all table location data

  final _tableList = RTableData(
    headerList: _headerList,
  );
  bool loading = true;

  int _page = 1;

  int get getPage => _page;

  set setPage(int val) {
    _page = val;
  }

  var tableData = <TLModel>[];

  void init() {
    _tableList.headerList = _headerList;
    tableData = <TLModel>[
      TLModel(title: LN.tableName, tableCltr: TextEditingController()),
      TLModel(title: LN.description, tableCltr: TextEditingController())
    ];
  }

  void clear() {
    itemId = "";
    _status = true;
    for (var e in tableData) {
      e.tableCltr.clear();
    }
    searchCltr.clear();
  }

  String itemId = "";
  final searchCltr = TextEditingController();

  Future<void> getData({int page = 1}) async {
    _getAllData = await Handler.getAllTableLocation(
        page: page, searchKey: searchCltr.text.toLowerCase());
    if (_getAllData?.data != null) {
      _tableList.tableDataList = [];
      for (var e in _getAllData!.data!) {
        _tableList.tableDataList.add(TableDataList(
          id: e.id!,
          itemList: [e.name!],
          statusList: [
            (e.isActive != null && e.isActive!)
                ? TableStatus.Active
                : TableStatus.Inactive
          ],
          // itemName: e.name!,
          // status: (e.isActive != null && e.isActive!)
          //     ? TableStatus.Active
          //     : TableStatus.Inactive,
        ));
      }
    }
    loading = false;
    notifyListeners();
  }

  AllTableLocationModel? get getATLData => _getAllData;

  RTableData get getTableList => _tableList;

  Future<void> addData({required List<SRDatum> tableList}) async {
    loading = true;
    notifyListeners();

    final isAddSuccess =
        await Handler.addUpdateTableLocation(tableList: tableList);

    loading = false;
    notifyListeners();

    if (isAddSuccess != null && _getAllData!.total != null) {
      if (_getAllData!.total! - (getPage * 10) < 10) {
        await getData(page: getPage);
      }
    }
  }

  Future<void> deleteData({required List<SRDatum> dataList}) async {
    final status = await Handler.deleteTableLocation(dataList: dataList);
    if (status != null && status) {
      for (var e in dataList) {
        getTableList.tableDataList.removeWhere((f) => e.id == f.id);
      }
      notifyListeners();
    }
  }

  int _countSelected = 0;

  int get getSelectedCount => _countSelected;

  set setCount(int val) {
    _countSelected = val;
    notifyListeners();
  }

  bool _status = true;

  bool get getStatus => _status;

  set setStatus(bool val) {
    _status = val;
    notifyListeners();
  }

  void notify() {
    notifyListeners();
  }

  Future<void> createTableLayout({String? tableLocationId}) async {
    final data = TableLayReq();
    data.tableLocationId = tableLocationId;
    data.tableSettings = layoutDesignModelToJson(LayoutDesignModel());
    final status = await Handler.addUpTableLay(tableLayReq: data);
    if (status ?? false) {
      getData(page: getPage);
    }
  }
}
