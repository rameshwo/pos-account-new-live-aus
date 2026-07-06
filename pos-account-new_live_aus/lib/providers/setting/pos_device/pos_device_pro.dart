import 'package:flutter/material.dart';
import 'package:pos_account/config/validator.dart';
import 'package:pos_account/ln.dart';
import 'package:pos_account/model/home/setting/pos_device/pos_device/all_pos_device.dart';
import 'package:pos_account/model/home/setting/pos_device/pos_device/pos_device_addsec.dart';
import 'package:pos_account/model/home/setting/pos_device/pos_device/pos_device_model.dart';
import 'package:pos_account/model/ui_model/tablelist_model.dart';
import 'package:pos_account/repository/handler.dart';

import '../../../config/utils/utils.dart';
import '../../../model/common/table_location.dart';
import '../../../model/ui_model/screen_time_model.dart';

class PosDevicePro extends ChangeNotifier {
  // static List<String> get _headerList => [
  //       LN.deviceName,
  //       "Device Identifier",
  //       // LN.planSubscribed,
  //       LN.status,
  //       // "Default",
  //       LN.action,
  //     ];
  void get notify => notifyListeners();

  PosDeviceAddSec? posDeviceAddSec;

  bool loading = true;

  int pageIndex = 1;

  var tableData = <TLModel>[];

  bool isActive = true;

  bool isMainDevice = false;
  bool openCashRegister = false;
  bool enableLoginPinCode = false;
  // bool isKitchenDisplay = false;
  // bool isDefault = false;

  int? posDefaultScreenIndex;

  int? screenSaverIndex;

  void init() {
    // tableList.headerList = _headerList;
    tableData = <TLModel>[
      TLModel(
        title: LN.deviceNameLoc,
        tableCltr: TextEditingController(),
        isReq: true,
      ),
      TLModel(
        title: LN.sort,
        tableCltr: TextEditingController(),
        textInputType: TextInputType.number,
        isReq: true,
      ),
      TLModel(
        title: "Device Identifier",
        tableCltr: TextEditingController(),
        textInputType: TextInputType.text,
        isReq: false,
      ),
    ];
  }

  void clear() {
    itemId = "";
    // departmentIndex = null;
    posDeviceIndex = null;
    printerIndex = null;
    isActive = true;
    isMainDevice = false;
    openCashRegister = false;
    // isKitchenDisplay = false;
    enableLoginPinCode = false;
    posDefaultScreenIndex = null;
    screenSaverIndex = null;

    // isDefault = false;
    for (var e in tableData) {
      e.tableCltr.clear();
    }
    // selectedCategoryList = [];
    deletedCategoryId = [];
    // categoryExpanded = false;
    searchCltr.clear();
    // groupedData = [];
    // allPosDevices = null;
    // loading = true;
  }

  void clearOnChangeDevice() {
    printerIndex = null;
    isMainDevice = false;
    openCashRegister = false;
    // isKitchenDisplay = false;
    enableLoginPinCode = false;
    posDefaultScreenIndex = null;
    screenSaverIndex = null;
  }

  AllPosDevices? allPosDevices;
  // final tableList = RTableData(
  //   headerList: [
  //     LN.deviceName,
  //     "Device Identifier",
  //     // LN.planSubscribed,
  //     LN.status,
  //     // LN.action,
  //   ],
  // );

  String itemId = "";
  int selectedCount = 0;
  // List<SelectedCategory> selectedCategoryList = [];

  // int? departmentIndex;
  int? posDeviceIndex;
  int? printerIndex;

  List<TableLocation>? get _posDevices => posDeviceAddSec?.posDeviceTypes;

  bool get _isAnySelected =>
      (_posDevices?.isNotEmpty ?? false) && posDeviceIndex != null;

  bool get isPosDevice =>
      _isAnySelected &&
      (_posDevices?[posDeviceIndex!].name?.toLowerCase().contains('pos') ??
          false);

  bool get isKioskDevice =>
      _isAnySelected &&
      (_posDevices?[posDeviceIndex!].name?.toLowerCase().contains('kios') ??
          false);

  bool get _isKitchenDevice =>
      _isAnySelected &&
      (_posDevices?[posDeviceIndex!].name?.toLowerCase().contains('kitchen') ??
          false);

  Future<void> getAddSec() async {
    posDeviceAddSec = await Handler.getPosDeviceAddSec();
    notify;
  }

  // void onSelectCategory(TableLocation cat) {
  //   final existingIndex =
  //       selectedCategoryList.indexWhere((e) => e.productCategoryId == cat.id);

  //   if (existingIndex >= 0) {
  //     selectedCategoryList.removeAt(existingIndex);
  //   } else {
  //     selectedCategoryList.add(
  //       SelectedCategory(
  //         id: "",
  //         productCategoryId: cat.id,
  //       ),
  //     );
  //   }
  //   notifyListeners();
  // }

  final searchCltr = TextEditingController();

  Future<void> getData({int page = 1}) async {
    pageIndex = page;
    allPosDevices = await Handler.getAllPosDevice(
        page: page, searchKey: searchCltr.text.toLowerCase());

    setData();
    // if (allPosDevices?.data != null) {
    //   tableList.tableDataList = [];

    //   for (var e in allPosDevices!.data!) {
    //     tableList.tableDataList.add(TableDataList(
    //       id: e.id!,
    //       itemList: [
    //         e.posDeviceNameOrLocation ?? '',
    //         e.deviceIdentifier ?? '',
    //       ],
    //       statusList: [
    //         // (e.isPlanSubscribed != null && e.isPlanSubscribed!)
    //         //     ? TableStatus.Yes
    //         //     : TableStatus.No,
    //         (e.isActive != null && e.isActive!)
    //             ? TableStatus.Active
    //             : TableStatus.Inactive,
    //         // (e.isDefault != null && e.isDefault!)
    //         //     ? TableStatus.Active
    //         //     : TableStatus.Inactive
    //       ],
    //     ));
    //   }
    // }
    loading = false;
    notify;
  }

  List<Map<String, List<PosDeviceData>?>> groupedData = [];

  void setData() {
    final List<String> deviceOrder = [
      'Pos',
      'Kitchen Display',
      'Kiosk',
    ];

    groupedData = deviceOrder.map((type) {
      final devices = allPosDevices?.data
          ?.where((item) => item.deviceType == type)
          .toList();

      return {
        type: devices,
      };
    }).toList();
  }

  Future<void> addUpdate() async {
    loading = true;
    notify;

    final data = PosDeviceModel(
      id: itemId,
      posDeviceNameOrLocation: tableData[0].tableCltr.text,
      sortOrder: int.tryParse(tableData[1].tableCltr.text),
      deviceIdentifier: tableData[2].tableCltr.text,
      isActive: isActive,
      openCashRegister: openCashRegister,
      enablePinCodePopUpScreen: enableLoginPinCode,
      isKitchenDisplay: _isKitchenDevice, // isKitchenDisplay,
      isMainPosDevice: isMainDevice,
      // posDeviceProductCategories: selectedCategoryList,
      // deletedPosDeviceProductCateogriesIds: findDeletedCategoryIds(
      //   editData?.posDeviceProductCategories ?? [],
      //   selectedCategoryList,
      // ),
      // isDefault: isDefault,
    );

    // if (posDeviceAddSec?.departments != null && departmentIndex != null) {
    //   _data.departmentId = posDeviceAddSec!.departments![departmentIndex!].id;
    // }
    if (posDeviceAddSec?.posPrinters != null && printerIndex != null) {
      data.printerId = posDeviceAddSec!.posPrinters![printerIndex!].id;
    } else {
      data.printerId = "";
    }

    if (posDeviceAddSec?.posDeviceTypes != null && posDeviceIndex != null) {
      data.posDeviceTypeId =
          posDeviceAddSec!.posDeviceTypes![posDeviceIndex!].id;
    }

    if (posDeviceAddSec?.posDefaultScreens != null &&
        posDefaultScreenIndex != null) {
      data.posDefaultScreen =
          posDeviceAddSec!.posDefaultScreens![posDefaultScreenIndex!].name;
    } else {
      data.posDefaultScreen = "";
    }

    if (screenSaverIndex != null) {
      data.screenSaverLogOffInterval =
          ScreenTimeOut[screenSaverIndex!].duration.toString();
    }

    final status = await Handler.addUpPosDevice(data: data);

    if (status ?? false) {
      clear();
      getData(page: pageIndex);
    }

    loading = false;
    notify;
  }

  // bool categoryExpanded = false;
  PosDeviceModel? editData;

  Future<bool?> getEditData() async {
    editData = null;
    if (itemId.isEmpty) return null;
    loading = true;
    notify;

    editData = await Handler.editPosDevice(id: itemId);

    if (editData != null) {
      tableData[0].tableCltr.text = editData?.posDeviceNameOrLocation ?? '';
      tableData[1].tableCltr.text = editData?.sortOrder?.toString() ?? '';
      tableData[2].tableCltr.text =
          editData?.deviceIdentifier?.toString() ?? '';
      isActive = editData?.isActive ?? false;
      openCashRegister = editData?.openCashRegister ?? false;
      enableLoginPinCode = editData?.enablePinCodePopUpScreen ?? false;
      // isKitchenDisplay = editData?.isKitchenDisplay ?? false;
      isMainDevice = editData?.isMainPosDevice ?? false;
      // isDefault = _editData.isDefault ?? false;

      // if (posDeviceAddSec?.departments != null &&
      //     posDeviceAddSec!.departments!.any((e) =>
      //         e.id?.toLowerCase() == editData?.departmentId?.toLowerCase())) {
      //   departmentIndex = posDeviceAddSec!.departments!.indexWhere((e) =>
      //       e.id?.toLowerCase() == editData?.departmentId?.toLowerCase());
      // }

      if (posDeviceAddSec?.posPrinters != null &&
          posDeviceAddSec!.posPrinters!.any((e) =>
              e.id?.toLowerCase() == editData?.printerId?.toLowerCase())) {
        printerIndex = posDeviceAddSec!.posPrinters!.indexWhere(
            (e) => e.id?.toLowerCase() == editData?.printerId?.toLowerCase());
      }

      if (posDeviceAddSec?.posDeviceTypes != null &&
          posDeviceAddSec!.posDeviceTypes!.any((e) =>
              e.id?.toLowerCase() ==
              editData?.posDeviceTypeId?.toLowerCase())) {
        posDeviceIndex = posDeviceAddSec!.posDeviceTypes!.indexWhere((e) =>
            e.id?.toLowerCase() == editData?.posDeviceTypeId?.toLowerCase());
      }

      if (posDeviceAddSec?.posDefaultScreens != null &&
          posDeviceAddSec!.posDefaultScreens!.any((e) =>
              e.name?.toLowerCase() ==
              editData?.posDefaultScreen?.toLowerCase())) {
        posDefaultScreenIndex = posDeviceAddSec!.posDefaultScreens!.indexWhere(
            (e) =>
                e.name?.toLowerCase() ==
                editData?.posDefaultScreen?.toLowerCase());
      }

      if (ScreenTimeOut.any((e) =>
          e.duration ==
          editData?.screenSaverLogOffInterval?.inDouble.floor())) {
        screenSaverIndex = ScreenTimeOut.indexWhere((e) =>
            e.duration ==
            editData?.screenSaverLogOffInterval?.inDouble.floor());
      } else {
        final _interval = editData?.screenSaverLogOffInterval?.inDouble.floor();
        if (_interval != null && _interval != 0) {
          final _screenTime = ScreenTimeModel(
            title: Utils.convertSeconds(_interval),
            duration: _interval,
            enable: true,
          );
          ScreenTimeOut.add(_screenTime);
          ScreenTimeOut.sort((a, b) => a.duration.compareTo(b.duration));
          final _first = ScreenTimeOut.first;
          ScreenTimeOut.add(_first);
          ScreenTimeOut.removeAt(0);

          screenSaverIndex = ScreenTimeOut.indexWhere((e) =>
              e.duration ==
              editData?.screenSaverLogOffInterval?.inDouble.floor());
        }
      }

      // if (editData?.posDeviceProductCategories != null) {
      //   selectedCategoryList = [];

      //   for (SelectedCategory e
      //       in (editData?.posDeviceProductCategories ?? [])) {
      //     selectedCategoryList.add(
      //       SelectedCategory(
      //         id: e.id,
      //         productCategoryId: e.productCategoryId,
      //       ),
      //     );
      //   }
      //   categoryExpanded = true;
      // }
    }

    loading = false;
    notify;

    return editData != null;
  }

  List<String> deletedCategoryId = [];

  // List<String> findDeletedCategoryIds(
  //   List<SelectedCategory>? originalCategories,
  //   List<SelectedCategory>? currentStateProductCategories,
  // ) {
  //   if (originalCategories == null) return [];

  //   final deletedProductCategoryIds = <String>[];

  //   for (final originalCategory in originalCategories) {
  //     final matchingCategory = currentStateProductCategories?.firstWhere(
  //       (currentCategory) =>
  //           currentCategory.productCategoryId ==
  //           originalCategory.productCategoryId,
  //       orElse: () => SelectedCategory(),
  //     );

  //     if (matchingCategory?.productCategoryId == null) {
  //       if (originalCategory.id != null) {
  //         deletedProductCategoryIds.add(originalCategory.id!);
  //       }
  //     }
  //   }

  //   return deletedProductCategoryIds;
  // }

  Future<void> updateDeviceForPos({String? id}) async {
    if (id == null) return;
    loading = true;
    notify;

    await Handler.updateDevice4Pos(id: id);

    loading = false;
    notify;
  }

  Future<void> generateQr({String? deviceId}) async {
    loading = true;
    notify;

    await Handler.generateQRForPos(deviceId: deviceId);
    getData(page: pageIndex);

    loading = false;
    notify;
  }
  // Future<void> deleteDeviceForPos({String? id}) async {
  //   if (id == null) return;
  //   loading = true;
  //   notify;

  //   await Handler.deletePosDevice(id: id);

  //   loading = false;
  //   notify;
  // }
}

class SelectedCategory {
  String? id;
  String? productCategoryId;

  SelectedCategory({
    this.id,
    this.productCategoryId,
  });

  factory SelectedCategory.fromJson(Map<String, dynamic> json) =>
      SelectedCategory(
        id: json["id"],
        productCategoryId: json["productCategoryId"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "productCategoryId": productCategoryId,
      };
}
