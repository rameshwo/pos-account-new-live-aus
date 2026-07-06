import 'package:flutter/material.dart';
import 'package:pos_account/ln.dart';
import 'package:pos_account/model/home/setting/general/barcode/barcode_req.dart';
import 'package:pos_account/model/home/setting/general/barcode/barcode_type_add_sec.dart';
import 'package:pos_account/model/home/setting/general/barcode/barcode_type_res.dart';
import 'package:pos_account/model/home/setting/general/category/restro_table_model.dart';
import 'package:pos_account/repository/handler.dart';

class BarcodePro extends ChangeNotifier {
  void get notify => notifyListeners();

  static List<String> get _headerList => [LN.name, LN.status, LN.action];

  final tableList = RTableData(
    headerList: _headerList,
    showCheckBox: false,
  );

  BarCodeTypeAddSec? barCodeTypeAddSec;
  int? barcodeTypeIndex;

  bool pageLoad = true;

  void init() {
    tableList.headerList = _headerList;
  }

  Future<void> getAddSec() async {
    barCodeTypeAddSec = await Handler.getBarcodeAddSec();
    notify;
  }

  int pageIndex = 1;
  BarCodeTypeList? barCodeTypeList;

  Future<void> getData({
    int page = 1,
  }) async {
    pageIndex = page;
    barCodeTypeList = await Handler.getAllBarCodes(page: page);
    if (barCodeTypeList?.data != null) {
      tableList.tableDataList = [];
      for (final e in barCodeTypeList!.data!) {
        tableList.tableDataList.add(
          TableDataList(
            id: e.id ?? '',
            itemList: [e.name ?? ''],
            statusList: [
              (e.isDefault ?? false) ? TableStatus.Active : TableStatus.Inactive
            ],
          ),
        );
      }
    }

    pageLoad = false;
    notify;
  }

  BarcodeData? editBarData;

  bool? editData(String id) {
    if (barCodeTypeList?.data == null &&
        !barCodeTypeList!.data!.any((e) => e.id == id)) return null;

    editBarData = barCodeTypeList!.data!.firstWhere((e) => e.id == id);

    if (barCodeTypeAddSec?.barCodeTypes != null &&
        barCodeTypeAddSec!.barCodeTypes!
            .any((e) => e.value == editBarData?.name)) {
      barcodeTypeIndex = barCodeTypeAddSec!.barCodeTypes!
          .indexWhere((e) => e.value == editBarData?.name);
    }

    notify;

    return true;
  }

  void clear() {
    barCodeTypeAddSec = null;
    barcodeTypeIndex = null;
    editBarData = null;
    pageLoad = true;
    pageIndex = 1;
    barCodeTypeList = null;
  }

  Future<void> updateData() async {
    if (editBarData == null) return;

    final data = BarCodeReq(
      id: editBarData?.id,
      isDefault: editBarData?.isDefault,
    );

    if (barCodeTypeAddSec?.barCodeTypes != null && barcodeTypeIndex != null) {
      data.barCodeTypeId =
          barCodeTypeAddSec!.barCodeTypes![barcodeTypeIndex!].id;
    }

    final status = await Handler.updateBarCodeType(req: data);
    if (status ?? false) {
      editBarData = null;
      barcodeTypeIndex = null;
      getData(page: pageIndex);
    }
  }
}
