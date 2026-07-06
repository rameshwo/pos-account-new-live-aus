import 'package:flutter/material.dart';
import 'package:oktoast/oktoast.dart';
import 'package:pos_account/config/responsive.dart';
import 'package:pos_account/config/size_config.dart';
import 'package:pos_account/config/validator.dart';
import 'package:pos_account/constant/constant.dart';
import 'package:pos_account/ln.dart';
import 'package:pos_account/model/home/menu/place_order/place_order_req.dart';
import 'package:pos_account/model/home/menu/place_order/pos_res/com/combo_detail_by_id.dart';
import 'package:pos_account/model/home/menu/place_order/pos_res/com/feature_product.dart';
import 'package:pos_account/model/home/menu/place_order/pos_res/pos_combo_res.dart';
import 'package:pos_account/providers/cus_val_pro.dart';
import 'package:pos_account/providers/menu/place_order_pro.dart';
import 'package:pos_account/screens/home_screen/com/items/tabs/pos_tab/variance_3/variance_item.dart';
import 'package:pos_account/screens/home_screen/com/quantity_sec.dart';
import 'package:pos_account/widgets/dialog/confirm_dialog.dart';
import 'package:pos_account/widgets/dialog/msg_dialog.dart';
import 'package:pos_account/widgets/image/network_image_sec.dart';
import 'package:pos_account/widgets/load_btn.dart';
import 'package:pos_account/widgets/loading.dart';
import 'package:pos_account/widgets/no_items_sec.dart';
import 'package:provider/provider.dart';
import 'combo/combo_item_detail.dart';
import 'combo/combo_retail_items.dart';
import 'item_tile.dart';

class SetMenuItem extends StatelessWidget {
  final List<ComboProduct> setMenuList;
  final Ssize size;
  final String? curSym;
  final PlaceOrderPro placeOrderPro;
  const SetMenuItem({
    super.key,
    required this.setMenuList,
    required this.size,
    this.curSym,
    required this.placeOrderPro,
  });

  onSelectSetMenu(BuildContext context, {required String setMenuId}) {
    placeOrderPro.selectedSetMenuProduct = null;
    placeOrderPro.loading = true;
    return showDialog(
        context: context,
        builder: (builder) => SimpleDialog(
              backgroundColor: kBackgroundColor,
              titlePadding: EdgeInsets.zero,
              // insetPadding: EdgeInsets.zero,
              contentPadding:
                  EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15)),
              children: [
                SetMenuDialog(
                  setMenuId: setMenuId,
                )
              ],
            )).then((_) {
      placeOrderPro.comboDetailById = null;
      // Future.delayed(Duration(milliseconds: 300), () {
      //   if (placeOrderPro.initRes?.setMenus != null &&
      //       placeOrderPro.initRes!.setMenus!
      //           .any((e) => e.id?.toLowerCase() == setMenuId.toLowerCase())) {
      //     final setmenu = placeOrderPro.initRes!.setMenus!.firstWhere(
      //         (e) => e.id?.toLowerCase() == setMenuId.toLowerCase());

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

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        setMenuList.isEmpty
            ? NoItemsSec(size: size, title: "No Combo Items Found")
            : GridView.builder(
                shrinkWrap: true,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  mainAxisExtent:
                      size.getH(Responsive.isDesktop(context) ? 224 : 196),
                  crossAxisCount: size.isProt ? 3 : 4,
                  crossAxisSpacing: size.getW(2),
                  mainAxisSpacing: size.getH(4),
                ),
                itemCount: setMenuList.length,
                itemBuilder: (context, i) {
                  return SizedBox(
                    height: size.getH(220),
                    width: size.getW(190),
                    child: ItemTile(
                      name: setMenuList[i].name ?? '',
                      imgPath: setMenuList[i].imageUrl,
                      size: size,
                      curSym: curSym,
                      price: setMenuList[i].actualPrice,
                      discountedPrice: setMenuList[i].discountedPrice,
                      disPercent: setMenuList[i].discountPercentage,
                      // hideAddBtn: true, //setMenuList[i].isSetMenu ?? true,
                      onTap: () {
                        setMenuList[i].curSym = curSym ?? '';
                        if (setMenuList[i].id != null &&
                            setMenuList[i].id!.isNotEmpty)
                          onSelectSetMenu(context,
                              setMenuId: setMenuList[i].id!);
                      },
                    ),
                  );
                },
              ),
        // Wrap(
        //   spacing: size.getW(2),
        //   runSpacing: size.getH(4),
        //   children: List.generate(
        //     setMenuList.length,
        //     (i) {
        //       return SizedBox(
        //         height: size.getH(220),
        //         width: size.getW(size.isProt ? 188 : 190),
        //         child: ItemTile(
        //           name: setMenuList[i].name ?? '',
        //           imgPath: setMenuList[i].imageUrl,
        //           size: size,
        //           curSym: curSym,
        //           price: setMenuList[i].actualPrice,
        //           discountedPrice: setMenuList[i].discountedPrice,
        //           disPercent: setMenuList[i].discountPercentage,
        //           //  () {
        //           //   return (curSym ?? '') + (setMenuList[i].actualPrice ?? '');
        //           // },
        //           hideAddBtn: true, //setMenuList[i].isSetMenu ?? true,
        //           onTap: () {
        //             setMenuList[i].curSym = curSym ?? '';
        //             if (setMenuList[i].id != null &&
        //                 setMenuList[i].id!.isNotEmpty)
        //               onSelectSetMenu(context, setMenuId: setMenuList[i].id!);
        //           },
        //         ),
        //       );
        //     },
        //   ),
        // ),
        SizedBox(
          height: size.getH(16),
        )
        // GridView.count(
        //   shrinkWrap: true,
        //   physics: NeverScrollableScrollPhysics(),
        //   crossAxisCount: Responsive.isMobile(context)
        //       ? 4
        //       : Responsive.isMobileLarge(context)
        //           ? 5
        //           : (size.isProt &&
        //                   (Responsive.isTablet(context) ||
        //                       Responsive.isTabletLarge(context)))
        //               ? 6
        //               : (Responsive.isTablet(context) ||
        //                       Responsive.isTabletLarge(context))
        //                   ? 5
        //                   : 6,
        //   mainAxisSpacing: size.getW(10),
        //   childAspectRatio: 0.9,
        //   padding: EdgeInsets.only(top: size.getH(12), bottom: size.getH(24)),
        //   children: List.generate(
        //     setMenuList.length,
        //     (i) {
        //       return ItemTile(
        //         pName: setMenuList[i].setMenuName ?? '',
        //         imgPath: null,
        //         size: size,
        //         price: () {
        //           return (curSym ?? '') + (setMenuList[i].setMenuPrice ?? '');
        //         },
        //         isSetMenu: setMenuList[i].isSetMenu ?? true,
        //         onTap: () {
        //           onSelectSetMenu(context, setMenu: setMenuList[i]);
        //         },
        //       );
        //     },
        //   ),
        // ),
      ],
    );
  }
}

class SetMenuDialog extends StatefulWidget {
  final String setMenuId;
  final int? upIndex;
  const SetMenuDialog({
    super.key,
    required this.setMenuId,
    this.upIndex,
  });

  @override
  State<SetMenuDialog> createState() => _SetMenuDialogState();
}

class _SetMenuDialogState extends State<SetMenuDialog> {
  Future<void> removeItem(
    BuildContext context, {
    required FeaturedProduct product,
    required PlaceOrderPro placeOrderPro,
  }) async {
    bool? status = true;
    if (placeOrderPro.reOrder != null &&
        (product.updateId?.isNotEmpty ?? false)) {
      status = false;
      await showDialog(
        context: context,
        builder: (_) => ConfirmDialog(
          title: "${LN.cancel} '${product.name ?? ''}'?",
          titleSize: 18,
          subTitle: "Are you sure to cancel ${product.name ?? ''} ?",
          actionText: LN.cancel,
          cancelText: LN.no,
          onDelete: () async {
            // print(
            //     "pId: ${product.id},\n pUID: ${product.updateId},\n listp ID: ${placeOrderPro.setMenuList[upIndex!].orderItemsViewModels!.first.id}\n list pvID: ${placeOrderPro.setMenuList[upIndex!].orderItemsViewModels!.first.productVariationId}");

            if (placeOrderPro.reOrder?.orderId != null) {
              if (widget.upIndex != null) {
                final itemList = placeOrderPro
                    .setMenuList[widget.upIndex!].orderItemsViewModels!
                    .where((e) =>
                        e.productVariationId?.toLowerCase() ==
                        product.id?.toLowerCase());
                for (final f in itemList) {
                  f.isCancelled = true;
                }
              }

              final idList = product.tempComboProduct
                  ?.map((f) => f?.updateId ?? '')
                  .toList();

              if (idList != null)
                status = await placeOrderPro.cancelPlaceOrderItem(
                  context,
                  orderId: placeOrderPro.reOrder!.orderId!,
                  type: ItemCancelType.setmenu,
                  itemIds: idList,
                  setmenuId: [],
                );
            }
            return status;
          },
          onCancel: () {
            status = false;
            Navigator.pop(context);
          },
        ),
      );
    }

    if (status ?? false) {
      product.isSelected = false;
      product.tempComboProduct = null;
      placeOrderPro.selectedSetMenuProduct = null;
      placeOrderPro.notify;
    }
  }

  @override
  void initState() {
    _getData();
    super.initState();
  }

  late PlaceOrderPro _placePro;

  Future<void> _getData() async {
    _placePro = Provider.of<PlaceOrderPro>(context, listen: false);
    await _placePro.getComboDetailById(id: widget.setMenuId);

    setData();
    _placePro.setRetailCombo(GlobalCVP.isRetailStore);
  }

  void setData() {
    if (widget.upIndex == null) return;

    final setmenuDetail = _placePro.setMenuList[widget.upIndex!];

    final setMenu = _placePro.comboDetailById;

    if (setMenu == null) return;

    _placePro.selectedSetMenuProduct?.tempComboProduct = null;
    _placePro.selectedSetMenuProduct = null;
    setMenu.quantity = setmenuDetail.setMenuQuantity ?? 1;
    if (setmenuDetail.orderItemsViewModels != null)
    // for (var a in setmenuDetail.orderItemsViewModels!) {

    //
    if (setMenu.setMenuProductListViewModelWithCategory != null)
      for (var b in setMenu.setMenuProductListViewModelWithCategory!) {
        //
        b.setMenuProductListViewModels
            ?.forEach((m) => m.tempComboProduct = null);

        for (var a in setmenuDetail.orderItemsViewModels!) {
          if (b.setMenuProductListViewModels != null &&
              b.setMenuProductListViewModels!.any((c) =>
                  c.id?.toLowerCase() == a.productVariationId?.toLowerCase())) {
            final product = b.setMenuProductListViewModels!.firstWhere((c) =>
                c.id?.toLowerCase() == a.productVariationId?.toLowerCase());

            product.isSelected = true;
            product.updateId = a.id;

            // placeOrderPro.selectedSetMenuProduct = _product;
            product.productVariationModifiers?.forEach((d) {
              d.modifierItems?.forEach((g) {
                // print("new setmenu :: ${d.toJson()}");
                if (a.orderItemsPriceModifierViewModels?.any((e) =>
                        e.priceVariationModifierId?.toLowerCase() ==
                        g.id?.toLowerCase()) ??
                    false) {
                  final _exiModifier = a.orderItemsPriceModifierViewModels
                      ?.firstWhere((e) =>
                          e.priceVariationModifierId?.toLowerCase() ==
                          g.id?.toLowerCase());

                  // print(
                  //     "old setmenu ${_exiModifier?.modifierName} ${_exiModifier?.isActive}");

                  g.updateId = _exiModifier?.id ?? '';
                  g.isActive = _exiModifier?.isActive;
                  g.quantity = setMenu.quantity.toDouble();
                  // d.id = _exiModifier?.priceVariationModifierId; //TODO: may need or not
                }
              });
            });
            product.productIngredients?.forEach((f) {
              if (a.removedOrderItemsIngredientsViewModels?.any(
                      (g) => g.name?.toLowerCase() == f.name?.toLowerCase()) ??
                  false) {
                final exiIgre = a.removedOrderItemsIngredientsViewModels
                    ?.firstWhere(
                        (g) => g.name?.toLowerCase() == f.name?.toLowerCase());

                f.isActive = exiIgre?.isActive ?? false;
                f.id = exiIgre?.id;
              }
            });

            product.tempComboProduct ??= [];

            final tempProd = FeaturedProduct.fromJson(product.toJson())
              ..quantity = double.tryParse(a.quantity ?? '1') ?? 1
              ..isSelected = true
              ..updateId = a.id;

            tempProd.productVariationModifiers?.forEach((d) {
              d.modifierItems?.forEach((f) {
                if (a.orderItemsPriceModifierViewModels?.any((e) =>
                        e.priceVariationModifierId?.toLowerCase() ==
                        f.id?.toLowerCase()) ??
                    false) {
                  final _exiModifier = a.orderItemsPriceModifierViewModels
                      ?.firstWhere((e) =>
                          e.priceVariationModifierId?.toLowerCase() ==
                          f.id?.toLowerCase());

                  f.updateId = _exiModifier?.id ?? '';
                  f.isActive = _exiModifier?.isActive;
                  f.quantity = setMenu.quantity.toDouble();
                }
              });
            });

            tempProd.productIngredients?.forEach((f) {
              if (a.removedOrderItemsIngredientsViewModels?.any(
                      (g) => g.name?.toLowerCase() == f.name?.toLowerCase()) ??
                  false) {
                final exiIgre = a.removedOrderItemsIngredientsViewModels
                    ?.firstWhere(
                        (g) => g.name?.toLowerCase() == f.name?.toLowerCase());

                f.isActive = exiIgre?.isActive ?? false;
                f.id = exiIgre?.id;
              }
            });

            product.tempComboProduct!.add(tempProd);

            product.quantity = product.tempComboProduct
                    ?.fold<double>(0.0, (pV, nV) => pV + (nV?.quantity ?? 0)) ??
                0;
            // (_product.tempComboProduct?.length ?? 1).toDouble();
          }
        }
      }
  }

  double _getTotalAmount(ComboDetailById? setMenu) {
    if (setMenu == null) return 0.0;

    final _setMenuPrice = (setMenu.discountedPrice?.inDouble ?? 0) > 0 ||
            (setMenu.discountPercentage?.inDouble ?? 0) > 99
        ? setMenu.discountedPrice.inDouble
        : setMenu.actualPrice.inDouble;

    return ((setMenu.quantity * _setMenuPrice) +
        (setMenu.setMenuProductListViewModelWithCategory?.fold<double>(
                0,
                (pV1, e1) =>
                    pV1 +
                    (e1.setMenuProductListViewModels?.fold<double>(
                            0,
                            (pV4, e4) =>
                                pV4 +
                                (e4.tempComboProduct?.fold<double>(
                                        0,
                                        (pV2, e2) =>
                                            pV2 +
                                            ((e2 == null || !e2.isSelected)
                                                ? 0
                                                : (e2.productVariationModifiers?.fold<double>(
                                                        0,
                                                        (pV3, e3) =>
                                                            pV3 +
                                                            (e3.modifierItems?.fold<
                                                                        double>(
                                                                    0,
                                                                    (pv4, e4) =>
                                                                        pv4 +
                                                                        (((e4.isActive ?? false) ? e4.quantity : 0) * (e4.discountedPrice.inDouble > 0 ? e4.discountedPrice.inDouble : e4.actualPrice.inDouble))) ??
                                                                0)) ??
                                                    0))) ??
                                    0)) ??
                        0)) ??
            0));
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = Ssize(context);
    final placeOrderPro = Provider.of<PlaceOrderPro>(context);
    final setMenu = placeOrderPro.comboDetailById;

    if (placeOrderPro.loading)
      return SizedBox(height: size.getH(50), child: Loading());
    else
      return Container(
        constraints: BoxConstraints(
          maxHeight: size.height / 1.155,
          minHeight: size.height / 4,
        ),
        width: size.width / 1.15,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  setMenu?.setMenuName ?? "",
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
                            fontSize: size.getS(24), color: Colors.white))

                    // )s
                    ),
              ],
            ),
            SizedBox(
              height: size.getH(8),
            ),
            Flexible(
              child: LayoutBuilder(builder: (context, contr) {
                // final _listWidth =
                //     placeOrderPro.selectedSetMenuProduct != null
                //         ? contr.maxWidth * 2 / 3
                //         : contr.maxWidth;
                // final _detailWidth = contr.maxWidth * 1 / 3;
                return Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Flexible(
                      flex: 2,
                      // width: _listWidth,
                      child: Card(
                        child: SizedBox(
                          height: double.maxFinite,
                          child: SingleChildScrollView(
                            padding: EdgeInsets.zero,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Card(
                                //   child: Padding(
                                //     padding: EdgeInsets.symmetric(
                                //         vertical: size.getH(8.0),
                                //         horizontal: size.getW(12)),
                                //     child: Column(
                                //       crossAxisAlignment: CrossAxisAlignment.start,
                                //       children: [
                                //         Text(
                                //           LN.categories,
                                //           style: TextStyle(
                                //             fontSize: size.getS(18),
                                //             fontFamily: kFontFMedium,
                                //             // fontWeight: FontWeight.bold,
                                //             color: Colors.black,
                                //           ),
                                //         ),
                                //         SizedBox(
                                //           height: size.getH(12),
                                //         ),
                                //         GridView.count(
                                //           crossAxisCount: size.isProt ? 3 : 4,
                                //           childAspectRatio: 7,
                                //           shrinkWrap: true,
                                //           physics: NeverScrollableScrollPhysics(),
                                //           mainAxisSpacing: size.getW(20),
                                //           crossAxisSpacing: size.getH(10),
                                //           children: [
                                //             if (setMenu
                                //                     ?.setMenuProductListViewModelWithCategory !=
                                //                 null)
                                //               ...List.generate(
                                //                   setMenu!
                                //                       .setMenuProductListViewModelWithCategory!
                                //                       .length, (i) {
                                //                 final _setMenuCat = setMenu
                                //                     .setMenuProductListViewModelWithCategory![i];
                                //                 return CheckBoxSection(
                                //                   size: size,
                                //                   checked: true,
                                //                   title: _setMenuCat.categoryName ??
                                //                       "",
                                //                   fillColor: Colors.green.shade800,
                                //                   // onChanged: (p0) {},
                                //                 );
                                //               })
                                //           ],
                                //         ),
                                //         SizedBox(
                                //           height: size.getH(12),
                                //         ),
                                //       ],
                                //     ),
                                //   ),
                                // ),
                                // SizedBox(
                                //   height: size.getH(16),
                                // ),
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                      vertical: size.getH(8.0),
                                      horizontal: size.getW(8)),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      if (setMenu
                                              ?.setMenuProductListViewModelWithCategory !=
                                          null)
                                        ...List.generate(
                                            setMenu!
                                                .setMenuProductListViewModelWithCategory!
                                                .length,
                                            (i) => Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text.rich(TextSpan(
                                                        text:
                                                            "${setMenu.setMenuProductListViewModelWithCategory![i].categoryName}",
                                                        style: TextStyle(
                                                          fontSize:
                                                              size.getS(16),
                                                          fontFamily:
                                                              kFontFMedium,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color: Colors.black,
                                                        ),
                                                        children: [
                                                          if (setMenu
                                                                      .setMenuProductListViewModelWithCategory![
                                                                          i]
                                                                      .categoryDescription !=
                                                                  null &&
                                                              setMenu
                                                                  .setMenuProductListViewModelWithCategory![
                                                                      i]
                                                                  .categoryDescription!
                                                                  .isNotEmpty)
                                                            TextSpan(
                                                              text:
                                                                  " (${setMenu.setMenuProductListViewModelWithCategory![i].categoryDescription})",
                                                              style: TextStyle(
                                                                fontSize: size
                                                                    .getS(16),
                                                                fontFamily:
                                                                    kFontFMedium,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .normal,
                                                                color:
                                                                    kSecondaryColor,
                                                              ),
                                                            )
                                                        ])),
                                                    if (setMenu
                                                            .setMenuProductListViewModelWithCategory![
                                                                i]
                                                            .maxItemCount
                                                            ?.isNotEmpty ??
                                                        false)
                                                      Text(
                                                        "Max count: ${setMenu.setMenuProductListViewModelWithCategory![i].maxItemCount}",
                                                        style: TextStyle(
                                                          fontSize:
                                                              size.getS(15),
                                                          fontFamily:
                                                              kFontFMedium,
                                                          fontWeight:
                                                              FontWeight.normal,
                                                          color:
                                                              kSecondaryColor,
                                                        ),
                                                      ),
                                                    SizedBox(
                                                      height: size.getH(8),
                                                    ),
                                                    GridView.count(
                                                      crossAxisCount: 4,
                                                      childAspectRatio: 1.15,
                                                      shrinkWrap: true,
                                                      physics:
                                                          NeverScrollableScrollPhysics(),
                                                      mainAxisSpacing:
                                                          size.getW(12),
                                                      crossAxisSpacing:
                                                          size.getH(12),
                                                      children: [
                                                        ...List.generate(
                                                            setMenu
                                                                .setMenuProductListViewModelWithCategory![
                                                                    i]
                                                                .setMenuProductListViewModels!
                                                                .length, (j) {
                                                          final product = setMenu
                                                              .setMenuProductListViewModelWithCategory![
                                                                  i]
                                                              .setMenuProductListViewModels![j];
                                                          final _selectCount = setMenu
                                                                  .setMenuProductListViewModelWithCategory?[
                                                                      i]
                                                                  .setMenuProductListViewModels
                                                                  ?.where((e) => e
                                                                      .isSelected)
                                                                  .toList()
                                                                  .fold<double>(
                                                                      0,
                                                                      (pV, ele) =>
                                                                          pV +
                                                                          ele.quantity) ??
                                                              0;
                                                          final _maxCount =
                                                              double.tryParse(setMenu
                                                                          .setMenuProductListViewModelWithCategory?[
                                                                              i]
                                                                          .maxItemCount ??
                                                                      '') ??
                                                                  0;

                                                          return Stack(
                                                            alignment: Alignment
                                                                .topRight,
                                                            children: [
                                                              Card(
                                                                elevation: 6,
                                                                // color:
                                                                //     kBackgroundColor,
                                                                shape:
                                                                    RoundedRectangleBorder(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              10),
                                                                  side:
                                                                      BorderSide(
                                                                    color:
                                                                        // product
                                                                        //         .isSelected
                                                                        //     ? kTempColor
                                                                        //     :
                                                                        Colors
                                                                            .transparent,
                                                                  ),
                                                                ),
                                                                child: InkWell(
                                                                  onTap: () {
                                                                    _onTabItem(
                                                                        _maxCount,
                                                                        _selectCount,
                                                                        product,
                                                                        placeOrderPro,
                                                                        i);
                                                                  },
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              10),
                                                                  highlightColor:
                                                                      kSecondaryColor
                                                                          .withOpacity(
                                                                              0.3),
                                                                  child:
                                                                      Container(
                                                                    width: double
                                                                        .infinity,
                                                                    padding: EdgeInsets.symmetric(
                                                                        vertical:
                                                                            size.getH(
                                                                                4.0),
                                                                        horizontal:
                                                                            size.getW(12)),
                                                                    child:
                                                                        Column(
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .center,
                                                                      children: [
                                                                        Expanded(
                                                                          child:
                                                                              NetworkImageSec(
                                                                            image:
                                                                                product.imageUrl,
                                                                            height: size.isProt
                                                                                ? 84
                                                                                : 96,
                                                                          ),
                                                                        ),
                                                                        SizedBox(
                                                                          height:
                                                                              size.getH(4),
                                                                        ),
                                                                        SizedBox(
                                                                          height:
                                                                              size.getH(48),
                                                                          child: Text(
                                                                              (product.name ?? '') + (product.productVariationName != null && product.productVariationName!.trim().isNotEmpty ? '(${product.productVariationName})' : ''),
                                                                              style: TextStyle(
                                                                                fontSize: size.getW(16),
                                                                                color: Colors.black,
                                                                                fontFamily: kFontFMedium,
                                                                              ),
                                                                              maxLines: 2,
                                                                              textAlign: TextAlign.center,
                                                                              overflow: TextOverflow.ellipsis),
                                                                        ),
                                                                        if (!GlobalCVP
                                                                            .isRetailStore)
                                                                          Row(
                                                                            mainAxisAlignment:
                                                                                MainAxisAlignment.center,
                                                                            children: [
                                                                              if (product.isSelected)
                                                                                Flexible(
                                                                                  child: SizedBox(
                                                                                    height: size.getH(36),
                                                                                    child: product.isSelected
                                                                                        ? Padding(
                                                                                            padding: EdgeInsets.only(bottom: size.getH(4)),
                                                                                            child: LoadButton(
                                                                                              vPad: 2,
                                                                                              hPad: 4,
                                                                                              btnColor: Colors.red.shade700,
                                                                                              textColor: Colors.white,
                                                                                              width: 80,
                                                                                              fontSize: 14,
                                                                                              btnText: "Remove",
                                                                                              onsave: () => removeItem(context, product: product, placeOrderPro: placeOrderPro),
                                                                                            ),
                                                                                          )
                                                                                        : SizedBox.shrink(),
                                                                                  ),
                                                                                ),
                                                                              if (product.isSelected && GlobalCVP.viewWidget.viewComboItemHalfButton)
                                                                                SizedBox(
                                                                                  width: size.getW(8),
                                                                                ),
                                                                              if (!product.isSelected && GlobalCVP.viewWidget.viewComboItemHalfButton)
                                                                                Flexible(
                                                                                  child: SizedBox(
                                                                                    height: size.getH(36),
                                                                                    child: LoadButton(
                                                                                      vPad: 2,
                                                                                      hPad: 4,
                                                                                      width: 90,
                                                                                      btnText: "Add Half",
                                                                                      fontSize: 14,
                                                                                      onsave: () {
                                                                                        // final _remainingCount = _maxCount - _selectCount;

                                                                                        _onTabItem(
                                                                                          _maxCount,
                                                                                          _selectCount,
                                                                                          product,
                                                                                          placeOrderPro,
                                                                                          i,
                                                                                          quantity: 0.5,
                                                                                        );

                                                                                        // if (_remainingCount == 0.5) {
                                                                                        //   product.quantity += 0.5;
                                                                                        //   product.tempComboProduct!.add(FeaturedProduct.fromJson(product.toJson())
                                                                                        //     ..isSelected = true
                                                                                        //     ..quantity = 0.5);

                                                                                        //   placeOrderPro.notify;
                                                                                        // }
                                                                                      },
                                                                                    ),
                                                                                  ),
                                                                                )
                                                                              else
                                                                                Flexible(child: SizedBox(height: size.getH(36)))
                                                                            ],
                                                                          )
                                                                      ],
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                              SizedBox(
                                                                height: size
                                                                    .getH(70),
                                                                child:
                                                                    FittedBox(
                                                                  child:
                                                                      IgnorePointer(
                                                                    ignoring:
                                                                        true,
                                                                    child:
                                                                        Checkbox(
                                                                      value: product
                                                                          .isSelected,
                                                                      activeColor:
                                                                          kSecondaryColor,
                                                                      // fillColor:
                                                                      //     MaterialStateProperty.all(
                                                                      //         kSecondaryColor),
                                                                      onChanged:
                                                                          (_) {},
                                                                      side: BorderSide(
                                                                          width:
                                                                              0.1),
                                                                      visualDensity:
                                                                          VisualDensity
                                                                              .compact,
                                                                      shape:
                                                                          RoundedRectangleBorder(
                                                                        borderRadius:
                                                                            BorderRadius.circular(100),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ),
                                                              )
                                                            ],
                                                          );
                                                        })
                                                      ],
                                                    ),
                                                    SizedBox(
                                                      height: size.getH(16),
                                                    )
                                                  ],
                                                ))
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    if (setMenu != null)
                      Flexible(
                          flex: 1,
                          // width: _detailWidth,
                          child: GlobalCVP.isRetailStore
                              ? ComboRetailItems(placePro: placeOrderPro)
                              : ComboItemDetail(
                                  placeOrderPro: placeOrderPro,
                                  setMenu: setMenu,
                                ))
                  ],
                );
              }),
            ),
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
                              if ((setMenu?.discountPercentage?.inDouble ??
                                      0) !=
                                  0)
                                TextSpan(
                                  text:
                                      "${placeOrderPro.curSym ?? ''}${setMenu?.discountedPrice ?? '0.00'} ",
                                  style: TextStyle(
                                    decoration: TextDecoration.none,
                                    overflow: TextOverflow.visible,
                                  ),
                                ),
                              TextSpan(
                                text:
                                    "${placeOrderPro.curSym ?? ''}${setMenu?.actualPrice ?? '0.00'}",
                                style: (setMenu?.discountPercentage?.inDouble ??
                                            0) !=
                                        0
                                    ? TextStyle(
                                        decoration: TextDecoration.lineThrough,
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
                        if ((setMenu?.discountPercentage?.inDouble ?? 0) != 0)
                          Container(
                            margin:
                                EdgeInsets.symmetric(horizontal: size.getW(8)),
                            decoration: BoxDecoration(
                              color: Colors.red.shade800,
                              // shape: BoxShape.circle,
                              borderRadius: BorderRadius.circular(5),
                            ),
                            padding: EdgeInsets.symmetric(
                                vertical: size.getS(6),
                                horizontal: size.getS(8)),
                            child: Text(
                              "${setMenu?.discountPercentage?.inQty}% OFF",
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
                        QuantitySection(
                          quantity: setMenu?.quantity.toDouble() ?? 1,
                          size: size,
                          fr: 1.2,
                          update: (p0) {
                            if (p0 == null) return;

                            if (p0)
                              setMenu!.quantity++;
                            else {
                              if (setMenu!.quantity < 2) return;
                              setMenu.quantity--;
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
                              placeOrderPro.removeSetmenu(widget.upIndex!);
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
                            onPressed: () {
                              placeOrderPro.updateSetMenuOnCart(
                                upIndex: widget.upIndex,
                              );
                              if (setMenu == null) return;

                              if (setMenu.setMenuProductListViewModelWithCategory !=
                                      null &&
                                  setMenu
                                      .setMenuProductListViewModelWithCategory!
                                      .any((f) =>
                                          f.setMenuProductListViewModels !=
                                              null &&
                                          f.setMenuProductListViewModels!
                                              .any((g) => g.isSelected))) {
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
                            },
                            sideColor: kSecondaryColor,
                            backColor:
                                MaterialStateProperty.all(kSecondaryColor),
                            title: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.shopping_cart_outlined,
                                    size: size.getS(24)),
                                SizedBox(width: size.getW(12)),
                                Text(
                                  "${widget.upIndex != null ? LN.update : LN.addToCart} - ${placeOrderPro.curSym}${_getTotalAmount(setMenu).roundToNString()}",
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
          ],
        ),
      );
  }

  void _onTabItem(
    double maxCount,
    double selectCount,
    FeaturedProduct product,
    PlaceOrderPro placeOrderPro,
    int i, {
    double? quantity,
  }) {
    final remainingCount = maxCount - selectCount;
    if (maxCount != 0 &&
        selectCount != 0 &&
        selectCount >= maxCount &&
        !product.isSelected) {
      showToast("Maximum selected item count is ${maxCount.round()}");

      return;
    }

    product.selectedItemQtyIndex = 0;

    if (!product.isSelected) {
      product.quantity = quantity ?? (remainingCount == 0.5 ? 0.5 : 1);
      product
        ..productVariationModifiers?.forEach(
            (v) => v.modifierItems?.forEach((w) => w.isActive = false))
        ..productIngredients?.forEach((u) => u.isActive = false);
      product.tempComboProduct = [
        FeaturedProduct.fromJson(product.toJson())
          ..isSelected = true
          ..quantity = product.quantity,
      ];
    } else {
      // product.tempComboProduct = List.generate(
      //     product
      //         .quantity
      //         .round(),
      //     (_) => FeaturedProduct.fromJson(
      //         product
      //             .toJson()));
    }

    product.isSelected = true;

    placeOrderPro.selectedSetMenuProduct = null;
    placeOrderPro.notify;

    Future.delayed(Duration(milliseconds: 400), () {
      // if (placeOrderPro
      //             .selectedSetMenuProduct
      //             ?.id !=
      //         product
      //             .id &&
      //     product
      //         .isSelected) {
      placeOrderPro.selectedSetMenuProduct = product;
      placeOrderPro.selectedSetMenuProduct?.maxSelectCount = maxCount;
      placeOrderPro.selectedSetMenuProduct?.selectedComboCatIndex = i;
      // }
      placeOrderPro.notify;
    });
  }
}
