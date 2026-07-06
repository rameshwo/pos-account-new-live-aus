import 'dart:math';

import 'package:flutter/material.dart';
import 'package:pos_account/config/size_config.dart';
import 'package:pos_account/config/utils/order_utils.dart';
import 'package:pos_account/config/utils/utils.dart';
import 'package:pos_account/config/validator.dart';
import 'package:pos_account/constant/constant.dart';
import 'package:pos_account/ln.dart';
import 'package:pos_account/model/home/menu/place_order/place_order_req.dart';
import 'package:pos_account/model/home/menu/place_order/pos_res/com/feature_product.dart';
import 'package:pos_account/providers/cus_val_pro.dart';
import 'package:pos_account/providers/menu/place_order_pro.dart';
import 'package:pos_account/providers/menu/pos_retail_pro.dart';
import 'package:pos_account/repository/if_exception.dart';
import 'package:pos_account/screens/home_screen/com/items/com/item_sec_tile.dart';
import 'package:pos_account/screens/home_screen/com/quantity_sec.dart';
import 'package:pos_account/screens/home_screen/com/variance/selective_tab.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'ingredients_sec.dart';
import 'modifier_section.dart';
import 'spice_sec.dart';
import 'variance_item.dart';

// ignore: must_be_immutable
class Variance3 extends StatefulWidget {
  FeaturedProduct? product;
  // final String? catTypeId;
  final String curSym;
  final int? orderDetailIndex;
  double? quantity;
  final String? uniqueKey;
  final List<OrderItemSelectOptionsViewModels>? filterTypeList;
  final bool isPosTab;
  // final bool isHalfItem;
  final String? productType;
  Variance3({
    super.key,
    required this.product,
    required this.curSym,
    this.orderDetailIndex,
    this.quantity,
    this.uniqueKey,
    this.filterTypeList,
    // required this.catTypeId,
    this.isPosTab = false,
    // this.isHalfItem = false,
    this.productType,
  });

  @override
  State<Variance3> createState() => _Variance3State();
}

class _Variance3State extends State<Variance3> {
  void onPopUp(FeaturedProduct? _product) {
    _product?.quantity = 1;
    _product?.taxRuleIndex = 0;
    _product?.preparationType = null;
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

  double _initQty = 0;

  PlaceOrderPro? _placeOr;

  String? _customPrice;

  String? _discountPercentInString;
  bool showSaveUpto = false;

  @override
  void initState() {
    _getData();
    super.initState();
  }

  void _getData() {
    _placeOr = Provider.of<PlaceOrderPro>(context, listen: false);
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      // await _placeOr?.getProductData(
      //   widget.product?.id,
      //   filterTypeList: widget.filterTypeList,
      //   featuredProduct: widget.product,
      //   isPosTab: widget.isPosTab,
      // );
      final _product =
          _placeOr?.productDetailView?.productListViewModel ?? widget.product;

      if (_product?.productVariations?.isNotEmpty ?? false) {
        if (widget.orderDetailIndex != null &&
            _product!.productVariations!.any((e) =>
                e.id?.toLowerCase() == widget.product?.varId?.toLowerCase())) {
          selectedVarIndex = _product.productVariations!.indexWhere((e) =>
              e.id?.toLowerCase() == widget.product?.varId?.toLowerCase());

          // _product.taxRuleIndex = widget.product?.taxRuleIndex ?? 0;
          _product.preparationType = widget.product?.preparationType;
          try {
            _product.taxRuleIndex = _product.taxRules?.indexWhere(
                    (n) =>
                        n.taxRuleName?.toLowerCase() ==
                        widget.product?.preparationType?.toLowerCase(),
                    0) ??
                0;
          } catch (e) {
            //
          }

          //modifier qty update
          if (_product.productVariations![selectedVarIndex]
                      .productVariationModifiers !=
                  null &&
              (widget.product?.productVariations?.isNotEmpty ?? false) &&
              widget.product?.productVariations?.first
                      .productVariationModifiers !=
                  null)
            for (final e in _product.productVariations![selectedVarIndex]
                .productVariationModifiers!) {
              if (e.modifierItems != null)
                for (final g in e.modifierItems!) {
                  if ((widget.product?.productVariations?.first
                              .productVariationModifiers?.isNotEmpty ??
                          false) &&
                      (widget.product?.productVariations?.first
                              .productVariationModifiers?.first.modifierItems
                              ?.any((h) =>
                                  h.id?.toLowerCase() == g.id?.toLowerCase()) ??
                          false)) {
                    final _modi = widget.product?.productVariations?.first
                        .productVariationModifiers?.first.modifierItems
                        ?.firstWhere(
                            (f) => f.id?.toLowerCase() == g.id?.toLowerCase());
                    g.quantity = _modi?.quantity ?? 1;
                  }
                }
            }
        } else if (_product!.productVariations!
            .any((e) => e.isDefault ?? false)) {
          selectedVarIndex = _product.productVariations!
              .indexWhere((e) => e.isDefault ?? false);
        }

        if (widget.quantity != null) {
          if (widget.uniqueKey != null) _initQty = widget.quantity!;

          _product.productVariations![selectedVarIndex].quantity =
              widget.quantity!;
          widget.quantity = null;
        }

        final _maxDiscountPercentInDouble = _product.productVariations
                ?.map((a) => a.discountPercentage?.inDouble ?? 0)
                .toList()
                .reduce(max) ??
            0;
        _discountPercentInString = _maxDiscountPercentInDouble > 0
            ? _maxDiscountPercentInDouble.toString()
            : ((_product.productVariations?[selectedVarIndex].discountPercentage
                            ?.inDouble ??
                        0.0) >
                    0)
                ? _product
                    .productVariations![selectedVarIndex].discountPercentage
                : null;

        final _allDiscountSame = _product.productVariations?.every((a) =>
                a.discountPercentage ==
                _product
                    .productVariations![selectedVarIndex].discountPercentage) ??
            false;
        showSaveUpto =
            _product.productVariations?.length != 1 && !_allDiscountSame;
      }
      // _placeOr!.varianceLoading = false;
      // _placeOr!.notify;
    });
  }

  @override
  void dispose() {
    // _placeOr?.varianceLoading = true;
    // _placeOr?.productDetailView = null;
    onPopUp(widget.product);
    super.dispose();
  }

  Future<void> addToCart(
    PlaceOrderPro placeOrderPro,
    FeaturedProduct _product, {
    bool isNew = false,
  }) async {
    // if (Utils.outOfBatchStock(selectedVariance: _selectedVariance)) {
    //   return;
    // }

    if (_product.productVariations == null) return;

    for (final e in _product.productVariations!) {
      if (e.isDefault ?? false) {
        await placeOrderPro
            .updateOrderCart(
          product: _product..quantity = e.quantity,
          variation: e,
          catId: _product.categoryId,
          // catTypeId: widget.catTypeId,
          orderDetailIndex: isNew ? null : widget.orderDetailIndex,
          // orderItemSelectOptionsViewModel:
          //     _getSelectedFilter,
          isVarianceUpdate: true,
          customPrice: _customPrice,
        )
            .then((value) {
          if (value) {
            IfException.showMessage(
                message: widget.orderDetailIndex != null
                    ? LN.updateSuccess
                    : LN.addCartSuccess,
                isError: false);
          }
        });
      }
    }

    _product.quantity = 1;

    Navigator.pop(context);
    Future.delayed(Duration(milliseconds: 500), () {
      onPopUp(_product);
    });
  }

  final _scrollCltr = ScrollController();

  @override
  Widget build(BuildContext context) {
    final size = Ssize(context);
    final placeOrderPro = Provider.of<PlaceOrderPro>(context);

    final _product = placeOrderPro
        .productDetailView?.productListViewModel; // ?? widget.product;

    // kPrint("${_product == null}");

    // if (_product?.productVariations?.isNotEmpty ?? false) {
    //   if (widget.orderDetailIndex != null &&
    //       _product!.productVariations!.any((e) =>
    //           e.id?.toLowerCase() == widget.product?.varId?.toLowerCase())) {
    //     selectedVarIndex = _product.productVariations!.indexWhere(
    //         (e) => e.id?.toLowerCase() == widget.product?.varId?.toLowerCase());
    //   } else if (_product!.productVariations!
    //       .any((e) => e.isDefault ?? false)) {
    //     selectedVarIndex =
    //         _product.productVariations!.indexWhere((e) => e.isDefault ?? false);
    //   }
    // }

    final _selectedVariance = (_product?.productVariations?.isNotEmpty ?? false)
        ? _product!.productVariations![selectedVarIndex]
        : null;

    // if (widget.quantity != null) {
    //   if (widget.uniqueKey != null) _initQty = widget.quantity!;

    //   _product!.productVariations![selectedVarIndex].quantity =
    //       widget.quantity!;
    //   // widget.quantity = null;
    // }

    // print(_product?.productVariations?[selectedVarIndex].quantity);

    final _itemPrice = _customPrice ?? _selectedVariance?.actualPrice;

    // final _promDiscount =
    //     OrderUtils.getPromDiscount(_selectedVariance?.discountedPromotions);

    /// add as halfItem
    // final _halfItemPro = Provider.of<HalfItemPro>(context);
    // final _isFirstHalf =
    //     _halfItemPro.isHalfFeatureEnable == HalfItemCount.secondHalf
    //         ? false
    //         : _halfItemPro.firstItem == null;

    // final outOfStockShow = _outOfStock && GlobalCVP.stockExceedRestriction;

    double _total = 0.0;

    _total += _product != null
        ? double.parse(
                // (_promDiscount?.isOfferStart ?? false) &&
                //           (_promDiscount?.tsCount.inDouble ?? 0) <=
                //               (_selectedVariance?.quantity ?? 0)
                //       ? (_promDiscount?.discountedPrice ?? '0')
                //       :
                (((_selectedVariance?.discountedPrice?.isNotEmpty ?? false) &&
                        ((_selectedVariance?.discountedPrice?.inDouble ?? 0) >
                                0 ||
                            (_selectedVariance?.discountPercentage?.inDouble ??
                                    0) >=
                                99))
                    ? _selectedVariance!.discountedPrice!
                    : (_itemPrice ?? '0'))) *
            (_selectedVariance?.quantity ?? 1)
        : 0;
    // }

    if (_selectedVariance?.productVariationModifiers != null &&
        _product != null)
      for (final f in _selectedVariance!.productVariationModifiers!) {
        if (f.modifierItems != null)
          for (final g in f.modifierItems!) {
            if (g.isActive ?? false) {
              _total += (g.discountedPrice.inDouble > 0
                      ? g.discountedPrice.inDouble
                      : g.actualPrice.inDouble) *
                  g.quantity *
                  _selectedVariance.quantity;
            }
          }
      }

    final filterOptions = placeOrderPro
        .productDetailView?.filterCategoriesWithChildernFilterOptions;

    final _modiList = _selectedVariance?.productVariationModifiers
        ?.whereModiType(ModifierType.modifier);

    final _rawIngre = _selectedVariance?.productVariationModifiers
        ?.whereModiType(ModifierType.rawingre);

    final _spiceList = _selectedVariance?.productVariationModifiers
        ?.whereModiType(ModifierType.spice);

    // final _isModifierSelected = false;
    //  _modiList?.any(
    //         (a) => a.modifierItems?.any((b) => b.isActive ?? false) ?? false) ??
    //     false;

    final _loading = (placeOrderPro.productDetailView == null &&
        placeOrderPro.varianceLoading);
    return WillPopScope(
      onWillPop: () async {
        onPopUp(_product);
        return true;
      },
      child: AnimatedContainer(
        duration: Duration(milliseconds: 400),
        height: _loading ? size.height / 3.5 : null,
        constraints: _loading
            ? null
            : BoxConstraints(
                maxHeight: size.height / 1.15,
                minHeight: size.height / 5,
              ),
        width: size.width / 2.4,
        decoration: BoxDecoration(color: kSecondaryColor),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            VarianceItem.header(size,
                name: _product?.name,
                imageUrl: _product?.imageUrl,
                estimatedTime: _selectedVariance?.estimatedTime,
                hasPromo: _selectedVariance
                        ?.promoModel?.discountPercent?.isNotEmpty ??
                    false,
                serviceGender: _selectedVariance?.serviceGender, onBack: () {
              Navigator.pop(context);
              onPopUp(_product);
            }),
            Flexible(
              child: _loading
                  ? Container(color: Colors.white, child: ShimmerMenuScreen())
                  : Container(
                      decoration: BoxDecoration(color: Colors.white),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Flexible(
                            child: SingleChildScrollView(
                              controller: _scrollCltr,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  if ((_product?.taxRules?.isNotEmpty ??
                                          false) &&
                                      _product!.taxRules!.length > 1) ...[
                                    SizedBox(height: size.getH(4)),
                                    Container(
                                      width: double.infinity,
                                      decoration: BoxDecoration(
                                        color: Colors.grey.withOpacity(0.15),
                                      ),
                                      padding: EdgeInsets.symmetric(
                                          horizontal: size.getW(24),
                                          vertical: size.getH(12)),
                                      child: Text.rich(
                                        TextSpan(
                                          text: "Choose Options ",
                                          // children: [
                                          //   TextSpan(
                                          //     text:
                                          //         "(Tax rate varies according to different options.)",
                                          //     style: TextStyle(
                                          //       fontSize: size.getS(16),
                                          //       color: Colors.black,
                                          //       fontWeight: FontWeight.normal,
                                          //     ),
                                          //   )
                                          // ],
                                        ),
                                        style: TextStyle(
                                          fontSize: size.getS(18),
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black,
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: size.getH(4)),
                                    if (_product.taxRules!.length < 4)
                                      Row(
                                        children: List.generate(
                                            _product.taxRules!.length,
                                            (index) => Expanded(
                                                    child:
                                                        SelectiveTab.taxTypeSec(
                                                  size,
                                                  isSelect: index ==
                                                      _product.taxRuleIndex,
                                                  title: _product
                                                      .taxRules![index]
                                                      .taxRuleName,
                                                  onTap: () {
                                                    _product.taxRuleIndex =
                                                        index;
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
                                                  isSelect: index ==
                                                      _product.taxRuleIndex,
                                                  title: _product
                                                      .taxRules![index]
                                                      .taxRuleName,
                                                  onTap: () {
                                                    _product.taxRuleIndex =
                                                        index;
                                                    placeOrderPro.notify;
                                                  },
                                                )),
                                      )
                                  ],
                                  if (_product != null &&
                                      _selectedVariance != null)
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding: EdgeInsets.fromLTRB(
                                              size.getW(12),
                                              size.getH(8),
                                              size.getW(12),
                                              0),
                                          child: VarianceItem(
                                            // name: _product.name ?? '',
                                            price: "$_itemPrice",
                                            quantity: _product.quantity,
                                            // filterOptions: placeOrderPro.productDetailView
                                            //     ?.filterCategoriesWithChildernFilterOptions,
                                            onChanged: () =>
                                                placeOrderPro.notify,
                                            // filterTypeList: widget.filterTypeList,
                                            curSym: widget.curSym,
                                            discountedPrice: _selectedVariance
                                                .discountedPrice,
                                            disPercent: _selectedVariance
                                                .discountPercentage,
                                            // promDiscount: _promDiscount,
                                            // update: (bool? val) async {
                                            //   if (val == null) {
                                            //     if (_outOfStock &&
                                            //         GlobalCVP.stockExceedRestriction)
                                            //       return;
                                            //     _product.quantity =
                                            //         await Utils.textQty(_product.quantity);
                                            //   } else if (val) {
                                            //     if (_outOfStock &&
                                            //         GlobalCVP.stockExceedRestriction)
                                            //       return;

                                            //     _product.quantity++;

                                            //     // _product.quantity++;
                                            //   } else {
                                            //     if (_product.quantity < 2) return;
                                            //     _product.quantity--;
                                            //   }
                                            //   _product.quantity =
                                            //       _product.quantity.roundToN(n: 0);
                                            //   placeOrderPro.notify;
                                            // },
                                            // outOfStockMessage: _outOfStock
                                            //     ? _selectedVariance
                                            //         .outOfStockMessage
                                            //     : null,
                                            // imgPath: _product.imageUrl,
                                            // onTapPrice: GlobalCVP.viewWidget
                                            //         .viewChangePriceText
                                            //     ? () {
                                            //         PriceUpdateDia.showDia(
                                            //           context,
                                            //           number: double.tryParse(
                                            //               _itemPrice ?? '0'),
                                            //         ).then((value) {
                                            //           if (value != null &&
                                            //               value is double) {
                                            //             _selectedVariance
                                            //                 .discount = null;
                                            //             _selectedVariance
                                            //                     .discountPercentage =
                                            //                 null;
                                            //             _selectedVariance
                                            //                     .discountedPrice =
                                            //                 null;

                                            //             _selectedVariance
                                            //                     .discountedPromotions =
                                            //                 null;
                                            //             _customPrice = value
                                            //                 .roundToNString();
                                            //             setStroundToNString()
                                            //           }
                                            //         });
                                            //       }
                                            //     : null,
                                            // estimatedTime: _selectedVariance.estimatedTime,
                                            // serviceGender: _selectedVariance.serviceGender,
                                            serviceItemList: _selectedVariance
                                                .productVariationServiceItems
                                                ?.map((e) => e.name ?? '')
                                                .toList(),
                                            // onBack: () {
                                            //   Navigator.pop(context);
                                            //   onPopUp(_product);
                                            // },
                                          ),
                                        ),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Container(
                                              width: double.infinity,
                                              decoration: BoxDecoration(
                                                color: Colors.grey
                                                    .withOpacity(0.15),
                                              ),
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: size.getW(24),
                                                  vertical: size.getH(12)),
                                              child: Row(
                                                children: [
                                                  Text(
                                                    _product.productVariationLabelName ??
                                                        LN.selectSize,
                                                    style: TextStyle(
                                                      fontSize: size.getS(18),
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.black,
                                                    ),
                                                  ),
                                                  SizedBox(
                                                      width: size.getW(12)),
                                                  if (_discountPercentInString !=
                                                      null)
                                                    _discountSec(size,
                                                        title:
                                                            "${showSaveUpto ? 'Save upto ' : 'Save '}${_discountPercentInString.inQty}%")
                                                ],
                                              ),
                                            ),
                                            SizedBox(
                                              height: size.getH(8),
                                            ),
                                            if (_product.productVariations
                                                    ?.isNotEmpty ??
                                                false) ...[
                                              if (_product.productVariations!
                                                      .length <
                                                  3)
                                                Row(
                                                  children: [
                                                    ...List.generate(
                                                        _product
                                                            .productVariations!
                                                            .length, (index) {
                                                      return Expanded(
                                                        child: Padding(
                                                          padding: EdgeInsets
                                                              .symmetric(
                                                                  horizontal:
                                                                      size.getW(
                                                                          6)),
                                                          child: _variationSec(
                                                            size,
                                                            placeOrderPro,
                                                            _product,
                                                            index,
                                                          ),
                                                        ),
                                                      );
                                                    }),
                                                  ],
                                                )
                                              else
                                                GridView.count(
                                                  shrinkWrap: true,
                                                  physics:
                                                      NeverScrollableScrollPhysics(),
                                                  padding: EdgeInsets.symmetric(
                                                      horizontal:
                                                          size.getW(16)),
                                                  crossAxisCount: 3,
                                                  childAspectRatio: 3.5,
                                                  crossAxisSpacing: 10,
                                                  mainAxisSpacing: 10,
                                                  children: [
                                                    ...List.generate(
                                                        _product
                                                            .productVariations!
                                                            .length, (index) {
                                                      return _variationSec(
                                                        size,
                                                        placeOrderPro,
                                                        _product,
                                                        index,
                                                      );
                                                    }),
                                                  ],
                                                )
                                            ],
                                          ],
                                        ),

                                        if ((_selectedVariance
                                                    .productVariationServiceEmployees
                                                    ?.isNotEmpty ??
                                                false) &&
                                            GlobalCVP.isServiceStore)
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              SizedBox(height: size.getH(12)),
                                              Container(
                                                width: double.infinity,
                                                decoration: BoxDecoration(
                                                  color: Colors.grey
                                                      .withOpacity(0.15),
                                                ),
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: size.getW(24),
                                                    vertical: size.getH(12)),
                                                child: Text(
                                                  "Assign Staff",
                                                  style: TextStyle(
                                                    fontSize: size.getS(18),
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.black,
                                                  ),
                                                ),
                                              ),
                                              SizedBox(
                                                height: size.getH(8),
                                              ),
                                              GridView.count(
                                                shrinkWrap: true,
                                                physics:
                                                    NeverScrollableScrollPhysics(),
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: size.getW(16)),
                                                crossAxisCount: 3,
                                                childAspectRatio: 4.5,
                                                crossAxisSpacing: 10,
                                                mainAxisSpacing: 10,
                                                children: [
                                                  ...List.generate(
                                                      _selectedVariance
                                                          .productVariationServiceEmployees!
                                                          .length, (j) {
                                                    final _staff = _selectedVariance
                                                        .productVariationServiceEmployees![j];
                                                    return SelectiveTab(
                                                      title: _staff.name ?? '',
                                                      isDefault:
                                                          _staff.isSelected,
                                                      onTap: () {
                                                        _staff.isSelected =
                                                            !_staff.isSelected;
                                                        _placeOr!.notify;
                                                      },
                                                    );
                                                  })
                                                ],
                                              ),

                                              // ...List.generate(
                                              //     _selectedVariance
                                              //         .productVariationServiceEmployees!
                                              //         .length, (j) {
                                              //   final _staff = _selectedVariance
                                              //       .productVariationServiceEmployees![j];
                                              //   return InkWell(
                                              //     onTap: () {
                                              //       _staff.isSelected =
                                              //           !_staff.isSelected;
                                              //       _placeOr!.notify;
                                              //     },
                                              //     child: Padding(
                                              //       padding:
                                              //           EdgeInsets.symmetric(
                                              //               horizontal: size
                                              //                   .getW(16)),
                                              //       child: SizedBox(
                                              //         width: double.infinity,
                                              //         height: size.getH(40),
                                              //         child: Row(
                                              //           children: [
                                              //             Text(
                                              //               _staff.name ?? '',
                                              //               style: TextStyle(
                                              //                 fontSize: size
                                              //                     .getS(16),
                                              //                 color: _staff
                                              //                         .isSelected
                                              //                     ? kSecondaryColor
                                              //                     : Colors
                                              //                         .black,
                                              //                 fontFamily:
                                              //                     kFontFMedium,
                                              //               ),
                                              //               textAlign:
                                              //                   TextAlign
                                              //                       .left,
                                              //             ),
                                              //             if (_staff
                                              //                 .isSelected)
                                              //               Padding(
                                              //                 padding: EdgeInsets.only(
                                              //                     left: size
                                              //                         .getW(
                                              //                             12)),
                                              //                 child: Icon(
                                              //                   Icons.check,
                                              //                   color:
                                              //                       kSecondaryColor,
                                              //                   size: size
                                              //                       .getS(20),
                                              //                 ),
                                              //               )
                                              //           ],
                                              //         ),
                                              //       ),
                                              //     ),
                                              // );
                                              // }),
                                            ],
                                          ),

                                        //
                                        // if (
                                        // // !placeOrderPro.varianceLoading &&
                                        // (_selectedVariance
                                        //         .productPriceModifiers
                                        //         ?.isNotEmpty ??
                                        //     false))
                                        AnimatedSwitcher(
                                          duration: Duration(milliseconds: 400),
                                          child: ModifierSection(
                                            key: ValueKey(
                                                "${placeOrderPro.varianceLoading}-${_product.productVariations![selectedVarIndex].id}"),
                                            width: 340,
                                            curSym: widget.curSym,
                                            itemQty: _product
                                                .productVariations![
                                                    selectedVarIndex]
                                                .quantity,
                                            productPriceModifiers:
                                                _modiList ?? [],
                                            update: ({bool? isItemSelected}) {
                                              // if (isItemSelected ?? false)
                                              //   _updateQty(
                                              //     val: true,
                                              //     outOfStock: _outOfStock,
                                              //     product: _product
                                              //             .productVariations![
                                              //         selectedVarIndex],
                                              //     quantity: 1,
                                              //   );
                                              placeOrderPro.notify;
                                            },
                                          ),
                                        ),
                                        SizedBox(height: size.getH(12)),
                                        if ((_rawIngre?.isNotEmpty ?? false))
                                          IngredientSec(
                                            productIngredients: _rawIngre!,
                                            onUpdate: () {
                                              placeOrderPro.notify;
                                            },
                                          ),

                                        SpiceSection(
                                          spiceList: _spiceList,
                                          onChanged: () {
                                            _placeOr!.notify;
                                          },
                                        ),

                                        // if (widget.filterTypeList?.isNotEmpty ??
                                        //     false) ...[
                                        //   SizedBox(height: size.getH(12)),
                                        //   Wrap(
                                        //     spacing: size.getW(8),
                                        //     runSpacing: size.getH(6),
                                        //     children: List.generate(
                                        //         widget.filterTypeList!.length,
                                        //         (index) => Container(
                                        //               padding:
                                        //                   EdgeInsets.symmetric(
                                        //                       horizontal:
                                        //                           size.getW(12),
                                        //                       vertical:
                                        //                           size.getH(2)),
                                        //               decoration: BoxDecoration(
                                        //                   color:
                                        //                       kSecondaryColor,
                                        //                   borderRadius:
                                        //                       BorderRadius
                                        //                           .circular(5)),
                                        //               child: Text.rich(
                                        //                 TextSpan(
                                        //                     text:
                                        //                         "${widget.filterTypeList![index].selectOptionName} : ",
                                        //                     style: TextStyle(
                                        //                       fontSize:
                                        //                           size.getS(18),
                                        //                       color:
                                        //                           Colors.white,
                                        //                     ),
                                        //                     children: [
                                        //                       TextSpan(
                                        //                         text: widget
                                        //                             .filterTypeList![
                                        //                                 index]
                                        //                             .selectOptionValue,
                                        //                         style:
                                        //                             TextStyle(
                                        //                           fontWeight:
                                        //                               FontWeight
                                        //                                   .bold,
                                        //                         ),
                                        //                       )
                                        //                     ]),
                                        //               ),
                                        //             )),
                                        //   )
                                        // ],
                                        if (filterOptions != null)
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              SizedBox(height: size.getH(12)),
                                              ...List.generate(
                                                  filterOptions.length,
                                                  (index) => VarianceItem
                                                          .filterSection(
                                                        size,
                                                        filterType:
                                                            filterOptions[
                                                                index],
                                                        onChanged: () =>
                                                            placeOrderPro
                                                                .notify,
                                                      ))
                                            ],
                                          ),

                                        // if (_selectedVariance
                                        //         .productVariationBatchStocks?.isNotEmpty ??
                                        //     false)
                                        //   BatchSection(
                                        //     isBatch: _isBatchEnable,
                                        //     batchList: _selectedVariance
                                        //         .productVariationBatchStocks!,
                                        //     dateFormat: placeOrderPro.dateFormat,
                                        //     onUpdate: () {
                                        //       placeOrderPro.notify;
                                        //     },
                                        //   ),
                                      ],
                                    ),
                                ],
                              ),
                            ),
                          ),
                          // Spacer(),
                          // if (_isModifierSelected)
                          //   _helperMessage(size,
                          //       text:
                          //           "Quantity cannot be changed for items with modifiers. Please add it again as a new item."),
                          if (_product?.productVariations?.isNotEmpty ?? false)
                            Row(
                              children: [
                                SizedBox(width: size.getW(8)),
                                _disableSection(
                                  readOnly: false, // _isModifierSelected,
                                  child: QuantitySection(
                                    quantity: _product!
                                        .productVariations![selectedVarIndex]
                                        .quantity,
                                    size: size,
                                    fr: 1.3,
                                    update: (p0) {
                                      if (p0 == null) {
                                        return;
                                      }
                                      if (p0) {
                                        _updateQty(
                                            val: true,
                                            outOfStock: _outOfStock,
                                            product:
                                                _product.productVariations![
                                                    selectedVarIndex]);
                                        placeOrderPro.notify;
                                      } else {
                                        _updateQty(
                                            val: false,
                                            outOfStock: _outOfStock,
                                            product:
                                                _product.productVariations![
                                                    selectedVarIndex]);
                                        placeOrderPro.notify;
                                      }
                                      placeOrderPro.notify;
                                    },
                                  ),
                                ),
                                // VarianceItem.qtyIcon(size,
                                //     hw: 60,
                                //     isDefault: true,
                                //     title: '-', onTap: () {
                                //   _updateQty(
                                //       val: false,
                                //       outOfStock: _outOfStock,
                                //       product: _product!.productVariations![
                                //           selectedVarIndex]);
                                //   placeOrderPro.notify;
                                // }),
                                // SizedBox(
                                //   width: size.getW(40),
                                //   child: Text(
                                //     "${_product!.productVariations![selectedVarIndex].quantity.floor()}",
                                //     style: TextStyle(
                                //       fontSize: size.getS(18),
                                //       fontFamily: kFontFMedium,
                                //       color: Colors.black,
                                //       height: 1.1,
                                //     ),
                                //     maxLines: 2,
                                //     textAlign: TextAlign.center,
                                //   ),
                                // ),
                                // VarianceItem.qtyIcon(size,
                                //     hw: 60,
                                //     isDefault: true,
                                //     title: '+', onTap: () {
                                //   _updateQty(
                                //       val: true,
                                //       outOfStock: _outOfStock,
                                //       product: _product.productVariations![
                                //           selectedVarIndex]);
                                //   placeOrderPro.notify;
                                // }),
                                SizedBox(width: size.getW(2)),
                                if (!_outOfStock &&
                                    widget.orderDetailIndex != null)
                                  Flexible(
                                    child: VarianceItem.textButton(
                                      size,
                                      onPressed: () => addToCart(
                                          placeOrderPro, _product,
                                          isNew: true),
                                      sideColor: _outOfStock
                                          ? Colors.grey.shade400
                                          : kSecondaryColor,
                                      backColor: _outOfStock
                                          ? MaterialStateProperty.all(
                                              Colors.grey.shade400)
                                          : MaterialStateProperty.all(
                                              kSecondaryColor),
                                      title: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Icon(Icons.shopping_cart_outlined,
                                              size: size.getS(24)),
                                          SizedBox(width: size.getW(12)),
                                          Text(
                                            "Add as New",
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
                                Flexible(
                                  child: VarianceItem.textButton(
                                    size,
                                    // width: 400,
                                    onPressed: _outOfStock
                                        ? null
                                        : () =>
                                            addToCart(placeOrderPro, _product),
                                    sideColor: _outOfStock
                                        ? Colors.grey.shade300
                                        : kSecondaryColor,
                                    backColor: _outOfStock
                                        ? MaterialStateProperty.all(
                                            Colors.grey.shade300)
                                        : MaterialStateProperty.all(
                                            kSecondaryColor),
                                    title: _outOfStock
                                        ? Text(
                                            "Out of Stock",
                                            style: TextStyle(
                                              fontSize: size.getS(18),
                                              fontFamily: kFontFMedium,
                                              color: Colors.grey,
                                            ),
                                          )
                                        : Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Icon(Icons.shopping_cart_outlined,
                                                  size: size.getS(24)),
                                              SizedBox(width: size.getW(12)),
                                              Text(
                                                "${widget.orderDetailIndex != null ? LN.update : LN.addToCart} - ${widget.curSym + _total.roundToNString()}",
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
                                SizedBox(width: size.getW(8)),
                              ],
                            )
                        ],
                      ),
                    ),
            ),

            // Row(
            //   mainAxisAlignment: MainAxisAlignment.end,
            //   children: [
            //     if (_product != null)
            //       Row(
            //         mainAxisSize: MainAxisSize.min,
            //         children: [
            //           Text(
            //             'Quantity : ',
            //             style: TextStyle(
            //               fontSize: size.getS(18),
            //               // fontFamily: kFontFMedium,
            //               fontWeight: FontWeight.bold,
            //               color: Colors.black,
            //             ),
            //           ),
            //           QuantitySection(
            //             size: size,
            //             quantity: _product.quantity,
            //             update: (bool? val) async {
            //               if (val == null) {
            //                 if (_outOfStock &&
            //                     GlobalCVP.stockExceedRestriction) return;
            //                 _product.quantity =
            //                     await Utils.textQty(_product.quantity);
            //               } else if (val) {
            //                 if (_outOfStock &&
            //                     GlobalCVP.stockExceedRestriction) return;

            //                 _product.quantity++;

            //                 // _product.quantity++;
            //               } else {
            //                 if (_product.quantity < 2) return;
            //                 _product.quantity--;
            //               }
            //               _product.quantity =
            //                   _product.quantity.roundToN(n: 0);
            //               placeOrderPro.notify;
            //             },
            //             fr: 1.2,
            //           ),
            //           SizedBox(width: size.getW(12)),
            //         ],
            //       ),
            //     Spacer(),

            //   ],
            // )
          ],
        ),
      ),
    );
  }

  Future<void> _updateQty({
    bool? val,
    bool outOfStock = false,
    required ProductVariation product,
    double? quantity,
  }) async {
    if (quantity != null) {
      product.quantity = quantity;
    } else {
      if (val == null) {
        if (outOfStock && GlobalCVP.stockExceedRestriction) return;
        product.quantity = await Utils.textQty(product.quantity);
      } else if (val) {
        if (outOfStock && GlobalCVP.stockExceedRestriction) return;

        product.quantity++;

        // _product.quantity++;
      } else {
        if (product.quantity < 2) return;
        product.quantity--;
      }
    }

    product.quantity = product.quantity.roundToN(n: 0);
  }

  bool _outOfStock = false;
  int selectedVarIndex = 0;

  Widget _variationSec(
    Ssize size,
    PlaceOrderPro placeOrderPro,
    FeaturedProduct _product,
    int index,
  ) {
    final _isDefault = _product.productVariations![index].isDefault ?? false;
    final _stock =
        double.tryParse(_product.productVariations![index].stockCount ?? '');
    // print("${_product.productVariations![index].name} $_stock");
    final _totalQuantity = placeOrderPro.orderList.any((b) =>
            _product.productVariations![index].id == b.productVariationId)
        ? placeOrderPro.orderList
                .where((b) =>
                    _product.productVariations![index].id ==
                    b.productVariationId)
                .fold<double>(0, (x, y) => x + (y.quantity ?? 0)) -
            _initQty
        : 0;

    bool _outOfBatchStock = false;
    final _posRetailPro = Provider.of<PosRetailPro>(context);

    final _isBatchEnable =
        (placeOrderPro.initAddSec?.storeInformation?.isBatch ?? false) ||
            (_posRetailPro.retailPosOrderRes?.storeInformation?.isBatch ??
                false);

    if (_isBatchEnable) {
      if (_product.productVariations![index].productVariationBatchStocks
              ?.any((e) => e.isActive) ??
          false) {
        final _batchStock = _product
            .productVariations![index].productVariationBatchStocks
            ?.firstWhere((e) => e.isActive)
            .stockCount;

        _outOfBatchStock = (_batchStock?.isNotEmpty ?? false) &&
            _batchStock.inDouble <
                (_product.productVariations![index].quantity + _totalQuantity);
      }
    }

    _outOfStock = GlobalCVP.stockExceedRestriction &&
        !GlobalCVP.isHospitality &&
        ((_stock != null &&
                _stock <
                    (_product.productVariations![index].quantity +
                        _totalQuantity)) ||
            _outOfBatchStock);

    final _disPrice = _product.productVariations![index].discountedPrice;
    final _actPrice = _product.productVariations![index].actualPrice;
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: size.getW(0)),
      child: InkWell(
        onTap: () {
          if (placeOrderPro.itemViewList.isEmpty) return;

          for (final e in _product.productVariations!) {
            e.isDefault = false;
            e.quantity = 1;
          }

          if (_product.productVariations![index].productVariationModifiers !=
              null)
            for (final f in _product
                .productVariations![index].productVariationModifiers!) {
              for (final g in f.modifierItems ?? <ModifierItem>[]) {
                g.isActive = false;
              }
            }
          if (selectedVarIndex == index &&
              (_product.productVariations![index].isDefault ?? false)) {
            _product.productVariations![index].isDefault = false;
          } else {
            _product.productVariations![index].isDefault = true;
          }

          selectedVarIndex = index;

          placeOrderPro.varianceLoading = true;
          placeOrderPro.notify;

          Future.delayed(Duration(milliseconds: 600), () {
            placeOrderPro.varianceLoading = false;
            placeOrderPro.notify;
          });
        },
        child: Container(
          decoration: BoxDecoration(
              color: _isDefault ? kSecondaryColor : Colors.white,
              border: Border.all(
                color: _isDefault ? kSecondaryColor : Colors.black45,
              ),
              borderRadius: BorderRadius.circular(5)),
          child: Padding(
            padding: EdgeInsets.symmetric(
                vertical: size.getH(4), horizontal: size.getW(12)),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Flexible(
                  child: Text(
                    (_product.productVariations![index].name == null ||
                            _product.productVariations![index].name!
                                .trim()
                                .isEmpty
                        ? (_product.name ?? '')
                        : (_product.productVariations![index].name ?? '')),
                    style: TextStyle(
                      fontSize: size.getS(17),
                      color: _isDefault ? Colors.white : Colors.black,
                      fontFamily: _isDefault ? kFontFMedium : null,
                    ),
                    maxLines: 1,
                    textAlign: TextAlign.center,
                  ),
                ),
                ItemPriceView(
                  size: size,
                  curSym: widget.curSym,
                  initPrice: _actPrice,
                  priceAfterDiscount: _disPrice,
                  fontRatio: 1.1,
                  bold: false,
                  textColors: _isDefault
                      ? [Colors.white, Colors.white]
                      : [Colors.black, Colors.red],
                )
                // Text(
                //   "${widget.curSym}${(_disPrice?.isNotEmpty ?? false) ? _disPrice : _actPrice}",
                //   style: TextStyle(
                //     fontSize: size.getS(15),
                //     fontFamily: kFontFMedium,
                //     color: _isDefault ? Colors.white : Colors.black,
                //   ),
                //   textAlign: TextAlign.center,
                //   maxLines: 1,
                // ),
              ],
            ),
          ),
        ),
      ),
    );

    // return Padding(
    //   padding: EdgeInsets.symmetric(horizontal: size.getW(16)),
    //   child: Row(
    //     children: [
    //       VarianceItem.qtyIcon(size,
    //           isDefault: selectedVarIndex == index && _isDefault,
    //           title: '-', onTap: () {
    //         _updateQty(
    //             val: false,
    //             outOfStock: _outOfStock,
    //             product: _product.productVariations![index]);
    //         placeOrderPro.notify;
    //       }),
    //       Expanded(
    //           child: InkWell(
    //         onTap: () {
    //           if (placeOrderPro.itemViewList.isEmpty) return;

    //           for (final e in _product.productVariations!) {
    //             e.isDefault = false;
    //           }

    //           if (_product.productVariations![index].productPriceModifiers !=
    //               null)
    //             for (final f in _product
    //                 .productVariations![index].productPriceModifiers!) {
    //               f.isActive = false;
    //             }
    //           if (selectedVarIndex == index &&
    //               (_product.productVariations![index].isDefault ?? false)) {
    //             _product.productVariations![index].isDefault = false;
    //           } else {
    //             _product.productVariations![index].isDefault = true;
    //           }

    //           selectedVarIndex = index;

    //           placeOrderPro.varianceLoading = true;
    //           placeOrderPro.notify;

    //           Future.delayed(Duration(milliseconds: 600), () {
    //             placeOrderPro.varianceLoading = false;
    //             placeOrderPro.notify;
    //           });
    //         },
    //         child: Padding(
    //           padding: EdgeInsets.symmetric(horizontal: size.getW(8)),
    //           child: Row(
    //             children: [
    //               Expanded(
    //                 child: Row(
    //                   children: [
    //                     if (_isDefault)
    //                       SizedBox(
    //                         width: size.getW(32),
    //                         child: Text(
    //                           (_isDefault
    //                               ? "${_product.productVariations![index].quantity.floor()} x "
    //                               : ""),
    //                           style: TextStyle(
    //                             fontSize: size.getS(16),
    //                             fontFamily: kFontFMedium,
    //                             color:
    //                                 _isDefault ? kSecondaryColor : Colors.black,
    //                             height: 1.1,
    //                           ),
    //                           maxLines: 2,
    //                           textAlign: TextAlign.left,
    //                         ),
    //                       ),
    //                     Text(
    //                       (_product.productVariations![index].name == null ||
    //                               _product
    //                                   .productVariations![index].name!.isEmpty
    //                           ? (_product.name ?? '')
    //                           : (_product.productVariations![index].name ??
    //                               '')),
    //                       style: TextStyle(
    //                         fontSize: size.getS(16),
    //                         fontFamily: kFontFMedium,
    //                         color: _isDefault ? kSecondaryColor : Colors.black,
    //                         height: 1.1,
    //                       ),
    //                       maxLines: 2,
    //                       textAlign: TextAlign.left,
    //                     ),
    //                     if (_isDefault)
    //                       Padding(
    //                         padding: EdgeInsets.only(left: size.getW(12)),
    //                         child: Icon(
    //                           Icons.check,
    //                           color: kSecondaryColor,
    //                           size: size.getS(18),
    //                         ),
    //                       ),
    //                     if (_outOfStock)
    //                       Container(
    //                         margin: EdgeInsets.only(left: size.getW(12)),
    //                         decoration: BoxDecoration(
    //                             borderRadius: BorderRadius.circular(15),
    //                             color: Colors.grey.withOpacity(0.15)),
    //                         padding: EdgeInsets.symmetric(
    //                             horizontal: size.getW(12),
    //                             vertical: size.getH(4)),
    //                         child: Text(
    //                           "Out of Stock",
    //                           style: TextStyle(
    //                             fontSize: size.getS(12),
    //                             fontFamily: kFontFMedium,
    //                             color: Colors.grey,
    //                             height: 1.1,
    //                           ),
    //                           maxLines: 2,
    //                           textAlign: TextAlign.left,
    //                         ),
    //                       ),
    //                   ],
    //                 ),
    //               ),
    //               Text(
    //                 "${widget.curSym}${_product.productVariations![index].actualPrice ?? ''}",
    //                 style: TextStyle(
    //                   fontSize: size.getS(16),
    //                   fontFamily: kFontFMedium,
    //                   color: _isDefault ? kSecondaryColor : Colors.black,
    //                 ),
    //                 textAlign: TextAlign.center,
    //                 maxLines: 1,
    //               ),
    //             ],
    //           ),
    //         ),
    //       )),
    //       VarianceItem.qtyIcon(size,
    //           isDefault: selectedVarIndex == index && _isDefault,
    //           title: '+', onTap: () {
    //         _updateQty(
    //             val: true,
    //             outOfStock: _outOfStock,
    //             product: _product.productVariations![index]);
    //         placeOrderPro.notify;
    //       }),
    //     ],
    //   ),
    // );
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

  Widget _discountSec(
    Ssize size, {
    required String title,
  }) {
    return Card(
      margin: EdgeInsets.zero,
      color: Colors.red.shade800,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
      child: Padding(
        padding: EdgeInsets.symmetric(
            vertical: size.getH(4), horizontal: size.getS(8)),
        child: Text(
          title,
          style: TextStyle(
            fontSize: size.getS(16),
            color: Colors.white,
            fontFamily: kFontFMedium,
          ),
        ),
      ),
    );
  }

  // Container _helperMessage(
  //   Ssize size, {
  //   required String text,
  // }) {
  //   return Container(
  //     width: double.infinity,
  //     decoration: BoxDecoration(
  //         color: Colors.red.withOpacity(0.1),
  //         borderRadius: BorderRadius.circular(10)),
  //     padding: EdgeInsets.symmetric(
  //         horizontal: size.getW(8), vertical: size.getH(8)),
  //     child: Row(
  //       crossAxisAlignment: CrossAxisAlignment.start,
  //       children: [
  //         Padding(
  //           padding: EdgeInsets.only(top: size.getH(2)),
  //           child: Icon(
  //             Icons.info_outline,
  //             size: size.getS(18),
  //             color: Colors.red,
  //           ),
  //         ),
  //         SizedBox(width: size.getW(6)),
  //         Expanded(
  //           child: Text(
  //             text,
  //             style: TextStyle(
  //               color: Colors.red.shade800,
  //               fontSize: size.getS(14),
  //             ),
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }
}

enum ModiIngreTab { Modifier, Ingre }

class ShimmerMenuScreen extends StatelessWidget {
  const ShimmerMenuScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: SingleChildScrollView(
        physics: NeverScrollableScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                _buildShimmerBox(height: 40, width: 200),
                Spacer(),
                _buildShimmerBox(height: 40, width: 80),
              ],
            ),
            const SizedBox(height: 20),
            _buildShimmerBox(height: 40, width: double.infinity),
            const SizedBox(height: 20),
            _buildShimmerList(),
            // const Spacer(),
            // _buildShimmerButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildShimmerBox(
      {double height = 20, double width = double.infinity}) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Container(
        height: height,
        width: width,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }

  Widget _buildShimmerList() {
    return Column(
      children: List.generate(
          2,
          (index) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: _buildShimmerBox(height: 40, width: double.infinity),
              )),
    );
  }
}
