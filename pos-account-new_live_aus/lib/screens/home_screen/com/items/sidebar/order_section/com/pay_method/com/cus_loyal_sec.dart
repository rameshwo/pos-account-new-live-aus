// import 'dart:async';

// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_barcode_listener/flutter_barcode_listener.dart';
// import 'package:oktoast/oktoast.dart';
// import 'package:pos_account/config/dual_display/dual_display_config.dart';
// import 'package:pos_account/config/size_config.dart';
// import 'package:pos_account/config/utils.dart';
// import 'package:pos_account/constant/constant.dart';
// import 'package:pos_account/ln.dart';
// import 'package:pos_account/model/home/booking/all_customer.dart';
// import 'package:pos_account/providers/menu/payment_pro.dart';
// import 'package:pos_account/screens/home_screen/com/dialogs/cus_list_dia.dart';
// import 'package:pos_account/screens/home_screen/com/items/tabs/setting_tab/com/pos_setting/com/pos_device_qr_dia.dart';
// import 'package:pos_account/widgets/input/text_form/text_form_widget.dart';
// import 'package:pos_account/widgets/load_btn.dart';
// import 'package:pos_account/widgets/switch_adap.dart';

// import 'add_customer.dart';

// class CusLoyalitySec extends StatelessWidget {
//   final Ssize size;
//   final PaymentPro payPro;
//   // final Function()? onEdit;
//   final FocusNode? focusNode;

//   const CusLoyalitySec(
//       {Key? key,
//       required this.size,
//       required this.payPro,
//       // this.onEdit,
//       this.focusNode})
//       : super(key: key);

//   Padding _tableTitle(
//     Ssize size, {
//     required String title,
//     bool isBold = false,
//   }) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 6),
//       child: Text(
//         title,
//         style: TextStyle(
//           fontSize: size.getS(13),
//           color: Colors.black,
//           fontFamily: kFontFMedium,
//           fontWeight: isBold ? FontWeight.bold : null,
//         ),
//       ),
//     );
//   }

//   void showCusList(BuildContext context) {
//     CustomerList.show(context).then((value) {
//       if (value != null && value is CusData) {
//         if (value.email != null && value.email!.isNotEmpty) {
//           payPro.searchCustomer(value.email!);
//         } else if (value.phoneNumber != null && value.phoneNumber!.isNotEmpty) {
//           payPro.searchCustomer(value.phoneNumber!);
//         }
//       }
//     });
//   }

//   void _redeemLoyalty(BuildContext context) {
//     showDialog(
//         context: context,
//         builder: (_) {
//           return SimpleDialog(
//             backgroundColor: kPrimaryColor,
//             contentPadding: EdgeInsets.symmetric(
//                 horizontal: size.getW(12), vertical: size.getH(12)),
//             children: [
//               Align(
//                 alignment: Alignment.topRight,
//                 child: Container(
//                     decoration: BoxDecoration(
//                       shape: BoxShape.circle,
//                       color: Colors.red.shade700,
//                     ),
//                     padding: EdgeInsets.symmetric(
//                         vertical: size.getS(4), horizontal: size.getS(4)),
//                     child: InkWell(
//                       onTap: () {
//                         Navigator.pop(_);
//                       },
//                       child: Icon(
//                         Icons.close,
//                         color: Colors.white,
//                         size: size.getS(28),
//                       ),
//                     )),
//               ),
//               SizedBox(height: size.getH(48)),
//               Center(
//                 child: Text(
//                   LN.totalLoyaltyAmt,
//                   style: TextStyle(
//                     fontSize: size.getS(20),
//                     color: Colors.white,
//                     fontFamily: kFontFMedium,
//                   ),
//                 ),
//               ),
//               SizedBox(height: size.getH(12)),
//               Center(
//                 child: Text(
//                   "${payPro.curSym}${payPro.cusForLoyalityRes!.eligibleAmount}",
//                   style: TextStyle(
//                     fontSize: size.getS(28),
//                     color: Colors.white,
//                     fontFamily: kFontFBold,
//                   ),
//                 ),
//               ),
//               SizedBox(height: size.getH(24)),
//               LoadButton(
//                 btnText: LN.redeemLoyalty,
//                 btnColor: Colors.amber.shade400,
//                 textColor: Colors.black,
//                 onsave: () {
//                   for (final e in payPro.paySecListRes!.paymentMethods!) {
//                     e.isSelected = false;
//                   }

//                   if (payPro.paySecListRes?.paymentMethods?.any((e) =>
//                           PayMethodClass.getMethod(e.additionalValue) ==
//                           PayMethodEnum.Loyalty) ??
//                       false) {
//                     payPro.paySecListRes!.paymentMethods!
//                         .firstWhere((e) =>
//                             PayMethodClass.getMethod(e.additionalValue) ==
//                             PayMethodEnum.Loyalty)
//                         .isSelected = true;
//                   }

//                   if (payPro.uniByPayRes != null)
//                     payPro.discountPercentCltr.clear();

//                   payPro.unicodeCltr.clear();
//                   payPro.amountPaidByUserCltr.clear();
//                   payPro.tipCltr.clear();

//                   payPro.uniByPayRes = null;

//                   payPro.loyaltyRedeem = true;

//                   payPro.setUniSearchData(isUpdatePaidAmt: false);
//                   payPro.onChangedPayAmount(isUpdatePaidAmount: false);

//                   payPro.notify;
//                   Navigator.pop(_);
//                 },
//               ),
//               SizedBox(height: size.getH(48)),
//             ],
//           );
//         });
//   }

//   // This function hits api every 2 seconds until valid data is received
//   Timer? fetchDataUntilValid(BuildContext ctx) {
//     Timer? _timer;

//     payPro.qrLoading = true;
//     payPro.notify;

//     _timer = Timer.periodic(Duration(seconds: 2), (_) async {
//       final _status = await payPro.listenQrScanData();
//       if (_status) {
//         // print("Valid data received:");

//         payPro.qrLoading = false;
//         payPro.notify;
//         _timer!.cancel(); // Stop the timer
//         Navigator.pop(ctx);
//       } else {
//         // print("Invalid data, retrying...");
//       }
//     });

//     return _timer;
//   }

//   showAddCusDia(BuildContext context) {
//     final size = Ssize(context);

//     return showDialog(
//         context: context,
//         builder: (builder) => SimpleDialog(
//               // backgroundColor: kBackgroundColor,
//               titlePadding: EdgeInsets.zero,
//               contentPadding: EdgeInsets.symmetric(
//                   horizontal: size.getW(24), vertical: size.getH(24)),
//               shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(15)),
//               children: [AddCustomer()],
//             ));
//   }

//   @override
//   Widget build(BuildContext context) {
//     return BarcodeKeyboardListener(
//       bufferDuration: Duration(milliseconds: 400),
//       onBarcodeScanned: (String val) async {
//         if (FocusManager.instance.primaryFocus?.hasFocus ?? false) {
//           SystemChannels.textInput.invokeMethod('TextInput.hide');
//         }

//         await payPro.scanCusQr(cusId: val);

// //
//       },
//       child: Column(
//         children: [
//           Row(
//             children: [
//               Expanded(
//                 child: Row(
//                   children: [
//                     Expanded(
//                       child: TextFormWidget(
//                         isReq: false,
//                         focusNode: focusNode,
//                         onChanged: (val) {
//                           if ((val?.length ?? 0) > 2) {
//                             payPro.notify;
//                           }
//                         },
//                         suffixIcon: Row(
//                           mainAxisAlignment: MainAxisAlignment.end,
//                           mainAxisSize: MainAxisSize.min,
//                           children: [
//                             if (payPro.searchCusCltr.text.isNotEmpty)
//                               InkWell(
//                                 onTap: () {
//                                   payPro.searchCusCltr.clear();
//                                   // payPro.cusForLoyalityRes = null;
//                                   payPro.loyalityEnable = false;
//                                   payPro.notify;
//                                   Utils.hideKeyBoard();
//                                 },
//                                 child: Padding(
//                                   padding: EdgeInsets.symmetric(horizontal: 6),
//                                   child: Icon(
//                                     Icons.close,
//                                     size: size.getS(28),
//                                   ),
//                                 ),
//                               ),
//                             InkWell(
//                               onTap: () async {
//                                 if (payPro.searchCusCltr.text.isNotEmpty) {
//                                   await payPro.searchCustomer(
//                                       payPro.searchCusCltr.text,
//                                       showMsg: true);
//                                 } else //if (payPro.cusForLoyalityRes == null)
//                                 {
//                                   showAddCusDia(context);
//                                   // showCusList(context);
//                                   Utils.hideKeyBoard();
//                                 }
//                               },
//                               child: Container(
//                                 margin: EdgeInsets.only(left: size.getW(6)),
//                                 decoration: BoxDecoration(
//                                     color: Colors.white,
//                                     borderRadius: BorderRadius.circular(5),
//                                     border: Border.all(color: Colors.black45)),
//                                 padding: EdgeInsets.symmetric(
//                                     horizontal: size.getW(8),
//                                     vertical: size.getH(9)),
//                                 child: Icon(
//                                   // payPro.searchCusCltr.text.isNotEmpty ?
//                                   Icons.search,
//                                   // : Icons.add,
//                                   color: Colors.black45,
//                                   size: size.getS(28),
//                                 ),
//                               ),
//                             ),
//                             // SizedBox(
//                             //   width: size.getW(4),
//                             // ),
//                             // if (payPro.searchCusCltr.text.isNotEmpty ||
//                             //     payPro.cusForLoyalityRes != null)
//                             //   InkWell(
//                             //     onTap: () {
//                             //       payPro.searchCusCltr.clear();
//                             //       payPro.cusForLoyalityRes = null;
//                             //       payPro.loyalityEnable = false;
//                             //       payPro.notify;
//                             //       Utils.hideKeyBoard();
//                             //     },
//                             //     child: Icon(
//                             //       Icons.close,
//                             //       size: size.getS(28),
//                             //     ),
//                             //   ),
//                             // SizedBox(
//                             //   width: size.getW(4),
//                             // )
//                           ],
//                         ),
//                         vPad: 12,
//                         borderRadius: 5,
//                         borderColor: Colors.black12,
//                         fillColor: kBackgroundColor,
//                         cltr: payPro.searchCusCltr,
//                         hintText: LN.searchCus,
//                         onSubmitted: (p0) async {
//                           await payPro
//                               .searchCustomer(payPro.searchCusCltr.text);
//                           if (payPro.cusForLoyalityRes == null) {
//                             if (p0 != null) showCusList(context);
//                           }
//                         },
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//               if (payPro.getPayMethod == PayMethodEnum.Loyalty)
//                 Padding(
//                   padding: EdgeInsets.only(left: size.getW(8)),
//                   child: IconButton(
//                       visualDensity: VisualDensity.compact,
//                       padding: EdgeInsets.zero,
//                       splashColor: kSecondaryColor.withOpacity(0.6),
//                       highlightColor: kSecondaryColor.withOpacity(0.2),
//                       onPressed: () {
//                         if (payPro.paySecListRes?.posqrImageUrl == null ||
//                             payPro.paySecListRes!.posqrImageUrl!.isEmpty) {
//                           showToast(LN.npQrFound);
//                           return;
//                         }
//                         DualDisplayConfig.sendData(
//                             isPayScreen: true,
//                             qrImage: payPro.paySecListRes?.posqrImageUrl);

//                         final _timer = fetchDataUntilValid(context);

//                         PosDeviceQrShow.showQRDia(
//                                 ctx: context,
//                                 diaName: "POS Device QR",
//                                 // title: "POS Device QR",
//                                 image:
//                                     payPro.paySecListRes?.posqrImageUrl ?? '',
//                                 loading: LoadButton(
//                                     loading: true,
//                                     loadingText: "Retrieving Data",
//                                     width: 240))
//                             .then((_) {
//                           if (_timer != null) {
//                             payPro.qrLoading = false;
//                             payPro.notify;
//                             _timer.cancel();
//                           }
//                           DualDisplayConfig.sendData(isPayScreen: true);
//                         });
//                       },
//                       icon: Icon(
//                         Icons.qr_code_2_outlined,
//                         size: size.getS(40),
//                         color: kSecondaryColor,
//                       )),
//                 )
//             ],
//           ),
//           SizedBox(
//             height: size.getH(4),
//           ),
//           Row(
//             children: [
//               if (payPro.cusForLoyalityRes != null)
//                 InkWell(
//                   onTap: () => _redeemLoyalty(context),
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.end,
//                     mainAxisSize: MainAxisSize.min,
//                     children: [
//                       Image.asset(
//                         "assets/png/loyalty.png",
//                         fit: BoxFit.cover,
//                         width: size.getW(25),
//                         height: size.getW(25),
//                       ),
//                       Text(
//                         "Redeem Loyalty",
//                         // "${LN.eligibleAmount}: \$${payPro.cusForLoyalityRes!.eligibleAmount}",
//                         style: TextStyle(
//                           fontSize: size.getS(14),
//                           color: Colors.black,
//                           fontFamily: kFontFMedium,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               if (payPro.cusForLoyalityRes != null) ...[
//                 Spacer(),
//                 InkWell(
//                   onTap: () {
//                     payPro.searchCusCltr.clear();
//                     payPro.cusForLoyalityRes = null;
//                     payPro.loyalityEnable = false;
//                     payPro.notify;
//                     Utils.hideKeyBoard();
//                   },
//                   child: Padding(
//                     padding: EdgeInsets.only(left: size.getW(24)),
//                     child: Text(
//                       LN.clear,
//                       style: TextStyle(
//                         color: Colors.red.shade700,
//                         fontSize: size.getS(14),
//                         fontFamily: kFontFMedium,
//                         decoration: TextDecoration.underline,
//                       ),
//                     ),
//                   ),
//                 )
//               ]
//             ],
//           ),
//           SizedBox(
//             height: size.getH(4),
//           ),
//           Table(
//             children: [
//               TableRow(
//                 children: [
//                   _tableTitle(size, title: LN.cusName),
//                   _tableTitle(size, title: LN.balPoint),
//                   _tableTitle(size, title: LN.eligibleAmount),
//                 ],
//               ),
//               payPro.cusForLoyalityRes != null
//                   ? TableRow(children: [
//                       _tableTitle(size,
//                           title: payPro.cusForLoyalityRes!.customerName ?? '',
//                           isBold: true),
//                       _tableTitle(size,
//                           title: payPro.cusForLoyalityRes!.accquiredPoints,
//                           isBold: true),
//                       _tableTitle(size,
//                           title:
//                               "${payPro.curSym}${payPro.cusForLoyalityRes!.eligibleAmount}",
//                           isBold: true),
//                     ])
//                   : TableRow(children: [
//                       _tableTitle(size, title: ""),
//                       _tableTitle(size, title: ""),
//                       _tableTitle(size, title: ""),
//                     ])
//             ],
//             border: TableBorder.all(
//               color: Colors.grey,
//             ),
//           ),
//           Row(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               if (payPro.cusForLoyalityRes?.message != null)
//                 Expanded(
//                   child: Text(
//                     "*" + (payPro.cusForLoyalityRes!.message ?? ''),
//                     style: TextStyle(
//                       fontSize: size.getS(13),
//                       color: Colors.red.shade700,
//                       fontFamily: kFontFMedium,
//                     ),
//                   ),
//                 ),
//               // Spacer(),
//               SizedBox(
//                 width: size.getW(8),
//               ),
//               Row(
//                 children: [
//                   Text(
//                     LN.enableLoyal,
//                     style: TextStyle(
//                       fontSize: size.getS(14),
//                       color: kSecondaryColor,
//                       fontFamily: kFontFMedium,
//                     ),
//                   ),
//                   SwitchAdap(
//                       size: size,
//                       activeColor: kSecondaryColor,
//                       value: payPro.cusForLoyalityRes?.loyaltyEnabled ?? false,
//                       height: 32,
//                       onChanged: (val) {
//                         if (payPro.cusForLoyalityRes != null)
//                           payPro.cusForLoyalityRes!.loyaltyEnabled = val;
//                         payPro.loyalityEnable = val;
//                         payPro.notify;
//                       }),
//                 ],
//               ),
//             ],
//           ),
//           Divider(
//             color: Colors.black,
//             thickness: 1,
//           ),
//         ],
//       ),
//     );
//   }
// }
