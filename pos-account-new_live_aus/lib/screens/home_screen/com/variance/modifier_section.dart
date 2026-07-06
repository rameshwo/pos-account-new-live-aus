// import 'package:flutter/material.dart';
// import 'package:pos_account/config/size_config.dart';
// import 'package:pos_account/config/utils.dart';
// import 'package:pos_account/constant/constant.dart';
// import 'package:pos_account/ln.dart';
// import 'package:pos_account/model/home/menu/place_order/pos_res/com/feature_product.dart';
// import 'package:pos_account/providers/cus_val_pro.dart';
// import 'package:pos_account/screens/home_screen/com/quantity_sec.dart';
// import 'selective_tab.dart';

// class ModifierSection extends StatefulWidget {
//   final List<ProductPriceModifier> productPriceModifiers;
//   final String curSym;
//   final Function()? update;
//   final double width;
//   const ModifierSection({
//     Key? key,
//     required this.productPriceModifiers,
//     required this.curSym,
//     required this.update,
//     this.width = 200,
//   }) : super(key: key);

//   @override
//   State<ModifierSection> createState() => _ModifierSectionState();
// }

// class _ModifierSectionState extends State<ModifierSection> {
//   final _grouplist = <GroupModifier>[];
//   int _selectedIndex = 0;

//   void _grouping() {
//     for (final a in widget.productPriceModifiers) {
//       if (_grouplist.any((b) => b.labelName == a.labelName)) {
//         final _modifierList =
//             _grouplist.firstWhere((b) => b.labelName == a.labelName);
//         _modifierList.modifierList?.add(a);
//       } else {
//         _grouplist
//             .add(GroupModifier(labelName: a.labelName, modifierList: [a]));
//       }
//     }
//     load();
//   }

//   @override
//   void initState() {
//     _grouping();
//     super.initState();
//   }

//   void load() {
//     if (widget.update != null)
//       WidgetsBinding.instance?.addPostFrameCallback((_) {
//         widget.update!();
//       });
//   }

//   @override
//   Widget build(BuildContext context) {
//     final size = Ssize(context);
//     if (_grouplist.isEmpty)
//       return SizedBox.shrink();
//     else
//       return Container(
//         // width: double.infinity,
//         // decoration: BoxDecoration(
//         //   color: kSecondaryColor.withOpacity(0.1),
//         //   borderRadius: BorderRadius.circular(10),
//         // ),
//         // padding: EdgeInsets.symmetric(
//         //     horizontal: size.getW(12), vertical: size.getH(8)),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             // Text(
//             //   LN.modifier,
//             //   style: TextStyle(
//             //     fontSize: size.getS(20),
//             //     fontWeight: FontWeight.bold,
//             //     color: kSecondaryColor,
//             //   ),
//             // ),
//             SizedBox(height: size.getH(8)),
//             Container(
//               width: double.infinity,
//               decoration: BoxDecoration(
//                 color: Colors.white,
//                 borderRadius: BorderRadius.circular(5),
//               ),
//               padding: EdgeInsets.symmetric(
//                   horizontal: size.getW(4), vertical: size.getH(0)),
//               child: SingleChildScrollView(
//                 scrollDirection: Axis.horizontal,
//                 child: Row(
//                   children: [
//                     ...List.generate(_grouplist.length, (index) {
//                       return SizedBox(
//                         width: size.getW(200),
//                         height: size.getH(48),
//                         child: SelectiveTab(
//                           title: _grouplist[index].labelName ?? '',
//                           isDefault: index == _selectedIndex,
//                           unSelectBorderColor: Colors.black12,
//                           onTap: () {
//                             _selectedIndex = index;
//                             load();
//                           },
//                         ),
//                       );
//                     }),
//                   ],
//                 ),
//               ),
//             ),
//             SizedBox(height: size.getH(8)),
//             if (_grouplist.isNotEmpty)
//               Wrap(
//                 spacing: size.getW(12),
//                 runSpacing: size.getH(8),
//                 children: List.generate(
//                     _grouplist[_selectedIndex].modifierList!.length, (j) {
//                   final _price = double.tryParse(
//                           _grouplist[_selectedIndex].modifierList![j].price ??
//                               '') ??
//                       0;
//                   final _isEstTime = (GlobalCVP.isServiceStore &&
//                       (_grouplist[_selectedIndex]
//                               .modifierList![j]
//                               .estimatedTime
//                               ?.isNotEmpty ??
//                           false));
//                   return Container(
//                     height: size.getH(70),
//                     decoration: BoxDecoration(
//                       color: (_grouplist[_selectedIndex]
//                                   .modifierList![j]
//                                   .isActive ??
//                               false)
//                           ? kSecondaryColor.withOpacity(0.16)
//                           : Colors.white,
//                       borderRadius: BorderRadius.circular(5),
//                     ),
//                     padding: EdgeInsets.symmetric(
//                         horizontal: size.getW(8), vertical: size.getH(3)),
//                     child: SizedBox(
//                       width: size.getW(widget.width),
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           Row(
//                             children: [
//                               Expanded(
//                                 child: InkWell(
//                                   onTap: () {
//                                     _grouplist[_selectedIndex]
//                                         .modifierList![j]
//                                         .isActive = !(_grouplist[_selectedIndex]
//                                             .modifierList![j]
//                                             .isActive ??
//                                         false);
//                                     load();
//                                   },
//                                   child: Column(
//                                     crossAxisAlignment:
//                                         CrossAxisAlignment.start,
//                                     children: [
//                                       Text(
//                                         _grouplist[_selectedIndex]
//                                                 .modifierList![j]
//                                                 .name ??
//                                             '',
//                                         style: TextStyle(
//                                           fontSize: size.getS(18),
//                                           color: Colors.black,
//                                           fontFamily: kFontFMedium,
//                                         ),
//                                         maxLines: 2,
//                                       ),
//                                       Text(
//                                         "${widget.curSym}${_price.roundToNString()}",
//                                         style: TextStyle(
//                                           fontSize: size.getS(16),
//                                           color: Colors.black,
//                                           fontFamily: kFontFBold,
//                                         ),
//                                       ),
//                                       if (_isEstTime)
//                                         Text(
//                                           Utils.convertMinutesToHours(
//                                               _grouplist[_selectedIndex]
//                                                   .modifierList![j]
//                                                   .estimatedTime,
//                                               true),
//                                           style: TextStyle(
//                                             fontSize: size.getS(14),
//                                             fontWeight: FontWeight.bold,
//                                             color: Colors.black87,
//                                           ),
//                                         )
//                                     ],
//                                   ),
//                                 ),
//                               ),
//                               if (_grouplist[_selectedIndex]
//                                       .modifierList![j]
//                                       .isActive ??
//                                   false)
//                                 QuantitySection(
//                                   size: size,
//                                   vPad: 8,
//                                   quantity: _grouplist[_selectedIndex]
//                                       .modifierList![j]
//                                       .quantity
//                                       .toDouble(),
//                                   update: (val) async {
//                                     final _modi = _grouplist[_selectedIndex]
//                                         .modifierList![j];
//                                     if (val == null) {
//                                       _modi.quantity = (await Utils.textQty(
//                                               _modi.quantity.toDouble()))
//                                           .toInt();
//                                     } else if (val) {
//                                       _modi.quantity++;
//                                     } else {
//                                       if (_modi.quantity < 2) {
//                                         _grouplist[_selectedIndex]
//                                             .modifierList![j]
//                                             .isActive = false;
//                                         load();
//                                         return;
//                                       }
//                                       _modi.quantity--;
//                                     }
//                                     load();
//                                   },
//                                   fr: 0.9,
//                                 )

//                               // Spacer(),
//                               // Text(
//                               //   "${widget.curSym}${(_grouplist[_selectedIndex].modifierList![j].quantity * _price).roundToNString()}",
//                               //   style: TextStyle(
//                               //     fontSize: size.getS(16),
//                               //     color: Colors.black,
//                               //     fontFamily: kFontFBold,
//                               //   ),
//                               // ),
//                             ],
//                           ),
//                           // SizedBox(
//                           //   height: size.getH(4),
//                           // ),
//                           // Row(
//                           //   crossAxisAlignment: CrossAxisAlignment.start,
//                           //   children: [
//                           //     Text(
//                           //       "${widget.curSym}${_price.roundToNString()}",
//                           //       style: TextStyle(
//                           //         fontSize: size.getS(16),
//                           //         color: Colors.black,
//                           //         fontFamily: kFontFMedium,
//                           //       ),
//                           //     ),
//                           //     Spacer(),
//                           //     Text(
//                           //       "${widget.curSym}${(_grouplist[_selectedIndex].modifierList![j].quantity * _price).roundToNString()}",
//                           //       style: TextStyle(
//                           //         fontSize: size.getS(16),
//                           //         color: Colors.black,
//                           //         fontFamily: kFontFBold,
//                           //       ),
//                           //     ),
//                           //     SizedBox(
//                           //       width: size.getW(4),
//                           //     )
//                           //   ],
//                           // ),
//                           // SizedBox(
//                           //   height: size.getH(8),
//                           // ),
//                         ],
//                       ),
//                     ),
//                   );
//                 }),
//               ),
//           ],
//         ),
//       );
//   }
// }

// class GroupModifier {
//   final String? labelName;
//   final List<ProductPriceModifier>? modifierList;

//   GroupModifier({
//     this.labelName,
//     this.modifierList,
//   });
// }
