import 'package:flutter/material.dart';
import '../../model/home/product/new_product/sort_product_res.dart';
import '../../model/home/product/setmenu/prod_by_prod_res.dart';
import '../../repository/handler.dart';

class ManageProdPro extends ChangeNotifier {
  void get notify => notifyListeners();

  bool loading = true;

  String? selectedCatId;

  Future<void> getParentCats() async {
    loading = true;
    notify;
    final _catList = await Handler.getAllProdParentCats();
    if (_catList?.isNotEmpty ?? false) {
      selectedCatId = _catList?.first.id;

      await getAllAssignedProd(catId: selectedCatId);
    }

    sortedDataList.clear();

    if (_catList != null) {
      for (int i = 0; i < _catList.length; i++) {
        final _catData = GetSortProductRes(
          id: _catList[i].id,
          sort: "${i + 1}",
          name: _catList[i].name,
          sortOrders: [],
        );
        sortedDataList.add(_catData);
      }
    }

    catSort();

    loading = false;
    notify;
  }

  ProdByProdCatRes? productList;

  Future<void> getAllAssignedProd({String? catId}) async {
    if (catId == null) return;

    loading = true;
    notify;
    productList = await Handler.getAllProductByProductCat(id: catId);

    final _sortOrderList = await Handler.getSortProductByCats(id: catId);

    _sortProductResponse(response: productList, sortList: _sortOrderList);

    loading = false;
    notify;
  }

  bool updateButtonLoad = false;

  final sortedDataList = <GetSortProductRes>[];

  void catSort() {
    for (int i = 0; i < sortedDataList.length; i++) {
      sortedDataList[i].sort = "${i + 1}";
    }
  }

  void productSort() {
    if (productList?.productVariations != null &&
        sortedDataList.any((a) =>
            a.id?.toLowerCase() == productList?.categoryId?.toLowerCase())) {
      final _catData = sortedDataList.firstWhere(
          (a) => a.id?.toLowerCase() == productList?.categoryId?.toLowerCase());

      _catData.isProdSorted = true;

      for (int i = 0; i < productList!.productVariations!.length; i++) {
        _catData.sortOrders!.add(SortOrder(
          id: productList!.productVariations![i].id,
          sort: "${i + 1}",
        ));
      }
    }
  }

  Future<void> updateOrder() async {
    //

    loading = true;
    updateButtonLoad = true;
    notify;

    await Handler.updateSortProductByCats(data: sortedDataList);
    await getParentCats();

    loading = false;
    updateButtonLoad = false;
    notify;
  }

  void clear() {
    loading = true;
    selectedCatId = null;
    productList = null;
    isAToZ = true;
    sortedDataList.clear();
  }

  bool isAToZ = true;

  void sortAlpha() {
    isAToZ = !isAToZ;

    final list = productList?.productVariations;
    if (list == null || list.isEmpty) return;

    list.sort((a, b) {
      final nameA = (a.name ?? '').toLowerCase();
      final nameB = (b.name ?? '').toLowerCase();

      return isAToZ ? nameA.compareTo(nameB) : nameB.compareTo(nameA);
    });

    productSort();

    notify;
  }

  ProdByProdCatRes? _sortProductResponse({
    required ProdByProdCatRes? response,
    required List<GetSortProductRes>? sortList,
  }) {
    final products = response?.productVariations;

    // Create lookup map
    final Map<String, int> sortMap = {};

    if ((sortList?.isNotEmpty ?? false) && sortList!.first.sortOrders != null) {
      for (var item in sortList.first.sortOrders!) {
        final key =
            "${item.id?.toLowerCase()}_${sortList.first.id?.toLowerCase()}";
        sortMap[key] = int.tryParse(item.sort!) ?? 9999;
      }
    }

    // Sort only productList
    if (products != null) {
      products.sort((a, b) {
        final keyA =
            "${a.id?.toLowerCase()}_${a.productCategoryId?.toLowerCase()}";
        final keyB =
            "${b.id?.toLowerCase()}_${b.productCategoryId?.toLowerCase()}";

        final orderA = sortMap[keyA] ?? 9999;
        final orderB = sortMap[keyB] ?? 9999;

        return orderA.compareTo(orderB);
      });
    }

    // Return same response structure with sorted productList
    return response;
  }
}
