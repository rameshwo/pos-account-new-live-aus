import 'package:flutter/material.dart';
import 'package:flutter_swipe_action_cell/core/cell.dart';
import 'package:oktoast/oktoast.dart';
import 'package:pos_account/config/size_config.dart';
import 'package:pos_account/config/utils/order_utils.dart';
import 'package:pos_account/config/validator.dart';
import 'package:pos_account/constant/constant.dart';
import 'package:pos_account/ln.dart';
import 'package:pos_account/model/common/table_location.dart';
import 'package:pos_account/model/home/menu/place_order/place_order_req.dart';
import 'package:pos_account/model/home/menu/place_order/pos_res/com/feature_product.dart';
import 'package:pos_account/providers/cus_val_pro.dart';
import 'package:pos_account/providers/menu/place_order_pro.dart';
import 'package:pos_account/providers/menu/pos_retail_pro.dart';
import 'package:pos_account/providers/menu/raw_ingre_pro.dart';
import 'package:pos_account/repository/if_exception.dart';
import 'package:pos_account/screens/home_screen/com/items/com/price_dis_up_dia.dart';
import 'package:pos_account/screens/home_screen/com/items/com/price_update_dia.dart';
import 'package:pos_account/screens/home_screen/com/items/tabs/pos_tab/pos_non_retail/com/combo/combo_dia.dart';
import 'package:pos_account/screens/home_screen/com/items/tabs/pos_tab/pos_non_retail/com/deal/deal_dia.dart';
import 'package:pos_account/screens/home_screen/com/items/tabs/pos_tab/pos_non_retail/com/half_half_2/half_half_dia.dart';
import 'package:pos_account/screens/home_screen/com/items/tabs/pos_tab/pos_non_retail/com/raw_ingre/raw_ingre_dia.dart';
import 'package:pos_account/screens/home_screen/com/items/tabs/pos_tab/pos_non_retail/com/set_menu_item.dart';
import 'package:pos_account/widgets/dialog/confirm_dialog.dart';
import 'package:pos_account/widgets/load_btn.dart';
import 'package:pos_account/widgets/input/text_form/text_form_widget.dart';
import 'package:provider/provider.dart';
import '../../../../../../../widgets/dialog/custom_dialog.dart';
import '../../../tabs/pos_tab/product_detail_dia.dart';
import 'item_detail.dart';
import 'order_total.dart';

class OrderItems extends StatelessWidget {
  final Function(bool)? onClickBtn;
  final PlaceOrderPro placeOrderPro;
  final PosRetailPro? posRetailPro;
  const OrderItems({
    super.key,
    this.onClickBtn,
    required this.placeOrderPro,
    this.posRetailPro,
  });

  List<ProductVariationModifier> _preModiList({
    List<OrderItemsPriceModifierViewModel>? orderItemsPriceModifierViewModels,
    double itemQty = 1,
  }) {
    final _varList = <ProductVariationModifier>[];

    if (orderItemsPriceModifierViewModels != null)
      for (final a in orderItemsPriceModifierViewModels) {
        //  print("${a.modifierName} ${a.isActive} || ${a.quantity} || $itemQty");
        final _varData = ModifierItem(
          id: a.priceVariationModifierId,
          actualPrice: a.modifierPrice?.roundToNString(),
          productName: a.modifierName,
          isActive: a.isActive,
          updateId: a.id ?? '',
          quantity:
              a.isActive ? ((a.quantity ?? 1) / itemQty) : (a.quantity ?? 1),
          halfItemPrice: (a.isDealsHalf ?? false) ? a.modifierPrice : null,
        );
        // if (a.isActive)
        //   kPrint(
        //       "${_varData.productName} || ${a.isDealsHalf} || ${_varData.actualPrice} || ${_varData.halfItemPrice}");

        final _moreModi = _preModiList(
            orderItemsPriceModifierViewModels:
                a.modifierItemsModifierViewModels,
            itemQty: itemQty);

        if (_varList.any((b) => b.name == a.labelName)) {
          _varList
              .firstWhere((c) => c.name == a.labelName)
              .modifierItems
              ?.add(_varData..modifierItemModifiers = _moreModi);
        } else {
          _varList.add(ProductVariationModifier(
            name: a.labelName,
            type: a.type,
            modifierItems: [_varData..modifierItemModifiers = _moreModi],
          ));
        }
      }

    return _varList;
  }

  selectVarience(BuildContext context, {required int orderDetailIndex}) async {
    // if (placeOrderPro.itemViewList.isEmpty) return;
    final _orderDetail = placeOrderPro.orderList[orderDetailIndex];
    _orderDetail.curSym = placeOrderPro.curSym ?? '';
    placeOrderPro.productDetailView = null;

    final _varList = <ProductVariationModifier>[];

    _varList.addAll(_preModiList(
      orderItemsPriceModifierViewModels:
          _orderDetail.orderItemModifiersViewModels,
      itemQty: _orderDetail.initQty,
    ));

    // for (final a in _varList) {
    //   kPrint("${a.name} ${a.modifierItems?.first?.halfItemPrice")
    // }

    final _product = FeaturedProduct(
        id: _orderDetail.productId,
        varId: _orderDetail.productVariationId,
        categoryId: _orderDetail.catId,
        name: _orderDetail.productName,
        productVariationName: _orderDetail.productVariationName,
        productDescription: _orderDetail.description,
        // taxExclusiveInclusiveType:
        //     Utils.getTaxTypeString(_orderDetail.taxType),
        salesTax: _orderDetail.taxPercent.toString(),
        imageUrl: _orderDetail.imgPath,
        quantity: _orderDetail.quantity ?? 1,
        // selectedSpiceId:
        //     _orderDetail.orderItemSpiceChoiceViewModel?.spiceChoiceId,
        // spiceUpdateId: _orderDetail.orderItemSpiceChoiceViewModel?.id,
        productType: _orderDetail.productType,
        productPriceType: _orderDetail.productPriceType,
        taxRuleIndex: _orderDetail.taxRuleIndex,
        preparationType: _orderDetail.preparationType,
        productVariations: [
          ProductVariation(
              id: _orderDetail.productVariationId,
              name: _orderDetail.productVariationName,
              isDefault: true,
              discount: _orderDetail.discountWithTax,
              discountedPrice: ((_orderDetail.actualPrice?.inDouble ?? 0) -
                      (_orderDetail.discountWithTax?.inDouble ?? 0))
                  .formatDouble,
              discountPercentage: _orderDetail.discountPercentage,
              // actualPrice:

              //     _orderDetail.productPrice?.roundToNString(),
              unitPrice: _orderDetail.unitCost,
              actualPrice: _orderDetail.actualPrice,
              stockCount: _orderDetail.stockCount.toString(),
              // outOfStockMessage: //TODO: stock count for updating order

              productVariationModifiers: _varList,
              // productIngredients:
              //     _orderDetail.removedOrderItemsIngredientsViewModels
              //         ?.map((e) => ProductIngredient(
              //               id: e.id,
              //               name: e.name,
              //               isActive: e.isActive,
              //             ))
              //         .toList(),
              productVariationBatchStocks: [
                ProductVariationBatchStock(
                  batchNumber: _orderDetail.batchNumber,
                  isActive: true,
                ),
              ],
              productVariationServiceEmployees:
                  _orderDetail.orderItemsServiceEmployeeViewModels
                      ?.map((e) => ProductSpiceChoice(
                            updateId: e.id,
                            id: e.employeeId,
                            isSelected: e.isSelected,
                          ))
                      .toList())
        ]);

    final _prodType = OrderUtils.prodType(_orderDetail.productType);
    final _prodPriceType =
        OrderUtils.productPriceType(_orderDetail.productPriceType);

    FeaturedProduct? _retailProduct;

    if (GlobalCVP.isRetailStore) {
      final _retailPro = Provider.of<PosRetailPro>(context, listen: false);

      _retailProduct = await _retailPro.getProductData(_product.id,
          orderTypeIndex: placeOrderPro.orderTypeIndex);
    }

    // if (_prodType == ProductType.Combo &&
    //     _prodPriceType != ProductPriceType.MakeYourOwn) {
    //   placeOrderPro.getProductData(
    //     _product.id,
    //     featuredProduct: _product,
    //     isPosTab: false,
    //     retailProduct: _retailProduct,
    //   );
    // } else {
    placeOrderPro.getProductData(
      _product.id,
      featuredProduct: _product,
      isPosTab: false,
      retailProduct: _retailProduct,
    );
    // }

    return showDialog(
        context: context,
        barrierDismissible: true,
        builder: (builder) => SimpleDialog(
              // backgroundColor: kSecondaryColor,
              titlePadding: EdgeInsets.zero,
              contentPadding: EdgeInsets.zero,
              insetPadding: _prodType == ProductType.Combo ||
                      _prodType == ProductType.Half
                  ? EdgeInsets.zero
                  : EdgeInsets.symmetric(horizontal: 40.0, vertical: 24.0),

              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15)),
              children: [
                if (_prodType == ProductType.Half)
                  HalfnHalfDia(
                    // id: _orderDetail.productId ?? '',
                    upIndex: orderDetailIndex,
                    product: _product,
                  )
                else if (_prodType == ProductType.Combo) ...[
                  if (_prodPriceType == ProductPriceType.MakeYourOwn)
                    DealDia(
                      upIndex: orderDetailIndex,
                      product: _product,
                    )
                  else
                    ComboNewDia(
                      upIndex: orderDetailIndex,
                      product: _product,
                    )
                ] else
                  ProductDetailDia(
                    product: _product,
                    // catTypeId: _orderDetail.categoryTypeId,
                    curSym: _orderDetail.curSym,
                    orderDetailIndex: orderDetailIndex,
                    quantity: _orderDetail.quantity ?? 1,
                    uniqueKey: _orderDetail.key,
                    // modifierList: _orderDetail.orderItemsPriceModifierViewModels,
                    // modifierIds:
                    //     _orderDetail.orderItemsPriceModifierViewModels == null
                    //         ? []
                    //         : _orderDetail.orderItemsPriceModifierViewModels!
                    //             .map((e) => e.priceVariationModifierId ?? '')
                    //             .toList(),
                    filterTypeList:
                        _orderDetail.orderItemSelectOptionsViewModels,
                  ),
              ],
            ));
  }

  onSelectSetMenu(BuildContext context, {required int index}) {
    placeOrderPro.loading = true;
    return showDialog(
        context: context,
        builder: (builder) => SimpleDialog(
              backgroundColor: kBackgroundColor,
              titlePadding: EdgeInsets.zero,
              contentPadding:
                  EdgeInsets.symmetric(horizontal: 24, vertical: 24),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15)),
              children: [
                SetMenuDialog(
                  setMenuId: placeOrderPro.setMenuList[index].setMenuId ?? '',
                  upIndex: index,
                )
              ],
            )).then((_) {
      placeOrderPro.comboDetailById = null;
      // Future.delayed(Duration(milliseconds: 300), () {
      //   if (placeOrderPro.initRes?.setMenus != null &&
      //       placeOrderPro.initRes!.setMenus!
      //           .any((e) => e.id?.toLowerCase() == setMenu.id?.toLowerCase())) {
      //     final setmenu = placeOrderPro.initRes!.setMenus!.firstWhere(
      //         (e) => e.id?.toLowerCase() == setMenu.id?.toLowerCase());

      //     setmenu.quantity = 1;
      //     if (setmenu.setMenuProductListViewModelWithCategory != null)
      //       for (final a in setmenu.setMenuProductListViewModelWithCategory!) {
      //         if (a.setMenuProductListViewModels != null)
      //           for (final b in a.setMenuProductListViewModels!) {
      //             b.isSelected = false;
      //           }
      //       }
      //     placeOrderPro.notify;
      //   }
      // });
    });
  }

  Future<void> selectIngre(BuildContext context, {required int index}) async {
    final _ingre = placeOrderPro.ingreList[index];

    final _ingreViewList = GlobalCVP.isRetailStore
        ? (posRetailPro?.ingreViewList ?? [])
        : placeOrderPro.ingreViewList;

    final _serverIngre = (_ingreViewList.any((e) =>
            e.id?.toLowerCase() == _ingre.rawIngredientId?.toLowerCase()))
        ? _ingreViewList.firstWhere(
            (e) => e.id?.toLowerCase() == _ingre.rawIngredientId?.toLowerCase())
        : null;

    final _rawPro = Provider.of<RawIngrePro>(context, listen: false);
    _rawPro.maxValueCltr.text = _ingre.quantity?.roundToNString() ?? '';

    _rawPro.onChange(
      data: _rawPro.maxValueCltr.text,
      maxToMinConFactor: _serverIngre
          ?.maxToMinConversionFactor, // _ingre.maxToMinConversionFactor
      isFirstText: false,
    );
    await showDialog(
        context: context,
        builder: (_) {
          return SimpleDialog(
            contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            children: [
              RawIngreDia(
                rawIngredient: _serverIngre,
                curSym: placeOrderPro.curSym,
                upIndex: index,
              )
            ],
          );
        });
  }

  updateOrderQuantity(
    BuildContext context,
    int i,
    bool _outOfStock, {
    bool? p0,
    bool qtyUpdate = true,
  }) async {
    // log(json.encode(placeOrderPro.orderList[i].toJson()));

    double _quantity = placeOrderPro.orderList[i].quantity ?? 1;
    final _oldQty = placeOrderPro.orderList[i].quantity ?? 1;

    final _paidQty = placeOrderPro.orderList[i].paymentType == 2 &&
            placeOrderPro.orderList[i].partialPayQty > 0
        ? placeOrderPro.orderList[i].partialPayQty
        : null;

    if (p0 != null) {
      if (p0) {
        if (_outOfStock) return;
        // if (_quantity == 0.5) {
        //   _quantity = 1;
        // } else {
        _quantity++;

        // }
      } else {
        // if (_quantity == 1) {
        //   _quantity = 0.5;
        // } else {
        if (_paidQty != null) {
          if (_quantity > _paidQty) {
            _quantity--;
          }
        } else {
          if (_quantity < 2) return;
          _quantity--;
        }
        // }
      }
    } else {
      if (_outOfStock) return;
      if (qtyUpdate) {
        _quantity = await PriceUpdateDia.showDia<int>(CUS_CTX!,
            number: _quantity, title: LN.quantity);
        if (_paidQty != null && _quantity < _paidQty) {
          _quantity = _paidQty;
        }
      }
      // Utils.textQty(_quantity);
    }
    _quantity = _quantity.roundToN(n: 0);

    final _prodType =
        OrderUtils.prodType(placeOrderPro.orderList[i].productType);
    final _prodPriceType = OrderUtils.productPriceType(
        placeOrderPro.orderList[i].productPriceType);

    final isHalfnHalf = _prodType == ProductType.Half;

    final _isDeal = _prodType == ProductType.Combo &&
        _prodPriceType == ProductPriceType.MakeYourOwn;

    final _finalItemPrice = (placeOrderPro.orderList[i].id?.isNotEmpty ?? false)
        ? placeOrderPro.orderList[i].productPrice?.toString()
        : isHalfnHalf || _isDeal
            ? placeOrderPro.orderList[i].productPrice?.toString()
            // : ((placeOrderPro.orderList[i].promDiscount?.isOfferStart ??
            //             false) &&
            //         (placeOrderPro
            //                     .orderList[i].promDiscount?.tsCount?.inDouble ??
            //                 0) <=
            //             _quantity)
            //     ? placeOrderPro.orderList[i].promDiscount?.discountedPrice
            : (placeOrderPro.orderList[i].nonPromPrice ??
                placeOrderPro.orderList[i].productPrice?.toString());

    final _amount = OrderUtils.getAmount(
      taxTypeString: placeOrderPro.taxExclusiveInclusiveType,
      taxPercent: placeOrderPro.orderList[i].taxPercent.toString(),
      price: _finalItemPrice,
      quantity: _quantity,
      actualPrice: placeOrderPro.orderList[i].actualPrice,
      orderTypeId: placeOrderPro.orderTypeId,
      taxRules: placeOrderPro.orderList[i].taxRules,
      taxRuleIndex: placeOrderPro.orderList[i].taxRuleIndex,
      isNoTax: placeOrderPro.orderList[i].isTaxExempt,
      // discountPercent: placeOrderPro.orderList[i].discountPercentage,
    );

    placeOrderPro.orderList[i].productPrice = _amount.itemPrice;
    placeOrderPro.orderList[i].quantity = _quantity;
    placeOrderPro.orderList[i].initQty = _quantity;
    placeOrderPro.orderList[i].total = _amount.totalPrice;
    placeOrderPro.orderList[i].totalTax = _amount.totalTax.roundToNString();
    placeOrderPro.orderList[i].taxPercent = _amount.taxPercent;

    placeOrderPro.orderList[i].originalSellingAmount =
        _amount.itemPrice.roundToNString();
    placeOrderPro.orderList[i].discountWithoutTax =
        _amount.discount.roundToNString();
    placeOrderPro.orderList[i].discountWithTax =
        _amount.discountWithTax.roundToNString();
    placeOrderPro.orderList[i].totalTax = _amount.totalTax.roundToNString();
    // placeOrderPro.orderList[i].hideTotal = false;

    if (placeOrderPro.orderList[i].orderItemModifiersViewModels != null) {
      placeOrderPro.orderList[i].orderItemModifiersViewModels?.forEach((a) {
        final _modifierAmount = OrderUtils.getAmount(
          taxTypeString: placeOrderPro.taxExclusiveInclusiveType,
          taxPercent: placeOrderPro.orderList[i].taxPercent.toString(),
          price: a.modifierPrice.toString(),
          quantity: a.isActive
              ? (a.quantity ?? 1) * _quantity / _oldQty
              : (a.quantity ?? 1),
          orderTypeId: placeOrderPro.orderTypeId,
          taxRules: a.taxRules,
          taxRuleIndex: placeOrderPro.orderList[i].taxRuleIndex,
          isNoTax: a.isTaxExempt,
        );

        // if (a.isActive) print("${a.quantity} * $_quantity / $_oldQty");

        a.quantity =
            a.isActive ? (a.quantity ?? 1) * _quantity / _oldQty : a.quantity;
        // a.initQty =
        a.totalTax = _modifierAmount.totalTax;
        a.totalModifierPrice = _modifierAmount.totalPrice;

        a.modifierItemsModifierViewModels?.forEach((b) {
          if (b.isActive) kPrint('${b.modifierName}');

          final _deepModiAmt = OrderUtils.getAmount(
            taxTypeString: placeOrderPro.taxExclusiveInclusiveType,
            taxPercent: placeOrderPro.orderList[i].taxPercent.toString(),
            price: b.modifierPrice.toString(),
            quantity: b.isActive
                ? (b.quantity ?? 1) * _quantity / _oldQty
                : (b.quantity ?? 1),
            orderTypeId: placeOrderPro.orderTypeId,
            taxRules: b.taxRules,
            taxRuleIndex: placeOrderPro.orderList[i].taxRuleIndex,
            isNoTax: b.isTaxExempt,
          );

          b.quantity =
              b.isActive ? (b.quantity ?? 1) * _quantity / _oldQty : b.quantity;
          b.totalTax = _deepModiAmt.totalTax;
          b.totalModifierPrice = _deepModiAmt.totalPrice;

          b.modifierItemsModifierViewModels?.forEach((c) {
            final _dealModiAmt = OrderUtils.getAmount(
              taxTypeString: placeOrderPro.taxExclusiveInclusiveType,
              taxPercent: placeOrderPro.orderList[i].taxPercent.toString(),
              price: c.modifierPrice.toString(),
              quantity: c.isActive
                  ? (c.quantity ?? 1) * _quantity / _oldQty
                  : (c.quantity ?? 1),
            );

            c.quantity = c.isActive
                ? (c.quantity ?? 1) * _quantity / _oldQty
                : c.quantity;
            c.totalTax = _dealModiAmt.totalTax;
            c.totalModifierPrice = _dealModiAmt.totalPrice;
          });
        });
      });
    }
    placeOrderPro.notify;
  }

  _onChangeOrderType() {
    for (final a in placeOrderPro.orderList) {
      final _amount = OrderUtils.getAmount(
        taxTypeString: placeOrderPro.taxExclusiveInclusiveType,
        taxPercent: a.taxPercent.toString(),
        price: a.productPrice.toString(),
        quantity: a.quantity,
        actualPrice: a.actualPrice,
        orderTypeId: placeOrderPro.orderTypeId,
        taxRules: a.taxRules,
        taxRuleIndex: a.taxRuleIndex,
        isNoTax: a.isTaxExempt,
      );

      // a.productPrice = _amount.itemPrice;
      a.total = _amount.totalPrice;
      a.totalTax = _amount.totalTax.roundToNString();
      a.taxPercent = _amount.taxPercent;

      // a.originalSellingAmount =
      //     _amount.itemPrice.roundToNString();
      a.discountWithoutTax = _amount.discount.roundToNString();
      a.discountWithTax = _amount.discountWithTax.roundToNString();
      a.totalTax = _amount.totalTax.roundToNString();

      if (a.orderItemModifiersViewModels != null) {
        a.orderItemModifiersViewModels?.forEach((b) {
          final _modifierAmount = OrderUtils.getAmount(
            taxTypeString: placeOrderPro.taxExclusiveInclusiveType,
            taxPercent: b.taxPercent,
            price: b.modifierPrice.toString(),
            quantity: b.quantity ?? 1,
            orderTypeId: placeOrderPro.orderTypeId,
            taxRules: b.taxRules,
            taxRuleIndex: a.taxRuleIndex,
            isNoTax: b.isTaxExempt,
          );

          // if (a.isActive) print("${a.quantity} * $_quantity / $_oldQty");

          // a.quantity =
          //     a.isActive ? (a.quantity ?? 1) * _quantity / _oldQty : a.quantity;
          // a.initQty =
          b.totalTax = _modifierAmount.totalTax;
          b.totalModifierPrice = _modifierAmount.totalPrice;

          b.modifierItemsModifierViewModels?.forEach((c) {
            final _deepModiAmt = OrderUtils.getAmount(
              taxTypeString: placeOrderPro.taxExclusiveInclusiveType,
              taxPercent: c.taxPercent,
              price: c.modifierPrice.toString(),
              quantity: c.quantity ?? 1,
              orderTypeId: placeOrderPro.orderTypeId,
              taxRules: c.taxRules,
              taxRuleIndex: a.taxRuleIndex,
              isNoTax: c.isTaxExempt,
            );

            // c.quantity =
            //     b.isActive ? (b.quantity ?? 1) * _quantity / _oldQty : b.quantity;
            c.totalTax = _deepModiAmt.totalTax;
            c.totalModifierPrice = _deepModiAmt.totalPrice;
          });
        });
      }
    }

    // placeOrderPro.manageHalfOrder();
    placeOrderPro.notify;
  }

  updateSetmenuQty(
    int i, {
    bool? p0,
    bool qtyUpdate = true,
  }) async {
    int _quantity = placeOrderPro.setMenuList[i].setMenuQuantity ?? 1;
    if (p0 != null) {
      if (p0) {
        _quantity++;
      } else {
        if (_quantity < 2) return;
        _quantity--;
      }
    } else {
      if (qtyUpdate) {
        _quantity = (await PriceUpdateDia.showDia<int>(CUS_CTX!,
                number: _quantity.toDouble(), title: LN.quantity))
            .toInt();
      }
    }
    final _amount = OrderUtils.getAmount(
      taxTypeString: placeOrderPro.taxExclusiveInclusiveType,
      taxPercent: placeOrderPro.setMenuList[i].taxPercent.toString(),
      price: placeOrderPro.setMenuList[i].setMenuPrice.toString(),
      quantity: _quantity.toDouble(),
      actualPrice: placeOrderPro.setMenuList[i].actualPrice,
      // discountPercent: placeOrderPro.setMenuList[i].discountPercentage,
    );
    placeOrderPro.setMenuList[i].setMenuQuantity = _quantity;
    placeOrderPro.setMenuList[i].initQty = _quantity;
    placeOrderPro.setMenuList[i].totalSetMenuPrice =
        _quantity * _amount.itemPrice;
    placeOrderPro.setMenuList[i].taxPercent = _amount.taxPercent;
    placeOrderPro.setMenuList[i].orderItemsViewModels?.forEach((a) {
      a.quantity = _quantity.toString();
      a.orderItemsPriceModifierViewModels?.forEach((b) {
        final _mA = OrderUtils.getAmount(
          taxTypeString: placeOrderPro.taxExclusiveInclusiveType,
          taxPercent: placeOrderPro.setMenuList[i].taxPercent.toString(),
          price: b.modifierPrice.toString(),
          quantity: b.quantity,
        );

        // b.quantity = _quantity.toDouble();
        b.totalModifierPrice = _mA.totalPrice;
        b.totalTax = _mA.totalTax;
      });
    });

    placeOrderPro.setMenuList[i].originalSellingAmount =
        _amount.itemPrice.roundToNString();
    placeOrderPro.setMenuList[i].discountWithoutTax =
        _amount.discount.roundToNString();
    placeOrderPro.setMenuList[i].discountWithTax =
        _amount.discountWithTax.roundToNString();
    placeOrderPro.setMenuList[i].totalTax = _amount.totalTax.roundToNString();

    placeOrderPro.notify;
  }

  void updateIngreQty(
    int i,
    bool _outOfStock, {
    bool? p0,
    bool qtyUpdate = true,
  }) async {
    double _quantity = placeOrderPro.ingreList[i].quantity ?? 1;
    if (p0 != null) {
      if (p0) {
        if (_outOfStock) return;

        _quantity++;
      } else {
        final diff = (placeOrderPro.ingreList[i].initQty - _quantity).abs();
        if (diff > 0 && diff < 1) {
          _quantity = placeOrderPro.ingreList[i].initQty;
        } else if (_quantity < 1.001)
          return;
        else
          _quantity--;
      }
    } else {
      if (_outOfStock) return;
      // _quantity = await Utils.textQty(_quantity);
      if (qtyUpdate) {
        _quantity = await PriceUpdateDia.showDia<double>(CUS_CTX!,
            number: _quantity, title: LN.quantity);
      }
    }

    _quantity = _quantity.roundToN(n: 3);

    final _amount = OrderUtils.getAmount(
      taxTypeString: placeOrderPro.taxExclusiveInclusiveType,
      taxPercent: placeOrderPro.ingreList[i].taxPercent.roundToNString(),
      price: placeOrderPro.ingreList[i].originalSellingPricePerUnit
          ?.roundToNString(),
      quantity: _quantity,
    );

    placeOrderPro.ingreList[i].quantity = _quantity;
    placeOrderPro.ingreList[i].totalTax = _amount.totalTax.roundToNString();
    placeOrderPro.ingreList[i].totalSellingPrice =
        _amount.totalPrice.roundToNString();
    placeOrderPro.notify;
  }

  List<String> _modiList({
    List<OrderItemsPriceModifierViewModel>? orderItemsPriceModifierViewModels,
    double itemQty = 1,
  }) {
    String _labelName = "";
    final _modifiers = <String>[];
    if (orderItemsPriceModifierViewModels != null)
      for (final m in orderItemsPriceModifierViewModels) {
        if (m.isActive && (m.modifierName?.isNotEmpty ?? false)) {
          String _modifierText = "";
          final _modiType = OrderUtils.getModifierType(m.type);
          final _hidePrice =
              ((m.isHalforCombo ?? false) && !(m.isDealModifier ?? false)) ||
                  _modiType == ModifierType.rawingre;

          if (_labelName != m.labelName) {
            _labelName = m.labelName ?? '';
            _modifierText = "$_labelName\n";
          }
          // kPrint("${m.modifierName} ${m.type}");
          final _qtyString = ((m.quantity ?? 0.0) / itemQty).formatDouble;
          final _totalString =
              ((m.totalModifierPrice ?? 0) / itemQty).formatDouble;
          _modifierText +=
              " ${_modiType == ModifierType.rawingre ? '-' : '+'} ${_hidePrice ? '' : '$_qtyString x '}${m.modifierName!}${m.variationName?.trim().isNotEmpty ?? false ? ' (${m.variationName})' : ''} ${_hidePrice ? '' : '(${placeOrderPro.curSym}$_totalString)${itemQty != 1 ? ' (each)' : ''}'}";
          _modifiers.add(_modifierText);

          if (_hidePrice && m.modifierItemsModifierViewModels != null) {
            _modifiers.addAll(_modiList(
              orderItemsPriceModifierViewModels:
                  m.modifierItemsModifierViewModels!,
              itemQty: itemQty,
            ));
          }
        }
      }

    return _modifiers;
  }

  static final scrollCltr = ScrollController();

  // static final observerController =
  //     ListObserverController(controller: scrollCltr);

  @override
  Widget build(BuildContext context) {
    final size = Ssize(context);
    final _cartList = placeOrderPro.setMenuList
            .where((a) =>
                OrderUtils.getStatusEnum(a.statusId) != OrderStatusEnum.cancel)
            .toList()
            .length +
        placeOrderPro.orderList
            .where((a) =>
                OrderUtils.getStatusEnum(a.statusId) != OrderStatusEnum.cancel)
            .toList()
            .length +
        placeOrderPro.ingreList
            .where((a) =>
                OrderUtils.getStatusEnum(a.statusId) != OrderStatusEnum.cancel)
            .toList()
            .length;
    final _isLastItemOnCart = _cartList == 1 &&
        placeOrderPro.reOrder?.orderId != null &&
        !GlobalCVP.isRetailStore;

    // log(json.encode(placeOrderPro.orderList.first.toJson()));

    final _listOfAllItems = [
      ...List.generate(placeOrderPro.setMenuList.length, (i) {
        final _modifierPrice = placeOrderPro.setMenuList[i].orderItemsViewModels
                ?.fold<double>(
                    0,
                    (pV1, e1) =>
                        pV1 +
                        (e1.orderItemsPriceModifierViewModels?.fold<double>(
                                0,
                                (pV2, e2) =>
                                    pV2 +
                                    (e2.isActive
                                        ? (e2.modifierPrice ?? 0) *
                                            (e2.quantity ?? 1)
                                        : 0)) ??
                            0)) ??
            0;

        final _itemPrice = (placeOrderPro.setMenuList[i].setMenuPrice ??
            0); // + _modifierPrice;

        final _disPercent =
            placeOrderPro.setMenuList[i].discountPercentage?.inDouble ?? 0;

        final _kitStatusEnum = OrderUtils.getItemStatusEnum(
            placeOrderPro.setMenuList[i].kitchenStatus);

        final _statusEnum =
            OrderUtils.getStatusEnum(placeOrderPro.setMenuList[i].statusId);
        if (_statusEnum == OrderStatusEnum.cancel)
          return SizedBox.shrink();
        else
          return _disableSection(
            readOnly: placeOrderPro.setMenuList[i].disabled,
            child: SwipeActionCell(
              key: ValueKey("${placeOrderPro.setMenuList[i].setMenuId}$i"),
              backgroundColor: Colors.white,
              trailingActions: [
                SwipeAction(
                    performsFirstActionWithFullSwipe: true,
                    icon: Center(
                      child: Icon(
                        Icons.delete,
                        color: Colors.white,
                        size: size.getS(25),
                      ),
                    ),
                    onTap: (CompletionHandler handler) async {
                      handler(false);
                      if (( //GlobalCVP.isHospitality &&
                          placeOrderPro.reOrder?.orderId != null &&
                              placeOrderPro.setMenuList[i].id != null)) {
                        if (!GlobalCVP.viewWidget.deleteOrderItem) {
                          return CustomDialog.showPermissionErrorDialog(
                            context: context,
                          );
                        }
                        showDialog(
                            context: context,
                            builder: (_) => ConfirmDialog(
                                title:
                                    "${LN.cancel} '${placeOrderPro.setMenuList[i].setMenuName ?? ''}'?",
                                titleSize: 18,
                                subTitle:
                                    "Are you sure to cancel ${placeOrderPro.setMenuList[i].setMenuName ?? ''} ?",
                                actionText: LN.cancel,
                                cancelText: LN.no,
                                onDelete: () async {
                                  _setmenuOnDelete(i, ctx: context);
                                  return null;
                                },
                                bottomRightWidget: _isLastItemOnCart
                                    ? ElevatedButton(
                                        style: ButtonStyle(
                                            backgroundColor:
                                                MaterialStateProperty.all(
                                                    kTempColor),
                                            padding: MaterialStateProperty.all(
                                                EdgeInsets.symmetric(
                                                    horizontal: size.getW(12),
                                                    vertical: size.getH(8)))),
                                        onPressed: () {
                                          _setmenuOnDelete(i,
                                              isSentToKt: true, ctx: context);
                                          Navigator.pop(context);
                                        },
                                        child: Text(
                                          LN.cancelSendKitchen,
                                          style: TextStyle(
                                            fontSize: size.getS(15),
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ))
                                    : null));
                      } else {
                        _setmenuOnDelete(i, ctx: context);
                      }
                      // showDialog(
                      //     context: context,
                      //     builder: (_) => ConfirmDialog(
                      //           title:
                      //               "${LN.cancel} '${placeOrderPro.setMenuList[i].setMenuName ?? ''}'?",
                      //           titleSize: 18,
                      //           subTitle:
                      //               "${LN.areYouSureCancel} ${placeOrderPro.setMenuList[i].setMenuName ?? ''} ?",
                      //           actionText: LN.cancel,
                      //           onDelete: () async {
                      //             _setmenuOnDelete(i);
                      //             return null;
                      //           },
                      //           cancelText: LN.no,
                      //         ));
                    },
                    color: Colors.red),
              ],
              child: ItemDetail(
                orderListIndex: i,
                docketGroupList: placeOrderPro.initAddSec?.docketGroups ?? [],
                docketGroupName: placeOrderPro.setMenuList[i].docketGroupName,
                statusEnum: _statusEnum,
                imgPath: placeOrderPro.setMenuList[i].imgPath,
                title: (placeOrderPro.setMenuList[i].setMenuName ?? '') +
                    (_disPercent == 0
                        ? ''
                        : ' (${_disPercent.formatDouble}% OFF)'),
                curSym: placeOrderPro.curSym,
                price: _itemPrice,
                quantity:
                    placeOrderPro.setMenuList[i].setMenuQuantity?.toDouble() ??
                        1.0,
                total: (_itemPrice *
                        (placeOrderPro.setMenuList[i].setMenuQuantity ?? 1)) +
                    _modifierPrice,
                //  placeOrderPro.setMenuList[i].totalSetMenuPrice,
                updateQtyDown: () =>
                    updateSetmenuQty(i, p0: false, qtyUpdate: false),
                updateQtyUp: () =>
                    updateSetmenuQty(i, p0: true, qtyUpdate: false),
                onTapQty: () => updateSetmenuQty(i, p0: null, qtyUpdate: true),
                onTapPrice: GlobalCVP.viewWidget.viewChangePriceText
                    ? () => PriceUpdateDia.showDia(
                          context,
                          number: placeOrderPro.setMenuList[i].setMenuPrice,
                        ).then((value) {
                          // if (value is double) {
                          placeOrderPro.setMenuList[i].setMenuPrice = value;
                          updateSetmenuQty(i);
                          // }
                        })
                    : null,
                onDelete:
                    //  placeOrderPro.loadCancelItem
                    //     ? null
                    //     :
                    () {
                  showDialog(
                      context: context,
                      builder: (_) => ConfirmDialog(
                          title:
                              "${LN.cancel} '${placeOrderPro.setMenuList[i].setMenuName ?? ''}'?",
                          titleSize: 18,
                          subTitle:
                              "Are you sure to cancel ${placeOrderPro.setMenuList[i].setMenuName ?? ''} ?",
                          actionText: LN.cancel,
                          cancelText: LN.no,
                          onDelete: () async {
                            _setmenuOnDelete(i, ctx: context);
                            return null;
                          },
                          bottomRightWidget: _isLastItemOnCart
                              ? ElevatedButton(
                                  style: ButtonStyle(
                                      backgroundColor:
                                          MaterialStateProperty.all(kTempColor),
                                      padding: MaterialStateProperty.all(
                                          EdgeInsets.symmetric(
                                              horizontal: size.getW(12),
                                              vertical: size.getH(8)))),
                                  onPressed: () {
                                    _setmenuOnDelete(i,
                                        isSentToKt: true, ctx: context);
                                    Navigator.pop(context);
                                  },
                                  child: Text(
                                    LN.cancelSendKitchen,
                                    style: TextStyle(
                                      fontSize: size.getS(15),
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ))
                              : null));
                },
                descCltr: TextEditingController(
                    text: placeOrderPro.setMenuList[i].description),
                onChangedDesc: (String? val) {
                  if (val == null) return;
                  placeOrderPro.setMenuList[i].description = val;
                },
                onTap: () {
                  // if (placeOrderPro.comboDetailById != null)
                  onSelectSetMenu(
                    context,
                    index: i,
                    // setmenuDetail: placeOrderPro.setMenuList[i],
                  );
                },
                comboItem:
                    placeOrderPro.setMenuList[i].orderItemsViewModels?.map((e) {
                  List<String>? modifiers;

                  // modifiers

                  if (e.orderItemsPriceModifierViewModels != null) {
                    modifiers = [];
                    String labelName = "";

                    for (final m in e.orderItemsPriceModifierViewModels!) {
                      if (m.isActive && (m.modifierName?.isNotEmpty ?? false)) {
                        String modifierText = "";

                        if (labelName != m.labelName) {
                          labelName = m.labelName ?? '';
                          modifierText = "$labelName\n";
                        }
                        modifierText +=
                            " + ${m.quantity.formatDouble} x ${m.modifierName!} (${placeOrderPro.curSym}${(m.totalModifierPrice)?.roundToNString()})";
                        modifiers.add(modifierText);
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
                    title:
                        "${e.productName ?? ''} (${e.productVariationName ?? ''})",
                    modifier: modifiers,
                    ingredients: ingredients,
                    quantity: e.quantity,
                    rootName: LN.modifiers,
                  );
                }).toList(),
                itemStatus: (placeOrderPro.setMenuList[i].disabled) &&
                        ((placeOrderPro.setMenuList[i].currentPayQty != 0) ||
                            (placeOrderPro.setMenuList[i].partialPayQty != 0))
                    ? ItemStatus.PartialPaid
                    : placeOrderPro.setMenuList[i].disabled &&
                            placeOrderPro.setMenuList[i].paymentType == 2
                        ? ItemStatus.Paid
                        : _kitStatusEnum == ItemStatusEnum.preparing
                            ? ItemStatus.Preparing
                            : _kitStatusEnum == ItemStatusEnum.prepared
                                ? ItemStatus.Prepared
                                : ItemStatus.None,
                outOfStockMessage:
                    placeOrderPro.setMenuList[i].outOfStockMessage,
              ),
            ),
          );
      }),
      ...List.generate(placeOrderPro.orderList.length, (i) {
        final _prodType =
            OrderUtils.prodType(placeOrderPro.orderList[i].productType);
        final _isItem = _prodType == ProductType.Item;

        List<String>? _rootModifiers;

        // modifiers

        if (placeOrderPro.orderList[i].orderItemModifiersViewModels != null) {
          _rootModifiers = [];

          _rootModifiers.addAll(_modiList(
            orderItemsPriceModifierViewModels: placeOrderPro
                .orderList[i].orderItemModifiersViewModels
                ?.whereModiType2(ModifierType.modifier),
            itemQty: placeOrderPro.orderList[i].initQty,
          ));
        }

        final _modifierPrice = OrderUtils.allMTotal(
          modiList: placeOrderPro.orderList[i].orderItemModifiersViewModels
              ?.whereModiType2(ModifierType.modifier),
          // itemQty: placeOrderPro.orderList[i].quantity ?? 1,
          // initQty: placeOrderPro.orderList[i].initQty,
        );

        // log(json.encode(placeOrderPro.orderList[i].toJson()));

        //  placeOrderPro
        //     .orderList[i].orderItemsPriceModifierViewModels
        //     ?.fold<double>(
        //         0,
        //         (previousValue, element) =>
        //             previousValue +
        //             (element.isActive
        //                 ? (element.modifierPrice ?? 0) * (element.quantity ?? 1)
        //                 : 0));

        // ingredents

        List<String>? _ingredients;

        final _ingre = placeOrderPro.orderList[i].orderItemModifiersViewModels
            ?.whereModiType2(ModifierType.rawingre);

        if (_ingre != null) {
          _ingredients = [];
          for (final p in _ingre) {
            if (p.isActive) {
              _ingredients.add(p.modifierName ?? '');
            }
          }
        }

        final _spiceList = placeOrderPro
            .orderList[i].orderItemModifiersViewModels
            ?.whereModiType2(ModifierType.spice);

        ///

        final _itemPrice = (placeOrderPro.orderList[i].productPrice ?? 0);
        //  + (_modifierPrice ?? 0);

        final totalQuantity = placeOrderPro.orderList
                .any((b) => b.productId == placeOrderPro.orderList[i].productId)
            ? placeOrderPro.orderList
                .where(
                    (b) => b.productId == placeOrderPro.orderList[i].productId)
                .fold<double>(0, (x, y) => x + (y.quantity ?? 0.0))
            : 0;

        final isBatchEnable =
            (placeOrderPro.initAddSec?.storeInformation?.isBatch ?? false) ||
                (posRetailPro?.retailPosOrderRes?.storeInformation?.isBatch ??
                    false);

        final _outOfBatchStock = isBatchEnable &&
            placeOrderPro.orderList[i].batchStock != null &&
            (placeOrderPro.orderList[i].batchStock! <=
                    (placeOrderPro.orderList[i].quantity ?? 0) ||
                placeOrderPro.orderList[i].batchStock! <= totalQuantity);

        final _outOfStock = GlobalCVP.stockExceedRestriction &&
            !GlobalCVP.isHospitality &&
            ((placeOrderPro.orderList[i].stockCount != null &&
                    (placeOrderPro.orderList[i].stockCount! <
                            (placeOrderPro.orderList[i].quantity ?? 0) ||
                        placeOrderPro.orderList[i].stockCount! <
                            totalQuantity)) ||
                _outOfBatchStock);

        final docketGroupId = placeOrderPro.orderList[i].docketGroupId ==
                    null ||
                placeOrderPro.orderList[i].docketGroupId == ""
            ? placeOrderPro.initAddSec?.docketGroups
                ?.firstWhere(
                    (e) => e.name == placeOrderPro.orderList[i].docketGroupName,
                    orElse: () => TableLocation())
                .id
            : placeOrderPro.orderList[i].docketGroupId;

        placeOrderPro.orderList[i].docketGroupId = docketGroupId;

        final _disPercent =
            placeOrderPro.orderList[i].discountPercentage?.inDouble ?? 0;

        final _statusEnum =
            OrderUtils.getStatusEnum(placeOrderPro.orderList[i].statusId);

        final _kitStatusEnum = OrderUtils.getItemStatusEnum(
            placeOrderPro.orderList[i].kitchenStatus);

        // final _hasModiOfCombo =
        //     placeOrderPro.orderList[i].orderItemModifiersViewModels?.any((x) =>
        //             x.modifierItemsModifierViewModels?.any((y) => y.isActive) ??
        //             false) ??
        //         false;
        // final _disableQtyUpdate = false;

        //  ((_modifiers?.isNotEmpty ?? false) &&
        //         _prodType == ProductType.Item) ||
        //     (_prodType == ProductType.Combo && _hasModiOfCombo) ||
        //     _prodType == ProductType.Half;

        final _partialDisabled = placeOrderPro.orderList[i].paymentType == 2 &&
            placeOrderPro.orderList[i].partialPayQty > 0;
        // kPrint(
        //     "_partialDisabled: $_partialDisabled ::: ${placeOrderPro.orderList[i].partialPayQty}");

        if (_statusEnum == OrderStatusEnum.cancel)
          return SizedBox.shrink();
        else
          return SwipeActionCell(
            key: ValueKey("${placeOrderPro.orderList[i].productId}$i"),
            backgroundColor: Colors.white,
            trailingActions: placeOrderPro.orderList[i].disabled ||
                    _partialDisabled
                ? []
                : [
                    SwipeAction(
                        // performsFirstActionWithFullSwipe: true,
                        icon: Column(
                          children: [
                            Icon(
                              Icons.delete,
                              color: Colors.white,
                              size: size.getS(25),
                            ),
                            SizedBox(height: size.getH(4)),
                            Text(
                              (placeOrderPro.orderList[i].id?.isNotEmpty ??
                                      false)
                                  ? "Cancel"
                                  : "Remove",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: size.getS(14),
                                fontFamily: kFontFMedium,
                              ),
                            ),
                          ],
                        ),
                        onTap: (CompletionHandler handler) async {
                          handler(false);
                          if (( //GlobalCVP.isHospitality &&
                              placeOrderPro.reOrder?.orderId != null &&
                                  placeOrderPro.orderList[i].id != null)) {
                            if (!GlobalCVP.viewWidget.deleteOrderItem) {
                              return CustomDialog.showPermissionErrorDialog(
                                context: context,
                              );
                            }
                            showDialog(
                                context: context,
                                builder: (_) => ConfirmDialog(
                                    title:
                                        "${LN.cancel} '${placeOrderPro.orderList[i].productName ?? ''}'?",
                                    titleSize: 18,
                                    subTitle:
                                        "${LN.areYouSureCancel} ${placeOrderPro.orderList[i].productName ?? ''} ?",
                                    actionText: LN.cancel,
                                    onDelete: () async {
                                      _orderOnDelete(i, ctx: context);
                                      return null;
                                    },
                                    cancelText: LN.no,
                                    bottomRightWidget: _isLastItemOnCart
                                        ? ElevatedButton(
                                            style: ButtonStyle(
                                                backgroundColor:
                                                    MaterialStateProperty.all(
                                                        kTempColor),
                                                padding:
                                                    MaterialStateProperty.all(
                                                        EdgeInsets.symmetric(
                                                            horizontal:
                                                                size.getW(12),
                                                            vertical:
                                                                size.getH(8)))),
                                            onPressed: () {
                                              _orderOnDelete(i,
                                                  isSentToKt: true,
                                                  ctx: context);
                                              Navigator.pop(context);
                                            },
                                            child: Text(
                                              LN.cancelSendKitchen,
                                              style: TextStyle(
                                                fontSize: size.getS(15),
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ))
                                        : null));
                          } else
                            _orderOnDelete(i, ctx: context);
                        },
                        color: Colors.red),
                    if (GlobalCVP.isHospitality)
                      SwipeAction(
                          // performsFirstActionWithFullSwipe: true,
                          icon: Column(
                            children: [
                              Icon(
                                _statusEnum == OrderStatusEnum.hold
                                    ? Icons.play_arrow
                                    : Icons.pause,
                                color: Colors.white,
                                size: size.getS(25),
                              ),
                              SizedBox(height: size.getH(4)),
                              Text(
                                _statusEnum == OrderStatusEnum.hold
                                    ? "Release"
                                    : "Hold",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: size.getS(14),
                                  fontFamily: kFontFMedium,
                                ),
                              ),
                            ],
                          ),
                          onTap: (CompletionHandler handler) async {
                            handler(false);
                            showDialog(
                                context: context,
                                builder: (_) => ConfirmDialog(
                                      title:
                                          "${_statusEnum == OrderStatusEnum.hold ? "Release" : "Hold"} '${placeOrderPro.orderList[i].productName ?? ''}'?",
                                      titleSize: 18,
                                      subTitle:
                                          "Are you sure you want to ${_statusEnum == OrderStatusEnum.hold ? "release" : "hold"} ${placeOrderPro.orderList[i].productName ?? ''} ?",
                                      actionText:
                                          _statusEnum == OrderStatusEnum.hold
                                              ? "Release"
                                              : "Hold",
                                      onDelete: () async {
                                        if (placeOrderPro
                                                .orderList[i].id?.isNotEmpty ??
                                            false) {
                                          placeOrderPro.isAnyItemJustCancelled =
                                              true;
                                        }

                                        if (_statusEnum ==
                                            OrderStatusEnum.hold) {
                                          final _releaseId =
                                              OrderUtils.getStatusId(
                                                  OrderStatusEnum.release);
                                          placeOrderPro.orderList[i].statusId =
                                              _releaseId;
                                        } else if (_statusEnum ==
                                            OrderStatusEnum.release) {
                                          final _holdId =
                                              OrderUtils.getStatusId(
                                                  OrderStatusEnum.hold);
                                          placeOrderPro.orderList[i].statusId =
                                              _holdId;
                                        }

                                        placeOrderPro.notify;
                                        return null;
                                        // if (placeOrderPro.orderList[i].statusId
                                        //         ?.isNotEmpty ??
                                        //     false) {
                                        //   if (_statusEnum == OrderStatusEnum.hold) {
                                        //     if (placeOrderPro
                                        //             .orderList[i].id?.isNotEmpty ??
                                        //         false) {
                                        //       placeOrderPro.isAnyItemJustCancelled =
                                        //           true;
                                        //       placeOrderPro
                                        //               .orderList[i].prevStatusId =
                                        //           placeOrderPro
                                        //               .orderList[i].statusId;
                                        //       if (placeOrderPro.orderList[i]
                                        //               .prevStatusId?.isNotEmpty ??
                                        //           false) {
                                        //         final _releaseId =
                                        //             Utils.getStatusId(
                                        //                 OrderStatusEnum.release);
                                        //         placeOrderPro.orderList[i]
                                        //             .statusId = _releaseId;
                                        //       } else {
                                        //         placeOrderPro
                                        //             .orderList[i].statusId = "";
                                        //       }
                                        //     } else {
                                        //       placeOrderPro.orderList[i].statusId =
                                        //           "";
                                        //     }
                                        //   } else if (_statusEnum ==
                                        //       OrderStatusEnum.release) {
                                        //     final _holdId = Utils.getStatusId(
                                        //         OrderStatusEnum.hold);
                                        //     placeOrderPro.orderList[i].statusId =
                                        //         _holdId;
                                        //   }
                                        // } else {
                                        //   if (placeOrderPro
                                        //           .orderList[i].id?.isNotEmpty ??
                                        //       false) {
                                        //     placeOrderPro.isAnyItemJustCancelled =
                                        //         true;
                                        //     placeOrderPro
                                        //             .orderList[i].prevStatusId =
                                        //         placeOrderPro.orderList[i].statusId;
                                        //   }
                                        //   placeOrderPro.orderList[i].statusId =
                                        //       Utils.getStatusId(
                                        //           OrderStatusEnum.hold);
                                        // }
                                        // placeOrderPro.notify;
                                        // return null;
                                      },
                                      cancelText: LN.cancel,
                                    ));
                          },
                          color: Colors.blue),
                  ],
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ItemDetail(
                      isOrderItem: true,
                      orderListIndex: i,
                      statusEnum: _statusEnum,
                      docketGroupList:
                          placeOrderPro.initAddSec?.docketGroups ?? [],
                      docketGroupName:
                          placeOrderPro.orderList[i].docketGroupName,
                      onTapDes: placeOrderPro.orderList[i].disabled ||
                              _partialDisabled
                          ? null
                          : () => placeOrderPro.notify,
                      imgPath: placeOrderPro.orderList[i].imgPath,
                      title: (placeOrderPro.orderList[i].productName ?? '') +
                          ((placeOrderPro.orderList[i].productVariationName
                                      ?.trim()
                                      .isNotEmpty ??
                                  false)
                              ? " (${placeOrderPro.orderList[i].productVariationName ?? ''})"
                              : "") +
                          ((_spiceList?.any((a) => a.isActive) ?? false)
                              ? "\n- ${_spiceList?.firstWhere((a) => a.isActive).modifierName ?? ''}"
                              : "") +
                          (_disPercent == 0
                              ? ''
                              : ' (${_disPercent.formatDouble}% OFF)'),
                      modifier: !_isItem ? null : _rootModifiers,
                      comboItem: !_isItem
                          ? placeOrderPro
                              .orderList[i].orderItemModifiersViewModels
                              ?.where((q) => q.isActive)
                              .toList()
                              .map((m) {
                              final _deepSpiceList = m
                                  .modifierItemsModifierViewModels
                                  ?.whereModiType2(ModifierType.spice);

                              final _deepSpice = ((_deepSpiceList
                                          ?.any((a) => a.isActive) ??
                                      false)
                                  ? "\n- ${_deepSpiceList?.firstWhere((a) => a.isActive).modifierName ?? ''}"
                                  : "");

                              final _modifiers = <String>[];

                              final _qtyString = ((m.quantity ?? 0.0) /
                                      placeOrderPro.orderList[i].initQty)
                                  .formatDouble;
                              _modifiers.add(
                                  " + $_qtyString X ${m.modifierName ?? ''}${placeOrderPro.orderList[i].initQty != 1 ? ' (each)' : ''}$_deepSpice");

                              _modifiers.addAll(_modiList(
                                orderItemsPriceModifierViewModels: m
                                    .modifierItemsModifierViewModels
                                    ?.whereModiType2(ModifierType.modifier),
                                itemQty: placeOrderPro.orderList[i].initQty,
                              ));

                              final _deepKitStatusEnum =
                                  OrderUtils.getItemStatusEnum(m.kitchenStatus);

                              // ingredents

                              List<String>? _deepIngredients;

                              final _deepIngre = m
                                  .modifierItemsModifierViewModels
                                  ?.whereModiType2(ModifierType.rawingre);

                              if (_deepIngre != null) {
                                _deepIngredients = [];
                                for (final q in _deepIngre) {
                                  if (q.isActive) {
                                    _deepIngredients.add(q.modifierName ?? '');
                                  }
                                }
                              }

                              return ComboItem(
                                title: _prodType == ProductType.Half
                                    ? m.labelName
                                    : null,
                                modifier: _modifiers,
                                ingredients: _deepIngredients,
                                quantity: null,
                                rootName: _prodType == ProductType.Half
                                    ? null
                                    : _prodType == ProductType.Combo
                                        ? m.labelName
                                        : LN.modifiers,
                                itemStatus: _deepKitStatusEnum ==
                                        ItemStatusEnum.preparing
                                    ? ItemStatus.Preparing
                                    : _deepKitStatusEnum ==
                                            ItemStatusEnum.prepared
                                        ? ItemStatus.Prepared
                                        : ItemStatus.None,
                              );
                            }).toList()
                          : null,
                      ingredients: _ingredients,
                      // vName: placeOrderPro.orderList[i].variationName,
                      curSym: placeOrderPro.curSym,
                      price: _itemPrice,
                      quantity: placeOrderPro.orderList[i].quantity ?? 1,
                      updateQtyDown: placeOrderPro.orderList[i].disabled
                          // || _disableQtyUpdate
                          ? null
                          : () => updateOrderQuantity(context, i,
                              _outOfStock && GlobalCVP.stockExceedRestriction,
                              p0: false),
                      updateQtyUp: placeOrderPro.orderList[i].disabled
                          // ||  _disableQtyUpdate
                          ? null
                          : _outOfStock && GlobalCVP.stockExceedRestriction
                              ? () {
                                  showToast(LN.productOutOfStock);
                                  return null;
                                }
                              : () => updateOrderQuantity(
                                  context,
                                  i,
                                  _outOfStock &&
                                      GlobalCVP.stockExceedRestriction,
                                  p0: true),
                      onTapQty: placeOrderPro
                              .orderList[i].disabled // || _disableQtyUpdate
                          ? null
                          : _outOfStock && GlobalCVP.stockExceedRestriction
                              ? () {
                                  showToast(LN.productOutOfStock);
                                  return null;
                                }
                              : () => updateOrderQuantity(
                                  context,
                                  i,
                                  _outOfStock &&
                                      GlobalCVP.stockExceedRestriction,
                                  p0: null),
                      total: (_itemPrice *
                              (placeOrderPro.orderList[i].quantity ?? 1)) +
                          _modifierPrice.total,
                      onTapPrice: placeOrderPro.orderList[i].disabled ||
                              _partialDisabled
                          ? null
                          : GlobalCVP.viewWidget.viewChangePriceText
                              ? () => PriceDisUpDia.showDia(
                                    context,
                                    number: _itemPrice,
                                    actualPrice:
                                        placeOrderPro.orderList[i].actualPrice,
                                    disPercent: placeOrderPro
                                        .orderList[i].discountPercentage,
                                  ).then((priceData) {
                                    final _oldPrice = placeOrderPro.orderList[i]
                                            .actualPrice?.inDouble ??
                                        0.0;

                                    if (priceData != null) {
                                      // placeOrderPro.orderList[i].promDiscount =
                                      //     null;
                                      placeOrderPro.orderList[i].nonPromPrice =
                                          null;
                                      if (priceData.priceDisEnum ==
                                          PriceDisEnum.Price) {
                                        placeOrderPro.orderList[i]
                                            .discountPercentage = null;
                                        placeOrderPro.orderList[i]
                                            .productPrice = priceData.value;
                                      } else if (priceData.priceDisEnum ==
                                          PriceDisEnum.Discount) {
                                        placeOrderPro.orderList[i]
                                                .discountPercentage =
                                            priceData.disPercent;
                                        placeOrderPro.orderList[i]
                                            .productPrice = priceData.value;
                                      }

                                      final _newPrice = placeOrderPro
                                              .orderList[i].productPrice ??
                                          0.0;

                                      if (_oldPrice != _newPrice) {
                                        placeOrderPro.orderList[i].customPrice =
                                            priceData.value.toString();
                                      }
                                      updateOrderQuantity(
                                        context,
                                        i,
                                        _outOfStock &&
                                            GlobalCVP.stockExceedRestriction,
                                        qtyUpdate: false,
                                      );
                                    }
                                  })
                              : null,

                      onDelete:
                          placeOrderPro.orderList[i].disabled ||
                                  _partialDisabled
                              ? null
                              :
                              // placeOrderPro.loadCancelItem
                              // ? null
                              // :
                              () {
                                  showDialog(
                                      context: context,
                                      builder: (_) => ConfirmDialog(
                                            title:
                                                "${LN.cancel} '${placeOrderPro.orderList[i].productName ?? ''}'?",
                                            titleSize: 18,
                                            subTitle:
                                                "${LN.areYouSureCancel} ${placeOrderPro.orderList[i].productName ?? ''} ?",
                                            actionText: LN.cancel,
                                            onDelete: () async {
                                              _orderOnDelete(i, ctx: context);
                                              return null;
                                            },
                                            cancelText: LN.no,
                                            bottomRightWidget: _isLastItemOnCart
                                                ? ElevatedButton(
                                                    style: ButtonStyle(
                                                        backgroundColor:
                                                            MaterialStateProperty
                                                                .all(
                                                                    kTempColor),
                                                        padding: MaterialStateProperty.all(
                                                            EdgeInsets.symmetric(
                                                                horizontal: size
                                                                    .getW(12),
                                                                vertical: size
                                                                    .getH(8)))),
                                                    onPressed: () {
                                                      _orderOnDelete(i,
                                                          isSentToKt: true,
                                                          ctx: context);
                                                      Navigator.pop(context);
                                                    },
                                                    child: Text(
                                                      LN.cancelSendKitchen,
                                                      style: TextStyle(
                                                        fontSize: size.getS(15),
                                                        color: Colors.white,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ))
                                                : null,
                                          ));
                                },
                      descCltr: TextEditingController(
                          text: placeOrderPro.orderList[i].description),
                      onChangedDesc: placeOrderPro.orderList[i].disabled ||
                              _partialDisabled
                          ? null
                          : (String? val) {
                              if (val == null) return;
                              placeOrderPro.orderList[i].description = val;
                              placeOrderPro.notify;
                            },
                      onTap: placeOrderPro.orderList[i].disabled ||
                              _partialDisabled
                          ? null
                          : () {
                              selectVarience(context, orderDetailIndex: i);
                            },
                      itemStatus: (placeOrderPro.orderList[i].disabled ||
                                  _partialDisabled) &&
                              ((placeOrderPro.orderList[i].currentPayQty !=
                                      0) ||
                                  (placeOrderPro.orderList[i].partialPayQty !=
                                      0))
                          ? ItemStatus.PartialPaid
                          : (placeOrderPro.orderList[i].disabled ||
                                      _partialDisabled) &&
                                  placeOrderPro.orderList[i].paymentType == 2
                              ? ItemStatus.Paid
                              : placeOrderPro.orderList[i].isBatchExpired
                                  ? ItemStatus.BatchExpire
                                  : _kitStatusEnum == ItemStatusEnum.preparing
                                      ? ItemStatus.Preparing
                                      : _kitStatusEnum ==
                                              ItemStatusEnum.prepared
                                          ? ItemStatus.Prepared
                                          : ItemStatus.None,
                      isOutOfStock: _outOfStock,
                      outOfStockMessage:
                          placeOrderPro.orderList[i].outOfStockMessage,
                    ),
                  ],
                ),
                // if (_endHalfCond)
                //   Divider(
                //     color: kSecondaryColor,
                //     thickness: 1,
                //   ),
              ],
            ),
          );
      }),
      ...List.generate(
        placeOrderPro.ingreList.length,
        (i) {
          final _totalQuantity = placeOrderPro.ingreList.any((b) =>
                  b.rawIngredientId ==
                  placeOrderPro.ingreList[i].rawIngredientId)
              ? placeOrderPro.ingreList
                  .where((b) =>
                      b.rawIngredientId ==
                      placeOrderPro.ingreList[i].rawIngredientId)
                  .fold<double>(0, (x, y) => x + (y.quantity ?? 0.0))
              : 0;

          final _outOfStock = GlobalCVP.stockExceedRestriction &&
              !GlobalCVP.isHospitality &&
              (placeOrderPro.ingreList[i].stockCount != null &&
                  (placeOrderPro.ingreList[i].stockCount! <=
                          (placeOrderPro.ingreList[i].quantity ?? 0) ||
                      placeOrderPro.ingreList[i].stockCount! <=
                          _totalQuantity));

          final _disPercent =
              placeOrderPro.ingreList[i].discountPercentage?.inDouble ?? 0.0;

          final _statusEnum =
              OrderUtils.getStatusEnum(placeOrderPro.ingreList[i].statusId);

          if (_statusEnum == OrderStatusEnum.cancel)
            return SizedBox.shrink();
          else
            return _disableSection(
              readOnly: placeOrderPro.ingreList[i].disabled,
              child: SwipeActionCell(
                key: ValueKey(
                    "${placeOrderPro.ingreList[i].rawIngredientId} $i"),
                backgroundColor: Colors.white,
                trailingActions: [
                  SwipeAction(
                      performsFirstActionWithFullSwipe: true,
                      icon: Center(
                        child: Icon(
                          Icons.delete,
                          color: Colors.white,
                          size: size.getS(25),
                        ),
                      ),
                      onTap: (CompletionHandler handler) async {
                        handler(false);
                        if (( //GlobalCVP.isHospitality &&
                            placeOrderPro.reOrder?.orderId != null &&
                                placeOrderPro.ingreList[i].id != null &&
                                placeOrderPro.ingreList[i].id != null)) {
                          if (!GlobalCVP.viewWidget.deleteOrderItem) {
                            return CustomDialog.showPermissionErrorDialog(
                              context: context,
                            );
                          }
                          showDialog(
                              context: context,
                              builder: (_) => ConfirmDialog(
                                  title:
                                      "${LN.cancel} '${placeOrderPro.ingreList[i].name ?? ''}'?",
                                  titleSize: 18,
                                  subTitle:
                                      "${LN.areYouSureCancel} ${placeOrderPro.ingreList[i].name ?? ''} ?",
                                  actionText: LN.cancel,
                                  onDelete: () async {
                                    _ingreDelete(i, ctx: context);
                                    return null;
                                  },
                                  cancelText: LN.no,
                                  bottomRightWidget: _isLastItemOnCart
                                      ? ElevatedButton(
                                          style: ButtonStyle(
                                              backgroundColor:
                                                  MaterialStateProperty.all(
                                                      kTempColor),
                                              padding: MaterialStateProperty
                                                  .all(EdgeInsets.symmetric(
                                                      horizontal: size.getW(12),
                                                      vertical: size.getH(8)))),
                                          onPressed: () {
                                            _ingreDelete(i,
                                                isSentToKt: true, ctx: context);
                                            Navigator.pop(context);
                                          },
                                          child: Text(
                                            LN.cancelSendKitchen,
                                            style: TextStyle(
                                              fontSize: size.getS(15),
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ))
                                      : null));
                        } else
                          _ingreDelete(i, ctx: context);
                        // showDialog(
                        //     context: context,
                        //     builder: (_) => ConfirmDialog(
                        //           title:
                        //               "${LN.cancel} '${placeOrderPro.ingreList[i].name ?? ''}'?",
                        //           titleSize: 18,
                        //           subTitle:
                        //               "${LN.areYouSureCancel} ${placeOrderPro.ingreList[i].name ?? ''} ?",
                        //           actionText: LN.cancel,
                        //           onDelete: () async {
                        //             _ingreDelete(i);
                        //             return null;
                        //           },
                        //           cancelText: LN.no,
                        //         ));
                      },
                      color: Colors.red),
                ],
                child: ItemDetail(
                  orderListIndex: i,
                  docketGroupList: placeOrderPro.initAddSec?.docketGroups ?? [],
                  docketGroupName: "",
                  statusEnum: _statusEnum,
                  // onTapDes: () => placeOrderPro.notify,
                  imgPath: "",
                  title: (placeOrderPro.ingreList[i].name ?? '') +
                      (_disPercent == 0
                          ? ''
                          : ' (${_disPercent.formatDouble}% OFF)'),
                  curSym: placeOrderPro.curSym,
                  price:
                      placeOrderPro.ingreList[i].originalSellingPricePerUnit ??
                          0,
                  quantity: placeOrderPro.ingreList[i].quantity ?? 1,
                  updateQtyDown: () => updateIngreQty(i, _outOfStock,
                      p0: false, qtyUpdate: false),
                  updateQtyUp: _outOfStock
                      ? () {
                          showToast(LN.productOutOfStock);
                          return null;
                        }
                      : () => updateIngreQty(i, _outOfStock,
                          p0: true, qtyUpdate: false),
                  onTapQty: _outOfStock
                      ? () {
                          showToast(LN.productOutOfStock);
                          return null;
                        }
                      : () => updateIngreQty(i, _outOfStock, p0: null),
                  total: double.tryParse(
                          placeOrderPro.ingreList[i].totalSellingPrice ?? '') ??
                      0,
                  // onTapPrice: GlobalCVP.viewWidget(
                  //         Strings.ViewChangePriceText)
                  //     ? () => PriceUpdateDia.showDia(
                  //           context,
                  //           number: _itemPrice,
                  //         ).then((value) {
                  //           if (value != null &&
                  //               value is double) {
                  //             placeOrderPro.orderList[i]
                  //                 .productPrice = value;
                  //             updateOrderQuantity(
                  //                 i, _outOfStock);
                  //           }
                  //         })
                  //     : null,

                  onDelete:
                      //  placeOrderPro.loadCancelItem
                      //     ? null
                      //     :
                      () {
                    showDialog(
                        context: context,
                        builder: (_) => ConfirmDialog(
                              title:
                                  "${LN.cancel} '${placeOrderPro.ingreList[i].name ?? ''}'?",
                              titleSize: 18,
                              subTitle:
                                  "${LN.areYouSureCancel} ${placeOrderPro.ingreList[i].name ?? ''} ?",
                              actionText: LN.cancel,
                              onDelete: () async {
                                _ingreDelete(i, ctx: context);
                                return null;
                              },
                              cancelText: LN.no,
                              bottomRightWidget: _isLastItemOnCart &&
                                      GlobalCVP.isHospitality
                                  ? ElevatedButton(
                                      style: ButtonStyle(
                                          backgroundColor:
                                              MaterialStateProperty.all(
                                                  kTempColor),
                                          padding: MaterialStateProperty.all(
                                              EdgeInsets.symmetric(
                                                  horizontal: size.getW(12),
                                                  vertical: size.getH(8)))),
                                      onPressed: () {
                                        _ingreDelete(i,
                                            isSentToKt: true, ctx: context);
                                        Navigator.pop(context);
                                      },
                                      child: Text(
                                        LN.cancelSendKitchen,
                                        style: TextStyle(
                                          fontSize: size.getS(15),
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ))
                                  : null,
                            ));
                  },
                  // descCltr: TextEditingController(
                  //     text: placeOrderPro
                  //         .ingreList[i].description),
                  // onChangedDesc: (String? val) {
                  //   if (val == null) return;
                  //   placeOrderPro.orderList[i].description =
                  //       val;
                  // },
                  onTap: () {
                    selectIngre(context, index: i);
                  },
                  //  descCltr: null,
                  itemStatus: ((placeOrderPro.ingreList[i].disabled) &&
                              (placeOrderPro.ingreList[i].currentPayQty != 0) ||
                          (placeOrderPro.ingreList[i].partialPayQty != 0))
                      ? ItemStatus.PartialPaid
                      : placeOrderPro.ingreList[i].disabled &&
                              placeOrderPro.ingreList[i].paymentType == 2
                          ? ItemStatus.Paid
                          : ItemStatus.None,
                  isOutOfStock: _outOfStock,
                  outOfStockMessage:
                      placeOrderPro.ingreList[i].outOfStockMessage,
                ),
              ),
            );
        },
      )
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (placeOrderPro.initAddSec?.orderTypes?.isNotEmpty ?? false) ...[
          if (placeOrderPro.initAddSec!.orderTypes!.length < 4)
            Row(
              children: List.generate(
                  placeOrderPro.initAddSec!.orderTypes!.length,
                  (index) => Expanded(child: _orderType(size, index: index))),
            )
          else
            Wrap(
              children: List.generate(
                  placeOrderPro.initAddSec!.orderTypes!.length,
                  (index) => _orderType(size, index: index)),
            )
        ],
        // if (PromoUtils.currentPromotion != null)
        //   Container(
        //     height: size.getH(40),
        //     margin: EdgeInsets.only(
        //       bottom: size.getH(4),
        //     ),
        //     decoration: BoxDecoration(
        //       borderRadius: BorderRadius.circular(5),
        //       color: placeOrderPro.promoId != null
        //           ? Colors.green.withOpacity(0.17)
        //           : Colors.grey.shade300,
        //     ),
        //     child: InkWell(
        //       onTap: () {
        //         placeOrderPro.orderTabName = "";
        //         placeOrderPro.orderTabId = "";
        //         placeOrderPro.orderTabLimit = null;
        //         placeOrderPro.showManageTab = false;
        //         placeOrderPro.reOrder = null;
        //         placeOrderPro.selectedAlpha = null;
        //         placeOrderPro.selectedSubCatIndex = null;
        //         placeOrderPro.selectedCatId = '';
        //         placeOrderPro.categoryTitle = null;
        //         placeOrderPro.searchCltr.clear();
        //         placeOrderPro.brandIndex = null;
        //         if (placeOrderPro.promoId == PromoUtils.currentPromotion?.id)
        //           placeOrderPro.promoId = null;
        //         else
        //           placeOrderPro.promoId = PromoUtils.currentPromotion?.id;
        //         placeOrderPro.notify;
        //         placeOrderPro.getInitData();
        //       },
        //       child: Padding(
        //         padding: EdgeInsets.symmetric(
        //             horizontal: size.getW(16), vertical: size.getH(4)),
        //         child: Row(
        //           children: [
        //             CircleAvatar(
        //               backgroundColor: placeOrderPro.promoId != null
        //                   ? Colors.green
        //                   : Colors.grey,
        //               radius: size.getS(25),
        //               child: Icon(Icons.local_offer,
        //                   color: Colors.white, size: size.getS(20)),
        //             ),
        //             SizedBox(width: size.getW(12)),
        //             Expanded(
        //               child: Text(
        //                 PromoUtils.currentPromotion?.name ?? '',
        //                 style: TextStyle(
        //                   fontSize: size.getS(18),
        //                   color: placeOrderPro.promoId != null
        //                       ? Colors.green
        //                       : Colors.grey.shade600,
        //                   fontFamily: kFontFMedium,
        //                 ),
        //                 overflow: TextOverflow.ellipsis,
        //                 maxLines: 2,
        //               ),
        //             ),
        //           ],
        //         ),
        //       ),
        //     ),
        //   ),
        Row(
          children: [
            Text(
              GlobalCVP.isServiceStore ? LN.services : LN.items,
              style: TextStyle(
                fontSize: size.getS(16),
                color: Colors.black,
                fontFamily: kFontFMedium,
                fontWeight: FontWeight.bold,
              ),
            ),
            // SizedBox(width: size.getW(12)),
            // if (placeOrderPro.orderList.isNotEmpty)
            //   SizedBox(
            //     height: size.getH(25),
            //     child: LoadButton(
            //       btnText: "Manage",
            //       vPad: 1,
            //       hPad: 2,
            //       fontSize: 13,
            //       width: 100,
            //       onsave: () async {
            //         final _val = await showDialog(
            //             context: context,
            //             builder: (BuildContext context) {
            //               return ManageItemsPage();
            //             });

            //         if (_val != null && _val is bool && _val) {
            //           placeOrderPro.notify;
            //         }
            //       },
            //     ),
            //   ),
            Spacer(),
            if (placeOrderPro.orderList.isNotEmpty ||
                placeOrderPro.setMenuList.isNotEmpty ||
                placeOrderPro.ingreList.isNotEmpty)
              InkWell(
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (_) => ConfirmDialog(
                      title: "Are you sure you want to clear all items?",
                      titleSize: 18,
                      subTitle: LN.canNotRevertBack,
                      actionText: LN.clear,
                      onDelete: () async {
                        placeOrderPro.selectedSetMenuProduct?.tempComboProduct
                            ?.clear();
                        placeOrderPro.reOrder = null;
                        placeOrderPro.noOfCustomer.clear();
                        placeOrderPro.clear();
                        placeOrderPro.clearCusData();
                        GlobalCVP.pathOfPOS = PathOfPOS.Init;
                        placeOrderPro.notify;
                        return null;
                      },
                    ),
                  );
                },
                child: Text(
                  LN.clear,
                  style: TextStyle(
                    fontSize: size.getS(16),
                    color: Colors.red,
                    fontFamily: kFontFMedium,
                    decoration: TextDecoration.underline,
                  ),
                ),
              )
          ],
        ),
        SizedBox(
          height: size.getH(4),
        ),
        AnimatedContainer(
          duration: Duration(milliseconds: 400),
          constraints: BoxConstraints(
            minHeight:
                placeOrderPro.reOrder?.orderNumber == null ? 0 : size.getH(40),
            maxHeight:
                placeOrderPro.reOrder?.orderNumber == null ? 0 : size.getH(64),
          ),
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            color: kSecondaryColor.withOpacity(0.17),
          ),
          padding: EdgeInsets.symmetric(
              horizontal: size.getW(16), vertical: size.getH(8)),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  placeOrderPro.reOrder?.orderNumber ?? '',
                  style: TextStyle(
                    fontSize: size.getS(16),
                    color: kSecondaryColor,
                    fontFamily: kFontFMedium,
                    fontWeight: FontWeight.bold,
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                ),
              ),
              Text(
                placeOrderPro.reOrder?.status ?? '',
                style: TextStyle(
                  fontSize: size.getS(16),
                  color: kSecondaryColor,
                  fontFamily: kFontFMedium,
                  fontWeight: FontWeight.bold,
                ),
                overflow: TextOverflow.ellipsis,
                maxLines: 2,
              ),
            ],
          ),
        ),
        Expanded(
          child: _listOfAllItems.isNotEmpty
              ? Scrollbar(
                  controller: scrollCltr,
                  thumbVisibility: false,
                  trackVisibility: false,
                  interactive: true,
                  thickness: 10,
                  radius: Radius.circular(40),
                  child: ListView.builder(
                    controller: scrollCltr,
                    shrinkWrap: true,
                    padding: EdgeInsets.only(right: size.getW(28)),
                    itemCount: _listOfAllItems.length,
                    itemBuilder: ((context, index) => _listOfAllItems[index]),
                  ))
              : Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Circle with icon
                      Container(
                        height: size.getW(100),
                        width: size.getW(100),
                        decoration: const BoxDecoration(
                          color: Color(0xFFE6E8EB),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.shopping_cart_outlined,
                          size: size.getS(42),
                          color: Color(0xFF9AA0A6),
                        ),
                      ),

                      SizedBox(height: size.getH(24)),

                      // Title
                      Text(
                        "Your cart is empty",
                        style: TextStyle(
                          fontSize: size.getS(18),
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF2F3A45),
                        ),
                      ),

                      SizedBox(height: size.getH(12)),

                      // Subtitle
                      Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: size.getW(40)),
                        child: Text(
                          "Add items to cart to start\nan order",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: size.getS(14),
                            color: Color(0xFF6B7280),
                            height: 1.5,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
        ),
        if (GlobalCVP.isHospitality &&
            placeOrderPro.reOrder?.orderId != null &&
            placeOrderPro.isAnyItemJustCancelled)
          _helperMessage(size,
              text:
                  "After canceling an item, you must send it to the kitchen."),
        if (WidgetsBinding.instance.window.viewInsets.bottom <= 0.0 ||
            (placeOrderPro.desFocus?.hasFocus ?? false))
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                height: size.getH(4),
              ),
              TextFormWidget(
                borderRadius: 5,
                borderColor: Colors.black12,
                maxLines: 4,
                minLines: 1,
                isReq: false,
                fillColor: kBackgroundColor,
                cltr: placeOrderPro.descCltr,
                hintText: LN.description,
                focusNode: placeOrderPro.desFocus,
                suffixIcon: GlobalCVP.isHospitality
                    ? Container(
                        height: size.getH(40),
                        decoration: BoxDecoration(
                          color: kSecondaryColor,
                          border: Border.all(color: kSecondaryColor),
                          borderRadius: BorderRadius.only(
                              topRight: Radius.circular(5),
                              bottomRight: Radius.circular(5)),
                        ),
                        child: InkWell(
                          onTap: () {
                            CustomDialog.showNotesDialog(
                              title: LN.addDescription,
                              context: context,
                              descCltr: placeOrderPro.descCltr,
                              hintText: "Add description here",
                              onChangedDesc: (text) {
                                placeOrderPro.descCltr.text = text;
                                placeOrderPro.notify;
                              },
                            );
                          },
                          borderRadius: BorderRadius.circular(5),
                          child: Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: size.getW(4),
                                  vertical: size.getH(4)),
                              child: Icon(
                                Icons.add,
                                size: size.getS(25),
                                color: Colors.white,
                              )
                              //  Text(
                              //   'Add',
                              //   style: TextStyle(
                              //     fontSize: size.getS(14),
                              //     color: kSecondaryColor,
                              //     fontWeight: FontWeight.bold,
                              //   ),
                              // ),
                              ),
                        ))
                    : null,
              ),
              if (placeOrderPro.isDelivery &&
                  placeOrderPro.delivertAmtCltr.text.isNotEmpty)
                Padding(
                  padding: EdgeInsets.only(top: size.getH(4)),
                  child: Row(
                    children: [
                      Text(
                        LN.deliAmt,
                        style: TextStyle(
                          fontSize: size.getS(16),
                          color: Colors.black,
                        ),
                      ),
                      Spacer(),
                      Text(
                        placeOrderPro.curSym! +
                            placeOrderPro.delivertAmtCltr.text,
                        style: TextStyle(
                          fontSize: size.getS(16),
                          color: Colors.black,
                          fontFamily: kFontFMedium,
                        ),
                      ),
                    ],
                  ),
                ),
              OrderTotalSection(
                amount: placeOrderPro.getAllAmount,
                curSym: placeOrderPro.curSym ?? '',
                taxType: OrderUtils.getTaxType(GlobalCVP.isRetailStore
                    ? posRetailPro?.retailPosOrderRes?.storeInformation
                        ?.taxExclusiveInclusiveType
                    : placeOrderPro.initAddSec?.storeInformation
                        ?.taxExclusiveInclusiveType),
                isPayScreen: false,
                bottomWidget: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (!GlobalCVP.isRetailStore &&
                        GlobalCVP.viewWidget.viewButtonSendToKitchen &&
                        !GlobalCVP.isServiceStore) ...[
                      Expanded(
                          child: LoadButton(
                        hPad: 4,
                        loading: placeOrderPro.loadStKtBtn,
                        btnColor: onClickBtn == null ||
                                placeOrderPro.loadStKtBtn ||
                                placeOrderPro.loadPlaceOr
                            ? Colors.grey.shade400
                            : kTempColor,
                        vPad: size.isDesktop ? 12 : 8,
                        onsave: onClickBtn == null ||
                                placeOrderPro.loadStKtBtn ||
                                placeOrderPro.loadPlaceOr
                            ? null
                            : () {
                                if (GlobalCVP.isHospitality &&
                                    placeOrderPro.orderTabId != "" &&
                                    placeOrderPro.orderTabLimit != null &&
                                    placeOrderPro.orderTabLimit != '' &&
                                    placeOrderPro.orderTabLimit.inDouble != 0) {
                                  if (placeOrderPro.getAllAmount.totalPrice
                                          .nonNan() >
                                      placeOrderPro.orderTabLimit.inDouble) {
                                    IfException.showMessage(
                                        message: "Order limit exceeded");
                                    return;
                                  }
                                }
                                onClickBtn!(true);
                              },
                        btnText: LN.sentTKtchn, // + " (F1)",
                        textColor: Colors.white,
                      )),
                      SizedBox(
                        width: size.getW(12),
                      )
                    ],
                    if (GlobalCVP.isServiceStore
                        ? GlobalCVP.viewWidget.viewButtonCheckOut
                        : GlobalCVP.viewWidget.viewCartPayButton)
                      Expanded(
                          child: LoadButton(
                        hPad: 4,
                        loading: placeOrderPro.loadPlaceOr,
                        btnColor: onClickBtn == null ||
                                placeOrderPro.loadStKtBtn ||
                                placeOrderPro.loadPlaceOr
                            ? Colors.grey.shade400
                            : kSecondaryColor,
                        vPad: size.isDesktop ? 12 : 8,
                        onsave: onClickBtn == null ||
                                placeOrderPro.loadStKtBtn ||
                                placeOrderPro.loadPlaceOr
                            ? null
                            : () {
                                if (GlobalCVP.isHospitality &&
                                    placeOrderPro.orderTabId != "" &&
                                    placeOrderPro.orderTabLimit != null &&
                                    placeOrderPro.orderTabLimit != '' &&
                                    placeOrderPro.orderTabLimit.inDouble != 0) {
                                  if (placeOrderPro.getAllAmount.totalPrice
                                          .nonNan() >
                                      placeOrderPro.orderTabLimit.inDouble) {
                                    IfException.showMessage(
                                        message: "Order limit exceeded");
                                    return;
                                  }
                                }
                                onClickBtn!(false);
                              },
                        btnText: GlobalCVP.isServiceStore
                            ? LN.checkout
                            : LN.pay, // + " (F2)",
                        textColor: Colors.white,
                      )),
                  ],
                ),
              )
            ],
          ),
      ],
    );
  }

  void _orderOnDelete(
    int i, {
    required BuildContext ctx,
    bool isSentToKt = false,
  }) {
    final itemId = placeOrderPro.orderList[i].id;

    if (itemId != null &&
        itemId.isNotEmpty &&
        placeOrderPro.reOrder?.orderId != null &&
        placeOrderPro.reOrder!.orderId!.isNotEmpty) {
      placeOrderPro.orderList[i].statusId =
          OrderUtils.getStatusId(OrderStatusEnum.cancel);
      placeOrderPro.isAnyItemJustCancelled = true;
      placeOrderPro.notify;
      // placeOrderPro.orderList[i].isCancelled = true;

      // placeOrderPro
      //     .cancelPlaceOrderItem(
      //   type: ItemCancelType.order,
      //   itemIds: [_itemId],
      //   orderId: placeOrderPro.reOrder!.orderId!,
      //   setmenuId: [],
      // )
      //     .then((value) {
      //   if (value ?? false) {
      //     placeOrderPro.orderList.removeAt(i);

      //     placeOrderPro.notify;
      placeOrderPro.orderStatusUpdate(
        ctx,
        isSentToKt: isSentToKt,
        onPopMsg: (bool val) {
          // if (ctx != null && isSentToKt) {
          //   SendToKitchenPrint.spdSendToKitchen(
          //     ctx,
          //     order: placeOrderPro.placeOrderRes,
          //     showLoading: false,
          //   );
          // }
        },
      );
      //   }
      // });
    } else {
      placeOrderPro.orderList.removeAt(i);

      placeOrderPro.notify;
    }
  }

  void _setmenuOnDelete(
    int i, {
    bool isSentToKt = false,
    required BuildContext ctx,
  }) {
    final itemId = placeOrderPro.setMenuList[i].id;
    if (itemId != null &&
        itemId.isNotEmpty &&
        placeOrderPro.reOrder?.orderId != null &&
        placeOrderPro.reOrder!.orderId!.isNotEmpty) {
      placeOrderPro.setMenuList[i].statusId =
          OrderUtils.getStatusId(OrderStatusEnum.cancel);
      placeOrderPro.isAnyItemJustCancelled = true;
      placeOrderPro.notify;
      // placeOrderPro.setMenuList[i].isCancelled = true;

      // placeOrderPro
      //     .cancelPlaceOrderItem(
      //   type: ItemCancelType.setmenu,
      //   itemIds: [],
      //   orderId: placeOrderPro.reOrder!.orderId!,
      //   setmenuId: [_itemId],
      // )
      //     .then((value) {
      //   if (value ?? false) {
      //     placeOrderPro.removeSetmenu(i);
      placeOrderPro.orderStatusUpdate(
        ctx,
        isSentToKt: isSentToKt,
        onPopMsg: (bool val) {
          // if (ctx != null && isSentToKt) {
          //   SendToKitchenPrint.spdSendToKitchen(
          //     ctx,
          //     order: placeOrderPro.placeOrderRes,
          //     showLoading: false,
          //   );
          // }
        },
      );
      //   }
      // });
    } else {
      placeOrderPro.removeSetmenu(i);
    }
  }

  void _ingreDelete(
    int i, {
    bool isSentToKt = false,
    required BuildContext ctx,
  }) {
    final itemId = placeOrderPro.ingreList[i].id;
    if ((itemId?.isNotEmpty ?? false) &&
        (placeOrderPro.reOrder?.orderId?.isNotEmpty ?? false)) {
      placeOrderPro.ingreList[i].statusId =
          OrderUtils.getStatusId(OrderStatusEnum.cancel);
      placeOrderPro.isAnyItemJustCancelled = true;
      placeOrderPro.notify;
      // placeOrderPro.ingreList[i].isCancelled = true;
      // placeOrderPro
      //     .cancelPlaceOrderItem(
      //   type: ItemCancelType.rawingre,
      //   itemIds: [_itemId!],
      //   orderId: placeOrderPro.reOrder!.orderId!,
      //   setmenuId: [],
      // )
      //     .then((value) {
      //   if (value ?? false) {
      //     placeOrderPro.ingreList.removeAt(i);
      placeOrderPro.orderStatusUpdate(
        ctx,
        isSentToKt: isSentToKt,
        onPopMsg: (bool val) {
          // if (ctx != null && isSentToKt) {
          //   SendToKitchenPrint.spdSendToKitchen(
          //     ctx,
          //     order: placeOrderPro.placeOrderRes,
          //     showLoading: false,
          //   );
          // }
        },
      );
      //     placeOrderPro.notify;
      //   }
      // });
    } else {
      placeOrderPro.ingreList.removeAt(i);
      placeOrderPro.notify;
    }
  }

  Widget _disableSection({bool readOnly = false, required Widget child}) {
    return IgnorePointer(
      ignoring: readOnly,
      child: Opacity(
        opacity: readOnly ? 0.5 : 1,
        child: child,
      ),
    );
  }

  Widget _orderType(
    Ssize size, {
    required int index,
  }) {
    return Card(
      color: (placeOrderPro.orderTypeIndex) == index
          ? (placeOrderPro.loading
              ? kPrimaryColor.withOpacity(0.5)
              : kPrimaryColor)
          : Colors.grey,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
      margin: EdgeInsets.only(
          right: size.getW(4), left: size.getW(4), bottom: size.getH(6)),
      child: InkWell(
        onTap: placeOrderPro.loading
            ? null
            : () {
                if (placeOrderPro.reOrder == null) {
                  placeOrderPro.tableIdName = null;
                  // placeOrderPro.tableId = null;
                  // placeOrderPro.tableName = "";
                }
                placeOrderPro.noOfCustomer.clear();
                placeOrderPro.orderTypeIndex = index;
                placeOrderPro.loading = true;
                _onChangeOrderType();
                placeOrderPro.notify;
                WidgetsBinding.instance
                    .addPostFrameCallback((_) => placeOrderPro.getInitData());
              },
        child: Padding(
          padding: EdgeInsets.symmetric(
              vertical: size.getH(8.0), horizontal: size.getW(4)),
          child: Text(
            placeOrderPro.initAddSec!.orderTypes![index].value ?? '',
            style: TextStyle(
              fontSize: size.getS(14),
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ),
    );
  }

  Container _helperMessage(
    Ssize size, {
    required String text,
  }) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
          color: Colors.red.withOpacity(0.1),
          borderRadius: BorderRadius.circular(10)),
      padding: EdgeInsets.symmetric(
          horizontal: size.getW(8), vertical: size.getH(8)),
      child: Row(
        children: [
          Icon(
            Icons.info_outline,
            size: size.getS(18),
            color: Colors.red,
          ),
          SizedBox(width: size.getW(6)),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                color: Colors.red.shade800,
                fontSize: size.getS(14),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
