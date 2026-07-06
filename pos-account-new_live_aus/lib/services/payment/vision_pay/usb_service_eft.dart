// import 'dart:convert';
// import 'dart:async';
// import 'package:flutter/services.dart';
// import 'package:oktoast/oktoast.dart';
// import 'package:pos_account/ln.dart';
// import 'package:pos_account/repository/if_exception.dart';
// import 'package:usb_serial/usb_serial.dart';

// class USBServiceEFt {
//   static final usbDevices = <UsbDevice>[];
//   static UsbDevice? connectedUsb;
//   static UsbPort? usbPort;

//   static final queue = <String>[];

//   static Future<void> scanDevice() async {
//     // TODO: VISION TEST
//     // await Future.delayed(Duration(seconds: 1));
//     // usbDevices.clear();
//     // usbDevices.add(UsbDevice("Device Name1", 1, 1, "productName",
//     //     "manufacturerName", 200, "seruak", 3));

//     try {
//       final deviceList = await UsbSerial.listDevices();
//       usbDevices.clear();
//       usbDevices.addAll(deviceList);
//     } on PlatformException catch (e) {
//       showToast("${LN.platformError}: ${e.message}");
//     } catch (e) {
//       showToast("${LN.unexpectedError}: ${e.toString()}");
//     }
//   }

//   static Future<void> connectDevice(int i, {bool showMessage = true}) async {
//     // TODO: VISION TEST
//     try {
//       usbPort = await usbDevices[i].create();

//       final openResult = (await usbPort?.open()) ?? false;
//       if (!openResult) {
//         showToast("${LN.failedToOpenPort}.");
//       }

//       usbPort?.setDTR(true);
//       usbPort?.setRTS(true);
//       usbPort?.setPortParameters(
//           115200, UsbPort.DATABITS_8, UsbPort.STOPBITS_1, UsbPort.PARITY_NONE);
//       //

//       connectedUsb = usbDevices[i];

//       if (showMessage)
//         IfException.showMessage(
//             message: LN.successfullyConnected, isError: false);
//     } catch (e) {
//       if (showMessage) IfException.showMessage(message: LN.connectionFailed);
//     }
//     _startReceiver();
//   }

//   static Future<void> disconnectDevice() async {
//     usbPort?.close();

//     usbPort = null;
//     connectedUsb = null;
//   }

//   // TODO: VISION TEST
//   // static bool start = false;
//   // static int i = 0;

//   static void _startReceiver() async {
//     // TODO: VISION TEST
//     // while (true) {
//     //   await Future.delayed(Duration(milliseconds: 1000));
//     //   if (start && _dataList.length > i) {
//     //     print("Data: ${_dataList[i]}");
//     //     queue.add(json.encode(_dataList[i]));
//     //     i++;
//     //   }
//     //   print('----------listening usb data-----$i--${queue.length}-------');
//     // }
//     usbPort?.inputStream?.listen((data) {
//       final receivedData = utf8.decode(data);
//       queue.add(receivedData);
//     });
//   }

//   static void clearQueue() {
//     queue.clear();
//     // TODO: VISION TEST
//     // i = 0;
//     // start = false;
//   }

//   static Future<void> sendDataToTerminal(String message) async {
//     try {
//       await usbPort?.write(Uint8List.fromList(message.codeUnits));

// // TODO: VISION TEST
//       // await Future.delayed(Duration(milliseconds: 500));
//       // start = true;
//       // print("---Data sent to terminal");
//     } catch (e) {
//       showToast("Error: send data to terminal :$e");
//       usbPort?.close();
//     }
//   }

//   static Map<String, dynamic> get getData {
//     if (queue.isEmpty) return {};

//     return json.decode(queue.last);
//   }
// }

// // TODO: VISION TEST
// // final _dataList = [
// //   {"externalReference": "7180", "im30Reference": "", "state": 1},
// //   {
// //     "applicationId": "",
// //     "applicationLabel": "",
// //     "applicationTransactionCounter": 0,
// //     "authorizationId": "",
// //     "authorizationType": 99,
// //     "cardExpiryDate": "",
// //     "cardSequenceNumber": "",
// //     "cardSignature": "",
// //     "cardType": "",
// //     "cardVerificationMethod": 0,
// //     "completedUTCDateTime": "2024-11-07 10:40:09.081",
// //     "createdUTCDateTime": "2024-11-07 10:40:08.912",
// //     "externalReference": "7180",
// //     "gatewayResponse": "",
// //     "gatewayResponseCode": "",
// //     "im30Reference": "",
// //     "im30State": 0,
// //     "im30TerminalId": "15000001",
// //     "merchantId": "",
// //     "stan": "",
// //     "transactionAmount": 500,
// //     "transactionCurrency": 36,
// //     "transactionStatus": 0,
// //     "transactionType": 0
// //   },
// //   {
// //     "applicationId": "A0000000031010",
// //     "applicationLabel": "Visa Debit",
// //     "applicationTransactionCounter": 88,
// //     "authorizationId": "",
// //     "authorizationType": 0,
// //     "cardExpiryDate": "2506",
// //     "cardSequenceNumber": "0",
// //     "cardSignature": "464579**********7361",
// //     "cardType": "VISA",
// //     "cardVerificationMethod": 0,
// //     "completedUTCDateTime": "2024-11-07 10:40:17.781",
// //     "createdUTCDateTime": "2024-11-07 10:40:08.912",
// //     "externalReference": "7180",
// //     "gatewayResponse": "",
// //     "gatewayResponseCode": "",
// //     "im30Reference": "",
// //     "im30State": 1,
// //     "im30TerminalId": "15000001",
// //     "merchantId": "",
// //     "stan": "",
// //     "transactionAmount": 500,
// //     "transactionCurrency": 36,
// //     "transactionStatus": 0,
// //     "transactionType": 0
// //   },
// //   {
// //     "applicationId": "A0000000031010",
// //     "applicationLabel": "Visa Debit",
// //     "applicationTransactionCounter": 88,
// //     "authorizationId": "",
// //     "authorizationType": 0,
// //     "cardExpiryDate": "2506",
// //     "cardSequenceNumber": "0",
// //     "cardSignature": "464579**********7361",
// //     "cardType": "VISA",
// //     "cardVerificationMethod": 0,
// //     "completedUTCDateTime": "2024-11-07 10:40:17.796",
// //     "createdUTCDateTime": "2024-11-07 10:40:08.912",
// //     "externalReference": "7180",
// //     "gatewayResponse": "",
// //     "gatewayResponseCode": "",
// //     "im30Reference": "",
// //     "im30State": 3,
// //     "im30TerminalId": "15000001",
// //     "merchantId": "",
// //     "stan": "",
// //     "transactionAmount": 500,
// //     "transactionCurrency": 36,
// //     "transactionStatus": 0,
// //     "transactionType": 0
// //   },
// //   {
// //     "applicationId": "A0000000031010",
// //     "applicationLabel": "Visa Debit",
// //     "applicationTransactionCounter": 88,
// //     "authorizationId": "",
// //     "authorizationType": 0,
// //     "cardExpiryDate": "2506",
// //     "cardSequenceNumber": "0",
// //     "cardSignature": "464579**********7361",
// //     "cardType": "VISA",
// //     "cardVerificationMethod": 0,
// //     "completedUTCDateTime": "2024-11-07 10:40:47.925",
// //     "createdUTCDateTime": "2024-11-07 10:40:08.912",
// //     "externalReference": "7180",
// //     "gatewayResponse": "",
// //     "gatewayResponseCode": "",
// //     "im30Reference": "",
// //     "im30State": 4,
// //     "im30TerminalId": "15000001",
// //     "merchantId": "",
// //     "stan": "",
// //     "transactionAmount": 500,
// //     "transactionCurrency": 36,
// //     "transactionStatus": 99,
// //     "transactionType": 0
// //   },
// //   {
// //     "applicationId": "A0000000031010",
// //     "applicationLabel": "Visa Debit",
// //     "applicationTransactionCounter": 88,
// //     "authorizationId": "",
// //     "authorizationType": 0,
// //     "cardExpiryDate": "2506",
// //     "cardSequenceNumber": "0",
// //     "cardSignature": "464579**********7361",
// //     "cardType": "VISA",
// //     "cardVerificationMethod": 0,
// //     "completedUTCDateTime": "2024-11-07 10:40:47.966",
// //     "createdUTCDateTime": "2024-11-07 10:40:08.912",
// //     "externalReference": "7180",
// //     "gatewayResponse": "",
// //     "gatewayResponseCode": "",
// //     "im30Reference": "",
// //     "im30State": 6,
// //     "im30TerminalId": "15000001",
// //     "merchantId": "",
// //     "stan": "",
// //     "transactionAmount": 500,
// //     "transactionCurrency": 36,
// //     "transactionStatus": 1,
// //     "transactionType": 0
// //   },
// //   {"externalReference": "7180", "im30Reference": "", "state": 1},
// //   {
// //     "applicationId": "",
// //     "applicationLabel": "",
// //     "applicationTransactionCounter": 0,
// //     "authorizationId": "",
// //     "authorizationType": 99,
// //     "cardExpiryDate": "",
// //     "cardSequenceNumber": "",
// //     "cardSignature": "",
// //     "cardType": "",
// //     "cardVerificationMethod": 0,
// //     "completedUTCDateTime": "2024-11-07 10:41:01.358",
// //     "createdUTCDateTime": "2024-11-07 10:41:01.335",
// //     "externalReference": "7180",
// //     "gatewayResponse": "",
// //     "gatewayResponseCode": "",
// //     "im30Reference": "",
// //     "im30State": 7,
// //     "im30TerminalId": "15000001",
// //     "merchantId": "",
// //     "stan": "",
// //     "transactionAmount": 500,
// //     "transactionCurrency": 36,
// //     "transactionStatus": 0,
// //     "transactionType": 0
// //   },
// //   {
// //     "applicationId": "",
// //     "applicationLabel": "",
// //     "applicationTransactionCounter": 0,
// //     "authorizationId": "",
// //     "authorizationType": 99,
// //     "cardExpiryDate": "",
// //     "cardSequenceNumber": "",
// //     "cardSignature": "",
// //     "cardType": "",
// //     "cardVerificationMethod": 0,
// //     "completedUTCDateTime": "2024-11-07 10:41:01.358",
// //     "createdUTCDateTime": "2024-11-07 10:41:01.335",
// //     "externalReference": "7180",
// //     "gatewayResponse": "",
// //     "gatewayResponseCode": "",
// //     "im30Reference": "",
// //     "im30State": 8,
// //     "im30TerminalId": "15000001",
// //     "merchantId": "",
// //     "stan": "",
// //     "transactionAmount": 500,
// //     "transactionCurrency": 36,
// //     "transactionStatus": 1,
// //     "transactionType": 0
// //   },
// // ];
