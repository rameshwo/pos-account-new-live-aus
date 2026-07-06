import 'package:flutter/material.dart';
import 'package:pos_account/ln.dart';
import 'package:pos_account/model/common/res_datum.dart';
import 'package:pos_account/model/home/setting/general/category/restro_table_model.dart';
import 'package:pos_account/model/home/setting/pos_device/pos_printer/get_all_pos_loc_res.dart';
import 'package:pos_account/model/home/setting/pos_device/pos_printer/pos_printer_add_sec.dart';
import 'package:pos_account/model/home/setting/pos_device/pos_printer/printer_location.dart';
import 'package:pos_account/model/ui_model/tablelist_model.dart';
import 'package:pos_account/repository/handler.dart';
import 'package:pos_account/services/printer/printer_enum.dart';

// pos printer location provider
class POSPLocationPro extends ChangeNotifier {
  static List<String> get _headerList => [
        LN.name,
        // LN.department,
        LN.address,
        LN.port,
        LN.status, LN.action
      ];
  GetAllPosLocBdRes? _getAllData;
  final _tableList = RTableData(headerList: _headerList);

  // PosLocAddSec? addSecData;

  PrinterLocationReq? editData;
  bool loading = true;

  int _page = 1;

  int get getPage => _page;

  set setPage(int val) {
    _page = val;
  }

  var tableData = <TLModel>[];

  void init({bool isTableDataUpdate = true}) {
    _tableList.headerList = _headerList;
    if (_tableList.headerList.any((e) => e == LN.address)) {
      _tableList.headerList[_tableList.headerList
          .indexWhere((e) => e == LN.address)] = "IP/MAC ${LN.address}";
    }
    tableData = <TLModel>[
      TLModel(
          title: LN.name,
          tableCltr: TextEditingController(
              text: isTableDataUpdate ? "" : tableData[0].tableCltr.text)),
      TLModel(
          title: LN.description,
          tableCltr: TextEditingController(
              text: isTableDataUpdate ? "" : tableData[1].tableCltr.text)),
      TLModel(
          title: printerType == PrinterTypeEnum.Bluetooth
              ? "Mac Address"
              : printerType == PrinterTypeEnum.USB
                  ? "Vendor Id"
                  : LN.ipAddress,
          tableCltr: TextEditingController(
              text: isTableDataUpdate ? "" : tableData[2].tableCltr.text)),
      TLModel(
        title: printerType == PrinterTypeEnum.USB ? "Product Id" : LN.port,
        tableCltr: TextEditingController(
            text: isTableDataUpdate
                ? (printerType == PrinterTypeEnum.Ethernet ? "9100" : "")
                : tableData[3].tableCltr.text),
        textInputType: TextInputType.number,
      ),
    ];
  }

  void clear() {
    itemId = "";
    _activeStatus = true;
    printerType = PrinterTypeEnum.Ethernet;
    // _isDefault = true;
    // _selectedIndex = null;
    for (var e in tableData) {
      e.tableCltr.clear();
    }
    printerTypeIndex = null;
    searchCltr.clear();
  }

  String itemId = "";

  PosPrinterAddSec? posPrinterAddSec;

  int? printerTypeIndex;

  Future<void> getAddSectionData() async {
    posPrinterAddSec = await Handler.getPosPrinterAddSec();
    notify;
  }

  void setPrinterType() {
    if (posPrinterAddSec?.printerTypes
            ?.any((e) => e.value == printerType.name) ??
        false) {
      printerTypeIndex = posPrinterAddSec?.printerTypes
          ?.indexWhere((e) => e.value == printerType.name);
      notify;
    }
  }

  void setPrintTypeEnum() {
    if (posPrinterAddSec?.printerTypes == null ||
        posPrinterAddSec!.printerTypes!.isEmpty ||
        printerTypeIndex == null) return;

    final key = posPrinterAddSec?.printerTypes?[printerTypeIndex!].value;

    if (key == PrinterTypeEnum.USB.name) {
      printerType = PrinterTypeEnum.USB;
    } else if (key == PrinterTypeEnum.Bluetooth.name) {
      printerType = PrinterTypeEnum.Bluetooth;
    } else {
      printerType = PrinterTypeEnum.Ethernet;
    }
  }

  final searchCltr = TextEditingController();

  Future<void> getData({int page = 1}) async {
    setPage = page;
    _getAllData = await Handler.getAllPosLocByDepart(
        page: page, searchKey: searchCltr.text.toLowerCase());
    if (_getAllData?.data != null) {
      _tableList.tableDataList = [];

      for (var e in _getAllData!.data!) {
        _tableList.tableDataList.add(TableDataList(
          id: e.id!,
          itemList: [
            e.name ?? '',
            e.ipAddress ?? '',
            e.port ?? '',
            // e.department!,
          ],
          statusList: [
            (e.isActive != null && e.isActive!)
                ? TableStatus.Active
                : TableStatus.Inactive,
            // (e.isDefault != null && e.isDefault!)
            //     ? TableStatus.Active
            //     : TableStatus.Inactive,
          ],
        ));
      }
    }
    loading = false;
    notify;
  }

  GetAllPosLocBdRes? get getAllRes => _getAllData;

  RTableData get getTableList => _tableList;

  Future<void> addUpData({required List<PrinterLocationReq> dataList}) async {
    loading = true;
    notify;

    final isAddSuccess = await Handler.addUpPosLoc(
      dataList: dataList,
    );

    loading = false;
    notify;

    if (isAddSuccess != null && isAddSuccess && _getAllData!.total != null) {
      if (_getAllData!.total! - (getPage * 10) < 10) {
        await getData(page: getPage);
      }
      clear();
      notify;
    }
  }

  Future<void> deleteData({required List<SRDatum> dataList}) async {
    loading = true;
    notify;
    final status = await Handler.deletePosLoc(dataList: dataList);
    if (status != null && status) {
      getData(page: getPage);
      // for (var e in dataList) {
      //   getTableList.tableDataList.removeWhere((f) => e.id == f.id);
      // }
      // notify;
    }
    loading = false;
    notify;
  }

  Future<void> getEditData({required String id}) async {
    loading = true;
    notify;
    editData = await Handler.editPosLoc(reqId: id);
    loading = false;
    notify;
  }

  int _countSelected = 0;

  int get getCountSelected => _countSelected;

  set setCountSelected(int val) {
    _countSelected = val;
    notify;
  }

  bool _activeStatus = true;

  bool get getActiveStatus => _activeStatus;

  set setActiveStatus(bool val) {
    _activeStatus = val;
    notify;
  }

  PrinterTypeEnum printerType = PrinterTypeEnum.Ethernet;

  // bool _isDefault = true;

  // bool get getDefault => _isDefault;

  // set setDefault(bool val) {
  //   _isDefault = val;
  //   notify;
  // }

  // int? _selectedIndex;
  // int? get getSIndex => _selectedIndex;

  // set setSIndex(int? val) {
  //   _selectedIndex = val;
  //   notify;
  // }

  void get notify {
    notifyListeners();
  }
}
