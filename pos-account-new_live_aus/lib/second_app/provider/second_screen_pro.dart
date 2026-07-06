import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:pos_account/config/utils/order_utils.dart';
import 'package:pos_account/model/ui_model/amount_class.dart';
import 'package:pos_account/second_app/model/call_back_model.dart';

class SecondScreenPro {
  // void get notify => notifyListeners();

  ScrollController? scrollCltr;

  // data list

  CallBackModel cbm = CallBackModel();

  String get curSym => cbm.curSym;
  bool get isPaymentScreen => cbm.isPaymentScreen;

  // TODO: tax percent

  AmountClass get getAmount => AmountClass(
        totalPrice: cbm.totalAmount,
        taxType: cbm.taxType,
        itemPrice: cbm.itemPrice,
        totalTax: cbm.taxAmount,
        // taxPercent: cbm.taxPercent,
      );

  // ads pattern
  AdsPattern? adsPattern;
  List<String> screenSaverImages = [];
  //
  void _setAdsPattern(AdsPattern? newPattern) {
    adsPattern ??= newPattern;
    // log(newPattern?.pattern?.name ?? '_');

    if (adsPattern != null && newPattern != null) {
      if (adsPattern!.toJson().toString().length !=
          newPattern.toJson().toString().length) {
        // log('pattern update');
        adsPattern = AdsPattern.fromJson(newPattern.toJson())
          ..adProductData = adsPattern?.adProductData;
      }
    }
  }

  void _setScreeSaverImage(List<String> newImages) {
    if (screenSaverImages.toString().length != newImages.toString().length) {
      screenSaverImages = newImages;
    }
  }

  // set all data
  Future<void> callback(dynamic data, {required Function() load}) async {
    try {
      if (data != null && data is String) {
        final data0 = json.decode(data);
        final newData = CallBackModel.fromJson(data0);

        final latestProduct = _getLatestProduct(newData);

        cbm = newData;

        //
        _setAdsPattern(cbm.adsPattern);
        _setScreeSaverImage(cbm.screenImageList);
        //
        if (adsPattern != null && latestProduct != null) {
          adsPattern!.adProductData = latestProduct;
        }

        OrderUtils.statusList ??= cbm.statusList;
        //
        load();
        // WidgetsBinding.instance?.addPostFrameCallback((_) => load());
        //
        // if (scrollCltr != null &&
        //     scrollCltr!.hasClients &&
        //     scrollCltr?.offset != cbm.scrollValue) {
        //   await scrollCltr!.animateTo(cbm.scrollValue,
        //       duration: Duration(milliseconds: 400), curve: Curves.easeInOut);
        // }
      } else {
        // showToast("81: second_screen_pro:$data");
      }
    } catch (e) {
      // showToast("82: second_screen_pro:$e");
    }
  }

  AdProductData? _getLatestProduct(CallBackModel newCbm) {
    AdProductData? _data;
    if (cbm.orderList.length < newCbm.orderList.length) {
      final _oD = newCbm.orderList.first;
      _data = AdProductData(
        productId: _oD.productId,
        productName: _oD.productName,
        image: _oD.imgPath,
        quantity: _oD.quantity.toString(),
        price: "$curSym${_oD.productPrice}",
      );
    } else if (cbm.setMenuList.length < newCbm.setMenuList.length) {
      final _sMD = newCbm.setMenuList.first;
      _data = AdProductData(
        productId: _sMD.setMenuId,
        productName: _sMD.setMenuName,
        image: _sMD.imgPath,
        quantity: _sMD.setMenuQuantity.toString(),
        price: "$curSym${_sMD.setMenuPrice}",
      );
    } else if (cbm.ingreList.length < newCbm.ingreList.length) {
      final _rID = newCbm.ingreList.first;
      _data = AdProductData(
        productId: _rID.rawIngredientId,
        productName: _rID.name,
        // image: _rID.imgPath,
        quantity: _rID.quantity.toString(),
        price: "$curSym${_rID.originalSellingPricePerUnit}",
      );
    }

    return _data;
  }

  bool get isThereItem =>
      cbm.orderList.isNotEmpty ||
      cbm.setMenuList.isNotEmpty ||
      cbm.ingreList.isNotEmpty;
}
