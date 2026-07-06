// import 'package:flutter/material.dart';
// import 'package:pos_account/config/size_config.dart';
// import 'package:pos_account/constant/constant.dart';
// import 'package:pos_account/ln.dart';
// import 'package:pos_account/model/home/menu/place_order/po_pay_sec_list_res.dart';
// import 'package:pos_account/providers/common/eftpro.dart';
// import 'package:pos_account/services/payment/vision_pay/model/vptm.dart';
// import 'package:pos_account/services/payment/vision_pay/vision_pay_eft.dart';
// import 'package:pos_account/widgets/loading.dart';
// import 'package:provider/provider.dart';

// class VisionPayEftDia extends StatefulWidget {
//   final double amount;
//   final VisionPayType type;
//   final bool askToCancel;
//   final EftposMerchantList? terminal;

//   const VisionPayEftDia({
//     super.key,
//     required this.amount,
//     this.type = VisionPayType.None,
//     this.askToCancel = false,
//     required this.terminal,
//   });

//   static Future<VisionPayTransactionMessage?> showDia(
//     BuildContext context, {
//     required double amount,
//     required VisionPayType type,
//     bool askToCancel = false,
//     EftposMerchantList? terminal,
//   }) async {
//     return await showDialog(
//         context: context,
//         barrierDismissible: false,
//         builder: (_) {
//           return SimpleDialog(
//             backgroundColor: kBackgroundColor,
//             titlePadding: EdgeInsets.zero,
//             contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
//             shape:
//                 RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
//             children: [
//               VisionPayEftDia(
//                 amount: amount,
//                 type: type,
//                 askToCancel: askToCancel,
//                 terminal: terminal,
//               )
//             ],
//           );
//         });
//   }

//   @override
//   State<VisionPayEftDia> createState() => _VisionPayEftDiaState();
// }

// class _VisionPayEftDiaState extends State<VisionPayEftDia> {
//   @override
//   void initState() {
//     super.initState();
//     VisionPayEFT.load = load;
//     _setData();
//   }

//   Future<void> _setData() async {
//     if (widget.terminal?.eftposPaymentProviderListModels == null) return;

//     // if (USBServiceEFt.usbDevices.isEmpty) {
//     //   await USBServiceEFt.scanDevice();
//     // }

//     // WindcaveHandler.wCConsoleData +=
//     //     USBServiceEFt.usbDevices.map((e) => "${e.pid},").toList().toString() +
//     //         '\n\n\n\n';

//     // USBServiceEFt.connectedUsb = null;

//     // if (USBServiceEFt.connectedUsb == null) {
//     // for (final e in widget.terminal!.eftposPaymentProviderListModels!) {
//     // final pId = double.tryParse(e.serialNumber ?? '')?.floor();
//     // WindcaveHandler.wCConsoleData +=
//     //     "_pId: $_pId | isDefault: ${e.isDefault} | ${USBServiceEFt.usbDevices.any((f) => f.pid == _pId)}\n\n\n\n";
//     // if (pId != null &&
//     //     (e.isDefault ?? false) &&
//     //     USBServiceEFt.usbDevices.any((f) => f.pid == pId)) {
//     //   final usbIndex =
//     //       USBServiceEFt.usbDevices.indexWhere((f) => f.pid == pId);
//     //   await USBServiceEFt.connectDevice(usbIndex, showMessage: false);
//     //   // WindcaveHandler.wCConsoleData +=
//     //   //     "Connect: ${USBServiceEFt.connectedUsb?.pid}\n\n\n\n";
//     // }
//     // }

//     load();
//   }

//   load() {
//     if (mounted) setState(() {});
//   }

//   bool loading = false;

//   @override
//   void dispose() {
//     VisionPayEFT.load = null;
//     VisionPayEFT.clear();
//     // USBServiceEFt.clearQueue();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final size = Ssize(context);
//     final eftPro = Provider.of<EftPro>(context);

//     final failed = [12, 15, 169, 98, 99, 199, 999]
//         .any((e) => e == VisionPayEFT.status.last.status);

//     return Processing(
//       loading: loading,
//       child: Container(
//         constraints: BoxConstraints(
//           maxHeight: size.height / 1.11,
//           minHeight: size.height / 5,
//         ),
//         width: size.width / 3,
//         padding: EdgeInsets.symmetric(
//             horizontal: size.getW(0), vertical: size.getH(12)),
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             if (VisionPayEFT.status.last.status == 16181)
//               _tranSuccess(size)
//             else if (eftPro.payloading && !failed)
//               _transcationSec(size, eftPro: eftPro)
//             else ...[
//               Row(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text.rich(
//                     TextSpan(
//                       text: LN.chooseTerminal,
//                     ),
//                     style: TextStyle(
//                       fontSize: size.getS(22),
//                       fontWeight: FontWeight.bold,
//                       color: Colors.black,
//                       height: 1.4,
//                     ),
//                   ),
//                   Spacer(),
//                   Container(
//                       decoration: BoxDecoration(
//                         color: Colors.red.shade800,
//                         shape: BoxShape.circle,
//                       ),
//                       child: InkWell(
//                         onTap: () async {
//                           // if (widget.askToCancel)
//                           //   await showDialog(
//                           //       context: context,
//                           //       builder: (_) {
//                           //         return ConfirmDialog(
//                           //           title: "Transaction Aborted?",
//                           //           subTitle:
//                           //               "Transaction Incomplete! Clicking 'OK' will result in losing this transaction.",
//                           //           onDelete: () async {
//                           //             await Future.delayed(
//                           //                 Duration(milliseconds: 500));
//                           //             Navigator.of(context).pop();

//                           //             return null;
//                           //           },
//                           //           actionText: LN.ok,
//                           //           cancelText: LN.no,
//                           //         );
//                           //       });
//                           // else
//                           Navigator.pop(context);
//                         },
//                         child: Padding(
//                           padding: EdgeInsets.symmetric(
//                               horizontal: size.getS(8), vertical: size.getS(8)),
//                           child: Icon(
//                             Icons.close,
//                             color: Colors.white,
//                           ),
//                         ),
//                       )),
//                 ],
//               ),
//               if (failed)
//                 _transFailedSec(size, eftPro: eftPro)
//               else if (eftPro.pageLoad)
//                 SizedBox(
//                   height: size.getH(100),
//                   child: Loading(),
//                 )
//               // else if (USBServiceEFt.connectedUsb == null)
//               //   _unpaired(size)
//               else
//                 _initPayment(size, eftPro: eftPro)
//             ],
//             SizedBox(
//               height: size.getH(12),
//             )
//           ],
//         ),
//       ),
//     );
//   }

//   // Widget _terminalStatus(
//   //   Ssize size, {
//   //   required String status,
//   //   required Color color,
//   // }) {
//   //   return Row(
//   //     children: [
//   //       Text(
//   //         "Terminal Status",
//   //         style: TextStyle(
//   //           fontSize: size.getS(20),
//   //           fontFamily: kFontFMedium,
//   //           color: Colors.black,
//   //         ),
//   //       ),
//   //       Spacer(),
//   //       Container(
//   //         decoration: BoxDecoration(
//   //             color: color, borderRadius: BorderRadius.circular(40)),
//   //         padding: EdgeInsets.symmetric(
//   //             horizontal: size.getW(24), vertical: size.getH(8)),
//   //         child: Text(
//   //           status,
//   //           style: TextStyle(
//   //             fontSize: size.getS(18),
//   //             fontFamily: kFontFMedium,
//   //             color: Colors.white,
//   //           ),
//   //         ),
//   //       ),
//   //     ],
//   //   );
//   // }

//   // Widget _unpaired(Ssize size) {
//   //   return Column(
//   //     children: [
//   //       SizedBox(
//   //         height: size.getH(24),
//   //       ),
//   //       _terminalStatus(size, status: "Disconnected", color: Colors.red),
//   //       SizedBox(
//   //         height: size.getH(36),
//   //       ),
//   //       LoadButton(
//   //         btnColor: kSecondaryColor,
//   //         width: double.infinity,
//   //         btnText: "Connect",
//   //         onsave: () async {
//   //           Navigator.pop(context);
//   //           await Future.delayed(Duration(milliseconds: 400));
//   //           showDialog(
//   //               barrierDismissible: false,
//   //               context: CUS_CTX!,
//   //               builder: (_) => VisionPayPair());
//   //         },
//   //       )
//   //     ],
//   //   );
//   // }

//   // Widget _inActive(
//   //   Ssize size, {
//   //   Function()? onTap,
//   // }) {
//   //   return Column(
//   //     children: [
//   //       SizedBox(
//   //         height: size.getH(24),
//   //       ),
//   //       _terminalStatus(size, status: "IN-ACTIVE", color: Colors.red),
//   //       SizedBox(
//   //         height: size.getH(36),
//   //       ),
//   //       LoadButton(
//   //         width: double.infinity,
//   //         btnColor: kSecondaryColor,
//   //         btnText: "REFRESH",
//   //         onsave: onTap,
//   //       )
//   //     ],
//   //   );
//   // }

//   Widget _initPayment(
//     Ssize size, {
//     required EftPro eftPro,
//   }) {
//     return Column(
//       children: [
//         SizedBox(
//           height: size.getH(24),
//           child: Divider(
//             color: Colors.black54,
//           ),
//         ),
//         // if (widget.terminal?.eftposPaymentProviderListModels != null)
//         //   ...List.generate(
//         //       widget.terminal!.eftposPaymentProviderListModels!.length,
//         //       (index) {
//         //     final terminal =
//         //         widget.terminal!.eftposPaymentProviderListModels![index];
//         //     final pId = int.tryParse(terminal.serialNumber ?? '');
//         //     final isConnect =
//         //         pId != null ;//&& pId == USBServiceEFt.connectedUsb?.pid;

//         //     return ListTile(
//         //       contentPadding: EdgeInsets.zero,
//         //       horizontalTitleGap: 0,
//         //       onTap: isConnect
//         //           ? () {
//         //               widget.terminal!.eftposPaymentProviderListModels!
//         //                   .forEach((e) {
//         //                 e.isDefault = false;
//         //               });

//         //               terminal.isDefault = true;
//         //               eftPro.notify;
//         //             }
//         //           : null,
//         //       minLeadingWidth: size.getW(54),
//         //       leading: isConnect
//         //           ? Radio(
//         //               groupValue: true,
//         //               onChanged: (bool? value) {
//         //                 widget.terminal!.eftposPaymentProviderListModels!
//         //                     .forEach((e) {
//         //                   e.isDefault = false;
//         //                 });

//         //                 terminal.isDefault = true;
//         //                 eftPro.notify;
//         //               },
//         //               value: terminal.isDefault ?? false,
//         //             )
//         //           : SizedBox(width: size.getW(40)),
//         //       title: Row(
//         //         children: [
//         //           Text(
//         //             terminal.terminalName ?? '',
//         //             style: TextStyle(
//         //               fontSize: size.getS(18),
//         //               color: Colors.black,
//         //               height: 1.4,
//         //             ),
//         //           ),
//         //           // if (!_isAvailable) ...[
//         //           //   SizedBox(width: size.getW(12)),
//         //           //   Container(
//         //           //       decoration: BoxDecoration(
//         //           //         color: Colors.red.withAlpha(50),
//         //           //         borderRadius: BorderRadius.circular(5),
//         //           //       ),
//         //           //       padding: EdgeInsets.symmetric(
//         //           //           horizontal: size.getW(8),
//         //           //           vertical: size.getH(4)),
//         //           //       child: Text(
//         //           //         'Disconnected',
//         //           //         style: TextStyle(
//         //           //           fontSize: size.getS(15),
//         //           //           color: Colors.red.shade700,
//         //           //         ),
//         //           //       ))
//         //           // ] else
//         //           if (isConnect) ...[
//         //             SizedBox(width: size.getW(12)),
//         //             Container(
//         //                 decoration: BoxDecoration(
//         //                   color: Colors.green.withAlpha(50),
//         //                   borderRadius: BorderRadius.circular(5),
//         //                 ),
//         //                 padding: EdgeInsets.symmetric(
//         //                     horizontal: size.getW(8), vertical: size.getH(4)),
//         //                 child: Text(
//         //                   LN.connected,
//         //                   style: TextStyle(
//         //                     fontSize: size.getS(15),
//         //                     color: Colors.green.shade700,
//         //                   ),
//         //                 ))
//         //           ]
//         //         ],
//         //       ),
//         //       subtitle: Text(
//         //         '${LN.deviceName}: ${terminal.customerId ?? ''}',
//         //         style: TextStyle(
//         //           fontSize: size.getS(16),
//         //           color: Colors.black54,
//         //           height: 1.4,
//         //         ),
//         //       ),
//         //       trailing: isConnect
//         //           ? null
//         //           : Container(
//         //               decoration: BoxDecoration(
//         //                 borderRadius: BorderRadius.circular(5),
//         //                 border: Border.all(color: Colors.green),
//         //               ),
//         //               child: InkWell(
//         //                 onTap: () async {
//         //                   final isAvailable = pId != null &&
//         //                       USBServiceEFt.usbDevices.any((e) => e.pid == pId);

//         //                   loading = true;
//         //                   load();

//         //                   if (isAvailable) {
//         //                     final usbIndex = USBServiceEFt.usbDevices
//         //                         .indexWhere((e) => e.pid == pId);
//         //                     await USBServiceEFt.connectDevice(usbIndex);

//         //                     load();
//         //                   } else {
//         //                     IfException.showMessage(
//         //                         message:
//         //                             "${terminal.terminalName} ${LN.deviceNotConnected}");
//         //                   }

//         //                   loading = false;
//         //                   load();
//         //                 },
//         //                 borderRadius: BorderRadius.circular(5),
//         //                 child: Padding(
//         //                   padding: EdgeInsets.symmetric(
//         //                       horizontal: size.getW(8), vertical: size.getH(4)),
//         //                   child: Text(
//         //                     LN.connect,
//         //                     style: TextStyle(
//         //                       fontSize: size.getS(15),
//         //                       color: Colors.green.shade700,
//         //                     ),
//         //                   ),
//         //                 ),
//         //               )),
//         //     );
//         //   }),
//         // ListTile(
//         //   contentPadding: EdgeInsets.zero,
//         //   horizontalTitleGap: 0,
//         //   leading: Radio(
//         //     groupValue: true,
//         //     onChanged: (bool? value) {},
//         //     value: true,
//         //   ),
//         //   title: Text(
//         //     'Vision Pay Terminal',
//         //     style: TextStyle(
//         //       fontSize: size.getS(18),
//         //       color: Colors.black,
//         //       height: 1.4,
//         //     ),
//         //   ),
//         // ),
//         SizedBox(
//           height: size.getH(24),
//         ),
//         // LoadButton(
//         //   width: double.infinity,
//         //   btnText: LN.initiatePayment,
//         //   loading: eftPro.payloading,
//         //   btnColor: USBServiceEFt.connectedUsb == null
//         //       ? kSecondaryColor.withAlpha(60)
//         //       : kSecondaryColor,
//         //   onsave: USBServiceEFt.connectedUsb == null || eftPro.payloading
//         //       ? null
//         //       : () async {
//         //           if (widget.type == VisionPayType.Purchase) {
//         //             eftPro.onPayClicked(context,
//         //                 eftMerchantType: EftPayMethod.VisionPay.name);
//         //           } else if (widget.type == VisionPayType.Refund) {
//         //             eftPro.onRefundClicked(context,
//         //                 eftMerchantType: EftPayMethod.VisionPay.name);
//         //           }
//         //           final status = await eftPro.visionPay(
//         //               amount: widget.amount, type: widget.type);
//         //           if (status != null) {
//         //             Navigator.pop(context, status);
//         //           }
//         //         },
//         // )
//       ],
//     );
//   }

//   Widget _transcationSec(
//     Ssize size, {
//     required EftPro eftPro,
//   }) {
//     return Column(
//       children: [
//         SizedBox(
//           height: size.getH(12),
//         ),
//         Loading(),
//         SizedBox(
//           height: size.getH(8),
//         ),
//         Text(
//           widget.type == VisionPayType.Purchase
//               ? LN.purchaseCap
//               : widget.type == VisionPayType.Refund
//                   ? LN.refundCap
//                   : "",
//           style: TextStyle(
//             fontSize: size.getS(22),
//             fontFamily: kFontFMedium,
//             color: Colors.black,
//           ),
//         ),
//         SizedBox(
//           height: size.getH(8),
//         ),
//         Text(
//           VisionPayEFT.status.last.message,
//           style: TextStyle(
//             fontSize: size.getS(18),
//             color: Colors.black54,
//           ),
//         ),
//         SizedBox(
//           height: size.getH(32),
//         ),
//         _textButton(size, title: "CANCEL TRANSCATION", onTap: () async {
//           await eftPro.cancelTransaction(amount: widget.amount);
//         })
//       ],
//     );
//   }

//   Widget _transFailedSec(
//     Ssize size, {
//     required EftPro eftPro,
//   }) {
//     return Column(
//       children: [
//         SizedBox(
//           height: size.getH(12),
//         ),
//         Text(
//           "TRANSACTION FAILED",
//           style: TextStyle(
//             fontSize: size.getS(22),
//             fontFamily: kFontFMedium,
//             color: Colors.red.shade700,
//           ),
//         ),
//         SizedBox(
//           height: size.getH(8),
//         ),
//         Text(
//           VisionPayEFT.status.last.message,
//           style: TextStyle(
//             fontSize: size.getS(18),
//             color: Colors.black54,
//           ),
//         ),
//         SizedBox(
//           height: size.getH(32),
//         ),
//         _textButton(
//           size,
//           title: LN.retry,
//           onTap: () {
//             VisionPayEFT.clear();
//             // USBServiceEFt.clearQueue();
//             eftPro.notify;
//           },
//         )
//       ],
//     );
//   }

//   Widget _textButton(
//     Ssize size, {
//     Function()? onTap,
//     required String title,
//   }) {
//     return TextButton(
//       onPressed: onTap,
//       style: ButtonStyle(
//           side: WidgetStateProperty.all(BorderSide(color: kSecondaryColor)),
//           padding: WidgetStateProperty.all(EdgeInsets.symmetric(
//               horizontal: size.getW(24), vertical: size.getH(8)))),
//       child: Text(
//         title,
//         style: TextStyle(
//           fontSize: size.getS(18),
//           color: kSecondaryColor,
//         ),
//       ),
//     );
//   }

//   Widget _tranSuccess(Ssize size) {
//     return Column(
//       children: [
//         SizedBox(
//           height: size.getH(12),
//         ),
//         Container(
//             decoration: BoxDecoration(
//               shape: BoxShape.circle,
//               color: Colors.green,
//             ),
//             padding: EdgeInsets.all(size.getS(6)),
//             child: Icon(Icons.check, color: Colors.white, size: size.getS(42))),
//         SizedBox(
//           height: size.getH(8),
//         ),
//         Text(
//           "TRANSACTION SUCCESSFUL",
//           style: TextStyle(
//             fontSize: size.getS(22),
//             fontFamily: kFontFMedium,
//             color: Colors.black,
//           ),
//         ),
//         // SizedBox(
//         //   height: size.getH(32),
//         // ),
//         // _textButton(size, title: "CLOSE", onTap: () async {})
//       ],
//     );
//   }
// }
