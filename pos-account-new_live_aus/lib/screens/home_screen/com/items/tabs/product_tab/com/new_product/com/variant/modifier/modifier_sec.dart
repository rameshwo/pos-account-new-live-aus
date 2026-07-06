// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_svg/flutter_svg.dart';
// import 'package:pos_account/config/size_config.dart';
// import 'package:pos_account/constant/constant.dart';
// import 'package:pos_account/ln.dart';
// import 'package:pos_account/providers/product/new_product_pro.dart';
// import 'package:pos_account/widgets/input/dropdown/drop_down.dart';
// import 'package:pos_account/widgets/input/text_form/text_form_widget.dart';
// import 'package:pos_account/widgets/load_btn.dart';
// import 'package:pos_account/widgets/switch_adap.dart';
// import 'package:provider/provider.dart';

// class VariationModifierSec extends StatelessWidget {
//   final Function()? remove;
//   final Animation<double> animation;
//   final Modifier? modifier;
//   final Function()? addNew;
//   final bool isService;
//   const VariationModifierSec({
//     Key? key,
//     this.remove,
//     required this.animation,
//     this.modifier,
//     this.addNew,
//     this.isService = false,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     final pro = Provider.of<NewProductPro>(context);
//     final size = Ssize(context);
//     return SizeTransition(
//       sizeFactor: animation,
//       child: Padding(
//         padding: EdgeInsets.symmetric(vertical: size.getH(8)),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Row(
//               children: [
//                 Expanded(
//                   child: DropDownList(
//                     vPad: 6,
//                     hint: "Choose Modifier",
//                     isReq: false,
//                     borderColor: Colors.black54,
//                     indexValue: modifier?.modifierLabelIndex,
//                     list: pro.addSecRes?.productPriceModifierGroups == null
//                         ? []
//                         : pro.addSecRes!.productPriceModifierGroups!
//                             .map((e) => e.name ?? '')
//                             .toList(),
//                     onChange: (int? i) {
//                       modifier?.modifierLabelIndex = i;

//                       pro.notify;
//                     },
//                   ),
//                 ),
//                 SizedBox(
//                   width: size.getW(18),
//                 ),
//                 Expanded(
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Card(
//                         elevation: 4,
//                         margin: EdgeInsets.zero,
//                         shadowColor: Colors.grey[200],
//                         color: kIconBackColor,
//                         shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(5)),
//                         child: InkWell(
//                           onTap: remove,
//                           child: Padding(
//                             padding: EdgeInsets.all(size.getW(11.0)),
//                             child: SvgPicture.asset(
//                               "assets/svg/icons/Delete.svg",
//                               width: size.getW(17),
//                               height: size.getW(18),
//                             ),
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//                 SizedBox(
//                   width: size.getW(2 * 18),
//                 ),
//                 Expanded(flex: 2, child: Container())
//               ],
//             ),
//             SizedBox(
//               height: size.getH(16),
//             ),
//             if (modifier != null)
//               ...List.generate(modifier!.modifierNameList.length, (index) {
//                 return Padding(
//                   padding: EdgeInsets.only(bottom: size.getH(8)),
//                   child: Row(
//                     children: [
//                       Expanded(
//                         flex: 1,
//                         child: DropDownList(
//                           hint: "Price Modifier",
//                           isReq: false,
//                           vPad: 6,
//                           borderColor: Colors.black54,
//                           indexValue: modifier!
//                               .modifierNameList[index].modifierNameIndex,
//                           list: pro.addSecRes?.productPriceModifers == null
//                               ? []
//                               : pro.addSecRes!.productPriceModifers!
//                                   .map((e) => e.name ?? '')
//                                   .toList(),
//                           onChange: (int? i) {
//                             modifier!
//                                 .modifierNameList[index].modifierNameIndex = i;
//                             modifier!.modifierNameList[index].modifierNameCltr
//                                 .clear();
//                             if (i != null) {
//                               modifier!.modifierNameList[index]
//                                       .modifierPriceCltr.text =
//                                   pro.addSecRes!.productPriceModifers![i]
//                                       .additionalValue
//                                       .toString();
//                             }
//                             pro.notify;
//                           },
//                         ),
//                       ),
//                       if (modifier?.modifierNameList[index].modifierNameIndex ==
//                           null) ...[
//                         SizedBox(
//                           width: size.getW(18),
//                         ),
//                         Expanded(
//                           child: TextFormWidget(
//                             isDense: true,
//                             isReq: false,
//                             // vPad: 6,
//                             errH: 0,
//                             borderColor: Colors.black54,
//                             borderRadius: 5,
//                             cltr: modifier == null
//                                 ? TextEditingController()
//                                 : modifier!
//                                     .modifierNameList[index].modifierNameCltr,
//                             hintText: "Name",
//                           ),
//                         )
//                       ],
//                       SizedBox(
//                         width: size.getW(18),
//                       ),
//                       Expanded(
//                         child: TextFormWidget(
//                           isDense: true,
//                           isReq: false,
//                           errH: 0,
//                           borderColor: Colors.black54,
//                           borderRadius: 5,
//                           textInputType: TextInputType.number,
//                           cltr: modifier == null
//                               ? TextEditingController()
//                               : modifier!
//                                   .modifierNameList[index].modifierPriceCltr,
//                           hintText: "Price",
//                         ),
//                       ),
//                       if (isService) ...[
//                         SizedBox(
//                           width: size.getW(18),
//                         ),
//                         Expanded(
//                           child: TextFormWidget(
//                             isDense: true,
//                             isReq: false,
//                             errH: 0,
//                             borderColor: Colors.black54,
//                             borderRadius: 5,
//                             textInputType: TextInputType.number,
//                             inputFormatters: [
//                               FilteringTextInputFormatter.digitsOnly
//                             ],
//                             cltr: modifier == null
//                                 ? TextEditingController()
//                                 : modifier!.modifierNameList[index].estTimeCltr,
//                             hintText: "Estimated Time",
//                             suffixIcon: Text('min',
//                                 style: TextStyle(fontSize: size.getS(14))),
//                             suffixIconWidth: 36,
//                           ),
//                         )
//                       ],
//                       SizedBox(
//                         width: size.getW(18),
//                       ),
//                       Expanded(
//                         child: Row(
//                           // mainAxisSize: MainAxisSize.min,
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           children: [
//                             SwitchAdap(
//                               value: modifier!.modifierNameList[index].status,
//                               size: size,
//                               onChanged: (val) {
//                                 modifier!.modifierNameList[index].status = val;
//                                 pro.notify;
//                               },
//                             ),
//                             SizedBox(
//                               width: size.getW(12),
//                             ),
//                             Text(
//                               modifier!.modifierNameList[index].status
//                                   ? LN.active
//                                   : LN.inActive,
//                               style: TextStyle(
//                                 fontSize: size.getS(16),
//                                 color: modifier!.modifierNameList[index].status
//                                     ? kSecondaryColor
//                                     : Colors.red.shade700,
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                       SizedBox(
//                         width: size.getW(18),
//                       ),
//                       Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Card(
//                             elevation: 4,
//                             margin: EdgeInsets.zero,
//                             shadowColor: Colors.grey[200],
//                             color: kIconBackColor,
//                             shape: RoundedRectangleBorder(
//                                 borderRadius: BorderRadius.circular(5)),
//                             child: InkWell(
//                               onTap: () {
//                                 modifier?.modifierNameList.removeAt(index);
//                                 pro.notify;
//                               },
//                               child: Padding(
//                                 padding: EdgeInsets.all(size.getW(11.0)),
//                                 child: SvgPicture.asset(
//                                   "assets/svg/icons/Delete.svg",
//                                   width: size.getW(17),
//                                   height: size.getW(18),
//                                 ),
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                       if (!isService ||
//                           modifier?.modifierNameList[index].modifierNameIndex !=
//                               null) ...[
//                         SizedBox(
//                           width: size.getW(18),
//                         ),
//                         Expanded(child: Container())
//                       ]
//                     ],
//                   ),
//                 );
//               }),
//             LoadButton(
//               vPad: 8,
//               hPad: 4,
//               width: 190,
//               btnText:
//                   isService ? "+ Add More Modifiers" : "+ Add Price Modifier",
//               btnColor: Colors.white,
//               textColor: kSecondaryColor,
//               shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(5),
//                   side: BorderSide(color: kSecondaryColor)),
//               onsave: () {
//                 modifier?.modifierNameList.add(
//                   ModifierName(
//                     modifierPriceCltr: TextEditingController(),
//                     modifierNameCltr: TextEditingController(),
//                     estTimeCltr: TextEditingController(),
//                   ),
//                 );
//                 pro.notify;
//               },
//             ),
//             Divider(
//               color: Colors.black38,
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
