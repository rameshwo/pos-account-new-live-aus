import 'package:flutter/material.dart';
import 'package:pos_account/config/utils/order_utils.dart';
import 'package:pos_account/config/responsive.dart';
import 'package:pos_account/config/size_config.dart';
import 'package:pos_account/constant/constant.dart';
import 'package:pos_account/ln.dart';
import 'package:pos_account/model/home/menu/place_order/pos_res/com/feature_product.dart';
import 'package:pos_account/model/home/menu/place_order/pos_res/pos_cat_res.dart';
import 'package:pos_account/providers/cus_val_pro.dart';
import 'package:pos_account/providers/menu/place_order_pro.dart';
import 'package:pos_account/providers/menu/pos_retail_pro.dart';
import 'package:pos_account/repository/if_exception.dart';
import 'package:pos_account/screens/home_screen/com/items/sidebar/order_section/com/pay_method/com/cash_drawer_button.dart';
import 'package:pos_account/screens/home_screen/com/items/tabs/pos_tab/pos_non_retail/com/combo/combo_dia.dart';
import 'package:pos_account/screens/home_screen/com/items/tabs/pos_tab/pos_non_retail/com/item_tile.dart';
import 'package:pos_account/widgets/input/dropdown/tree_dropdown/tree_dropdown.dart';
import 'package:pos_account/widgets/input/text_form/text_form_widget.dart';
import 'package:pos_account/widgets/loading.dart';
import 'package:pos_account/widgets/no_items_sec.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import '../pos_non_retail/com/raw_ingre/raw_ingre_item.dart';
import '../pos_non_retail/com/title_section.dart';

ScrollController? retailScrollCltr;

class POSRetailSection extends StatefulWidget {
  final PlaceOrderPro placeOrderPro;
  final Function()? onTapSubs;
  const POSRetailSection({
    super.key,
    required this.placeOrderPro,
    this.onTapSubs,
  });

  @override
  State<POSRetailSection> createState() => _POSRetailSectionState();
}

class _POSRetailSectionState extends State<POSRetailSection> {
  PosRetailPro? _posPro;

  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  @override
  void initState() {
    retailScrollCltr = ScrollController();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      widget.placeOrderPro.getCusAddSec();

      setUp();
    });

    super.initState();
  }

  void setUp() {
    _posPro = Provider.of<PosRetailPro>(context, listen: false);
    _posPro?.placeOrderPro = widget.placeOrderPro;
    _posPro?.posRetailPro = _posPro;
    _posPro?.getOrderAddSection(placeOr: widget.placeOrderPro);
    paginate(1);
  }

  void paginate(int page) {
    _posPro!.pageLoad = true;
    if (_posPro != null) {
      // if (itemViewType == ItemViewType.combo) {
      //   widget.placeOrderPro.loading = true;
      //   widget.placeOrderPro.getComboData(page: page);
      // } else if (itemViewType == ItemViewType.ingre) {
      //   widget.placeOrderPro.loading = true;
      //   widget.placeOrderPro.getIngreData(page: page);
      // } else {
      _posPro
          ?.getItemData(page: page, searchKey: _posPro?.searchCltr.text ?? "")
          .then((_) {
        _refreshController.refreshCompleted();
        _refreshController.loadComplete();
      });
      // }
    }
  }

  @override
  void dispose() {
    _posPro?.clear();
    if (retailScrollCltr != null) retailScrollCltr!.dispose();
    _refreshController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = Ssize(context);
    final posPro = Provider.of<PosRetailPro>(context);
    final placeOrderPro = widget.placeOrderPro;
    return Processing(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // if (widget.onTapSubs != null) ...[
          SizedBox(height: size.getH(8)),
          //   TrialExpiryMsg(
          //       size: size,
          //       show: posPro.retailPosOrderRes?.message?.isNotEmpty ?? false,
          //       message: posPro.retailPosOrderRes?.message ?? '',
          //       btnText:
          //           (posPro.retailPosOrderRes?.isSubscriptionActive ?? false)
          //               ? LN.changePlan
          //               : LN.subsNow,
          //       onTap: widget.onTapSubs)
          // ],
          if (!(posPro.retailPosOrderRes?.message?.isNotEmpty ?? false)) ...[
            Padding(
              padding: EdgeInsets.symmetric(horizontal: size.getW(6)),
              child: Row(
                children: [
                  ...[
                    if (posPro.itemViewType == ItemViewType.product)
                      TreeDropWidget(
                        isReq: false,
                        width: size.width * 0.12,
                        vPad: 12,
                        dialogWidth: size.width / 2,
                        mode: Mode.DIALOG,
                        selectedColor: kSecondaryColor,
                        borderColor: Colors.black26,
                        hintText: LN.brand,
                        dropdownTitle: LN.brand,
                        categoryList: posPro.brandList,
                        selectedId: posPro.selectedBrandId,
                        onChanged: (p0) {
                          posPro.selectedBrandId = p0 ?? '';
                          posPro.notify;
                          paginate(1);
                        },
                        suffixIcon: posPro.selectedBrandId.isNotEmpty
                            ? InkWell(
                                onTap: () {
                                  posPro.selectedBrandId = '';
                                  posPro.notify;
                                  paginate(1);
                                },
                                child: Icon(
                                  Icons.close,
                                  size: size.getS(24),
                                ),
                              )
                            : null,
                      ),
                    SizedBox(width: size.getW(12)),
                  ],
                  Flexible(
                    child: TextFormWidget(
                      isReq: false,
                      vPad: 10,
                      prefixIcon: Icon(
                        Icons.search,
                        size: size.getS(32),
                      ),
                      borderRadius: 5,
                      borderColor: Colors.black12,
                      cltr: posPro.searchCltr,
                      hintText: posPro.itemViewType == ItemViewType.combo
                          ? LN.searchComboProduct
                          : posPro.itemViewType == ItemViewType.ingre
                              ? LN.searchNewIngre
                              : LN.search,
                      onChanged: (p0) {
                        if (p0 == null) return;
                        paginate(1);
                      },
                      suffixIcon: posPro.searchCltr.text.isEmpty
                          ? null
                          : InkWell(
                              onTap: () {
                                posPro.searchCltr.clear();
                                paginate(1);
                              },
                              child: Icon(
                                Icons.close,
                                size: size.getS(28),
                                color: Colors.black,
                              ),
                            ),
                    ),
                  ),
                  SizedBox(width: size.getW(12)),
                  if (GlobalCVP.viewWidget.viewCashRegisterButton)
                    CashDrawerButton(),
                  // if (GlobalCVP.viewWidget.viewProductRefreshButton)
                  //   Padding(
                  //     padding: EdgeInsets.only(left: size.getW(12)),
                  //     child: RefreshBtn(
                  //       size: size,
                  //       onTap: () async {
                  //         // posPro.itemViewList.clear();
                  //         posPro.pageLoad = true;

                  //         posPro.selectedCatId = "";
                  //         posPro.brandIndex = 0;
                  //         // posPro.alphaId = "";
                  //         posPro.searchCltr.clear();
                  //         posPro.notify;
                  //         Loading.dialog(
                  //           context,
                  //           title: "Retrieving Data",
                  //           width: 200,
                  //           height: 200,
                  //         );

                  //         // await GlobalCVP.getAllAddSection(isServerCall: true);

                  //         await posPro.getAllRetailProducts(isServerCall: true);

                  //         placeOrderPro.getCusAddSec();

                  //         await posPro.getOrderAddSection(
                  //             placeOr: placeOrderPro);

                  //         posPro.pageLoad = false;
                  //         placeOrderPro.loading = false;
                  //         posPro.itemViewType = ItemViewType.product;

                  //         if (Navigator.canPop(context)) {
                  //           Navigator.pop(context);
                  //         }
                  //         posPro.getItemData();
                  //         posPro.notify;

                  //         // placeOrderPro?.selectedCatId = "";
                  //         // placeOrderPro?.alphaId = "";
                  //         // placeOrderPro!.notify;
                  //         // placeOrderPro.searchCltr.clear();
                  //         // placeOrderPro.getCats(context).then((value) => {
                  //         //       placeOrderPro.notify,
                  //         //       placeOrderPro.loading = false,
                  //         //       posPro.pageLoad = true,
                  //         //       placeOrderPro.itemViewType =
                  //         //           ItemViewType.product,
                  //         //       posPro.getData()
                  //         //     });
                  //       },
                  //     ),
                  //   ),
                ],
              ),
            ),
            // if ((widget.itemViewType == ItemViewType.product
            //         ? posPro.pageLoad
            //         : placeOrderPro?.loading) ??
            //     false)
            //   LinearProgressIndicator()
            // else
            //   SizedBox(height: 4),

            if (posPro.alphaList?.isNotEmpty ?? false)
              SizedBox(
                height: size.getH(48),
                child: Align(
                  alignment: Alignment.center,
                  child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: size.getW(4), vertical: size.getH(4)),
                          child: InkWell(
                            onTap: () {
                              if (posPro.selectedAlpha ==
                                  posPro.alphaList?[index])
                                posPro.selectedAlpha = null;
                              else
                                posPro.selectedAlpha =
                                    posPro.alphaList?[index] ?? '';
                              posPro.notify;
                              posPro.pageLoad = true;
                              paginate(1);
                            },
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: size.getW(18),
                                  vertical: size.getH(0)),
                              decoration: BoxDecoration(
                                color: posPro.selectedAlpha ==
                                        posPro.alphaList?[index]
                                    ? kUserColor
                                    : kBackgroundColor,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Center(
                                child: Text(
                                  posPro.alphaList?[index] ?? '',
                                  style: TextStyle(
                                    color: posPro.selectedAlpha ==
                                            posPro.alphaList?[index]
                                        ? Colors.white
                                        : kPrimaryColor,
                                    fontSize: size.getH(16),
                                    fontFamily: kFontFMedium,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                      itemCount: posPro.alphaList?.length ?? 0,
                      shrinkWrap: true),
                ),
              ),
            // if (widget.itemViewType != ItemViewType.product)
            TitleSection(
              placeOrderPro: widget.placeOrderPro,
              posRetailPro: posPro,
            ),
            SizedBox(height: size.getH(4)),
            Flexible(
              child: Scrollbar(
                controller: retailScrollCltr,
                thumbVisibility: false,
                trackVisibility: false,
                interactive: true,
                thickness: 10,
                radius: Radius.circular(40),
                child: SmartRefresher(
                  scrollController: retailScrollCltr,
                  enablePullUp: true,
                  controller: _refreshController,
                  onRefresh: () => paginate(1),
                  onLoading: () => paginate((posPro.pageIndex) + 1),
                  child: ListView(
                    controller: retailScrollCltr,
                    children: [
                      SizedBox(height: size.getH(8)),
                      Column(
                        children: [
                          if ((posPro.itemViewList.isEmpty &&
                                  posPro.ingreViewList.isEmpty) &&
                              !(posPro.pageLoad))
                            Align(
                              alignment: Alignment.topCenter,
                              child: NoItemsSec(
                                size: size,
                                title: LN.noProductFound,
                              ),
                            )
                          else if (posPro.itemViewType != ItemViewType.ingre)
                            GridView.builder(
                              physics: NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: posPro.itemViewList.length,
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                mainAxisExtent: size.getH(
                                    Responsive.isDesktop(context) ? 244 : 216),
                                crossAxisSpacing: size.getW(0),
                                mainAxisSpacing: size.getH(0),
                                crossAxisCount: size.isProt ? 3 : 4,
                              ),
                              itemBuilder: (context, index) {
                                final e = posPro.itemViewList[index];
                                // final _varCount = e.productDetails
                                //         ?.productVariations?.length ??
                                //     0;
                                return ItemTile(
                                  // hideAddBtn: true,
                                  // message: _varCount == 0
                                  //     ? null
                                  //     : "$_varCount option${_varCount == 1 ? '' : 's'} available",
                                  disPercent: e.discountPercentage ?? "0",
                                  discountedPrice: e.discountedPrice,
                                  price: e.actualPrice ?? "0",
                                  imgPath: e.imageUrl ?? '',
                                  name: e.name ?? '',
                                  stockMessage: e.stockCount == ""
                                      ? null
                                      : " ${LN.inStock}: ${e.stockCount}",
                                  curSym: placeOrderPro.curSym,
                                  addText: LN.addToCart,
                                  // onAdd: () async {
                                  //   if (placeOrderPro == null) return;

                                  //   final _stock =
                                  //       double.tryParse(e.stockCount ?? '');
                                  //   final _totalQuantity = placeOrderPro
                                  //           .orderList
                                  //           .any((b) =>
                                  //               b.productId == e.productId)
                                  //       ? placeOrderPro.orderList
                                  //           .where(
                                  //               (b) => b.productId == e.id)
                                  //           .fold<double>(
                                  //               0,
                                  //               (x, y) =>
                                  //                   x + (y.quantity ?? 0))
                                  //       : 0;

                                  //   final bool _outOfStock =
                                  //       _stock != null &&
                                  //           _stock <= _totalQuantity;
                                  //   if (_outOfStock) {
                                  //     showToast(LN.productOutOfStock);
                                  //   } else {
                                  //     await posPro.getProductDetail(
                                  //         varId: e.id);
                                  //     if (posPro.retailProductDetail ==
                                  //         null) return;

                                  //     if ((posPro
                                  //                 .retailProductDetail
                                  //                 ?.productVariations
                                  //                 ?.isNotEmpty ??
                                  //             false) &&
                                  //         (posPro
                                  //                 .retailProductDetail
                                  //                 ?.productVariations
                                  //                 ?.first
                                  //                 .productVariationBatchStocks
                                  //                 ?.isNotEmpty ??
                                  //             false)) {
                                  //       final _batchCount = posPro
                                  //           .retailProductDetail!
                                  //           .productVariations!
                                  //           .first
                                  //           .productVariationBatchStocks!
                                  //           .length;

                                  //       if (_batchCount > 1) {
                                  //         selectVarience(
                                  //           context,
                                  //           catTypeId: posPro
                                  //               .retailProductDetail
                                  //               ?.categoryTypeId,
                                  //           featuredProduct:
                                  //               posPro.retailProductDetail!,
                                  //           curSym:
                                  //               placeOrderPro.curSym ?? '',
                                  //         );
                                  //         return;
                                  //       } else {
                                  //         e.productDetails
                                  //                 ?.productVariations =
                                  //             posPro.retailProductDetail!
                                  //                 .productVariations!;

                                  //         if (e
                                  //                 .productDetails
                                  //                 ?.productVariations
                                  //                 ?.isNotEmpty ??
                                  //             false) {
                                  //           e
                                  //               .productDetails
                                  //               ?.productVariations
                                  //               ?.first
                                  //               .productVariationBatchStocks
                                  //               ?.first
                                  //               .isActive = true;

                                  //           if (Utils.outOfBatchStock(
                                  //               selectedVariance: e
                                  //                   .productDetails
                                  //                   ?.productVariations
                                  //                   ?.first)) {
                                  //             return;
                                  //           }
                                  //         }
                                  //       }
                                  //     }

                                  //     placeOrderPro.updateOrderCart(
                                  //       product: posPro
                                  //               .retailProductDetail ??
                                  //           FeaturedProduct(
                                  //             id: e.id,
                                  //             imageUrl: e.productImage,
                                  //             name: e.name,
                                  //             productTax: e.salesTaxValue,
                                  //             categoryTypeId:
                                  //                 e.categoryTypeId,
                                  //           ),
                                  //       variation: ProductVariation(
                                  //         id: e.id,
                                  //         isDefault: true,
                                  //         name: e.productVariationName,
                                  //         actualPrice: e.actualPrice,
                                  //         unitPrice: e.actualPrice,
                                  //         discount: e.discount,
                                  //         stockCount: e.stockCount,
                                  //       ),
                                  //     );
                                  //   }
                                  // },
                                  onTap: () async {
                                    final _stock =
                                        double.tryParse(e.stockCount ?? '');
                                    final _totalQuantity = placeOrderPro
                                            .orderList
                                            .any((b) =>
                                                b.productId == e.productId)
                                        ? placeOrderPro.orderList
                                            .where((b) => b.productId == e.id)
                                            .fold<double>(0,
                                                (x, y) => x + (y.quantity ?? 0))
                                        : 0;

                                    final bool _outOfStock =
                                        GlobalCVP.stockExceedRestriction &&
                                            !GlobalCVP.isHospitality &&
                                            _stock != null &&
                                            _stock <= _totalQuantity;
                                    if (_outOfStock) {
                                      IfException.showMessage(
                                          message: LN.productOutOfStock);
                                    } else {
                                      // await posPro.getProductDetail(
                                      //     varId: e.id);
                                      // if (posPro.retailProductDetail ==
                                      //     null) return;

                                      // if (!Utils.doDirectAddToCart(
                                      //     product:
                                      //         posPro.retailProductDetail)) {
                                      //   selectVarience(
                                      //     context,
                                      //     catTypeId: posPro
                                      //         .retailProductDetail
                                      //         ?.categoryTypeId,
                                      //     featuredProduct:
                                      //         posPro.retailProductDetail!,
                                      //     curSym:
                                      //         placeOrderPro.curSym ?? '',
                                      //   );
                                      //   return;
                                      // } else {

                                      final _var = ProductVariation(
                                          id: e.id,
                                          stockCount: e.stockCount,
                                          actualPrice: e.actualPrice,
                                          discountPercentage:
                                              e.discountPercentage,
                                          discountedPrice: e.discountedPrice,
                                          discount: e.discountPrice,
                                          unitPrice: e.unitPrice,
                                          quantity: e.quantity.toDouble(),
                                          isDefault: true,
                                          promoModel: e.promoModel,
                                          productVariationModifiers:
                                              e.comboProducts != null
                                                  ? [
                                                      ProductVariationModifier(
                                                          modifierItems:
                                                              List.generate(
                                                                  e.comboProducts!
                                                                      .length,
                                                                  (index) =>
                                                                      ModifierItem(
                                                                        productName: e
                                                                            .comboProducts![index]
                                                                            .name,
                                                                        imageUrl: e
                                                                            .comboProducts![index]
                                                                            .imageUrl,
                                                                        isActive:
                                                                            true,
                                                                      )))
                                                    ]
                                                  : []);
                                      final _product = FeaturedProduct()
                                        ..id = e.productId
                                        ..categoryId = e.categoryId
                                        ..name = e.name
                                        ..salesTax = e.salesTax
                                        ..imageUrl = e.imageUrl
                                        ..quantity = e.quantity.toDouble()
                                        ..parentCatId = e.parentCatId
                                        ..productType = e.productType
                                        ..productVariations = [_var];

                                      if (e.comboProducts?.isNotEmpty ??
                                          false) {
                                        placeOrderPro.productDetailView = null;
                                        selectVarience(
                                          context,
                                          featuredProduct: _product,
                                          placeOrderPro: placeOrderPro,
                                        );
                                      } else {
                                        placeOrderPro.updateOrderCart(
                                          product: _product,
                                          variation: _var,
                                        );
                                      }
                                      // }
                                    }
                                  },
                                  size: size,
                                  hasPromo: e.promoModel != null,
                                  // vName: e.productVariationName ?? '',
                                );
                              },
                            )
                          // ] else if (posPro.itemViewType ==
                          //     ItemViewType.combo) ...[
                          //   if ((placeOrderPro?.comboViewList.isEmpty ??
                          //           true) &&
                          //       !(placeOrderPro?.loading ?? false))
                          //     NoItemsSec(size: size, title: LN.noProductFound)
                          //   else if (placeOrderPro
                          //           ?.comboViewList.isNotEmpty ??
                          //       false)
                          //     SetMenuItem(
                          //       setMenuList: placeOrderPro!.comboViewList,
                          //       curSym: placeOrderPro.curSym,
                          //       size: size,
                          //       placeOrderPro: placeOrderPro,
                          //     )
                          // ]
                          else if (posPro.itemViewType == ItemViewType.ingre)
                            RawIngreItems(
                              dataList: posPro.ingreViewList,
                              curSym: placeOrderPro.curSym,
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
          // SizedBox(height: size.getH(24)),
        ],
      ),
    );
  }

  static selectVarience(
    BuildContext context, {
    FeaturedProduct? featuredProduct,
    required PlaceOrderPro placeOrderPro,
  }) {
    placeOrderPro.getProductData(
      featuredProduct?.id,
      featuredProduct: featuredProduct,
      isPosTab: true,
    );

    return showDialog(
        context: context,
        barrierDismissible: true,
        builder: (builder) => SimpleDialog(
              // backgroundColor: kSecondaryColor,
              titlePadding: EdgeInsets.zero,
              contentPadding: EdgeInsets.zero,
              insetPadding: OrderUtils.prodType(featuredProduct?.productType) ==
                      ProductType.Combo
                  ? EdgeInsets.zero
                  : EdgeInsets.symmetric(horizontal: 40.0, vertical: 24.0),

              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15)),
              children: [
                if (OrderUtils.prodType(featuredProduct?.productType) ==
                    ProductType.Combo)
                  ComboNewDia(
                    product: featuredProduct,
                  )
                // Variance(
                //   product: featuredProduct,
                //   catTypeId: catTypeId,
                //   curSym: curSym,
                //   quantity: 1,
                //   isPosTab: true,
                // ),
              ],
            ));
  }
}
