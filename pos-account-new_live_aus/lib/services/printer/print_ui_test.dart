// import 'dart:typed_data';
// import 'package:flutter/material.dart';
// import 'package:pos_account/config/size_config.dart';
// import 'package:pos_account/model/home/menu/place_order/place_order_res.dart';
// import 'package:pos_account/providers/cus_val_pro.dart';
// import 'package:pos_account/screens/home_screen/com/items/sidebar/pay_receipt/com/stk.dart';
// import 'package:pos_account/widgets/loading.dart';
// import 'package:pos_account/widgets/no_items_sec.dart';
// import 'com/send_to_kitchen_print.dart';
// import 'dart:ui' as ui;
// import 'package:flutter/rendering.dart';

// class PrintUITest extends StatefulWidget {
//   final PlaceOrderRes order;

//   const PrintUITest({super.key, required this.order});

//   @override
//   State<PrintUITest> createState() => _PrintUITestState();
// }

// class _PrintUITestState extends State<PrintUITest> {
//   bool isByte = true;

//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//     WidgetsBinding.instance.addPostFrameCallback((_) => _printStk());
//   }

//   Future<void> _printStk() async {
//     captureWidget = [];
//     captureBytes = [];

//     for (final e in widget.order.printingDetailsResponseViewModels!) {
//       if ((e.orderItemsDetailsResponseViewModels?.isNotEmpty ?? false) ||
//           (e.setMenuOrderOrderDetailsResponseViewModels?.isNotEmpty ?? false) ||
//           (e.orderItemsDetailsResponseDocketGroupViewModels?.isNotEmpty ??
//               false) ||
//           (e.description?.isNotEmpty ?? false)) {
//         final _printList = _splitPrintList(e: e);

//         final _j = (e.orderPrintCopy ?? false) ? 2 : 1;

//         for (int i = 0; i < _j; i++) {
//           for (final b in _printList) {
//             final _pi = SendToKitchenPrint.cISentToKitchen(
//               b,
//               url: widget.order.url,
//               stkRt: i == 0
//                   ? SendToKitReceiptType.Normal
//                   : SendToKitReceiptType.Waiter,
//             );
//             if (isByte) {
//               final _imgByte = await captureWidgetToBytes(
//                   context: context, child: Stk.captureWidget(_pi));
//               captureBytes!.add(_imgByte);
//               //  final _imgByte = await Stk.capture(pI: _pi);
//               // if (_imgByte.staticByte != null) {
//               //   captureBytes?.add(_imgByte.staticByte!);
//               // }
//             } else {
//               captureWidget!.add(Stk.captureWidget(_pi));
//             }
//             load();
//           }
//         }
//       }
//     }
//     if (captureWidget!.isEmpty) {
//       captureWidget!
//           .add(NoItemsSec(size: Ssize(context), title: "No Printing Items"));
//     }
//   }

//   void load() {
//     if (mounted) setState(() {});
//   }

//   List<Widget>? captureWidget;
//   List<Uint8List>? captureBytes;

//   List<PrintingDetailsResponseViewModel> _splitPrintList({
//     required PrintingDetailsResponseViewModel e,
//   }) {
//     final _isSplitDocket =
//         GlobalCVP.storeInfo?.enableDocketGroupSplitPrint ?? false;

//     if (_isSplitDocket) {
//       List<PrintingDetailsResponseViewModel> _splitByDocketGroup() {
//         final _listData = <PrintingDetailsResponseViewModel>[];

//         if (e.orderItemsDetailsResponseDocketGroupViewModels != null)
//           for (var item in e.orderItemsDetailsResponseDocketGroupViewModels!) {
//             _listData.add(PrintingDetailsResponseViewModel.fromJson(e.toJson())
//               ..orderItemsDetailsResponseViewModels = []
//               ..orderItemsDetailsResponseDocketGroupViewModels = [
//                 OrderItemsDetailsResponseDocketGroupViewModel.fromJson(
//                     item.toJson())
//               ]);
//           }

//         if (e.orderItemsDetailsResponseViewModels?.isNotEmpty ?? false)
//           _listData.add(
//             PrintingDetailsResponseViewModel.fromJson(e.toJson())
//               ..orderItemsDetailsResponseDocketGroupViewModels = [],
//           );

//         return _listData;
//       }

//       return _splitByDocketGroup();
//     } else {
//       return [e];
//     }
//   }

//   final _scrollCltr = ScrollController();

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("Docket Print View"),
//         iconTheme: IconThemeData(size: 25),
//       ),
//       body: Center(
//         child: Scrollbar(
//           controller: _scrollCltr,
//           thumbVisibility: true,
//           trackVisibility: true,
//           interactive: true,
//           thickness: 24,
//           radius: Radius.circular(40),
//           child: SingleChildScrollView(
//             controller: _scrollCltr,
//             child: Column(
//               children: [
//                 if (isByte) ...[
//                   if (captureBytes?.isNotEmpty ?? false)
//                     ...List.generate(captureBytes!.length, (i) {
//                       return Image.memory(
//                         captureBytes![i],
//                         fit: BoxFit.contain,
//                       );
//                     })
//                   else
//                     Loading(),
//                 ] else ...[
//                   if (captureWidget?.isNotEmpty ?? false)
//                     ...captureWidget!
//                   else
//                     Loading(),
//                 ]
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

// Future<Uint8List> captureWidgetToBytes({
//   required BuildContext context,
//   required Widget child,
//   double pixelRatio = 1.5,
// }) async {
//   final repaintBoundaryKey = GlobalKey();

//   final overlay = Overlay.of(context);

//   late OverlayEntry entry;

//   entry = OverlayEntry(
//     builder: (_) {
//       return Positioned(
//         left:
//             0, // Render completely off-screen so the user doesn't see it flicker
//         top: 0,
//         child: RepaintBoundary(
//           key: repaintBoundaryKey,
//           child: SizedBox(
//             width: 560,
//             child: SingleChildScrollView(
//               child: Material(
//                 color: Colors.white,
//                 child: Directionality(
//                   textDirection: TextDirection.ltr,
//                   child: IntrinsicHeight(child: child),
//                 ),
//               ),
//             ),
//           ),
//         ),
//       );
//     },
//   );

//   overlay.insert(entry);

//   // wait for complete rendering
//   await Future.delayed(
//     const Duration(milliseconds: 2000),
//   );

//   await WidgetsBinding.instance.endOfFrame;

//   final boundary = repaintBoundaryKey.currentContext!.findRenderObject()
//       as RenderRepaintBoundary;

//   // ensure paint completed
//   if (boundary.debugNeedsPaint) {
//     await Future.delayed(
//       const Duration(milliseconds: 100),
//     );
//   }

//   final image = await boundary.toImage(
//     pixelRatio: pixelRatio,
//   );

//   final byteData = await image.toByteData(
//     format: ui.ImageByteFormat.png,
//   );

//   entry.remove();

//   return byteData!.buffer.asUint8List();
// }
