import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pos_account/config/utils/promo_utils.dart';
import 'package:pos_account/config/size_config.dart';
import 'package:pos_account/constant/constant.dart';
import 'package:pos_account/constant/strings.dart';
import 'package:pos_account/ln.dart';
import 'package:pos_account/model/home/menu/place_order/pos_res/pos_cat_res.dart';
import 'package:pos_account/providers/cus_val_pro.dart';
import 'package:pos_account/providers/keypad/keypad_pro.dart';
import 'package:pos_account/providers/menu/place_order_pro.dart';
import 'package:pos_account/screens/home_screen/com/items/tabs/floor_tab/booking_tab/com/booking_drawer.dart';
import 'package:pos_account/screens/home_screen/com/items/tabs/pos_tab/pos_non_retail/pos_tab.dart';
import 'package:pos_account/screens/home_screen/com/items/tabs/pos_tab/pos_retail/pos_retail_section.dart';
import 'package:pos_account/screens/home_screen/com/pos_orders/com/order_drawer.dart';
import 'package:pos_account/widgets/image/svg_image_sec.dart';
import 'package:provider/provider.dart';
import '../../providers/menu/pos_retail_pro.dart';
import 'com/logo_sec.dart';

class CustomDrawer extends StatelessWidget {
  final PageController? homeProfilePageCltr;
  const CustomDrawer({
    super.key,
    this.homeProfilePageCltr,
  });

  @override
  Widget build(BuildContext context) {
    final size = Ssize(context);
    final placeOrderPro = Provider.of<PlaceOrderPro>(context);
    final posPro = Provider.of<PosRetailPro>(context);

    final KeyPadPro keyPro = Provider.of<KeyPadPro>(context);
    final cvp = GlobalCVP;
    final _promoCat = PromoUtils.currentPromotion?.isNotEmpty ?? false
        ? CategoryData(
            id: Strings.staticPromoId,
            name: PromoUtils.currentPromotion!.length > 1
                ? 'Promotion'
                : PromoUtils.currentPromotion?.first.name,
            type: "Promotion",
            defaultBackGroundColor: '#4FAF8A',
            defaultTextColor: '#FFFFFF',
            // onFocusBackGroundColor: ,
            onFocusTextColor: '#FFFFFF',
            itemViewType: ItemViewType.promotion,
          )
        : null;

    final _allProdCat = CategoryData(
      id: '',
      name: 'All',
      type: "AllProducts",
      // defaultBackGroundColor: '#4FAF8A',
      // defaultTextColor: '#FFFFFF',
      // onFocusTextColor: '#FFFFFF',
      itemViewType: ItemViewType.product,
    );

    final _categories = [_allProdCat] +
        (_promoCat != null ? [_promoCat] : <CategoryData>[]) +
        (cvp.isRetailStore
            ? (posPro.posCatRes?.comboCategories ?? []) +
                (posPro.posCatRes?.rawLooseCategories ?? []) +
                (posPro.posCatRes?.productCategories ?? [])
            : (placeOrderPro.posCatRes?.comboCategories ?? []) +
                (placeOrderPro.posCatRes?.rawLooseCategories ?? []) +
                (placeOrderPro.posCatRes?.productCategories ?? []));

    // print("${cvp.isRetailStore} :: ${_categories.length}");

    return Drawer(
      backgroundColor: Colors.transparent,
      elevation: 0,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: SizedBox(
              width: double.infinity,
              child: LogoSection(
                size: size,
              ),
            ),
          ),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                  color: _categories.isNotEmpty &&
                          cvp.getMainPage != MainPage.OrderPage
                      ? kBackgroundColor
                      : cvp.isRetailStore //&& cvp.isRetailScreen
                          ? kBackgroundColor
                          : kPrimaryColor,
                  borderRadius: BorderRadius.only(
                    // topLeft: Radius.circular(10),
                    topRight: Radius.circular(20),
                  )),
              padding: EdgeInsets.only(left: size.getW(4)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: (cvp.tabs[cvp.currentPage].title == LN.orders ||
                            cvp.tabs[cvp.currentPage].title == LN.services)
                        ? OrderDrawer(
                            key: ValueKey(LN.orders),
                          )
                        : (cvp.tabs[cvp.currentPage].title == "Appointments" ||
                                cvp.tabs[cvp.currentPage].title == "Booking")
                            ? BookingDrawer(
                                key: ValueKey("Booking"),
                              )
                            : (cvp.tabs[cvp.currentPage].title == "Keypad")
                                ? keyPadDrawer(
                                    key: ValueKey("Keypad"),
                                    size: size,
                                    keyPro: keyPro,
                                  )
                                : (_categories.isNotEmpty &&
                                        cvp.isRetailStore &&
                                        ((cvp.tabs[cvp.currentPage].title !=
                                                "Manage") ||
                                            cvp.getMainPage ==
                                                MainPage.HomePage))
                                    ? _retailScreenCatDrawer(
                                        size: size,
                                        // placeOrderPro: placeOrderPro,
                                        categories: _categories,
                                        posPro: posPro,
                                      )
                                    : _categories.isNotEmpty &&
                                            !cvp.isRetailStore &&
                                            !placeOrderPro.showManageTab &&
                                            (cvp.tabs[cvp.currentPage].title !=
                                                "Keypad") &&
                                            ((cvp.tabs[cvp.currentPage].title !=
                                                    "Manage") ||
                                                cvp.getMainPage ==
                                                    MainPage.HomePage)
                                        ? Align(
                                            alignment: Alignment.topLeft,
                                            child: GridView.builder(
                                              key: ValueKey("Pos"),
                                              shrinkWrap: true,
                                              padding: EdgeInsets.only(
                                                  bottom: size.getH(24)),
                                              physics: BouncingScrollPhysics(),
                                              itemBuilder: (context, index) {
                                                return DrawerTile(
                                                  key: ValueKey(
                                                      _categories[index].id),
                                                  size: size,
                                                  isSelected: placeOrderPro
                                                          .selectedCatId ==
                                                      _categories[index].id,
                                                  isDrawerFocus: (cvp
                                                          .tabs.isNotEmpty &&
                                                      cvp.tabs[cvp.currentPage]
                                                              .title ==
                                                          LN.pos),
                                                  imageUrl: _categories[index]
                                                      .imageUrl,
                                                  catName:
                                                      _categories[index].name,
                                                  onTap: () async {
                                                    placeOrderPro.posDataPath =
                                                        PosDataPath.Drawer;
                                                    cvp.jumpToTabOnSetPage =
                                                        false;
                                                    cvp.setMainPage =
                                                        MainPage.HomePage;

                                                    placeOrderPro
                                                        .selectedAlpha = null;
                                                    placeOrderPro
                                                            .selectedSubCatIndex =
                                                        null;

                                                    if (placeOrderPro
                                                            .selectedCatId ==
                                                        _categories[index].id) {
                                                      placeOrderPro
                                                          .selectedCatId = "";
                                                      placeOrderPro
                                                          .categoryTitle = null;
                                                    } else {
                                                      placeOrderPro
                                                              .selectedCatId =
                                                          _categories[index]
                                                                  .id ??
                                                              '';
                                                      placeOrderPro
                                                              .categoryTitle =
                                                          _categories[index]
                                                              .name;
                                                    }

                                                    placeOrderPro.loading =
                                                        true;

                                                    placeOrderPro.notify;
                                                    if (cvp.tabs.any(
                                                        (element) =>
                                                            element.title ==
                                                            LN.pos))
                                                      cvp.setCurrentPage(
                                                        cvp.tabs.indexWhere(
                                                            (element) =>
                                                                element.title ==
                                                                LN.pos),
                                                      );

                                                    if (_categories[index]
                                                            .itemViewType ==
                                                        null) return;

                                                    placeOrderPro.itemViewType =
                                                        _categories[index]
                                                            .itemViewType!;

                                                    if (placeOrderPro
                                                                .itemViewType ==
                                                            ItemViewType
                                                                .promotion &&
                                                        PromoUtils
                                                                .currentPromotion !=
                                                            null) {
                                                      placeOrderPro
                                                          .orderTabName = "";
                                                      placeOrderPro.orderTabId =
                                                          "";
                                                      placeOrderPro
                                                          .orderTabLimit = null;
                                                      placeOrderPro
                                                              .showManageTab =
                                                          false;
                                                      // placeOrderPro.selectedAlpha = null;
                                                      // placeOrderPro.selectedSubCatIndex = null;
                                                      // placeOrderPro.selectedCatId = '';
                                                      // placeOrderPro.categoryTitle = null;
                                                      placeOrderPro.searchCltr
                                                          .clear();
                                                      placeOrderPro.brandIndex =
                                                          null;
                                                      // kPrint(
                                                      //     "1. ${placeOrderPro.promoId} ${PromoUtils.currentPromotion?.first.id}");
                                                      if (placeOrderPro
                                                              .promoId ==
                                                          PromoUtils
                                                              .currentPromotion
                                                              ?.first
                                                              .id)
                                                        placeOrderPro.promoId =
                                                            null;
                                                      else
                                                        placeOrderPro.promoId =
                                                            PromoUtils
                                                                .getNearestPromoId();
                                                      // PromoUtils
                                                      //     .currentPromotion
                                                      //     ?.first
                                                      //     .id;
                                                    } else {
                                                      placeOrderPro.promoId =
                                                          null;
                                                    }

                                                    // kPrint(
                                                    //     "2. ${placeOrderPro.promoId}");

                                                    await placeOrderPro
                                                        .getInitData();

                                                    placeOrderPro.posDataPath =
                                                        PosDataPath.Menu;
                                                    if ((posScrollCltr
                                                                ?.hasClients ??
                                                            false) &&
                                                        posScrollCltr!.offset >
                                                            0) {
                                                      posScrollCltr!
                                                          .jumpTo(0.0);
                                                    }
                                                  },
                                                  drawerColor:
                                                      TileColor.getColor(
                                                    backColor: _categories[
                                                            index]
                                                        .defaultBackGroundColor,
                                                    textColor:
                                                        _categories[index]
                                                            .defaultTextColor,
                                                    selectedBackColor: _categories[
                                                            index]
                                                        .onFocusBackGroundColor,
                                                    selectedTextColor:
                                                        _categories[index]
                                                            .onFocusTextColor,
                                                  ),
                                                );
                                              },
                                              itemCount: _categories.length,
                                              gridDelegate:
                                                  SliverGridDelegateWithFixedCrossAxisCount(
                                                crossAxisCount: 2,
                                                crossAxisSpacing: 4.0,
                                                mainAxisSpacing: 4.0,
                                                childAspectRatio: 1,
                                              ),
                                            ),
                                          )
                                        : Container(),
                  ),
                  // AllOrderButton()
                  // buildStatus(size),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _retailScreenCatDrawer({
    required Ssize size,
    // required PlaceOrderPro placeOrderPro,
    required final List<CategoryData> categories,
    required PosRetailPro posPro,
  }) {
    return Container(
      constraints: BoxConstraints(
        minHeight: size.getH(300),
      ),
      decoration: BoxDecoration(
        border: Border(
          right: BorderSide(
            color: Colors.grey.shade300,
            width: 1,
          ),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 2.0),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                itemCount: categories.length,
                itemBuilder: (context, index) {
                  return InkWell(
                    onTap: () {
                      if (posPro.selectedCatId == categories[index].id) {
                        posPro.selectedCatId = "";
                      } else {
                        posPro.selectedCatId = categories[index].id ?? "";
                      }
                      posPro.itemViewType = categories[index].itemViewType ??
                          ItemViewType.product;
                      posPro.selectedAlpha = null;

                      posPro.pageLoad = true;
                      if (GlobalCVP.tabs
                          .any((element) => element.title == LN.pos)) {
                        final _posTab = GlobalCVP.tabs
                            .indexWhere((element) => element.title == LN.pos);

                        GlobalCVP.setCurrentPage(_posTab);
                        GlobalCVP.notify;
                      }

                      if (posPro.itemViewType == ItemViewType.promotion &&
                          PromoUtils.currentPromotion != null) {
                        posPro.searchCltr.clear();
                        posPro.selectedBrandId = "";
                        if (posPro.promoId ==
                            PromoUtils.currentPromotion?.first.id)
                          posPro.promoId = null;
                        else
                          posPro.promoId = PromoUtils.getNearestPromoId();
                      } else {
                        posPro.promoId = null;
                      }

                      posPro.notify;

                      posPro.getItemData(page: 1);
                      // }
                      if ((retailScrollCltr?.hasClients ?? false) &&
                          retailScrollCltr!.offset > 0) {
                        retailScrollCltr!.jumpTo(0.0);
                      }
                    },
                    child: Card(
                      margin: EdgeInsets.symmetric(
                        vertical: size.getH(4),
                        horizontal: size.getW(4),
                      ),
                      elevation: 5,
                      child: Container(
                        width: size.getW(200),
                        padding: EdgeInsets.symmetric(
                          vertical: size.getH(8),
                          horizontal: size.getW(8),
                        ),
                        decoration: BoxDecoration(
                          color: posPro.selectedCatId == categories[index].id
                              ? kSecondaryColor
                              : categories[index].id == Strings.staticPromoId
                                  ? kSecondaryColor.withOpacity(0.15)
                                  : null,
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            // ClipRRect(
                            //   borderRadius: BorderRadius.circular(5),
                            //   child: CachedNetworkImage(
                            //     imageUrl:
                            //         _categories[index].imageUrl ?? "",
                            //     height: size.getH(50),
                            //     width: size.getW(50),
                            //     fit: BoxFit.cover,
                            //   ),
                            // ),
                            // SizedBox(width: size.getW(8)),
                            Flexible(
                              child: Text(
                                categories[index].name ?? "",
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: size.getS(16),
                                  color: posPro.selectedCatId ==
                                          categories[index].id
                                      ? Colors.white
                                      : categories[index].id ==
                                              Strings.staticPromoId
                                          ? kSecondaryColor
                                          : Colors.black,
                                  fontFamily: kFontFMedium,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget keyPadDrawer({
    Key? key,
    required Ssize size,
    required KeyPadPro keyPro,
  }) {
    return Column(
      key: key,
      children: [
        if (keyPro.keyPadProducts?.isNotEmpty ?? false)
          Expanded(
            child: Container(
              color: Colors.white,
              child: ListView.separated(
                scrollDirection: Axis.vertical,
                separatorBuilder: (context, index) {
                  return SizedBox(height: size.getH(5));
                },
                shrinkWrap: true,
                itemCount: keyPro.keyPadProducts?.length ?? 0,
                itemBuilder: (context, index) {
                  if (index < keyPro.keyPadProducts!.length)
                    return InkWell(
                      onTap: () {
                        keyPro.selectProduct(
                          featuredProduct: keyPro.keyPadProducts![index],
                        );
                        keyPro.notify;
                      },
                      child: Container(
                        width: size.getW(200),
                        height: size.getH(80),
                        decoration: BoxDecoration(
                          color: keyPro.isProductSelected(
                                  keyPro.keyPadProducts?[index])
                              ? kSecondaryColor
                              : null,
                          borderRadius: BorderRadius.circular(5),
                          border: Border.all(
                            color: Colors.grey.shade300,
                            width: 1,
                          ),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              keyPro.keyPadProducts?[index].name ?? "",
                              style: TextStyle(
                                fontSize: size.getS(18),
                                color: keyPro.isProductSelected(
                                        keyPro.keyPadProducts?[index])
                                    ? Colors.white
                                    : Colors.black,
                                fontFamily: kFontFMedium,
                              ),
                            ),
                            if (keyPro.keyPadProducts?[index].productVariations
                                    ?.isNotEmpty ??
                                false)
                              Text(
                                keyPro.keyPadProducts?[index].productVariations
                                        ?.first.name ??
                                    "",
                                style: TextStyle(
                                  fontSize: size.getS(16),
                                  color: keyPro.isProductSelected(
                                          keyPro.keyPadProducts?[index])
                                      ? Colors.white
                                      : Colors.black,
                                  fontFamily: kFontFMedium,
                                ),
                              ),
                          ],
                        ),
                      ),
                    );
                  else
                    return SizedBox.shrink();
                },
              ),
            ),
          ),
      ],
    );
  }

  // Widget buildStatus(Ssize size) {
  //   final _status = SignalRCore.status == ConnectionStatus.Online;
  //   final _isNetSlow = InternetUtils.status == InternetStatus.Slow;
  //   return Container(
  //     padding: EdgeInsets.symmetric(
  //       horizontal: size.getW(10),
  //       vertical: size.getH(4),
  //     ),
  //     decoration: BoxDecoration(
  //       color: _status
  //           ? (_isNetSlow ? Colors.amber.shade700 : Colors.green)
  //           : Colors.grey,
  //       borderRadius: BorderRadius.circular(8),
  //       border: Border.all(color: Colors.white, width: 1),
  //     ),
  //     child: Text(
  //       (SignalRCore.status != ConnectionStatus.Online &&
  //               SignalRCore.status != ConnectionStatus.Offline)
  //           ? "${SignalRCore.status.name}.."
  //           : '● ${_status ? 'Online' : 'Offline'}',
  //       style: TextStyle(
  //         color: Colors.white,
  //         fontSize: size.getS(14),
  //         fontWeight: FontWeight.bold,
  //         fontFamily: kFontFMedium,
  //       ),
  //     ),
  //   );
  // }
}

class DrawerTile extends StatelessWidget {
  final Function()? onTap;
  final Ssize size;
  final String? catName;
  final bool isSelected;
  final String? imageUrl;
  final bool isDrawerFocus;
  final TileColor? drawerColor;
  final Widget? overlay;
  const DrawerTile({
    super.key,
    this.onTap,
    required this.size,
    this.catName,
    this.isSelected = false,
    this.imageUrl,
    this.isDrawerFocus = false,
    this.drawerColor,
    this.overlay,
  });

  @override
  Widget build(BuildContext context) {
    final catLen = catName?.length ?? 0;
    final _drawerColor = drawerColor ?? TileColor.defaultColor();
    return InkWell(
      key: ValueKey(key),
      borderRadius: BorderRadius.circular(10),
      onTap: onTap,
      child: Stack(
        fit: StackFit.expand,
        children: [
          AnimatedContainer(
            width: size.getW(100),
            constraints: BoxConstraints(
                maxHeight: size.getH(120), minHeight: size.getH(84)),
            duration: Duration(milliseconds: 300),
            margin: EdgeInsets.symmetric(vertical: size.getH(0)),
            decoration: BoxDecoration(
                color: isSelected
                    ? (isDrawerFocus
                        ? _drawerColor.selectedBackColor
                        : _drawerColor.selectedBackColor?.withOpacity(0.4))
                    : _drawerColor.backColor,
                borderRadius: BorderRadius.circular(5)),
            padding: EdgeInsets.symmetric(
                vertical: size.getH(2), horizontal: size.getW(4)),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Flexible(
                  child: Text(
                    catName ?? '',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: size.getS(catLen > 32
                          ? 13
                          : catLen > 28
                              ? 15
                              : 17),
                      color: isSelected
                          ? _drawerColor.selectedTextColor
                          : _drawerColor.textColor,
                      fontWeight: FontWeight.w700,
                      fontFamily: kFontFMedium,
                    ),
                    overflow: TextOverflow.fade,
                  ),
                )
              ],
            ),
          ),
          if (overlay != null) overlay!,
        ],
      ),
    );
  }
}

class DragObjectDrawer extends StatelessWidget {
  final Ssize size;
  final String? catName;
  final String? catImage;
  const DragObjectDrawer(
      {super.key, required this.size, this.catName, this.catImage});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        catImage == null || catImage!.isEmpty
            ? SvgPicture.asset(
                "assets/svg/icons/Graph.svg",
                width: size.getW(40),
                height: size.getW(40),
                theme: SvgTheme(
                  currentColor: Colors.white70,
                ),
                // color: Colors.white70,
              )
            : SvgImageSection(
                imageUrl: catImage!,
                width: size.getW(40),
                height: size.getW(40),
                placeholder: (ctx) => SvgPicture.asset(
                  "assets/svg/icons/Graph.svg",
                  width: size.getW(40),
                  height: size.getW(40),
                  theme: SvgTheme(
                    currentColor: Colors.white70,
                  ),
                  // color: Colors.white70,
                ),
              ),
        SizedBox(height: size.getH(4)),
        Flexible(
          child: Text(
            catName ?? '',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: size.getS(14),
              color: Colors.white,
              fontWeight: FontWeight.w700,
              fontFamily: kFontFMedium,
            ),
            overflow: TextOverflow.visible,
          ),
        )
      ],
    );
  }
}
