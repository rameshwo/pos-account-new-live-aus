// import 'package:flutter/material.dart';
// import 'package:pos_account/config/size_config.dart';
// import 'package:pos_account/constant/constant.dart';
// import 'package:pos_account/providers/product/new_product_pro.dart';
// import 'package:pos_account/widgets/cus_expansion_tile.dart';
// import 'package:provider/provider.dart';
// import '../add_icon_b.dart';
// import 'modifier_sec.dart';

// class ModifierListSec extends StatelessWidget {
//   final Ssize size;
//   final String title;
//   final Function()? onAdd;
//   final List<Modifier> modifierList;
//   final int vIndex;
//   final Function(int)? remove;
//   final bool isService;

//   const ModifierListSec({
//     Key? key,
//     required this.size,
//     required this.title,
//     this.onAdd,
//     required this.vIndex,
//     required this.modifierList,
//     this.remove,
//     this.isService = false,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     final newProdPro = Provider.of<NewProductPro>(context);

//     return Container(
//       // width: newProdPro.editData == null
//       //     ? MediaQuery.of(context).size.width * 0.5
//       //     : MediaQuery.of(context).size.width,
//       margin: EdgeInsets.only(top: size.getH(12)),
//       decoration: BoxDecoration(
//           color: kBackgroundColor, borderRadius: BorderRadius.circular(10)),
//       padding: EdgeInsets.symmetric(
//           vertical: size.getH(8), horizontal: size.getW(24)),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Theme(
//             data: ThemeData().copyWith(dividerColor: Colors.transparent),
//             child: CusExpansionTile(
//               initiallyExpanded: true,
//               assignFunction: (val) {
//                 newProdPro.modifierExFun = val;
//               },
//               onExpansionChanged: (val) => newProdPro.modifierExpand = val,
//               tilePadding: EdgeInsets.zero,
//               childrenPadding: EdgeInsets.zero,
//               controlAffinity: ListTileControlAffinity.leading,
//               title: Row(
//                 children: [
//                   Text.rich(
//                     TextSpan(
//                       text: title,
//                       style: TextStyle(
//                         fontSize: size.getS(18),
//                         color: Colors.black,
//                       ),
//                     ),
//                   ),
//                   SizedBox(
//                     width: size.getW(18),
//                   ),
//                   AddIconB(
//                     size: size,
//                     onTap: onAdd,
//                   )
//                 ],
//               ),
//               children: [
//                 if (modifierList.isNotEmpty)
//                   AnimatedList(
//                       key: newProdPro.modifierKeyList[vIndex],
//                       shrinkWrap: true,
//                       physics: NeverScrollableScrollPhysics(),
//                       initialItemCount: modifierList.length,
//                       itemBuilder: (ctx, i, animation) {
//                         return VariationModifierSec(
//                           animation: animation,
//                           remove: remove == null ? null : () => remove!(i),
//                           modifier: modifierList[i],
//                           isService: isService,
//                         );
//                       }),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
