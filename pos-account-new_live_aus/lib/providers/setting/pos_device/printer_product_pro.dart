import 'package:flutter/material.dart';
import 'package:pos_account/model/home/product/setmenu/prod_by_prod_res.dart';
import 'package:pos_account/model/home/setting/pos_device/printer_product/printer_prod_detail_res.dart';
import 'package:pos_account/model/home/setting/pos_device/printer_product/printer_prod_req.dart';
import 'package:pos_account/model/home/setting/pos_device/set_up/printer_add_sec.dart';
import 'package:pos_account/repository/handler.dart';

class PrinterProductPro extends ChangeNotifier {
  void get notify => notifyListeners();

  bool loading = true;

  PrinterSetupAddSec? printAddSec;

  PrintProdDetailRes? printProdDetailRes;
  ProdByProdCatRes? productList;
  ProdByProdCatRes? subCatProdList;
  int printerIndex = 0;

  String? selectedCatId;
  int? selectedSubCatIndex = 0;
  List<PrintProdDetailRes> selectedList = [];
  final searchCltr = TextEditingController();
  final filterCltr = TextEditingController();

  Future<void> getData({
    required int printerIndex,
    bool isFromRecent = false,
  }) async {
    if (isFromRecent == true) {
      printAddSec = await Handler.getPrinterAddSec();
      if (printAddSec?.posPrinters != null) {
        selectedList = List.filled(
          printAddSec?.posPrinters?.length ?? 0,
          PrintProdDetailRes(),
        );
      }
    }
    if (printAddSec?.posPrinters == null ||
        (printAddSec!.posPrinters?.isEmpty ?? true)) {
      loading = false;
      notify;
      return;
    }

    getPrinterProdDetails(
      isFromRecent: isFromRecent,
      printerIndex: printerIndex,
    );
  }

  Future<void> getPrinterProdDetails({
    bool isFromRecent = false,
    int printerIndex = 0,
  }) async {
    if (isFromRecent) {
      loading = true;
      notify;
    }
    final req = PrintProdReq(
      printerId: printAddSec?.posPrinters?[printerIndex].id,
      printerName: printAddSec?.posPrinters?[printerIndex].name,
    );
    printProdDetailRes = await Handler.getPrinterProdDetails(req: req);

    if (selectedList.length <= printerIndex) {
      selectedList.addAll(List.generate(
        printerIndex - selectedList.length + 1,
        (_) => PrintProdDetailRes(),
      ));
      notify;
    }

    if (selectedList[printerIndex].printerId?.toLowerCase() ==
        printProdDetailRes?.printerId?.toLowerCase()) {
    } else {
      selectedList[printerIndex] = PrintProdDetailRes(
        printerId: printProdDetailRes?.printerId,
        printerName: printProdDetailRes?.printerName,
        printAllProductToKitchen: printProdDetailRes?.printAllProductToKitchen,
        productCategoryVariationList:
            printProdDetailRes?.productCategoryVariationList,
      );
    }
    productList == null ? await getAllProd() : null;
    loading = false;
    notify;
  }

  List<PrinterProductVariation>? allAssignedItems;

  Future<void> getAllAssignedProd({int? pIndex}) async {
    loading = true;
    notify;
    allAssignedItems = await Handler.getAllAssignedPrinterProducts(
      printerId: printAddSec?.posPrinters?[pIndex ?? printerIndex].id ?? '',
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

  bool buttonLoad = false;

  Future<void> addUpdate() async {
    loading = true;
    buttonLoad = true;
    notify;

    var req = selectedList.toList();
    req.removeWhere((element) => element.printerId == null);

    await Handler.addUpPrinterProdDetails(req: req);

    loading = false;
    buttonLoad = false;
    notify;
  }

  void clear() {
    loading = true;
    selectedCatId = null;
    printAddSec = null;
    selectedSubCatIndex = 0;
    printProdDetailRes = null;
    productList = null;
    buttonLoad = false;
    searchCltr.clear();
    filterCltr.clear();
    selectedList = [];
    printerIndex = 0;
  }
}
