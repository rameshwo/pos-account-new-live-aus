import 'package:flutter/material.dart';
import 'package:pos_account/config/size_config.dart';
import 'package:pos_account/config/utils/order_utils.dart';
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
import 'com/combo_item_detail_2.dart';

class ComboNewDia extends StatefulWidget {
  final FeaturedProduct? product;
  final int? upIndex;
  const ComboNewDia({
    super.key,
    this.product,
    this.upIndex,
  });

  @override
  State<ComboNewDia> createState() => _ComboNewDiaState();
}

class _ComboNewDiaState extends State<ComboNewDia> {
  @override
  void initState() {
    _getData();
    super.initState();
  }

  late PlaceOrderPro _placePro;

  Future<void> _getData() async {
    _placePro = Provider.of<PlaceOrderPro>(context, listen: false);
    // final _retailPro = Provider.of<PosRetailPro>(context, listen: false);
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      // FeaturedProduct? _retailProduct;

      // if (GlobalCVP.isRetailStore && widget.upIndex != null) {
      //   _retailProduct = await _retailPro.getProductData(widget.product?.id,
      //       orderTypeIndex: _placePro.orderTypeIndex);
      // }

      // await _placePro.getProductData(
      //   widget.product?.id,
      //   featuredProduct: widget.product,
      //   isPosTab: widget.upIndex == null,
      //   retailProduct: _retailProduct,
      // );
      setData();
    });
  }

  void setData() {
    final _varList =
        _placePro.productDetailView?.productListViewModel?.productVariations ??
            [];
    // log(json.encode(_placePro.productDetailView));

    _prodPriceType = OrderUtils.productPriceType(
        _placePro.productDetailView?.productListViewModel?.productPriceType);

    if (_varList.isNotEmpty) {
      if (widget.upIndex != null) {
        // log(json.encode(_placePro.orderList[widget.upIndex!].toJson()));

        _placePro.selectedvarCombo = _varList.firstWhere((a) =>
            a.id?.toLowerCase() ==
            _placePro.orderList[widget.upIndex!].productVariationId
                ?.toLowerCase());
        final _product =
            _placePro.productDetailView?.productListViewModel ?? widget.product;

        // _product?.taxRuleIndex = widget.product?.taxRuleIndex ?? 0;
        _product?.preparationType = widget.product?.preparationType;

        try {
          _product?.taxRuleIndex = _product.taxRules?.indexWhere(
                  (n) =>
                      n.taxRuleName?.toLowerCase() ==
                      widget.product?.preparationType?.toLowerCase(),
                  0) ??
              0;
        } catch (e) {
          //
        }

        // log(json.encode(_placePro.orderList[widget.upIndex!].toJson()));

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
                            (d.id != null &&
                                d.id?.toLowerCase() ==
                                    b.priceVariationModifierId
                                        ?.toLowerCase()) ||
                            (GlobalCVP.isRetailStore &&
                                d.productName == b.modifierName)) ??
                        false) ??
                false) {
              final _newModiVar = _placePro
                  .selectedvarCombo?.productVariationModifiers
                  ?.firstWhere((f) =>
                      f.modifierItems?.any((g) =>
                          (g.id != null &&
                              g.id?.toLowerCase() ==
                                  b.priceVariationModifierId?.toLowerCase()) ||
                          (GlobalCVP.isRetailStore &&
                              g.productName == b.modifierName)) ??
                      false);

              final _newModi = _newModiVar?.modifierItems?.firstWhere((h) =>
                  (h.id != null &&
                      h.id?.toLowerCase() ==
                          b.priceVariationModifierId?.toLowerCase()) ||
                  (GlobalCVP.isRetailStore && h.productName == b.modifierName));

              // log(json.encode(
              //     _newModiVar?.modifierItems?.map((e) => e.toJson()).toList()));

              if (_newModi != null) {
                _newModi.isActive = b.isActive;
                // _newModi.quantity = b.quantity ?? 1;
                _newModi.updateId = b.id ?? '';

                _newModi.multipleCombo ??= [];

                final _thisData = ModifierItem.fromJson(_newModi.toJson())
                  ..isActive = b.isActive
                  // ..quantity = b.quantity ?? 1
                  ..updateId = b.id ?? '';

                // kPrint(
                //     "-- ${_thisData.productName} ${_thisData.quantity} ${b.quantity}");

                if (b.modifierItemsModifierViewModels?.isNotEmpty ?? false) {
                  _thisData.modifierItemModifiers?.forEach((i) {
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
                      }
                    });
                  });

                  _newModi.multipleCombo?.add(_thisData);
                  if (_newModi.multipleCombo?.isNotEmpty ?? false) {
                    _newModi.quantity =
                        _newModi.multipleCombo?.length.toDouble() ?? 1.0;
                  }
                }
                // log(json.encode(
                //     _newModi.multipleCombo?.map((e) => e?.toJson()).toList()));
              } else {
                _newModi?.isActive = b.isActive;
                _newModi?.quantity = b.quantity ?? 1;
                _newModi?.updateId = b.id ?? '';
              }
            }
          }
        }

        if ((_varList.first.productVariationModifiers?.isNotEmpty ?? false) &&
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

        // kPrint(
        //     "Q: currentSelectedModifier: ${_placePro.currentSelectedModifier?.quantity}");

        // log(json.encode(_placePro.selectedvarCombo?.toJson()));
      } else {
        // if (_prodPriceType == ProductPriceType.FixedPriceFixedProduct) {
        for (final a in _varList) {
          if (a.productVariationModifiers != null)
            for (final b in a.productVariationModifiers!) {
              if (b.modifierItems != null)
                for (final c in b.modifierItems!) {
                  c.isActive = c.isRequired; // c.isDefault;
                  c.quantity = (c.maxThresholdQuantity?.inDouble ?? 0) == 0
                      ? 1
                      : (c.maxThresholdQuantity?.inDouble ?? 1.0);
                }
            }
        }
        // }
        _placePro.selectedvarCombo = _varList.firstWhere(
            (e) => e.isDefault ?? false,
            orElse: () => _varList.first..isDefault = true);

        if (_varList.first.productVariationModifiers?.isNotEmpty ?? false)
          selectedVarModiName =
              _varList.first.productVariationModifiers?.first.name;
      }
    }

    _placePro.notify;
  }

  ProductPriceType? _prodPriceType;

  void _onTabItem({
    required PlaceOrderPro placeOrderPro,
    ModifierItem? modifier,
    required ProductVariationModifier? selectedVar,
    bool isSelected = false,
  }) async {
    if (modifier == null) {
      return;
    }

    // if (OrderUtils.prodType(modifier.productType) == ProductType.Half) {
    //   final _oldMItem = ModifierItem.fromJson(modifier.toJson());

    //   placeOrderPro.firstHalf =
    //       OrderUtils.getActiveModifierItem(modifier, 'first');

    //   placeOrderPro.secondHalf =
    //       OrderUtils.getActiveModifierItem(modifier, 'second');

    //   final _mItemStatus = await showDialog(
    //       context: context,
    //       barrierDismissible: true,
    //       builder: (builder) => SimpleDialog(
    //             // backgroundColor: kSecondaryColor,
    //             titlePadding: EdgeInsets.zero,
    //             contentPadding: EdgeInsets.zero,
    //             shape: RoundedRectangleBorder(
    //                 borderRadius: BorderRadius.circular(15)),
    //             children: [
    //               ComboHalfDia(
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

    // final _remainingCount = _maxCount - _selectCount;

    if (_maxCount != 0 &&
        _selectCount != 0 &&
        _selectCount >= _maxCount &&
        !(modifier.isActive ?? false)) {
      // kPrint('message: 1');
      IfException.showMessage(
          message: "Maximum selected item count is ${_maxCount.round()}");

      return;
    }

    placeOrderPro.currentSelectedModifier = modifier;

    modifier.selectedItemQtyIndex = 0;

    if (!isSelected) {
      if (_isSingleSelect) {
        selectedVar?.modifierItems?.forEach((e) {
          e.isActive = false;
        });
      }
      modifier.multipleCombo = [
        ModifierItem.fromJson(modifier.toJson())..isActive = true
      ];

      modifier.isActive = !(modifier.isActive ?? false);
    }

    // if (_prodPriceType == ProductPriceType.FixedPriceFixedProduct) {
    if (modifier.multipleCombo == null || modifier.multipleCombo!.isEmpty)
      modifier.multipleCombo = [
        ModifierItem.fromJson(modifier.toJson())..isActive = true
      ];
    // }

    // kPrint(modifier.multipleCombo?.length);

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

  double _getTotalAmount() {
    if (_placePro.selectedvarCombo == null) return 0.0;

    final _setMenuPrice =
        (_placePro.selectedvarCombo?.discountedPrice?.inDouble ?? 0) > 0 ||
                (_placePro.selectedvarCombo?.discountPercentage?.inDouble ??
                        0) >
                    99
            ? _placePro.selectedvarCombo?.discountedPrice.inDouble ?? 0
            : _placePro.selectedvarCombo?.actualPrice.inDouble ?? 0;

    return (_placePro.selectedvarCombo!.quantity *
        (_setMenuPrice +
            (_placePro.selectedvarCombo?.productVariationModifiers?.fold<double>(
                    0,
                    (pV1, e1) =>
                        pV1 +
                        (e1.modifierItems?.fold<double>(
                                0,
                                (pV4, e4) =>
                                    pV4 +
                                    ((e4.isActive ?? false)
                                        ? (e4.additionalPrice?.inDouble ?? 0)
                                        : 0.0) +
                                    (e4.multipleCombo?.fold<double>(
                                            0,
                                            (pV2, e2) =>
                                                pV2 +
                                                ((e2 == null || !e2.isActive!)
                                                    ? 0
                                                    : (e2.modifierItemModifiers
                                                            ?.fold<double>(
                                                                0,
                                                                (pV3, e3) =>
                                                                    pV3 +
                                                                    (e3.modifierItems?.fold<double>(
                                                                            0,
                                                                            (pv4, e4) => pv4 + (((e4.isActive ?? false) ? e4.quantity : 0) * (e4.discountedPrice.inDouble > 0 ? e4.discountedPrice.inDouble : e4.actualPrice.inDouble))) ??
                                                                        0)) ??
                                                        0))) ??
                                        0)) ??
                            0)) ??
                0)));
  }

  void addToCart(
    PlaceOrderPro placeOrderPro,
    FeaturedProduct _product, {
    bool isNew = false,
  }) {
    if (placeOrderPro.selectedvarCombo == null) return;

    final e = placeOrderPro.selectedvarCombo!;

    // log(json.encode(e.toJson()));
    if (e.productVariationModifiers != null)
      for (final a in e.productVariationModifiers!) {
        if (a.modifierItems != null) {
          final _additionalList = <ModifierItem>[];
          for (final b in a.modifierItems!) {
            if ((b.isActive ?? false) && b.multipleCombo != null) {
              for (final c in b.multipleCombo!) {
                if ((c?.isActive ?? false) &&
                    (c?.modifierItemModifiers?.isNotEmpty ?? false)) {
                  // log(json.encode(c!.toJson()));

                  _additionalList.add(c!);
                }
              }
              if (_additionalList
                  .any((d) => d.id?.toLowerCase() == b.id?.toLowerCase())) {
                b.isActive = false;
              }
            }
          }
          a.modifierItems!.addAll(_additionalList);
        }
      }

    placeOrderPro.updateOrderCart(
      product: _product..quantity = e.quantity,
      variation: e,
      catId: _product.categoryId,
      // catTypeId: widget.product?.categoryTypeId,
      orderDetailIndex: isNew ? null : widget.upIndex,
      // orderItemSelectOptionsViewModel:
      //     _getSelectedFilter,
      isVarianceUpdate: true,
      // isHalfnHalf: true,
    );

    IfException.showMessage(
        message: widget.upIndex != null ? LN.updateSuccess : LN.addCartSuccess,
        isError: false);

    _product.quantity = 1;

    // Navigator.pop(context);
  }

  void removeFromCart(PlaceOrderPro placeOrderPro, int index) {
    placeOrderPro.orderList.removeAt(index);
    placeOrderPro.notify;
  }

  @override
  void dispose() {
    _placePro.selectedvarCombo?.quantity = 1;
    _placePro.selectedvarCombo = null;
    _placePro.currentSelectedModifier = null;
    onPopUp(widget.product);
    super.dispose();
  }

  void onPopUp(FeaturedProduct? _product) {
    _product?.quantity = 1;
    _product?.preparationType = null;
    _product?.taxRuleIndex = 0;

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
    // _product?.selectedSpiceId = null;
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

    final _ifThereAnyReqCat = placeOrderPro
            .selectedvarCombo?.productVariationModifiers
            ?.any((a) => (a.isRequired ?? false)) ??
        false;

    final _canAddToCart = (placeOrderPro
                .selectedvarCombo?.productVariationModifiers
                ?.every((a) => a.isRequired == null || !a.isRequired!) ??
            false) ||
        (placeOrderPro.selectedvarCombo?.productVariationModifiers
                ?.where((z) => (z.isRequired ?? false))
                .every((a) =>
                    (a.modifierItems?.any((b) => b.isActive ?? false) ??
                        false)) ??
            false);
    final _priceType = OrderUtils.productPriceType(_product?.productPriceType);

    // final _defaultModiItem =
    //     (_selectedVarModi?.modifierItems?.any((a) => a.isDefault ?? false) ??
    //                 false) &&
    //             _priceType == HalfPriceType.Higher
    //         ? _selectedVarModi?.modifierItems
    //             ?.firstWhere((a) => a.isDefault ?? false)
    //         : null;
    // final _isModifierSelected = false;
    // placeOrderPro.selectedvarCombo?.productVariationModifiers?.any((a) =>
    //         a.modifierItems?.any((b) =>
    //             (b.isActive ?? false) &&
    //             (b.multipleCombo?.any((c) =>
    //                     c?.modifierItemModifiers
    //                         ?.whereModiType(ModifierType.modifier)
    //                         .any((d) =>
    //                             d.modifierItems
    //                                 ?.any((e) => e.isActive ?? false) ??
    //                             false) ??
    //                     false) ??
    //                 false)) ??
    //         false) ??
    //     false;

    return Processing(
      loading: placeOrderPro.productDetailView == null &&
          placeOrderPro.varianceLoading,
      child: Container(
        // constraints: BoxConstraints(
        //   maxHeight: size.height / 1,
        //   minHeight: size.height / 1,
        // ),
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
                        text: (_product?.name ?? 'Combo Product'),
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
                  Flexible(
                      child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Flexible(
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
                                      children: placeOrderPro.selectedvarCombo
                                                      ?.productVariationModifiers ==
                                                  null ||
                                              placeOrderPro
                                                  .selectedvarCombo!
                                                  .productVariationModifiers!
                                                  .isEmpty
                                          ? [
                                              NoItemsSec(
                                                  size: size,
                                                  title: LN.noProductFound),
                                            ]
                                          :

                                          // List.generate(
                                          //     placeOrderPro
                                          //         .selectedvarCombo!
                                          //         .productVariationModifiers!
                                          //         .length, (int i) {
                                          //     final _selectedVarModi = placeOrderPro
                                          //         .selectedvarCombo!
                                          //         .productVariationModifiers![i];

                                          //   })
                                          [
                                              Text.rich(
                                                TextSpan(
                                                    text: _selectedVarModi
                                                            ?.name ??
                                                        '',
                                                    children: [
                                                      if (_selectedVarModi
                                                              ?.isRequired ??
                                                          false)
                                                        TextSpan(
                                                          text: "*",
                                                          style: TextStyle(
                                                            fontSize:
                                                                size.getS(17),
                                                            fontFamily:
                                                                kFontFMedium,
                                                            fontWeight:
                                                                FontWeight
                                                                    .normal,
                                                            color: Colors.red,
                                                          ),
                                                        ),
                                                      if (_selectionCount != 0)
                                                        TextSpan(
                                                          text: _selectionCount ==
                                                                  1
                                                              ? " (Choose only one item)"
                                                              : " (Choose upto ${_selectionCount.formatDouble} items)",
                                                          style: TextStyle(
                                                            fontSize:
                                                                size.getS(17),
                                                            fontFamily:
                                                                kFontFMedium,
                                                            fontWeight:
                                                                FontWeight
                                                                    .normal,
                                                            color:
                                                                kSecondaryColor,
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
                                              if (_selectedVarModi
                                                      ?.modifierItems
                                                      ?.isNotEmpty ??
                                                  false)
                                                GridView.count(
                                                  crossAxisCount:
                                                      GlobalCVP.isHospitality
                                                          ? 5
                                                          : 7,
                                                  childAspectRatio: (OrderUtils
                                                              .productPriceType(
                                                                  widget.product
                                                                      ?.productPriceType) ==
                                                          ProductPriceType
                                                              .MakeYourOwn)
                                                      ? 0.8
                                                      : 0.9,
                                                  shrinkWrap: true,
                                                  physics:
                                                      NeverScrollableScrollPhysics(),
                                                  mainAxisSpacing:
                                                      size.getW(12),
                                                  crossAxisSpacing:
                                                      size.getH(12),
                                                  children: [
                                                    ...List.generate(
                                                        _selectedVarModi!
                                                            .modifierItems!
                                                            .length, (j) {
                                                      final _modifier =
                                                          _selectedVarModi
                                                              .modifierItems![j];
                                                      final _isSelected =
                                                          _modifier.isActive ??
                                                              false;

                                                      final _excedPrice =
                                                          _modifier
                                                                  .additionalPrice
                                                                  ?.inDouble ??
                                                              0.0;

                                                      // final _excedPrice = ((_modifier
                                                      //             .actualPrice
                                                      //             ?.inDouble ??
                                                      //         0) -
                                                      //     (_defaultModiItem
                                                      //             ?.actualPrice
                                                      //             .inDouble ??
                                                      //         0));

                                                      // final _price = (_modifier
                                                      //                 .discountedPrice
                                                      //                 ?.inDouble ??
                                                      //             0) !=
                                                      //         0
                                                      //     ? _modifier
                                                      //         .discountedPrice
                                                      //     : _modifier.actualPrice;

                                                      return InkWell(
                                                        onTap: () {
                                                          _onTabItem(
                                                            placeOrderPro:
                                                                placeOrderPro,
                                                            modifier: _modifier,
                                                            selectedVar:
                                                                _selectedVarModi,
                                                            isSelected:
                                                                _isSelected,
                                                          );
                                                        },
                                                        child: Stack(
                                                          alignment: Alignment
                                                              .topRight,
                                                          children: [
                                                            Card(
                                                              margin: EdgeInsets
                                                                  .fromLTRB(
                                                                      2,
                                                                      size.getH(
                                                                          8),
                                                                      size.getW(
                                                                          8),
                                                                      2),
                                                              elevation: 3,
                                                              shape:
                                                                  RoundedRectangleBorder(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            10),
                                                                side:
                                                                    BorderSide(
                                                                  color: placeOrderPro
                                                                              .currentSelectedModifier?.id ==
                                                                          _modifier
                                                                              .id
                                                                      ? Colors
                                                                          .green
                                                                          .shade600
                                                                      : Colors
                                                                          .transparent,
                                                                  width: placeOrderPro
                                                                              .currentSelectedModifier
                                                                              ?.id ==
                                                                          _modifier
                                                                              .id
                                                                      ? 2
                                                                      : 1.0,
                                                                ),
                                                              ),
                                                              child: Container(
                                                                width: double
                                                                    .infinity,
                                                                padding: EdgeInsets.symmetric(
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
                                                                      child:
                                                                          NetworkImageSec(
                                                                        image: _modifier
                                                                            .imageUrl,
                                                                        height:
                                                                            100,
                                                                        boxFit:
                                                                            BoxFit.cover,
                                                                        width: double
                                                                            .infinity,
                                                                      ),
                                                                    ),
                                                                    SizedBox(
                                                                      height: size
                                                                          .getH(
                                                                              4),
                                                                    ),
                                                                    SizedBox(
                                                                      height: size
                                                                          .getH(
                                                                              48),
                                                                      child:
                                                                          Center(
                                                                        child: Text(
                                                                            (_modifier.productName ?? '') +
                                                                                ((_modifier.variationName?.trim().isNotEmpty ?? false) ? ' (${_modifier.variationName})' : ''),
                                                                            style: TextStyle(
                                                                              fontSize: size.getW(16),
                                                                              color: Colors.black,
                                                                              fontFamily: kFontFMedium,
                                                                              height: 1.2,
                                                                            ),
                                                                            maxLines: 2,
                                                                            textAlign: TextAlign.center,
                                                                            overflow: TextOverflow.ellipsis),
                                                                      ),
                                                                    ),
                                                                    if (_priceType ==
                                                                        ProductPriceType
                                                                            .MakeYourOwn)
                                                                      Padding(
                                                                        padding:
                                                                            EdgeInsets.only(bottom: size.getH(4)),
                                                                        child:
                                                                            ItemPriceView(
                                                                          size:
                                                                              size,
                                                                          curSym:
                                                                              placeOrderPro.curSym,
                                                                          initPrice:
                                                                              _modifier.actualPrice,
                                                                          priceAfterDiscount:
                                                                              _modifier.discountedPrice,
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
                                                                      child: _isSelected &&
                                                                              _prodPriceType != ProductPriceType.FixedPriceFixedProduct
                                                                          ? Container(
                                                                              key: ValueKey('button1'),
                                                                              height: size.getH(36),
                                                                              padding: EdgeInsets.only(bottom: size.getH(4)),
                                                                              alignment: Alignment.center,
                                                                              child: LoadButton(
                                                                                vPad: 2,
                                                                                hPad: 4,
                                                                                btnColor: Colors.red.shade700,
                                                                                textColor: Colors.white,
                                                                                width: 80,
                                                                                fontSize: 14,
                                                                                btnText: "Remove",
                                                                                onsave: () => _onRemoveItem(modifier: _modifier, placeOrderPro: placeOrderPro),
                                                                              ),
                                                                            )
                                                                          : SizedBox(
                                                                              key: ValueKey('empty1'), // Unique key to trigger switch
                                                                              height: 0,
                                                                            ),
                                                                    ),
                                                                    SizedBox(
                                                                      height: size
                                                                          .getH(
                                                                              4),
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
                                                                    child:
                                                                        child);
                                                              },
                                                              child: Card(
                                                                key: ValueKey<
                                                                        bool>(
                                                                    _isSelected),
                                                                elevation: 5,
                                                                color: _isSelected
                                                                    ? Colors
                                                                        .green
                                                                        .shade700
                                                                    : Colors
                                                                        .white,
                                                                shape: RoundedRectangleBorder(
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            100)),
                                                                child: Padding(
                                                                  padding: EdgeInsets
                                                                      .all(size
                                                                          .getS(
                                                                              4)),
                                                                  child: Icon(
                                                                    _isSelected
                                                                        ? Icons
                                                                            .check
                                                                        : Icons
                                                                            .add,
                                                                    size: size
                                                                        .getS(
                                                                            32),
                                                                    color: _isSelected
                                                                        ? Colors
                                                                            .white
                                                                        : Colors
                                                                            .black,
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                            if (_excedPrice > 0)
                                                              Align(
                                                                alignment:
                                                                    Alignment
                                                                        .topLeft,
                                                                child: Card(
                                                                  elevation: 5,
                                                                  color: _isSelected
                                                                      ? Colors
                                                                          .green
                                                                          .shade700
                                                                      : Colors
                                                                          .grey,
                                                                  shape: RoundedRectangleBorder(
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              100)),
                                                                  child:
                                                                      Padding(
                                                                    padding: EdgeInsets.symmetric(
                                                                        vertical:
                                                                            size.getS(
                                                                                4),
                                                                        horizontal:
                                                                            size.getS(12)),
                                                                    child: Text(
                                                                      "+${placeOrderPro.curSym}${_excedPrice.formatDoubleN(digit: 2)}",
                                                                      style: TextStyle(
                                                                          fontSize: size.getS(
                                                                              16),
                                                                          color:
                                                                              Colors.white),
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
                                              // if (placeOrderPro
                                              //             .selectedvarCombo!
                                              //             .productVariationModifiers!
                                              //             .length -
                                              //         1 >
                                              //     i)
                                              //   Divider(),
                                            ],
                                    ),
                                  ),
                                ),
                                if (_ifThereAnyReqCat && !_canAddToCart)
                                  _helperMessage(size,
                                      text:
                                          "Please make a selection from required(*) category before adding this combo to your cart."),
                                // if (_isModifierSelected)
                                //   _helperMessage(size,
                                //       text:
                                //           "Quantity cannot be changed for items with modifiers. Please add it again as a new item."),
                              ],
                            ),
                          ),
                        ),
                      ),
                      if (GlobalCVP.isHospitality)
                        Flexible(
                            flex: 1,
                            child: Card(
                              elevation: 8,
                              shape: RoundedRectangleBorder(
                                side: BorderSide(color: Colors.black12),
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    flex: 2,
                                    child:
                                        // OrderUtils.prodType(placeOrderPro
                                        //             .currentSelectedModifier
                                        //             ?.productType) ==
                                        //         ProductType.Half
                                        //     ? ComboHalfModifierDetailView(
                                        //         currentModifier: placeOrderPro
                                        //             .currentSelectedModifier,
                                        //       )
                                        //     :
                                        ComboItemDetail2(
                                      placeOrderPro: placeOrderPro,
                                      selectedVarModi: _selectedVarModi,
                                      prodPriceType: _prodPriceType,
                                      modiUpdate: () {
                                        // placeOrderPro.selectedvarCombo!.quantity = 1;
                                      },
                                    ),
                                  ),
                                  if (_product?.productVariations?.isNotEmpty ??
                                      false)
                                    Flexible(
                                        flex: 2,
                                        child: Padding(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: size.getW(12)),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              if ((_product?.taxRules
                                                          ?.isNotEmpty ??
                                                      false) &&
                                                  _product!.taxRules!.length >
                                                      1) ...[
                                                Padding(
                                                  padding: EdgeInsets.symmetric(
                                                      horizontal: size.getW(4),
                                                      vertical: size.getH(4)),
                                                  child: Text.rich(
                                                    TextSpan(
                                                        text: "Choose Options ",
                                                        children: [
                                                          // TextSpan(
                                                          //   text:
                                                          //       "(Tax rate varies based on options.)",
                                                          //   style: TextStyle(
                                                          //     fontSize:
                                                          //         size.getS(14),
                                                          //     color:
                                                          //         Colors.black,
                                                          //     fontWeight:
                                                          //         FontWeight
                                                          //             .normal,
                                                          //   ),
                                                          // )
                                                        ]),
                                                    style: TextStyle(
                                                      fontSize: size.getS(16),
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.black,
                                                    ),
                                                  ),
                                                ),
                                                if (_product.taxRules!.length <
                                                    4)
                                                  Row(
                                                    children: List.generate(
                                                        _product
                                                            .taxRules!.length,
                                                        (index) => Expanded(
                                                                child: SelectiveTab
                                                                    .taxTypeSec(
                                                              size,
                                                              fontRatio: 0.4,
                                                              isSelect: index ==
                                                                  _product
                                                                      .taxRuleIndex,
                                                              title: _product
                                                                  .taxRules![
                                                                      index]
                                                                  .taxRuleName,
                                                              onTap: () {
                                                                _product.taxRuleIndex =
                                                                    index;
                                                                placeOrderPro
                                                                    .notify;
                                                              },
                                                            ))),
                                                  )
                                                else
                                                  Wrap(
                                                    children: List.generate(
                                                        _product
                                                            .taxRules!.length,
                                                        (index) => SelectiveTab
                                                                .taxTypeSec(
                                                              size,
                                                              fontRatio: 0.4,
                                                              isSelect: index ==
                                                                  _product
                                                                      .taxRuleIndex,
                                                              title: _product
                                                                  .taxRules![
                                                                      index]
                                                                  .taxRuleName,
                                                              onTap: () {
                                                                _product.taxRuleIndex =
                                                                    index;
                                                                placeOrderPro
                                                                    .notify;
                                                              },
                                                            )),
                                                  )
                                              ],
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
                                                        fontFamily:
                                                            kFontFMedium,
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
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      // runSpacing: size.getH(12),
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
                                                                          ((e.isActive ?? false)
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
                                                                  ((_selectedVarModi
                                                                              .isRequired ??
                                                                          false)
                                                                      ? '*'
                                                                      : '') +
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
                                          ),
                                        ))
                                ],
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
                                  if ((placeOrderPro.selectedvarCombo
                                              ?.discountPercentage?.inDouble ??
                                          0) !=
                                      0)
                                    TextSpan(
                                      text:
                                          "${placeOrderPro.curSym ?? ''}${placeOrderPro.selectedvarCombo?.discountedPrice ?? '0.00'} ",
                                      style: TextStyle(
                                        decoration: TextDecoration.none,
                                        overflow: TextOverflow.visible,
                                      ),
                                    ),
                                  TextSpan(
                                    text:
                                        "${placeOrderPro.curSym ?? ''}${placeOrderPro.selectedvarCombo?.actualPrice ?? '0.00'}",
                                    style: (placeOrderPro
                                                    .selectedvarCombo
                                                    ?.discountPercentage
                                                    ?.inDouble ??
                                                0) !=
                                            0
                                        ? TextStyle(
                                            decoration:
                                                TextDecoration.lineThrough,
                                            fontSize: size.getS(18),
                                            color: Colors.red,
                                            overflow: TextOverflow.visible,
                                          )
                                        : null,
                                  ),
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
                            if ((placeOrderPro.selectedvarCombo
                                        ?.discountPercentage?.inDouble ??
                                    0) !=
                                0)
                              Container(
                                margin: EdgeInsets.symmetric(
                                    horizontal: size.getW(8)),
                                decoration: BoxDecoration(
                                  color: Colors.red.shade800,
                                  // shape: BoxShape.circle,
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                padding: EdgeInsets.symmetric(
                                    vertical: size.getS(6),
                                    horizontal: size.getS(8)),
                                child: Text(
                                  "${placeOrderPro.selectedvarCombo?.discountPercentage?.inQty}% OFF",
                                  style: TextStyle(
                                    fontSize: size.getS(16),
                                    color: Colors.white,
                                    fontFamily: kFontFMedium,
                                  ),
                                ),
                              ),

                            // Text(
                            //   "${LN.price}  ${placeOrderPro.curSym}${setMenu?.setMenuPrice ?? ''}",
                            //   style: TextStyle(
                            //     fontSize: size.getS(20),
                            //     fontFamily: kFontFMedium,
                            //     color: Colors.black,
                            //   ),
                            // ),
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
                            _disableSection(
                              readOnly: false, // _isModifierSelected,
                              child: QuantitySection(
                                quantity: placeOrderPro
                                        .selectedvarCombo?.quantity
                                        .toDouble() ??
                                    1,
                                size: size,
                                fr: 1.2,
                                update: (p0) {
                                  if (p0 == null) return;

                                  if (p0)
                                    placeOrderPro.selectedvarCombo!.quantity++;
                                  else {
                                    if (placeOrderPro
                                            .selectedvarCombo!.quantity <
                                        2) return;
                                    placeOrderPro.selectedvarCombo!.quantity--;
                                  }
                                  placeOrderPro.notify;
                                },
                              ),
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
                                  style: TextStyle(
                                    fontSize: size.getS(18),
                                    color: Colors.white,
                                    fontFamily: kFontFMedium,
                                  ),
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
                                        // placeOrderPro.updateSetMenuOnCart(
                                        //   upIndex: widget.upIndex,
                                        // );
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
                                      "${widget.upIndex != null ? LN.update : LN.addToCart} - ${placeOrderPro.curSym}${_getTotalAmount().roundToNString()}",
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

  Widget _disableSection({bool readOnly = false, required Widget child}) {
    return IgnorePointer(
      ignoring: readOnly,
      child: Opacity(
        opacity: readOnly ? 0.3 : 1,
        child: child,
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(top: size.getH(2)),
            child: Icon(
              Icons.info_outline,
              size: size.getS(18),
              color: Colors.red,
            ),
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
