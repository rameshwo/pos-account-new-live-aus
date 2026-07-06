import 'package:flutter/material.dart';
import 'package:pos_account/config/size_config.dart';
import 'package:pos_account/config/utils/order_utils.dart';
import 'package:pos_account/config/validator.dart';
import 'package:pos_account/constant/constant.dart';
import 'package:pos_account/ln.dart';
import 'package:pos_account/screens/home_screen/com/items/sidebar/sidebar_section/com/item_detail.dart';
import 'package:pos_account/screens/home_screen/com/items/sidebar/sidebar_section/com/order_total.dart';
import 'package:pos_account/second_app/provider/second_screen_pro.dart';
import 'package:pos_account/widgets/input/text_form/text_form_widget.dart';

class ItemViewSection extends StatelessWidget {
  final Ssize size;
  final SecondScreenPro screenPro;
  const ItemViewSection(
      {super.key, required this.size, required this.screenPro});

  @override
  Widget build(BuildContext context) {
    final secondPro = screenPro;
    final scrollCltr = screenPro.scrollCltr;

    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: size.getW(16),
            ),
            child: Text(
              LN.items,
              style: TextStyle(
                fontSize: size.getS(22),
                color: Colors.black,
                fontFamily: kFontFMedium,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          SizedBox(
            height: size.getH(4),
          ),
          if (secondPro.cbm.reOrder?.orderNumber != null)
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                color: kSecondaryColor.withAlpha(50),
              ),
              padding: EdgeInsets.symmetric(
                  horizontal: size.getW(16), vertical: size.getH(8)),
              child: Text(
                secondPro.cbm.reOrder?.orderNumber ?? '',
                style: TextStyle(
                  fontSize: size.getS(18),
                  color: kSecondaryColor,
                  fontFamily: kFontFMedium,
                  fontWeight: FontWeight.bold,
                ),
                overflow: TextOverflow.ellipsis,
                maxLines: 2,
              ),
            ),
          Expanded(
            child: Scrollbar(
              controller: scrollCltr,
              // isAlwaysShown: false,
              // showTrackOnHover: true,
              interactive: true,
              thickness: 10,
              radius: Radius.circular(40),
              child: SingleChildScrollView(
                controller: scrollCltr,
                padding: EdgeInsets.symmetric(horizontal: size.getW(12)),
                child: Column(
                  children: [
                    ..._setMenu(),
                    ..._orderItem(),
                    ..._ingre(),
                  ],
                ),
              ),
            ),
          ),
          SizedBox(
            height: size.getH(4),
          ),
          if (secondPro.isPaymentScreen)
            Padding(
              padding: EdgeInsets.symmetric(horizontal: size.getW(12)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Spacer(),
                      Text(
                        "${LN.discount}(%)",
                        style: TextStyle(
                          fontSize: size.getS(18),
                          color: Colors.black,
                        ),
                      ),
                      SizedBox(
                        width: size.getW(8),
                      ),
                      SizedBox(
                        width: size.getW(84),
                        child: TextFormWidget(
                          borderRadius: 5,
                          borderColor: Colors.black12,
                          readOnly: true,
                          isReq: true,
                          initValidate: true,
                          fillColor: kBackgroundColor,
                          cltr: TextEditingController(
                              text: secondPro.cbm.discountPercent.toString()),
                          hintText: "0",
                          textInputType: TextInputType.number,
                          textAlign: TextAlign.right,
                          suffix: Text(
                            "%",
                            style: TextStyle(
                              fontSize: size.getS(16),
                              color: Colors.black,
                              fontFamily: kFontFMedium,
                            ),
                          ),
                          errH: 0,
                        ),
                      ),
                      SizedBox(
                        width: size.getW(102),
                        child: Text(
                          secondPro.curSym +
                              (secondPro.cbm.discountAmount ?? ''),
                          style: TextStyle(
                            fontSize: size.getS(18),
                            color: Colors.black,
                            fontFamily: kFontFMedium,
                          ),
                          textAlign: TextAlign.right,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: size.getH(4),
                  ),
                  if (secondPro.cbm.pubSurAmount?.isNotEmpty ?? false)
                    Row(
                      children: [
                        Text(
                          "Surcharge", //  LN.publicHolidaySc,
                          style: TextStyle(
                            fontSize: size.getS(18),
                            color: Colors.black,
                          ),
                        ),
                        Expanded(
                          child: SizedBox(
                            width: size.getW(102),
                            child: Text(
                              secondPro.cbm.curSym +
                                  (secondPro.cbm.pubSurAmount ?? ''),
                              style: TextStyle(
                                fontSize: size.getS(18),
                                color: Colors.black,
                                fontFamily: kFontFMedium,
                              ),
                              textAlign: TextAlign.right,
                            ),
                          ),
                        ),
                      ],
                    ),
                  SizedBox(height: size.getH(4)),
                  if (secondPro.cbm.creSurAmount?.isNotEmpty ?? false)
                    Row(
                      children: [
                        Text(
                          "${LN.creditCardSc} ",
                          style: TextStyle(
                            fontSize: size.getS(18),
                            color: Colors.black,
                          ),
                        ),
                        SizedBox(
                          width: size.getW(84),
                          child: TextFormWidget(
                            borderRadius: 5,
                            borderColor: Colors.black12,
                            isReq: true,
                            initValidate: true,
                            readOnly: true,
                            fillColor: kBackgroundColor,
                            cltr: TextEditingController(
                                text: secondPro.cbm.creSurPercent),
                            hintText: "0",
                            textInputType: TextInputType.number,
                            textAlign: TextAlign.right,
                            errH: 0,
                            suffix: Text(
                              "%",
                              style: TextStyle(
                                fontSize: size.getS(16),
                                color: Colors.black,
                                fontFamily: kFontFMedium,
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: SizedBox(
                            width: size.getW(102),
                            child: Text(
                              secondPro.cbm.curSym +
                                  (secondPro.cbm.creSurAmount ?? ''),
                              style: TextStyle(
                                fontSize: size.getS(18),
                                color: Colors.black,
                                fontFamily: kFontFMedium,
                              ),
                              textAlign: TextAlign.right,
                            ),
                          ),
                        ),
                      ],
                    ),
                  SizedBox(height: size.getH(4)),
                  if (secondPro.cbm.serviceChargeAmount?.isNotEmpty ?? false)
                    Row(
                      children: [
                        Text(
                          "Service Charge ",
                          style: TextStyle(
                            fontSize: size.getS(18),
                            color: Colors.black,
                          ),
                        ),
                        SizedBox(
                          width: size.getW(84),
                          child: TextFormWidget(
                            borderRadius: 5,
                            borderColor: Colors.black12,
                            isReq: true,
                            initValidate: true,
                            readOnly: true,
                            fillColor: kBackgroundColor,
                            cltr: TextEditingController(
                                text: secondPro.cbm.sCPercent),
                            hintText: "0",
                            textInputType: TextInputType.number,
                            textAlign: TextAlign.right,
                            errH: 0,
                            suffix: Text(
                              "%",
                              style: TextStyle(
                                fontSize: size.getS(16),
                                color: Colors.black,
                                fontFamily: kFontFMedium,
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: SizedBox(
                            width: size.getW(102),
                            child: Text(
                              secondPro.cbm.curSym +
                                  (secondPro.cbm.serviceChargeAmount ?? ''),
                              style: TextStyle(
                                fontSize: size.getS(18),
                                color: Colors.black,
                                fontFamily: kFontFMedium,
                              ),
                              textAlign: TextAlign.right,
                            ),
                          ),
                        ),
                      ],
                    ),
                ],
              ),
            )
          else
            TextFormWidget(
              borderRadius: 5,
              borderColor: Colors.black12,
              maxLines: 2,
              isReq: false,
              readOnly: true,
              fillColor: kBackgroundColor,
              cltr: TextEditingController(text: secondPro.cbm.descText),
              hintText: LN.description,
            ),
          if (secondPro.cbm.isDelivery && secondPro.cbm.descText.isNotEmpty)
            Padding(
              padding: EdgeInsets.only(top: size.getH(4)),
              child: Row(
                children: [
                  Text(
                    LN.deliAmt,
                    style: TextStyle(
                      fontSize: size.getS(18),
                      color: Colors.black,
                    ),
                  ),
                  Spacer(),
                  Text(
                    secondPro.curSym + secondPro.cbm.descText,
                    style: TextStyle(
                      fontSize: size.getS(18),
                      color: Colors.black,
                      fontFamily: kFontFMedium,
                    ),
                  ),
                ],
              ),
            ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: size.getW(12)),
            child: OrderTotalSection(
              amount: secondPro.getAmount,
              curSym: secondPro.curSym,
              taxType: secondPro.getAmount.taxType,
              fontUp: 4,
            ),
          )
        ],
      ),
    );
  }

  /// Widgets

  List<Widget> _setMenu() {
    final setmenuList = screenPro.cbm.setMenuList;
    return List.generate(setmenuList.length, (i) {
      final modifierPrice = setmenuList[i].orderItemsViewModels?.fold<double>(
              0,
              (pV1, e1) =>
                  pV1 +
                  (e1.orderItemsPriceModifierViewModels?.fold<double>(
                          0,
                          (pV2, e2) =>
                              pV2 +
                              (e2.isActive ? (e2.modifierPrice ?? 0) : 0)) ??
                      0)) ??
          0;

      final itemPrice = (setmenuList[i].setMenuPrice ?? 0) + modifierPrice;

      return ItemDetail(
        imgPath: setmenuList[i].imgPath,
        title: setmenuList[i].setMenuName ?? '',
        curSym: screenPro.curSym,
        price: itemPrice,
        quantity: setmenuList[i].setMenuQuantity?.toDouble() ?? 1.0,
        total: itemPrice * (setmenuList[i].setMenuQuantity ?? 1),
        descCltr: screenPro.cbm.isPaymentScreen
            ? null
            : TextEditingController(text: setmenuList[i].description),
        comboItem: setmenuList[i].orderItemsViewModels?.map((e) {
          List<String>? _modifiers;

          // modifiers

          if (e.orderItemsPriceModifierViewModels != null) {
            _modifiers = [];

            for (final m in e.orderItemsPriceModifierViewModels!) {
              if (m.isActive && (m.modifierName?.isNotEmpty ?? false)) {
                _modifiers.add(
                    "${(m.labelName?.isNotEmpty ?? false) ? "${m.labelName}" : ""} - ${m.modifierName!} (${screenPro.curSym}${(m.totalModifierPrice)?.roundToNString()})");
              }
            }
          }

          // ingredents

          List<String>? ingredients;

          if (e.removedOrderItemsIngredientsViewModels != null) {
            ingredients = [];
            for (final p in e.removedOrderItemsIngredientsViewModels!) {
              if (p.isActive) {
                ingredients.add(p.name ?? '');
              }
            }
          }

          return ComboItem(
            // imgPath: "",
            title: e.productName ?? '',
            modifier: _modifiers,
            ingredients: ingredients,
          );
        }).toList(),
        outOfStockMessage: setmenuList[i].outOfStockMessage,
        isSecondScreen: true,
      );
    });
  }

  List<Widget> _orderItem() {
    final orderList = screenPro.cbm.orderList;
    return List.generate(orderList.length, (i) {
      List<String>? _modifiers;

      // modifiers

      if (orderList[i].orderItemModifiersViewModels != null) {
        _modifiers = [];

        for (final m in orderList[i].orderItemModifiersViewModels!) {
          if (m.isActive && (m.modifierName?.isNotEmpty ?? false)) {
            _modifiers.add(
                "${(m.labelName?.isNotEmpty ?? false) ? "${m.labelName}" : ""} - ${m.modifierName!}(${screenPro.curSym}${(m.totalModifierPrice)?.roundToNString()})");
          }
        }
      }

      final modifierPrice =
          orderList[i]
              .orderItemModifiersViewModels
              ?.fold<double>(
                  0,
                  (previousValue, element) =>
                      previousValue +
                      (element.isActive ? (element.modifierPrice ?? 0) : 0));

      // ingredents

      List<String>? ingredients;

      final _ingre = orderList[i]
          .orderItemModifiersViewModels
          ?.whereModiType2(ModifierType.rawingre);

      if (_ingre != null) {
        ingredients = [];
        for (final p in _ingre) {
          if (p.isActive) {
            ingredients.add(p.modifierName ?? '');
          }
        }
      }

      final _spiceList = orderList[i]
          .orderItemModifiersViewModels
          ?.whereModiType2(ModifierType.spice);

      ///

      final _itemPrice =
          (orderList[i].productPrice ?? 0) + (modifierPrice ?? 0);

      final _statusEnum = OrderUtils.getStatusEnum(orderList[i].statusId);

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ItemDetail(
                imgPath: orderList[i].imgPath,
                title: (orderList[i].productName ?? '') +
                    ((orderList[i].productVariationName?.trim().isNotEmpty ??
                            false)
                        ? " (${orderList[i].productVariationName ?? ''})"
                        : "") +
                    ((_spiceList?.any((a) => a.isActive) ?? false)
                        ? "\n- ${_spiceList?.firstWhere((a) => a.isActive).modifierName ?? ''}"
                        : ""),
                modifier: _modifiers,
                ingredients: ingredients,
                // vName: placeOrderPro.orderList[i].variationName,
                curSym: screenPro.curSym,
                price: _itemPrice,
                quantity: orderList[i].quantity ?? 1,
                total: _itemPrice * (orderList[i].quantity ?? 1),

                descCltr: screenPro.cbm.isPaymentScreen
                    ? null
                    : TextEditingController(text: orderList[i].description),
                outOfStockMessage: orderList[i].outOfStockMessage,
                statusEnum: _statusEnum,
                isSecondScreen: true,
              ),
            ],
          ),
        ],
      );
    });
  }

  List<Widget> _ingre() {
    final ingreList = screenPro.cbm.ingreList;
    return List.generate(
      ingreList.length,
      (i) {
        final _statusEnum = OrderUtils.getStatusEnum(ingreList[i].statusId);

        return ItemDetail(
          imgPath: "",
          title: ingreList[i].name ?? '',
          curSym: screenPro.curSym,
          price: ingreList[i].originalSellingPricePerUnit ?? 0,
          quantity: ingreList[i].quantity ?? 1,
          total: double.tryParse(ingreList[i].totalSellingPrice ?? '') ?? 0,
          outOfStockMessage: ingreList[i].outOfStockMessage,
          statusEnum: _statusEnum,
          isSecondScreen: true,
        );
      },
    );
  }
}
