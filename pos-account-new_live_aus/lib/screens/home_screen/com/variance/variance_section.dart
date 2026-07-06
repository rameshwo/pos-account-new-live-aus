// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:flutter/material.dart';
// import 'package:oktoast/oktoast.dart';
// import 'package:pos_account/config/responsive.dart';
// import 'package:pos_account/config/size_config.dart';
// import 'package:pos_account/config/utils.dart';
// import 'package:pos_account/config/validator.dart';
// import 'package:pos_account/constant/constant.dart';
// import 'package:pos_account/ln.dart';
// import 'package:pos_account/model/home/menu/place_order/place_order_req.dart';
// import 'package:pos_account/model/home/menu/place_order/pos_res/com/feature_product.dart';
// import 'package:pos_account/providers/cus_val_pro.dart';
// import 'package:pos_account/providers/menu/half_item_pro.dart';
// import 'package:pos_account/providers/menu/place_order_pro.dart';
// import 'package:pos_account/providers/menu/pos_retail_pro.dart';
// import 'package:pos_account/screens/home_screen/com/items/tabs/pos_tab/pos_non_retail/com/half_half/half_half_sec.dart';
// import 'package:pos_account/screens/home_screen/com/variance/selective_tab.dart';
// import 'package:pos_account/screens/home_screen/com/variance/variance_item.dart';
// import 'package:pos_account/widgets/image/image_error.dart';
// import 'package:pos_account/widgets/loading.dart';
// import 'package:provider/provider.dart';
// import '../items/com/price_update_dia.dart';
// import 'batch_sec.dart';
// import 'ingredients_sec.dart';
// import 'modifier_section.dart';

// // ignore: must_be_immutable
// class Variance extends StatefulWidget {
//   FeaturedProduct? product;
//   final String? catTypeId;
//   final String curSym;
//   final int? orderDetailIndex;
//   double? quantity;
//   final String? uniqueKey;
//   // List<String>? modifierIds;
//   // List<OrderItemsPriceModifierViewModel>? modifierList;
//   final List<OrderItemSelectOptionsViewModels>? filterTypeList;
//   final bool isPosTab;
//   final bool isHalfItem;
//   Variance({
//     Key? key,
//     required this.product,
//     required this.curSym,
//     this.orderDetailIndex,
//     this.quantity,
//     this.uniqueKey,
//     // this.modifierIds,
//     // this.modifierList,
//     this.filterTypeList,
//     required this.catTypeId,
//     this.isPosTab = false,
//     this.isHalfItem = false,
//   }) : super(key: key);

//   @override
//   State<Variance> createState() => _VarianceState();
// }

// class _VarianceState extends State<Variance> {
//   void onPopUp(FeaturedProduct? _product) {
//     if (_product?.productVariations != null)
//       for (final a in _product!.productVariations!) {
//         if (a.productPriceModifiers != null)
//           for (final b in a.productPriceModifiers!) {
//             b.isActive = false;
//           }
//       }
//     _product?.selectedSpiceId = null;
//   }

//   double _initQty = 0;

//   PlaceOrderPro? _placeOr;

//   String? _customPrice;

//   @override
//   void initState() {
//     _getData();
//     super.initState();
//   }

//   void _getData() {
//     _placeOr = Provider.of<PlaceOrderPro>(context, listen: false);
//     WidgetsBinding.instance!.addPostFrameCallback((_) {
//       _placeOr?.getProductData(
//         widget.product?.id,
//         filterTypeList: widget.filterTypeList,
//         featuredProduct: widget.product,
//         isPosTab: widget.isPosTab,
//       );
//     });
//   }

//   // List<OrderItemSelectOptionsViewModels>? get _getSelectedFilter {
//   //   if (_placeOr
//   //           ?.productDetailView?.filterCategoriesWithChildernFilterOptions ==
//   //       null) return null;
//   //   final _fiterData = <OrderItemSelectOptionsViewModels>[];

//   //   for (final a in _placeOr!
//   //       .productDetailView!.filterCategoriesWithChildernFilterOptions!) {
//   //     if (a.childernCategories != null && a.childernCategories!.isNotEmpty) {
//   //       final _optionValue = <String>[];
//   //       final _optionId = <String>[];

//   //       for (final e in a.childernCategories!) {
//   //         if (e.filterTypeOptions != null &&
//   //             e.filterTypeOptions!.any((f) => f.isSelected)) {
//   //           final _selected = e.filterTypeOptions!.where((g) => g.isSelected);

//   //           _optionId.addAll(
//   //               _selected.map((i) => i.filterCategoryOptionId ?? '').toList());

//   //           _optionValue.addAll(_selected
//   //               .map((h) =>
//   //                   "${e.filterCategoryName ?? ''}(${h.filterCategoryOptionName ?? ''})")
//   //               .toList());
//   //         }
//   //       }
//   //       if (_optionId.isNotEmpty) {
//   //         _fiterData.add(
//   //           OrderItemSelectOptionsViewModels(
//   //             id: a.id,
//   //             filterTypeId: a.filterCategoryId,
//   //             selectOptionName: a.filterCategoryName,
//   //             selectOptionValue: _optionValue.join(','),
//   //             filterTypeOptionsId: _optionId.join(','),
//   //           ),
//   //         );
//   //       }
//   //     } else if (a.filterTypeOptions != null &&
//   //         a.filterTypeOptions!.any((b) => b.isSelected)) {
//   //       _fiterData.add(
//   //         OrderItemSelectOptionsViewModels(
//   //             id: a.id,
//   //             filterTypeId: a.filterCategoryId,
//   //             selectOptionName: a.filterCategoryName,
//   //             selectOptionValue: a.filterTypeOptions!
//   //                 .where((c) => c.isSelected)
//   //                 .map((d) => d.filterCategoryOptionName ?? '')
//   //                 .toList()
//   //                 .join(","),
//   //             filterTypeOptionsId: a.filterTypeOptions!
//   //                 .where((c) => c.isSelected)
//   //                 .map((d) => d.filterCategoryOptionId ?? '')
//   //                 .toList()
//   //                 .join(",")),
//   //       );
//   //     }
//   //   }

//   //   // log(jsonEncode(_fiterData.map((e) => e.toJson()).toList()));

//   //   return _fiterData;
//   // }

//   @override
//   void dispose() {
//     _placeOr?.productDetailView?.filterCategoriesWithChildernFilterOptions =
//         null;
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final size = Ssize(context);
//     final placeOrderPro = Provider.of<PlaceOrderPro>(context);

//     final _product =
//         placeOrderPro.productDetailView?.productListViewModel ?? widget.product;

//     final _selectedVariance = (_product?.productVariations?.isNotEmpty ?? false)
//         ? _product!.productVariations!.firstWhere(
//             (e) => e.isDefault != null && e.isDefault!,
//             orElse: () => _product.productVariations!.first,
//           )
//         : null;

//     if (widget.quantity != null) {
//       if (widget.uniqueKey != null) _initQty = widget.quantity!;

//       _product?.quantity = widget.quantity!;
//       widget.quantity = null;
//     }

//     // List<OrderItemsPriceModifierViewModel>? _modifierList = widget.modifierList
//     //     ?.map((e) => OrderItemsPriceModifierViewModel.fromJson(e.toJson()))
//     //     .toList();

//     // if (widget.modifierList != null &&
//     //     _selectedVariance?.productPriceModifiers != null) {
//     //   for (final e in _selectedVariance!.productPriceModifiers!) {
//     //     if (widget.modifierList!.any((a) =>
//     //         a.priceVariationModifierId?.toLowerCase() == e.id?.toLowerCase())) {
//     //       e.isActive = true;
//     //       e.updateId = widget.modifierList!
//     //           .firstWhere((a) =>
//     //               a.priceVariationModifierId?.toLowerCase() ==
//     //               e.id?.toLowerCase())
//     //           .id;
//     //     }
//     //   }
//     //   widget.modifierList = null;
//     // }

//     final _itemPrice = _customPrice ?? _selectedVariance?.actualPrice;

//     final _promDiscount =
//         Utils.getPromDiscount(_selectedVariance?.discountedPromotions);

//     /// add as halfItem
//     final _halfItemPro = Provider.of<HalfItemPro>(context);
//     final _isFirstHalf =
//         _halfItemPro.isHalfFeatureEnable == HalfItemCount.secondHalf
//             ? false
//             : _halfItemPro.firstItem == null;

//     final _posRetailPro = Provider.of<PosRetailPro>(context);

//     final _isBatchEnable =
//         (placeOrderPro.initAddSec?.storeStockDeductInformation?.isBatch ??
//                 false) ||
//             (_posRetailPro
//                     .retailPosOrderRes?.storeStockDeductInformation?.isBatch ??
//                 false);

//     if (placeOrderPro.productDetailView == null &&
//         placeOrderPro.varianceLoading)
//       return SizedBox(height: size.getH(50), child: Loading());
//     else
//       return WillPopScope(
//         onWillPop: () async {
//           onPopUp(_product);
//           return true;
//         },
//         child: Container(
//           constraints: BoxConstraints(
//             maxHeight: size.height / 1.2,
//             minHeight: size.height / 5,
//           ),
//           width: size.width / 1.6,
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               Row(
//                 children: [
//                   Text(
//                     GlobalCVP.isServiceStore
//                         ? "Add Service to Cart"
//                         : LN.selectNumOfItems,
//                     style: TextStyle(
//                       fontSize: size.getS(18),
//                       fontFamily: kFontFMedium,
//                       fontWeight: FontWeight.bold,
//                       color: Colors.white,
//                     ),
//                   ),
//                   Spacer(),
//                   // if (!widget.isHalfItem)
//                   ElevatedButton(
//                       style: ButtonStyle(
//                         backgroundColor:
//                             MaterialStateProperty.all(kSecondaryColor),
//                         minimumSize: MaterialStateProperty.all(Size(0, 0)),
//                         padding: MaterialStateProperty.all(EdgeInsets.symmetric(
//                             horizontal: size.getW(20),
//                             vertical: size.getH(10))),
//                       ),
//                       onPressed: () {
//                         Navigator.pop(context);
//                         onPopUp(_product);
//                       },
//                       child:
//                           Text("X", style: TextStyle(fontSize: size.getS(16)))
//                       // Icon(
//                       //   Icons.close,
//                       //   size: size.getS(24),
//                       //   color: Colors.white,
//                       // )
//                       )
//                 ],
//               ),
//               Flexible(
//                 child: SingleChildScrollView(
//                   child: Column(
//                     mainAxisSize: MainAxisSize.min,
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       SizedBox(
//                         height: size.getH(8),
//                       ),
//                       Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Text(
//                             _product?.productVariationLabelName ??
//                                 LN.selectSize,
//                             style: TextStyle(
//                               fontSize: size.getS(16),
//                               color: Colors.white,
//                               fontWeight: FontWeight.bold,
//                             ),
//                           ),
//                           SizedBox(
//                             height: size.getH(8),
//                           ),
//                           if (_product != null &&
//                               _product.productVariations != null)
//                             Wrap(
//                               runSpacing: size.getH(8),
//                               // crossAxisAlignment: CrossAxisAlignment.start,
//                               // mainAxisSize: MainAxisSize.min,
//                               children: [
//                                 ...List.generate(
//                                     _product.productVariations!.length,
//                                     (index) {
//                                   final _isDefault = _product
//                                           .productVariations![index]
//                                           .isDefault ??
//                                       false;
//                                   return Padding(
//                                     padding:
//                                         EdgeInsets.only(right: size.getW(4)),
//                                     child: SelectiveTab(
//                                       title: _product.productVariations![index]
//                                                       .name ==
//                                                   null ||
//                                               _product.productVariations![index]
//                                                   .name!.isEmpty
//                                           ? (_product.name ?? '')
//                                           : (_product.productVariations![index]
//                                                   .name ??
//                                               ''),
//                                       isDefault: _isDefault,
//                                       onTap: () {
//                                         if (placeOrderPro.itemViewList.isEmpty)
//                                           return;

//                                         for (final e
//                                             in _product.productVariations!) {
//                                           e.isDefault = false;
//                                         }

//                                         if (_selectedVariance
//                                                 ?.productPriceModifiers !=
//                                             null)
//                                           for (final f in _selectedVariance!
//                                               .productPriceModifiers!) {
//                                             f.isActive = false;
//                                           }

//                                         _product.productVariations![index]
//                                             .isDefault = true;
//                                         placeOrderPro.varianceLoading = true;
//                                         placeOrderPro.notify;

//                                         Future.delayed(
//                                             Duration(milliseconds: 50), () {
//                                           placeOrderPro.varianceLoading = false;
//                                           placeOrderPro.notify;
//                                         });
//                                       },
//                                     ),
//                                   );
//                                 }),
//                               ],
//                             )
//                         ],
//                       ),
//                       SizedBox(
//                         height: size.getH(24),
//                       ),
//                       if (_product != null && _selectedVariance != null)
//                         LayoutBuilder(builder: (context, cons) {
//                           final _stock = double.tryParse(
//                               _selectedVariance.stockCount ?? '');
//                           final _totalQuantity = placeOrderPro.orderList
//                                   .any((b) => b.productId == _product.id)
//                               ? placeOrderPro.orderList
//                                       .where((b) => b.productId == _product.id)
//                                       .fold<double>(
//                                           0, (x, y) => x + (y.quantity ?? 0)) -
//                                   _initQty
//                               : 0;

//                           bool _outOfBatchStock = false;

//                           if (_isBatchEnable) {
//                             if (_selectedVariance.productVariationBatchStocks
//                                     ?.any((e) => e.isActive) ??
//                                 false) {
//                               final _batchStock = _selectedVariance
//                                   .productVariationBatchStocks
//                                   ?.firstWhere((e) => e.isActive)
//                                   .stockCount;

//                               _outOfBatchStock =
//                                   (_batchStock?.isNotEmpty ?? false) &&
//                                       _batchStock.inDouble <
//                                           (_product.quantity + _totalQuantity);
//                             }
//                           }

//                           final bool _outOfStock = (_stock != null &&
//                                   _stock <
//                                       (_product.quantity + _totalQuantity)) ||
//                               _outOfBatchStock;

//                           return SizedBox(
//                             // width: Responsive.isDesktop(context)
//                             //     ? (cons.maxWidth / 2 - 8)
//                             //     : null,
//                             child: Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 VarianceItem(
//                                   name: _product.name ?? '',
//                                   price: "$_itemPrice",
//                                   quantity: _product.quantity,
//                                   filterOptions: placeOrderPro.productDetailView
//                                       ?.filterCategoriesWithChildernFilterOptions,
//                                   onChanged: () => placeOrderPro.notify,
//                                   filterTypeList: widget.filterTypeList,
//                                   curSym: widget.curSym,
//                                   discountedPrice:
//                                       _selectedVariance.discountedPrice,
//                                   disPercent:
//                                       _selectedVariance.discountPercentage,
//                                   promDiscount: _promDiscount,
//                                   update: (bool? val) async {
//                                     if (val == null) {
//                                       if (_outOfStock &&
//                                           GlobalCVP.stockExceedRestriction)
//                                         return;
//                                       _product.quantity = await Utils.textQty(
//                                           _product.quantity);
//                                     } else if (val) {
//                                       if (_outOfStock &&
//                                           GlobalCVP.stockExceedRestriction)
//                                         return;

//                                       _product.quantity++;

//                                       // _product.quantity++;
//                                     } else {
//                                       if (_product.quantity < 2) return;
//                                       _product.quantity--;
//                                     }
//                                     _product.quantity =
//                                         _product.quantity.roundToN(n: 0);
//                                     placeOrderPro.notify;
//                                   },
//                                   outOfStockMessage: _outOfStock
//                                       ? _selectedVariance.outOfStockMessage
//                                       : null,
//                                   imgPath: _product.imageUrl,
//                                   isUpdate: widget.orderDetailIndex != null,
//                                   //  placeOrderPro.orderList.any((e) =>
//                                   //     e.productId == _product.id &&
//                                   //     e.quantity == _product.quantity &&
//                                   //     (e.productVariationId ==
//                                   // _product.productVariations!
//                                   //     .firstWhere(
//                                   //         (f) => f.isDefault != null && f.isDefault!)
//                                   //             .id)),
//                                   addToCart: _outOfStock &&
//                                           GlobalCVP.stockExceedRestriction
//                                       ? null
//                                       : () {
//                                           if (Utils.outOfBatchStock(
//                                               selectedVariance:
//                                                   _selectedVariance)) {
//                                             return;
//                                           }

//                                           placeOrderPro.updateOrderCart(
//                                             product: _product,
//                                             variation: _selectedVariance,
//                                             catId: _product.categoryId,
//                                             catTypeId: widget.catTypeId,
//                                             orderDetailIndex:
//                                                 widget.orderDetailIndex,
//                                             // orderItemSelectOptionsViewModel:
//                                             //     _getSelectedFilter,
//                                             isVarianceUpdate: true,
//                                             customPrice: _customPrice,
//                                           );

//                                           showToast(
//                                             widget.orderDetailIndex != null
//                                                 ? LN.updateSuccess
//                                                 : LN.addCartSuccess,
//                                             backgroundColor: Colors.green,
//                                             textStyle: TextStyle(
//                                                 color: Colors.white,
//                                                 fontFamily: kFontFMedium,
//                                                 fontSize: size.getS(16)),
//                                           );
//                                           _product.quantity = 1;

//                                           // MsgDia.show(
//                                           //   CUS_CTX,
//                                           //   headerAnimation: false,
//                                           //   diaType: DiaType.success,
//                                           //   title: widget.orderDetailIndex != null
//                                           //       ?  LN.updateSuccess
//                                           //       :  LN.addCartSuccess,
//                                           //   autoHideSecond: 2,
//                                           // );

//                                           // Navigator.pop(context);
//                                           onPopUp(_product);
//                                         },
//                                   //// half item section
//                                   onAddAsHalfItem: widget.isHalfItem
//                                       //  _halfItemPro
//                                       //             .isHalfFeatureEnable !=
//                                       //         HalfItemStatus.None
//                                       ? () {
//                                           if (_outOfStock &&
//                                               GlobalCVP.stockExceedRestriction)
//                                             return;
//                                           _halfItemPro.curSym =
//                                               placeOrderPro.curSym ?? '';
//                                           // print(
//                                           //     "object: ${_halfItemPro.updateCartIndex}");
//                                           _halfItemPro.createOrder(
//                                             product: _product,
//                                             variation: _selectedVariance,
//                                             catId: _product.categoryId,
//                                             catTypeId: widget.catTypeId,
//                                             itemKey:
//                                                 _halfItemPro.updateCartIndex !=
//                                                         null
//                                                     ? placeOrderPro
//                                                         .orderList[_halfItemPro
//                                                             .updateCartIndex!]
//                                                         .key
//                                                     : null,
//                                             isVarianceUpdate: true,
//                                             customPrice: _customPrice,
//                                             taxExclusiveInclusiveType:
//                                                 placeOrderPro
//                                                     .taxExclusiveInclusiveType,
//                                             getSelectedFilter:
//                                                 placeOrderPro.getSelectedFilter,
//                                             // drawerIndex: placeOrderPro.getDI,
//                                             orderTypeIndex:
//                                                 placeOrderPro.orderTypeIndex,
//                                           );

//                                           showToast(
//                                             LN.addHalfSucc,
//                                             backgroundColor: Colors.green,
//                                             textStyle: TextStyle(
//                                                 color: Colors.white,
//                                                 fontFamily: kFontFMedium,
//                                                 fontSize: size.getS(16)),
//                                           );
//                                           Navigator.pop(context);

//                                           if (_halfItemPro.firstItem != null &&
//                                               _halfItemPro.secondItem != null) {
//                                             final _orderList =
//                                                 _halfItemPro.orderToCart;

//                                             if (_orderList.isNotEmpty) {
//                                               if (_halfItemPro.halfGroupKey !=
//                                                   null) {
//                                                 for (final e in _orderList) {
//                                                   if (placeOrderPro.orderList
//                                                       .any((a) =>
//                                                           a.key
//                                                               ?.toLowerCase() ==
//                                                           e.key
//                                                               ?.toLowerCase())) {
//                                                     final _i = placeOrderPro
//                                                         .orderList
//                                                         .indexWhere((a) =>
//                                                             a.key
//                                                                 ?.toLowerCase() ==
//                                                             e.key
//                                                                 ?.toLowerCase());
//                                                     placeOrderPro
//                                                         .orderList[_i] = e;
//                                                   }
//                                                 }
//                                                 _halfItemPro.halfGroupKey =
//                                                     null;
//                                               } else {
//                                                 placeOrderPro.orderList
//                                                     .addAll(_orderList);
//                                               }
//                                               placeOrderPro.notify;
//                                             }
//                                             _halfItemPro.clear();
//                                           } else {
//                                             if (CUS_CTX != null) {
//                                               HalfHalfItemSec.showDia(
//                                                   CUS_CTX!, size);
//                                             }
//                                           }
//                                         }
//                                       : null,

//                                   halfAddTitle: _isFirstHalf
//                                       ? "Add as 1st Half"
//                                       : "Add as 2nd Half",

//                                   onTapPrice: GlobalCVP
//                                           .viewWidget.viewChangePriceText
//                                       ? () {
//                                           PriceUpdateDia.showDia(
//                                             context,
//                                             number: double.tryParse(
//                                                 _itemPrice ?? '0'),
//                                           ).then((value) {
//                                             if (value != null &&
//                                                 value is double) {
//                                               _selectedVariance.discount = null;
//                                               _selectedVariance
//                                                   .discountPercentage = null;
//                                               _selectedVariance
//                                                   .discountedPrice = null;

//                                               _selectedVariance
//                                                   .discountedPromotions = null;
//                                               _customPrice =
//                                                   value.roundToNString();
//                                               setState(() {});
//                                             }
//                                           });
//                                         }
//                                       : null,
//                                   spice: ((_selectedVariance
//                                                   .productVariationServiceEmployees
//                                                   ?.isNotEmpty ??
//                                               false) &&
//                                           GlobalCVP.isServiceStore)
//                                       ? Column(
//                                           crossAxisAlignment:
//                                               CrossAxisAlignment.start,
//                                           children: [
//                                             SizedBox(
//                                               height: size.getH(8),
//                                             ),
//                                             Text(
//                                               "Assign Staff",
//                                               style: TextStyle(
//                                                 fontSize: size.getS(16),
//                                                 fontFamily: kFontFMedium,
//                                                 color: Colors.black,
//                                               ),
//                                             ),
//                                             GridView.count(
//                                               physics:
//                                                   NeverScrollableScrollPhysics(),
//                                               crossAxisCount: 4,
//                                               mainAxisSpacing: 12,
//                                               crossAxisSpacing: 16,
//                                               childAspectRatio: 3,
//                                               shrinkWrap: true,
//                                               children: List.generate(
//                                                   _selectedVariance
//                                                       .productVariationServiceEmployees!
//                                                       .length, (j) {
//                                                 final _staff = _selectedVariance
//                                                     .productVariationServiceEmployees![j];
//                                                 return SpiceWidget(
//                                                     size: size,
//                                                     name: _staff.name ?? '',
//                                                     imgPath: _staff.imageUrl,
//                                                     isChecked:
//                                                         _staff.isSelected,
//                                                     onChanged: (val) {
//                                                       _staff.isSelected =
//                                                           !_staff.isSelected;
//                                                       _placeOr!.notify;
//                                                     });
//                                               }),
//                                             )
//                                           ],
//                                         )
//                                       : (_product.productSpiceChoices
//                                                   ?.isNotEmpty ??
//                                               false)
//                                           ? Column(
//                                               crossAxisAlignment:
//                                                   CrossAxisAlignment.start,
//                                               children: [
//                                                 SizedBox(
//                                                   height: size.getH(8),
//                                                 ),
//                                                 Text(
//                                                   LN.spiceChoices,
//                                                   style: TextStyle(
//                                                     fontSize: size.getS(16),
//                                                     fontFamily: kFontFMedium,
//                                                     color: Colors.black,
//                                                   ),
//                                                 ),
//                                                 GridView.count(
//                                                   physics:
//                                                       NeverScrollableScrollPhysics(),
//                                                   crossAxisCount: 4,
//                                                   mainAxisSpacing: 12,
//                                                   crossAxisSpacing: 16,
//                                                   childAspectRatio: 3,
//                                                   shrinkWrap: true,
//                                                   children: List.generate(
//                                                       _product
//                                                           .productSpiceChoices!
//                                                           .length,
//                                                       (j) => SpiceWidget(
//                                                           size: size,
//                                                           name: _product
//                                                                   .productSpiceChoices?[
//                                                                       j]
//                                                                   .name ??
//                                                               '',
//                                                           imgPath: _product
//                                                               .productSpiceChoices?[
//                                                                   j]
//                                                               .imageUrl,
//                                                           isChecked: _product
//                                                                   .selectedSpiceId ==
//                                                               _product
//                                                                   .productSpiceChoices![
//                                                                       j]
//                                                                   .id,
//                                                           onChanged: (val) {
//                                                             if (_product
//                                                                     .selectedSpiceId ==
//                                                                 _product
//                                                                     .productSpiceChoices![
//                                                                         j]
//                                                                     .id)
//                                                               _product.selectedSpiceId =
//                                                                   null;
//                                                             else
//                                                               _product.selectedSpiceId =
//                                                                   _product
//                                                                       .productSpiceChoices![
//                                                                           j]
//                                                                       .id;
//                                                             _placeOr!.notify;
//                                                           })),
//                                                 )
//                                               ],
//                                             )
//                                           : null,
//                                   estimatedTime:
//                                       _selectedVariance.estimatedTime,
//                                   serviceGender:
//                                       _selectedVariance.serviceGender,
//                                   serviceItemList: _selectedVariance
//                                       .productVariationServiceItems
//                                       ?.map((e) => e.name ?? '')
//                                       .toList(),
//                                 ),
//                                 if (_selectedVariance
//                                         .productVariationBatchStocks
//                                         ?.isNotEmpty ??
//                                     false)
//                                   BatchSection(
//                                     isBatch: _isBatchEnable,
//                                     batchList: _selectedVariance
//                                         .productVariationBatchStocks!,
//                                     dateFormat: placeOrderPro.dateFormat,
//                                     onUpdate: () {
//                                       placeOrderPro.notify;
//                                     },
//                                   ),
//                                 AnimatedSwitcher(
//                                   duration: Duration(milliseconds: 700),
//                                   switchInCurve: Curves.linearToEaseOut,
//                                   switchOutCurve: Curves.linearToEaseOut,
//                                   child: (!placeOrderPro.varianceLoading &&
//                                           (_selectedVariance
//                                                   .productPriceModifiers
//                                                   ?.isNotEmpty ??
//                                               false))
//                                       ? ModifierSection(
//                                           curSym: widget.curSym,
//                                           productPriceModifiers:
//                                               _selectedVariance
//                                                       .productPriceModifiers ??
//                                                   [],
//                                           update: () => placeOrderPro.notify,
//                                         )
//                                       : SizedBox.shrink(),
//                                 ),
//                                 if (_selectedVariance
//                                         .productIngredients?.isNotEmpty ??
//                                     false)
//                                   IngredientSec(
//                                     productIngredients:
//                                         _selectedVariance.productIngredients!,
//                                     onUpdate: () {
//                                       placeOrderPro.notify;
//                                     },
//                                   ),
//                               ],
//                             ),
//                           );
//                         }),
//                       SizedBox(
//                         height: size.getH(24),
//                       ),
//                       if (_product != null &&
//                           _product.addOns != null &&
//                           _product.addOns!.isNotEmpty)
//                         Column(
//                           children: [
//                             Text(
//                               LN.selectAdons,
//                               style: TextStyle(
//                                 fontSize: size.getS(18),
//                                 fontFamily: kFontFMedium,
//                                 fontWeight: FontWeight.bold,
//                                 color: Colors.white,
//                               ),
//                             ),
//                             SizedBox(
//                               height: size.getH(8),
//                             ),
//                           ],
//                         ),
//                       if (_product != null &&
//                           _product.addOns != null &&
//                           _product.addOns!.isNotEmpty)
//                         Flexible(
//                           child: GridView.count(
//                             physics: NeverScrollableScrollPhysics(),
//                             crossAxisCount:
//                                 Responsive.isTabletLarge(context) ? 2 : 1,
//                             mainAxisSpacing: 12,
//                             crossAxisSpacing: 16,
//                             childAspectRatio:
//                                 Responsive.isTabletLarge(context) ? 3.5 : 6,
//                             shrinkWrap: true,
//                             children: [
//                               ...List.generate(_product.addOns!.length,
//                                   (index) {
//                                 final _variationList = (_product.addOns![index]
//                                                 .productVariations !=
//                                             null &&
//                                         _product.addOns![index]
//                                             .productVariations!.isNotEmpty)
//                                     ? _product.addOns![index].productVariations!
//                                     // .firstWhere(
//                                     //     (e) => e.isDefault != null && e.isDefault!)
//                                     : null;
//                                 final _pVariation = _variationList != null &&
//                                         _variationList.any((e) =>
//                                             e.isDefault != null && e.isDefault!)
//                                     ? (_variationList.firstWhere((e) =>
//                                         e.isDefault != null && e.isDefault!))
//                                     : null;
//                                 final _outOfStock = double.tryParse(
//                                             _pVariation?.stockCount ?? '') ==
//                                         0 ||
//                                     (_pVariation?.stockCount != null &&
//                                         double.tryParse(
//                                                 _pVariation?.stockCount ??
//                                                     '') !=
//                                             0 &&
//                                         (double.tryParse(
//                                                     _pVariation?.stockCount ??
//                                                         '') ??
//                                                 0) <
//                                             _product.addOns![index].quantity);
//                                 return VarianceItem(
//                                   name: _product.addOns![index].name ?? '',
//                                   price: _pVariation != null
//                                       ? (widget.curSym +
//                                           (_pVariation.actualPrice ?? ''))
//                                       : '',
//                                   outOfStockMessage: _outOfStock
//                                       ? _pVariation?.outOfStockMessage
//                                       : null,
//                                   quantity: _product.addOns![index].quantity,
//                                   imgPath: _product.addOns![index].imageUrl,
//                                   isUpdate: widget.orderDetailIndex != null,
//                                   update: (bool? val) async {
//                                     if (val == null) {
//                                       if (!(_outOfStock &&
//                                           GlobalCVP.stockExceedRestriction))
//                                         _product.addOns![index].quantity =
//                                             await Utils.textQty(_product
//                                                 .addOns![index].quantity);
//                                     } else if (val) {
//                                       if (!(_outOfStock &&
//                                           GlobalCVP.stockExceedRestriction))
//                                         _product.addOns![index].quantity++;
//                                     } else {
//                                       if (_product.addOns![index].quantity < 2)
//                                         return;
//                                       _product.addOns![index].quantity--;
//                                     }
//                                     _product.addOns![index].quantity.roundToN();
//                                     placeOrderPro.notify;
//                                   },
//                                   addToCart: _outOfStock &&
//                                           GlobalCVP.stockExceedRestriction
//                                       ? null
//                                       : () {
//                                           placeOrderPro.updateOrderCart(
//                                             product: _product.addOns![index],
//                                             variation: _pVariation,
//                                             catId: _product.categoryId,
//                                             catTypeId: widget.catTypeId,
//                                           );
//                                           showToast(
//                                             LN.addCartSuccess,
//                                             backgroundColor: Colors.green,
//                                             textStyle: TextStyle(
//                                                 color: Colors.white,
//                                                 fontFamily: kFontFMedium,
//                                                 fontSize: size.getS(16)),
//                                           );
//                                         },
//                                   showAdOnVar: true,
//                                   adVarList: _variationList,
//                                   selectedVar: _variationList?.indexWhere((e) =>
//                                       e.isDefault != null && e.isDefault!),
//                                   onChanged: () {
//                                     placeOrderPro.notify;
//                                   },
//                                 );
//                               })
//                             ],
//                           ),
//                         ),
//                       SizedBox(
//                         height: size.getH(16),
//                       ),
//                       SizedBox(
//                         width: size.width / 3,
//                         child: Card(
//                           color: kTempColor,
//                           shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(10),
//                           ),
//                           child: InkWell(
//                             // onTap: () {},
//                             borderRadius: BorderRadius.circular(10),
//                             child: Padding(
//                               padding: EdgeInsets.symmetric(
//                                   horizontal: size.getW(16.0),
//                                   vertical: size.getH(12)),
//                               child: Row(
//                                 mainAxisAlignment:
//                                     MainAxisAlignment.spaceBetween,
//                                 children: [
//                                   Text(
//                                     LN.total,
//                                     style: TextStyle(
//                                       fontSize: size.getS(16),
//                                       fontFamily: kFontFMedium,
//                                       color: Colors.white,
//                                     ),
//                                   ),
//                                   if (_product != null)
//                                     Builder(builder: (context) {
//                                       double _total = 0.0;

//                                       // if (placeOrderPro.orderList.any((a) =>
//                                       //     _product.id?.toLowerCase() ==
//                                       //         a.productId?.toLowerCase() &&
//                                       //     a.key == widget.uniqueKey)) {
//                                       //   final _oDetail = placeOrderPro.orderList
//                                       //       .firstWhere((b) =>
//                                       //           _product.id?.toLowerCase() ==
//                                       //               b.productId
//                                       //                   ?.toLowerCase() &&
//                                       //           b.key == widget.uniqueKey);
//                                       //   _total += (_oDetail.productPrice ?? 0) *
//                                       //       _product.quantity;
//                                       //   // for (final e in placeOrderPro.orderList) {
//                                       //   // if (_product.id?.toLowerCase() ==
//                                       //   //     e.productId?.toLowerCase()) {
//                                       //   // _total +=
//                                       //   //     (e.productPrice ?? 0) * _product.quantity;
//                                       //   // }
//                                       //   // else if (_product.addOns!.any((f) =>
//                                       //   //     f.id?.toLowerCase() ==
//                                       //   //     e.productId?.toLowerCase())) {
//                                       //   //   if (_product.addOns!.any((c) =>
//                                       //   //       c.id?.toLowerCase() ==
//                                       //   //       e.productId?.toLowerCase())) {
//                                       //   //     final _vIndex = _product.addOns!.indexWhere(
//                                       //   //         (c) =>
//                                       //   //             c.id?.toLowerCase() ==
//                                       //   //             e.productId?.toLowerCase());
//                                       //   //     _total += (e.productPrice ?? 0) *
//                                       //   //         _product.addOns![_vIndex].quantity;
//                                       //   //   }
//                                       //   // }
//                                       //   // }
//                                       // } else {
//                                       _total += double.parse((_promDiscount
//                                                           ?.isOfferStart ??
//                                                       false) &&
//                                                   (_promDiscount?.tsCount.inDouble ??
//                                                           0) <=
//                                                       _product.quantity
//                                               ? (_promDiscount?.discountedPrice ??
//                                                   '0')
//                                               : (((_selectedVariance
//                                                               ?.discountedPrice
//                                                               ?.isNotEmpty ??
//                                                           false) &&
//                                                       ((_selectedVariance
//                                                                       ?.discountedPrice
//                                                                       ?.inDouble ??
//                                                                   0) >
//                                                               0 ||
//                                                           (_selectedVariance
//                                                                       ?.discountPercentage
//                                                                       ?.inDouble ??
//                                                                   0) >=
//                                                               99))
//                                                   ? _selectedVariance!
//                                                       .discountedPrice!
//                                                   : (_itemPrice ?? '0'))) *
//                                           _product.quantity;
//                                       // }

//                                       if (_selectedVariance
//                                               ?.productPriceModifiers !=
//                                           null)
//                                         for (final f in _selectedVariance!
//                                             .productPriceModifiers!) {
//                                           if (f.isActive ?? false)
//                                             _total +=
//                                                 double.parse(f.price ?? '0') *
//                                                     _product.quantity *
//                                                     f.quantity;
//                                         }
//                                       return Text(
//                                         widget.curSym +
//                                             _total.roundToNString(),
//                                         style: TextStyle(
//                                           fontSize: size.getS(17),
//                                           fontFamily: kFontFBold,
//                                           color: Colors.white,
//                                         ),
//                                       );
//                                     })
//                                 ],
//                               ),
//                             ),
//                           ),
//                         ),
//                       )
//                     ],
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       );
//   }
// }

// class SpiceWidget extends StatelessWidget {
//   final String? imgPath;
//   final String name;
//   final String? price;
//   final bool isChecked;
//   final Function(bool?)? onChanged;
//   final Ssize size;
//   const SpiceWidget({
//     Key? key,
//     this.imgPath,
//     required this.name,
//     this.price,
//     required this.isChecked,
//     this.onChanged,
//     required this.size,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Card(
//       shape: RoundedRectangleBorder(
//         side: BorderSide(
//           color: isChecked ? kSecondaryColor : Colors.black26,
//         ),
//         borderRadius: BorderRadius.circular(10),
//       ),
//       child: InkWell(
//         borderRadius: BorderRadius.circular(10),
//         onTap: onChanged != null ? () => onChanged!(!isChecked) : null,
//         child: Padding(
//           padding: EdgeInsets.symmetric(
//               vertical: size.getH(6), horizontal: size.getW(4)),
//           child: Row(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               // if (imgPath != null)
//               ClipRRect(
//                   borderRadius: BorderRadius.circular(100),
//                   child: CachedNetworkImage(
//                       imageUrl: imgPath ?? '',
//                       height: size.getW(48),
//                       width: size.getW(48),
//                       fit: BoxFit.fitHeight,
//                       placeholder: ImageError.load,
//                       errorWidget: ImageError.notSupportIcon)),
//               SizedBox(
//                 width: size.getW(8),
//               ),
//               Expanded(
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     Text(
//                       name,
//                       style: TextStyle(
//                         fontSize: size.getS(15),
//                         color: Colors.black,
//                         fontFamily: kFontFMedium,
//                       ),
//                       maxLines: 2,
//                       overflow: TextOverflow.ellipsis,
//                     ),
//                     if (price != null)
//                       Text(
//                         price!,
//                         style: TextStyle(
//                           fontSize: size.getS(14),
//                           color: Colors.black,
//                         ),
//                       ),
//                   ],
//                 ),
//               ),
//               Checkbox(
//                 value: isChecked,
//                 onChanged: onChanged,
//                 activeColor: kSecondaryColor,
//               )
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
