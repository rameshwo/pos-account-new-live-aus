import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:pos_account/config/utils/order_utils.dart';
import 'package:pos_account/config/size_config.dart';
import 'package:pos_account/config/validator.dart';
import 'package:pos_account/constant/constant.dart';
import 'package:pos_account/model/home/menu/place_order/pos_res/com/feature_product.dart';
import 'package:pos_account/providers/menu/place_order_pro.dart';
import 'package:pos_account/screens/home_screen/com/items/tabs/pos_tab/pos_non_retail/com/half_half_2/com/new_modi_sec.dart';
import 'package:pos_account/screens/home_screen/com/items/tabs/pos_tab/pos_non_retail/com/half_half_2/com/new_raw_ingre_sec.dart';
import 'package:pos_account/widgets/image/image_error.dart';
import 'package:pos_account/widgets/loading.dart';
import 'package:pos_account/widgets/no_items_sec.dart';

import '../../half_half_2/com/new_spice_sec.dart';

class DealItemDetailSec extends StatelessWidget {
  final PlaceOrderPro placeOrderPro;
  final ProductVariationModifier? selectedVarModi;
  const DealItemDetailSec({
    super.key,
    required this.placeOrderPro,
    this.selectedVarModi,
  });

  void _showVarDia(
    BuildContext context, {
    required PlaceOrderPro placeOrderPro,
    required ProductVariationModifier modiData,
  }) {
    final _modiType = OrderUtils.getModifierType(modiData.type);
    showDialog(
        context: context,
        barrierDismissible: true,
        builder: (builder) => SimpleDialog(
              titlePadding: EdgeInsets.zero,
              contentPadding: EdgeInsets.zero,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15)),
              children: [
                if (_modiType == ModifierType.modifier)
                  NewModiSec(
                    curSym: placeOrderPro.curSym,
                    title: modiData.name ?? '',
                    modifierItems: modiData.modifierItems,
                    maxThresholdQuantity: modiData.maxThresholdQuantity,
                    selectionType: modiData.selectionType,
                    update: ({bool? isItemSelected}) {
                      placeOrderPro.notify;
                    },
                  )
                else if (_modiType == ModifierType.rawingre)
                  NewRawIngreSec(
                    title: modiData.name ?? '',
                    modifierItems: modiData.modifierItems,
                    onUpdate: () {
                      placeOrderPro.notify;
                    },
                  )
                else if (_modiType == ModifierType.spice)
                  NewSpiceSec(
                    title: modiData.name ?? '',
                    modifierItems: modiData.modifierItems,
                    onUpdate: () {
                      placeOrderPro.notify;
                    },
                  )
              ],
            ));
  }

  @override
  Widget build(BuildContext context) {
    final size = Ssize(context);
    final modifier = placeOrderPro.currentSelectedModifier;

    if (modifier == null)
      return NoItemsSec(
        size: size,
        title: "View item details",
        iconHeight: 200,
      );
    else
      return Card(
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Flexible(
                child: Padding(
                  padding: EdgeInsets.symmetric(
                      vertical: size.getH(6), horizontal: size.getW(0)),
                  child: Row(
                    children: [
                      ClipRRect(
                          borderRadius: BorderRadius.circular(100),
                          child: CachedNetworkImage(
                              imageUrl: modifier.imageUrl ?? '',
                              height: size.getW(48),
                              width: size.getW(48),
                              fit: BoxFit.fitHeight,
                              placeholder: ImageError.load,
                              errorWidget: ImageError.notSupportIcon)),
                      SizedBox(
                        width: size.getW(6),
                      ),
                      Expanded(
                        child: Text(
                          'Customize ${modifier.productName ?? ''}${(modifier.variationName?.trim().isNotEmpty ?? false) ? ' (${modifier.variationName})' : ''}',
                          style: TextStyle(
                            fontSize: size.getS(18),
                            color: Colors.black,
                            fontFamily: kFontFMedium,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          Divider(),
          SizedBox(height: size.getH(4)),
          if (!placeOrderPro.varianceLoading &&
              (modifier.modifierItemModifiers?.isNotEmpty ?? false)) ...[
            if (modifier.loadItemDetail)
              Expanded(child: Loading())
            else
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      SizedBox(height: size.getH(12)),
                      // Align(
                      //   alignment: Alignment.centerLeft,
                      //   child: Padding(
                      //     padding: EdgeInsets.symmetric(
                      //       horizontal: size.getW(12),
                      //     ),
                      //     child: Text(
                      //       'Customize',
                      //       style: TextStyle(
                      //         fontSize: size.getS(16),
                      //         fontFamily: kFontFMedium,
                      //         color: kSecondaryColor,
                      //       ),
                      //     ),
                      //   ),
                      // ),
                      if (modifier.modifierItemModifiers?.isNotEmpty ?? false)
                        GridView.count(
                          crossAxisCount: 2,
                          childAspectRatio: 6,
                          shrinkWrap: true,
                          padding: EdgeInsets.symmetric(
                              horizontal: size.getW(12),
                              vertical: size.getH(4)),
                          physics: NeverScrollableScrollPhysics(),
                          mainAxisSpacing: size.getW(12),
                          crossAxisSpacing: size.getH(12),
                          children: [
                            ...List.generate(
                                modifier.modifierItemModifiers!.length,
                                (index) {
                              final _modiData =
                                  modifier.modifierItemModifiers![index];
                              final _totalQty = _modiData.modifierItems
                                      ?.fold<double>(
                                          0,
                                          (pV, eV) =>
                                              pV +
                                              ((eV.isActive ?? false)
                                                  ? eV.quantity
                                                  : 0)) ??
                                  0;

                              final _modiType =
                                  OrderUtils.getModifierType(_modiData.type);

                              return InkWell(
                                borderRadius: BorderRadius.circular(5),
                                onTap: () {
                                  _showVarDia(
                                    context,
                                    placeOrderPro: placeOrderPro,
                                    modiData: _modiData,
                                  );
                                },
                                child: Card(
                                  color: _totalQty != 0
                                      ? kSecondaryColor
                                      : Colors.white,
                                  margin: EdgeInsets.zero,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(5),
                                      side: BorderSide(color: kSecondaryColor)),
                                  child: Center(
                                    child: Padding(
                                      padding: EdgeInsets.symmetric(
                                          vertical: size.getH(6),
                                          horizontal: size.getW(20)),
                                      child: Text.rich(
                                        TextSpan(
                                            text: (_modiData.name ?? ''),
                                            children: [
                                              if (_totalQty != 0) ...[
                                                TextSpan(text: ' ('),
                                                TextSpan(
                                                  text: _totalQty.formatDouble,
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    decoration: _modiType ==
                                                            ModifierType
                                                                .rawingre
                                                        ? TextDecoration
                                                            .lineThrough
                                                        : null,
                                                  ),
                                                ),
                                                TextSpan(text: ')')
                                              ]
                                            ]),
                                        style: TextStyle(
                                          fontSize: size.getS(16),
                                          fontFamily: kFontFMedium,
                                          color: _totalQty != 0
                                              ? Colors.white
                                              : kSecondaryColor,
                                        ),
                                        textAlign: TextAlign.center,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            }),
                          ],
                        ),
                    ],
                  ),
                ),
              )
          ]
        ]),
      );
  }
}
