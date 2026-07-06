import 'package:flutter/material.dart';
import 'package:pos_account/model/common/res_datum.dart';
import 'package:pos_account/model/home/product/feat_product/feat_prod_data.dart';
import 'package:pos_account/model/home/product/feat_product/get_all_feat_prod_res.dart';
import 'package:pos_account/model/home/product/new_product/adon_res.dart';
import 'package:pos_account/repository/handler.dart';

class FeaturedProductPro extends ChangeNotifier {
  void get notify => notifyListeners();
  bool screenLoad = true;

  // FeatProRes? featuredProducts;

  List<AdonRes>? adonSuggestion;
  final adonList = <AdonsModel>[];
  final adonTextCltr = TextEditingController();

  final selectedIds = <SRDatum>[];

  // int? orderTypeIndex;

  void clear() {
    adonList.clear();
    adonTextCltr.clear();
    adonSuggestion = null;
  }

  int pageIndex = 1;
  final _pageSize = 15;
  int _totalPage = 0;
  final featuredList = <FeatProdData>[];
  final searchCltr = TextEditingController();

  Future<void> getData({int page = 1}) async {
    if (page == 1 || pageIndex * _pageSize < _totalPage) {
      pageIndex = page;
      final data = await Handler.getAllFeatProds(
        page: page,
        pageSize: _pageSize,
        searchKey: searchCltr.text,
      );

      if (page == 1) {
        featuredList.clear();
      }
      if (data?.data != null) {
        _totalPage = data?.total ?? 0;
        featuredList.addAll(data!.data!);
      }
    }
    screenLoad = false;
    notify;
  }

  Future<void> getAdonSuggest({required String keyWord}) async {
    adonSuggestion = await Handler.getAllProductByStore(keyWord: keyWord);
    notify;
  }

  // void setData({required int i}) {
  //   clear();
  //   if (featuredProducts == null || featuredProducts!.data == null) return;
  //   final _data = featuredProducts!.data![i];
  //   adonList.add(AdonsModel(
  //     id: _data.id!,
  //     productId: _data.productId!,
  //     name: _data.name!,
  //   ));
  //   notifyListeners();
  // }

  Future<void> addData() async {
    final newData = <AddFeatProData>[];
    for (final e in adonList) {
      newData.add(AddFeatProData(
        id: e.id,
        productId: e.productId,
        name: e.name,
      ));
    }
    final status = await Handler.addUpFeatProd(dataList: newData);
    if (status != null && status) {
      clear();
      getData();
    }
  }

  Future<void> deleteData({required List<SRDatum> dataList}) async {
    final status = await Handler.deleteFeaturedProd(dataList: dataList);
    if (status != null && status) {
      selectedIds.clear();
      getData();
    }
  }

  // Future<void> editData({String? id}) async {
  //   if (id == null) return;

  //   await Handler.editFeatProd(reqId: id);
  // }
}

class AdonsModel {
  final String id;
  final String productId;
  final String name;

  AdonsModel({
    this.id = "",
    this.productId = "",
    this.name = "",
  });
}
