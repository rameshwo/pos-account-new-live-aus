import 'dart:convert';
import 'package:pos_account/config/utils/order_utils.dart';
import 'package:pos_account/config/utils/utils.dart';
import 'package:pos_account/config/validator.dart';
import 'package:pos_account/ln.dart';
import 'package:pos_account/model/ui_model/amount_class.dart';
import 'package:pos_account/providers/menu/payment_pro.dart';
import 'package:pos_account/providers/menu/place_order_pro.dart';
import 'package:pos_account/providers/screen_saver/screen_saver_pro.dart';
import 'package:pos_account/screens/home_screen/com/items/sidebar/order_section/com/order_detail_sec.dart';
import 'package:pos_account/screens/home_screen/com/items/sidebar/sidebar_section/com/order_items.dart';
import 'package:pos_account/second_app/model/call_back_model.dart';
import 'package:pos_account/services/database/shared_pref.dart';
import 'package:presentation_displays/display.dart';
import 'package:presentation_displays/displays_manager.dart';
import 'package:provider/provider.dart';
import '../../second_app/second_splash_screen.dart';
import 'file_path_config.dart';

class DualDisplayConfig {
  static final displayManager = DisplayManager();
  static final displays = <Display>[];
  //
  static late PlaceOrderPro _placePro;
  static late PaymentPro _payPro;
  static late ScreenSaverPro _screenSaverPro;

  // remove it later dual screen
  // static late SecondScreenPro _secondPro;

  // pattern show
  static DualDisPattern _pattern = DualDisPattern.none;
  static AdsPattern? adsPattern;

  static Future<void> init() async {
    // final _permissionStatus = await Permission.systemAlertWindow.status;

    // if (!_permissionStatus.isGranted) {
    //   await Permission.systemAlertWindow.request();
    // }

    try {
      await getSetPattern();

      if (CUS_CTX != null) {
        _placePro = Provider.of<PlaceOrderPro>(CUS_CTX!, listen: false);
        _payPro = Provider.of<PaymentPro>(CUS_CTX!, listen: false);
        _screenSaverPro = Provider.of<ScreenSaverPro>(CUS_CTX!, listen: false);

        //
        // _secondPro = Provider.of<SecondScreenPro>(CUS_CTX!, listen: false);
      }

      final values = await displayManager.getDisplays();
      displays.clear();
      if (values != null) displays.addAll(values);
      await show();
      await Future.delayed(Duration(seconds: 1), () async {
        await sendData();
        _listenToScroll();
      });
    } catch (e) {
      // showToast("55: dual_dis_config:$e");
    }
  }

  static Future<void> getSetPattern() async {
    try {
      final stringPattern = await SharedPrefs.dualDisPattern;
      if (DualDisPattern.values.any((e) => e.name == stringPattern)) {
        _pattern =
            DualDisPattern.values.firstWhere((e) => e.name == stringPattern);
      }

      adsPattern = AdsPattern(
        pattern: _pattern,
        imagePathList: await FilePathConfig.getImageData,
        videoPath: await FilePathConfig.getVideoData,
      );
    } catch (e) {
      // showToast("73: dual_dis_config:$e");
    }
  }

  static Future<void> show() async {
    if (displays.any((e) => e.a == "1"))
      await displayManager.showSecondaryDisplay(
          displayId: "1", routerName: SecondSplashScreen.routeName);
    else if (displays.isNotEmpty)
      await displayManager.showSecondaryDisplay(
          displayId: displays.last.a, routerName: SecondSplashScreen.routeName);
  }

  static Future<void> sendData({
    bool isPayScreen = false,
    String? qrImage,
  }) async {
    // if (_placePro.orderList.isEmpty &&
    //     _placePro.setMenuList.isEmpty &&
    //     _placePro.ingreList.isEmpty) return;

    try {
      CallBackModel? callBack;

      if (isPayScreen) {
        final amount = _payPro.getAllAmount;

        callBack = CallBackModel(
          curSym: _payPro.curSym ?? '',
          isPaymentScreen: true,
          discountAmount: amount.taxType == TaxType.Inclusive
              ? amount.discountWithTax.roundToNString()
              : amount.discount.roundToNString(),
          discountPercent: _payPro.discountPercentCltr.text,
          pubSurAmount: amount.pHSurCharge.roundToNString(),
          creSurPercent: _payPro.creCardCltr.text,
          sCPercent: _payPro.serviceChargePerCltr.text,
          serviceChargeAmount: amount.serviceCharge.roundToNString(),
          creSurAmount: amount.ccSurCharge.roundToNString(),
          isDelivery: _payPro.isDeliveryCheck,
          delivertAmtText: _payPro.deliveryTextCltr.text,
          orderList: _payPro.orderList,
          setMenuList: _payPro.setMenuList,
          ingreList: _payPro.ingreList,
          itemPrice: amount.itemPrice,
          // taxPercent: _payPro.taxPercentDDS,
          taxAmount: amount.totalTax,
          totalAmount: amount.totalPrice,
          taxType: amount.taxType,
          scrollValue: OrderDetailSec.scrollCltr.hasClients
              ? OrderDetailSec.scrollCltr.offset
              : 0.0,
          adsPattern: adsPattern,
          screenImageList: _screenSaverPro.screenImages,
          qrImageUrl: qrImage,
          statusList: OrderUtils.statusList,
        );
      } else {
        final amount = _placePro.getAllAmount;

        callBack = CallBackModel(
          curSym: _placePro.curSym ?? '',
          isPaymentScreen: false,
          descText: _placePro.descCltr.text,
          isDelivery: _placePro.isDelivery,
          delivertAmtText: _placePro.delivertAmtCltr.text,
          orderList: _placePro.orderList,
          setMenuList: _placePro.setMenuList,
          ingreList: _placePro.ingreList,
          reOrder: _placePro.reOrder,
          itemPrice: amount.itemPrice,
          // taxPercent: _placePro.taxPercentDDS,
          taxAmount: amount.totalTax,
          totalAmount: amount.totalPrice,
          taxType: amount.taxType,
          scrollValue: OrderItems.scrollCltr.hasClients
              ? OrderItems.scrollCltr.offset
              : 0.0,
          adsPattern: adsPattern,
          screenImageList: _screenSaverPro.screenImages,
          qrImageUrl: qrImage,
          statusList: OrderUtils.statusList,
        );
      }

      // for now testing
      // _secondPro.callback(_callBack.toJson());
      // callBackJson = _callBack.toJson();
      // log(json.encode(_callBack.toJson()));

      // dual display
      await displayManager
          .transferDataToPresentation(json.encode(callBack.toJson()));
    } catch (e) {
      // showToast("149: dual_dis_config:$e");
    }
  }

  static void _listenToScroll() {
    OrderItems.scrollCltr.addListener(() {
      if (_placePro.orderList.isEmpty &&
          _placePro.setMenuList.isEmpty &&
          _placePro.ingreList.isEmpty) return;
      _sendListenableData();
    });
    OrderDetailSec.scrollCltr.addListener(() {
      if (_payPro.orderList.isEmpty &&
          _payPro.setMenuList.isEmpty &&
          _payPro.ingreList.isEmpty) return;
      _sendListenableData();
    });
  }

  static void _sendListenableData() {
    // if (!GlobalCVP.isDualMainScreen) return;

    Utils.handleSearch(
      callback: () async {
        sendData(isPayScreen: _payPro.isOnPaymentScreen);
      },
      millisecond: 500,
    );
  }
}

enum DualDisPattern { none, style1, style2, style3, style4 }
