import 'package:pos_account/model/auth/login_res.dart';
import 'package:pos_account/model/auth/store_detail_res.dart';
import 'package:pos_account/model/auth/user_stores_res.dart';
import 'package:pos_account/model/common/view_keys.dart';
import 'package:pos_account/model/home/menu/orders/refund_order.dart';
import 'package:pos_account/model/home/menu/place_order/po_make_pay_req.dart';
import 'package:pos_account/model/home/menu/place_order/retail_pos_res.dart';
import 'package:pos_account/model/home/menu/signal_r/place_order_info.dart';
import 'package:pos_account/model/notification/new_order_notifi.dart';
import 'package:pos_account/model/profile/user_add_sec.dart';
import 'package:pos_account/model/profile/user_info.dart';
import 'package:pos_account/repository/mx/model/trans_req.dart';
import 'package:pos_account/repository/windcave/model/tran_req.dart';
import 'package:pos_account/services/language/lang_model.dart';
import '../shared_pref.dart';
import 'db.dart';
part 'dbt_name.dart';

class DbLocalData {
  static final _db = DB.instance;

  ///[Login_Response] get Login Response from Local Database
  static Future<LoginRes?> getLoginData() async {
    final data = await _db.getDB(kDbTName: _kDB_Loginres);

    if (data.isNotEmpty) {
      try {
        return data.map((e) => LoginRes.fromJson(e.value)).toList()[0];
      } catch (e) {
        // print("get UserDataFrom DB ${e.toString()}");
      }
    }
    return null;
  }

  static Future<void> updateLoginData({LoginRes? loginRes}) async {
    if (loginRes == null) return;

    await _db.deleteAll(kDbTName: _kDB_Loginres);
    await _db.addOnDB(data: loginRes.toJson(), kDbTName: _kDB_Loginres);

    // store storeID in sharedPref
    SharedPrefs.setApiToken = loginRes.token ?? '';
    SharedPrefs.setUserId = loginRes.userId ?? '';
  }

  // get All Store
  static Future<UserStoresRes?> getAllStores() async {
    var data = await _db.getDB(kDbTName: _kDB_STORE_LIST);
    if (data.isNotEmpty) {
      try {
        return data.map((e) => UserStoresRes.fromJson(e.value)).toList()[0];
      } catch (e) {
        // print("get UserDataFrom DB ${e.toString()}");
      }
    }
    return null;
  }

  static Future<void> updateAllStores({UserStoresRes? data}) async {
    // print("---------data ${data?.toJson()}");

    if (data == null) return;

    await _db.deleteAll(kDbTName: _kDB_STORE_LIST);

    await _db.addOnDB(data: data.toJson(), kDbTName: _kDB_STORE_LIST);
  }

  ///[STORE_DATA] get STORE_DATA from Local Database
  static Future<StoreDetailRes?> getStoreData() async {
    final data = await _db.getDB(kDbTName: _kDB_STORE_DATA);
    if (data.isNotEmpty) {
      try {
        return data.map((e) => StoreDetailRes.fromJson(e.value)).toList()[0];
      } catch (e) {
        // print("get UserDataFrom DB ${e.toString()}");
      }
    }
    return null;
  }

  static Future<void> updateStoreData({StoreDetailRes? data}) async {
    if (data == null) return;

    await _db.deleteAll(kDbTName: _kDB_STORE_DATA);
    await _db.addOnDB(data: data.toJson(), kDbTName: _kDB_STORE_DATA);

    SharedPrefs.setCurSym = data.currencySymbol ?? '';
    await SharedPrefs.setDateFormat(data.dateFormat ?? '');
    SharedPrefs.setemployeeId = data.employeeId ?? '';
  }

  ///[Language_data] get Language Data from Local Database

  static Future<LangModel?> getLangData() async {
    var data = await _db.getDB(kDbTName: _KDB_LANGDATA);
    if (data.isNotEmpty) {
      try {
        return data.map((e) => LangModel.fromJson(e.value)).toList().first;
      } catch (e) {
        // print("get Language Data error DB ${e.toString()}");
      }
    }
    return null;
  }

  static Future<void> localLangUpdate({required LangModel appStrings}) async {
    await _db.deleteAll(kDbTName: _KDB_LANGDATA);
    await _db.addOnDB(data: appStrings.toJson(), kDbTName: _KDB_LANGDATA);
  }

  ///[Menu_Data] get Home Screen menu data

  // static Future<AllPosOrderSecRes?> getInitProd() async {
  //   var data = await _db.getDB(kDbTName: _kDB_POS_ORDER_SEC);
  //   if (data.isNotEmpty) {
  //     try {
  //       return data
  //           .map((e) => AllPosOrderSecRes.fromJson(e.value))
  //           .toList()
  //           .first;
  //     } catch (e) {
  //       // print("get Menu list DB ${e.toString()}");
  //     }
  //   }
  //   return null;
  // }

  // static Future<void> updateInitProd({required AllPosOrderSecRes menu}) async {
  //   await _db.deleteAll(kDbTName: _kDB_POS_ORDER_SEC);
  //   await _db.addOnDB(
  //     data: menu.toJson(),
  //     kDbTName: _kDB_POS_ORDER_SEC,
  //   );
  // }

  // static Future<void> deleteMenuRes() async {
  //   await _db.deleteAll(kDbTName: _kDB_POS_ORDER_SEC);
  // }

  ///[Notification_Data] get Notification data from local db

  static Future<NewOrderDbModel?> getOrdersNotify() async {
    var data = await _db.getDB(kDbTName: _kDB_ORDER_NOTIFY);
    if (data.isNotEmpty) {
      try {
        return data
            .map((e) => NewOrderDbModel.fromJson(e.value))
            .toList()
            .first;
      } catch (e) {
        // print("get order notify DB ${e.toString()}");
      }
    }
    return null;
  }

  static Future<void> updateOrderNotify(
      {required NewOrderDbModel order}) async {
    await _db.deleteAll(kDbTName: _kDB_ORDER_NOTIFY);
    await _db.addOnDB(
      data: order.toJson(),
      kDbTName: _kDB_ORDER_NOTIFY,
    );
  }

  static Future<void> deleteOrderNotify() async {
    await _db.deleteAll(kDbTName: _kDB_ORDER_NOTIFY);
  }

  ///[LOGIN_BANNER_LIST] get Notification data from local db

  static Future<UserAddSec?> getLoginBanners() async {
    var data = await _db.getDB(kDbTName: _kDB_BANNER_KEY);
    if (data.isNotEmpty) {
      try {
        return data.map((e) => UserAddSec.fromJson(e.value)).toList().first;
      } catch (e) {
        // print("get login banner list DB ${e.toString()}");
      }
    }
    return null;
  }

  static Future<void> updateLoginBanners(
      {required UserAddSec bannerData}) async {
    await _db.deleteAll(kDbTName: _kDB_BANNER_KEY);
    await _db.addOnDB(
      data: bannerData.toJson(),
      kDbTName: _kDB_BANNER_KEY,
    );
  }

  //screen saver
  // static Future<ScreenTimeModel?> getScreenSaver() async {
  //   var data = await _db.getDB(kDbTName: _kDB_SCREEN_SAVER_KEY);
  //   if (data.isNotEmpty) {
  //     try {
  //       return data
  //           .map((e) => ScreenTimeModel.fromJson(e.value))
  //           .toList()
  //           .first;
  //     } catch (e) {
  //       // print("get screen saver data DB ${e.toString()}");
  //     }
  //   }
  //   return null;
  // }

  // static Future<void> updateScreenSavers(
  //     {required ScreenTimeModel data}) async {
  //   await _db.deleteAll(kDbTName: _kDB_SCREEN_SAVER_KEY);
  //   await _db.addOnDB(
  //     data: data.toJson(),
  //     kDbTName: _kDB_SCREEN_SAVER_KEY,
  //   );
  // }

  //profile information
  static Future<UserInfo?> getUserInfo() async {
    var data = await _db.getDB(kDbTName: _kDB_USER_INFO);
    if (data.isNotEmpty) {
      try {
        return data.map((e) => UserInfo.fromJson(e.value)).toList().first;
      } catch (e) {
        // print("get user info data DB ${e.toString()}");
      }
    }
    return null;
  }

  static Future<void> updateUserInfo({required UserInfo data}) async {
    await _db.deleteAll(kDbTName: _kDB_USER_INFO);
    await _db.addOnDB(
      data: data.toJson(),
      kDbTName: _kDB_USER_INFO,
    );
  }

  //button permissons
  static Future<ViewKeys> getButtonsPermisson() async {
    var data = await _db.getDB(kDbTName: _kDB_BUTTON_PERMISSION);
    if (data.isNotEmpty) {
      try {
        return data.map((e) => ViewKeys.fromJson(e.value)).toList().first;
      } catch (e) {
        // print("get user info data DB ${e.toString()}");
      }
    }
    return ViewKeys();
  }

  static Future<void> updateButtonPermission({ViewKeys? data}) async {
    if (data == null) return;

    await _db.deleteAll(kDbTName: _kDB_BUTTON_PERMISSION);

    await _db.addOnDB(
      data: data.toJson(),
      kDbTName: _kDB_BUTTON_PERMISSION,
    );
  }

  // incomplete payment request
  static Future<PoMakePaymentReq?> getPaymentReqData() async {
    var data = await _db.getDB(kDbTName: _kDB_INCOMPLETE_PAYMENT_REQ);
    if (data.isNotEmpty) {
      try {
        return data
            .map((e) => PoMakePaymentReq.fromJson(e.value))
            .toList()
            .first;
      } catch (e) {
        // print("get user info data DB ${e.toString()}");
      }
    }
    return null;
  }

  static Future<void> updatePaymentRequestData({PoMakePaymentReq? data}) async {
    // print("---------incomplete pay data ${data?.toJson()}");

    await _db.deleteAll(kDbTName: _kDB_INCOMPLETE_PAYMENT_REQ);
    if (data != null) {
      await _db.addOnDB(
        data: data.toJson(),
        kDbTName: _kDB_INCOMPLETE_PAYMENT_REQ,
      );
    }
  }

  // incomplete refund request
  static Future<RefundOrderReq?> getRefundReqData() async {
    var data = await _db.getDB(kDbTName: _kDB_INCOMPLETE_REFUND_REQ);
    if (data.isNotEmpty) {
      try {
        return data.map((e) => RefundOrderReq.fromJson(e.value)).toList().first;
      } catch (e) {
        // log("get user info data DB ${e.toString()}");
      }
    }
    return null;
  }

  static Future<void> updateRefundRequestData({RefundOrderReq? data}) async {
    // log("incomplete refund data ${data?.toJson()}");

    await _db.deleteAll(kDbTName: _kDB_INCOMPLETE_REFUND_REQ);
    if (data != null) {
      await _db.addOnDB(
        data: data.toJson(),
        kDbTName: _kDB_INCOMPLETE_REFUND_REQ,
      );
    }
  }

  // incomplete windcave request
  static Future<WcTransactionReq?> getWindcaveReqData() async {
    var data = await _db.getDB(kDbTName: _kDB_WINDCAVE_TRANSACTION);
    if (data.isNotEmpty) {
      try {
        return data
            .map((e) => WcTransactionReq.fromJson(e.value))
            .toList()
            .first;
      } catch (e) {
        // print("get user info data DB ${e.toString()}");
      }
    }
    return null;
  }

  static Future<void> updateWindcaveRequestData(
      {WcTransactionReq? data}) async {
    // log("incomplete windcave data $data");

    await _db.deleteAll(kDbTName: _kDB_WINDCAVE_TRANSACTION);
    if (data != null) {
      await _db.addOnDB(
        data: data.toJson(),
        kDbTName: _kDB_WINDCAVE_TRANSACTION,
      );
    }
  }

  static Future<void> updateAllPosProduct({List<dynamic>? data}) async {
    // print("---------data ${data?.toJson()}");
    final _body = {"data": data};

    await _db.deleteAll(kDbTName: _kDB_ALL_POS_PRODUCTS);
    if (data != null) {
      await _db.addOnDB(
        data: _body,
        kDbTName: _kDB_ALL_POS_PRODUCTS,
      );
    }
  }

  // get All Pos Products
  static Future<List<dynamic>?> getAllPosProducts() async {
    var data = await _db.getDB(kDbTName: _kDB_ALL_POS_PRODUCTS);
    if (data.isNotEmpty) {
      try {
        final _data = data.map((e) => e.value).toList().first;
        return _data['data'] as List<dynamic>;
        // return List<AllPosProductRes>.from(
        //     _data['data']!.map((x) => AllPosProductRes.fromJson(x)));
      } catch (e) {
        // kPrint("errorL ${e.toString()}");
      }
    }
    return null;
  }

  static Future<void> updateAllRetailProduct(
      {List<RetailProductRes>? data}) async {
    // print("---------data ${data?.toJson()}");
    final _body = {"data": data?.map((e) => e.toJson()).toList()};

    await _db.deleteAll(kDbTName: _kDB_ALL_RETAIL_PRODUCTS);
    if (data != null) {
      await _db.addOnDB(
        data: _body,
        kDbTName: _kDB_ALL_RETAIL_PRODUCTS,
      );
    }
  }

  // get All Pos Products
  static Future<List<RetailProductRes>?> getAllRetailProducts() async {
    var data = await _db.getDB(kDbTName: _kDB_ALL_RETAIL_PRODUCTS);
    if (data.isNotEmpty) {
      try {
        final _data = data.map((e) => e.value).toList().first;
        return List<RetailProductRes>.from(
            _data['data']!.map((x) => RetailProductRes.fromJson(x)));
      } catch (e) {
        // log("errorL ${e.toString()}");
      }
    }
    return null;
  }

  // all add section list
  static Future<Map<String, dynamic>?> getAllAddSection() async {
    var data = await _db.getDB(kDbTName: _kDB_ALL_ADD_SECTION);
    if (data.isNotEmpty) {
      try {
        return data.map((e) => e.value).toList().first;
      } catch (e) {
        // print("get user info data DB ${e.toString()}");
      }
    }
    return null;
  }

  static Future<void> updateAllAddSection({Map<String, dynamic>? data}) async {
    // log("incomplete windcave data $data");

    await _db.deleteAll(kDbTName: _kDB_ALL_ADD_SECTION);
    if (data != null) {
      await _db.addOnDB(
        data: data,
        kDbTName: _kDB_ALL_ADD_SECTION,
      );
    }
  }

  // incomplete mx request
  static Future<MxTransReq?> getMxReqData() async {
    var data = await _db.getDB(kDbTName: _kDB_MX_TRANSACTION);
    if (data.isNotEmpty) {
      try {
        return data.map((e) => MxTransReq.fromJson(e.value)).toList().first;
      } catch (e) {
        // print("get user info data DB ${e.toString()}");
      }
    }
    return null;
  }

  static Future<void> updateMxRequestData({MxTransReq? data}) async {
    // log("incomplete mx data $data");

    await _db.deleteAll(kDbTName: _kDB_MX_TRANSACTION);
    if (data != null) {
      await _db.addOnDB(
        data: data.toJson(),
        kDbTName: _kDB_MX_TRANSACTION,
      );
    }
  }

  static Future<void> addAllPrintData({List<PlaceOrderInfo>? data}) async {
    // print("---------data ${data?.toJson()}");
    final _body = {"data": data?.map((e) => e.toJson()).toList()};

    await _db.deleteAll(kDbTName: _kDB_PRINT_DATA);
    if (data != null) {
      await _db.addOnDB(
        data: _body,
        kDbTName: _kDB_PRINT_DATA,
      );
    }
  }

  // get All Pos Products
  static Future<List<PlaceOrderInfo>?> getPrintData() async {
    var data = await _db.getDB(kDbTName: _kDB_PRINT_DATA);
    if (data.isNotEmpty) {
      try {
        final _data = data.map((e) => e.value).toList().first;
        return List<PlaceOrderInfo>.from(
            _data['data']!.map((x) => PlaceOrderInfo.fromJson(x)));
      } catch (e) {
        // log("errorL ${e.toString()}");
      }
    }
    return null;
  }

  // // get device detail data
  // static Future<DeviceDetailRes?> getDeviceDetail() async {
  //   var data = await _db.getDB(kDbTName: _kDB_DEVICE_DETAIL);
  //   if (data.isNotEmpty) {
  //     // try {
  //     return data.map((e) => DeviceDetailRes.fromJson(e.value)).toList().first;
  //     // } catch (e) {
  //     //   log("get device detail data DB ${e.toString()}");
  //     // }
  //   }
  //   return null;
  // }

  // static Future<void> updateDeviceDetail({DeviceDetailRes? data}) async {
  //   // log("get device detail data ${data?.toJson()}");

  //   await _db.deleteAll(kDbTName: _kDB_DEVICE_DETAIL);
  //   if (data != null) {
  //     await _db.addOnDB(
  //       data: data.toJson(),
  //       kDbTName: _kDB_DEVICE_DETAIL,
  //     );
  //   }
  // }

  // // MX-51
  // static Future<Map<String, dynamic>?> getMxPairData() async {
  //   var data = await _db.getDB(kDbTName: _kDB_MX_PAIR);
  //   if (data.isNotEmpty) {
  //     try {
  //       return data.map((e) => e.value).toList().first;
  //     } catch (e) {
  //       // print("get user info data DB ${e.toString()}");
  //     }
  //   }
  //   return null;
  // }

  // static Future<void> setMxPairData({Map<String, dynamic>? data}) async {
  //   // log("incomplete windcave data $data");

  //   await _db.deleteAll(kDbTName: _kDB_MX_PAIR);
  //   if (data != null) {
  //     await _db.addOnDB(
  //       data: data,
  //       kDbTName: _kDB_MX_PAIR,
  //     );
  //   }
  // }

  static Future<void> clear({bool isAuth = true}) async {
    if (isAuth) {
      await _db.deleteAll(kDbTName: _kDB_Loginres);
      await _db.deleteAll(kDbTName: _kDB_STORE_LIST);
      await _db.deleteAll(kDbTName: _kDB_USER_INFO);
      SharedPrefs.clear;
    }
    await _db.deleteAll(kDbTName: _kDB_PRINT_DATA);
    await _db.deleteAll(kDbTName: _kDB_STORE_DATA);
    // await _db.deleteAll(kDbTName: _kDB_POS_ORDER_SEC);
    await _db.deleteAll(kDbTName: _kDB_ORDER_NOTIFY);
    // await _db.deleteAll(kDbTName: _kDB_SCREEN_SAVER_KEY);

    await _db.deleteAll(kDbTName: _kDB_BUTTON_PERMISSION);
    await _db.deleteAll(kDbTName: _kDB_INCOMPLETE_PAYMENT_REQ);
    await _db.deleteAll(kDbTName: _kDB_INCOMPLETE_REFUND_REQ);
    await _db.deleteAll(kDbTName: _kDB_WINDCAVE_TRANSACTION);
    await _db.deleteAll(kDbTName: _kDB_ALL_POS_PRODUCTS);
    await _db.deleteAll(kDbTName: _kDB_ALL_RETAIL_PRODUCTS);
    await _db.deleteAll(kDbTName: _kDB_MX_TRANSACTION);
    // await _db.deleteAll(kDbTName: _kDB_DEVICE_DETAIL);
    // await _db.closeDB();
  }

  // static Future<void> testDelete() async {
  //   await _db.deleteAll(kDbTName: _kDB_ORDER_NOTIFY);
  // }
}
