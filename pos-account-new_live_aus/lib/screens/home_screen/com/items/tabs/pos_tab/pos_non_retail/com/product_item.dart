import 'dart:math';

import 'package:flutter/material.dart';
import 'package:pos_account/config/size_config.dart';
import 'package:pos_account/config/utils/order_utils.dart';
import 'package:pos_account/config/validator.dart';
import 'package:pos_account/ln.dart';
import 'package:pos_account/model/home/menu/place_order/pos_res/com/feature_product.dart';
import 'package:pos_account/providers/cus_val_pro.dart';
import 'package:pos_account/providers/menu/place_order_pro.dart';
import 'package:pos_account/widgets/no_items_sec.dart';
import 'item_tile.dart';

class ProductItem extends StatelessWidget {
  final Function(String?)? onTap;
  // final Function(int, {String? price})? onAdd;
  // final List<String> addedId;
  final String? curSym;
  final PlaceOrderPro placeOrderPro;
  final List<FeaturedProduct> itemViewList;
  // final bool hideAddBtn;
  const ProductItem({
    super.key,
    this.onTap,
    // this.onAdd,
    // this.addedId = const [],
    this.curSym,
    required this.placeOrderPro,
    required this.itemViewList,
    // this.hideAddBtn = false,
  });

  @override
  Widget build(BuildContext context) {
    final size = Ssize(context);
    final _itemsOnly = itemViewList
        .where((a) => OrderUtils.prodType(a.productType) != ProductType.Combo)
        .toList();
    final _comboOnly = itemViewList
        .where((a) => OrderUtils.prodType(a.productType) == ProductType.Combo)
        .toList();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (itemViewList.isNotEmpty) ...[
          //   GridView.builder(
          //     gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          //       mainAxisExtent:
          //           size.getH(Responsive.isDesktop(context) ? 220 : 220),
          //       crossAxisSpacing: size.getW(0),
          //       mainAxisSpacing: size.getH(0),
          //       crossAxisCount: size.isProt ? 3 : 4,
          //     ),
          //     shrinkWrap: true,
          //     physics: NeverScrollableScrollPhysics(),
          //     itemCount: itemViewList.length,
          //     itemBuilder: (context, i2) {
          //       final _prod = itemViewList[i2];

          //       final _pV = _prod.productVariations?.isNotEmpty ?? false
          //           ? _prod.productVariations!.firstWhere(
          //               (e) => e.isDefault != null && e.isDefault!,
          //               orElse: () => _prod.productVariations!.first,
          //             )
          //           : null;

          //       final _stock =
          //           _pV?.stockCount != null && _pV!.stockCount!.isNotEmpty
          //               ? double.tryParse(_pV.stockCount ?? '')
          //               : null;

          //       final _totalQuantity = placeOrderPro.orderList
          //               .any((b) => b.productId == _prod.id)
          //           ? placeOrderPro.orderList
          //               .where((b) => b.productId == _prod.id)
          //               .fold<double>(0, (x, y) => x + (y.quantity ?? 0))
          //           : 0;
          //       final bool _outOfStock = !GlobalCVP.isHospitality &&
          //           _stock != null &&
          //           _stock <= _totalQuantity;

          //       // final _promDiscount =
          //       //     Utils.getPromDiscount(_pV.discountedPromotions);
          //       bool _isMultiBatch = false;

          //       if (placeOrderPro
          //               .initAddSec?.storeStockDeductInformation?.isBatch ??
          //           false) {
          //         if ((_prod.productVariations?.isNotEmpty ?? false) &&
          //             (_prod.productVariations?.first
          //                     .productVariationBatchStocks?.isNotEmpty ??
          //                 false)) {
          //           _isMultiBatch = _prod.productVariations!.first
          //                   .productVariationBatchStocks!.length >
          //               1;
          //         }
          //       }

          //       // if (_prod.promoModel != null) {
          //       //   if (_prod.promoModel?.discountAmount != null) {
          //       //     final _disPer = PromoUtils.getPromoDisPercent(
          //       //       disValue: _prod.promoModel?.discountAmount,
          //       //       price: _pV?.actualPrice,
          //       //     );
          //       //     _prod.promoModel?.discountPercent = _disPer;
          //       //   } else if (_prod.promoModel?.discountPercent != null) {
          //       //     final _disAmount = PromoUtils.getPromoDisAmount(
          //       //       disPercent: _prod.promoModel?.discountPercent,
          //       //       price: _pV?.actualPrice,
          //       //     );
          //       //     _prod.promoModel?.discountAmount = _disAmount;
          //       //   }
          //       // }

          //       // final _varCount = _prod.productVariations?.length ?? 0;

          //       // print(
          //       //     "${_prod.name} | actualPrice ${_pV?.actualPrice} | discount: ${_pV?.discount} | discountPercentage : ${_pV?.discountPercentage} | discountedPrice ${_pV?.discountedPrice}");

          //       return Padding(
          //         padding: EdgeInsets.only(
          //             right: size.getW(0), bottom: size.getH(4)),
          //         child: SizedBox(
          //           height: size.getH(300),
          //           width: size.getW(192),
          //           child: ItemTile(
          //             onTap: onTap != null ? () => onTap!(i2) : null,
          //             // message: _varCount == 0
          //             //     ? null
          //             //     : "$_varCount option${_varCount == 1 ? '' : 's'} available",
          //             // hideAddBtn:
          //             //     Utils.prodType(_prod.productType) != ProductType.Item,
          //             imgPath: _prod.imageUrl,
          //             name: _prod.name ?? '',
          //             // vName: (_pV.name == null || _pV.name!.trim().isEmpty)
          //             //     ? ""
          //             //     : " (${_pV.name})",
          //             outOfStockMessage:
          //                 _outOfStock ? _pV?.outOfStockMessage : null,
          //             price: OrderUtils.priceType(_prod.productPriceType) ==
          //                     HalfPriceType.Fixed
          //                 ? _pV?.actualPrice
          //                 : null,
          //             curSym: curSym,
          //             discountedPrice:
          //                 // _prod.promoModel != null ? _prod.promoModel?.discountAmount :
          //                 _pV?.discountedPrice,
          //             disPercent:
          //                 // _prod.promoModel != null ? _prod.promoModel?.discountPercent  :
          //                 _pV?.discountPercentage,
          //             // promDiscount: _promDiscount,
          //             size: size,
          //             // onAdd: onAdd != null
          //             //     ? () => onAdd!(i2,
          //             //         price: (_promDiscount?.isOfferStart ?? false)
          //             //             ? _promDiscount?.discountedPrice
          //             //             : (_pV.discountedPrice?.inDouble != null &&
          //             //                     (_pV.discountedPrice.inDouble > 0 ||
          //             //                         _pV.discountPercentage.inDouble >=
          //             //                             99))
          //             //                 ? _pV.discountedPrice.toString()
          //             //                 : _pV.actualPrice.toString())
          //             //     : null,
          //             addText: ((_prod.variationCount?.inDouble != null &&
          //                         _prod.variationCount!.inDouble > 1) ||
          //                     GlobalCVP.isServiceStore)
          //                 ? LN.select
          //                 : _isMultiBatch
          //                     ? LN.select
          //                     : LN.add,
          //             refresh: () {
          //               placeOrderPro.notify;
          //             },
          //             hasPromo:
          //                 _prod.promoModel?.discountPercent?.isNotEmpty ??
          //                     false,
          //           ),
          //         ),
          //       );
          //     },
          //   )
          // else
          _datalist(size, _comboOnly, crossAxis: 3, isItem: false),
          _datalist(size, _itemsOnly)
        ] else if (!placeOrderPro.loading)
          NoItemsSec(size: size, title: LN.noProducts),
        SizedBox(
          height: size.getH(16),
        )
      ],
    );
  }

  Widget _datalist(
    Ssize size,
    List<FeaturedProduct> itemList, {
    int crossAxis = 4,
    bool isItem = true,
  }) {
    return FourPerRowWrap(
      crossAxisCount: crossAxis,
      children: List.generate(
        itemList.length,
        (i2) {
          final _prod = itemList[i2];

          // kPrint(
          //     "${_prod.name} ${_prod.productVariations?.first.promoModel?.name} ${_prod.productVariations?.first.promoModel?.discountAmount} ${_prod.productVariations?.first.promoModel?.discountPercent}");

          final _pV = _prod.productVariations?.isNotEmpty ?? false
              ? _prod.productVariations!.firstWhere(
                  (e) =>
                      (e.discountPercentage?.inDouble ?? 0) > 0 ||
                      (e.isDefault ?? false),
                  orElse: () => _prod.productVariations!.first,
                )
              : null;

          final _maxDiscountPercentInDouble =
              (_prod.productVariations?.isNotEmpty ?? false)
                  ? (_prod.productVariations
                          ?.map((a) => a.discountPercentage?.inDouble ?? 0)
                          .toList()
                          .reduce(max) ??
                      0)
                  : 0;
          final _allDiscountSame = _prod.productVariations?.every(
                  (a) => a.discountPercentage == _pV?.discountPercentage) ??
              false;

          final _maxDiscountPercentInString = _maxDiscountPercentInDouble > 0
              ? _maxDiscountPercentInDouble.toString()
              : _pV?.discountPercentage;

          final _stock = _pV?.stockCount != null && _pV!.stockCount!.isNotEmpty
              ? double.tryParse(_pV.stockCount ?? '')
              : null;

          final _totalQuantity =
              placeOrderPro.orderList.any((b) => b.productId == _prod.id)
                  ? placeOrderPro.orderList
                      .where((b) => b.productId == _prod.id)
                      .fold<double>(0, (x, y) => x + (y.quantity ?? 0))
                  : 0;
          final bool _outOfStock = GlobalCVP.stockExceedRestriction &&
              !GlobalCVP.isHospitality &&
              _stock != null &&
              _stock <= _totalQuantity;

          // final _promDiscount =
          //     Utils.getPromDiscount(_pV.discountedPromotions);
          bool _isMultiBatch = false;

          if (placeOrderPro.initAddSec?.storeInformation?.isBatch ?? false) {
            if ((_prod.productVariations?.isNotEmpty ?? false) &&
                (_prod.productVariations?.first.productVariationBatchStocks
                        ?.isNotEmpty ??
                    false)) {
              _isMultiBatch = _prod.productVariations!.first
                      .productVariationBatchStocks!.length >
                  1;
            }
          }

          // if (_prod.promoModel != null) {
          //   if (_prod.promoModel?.discountAmount != null) {
          //     final _disPer = PromoUtils.getPromoDisPercent(
          //       disValue: _prod.promoModel?.discountAmount,
          //       price: _pV?.actualPrice,
          //     );
          //     _prod.promoModel?.discountPercent = _disPer;
          //   } else if (_prod.promoModel?.discountPercent != null) {
          //     final _disAmount = PromoUtils.getPromoDisAmount(
          //       disPercent: _prod.promoModel?.discountPercent,
          //       price: _pV?.actualPrice,
          //     );
          //     _prod.promoModel?.discountAmount = _disAmount;
          //   }
          // }

          // final _varCount = _prod.productVariations?.length ?? 0;

          // print(
          //     "${_prod.name} | actualPrice ${_pV?.actualPrice} | discount: ${_pV?.discount} | discountPercentage : ${_pV?.discountPercentage} | discountedPrice ${_pV?.discountedPrice}");

          return SizedBox(
            height: size.getH(isItem ? 220 : 250),
            child: ItemTile(
              onTap: onTap != null ? () => onTap!(_prod.id) : null,
              // hideAddBtn: hideAddBtn,
              imgPath: _prod.imageUrl,
              name: _prod.name ?? '',
              // vName: (_pV.name == null || _pV.name!.trim().isEmpty)
              //     ? ""
              //     : " (${_pV.name})",
              outOfStockMessage: _outOfStock ? _pV?.outOfStockMessage : null,
              price: OrderUtils.productPriceType(_prod.productPriceType) ==
                      ProductPriceType.FixedPrice
                  ? _pV?.actualPrice
                  : null,
              curSym: curSym,
              discountedPrice: _pV?.discountedPrice,
              disPercent: _maxDiscountPercentInString,
              // _pV?.discountPercentage,
              // promDiscount: _promDiscount,

              //  () {
              //   double _price = 0.0;
              //   if (_pV.discountedPrice?.inDouble != null)
              //     _price = _pV.discountedPrice!.inDouble;
              //   else
              //     _price = _pV.actualPrice.inDouble;

              //   return (curSym ?? '') +
              //       "${_price.roundToNString()}${hideAddBtn ? '' : _vName}";
              // },
              size: size,
              // onAdd: onAdd != null
              //     ? () => onAdd!(i2,
              //         price: (_promDiscount?.isOfferStart ?? false)
              //             ? _promDiscount?.discountedPrice
              //             : (_pV.discountedPrice?.inDouble !=
              //                         null &&
              //                     (_pV.discountedPrice.inDouble >
              //                             0 ||
              //                         _pV.discountPercentage
              //                                 .inDouble >=
              //                             99))
              //                 ? _pV.discountedPrice.toString()
              //                 : _pV.actualPrice.toString())
              //     : null,
              addText: ((_prod.variationCount?.inDouble != null &&
                          _prod.variationCount!.inDouble > 1) ||
                      GlobalCVP.isServiceStore)
                  ? LN.select
                  : _isMultiBatch
                      ? LN.select
                      : LN.add,
              refresh: () {
                placeOrderPro.notify;
              },
              hasPromo: _prod.productVariations?.length != 1 &&
                  !_allDiscountSame, // && (_pV?.promoModel?.discountPercent?.isNotEmpty ?? false),
              message: isItem ? null : _prod.productDescription,
            ),
          );
        },
      ),
    );
  }
}

class FourPerRowWrap extends StatelessWidget {
  final List<Widget> children;
  final int crossAxisCount;

  const FourPerRowWrap({
    super.key,
    required this.children,
    this.crossAxisCount = 4,
  });

  @override
  Widget build(BuildContext context) {
    const spacing = 4.0;
    final totalSpacing = (crossAxisCount - 1) * spacing;

    return LayoutBuilder(
      builder: (context, constraints) {
        final totalWidth = constraints.maxWidth;

        final itemWidth = (totalWidth - totalSpacing) / crossAxisCount;
        return Wrap(
          spacing: spacing,
          runSpacing: spacing,
          children: children.map((item) {
            return SizedBox(
              width: itemWidth,
              child: item,
            );
          }).toList(),
        );
      },
    );
  }
}
