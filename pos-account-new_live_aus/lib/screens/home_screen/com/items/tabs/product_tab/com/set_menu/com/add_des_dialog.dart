// import 'package:flutter/material.dart';
// import 'package:pos_account/config/size_config.dart';
// import 'package:pos_account/constant/constant.dart';
// import 'package:pos_account/ln.dart';
// import 'package:pos_account/widgets/input/text_form/title_text_form.dart';

// class AddSingleDataDia extends StatelessWidget {
//   final Ssize size;
//   final Function()? onAdd;
//   final TextEditingController desCltr;
//   final TextEditingController countCltr;
//   const AddSingleDataDia({
//     Key? key,
//     required this.size,
//     this.onAdd,
//     required this.desCltr,
//     required this.countCltr,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return SimpleDialog(
//       // backgroundColor: kPrimaryColor,
//       titlePadding: EdgeInsets.zero,
//       contentPadding: EdgeInsets.symmetric(horizontal: 24, vertical: 24),
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
//       children: [
//         Container(
//           constraints: BoxConstraints(
//             maxHeight: size.height / 1.5,
//             minHeight: size.height / 6,
//           ),
//           width: size.width / 4,
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.end,
//                 children: [
//                   InkWell(
//                       onTap: () {
//                         Navigator.pop(context);
//                       },
//                       child: Icon(Icons.close)),
//                 ],
//               ),
//               TitleTextForm(
//                 title: "Max Item Count",
//                 isReq: false,
//                 textCltr: countCltr,
//                 hintText: "max item count",
//                 textInputType: TextInputType.number,
//               ),
//               SizedBox(
//                 height: size.getH(16),
//               ),
//               TitleTextForm(
//                 title: LN.addDescription,
//                 isReq: false,
//                 textCltr: desCltr,
//                 hintText: LN.description,
//                 maxLines: 4,
//               ),
//               SizedBox(
//                 height: size.getH(24),
//               ),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.end,
//                 children: [
//                   ElevatedButton(
//                       style: ButtonStyle(
//                           backgroundColor:
//                               MaterialStateProperty.all(Colors.white),
//                           padding: MaterialStateProperty.all(
//                               EdgeInsets.symmetric(
//                                   horizontal: size.getW(24),
//                                   vertical: size.getH(8)))),
//                       onPressed: onAdd,
//                       child: Text(
//                         LN.cancel,
//                         style: TextStyle(
//                           fontSize: size.getS(16),
//                           color: Colors.black,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       )),
//                   SizedBox(
//                     width: size.getW(12),
//                   ),
//                   ElevatedButton(
//                       style: ButtonStyle(
//                           backgroundColor:
//                               MaterialStateProperty.all(kSecondaryColor),
//                           padding: MaterialStateProperty.all(
//                               EdgeInsets.symmetric(
//                                   horizontal: size.getW(24),
//                                   vertical: size.getH(8)))),
//                       onPressed: onAdd,
//                       child: Text(
//                         LN.add,
//                         style: TextStyle(
//                           fontSize: size.getS(16),
//                           color: Colors.white,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       )),
//                 ],
//               )
//             ],
//           ),
//         ),
//       ],
//     );
//   }
// }
