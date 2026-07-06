import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:pos_account/config/utils/utils.dart';
import 'package:pos_account/constant/constant.dart';
import 'package:pos_account/ln.dart';
import 'package:pos_account/model/home/menu/signal_r/place_order_info.dart';
import 'package:pos_account/providers/auth/auth_pro.dart';
import 'package:pos_account/repository/handler.dart';
import 'package:pos_account/services/database/database/db_local_data.dart';
import 'package:pos_account/services/database/shared_pref.dart';
import 'package:pos_account/services/printer/com/send_to_kitchen_print.dart';
import '../../../model/home/menu/place_order/place_order_res.dart';
import '../../../model/home/menu/place_order/pos_res/store_information.dart';
import '../../../widgets/dialog/cus_notify_dia.dart';

class StkEventUtils {
  static String? _getAuth;

  static final _newOrderList = <PlaceOrderInfo>[];

  static Future<void> newOrder({
    List<dynamic>? payload,
  }) async {
    _getAuth ??= await SharedPrefs.isAuth;

    final _deviceInfo = await DbLocalData.getAllStores();

    if (_getAuth != AuthStatus.AUTHENTICATE.name ||
        !(_deviceInfo?.isMainDevice ?? false)) return;

    if (payload == null || payload.isEmpty) {
      kPrint('SignalRStkUtils: 1');
      return;
    }

    final _newData = List<PlaceOrderInfo>.from(
      payload.map((x) =>
          PlaceOrderInfo.fromJson(x)..dateTime = DateTime.now().toString()),
    );

    final _storeData = await _getStoreInfo;
    if (!(_storeData?.autoSendToKitchenOnlineOrder ?? false)) {
      // if (_newData.first.title?.isNotEmpty ?? false) {
      _newData.first.title ??= "New online order";
      _newOrderPopup(printInfo: _newData.first);
      // }

      return;
    }

    _newOrderList.addAll(_newData);

    _AutoSTKHandler.resetSTKTimer();

    _showLogs("0.newOrder start : _newOrderList: ${_newOrderList.length}");

    // kPrint(" converted new Data = ${_newData.first.toJson()}");

    Utils.handleSearch(
        millisecond: 2000,
        callback: () async {
          if (_isLoopPrinting) {
            await Future.doWhile(() async {
              await Future.delayed(Duration(seconds: 2));
              _showLogs(
                  "1.newOrder print waiting ..: _isLoopPrinting: $_isLoopPrinting");
              // kPrint("newOrder print waiting .. $_isLoopPrinting");
              return _isLoopPrinting;
            });
          }

          _isLoopPrinting = true;

          _showLogs(
              "2.newOrder print wait over: _newOrderList: ${_newOrderList.length}");

          var _dbData = await DbLocalData.getPrintData();

          _dbData ??= [];

          for (final b in _newOrderList) {
            final _alreadyExists = _dbData.any(
              (a) =>
                  a.orderId?.toLowerCase() == b.orderId?.toLowerCase() &&
                  a.sessionId?.toLowerCase() == b.sessionId?.toLowerCase(),
            );
            if (!_alreadyExists) {
              _dbData.add(b);
            }
          }
          _newOrderList.clear();

          _showLogs("3:_runLocalPrint start with _dbData: ${_dbData.length}");

          await _runLocalPrint(dbData: _dbData, path: "eventOrder");

          _isLoopPrinting = false;
        });
  }

  static Future<void> _runLocalPrint({
    String path = "",
    required List<PlaceOrderInfo> dbData,
  }) async {
    for (final a in dbData) {
      _showLogs(
          "4._runLocalPrint start $path : orderId: ${a.orderId} sessionId: ${a.sessionId} isPrinted: ${a.isPrinted}");
      // kPrint(
      //     "_dbData: orderId: ${a.orderId} sessionId: ${a.sessionId} posDeviceId:${a.isPrinted}");
      if (!(a.isPrinted ?? false)) {
        // kPrint("$path: ${a.orderId}");
        await _sendToKitchen(
          orderId: a.orderId,
          isOnline: true,
          bypass: false,
          sessionId: a.sessionId ?? '',
          posDeviceId: a.posDeviceId ?? '',
          placeOrderInfo: a,
          path: path,
        );
      }

      _showLogs(
          "9._runLocalPrint end $path : orderid: ${a.orderId} _status: ${a.isPrinted}");

      // kPrint("done : ${a.orderId} ${a.isPrinted}");
    }

    // final _nonPrintedOrder = <PlaceOrderInfo>[];

    // for (final a in _dbData) {
    //   if (!(a.isPrinted ?? false)) {
    //     _nonPrintedOrder.add(a);
    //   }
    // }

    await DbLocalData.addAllPrintData(data: dbData);
  }

  static Future<bool?> _confirmOrderStk(
      {String? orderId, required String sessionId}) async {
    if (orderId == null) return null;

    return await Handler.confirmOrderSendToKitPrint(
      data: [
        {
          "OrderId": orderId,
          "SessionId": sessionId,
          "IsOrderPrinted": true,
        }
      ],
    );
  }

  static Future<bool?> _sendToKitchen({
    String? orderId,
    bool isOnline = false,
    bool bypass = false,
    int? extendedTime,
    String sessionId = "",
    String posDeviceId = "",
    PlaceOrderInfo? placeOrderInfo,
    String path = "",
  }) async {
    if (orderId == null) return null;

    final _storeData = await _getStoreInfo;

    bool? _status;
    _showLogs(
        "5._sendToKitchen $path : orderId: $orderId sessionId: $sessionId");
    // kPrint(
    //     "sendToKitchen path: $path | $orderId  |||isSendToKitchenPrinter:  ${(_storeData?.isSendToKitchenPrinter ?? false)}");

    final _stkPrinter =
        // stkPrinter &&
        (bypass || (_storeData?.isSendToKitchenPrinter ?? false));

    final _stkDisplay =
        // stkDisplay &&
        (bypass || (_storeData?.isSendToKitchenDisplay ?? false));

    if (_stkPrinter || _stkDisplay) {
      final _value = await Handler.posOrderStkPrinter(
        req: PlaceOrderInfo(
          orderId: orderId,
          extendedPickupDeliveryTimeInMins:
              extendedTime == null ? null : "$extendedTime",
          isSendToKitchenPrinter: _stkPrinter,
          isSendToKitchenDisplay: _stkDisplay,
          sessionId: sessionId,
          posDeviceId: posDeviceId,
        ),
      );
      _showLogs(
          "6._sendToKitchen $path : _stkPrinter: $_stkPrinter _value: ${_value != null}");

      if (_stkPrinter && _value != null) {
        if (isOnline) {
          _value.askForPrintConfirmation = false;
        }
        await SendToKitchenPrint.stkPos(
          CUS_CTX,
          order: _value,
          runSuccessFun: () async {
            _showLogs(
                "7._confirmOrderStk init $path : orderid: ${_value.orderId} sessionId: $sessionId");
            // Physical print succeeded: persist this immediately so the DB is
            // always correct even when the confirmation API call below fails.
            _status = true;
            placeOrderInfo?.isPrinted = true;
            await _confirmOrderStk(
                orderId: _value.orderId, sessionId: sessionId);
            _showLogs(
                "8._confirmOrderStk end $path : orderid: ${_value.orderId} _status: $_status");
          },
        );
      }
      // kPrint("Print Status : $_status || $_stkPrinter && ${_value != null}");
    }

    return _status;
  }

  static Future<void> sendTokitchenOrder({
    PlaceOrderRes? res,
    required String sessionId,
  }) async {
    SendToKitchenPrint.stkPos(
      CUS_CTX,
      order: res,
      runSuccessFun: () async {
        _confirmOrderStk(orderId: res?.orderId, sessionId: sessionId);
      },
    );
  }

  static Future<StoreInformation?> get _getStoreInfo async {
    final _dbData = await DbLocalData.getAllAddSection();
    if (_dbData != null) {
      final _storeInfo = StoreInformation.fromJson(_dbData["storeInformation"]);
      return _storeInfo;
    } else {
      return null;
    }
  }

  static Future<bool> get isAutoStkOnline async {
    final _getAuth = await SharedPrefs.isAuth;
    final _storeData = await _getStoreInfo;

    return _getAuth == AuthStatus.AUTHENTICATE.name &&
        (_storeData?.autoSendToKitchenOnlineOrder ?? false);
  }

  static Future<void> listenOnlineOrder() async {
    await clearPrintDb();
    await Future.delayed(Duration(seconds: 10));
    final _isAuth = await SharedPrefs.isAuth;
    final _deviceInfo = await DbLocalData.getAllStores();

    if (_isAuth != AuthStatus.AUTHENTICATE.name ||
        !(_deviceInfo?.isMainDevice ?? false)) return;

    _AutoSTKHandler.startSTKLoop();
  }

  static bool _isLoopPrinting = false;

  static Future<void> _getOnlineOrderSTK() async {
    _showLogs(
        "1._getOnlineOrderSTK Called: ${_isLoopPrinting ? 'return' : 'continue'}");
    if (_isLoopPrinting) return;

    if ((await isAutoStkOnline) && !_isLoopPrinting) {
      _isLoopPrinting = true;

      final _serverPrintData = await Handler.getOrderPrintStatus();

      var _dbPrintData = await DbLocalData.getPrintData();

      _dbPrintData ??= [];

      _showLogs(
          "2._getOnlineOrderSTK DB called-datalist: ${_dbPrintData.length}");

      if (_serverPrintData != null) {
        for (final a in _serverPrintData) {
          final _alreadyExists = _dbPrintData.any(
            (b) =>
                b.orderId?.toLowerCase() == a.orderId?.toLowerCase() &&
                b.sessionId?.toLowerCase() == a.sessionId?.toLowerCase(),
          );
          if (!_alreadyExists) {
            _dbPrintData.add(PlaceOrderInfo(
              orderId: a.orderId,
              sessionId: a.sessionId,
              dateTime: DateTime.now().toString(),
            ));
          }
        }
      }

      _showLogs("3._getOnlineOrderSTK _runLocalPrint: ${_dbPrintData.length}");

      // await DbLocalData.addAllPrintData(data: _dbPrintData);

      await _runLocalPrint(dbData: _dbPrintData, path: "getOnlineOrderStk");

      // kPrint("_isLoopPrinting: $_isLoopPrinting");
      _isLoopPrinting = false;
    }
  }

  static Future<void> _newOrderPopup({
    PlaceOrderInfo? printInfo,
  }) async {
    CusNotifyDia.show(payLoad: printInfo);
  }

  static Future<void> stkFromPopup({
    PlaceOrderInfo? printInfo,
    int? extendTimeInMin,
    bool bypass = true,
  }) async {
    final _getAuth = await SharedPrefs.isAuth;
    if (_getAuth != AuthStatus.AUTHENTICATE.name) return;

    if (printInfo == null) {
      kPrint('1');
      return;
    }

    _AutoSTKHandler.resetSTKTimer();

    await _sendToKitchen(
      orderId: printInfo.orderId,
      isOnline: true,
      bypass: bypass,
      extendedTime: extendTimeInMin,
      placeOrderInfo: printInfo,
      sessionId: printInfo.sessionId ?? '',
      posDeviceId: printInfo.posDeviceId ?? '',
      path: 'stkFromPopup',
    );
  }

  static Future<void> clearPrintDb({List<PlaceOrderInfo>? dbOrderData}) async {
    var _dbData = dbOrderData ?? (await DbLocalData.getPrintData());

    _dbData ??= [];

    final now = DateTime.now();

    final _newDBPrintList = <PlaceOrderInfo>[];

    for (final a in _dbData) {
      final _parsedDate = DateTime.tryParse(a.dateTime ?? '');

      final _isOneDayDiff = _parsedDate != null &&
          _parsedDate.year == now.year &&
          _parsedDate.month == now.month &&
          (_parsedDate.day - now.day).abs() < 2;

      if (_isOneDayDiff) {
        _newDBPrintList.add(a);
      }
    }

    await DbLocalData.addAllPrintData(data: _newDBPrintList);
  }

  static void _showLogs(String message) {
    // if (sendLogs)
    //   HttpLog.sendLog(
    //     method: "STK",
    //     url: '/stk\n: ${message.trim()}',
    //     header: {},
    //     statusCode: 200,
    //     duration: 0,
    //     response: message,
    //   );
  }
}

enum StkType { SendToKitchenPrinter, SendToKitchenDisplay }

class _AutoSTKHandler {
  static Timer? _stkTimer;

  static bool _isLoopRunning = false;

  static void startSTKLoop() {
    if (_isLoopRunning) return;

    _isLoopRunning = true;

    _runSTK();
  }

  static Future<void> _runSTK() async {
    if (!(await StkEventUtils.isAutoStkOnline)) {
      _isLoopRunning = false;
      return;
    }

    await StkEventUtils._getOnlineOrderSTK();

    _stkTimer?.cancel();

    _stkTimer = Timer(
      Duration(seconds: kDebugMode ? 300 : 120),
      () {
        _runSTK();
      },
    );
  }

  static void resetSTKTimer() {
    _stkTimer?.cancel();

    _stkTimer = Timer(
      Duration(seconds: kDebugMode ? 300 : 120),
      () {
        _runSTK();
      },
    );
  }
}
