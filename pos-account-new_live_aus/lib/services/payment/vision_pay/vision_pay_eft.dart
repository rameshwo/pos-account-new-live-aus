// import 'dart:async';
// import 'dart:convert';
// import 'dart:math';
// import 'package:flutter_http_logger/flutter_http_logger.dart';
// import 'package:pos_account/services/payment/vision_pay/model/vp_status.dart';

// import 'model/mcm.dart';
// import 'model/pos_trans_req.dart';
// import 'model/pos_trans_res.dart';
// import 'model/rm.dart';
// import 'model/vptm.dart';
// import 'usb_service_eft.dart';

// enum VisionPayType { Purchase, Refund, None }

// class VisionPayEFT {
//   static const String externalDeviceToken =
//       "C6104D16-67DB-4156-A86E-08DBFF9D7DF6";
//   static const int currency = 36; // AUD
//   static final Random rand = Random();
//   static int get _randInt4 => rand.nextInt(10000);

//   static Function()? load;
//   static final status = [VisionPayStatus(status: 0, message: "Processing")];

//   static String refId = "";

//   static void clear() {
//     status.clear();
//     status.add(VisionPayStatus(status: 0, message: "Processing"));
//     refId = "";
//   }

//   static void showMessage(int i, String message) {
//     // TODO: VISION TEST
//     // print("Message: $message");
//     status.add(VisionPayStatus(status: i, message: message));
//     if (load != null) load!();
//   }

//   static Future<VisionPayTransactionMessage?> processPayment({
//     required double amount,
//     VisionPayType type = VisionPayType.Purchase,
//   }) async {
//     USBServiceEFt.clearQueue();
//     showMessage(0, "Payment started");
//     // final amount = int.parse(await readInput());

//     refId = _randInt4.toString();

//     final posTransaction = PosTransactionReq(
//       externalDeviceToken: externalDeviceToken,
//       externalReference: refId,
//       transactionAmount: (amount * 100).floor(),
//       transactionCurrency: currency,
//       processType: type == VisionPayType.Refund ? 2 : 0,
//     );

//     try {
//       await USBServiceEFt.sendDataToTerminal(
//           json.encode(posTransaction.toJson()));

//       for (int i = 0; i < 10; i++) {
//         if (USBServiceEFt.queue.isEmpty) {
//           await Future.delayed(Duration(seconds: 1));
//         } else {
//           break;
//         }
//       }

//       if (USBServiceEFt.queue.isEmpty) {
//         showMessage(99, "Timeout");
//         return null;
//       }

// // TODO: VISION TEST
//       // print(
//       //     '-------Init Data added on quueu ${USBServiceEFt.queue.first}---------');

//       final tranRes =
//           PosTransactionRes.fromJson(json.decode(USBServiceEFt.queue.first));

//       HttpLog.sendLog(
//         method: "USB",
//         statusCode: 200,
//         url: "Process Transaction",
//         response: tranRes.toJson(),
//       );

//       if (tranRes.externalReference != null && tranRes.state == 1) {
//         return await _handleTransactionMessages(tranRes.externalReference!);
//       }
//     } catch (e) {
//       showMessage(999, e.toString());
//     }

//     return null;
//   }

//   static Future<VisionPayTransactionMessage?> _handleTransactionMessages(
//       String externalReference) async {
//     // TODO: VISION TEST
//     // int j = 0;
//     while (true) {
//       await Future.delayed(Duration(milliseconds: 100));
//       final message =
//           VisionPayTransactionMessage.fromJson(USBServiceEFt.getData);

//       HttpLog.sendLog(
//         method: "USB",
//         statusCode: 200,
//         url: "Handle Transaction",
//         response: message.toJson(),
//       );

// // TODO: VISION TEST
//       // print(
//       //     "-------JJJ --- ${++j}--- -${message.externalReference} == $externalReference ---- ${message.im30State}");

//       if (message.externalReference == externalReference) {
//         switch (message.im30State) {
//           case 0:
//             showMessage(10, "Awaiting Card Read...");
//             break;
//           case 1:
//             showMessage(11, "Card Read Success");
//             break;
//           case 2:
//             showMessage(12, "Card Read Failed");
//             // break;
//             return null;
//           case 3:
//             showMessage(13, "Sending Online...");
//             break;
//           case 4:
//             showMessage(14, "Sending Online Complete");
//             break;
//           case 5:
//             showMessage(15, "Sending Online Failed");
//             // break;
//             return null;
//           case 6:
//             showMessage(16, "Pre-Authorization Complete");
//             if (message.transactionStatus == 1) {
//               showMessage(161, "Transaction Approved");
//               // Proceed to capture
//               // TODO: VISION TEST
//               // USBServiceEFt.start = false;
//               return await _captureTransaction(
//                   externalReference, message.transactionAmount);
//             } else {
//               showMessage(169, "Transaction Declined");
//               return null;
//             }
//           case 98:
//             showMessage(98, "Transaction Cancelled");
//             // break;
//             return null;
//           case 99:
//             showMessage(99, "Transaction Timeout");
//             // break;
//             return null;
//           default:
//             if (USBServiceEFt.queue.length > 1) {
//               showMessage(199, "Failed State: ${message.im30State}");
//               return null;
//             } else
//               break;
//         }
//       }
//     }
//   }

//   static Future<VisionPayTransactionMessage?> _captureTransaction(
//       String? externalReference, int? amount) async {
//     showMessage(0, "Capturing Transaction...");

//     final captureTransaction = PosTransactionReq(
//       externalDeviceToken: externalDeviceToken,
//       externalReference: externalReference ?? '',
//       transactionAmount: amount ?? 0,
//       transactionCurrency: currency,
//       processType: 1,
//     );

//     await USBServiceEFt.sendDataToTerminal(
//         json.encode(captureTransaction.toJson()));

//     // Await capture confirmation
//     // TODO: VISION TEST
//     // int k = 0;
//     while (true) {
//       await Future.delayed(Duration(milliseconds: 100));
//       final message =
//           VisionPayTransactionMessage.fromJson(USBServiceEFt.getData);

//       HttpLog.sendLog(
//         method: "USB",
//         statusCode: 200,
//         url: "Capture Transaction",
//         response: message.toJson(),
//       );
// // TODO: VISION TEST
//       // print(
//       //     "-------KKK --- ${++k}--- -${message.externalReference} == $externalReference::: ${message.im30State}");

//       if (message.externalReference == externalReference) {
//         switch (message.im30State) {
//           case 0:
//             break;
//           case 7:
//             showMessage(10, "Sending Capture...");
//             break;
//           case 8:
//             if (message.transactionStatus == 1) {
//               showMessage(16181, "Capture Completed Successfully");
//               await Future.delayed(Duration(seconds: 1));
//               return message;
//             } else {
//               showMessage(12, "Capture Failed");
//               return null;
//             }
//           case 9:
//             showMessage(12, "Capture Failed");
//             return null;
//           default:
//             // showMessage(
//             //     199, "Cancelled (" + message.im30State.toString() + ")");
//             break;
//         }
//       }
//     }
//   }

//   static Future<bool?> cancelTransaction({
//     required double amount,
//   }) async {
//     USBServiceEFt.clearQueue();

//     final posTransaction = PosTransactionReq(
//       externalDeviceToken: externalDeviceToken,
//       externalReference: refId,
//       transactionAmount: (amount * 100).floor(),
//       transactionCurrency: currency,
//       processType: 99,
//     );

//     try {
//       // TODO: VISION TEST
//       // USBServiceEFt.queue.add(json.encode(_cancelledData));

//       await USBServiceEFt.sendDataToTerminal(
//           json.encode(posTransaction.toJson()));
//       return true;
//     } catch (e) {
//       showMessage(999, e.toString());
//     }

//     return null;
//   }

//   static Future<MagneticCardMessage?> processMagneticCard({
//     required int amount,
//   }) async {
//     showMessage(0, "Magnetic Payment started");
//     USBServiceEFt.clearQueue();
//     // Similar to processPayment, but adapted for magnetic card processing.

//     refId = _randInt4.toString();

//     final transaction = PosTransactionReq(
//       externalDeviceToken: externalDeviceToken,
//       externalReference: refId,
//       transactionAmount: (amount * 100).floor(), // 0
//       transactionCurrency: currency, // 0
//       processType: 3,
//     );

//     try {
//       await USBServiceEFt.sendDataToTerminal(json.encode(transaction.toJson()));

//       final tranRes =
//           PosTransactionRes.fromJson(json.decode(USBServiceEFt.queue.first));

//       if (tranRes.state == 1) {
//         while (true) {
//           await Future.delayed(Duration(milliseconds: 100));
//           final magneticMessage =
//               MagneticCardMessage.fromJson(USBServiceEFt.getData);
//           switch (magneticMessage.magneticState) {
//             case 0:
//               showMessage(10, "Awaiting Card Read...");
//               break;
//             case 1:
//               showMessage(11, "Magnetic Card Read Success");
//               // Process track data
//               // showMessage("Track Data 1: " + magneticMessage.trackData1!);
//               // showMessage("Track Data 2: " + magneticMessage.trackData2!);
//               // showMessage("Track Data 3: " + magneticMessage.trackData3!);
//               return magneticMessage;
//             case 2:
//               showMessage(15, "Magnetic Card Read Failed");
//               return null;
//             default:
//               return null;
//           }
//         }
//       } else {
//         showMessage(
//             199, "Magnetic Transaction rejected: ${tranRes.errorMessage}");
//       }
//     } catch (e) {
//       showMessage(999, e.toString());
//     }

//     return null;
//   }

//   static Future<ReceiptMessage?> processReceipt({
//     required int amount,
//   }) async {
//     USBServiceEFt.clearQueue();
//     // Similar to processPayment, but adapted for receipt processing.

//     showMessage(0, "Processing Receipt...");

//     refId = _randInt4.toString();

//     final transaction = PosTransactionReq(
//       externalDeviceToken: externalDeviceToken,
//       externalReference: refId,
//       transactionAmount: (amount * 100).floor(), // 0
//       transactionCurrency: currency, // 0
//       processType: 4,
//     );

//     try {
//       await USBServiceEFt.sendDataToTerminal(json.encode(transaction.toJson()));

//       final tranRes =
//           PosTransactionRes.fromJson(json.decode(USBServiceEFt.queue.first));

//       if (tranRes.state == 1) {
//         while (true) {
//           await Future.delayed(Duration(milliseconds: 100));
//           final receiptMessage = ReceiptMessage.fromJson(USBServiceEFt.getData);
//           switch (receiptMessage.receiptState) {
//             case 0:
//               showMessage(10, "Awaiting Card Read...");
//               break;
//             case 1:
//               showMessage(11, "Receipt Read Success");
//               // showMessage("Card Signature: " + receiptMessage.cardSignature!);
//               return receiptMessage;
//             case 2:
//               showMessage(12, "Receipt Read Failed");
//               return null;
//             default:
//               break;
//             // return null;
//           }
//         }
//       } else {
//         showMessage(
//             199, "Receipt Transaction rejected: ${tranRes.errorMessage}");
//       }
//     } catch (e) {
//       showMessage(999, e.toString());
//     }
//     return null;
//   }
// }

// // final _cancelledData = {
// //   "applicationId": "",
// //   "applicationLabel": "",
// //   "applicationTransactionCounter": 0,
// //   "authorizationId": "",
// //   "authorizationType": 99,
// //   "cardExpiryDate": "",
// //   "cardSequenceNumber": "",
// //   "cardSignature": "",
// //   "cardType": "",
// //   "cardVerificationMethod": 0,
// //   "completedUTCDateTime": "2024-11-07 10:40:09.081",
// //   "createdUTCDateTime": "2024-11-07 10:40:08.912",
// //   "externalReference": "7180",
// //   "gatewayResponse": "",
// //   "gatewayResponseCode": "",
// //   "im30Reference": "",
// //   "im30State": 98,
// //   "im30TerminalId": "15000001",
// //   "merchantId": "",
// //   "stan": "",
// //   "transactionAmount": 500,
// //   "transactionCurrency": 36,
// //   "transactionStatus": 0,
// //   "transactionType": 0
// // };
