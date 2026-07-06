// import 'package:flutter/material.dart';
// import 'package:pos_account/config/size_config.dart';
// import 'package:pos_account/constant/constant.dart';
// import 'package:pos_account/env.dart';
// import 'package:pos_account/model/home/menu/payment/eftpos/mx51_pair_model.dart';
// import 'package:pos_account/services/web_view/inapp_web_screen.dart';

// class Mx51Pairing extends StatelessWidget {
//   final MxPairModel pairModel;
//   const Mx51Pairing({Key? key, required this.pairModel}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     final size = Ssize(context);
//     // final _data = Utils.encodebase64(pairModel.map((e) => e.toJson()).toList());

//     final _url =
//         "${AppEnviro.eftposPay}pair-terminal-mx51?serialNumber=${pairModel.serialNumber}&posId=${pairModel.posId ?? ''}";

//     return SimpleDialog(
//       backgroundColor: kBackgroundColor,
//       titlePadding: EdgeInsets.zero,
//       contentPadding: EdgeInsets.symmetric(
//           horizontal: size.getW(12), vertical: size.getH(12)),
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
//       children: [
//         Row(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             SizedBox(
//               width: size.getW(24),
//             ),
//             Text.rich(
//               TextSpan(text: "MX-51 Terminal Pairing", children: [
//                 TextSpan(
//                     text: "\nEnter terminal details for this POS",
//                     style: TextStyle(
//                       fontSize: size.getS(16),
//                       color: Colors.black54,
//                     )),
//               ]),
//               style: TextStyle(
//                 fontSize: size.getS(22),
//                 fontWeight: FontWeight.bold,
//                 color: Colors.black,
//                 height: 1.4,
//               ),
//             ),
//             Spacer(),
//             Container(
//                 decoration: BoxDecoration(
//                   color: Colors.red.shade800,
//                   shape: BoxShape.circle,
//                 ),
//                 child: InkWell(
//                   onTap: () {
//                     Navigator.pop(context);
//                   },
//                   child: Padding(
//                     padding: EdgeInsets.symmetric(
//                         horizontal: size.getS(8), vertical: size.getS(8)),
//                     child: Icon(
//                       Icons.close,
//                       color: Colors.white,
//                     ),
//                   ),
//                 )),
//           ],
//         ),
//         SizedBox(
//             height: size.getH(740),
//             width: size.width / 1.2,
//             child: InAppWebViewScreen(
//                 webContent: WebContent(
//               title: "EFTPOS Payment",
//               url: _url,
//             )))
//       ],
//     );
//   }
// }

// // http://192.168.1.82:3000/pair-terminal-mx51?terminals=base64data
