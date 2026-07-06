import 'package:flutter/material.dart';
import 'package:pos_account/model/common/category.dart';
import '../../model/home/setting/all_setting.dart';
import '../../repository/handler.dart';

class SettingProvider extends ChangeNotifier {
  AllSettings? _allSettings;
  bool loading = true;

  void get notify => notifyListeners();

  Future<void> getAllSetting() async {
    _allSettings = await Handler.getAllSetting();
    loading = false;
    notifyListeners();
  }

  AllSettings? get allSetting => _allSettings;

  //drop down setting

  // selected category index
  int? _sCatTypeIndex;
  int? get getSCatTypeIndex => _sCatTypeIndex;

  set setSCatTypeIndex(int? val) {
    _sCatTypeIndex = val;
    notifyListeners();
  }

  // selected category index
  int? _sCatIndex;
  int? get getSCatIndex => _sCatIndex;

  set setSCatIndex(int? val) {
    _sCatIndex = val;
    notifyListeners();
  }

  // selected sub category index
  int? _sSubCatIndex;
  int? get getSubCatIndex => _sSubCatIndex;

  set setSubCatIndex(int? val) {
    _sSubCatIndex = val;
    notifyListeners();
  }

  // selected brand index
  int? _sBrandIndex;
  int? get getSBrandIndex => _sBrandIndex;

  set setSBrandIndex(int? val) {
    _sBrandIndex = val;
    notifyListeners();
  }

  // selected table location index
  int? _sTLIndex;
  int? get getSTLIndex => _sTLIndex;

  set setSTLIndex(int? val) {
    _sTLIndex = val;
    notifyListeners();
  }

  int? barCodeTypeIndex;

  int? docketGroupIndex;

  // selected table location index
  int? _sTNoIndex;
  int? get getSTNoIndex => _sTNoIndex;

  set setSTNoIndex(int? val) {
    _sTNoIndex = val;
    notifyListeners();
  }

  // selected order type index
  // int? _ssOTIndex;
  // int? get getsOTIndex => _ssOTIndex;

  // set setsOTIndex(int? val) {
  //   _ssOTIndex = val;
  //   notifyListeners();
  // }

  String? selectedOrderTypeId;

  List<Category>? get getOrderTypeList {
    if (allSetting?.orderTypes == null) return null;

    return List<Category>.generate(allSetting!.orderTypes!.length, (i) {
      final a = allSetting!.orderTypes![i];
      return Category(
          categoryName: a.channelName,
          childernCategories: a.orderTypes == null
              ? null
              : List<Category>.generate(a.orderTypes!.length, (j) {
                  final b = a.orderTypes![j];
                  return Category(
                    categoryId: b.id,
                    categoryName: b.value,
                  );
                }));
    });
  }

  // selected tax index
  // int? _ssTaxIndex;
  // int? get getsTaxIndex => _ssTaxIndex;

  // set setsTaxIndex(int? val) {
  //   _ssTaxIndex = val;
  //   notifyListeners();
  // }

  String? selectedTaxTypeId;

  List<Category>? get getTaxTypeList {
    if (allSetting?.taxTypes == null) return null;

    return List<Category>.generate(allSetting!.taxTypes!.length, (i) {
      final a = allSetting!.taxTypes![i];
      return Category(
          categoryName: a.taxType,
          childernCategories: a.taxes == null
              ? null
              : List<Category>.generate(a.taxes!.length, (j) {
                  final b = a.taxes![j];
                  return Category(
                    categoryId: b.id,
                    categoryName: b.value,
                  );
                }));
    });
  }

// setting page index
  int _settingPageIndex = 1;
  int get getSPTabIndex => _settingPageIndex;

  set setSPTabIndex(int val) {
    _settingPageIndex = val;
    notifyListeners();
  }
}
