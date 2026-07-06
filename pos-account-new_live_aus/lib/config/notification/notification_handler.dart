import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:pos_account/config/utils/menu_schedule_utils.dart';
import 'package:pos_account/config/validator.dart';
import 'package:pos_account/ln.dart';
import 'package:pos_account/model/notification/notify_model.dart';
import 'package:pos_account/model/notification/sync_noti_data.dart';
import 'package:pos_account/providers/booking/table_arrange_pro.dart';
import 'package:pos_account/providers/cus_val_pro.dart';
import 'package:pos_account/providers/menu/orders_pro.dart';
import 'package:pos_account/providers/menu/payment_pro.dart';
import 'package:pos_account/providers/menu/place_order_pro.dart';
import 'package:pos_account/providers/menu/pos_retail_pro.dart';
import 'package:pos_account/providers/screen_saver/screen_saver_pro.dart';
import 'package:pos_account/repository/handler.dart';
import 'package:provider/provider.dart';

enum NotiNavi { Orders, tablereservation }

class NotificationHandler {
  static void onClickNotification(String? payload) {
    if (payload == null || payload == "") return;

    final context = CUS_CTX;

    if (context == null) return;

    final _cvp = Provider.of<CusValuePro>(context, listen: false);

    Provider.of<ScreenSaverPro>(context, listen: false)
        .screenSaverCheck('notification_tap');

    // log(payload);
    final notifyData = NotifyModel.fromJson(json.decode(payload));
    if (notifyData.navigation?.toLowerCase() == NotiNavi.Orders.name) {
      _orderPageNavigate(cvp: _cvp, context: context);
    } else if (notifyData.navigation?.toLowerCase() ==
        NotiNavi.tablereservation.name) {
      _bookPageNavigate(
        cvp: _cvp,
      );
    }
  }

  static void _orderPageNavigate({
    required CusValuePro cvp,
    required BuildContext context,
    String? orderId,
  }) {
    Future.delayed(Duration(milliseconds: 200), () {
      cvp.setMainPage = MainPage.OrderPage;
      if (orderId == null) return;

      final orderP = Provider.of<OrderPro>(context, listen: false);
      Future.delayed(Duration(milliseconds: 350), () {
        orderP.viewOrder(context, orderId: orderId);
      });
    });
  }

  static void _bookPageNavigate({
    required CusValuePro cvp,
  }) {
    Future.delayed(Duration(milliseconds: 200), () {
      if (cvp.getMainPage != MainPage.HomePage) {
        cvp.setMainPage = MainPage.HomePage;
      }
      if (cvp.PageCltr != null) {
        final _index = cvp.tabs[cvp.currentPage].title == LN.floorPlan
            ? cvp.currentPage
            : cvp.tabs.indexWhere((element) => element.title == LN.floorPlan);
        Future.delayed(Duration(milliseconds: 350), () {
          cvp.setHPTIndex = _index;
          cvp.PageCltr!.jumpTo(_index.toDouble());
        });
      }
    });
  }

  static String? _actionDataType;

  // data sync
  static Future<void> sync(
    syncData, {
    String? title,
    String? body,
  }) async {
    final _synNcotiData = SyncNotiData.fromJson(syncData);

    if (_actionDataType != null &&
        _actionDataType == _synNcotiData.actiontype) {
      _actionDataType = null;
      // print('---- sync cancel');
      return;
    }

    _actionDataType = _synNcotiData.actiontype;

    final _pusNotiType = _synNcotiData.actiontype._getNotiActionType;

    final context = CUS_CTX;

    if (context == null) return;

    final _cvp = Provider.of<CusValuePro>(context, listen: false);

    if (_pusNotiType == PushNotificationActionEnum.DataSync) {
      if (_synNcotiData.payload == null) {
        _actionDataType = null;
        return;
      }

      final _payload = json.decode(_synNcotiData.payload!);

      if (_payload == null) {
        _actionDataType = null;
        return;
      }

      final _dataTypeList =
          List<String>.from(_payload.map((x) => x?.toString() ?? ''));

      await Future.delayed(Duration(milliseconds: 200));

      for (final a in _dataTypeList) {
        await _apiCall(
          context,
          syncData: _synNcotiData,
          dataType: a,
          cvp: _cvp,
        );
      }
    } else if (_cvp.userStoresRes?.isMainDevice ?? false) {
      String? dataType;

      if (_pusNotiType == PushNotificationActionEnum.PrintOrder) {
        dataType = SyncDataType.PrintOrder.name;
      } else if (_pusNotiType == PushNotificationActionEnum.Notification) {
        dataType = SyncDataType.NewOrder.name;
      }

      if (dataType != null)
        await _apiCall(
          context,
          syncData: _synNcotiData,
          dataType: dataType,
          cvp: _cvp,
          title: title,
          body: body,
        );
    }

    //

    _actionDataType = null;
  }

  // static String? _syncDataType;

  static Future<void> _apiCall(
    BuildContext context, {
    required SyncNotiData syncData,
    String? dataType,
    required CusValuePro cvp,
    String? title,
    String? body,
  }) async {
    final _cvp = cvp;

    final _syncData = syncData;

    // if (_syncDataType != null && _syncDataType == dataType) {
    //   _syncDataType = null;
    //   // print('---- sync cancel');
    //   return;
    // }

    // _syncDataType = dataType;

    final _syncType = dataType._getSyncType;

    final _storeId = _cvp.currentStore?.id;

    // if (_cvp.isRetailStore) return;

    if (_syncData.storeid?.toLowerCase() != _storeId?.toLowerCase()) return;

    final _placeOrderPro = Provider.of<PlaceOrderPro>(context, listen: false);
    final _payPro = Provider.of<PaymentPro>(context, listen: false);
    final _retailPro = Provider.of<PosRetailPro>(context, listen: false);

    //
    if (_syncType == SyncDataType.Products) {
      if (_cvp.isRetailStore) {
        await _retailPro.getAllRetailProducts(isServerCall: true);
        _retailPro.getItemData();
      } else {
        await _placeOrderPro.getAllProducts(isServerCall: true);
        _placeOrderPro.getItemData();
      }
    } //

    else if (_syncType == SyncDataType.Promotions) {
      if (_cvp.isRetailStore) {
        _retailPro.getAllPromotions();
      } else {
        _placeOrderPro.getAllPromotions();
      }
    } //

    else if (_syncType == SyncDataType.Brands) {
      final _data = await Handler.syncBrand();
      if (_data == null) return;

      _cvp.updateAddSection(data: {"brands": _data});
      _placeOrderPro.getOrderAddSection();
      _placeOrderPro.notify;
    } //

    else if (_syncType == SyncDataType.OrderTypes) {
      final _data1 = await Handler.syncPosOrderType();
      final _data2 = await Handler.syncOrdersOrderType();

      _cvp.updateAddSection(data: {
        if (_data1 != null) "posOrderTypes": _data1,
        if (_data2 != null) "allOrdersOrderTypes": _data2,
      });
      _placeOrderPro.getOrderAddSection();
      _placeOrderPro.notify;
      final _orderPro = Provider.of<OrderPro>(context, listen: false);
      _orderPro.getOrDeSec();
    } //

    else if (_syncType == SyncDataType.DocketGroup) {
      final _data = await Handler.syncDocketGroup();
      if (_data == null) return;

      _cvp.updateAddSection(data: {"docketGroups": _data});

      _placeOrderPro.getOrderAddSection();
      _placeOrderPro.notify;
    } //

    else if (_syncType == SyncDataType.OrderItemStatus) {
      final _data = await Handler.syncOrderItemStatus();
      if (_data == null) return;

      _cvp.updateAddSection(data: {"orderItemStatus": _data});

      _placeOrderPro.getOrderAddSection();
      _placeOrderPro.notify;
    } //

    else if (_syncType == SyncDataType.Discounts) {
      final _data = await Handler.syncDiscount();
      if (_data == null) return;

      _cvp.updateAddSection(data: {"discounts": _data});

      _payPro.getData();
    } //

    else if (_syncType == SyncDataType.CustomerGroups) {
      final _data = await Handler.syncCusGroup();
      if (_data == null) return;

      _cvp.updateAddSection(data: {"customerGroups": _data});
    } //

    else if (_syncType == SyncDataType.Merchants) {
      final _data = await Handler.syncMerchant();
      if (_data == null) return;

      _cvp.updateAddSection(data: {"eftPosMerchants": _data});
      _payPro.getData();
    } //

    else if (_syncType == SyncDataType.StoreInfo) {
      final _data1 = await Handler.syncStoreInfo();
      // to get tax value and type, need to call this api too.
      final _data2 = await Handler.getStoreChargeInfo();
      // final _data2 = await Handler.syncStockDeduct();
      // final _data3 = await Handler.syncDeliveryInfo();

      _cvp.updateAddSection(
        data: {
          "storeInformation": {
            if (_data1 != null) ..._data1,
            if (_data2 != null) ..._data2,
          },
        },
      );

      _placeOrderPro.getOrderAddSection();
      _placeOrderPro.notify;
    }
    //
    else if (_syncType == SyncDataType.OrderNote) {
      if (_cvp.isRetailStore) return;
      final _data = await Handler.syncOrderNote();
      if (_data == null) return;

      _cvp.updateAddSection(data: {"orderNotes": _data});
      _placeOrderPro.setOrderNotes();
    }
    //
    else if (_syncType == SyncDataType.Menus) {
      if (_cvp.isRetailStore) return;
      final _data = await Handler.syncMenus();
      if (_data == null) return;
      _cvp.updateAddSection(data: {"menus": _data});
      _placeOrderPro.getOrderAddSection();
    }
    //
    else if (_syncType == SyncDataType.ScheduleMenu) {
      final _placeOrderPro = Provider.of<PlaceOrderPro>(context, listen: false);
      if (GlobalCVP.isHospitality) {
        MenuScheduleUtils.listen(
          (slot) async {
            _placeOrderPro.menuslot = slot;
            _placeOrderPro.getItemData();
          },
          enableCloseTimeCheck: false,
        );
      }
    }
    //
    else if (_syncType == SyncDataType.PrintOrder) {
      // if (_syncData.payload != null) {
      //   StkUtils.newOrderStk(
      //     _syncData.payload!,
      //     bypass: false,
      //     isNewOrderPopup: false,
      //   );
      // }
    }
    //
    else if (_syncType == SyncDataType.NewOrder) {
      // CusNotifyDia.show(
      //   //payload: _syncData.payload
      //   title: title,
      //   body: body,
      //   payLoad: syncData.payload,
      // );
    }
    //
    else if (_syncType == SyncDataType.TableLocation) {
      final _data = await Handler.syncTableLocations();
      if (_data == null) return;

      _cvp.updateAddSection(data: {"tableLocations": _data});
      final _tableArrPro = Provider.of<TableArrangePro>(context, listen: false);
      _tableArrPro.setTableLocations();
    }
    //
    else if (_syncType == SyncDataType.FloorPlan) {
      final _tableArrPro = Provider.of<TableArrangePro>(context, listen: false);
      if (_tableArrPro.addSecRes?.tableLocationsWithTables?.isNotEmpty ??
          false) {
        _tableArrPro.getTableStatus(
          id: _tableArrPro
                  .addSecRes
                  ?.tableLocationsWithTables?[_tableArrPro.selectedForEdit]
                  .id ??
              '',
          serverLoad: true,
          doPageLoad: false,
          doResize: true,
        );
      }
    }
    //
    else if (_syncType == SyncDataType.Orders) {
      final _orderPro = Provider.of<OrderPro>(context, listen: false);
      _orderPro.getData(blockRecallWithinSeconds: 3);
    }
    //
    else if (_syncType == SyncDataType.PopularProducts) {
      await _placeOrderPro.getPopularProducts();
      _placeOrderPro.getAllProducts(serverCallLater: false);
    }
    //
    else if (_syncType == SyncDataType.DocketPrintSetups) {
      final _data = await Handler.syncPrintDocket();

      if (_data == null) return;

      _cvp.updateAddSection(data: {"printingSetUps": _data});
      _cvp.setSyncData();
    }
    //

    // _syncDataType = null;
  }

  // static Future<void> syncInBackground(Map<String, dynamic> data) async {
  //   final _synNcotiData = SyncNotiData.fromJson(data);
  //   kPrint("syncing: ${_synNcotiData.actiontype}");

  //   if (_actionDataType != null &&
  //       _actionDataType == _synNcotiData.actiontype) {
  //     _actionDataType = null;
  //     return;
  //   }

  //   _actionDataType = _synNcotiData.actiontype;

  //   final _pusNotiType = _synNcotiData.actiontype._getNotiActionType;

  //   kPrint("_pusNotiType:$_pusNotiType");

  //   if (_pusNotiType == PushNotificationActionEnum.PrintOrder) {
  //     await NotificationApi.showSyncNotification(
  //       id: 11,
  //       title: "POSApt",
  //       body: "Syncing orders",
  //     );

  //     // Example: direct API call
  //     final _deviceDetailLocal = await DbLocalData.getAllStores();

  //     kPrint(
  //         "isMainDevice: ${(_deviceDetailLocal?.isMainDevice ?? false)} $_pusNotiType");

  //     if (_deviceDetailLocal?.isMainDevice ?? false) {
  //       await StkUtils.getOnlineOrderSTK(isAppOpen: false);
  //     }

  //     await Future.delayed(const Duration(seconds: 15));
  //     await NotificationApi.cancelAllNotifications();
  //     // await NotificationApi.cancelNotification(11);
  //   }

  //   _actionDataType = null;
  // }

  // static const String _sync_noti_key = 'sync_noti_key_5343';

  // static void storeBackNoti(Map<String, dynamic> _notiData) {
  //   SharedPreferences.getInstance().then((_pref) {
  //     final value = _pref.getString(_sync_noti_key) ?? "";
  //     final body = value.isNotEmpty ? jsonDecode(value) : null;
  //     final _listMap = body is List
  //         ? body.map((e) => e as Map<String, dynamic>).toList()
  //         : <Map<String, dynamic>>[];

  //     // print('- getting listMap- $_listMap ');

  //     if (_listMap.any((a) => a['datatype'] == _notiData['datatype'])) {
  //       _listMap.removeWhere((a) => a['datatype'] == _notiData['datatype']);
  //     }

  //     _pref
  //         .setString(_sync_noti_key, jsonEncode([..._listMap, _notiData]))
  //         .then((result) {
  //       // print('-_notiData- $_notiData | result: $result');
  //     });
  //   });
  // }

  // static Future<void> runBackNoti() async {
  //   // print('-running Back Notification');
  //   await Future.delayed(Duration(milliseconds: 500));
  //   final _pref = await SharedPreferences.getInstance();
  //   await _pref.reload();

  //   String _value = _pref.getString(_sync_noti_key) ?? "";

  //   if (_value.isEmpty) {
  //     await _pref.reload();
  //     _value = _pref.getString(_sync_noti_key) ?? "";
  //   }

  //   // print('-_value- $_value');

  //   if (_value.isEmpty) return;

  //   final _body = jsonDecode(_value);
  //   final _listMap = _body is List
  //       ? _body.map((e) => e as Map<String, dynamic>).toList()
  //       : <Map<String, dynamic>>[];

  //   // print('-_listMap- $_listMap');

  //   for (final a in _listMap) {
  //     await sync(a);
  //   }
  //   await _pref.remove(_sync_noti_key);
  //   // print('-clearrrr - clearNotiKey');
  // }

  // static void clearNotiKey() async {
  //   await Future.delayed(Duration(milliseconds: 500));
  //   final _pref = await SharedPreferences.getInstance();
  //   await _pref.remove(_sync_noti_key);
  //   // print('-inactive clear- clearNotiKey');
  // }
}

enum SyncDataType {
  Promotions,
  Brands,
  Products,
  Merchants,
  OrderTypes,
  DocketGroup,
  OrderItemStatus,
  Discounts,
  CustomerGroups,
  StoreInfo,
  OrderNote,
  // MxMerchantCredential,
  Menus,
  ScheduleMenu,
  PrintOrder,
  NewOrder,
  TableLocation,
  FloorPlan,
  Orders,
  Tables,
  PopularProducts,
  DocketPrintSetups,
  None
}

enum PushNotificationActionEnum { DataSync, PrintOrder, Notification, None }

extension SyncDataTypeX on String? {
  /// Key-value mapping
  static const Map<int, SyncDataType> _map = {
    1: SyncDataType.Promotions,
    2: SyncDataType.Brands,
    3: SyncDataType.Products,
    4: SyncDataType.Merchants,
    5: SyncDataType.OrderTypes,
    6: SyncDataType.DocketGroup,
    7: SyncDataType.OrderItemStatus,
    8: SyncDataType.Discounts,
    9: SyncDataType.CustomerGroups,
    10: SyncDataType.StoreInfo,
    11: SyncDataType.OrderNote,
    // 12: SyncDataType.MxMerchantCredential,
    14: SyncDataType.Menus,
    15: SyncDataType.ScheduleMenu,
    16: SyncDataType.PrintOrder,
    17: SyncDataType.NewOrder,
    18: SyncDataType.TableLocation,
    19: SyncDataType.FloorPlan,
    20: SyncDataType.Orders,
    21: SyncDataType.Tables,
    22: SyncDataType.PopularProducts,
    23: SyncDataType.DocketPrintSetups,
  };

  SyncDataType get _getSyncType {
    if (this == null)
      return SyncDataType.None;
    else {
      return _map.entries
          .firstWhere(
            (e) => e.value.name == this || e.key.toDouble() == this?.inDouble,
            orElse: () => const MapEntry(0, SyncDataType.None),
          )
          .value;
    }
  }

  static const Map<int, PushNotificationActionEnum> _map2 = {
    1: PushNotificationActionEnum.DataSync,
    2: PushNotificationActionEnum.PrintOrder,
    3: PushNotificationActionEnum.Notification,
  };

  PushNotificationActionEnum get _getNotiActionType {
    if (this == null)
      return PushNotificationActionEnum.None;
    else {
      return _map2.entries
          .firstWhere(
            (e) => e.value.name == this || e.key.toDouble() == this?.inDouble,
            orElse: () => const MapEntry(0, PushNotificationActionEnum.None),
          )
          .value;
    }
  }
}
