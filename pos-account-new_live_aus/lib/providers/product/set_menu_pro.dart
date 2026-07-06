import 'package:flutter/material.dart';
import 'package:oktoast/oktoast.dart';
import 'package:pos_account/config/utils/order_utils.dart';
import 'package:pos_account/ln.dart';
import 'package:pos_account/model/common/category.dart';
import 'package:pos_account/model/common/res_datum.dart';
import 'package:pos_account/model/home/product/setmenu/all_set_menu_res.dart';
import 'package:pos_account/model/home/product/setmenu/prod_by_prod_res.dart';
import 'package:pos_account/model/home/product/setmenu/set_menu_data.dart';
import 'package:pos_account/model/home/product/setmenu/setmenu_res.dart';
import 'package:pos_account/repository/handler.dart';
import 'package:pos_account/services/image/image_service.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class SetMenuPro extends ChangeNotifier {
  bool loading = true;

  SetMenuRes? setMenuRes;

  final nameCltr = TextEditingController();
  final descCltr = TextEditingController();
  final priceCltr = TextEditingController();
  final discountPerCltr = TextEditingController();
  final searcCltr = TextEditingController();

  int? taxTypeIndex;

  List<ProdByProdCatRes>? productList;

  final prodCatDesList = <ProdCatIdDes>[];

  // AllSetMenuRes? allSetMenuRes;

  SetMenuData? editSetMenu;

  final selectedIds = <SRDatum>[];

  bool activeStatus = true;

  void clear() {
    nameCltr.clear();
    descCltr.clear();
    priceCltr.clear();
    discountPerCltr.clear();
    // taxTypeIndex = null;
    _filePath = null;
    if (setMenuRes?.productCategories != null)
      for (var e in setMenuRes!.productCategories!) {
        e.isSelected = false;
      }
    productList = null;
    selectedIds.clear();
    prodCatDesList.clear();
    selectedSetCatId = null;
    editSetMenu = null;
    searcCltr.clear();
  }

  Future<void> getData() async {
    setMenuRes = await Handler.getAllSetMenuAS();
    loading = false;
    productList = null;
    setAddSec();
    notify();
  }

  void setAddSec() {
    if (setMenuRes?.salesTaxes != null &&
        setMenuRes!.salesTaxes!.any((e) => e.isSelected ?? false)) {
      taxTypeIndex =
          setMenuRes!.salesTaxes!.indexWhere((e) => e.isSelected ?? false);
    }

    if (setMenuRes?.filterCategories != null) {
      setCatList
          .addAll(OrderUtils.getCatList(setMenuRes!.filterCategories!) ?? []);
    }
  }

  Future<void> getAllProdByProd({required List<String> ids}) async {
    if (ids.isNotEmpty) {
      loading = true;
      notify();

      final list = await Handler.getAllProdBProd(ids: ids);

      if (list != null) {
        productList ??= [];

        final prevList = productList!.map((e) => e).toList();

        productList = prevList
            .where((e) => ids.contains(e.categoryId?.toLowerCase()))
            .toList();

        for (int i = 0; i < list.length; i++) {
          if (!prevList.any((a) =>
              a.categoryId?.toLowerCase() ==
              list[i].categoryId?.toLowerCase())) {
            productList!.add(list[i]);
          }
        }
      } else {
        productList = list;
      }
    } else {
      productList = null;
    }

    prodCatDesList.clear();
    if (productList != null) {
      for (var e in productList!) {
        prodCatDesList.add(ProdCatIdDes(
          id: e.categoryId,
          desCltr: TextEditingController(),
          countCltr: TextEditingController(),
        ));
      }
    }
    loading = false;
    notify();
  }

  bool addButtonLoad = false;

  Future<void> addUpSetMenu() async {
    if (taxTypeIndex == null) {
      showToast(LN.taxTypeIsEmpty);
      return;
    }
    final setMenu = SetMenuData()
      ..id = editSetMenu == null ? "" : editSetMenu!.id
      ..name = nameCltr.text
      ..description = descCltr.text
      ..price = priceCltr.text
      ..discountPercentage = discountPerCltr.text
      ..isActive = activeStatus
      ..salesTaxId = taxTypeIndex == null
          ? null
          : setMenuRes!.salesTaxes![taxTypeIndex!].id
      ..productCategoryId = selectedSetCatId
      ..productCatgories = prodCatDesList
          .map((e) => ProductCatgory(
                id: e.id,
                description: e.desCltr.text,
                maxItemCount: e.countCltr.text,
              ))
          .toList();

    final listOfProduct = <ProductVariationData>[];
    if (productList != null)
      for (final a in productList!) {
        for (final b in a.productVariations!) {
          if (a.productVariations != null) {
            if (b.isSelected) {
              final stock = double.tryParse(b.stockCount ?? '') ?? 0;
              listOfProduct.add(ProductVariationData(
                id: b.id,
                stockCount: stock != 0 ? b.customStock ?? '' : null,
              ));
            }
          }
        }
      }

    setMenu.productVariations ??= [];
    setMenu.productVariations!.addAll(listOfProduct);

    if (getFilePath != null &&
        getFilePath!.isEmpty &&
        editSetMenu?.imagePath != null &&
        editSetMenu!.imagePath!.isNotEmpty) {
      setMenu.isImageDeleted = true;
    }

    loading = true;
    addButtonLoad = true;
    notify();
    final status =
        await Handler.addUpSetMenu(setMenuData: setMenu, filePath: getFilePath);
    if (status != null && status) clear();
    loading = false;
    addButtonLoad = false;
    notify();
  }

  int _pageIndex = 1;

  int get getPage => _pageIndex;

  set setPage(int val) {
    _pageIndex = val;
  }

  bool setMenuScreenLoad = true;

  final refreshCltr = RefreshController(initialRefresh: false);
  int _totalPage = 0;
  static const int _pageSize = 15;
  final setMenuList = <AllSetMenuData>[];
  final searchCltr = TextEditingController();

  Future<void> getAllSetMenu({int page = 1}) async {
    if (page == 1 || _pageIndex * _pageSize < _totalPage) {
      setPage = page;
      final allSetMenuRes = await Handler.getAllSetMenu(
        page: page,
        pageSize: _pageSize,
        searchKey: searchCltr.text,
      );

      if (page == 1) {
        setMenuList.clear();
      }

      if (allSetMenuRes?.data != null) {
        _totalPage = allSetMenuRes?.total ?? 0;
        setMenuList.addAll(allSetMenuRes!.data!);
      }
    }
    setMenuScreenLoad = false;
    refreshCltr.loadComplete();
    refreshCltr.refreshCompleted();
    notify();
  }

  Future<void> editSetMenuData({required String id}) async {
    editSetMenu = await Handler.editSetMenu(id: id);
    await setData();
  }

  Future<void> setData() async {
    if (editSetMenu == null) {
      loading = false;
      notifyListeners();
      return;
    }

    nameCltr.text = editSetMenu!.name ?? '';
    descCltr.text = editSetMenu!.description ?? '';
    priceCltr.text = editSetMenu!.price ?? "";
    discountPerCltr.text = editSetMenu?.discountPercentage ?? '';
    activeStatus = editSetMenu!.isActive ?? false;
    if (setMenuRes == null) return;
    if (setMenuRes!.salesTaxes != null)
      taxTypeIndex = setMenuRes!.salesTaxes!.indexWhere(
          (e) => e.id?.toLowerCase() == editSetMenu!.salesTaxId?.toLowerCase());
    if (taxTypeIndex != null && taxTypeIndex! < 0) taxTypeIndex = null;
    _filePath = editSetMenu!.imagePath;

    final ids = editSetMenu!.productCatgories!.map((e) => e.id!).toList();
    await getAllProdByProd(ids: ids);

    if (editSetMenu!.productCatgories != null)
      for (final e in editSetMenu!.productCatgories!) {
        if (setMenuRes != null &&
            (setMenuRes?.productCategories?.any((f) => f.id == e.id) ?? false))
          setMenuRes?.productCategories
              ?.firstWhere((f) => f.id == e.id)
              .isSelected = true;
        if (prodCatDesList.isNotEmpty) {
          prodCatDesList.firstWhere((g) => g.id == e.id)
            ..desCltr.text = (e.description ?? '')
            ..countCltr.text = e.maxItemCount?.toString() ?? '';
        }
      }

    if (productList != null && editSetMenu!.productVariations != null)
      for (final a in productList!) {
        for (final b in editSetMenu!.productVariations!) {
          if (a.productVariations!
              .map((c) => c.id?.toLowerCase())
              .contains(b.id?.toLowerCase())) {
            a.productVariations!
                .firstWhere((d) => d.id?.toLowerCase() == b.id?.toLowerCase())
              ..isSelected = true
              ..customStock = b.stockCount;
          }
        }
      }
    selectedSetCatId = editSetMenu!.productCategoryId;

    loading = false;
    notifyListeners();
  }

  Future<void> deleteData({required List<SRDatum> dataList}) async {
    final status = await Handler.deleteSetMenu(dataList: dataList);
    if (status != null && status) {
      for (var e in dataList) {
        if (setMenuList.any((f) => e.id == f.id))
          setMenuList.removeWhere((f) => e.id == f.id);
      }
    }
  }

  //file picker section
  String? _filePath;
  String? get getFilePath => _filePath;

  set setFilepath(String? val) {
    _filePath = val;
  }

  void getFilePick() async {
    final file = await ImageService.filePick(
        showRemoveTile: getFilePath != null &&
            getFilePath!.isNotEmpty &&
            editSetMenu?.imagePath != null &&
            editSetMenu!.imagePath!.isNotEmpty);
    if (file != null) {
      setFilepath = file;
      notify();
    }
  }

  // setmenu category
  final setCatList = <Category>[];
  String? selectedSetCatId;

  void notify() {
    notifyListeners();
  }
}

class ProdCatIdDes {
  final String? id;
  final TextEditingController desCltr;
  final TextEditingController countCltr;

  ProdCatIdDes({
    this.id,
    required this.desCltr,
    required this.countCltr,
  });
}
