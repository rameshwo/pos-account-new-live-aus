// import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:pos_account/config/utils/order_utils.dart';
import 'package:pos_account/config/size_config.dart';
import 'package:pos_account/config/validator.dart';
import 'package:pos_account/constant/constant.dart';
import 'package:pos_account/ln.dart';
import 'package:pos_account/model/home/menu/place_order/pos_res/com/feature_product.dart';
import 'package:pos_account/providers/cus_val_pro.dart';
import 'package:pos_account/providers/menu/place_order_pro.dart';
import 'package:pos_account/repository/if_exception.dart';
import 'package:pos_account/screens/home_screen/com/items/com/item_sec_tile.dart';
import 'package:pos_account/screens/home_screen/com/items/tabs/pos_tab/variance_3/variance_item.dart';
import 'package:pos_account/screens/home_screen/com/quantity_sec.dart';
import 'package:pos_account/screens/home_screen/com/variance/selective_tab.dart';
import 'package:pos_account/widgets/dialog/msg_dialog.dart';
import 'package:pos_account/widgets/image/network_image_sec.dart';
import 'package:pos_account/widgets/load_btn.dart';
import 'package:pos_account/widgets/loading.dart';
import 'package:pos_account/widgets/no_items_sec.dart';
import 'package:provider/provider.dart';
import 'deal_half_item/combo_half_detail_view.dart';
import 'deal_half_item/deal_half_dia.dart';
import 'deal_half_item/deal_item_detail.dart';
import 'deal_half_item/deal_item_varation_select.dart';

class DealDia extends StatefulWidget {
  final FeaturedProduct? product;
  final int? upIndex;
  const DealDia({
    super.key,
    this.product,
    this.upIndex,
  });

  @override
  State<DealDia> createState() => _DealDiaState();
}

class _DealDiaState extends State<DealDia> {
  @override
  void initState() {
    _getData();
    super.initState();
  }

  late PlaceOrderPro _placePro;

  Future<void> _getData() async {
    _placePro = Provider.of<PlaceOrderPro>(context, listen: false);
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      // await _placePro.getProductData(
      //   widget.product?.id,
      //   featuredProduct: widget.product,
      //   isPosTab: widget.upIndex == null,
      // );
      setData();
    });
  }

  void setData() {
    final _varList =
        _placePro.productDetailView?.productListViewModel?.productVariations ??
            [];
    if (_varList.isNotEmpty) {
      if (widget.upIndex != null) {
        _placePro.selectedvarCombo = _varList.firstWhere((a) =>
            a.id?.toLowerCase() ==
            _placePro.orderList[widget.upIndex!].productVariationId
                ?.toLowerCase());

        _varList.forEach((e) => e.isDefault = false);

        _placePro.selectedvarCombo?.isDefault = true;
        _placePro.selectedvarCombo?.quantity = widget.product?.quantity ?? 1;

        if (_placePro.orderList[widget.upIndex!].orderItemModifiersViewModels !=
            null) {
          for (final b in _placePro
              .orderList[widget.upIndex!].orderItemModifiersViewModels!
              .where((e) => e.isActive)
              .toList()) {
            if (_placePro.selectedvarCombo?.productVariationModifiers?.any(
                    (c) =>
                        c.modifierItems?.any((d) =>
                            d.id?.toLowerCase() ==
                            b.priceVariationModifierId?.toLowerCase()) ??
                        false) ??
                false) {
              final _newModiVar = _placePro
                  .selectedvarCombo?.productVariationModifiers
                  ?.firstWhere((f) =>
                      f.modifierItems?.any((g) =>
                          g.id?.toLowerCase() ==
                          b.priceVariationModifierId?.toLowerCase()) ??
                      false);
              final _newModi = _newModiVar?.modifierItems?.firstWhere((h) =>
                  h.id?.toLowerCase() ==
                  b.priceVariationModifierId?.toLowerCase());

              final _prodType = OrderUtils.prodType(_newModi?.productType);
              if (_prodType == ProductType.Half) {
                _placePro.setHalfProdByVarIdForDeal(_newModi);
              }

              if (b.modifierItemsModifierViewModels?.isNotEmpty ?? false) {
                if (_newModi != null) {
                  _newModi
                    ..isActive = b.isActive
                    ..quantity = (b.quantity ?? 1) /
                        (_placePro.orderList[widget.upIndex!].initQty)
                    ..updateId = b.id ?? '';

                  _newModi.modifierItemModifiers?.forEach((i) {
                    i.modifierItems?.forEach((j) {
                      if (b.modifierItemsModifierViewModels?.any((k) =>
                              k.priceVariationModifierId?.toLowerCase() ==
                              j.id?.toLowerCase()) ??
                          false) {
                        final _modiLast = b.modifierItemsModifierViewModels
                            ?.firstWhere((k) =>
                                k.priceVariationModifierId?.toLowerCase() ==
                                j.id?.toLowerCase());

                        j.isActive = _modiLast?.isActive;
                        j.quantity = (_modiLast?.isActive ?? false)
                            ? (_modiLast?.quantity ?? 1) /
                                (_placePro.orderList[widget.upIndex!].initQty)
                            : (_modiLast?.quantity ?? 1);
                        j.updateId = _modiLast?.id ?? '';

                        if (_modiLast?.modifierItemsModifierViewModels != null)
                          j.modifierItemModifiers?.forEach((k) {
                            k.modifierItems?.forEach((l) {
                              if (_modiLast?.modifierItemsModifierViewModels
                                      ?.any((m) =>
                                          m.modifierName == l.productName) ??
                                  false) {
                                final _modiFinal = _modiLast
                                    ?.modifierItemsModifierViewModels
                                    ?.firstWhere(
                                        (m) => m.modifierName == l.productName);
                                l.isActive = _modiFinal?.isActive;
                                l.quantity = (_modiFinal?.isActive ?? false)
                                    ? (_modiFinal?.quantity ?? 1) /
                                        (_placePro
                                            .orderList[widget.upIndex!].initQty)
                                    : (_modiFinal?.quantity ?? 1);
                                l.updateId = _modiFinal?.id ?? '';
                              }
                            });
                          });
                      }
                    });
                  });

                  final _prodType = OrderUtils.prodType(_newModi.productType);

                  try {
                    if (_newModi.isActive ?? false) {
                      if (_prodType == ProductType.Half) {
                        // log(json.encode(_newModi.toJson()));
                        final _firstHalf = _newModi.modifierItemModifiers
                            ?.firstWhere((a) =>
                                a.name?.toLowerCase().contains('first') ??
                                false);

                        _placePro.firstHalf = _firstHalf?.modifierItems
                            ?.firstWhere((b) => b.isActive ?? false);

                        final _secondHalf = _newModi.modifierItemModifiers
                            ?.firstWhere((a) =>
                                a.name?.toLowerCase().contains('second') ??
                                false);

                        _placePro.secondHalf = _secondHalf?.modifierItems
                            ?.firstWhere((b) => b.isActive ?? false);

                        final _isQuarter =
                            OrderUtils.halfType(_newModi.productType) ==
                                HalfProductType.Quarter;

                        if (_isQuarter) {
                          final _thirdHalf = _newModi.modifierItemModifiers
                              ?.firstWhere((a) =>
                                  a.name?.toLowerCase().contains('third') ??
                                  false);

                          _placePro.thirdHalf = _thirdHalf?.modifierItems
                              ?.firstWhere((b) => b.isActive ?? false);

                          final _fourthHalf = _newModi.modifierItemModifiers
                              ?.firstWhere((a) =>
                                  a.name?.toLowerCase().contains('four') ??
                                  false);

                          _placePro.fourthHalf = _fourthHalf?.modifierItems
                              ?.firstWhere((b) => b.isActive ?? false);
                        }
                      }
                    }
                  } catch (e) {
                    //
                  }

                  //
                  // if (_prodType == ProductType.Half) {
                  //   _newModi.halfItemPrice =
                  //       getHigherItemPrice(_newModi.productType);
                  //   // kPrint(
                  //   //     "${_newModi.productName} ${_newModi.halfItemPrice} ${_placePro.firstHalf?.productName} ${_placePro.firstHalf?.actualPrice} ");
                  // }

                  // _newModi.multipleCombo ??= [];
                  // final _thisData = ModifierItem.fromJson(_newModi.toJson())
                  //   ..isActive = b.isActive
                  //   ..quantity = b.quantity ?? 1
                  //   ..updateId = b.id ?? '';

                  // _thisData.modifierItemModifiers?.forEach((i) {
                  //   i.modifierItems?.forEach((j) {
                  //     if (b.modifierItemsModifierViewModels?.any((k) =>
                  //             k.priceVariationModifierId?.toLowerCase() ==
                  //             j.id?.toLowerCase()) ??
                  //         false) {
                  //       final _modiLast = b.modifierItemsModifierViewModels
                  //           ?.firstWhere((k) =>
                  //               k.priceVariationModifierId?.toLowerCase() ==
                  //               j.id?.toLowerCase());

                  //       j.isActive = _modiLast?.isActive;
                  //       j.quantity = (_modiLast?.isActive ?? false)
                  //           ? (_modiLast?.quantity ?? 1) /
                  //               (_placePro.orderList[widget.upIndex!].initQty)
                  //           : (_modiLast?.quantity ?? 1);
                  //       j.updateId = _modiLast?.id ?? '';
                  //     }
                  //   });
                  // });
                  // _newModi.multipleCombo?.add(_thisData);
                }
              } else {
                _newModi?.isActive = b.isActive;
                _newModi?.quantity = b.quantity ?? 1;
                _newModi?.updateId = b.id ?? '';
              }
            }
          }
        }

        if ( //(_varList.first.productVariationModifiers?.isNotEmpty ?? false) &&
            (_placePro.selectedvarCombo?.productVariationModifiers?.any((a) =>
                    a.modifierItems?.any((b) => b.isActive ?? false) ??
                    false) ??
                false)) {
          final _choosedModi = _placePro
              .selectedvarCombo?.productVariationModifiers
              ?.firstWhere((a) =>
                  a.modifierItems?.any((b) => b.isActive ?? false) ?? false);
          selectedVarModiName = _choosedModi?.name;

          if (_choosedModi?.modifierItems?.any((c) => c.isActive ?? false) ??
              false) {
            _placePro.currentSelectedModifier = _choosedModi?.modifierItems
                ?.firstWhere((c) => c.isActive ?? false);
          }
        }
      } else {
        for (final a in _varList) {
          if (a.productVariationModifiers != null)
            for (final b in a.productVariationModifiers!) {
              if (b.modifierItems != null)
                for (final c in b.modifierItems!) {
                  c.isActive = c.isRequired;
                }
            }
        }

        _placePro.selectedvarCombo = _varList.firstWhere(
            (e) => e.isDefault ?? false,
            orElse: () => _varList.first..isDefault = true);

        if (_varList.first.productVariationModifiers?.isNotEmpty ?? false)
          selectedVarModiName =
              _varList.first.productVariationModifiers?.first.name;
      }
    }

    _grouping();
    _placePro.notify;
  }

  void _grouping() {
    try {
      groupedItems = {};

      final _initSelectedVar = _placePro
          .selectedvarCombo?.productVariationModifiers
          ?.firstWhere((a) => a.name == selectedVarModiName);

      if (_initSelectedVar?.modifierItems != null) {
        // _initSelectedVar?.modifierItems?.sort((a, b) {
        //   final aIsHalf =
        //       OrderUtils.prodType(a.productType) == ProductType.Half;
        //   final bIsHalf =
        //       OrderUtils.prodType(b.productType) == ProductType.Half;
        //   if (aIsHalf && !bIsHalf) return -1; // a first
        //   if (!aIsHalf && bIsHalf) return 1; // b first
        //   return 0; // keep relative order otherwise
        // });

        for (var item in _initSelectedVar!.modifierItems!) {
          if (item.productName?.isNotEmpty ?? false) {
            groupedItems.putIfAbsent(item.productName ?? '', () => []);

            groupedItems[item.productName]!.add(item);
          }
        }
      }
    } catch (e) {
      // kPrint("Erro: $e");
    }
  }

  Map<String, List<ModifierItem>> groupedItems = {};

  // double getHigherItemPrice(String? _productType) {
  //   final _isQuarter =
  //       OrderUtils.halfType(_productType) == HalfProductType.Quarter;

  //   final _firstPrice =
  //       (_placePro.firstHalf?.discountedPrice?.inDouble ?? 0) != 0
  //           ? _placePro.firstHalf?.discountedPrice?.inDouble ?? 0
  //           : _placePro.firstHalf?.actualPrice?.inDouble ?? 0;

  //   final _secondPrice =
  //       (_placePro.secondHalf?.discountedPrice?.inDouble ?? 0) != 0
  //           ? _placePro.secondHalf?.discountedPrice?.inDouble ?? 0
  //           : _placePro.secondHalf?.actualPrice?.inDouble ?? 0;

  //   final _thirdPrice =
  //       (_placePro.thirdHalf?.discountedPrice?.inDouble ?? 0) != 0
  //           ? _placePro.thirdHalf?.discountedPrice?.inDouble ?? 0
  //           : _placePro.thirdHalf?.actualPrice?.inDouble ?? 0;

  //   final _fourthPrice =
  //       (_placePro.fourthHalf?.discountedPrice?.inDouble ?? 0) != 0
  //           ? _placePro.fourthHalf?.discountedPrice?.inDouble ?? 0
  //           : _placePro.fourthHalf?.actualPrice?.inDouble ?? 0;

  //   if (_isQuarter) {
  //     return [_firstPrice, _secondPrice, _thirdPrice, _fourthPrice]
  //         .reduce(math.max);
  //   } else {
  //     if (_firstPrice >= _secondPrice)
  //       return _firstPrice;
  //     else if (_firstPrice <= _secondPrice)
  //       return _secondPrice;
  //     else
  //       return 0;
  //   }
  // }

  void _onTabItem({
    required PlaceOrderPro placeOrderPro,
    ModifierItem? modifier,
    required ProductVariationModifier? selectedVar,
  }) async {
    if (modifier == null) {
      return;
    }

    // log(json.encode(modifier.toJson()));

    // if (!(modifier.isActive ?? false) &&
    //     OrderUtils.prodType(modifier.productType) == ProductType.Half) {
    //   if (OrderUtils.productPriceType(modifier.productPriceType) !=
    //       OrderUtils.productPriceType(widget.product?.productPriceType)) {
    //     IfException.showMessage(message: "Item Price validation error");
    //     return;
    //   }

    //   placeOrderPro.setHalfProdByVarIdForDeal(modifier);

    //   final _oldMItem = ModifierItem.fromJson(modifier.toJson());

    //   placeOrderPro.firstHalf =
    //       OrderUtils.getActiveModifierItem(modifier, 'first');

    //   placeOrderPro.secondHalf =
    //       OrderUtils.getActiveModifierItem(modifier, 'second');

    //   final _mItemStatus = await showDialog(
    //       context: context,
    //       barrierDismissible: true,
    //       builder: (builder) => SimpleDialog(
    //             titlePadding: EdgeInsets.zero,
    //             contentPadding: EdgeInsets.zero,
    //             shape: RoundedRectangleBorder(
    //                 borderRadius: BorderRadius.circular(15)),
    //             children: [
    //               DealHalfDia(
    //                 modifierItem: modifier,
    //               )
    //             ],
    //           ));

    //   if (_mItemStatus == null) {
    //     modifier = _oldMItem;
    //     placeOrderPro.firstHalf = null;
    //     placeOrderPro.secondHalf = null;
    //   }
    // }

    final _isSingleSelect =
        selectedVar?.selectionType?.toLowerCase().contains('single') ?? false;

    final _maxCount = selectedVar?.maxThresholdQuantity?.inDouble ?? 0;

    final _selectCount = selectedVar?.modifierItems
            ?.where((e) => e.isActive ?? false)
            .toList()
            .fold<double>(0, (pV, ele) => pV + ele.quantity) ??
        0;

    if (_maxCount != 0 &&
        _selectCount != 0 &&
        _selectCount >= _maxCount &&
        !(modifier.isActive ?? false)) {
      // kPrint('message: 5');
      IfException.showMessage(
          message: "Maximum selected item count is ${_maxCount.round()}");

      return;
    }

    placeOrderPro.currentSelectedModifier = modifier;

    modifier.selectedItemQtyIndex = 0;

    if (_isSingleSelect) {
      selectedVar?.modifierItems?.forEach((e) {
        e.isActive = false;
      });
    }
    // modifier.multipleCombo = [
    //   ModifierItem.fromJson(modifier.toJson())..isActive = true
    // ];

    modifier.isActive = true; // !(modifier.isActive ?? false);

    placeOrderPro.varianceLoading = true;

    placeOrderPro.notify;

    Future.delayed(Duration(milliseconds: 100), () {
      placeOrderPro.varianceLoading = false;
      modifier.maxSelectCount = _maxCount;

      placeOrderPro.notify;
    });
  }

  void _onRemoveItem({
    required PlaceOrderPro placeOrderPro,
    ModifierItem? modifier,
  }) {
    modifier?.isActive = false;
    modifier?.modifierItemModifiers?.forEach((e) {
      e.modifierItems?.forEach((e1) {
        e1.isActive = false;
      });
    });
    placeOrderPro.currentSelectedModifier = null;
    placeOrderPro.notify;
  }

  double _getUnitTotalAmount({bool isAllData = true}) {
    if (_placePro.selectedvarCombo == null) return 0.0;

    final _setMenuPrice =
        (_placePro.selectedvarCombo?.discountedPrice?.inDouble ?? 0) > 0 ||
                (_placePro.selectedvarCombo?.discountPercentage?.inDouble ??
                        0) >
                    99
            ? _placePro.selectedvarCombo?.discountedPrice.inDouble ?? 0
            : _placePro.selectedvarCombo?.actualPrice.inDouble ?? 0;

    // log(json.encode(_placePro.selectedvarCombo?.toJson()));

    return _setMenuPrice +
        (_placePro.selectedvarCombo?.productVariationModifiers?.fold<double>(
                0,
                (pV1, e1) =>
                    pV1 +
                    (e1.modifierItems?.fold<double>(0, (pV4, e4) {
                          // if (e4.isActive ?? false)
                          //   kPrint(
                          //       "${e4.productName} ${e4.isActive} ${e4.quantity} ${e4.halfItemPrice} ${e4.actualPrice} ${e4.additionalPrice}"); // Half n Half Large true 1.0 18.0 0.00

                          return pV4 +
                              (((e4.isActive ?? false) ? e4.quantity : 0) *
                                  ((e4.halfItemPrice != null
                                          ? (e4.halfItemPrice ?? 0)
                                          : ((e4.discountedPrice.inDouble > 0
                                                  ? (e4.discountedPrice
                                                          ?.inDouble ??
                                                      0)
                                                  : (e4.actualPrice?.inDouble ??
                                                      0)) +
                                              (e4.additionalPrice?.inDouble ??
                                                  0.0))) +
                                      (!isAllData
                                          ? 0.0
                                          : (e4.modifierItemModifiers
                                                  ?.fold<double>(0, (pV5, e5) {
                                                return pV5 +
                                                    (e5.modifierItems
                                                            ?.fold<double>(0,
                                                                (pV6, e5) {
                                                          return pV6 +
                                                              ((e5.isActive ??
                                                                      false)
                                                                  ? (e5.quantity *
                                                                      ((e4.halfItemPrice != null
                                                                              ? 0
                                                                              : ((e5.discountedPrice.inDouble > 0 ? (e5.discountedPrice?.inDouble ?? 0) : (e5.actualPrice?.inDouble ?? 0)))) +
                                                                          (e5.additionalPrice?.inDouble ?? 0) +
                                                                          (e5.modifierItemModifiers?.fold<double>(0, (pv7, e6) => pv7 + (e6.modifierItems?.fold<double>(0, (pv8, e7) => pv8 + ((e7.isActive ?? false) ? (e7.discountedPrice.inDouble > 0 ? (e7.discountedPrice?.inDouble ?? 0) : (e7.actualPrice?.inDouble ?? 0)) : 0)) ?? 0)) ?? 0)))
                                                                  : 0);
                                                        }) ??
                                                        0);
                                              }) ??
                                              0))));
                        }) ??
                        0)) ??
            0);
  }

  void addToCart(
    PlaceOrderPro placeOrderPro,
    FeaturedProduct _product, {
    bool isNew = false,
  }) {
    if (placeOrderPro.selectedvarCombo == null) return;

    final e = placeOrderPro.selectedvarCombo!;

    // log(json.encode(e.toJson()));
    // if (e.productVariationModifiers != null)
    //   for (final a in e.productVariationModifiers!) {
    //     if (a.modifierItems != null) {
    // final _additionalList = <ModifierItem>[];
    // for (final b in a.modifierItems!) {
    //   if ((b.isActive ?? false) && b.multipleCombo != null) {
    //     for (final c in b.multipleCombo!) {
    //       if ((c?.isActive ?? false) &&
    //           (c?.modifierItemModifiers?.isNotEmpty ?? false)) {
    //         // log(json.encode(c!.toJson()));

    //         _additionalList.add(c!);
    //       }
    //     }
    //     if (_additionalList
    //         .any((d) => d.id?.toLowerCase() == b.id?.toLowerCase())) {
    //       b.isActive = false;
    //     }
    //   }
    // }

    // a.modifierItems!.addAll(_additionalList);
    // }
    // }
    // kPrint(_getUnitTotalAmount(isAllData: false));

    placeOrderPro.updateOrderCart(
      product: _product..quantity = e.quantity,
      variation: e,
      catId: _product.categoryId,
      orderDetailIndex: isNew ? null : widget.upIndex,
      isVarianceUpdate: true,
      customPrice: _getUnitTotalAmount(isAllData: false).roundToNString(),
    );

    IfException.showMessage(
        message: widget.upIndex != null ? LN.updateSuccess : LN.addCartSuccess,
        isError: false);

    _product.quantity = 1;
  }

  void removeFromCart(PlaceOrderPro placeOrderPro, int index) {
    placeOrderPro.orderList.removeAt(index);
    placeOrderPro.notify;
  }

  Future<void> _showItemVariationDia({
    required List<ModifierItem> modifierList,
  }) async {
    if (modifierList.isEmpty) return;

    if (modifierList.length == 1) {
      if (!(modifierList.first.isActive ?? false) &&
          OrderUtils.prodType(modifierList.first.productType) ==
              ProductType.Half) {
        if (OrderUtils.productPriceType(modifierList.first.productPriceType) !=
            OrderUtils.productPriceType(widget.product?.productPriceType)) {
          IfException.showMessage(message: "Item Price validation error");
          return;
        }

        _placePro.setHalfProdByVarIdForDeal(modifierList.first);

        // final _oldMItem = ModifierItem.fromJson(modifierList.first.toJson());

        _placePro.firstHalf =
            OrderUtils.getActiveModifierItem(modifierList.first, 'first');

        _placePro.secondHalf =
            OrderUtils.getActiveModifierItem(modifierList.first, 'second');

        final _mItemStatus = await showDialog(
            context: context,
            barrierDismissible: true,
            builder: (builder) => SimpleDialog(
                  titlePadding: EdgeInsets.zero,
                  contentPadding: EdgeInsets.zero,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15)),
                  children: [
                    DealHalfDia(
                      modifierItem: modifierList.first,
                    )
                  ],
                ));

        if (_mItemStatus != null && _mItemStatus is ModifierItem) {
          modifierList.first = _mItemStatus..isActive = true;
          // kPrint(
          //     "${modifierList.first.productName} ${modifierList.first.isActive}");
          // log(json.encode(modifierList.first.toJson()));
        } else {
          _placePro.firstHalf = null;
          _placePro.secondHalf = null;
          _placePro.currentSelectedModifier = null;
          _placePro.notify;
          return;
        }
      }

      modifierList.first.isActive = true;

      final _selectedVarModi = (_placePro
                  .selectedvarCombo?.productVariationModifiers
                  ?.any((e) => e.name == selectedVarModiName) ??
              false)
          ? _placePro.selectedvarCombo?.productVariationModifiers
              ?.firstWhere((e) => e.name == selectedVarModiName)
          : null;

      _onTabItem(
        placeOrderPro: _placePro,
        modifier: modifierList.first,
        selectedVar: _selectedVarModi,
        // isSelected: item.isActive ?? false,
      );
    } else {
      await showDialog(
          context: context,
          barrierDismissible: true,
          builder: (builder) => SimpleDialog(
                titlePadding: EdgeInsets.zero,
                contentPadding: EdgeInsets.zero,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15)),
                children: [
                  DealItemVariationSelectionDia(
                    modifierList: modifierList,
                    onUpdate: (ModifierItem item) {
                      final _selectedVarModi = (_placePro
                                  .selectedvarCombo?.productVariationModifiers
                                  ?.any((e) => e.name == selectedVarModiName) ??
                              false)
                          ? _placePro
                              .selectedvarCombo?.productVariationModifiers
                              ?.firstWhere((e) => e.name == selectedVarModiName)
                          : null;

                      _onTabItem(
                        placeOrderPro: _placePro,
                        modifier: item,
                        selectedVar: _selectedVarModi,
                        // isSelected: item.isActive ?? false,
                      );
                      // _placePro.notify;
                    },
                  ),
                ],
              ));
    }
    // if (modifierList.any((a) => a.isActive ?? false)) {
    //   final _selectedVarModi = (_placePro
    //               .selectedvarCombo?.productVariationModifiers
    //               ?.any((e) => e.name == selectedVarModiName) ??
    //           false)
    //       ? _placePro.selectedvarCombo?.productVariationModifiers
    //           ?.firstWhere((e) => e.name == selectedVarModiName)
    //       : null;

    //   final item = modifierList.firstWhere((a) => a.isActive ?? false);

    //   _onTabItem(
    //     placeOrderPro: _placePro,
    //     modifier: item,
    //     selectedVar: _selectedVarModi,
    //     isSelected: item.isActive ?? false,
    //   );
    // }
  }

  @override
  void dispose() {
    _placePro.selectedvarCombo?.quantity = 1;
    _placePro.selectedvarCombo = null;
    _placePro.currentSelectedModifier = null;
    _placePro.selectedHalfEnum = HalfItemTypeEnum.first;
    _placePro.firstHalf = null;
    _placePro.secondHalf = null;
    _placePro.thirdHalf = null;
    _placePro.fourthHalf = null;

    onPopUp(widget.product);
    super.dispose();
  }

  void onPopUp(FeaturedProduct? _product) {
    _product?.quantity = 1;
    if (_product?.productVariations != null)
      for (final a in _product!.productVariations!) {
        if (a.productVariationModifiers != null)
          for (final b in a.productVariationModifiers!) {
            for (final c in b.modifierItems!) {
              c.isActive = false;
              c.quantity = 1;
              if (c.modifierItemModifiers != null)
                for (final d in c.modifierItemModifiers!) {
                  d.modifierItems?.forEach((e) {
                    e.isActive = false;
                    e.quantity = 1;
                  });
                }
            }
          }
      }
  }

  String? selectedVarModiName;

  @override
  Widget build(BuildContext context) {
    final size = Ssize(context);
    final placeOrderPro = Provider.of<PlaceOrderPro>(context);

    final _product =
        placeOrderPro.productDetailView?.productListViewModel ?? widget.product;

    _product
      ?..productType = widget.product?.productType
      ..productPriceType = widget.product?.productPriceType;

    final _selectedVarModi = (placeOrderPro
                .selectedvarCombo?.productVariationModifiers
                ?.any((e) => e.name == selectedVarModiName) ??
            false)
        ? placeOrderPro.selectedvarCombo?.productVariationModifiers
            ?.firstWhere((e) => e.name == selectedVarModiName)
        : null;

    final _selectionCount =
        (_selectedVarModi?.selectionType?.toLowerCase().contains('single') ??
                false)
            ? 1.0
            : _selectedVarModi?.maxThresholdQuantity?.inDouble ?? 0.0;

    final _canAddToCart =
        placeOrderPro.selectedvarCombo?.productVariationModifiers?.any((a) =>
                a.modifierItems?.any((b) => b.isActive ?? false) ?? false) ??
            false;
    //  (placeOrderPro
    //             .selectedvarCombo?.productVariationModifiers
    //             ?.every((a) => a.isRequired == null || !a.isRequired!) ??
    //         false) ||
    //     (placeOrderPro.selectedvarCombo?.productVariationModifiers
    //             ?.where((z) => (z.isRequired ?? false))
    //             .every((a) =>
    //                 (a.modifierItems?.any((b) => b.isActive ?? false) ??
    //                     false)) ??
    //         false);

    final _priceType = OrderUtils.productPriceType(_product?.productPriceType);

    // double _leastValue() {
    //   final list = _selectedVarModi?.modifierItems
    //           ?.where(
    //               (f) => OrderUtils.prodType(f.productType) != ProductType.Half)
    //           .map((e) => (e.discountedPrice ?? e.actualPrice)?.inDouble ?? 0)
    //           .toList() ??
    //       [];

    //   if (list.isEmpty) return 0;

    //   return list.reduce(math.min);
    // }

    // final _defaultModiItem = _priceType == ProductPriceType.MakeYourOwn
    //     ? ((_selectedVarModi?.modifierItems?.any((a) => a.isDefault ?? false) ??
    //             false)
    //         ? _selectedVarModi?.modifierItems
    //             ?.firstWhere((a) => a.isDefault ?? false)
    //         : _selectedVarModi?.modifierItems?.firstWhere((e) =>
    //             ((e.discountedPrice ?? e.actualPrice)?.inDouble ?? 0) ==
    //             _leastValue()))
    //     : null;

    ((_selectedVarModi?.modifierItems?.any((a) => a.isDefault ?? false) ??
                false) &&
            _priceType == ProductPriceType.MakeYourOwn)
        ? _selectedVarModi?.modifierItems
            ?.firstWhere((a) => a.isDefault ?? false)
        : null;

    final _unitAmount = _getUnitTotalAmount();

    final _totalAmount =
        (_placePro.selectedvarCombo?.quantity ?? 0) * _unitAmount;

    // kPrint(placeOrderPro.currentSelectedModifier?.productName);

    return Processing(
      loading: placeOrderPro.productDetailView == null &&
          placeOrderPro.varianceLoading,
      child: Container(
        height: size.height,
        width: size.width,
        padding: EdgeInsets.symmetric(
            vertical: size.getH(12), horizontal: size.getW(24)),
        child: SafeArea(
          child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text.rich(
                      TextSpan(
                        text: (_product?.name ?? 'Deal'),
                      ),
                      style: TextStyle(
                        fontSize: size.getS(24),
                        fontFamily: kFontFMedium,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all(Colors.red),
                          minimumSize: MaterialStateProperty.all(Size(0, 0)),
                          shape: MaterialStateProperty.all(
                              RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(100))),
                          padding: MaterialStateProperty.all(
                              EdgeInsets.symmetric(
                                  horizontal: size.getW(14),
                                  vertical: size.getH(4))),
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text("X",
                            style: TextStyle(
                                fontSize: size.getS(24), color: Colors.white))

                        // )s
                        ),
                  ],
                ),
                // SizedBox(
                //   height: size.getH(8),
                // ),

                if (placeOrderPro.productDetailView == null &&
                    placeOrderPro.varianceLoading)
                  Flexible(
                    child: SizedBox(
                      height: double.maxFinite,
                      width: double.maxFinite,
                    ),
                  )
                else
                  Expanded(
                      child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 2,
                        child: Card(
                          elevation: 8,
                          shape: RoundedRectangleBorder(
                            side: BorderSide(color: Colors.black12),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: SizedBox(
                            height: double.maxFinite,
                            width: double.maxFinite,
                            child: Column(
                              children: [
                                Expanded(
                                  child: SingleChildScrollView(
                                    padding: EdgeInsets.symmetric(
                                        vertical: size.getH(12),
                                        horizontal: size.getW(12)),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        if (placeOrderPro.selectedvarCombo
                                                    ?.productVariationModifiers ==
                                                null ||
                                            placeOrderPro
                                                .selectedvarCombo!
                                                .productVariationModifiers!
                                                .isEmpty)
                                          NoItemsSec(
                                              size: size,
                                              title: LN.noProductFound)
                                        else ...[
                                          Text.rich(
                                            TextSpan(
                                                text: _selectedVarModi?.name ??
                                                    '',
                                                children: [
                                                  if (_selectedVarModi
                                                          ?.isRequired ??
                                                      false)
                                                    TextSpan(
                                                      text: "*",
                                                      style: TextStyle(
                                                        fontSize: size.getS(17),
                                                        fontFamily:
                                                            kFontFMedium,
                                                        fontWeight:
                                                            FontWeight.normal,
                                                        color: Colors.red,
                                                      ),
                                                    ),
                                                  if (_selectionCount != 0)
                                                    TextSpan(
                                                      text: _selectionCount == 1
                                                          ? " (Choose only one item)"
                                                          : " (Choose upto ${_selectionCount.formatDouble} items)",
                                                      style: TextStyle(
                                                        fontSize: size.getS(17),
                                                        fontFamily:
                                                            kFontFMedium,
                                                        fontWeight:
                                                            FontWeight.normal,
                                                        color: kSecondaryColor,
                                                      ),
                                                    )
                                                ]),
                                            style: TextStyle(
                                              fontSize: size.getS(20),
                                              fontFamily: kFontFMedium,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black,
                                            ),
                                          ),
                                          SizedBox(
                                            height: size.getH(8),
                                          ),
                                          // if (_selectedVarModi
                                          //         ?.modifierItems
                                          //         ?.isNotEmpty ??
                                          //     false)
                                          if (groupedItems.isNotEmpty)
                                            GridView.count(
                                              crossAxisCount: 5,
                                              childAspectRatio: (OrderUtils
                                                          .productPriceType(widget
                                                              .product
                                                              ?.productPriceType) ==
                                                      ProductPriceType
                                                          .MakeYourOwn)
                                                  ? 0.8
                                                  : 0.9,
                                              shrinkWrap: true,
                                              physics:
                                                  NeverScrollableScrollPhysics(),
                                              mainAxisSpacing: size.getW(12),
                                              crossAxisSpacing: size.getH(12),
                                              children: [
                                                ...List.generate(
                                                    groupedItems.entries
                                                        .toList()
                                                        .length, (j) {
                                                  ModifierItem _modifier;

                                                  try {
                                                    _modifier = groupedItems
                                                        .entries
                                                        .toList()[j]
                                                        .value
                                                        .firstWhere((a) =>
                                                            a.isActive ??
                                                            false);
                                                  } catch (z) {
                                                    _modifier = groupedItems
                                                        .entries
                                                        .toList()[j]
                                                        .value
                                                        .first;
                                                  }

                                                  final _isSelected =
                                                      _modifier.isActive ??
                                                          false;

                                                  final _prodType =
                                                      OrderUtils.prodType(
                                                          _modifier
                                                              .productType);
                                                  final _isHalf = _modifier
                                                          .productType
                                                          ?.toLowerCase()
                                                          .contains('half') ??
                                                      false;
                                                  final _isQuarter = _modifier
                                                          .productType
                                                          ?.toLowerCase()
                                                          .contains(
                                                              'quarter') ??
                                                      false;

                                                  // final _excedPrice = _prodType ==
                                                  //         ProductType.Half
                                                  //     ? 0.0
                                                  //     : ((_modifier.actualPrice
                                                  //                 ?.inDouble ??
                                                  //             0) -
                                                  //         (_defaultModiItem
                                                  //                 ?.actualPrice
                                                  //                 .inDouble ??
                                                  //             0));
                                                  final _excedPrice = _prodType ==
                                                          ProductType.Half
                                                      ? 0.0
                                                      : _modifier
                                                              .additionalPrice
                                                              ?.inDouble ??
                                                          0.0;
                                                  final _modifiers =
                                                      groupedItems.entries
                                                          .toList()[j]
                                                          .value;

                                                  final double? _modiPrice = _prodType ==
                                                              ProductType
                                                                  .Half &&
                                                          (_modifier.isActive ??
                                                              false)
                                                      ? (_modifier.halfItemPrice ??
                                                              0) +
                                                          ((_modifier
                                                                  .modifierItemModifiers
                                                                  ?.fold<double>(
                                                                      0, (pV5,
                                                                          e5) {
                                                                return pV5 +
                                                                    (e5.modifierItems?.fold<double>(
                                                                            0,
                                                                            (pV6,
                                                                                e5) {
                                                                          if (e5.isActive ??
                                                                              false) {}
                                                                          return pV6 +
                                                                              ((e5.isActive ?? false) ? (e5.quantity * ((_modifier.halfItemPrice != null ? 0 : ((e5.discountedPrice.inDouble > 0 ? (e5.discountedPrice?.inDouble ?? 0) : (e5.actualPrice?.inDouble ?? 0)))) + (e5.modifierItemModifiers?.fold<double>(0, (pv7, e6) => pv7 + (e6.modifierItems?.fold<double>(0, (pv8, e7) => pv8 + ((e7.isActive ?? false) ? (e7.discountedPrice.inDouble > 0 ? (e7.discountedPrice?.inDouble ?? 0) : (e7.actualPrice?.inDouble ?? 0)) : 0)) ?? 0)) ?? 0))) : 0);
                                                                        }) ??
                                                                        0);
                                                              }) ??
                                                              0))
                                                      : null;

                                                  return InkWell(
                                                    onTap: () {
                                                      _showItemVariationDia(
                                                          modifierList:
                                                              _modifiers);
                                                      // _onTabItem(
                                                      //   placeOrderPro:
                                                      //       placeOrderPro,
                                                      //   modifier: _modifier,
                                                      //   selectedVar:
                                                      //       _selectedVarModi,
                                                      //   isSelected: _isSelected,
                                                      // );
                                                    },
                                                    child: Stack(
                                                      alignment:
                                                          Alignment.topRight,
                                                      children: [
                                                        Card(
                                                          margin: EdgeInsets
                                                              .fromLTRB(
                                                                  2,
                                                                  size.getH(8),
                                                                  size.getW(8),
                                                                  2),
                                                          elevation: 3,
                                                          shape:
                                                              RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        10),
                                                            side: BorderSide(
                                                              color: placeOrderPro
                                                                          .currentSelectedModifier
                                                                          ?.productName ==
                                                                      _modifier
                                                                          .productName
                                                                  ? Colors.green
                                                                      .shade600
                                                                  : Colors
                                                                      .transparent,
                                                              width: placeOrderPro
                                                                          .currentSelectedModifier
                                                                          ?.productName ==
                                                                      _modifier
                                                                          .productName
                                                                  ? 2
                                                                  : 1.0,
                                                            ),
                                                          ),
                                                          child: Container(
                                                            width:
                                                                double.infinity,
                                                            padding: EdgeInsets
                                                                .symmetric(
                                                                    vertical:
                                                                        size.getH(
                                                                            4.0),
                                                                    horizontal:
                                                                        size.getW(
                                                                            8)),
                                                            child: Column(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .center,
                                                              children: [
                                                                Expanded(
                                                                  child: NetworkImageSec(
                                                                      image: _modifiers.first.imageUrl,
                                                                      height: 100,
                                                                      boxFit: BoxFit.cover,
                                                                      width: double.infinity,
                                                                      errWidget: _isHalf || _isQuarter
                                                                          ? Center(
                                                                              child: Text(
                                                                                _isHalf ? '1/2' : '1/4',
                                                                                style: TextStyle(
                                                                                  fontSize: size.getS(60),
                                                                                ),
                                                                                textAlign: TextAlign.center,
                                                                              ),
                                                                            )
                                                                          : null),
                                                                ),
                                                                SizedBox(
                                                                  height: size
                                                                      .getH(4),
                                                                ),
                                                                SizedBox(
                                                                  height: size
                                                                      .getH(48),
                                                                  child: Center(
                                                                    child: Text(
                                                                        (_modifier.productName ??
                                                                                '') +
                                                                            (((_modifier.isActive ?? false) || _modifiers.length == 1) && (_modifier.variationName?.trim().isNotEmpty ?? false)
                                                                                ? ' (${_modifier.variationName})'
                                                                                : ''),
                                                                        style:
                                                                            TextStyle(
                                                                          fontSize:
                                                                              size.getW(16),
                                                                          color:
                                                                              Colors.black,
                                                                          fontFamily:
                                                                              kFontFMedium,
                                                                          height:
                                                                              1.2,
                                                                        ),
                                                                        maxLines:
                                                                            2,
                                                                        textAlign:
                                                                            TextAlign
                                                                                .center,
                                                                        overflow:
                                                                            TextOverflow.ellipsis),
                                                                  ),
                                                                ),
                                                                if (_priceType ==
                                                                    ProductPriceType
                                                                        .MakeYourOwn)
                                                                  Padding(
                                                                    padding: EdgeInsets.only(
                                                                        bottom:
                                                                            size.getH(4)),
                                                                    child:
                                                                        ItemPriceView(
                                                                      size:
                                                                          size,
                                                                      curSym: placeOrderPro
                                                                          .curSym,
                                                                      initPrice: _prodType ==
                                                                              ProductType
                                                                                  .Half
                                                                          ? _modiPrice
                                                                              .roundToNString()
                                                                          : _modifier
                                                                              .actualPrice,
                                                                      priceAfterDiscount: _prodType ==
                                                                              ProductType.Half
                                                                          ? null
                                                                          : _modifier.discountedPrice,
                                                                      fontRatio:
                                                                          1,
                                                                      bold:
                                                                          false,
                                                                    ),
                                                                  ),
                                                                AnimatedSwitcher(
                                                                  duration: Duration(
                                                                      milliseconds:
                                                                          400),
                                                                  transitionBuilder:
                                                                      (child,
                                                                          animation) {
                                                                    return FadeTransition(
                                                                      opacity:
                                                                          animation,
                                                                      child:
                                                                          SizeTransition(
                                                                        sizeFactor:
                                                                            animation,
                                                                        axisAlignment:
                                                                            -1.0,
                                                                        child:
                                                                            child,
                                                                      ),
                                                                    );
                                                                  },
                                                                  child: _isSelected
                                                                      ? Container(
                                                                          key: ValueKey(
                                                                              'button1'),
                                                                          height:
                                                                              size.getH(36),
                                                                          padding:
                                                                              EdgeInsets.only(bottom: size.getH(4)),
                                                                          alignment:
                                                                              Alignment.center,
                                                                          child:
                                                                              LoadButton(
                                                                            vPad:
                                                                                2,
                                                                            hPad:
                                                                                4,
                                                                            btnColor:
                                                                                Colors.red.shade700,
                                                                            textColor:
                                                                                Colors.white,
                                                                            width:
                                                                                80,
                                                                            fontSize:
                                                                                14,
                                                                            btnText:
                                                                                "Remove",
                                                                            onsave: () =>
                                                                                _onRemoveItem(modifier: _modifier, placeOrderPro: placeOrderPro),
                                                                          ),
                                                                        )
                                                                      : SizedBox(
                                                                          key: ValueKey(
                                                                              'empty1'), // Unique key to trigger switch
                                                                          height:
                                                                              0,
                                                                        ),
                                                                ),
                                                                SizedBox(
                                                                  height: size
                                                                      .getH(4),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                        AnimatedSwitcher(
                                                          duration: Duration(
                                                              milliseconds:
                                                                  300),
                                                          transitionBuilder:
                                                              (child,
                                                                  animation) {
                                                            return ScaleTransition(
                                                                scale:
                                                                    animation,
                                                                child: child);
                                                          },
                                                          child: Card(
                                                            key: ValueKey<bool>(
                                                                _isSelected),
                                                            elevation: 5,
                                                            color: _isSelected
                                                                ? Colors.green
                                                                    .shade700
                                                                : Colors.white,
                                                            shape: RoundedRectangleBorder(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            100)),
                                                            child: Padding(
                                                              padding:
                                                                  EdgeInsets.all(
                                                                      size.getS(
                                                                          4)),
                                                              child: Icon(
                                                                _isSelected
                                                                    ? Icons
                                                                        .check
                                                                    : Icons.add,
                                                                size: size
                                                                    .getS(32),
                                                                color: _isSelected
                                                                    ? Colors
                                                                        .white
                                                                    : Colors
                                                                        .black,
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                        if (_priceType ==
                                                                ProductPriceType
                                                                    .MakeYourOwn &&
                                                            _excedPrice > 0)
                                                          Align(
                                                            alignment: Alignment
                                                                .topLeft,
                                                            child: Card(
                                                              elevation: 5,
                                                              color: _excedPrice >
                                                                      0
                                                                  ? Colors.green
                                                                      .shade700
                                                                  : Colors.red,
                                                              shape: RoundedRectangleBorder(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              100)),
                                                              child: Padding(
                                                                padding: EdgeInsets.symmetric(
                                                                    vertical:
                                                                        size.getS(
                                                                            4),
                                                                    horizontal:
                                                                        size.getS(
                                                                            12)),
                                                                child: Text(
                                                                  "${_excedPrice > 0 ? '+' : '-'}${placeOrderPro.curSym}${_excedPrice.abs().formatDoubleN(digit: 2)}",
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          size.getS(
                                                                              16),
                                                                      color: Colors
                                                                          .white),
                                                                ),
                                                              ),
                                                            ),
                                                          )
                                                      ],
                                                    ),
                                                  );
                                                })
                                              ],
                                            )
                                          else
                                            NoItemsSec(
                                                size: size,
                                                title: LN.noProductFound),
                                          SizedBox(height: size.getH(24)),
                                        ]
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                          flex: 1,
                          child: Card(
                            elevation: 8,
                            shape: RoundedRectangleBorder(
                              side: BorderSide(color: Colors.black12),
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                  vertical: size.getH(12),
                                  horizontal: size.getW(12)),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    flex: 2,
                                    child: OrderUtils.prodType(placeOrderPro
                                                .currentSelectedModifier
                                                ?.productType) ==
                                            ProductType.Half
                                        ? ComboHalfModifierDetailView(
                                            currentModifier: placeOrderPro
                                                .currentSelectedModifier,
                                            placeOrderPro: placeOrderPro)
                                        : DealItemDetailSec(
                                            placeOrderPro: placeOrderPro,
                                            selectedVarModi: _selectedVarModi,
                                          ),
                                  ),
                                  if (_product?.productVariations?.isNotEmpty ??
                                      false)
                                    Flexible(
                                        flex: 2,
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            ...List.generate(
                                                _product!.productVariations!
                                                    .length, (i) {
                                              final _prodVar = _product
                                                  .productVariations![i];
                                              return Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  SizedBox(
                                                    height: size.getH(4),
                                                  ),
                                                  Text(
                                                    "Choose ${(_prodVar.name?.isNotEmpty ?? false) ? _prodVar.name! : 'Category'}",
                                                    style: TextStyle(
                                                      fontSize: size.getS(18),
                                                      fontFamily: kFontFMedium,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.black,
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    height: size.getH(12),
                                                  ),
                                                  Column(
                                                    spacing: size.getW(12),
                                                    // runSpacing: size.getH(12),
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      ...List.generate(
                                                          _prodVar
                                                              .productVariationModifiers!
                                                              .length, (j) {
                                                        final _selectedVarModi =
                                                            _prodVar
                                                                .productVariationModifiers![j];
                                                        final _selectedCount = _selectedVarModi
                                                                .modifierItems
                                                                ?.fold<double>(
                                                                    0,
                                                                    (pV, e) =>
                                                                        pV +
                                                                        ((e.isActive ??
                                                                                false)
                                                                            ? (e.quantity)
                                                                            : 0.0)) ??
                                                            0.0;
                                                        return SizedBox(
                                                          width:
                                                              double.infinity,
                                                          child: SelectiveTab(
                                                            title: (_selectedVarModi
                                                                        .name ??
                                                                    '') +
                                                                // ((_selectedVarModi
                                                                //             .isRequired ??
                                                                //         false)
                                                                //     ? '*'
                                                                //     : '') +
                                                                (_selectedCount !=
                                                                        0
                                                                    ? '(${_selectedCount.formatDouble})'
                                                                    : ''),
                                                            isDefault:
                                                                selectedVarModiName ==
                                                                    _selectedVarModi
                                                                        .name,
                                                            fRatio: 1.2,
                                                            onTap: () {
                                                              if (selectedVarModiName ==
                                                                  _selectedVarModi
                                                                      .name)
                                                                return;

                                                              selectedVarModiName =
                                                                  _selectedVarModi
                                                                      .name;
                                                              _placePro
                                                                      .currentSelectedModifier =
                                                                  null;
                                                              _grouping();
                                                              //
                                                              if (_selectedVarModi
                                                                      .modifierItems
                                                                      ?.any((a) =>
                                                                          a.isActive ??
                                                                          false) ??
                                                                  false) {
                                                                final item = _selectedVarModi
                                                                    .modifierItems
                                                                    ?.firstWhere((a) =>
                                                                        a.isActive ??
                                                                        false);
                                                                _onTabItem(
                                                                  placeOrderPro:
                                                                      _placePro,
                                                                  modifier:
                                                                      item,
                                                                  selectedVar:
                                                                      _selectedVarModi,
                                                                );
                                                              }
                                                              placeOrderPro
                                                                  .notify;
                                                            },
                                                          ),
                                                        );
                                                      })
                                                    ],
                                                  ),
                                                ],
                                              );
                                            })
                                          ],
                                        ))
                                ],
                              ),
                            ),
                          ))
                    ],
                  )),
                SizedBox(
                  height: size.getH(4),
                ),

                Container(
                  decoration: BoxDecoration(color: Colors.white),
                  child: Row(
                    children: [
                      Expanded(
                        child: Row(
                          children: [
                            Text.rich(
                              TextSpan(
                                text: "${LN.price} : ",
                                children: [
                                  TextSpan(
                                    text:
                                        "${placeOrderPro.curSym ?? ''}${_unitAmount.roundToNString()}",
                                  ),
                                  // if ((placeOrderPro.selectedvarCombo
                                  //             ?.discountPercentage?.inDouble ??
                                  //         0) !=
                                  //     0)
                                  //   TextSpan(
                                  //     text:
                                  //         "${placeOrderPro.curSym ?? ''}${placeOrderPro.selectedvarCombo?.discountedPrice ?? '0.00'} ",
                                  //     style: TextStyle(
                                  //       decoration: TextDecoration.none,
                                  //       overflow: TextOverflow.visible,
                                  //     ),
                                  //   ),
                                  // TextSpan(
                                  //   text:
                                  //       "${placeOrderPro.curSym ?? ''}${placeOrderPro.selectedvarCombo?.actualPrice ?? '0.00'}",
                                  //   style: (placeOrderPro
                                  //                   .selectedvarCombo
                                  //                   ?.discountPercentage
                                  //                   ?.inDouble ??
                                  //               0) !=
                                  //           0
                                  //       ? TextStyle(
                                  //           decoration:
                                  //               TextDecoration.lineThrough,
                                  //           fontSize: size.getS(18),
                                  //           color: Colors.red,
                                  //           overflow: TextOverflow.visible,
                                  //         )
                                  //       : null,
                                  // ),
                                ],
                              ),
                              style: TextStyle(
                                fontSize: size.getS(24),
                                fontFamily: kFontFMedium,
                                color: Colors.black,
                              ),
                              // maxLines: 2,
                              textAlign: TextAlign.center,
                              overflow: TextOverflow.ellipsis,
                            ),
                            // if ((placeOrderPro.selectedvarCombo
                            //             ?.discountPercentage?.inDouble ??
                            //         0) !=
                            //     0)
                            //   Container(
                            //     margin: EdgeInsets.symmetric(
                            //         horizontal: size.getW(8)),
                            //     decoration: BoxDecoration(
                            //       color: Colors.red.shade800,
                            //       // shape: BoxShape.circle,
                            //       borderRadius: BorderRadius.circular(5),
                            //     ),
                            //     padding: EdgeInsets.symmetric(
                            //         vertical: size.getS(6),
                            //         horizontal: size.getS(8)),
                            //     child: Text(
                            //       "${placeOrderPro.selectedvarCombo?.discountPercentage?.inQty}% OFF",
                            //       style: TextStyle(
                            //         fontSize: size.getS(16),
                            //         color: Colors.white,
                            //         fontFamily: kFontFMedium,
                            //       ),
                            //     ),
                            //   ),
                            SizedBox(
                              width: size.getW(32),
                            ),
                            Text(
                              "${LN.quantity}   ",
                              style: TextStyle(
                                fontSize: size.getS(24),
                                fontFamily: kFontFMedium,
                                color: Colors.black,
                              ),
                            ),
                            QuantitySection(
                              quantity: placeOrderPro.selectedvarCombo?.quantity
                                      .toDouble() ??
                                  1,
                              size: size,
                              fr: 1.2,
                              update: (p0) {
                                if (p0 == null) return;

                                if (p0)
                                  placeOrderPro.selectedvarCombo!.quantity++;
                                else {
                                  if (placeOrderPro.selectedvarCombo!.quantity <
                                      2) return;
                                  placeOrderPro.selectedvarCombo!.quantity--;
                                }
                                placeOrderPro.notify;
                              },
                            ),
                          ],
                        ),
                      ),
                      Row(
                        children: [
                          if (widget.upIndex != null)
                            ElevatedButton(
                                style: ButtonStyle(
                                    backgroundColor: MaterialStateProperty.all(
                                        Colors.red.shade700),
                                    padding: MaterialStateProperty.all(
                                        EdgeInsets.symmetric(
                                            vertical: size.getH(10),
                                            horizontal: size.getH(12)))),
                                onPressed: () {
                                  removeFromCart(
                                      placeOrderPro, widget.upIndex!);
                                  // placeOrderPro.removeSetmenu(widget.upIndex!);
                                  Navigator.pop(context);
                                },
                                child: Text(
                                  LN.removeFromCart,
                                  style: TextStyle(fontSize: size.getS(18)),
                                )),
                          SizedBox(
                            width: size.getW(12),
                          ),
                          if (GlobalCVP.viewWidget.viewAddToCartButton)
                            SizedBox(
                              width: size.getW(400),
                              child: VarianceItem.textButton(
                                size,
                                onPressed: _canAddToCart
                                    ? () {
                                        if (placeOrderPro.selectedvarCombo ==
                                            null) return;

                                        if (placeOrderPro.selectedvarCombo
                                                    ?.productVariationModifiers !=
                                                null &&
                                            placeOrderPro.selectedvarCombo!
                                                .productVariationModifiers!
                                                .any((f) =>
                                                    f.modifierItems != null &&
                                                    f.modifierItems!.any((g) =>
                                                        g.isActive ?? false))) {
                                          addToCart(placeOrderPro, _product!,
                                              isNew: widget.upIndex == null);
                                          Navigator.pop(context);
                                        } else {
                                          MsgDia.show(
                                            CUS_CTX,
                                            headerAnimation: false,
                                            diaType: DiaType.info,
                                            title: LN.noItemsSelected,
                                            autoHideSecond: 2,
                                          );
                                        }
                                      }
                                    : null,
                                sideColor: _canAddToCart
                                    ? kSecondaryColor
                                    : Colors.grey.shade400,
                                backColor: MaterialStateProperty.all(
                                    _canAddToCart
                                        ? kSecondaryColor
                                        : Colors.grey.shade400),
                                title: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      Icons.shopping_cart_outlined,
                                      color: Colors.white,
                                      size: size.getS(24),
                                    ),
                                    SizedBox(width: size.getW(12)),
                                    Text(
                                      "${widget.upIndex != null ? LN.update : LN.addToCart} - ${placeOrderPro.curSym}${_totalAmount.roundToNString()}",
                                      style: TextStyle(
                                        fontSize: size.getS(18),
                                        fontFamily: kFontFMedium,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          SizedBox(
                            width: size.getW(4),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ]),
        ),
      ),
    );
  }
}
