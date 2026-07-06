// import 'package:flutter/material.dart';
// import 'package:pos_account/config/size_config.dart';
// import 'package:pos_account/ln.dart';
// import 'package:pos_account/providers/booking/table_arrange_pro.dart';
// import 'package:pos_account/providers/cus_val_pro.dart';
// import 'package:provider/provider.dart';
// import 'com/all_table_lay_sec.dart';
// import 'com/table_layout_view.dart';

// class TableLayout extends StatefulWidget {
//   final Function()? onBack;
//   const TableLayout({Key? key, this.onBack}) : super(key: key);

//   @override
//   State<TableLayout> createState() => _TableLayoutState();
// }

// class _TableLayoutState extends State<TableLayout> {
//   final _pageCltr = PageController();
//   @override
//   void initState() {
//     getData();
//     super.initState();
//   }

//   late TableArrangePro _taPro;

//   getData() {
//     _taPro = Provider.of<TableArrangePro>(context, listen: false);
//     _taPro.getAddSection();
//     _taPro.getData();
//   }

//   @override
//   void dispose() {
//     _taPro.pageLoad = true;
//     _taPro.selectedForEdit = 0;
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final size = Ssize(context);
//     final cvp = Provider.of<CusValuePro>(context);
//     final taPro = Provider.of<TableArrangePro>(context);
//     return PageView(
//       physics: NeverScrollableScrollPhysics(),
//       controller: _pageCltr,
//       children: [
//         Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Row(
//               children: [
//                 IconButton(
//                     onPressed: widget.onBack, icon: Icon(Icons.arrow_back)),
//                 Text(
//                   LN.tableLayout,
//                   style: TextStyle(
//                     fontSize: size.getS(18),
//                     // fontFamily: ,ph
//                     fontWeight: FontWeight.bold,
//                     color: Colors.black,
//                   ),
//                 ),
//               ],
//             ),
//             Flexible(
//               child: AllTableLaySec(
//                 size: size,
//                 allTableLayRes: taPro.allTableLayRes,
//                 createNew: () {
//                   taPro.initTableData?.clear();
//                   taPro.pDList.clear();
//                   taPro.editTableData = null;
//                   taPro.editPData?.clear();
//                   taPro.layoutDesign = null;
//                   taPro.notify;
//                   cvp.isForBooking = true;
//                   cvp.setMainPage = MainPage.BookingPage;
//                 },
//                 onTabTable: (p0) {
//                   taPro.selectedForEdit = p0;
//                   taPro.notify;
//                   _pageCltr.animateToPage(1,
//                       duration: Duration(milliseconds: 300),
//                       curve: Curves.easeInOut);
//                   if (taPro.allTableLayRes != null &&
//                       taPro.allTableLayRes!.data != null &&
//                       taPro.allTableLayRes!.data![p0].id != null)
//                     taPro.editTableLay(
//                         layoutId: taPro.allTableLayRes!.data![p0].id!);
//                 },
//               ),
//             )
//           ],
//         ),
//         TableLayView(
//           size: size,
//           taPro: taPro,
//           onBack: () {
//             _pageCltr.animateToPage(0,
//                 duration: Duration(milliseconds: 300), curve: Curves.easeInOut);
//           },
//           onEdit: () {
//             taPro.initTableData?.clear();
//             taPro.pDList.clear();

//             // if (taPro.addSecRes != null &&
//             //     taPro.addSecRes!.tableLocationsWithTables != null &&
//             //     taPro.addSecRes!.tableLocationsWithTables!.isNotEmpty &&
//             //     taPro.editTableData != null) {
//             //   taPro.tableLocationIndex =
//             //       taPro.addSecRes!.tableLocationsWithTables!.indexWhere(
//             //           (e) => e.id == taPro.editTableData!.tableLocationId);
//             //   for (final f in taPro
//             //       .addSecRes!
//             //       .tableLocationsWithTables![taPro.tableLocationIndex!]
//             //       .tables!) {
//             //     if (taPro.editPData!.map((g) => g.id).contains(f.id))
//             //       f.isSelect = true;
//             //   }
//             //   taPro.onCheckedTable();
//             //   if (taPro.editPData != null && taPro.initTableData != null) {
//             //     for (final h in taPro.editPData!) {
//             //       h.key =
//             //           taPro.initTableData!.firstWhere((i) => i.id == h.id).key;
//             //     }
//             if (taPro.editPData != null) taPro.pDList.addAll(taPro.editPData!);
//             // }

//             taPro.notify;
//             // }

//             cvp.isForBooking = true;
//             cvp.setMainPage = MainPage.BookingPage;
//           },
//         )
//       ],
//     );
//   }
// }
