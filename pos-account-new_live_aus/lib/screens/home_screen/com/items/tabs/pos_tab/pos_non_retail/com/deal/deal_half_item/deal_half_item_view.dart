import 'dart:math';
import 'package:flutter/material.dart';
import 'package:pos_account/config/utils/order_utils.dart';
import 'package:pos_account/config/size_config.dart';
import 'package:pos_account/config/validator.dart';
import 'package:pos_account/constant/constant.dart';
import 'package:pos_account/ln.dart';
import 'package:pos_account/model/home/menu/place_order/pos_res/com/feature_product.dart';
import 'package:pos_account/providers/menu/place_order_pro.dart';
import 'package:pos_account/screens/home_screen/com/items/tabs/pos_tab/pos_non_retail/com/half_half_2/com/half_half_widget.dart';

class DealHalfItemView extends StatelessWidget {
  final PlaceOrderPro placeOrderPro;
  final Function()? addToCart;
  final String? addCartText;
  // final Function(HalfItemTypeEnum)? onSelectHalf;
  final ModifierItem? modifierItem;
  const DealHalfItemView({
    super.key,
    required this.placeOrderPro,
    this.addToCart,
    this.addCartText,
    // this.onSelectHalf,
    this.modifierItem,
  });

  double getHigherItemPrice() {
    // final _priceType = OrderUtils.priceType(product?.productPriceType);
    // if (_priceType == HalfPriceType.Fixed) {
    //   final _price =
    //       (placeOrderPro.selectedvarHalfnHalf?.discountedPrice?.inDouble ??
    //                   0) !=
    //               0
    //           ? placeOrderPro.selectedvarHalfnHalf?.discountedPrice?.inDouble
    //           : placeOrderPro.selectedvarHalfnHalf?.actualPrice?.inDouble;
    //   return _price ?? 0;
    // }

    final _isQuarter = OrderUtils.halfType(modifierItem?.productType) ==
        HalfProductType.Quarter;

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

    // if (_priceType == HalfPriceType.Average) {
    //   return (_firstPrice + _secondPrice) / 2;
    // }

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
    // placeOrderPro.currentSelectedModifier = modiItem;
    // showDialog(
    //     context: context,
    //     barrierDismissible: true,
    //     builder: (builder) => SimpleDialog(
    //           titlePadding: EdgeInsets.zero,
    //           contentPadding: EdgeInsets.zero,
    //           shape: RoundedRectangleBorder(
    //               borderRadius: BorderRadius.circular(15)),
    //           children: [HalfItemVariance()],
    //         ));
  }

  void onTapHalf({
    required HalfItemTypeEnum halfEnum,
    ModifierItem? halfItem,
  }) {
    placeOrderPro.selectedHalfEnum = halfEnum;
    placeOrderPro.currentSelectedModifier = halfItem;
    // if (onSelectHalf != null) onSelectHalf!(halfEnum);

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
    final _isQuarter = OrderUtils.halfType(modifierItem?.productType) ==
        HalfProductType.Quarter;

    final _price = getHigherItemPrice();
    final _firstPrice = _getModiPrice(placeOrderPro.firstHalf);
    final _secondPrice = _getModiPrice(placeOrderPro.secondHalf);

    final _thirdPrice = _getModiPrice(placeOrderPro.thirdHalf);
    final _fourthPrice = _getModiPrice(placeOrderPro.fourthHalf);

    final _totalPrice = _price +
        _firstPrice +
        _secondPrice +
        (_isQuarter ? (_thirdPrice + _fourthPrice) : 0);

    //  +
    // (placeOrderPro.selectedvarHalfnHalf?.additionalPrice.inDouble ?? 0.0);

    // final _priceType = OrderUtils.priceType(product?.productPriceType);

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

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: size.getS(12)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: size.getH(4)),
          Expanded(
              child: Column(
            children: _itemView,
          )),

          SizedBox(height: size.getH(6)),

          // Spacer(),

          // // Add to Order button
          SizedBox(
            width: double.infinity,
            height: size.getH(48),
            child: ElevatedButton(
              onPressed: placeOrderPro.firstHalf != null &&
                      placeOrderPro.secondHalf != null
                  ? () {
                      modifierItem?.halfItemPrice = _price;
                      if (addToCart != null) addToCart!();
                    }
                  : () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: placeOrderPro.firstHalf != null &&
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
                  fontSize: size.getS(18),
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
