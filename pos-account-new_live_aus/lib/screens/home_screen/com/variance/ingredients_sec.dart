// import 'package:flutter/material.dart';
// import 'package:pos_account/config/size_config.dart';
// import 'package:pos_account/constant/constant.dart';
// import 'package:pos_account/model/home/menu/place_order/pos_res/com/feature_product.dart';

// class IngredientSec extends StatelessWidget {
//   final List<ProductIngredient> productIngredients;
//   final Function() onUpdate;
//   const IngredientSec({
//     Key? key,
//     required this.productIngredients,
//     required this.onUpdate,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     final size = Ssize(context);
//     return Container(
//       // width: double.infinity,
//       // decoration: BoxDecoration(
//       //   color: kSecondaryColor.withOpacity(0.1),
//       //   borderRadius: BorderRadius.circular(10),
//       // ),
//       // padding: EdgeInsets.symmetric(
//       //     horizontal: size.getW(12), vertical: size.getH(8)),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           // Text(
//           //   "Remove Ingredients",
//           //   style: TextStyle(
//           //     fontSize: size.getS(18),
//           //     color: kSecondaryColor,
//           //     fontWeight: FontWeight.bold,
//           //   ),
//           // ),
//           SizedBox(height: size.getH(4)),
//           Wrap(
//             spacing: size.getW(16),
//             runSpacing: size.getH(8),
//             children: List.generate(
//                 productIngredients.length,
//                 (index) => InkWell(
//                       onTap: () {
//                         productIngredients[index].isActive =
//                             !productIngredients[index].isActive;
//                         onUpdate();
//                       },
//                       child: Container(
//                         height: size.getH(60),
//                         width: size.getW(200),
//                         alignment: Alignment.center,
//                         decoration: BoxDecoration(
//                           color: productIngredients[index].isActive
//                               ? Colors.grey.withOpacity(0.3)
//                               : Colors.white,
//                           borderRadius: BorderRadius.circular(5),
//                         ),
//                         padding: EdgeInsets.symmetric(
//                             horizontal: size.getW(8), vertical: size.getH(2)),
//                         child: Text(
//                           productIngredients[index].name ?? '',
//                           style: TextStyle(
//                             fontSize: size.getS(18),
//                             color: productIngredients[index].isActive
//                                 ? Colors.black45
//                                 : Colors.black,
//                             fontFamily: kFontFMedium,
//                             fontStyle: productIngredients[index].isActive
//                                 ? FontStyle.italic
//                                 : null,
//                             decoration: productIngredients[index].isActive
//                                 ? TextDecoration.lineThrough
//                                 : null,
//                           ),
//                           textAlign: TextAlign.center,
//                         ),
//                       ),
//                     )),
//           )
//         ],
//       ),
//     );
//   }
// }
