import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:pos_account/config/size_config.dart';
import 'package:pos_account/config/utils/order_utils.dart';
import 'package:pos_account/config/validator.dart';
import 'package:pos_account/constant/constant.dart';
import 'package:pos_account/ln.dart';
import 'package:pos_account/model/home/menu/place_order/pos_res/com/feature_product.dart';
import 'package:pos_account/providers/menu/place_order_pro.dart';
import 'package:pos_account/repository/if_exception.dart';
import 'package:pos_account/screens/home_screen/com/quantity_sec.dart';
import 'package:pos_account/screens/home_screen/com/variance/selective_tab.dart';
import 'package:pos_account/widgets/image/image_error.dart';
import 'package:pos_account/widgets/loading.dart';
import 'package:pos_account/widgets/no_items_sec.dart';
import '../../half_half_2/com/new_modi_sec.dart';
import '../../half_half_2/com/new_raw_ingre_sec.dart';
import '../../half_half_2/com/new_spice_sec.dart';

class ComboItemDetail2 extends StatelessWidget {
  final PlaceOrderPro placeOrderPro;
  final Function()? modiUpdate;
  final ProductVariationModifier? selectedVarModi;
  final ProductPriceType? prodPriceType;
  const ComboItemDetail2({
    super.key,
    required this.placeOrderPro,
    this.modiUpdate,
    required this.selectedVarModi,
    this.prodPriceType,
  });

  Future<void> _removeItem(String? itemId) async {
    if (itemId == null || itemId.isEmpty) return;

    // await placeOrderPro.cancelPlaceOrderItem(
    //   orderId: placeOrderPro.reOrder!.orderId!,
    //   type: ItemCancelType.setmenu,
    //   itemIds: [itemId],
    //   setmenuId: [],
    // );
  }

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

    final _modiDataList = (modifier?.multipleCombo?.isNotEmpty ?? false) &&
            (modifier!.multipleCombo!.length > modifier.selectedItemQtyIndex)
        ? (modifier.multipleCombo?[modifier.selectedItemQtyIndex]
            ?.modifierItemModifiers
            ?.where((a) => a.modifierItems?.isNotEmpty ?? false)
            .toList())
        : null;

    // print(
    //     "${(modifier?.multipleCombo?.length)} ${modifier?.selectedItemQtyIndex}");
    if (modifier == null)
      return NoItemsSec(
        size: size,
        title: "View item details",
        iconHeight: 200,
      );
    else
      return Card(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
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
                          child: Text.rich(
                            TextSpan(
                              text: prodPriceType ==
                                      ProductPriceType.FixedPriceFixedProduct
                                  ? '${modifier.quantity.formatDouble} X '
                                  : '',
                              children: [
                                TextSpan(
                                  text:
                                      'Customize ${modifier.productName ?? ''}${(modifier.variationName?.trim().isNotEmpty ?? false) ? ' (${modifier.variationName})' : ''}',
                                  style: TextStyle(
                                    fontSize: size.getS(16),
                                  ),
                                )
                              ],
                            ),
                            style: TextStyle(
                              fontSize: size.getS(18),
                              color: Colors.black,
                              fontFamily: kFontFMedium,
                            ),
                          ),
                        ),
                        if (prodPriceType !=
                            ProductPriceType.FixedPriceFixedProduct)
                          Padding(
                            padding: EdgeInsets.only(left: size.getW(12)),
                            child: QuantitySection(
                              size: size,
                              quantity: modifier.quantity,
                              update: (p0) {
                                if (p0 == null) return;

                                modifier.multipleCombo ??= [];

                                if (p0) {
                                  final _catMax = modifier.maxSelectCount ?? 0;
                                  // final _modiMax =
                                  //     modifier.maxThresholdQuantity?.inDouble ??
                                  //         0.0;

                                  final _selectCount = selectedVarModi
                                          ?.modifierItems
                                          ?.fold<double>(
                                              0,
                                              (pV2, ev2) =>
                                                  pV2 +
                                                  ((ev2.isActive ?? false)
                                                      ? (ev2.quantity)
                                                      : 0)) ??
                                      0;

                                  if (_catMax != 0 &&
                                      _catMax - _selectCount <= 0.5) {
                                    // kPrint(
                                    //     'message: 3: $_modiMax - $_selectCount');
                                    IfException.showMessage(
                                        message:
                                            "Maximum selected item count is ${_catMax.round()}");
                                    return;
                                  }

                                  final _remainingCount =
                                      _catMax - _selectCount;

                                  // kPrint(
                                  //     "_catMax: $_catMax | _selectCount: $_selectCount | _remainingCount: $_remainingCount  | modifier.quantity : ${modifier.quantity}");

                                  if (_remainingCount > 0.5 || _catMax == 0) {
                                    if (modifier.quantity <= 0.5) {
                                      modifier.quantity = 1;
                                      if (modifier.multipleCombo?.isNotEmpty ??
                                          false) {
                                        modifier
                                            .multipleCombo!.first!.quantity = 1;
                                      }
                                    } else {
                                      modifier.quantity++;
                                      modifier.multipleCombo!.add(
                                          ModifierItem.fromJson(
                                              modifier.toJson())
                                            ..isActive = true
                                            ..quantity = 1);
                                    }
                                  }
                                  // else if (_remainingCount == 0.5) {
                                  //   modifier.quantity += 0.5;
                                  //   modifier.multipleCombo!
                                  //       .add(ModifierItem.fromJson(modifier.toJson())
                                  //         ..isActive = true
                                  //         ..quantity = 0.5);
                                  // }
                                  else {
                                    kPrint('message: 4');
                                    IfException.showMessage(
                                        message:
                                            "Maximum selected item count is ${_catMax.round()}");
                                    return;
                                  }
                                } else {
                                  // final _canHalf =
                                  //     GlobalCVP.viewWidget.viewComboItemHalfButton;
                                  // final _roundQty = modifier.quantity.round();
                                  if (modifier.quantity > 1
                                      // &&
                                      //     modifier.quantity % _roundQty != 0
                                      )
                                  //      {
                                  //   // if (!_canHalf) return;
                                  //   modifier.quantity -= 0.5;
                                  //   if (modifier.multipleCombo?.isNotEmpty ?? false) {
                                  //     _removeItem(modifier.multipleCombo?.last?.updateId);
                                  //     modifier.multipleCombo!.removeLast();
                                  //   }
                                  // }
                                  // else if (modifier.quantity == 1) {
                                  //   // if (!_canHalf) return;
                                  //   modifier.quantity = 0.5;
                                  //   if (modifier.multipleCombo?.isNotEmpty ?? false) {
                                  //     modifier.multipleCombo?.first?.quantity = 0.5;
                                  //   }
                                  // } else if (modifier.quantity <= 0.5) {
                                  //   return;
                                  // }
                                  // else
                                  {
                                    modifier.quantity--;
                                    if (modifier.multipleCombo?.isNotEmpty ??
                                        false) {
                                      _removeItem(modifier
                                          .multipleCombo?.last?.updateId);
                                      modifier.multipleCombo!.removeLast();
                                    }
                                  }
                                }

                                // final _qtyCount = _selectedProduct.quantity.round();
                                // _selectedProduct.tempComboProduct = List.generate(
                                //     _qtyCount,
                                //     (_) => FeaturedProduct.fromJson(_selectedProduct.toJson())
                                //       ..isSelected = true
                                //       ..quantity = 1);

                                if (modifier.multipleCombo!.isNotEmpty &&
                                    modifier.selectedItemQtyIndex >
                                        modifier.multipleCombo!.length - 1) {
                                  modifier.selectedItemQtyIndex =
                                      modifier.multipleCombo!.length - 1;
                                }

                                placeOrderPro.notify;
                              },
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
                // IconButton(
                //     visualDensity: VisualDensity.compact,
                //     onPressed: () {
                //       // placeOrderPro. = null;
                //       placeOrderPro.notify;
                //     },
                //     icon: Icon(Icons.close)),
              ],
            ),

            // quantity
            // Padding(
            //   padding: EdgeInsets.only(left: size.getW(72)),
            //   child: QuantitySection(
            //     size: size,
            //     quantity: modifier.quantity.toDouble(),
            //     update: (p0) {
            //       if (p0 == null) return;

            //       modifier.multipleCombo ??= [];

            //       if (p0) {
            //         final _catMax = modifier.maxSelectCount ?? 0;
            //         final _modiMax =
            //             modifier.maxThresholdQuantity?.inDouble ?? 0.0;

            //         final _selectCount = selectedVarModi?.modifierItems
            //                 ?.fold<double>(
            //                     0,
            //                     (pV2, ev2) =>
            //                         pV2 +
            //                         ((ev2.isActive ?? false)
            //                             ? (ev2.quantity)
            //                             : 0)) ??
            //             0;

            //         if (_modiMax != 0 && _modiMax - _selectCount <= 0.5) {
            //           IfException.showMessage(
            //               message:
            //                   "Maximum selected item count is ${_catMax.round()}");
            //           return;
            //         }

            //         final _remainingCount = _catMax - _selectCount;

            //         if (_remainingCount > 0.5 || _catMax == 0) {
            //           if (modifier.quantity <= 0.5) {
            //             modifier.quantity = 1;
            //             if (modifier.multipleCombo?.isNotEmpty ?? false) {
            //               modifier.multipleCombo!.first!.quantity = 1;
            //             }
            //           } else {
            //             modifier.quantity++;
            //             modifier.multipleCombo!
            //                 .add(ModifierItem.fromJson(modifier.toJson())
            //                   ..isActive = true
            //                   ..quantity = 1);
            //           }
            //         }
            //         // else if (_remainingCount == 0.5) {
            //         //   modifier.quantity += 0.5;
            //         //   modifier.multipleCombo!
            //         //       .add(ModifierItem.fromJson(modifier.toJson())
            //         //         ..isActive = true
            //         //         ..quantity = 0.5);
            //         // }
            //         else {
            //           IfException.showMessage(
            //               message:
            //                   "Maximum selected item count is ${_catMax.round()}");
            //           return;
            //         }
            //       } else {
            //         // final _canHalf =
            //         //     GlobalCVP.viewWidget.viewComboItemHalfButton;
            //         // final _roundQty = modifier.quantity.round();
            //         if (modifier.quantity > 1
            //             // &&
            //             //     modifier.quantity % _roundQty != 0
            //             )
            //         //      {
            //         //   // if (!_canHalf) return;
            //         //   modifier.quantity -= 0.5;
            //         //   if (modifier.multipleCombo?.isNotEmpty ?? false) {
            //         //     _removeItem(modifier.multipleCombo?.last?.updateId);
            //         //     modifier.multipleCombo!.removeLast();
            //         //   }
            //         // }
            //         // else if (modifier.quantity == 1) {
            //         //   // if (!_canHalf) return;
            //         //   modifier.quantity = 0.5;
            //         //   if (modifier.multipleCombo?.isNotEmpty ?? false) {
            //         //     modifier.multipleCombo?.first?.quantity = 0.5;
            //         //   }
            //         // } else if (modifier.quantity <= 0.5) {
            //         //   return;
            //         // }
            //         // else
            //         {
            //           modifier.quantity--;
            //           if (modifier.multipleCombo?.isNotEmpty ?? false) {
            //             _removeItem(modifier.multipleCombo?.last?.updateId);
            //             modifier.multipleCombo!.removeLast();
            //           }
            //         }
            //       }

            //       // final _qtyCount = _selectedProduct.quantity.round();
            //       // _selectedProduct.tempComboProduct = List.generate(
            //       //     _qtyCount,
            //       //     (_) => FeaturedProduct.fromJson(_selectedProduct.toJson())
            //       //       ..isSelected = true
            //       //       ..quantity = 1);

            //       if (modifier.multipleCombo!.isNotEmpty &&
            //           modifier.selectedItemQtyIndex >
            //               modifier.multipleCombo!.length - 1) {
            //         modifier.selectedItemQtyIndex =
            //             modifier.multipleCombo!.length - 1;
            //       }

            //       placeOrderPro.notify;
            //     },
            //   ),
            // ),

            Divider(),
            SizedBox(height: size.getH(4)),
            // quantity tab
            if (!placeOrderPro.varianceLoading &&
                (modifier.multipleCombo?.isNotEmpty ?? false)) ...[
              if (modifier.multipleCombo!.length > 1)
                Align(
                  alignment: Alignment.centerLeft,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    padding: EdgeInsets.symmetric(horizontal: size.getW(12)),
                    child: Row(
                      children: List.generate(
                        modifier.multipleCombo!.length,
                        (i) {
                          final _qty = modifier.multipleCombo![i]!.quantity;

                          return Padding(
                            padding: EdgeInsets.only(right: size.getW(4)),
                            child: SelectiveTab(
                              title:
                                  '${_qty == 0.5 ? LN.halfItem : LN.item} ${i + 1}',
                              isDefault: i == modifier.selectedItemQtyIndex,
                              onTap: () async {
                                modifier.loadItemDetail = true;
                                modifier.selectedItemQtyIndex = i;
                                placeOrderPro.notify;
                                await Future.delayed(
                                    Duration(milliseconds: 300));
                                modifier.loadItemDetail = false;
                                placeOrderPro.notify;
                              },
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ),
              if (modifier.loadItemDetail)
                Expanded(child: Loading())
              else
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        SizedBox(height: size.getH(8)),
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
                        if (_modiDataList?.isNotEmpty ?? false)
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
                              ...List.generate(_modiDataList!.length, (index) {
                                final _modiData = _modiDataList[index];

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
                                        side:
                                            BorderSide(color: kSecondaryColor)),
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
                                                    text:
                                                        _totalQty.formatDouble,
                                                    style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
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
                        // AnimatedSwitcher(
                        //   duration: Duration(milliseconds: 400),
                        //   child: ModifierSection(
                        //     width: 300,
                        //     key: ValueKey(placeOrderPro.varianceLoading),
                        //     curSym: placeOrderPro.curSym ?? '',
                        //     productPriceModifiers: modifier
                        //             .multipleCombo![
                        //                 modifier.selectedItemQtyIndex]
                        //             ?.modifierItemModifiers
                        //             ?.whereModiType(ModifierType.modifier) ??
                        //         [],
                        //     update: ({bool? isItemSelected}) {
                        //       if ((isItemSelected ?? false) &&
                        //           modiUpdate != null) {
                        //         modiUpdate!();
                        //       }
                        //       placeOrderPro.notify;
                        //     },
                        //     itemQty:
                        //         placeOrderPro.selectedvarCombo?.quantity ?? 1,
                        //   ),
                        // ),
                        // SizedBox(height: size.getH(12)),
                        // IngredientSec(
                        //   productIngredients: modifier
                        //           .multipleCombo![modifier.selectedItemQtyIndex]
                        //           ?.modifierItemModifiers
                        //           ?.whereModiType(ModifierType.rawingre) ??
                        //       [],
                        //   onUpdate: () {
                        //     placeOrderPro.notify;
                        //   },
                        // ),
                        // SpiceSection(
                        //   isItem: false,
                        //   spiceList: modifier
                        //       .multipleCombo![modifier.selectedItemQtyIndex]
                        //       ?.modifierItemModifiers
                        //       ?.whereModiType(ModifierType.spice),
                        //   onChanged: () {
                        //     placeOrderPro.notify;
                        //   },
                        // ),
                        // SizedBox(height: size.getH(24)),
                      ],
                    ),
                  ),
                )
            ]
          ],
        ),
      );
  }
}
