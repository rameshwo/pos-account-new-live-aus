// import 'package:flutter/material.dart';
// import 'package:pos_account/config/size_config.dart';
// import 'package:pos_account/constant/constant.dart';
// import 'package:pos_account/constant/date_format_keys.dart';
// import 'package:pos_account/ln.dart';
// import 'package:pos_account/providers/booking/table_arrange_pro.dart';
// import 'package:pos_account/providers/cus_val_pro.dart';
// import 'package:pos_account/screens/custom_drawer/com/logo_sec.dart';
// import 'package:pos_account/widgets/header_logo.dart';
// import 'package:pos_account/widgets/input/dropdown/drop_down.dart';

// class HeaderBookingSec extends StatelessWidget {
//   const HeaderBookingSec({
//     super.key,
//     required this.size,
//     this.onBack,
//   });

//   final Ssize size;
//   final Function()? onBack;

//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         if (!size.isProt)
//           Expanded(
//             flex: kFlexLeft,
//             child: LogoSection(
//               cvp: GlobalCVP,
//               size: size,
//             ),
//           ),
//         Expanded(
//           flex: kFlexMiddleProt,
//           child: Padding(
//             padding: EdgeInsets.fromLTRB(
//                 size.getW(12), size.getH(8), size.getW(12), 0),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 HeaderLogo(),
//                 Text(
//                   DATE_FORMAT.format(DateTime.now()),
//                   // "Tuesday, 29 Mar 2022",
//                   style: TextStyle(
//                     color: kPrimaryColor,
//                     fontSize: size.getS(14),
//                   ),
//                 ),
//                 SizedBox(
//                   height: size.getH(12),
//                 ),
//                 Padding(
//                   padding: EdgeInsets.symmetric(horizontal: size.getW(8.0)),
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       Text(
//                         LN.arrangeTable,
//                         style: TextStyle(
//                           fontSize: size.getS(18),
//                           // fontFamily: ,
//                           fontWeight: FontWeight.bold,
//                           color: Colors.black,
//                         ),
//                       ),
//                       InkWell(onTap: onBack, child: Icon(Icons.close)),
//                     ],
//                   ),
//                 ),
//                 Divider(
//                   color: Colors.black87,
//                   thickness: 0.6,
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ],
//     );
//   }
// }

// class TableLocSec extends StatelessWidget {
//   const TableLocSec({super.key, required this.size, required this.taPro});

//   final Ssize size;
//   final TableArrangePro taPro;

//   @override
//   Widget build(BuildContext context) {
//     return Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
//       Expanded(flex: kFlexLeft, child: Container()),
//       Expanded(
//         flex: kFlexMiddleProt,
//         child: Padding(
//           padding: EdgeInsets.symmetric(horizontal: size.getW(12)),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Row(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Column(
//                     children: [
//                       Row(
//                         children: [
//                           Text(
//                             LN.tableLocation,
//                             style: TextStyle(
//                               fontSize: size.getS(18),
//                               color: Colors.black,
//                             ),
//                           ),
//                           SizedBox(
//                             width: size.getW(12),
//                           ),
//                           SizedBox(
//                             width: size.width * 0.24,
//                             child: DropDownList(
//                               indexValue: taPro.tableLocationIndex,
//                               hint: LN.chooseTable,
//                               list: taPro.addSecRes == null ||
//                                       taPro.addSecRes!
//                                               .tableLocationsWithTables ==
//                                           null
//                                   ? []
//                                   : taPro.addSecRes!.tableLocationsWithTables!
//                                       .map((e) => e.value ?? '')
//                                       .toList(),
//                               onChange: (p0) {
//                                 taPro.tableLocationIndex = p0;
//                                 taPro.notify;
//                               },
//                             ),
//                           ),
//                         ],
//                       )
//                       // TitleDropDown(
//                       //   title: LN.tableLocation,
//                       //   indexVal: taPro.tableLocationIndex,
//                       //   list: taPro.addSecRes == null ||
//                       //           taPro.addSecRes!.tableLocationsWithTables ==
//                       //               null
//                       //       ? []
//                       //       : taPro.addSecRes!.tableLocationsWithTables!
//                       //           .map((e) => e.value ?? '')
//                       //           .toList(),
//                       //   hintText: LN.chooseTable,
//                       //   pWidth: 0.24,
//                       //   onChanged: (p0) {
//                       //     taPro.tableLocationIndex = p0;
//                       //     taPro.notify;
//                       //   },
//                       // ),
//                     ],
//                   ),
//                   Spacer(),
//                   Row(
//                     children: [
//                       Padding(
//                         padding: const EdgeInsets.only(right: 12.0),
//                         child: ElevatedButton(
//                             style: ButtonStyle(
//                                 backgroundColor: WidgetStateProperty.all(
//                                     Colors.red.shade700)),
//                             onPressed: () {
//                               taPro.refresh();
//                             },
//                             child: Text(
//                               LN.clearTables,
//                               style: TextStyle(
//                                 fontSize: size.getS(16),
//                                 color: Colors.white,
//                               ),
//                             )),
//                       ),
//                       Padding(
//                         padding: const EdgeInsets.only(right: 12.0),
//                         child: ElevatedButton(
//                             style: ButtonStyle(
//                                 backgroundColor:
//                                     WidgetStateProperty.all(kSecondaryColor)),
//                             onPressed: () {
//                               // taPro.refresh();
//                               taPro.addUpTableLay();
//                             },
//                             child: Text(
//                               taPro.editTableData == null ? LN.add : LN.update,
//                               style: TextStyle(
//                                 fontSize: size.getS(16),
//                                 color: Colors.white,
//                               ),
//                             )),
//                       )
//                     ],
//                   )
//                 ],
//               ),
//               // SizedBox(
//               //   height: size.getH(12),
//               // ),
//               // if (taPro.addSecRes != null &&
//               //     taPro.addSecRes!.tableLocationsWithTables != null &&
//               //     taPro.tableLocationIndex != null &&
//               //     taPro
//               //             .addSecRes!
//               //             .tableLocationsWithTables![taPro.tableLocationIndex!]
//               //             .tables !=
//               //         null)
//               //   Column(
//               //     crossAxisAlignment: CrossAxisAlignment.start,
//               //     children: [
//               //       Text(
//               //         LN.tables,
//               //         style: TextStyle(
//               //           fontSize: size.getS(18),
//               //           color: Colors.black,
//               //         ),
//               //       ),
//               //       SizedBox(
//               //         height: size.getH(8),
//               //       ),
//               //       Container(
//               //         padding: EdgeInsets.symmetric(
//               //           horizontal: size.getW(8.0),
//               //         ),
//               //         decoration: BoxDecoration(
//               //             border: Border.all(),
//               //             borderRadius: BorderRadius.circular(10)),
//               //         child: GridView.count(
//               //           crossAxisCount: 4,
//               //           childAspectRatio: 6,
//               //           shrinkWrap: true,
//               //           physics: NeverScrollableScrollPhysics(),
//               //           mainAxisSpacing: 20,
//               //           crossAxisSpacing: 10,
//               //           children: List.generate(
//               //               taPro
//               //                   .addSecRes!
//               //                   .tableLocationsWithTables![
//               //                       taPro.tableLocationIndex!]
//               //                   .tables!
//               //                   .length, (index) {
//               //             final _tables = taPro
//               //                 .addSecRes!
//               //                 .tableLocationsWithTables![
//               //                     taPro.tableLocationIndex!]
//               //                 .tables![index];
//               //             return CheckBoxSection(
//               //               size: size,
//               //               checked: _tables.isSelect,
//               //               title: _tables.name ?? '',
//               //               onChanged: (val) {
//               //                 _tables.isSelect = val ?? false;
//               //                 taPro.onCheckedTable();
//               //                 taPro.notify;
//               //               },
//               //             );
//               //           }),
//               //         ),
//               //       ),
//               //     ],
//               //   ),
//               SizedBox(
//                 height: size.getH(12),
//               ),
//             ],
//           ),
//         ),
//       )
//     ]);
//   }
// }
