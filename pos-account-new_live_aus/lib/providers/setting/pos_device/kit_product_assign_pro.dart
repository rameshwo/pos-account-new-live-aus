import 'package:flutter/material.dart';
import 'package:pos_account/model/home/product/setmenu/prod_by_prod_res.dart';
import 'package:pos_account/model/home/setting/pos_device/kd/pos_device_detail_res.dart';
import 'package:pos_account/model/home/setting/pos_device/set_up/printer_add_sec.dart';
import 'package:pos_account/repository/handler.dart';

class KitProdAssignPro extends ChangeNotifier {
  void get notify => notifyListeners();

  bool loading = true;

  PrinterSetupAddSec? printAddSec;

  PosDeviceDetailsRes? posDeviceDetailsRes;

  List<PosDeviceDetailsRes> selectedList = [];

  ProdByProdCatRes? productList;
  String? selectedCatId;
  ProdByProdCatRes? subCatProdList;

  int? selectedSubCatIndex = 0;

  final searchCltr = TextEditingController();
  final filterCltr = TextEditingController();

  bool buttonLoad = false;

  int selectedIndex = 0;

  Future<void> getData({
    required int index,
  }) async {
    // if (printAddSec?.posPrinters == null ||
    //     (printAddSec!.posPrinters?.isEmpty ?? true)) {
    //   loading = false;
    //   notify;
    //   return;
    // }

    posDeviceDetailsRes = await Handler.getPosDeviceSetupDetails(
      id: printAddSec?.posDevices?[index].id,
      name: printAddSec?.posDevices?[index].name,
    );

    if (selectedList.length <= index) {
      selectedList.addAll(List.generate(
        index - selectedList.length + 1,
        (_) => PosDeviceDetailsRes(),
      ));
      notify;
    }

    if (selectedList[index].posDeviceId?.toLowerCase() ==
        posDeviceDetailsRes?.posDeviceId?.toLowerCase()) {
    } else {
      selectedList[index] = PosDeviceDetailsRes(
        posDeviceId: posDeviceDetailsRes?.posDeviceId,
        posDeviceName: posDeviceDetailsRes?.posDeviceName,
        sendAllProductToKitchenDisplay:
            posDeviceDetailsRes?.sendAllProductToKitchenDisplay,
        productCategoryVariationList:
            posDeviceDetailsRes?.productCategoryVariationList,
      );
    }

    productList == null ? await getAllProd() : null;

    loading = false;
    notify;
  }

  Future<void> getAllProd() async {
    if (printAddSec?.categories == null || printAddSec!.categories!.isEmpty)
      return;
    final _id = selectedCatId ?? printAddSec?.categories?.first.id;
    if (_id == null) return;
    selectedCatId ??= _id;

    await getAllProd2(id: _id);
  }

  Future<void> getAllProd2({String id = ""}) async {
    loading = true;
    notify;

    productList = await Handler.getAllVarByCat(id: id);
    if (productList != null)
      subCatProdList = ProdByProdCatRes.fromJson(productList!.toJson());
    loading = false;
    notify;
  }

  List<PrinterProductVariation>? allAssignedItems;

  Future<void> getAllAssignedProd({int? pIndex}) async {
    if (printAddSec?.posPrinters == null || printAddSec!.posPrinters!.isEmpty)
      return;
    loading = true;
    notify;
    allAssignedItems = await Handler.getAllAssignedPrinterProducts(
      printerId: printAddSec?.posPrinters?[pIndex ?? selectedIndex].id ?? '',
    );
    loading = false;
    notify;
  }

  onTapSubCategory(int index) {
    selectedSubCatIndex = index;
    if (index == 0) {
      subCatProdList?.productVariations = productList?.productVariations;
      notify;
      return;
    }
    subCatProdList?.productVariations = productList?.productVariations
        ?.where(
          (element) =>
              element.productCategoryId?.toLowerCase() ==
              productList?.subCategories?[index - 1].id?.toLowerCase(),
        )
        .toList();
    notify;
  }

  Future<void> addUpdate() async {
    loading = true;
    buttonLoad = true;
    notify;

    var req = selectedList.toList();
    req.removeWhere((element) => element.posDeviceId == null);

    await Handler.addUpPosDeviceDetails(req: req);

    loading = false;
    buttonLoad = false;
    notify;
  }

  void clear() {
    loading = true;
    selectedCatId = null;
    printAddSec = null;
    selectedSubCatIndex = 0;
    posDeviceDetailsRes = null;
    productList = null;
    buttonLoad = false;
    searchCltr.clear();
    filterCltr.clear();
    selectedList = [];
    selectedIndex = 0;
  }
}
