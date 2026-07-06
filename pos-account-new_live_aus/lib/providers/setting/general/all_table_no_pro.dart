import 'package:flutter/material.dart';
import 'package:pos_account/ln.dart';
import 'package:pos_account/model/common/res_datum.dart';
import 'package:pos_account/model/home/product/gen_barcode/invoice_printer_detail.dart';
import 'package:pos_account/model/home/setting/general/category/pro_cat_image.dart';
import 'package:pos_account/model/home/setting/general/category/restro_table_model.dart';
import 'package:pos_account/model/home/setting/general/table_number/au_table_list.dart';
import 'package:pos_account/model/home/setting/general/table_number/all_table_asl.dart';
import 'package:pos_account/model/home/setting/general/table_number/all_table_res.dart';
import 'package:pos_account/model/home/setting/general/table_number/table_qr.dart';
import 'package:pos_account/model/ui_model/tablelist_model.dart';
import 'package:pos_account/repository/handler.dart';

class AllTableNumPro extends ChangeNotifier {
  static List<String> get _headerList =>
      [LN.name, LN.adult, LN.child, LN.status, LN.action];
  //all table number
  GaTableAsl? tableAddSecList;
  String? selectedTImgId;

  int? tableLocIndex;

  AllTableRes? _getAllData;
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

  void clear() {
    itemId = "";
    _status = true;
    selectedTImgId = null;
    if (imageList != null)
      for (final e in imageList!) {
        e.isDefaultImage = false;
      }
    tableLocIndex = null;
    for (var e in tableData) {
      e.tableCltr.clear();
    }
    searchCltr.clear();
  }

  String itemId = "";
  List<ProductCategoriesImage>? imageList;

  InvoicePrinterDetail? printerDetails;

  void init() {
    _tableList.headerList = _headerList;
    tableData = <TLModel>[
      TLModel(
        title: LN.name,
        tableCltr: TextEditingController(),
      ),
      TLModel(
        title: LN.adultCapacity,
        tableCltr: TextEditingController(),
        textInputType: TextInputType.number,
      ),
      TLModel(
        title: LN.childCapacity,
        tableCltr: TextEditingController(),
        textInputType: TextInputType.number,
      ),
      TLModel(
        title: LN.description,
        tableCltr: TextEditingController(),
      )
    ];
  }

  Future<void> getAddSecData() async {
    tableAddSecList = await Handler.getAllTableAddSecList();
    if (tableAddSecList?.tableImageList != null) {
      imageList = tableAddSecList!.tableImageList!
          .map((e) => ProductCategoriesImage(
                id: e.id,
                name: e.name,
                imageUrl: e.image,
                isDefaultImage: false,
              ))
          .toList();
    }
    notifyListeners();
    printerDetails = await Handler.getInvoicePrinterDetail();
  }

  set selectImageId(String? id) {
    selectedTImgId = id;
    notifyListeners();
  }

  final searchCltr = TextEditingController();

  Future<void> getData({int page = 1}) async {
    setPage = page;
    loading = true;
    notifyListeners();
    _getAllData = await Handler.getAllTableNum(
        page: page, searchKey: searchCltr.text.toLowerCase());
    if (_getAllData?.data != null) {
      _tableList.tableDataList = [];
      for (var e in _getAllData!.data!) {
        _tableList.tableDataList.add(TableDataList(
          id: e.id!,
          itemList: [
            e.name!,
            e.adultCapacity,
            e.childCapacity,
            e.tableQrImageUrl ?? ''
          ],
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

  AllTableRes? get getTableData => _getAllData;

  RTableData get getTableList => _tableList;

  bool btnLoading = false;

  Future<void> addUpData({required List<AllTableNoList> allTableNoL}) async {
    btnLoading = true;
    notifyListeners();

    final isAddSuccess = await Handler.addUpdateTableNum(
      tableList: allTableNoL,
    );

    btnLoading = false;
    notifyListeners();
    if (isAddSuccess != null && isAddSuccess && _getAllData!.total != null) {
      if (_getAllData!.total! - (getPage * 10) < 10) {
        await getData(page: getPage);
      }
    }
  }

  Future<void> deleteData({required List<SRDatum> dataList}) async {
    final status = await Handler.deleteTablesNum(dataList: dataList);
    if (status != null && status) {
      for (var e in dataList) {
        getTableList.tableDataList.removeWhere((f) => e.id == f.id);
      }
      notifyListeners();
    }
  }

  Future<bool?> getEditData({required String id}) async {
    final editTable = await Handler.editTable(id: id);
    if (editTable != null) {
      itemId = editTable.id ?? '';
      tableData[0].tableCltr.text = editTable.name ?? '';
      tableData[1].tableCltr.text = editTable.adultCapacity ?? '';
      tableData[2].tableCltr.text = editTable.childCapacity ?? '';
      tableData[3].tableCltr.text = editTable.description ?? '';
      setStatus = editTable.isActive ?? false;

      if (tableAddSecList != null && tableAddSecList!.tableLocations != null)
        tableLocIndex = tableAddSecList!.tableLocations!
            .indexWhere((e) => e.id == editTable.tableLocationId);

      if (imageList != null)
        for (final e in imageList!) {
          if (e.id == editTable.tableImageId) {
            e.isDefaultImage = true;
          } else {
            e.isDefaultImage = false;
          }
        }

      selectImageId = editTable.tableImageId;
      return true;
    }
    return false;
  }

  int _countSelected = 0;

  int get getCountSelected => _countSelected;

  set setCountSelected(int val) {
    _countSelected = val;
    notifyListeners();
  }

  bool _status = true;

  bool get getStatus => _status;

  set setStatus(bool val) {
    _status = val;
    notifyListeners();
  }

  Future<void> generateQr({required String tableId}) async {
    loading = true;
    notify();

    await Handler.generateQR4table(tableId: tableId);

    loading = false;
    notify();
  }

  List<TableQr>? tableQrList;

  Future<void> getTableQr({required String tableId}) async {
    loading = true;
    notify();

    tableQrList = await Handler.getTableQr(tableId: tableId);

    loading = false;
    notify();
  }

  void notify() {
    notifyListeners();
  }
}
