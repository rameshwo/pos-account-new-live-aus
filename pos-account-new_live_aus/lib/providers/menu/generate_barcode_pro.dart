import 'package:flutter/material.dart';
import 'package:pos_account/config/utils/order_utils.dart';
import 'package:pos_account/ln.dart';
import 'package:pos_account/model/common/category.dart';
import 'package:pos_account/model/home/product/gen_barcode/combo/combo_barcode_list.dart';
import 'package:pos_account/model/home/product/gen_barcode/combo/combo_barcode_print_req.dart';
import 'package:pos_account/model/home/product/gen_barcode/gen_bar_addsec.dart';
import 'package:pos_account/model/home/product/gen_barcode/gen_bar_print_res.dart';
import 'package:pos_account/model/home/product/gen_barcode/gen_barcode_print_req.dart';
import 'package:pos_account/model/home/product/gen_barcode/invoice_printer_detail.dart';
import 'package:pos_account/model/home/product/gen_barcode/retail_pos_poduct.dart';
import 'package:pos_account/model/home/setting/general/category/restro_table_model.dart';
import 'package:pos_account/repository/handler.dart';
import 'package:pos_account/screens/home_screen/com/items/tabs/product_tab/com/new_product/com/dialog/com/dialog/barcode_product_view.dart';
import 'package:pos_account/services/database/shared_pref.dart';
import 'package:pos_account/services/printer/com/barcode_qr_print.dart';

enum BarCodeType { Product, Combo }

class GenBarcodePro extends ChangeNotifier {
  void get notify => notifyListeners();

  String curSym = "";

  GenBarAddSec? barcodeAddSec;
  final categoryList = <Category>[];

  InvoicePrinterDetail? printerDetails;

  Future<void> getBarcodeSec() async {
    curSym = await SharedPrefs.curSym;
    barcodeAddSec = await Handler.genBarcodeAddSec();

    if (barcodeAddSec?.productCategories != null) {
      categoryList.addAll(
          OrderUtils.getCatList(barcodeAddSec?.productCategories) ?? []);
    }
    printerDetails = await Handler.getInvoicePrinterDetail();
  }

  ///[PRODUCTS]

  String? selectedCatId;
  int? brandIndex;
  final searchProdCltr = TextEditingController();
  bool pageLoad = true;
  int pageIndex = 1;
  int? productTypeIndex;

  static List<String> get _headerList => [
        LN.category,
        LN.brand,
        LN.product,
        "Product Type",
        "Item Code",
        LN.barcode,
        LN.action,
      ];

  final tableList = RTableData(
    headerList: _headerList,
    hasAction: false,
  );

  void init() {
    tableList.headerList = _headerList;
  }

  RetailPosProduct? barCodeTypeList;

  Future<void> getData({
    int page = 1,
  }) async {
    pageIndex = page;
    String _brandId = "";
    String _productTypeId = "";

    if (barcodeAddSec?.brands != null && brandIndex != null) {
      _brandId = barcodeAddSec?.brands?[brandIndex!].id ?? '';
    }

    if (barcodeAddSec?.productTypes != null && productTypeIndex != null) {
      _productTypeId = barcodeAddSec?.productTypes?[productTypeIndex!].id ?? '';
    }

    barCodeTypeList = await Handler.getRetailPosProduct(
      page: page,
      brandId: _brandId,
      searchText: searchProdCltr.text,
      categoryId: selectedCatId ?? '',
      productTypeId: _productTypeId,
    );
    if (barCodeTypeList?.data != null) {
      tableList.tableDataList = [];
      for (final e in barCodeTypeList!.data!) {
        tableList.tableDataList.add(
          TableDataList(
            id: e.id ?? '',
            itemList: [
              e.category ?? '',
              e.brand ?? '',
              e.productName ?? '',
              e.productType ?? '',
              e.code ?? '',
              e.barCodeNumber ?? ''
            ],
            statusList: [],
            actionWidget: GenBarCodeProductDia.actionWidget(
                req: BarcodePrintReq(id: e.id), type: BarCodeType.Product),
          ),
        );
      }
    }

    pageLoad = false;
    notify;
  }

  void productClear() {
    barcodeAddSec = null;
    pageLoad = true;
    pageIndex = 1;
    barCodeTypeList = null;
    categoryList.clear();
    selectedCatId = null;
    brandIndex = null;
    productTypeIndex = null;
    searchProdCltr.clear();
    tableList.tableDataList = [];
    bulkBarCode = null;
  }

  ///[BarcodePrint]

  bool productBarLoad = true;

  BarcodeLabelPrintViewModel? printData;
  final codeCltr = TextEditingController();
  final nameCltr = TextEditingController();
  final priceCltr = TextEditingController();
  final barcodeCltr = TextEditingController();
  final noOfPrintCltr = TextEditingController(text: "1");

  Future<void> barcodePrint({
    BarcodePrintReq? req,
    required BarCodeType type,
  }) async {
    if (type == BarCodeType.Product)
      printData = await Handler.barcodePrint(variationId: req?.id);
    else if (type == BarCodeType.Combo)
      printData = await Handler.barcodeComboPrint(req: req);

    codeCltr.text = printData?.productCode ?? '';
    nameCltr.text = printData?.productName ?? '';
    priceCltr.text = printData?.actualPrice ?? '';
    barcodeCltr.text = printData?.barCodeNumber ?? '';
    productBarLoad = false;
    notify;
    await Handler.getInvoicePrinterDetail();
  }

  void clearProd() {
    productBarLoad = true;
    printData = null;
    codeCltr.clear();
    nameCltr.clear();
    priceCltr.clear();
    barcodeCltr.clear();
    noOfPrintCltr.text = "1";
    printButtonLoad = false;
  }

  bool printButtonLoad = false;

  Future<void> printBarcode(BuildContext context,
      {Widget? captureWidget}) async {
    // printerDetails = [
    //   InvoicePrinterDetail(
    //       ipAddress: "192.168.1.100", port: "9100", printerType: "Ethernet")
    // ];

    printButtonLoad = true;
    productBarLoad = true;
    notify;

    // final imagePath = await ImageService.getTempImagePathFromKey(
    //     globalKey: globalKey, title: nameCltr.text);

    // if (imagePath == null) return;

    // final barcodeModel = ImagePrintModel(
    //   filePath: imagePath,
    //   height: 220,
    //   printCount: int.tryParse(noOfPrintCltr.text) ?? 1,
    //   isBarcode: true,
    // );

    final barcodeModel = await BarcodeQrPrint.capture(
        captureWidget: captureWidget,
        printCount: int.tryParse(noOfPrintCltr.text) ?? 1,
        isBarcode: true);

    if (barcodeModel == null) {
      printButtonLoad = false;
      productBarLoad = false;
      notify;
      return;
    }

    await BarcodeQrPrint.print(context,
        data: [barcodeModel], printerDetail: printerDetails);

    printButtonLoad = false;
    productBarLoad = false;
    notify;
  }

  GenBarcodePrintRes? bulkBarCode;

  Future<void> getBulkBarCode({
    required BarCodeType type,
  }) async {
    pageLoad = true;
    notify;

    if (type == BarCodeType.Product) {
      final data = tableList.tableDataList
          .where((e) => e.selected)
          .map((e) => GenBarcodePrintReq(productVariationId: e.id))
          .toList();

      bulkBarCode = await Handler.barcodePrintBulk(req: data);
    } else if (type == BarCodeType.Combo) {
      final data = tableList_2.tableDataList
          .where((e) => e.selected)
          .map((e) => BarcodePrintReq(id: e.id, name: e.itemList[1]))
          .toList();

      bulkBarCode = await Handler.barcodeComboPrintBulk(req: data);
    }

    pageLoad = false;
    notify;
  }

  Future<void> printBulkBarcode(BuildContext context) async {
    if (bulkBarCode?.barcodeLabelPrintViewModels == null) return;

    final dataList = <ImagePrintModel>[];

    printButtonLoad = true;
    pageLoad = true;
    notify;

    for (final e in bulkBarCode!.barcodeLabelPrintViewModels!) {
      final barcodeModel = await BarcodeQrPrint.capture(
        captureWidget: e.captureWidget,
        printCount: 1,
        isBarcode: true,
      );
      if (barcodeModel != null) {
        dataList.add(barcodeModel);
      }

      // final imagePath = await ImageService.getTempImagePathFromKey(
      //     globalKey: e.globalKey, title: e.productName ?? '');
      // if (imagePath != null) {
      //   dataList.add(ImagePrintModel(
      //     height: 220,
      //     printCount: 1,
      //     filePath: imagePath,
      //     isBarcode: true,
      //   ));
      // }
    }

    await BarcodeQrPrint.print(context,
        data: dataList, printerDetail: printerDetails);
    printButtonLoad = false;
    pageLoad = false;
    notify;
  }

  ///[COMBO]
  static List<String> get _headerList_2 =>
      [LN.category, LN.name, "Item Code", LN.barcode, LN.action];

  final tableList_2 = RTableData(
    headerList: _headerList_2,
    hasAction: false,
  );

  void init_2() {
    tableList_2.headerList = _headerList_2;
  }

  RetailPosComboBarcodeRes? barCodeTypeList_2;
  bool pageLoad_2 = true;
  int pageIndex_2 = 1;

  Future<void> getData_2({
    int page = 1,
  }) async {
    pageIndex_2 = page;

    barCodeTypeList_2 = await Handler.getRetailPosCombo(
      page: page,
    );
    if (barCodeTypeList_2?.data != null) {
      tableList_2.tableDataList = [];
      for (final e in barCodeTypeList_2!.data!) {
        tableList_2.tableDataList.add(
          TableDataList(
            id: e.id ?? '',
            itemList: [
              e.category ?? '',
              e.name ?? '',
              e.code ?? '',
              e.barCodeNumber ?? ''
            ],
            statusList: [],
            actionWidget: GenBarCodeProductDia.actionWidget(
                req: BarcodePrintReq(id: e.id, name: e.name),
                type: BarCodeType.Combo),
          ),
        );
      }
    }

    pageLoad_2 = false;
    notify;
  }

  void comboClear() {
    pageLoad_2 = true;
    pageIndex_2 = 1;
    barCodeTypeList_2 = null;
    tableList_2.tableDataList = [];
    bulkBarCode = null;
  }
}
