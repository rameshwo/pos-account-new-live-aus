// import 'package:flutter/material.dart';
// import 'package:pos_account/config/size_config.dart';
// import 'package:pos_account/constant/constant.dart';
// import 'package:pos_account/widgets/no_items_sec.dart';

// class PrinterListDia extends StatelessWidget {
//   final List<PrinterModel> printerList;
//   const PrinterListDia({Key? key, required this.printerList}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     final size = Ssize(context);
//     return Container(
//       constraints: BoxConstraints(
//         maxHeight: size.height / 1.2,
//         minHeight: size.height / 4,
//       ),
//       width: size.width / 3,
//       padding: EdgeInsets.symmetric(vertical: size.getH(8)),
//       child: Column(
//         mainAxisSize: MainAxisSize.min,
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Text(
//                 "Available Printers",
//                 style: TextStyle(
//                   fontSize: size.getS(22),
//                   // fontFamily: ,
//                   fontWeight: FontWeight.bold,
//                   color: Colors.black,
//                 ),
//               ),
//               Spacer(),
//               IconButton(
//                 visualDensity: VisualDensity.compact,
//                 onPressed: () {
//                   Navigator.pop(context);
//                 },
//                 icon: Icon(Icons.close),
//               )
//             ],
//           ),
//           Text(
//             "Connection status of the printers",
//             // "View and manage your connected printers. Click 'Connect' to establish a connection with an offline printer.",
//             style: TextStyle(
//               fontSize: size.getS(16),
//               color: Colors.black54,
//             ),
//           ),
//           SizedBox(height: size.getH(12)),
//           if (printerList.isNotEmpty)
//             Flexible(
//               child: Container(
//                 decoration: BoxDecoration(
//                     border: Border.all(color: Colors.black38),
//                     borderRadius: BorderRadius.circular(5)),
//                 padding: EdgeInsets.symmetric(
//                     horizontal: size.getW(12), vertical: size.getH(12)),
//                 child: SingleChildScrollView(
//                   physics: BouncingScrollPhysics(),
//                   child: Column(
//                     mainAxisSize: MainAxisSize.min,
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       ...List.generate(printerList.length, (index) {
//                         return ListTile(
//                           leading: Icon(Icons.print, size: size.getS(32)),
//                           minLeadingWidth: 0,
//                           dense: true,
//                           contentPadding: EdgeInsets.zero,
//                           title: Text(
//                             (printerList[index].name ?? '') +
//                                 " [${printerList[index].type ?? ''}]",
//                             style: TextStyle(
//                               color: Colors.black,
//                               fontFamily: kFontFMedium,
//                               fontSize: size.getS(18),
//                             ),
//                           ),
//                           subtitle: printerList[index].status
//                               ? Row(
//                                   mainAxisSize: MainAxisSize.min,
//                                   children: [
//                                     Icon(
//                                       Icons.check_circle_outline,
//                                       size: size.getS(18),
//                                       color: Colors.green,
//                                     ),
//                                     Text(
//                                       " Print Succcess",
//                                       style: TextStyle(
//                                         color: Colors.green,
//                                         fontSize: size.getS(16),
//                                       ),
//                                     ),
//                                   ],
//                                 )
//                               : Row(
//                                   mainAxisSize: MainAxisSize.min,
//                                   children: [
//                                     Icon(
//                                       Icons.cancel_outlined,
//                                       size: size.getS(18),
//                                       color: Colors.red,
//                                     ),
//                                     Text(
//                                       " Failed to Print",
//                                       style: TextStyle(
//                                         color: Colors.red,
//                                         fontSize: size.getS(16),
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                           trailing: Row(
//                             mainAxisSize: MainAxisSize.min,
//                             children: [
//                               // if (printerList[index].status)
//                               //   Container(
//                               //     decoration: BoxDecoration(
//                               //       color: Colors.green.withOpacity(0.15),
//                               //       borderRadius: BorderRadius.circular(5),
//                               //     ),
//                               //     padding: EdgeInsets.symmetric(
//                               //         vertical: size.getH(8),
//                               //         horizontal: size.getW(12)),
//                               //     child: Text(
//                               //       LN.connected,
//                               //       style: TextStyle(
//                               //         color: Colors.green.shade700,
//                               //         fontWeight: FontWeight.bold,
//                               //       ),
//                               //     ),
//                               //   )
//                               // else
//                               //   Container(
//                               //     decoration: BoxDecoration(
//                               //       color: Colors.red.withOpacity(0.15),
//                               //       borderRadius: BorderRadius.circular(5),
//                               //     ),
//                               //     padding: EdgeInsets.symmetric(
//                               //         vertical: size.getH(8),
//                               //         horizontal: size.getW(12)),
//                               //     child: Text(
//                               //       LN.disconnected,
//                               //       style: TextStyle(
//                               //         color: Colors.red.shade700,
//                               //         fontWeight: FontWeight.bold,
//                               //       ),
//                               //     ),
//                               //   )
//                               // LoadButton(
//                               //   vPad: 8,
//                               //   hPad: 4,
//                               //   width: 140,
//                               //   onsave: () async {
//                               //     if (printerList[index].type ==
//                               //         PrinterTypeEnum.Bluetooth.name) {
//                               //       BluetoothService.setConnect(
//                               //           BluetoothDevice(
//                               //               name:
//                               //                   printerList[index].name ?? '',
//                               //               macAddress:
//                               //                   printerList[index].name ??
//                               //                       ''));
//                               //       // Navigator.pop(context);
//                               //       return;
//                               //     } else if (printerList[index].type ==
//                               //         PrinterTypeEnum.USB.name) {
//                               //       UsbService.connect(
//                               //           device: UsbDevice(
//                               //         vendorId: printerList[index].name,
//                               //         productId: printerList[index].subName,
//                               //       ));
//                               //       // Navigator.pop(context);
//                               //       return;
//                               //     } else {
//                               //       await PrinterService.checkDevice(
//                               //         ip: printerList[index].name,
//                               //         port: int.tryParse(
//                               //                 printerList[index].subName ??
//                               //                     '9100') ??
//                               //             9100,
//                               //         context: context,
//                               //         doPrint: false,
//                               //       );
//                               //     }
//                               //   },
//                               //   // btnColor: Colors.green.shade600,
//                               //   btnText: LN.connect,
//                               // )
//                             ],
//                           ),
//                         );
//                       }),
//                     ],
//                   ),
//                 ),
//               ),
//             )
//           else
//             NoItemsSec(size: size, title: "No Printer has items")
//         ],
//       ),
//     );
//   }
// }

// class PrinterModel {
//   final String? name;
//   final String? subName;
//   final String? type;
//   bool status;
//   // final Function()? onChange;

//   PrinterModel({
//     this.name,
//     this.subName,
//     this.type,
//     this.status = false,
//     // this.onChange,
//   });
// }
