import 'package:flutter/material.dart';
import 'package:pos_account/ln.dart';
import 'package:pos_account/model/common/res_datum.dart';
import 'package:pos_account/model/home/setting/general/category/restro_table_model.dart';
import 'package:pos_account/model/ui_model/tablelist_model.dart';
import 'package:pos_account/repository/handler.dart';

import '../../../model/home/setting/general/discount_res.dart';

class DiscountPro extends ChangeNotifier {
  static List<String> get _headerList => [LN.name, LN.status, LN.action];
  void get notify => notifyListeners();

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
  String discountId = "";

  DiscountSetRes? getAllDiscounts;

  final searchCltr = TextEditingController();

  Future<void> getData({int page = 1}) async {
    pageNum = page;
    getAllDiscounts = await Handler.getDiscountsSet(
        page: page, searchKey: searchCltr.text.toLowerCase());
    if (getAllDiscounts?.data != null) {
      tableList.tableDataList = [];
      for (var e in getAllDiscounts!.data!) {
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
      id: discountId,
      name: tableData[0].tableCltr.text,
      description: "",
      isActive: isActiveStatus,
    );
    final _status = await Handler.addUpDiscounts(discountList: _data);
    if (_status ?? false) {
      if (getAllDiscounts!.total! - (pageNum * 10) < 10) {
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
    discountId = "";
    for (var e in tableData) {
      e.tableCltr.clear();
    }
    searchCltr.clear();
  }
}
