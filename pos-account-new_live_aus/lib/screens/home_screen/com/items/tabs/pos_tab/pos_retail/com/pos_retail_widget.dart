import 'package:flutter/material.dart';
import 'package:pos_account/constant/constant.dart';
import 'package:pos_account/model/home/menu/place_order/pos_res/com/feature_product.dart';
import 'package:pos_account/providers/menu/place_order_pro.dart';
import '../../product_detail_dia.dart';

class PosRetailWidget {
  // static Widget posActionWidget({
  //   PlaceOrderPro? placeOrderPro,
  //   required ProductData e,
  //   PosRetailPro? posRetailPro,
  // }) {
  //   return Builder(builder: (context) {
  //     return Row(
  //       children: [
  //         _actionButton(
  //             title: LN.addToCart,
  //             onTap: () async {
  //               try {
  //                 // if (placeOrderPro == null ||
  //                 //     e.productDetails?.productVariations == null ||
  //                 //     e.productDetails!.productVariations!.isEmpty) {
  //                 //   showToast(LN.noProductAvai);
  //                 //   return;
  //                 // }

  //                 // final _prodVariations =
  //                 //     e.productDetails!.productVariations!.firstWhere(
  //                 //   (e) => e.isDefault != null && e.isDefault!,
  //                 //   orElse: () => e.productDetails!.productVariations!.first,
  //                 // );
  //                 if (placeOrderPro == null) return;

  //                 final _stock = double.tryParse(e.stockCount ?? '');

  //                 final _totalQuantity = placeOrderPro.orderList.any((b) {
  //                   return b.productId == e.productId;
  //                 })
  //                     ? placeOrderPro.orderList
  //                         .where((b) => b.productId == e.id)
  //                         .fold<double>(0, (x, y) => x + (y.quantity ?? 0))
  //                     : 0;

  //                 final bool _outOfStock =
  //                     _stock != null && _stock <= _totalQuantity;
  //                 if (_outOfStock) {
  //                   showToast(LN.productOutOfStock);
  //                 } else {
  //                   if (posRetailPro?.retailPosOrderRes
  //                           ?.storeStockDeductInformation?.isBatch ??
  //                       false) {
  //                     await posRetailPro?.getProductDetail(varId: e.id);

  //                     if ((posRetailPro?.retailProductDetail?.productVariations
  //                                 ?.isNotEmpty ??
  //                             false) &&
  //                         (posRetailPro
  //                                 ?.retailProductDetail
  //                                 ?.productVariations
  //                                 ?.first
  //                                 .productVariationBatchStocks
  //                                 ?.isNotEmpty ??
  //                             false)) {
  //                       final _batchCount = posRetailPro!
  //                           .retailProductDetail!
  //                           .productVariations!
  //                           .first
  //                           .productVariationBatchStocks!
  //                           .length;

  //                       if (_batchCount > 1) {
  //                         selectVarience(
  //                           context,
  //                           catTypeId: posRetailPro
  //                               .retailProductDetail?.categoryTypeId,
  //                           featuredProduct: posRetailPro.retailProductDetail!,
  //                           curSym: placeOrderPro.curSym ?? '',
  //                         );
  //                         return;
  //                       } else {
  //                         e.productDetails?.productVariations = posRetailPro
  //                             .retailProductDetail!.productVariations!;

  //                         if (e.productDetails?.productVariations?.isNotEmpty ??
  //                             false) {
  //                           e
  //                               .productDetails
  //                               ?.productVariations
  //                               ?.first
  //                               .productVariationBatchStocks
  //                               ?.first
  //                               .isActive = true;

  //                           if (Utils.outOfBatchStock(
  //                               selectedVariance: e.productDetails
  //                                   ?.productVariations?.first)) {
  //                             return;
  //                           }
  //                         }
  //                       }
  //                     }
  //                   }

  //                   placeOrderPro.updateOrderCart(
  //                     product: FeaturedProduct(
  //                       id: e.productId,
  //                       imageUrl: e.productImage,
  //                       name: e.productName,
  //                       productTax: e.salesTaxValue,
  //                       categoryTypeId: e.categoryTypeId,
  //                       // categoryId:"",
  //                     ),
  //                     variation: ProductVariation(
  //                       id: e.id,
  //                       isDefault: true,
  //                       // price: e.price,
  //                       name: e.productVariationName,
  //                       actualPrice: e.actualPrice,
  //                       unitPrice: e.actualPrice,
  //                       discount: e.discount,
  //                       stockCount: e.stockCount,
  //                       // productVariationBatchStocks:
  //                       //     (e.productDetails?.productVariations?.isNotEmpty ??
  //                       //             false)
  //                       //         ? e.productDetails?.productVariations?.first
  //                       //             .productVariationBatchStocks
  //                       //         : null,
  //                     ),
  //                   );
  //                   // MsgDia.show(
  //                   //   CUS_CTX,
  //                   //   headerAnimation: false,
  //                   //   diaType: DiaType.success,
  //                   //   title: LN.addCartSuccess,
  //                   //   autoHideSecond: 2,
  //                   // );
  //                 }
  //               } catch (e) {
  //                 log("Error: $e");
  //                 showToast(LN.somethingWentWrong);
  //               }
  //             }),
  //         // IconButton(
  //         //     onPressed: () {
  //         //       if (e.barCodeImage != null && e.barCodeImage!.isNotEmpty) {
  //         //         showDialog(
  //         //             context: context,
  //         //             builder: (ctx) {
  //         //               return SimpleDialog(
  //         //                 children: [
  //         //                   SizedBox(
  //         //                     width: 600,
  //         //                     height: 400,
  //         //                     child:
  //         //                         CachedNetworkImage(imageUrl: e.barCodeImage!),
  //         //                   )
  //         //                 ],
  //         //               );
  //         //             });
  //         //       } else {
  //         //         showToast(LN.noBarcodeAvai);
  //         //       }
  //         //     },
  //         //     icon: Icon(
  //         //       Icons.info_outline,
  //         //       color: Colors.black54,
  //         //     ))
  //       ],
  //     );
  //   });
  // }

  // static Widget addProductActionWidget({
  //   required ProductData e,
  // }) {
  //   return Builder(builder: (context) {
  //     return Row(
  //       children: [
  //         _actionButton(
  //           title: LN.generate,
  //           onTap: () => _showDia(
  //             context,
  //             action: BarcodeAction.Generate,
  //             e: e,
  //           ),
  //           color: kPrimaryColor,
  //         ),
  //         SizedBox(
  //           width: 12,
  //         ),
  //         _actionButton(
  //           title: LN.print,
  //           onTap: () => _showDia(
  //             context,
  //             action: BarcodeAction.Print,
  //             e: e,
  //           ),
  //           color: kSecondaryColor,
  //         ),
  //       ],
  //     );
  //   });
  // }

  // static void _showDia(
  //   BuildContext context, {
  //   required BarcodeAction action,
  //   required ProductData e,
  // }) {
  //   showDialog(
  //       context: context,
  //       builder: (ctx) => SimpleDialog(
  //             backgroundColor: kBackgroundColor,
  //             titlePadding: EdgeInsets.zero,
  //             contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 0),
  //             shape: RoundedRectangleBorder(
  //                 borderRadius: BorderRadius.circular(15)),
  //             children: [
  //               BarcodeActionDia(
  //                 barcodeAction: action,
  //                 variationId: e.id ?? '',
  //               )
  //             ],
  //           ));
  // }

  // static Widget _actionButton(
  //     {required String title, Function()? onTap, Color color = Colors.red}) {
  //   return Container(
  //       decoration: BoxDecoration(
  //           borderRadius: BorderRadius.circular(5),
  //           border: Border.all(color: color)),
  //       child: InkWell(
  //         onTap: onTap,
  //         borderRadius: BorderRadius.circular(5),
  //         splashColor: kSecondaryColor.withOpacity(0.3),
  //         highlightColor: kSecondaryColor.withOpacity(0.15),
  //         child: Padding(
  //           padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
  //           child: Text(
  //             title,
  //             style: TextStyle(
  //               fontSize: 12,
  //               fontFamily: kFontFRegular,
  //               color: color,
  //             ),
  //           ),
  //         ),
  //       ));
  // }

  static selectVarience(
    BuildContext context, {
    // String? catTypeId,
    FeaturedProduct? featuredProduct,
    required String curSym,
    PlaceOrderPro? placeOrderPro,
  }) {
    placeOrderPro?.productDetailView = null;

    placeOrderPro?.getProductData(
      featuredProduct?.id,
      featuredProduct: featuredProduct,
      isPosTab: true,
    );

    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (builder) => SimpleDialog(
              backgroundColor: kSecondaryColor,
              titlePadding: EdgeInsets.zero,
              contentPadding: EdgeInsets.zero,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15)),
              children: [
                ProductDetailDia(
                  product: featuredProduct,
                  // catTypeId: catTypeId,
                  curSym: curSym,
                  quantity: 1,
                  isPosTab: true,
                ),
              ],
            ));
  }
}
