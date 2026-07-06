// import 'package:flutter/material.dart';
// import 'package:pos_account/config/size_config.dart';
// import 'package:pos_account/constant/constant.dart';
// import 'package:pos_account/providers/cus_val_pro.dart';
// import 'package:pos_account/providers/dashboard/punch_pro.dart';
// import 'package:pos_account/widgets/input/text_form/title_text_form.dart';
// import 'package:pos_account/widgets/load_btn.dart';
// import 'package:pos_account/widgets/loading.dart';
// import 'package:provider/provider.dart';

// class PunchDia extends StatefulWidget {
//   const PunchDia({super.key}) ;

//   @override
//   State<PunchDia> createState() => _PunchDiaState();
// }

// class _PunchDiaState extends State<PunchDia> {
//   PunchPro? punchPro;

//   @override
//   void initState() {
//     super.initState();
//     punchPro = Provider.of<PunchPro>(context, listen: false);
//     punchPro?.getPunchData();
//   }

//   @override
//   void dispose() {
//     punchPro?.clear();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final size = Ssize(context);
//     final _punchPro = Provider.of<PunchPro>(context);

//     final _isPunchIn = _punchPro.punchInOutData?.isPunchedInAlready ?? false;
//     return Processing(
//       loading: _punchPro.loading,
//       child: Container(
//         constraints: BoxConstraints(
//           maxHeight: size.height / 1.11,
//           minHeight: size.height / 5,
//         ),
//         width: size.width * 0.5,
//         child: SingleChildScrollView(
//           physics: BouncingScrollPhysics(),
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Text(
//                     "Punch In/Out",
//                     style: TextStyle(
//                       fontSize: size.getS(20),
//                       fontWeight: FontWeight.bold,
//                       color: Colors.black,
//                     ),
//                   ),
//                   IconButton(
//                       visualDensity: VisualDensity.compact,
//                       onPressed: () {
//                         Navigator.pop(context);
//                       },
//                       icon: Icon(Icons.close))
//                 ],
//               ),
//               Divider(),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 crossAxisAlignment: CrossAxisAlignment.end,
//                 children: [
//                   TitleTextForm(
//                     pWidth: 0.24,
//                     isReq: false,
//                     title: "Employee Code",
//                     borderColor: Colors.black38,
//                     textCltr: _punchPro.codeCltr,
//                   ),
//                   SizedBox(width: size.getW(12)),
//                   SizedBox(
//                     height: size.getH(46),
//                     child: Column(
//                       children: [
//                         Expanded(
//                           child: ElevatedButton(
//                               style: ButtonStyle(
//                                   padding: WidgetStateProperty.all(
//                                       EdgeInsets.symmetric(
//                                           horizontal: size.getW(12)))),
//                               onPressed: () {
//                                 FocusManager.instance.primaryFocus?.unfocus();
//                                 _punchPro.getPunchData(refresh: true);
//                               },
//                               child: Icon(
//                                 Icons.search,
//                                 size: size.getS(32),
//                               )),
//                         ),
//                       ],
//                     ),
//                   )
//                 ],
//               ),
//               SizedBox(height: size.getH(24)),
//               if (_punchPro.punchInOutData?.name?.isNotEmpty ?? false)
//                 _titleVal(
//                   size,
//                   title: "Employee Name : ",
//                   value: _punchPro.punchInOutData?.name ?? '',
//                 ),
//               if (_punchPro.punchInOutData?.code?.isNotEmpty ?? false)
//                 _titleVal(
//                   size,
//                   title: "Employee Code : ",
//                   value: _punchPro.punchInOutData?.code ?? '',
//                 ),
//               if (_punchPro.punchInOutData?.phoneNumber?.isNotEmpty ?? false)
//                 _titleVal(
//                   size,
//                   title: "Employee Phone : ",
//                   value: _punchPro.punchInOutData?.phoneNumber ?? '',
//                 ),
//               if (_punchPro.punchInOutData?.email?.isNotEmpty ?? false)
//                 _titleVal(
//                   size,
//                   title: "Employee Email : ",
//                   value: _punchPro.punchInOutData?.email ?? '',
//                 ),
//               if (_punchPro.dateTime.isNotEmpty)
//                 _titleVal(
//                   size,
//                   title: "Current Date/Time : ",
//                   value: _punchPro.dateTime,
//                 ),
//               if (_punchPro.punchInOutData?.timeDiff?.isNotEmpty ?? false)
//                 _titleVal(
//                   size,
//                   title: "Total Working Hours : ",
//                   value: _punchPro.punchInOutData!.timeDiff,
//                 ),
//               SizedBox(height: size.getH(24)),
//               if (_punchPro.punchInOutData?.punchInPunchOutList != null)
//                 Center(
//                   child: SizedBox(
//                     width: size.getW(644),
//                     child: Table(
//                       border: TableBorder.all(
//                         width: 0.7,
//                         color: Colors.black54,
//                       ),
//                       children: [
//                         ...List.generate(
//                             _punchPro.punchInOutData!.punchInPunchOutList!
//                                 .length, (index) {
//                           final _data = _punchPro
//                               .punchInOutData!.punchInPunchOutList![index];
//                           return _tableData(
//                             size,
//                             title: _data.type,
//                             value: _data.date,
//                           );
//                         })
//                       ],
//                     ),
//                   ),
//                 ),
//               SizedBox(height: size.getH(24)),
//               Center(
//                 child: LoadButton(
//                   btnText: _isPunchIn ? "Punch Out" : "Punch In",
//                   btnColor: _isPunchIn ? Colors.red.shade700 : kSecondaryColor,
//                   loading: _punchPro.buttonLoad,
//                   loadingText: "Punching",
//                   onsave: () {
//                     GlobalCVP.isInitApiCalled = false;
//                     GlobalCVP.notify;
//                     _punchPro.punch().then((value) {
//                       GlobalCVP.isInitApiCalled = true;
//                       GlobalCVP.notify;
//                       if ((value ?? false) && mounted) {
//                         Navigator.pop(context);
//                       }
//                     });
//                   },
//                 ),
//               ),
//               SizedBox(height: size.getH(48)),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   TableRow _tableData(
//     Ssize size, {
//     String? title,
//     String? value,
//   }) {
//     return TableRow(
//         decoration: BoxDecoration(
//           border: Border.all(
//             width: 0.5,
//             color: Colors.black54,
//           ),
//           // color: Colors.grey[200],
//         ),
//         children: [
//           Padding(
//             padding: EdgeInsets.symmetric(
//                 vertical: size.getH(12), horizontal: size.getW(8)),
//             child: Text(
//               title ?? '',
//               style: TextStyle(
//                 fontSize: size.getS(18),
//                 fontWeight: FontWeight.bold,
//               ),
//               textAlign: TextAlign.center,
//             ),
//           ),
//           Padding(
//             padding: EdgeInsets.symmetric(
//                 vertical: size.getH(12), horizontal: size.getW(8)),
//             child: Text(
//               value ?? '',
//               style: TextStyle(
//                 fontSize: size.getS(18),
//                 fontWeight: FontWeight.bold,
//               ),
//               textAlign: TextAlign.center,
//             ),
//           ),
//         ]);
//   }

//   Widget _titleVal(
//     Ssize size, {
//     String? title,
//     String? value,
//   }) {
//     return Padding(
//       padding: EdgeInsets.symmetric(horizontal: size.getW(36)),
//       child: Text.rich(
//         TextSpan(
//           text: title ?? "",
//           children: [
//             if (value != null)
//               TextSpan(
//                 text: value,
//                 style: TextStyle(
//                   fontSize: size.getS(20),
//                   fontWeight: FontWeight.bold,
//                   color: Colors.black,
//                 ),
//               ),
//           ],
//         ),
//         style: TextStyle(
//           fontSize: size.getS(20),
//           // fontWeight: FontWeight.bold,
//           color: Colors.black,
//         ),
//       ),
//     );
//   }
// }
