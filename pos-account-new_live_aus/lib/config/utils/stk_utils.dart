// import 'dart:async';
// import 'dart:convert';
// import 'package:flutter/foundation.dart';
// import 'package:pos_account/constant/constant.dart';
// import 'package:pos_account/ln.dart';
// import 'package:pos_account/model/home/menu/signal_r/place_order_info.dart';
// import 'package:pos_account/providers/auth/auth_pro.dart';
// import 'package:pos_account/repository/handler.dart';
// import 'package:pos_account/services/database/database/db_local_data.dart';
// import 'package:pos_account/services/database/shared_pref.dart';
// import 'package:pos_account/services/printer/com/send_to_kitchen_print.dart';
// import '../../model/home/menu/place_order/place_order_res.dart';
// import '../../model/home/menu/place_order/pos_res/store_information.dart';

// class StkUtils {
//   // static Future<void> onReceiveOrderToPrint({
//   //   required List<PlaceOrderRes> data,
//   // }) async {
//   //   if (data.isEmpty) return;

//   //   await SendToKitchenPrint.spdSendToKitchen(
//   //     CUS_CTX,
//   //     order: data.first,
//   //     runSuccessFun: () async {
//   //       _confirmOrderStk(orderId: data.first.orderId);
//   //     },
//   //     showMsg: false,
//   //     showLoading: true,
//   //   );
//   // }

//   // static bool _isConfirmOrderCalled = false;

//   static Future<bool?> _confirmOrderStk({String? orderId}) async {
//     if (orderId == null) return null;

//     // _isConfirmOrderCalled = true;
//     // kPrint("confirmOrderSendToKitPrint start");
//     return await Handler.confirmOrderSendToKitPrint(data: [
//       {"Id": orderId, "Name": ""}
//     ]);

//     // kPrint("confirmOrderSendToKitPrint end");
//     // _isConfirmOrderCalled = false;
//   }

//   // static Future<bool?> sendToKD({
//   //   String? orderId,
//   //   bool stkDisplay = true,
//   //   bool bypass = false,
//   // }) async {
//   //   if (orderId == null) return null;

//   //   final _storeData = await _getStoreInfo;

//   //   kPrint(
//   //       "sendToKitchenDisplay  $orderId | stkDisplay: $stkDisplay  ||| isSendToKitchenDisplay: ${(_storeData?.isSendToKitchenDisplay ?? false)} | bypass: $bypass");

//   //   if (stkDisplay &&
//   //       (bypass || (_storeData?.isSendToKitchenDisplay ?? false))) {
//   //     return await Handler.posOrderStkitDisplay(
//   //         req: PlaceOrderInfo(orderId: orderId));
//   //   }

//   //   return false;
//   // }

//   static Future<bool?> sendToKitchen({
//     String? orderId,
//     bool stkPrinter = true,
//     required bool stkDisplay,
//     bool isOnline = false,
//     String path = "",
//     bool bypass = false,
//     int? extendedTime,
//   }) async {
//     if (orderId == null) return null;

//     final _storeData = await _getStoreInfo;

//     bool? _status;

//     // kPrint(
//     //     "sendToKitchen path: $path | stkPrinter: $stkPrinter | $orderId  ||| ${(_storeData?.isSendToKitchenDisplay ?? false)} | bypass: $bypass");

//     final _stkPrinter =
//         stkPrinter && (bypass || (_storeData?.isSendToKitchenPrinter ?? false));

//     final _stkDisplay =
//         stkDisplay && (bypass || (_storeData?.isSendToKitchenDisplay ?? false));

//     if (_stkPrinter || _stkDisplay) {
//       final _value = await Handler.posOrderStkPrinter(
//         req: PlaceOrderInfo(
//           orderId: orderId,
//           extendedPickupDeliveryTimeInMins:
//               extendedTime == null ? null : "$extendedTime",
//           isSendToKitchenPrinter: _stkPrinter,
//           isSendToKitchenDisplay: _stkDisplay,
//         ),
//       );
//       if (_stkPrinter && _value != null) {
//         if (isOnline) {
//           _value.askForPrintConfirmation = false;
//         }
//         await SendToKitchenPrint.stkPos(
//           CUS_CTX,
//           order: _value,
//           runSuccessFun: () async {
//             _status = await _confirmOrderStk(orderId: _value.orderId);
//           },
//         );
//       }
//     }
//     return _status;
//   }

//   static Future<void> sendTokitchenOrder({
//     PlaceOrderRes? res,
//   }) async {
//     SendToKitchenPrint.stkPos(
//       CUS_CTX,
//       order: res,
//       runSuccessFun: () async {
//         _confirmOrderStk(orderId: res?.orderId);
//       },
//     );

//     // if (GlobalCVP.storeInfo?.isSendToKitchenDisplay ?? false) {
//     //   Handler.posOrderStkitDisplay(req: data);
//     // }
//   }

//   static Future<StoreInformation?> get _getStoreInfo async {
//     final _dbData = await DbLocalData.getAllAddSection();
//     if (_dbData != null) {
//       final _storeInfo = StoreInformation.fromJson(_dbData["storeInformation"]);
//       return _storeInfo;
//     } else {
//       return null;
//     }
//   }

//   static Future<bool> get isAutoStkOnline async {
//     final _getAuth = await SharedPrefs.isAuth;
//     final _storeData = await _getStoreInfo;

//     return _getAuth == AuthStatus.AUTHENTICATE.name &&
//         (_storeData?.autoSendToKitchenOnlineOrder ?? false);
//   }

//   static Future<void> listenOnlineOrder() async {
//     await Future.delayed(Duration(seconds: 10));
//     _AutoSTKHandler.startSTKLoop();
//     // if (await isAutoStkOnline) {
//     //   Future.doWhile(() async {
//     //     if (await isAutoStkOnline) {
//     //       if (!_isPrinting) {
//     //         // print('--------------------online send to kitchen -----------');
//     //         await getOnlineOrderSTK();
//     //       }
//     //     } else {
//     //       return false;
//     //     }

//     //     await Future.delayed(Duration(seconds: kDebugMode ? 300 : 120));

//     //     return true;
//     //   });
//     // }
//   }

//   static bool _isPrinting = false;

//   static List<String?>? _printOrderIds = [];

//   static Future<void> getOnlineOrderSTK() async {
//     if (await isAutoStkOnline) {
//       final _data = await Handler.getOnlineOrderFotSTK();
//       _printOrderIds = _data?.map((a) => a.id).toList();

//       // kPrint("getOnlineOrderSTK data: ${_data?.map((a) => a.id).toList()} ");

//       // if (_data?.isNotEmpty ?? false) {
//       //   if (!isAppOpen) {
//       //     await NotificationApi.showSyncNotification(
//       //       id: 11,
//       //       title: "POSApt",
//       //       body:
//       //           "Sending orders${(_data?.length ?? 0) == 0 ? '' : '(${_data?.length})'} to Kitchen",
//       //     );
//       //   }

//       //   bool? _sendTokD;

//       //   for (final e in _data!) {
//       //     // Tts.speak(text: 'New online order received!');
//       //     _sendTokD = await sendToKD(
//       //       orderId: e.id,
//       //       stkDisplay: e.name == StkType.SendToKitchenDisplay.name,
//       //       bypass: !isAppOpen,
//       //     );
//       //   }

//       //   if (!isAppOpen && (_sendTokD ?? false)) {
//       //     await NotificationApi.showSyncNotification(
//       //       id: 11,
//       //       title: "POSApt",
//       //       body: "Orders sent to Kitchen",
//       //     );
//       //   }
//       // }

//       if (_isPrinting) {
//         await Future.doWhile(() async {
//           // kPrint("getOnlineOrderSTK waiting .. $_isPrinting");
//           await Future.delayed(Duration(seconds: 2));
//           return _isPrinting;
//         });
//         // kPrint("getOnlineOrderSTK wait over. ");
//       }

//       if (!_isPrinting) {
//         _isPrinting = true;

//         if (_data?.isNotEmpty ?? false) {
//           for (final e in _data!) {
//             // Tts.speak(text: 'New online order received!');
//             await sendToKitchen(
//               orderId: e.id,
//               isOnline: true,
//               stkPrinter: e.name == StkType.SendToKitchenPrinter.name,
//               stkDisplay: false,
//             );
//           }
//         }
//       }
//       _isPrinting = false;
//     }
//     _printOrderIds = [];
//   }

//   // static Future<void> printFromFirebase(SyncNotiData _syncData) async {
//   //   await getOnlineOrderSTK();
//   // }

//   static Future<void> newOrderStk(
//     String payload, {
//     int? extendTimeInMin,
//     bool bypass = true,
//     required isNewOrderPopup,
//   }) async {
//     final _getAuth = await SharedPrefs.isAuth;
//     if (_getAuth != AuthStatus.AUTHENTICATE.name) return;

//     final _payload = json.decode(payload);

//     if (_payload == null) {
//       kPrint('1');
//       return;
//     }

//     // final _orderDataList =
//     //     List<CuisineType>.from(_payload.map((x) => CuisineType.fromJson(x)));

//     final Map<String, List<String>> grouped = {};

//     for (var item in _payload) {
//       if (item['Id'] != null && item['Name'] != null) {
//         grouped.putIfAbsent(item['Id'], () => []);
//         grouped[item['Id']]!.add(item['Name']);
//       }
//     }

//     final result = grouped.entries
//         .map(
//           (e) => _GroupedPrintModel(
//             id: e.key,
//             nameList: e.value,
//           ),
//         )
//         .toList();

//     if (_isPrinting) {
//       // This handles when order already came on timer function and printing, if the same id is coming from firebase lately, on that case, order is not printed from firebase.
//       if (_printOrderIds?.any((a) =>
//               (a?.isNotEmpty ?? false) &&
//               result.any((b) => b.id.toLowerCase() == a?.toLowerCase())) ??
//           false) {
//         kPrint('2');
//         return;
//       }

//       await Future.doWhile(() async {
//         kPrint("New Order waiting .. $_isPrinting");
//         await Future.delayed(Duration(seconds: 2));
//         return _isPrinting;
//       });
//       // kPrint("getOnlineOrderSTK wait over. ");
//     }

//     kPrint('3');

//     if (!_isPrinting) {
//       _isPrinting = true;
//       _AutoSTKHandler.resetSTKTimer();

//       kPrint(
//           'Firebase order Id: ${result.map((a) => "${a.id} : ${a.nameList}").toList()}');

//       for (final a in result) {
//         await sendToKitchen(
//           orderId: a.id,
//           isOnline: true,
//           stkPrinter:
//               a.nameList.any((b) => b == StkType.SendToKitchenPrinter.name),
//           stkDisplay: isNewOrderPopup &&
//               a.nameList.any((b) => b == StkType.SendToKitchenDisplay.name),
//           bypass: bypass,
//           extendedTime: extendTimeInMin,
//         );
//       }
//     }

//     _isPrinting = false;
//   }

//   static clear() {
//     _isPrinting = false;
//   }
// }

// enum StkType { SendToKitchenPrinter, SendToKitchenDisplay }

// class _AutoSTKHandler {
//   static Timer? _stkTimer;

//   static bool _isLoopRunning = false;

//   static void startSTKLoop() {
//     if (_isLoopRunning) return;

//     _isLoopRunning = true;

//     _runSTK();
//   }

//   static Future<void> _runSTK() async {
//     if (!(await StkUtils.isAutoStkOnline)) {
//       _isLoopRunning = false;
//       return;
//     }

//     if (!StkUtils._isPrinting) {
//       await StkUtils.getOnlineOrderSTK();
//     }

//     _stkTimer?.cancel();

//     _stkTimer = Timer(
//       Duration(seconds: kDebugMode ? 300 : 120),
//       () {
//         _runSTK();
//       },
//     );
//   }

//   static void resetSTKTimer() {
//     _stkTimer?.cancel();

//     _stkTimer = Timer(
//       Duration(seconds: kDebugMode ? 300 : 120),
//       () {
//         _runSTK();
//       },
//     );
//   }

//   // static void stopSTKLoop() {
//   //   _stkTimer?.cancel();
//   //   _stkTimer = null;
//   //   _isLoopRunning = false;
//   // }
// }

// class _GroupedPrintModel {
//   final String id;
//   final List<String> nameList;

//   _GroupedPrintModel({
//     required this.id,
//     required this.nameList,
//   });
// }
