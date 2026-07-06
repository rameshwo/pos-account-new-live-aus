import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:pos_account/config/size_config.dart';
import 'package:pos_account/config/utils/order_utils.dart';
import 'package:pos_account/config/validator.dart';
import 'package:pos_account/constant/constant.dart';
import 'package:pos_account/ln.dart';
import 'package:pos_account/model/home/menu/place_order/pos_res/com/feature_product.dart';
import 'package:pos_account/providers/menu/place_order_pro.dart';
import 'package:pos_account/screens/home_screen/com/items/com/item_sec_tile.dart';
import 'package:pos_account/screens/home_screen/com/items/tabs/pos_tab/pos_non_retail/com/half_half_2/com/new_modi_sec.dart';
import 'package:pos_account/screens/home_screen/com/items/tabs/pos_tab/pos_non_retail/com/half_half_2/com/new_raw_ingre_sec.dart';
import 'package:pos_account/screens/home_screen/com/items/tabs/pos_tab/pos_non_retail/com/half_half_2/com/new_spice_sec.dart';
import 'package:pos_account/widgets/image/image_error.dart';
import 'package:pos_account/widgets/image/network_image_sec.dart';
import 'package:pos_account/widgets/no_items_sec.dart';
import 'package:provider/provider.dart';
import 'deal_half_item_view.dart';

class DealHalfDia extends StatefulWidget {
  final ModifierItem? modifierItem;
  const DealHalfDia({
    super.key,
    this.modifierItem,
  });

  @override
  State<DealHalfDia> createState() => _DealHalfDiaState();
}

class _DealHalfDiaState extends State<DealHalfDia> {
  @override
  void initState() {
    _getData();
    super.initState();
  }

  late PlaceOrderPro _placePro;

  Future<void> _getData() async {
    _placePro = Provider.of<PlaceOrderPro>(context, listen: false);
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      setData();
    });
  }

  void setData() {
    // _modifierItem = ModifierItem.fromJson(widget.modifierItem!.toJson());
    // _modifierItem?.halfItemPrice = widget.modifierItem!.halfItemPrice;
    _modifierItem = widget.modifierItem;

    // log(json.encode(_modifierItem?.toJson()));
    //  != null
    //     ? ModifierItem.fromJson(widget.modifierItem!.toJson())
    //     : null;

    // if (widget.upIndex != null) {
    //   // log(json.encode(_placePro.orderList[widget.upIndex!].toJson()));

    //   _placePro.selectedvarHalfnHalf = _varList.firstWhere((a) =>
    //       a.id?.toLowerCase() ==
    //       _placePro.orderList[widget.upIndex!].productVariationId
    //           ?.toLowerCase());

    //   _varList.forEach((e) => e.isDefault = false);

    //   _placePro.selectedvarHalfnHalf?.isDefault = true;
    //   if (_placePro.orderList[widget.upIndex!].orderItemModifiersViewModels !=
    //       null) {
    //     for (final b in _placePro
    //         .orderList[widget.upIndex!].orderItemModifiersViewModels!
    //         .where((e) => e.isActive)
    //         .toList()) {
    //       if (_placePro.selectedvarHalfnHalf?.productVariationModifiers?.any(
    //               (c) =>
    //                   c.modifierItems?.any((d) =>
    //                       d.id?.toLowerCase() ==
    //                       b.priceVariationModifierId?.toLowerCase()) ??
    //                   false) ??
    //           false) {
    //         final _data1 = _placePro
    //             .selectedvarHalfnHalf?.productVariationModifiers
    //             ?.firstWhere((c) =>
    //                 c.modifierItems?.any((d) =>
    //                     d.id?.toLowerCase() ==
    //                     b.priceVariationModifierId?.toLowerCase()) ??
    //                 false);

    //         final _halfData = _data1?.modifierItems?.firstWhere((d) =>
    //             d.id?.toLowerCase() ==
    //             b.priceVariationModifierId?.toLowerCase());

    //         if (b.modifierItemsModifierViewModels != null) {
    //           for (final f in b.modifierItemsModifierViewModels!
    //               .where((k) => k.isActive)
    //               .toList()) {
    //             final _data2 = _halfData?.modifierItemModifiers?.any((g) =>
    //                         g.modifierItems?.any((h) =>
    //                             h.id?.toLowerCase() ==
    //                             f.priceVariationModifierId?.toLowerCase()) ??
    //                         false) ??
    //                     false
    //                 ? _halfData?.modifierItemModifiers?.firstWhere((g) =>
    //                     g.modifierItems?.any((h) =>
    //                         h.id?.toLowerCase() ==
    //                         f.priceVariationModifierId?.toLowerCase()) ??
    //                     false)
    //                 : null;
    //             final _modifiers = _data2?.modifierItems?.firstWhere((j) =>
    //                 j.id?.toLowerCase() ==
    //                 f.priceVariationModifierId?.toLowerCase());

    //             _modifiers?.quantity = f.quantity ?? 1;
    //             _modifiers?.isActive = f.isActive;
    //             _modifiers?.updateId = f.id ?? '';
    //           }
    //         }
    //         if (b.labelName?.toLowerCase().contains('first') ?? false) {
    //           _placePro.firstHalf = _halfData;
    //           _placePro.currentSelectedModifier = _halfData;
    //         } else if (b.labelName?.toLowerCase().contains('second') ??
    //             false) {
    //           _placePro.secondHalf = _halfData;
    //         }
    //       }
    //     }
    //   }
    // }
    //  else {
    // _placePro.selectedvarHalfnHalf = _varList.firstWhere(
    //     (e) => e.isDefault ?? false,
    //     orElse: () => _varList.first..isDefault = true);
    // }

    _placePro.notify;
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

    if (selectedVar == null) return;

    // final _selectedVar =
    //     placeOrderPro.selectedvarHalfnHalf!.productVariationModifiers![i];

    if (selectedVar.name?.toLowerCase().contains('first') ?? false) {
      placeOrderPro.selectedHalfEnum = HalfItemTypeEnum.first;
    } else if (selectedVar.name?.toLowerCase().contains('second') ?? false) {
      placeOrderPro.selectedHalfEnum = HalfItemTypeEnum.second;
    } else if (selectedVar.name?.toLowerCase().contains('third') ?? false) {
      placeOrderPro.selectedHalfEnum = HalfItemTypeEnum.third;
    } else if (selectedVar.name?.toLowerCase().contains('four') ?? false) {
      placeOrderPro.selectedHalfEnum = HalfItemTypeEnum.fourth;
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

  void addToCart() {
    Navigator.pop(context, _modifierItem);
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
  void dispose() {
    // _placePro.selectedvarHalfnHalf = null;
    // _placePro.currentSelectedModifier = null;
    // _placePro.firstHalf = null;
    // _placePro.secondHalf = null;
    // _placePro.selectedHalfEnum = HalfItemTypeEnum.first;
    // onPopUp(widget.product);
    // _scrollCltr.dispose();
    super.dispose();
  }

  // void onPopUp(FeaturedProduct? _product) {
  //   _product?.quantity = 1;
  //   if (_product?.productVariations != null)
  //     for (final a in _product!.productVariations!) {
  //       if (a.productVariationModifiers != null)
  //         for (final b in a.productVariationModifiers!) {
  //           for (final c in b.modifierItems!) {
  //             c.isActive = false;
  //             c.quantity = 1;
  //             if (c.modifierItemModifiers != null)
  //               for (final d in c.modifierItemModifiers!) {
  //                 d.modifierItems?.forEach((e) {
  //                   e.isActive = false;
  //                   e.quantity = 1;
  //                 });
  //               }
  //           }
  //         }
  //     }
  // }

  ModifierItem? _modifierItem;

  @override
  Widget build(BuildContext context) {
    final size = Ssize(context);
    final placeOrderPro = Provider.of<PlaceOrderPro>(context);

    // _product
    //   ?..productType = widget.product?.productType
    //   ..productPriceType = widget.product?.productPriceType;

    // final _selectedVarModi = (_modifierItem?.modifierItemModifiers?.any((a) =>
    //             placeOrderPro.selectedHalfEnum == HalfItemTypeEnum.first
    //                 ? (a.name?.toLowerCase().contains('first') ?? false)
    //                 : (a.name?.toLowerCase().contains('second') ?? false)) ??
    //         false)
    //     ? _modifierItem?.modifierItemModifiers?.firstWhere((a) =>
    //         placeOrderPro.selectedHalfEnum == HalfItemTypeEnum.first
    //             ? (a.name?.toLowerCase().contains('first') ?? false)
    //             : (a.name?.toLowerCase().contains('second') ?? false))
    //     : null;

    final _selectedVarModi = (_modifierItem?.modifierItemModifiers?.any((a) {
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
        ? _modifierItem?.modifierItemModifiers?.firstWhere((a) {
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

    return Container(
      constraints: BoxConstraints(
        maxHeight: size.height / 1.15,
        minHeight: size.height / 4,
      ),
      width: size.width / 1.15,
      padding: EdgeInsets.symmetric(
          vertical: size.getH(16), horizontal: size.getW(12)),
      child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text.rich(
                  TextSpan(
                    text: (_modifierItem?.productName?.isNotEmpty ?? false)
                        ? "${_modifierItem?.productName ?? ''}${(_modifierItem?.variationName?.trim().isNotEmpty ?? false) ? ' (${_modifierItem!.variationName})' : ''} "
                        : 'Half n Half',
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
                      backgroundColor: MaterialStateProperty.all(Colors.red),
                      minimumSize: MaterialStateProperty.all(Size(0, 0)),
                      shape: MaterialStateProperty.all(RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(100))),
                      padding: MaterialStateProperty.all(EdgeInsets.symmetric(
                          horizontal: size.getW(14), vertical: size.getH(4))),
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text("X",
                        style: TextStyle(
                            fontSize: size.getS(24), color: Colors.white))),
              ],
            ),

            // if (placeOrderPro.productDetailView == null &&
            //     placeOrderPro.varianceLoading)
            //   Flexible(
            //     child: SizedBox(
            //       height: double.maxFinite,
            //       width: double.maxFinite,
            //     ),
            //   )
            // else
            Flexible(
                child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Flexible(
                  flex: 2,
                  child: Card(
                    child: SizedBox(
                      height: double.maxFinite,
                      width: double.maxFinite,
                      child: ListView(
                          // controller: _scrollCltr,
                          shrinkWrap: true,
                          padding: EdgeInsets.symmetric(
                              vertical: size.getH(8.0),
                              horizontal: size.getW(8)),
                          children: _modifierItem?.modifierItemModifiers ==
                                      null ||
                                  _modifierItem!.modifierItemModifiers!.isEmpty
                              ? [
                                  NoItemsSec(
                                      size: size, title: LN.noProductFound),
                                ]
                              : [
                                  Text.rich(
                                    TextSpan(
                                        text: _selectedVarModi?.name ?? '',
                                        children: [
                                          TextSpan(
                                            text:
                                                " (Choose ${_selectedVarModi?.selectionType ?? ''} item)",
                                            style: TextStyle(
                                              fontSize: size.getS(16),
                                              fontFamily: kFontFMedium,
                                              color: kSecondaryColor,
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
                                          ?.modifierItems?.isNotEmpty ??
                                      false)
                                    GridView.count(
                                      crossAxisCount: 5,
                                      childAspectRatio:
                                          // (OrderUtils.priceType(widget
                                          //             .product
                                          //             ?.productPriceType) ==
                                          //         HalfPriceType.Higher)
                                          //     ? 1.1
                                          //     :
                                          0.95,
                                      shrinkWrap: true,
                                      physics: NeverScrollableScrollPhysics(),
                                      mainAxisSpacing: size.getW(12),
                                      crossAxisSpacing: size.getH(12),
                                      children: [
                                        ...List.generate(
                                            _selectedVarModi!
                                                .modifierItems!.length, (j) {
                                          final _modifier = _selectedVarModi
                                              .modifierItems![j];
                                          final _isSelected = placeOrderPro
                                                      .firstHalf?.id ==
                                                  _modifier.id ||
                                              placeOrderPro.secondHalf?.id ==
                                                  _modifier.id;

                                          return InkWell(
                                            onTap: () {
                                              _onTabItem(
                                                placeOrderPro: placeOrderPro,
                                                modifier: _modifier,
                                                selectedVar: _selectedVarModi,
                                                isSelected: _isSelected,
                                              );
                                            },
                                            child: Stack(
                                              alignment: Alignment.topRight,
                                              children: [
                                                Card(
                                                  margin: EdgeInsets.fromLTRB(
                                                      2,
                                                      size.getH(8),
                                                      size.getW(8),
                                                      2),
                                                  elevation: 3,
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                    side: BorderSide(
                                                      color: placeOrderPro
                                                                  .currentSelectedModifier
                                                                  ?.id ==
                                                              _modifier.id
                                                          ? Colors
                                                              .green.shade600
                                                          : Colors.transparent,
                                                    ),
                                                  ),
                                                  child: Container(
                                                    width: double.infinity,
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                            vertical:
                                                                size.getH(4.0),
                                                            horizontal:
                                                                size.getW(8)),
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
                                                            height: 100,
                                                            boxFit:
                                                                BoxFit.cover,
                                                            width:
                                                                double.infinity,
                                                          ),
                                                        ),
                                                        SizedBox(
                                                          height: size.getH(4),
                                                        ),
                                                        SizedBox(
                                                          height: size.getH(48),
                                                          child: Center(
                                                            child: Text(
                                                                (_modifier
                                                                        .productName ??
                                                                    ''),
                                                                style:
                                                                    TextStyle(
                                                                  fontSize: size
                                                                      .getW(16),
                                                                  color: Colors
                                                                      .black,
                                                                  fontFamily:
                                                                      kFontFMedium,
                                                                  height: 1.2,
                                                                ),
                                                                maxLines: 2,
                                                                textAlign:
                                                                    TextAlign
                                                                        .center,
                                                                overflow:
                                                                    TextOverflow
                                                                        .ellipsis),
                                                          ),
                                                        ),
                                                        // if (OrderUtils.priceType(
                                                        //         widget
                                                        //             .product
                                                        //             ?.productPriceType) ==
                                                        //     HalfPriceType
                                                        //         .Higher)
                                                        ItemPriceView(
                                                          size: size,
                                                          curSym: placeOrderPro
                                                              .curSym,
                                                          initPrice: _modifier
                                                              .actualPrice,
                                                          priceAfterDiscount:
                                                              _modifier
                                                                  .discountedPrice,
                                                          fontRatio: 1,
                                                          bold: false,
                                                        ),

                                                        SizedBox(
                                                          height: size.getH(4),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                                AnimatedSwitcher(
                                                  duration: Duration(
                                                      milliseconds: 300),
                                                  transitionBuilder:
                                                      (child, animation) {
                                                    return ScaleTransition(
                                                        scale: animation,
                                                        child: child);
                                                  },
                                                  child: Card(
                                                    key: ValueKey<bool>(
                                                        _isSelected),
                                                    elevation: 5,
                                                    color: _isSelected
                                                        ? Colors.green.shade700
                                                        : Colors.white,
                                                    shape:
                                                        RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        100)),
                                                    child: Padding(
                                                      padding: EdgeInsets.all(
                                                          size.getS(4)),
                                                      child: Icon(
                                                        _isSelected
                                                            ? Icons.check
                                                            : Icons.add,
                                                        size: size.getS(32),
                                                        color: _isSelected
                                                            ? Colors.white
                                                            : Colors.black,
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
                                        size: size, title: LN.noProductFound),
                                  SizedBox(height: size.getH(24)),
                                ]),
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
                            child: SizedBox(
                              height: double.maxFinite,
                              width: double.maxFinite,
                              child: Column(
                                children: placeOrderPro
                                            .currentSelectedModifier !=
                                        null
                                    ? [
                                        Row(
                                          children: [
                                            ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(100),
                                                child: CachedNetworkImage(
                                                    imageUrl: placeOrderPro
                                                            .currentSelectedModifier
                                                            ?.imageUrl ??
                                                        '',
                                                    height: size.getW(48),
                                                    width: size.getW(48),
                                                    fit: BoxFit.fitHeight,
                                                    placeholder:
                                                        ImageError.load,
                                                    errorWidget: ImageError
                                                        .notSupportIcon)),
                                            SizedBox(
                                              width: size.getW(12),
                                            ),
                                            Flexible(
                                              child: Text(
                                                "Customize ${placeOrderPro.currentSelectedModifier?.productName ?? ''}",
                                                style: TextStyle(
                                                  fontSize: size.getS(16),
                                                  color: Colors.black,
                                                  fontFamily: kFontFMedium,
                                                ),
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
                                                if (placeOrderPro
                                                        .currentSelectedModifier
                                                        ?.modifierItemModifiers
                                                        ?.isNotEmpty ??
                                                    false)
                                                  GridView.count(
                                                    crossAxisCount: 2,
                                                    childAspectRatio: 6,
                                                    shrinkWrap: true,
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                            horizontal:
                                                                size.getW(12)),
                                                    physics:
                                                        NeverScrollableScrollPhysics(),
                                                    mainAxisSpacing:
                                                        size.getW(12),
                                                    crossAxisSpacing:
                                                        size.getH(12),
                                                    children: [
                                                      ...List.generate(
                                                          placeOrderPro
                                                              .currentSelectedModifier!
                                                              .modifierItemModifiers!
                                                              .length, (index) {
                                                        final _modiData = placeOrderPro
                                                            .currentSelectedModifier!
                                                            .modifierItemModifiers![index];
                                                        final _totalQty = _modiData
                                                                .modifierItems
                                                                ?.fold<double>(
                                                                    0,
                                                                    (pV, eV) =>
                                                                        pV +
                                                                        ((eV.isActive ??
                                                                                false)
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
                                                                  .circular(5),
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
                                                                : Colors.white,
                                                            margin:
                                                                EdgeInsets.zero,
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
                                                                      text: (_modiData
                                                                              .name ??
                                                                          ''),
                                                                      children: [
                                                                        if (_totalQty !=
                                                                            0) ...[
                                                                          TextSpan(
                                                                              text: ' ('),
                                                                          TextSpan(
                                                                            text:
                                                                                _totalQty.formatDouble,
                                                                            style:
                                                                                TextStyle(
                                                                              fontWeight: FontWeight.bold,
                                                                              decoration: _modiType == ModifierType.rawingre ? TextDecoration.lineThrough : null,
                                                                            ),
                                                                          ),
                                                                          TextSpan(
                                                                              text: ')')
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
                                                //   AnimatedSwitcher(
                                                //     duration: Duration(
                                                //         milliseconds: 300),
                                                //     child: ModifierSection(
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
                                                //       update:
                                                //           ({bool? isItemSelected}) =>
                                                //               placeOrderPro
                                                //                   .notify,
                                                //     ),
                                                //   )
                                                // else
                                                //   NoItemsSec(
                                                //     size: size,
                                                //     title: "No Modifier found",
                                                //     iconHeight: 140,
                                                //   ),
                                                // SizedBox(height: size.getH(12)),
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
                                                //           ModifierType.spice),
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
                                    : [
                                        NoItemsSec(
                                          size: size,
                                          title: "No items has been selected",
                                          iconHeight: 120,
                                        )
                                      ],
                              ),
                            ),
                          )),
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
                                child: DealHalfItemView(
                                  placeOrderPro: placeOrderPro,
                                  modifierItem: _modifierItem,
                                  addToCart: addToCart,
                                  addCartText:
                                      //  widget.upIndex != null
                                      //     ? LN.update
                                      //     :
                                      LN.confirm,
                                ),
                              ),
                            ),
                          )),
                    ],
                  ),
                )
              ],
            ))
          ]),
    );
  }
}
