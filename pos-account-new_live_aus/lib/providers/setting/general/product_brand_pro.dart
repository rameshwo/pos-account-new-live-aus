import 'package:flutter/material.dart';
import 'package:pos_account/ln.dart';
import 'package:pos_account/model/common/res_datum.dart';
import 'package:pos_account/model/common/setting_res.dart';
import 'package:pos_account/model/home/setting/general/brand/brand_req.dart';
import 'package:pos_account/model/home/setting/general/category/restro_table_model.dart';
import 'package:pos_account/model/ui_model/tablelist_model.dart';
import 'package:pos_account/repository/handler.dart';

class ProductBrandPro extends ChangeNotifier {
  static List<String> get _headerList => [LN.name, LN.status, LN.action];
  //product brands
  SettingRes? _getAllData;
  final tableList = RTableData(
    headerList: _headerList,
  );
  bool loading = true;

  int _page = 1;

  int get getPage => _page;

  set setPage(int val) {
    _page = val;
  }

  var tableData = <TLModel>[];

  final searchCltr = TextEditingController();

  String? uploadImageUrl;

  void init() {
    tableList.headerList = _headerList;
    tableData = <TLModel>[
      TLModel(title: LN.brandName, tableCltr: TextEditingController()),
      TLModel(title: LN.description, tableCltr: TextEditingController())
    ];
  }

  void clear() {
    itemId = "";
    _statusBrand = true;
    uploadImageUrl = null;
    for (var e in tableData) {
      e.tableCltr.clear();
    }
    searchCltr.clear();
  }

  String itemId = "";

  Future<void> getData({int page = 1}) async {
    setPage = page;
    _getAllData = await Handler.getProductBrands(
        page: page, searchKey: searchCltr.text.toLowerCase());
    if (_getAllData?.data != null) {
      tableList.tableDataList = [];

      for (var e in _getAllData!.data!) {
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
    notifyListeners();
  }

  SettingRes? get getPBrands => _getAllData;

  Future<void> addUpData() async {
    loading = true;
    notifyListeners();

    final req = BrandReq(
      id: itemId,
      name: tableData[0].tableCltr.text,
      description: tableData[1].tableCltr.text,
      isActive: getStatusBrand,
      isImageDeleted: uploadImageUrl == null,
    );
    final isAddSuccess = await Handler.addProductBrand(
      brandReq: req,
      filePath: uploadImageUrl ?? '',
    );
    loading = false;
    notifyListeners();
    if (isAddSuccess != null && isAddSuccess && _getAllData?.total != null) {
      clear();
      if (_getAllData!.total! - (getPage * 10) < 10) {
        await getData(page: getPage);
      }
    }
  }

  Future<bool?> editBrand(String id) async {
    loading = true;
    notify();
    final _editData = await Handler.editProdBrands(id: id);
    loading = false;
    notify();

    tableData[0].tableCltr.text = _editData?.name ?? '';
    tableData[1].tableCltr.text = _editData?.description ?? '';
    itemId = _editData?.id ?? '';
    uploadImageUrl = _editData?.imagePath;
    setStatusBrand = _editData?.isActive ?? false;

    return _editData != null;
  }

  Future<void> deleteData({required List<SRDatum> prodBrands}) async {
    final status =
        await Handler.deleteProductBrand(productCatsList: prodBrands);
    if (status != null && status) {
      for (var e in prodBrands) {
        tableList.tableDataList.removeWhere((f) => e.id == f.id);
      }
      notifyListeners();
    }
  }

  int _countSelectedBrands = 0;

  int get getCountSBrI => _countSelectedBrands;

  set setCountSBrI(int val) {
    _countSelectedBrands = val;
    notifyListeners();
  }

  bool _statusBrand = true;

  bool get getStatusBrand => _statusBrand;

  set setStatusBrand(bool val) {
    _statusBrand = val;
    notifyListeners();
  }

  void notify() {
    notifyListeners();
  }
}
