import 'package:flutter/material.dart';
import 'package:pos_account/config/utils/menu_schedule_utils.dart';
import 'package:pos_account/config/utils/promo_utils.dart';
import 'package:pos_account/config/size_config.dart';
import 'package:pos_account/config/utils/order_utils.dart';
import 'package:pos_account/config/validator.dart';
import 'package:pos_account/constant/constant.dart';
import 'package:pos_account/constant/strings.dart';
import 'package:pos_account/ln.dart';
import 'package:pos_account/model/home/menu/place_order/pos_res/com/feature_product.dart';
import 'package:pos_account/model/home/menu/place_order/pos_res/pos_cat_res.dart';
import 'package:pos_account/providers/cus_val_pro.dart';
import 'package:pos_account/providers/menu/place_order_pro.dart';
import 'package:pos_account/providers/menu/pos_retail_pro.dart';
import 'package:pos_account/repository/if_exception.dart';
import 'package:pos_account/screens/home_screen/com/items/com/search_section.dart';
import 'package:pos_account/widgets/loading.dart';
import 'package:pos_account/widgets/message_widgets/trial_expire.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import '../order_tab/order_manage_tab.dart';
import '../product_detail_dia.dart';
import 'com/combo/combo_dia.dart';
import 'com/deal/deal_dia.dart';
import 'com/half_half_2/half_half_dia.dart';
import 'com/product_item.dart';
import 'com/promo_timer.dart';
import 'com/raw_ingre/raw_ingre_item.dart';
import 'com/set_menu_item.dart';
import 'com/title_section.dart';

ScrollController? posScrollCltr;

class PosTab extends StatefulWidget {
  final PlaceOrderPro placeOrderPro;
  final CusValuePro cvp;
  final Function()? onTapSubs;
  final GlobalKey<ScaffoldState> scafKey;
  const PosTab({
    super.key,
    required this.placeOrderPro,
    required this.cvp,
    this.onTapSubs,
    required this.scafKey,
  });

  @override
  State<PosTab> createState() => _PosTabState();

  static bool _isVarDiaOpen = false;

  static Future<void> selectVarience(
    BuildContext context, {
    // String? catTypeId,
    FeaturedProduct? featuredProduct,
    required PlaceOrderPro placeOrderPro,
  }) async {
    if (_isVarDiaOpen) {
      IfException.showMessage(
          message: "Please wait and try again after a short moment.");
      return;
    }

    _isVarDiaOpen = true;

    final _prodType = OrderUtils.prodType(featuredProduct?.productType);
    final _prodPriceType =
        OrderUtils.productPriceType(featuredProduct?.productPriceType);

    placeOrderPro.getProductData(
      featuredProduct?.id,
      featuredProduct: featuredProduct,
      isPosTab: true,
    );

    await showDialog(
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
                    // id: featuredProduct?.id ?? '',
                    product: featuredProduct,
                  )
                else if (_prodType == ProductType.Combo) ...[
                  if (_prodPriceType == ProductPriceType.MakeYourOwn)
                    DealDia(
                      product: featuredProduct,
                    )
                  else
                    ComboNewDia(
                      product: featuredProduct,
                    )
                ] else
                  ProductDetailDia(
                    product: featuredProduct,
                    // catTypeId: catTypeId,
                    curSym: placeOrderPro.curSym ?? '',
                    quantity: 1,
                    isPosTab: true,
                    productType: featuredProduct?.productType,
                  ),
              ],
            ));

    _isVarDiaOpen = false;
  }
}

class _PosTabState extends State<PosTab> {
  final refreshCltr = RefreshController(initialRefresh: false);

  @override
  void initState() {
    super.initState();
    posScrollCltr = ScrollController();
    getData();
  }

  bool get _isPromoCat =>
      widget.placeOrderPro.promoId != null &&
      widget.placeOrderPro.selectedCatId == Strings.staticPromoId;

  getData() async {
    if (widget.placeOrderPro.posDataPath == PosDataPath.Drawer ||
        widget.placeOrderPro.posDataPath == PosDataPath.Order) return;

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      // widget.placeOrderPro.loading = true;
      // widget.placeOrderPro.notify;

      // widget.placeOrderPro.init();
      if (!GlobalCVP.isRetailStore) {
        await MenuScheduleUtils.listen(
          (slot) async {
            widget.placeOrderPro.menuslot = slot;
            // widget.placeOrderPro.getItemData();
            await widget.placeOrderPro.init();
          },
          isServerCall: false,
        );
      }
      Future.delayed(Duration(milliseconds: 400), () {
        if (GlobalCVP.pathOfPOS == PathOfPOS.FloorPlan) {
          //  SideBarSection.showOrderType(context)
          // SideBarSection.addCustomer(context)
          //     .then((value) => GlobalCVP.pathOfPOS = PathOfPOS.Init);
          // SideBarSection.showNoOfCus(context, placeOrderPro: widget.placeOrderPro)
          //     .then((value) => GlobalCVP.pathOfPOS = PathOfPOS.Init);
        }
      });
    });
  }

  void paginate(int page) {
    widget.placeOrderPro.getInitData(page: page).then((_) {
      if (page == 1) {
        refreshCltr.refreshCompleted();
      } else {
        refreshCltr.loadComplete();
      }
    });
  }

  @override
  void dispose() {
    widget.placeOrderPro.showManageTab = false;
    // scrollCltr2.dispose();
    widget.placeOrderPro.selectedSubCatIndex = null;
    widget.placeOrderPro.searchCltr.clear();
    widget.placeOrderPro.selectedAlpha = '';
    refreshCltr.dispose();
    if (posScrollCltr != null && posScrollCltr!.hasClients)
      posScrollCltr!.dispose();
    // if (_timer != null) _timer!.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = Ssize(context);
    final posPro = Provider.of<PosRetailPro>(context);
    posPro.placeOrderPro = widget.placeOrderPro;

    if (widget.placeOrderPro.showManageTab)
      return OrderTabManageScreen(
        placePro: widget.placeOrderPro,
        scafKey: widget.scafKey,
      );
    else
      return Padding(
        padding: EdgeInsets.symmetric(horizontal: size.getW(8)),
        child: Processing(
          loading: widget.placeOrderPro.orderTabLoading,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: size.getH(12)),
              SearchSection(
                placeOrderPro: widget.placeOrderPro,
                scafKey: widget.scafKey,
              ),
              if (widget.placeOrderPro.alphaList?.isNotEmpty ?? false)
                SizedBox(
                  height: size.getH(48),
                  child: Align(
                    alignment: Alignment.center,
                    child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: size.getW(4),
                                vertical: size.getH(4)),
                            child: InkWell(
                              onTap: () {
                                final _nextAlph =
                                    widget.placeOrderPro.alphaList?[index] ??
                                        '';

                                if (widget.placeOrderPro.selectedAlpha ==
                                    _nextAlph)
                                  widget.placeOrderPro.selectedAlpha = null;
                                else
                                  widget.placeOrderPro.selectedAlpha =
                                      _nextAlph;

                                widget.placeOrderPro.notify;
                                widget.placeOrderPro.loading = true;
                                widget.placeOrderPro.getItemData();
                              },
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: size.getW(18),
                                    vertical: size.getH(0)),
                                decoration: BoxDecoration(
                                  color: widget.placeOrderPro.selectedAlpha ==
                                          widget.placeOrderPro.alphaList?[index]
                                      ? kUserColor
                                      : Colors.white,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Center(
                                  child: Text(
                                    widget.placeOrderPro.alphaList?[index] ??
                                        '',
                                    style: TextStyle(
                                      color:
                                          widget.placeOrderPro.selectedAlpha ==
                                                  widget.placeOrderPro
                                                      .alphaList?[index]
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
                        itemCount: widget.placeOrderPro.alphaList?.length ?? 0,
                        shrinkWrap: true),
                  ),
                ),
              if (widget.onTapSubs != null &&
                  (widget.placeOrderPro.initAddSec?.message?.isNotEmpty ??
                      false)) ...[
                SizedBox(
                  height: size.getH(12),
                ),
                TrialExpiryMsg(
                    size: size,
                    show:
                        widget.placeOrderPro.initAddSec?.message?.isNotEmpty ??
                            false,
                    message: widget.placeOrderPro.initAddSec?.message ?? '',
                    btnText: (widget.placeOrderPro.initAddSec
                                ?.isSubscriptionActive ??
                            false)
                        ? LN.changePlan
                        : LN.subsNow,
                    onTap: widget.onTapSubs)
              ],
              TitleSection(
                placeOrderPro: widget.placeOrderPro,
              ),
              if (_isPromoCat && PromoUtils.promoDuration != null)
                Flexible(
                    child: PromoTImerSection(
                  onTimeStop: () {
                    PromoUtils.promoDuration = null;
                    widget.placeOrderPro.getInitData();
                    widget.placeOrderPro.notify;
                  },
                  duration: PromoUtils.promoDuration!,
                ))
              else
                Flexible(child: Builder(builder: (context) {
                  return SmartRefresher(
                    controller: refreshCltr,
                    scrollController: posScrollCltr,
                    enablePullUp: true,
                    onLoading: () {
                      paginate(widget.placeOrderPro.pageIndex + 1);
                    },
                    onRefresh: () {
                      paginate(1);
                    },
                    child: ListView(
                      shrinkWrap: true,
                      controller: posScrollCltr,
                      children: [
                        if (widget.placeOrderPro.itemViewType ==
                            ItemViewType.combo)
                          SetMenuItem(
                            setMenuList: widget.placeOrderPro.comboViewList,
                            curSym: widget.placeOrderPro.curSym,
                            size: size,
                            placeOrderPro: widget.placeOrderPro,
                          )
                        else if (widget.placeOrderPro.itemViewType ==
                            ItemViewType.ingre)
                          RawIngreItems(
                            dataList: widget.placeOrderPro.ingreViewList,
                            curSym: widget.placeOrderPro.curSym,
                          )
                        else if (widget.placeOrderPro.itemViewType ==
                            ItemViewType.product)
                          _productItems(
                              itemViewList: widget.placeOrderPro.itemViewList)
                      ],
                    ),
                  );
                })),
            ],
          ),
        ),
      );
  }

  Widget _productItems({required List<FeaturedProduct> itemViewList}) {
    return ProductItem(
      key: ValueKey(widget.placeOrderPro.loading),
      placeOrderPro: widget.placeOrderPro,
      itemViewList: itemViewList,
      curSym: widget.placeOrderPro.curSym,
      onTap: (p2) async {
        FeaturedProduct product;

        try {
          product = itemViewList.firstWhere((a) => a.id == p2);
        } catch (e) {
          return;
        }

        if (product.productVariations == null) return;

        if (OrderUtils.doDirectAddToCart(
            product: product,
            channelId:
                widget.placeOrderPro.initAddSec?.orderTypes?.isNotEmpty ?? false
                    ? (widget
                            .placeOrderPro
                            .initAddSec
                            ?.orderTypes?[widget.placeOrderPro.orderTypeIndex]
                            .channelId ??
                        '')
                    : '')) {
          final variation = product.productVariations?.first;

          if (GlobalCVP.stockExceedRestriction &&
              variation?.stockCount != null &&
              variation!.stockCount!.isNotEmpty &&
              variation.stockCount.inDouble <= 0) {
            IfException.showMessage(message: LN.productOutOfStock);
            return;
          }
          product.quantity = 1;

          widget.placeOrderPro
              .updateOrderCart(
            product: product,
            variation: variation,
            catId: product.categoryId,
          )
              .then((value) {
            if (value) {
              IfException.showMessage(
                  message: LN.addCartSuccess, isError: false);
            }
          });
        } else {
          widget.placeOrderPro.productDetailView = null;

          PosTab.selectVarience(
            context,
            featuredProduct: product,
            placeOrderPro: widget.placeOrderPro,
          );
        }
      },
      // addedId:
      //     widget.placeOrderPro.orderList.map((e) => e.productId ?? '').toList(),
    );
  }
}
