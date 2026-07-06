import 'dart:math';
import 'package:flutter/material.dart';
import 'package:pos_account/config/size_config.dart';
import 'package:pos_account/config/utils/order_utils.dart';
import 'package:pos_account/config/validator.dart';
import 'package:pos_account/constant/constant.dart';
import 'package:pos_account/ln.dart';
import 'package:pos_account/model/home/menu/place_order/pos_res/com/feature_product.dart';
import 'package:pos_account/providers/menu/place_order_pro.dart';
import 'com/half_half_widget.dart';
import 'half_item_variance.dart';

class HalfItemViewSection extends StatelessWidget {
  final PlaceOrderPro placeOrderPro;
  final FeaturedProduct? product;
  final Function()? addToCart;
  final String? addCartText;
  final Function(HalfItemTypeEnum)? onSelectHalf;
  const HalfItemViewSection({
    super.key,
    required this.placeOrderPro,
    this.product,
    this.addToCart,
    this.addCartText,
    this.onSelectHalf,
  });

  double getHigherItemPrice() {
    final _priceType = OrderUtils.productPriceType(product?.productPriceType);

    final _isQuarter =
        OrderUtils.halfType(product?.productType) == HalfProductType.Quarter;

    if (_priceType == ProductPriceType.FixedPrice) {
      final _price =
          (placeOrderPro.selectedvarHalfnHalf?.discountedPrice?.inDouble ??
                      0) !=
                  0
              ? placeOrderPro.selectedvarHalfnHalf?.discountedPrice?.inDouble
              : placeOrderPro.selectedvarHalfnHalf?.actualPrice?.inDouble;
      return _price ?? 0;
    }

    final _firstPrice =
        (placeOrderPro.firstHalf?.discountedPrice?.inDouble ?? 0) != 0
            ? placeOrderPro.firstHalf?.discountedPrice?.inDouble ?? 0
            : placeOrderPro.firstHalf?.actualPrice?.inDouble ?? 0;

    final _secondPrice =
        (placeOrderPro.secondHalf?.discountedPrice?.inDouble ?? 0) != 0
            ? placeOrderPro.secondHalf?.discountedPrice?.inDouble ?? 0
            : placeOrderPro.secondHalf?.actualPrice?.inDouble ?? 0;

    final _thirdPrice =
        (placeOrderPro.thirdHalf?.discountedPrice?.inDouble ?? 0) != 0
            ? placeOrderPro.thirdHalf?.discountedPrice?.inDouble ?? 0
            : placeOrderPro.thirdHalf?.actualPrice?.inDouble ?? 0;

    final _fourthPrice =
        (placeOrderPro.fourthHalf?.discountedPrice?.inDouble ?? 0) != 0
            ? placeOrderPro.fourthHalf?.discountedPrice?.inDouble ?? 0
            : placeOrderPro.fourthHalf?.actualPrice?.inDouble ?? 0;

    if (_priceType == ProductPriceType.WeightedAveragePrice) {
      if (_isQuarter) {
        return (_firstPrice + _secondPrice + _thirdPrice + _fourthPrice) / 4;
      } else
        return (_firstPrice + _secondPrice) / 2;
    }

    if (_isQuarter) {
      return [_firstPrice, _secondPrice, _thirdPrice, _fourthPrice].reduce(max);
    } else {
      if (_firstPrice >= _secondPrice)
        return _firstPrice;
      else if (_firstPrice <= _secondPrice)
        return _secondPrice;
      else
        return 0;
    }
  }

  double _getModiPrice(ModifierItem? halfItem) {
    double _modiTotal = 0;

    if (halfItem?.modifierItemModifiers! != null) {
      for (final z in halfItem!.modifierItemModifiers!)
        if (z.modifierItems != null)
          for (final a in z.modifierItems!) {
            if (a.isActive ?? false) {
              final _price = a.discountedPrice.inDouble != 0
                  ? a.discountedPrice
                  : a.actualPrice;
              _modiTotal += _price.inDouble * a.quantity;
            }
          }
    }
    return _modiTotal;
  }

  void _customize(BuildContext context, ModifierItem? modiItem) {
    placeOrderPro.currentSelectedModifier = modiItem;
    showDialog(
        context: context,
        barrierDismissible: true,
        builder: (builder) => SimpleDialog(
              titlePadding: EdgeInsets.zero,
              contentPadding: EdgeInsets.zero,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15)),
              children: [HalfItemVariance()],
            ));
  }

  void onTapHalf({
    required HalfItemTypeEnum halfEnum,
    ModifierItem? halfItem,
  }) {
    placeOrderPro.selectedHalfEnum = halfEnum;
    placeOrderPro.currentSelectedModifier = halfItem;
    if (onSelectHalf != null) onSelectHalf!(halfEnum);

    placeOrderPro.varianceLoading = true;
    placeOrderPro.notify;
    Future.delayed(Duration(milliseconds: 100), () {
      placeOrderPro.varianceLoading = false;
      placeOrderPro.notify;
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = Ssize(context);

    final _isQuarter =
        OrderUtils.halfType(product?.productType) == HalfProductType.Quarter;

    final _price = getHigherItemPrice();
    final _firstPrice = _getModiPrice(placeOrderPro.firstHalf);
    final _secondPrice = _getModiPrice(placeOrderPro.secondHalf);

    final _thirdPrice = _getModiPrice(placeOrderPro.thirdHalf);
    final _fourthPrice = _getModiPrice(placeOrderPro.fourthHalf);

    final _totalPrice = _price +
        _firstPrice +
        _secondPrice +
        (_isQuarter ? (_thirdPrice + _fourthPrice) : 0) +
        (placeOrderPro.selectedvarHalfnHalf?.additionalPrice.inDouble ?? 0.0);

    final _itemView = [
      SizedBox(height: size.getH(6)),

      // Pizza halves display
      Expanded(
        child: Center(
          child: AspectRatio(
            aspectRatio: 1,
            child: SizedBox(
              // width: size.getS(250),
              // height: size.getS(250),
              child: _isQuarter
                  ? Column(
                      children: [
                        Expanded(
                          child: Row(
                            children: [
                              HalfnHalfWidget.newQuarterItem(
                                size,
                                placeOrderPro: placeOrderPro,
                                onTapItem: () {
                                  onTapHalf(
                                      halfEnum: HalfItemTypeEnum.first,
                                      halfItem: placeOrderPro.firstHalf);
                                },
                                quarterEnum: HalfItemTypeEnum.first,
                                quarterItem: placeOrderPro.firstHalf,
                                customize: () {
                                  _customize(context, placeOrderPro.firstHalf);
                                },
                              ),
                              SizedBox(width: size.getW(4)),
                              HalfnHalfWidget.newQuarterItem(
                                size,
                                placeOrderPro: placeOrderPro,
                                onTapItem: () {
                                  onTapHalf(
                                      halfEnum: HalfItemTypeEnum.second,
                                      halfItem: placeOrderPro.secondHalf);
                                },
                                quarterEnum: HalfItemTypeEnum.second,
                                quarterItem: placeOrderPro.secondHalf,
                                customize: () {
                                  _customize(context, placeOrderPro.secondHalf);
                                },
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: size.getH(4)),
                        Expanded(
                          child: Row(
                            children: [
                              HalfnHalfWidget.newQuarterItem(
                                size,
                                placeOrderPro: placeOrderPro,
                                onTapItem: () {
                                  onTapHalf(
                                      halfEnum: HalfItemTypeEnum.third,
                                      halfItem: placeOrderPro.thirdHalf);
                                },
                                quarterEnum: HalfItemTypeEnum.third,
                                quarterItem: placeOrderPro.thirdHalf,
                                customize: () {
                                  _customize(context, placeOrderPro.thirdHalf);
                                },
                              ),
                              SizedBox(width: size.getW(4)),
                              HalfnHalfWidget.newQuarterItem(
                                size,
                                placeOrderPro: placeOrderPro,
                                onTapItem: () {
                                  onTapHalf(
                                      halfEnum: HalfItemTypeEnum.fourth,
                                      halfItem: placeOrderPro.fourthHalf);
                                },
                                quarterEnum: HalfItemTypeEnum.fourth,
                                quarterItem: placeOrderPro.fourthHalf,
                                customize: () {
                                  _customize(context, placeOrderPro.fourthHalf);
                                },
                              ),
                            ],
                          ),
                        ),
                      ],
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Left half - Paneer Delight

                        HalfnHalfWidget.newHalfItem(
                          size,
                          placeOrderPro: placeOrderPro,
                          onTapItem: () {
                            onTapHalf(
                                halfEnum: HalfItemTypeEnum.first,
                                halfItem: placeOrderPro.firstHalf);
                          },
                          halfEnum: HalfItemTypeEnum.first,
                          halfItem: placeOrderPro.firstHalf,
                          customize: () {
                            _customize(context, placeOrderPro.firstHalf);
                          },
                        ),
                        SizedBox(width: size.getW(6)),

                        // Right half - Butter Chicken Pizza
                        HalfnHalfWidget.newHalfItem(
                          size,
                          placeOrderPro: placeOrderPro,
                          onTapItem: () {
                            onTapHalf(
                                halfEnum: HalfItemTypeEnum.second,
                                halfItem: placeOrderPro.secondHalf);
                          },
                          halfEnum: HalfItemTypeEnum.second,
                          halfItem: placeOrderPro.secondHalf,
                          customize: () {
                            _customize(context, placeOrderPro.secondHalf);
                          },
                        )
                      ],
                    ),
            ),
          ),
        ),
      ),
      SizedBox(height: size.getH(6))
    ];

    Widget _variationSec(int i) {
      final _isSelected = placeOrderPro.selectedvarHalfnHalf?.id ==
          product!.productVariations![i].id;

      return Padding(
        padding: EdgeInsets.only(right: size.getW(4), left: size.getW(4)),
        child: InkWell(
          borderRadius: BorderRadius.circular(5),
          onTap: () {
            if (placeOrderPro.selectedvarHalfnHalf?.id?.toLowerCase() !=
                product!.productVariations![i].id?.toLowerCase()) {
              placeOrderPro.firstHalf = null;
              placeOrderPro.secondHalf = null;

              placeOrderPro.thirdHalf = null;
              placeOrderPro.fourthHalf = null;
              placeOrderPro.currentSelectedModifier = null;
            }
            product!.productVariations!.forEach((e) => e.isDefault = false);
            product!.productVariations![i].isDefault = true;
            placeOrderPro.selectedvarHalfnHalf = product!.productVariations![i];
            // placeOrderPro.currentSelectedModifier = null;
            placeOrderPro.notify;
          },
          child: Card(
            color: _isSelected ? kSecondaryColor : Colors.white,
            margin: EdgeInsets.zero,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5),
                side: BorderSide(color: kSecondaryColor)),
            child: Padding(
              padding: EdgeInsets.symmetric(
                  vertical: size.getH(6), horizontal: size.getW(20)),
              child: Text(
                product!.productVariations?[i].name ?? '',
                style: TextStyle(
                  fontSize: size.getS(20),
                  fontFamily: kFontFMedium,
                  color: _isSelected ? Colors.white : kSecondaryColor,
                ),
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
        ),
      );
    }

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: size.getS(0)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: size.getH(4)),
          // Back button and title
          // Row(
          //   children: [
          //     Text(
          //       'Half / Half',
          //       style: TextStyle(
          //         fontSize: size.getS(20),
          //         fontWeight: FontWeight.bold,
          //         fontFamily: kFontFRegular,
          //         color: Colors.black,
          //       ),
          //     ),
          //   ],
          // ),
          // SizedBox(height: size.getH(4)),

          // // Size buttons
          // Row(
          //   children: [
          //     _buildSizeButton(size, 'LARGE'),
          //     SizedBox(width: size.getW(16)),
          //     _buildSizeButton(size, 'FAMILY'),
          //   ],
          // ),
          if (product?.productVariations != null &&
              product!.productVariations!.length > 1) ...[
            // Text(
            //   'Select Variations',
            //   style: TextStyle(
            //     fontSize: size.getS(20),
            //     fontWeight: FontWeight.bold,
            //     fontFamily: kFontFRegular,
            //     color: Colors.black,
            //   ),
            // ),
            if (product!.productVariations?.isNotEmpty ?? false) ...[
              if (product!.productVariations!.length < 4)
                Row(
                  children: List.generate(product!.productVariations!.length,
                      (index) => Expanded(child: _variationSec(index))),
                )
              else
                Wrap(
                  children: List.generate(product!.productVariations!.length,
                      (index) => _variationSec(index)),
                )
            ],
          ],
          // else
          //   Text(
          //     'Half / Half',
          //     style: TextStyle(
          //       fontSize: size.getS(20),
          //       fontWeight: FontWeight.bold,
          //       fontFamily: kFontFRegular,
          //       color: Colors.black,
          //     ),
          //   ),
          Expanded(
              child: Column(
            children: _itemView,
          )),
          // Text(
          // _priceType == HalfPriceType.Higher
          //     ? '(Highest price will be choosen)'
          //     : _priceType == HalfPriceType.Fixed
          //         ? '(Fixed price will be choosen)'
          //         : '(Item\'s average price will be choosen)',
          //   style: TextStyle(
          //     fontSize: size.getS(18),
          //     fontFamily: kFontFMedium,
          //     color: kSecondaryColor,
          //   ),
          //   textAlign: TextAlign.center,
          // ),

          // Spacer(),
          if (placeOrderPro.selectedvarHalfnHalf?.additionalPrice?.isNotEmpty ??
              false)
            Center(
              child: Text(
                'Additional Price(${placeOrderPro.curSym}${placeOrderPro.selectedvarHalfnHalf?.additionalPrice ?? '0.00'}) will be added',
                style: TextStyle(
                  fontSize: size.getS(15),
                  fontFamily: kFontFMedium,
                  color: kSecondaryColor,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          SizedBox(
            width: double.infinity,
            height: size.getH(48),
            child: ElevatedButton(
              onPressed: (_isQuarter
                          ? (placeOrderPro.thirdHalf != null &&
                              placeOrderPro.fourthHalf != null)
                          : true) &&
                      placeOrderPro.firstHalf != null &&
                      placeOrderPro.secondHalf != null
                  ? addToCart
                  : () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: (_isQuarter
                            ? (placeOrderPro.thirdHalf != null &&
                                placeOrderPro.fourthHalf != null)
                            : true) &&
                        placeOrderPro.firstHalf != null &&
                        placeOrderPro.secondHalf != null
                    ? kSecondaryColor
                    : Colors.grey,

                // backgroundColor: Colors.black,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(
                (addCartText ?? LN.addToCart) +
                    (_price == 0
                        ? ''
                        : ' - ${placeOrderPro.curSym}${_totalPrice.formatDouble}'),
                style: TextStyle(
                  fontSize: size.getS(16),
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),

          SizedBox(height: size.getH(4)),

          // Spacer(),

          // // Add to Order button
          // SizedBox(
          //   width: double.infinity,
          //   height: size.getH(48),
          //   child: ElevatedButton(
          //     onPressed: (_isQuarter
          //                 ? (placeOrderPro.thirdHalf != null &&
          //                     placeOrderPro.fourthHalf != null)
          //                 : true) &&
          //             placeOrderPro.firstHalf != null &&
          //             placeOrderPro.secondHalf != null
          //         ? addToCart
          //         : () {},
          //     style: ElevatedButton.styleFrom(
          //       primary: (_isQuarter
          //                   ? (placeOrderPro.thirdHalf != null &&
          //                       placeOrderPro.fourthHalf != null)
          //                   : true) &&
          //               placeOrderPro.firstHalf != null &&
          //               placeOrderPro.secondHalf != null
          //           ? kSecondaryColor
          //           : Colors.grey,

          //       // backgroundColor: Colors.black,
          //       shape: RoundedRectangleBorder(
          //         borderRadius: BorderRadius.circular(8),
          //       ),
          //     ),
          //     child: Text(
          //       (addCartText ?? LN.addToCart) +
          //           (_price == 0
          //               ? ''
          //               : ' - ${placeOrderPro.curSym}${_totalPrice.formatDouble}'),
          //       style: TextStyle(
          //         fontSize: size.getS(18),
          //         fontWeight: FontWeight.bold,
          //         color: Colors.white,
          //       ),
          //     ),
          //   ),
          // ),
        ],
      ),
    );
  }
}
