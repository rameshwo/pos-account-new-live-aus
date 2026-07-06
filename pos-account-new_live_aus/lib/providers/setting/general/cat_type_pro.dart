import 'package:flutter/material.dart';
import 'package:pos_account/ln.dart';
import 'package:pos_account/model/common/res_datum.dart';
import 'package:pos_account/model/home/setting/general/cat_type/cat_type_res.dart';
import 'package:pos_account/model/home/setting/general/category/restro_table_model.dart';
import 'package:pos_account/model/ui_model/tablelist_model.dart';
import 'package:pos_account/repository/handler.dart';

class CatTypePro extends ChangeNotifier {
  static List<String> get _headerList =>
      [LN.sortOrder, LN.name, LN.status, LN.action];
  void get notify => notifyListeners();

  final tableList = RTableData(
    headerList: _headerList,
    nameIndex: 1,
  );

  var tableData = <TLModel>[];

  void init() {
    tableList.headerList = _headerList;
    tableData = <TLModel>[
      TLModel(
        title: LN.name,
        tableCltr: TextEditingController(),
      ),
      TLModel(
        title: LN.sort,
        tableCltr: TextEditingController(),
        textInputType: TextInputType.number,
      )
    ];
  }

  bool isActiveStatus = true;

  int pageNum = 1;
  bool loading = true;
  String catTypeId = "";

  CateTypeRes? getAllCatTypes;

  Future<void> getData({int page = 1}) async {
    pageNum = page;
    getAllCatTypes = await Handler.getCatTypes(page: page);
    if (getAllCatTypes?.data != null) {
      tableList.tableDataList = [];
      for (var e in getAllCatTypes!.data!) {
        tableList.tableDataList.add(TableDataList(
          id: e.id!,
          itemList: [e.sortOrder.toString(), e.name!],
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
    final data = SRDatum(
      id: catTypeId,
      name: tableData[0].tableCltr.text,
      sortOrder: int.tryParse(tableData[1].tableCltr.text),
      isActive: isActiveStatus,
    );
    final status = await Handler.addUpCatTypes(catTypeList: [data]);
    if (status ?? false) {
      if (getAllCatTypes!.total! - (pageNum * 10) < 10) {
        getData(page: pageNum);
      }
      clear();
    }
    loading = false;
    notify;
  }

  int countMultipleCatTypes = 0;

  Future<void> deleteData({required List<SRDatum> dataList}) async {
    final status = await Handler.deleteCatTypes(catTypeList: dataList);
    if (status != null && status) {
      for (var e in dataList) {
        tableList.tableDataList.removeWhere((f) => e.id == f.id);
      }
      notify;
    }
  }

  void clear() {
    catTypeId = "";
    for (var e in tableData) {
      e.tableCltr.clear();
    }
  }
}
