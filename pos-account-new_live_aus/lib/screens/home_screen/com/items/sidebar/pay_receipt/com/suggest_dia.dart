// import 'package:flutter/material.dart';
// import 'package:pos_account/config/size_config.dart';
// import 'package:pos_account/constant/constant.dart';
// import 'package:pos_account/ln.dart';

// class SuggestDia extends StatelessWidget {
//   final Function()? oK;
//   final String? description;
//   const SuggestDia({super.key, this.oK, this.description});

//   @override
//   Widget build(BuildContext context) {
//     final size = Ssize(context);
//     return SimpleDialog(
//       titlePadding: EdgeInsets.zero,
//       contentPadding: EdgeInsets.symmetric(horizontal: 24, vertical: 24),
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
//       children: [
//         SizedBox(
//           height: size.height / 6,
//           width: size.width / 3.5,
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Text(
//                     LN.downloadCmpt,
//                     style: TextStyle(
//                       fontSize: size.getS(18),
//                       fontFamily: kFontFMedium,
//                       fontWeight: FontWeight.bold,
//                       color: Colors.black,
//                     ),
//                   ),
//                   IconButton(
//                       onPressed: () {
//                         Navigator.pop(context);
//                       },
//                       icon: Icon(Icons.close))
//                 ],
//               ),
//               SizedBox(
//                 height: size.getH(6),
//               ),
//               Text(
//                 description ?? '',
//                 style: TextStyle(
//                   fontSize: size.getS(16),
//                   fontFamily: kFontFMedium,
//                   color: Colors.black,
//                 ),
//               ),
//               Spacer(),
//               if (oK != null)
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.end,
//                   children: [
//                     ElevatedButton(
//                         style: ButtonStyle(
//                             backgroundColor:
//                                 WidgetStateProperty.all(Colors.red.shade700),
//                             padding: WidgetStateProperty.all(
//                                 EdgeInsets.symmetric(
//                                     horizontal: 12, vertical: 8))),
//                         onPressed: oK,
//                         child: Text(
//                           LN.open,
//                           style: TextStyle(
//                             fontSize: 15,
//                             color: Colors.white,
//                             fontWeight: FontWeight.bold,
//                           ),
//                         )),
//                   ],
//                 ),
//             ],
//           ),
//         ),
//       ],
//     );
//   }
// }
