import 'package:flutter/material.dart';
import 'package:pos_account/ln.dart';
import 'package:pos_account/model/common/res_datum.dart';
import 'package:pos_account/model/common/setting_res.dart';
import 'package:pos_account/model/home/setting/general/category/restro_table_model.dart';
import 'package:pos_account/model/ui_model/tablelist_model.dart';
import 'package:pos_account/repository/handler.dart';

class DepartmentPro extends ChangeNotifier {
  static List<String> get _headerList => [LN.name, LN.status, LN.action];
  //pos printer department
  SettingRes? _getAllData;
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
      TLModel(title: LN.name, tableCltr: TextEditingController()),
      TLModel(title: LN.description, tableCltr: TextEditingController())
    ];
  }

  void clear() {
    itemId = "";
    _activeStatus = true;
    for (var e in tableData) {
      e.tableCltr.clear();
    }
    searchCltr.clear();
  }

  String itemId = "";
  final searchCltr = TextEditingController();

  Future<void> getData({int page = 1}) async {
    setPage = page;
    _getAllData = await Handler.getAllDeparment(
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
        ));
      }
    }
    loading = false;
    notifyListeners();
  }

  SettingRes? get getDepartRes => _getAllData;

  RTableData get getTableList => _tableList;

  Future<void> addUpData({required List<SRDatum> tableList}) async {
    loading = true;
    notifyListeners();

    final isAddSuccess = await Handler.addUpDepartment(
      tableList: tableList,
    );

    loading = false;
    notifyListeners();
    if (isAddSuccess != null && isAddSuccess && _getAllData!.total != null) {
      if (_getAllData!.total! - (getPage * 10) < 10) {
        await getData(page: getPage);
      }
    }
  }

  Future<void> deleteData({required List<SRDatum> dataList}) async {
    final status = await Handler.deleteDepartment(dataList: dataList);
    if (status != null && status) {
      for (var e in dataList) {
        getTableList.tableDataList.removeWhere((f) => e.id == f.id);
      }
      notifyListeners();
    }
  }

  int _countSelected = 0;

  int get getCountSelected => _countSelected;

  set setCountSelected(int val) {
    _countSelected = val;
    notifyListeners();
  }

  bool _activeStatus = true;

  bool get getActiveStatus => _activeStatus;

  set setActiveStatus(bool val) {
    _activeStatus = val;
    notifyListeners();
  }

  void notify() {
    notifyListeners();
  }
}
