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

          final bool hasMultipleVariations = (_prod.variationCount?.inDouble ?? 0) > 1;

          return SizedBox(
            height: size.getH(isItem ? 220 : 250),
            child: ItemTile(
              onTap: onTap != null ? () => onTap!(_prod.id) : null,
              // hideAddBtn: hideAddBtn,
              imgPath: _prod.imageUrl,
              name: _prod.name ?? '',
              outOfStockMessage: _outOfStock ? _pV?.outOfStockMessage : null,
              price: OrderUtils.productPriceType(_prod.productPriceType) ==
                      ProductPriceType.FixedPrice
                  ? _pV?.actualPrice
                  : null,
              curSym: curSym,
              discountedPrice: _pV?.discountedPrice,
              disPercent: _maxDiscountPercentInString,
              // _pV?.discountPercentage,
              size: size,
              addText: (hasMultipleVariations ||
                      GlobalCVP.isServiceStore ||
                      _isMultiBatch)
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
