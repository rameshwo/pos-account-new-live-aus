import 'package:flutter/material.dart';
import 'package:pos_account/ln.dart';
import 'package:pos_account/model/common/table_location.dart';
import 'package:pos_account/model/home/product/setmenu/prod_by_prod_res.dart';
import 'package:pos_account/model/home/setting/general/category/restro_table_model.dart';
import 'package:pos_account/model/home/setting/general/docket/docket_req.dart';
import 'package:pos_account/model/home/setting/general/docket/docket_res.dart';
import 'package:pos_account/model/home/setting/general/docket/product_tag_docket.dart';
import 'package:pos_account/model/home/setting/general/docket/tag_product_docket_req.dart';
import 'package:pos_account/model/home/setting/pos_device/kd/pos_device_detail_res.dart';
import 'package:pos_account/model/home/setting/pos_device/printer_product/printer_prod_detail_res.dart';
import 'package:pos_account/model/ui_model/tablelist_model.dart';
import 'package:pos_account/repository/handler.dart';

class DocketGroupPro extends ChangeNotifier {
  void get notify => notifyListeners();

  static List<String> get _headerList =>
      [LN.name, LN.sortNo, LN.enDocGroupSpliter, LN.action];

  final tableList = RTableData(headerList: _headerList);

  bool loading = true;

  int pageIndex = 1;

  var tableData = <TLModel>[];

  DocketGroupRes? docketAllData;

  void init() {
    tableList.headerList = _headerList;
    tableData = <TLModel>[
      TLModel(title: LN.name, tableCltr: TextEditingController()),
      TLModel(
        title: LN.sortOrder,
        tableCltr: TextEditingController(),
        textInputType: TextInputType.number,
      ),
    ];
  }

  void clear() {
    itemId = "";
    enableDocketGroupSpliter = false;
    for (var e in tableData) {
      e.tableCltr.clear();
    }
    searchCltr.clear();
  }

  String itemId = "";

  bool enableDocketGroupSpliter = false;

  Future<void> getData({int page = 1}) async {
    pageIndex = page;
    docketAllData = await Handler.getAllDocketGroup(
        page: page, searchKey: searchCltr.text.toLowerCase());
    if (docketAllData?.data != null) {
      tableList.tableDataList = [];
      for (var e in docketAllData!.data!) {
        tableList.tableDataList.add(TableDataList(
          id: e.id!,
          itemList: [e.name ?? '', '${e.sortOrder ?? ''}'],
          statusList: [
            e.enableDocketGroupSpliter
                ? TableStatus.Active
                : TableStatus.Inactive,
          ],
        ));
      }
    }
    loading = false;
    notify;
  }

  Future<void> addUpData() async {
    loading = true;
    notifyListeners();

    final data = DocketGroupReq(
      id: itemId,
      name: tableData[0].tableCltr.text,
      sortOrder: int.tryParse(tableData[1].tableCltr.text),
      enableDocketGroupSpliter: enableDocketGroupSpliter,
    );

    final isAddSuccess = await Handler.addDocketGroup(dataList: [data]);

    loading = false;
    notifyListeners();

    if (isAddSuccess != null && isAddSuccess && docketAllData?.total != null) {
      clear();
      if (docketAllData!.total! - (pageIndex * 10) < 10) {
        await getData(page: pageIndex);
      }
    }
  }

  Future<bool?> getEditData({required String id}) async {
    loading = true;
    notify;

    final editData = await Handler.editDocketGroup(id: id);
    if (editData == null) return null;

    tableData[0].tableCltr.text = editData.name ?? '';
    tableData[1].tableCltr.text = editData.sortOrder?.toString() ?? '';
    enableDocketGroupSpliter = editData.enableDocketGroupSpliter;
    itemId = editData.id ?? "";

    loading = false;
    notify;
    return true;
  }

  //   Future<void> deleteData({required List<SRDatum> dataList}) async {
  //   final status = await Handler.deleteTaxIE(dataList: dataList);
  //   if (status != null && status) {
  //     for (var e in dataList) {
  //       getTableList.tableDataList.removeWhere((f) => e.id == f.id);
  //     }
  //     notifyListeners();
  //   }
  // }

  // tag products

  List<ProductTagToDocketRes>? productTagList;

  final selectedList = <PosDeviceDetailsRes>[];

  Future<void> tagProductAddSec(String? id) async {
    if (id == null) return;

    selectedList.clear();

    productTagList = await Handler.getProductTagToDocket(id: id);

    if (productTagList != null) {
      selectedList.add(PosDeviceDetailsRes(
          posDeviceId: id,
          productCategoryVariationList: productTagList
              ?.map((e) => ProductCategoryVariationList(
                    categoryId: e.categoryId,
                    productVariationIds: e.productIds,
                  ))
              .toList()));
    }
    await getParentCats();

    loading = false;
    notify;
  }

  List<TableLocation>? catList;

  String? selectedCatId;

  Future<void> getParentCats() async {
    catList = await Handler.getAllProdParentCats();
    if (catList?.isNotEmpty ?? false) {
      selectedCatId = catList?.first.id;

      await getAllAssignedProd(catId: selectedCatId);
    }
  }

  ProdByProdCatRes? productList;
  ProdByProdCatRes? subCatProdList;

  Future<void> getAllAssignedProd({String? catId}) async {
    if (catId == null) return;

    loading = true;
    notify;
    productList = await Handler.getAllProductByProductCat(id: catId);

    if (productList != null)
      subCatProdList = ProdByProdCatRes.fromJson(productList!.toJson());
    loading = false;
    notify;
  }

  int? selectedSubCatIndex = 0;

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

  bool buttonLoad = false;

  Future<void> updateDocketProducts() async {
    loading = true;
    buttonLoad = true;
    notify;

    final _selectedIds = <String>[];

    for (final a in selectedList) {
      if (a.productCategoryVariationList != null)
        for (final b in a.productCategoryVariationList!) {
          if (b.productVariationIds != null)
            _selectedIds.addAll(b.productVariationIds!);
        }
    }

    var req = TagProductToDocketReq(
      docketGroupId: selectedList.first.posDeviceId,
      productList: _selectedIds,
    );

    await Handler.tagProductToDocket(req: req);

    loading = false;
    buttonLoad = false;
    notify;
  }

  final searchCltr = TextEditingController();
  final filterCltr = TextEditingController();

  void clearAssignDia() {
    loading = false;
    productTagList = null;
    selectedSubCatIndex = 0;
    selectedCatId = null;
    productList = null;
    subCatProdList = null;
    buttonLoad = false;
    searchCltr.clear();
    filterCltr.clear();
    selectedList.clear();
    catList = null;
  }
}
