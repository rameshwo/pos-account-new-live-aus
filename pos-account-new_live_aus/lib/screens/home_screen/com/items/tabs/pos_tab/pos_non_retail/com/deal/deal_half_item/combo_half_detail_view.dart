import 'package:flutter/material.dart';
import 'package:pos_account/config/utils/order_utils.dart';
import 'package:pos_account/config/size_config.dart';
import 'package:pos_account/constant/constant.dart';
import 'package:pos_account/ln.dart';
import 'package:pos_account/providers/menu/place_order_pro.dart';
import 'package:pos_account/screens/home_screen/com/items/tabs/pos_tab/pos_non_retail/com/half_half_2/com/half_half_widget.dart';
import '../../../../../../../../../../model/home/menu/place_order/pos_res/com/feature_product.dart';
import 'deal_half_dia.dart';

class ComboHalfModifierDetailView extends StatelessWidget {
  final ModifierItem? currentModifier;
  final PlaceOrderPro placeOrderPro;
  final Function(HalfItemTypeEnum)? onSelectHalf;
  const ComboHalfModifierDetailView(
      {super.key,
      this.currentModifier,
      required this.placeOrderPro,
      this.onSelectHalf});

  void onTapHalf({
    required HalfItemTypeEnum halfEnum,
    ModifierItem? halfItem,
  }) async {
    // placeOrderPro.setHalfProdByVarIdForDeal(currentModifier);

    placeOrderPro.firstHalf =
        OrderUtils.getActiveModifierItem(currentModifier, 'first');

    placeOrderPro.secondHalf =
        OrderUtils.getActiveModifierItem(currentModifier, 'second');

    placeOrderPro.selectedHalfEnum = halfEnum;
    placeOrderPro.currentSelectedModifier = halfItem;

    // log(json.encode(currentModifier?.toJson()));

    final _mItemStatus = await showDialog(
        context: CUS_CTX!,
        barrierDismissible: true,
        builder: (builder) => SimpleDialog(
              titlePadding: EdgeInsets.zero,
              contentPadding: EdgeInsets.zero,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15)),
              children: [
                DealHalfDia(
                  modifierItem: currentModifier,
                )
              ],
            ));

    if (_mItemStatus != null && _mItemStatus is ModifierItem) {
      //  currentModifier = _mItemStatus..isActive = true;
      // log(json.encode(_mItemStatus.toJson()));
    }

    // placeOrderPro.selectedHalfEnum = halfEnum;
    placeOrderPro.currentSelectedModifier = currentModifier;
    // if (onSelectHalf != null) onSelectHalf!(halfEnum);

    // placeOrderPro.varianceLoading = true;
    placeOrderPro.notify;
    // Future.delayed(Duration(milliseconds: 100), () {
    //   placeOrderPro.varianceLoading = false;
    //   placeOrderPro.notify;
    // });
  }

  @override
  Widget build(BuildContext context) {
    final size = Ssize(context);
    final _isQuarter = OrderUtils.halfType(currentModifier?.productType) ==
        HalfProductType.Quarter;

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
                                  // _customize(context, placeOrderPro.firstHalf);
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
                                  // _customize(context, placeOrderPro.secondHalf);
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
                                  // _customize(context, placeOrderPro.thirdHalf);
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
                                  // _customize(context, placeOrderPro.fourthHalf);
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
                            // _customize(context, placeOrderPro.firstHalf);
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
                            // _customize(context, placeOrderPro.secondHalf);
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
          Text(
            (currentModifier?.productName ?? '') +
                ((currentModifier?.variationName?.trim().isNotEmpty ?? false)
                    ? ' (${currentModifier?.variationName})'
                    : ''),
            // 'Half / Half',
            style: TextStyle(
              fontSize: size.getS(16),
              fontWeight: FontWeight.bold,
              fontFamily: kFontFRegular,
              color: Colors.black,
            ),
          ),
          ..._itemView,
          // Expanded(
          //     child: Column(
          //   children: _itemView,
          // )),
          // SizedBox(
          //   height: size.getW(100),
          //   child: Row(
          //     mainAxisAlignment: MainAxisAlignment.center,
          //     children: [
          //       // Left half - Paneer Delight
          //       _halfItemSec(
          //         size,
          //         halfEnum: HalfItemTypeEnum.first,
          //         halfItem: OrderUtils.getActiveModifierItem(
          //             currentModifier, 'first'),
          //       ),
          //       // SizedBox(width: size.getW(12)),

          //       // Right half - Butter Chicken Pizza
          //       _halfItemSec(size,
          //           halfEnum: HalfItemTypeEnum.second,
          //           halfItem: OrderUtils.getActiveModifierItem(
          //               currentModifier, 'second')),
          //     ],
          //   ),
          // ),
          SizedBox(height: size.getH(6)),
        ],
      ),
    );
  }

  // Widget _halfItemSec(
  //   Ssize size, {
  //   required HalfItemTypeEnum halfEnum,
  //   ModifierItem? halfItem,
  // }) {
  //   return Expanded(
  //     child: Padding(
  //       padding: EdgeInsets.only(top: size.getH(16), right: size.getW(16)),
  //       child: Container(
  //         decoration: BoxDecoration(
  //           border: Border.all(
  //             color: kSecondaryColor,
  //             width: 4,
  //           ),
  //           borderRadius: BorderRadius.circular(10),
  //         ),

  //         // width: size.getW(150),
  //         child: Stack(
  //           children: [
  //             ClipRRect(
  //                 borderRadius: BorderRadius.circular(100),
  //                 child: CachedNetworkImage(
  //                     imageUrl: halfItem?.imageUrl ?? '',
  //                     height: size.getW(200),
  //                     width: size.getW(200),
  //                     fit: BoxFit.cover,
  //                     placeholder: ImageError.load,
  //                     errorWidget: (ctx, _, __) => Container())),
  //             Container(
  //               width: size.getS(200),
  //               height: size.getS(200),
  //               decoration: BoxDecoration(
  //                 gradient: LinearGradient(
  //                   begin: Alignment.topCenter,
  //                   end: Alignment.bottomCenter,
  //                   colors: [
  //                     Colors.black.withOpacity(0.1),
  //                     Colors.black.withOpacity(0.5),
  //                   ],
  //                 ),
  //               ),
  //               child: Center(
  //                 child: Column(
  //                   mainAxisAlignment: MainAxisAlignment.center,
  //                   children: [
  //                     Text(
  //                       halfItem == null
  //                           ? "${halfEnum == HalfItemTypeEnum.first ? 'First' : 'Second'} Half"
  //                           : '${halfItem.productName ?? ''} (${halfItem.variationName ?? ''})',
  //                       style: TextStyle(
  //                         color:
  //                             // placeOrderPro.selectedHalfEnum == halfEnum
  //                             //     ?
  //                             Colors.white,
  //                         // : Colors.black,
  //                         fontSize: size.getS(18),
  //                         fontWeight: FontWeight.bold,
  //                         fontFamily: kFontFMedium,
  //                       ),
  //                       textAlign: TextAlign.center,
  //                     ),
  //                   ],
  //                 ),
  //               ),
  //             ),
  //           ],
  //         ),
  //       ),
  //     ),
  //   );
  // }
}
