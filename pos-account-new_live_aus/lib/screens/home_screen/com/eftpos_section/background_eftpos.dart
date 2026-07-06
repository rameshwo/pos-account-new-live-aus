// // import 'dart:developer';

// import 'package:flutter/material.dart';
// import 'package:pos_account/config/size_config.dart';
// import 'package:pos_account/env.dart';
// import 'package:pos_account/ln.dart';
// import 'package:pos_account/providers/common/eftpro.dart';
// import 'package:pos_account/screens/home_screen/com/items/sidebar/order_section/com/pay_method/com/choose_eft_pay_dia.dart';
// import 'package:pos_account/services/payment/eft_payment.dart';
// import 'package:pos_account/services/printer/com/signature_print.dart';
// import 'package:pos_account/widgets/dialog/msg_dialog.dart';
// import 'package:provider/provider.dart';
// import '../../../../services/web_view/inapp_web_screen.dart';
// // import 'webview_screen.dart';

// class BackgroundEftPos extends StatefulWidget {
//   const BackgroundEftPos({Key? key}) : super(key: key);

//   @override
//   State<BackgroundEftPos> createState() => _BackgroundEftPosState();
// }

// class _BackgroundEftPosState extends State<BackgroundEftPos> {
//   final scaffoldKey = GlobalKey<ScaffoldState>();

//   @override
//   Widget build(BuildContext context) {
//     final _eftPro = Provider.of<EftPro>(context);
//     final size = Ssize(context);
//     // print(
//     //     'EFT POS MX Running in background .................................................');
//     return IgnorePointer(
//       ignoring: !_eftPro.showEftPay_Mx51,
//       child: SizedBox(
//         // color: Colors.amber.withOpacity(0.5),
//         width: _eftPro.showEftPay_Mx51 ? size.width : 0,
//         height: _eftPro.showEftPay_Mx51 ? size.height : 0,
//         child: InAppWebViewScreen(
//           webContent: WebContent(
//             title: "EFTPOS Payment",
//             url: _eftPro.payUrl,
//           ),
//           onLoadUrl: ({webCltr}) async {
//             _eftPro.webCltr = webCltr;
//             final _uri = await webCltr?.getOriginalUrl();
//             if (_uri == null) return;
//             final _loadUrl = _uri.toString();

//             // log("on progress url: $_loadUrl  ${_loadUrl == EFTPayment.loadedString}");

//             if (_loadUrl == EFTPayment.loadedString) return;

//             // log("on progress url: $_loadUrl");

//             EFTPayment.loadedString = _loadUrl;

//             // if (_loadUrl == null) return;
//             final _parameter = Uri.parse(_loadUrl).queryParameters;

//             //write funtion below

//             if (_parameter['isWebClosed'] == 'true' ||
//                 _loadUrl == AppEnviro.eftposPay) {
//               _eftPro.loadUrl(AppEnviro.eftposPay);
//               // await webCltr?.loadUrl(AppEnviro.eftposPay);
//               _eftPro.showEftPay_Mx51 = false;

//               _eftPro.notify;

//               if (_parameter['isWebClosed'] == 'true') {
//                 _eftPro.removePayReqData();
//                 _eftPro.removeRefundReqData();
//               }

//               // Navigator.of(context).pop();
//             } else if (_parameter['payWithoutPairing'] == 'true') {
//               _eftPro.eftReturnValue = EFTReturnValue(
//                   refId: "", merchantType: EftPayMethod.Mx51.name);
//               // Navigator.pop(context);
//               _eftPro.showEftPay_Mx51 = false;

//               _eftPro.notify;
//             } else if (_parameter['isPaired'] == 'true') {
//               // await webCltr?.loadUrl(_eftPro.payUrl);
//               _eftPro.loadUrl(_eftPro.payUrl);
//             } else
//             //////////////break point////////

//             if (_parameter['printSignature'] == 'true') {
//               //do print signature
//               if (_eftPro.orderId != null)
//                 SignaturePrint.printSignature(
//                     data: _parameter['signatureString'],
//                     orderId: _eftPro.orderId!);
//             } else if (_parameter['isPaymentSuccess'] == 'true') {
//               _eftPro.eftReturnValue = EFTReturnValue(
//                 refId: _parameter['posRefId'],
//                 merchantReceipt: _parameter['merchantReceipt'],
//                 customerReceipt: _parameter['customerReceipt'],
//                 serialNumber: _parameter['serialNumber'],
//                 merchantType: EftPayMethod.Mx51.name,
//               );

//               // print('-----1. ${_eftReturnValue?.refId}');

//               // Navigator.of(context).pop();
//               _eftPro.showEftPay_Mx51 = false;

//               _eftPro.notify;
//               _eftPro.removePayReqData();
//               _eftPro.removeRefundReqData();
//             } else if (_parameter['isPaymentSuccess'] == 'false') {
//               EFTPayment.merchantLog(
//                   parameter: _parameter, orderId: _eftPro.orderId);
//               _eftPro.removePayReqData();
//               _eftPro.removeRefundReqData();
//             } else if (_parameter['isPayClicked'] == 'true') {
//               _eftPro.onPayClicked(context,
//                   eftMerchantType: EftPayMethod.Mx51.name);
//             } else if (_parameter['isRefundClicked'] == 'true') {
//               _eftPro.onRefundClicked(context,
//                   eftMerchantType: EftPayMethod.Mx51.name);
//             } else if (_parameter['isPayLastOrderClicked'] == 'true') {
//               // Navigator.of(context).pop();
//               _eftPro.showEftPay_Mx51 = false;

//               _eftPro.eftReturnValue = EFTReturnValue(
//                 refId: _parameter['posRefId'],
//                 merchantReceipt: _parameter['merchantReceipt'],
//                 customerReceipt: _parameter['customerReceipt'],
//                 serialNumber: _parameter['serialNumber'],
//                 merchantType: EftPayMethod.Mx51.name,
//               );

//               _eftPro.notify;
//             } else if (_parameter['isTransactionCancel'] == 'true') {
//               _eftPro.removePayReqData();
//               _eftPro.removeRefundReqData();
//             } else if (_parameter['isRetryButtonClicked'] == 'true') {
//               // await webCltr?.loadUrl(_eftPro.payUrl);
//             }
//           },
//           onError: ({String? message}) {
//             if (_eftPro.eftPayInit_Mx51) {
//               _eftPro.runEftPay_Mx51 = false;
//               _eftPro.notify;
//               MsgDia.show(CUS_CTX,
//                       title: "Server Error",
//                       desc: message,
//                       diaType: DiaType.error,
//                       autoHideSecond: 2)
//                   .then((value) {
//                 _eftPro.showEftPay_Mx51 = false;
//                 _eftPro.eftPayInit_Mx51 = false;
//                 _eftPro.runEftPay_Mx51 = true;
//                 _eftPro.notify;
//               });
//             }
//           },
//         ),
//       ),
//     );
//   }
// }
