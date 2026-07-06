import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:oktoast/oktoast.dart';
import 'package:pos_account/config/size_config.dart';
import 'package:pos_account/config/utils/order_utils.dart';
import 'package:pos_account/constant/constant.dart';
import 'package:pos_account/ln.dart';
import 'package:pos_account/model/home/menu/place_order/place_order_req.dart';
import 'package:pos_account/model/home/menu/place_order/pos_res/com/combo_detail_by_id.dart';
import 'package:pos_account/model/home/menu/place_order/pos_res/com/feature_product.dart';
import 'package:pos_account/providers/cus_val_pro.dart';
import 'package:pos_account/providers/menu/place_order_pro.dart';
import 'package:pos_account/screens/home_screen/com/items/tabs/pos_tab/variance_3/ingredients_sec.dart';
import 'package:pos_account/screens/home_screen/com/items/tabs/pos_tab/variance_3/modifier_section.dart';
import 'package:pos_account/screens/home_screen/com/quantity_sec.dart';
import 'package:pos_account/screens/home_screen/com/variance/selective_tab.dart';
import 'package:pos_account/widgets/image/image_error.dart';
import 'package:pos_account/widgets/loading.dart';

class ComboItemDetail extends StatelessWidget {
  final PlaceOrderPro placeOrderPro;
  final ComboDetailById setMenu;
  const ComboItemDetail(
      {super.key, required this.placeOrderPro, required this.setMenu});

  // double _getTotalAmount() {
  //   final _setMenuPrice = (setMenu.discountedPrice?.inDouble ?? 0) > 0 ||
  //           (setMenu.discountPercentage?.inDouble ?? 0) > 99
  //       ? setMenu.discountedPrice.inDouble
  //       : setMenu.actualPrice.inDouble;

  //   return setMenu.quantity *
  //       (_setMenuPrice +
  //           (setMenu.setMenuProductListViewModelWithCategory?.fold<double>(
  //                   0,
  //                   (pV1, e1) =>
  //                       pV1 +
  //                       (e1.setMenuProductListViewModels?.fold<double>(
  //                               0,
  //                               (pV4, e4) =>
  //                                   pV4 +
  //                                   (e4.tempComboProduct?.fold<double>(
  //                                           0,
  //                                           (pV2, e2) =>
  //                                               pV2 +
  //                                               ((e2 == null || !e2.isSelected)
  //                                                   ? 0
  //                                                   : (e2.productPriceModifiers?.fold<
  //                                                               double>(
  //                                                           0,
  //                                                           (pV3, e3) =>
  //                                                               pV3 +
  //                                                               ((e3.isActive ??
  //                                                                           false)
  //                                                                       ? e3
  //                                                                           .quantity
  //                                                                       : 0) *
  //                                                                   (double.tryParse(e3.price ?? '') ??
  //                                                                       0)) ??
  //                                                       0))) ??
  //                                       0)) ??
  //                           0)) ??
  //               0));
  // }

  Future<void> _removeItem(String? itemId, BuildContext ctx) async {
    if (itemId == null || itemId.isEmpty) return;

    await placeOrderPro.cancelPlaceOrderItem(
      ctx,
      orderId: placeOrderPro.reOrder!.orderId!,
      type: ItemCancelType.setmenu,
      itemIds: [itemId],
      setmenuId: [],
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = Ssize(context);
    final selectedProduct = placeOrderPro.selectedSetMenuProduct;

    final _removIngre = selectedProduct
        ?.tempComboProduct?[
            placeOrderPro.selectedSetMenuProduct!.selectedItemQtyIndex]
        ?.productVariationModifiers
        ?.whereModiType(ModifierType.rawingre);
    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (selectedProduct != null) ...[
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Flexible(
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                        vertical: size.getH(6), horizontal: size.getW(16)),
                    child: Row(
                      children: [
                        ClipRRect(
                            borderRadius: BorderRadius.circular(100),
                            child: CachedNetworkImage(
                                imageUrl: placeOrderPro
                                    .selectedSetMenuProduct!.imageUrl!,
                                height: size.getW(48),
                                width: size.getW(48),
                                fit: BoxFit.fitHeight,
                                placeholder: ImageError.load,
                                errorWidget: ImageError.notSupportIcon)),
                        SizedBox(
                          width: size.getW(12),
                        ),
                        Flexible(
                          child: Text(
                            (placeOrderPro.selectedSetMenuProduct?.name ?? '') +
                                (selectedProduct.productVariationName != null &&
                                        (selectedProduct.productVariationName
                                                ?.trim()
                                                .isNotEmpty ??
                                            false)
                                    ? '(${selectedProduct.productVariationName})'
                                    : ''),
                            style: TextStyle(
                              fontSize: size.getS(14),
                              color: Colors.black,
                              fontFamily: kFontFMedium,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                IconButton(
                    visualDensity: VisualDensity.compact,
                    onPressed: () {
                      placeOrderPro.selectedSetMenuProduct = null;
                      placeOrderPro.notify;
                    },
                    icon: Icon(Icons.close)),
              ],
            ),

            // quantity
            Padding(
              padding: EdgeInsets.only(left: size.getW(72)),
              child: QuantitySection(
                size: size,
                quantity: selectedProduct.quantity,
                update: (p0) {
                  if (p0 == null) return;

                  selectedProduct.tempComboProduct ??= [];

                  if (p0) {
                    final maxCount = selectedProduct.maxSelectCount ?? 0;
                    final selectCount =
                        selectedProduct.selectedComboCatIndex != null
                            ? (setMenu
                                    .setMenuProductListViewModelWithCategory?[
                                        selectedProduct.selectedComboCatIndex!]
                                    .setMenuProductListViewModels
                                    ?.where((e) => e.isSelected)
                                    .toList()
                                    .fold<double>(
                                        0, (pV, ele) => pV + ele.quantity)) ??
                                0
                            : 0.0;
                    final remainingCount = maxCount - selectCount;
                    // print("$_remainingCount $_maxCount $_selectCount");
                    if (remainingCount > 0.5 || maxCount == 0) {
                      if (selectedProduct.quantity <= 0.5) {
                        selectedProduct.quantity = 1;
                        if (selectedProduct.tempComboProduct?.isNotEmpty ??
                            false) {
                          selectedProduct.tempComboProduct!.first!.quantity = 1;
                        }
                      } else {
                        selectedProduct.quantity++;
                        selectedProduct.tempComboProduct!.add(
                            FeaturedProduct.fromJson(selectedProduct.toJson())
                              ..isSelected = true
                              ..quantity = 1);
                      }
                    } else if (remainingCount == 0.5) {
                      selectedProduct.quantity += 0.5;
                      selectedProduct.tempComboProduct!.add(
                          FeaturedProduct.fromJson(selectedProduct.toJson())
                            ..isSelected = true
                            ..quantity = 0.5);
                    } else {
                      // kPrint('message: 2');
                      showToast(
                          "Maximum selected item count is ${maxCount.round()}");
                      return;
                    }
                  } else {
                    final canHalf =
                        GlobalCVP.viewWidget.viewComboItemHalfButton;
                    final roundQty = selectedProduct.quantity.round();
                    if (selectedProduct.quantity > 1 &&
                        selectedProduct.quantity % roundQty != 0) {
                      if (!canHalf) return;
                      selectedProduct.quantity -= 0.5;
                      if (selectedProduct.tempComboProduct?.isNotEmpty ??
                          false) {
                        _removeItem(
                            selectedProduct.tempComboProduct?.last?.updateId,
                            context);
                        selectedProduct.tempComboProduct!.removeLast();
                      }
                    } else if (selectedProduct.quantity == 1) {
                      if (!canHalf) return;
                      selectedProduct.quantity = 0.5;
                      if (selectedProduct.tempComboProduct?.isNotEmpty ??
                          false) {
                        selectedProduct.tempComboProduct?.first?.quantity = 0.5;
                      }
                    } else if (selectedProduct.quantity <= 0.5) {
                      return;
                    } else {
                      selectedProduct.quantity--;
                      if (selectedProduct.tempComboProduct?.isNotEmpty ??
                          false) {
                        _removeItem(
                            selectedProduct.tempComboProduct?.last?.updateId,
                            context);
                        selectedProduct.tempComboProduct!.removeLast();
                      }
                    }
                  }

                  // final _qtyCount = _selectedProduct.quantity.round();
                  // _selectedProduct.tempComboProduct = List.generate(
                  //     _qtyCount,
                  //     (_) => FeaturedProduct.fromJson(_selectedProduct.toJson())
                  //       ..isSelected = true
                  //       ..quantity = 1);

                  if (selectedProduct.tempComboProduct!.isNotEmpty &&
                      selectedProduct.selectedItemQtyIndex >
                          selectedProduct.tempComboProduct!.length - 1) {
                    selectedProduct.selectedItemQtyIndex =
                        selectedProduct.tempComboProduct!.length - 1;
                  }

                  placeOrderPro.notify;
                },
              ),
            ),

            SizedBox(height: size.getH(12)),

            // quantity tab
            if (selectedProduct.tempComboProduct != null &&
                ((selectedProduct
                            .tempComboProduct?[placeOrderPro
                                .selectedSetMenuProduct!.selectedItemQtyIndex]
                            ?.productIngredients
                            ?.isNotEmpty ??
                        false) ||
                    (selectedProduct
                            .tempComboProduct![placeOrderPro
                                .selectedSetMenuProduct!.selectedItemQtyIndex]
                            ?.productVariationModifiers
                            ?.isNotEmpty ??
                        false))) ...[
              Align(
                alignment: Alignment.centerLeft,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: List.generate(
                      selectedProduct.tempComboProduct!.length,
                      (i) {
                        final qty =
                            selectedProduct.tempComboProduct![i]!.quantity;

                        return Padding(
                          padding: EdgeInsets.only(right: size.getW(4)),
                          child: SelectiveTab(
                            title:
                                '${qty == 0.5 ? LN.halfItem : LN.item} ${i + 1}',
                            isDefault: i ==
                                placeOrderPro.selectedSetMenuProduct!
                                    .selectedItemQtyIndex,
                            onTap: () async {
                              selectedProduct.loadItemDetail = true;
                              placeOrderPro.selectedSetMenuProduct!
                                  .selectedItemQtyIndex = i;
                              placeOrderPro.notify;
                              await Future.delayed(Duration(milliseconds: 300));
                              selectedProduct.loadItemDetail = false;
                              placeOrderPro.notify;
                            },
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),
              if (selectedProduct.loadItemDetail)
                Expanded(child: Loading())
              else
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        AnimatedSwitcher(
                          duration: Duration(milliseconds: 400),
                          child: ModifierSection(
                            width: 300,
                            key: ValueKey(placeOrderPro.varianceLoading),
                            curSym: placeOrderPro.curSym ?? '',
                            productPriceModifiers: selectedProduct
                                    .tempComboProduct![placeOrderPro
                                        .selectedSetMenuProduct!
                                        .selectedItemQtyIndex]
                                    ?.productVariationModifiers ??
                                [],
                            update: ({bool? isItemSelected}) =>
                                placeOrderPro.notify,
                          ),
                        ),
                        SizedBox(height: size.getH(12)),
                        if (_removIngre?.isNotEmpty ?? false)
                          IngredientSec(
                            productIngredients: _removIngre!,
                            onUpdate: () {
                              placeOrderPro.notify;
                            },
                          ),
                      ],
                    ),
                  ),
                )
            ] else
              Spacer(),
          ] else
            Spacer(),
          // Row(
          //   mainAxisAlignment: MainAxisAlignment.center,
          //   children: [
          //     Text(
          //       "${LN.totalAmount}:  ${placeOrderPro.curSym}${_getTotalAmount().roundToNString()}",
          //       style: TextStyle(
          //         fontSize: size.getS(22),
          //         fontFamily: kFontFMedium,
          //         color: Colors.black,
          //       ),
          //     ),
          //   ],
          // ),
          // SizedBox(height: size.getH(12)),
        ],
      ),
    );
  }
}
