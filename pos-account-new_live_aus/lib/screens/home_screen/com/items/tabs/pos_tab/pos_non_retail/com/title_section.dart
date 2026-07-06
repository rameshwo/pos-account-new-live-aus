import 'package:flutter/material.dart';
import 'package:pos_account/config/utils/promo_utils.dart';
import 'package:pos_account/config/size_config.dart';
import 'package:pos_account/constant/constant.dart';
import 'package:pos_account/constant/strings.dart';
import 'package:pos_account/ln.dart';
import 'package:pos_account/model/home/menu/place_order/pos_res/pos_cat_res.dart';
import 'package:pos_account/providers/cus_val_pro.dart';
import 'package:pos_account/providers/menu/place_order_pro.dart';
import 'package:pos_account/providers/menu/pos_retail_pro.dart';

class TitleSection extends StatelessWidget {
  final PlaceOrderPro placeOrderPro;
  final PosRetailPro? posRetailPro;
  TitleSection({
    super.key,
    required this.placeOrderPro,
    this.posRetailPro,
  });

  final _scrollCltr = ScrollController();
  final _scrollCltr2 = ScrollController();
  final _scrollCltr3 = ScrollController();

  bool get isRetail => posRetailPro != null;

  Future<void> _onSelectSubCat(int i) async {
    placeOrderPro.loading = true;
    posRetailPro?.pageLoad = true;
    if (isRetail) {
      if (posRetailPro?.selectedSubCatIndex == i)
        posRetailPro?.selectedSubCatIndex = null;
      else
        posRetailPro?.selectedSubCatIndex = i;
      posRetailPro!.notify;

      await posRetailPro?.getItemData(
          subCatId: posRetailPro?.selectedSubCatIndex == null
              ? null
              : posRetailPro!.subCategoryList![i].id);
    } else {
      if (placeOrderPro.selectedSubCatIndex == i)
        placeOrderPro.selectedSubCatIndex = null;
      else
        placeOrderPro.selectedSubCatIndex = i;
      placeOrderPro.notify;

      if (placeOrderPro.itemViewType == ItemViewType.combo) {
        await placeOrderPro.getComboData(
            subCatId: placeOrderPro.selectedSubCatIndex == null
                ? null
                : placeOrderPro.subCategoryList![i].id);
      } else if (placeOrderPro.itemViewType == ItemViewType.ingre) {
        await placeOrderPro.getIngreData(
            subCatId: placeOrderPro.selectedSubCatIndex == null
                ? null
                : placeOrderPro.subCategoryList![i].id);
      } else {
        await placeOrderPro.getItemData(
            subCatId: placeOrderPro.selectedSubCatIndex == null
                ? null
                : placeOrderPro.subCategoryList![i].id);
      }
    }

    placeOrderPro.loading = false;
    posRetailPro?.pageLoad = false;
    placeOrderPro.notify;
  }

  void _onSelectPromoCat(String? id) {
    if (isRetail) {
      posRetailPro?.promoId = id;
      posRetailPro?.getItemData();
      posRetailPro?.pageLoad = false;
      posRetailPro!.notify;
    } else {
      placeOrderPro.promoId = id;
      placeOrderPro.getInitData();
      placeOrderPro.loading = false;
      posRetailPro?.pageLoad = false;
      placeOrderPro.notify;
    }
  }

  Future<void> _onSelectDocket(int i) async {
    placeOrderPro.loading = true;

    if (placeOrderPro.selectedDocketIndex == i)
      placeOrderPro.selectedDocketIndex = null;
    else
      placeOrderPro.selectedDocketIndex = i;
    placeOrderPro.notify;

    if (placeOrderPro.itemViewType == ItemViewType.product) {
      await placeOrderPro.getItemData(
          docketName: placeOrderPro.selectedDocketIndex == null
              ? null
              : placeOrderPro.docketNameList![i]);
    }

    placeOrderPro.loading = false;
    placeOrderPro.notify;
  }

  bool get _isPromoCatHospitality =>
      placeOrderPro.promoId != null &&
      placeOrderPro.selectedCatId == Strings.staticPromoId;

  bool get _isPromoCatRetail =>
      posRetailPro?.promoId != null &&
      posRetailPro?.selectedCatId == Strings.staticPromoId;

  @override
  Widget build(BuildContext context) {
    final size = Ssize(context);
    final _selectedCatId =
        isRetail ? posRetailPro?.selectedCatId : placeOrderPro.selectedCatId;

    final _subCatList = isRetail
        ? posRetailPro?.subCategoryList
        : placeOrderPro.subCategoryList;

    final _subCatIndex = isRetail
        ? posRetailPro?.selectedSubCatIndex
        : placeOrderPro.selectedSubCatIndex;

    final _promoList = ((isRetail && _isPromoCatRetail) ||
                (!isRetail && _isPromoCatHospitality)) &&
            PromoUtils.currentPromotion != null &&
            PromoUtils.currentPromotion!.length > 1
        ? PromoUtils.currentPromotion
        : null;
    return Padding(
      padding: EdgeInsets.only(right: size.getW(24.0)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!isRetail) ...[
            if (_selectedCatId == null || _selectedCatId.isEmpty) ...[
              if (GlobalCVP.isServiceStore)
                Text(
                  LN.allServices,
                  style: TextStyle(
                    fontSize: size.getS(18),
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                )
              else ...[
                Text(
                  LN.allProducts,
                  style: TextStyle(
                    fontSize: size.getS(18),
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                if (placeOrderPro.docketNameList != null)
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    // controller: _scrollCltr,
                    child: Row(
                      children: [
                        ...List.generate(placeOrderPro.docketNameList!.length,
                            (i) {
                          final _docket = placeOrderPro.docketNameList![i];
                          return _tabItem(
                            size,
                            isSelected: placeOrderPro.selectedDocketIndex == i,
                            isSubCat: false,
                            title: _docket,
                            onTap: () => _onSelectDocket(i),
                          );
                        }),
                      ],
                    ),
                  )
              ]
            ],
            if (placeOrderPro.categoryTitle != null)
              Text(
                placeOrderPro.categoryTitle ?? '',
                style: TextStyle(
                  fontSize: size.getS(18),
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
          ],
          if (_promoList?.isNotEmpty ?? false)
            Padding(
                padding: EdgeInsets.symmetric(horizontal: size.getW(4)),
                child: Row(children: [
                  Expanded(
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      controller: _scrollCltr3,
                      child: Row(
                        children: [
                          ...List.generate(_promoList!.length, (i) {
                            final _promoCats = _promoList[i];
                            return _tabItem(size,
                                isSelected: isRetail
                                    ? posRetailPro?.promoId == _promoCats.id
                                    : placeOrderPro.promoId == _promoCats.id,
                                title: _promoCats.name ?? '',
                                onTap: () => _onSelectPromoCat(_promoCats.id));
                          }),
                        ],
                      ),
                    ),
                  ),
                ])),
          if ((_subCatList?.isNotEmpty ?? false) &&
              (_selectedCatId?.isNotEmpty ?? false))
            Padding(
              padding: EdgeInsets.symmetric(horizontal: size.getW(4)),
              child: Row(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      controller: _scrollCltr,
                      child: Row(
                        children: [
                          ...List.generate(_subCatList!.length, (i) {
                            final _subCats = _subCatList[i];
                            return _tabItem(size,
                                isSelected: _subCatIndex == i,
                                title: _subCats.name ?? '',
                                onTap: () => _onSelectSubCat(i));
                          }),
                        ],
                      ),
                    ),
                  ),
                  PopupMenuButton(
                    tooltip: "Show category",
                    itemBuilder: (_) {
                      return [
                        PopupMenuItem(
                          padding: EdgeInsets.zero,
                          height: 0,
                          enabled: false,
                          child: SizedBox(
                            height: _subCatList.length > 10
                                ? 400.0
                                : (40.0 * _subCatList.length),
                            width: double.infinity,
                            child: Scrollbar(
                              controller: _scrollCltr2,
                              // isAlwaysShown: false,
                              trackVisibility: true,
                              thickness: 4,
                              child: SingleChildScrollView(
                                controller: _scrollCltr2,
                                child: Column(
                                  children:
                                      List.generate(_subCatList.length, (i) {
                                    return Container(
                                      width: double.infinity,
                                      color:
                                          _subCatIndex == i ? kTempColor : null,
                                      child: InkWell(
                                        onTap: () {
                                          _onSelectSubCat(i);

                                          final _val = _subCatList
                                              .getRange(0, i)
                                              .fold<double>(
                                                  0,
                                                  (pV, nV) =>
                                                      pV +
                                                      (nV.name?.length ?? 0));

                                          _scrollCltr.animateTo(
                                              (i * 12) + _val * 8.4,
                                              duration:
                                                  Duration(milliseconds: 600),
                                              curve: Curves.easeInOut);
                                          Navigator.pop(context);
                                        },
                                        child: Padding(
                                          padding: EdgeInsets.symmetric(
                                              vertical: size.getH(8),
                                              horizontal: size.getW(12)),
                                          child: Text(
                                            _subCatList[i].name ?? '',
                                            style: TextStyle(
                                              fontSize: size.getS(18),
                                              color: _subCatIndex == i
                                                  ? Colors.white
                                                  : Colors.black,
                                              fontFamily: kFontFMedium,
                                            ),
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                      ),
                                    );
                                  }),
                                ),
                              ),
                            ),
                          ),
                        )
                      ];
                    },
                    child: Icon(Icons.more_vert),
                  )
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _tabItem(
    Ssize size, {
    bool isSelected = false,
    required String title,
    Function()? onTap,
    bool isSubCat = true,
  }) {
    return Card(
      color: isSelected
          ? kSecondaryColor
          : isSubCat
              ? kPrimaryColor
              : null,
      shape: RoundedRectangleBorder(
        side: BorderSide(color: kSecondaryColor),
        borderRadius: BorderRadius.circular(5),
      ),
      margin: EdgeInsets.symmetric(
          vertical: size.getH(4), horizontal: size.getW(4)),
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: EdgeInsets.symmetric(
              vertical: size.getH(8.0), horizontal: size.getW(8)),
          child: Text(
            title,
            style: TextStyle(
              fontSize: size.getS(16),
              color: isSelected || isSubCat ? Colors.white : kSecondaryColor,
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
}
