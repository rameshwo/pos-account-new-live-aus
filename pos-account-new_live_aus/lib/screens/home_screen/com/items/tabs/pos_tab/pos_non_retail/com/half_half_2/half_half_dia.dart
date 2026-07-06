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
import 'package:pos_account/screens/home_screen/com/items/com/item_sec_tile.dart';
import 'package:pos_account/screens/home_screen/com/variance/selective_tab.dart';
import 'package:pos_account/widgets/image/image_error.dart';
import 'package:pos_account/widgets/image/network_image_sec.dart';
import 'package:pos_account/widgets/loading.dart';
import 'package:pos_account/widgets/no_items_sec.dart';
import 'package:provider/provider.dart';
import 'com/new_modi_sec.dart';
import 'com/new_raw_ingre_sec.dart';
import 'com/new_spice_sec.dart';
import 'half_item_view.dart';

class HalfnHalfDia extends StatefulWidget {
  final FeaturedProduct? product;
  final int? upIndex;
  const HalfnHalfDia({
    super.key,
    this.upIndex,
    this.product,
  });

  @override
  State<HalfnHalfDia> createState() => _HalfnHalfDiaState();
}

class _HalfnHalfDiaState extends State<HalfnHalfDia> {
  // final _scrollCltr = ScrollController();

  // late ListObserverController observerController =
  //     ListObserverController(controller: _scrollCltr);

  // Future<void> _scrollToNextItem(int _index) async {
  //   observerController.animateTo(
  //     index: _index,
  //     duration: Duration(milliseconds: 1200),
  //     curve: Curves.ease,
  //   );
  // }

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
        // log(json.encode(_placePro.orderList[widget.upIndex!].toJson()));

        _placePro.selectedvarHalfnHalf = _varList.firstWhere((a) =>
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

        _varList.forEach((e) => e.isDefault = false);

        _placePro.selectedvarHalfnHalf?.isDefault = true;
        if (_placePro.orderList[widget.upIndex!].orderItemModifiersViewModels !=
            null) {
          for (final b in _placePro
              .orderList[widget.upIndex!].orderItemModifiersViewModels!
              .where((e) => e.isActive)
              .toList()) {
            if (_placePro.selectedvarHalfnHalf?.productVariationModifiers?.any(
                    (c) =>
                        c.modifierItems?.any((d) =>
                            d.id?.toLowerCase() ==
                            b.priceVariationModifierId?.toLowerCase()) ??
                        false) ??
                false) {
              final _data1 = _placePro
                  .selectedvarHalfnHalf?.productVariationModifiers
                  ?.firstWhere((c) =>
                      c.modifierItems?.any((d) =>
                          d.id?.toLowerCase() ==
                          b.priceVariationModifierId?.toLowerCase()) ??
                      false);

              final _halfData = _data1?.modifierItems?.firstWhere((d) =>
                  d.id?.toLowerCase() ==
                  b.priceVariationModifierId?.toLowerCase());

              if (b.modifierItemsModifierViewModels != null) {
                for (final f in b.modifierItemsModifierViewModels!
                    .where((k) => k.isActive)
                    .toList()) {
                  final _data2 = _halfData?.modifierItemModifiers?.any((g) =>
                              g.modifierItems?.any((h) =>
                                  h.id?.toLowerCase() ==
                                  f.priceVariationModifierId?.toLowerCase()) ??
                              false) ??
                          false
                      ? _halfData?.modifierItemModifiers?.firstWhere((g) =>
                          g.modifierItems?.any((h) =>
                              h.id?.toLowerCase() ==
                              f.priceVariationModifierId?.toLowerCase()) ??
                          false)
                      : null;
                  final _modifiers = _data2?.modifierItems?.firstWhere((j) =>
                      j.id?.toLowerCase() ==
                      f.priceVariationModifierId?.toLowerCase());

                  _modifiers?.quantity = f.quantity ?? 1;
                  _modifiers?.isActive = f.isActive;
                  _modifiers?.updateId = f.id ?? '';
                }
              }
              if (b.labelName
                      ?.toLowerCase()
                      .contains(HalfItemTypeEnum.first.name) ??
                  false) {
                _placePro.firstHalf = _halfData;
                _placePro.currentSelectedModifier = _halfData;
              } else if (b.labelName
                      ?.toLowerCase()
                      .contains(HalfItemTypeEnum.second.name) ??
                  false) {
                _placePro.secondHalf = _halfData;
              } else if (b.labelName
                      ?.toLowerCase()
                      .contains(HalfItemTypeEnum.third.name) ??
                  false) {
                _placePro.thirdHalf = _halfData;
              } else if (b.labelName
                      ?.toLowerCase()
                      .contains(HalfItemTypeEnum.fourth.name) ??
                  false) {
                _placePro.fourthHalf = _halfData;
              }
            }
          }
        }
      } else {
        _placePro.selectedvarHalfnHalf = _varList.firstWhere(
            (e) => e.isDefault ?? false,
            orElse: () => _varList.first..isDefault = true);
      }
    }
    _placePro.notify;
  }

  void _clearOnRemove(ModifierItem? _item) {
    _item?.quantity = 1;
    if (_item?.modifierItemModifiers != null)
      for (final d in _item!.modifierItemModifiers!) {
        d.modifierItems?.forEach((e) {
          e.isActive = false;
          e.quantity = 1;
        });
      }
  }

  void _onTabItem({
    required PlaceOrderPro placeOrderPro,
    ModifierItem? modifier,
    // bool isSingleSelect = false,
    // required int i,
    ProductVariationModifier? selectedVar,
    bool isSelected = false,
  }) {
    if (modifier == null) {
      return;
    }

    _clearOnRemove(placeOrderPro.currentSelectedModifier);

    if (selectedVar == null) return;

    // final _selectedVar =
    //     placeOrderPro.selectedvarHalfnHalf!.productVariationModifiers![i];

    if (selectedVar.name?.toLowerCase().contains(HalfItemTypeEnum.first.name) ??
        false) {
      placeOrderPro.selectedHalfEnum = HalfItemTypeEnum.first;
    } else if (selectedVar.name
            ?.toLowerCase()
            .contains(HalfItemTypeEnum.second.name) ??
        false) {
      placeOrderPro.selectedHalfEnum = HalfItemTypeEnum.second;
    }

    placeOrderPro.currentSelectedModifier = modifier;

    if (!isSelected) {
      selectedVar.modifierItems?.forEach((e) {
        e.isActive = false;
      });

      final _isSingleSelect =
          selectedVar.selectionType?.toLowerCase().contains('single') ?? false;

      if (placeOrderPro.selectedHalfEnum == HalfItemTypeEnum.first) {
        if (!_isSingleSelect ||
            !selectedVar.modifierItems!.any((e) => [
                  placeOrderPro.secondHalf?.id,
                  placeOrderPro.thirdHalf?.id,
                  placeOrderPro.fourthHalf?.id
                ].contains(e.id))) {
          placeOrderPro.firstHalf = modifier..isActive = true;
        }
      } else if (placeOrderPro.selectedHalfEnum == HalfItemTypeEnum.second) {
        if (!_isSingleSelect ||
            !selectedVar.modifierItems!.any((e) => [
                  placeOrderPro.firstHalf?.id,
                  placeOrderPro.thirdHalf?.id,
                  placeOrderPro.fourthHalf?.id
                ].contains(e.id))) {
          placeOrderPro.secondHalf = modifier..isActive = true;
        }
      } else if (placeOrderPro.selectedHalfEnum == HalfItemTypeEnum.third) {
        if (!_isSingleSelect ||
            !selectedVar.modifierItems!.any((e) => [
                  placeOrderPro.firstHalf?.id,
                  placeOrderPro.secondHalf?.id,
                  placeOrderPro.fourthHalf?.id
                ].contains(e.id))) {
          placeOrderPro.thirdHalf = modifier..isActive = true;
        }
      } else if (placeOrderPro.selectedHalfEnum == HalfItemTypeEnum.fourth) {
        if (!_isSingleSelect ||
            !selectedVar.modifierItems!.any((e) => [
                  placeOrderPro.firstHalf?.id,
                  placeOrderPro.secondHalf?.id,
                  placeOrderPro.thirdHalf?.id
                ].contains(e.id))) {
          placeOrderPro.fourthHalf = modifier..isActive = true;
        }
      }
    }

    placeOrderPro.varianceLoading = true;

    placeOrderPro.notify;

    Future.delayed(Duration(milliseconds: 100), () {
      placeOrderPro.varianceLoading = false;
      // if (placeOrderPro.selectedHalfEnum == HalfEnum.First &&
      //     placeOrderPro.secondHalf == null) {
      //   placeOrderPro.selectedHalfEnum = HalfEnum.Second;
      // }

      placeOrderPro.notify;
    });
  }

  // Future<void> removeItem({
  //   ModifierItem? modifier,
  //   required PlaceOrderPro placeOrderPro,
  // }) async {
  // if (placeOrderPro.firstHalf?.id == modifier?.id) {
  //   placeOrderPro.firstHalf = null;
  // } else if (placeOrderPro.secondHalf?.id == modifier?.id) {
  //   placeOrderPro.secondHalf = null;
  // }
  // placeOrderPro.currentSelectedModifier = null;
  // placeOrderPro.notify;
  // }

  void addToCart(
    PlaceOrderPro placeOrderPro,
    FeaturedProduct _product, {
    bool isNew = false,
  }) {
    if (_product.productVariations == null ||
        !_product.productVariations!.any((e) => e.isDefault ?? false)) return;

    final e =
        _product.productVariations!.firstWhere((e) => e.isDefault ?? false);

    // log(json.encode(e.toJson()));

    placeOrderPro.updateOrderCart(
      product: _product..quantity = e.quantity,
      variation: e
        ..actualPrice =
            HalfItemViewSection(placeOrderPro: placeOrderPro, product: _product)
                .getHigherItemPrice()
                .toString(),
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

    Navigator.pop(context);
    // Future.delayed(Duration(milliseconds: 500), () {
    //   // onPopUp(_product);
    // });
  }

  @override
  void dispose() {
    _placePro.selectedvarHalfnHalf = null;
    _placePro.currentSelectedModifier = null;
    _placePro.firstHalf = null;
    _placePro.secondHalf = null;
    _placePro.thirdHalf = null;
    _placePro.fourthHalf = null;
    _placePro.selectedHalfEnum = HalfItemTypeEnum.first;
    onPopUp(widget.product);
    // _scrollCltr.dispose();
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

  void _showVarDia({
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
    final placeOrderPro = Provider.of<PlaceOrderPro>(context);

    final _product =
        placeOrderPro.productDetailView?.productListViewModel ?? widget.product;

    _product
      ?..productType = widget.product?.productType
      ..productPriceType = widget.product?.productPriceType;

    final _selectedVarModi = (placeOrderPro
                .selectedvarHalfnHalf?.productVariationModifiers
                ?.any((a) {
              if (placeOrderPro.selectedHalfEnum == HalfItemTypeEnum.first) {
                return a.name
                        ?.toLowerCase()
                        .contains(HalfItemTypeEnum.first.name) ??
                    false;
              } else if (placeOrderPro.selectedHalfEnum ==
                  HalfItemTypeEnum.second) {
                return a.name
                        ?.toLowerCase()
                        .contains(HalfItemTypeEnum.second.name) ??
                    false;
              } else if (placeOrderPro.selectedHalfEnum ==
                  HalfItemTypeEnum.third) {
                return a.name
                        ?.toLowerCase()
                        .contains(HalfItemTypeEnum.third.name) ??
                    false;
              } else {
                return a.name
                        ?.toLowerCase()
                        .contains(HalfItemTypeEnum.fourth.name) ??
                    false;
              }
            }) ??
            false)
        ? placeOrderPro.selectedvarHalfnHalf?.productVariationModifiers
            ?.firstWhere((a) {
            if (placeOrderPro.selectedHalfEnum == HalfItemTypeEnum.first) {
              return a.name
                      ?.toLowerCase()
                      .contains(HalfItemTypeEnum.first.name) ??
                  false;
            } else if (placeOrderPro.selectedHalfEnum ==
                HalfItemTypeEnum.second) {
              return a.name
                      ?.toLowerCase()
                      .contains(HalfItemTypeEnum.second.name) ??
                  false;
            } else if (placeOrderPro.selectedHalfEnum ==
                HalfItemTypeEnum.third) {
              return a.name
                      ?.toLowerCase()
                      .contains(HalfItemTypeEnum.third.name) ??
                  false;
            } else {
              return a.name
                      ?.toLowerCase()
                      .contains(HalfItemTypeEnum.fourth.name) ??
                  false;
            }
          })
        : null;

    final _priceType = OrderUtils.productPriceType(_product?.productPriceType);

    final _modiList = placeOrderPro
        .currentSelectedModifier?.modifierItemModifiers
        ?.where((a) => a.modifierItems?.isNotEmpty ?? false)
        .toList();

    return Processing(
      loading: placeOrderPro.productDetailView == null &&
          placeOrderPro.varianceLoading,
      child: Container(
        // constraints: BoxConstraints(
        //   maxHeight: size.height / 1.15,
        //   minHeight: size.height / 4,
        // ),
        height: size.height,
        width: size.width,
        padding: EdgeInsets.symmetric(
            vertical: size.getH(8), horizontal: size.getW(16)),
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
                        text: (_product?.name ?? 'Half n Half'),
                      ),
                      style: TextStyle(
                        fontSize: size.getS(22),
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
                //

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
                                  child: ListView(
                                      // controller: _scrollCltr,
                                      shrinkWrap: true,
                                      padding: EdgeInsets.symmetric(
                                          vertical: size.getH(12),
                                          horizontal: size.getW(12)),
                                      children: placeOrderPro
                                                      .selectedvarHalfnHalf
                                                      ?.productVariationModifiers ==
                                                  null ||
                                              placeOrderPro
                                                  .selectedvarHalfnHalf!
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
                                          //         .selectedvarHalfnHalf!
                                          //         .productVariationModifiers!
                                          //         .length, (int i) {
                                          //     final _selectedVarModi = placeOrderPro
                                          //         .selectedvarHalfnHalf!
                                          //         .productVariationModifiers![i];
                                          //     final _isSingleSelect = _selectedVarModi
                                          //             .selectionType
                                          //             ?.toLowerCase()
                                          //             .contains('single') ??
                                          //         false;

                                          //     return ;
                                          //   }),

                                          [
                                              Text.rich(
                                                TextSpan(
                                                    text: _selectedVarModi
                                                            ?.name ??
                                                        '',
                                                    children: [
                                                      TextSpan(
                                                        text:
                                                            " (Choose ${_selectedVarModi?.selectionType ?? ''} item)",
                                                        style: TextStyle(
                                                          fontSize:
                                                              size.getS(16),
                                                          fontFamily:
                                                              kFontFMedium,
                                                          color:
                                                              kSecondaryColor,
                                                        ),
                                                      )
                                                    ]),
                                                style: TextStyle(
                                                  fontSize: size.getS(18),
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
                                                  crossAxisCount: 5,
                                                  // : (size.isProt ? 5 : 6),
                                                  childAspectRatio: (OrderUtils
                                                              .productPriceType(
                                                                  widget.product
                                                                      ?.productPriceType) ==
                                                          ProductPriceType
                                                              .MakeYourOwn)
                                                      ? 1.0
                                                      : 1.1,
                                                  shrinkWrap: true,
                                                  physics:
                                                      NeverScrollableScrollPhysics(),
                                                  mainAxisSpacing: size.getW(0),
                                                  crossAxisSpacing:
                                                      size.getH(0),
                                                  children: [
                                                    ...List.generate(
                                                        _selectedVarModi!
                                                            .modifierItems!
                                                            .length, (j) {
                                                      final _modifier =
                                                          _selectedVarModi
                                                              .modifierItems![j];
                                                      final _isSelected =
                                                          placeOrderPro
                                                                      .firstHalf
                                                                      ?.id ==
                                                                  _modifier
                                                                      .id ||
                                                              placeOrderPro
                                                                      .secondHalf
                                                                      ?.id ==
                                                                  _modifier
                                                                      .id ||
                                                              placeOrderPro
                                                                      .thirdHalf
                                                                      ?.id ==
                                                                  _modifier
                                                                      .id ||
                                                              placeOrderPro
                                                                      .fourthHalf
                                                                      ?.id ==
                                                                  _modifier.id;

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
                                                                          .black12,
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
                                                                            120,
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
                                                                              40),
                                                                      child:
                                                                          Center(
                                                                        child: Text(
                                                                            (_modifier.productName ??
                                                                                ''),
                                                                            //     +
                                                                            // (product.productVariationName !=
                                                                            //             null &&
                                                                            //         product.productVariationName!
                                                                            //             .trim()
                                                                            //             .isNotEmpty
                                                                            //     ? '(${product.productVariationName})'
                                                                            //     : ''),
                                                                            style:
                                                                                TextStyle(
                                                                              fontSize: size.getW(16),
                                                                              color: Colors.black,
                                                                              fontFamily: kFontFMedium,
                                                                              height: 1.2,
                                                                            ),
                                                                            maxLines:
                                                                                2,
                                                                            textAlign:
                                                                                TextAlign.center,
                                                                            overflow: TextOverflow.ellipsis),
                                                                      ),
                                                                    ),
                                                                    if (OrderUtils.productPriceType(widget
                                                                            .product
                                                                            ?.productPriceType) ==
                                                                        ProductPriceType
                                                                            .MakeYourOwn)
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
                                                                    // SizedBox(
                                                                    //   height: size
                                                                    //       .getH(24),
                                                                    //   child: Text(
                                                                    //       "${placeOrderPro.curSym}$_price",
                                                                    //       style:
                                                                    //           TextStyle(
                                                                    //         fontSize:
                                                                    //             size.getW(
                                                                    //                 16),
                                                                    //         color: Colors
                                                                    //             .black,
                                                                    //         fontFamily:
                                                                    //             kFontFMedium,
                                                                    //       ),
                                                                    //       maxLines: 2,
                                                                    //       textAlign:
                                                                    //           TextAlign
                                                                    //               .center,
                                                                    //       overflow:
                                                                    //           TextOverflow
                                                                    //               .ellipsis),
                                                                    // ),
                                                                    // SizedBox(
                                                                    //   height: size
                                                                    //       .getH(
                                                                    //           4),
                                                                    // ),
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
                                              //             .selectedvarHalfnHalf!
                                              //             .productVariationModifiers!
                                              //             .length -
                                              //         1 >
                                              //     i)
                                              //   Divider(),
                                            ]),
                                ),
                                _helperMessage(
                                  size,
                                  text: (_priceType ==
                                          ProductPriceType.MakeYourOwn
                                      ? 'Highest price will be choosen'
                                      : _priceType ==
                                              ProductPriceType.FixedPrice
                                          ? 'Fixed price will be choosen'
                                          : 'Item\'s average price will be choosen'),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Flexible(
                        flex: 1,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Flexible(
                                flex: 3,
                                child: Card(
                                  elevation: 3,
                                  shape: RoundedRectangleBorder(
                                    side: BorderSide(color: Colors.black12),
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  child: SizedBox(
                                    height: double.maxFinite,
                                    width: double.maxFinite,
                                    child: Column(
                                      children: [
                                        if (placeOrderPro
                                                .currentSelectedModifier !=
                                            null) ...[
                                          Row(
                                            children: [
                                              ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          100),
                                                  child: CachedNetworkImage(
                                                      imageUrl: placeOrderPro
                                                              .currentSelectedModifier
                                                              ?.imageUrl ??
                                                          '',
                                                      height: size.getW(60),
                                                      width: size.getW(60),
                                                      fit: BoxFit.fitHeight,
                                                      placeholder:
                                                          ImageError.load,
                                                      errorWidget: ImageError
                                                          .notSupportIcon)),
                                              SizedBox(
                                                width: size.getW(12),
                                              ),
                                              Flexible(
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      "Customize ${placeOrderPro.currentSelectedModifier?.productName ?? ''}${placeOrderPro.currentSelectedModifier?.variationName?.trim().isNotEmpty ?? false ? " (${placeOrderPro.currentSelectedModifier?.variationName ?? ''})" : ""}",
                                                      style: TextStyle(
                                                        fontSize: size.getS(16),
                                                        color: Colors.black,
                                                        fontFamily:
                                                            kFontFMedium,
                                                      ),
                                                    ),
                                                    if (placeOrderPro
                                                            .currentSelectedModifier
                                                            ?.promoModel !=
                                                        null)
                                                      Container(
                                                        margin: EdgeInsets.only(
                                                            top: size.getW(4)),
                                                        padding: EdgeInsets
                                                            .symmetric(
                                                                horizontal: size
                                                                    .getW(16),
                                                                vertical: size
                                                                    .getH(2)),
                                                        decoration: BoxDecoration(
                                                            color: Colors.green,
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        10)),
                                                        child: Text(
                                                          "● Promotion applied",
                                                          style: TextStyle(
                                                            fontSize:
                                                                size.getS(14),
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color: Colors.white,
                                                          ),
                                                        ),
                                                      ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                          SizedBox(height: size.getH(8)),

                                          // if (placeOrderPro.varianceLoading)
                                          //   Expanded(child: Loading())
                                          // else
                                          Expanded(
                                            child: SingleChildScrollView(
                                              child: Column(
                                                children: [
                                                  if (_modiList?.isNotEmpty ??
                                                      false)
                                                    GridView.count(
                                                      crossAxisCount: 2,
                                                      childAspectRatio: 6,
                                                      shrinkWrap: true,
                                                      padding:
                                                          EdgeInsets.symmetric(
                                                              horizontal: size
                                                                  .getW(12)),
                                                      physics:
                                                          NeverScrollableScrollPhysics(),
                                                      mainAxisSpacing:
                                                          size.getW(12),
                                                      crossAxisSpacing:
                                                          size.getH(12),
                                                      children: [
                                                        ...List.generate(
                                                            _modiList!.length,
                                                            (index) {
                                                          final _modiData =
                                                              _modiList[index];
                                                          final _totalQty = _modiData
                                                                  .modifierItems
                                                                  ?.fold<double>(
                                                                      0,
                                                                      (pV, eV) =>
                                                                          pV +
                                                                          ((eV.isActive ?? false)
                                                                              ? eV.quantity
                                                                              : 0)) ??
                                                              0;

                                                          final _modiType =
                                                              OrderUtils
                                                                  .getModifierType(
                                                                      _modiData
                                                                          .type);

                                                          return InkWell(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        5),
                                                            onTap: () {
                                                              _showVarDia(
                                                                placeOrderPro:
                                                                    placeOrderPro,
                                                                modiData:
                                                                    _modiData,
                                                              );
                                                            },
                                                            child: Card(
                                                              color: _totalQty !=
                                                                      0
                                                                  ? kSecondaryColor
                                                                  : Colors
                                                                      .white,
                                                              margin: EdgeInsets
                                                                  .zero,
                                                              shape: RoundedRectangleBorder(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              5),
                                                                  side: BorderSide(
                                                                      color:
                                                                          kSecondaryColor)),
                                                              child: Center(
                                                                child: Padding(
                                                                  padding: EdgeInsets.symmetric(
                                                                      vertical:
                                                                          size.getH(
                                                                              6),
                                                                      horizontal:
                                                                          size.getW(
                                                                              20)),
                                                                  child:
                                                                      Text.rich(
                                                                    TextSpan(
                                                                        text: (_modiData.name ??
                                                                            ''),
                                                                        children: [
                                                                          if (_totalQty !=
                                                                              0) ...[
                                                                            TextSpan(text: ' ('),
                                                                            TextSpan(
                                                                              text: _totalQty.formatDouble,
                                                                              style: TextStyle(
                                                                                fontWeight: FontWeight.bold,
                                                                                decoration: _modiType == ModifierType.rawingre ? TextDecoration.lineThrough : null,
                                                                              ),
                                                                            ),
                                                                            TextSpan(text: ')')
                                                                          ]
                                                                        ]),
                                                                    style:
                                                                        TextStyle(
                                                                      fontSize:
                                                                          size.getS(
                                                                              16),
                                                                      fontFamily:
                                                                          kFontFMedium,
                                                                      color: _totalQty !=
                                                                              0
                                                                          ? Colors
                                                                              .white
                                                                          : kSecondaryColor,
                                                                    ),
                                                                    textAlign:
                                                                        TextAlign
                                                                            .center,
                                                                    maxLines: 1,
                                                                    overflow:
                                                                        TextOverflow
                                                                            .ellipsis,
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                          );
                                                        }),
                                                      ],
                                                    ),
                                                  // if (placeOrderPro
                                                  //         .currentSelectedModifier
                                                  //         ?.modifierItemModifiers
                                                  //         ?.isNotEmpty ??
                                                  //     false)
                                                  //   AnimatedSwitcher(
                                                  //     duration: Duration(
                                                  //         milliseconds:
                                                  //             300),
                                                  //     child:
                                                  //         ModifierSection(
                                                  //       width: 300,
                                                  //       key: ValueKey(
                                                  //           placeOrderPro
                                                  //               .varianceLoading),
                                                  //       curSym: placeOrderPro
                                                  //               .curSym ??
                                                  //           '',
                                                  //       productPriceModifiers: placeOrderPro
                                                  //               .currentSelectedModifier
                                                  //               ?.modifierItemModifiers
                                                  //               ?.whereModiType(
                                                  //                   ModifierType
                                                  //                       .modifier) ??
                                                  //           [],
                                                  //       update: (
                                                  //               {bool?
                                                  //                   isItemSelected}) =>
                                                  //           placeOrderPro
                                                  //               .notify,
                                                  //     ),
                                                  //   )
                                                  // else
                                                  //   NoItemsSec(
                                                  //     size: size,
                                                  //     title:
                                                  //         "No Modifier found",
                                                  //     iconHeight: 140,
                                                  //   ),
                                                  // SizedBox(
                                                  //     height:
                                                  //         size.getH(12)),
                                                  // IngredientSec(
                                                  //   productIngredients: placeOrderPro
                                                  //           .currentSelectedModifier
                                                  //           ?.modifierItemModifiers
                                                  //           ?.whereModiType(
                                                  //               ModifierType
                                                  //                   .rawingre) ??
                                                  //       [],
                                                  //   onUpdate: () {
                                                  //     placeOrderPro.notify;
                                                  //   },
                                                  // ),
                                                  // SpiceSection(
                                                  //   isItem: false,
                                                  //   spiceList: placeOrderPro
                                                  //       .currentSelectedModifier
                                                  //       ?.modifierItemModifiers
                                                  //       ?.whereModiType(
                                                  //           ModifierType
                                                  //               .spice),
                                                  //   onChanged: () {
                                                  //     placeOrderPro.notify;
                                                  //   },
                                                  // ),
                                                  // SizedBox(
                                                  //     height:
                                                  //         size.getH(24)),
                                                ],
                                              ),
                                            ),
                                          )
                                        ] else
                                          NoItemsSec(
                                            size: size,
                                            title: "No items has been selected",
                                            iconHeight: 150,
                                          )
                                      ],
                                    ),
                                  ),
                                )),
                            if ((_product?.taxRules?.isNotEmpty ?? false) &&
                                _product!.taxRules!.length > 1) ...[
                              Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: size.getW(4),
                                    vertical: size.getH(4)),
                                child: Text.rich(
                                  TextSpan(text: "Choose Options ", children: [
                                    // TextSpan(
                                    //   text:
                                    //       "(Tax rate varies based on options.)",
                                    //   style: TextStyle(
                                    //     fontSize: size.getS(14),
                                    //     color: Colors.black,
                                    //     fontWeight: FontWeight.normal,
                                    //   ),
                                    // )
                                  ]),
                                  style: TextStyle(
                                    fontSize: size.getS(16),
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                              if (_product.taxRules!.length < 4)
                                Row(
                                  children: List.generate(
                                      _product.taxRules!.length,
                                      (index) => Expanded(
                                              child: SelectiveTab.taxTypeSec(
                                            size,
                                            fontRatio: 0.4,
                                            isSelect:
                                                index == _product.taxRuleIndex,
                                            title: _product
                                                .taxRules![index].taxRuleName,
                                            onTap: () {
                                              _product.taxRuleIndex = index;
                                              placeOrderPro.notify;
                                            },
                                          ))),
                                )
                              else
                                Wrap(
                                  children: List.generate(
                                      _product.taxRules!.length,
                                      (index) => SelectiveTab.taxTypeSec(
                                            size,
                                            fontRatio: 0.4,
                                            isSelect:
                                                index == _product.taxRuleIndex,
                                            title: _product
                                                .taxRules![index].taxRuleName,
                                            onTap: () {
                                              _product.taxRuleIndex = index;
                                              placeOrderPro.notify;
                                            },
                                          )),
                                )
                            ],
                            Flexible(
                                flex: 5,
                                child: Card(
                                  elevation: 3,
                                  shape: RoundedRectangleBorder(
                                    side: BorderSide(color: Colors.black12),
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  child: SizedBox(
                                    height: double.maxFinite,
                                    width: double.maxFinite,
                                    child: Padding(
                                      padding: EdgeInsets.all(size.getS(8)),
                                      child: HalfItemViewSection(
                                        placeOrderPro: placeOrderPro,
                                        product: _product,
                                        addToCart: () {
                                          addToCart(placeOrderPro, _product!);
                                        },
                                        addCartText: widget.upIndex != null
                                            ? LN.update
                                            : LN.addToCart,
                                        // onSelectHalf: (val) {
                                        // final _length = placeOrderPro
                                        //         .selectedvarHalfnHalf
                                        //         ?.productVariationModifiers
                                        //         ?.length ??
                                        //     0;
                                        // if (_length > 1) {
                                        //   if (val == HalfEnum.First) {
                                        //     _scrollToNextItem(0);
                                        //   } else if (val == HalfEnum.Second) {
                                        //     _scrollToNextItem(1);
                                        //   }
                                        // }
                                        // },
                                      ),
                                    ),
                                  ),
                                )),
                          ],
                        ),
                      )
                    ],
                  )),
              ]),
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
          color: kSecondaryColor.withOpacity(0.1),
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
              color: kSecondaryColor,
            ),
          ),
          SizedBox(width: size.getW(6)),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                color: kSecondaryColor,
                fontSize: size.getS(14),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
