// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:flutter/material.dart';
// import 'package:pos_account/config/size_config.dart';
// import 'package:pos_account/config/utils.dart';
// import 'package:pos_account/config/validator.dart';
// import 'package:pos_account/constant/constant.dart';
// import 'package:pos_account/ln.dart';
// import 'package:pos_account/model/home/menu/place_order/place_order_req.dart';
// import 'package:pos_account/model/home/menu/place_order/pos_res/com/feature_product.dart';
// import 'package:pos_account/model/home/menu/place_order/product_filter_option.dart';
// import 'package:pos_account/model/ui_model/prom_discount.dart';
// import 'package:pos_account/providers/cus_val_pro.dart';
// import 'package:pos_account/screens/home_screen/com/items/com/item_sec_tile.dart';
// import 'package:pos_account/screens/home_screen/com/quantity_sec.dart';
// import 'package:pos_account/widgets/image/image_error.dart';
// import 'package:pos_account/widgets/input/dropdown/drop_down.dart';
// import 'selective_tab.dart';

// class VarianceItem extends StatelessWidget {
//   final String name;
//   final String? imgPath;
//   final String price;
//   final double quantity;
//   final Function(bool?)? update;
//   final Function()? addToCart;
//   final bool isUpdate;
//   //for adons variation only
//   final bool showAdOnVar;
//   final List<ProductVariation>? adVarList;
//   final Function()? onChanged;
//   final int? selectedVar;
//   final String? outOfStockMessage;
//   final List<ProductFilterOption>? filterOptions;
//   final List<OrderItemSelectOptionsViewModels>? filterTypeList;
//   final Function()? onTapPrice;
//   final Widget? spice;
//   final Function()? onAddAsHalfItem;
//   final String? halfAddTitle;
//   final bool isFromHalfDia;
//   final String? curSym;
//   final String? discountedPrice;
//   final String? disPercent;
//   final PromDiscount? promDiscount;
//   final String? estimatedTime;
//   final List<String?>? serviceItemList;
//   final String? serviceGender;

//   const VarianceItem({
//     Key? key,
//     required this.name,
//     this.imgPath,
//     required this.price,
//     required this.quantity,
//     this.update,
//     this.addToCart,
//     this.isUpdate = false,
//     this.showAdOnVar = false,
//     this.adVarList,
//     this.onChanged,
//     this.selectedVar,
//     this.outOfStockMessage,
//     this.filterOptions,
//     this.filterTypeList,
//     this.onTapPrice,
//     this.spice,
//     this.onAddAsHalfItem,
//     this.halfAddTitle,
//     this.isFromHalfDia = false,
//     this.curSym,
//     this.discountedPrice,
//     this.promDiscount,
//     this.disPercent,
//     this.estimatedTime,
//     this.serviceItemList,
//     this.serviceGender,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     final size = Ssize(context);
//     final outOfStockShow =
//         outOfStockMessage != null && GlobalCVP.stockExceedRestriction;
//     return Card(
//       child: Padding(
//         padding: EdgeInsets.symmetric(
//             vertical: size.getH(6), horizontal: size.getW(16)),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Row(
//               mainAxisSize: MainAxisSize.min,
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 if (imgPath != null)
//                   ClipRRect(
//                       borderRadius: BorderRadius.circular(100),
//                       child: CachedNetworkImage(
//                           imageUrl: imgPath!,
//                           height: size.getW(48),
//                           width: size.getW(48),
//                           fit: BoxFit.fitHeight,
//                           placeholder: ImageError.load,
//                           errorWidget: ImageError.notSupportIcon)),
//                 SizedBox(
//                   width: size.getW(12),
//                 ),
//                 Expanded(
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Row(
//                             children: [
//                               Flexible(
//                                 child: Text(
//                                   name,
//                                   style: TextStyle(
//                                     fontSize: size.getS(16),
//                                     color: Colors.black,
//                                     fontFamily: kFontFMedium,
//                                   ),
//                                 ),
//                               ),
//                               if (GlobalCVP.isServiceStore &&
//                                   (estimatedTime?.isNotEmpty ?? false)) ...[
//                                 if (serviceGender?.isNotEmpty ?? false)
//                                   Text(
//                                     "  ● ${serviceGender ?? ''}",
//                                     style: TextStyle(
//                                       fontSize: size.getS(16),
//                                       fontWeight: FontWeight.bold,
//                                       color: Colors.green.shade700,
//                                     ),
//                                   ),
//                                 Container(
//                                   margin: EdgeInsets.only(left: size.getW(12)),
//                                   padding: EdgeInsets.symmetric(
//                                       horizontal: size.getW(16),
//                                       vertical: size.getH(2)),
//                                   decoration: BoxDecoration(
//                                       color: Colors.green.withOpacity(0.15),
//                                       borderRadius: BorderRadius.circular(10)),
//                                   child: Text(
//                                     "● Estimated Time : ${Utils.convertMinutesToHours(estimatedTime, false)}",
//                                     style: TextStyle(
//                                       fontSize: size.getS(16),
//                                       fontWeight: FontWeight.bold,
//                                       color: Colors.green.shade700,
//                                     ),
//                                   ),
//                                 )
//                               ]
//                             ],
//                           ),
//                           Row(
//                             crossAxisAlignment: CrossAxisAlignment.end,
//                             children: [
//                               ItemPriceView(
//                                 size: size,
//                                 curSym: curSym,
//                                 initPrice: price,
//                                 priceAfterDiscount:
//                                     (promDiscount?.isOfferStart ?? false) &&
//                                             (promDiscount?.offerStartsIn
//                                                         ?.inSeconds ??
//                                                     0) <
//                                                 300
//                                         ? promDiscount?.discountedPrice
//                                         : discountedPrice,
//                                 fontRatio: 1.1,
//                               ),
//                               if ((discountedPrice != null &&
//                                       disPercent.inDouble != 0) ||
//                                   ((promDiscount?.isOfferStart ?? false) &&
//                                       (promDiscount?.offerStartsIn?.inSeconds ??
//                                               0) <
//                                           300))
//                                 Container(
//                                   margin: EdgeInsets.symmetric(
//                                       horizontal: size.getW(8)),
//                                   decoration: BoxDecoration(
//                                     color: Colors.red.shade800,
//                                     borderRadius: BorderRadius.circular(5),
//                                   ),
//                                   padding: EdgeInsets.symmetric(
//                                       vertical: size.getS(4),
//                                       horizontal: size.getS(8)),
//                                   child: Text(
//                                     ((promDiscount?.isOfferStart ?? false) &&
//                                                 (promDiscount?.offerStartsIn
//                                                             ?.inSeconds ??
//                                                         0) <
//                                                     300
//                                             ? "${(promDiscount?.discountPercent ?? '').inQty}%"
//                                             : "${disPercent.inQty}%") +
//                                         ' OFF',
//                                     style: TextStyle(
//                                       fontSize: size.getS(15),
//                                       color: Colors.white,
//                                       fontFamily: kFontFMedium,
//                                     ),
//                                   ),
//                                 ),
//                               if (onTapPrice != null) ...[
//                                 SizedBox(
//                                   width: size.getW(8),
//                                 ),
//                                 InkWell(
//                                   onTap: onTapPrice,
//                                   child: Text(
//                                     LN.changePrice,
//                                     style: TextStyle(
//                                       fontSize: size.getS(14),
//                                       color: Colors.red,
//                                       decoration: TextDecoration.underline,
//                                     ),
//                                   ),
//                                 )
//                               ]
//                             ],
//                           ),
//                           if (!GlobalCVP.stockExceedRestriction &&
//                               (outOfStockMessage?.isNotEmpty ?? false))
//                             AnimatedContainer(
//                                 margin: EdgeInsets.only(top: size.getH(4)),
//                                 duration: Duration(milliseconds: 400),
//                                 height: outOfStockMessage != null
//                                     ? size.getH(28)
//                                     : 0,
//                                 decoration: BoxDecoration(
//                                   color: Colors.red.withAlpha(50),
//                                   borderRadius: BorderRadius.circular(15),
//                                 ),
//                                 padding: EdgeInsets.symmetric(
//                                     horizontal: size.getW(12),
//                                     vertical: size.getH(4)),
//                                 child: Text(
//                                   outOfStockMessage ?? '',
//                                   style: TextStyle(
//                                     color: Colors.red.shade800,
//                                     fontSize: size.getS(14),
//                                     fontFamily: kFontFMedium,
//                                   ),
//                                   textAlign: TextAlign.center,
//                                 )),
//                           // if (GlobalCVP.isServiceStore &&
//                           //     (estimatedTime?.isNotEmpty ?? false)) ...[
//                           //   SizedBox(height: size.getH(2)),
//                           //   Container(
//                           //     margin: EdgeInsets.only(top: size.getH(6)),
//                           //     padding: EdgeInsets.symmetric(
//                           //         horizontal: size.getW(16),
//                           //         vertical: size.getH(2)),
//                           //     decoration: BoxDecoration(
//                           //         color: Colors.green.withOpacity(0.15),
//                           //         borderRadius: BorderRadius.circular(10)),
//                           //     child: Text(
//                           //       "$estimatedTime minutes",
//                           //       style: TextStyle(
//                           //         fontSize: size.getS(18),
//                           //         fontWeight: FontWeight.bold,
//                           //         color: Colors.green.shade700,
//                           //       ),
//                           //     ),
//                           //   )
//                           // ]
//                         ],
//                       ),
//                       if (GlobalCVP.isServiceStore && serviceItemList != null)
//                         Wrap(
//                           children:
//                               List.generate(serviceItemList!.length, (index) {
//                             final _serviceItem = serviceItemList![index];
//                             return SizedBox(
//                               // color: Colors.amber,
//                               width: size.getW(180),
//                               child: Row(
//                                 children: [
//                                   Text(
//                                     "● ",
//                                     style: TextStyle(
//                                       fontSize: size.getS(20),
//                                       fontFamily: kFontFMedium,
//                                       color: Colors.green.shade700,
//                                       height: 1.2,
//                                     ),
//                                     maxLines: 1,
//                                   ),
//                                   Expanded(
//                                     child: Text(
//                                       _serviceItem?.trim() ?? '',
//                                       style: TextStyle(
//                                         fontSize: size.getS(16),
//                                         fontFamily: kFontFMedium,
//                                         height: 1.3,
//                                         color: Colors.green.shade700,
//                                       ),
//                                       maxLines: 2,
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             );
//                           }),
//                         ),
//                       if (promDiscount != null) ...[
//                         ItemTimerView(
//                           size: size,
//                           promDiscount: promDiscount!,
//                           refresh: onChanged,
//                         ),
//                         if ((promDiscount?.offerStartsIn?.inSeconds ?? 0) < 300)
//                           Container(
//                             margin: EdgeInsets.only(top: size.getH(6)),
//                             padding: EdgeInsets.symmetric(
//                                 horizontal: size.getW(8),
//                                 vertical: size.getH(2)),
//                             decoration: BoxDecoration(
//                                 color: Colors.green.withOpacity(0.15),
//                                 borderRadius: BorderRadius.circular(5)),
//                             child: Text(
//                               promDiscount?.message ?? '',
//                               style: TextStyle(
//                                 fontSize: size.getS(17),
//                                 fontFamily: kFontFMedium,
//                                 color: Colors.green.shade900,
//                               ),
//                             ),
//                           ),
//                         if ((promDiscount?.offerStartsIn?.inSeconds ?? 0) < 300)
//                           Container(
//                             margin: EdgeInsets.only(top: size.getH(6)),
//                             padding: EdgeInsets.symmetric(
//                                 horizontal: size.getW(8),
//                                 vertical: size.getH(2)),
//                             decoration: BoxDecoration(
//                                 color: Colors.green.withOpacity(0.15),
//                                 borderRadius: BorderRadius.circular(5)),
//                             child: Text(
//                               "${LN.minPurchaseQty}: ${promDiscount?.tsCount}",
//                               style: TextStyle(
//                                 fontSize: size.getS(17),
//                                 fontFamily: kFontFMedium,
//                                 color: Colors.green.shade900,
//                               ),
//                             ),
//                           ),
//                       ],
//                       if (showAdOnVar &&
//                           adVarList != null &&
//                           adVarList!.isNotEmpty)
//                         Padding(
//                           padding: const EdgeInsets.only(top: 4.0),
//                           child: SizedBox(
//                             width: size.getW(140),
//                             child: DropDownList(
//                               borderRadius: 5,
//                               borderColor: kTempColor,
//                               textColor: kTempColor,
//                               iconEnableColor: kTempColor,
//                               vPad: 8,
//                               list: adVarList == null
//                                   ? []
//                                   : adVarList!
//                                       .map((e) => e.name ?? '')
//                                       .toList(),
//                               onChange: (p0) {
//                                 if (p0 == null || adVarList == null) return;
//                                 for (final e in adVarList!) {
//                                   e.isDefault = false;
//                                 }
//                                 adVarList![p0].isDefault = true;
//                                 if (onChanged != null) onChanged!();
//                               },
//                               indexValue: selectedVar,
//                               fontSize: 14,
//                             ),
//                           ),
//                         ),
//                       if (filterTypeList?.isNotEmpty ?? false)
//                         Wrap(
//                           spacing: size.getW(8),
//                           runSpacing: size.getH(6),
//                           children: List.generate(
//                               filterTypeList!.length,
//                               (index) => Container(
//                                     padding: EdgeInsets.symmetric(
//                                         horizontal: size.getW(12),
//                                         vertical: size.getH(2)),
//                                     decoration: BoxDecoration(
//                                         color: kSecondaryColor,
//                                         borderRadius: BorderRadius.circular(5)),
//                                     child: Text.rich(
//                                       TextSpan(
//                                           text:
//                                               "${filterTypeList![index].selectOptionName} : ",
//                                           style: TextStyle(
//                                             fontSize: size.getS(14),
//                                             color: Colors.white,
//                                           ),
//                                           children: [
//                                             TextSpan(
//                                               text: filterTypeList![index]
//                                                   .selectOptionValue,
//                                               style: TextStyle(
//                                                 fontWeight: FontWeight.bold,
//                                               ),
//                                             )
//                                           ]),
//                                     ),
//                                   )),
//                         ),
//                       AnimatedSwitcher(
//                         duration: Duration(milliseconds: 400),
//                         switchInCurve: Curves.easeInToLinear,
//                         child: Column(
//                           key: ValueKey<bool>(filterOptions != null),
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             if (filterOptions != null)
//                               ...List.generate(
//                                   filterOptions!.length,
//                                   (index) => _filterSection(
//                                         size,
//                                         filterType: filterOptions![index],
//                                         onChanged: onChanged,
//                                       )),
//                           ],
//                         ),
//                       )
//                     ],
//                   ),
//                 ),
//                 Column(
//                   crossAxisAlignment: CrossAxisAlignment.end,
//                   children: [
//                     if (onAddAsHalfItem == null)
//                       QuantitySection(
//                         quantity: quantity,
//                         size: size,
//                         update: update,
//                       ),
//                     SizedBox(
//                       height: size.getH(4),
//                     ),
//                     Row(
//                       children: [
//                         if (onAddAsHalfItem != null) ...[
//                           textButton(
//                             size,
//                             width: 160,
//                             onPressed: onAddAsHalfItem,
//                             sideColor: !outOfStockShow
//                                 ? kSecondaryColor
//                                 : kSecondaryColor.withAlpha(60),
//                             backColor: !outOfStockShow
//                                 ? null
//                                 : MaterialStateProperty.all(
//                                     kSecondaryColor.withAlpha(60)),
//                             title: outOfStockShow
//                                 ? (outOfStockMessage ?? '')
//                                 : (halfAddTitle ?? LN.add),
//                             textColor: kSecondaryColor,
//                           ),
//                           SizedBox(width: size.getW(12))
//                         ] else
//                           // if (!isFromHalfDia)
//                           textButton(
//                             size,
//                             onPressed: outOfStockShow ? null : addToCart,
//                             sideColor: outOfStockShow
//                                 ? Colors.red.withAlpha(60)
//                                 : Colors.red,
//                             backColor: outOfStockShow
//                                 ? MaterialStateProperty.all(
//                                     Colors.red.withAlpha(60))
//                                 : null,
//                             title: outOfStockShow
//                                 ? (outOfStockMessage ?? '')
//                                 : isUpdate
//                                     ? LN.update
//                                     : LN.addToCart,
//                             textColor: Colors.red.shade800,
//                           ),
//                       ],
//                     )
//                   ],
//                 ),
//               ],
//             ),
//             if (spice != null) spice!
//           ],
//         ),
//       ),
//     );
//   }

//   static Widget textButton(
//     Ssize size, {
//     double width = 128,
//     Function()? onPressed,
//     required Color sideColor,
//     MaterialStateProperty<Color?>? backColor,
//     required Color textColor,
//     required String title,
//   }) {
//     return SizedBox(
//       width: size.getW(width),
//       child: TextButton(
//           onPressed: onPressed,
//           style: ButtonStyle(
//               padding: MaterialStateProperty.all(EdgeInsets.symmetric(
//                 vertical: size.getH(4.0),
//                 horizontal: size.getW(4),
//               )),
//               shape: MaterialStateProperty.all(RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(10),
//                   side: BorderSide(
//                     color: sideColor,
//                   ))),
//               backgroundColor: backColor),
//           child: Text(
//             title,
//             style: TextStyle(
//               fontSize: size.getS(14),
//               color: textColor,
//             ),
//           )),
//     );
//   }

//   Widget _filterSection(
//     Ssize size, {
//     final ProductFilterOption? filterType,
//     Function()? onChanged,
//   }) {
//     if (filterType?.filterCategoryName == null ||
//         filterType?.filterTypeOptions == null) return SizedBox.shrink();
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Row(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             Text(
//               filterType!.filterCategoryName ?? '',
//               style: TextStyle(
//                 fontSize: size.getS(16),
//                 color: Colors.black,
//                 fontFamily: kFontFMedium,
//               ),
//             ),
//             SizedBox(width: size.getW(8)),
//             if (filterType.childernCategories?.isNotEmpty ?? false)
//               Padding(
//                 padding: EdgeInsets.only(top: size.getH(12)),
//                 child: SizedBox(
//                     width: size.getW(160),
//                     child: DropDownList(
//                       hPad: 0,
//                       fontSize: 14,
//                       borderColor: Colors.black38,
//                       list: filterType.childernCategories!
//                           .map((e) => e.filterCategoryName ?? '')
//                           .toList(),
//                       indexValue: filterType.childSelectedIndex,
//                       vPad: 4,
//                       onChange: (p0) {
//                         filterType.childSelectedIndex = p0;
//                         if (onChanged != null) onChanged();
//                       },
//                     )),
//               )
//           ],
//         ),
//         SizedBox(height: size.getH(4)),
//         if ((filterType.childernCategories?.isNotEmpty ?? false) &&
//             filterType.childSelectedIndex != null)
//           Builder(builder: (context) {
//             final _option =
//                 filterType.childernCategories![filterType.childSelectedIndex!];
//             return Padding(
//               padding: EdgeInsets.only(top: size.getH(4)),
//               child: _optionSection(
//                 size,
//                 filterTypeOptions: _option.filterTypeOptions!,
//                 isMultiSelected: _option.selectionType ==
//                     "1", // filterType.selectionType == "1": may be
//                 onChanged: () {
//                   if (onChanged != null) onChanged();
//                 },
//               ),
//             );
//           })
//         else
//           _optionSection(
//             size,
//             filterTypeOptions: filterType.filterTypeOptions!,
//             isMultiSelected: filterType.selectionType == "1",
//             onChanged: () {
//               if (onChanged != null) onChanged();
//             },
//           ),
//         SizedBox(
//           height: size.getH(12),
//         ),
//         Divider(
//           height: 1,
//           color: Colors.black54,
//         ),
//       ],
//     );
//   }

//   Widget _optionSection(
//     Ssize size, {
//     required final List<FilterTypeOption> filterTypeOptions,
//     final bool isMultiSelected = false,
//     final Function()? onChanged,
//   }) {
//     return Wrap(
//       spacing: size.getW(6),
//       runSpacing: size.getH(6),
//       children: List.generate(
//           filterTypeOptions.length,
//           (index) => SelectiveTab(
//                 title: filterTypeOptions[index].filterCategoryOptionName ?? '',
//                 isDefault: filterTypeOptions[index].isSelected,
//                 onTap: () {
//                   if (!isMultiSelected) {
//                     for (int i = 0; i < filterTypeOptions.length; i++)
//                       if (index != i) filterTypeOptions[i].isSelected = false;
//                   }
//                   filterTypeOptions[index].isSelected =
//                       !filterTypeOptions[index].isSelected;
//                   if (onChanged != null) onChanged();
//                 },
//               )),
//     );
//   }
// }
