// import 'package:flutter/material.dart';
// import 'package:oktoast/oktoast.dart';
// import 'package:pos_account/config/size_config.dart';
// import 'package:pos_account/config/utils.dart';
// import 'package:pos_account/ln.dart';
// import 'package:pos_account/providers/menu/place_order_pro.dart';
// import 'package:pos_account/providers/menu/pos_retail_pro.dart';
// import 'package:pos_account/screens/home_screen/com/items/tabs/pos_tab/pos_non_retail/com/item_tile.dart';
// import 'package:pos_account/widgets/input/dropdown/drop_down.dart';
// import 'package:pos_account/widgets/input/text_form/text_form_widget.dart';
// import 'package:pos_account/widgets/loading.dart';
// import 'package:pos_account/widgets/message_widgets/trial_expire.dart';
// import 'package:pos_account/widgets/no_items_sec.dart';
// import 'package:provider/provider.dart';
// import 'package:pull_to_refresh/pull_to_refresh.dart';

// import '../../../../../../../../constant/constant.dart';
// import '../../../../../../../../model/home/menu/place_order/pos_res/com/feature_product.dart';
// import '../../../../../../../../providers/cus_val_pro.dart';
// import '../../../../../../../../widgets/refresh_btn.dart';
// import '../../../../sidebar/order_section/com/pay_method/com/cash_drawer_button.dart';
// import '../../variance_3/variance_3.dart';

// class RetailProductTab extends StatefulWidget {
//   final Function()? onTapSubs;
//   final bool isOnPos;
//   final PlaceOrderPro? placeOrderPro;
//   const RetailProductTab({
//     Key? key,
//     this.onTapSubs,
//     this.placeOrderPro,
//     this.isOnPos = true,
//   }) : super(key: key);

//   @override
//   State<RetailProductTab> createState() => _RetailProductTabState();
// }

// class _RetailProductTabState extends State<RetailProductTab> {
//   @override
//   void initState() {
//     setUp();
//     super.initState();
//   }

//   PosRetailPro? _posPro;

//   void setUp() {
//     _posPro = Provider.of<PosRetailPro>(context, listen: false);
//     _posPro?.placeOrderPro = widget.placeOrderPro;
//     _posPro?.posRetailPro = _posPro;
//     _posPro?.init(isOnPos: widget.isOnPos);
//     _posPro?.getData();
//   }

//   final RefreshController _refreshController =
//       RefreshController(initialRefresh: false);

//   final _scrollController = ScrollController();

//   @override
//   void dispose() {
//     // _posPro?.clear();
//     _scrollController.dispose();
//     _refreshController.dispose();

//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final size = Ssize(context);
//     final posPro = Provider.of<PosRetailPro>(context);
//     return Processing(
//       // loading: posPro.pageLoad,
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           if (widget.onTapSubs != null) ...[
//             SizedBox(
//               height: size.getH(8),
//             ),
//             TrialExpiryMsg(
//                 size: size,
//                 show: posPro.retailPosOrderRes?.message?.isNotEmpty ?? false,
//                 message: posPro.retailPosOrderRes?.message ?? '',
//                 btnText:
//                     (posPro.retailPosOrderRes?.isSubscriptionActive ?? false)
//                         ? LN.changePlan
//                         : LN.subsNow,
//                 onTap: widget.onTapSubs)
//           ],
//           if (!(posPro.retailPosOrderRes?.message?.isNotEmpty ?? false)) ...[
//             Row(
//               children: [
//                 // if (GlobalCVP.DontShowLeftSide)
//                 //   SizedBox(width: size.getW(148), child: AllOrderButton()),
//                 SizedBox(
//                   width: size.getW(180),
//                   child: DropDownList(
//                     hint: LN.brand,
//                     isReq: false,
//                     vPad: 10,
//                     borderColor: Colors.black12,
//                     indexValue: posPro.brandIndex,
//                     list: posPro.retailPosOrderRes?.brands == null
//                         ? []
//                         : posPro.retailPosOrderRes!.brands!
//                             .map((e) => e.name ?? '')
//                             .toList(),
//                     onChange: (p0) {
//                       posPro.brandIndex = p0;
//                       posPro.notify;
//                       posPro.getItemData(page: 1);
//                     },
//                   ),
//                 ),
//                 SizedBox(width: size.getW(12)),
//                 Flexible(
//                   child: TextFormWidget(
//                     isReq: false,
//                     vPad: 10,
//                     prefixIcon: Icon(
//                       Icons.search,
//                       size: size.getS(32),
//                     ),
//                     borderRadius: 5,
//                     borderColor: Colors.black12,
//                     cltr: posPro.searchCltr,
//                     hintText: LN.search,
//                     onChanged: (p0) {
//                       if (p0 == null) return;

//                       Utils.handleSearch(callback: () async {
//                         posPro.getItemData(page: 1);
//                       });
//                     },
//                     suffixIcon: posPro.searchCltr.text.isEmpty
//                         ? null
//                         : InkWell(
//                             onTap: () {
//                               posPro.searchCltr.clear();
//                               Utils.handleSearch(callback: () async {
//                                 posPro.getItemData(page: 1);
//                               });
//                             },
//                             child: Icon(
//                               Icons.close,
//                               size: size.getS(28),
//                               color: Colors.black,
//                             ),
//                           ),
//                   ),
//                 ),
//                 SizedBox(width: size.getW(12)),
//                 if (GlobalCVP.viewWidget.viewCashRegisterButton)
//                   CashDrawerButton(),
//                 if (GlobalCVP.viewWidget.viewProductRefreshButton)
//                   Padding(
//                     padding: EdgeInsets.only(left: size.getW(12)),
//                     child: RefreshBtn(
//                       size: size,
//                       onTap: () async {
//                         posPro.pageLoad = true;
//                         posPro.notify;
//                         posPro.selectedCatId = "";
//                         posPro.brandIndex = null;
//                         posPro.alphaId = "";
//                         posPro.placeOrderPro?.alphaId = null;
//                         posPro.placeOrderPro?.searchCltr.clear();
//                         posPro.placeOrderPro?.selectedCatId = "";
//                         posPro.searchCltr.clear();
//                         posPro.getData();
//                       },
//                     ),
//                   ),
//               ],
//             ),
//             if (posPro.pageLoad) LinearProgressIndicator(),
//             if (posPro.retailPosOrderRes?.alphabets?.isNotEmpty ?? false)
//               SizedBox(
//                 height: size.getH(48),
//                 child: Align(
//                   alignment: Alignment.center,
//                   child: ListView.builder(
//                       scrollDirection: Axis.horizontal,
//                       itemBuilder: (context, index) {
//                         return Padding(
//                           padding: EdgeInsets.symmetric(
//                               horizontal: size.getW(4), vertical: size.getH(4)),
//                           child: InkWell(
//                             onTap: () {
//                               posPro.pageLoad = true;
//                               posPro.notify;
//                               posPro.alphaId = posPro.retailPosOrderRes
//                                       ?.alphabets?[index].name ??
//                                   '';
//                               posPro.placeOrderPro?.alphaId = posPro
//                                   .retailPosOrderRes?.alphabets?[index].id;
//                               posPro.notify;
//                               posPro.getItemData(
//                                 page: 1,
//                               );
//                             },
//                             child: Container(
//                               padding: EdgeInsets.symmetric(
//                                   horizontal: size.getW(18),
//                                   vertical: size.getH(0)),
//                               decoration: BoxDecoration(
//                                 color: posPro.alphaId ==
//                                         posPro.retailPosOrderRes
//                                             ?.alphabets?[index].name
//                                     ? kUserColor
//                                     : Colors.white,
//                                 borderRadius: BorderRadius.circular(8),
//                               ),
//                               child: Center(
//                                 child: Text(
//                                   posPro.retailPosOrderRes?.alphabets?[index]
//                                           .name ??
//                                       '',
//                                   style: TextStyle(
//                                     color: posPro.alphaId ==
//                                             posPro.retailPosOrderRes
//                                                 ?.alphabets?[index].name
//                                         ? Colors.white
//                                         : kPrimaryColor,
//                                     fontSize: size.getH(16),
//                                     fontFamily: kFontFMedium,
//                                   ),
//                                 ),
//                               ),
//                             ),
//                           ),
//                         );
//                       },
//                       itemCount:
//                           posPro.retailPosOrderRes?.alphabets?.length ?? 0,
//                       shrinkWrap: true),
//                 ),
//               ),
//             Flexible(
//               child: Scrollbar(
//                 controller: _scrollController,
//                 isAlwaysShown: false,
//                 showTrackOnHover: true,
//                 interactive: true,
//                 thickness: 10,
//                 radius: Radius.circular(40),
//                 child: SmartRefresher(
//                   scrollController: _scrollController,
//                   enablePullUp: true,
//                   controller: _refreshController,
//                   onRefresh: () async {
//                     if (_posPro != null) {
//                       _posPro!.pageLoad = true;
//                       _posPro!.notify;
//                       _posPro!.getData();
//                     } else {
//                       widget.placeOrderPro?.loading = true;
//                       widget.placeOrderPro?.getRetailCats();
//                       widget.placeOrderPro?.getInitData();
//                     }
//                     _refreshController.refreshCompleted();
//                   },
//                   onLoading: () async {
//                     posPro.getItemData(page: posPro.pageIndex + 1);
//                     _refreshController.loadComplete();
//                   },
//                   child: ListView(
//                     controller: _scrollController,
//                     children: [
//                       SizedBox(
//                         height: size.getH(8),
//                       ),
//                       Card(
//                         child: Column(
//                           children: [
//                             if (posPro.itemViewList.isEmpty && !posPro.pageLoad)
//                               Align(
//                                 alignment: Alignment.topCenter,
//                                 child: NoItemsSec(
//                                   size: size,
//                                   title: LN.noProductFound,
//                                 ),
//                               )
//                             else
//                               // TableData(
//                               //   tableData: posPro.tableList,
//                               //   paginate: posPro.paginate,
//                               //   total:
//                               //       posPro.retailPosOrderRes?.products?.total,
//                               //   pageSize:
//                               //       posPro.pageSizeList[posPro.pageSizeIndex],
//                               //   page: posPro.pageIndex,
//                               //   sortColumnIndex: 1,
//                               //   showDeleteBtn: false,
//                               // ),
//                               GridView.builder(
//                                 physics: NeverScrollableScrollPhysics(),
//                                 shrinkWrap: true,
//                                 itemCount: posPro.itemViewList.length,
//                                 gridDelegate:
//                                     SliverGridDelegateWithFixedCrossAxisCount(
//                                   mainAxisExtent: size.getH(280),
//                                   crossAxisSpacing: size.getW(0),
//                                   mainAxisSpacing: size.getH(0),
//                                   crossAxisCount: size.isProt ? 3 : 4,
//                                 ),
//                                 itemBuilder: (context, index) {
//                                   return ItemTile(
//                                     // hideAddBtn: false,
//                                     disPercent: posPro.itemViewList[index]
//                                             .discountPercentage ??
//                                         "0",
//                                     price: posPro
//                                             .itemViewList[index].actualPrice ??
//                                         "0",
//                                     imgPath:
//                                         posPro.itemViewList[index].imageUrl ??
//                                             '',
//                                     name: posPro.itemViewList[index].name ?? '',
//                                     stockMessage: posPro.itemViewList[index]
//                                                 .stockCount ==
//                                             ""
//                                         ? null
//                                         : " ${LN.inStock}: ${posPro.itemViewList[index].stockCount}",
//                                     curSym: widget.placeOrderPro?.curSym,
//                                     addText: LN.addToCart,
//                                     // onAdd: () async {
//                                     //   final e = posPro.itemViewList[index];
//                                     //   // if (placeOrderPro == null ||
//                                     //   //     e.productDetails?.productVariations == null ||
//                                     //   //     e.productDetails!.productVariations!.isEmpty) {
//                                     //   //   showToast(LN.noProductAvai);
//                                     //   //   return;
//                                     //   // }

//                                     //   // final _prodVariations =
//                                     //   //     e.productDetails!.productVariations!.firstWhere(
//                                     //   //   (e) => e.isDefault != null && e.isDefault!,
//                                     //   //   orElse: () => e.productDetails!.productVariations!.first,
//                                     //   // );
//                                     //   if (widget.placeOrderPro == null) return;

//                                     //   final _stock =
//                                     //       double.tryParse(e.stockCount ?? '');

//                                     //   final _totalQuantity = widget
//                                     //           .placeOrderPro!.orderList
//                                     //           .any((b) {
//                                     //     return b.productId == e.productId;
//                                     //   })
//                                     //       ? widget.placeOrderPro!.orderList
//                                     //           .where((b) => b.productId == e.id)
//                                     //           .fold<double>(
//                                     //               0,
//                                     //               (x, y) =>
//                                     //                   x + (y.quantity ?? 0))
//                                     //       : 0;

//                                     //   final bool _outOfStock = _stock != null &&
//                                     //       _stock <= _totalQuantity;
//                                     //   if (_outOfStock) {
//                                     //     showToast(LN.productOutOfStock);
//                                     //   } else {
//                                     //     // if (posPro
//                                     //     //         .retailPosOrderRes
//                                     //     //         ?.storeStockDeductInformation
//                                     //     //         ?.isBatch ??
//                                     //     //     false)
//                                     //     // {
//                                     //     await posPro.getProductDetail(
//                                     //         varId: e.id);

//                                     //     if (posPro.retailProductDetail == null)
//                                     //       return;

//                                     //     if ((posPro
//                                     //                 .retailProductDetail
//                                     //                 ?.productVariations
//                                     //                 ?.isNotEmpty ??
//                                     //             false) &&
//                                     //         (posPro
//                                     //                 .retailProductDetail
//                                     //                 ?.productVariations
//                                     //                 ?.first
//                                     //                 .productVariationBatchStocks
//                                     //                 ?.isNotEmpty ??
//                                     //             false)) {
//                                     //       final _batchCount = posPro
//                                     //           .retailProductDetail!
//                                     //           .productVariations!
//                                     //           .first
//                                     //           .productVariationBatchStocks!
//                                     //           .length;

//                                     //       if (_batchCount > 1) {
//                                     //         selectVarience(
//                                     //           context,
//                                     //           catTypeId: posPro
//                                     //               .retailProductDetail
//                                     //               ?.categoryTypeId,
//                                     //           featuredProduct:
//                                     //               posPro.retailProductDetail!,
//                                     //           curSym: widget
//                                     //                   .placeOrderPro!.curSym ??
//                                     //               '',
//                                     //         );
//                                     //         return;
//                                     //       } else {
//                                     //         e.productDetails
//                                     //                 ?.productVariations =
//                                     //             posPro.retailProductDetail!
//                                     //                 .productVariations!;

//                                     //         if (e
//                                     //                 .productDetails
//                                     //                 ?.productVariations
//                                     //                 ?.isNotEmpty ??
//                                     //             false) {
//                                     //           e
//                                     //               .productDetails
//                                     //               ?.productVariations
//                                     //               ?.first
//                                     //               .productVariationBatchStocks
//                                     //               ?.first
//                                     //               .isActive = true;

//                                     //           if (Utils.outOfBatchStock(
//                                     //               selectedVariance: e
//                                     //                   .productDetails
//                                     //                   ?.productVariations
//                                     //                   ?.first)) {
//                                     //             return;
//                                     //           }
//                                     //         }
//                                     //       }
//                                     //     }
//                                     //     // }

//                                     //     widget.placeOrderPro!.updateOrderCart(
//                                     //       product: posPro.retailProductDetail ??
//                                     //           FeaturedProduct(
//                                     //             id: e.id,
//                                     //             imageUrl: e.productImage,
//                                     //             name: e.name,
//                                     //             productTax: e.salesTaxValue,
//                                     //             categoryTypeId:
//                                     //                 e.categoryTypeId,
//                                     //             // categoryId:"",
//                                     //           ),
//                                     //       variation: ProductVariation(
//                                     //         id: e.id,
//                                     //         isDefault: true,
//                                     //         // price: e.price,
//                                     //         name: e.productVariationName,
//                                     //         actualPrice: e.actualPrice,
//                                     //         unitPrice: e.actualPrice,
//                                     //         discount: e.discount,
//                                     //         stockCount: e.stockCount,
//                                     //         // productVariationBatchStocks:
//                                     //         //     (e.productDetails?.productVariations?.isNotEmpty ??
//                                     //         //             false)
//                                     //         //         ? e.productDetails?.productVariations?.first
//                                     //         //             .productVariationBatchStocks
//                                     //         //         : null,
//                                     //       ),
//                                     //     );
//                                     //     // MsgDia.show(
//                                     //     //   CUS_CTX,
//                                     //     //   headerAnimation: false,
//                                     //     //   diaType: DiaType.success,
//                                     //     //   title: LN.addCartSuccess,
//                                     //     //   autoHideSecond: 2,
//                                     //     // );
//                                     //   }
//                                     // },
//                                     onTap: () async {
//                                       final e = posPro.itemViewList[index];

//                                       if (widget.placeOrderPro == null) return;

//                                       final _stock =
//                                           double.tryParse(e.stockCount ?? '');

//                                       final _totalQuantity = widget
//                                               .placeOrderPro!.orderList
//                                               .any((b) {
//                                         return b.productId == e.productId;
//                                       })
//                                           ? widget.placeOrderPro!.orderList
//                                               .where((b) => b.productId == e.id)
//                                               .fold<double>(
//                                                   0,
//                                                   (x, y) =>
//                                                       x + (y.quantity ?? 0))
//                                           : 0;

//                                       final bool _outOfStock = _stock != null &&
//                                           _stock <= _totalQuantity;
//                                       if (_outOfStock) {
//                                         showToast(LN.productOutOfStock);
//                                         return;
//                                       }

//                                       await posPro.getProductDetail(
//                                           varId: e.id);

//                                       if (posPro.retailProductDetail == null)
//                                         return;

//                                       if (Utils.doDirectAddToCart(
//                                           product:
//                                               posPro.retailProductDetail)) {
//                                         widget.placeOrderPro!.updateOrderCart(
//                                           product: posPro.retailProductDetail ??
//                                               FeaturedProduct(
//                                                 id: e.id,
//                                                 imageUrl: e.imageUrl,
//                                                 name: e.name,
//                                                 productTax: e.salesTax,
//                                                 // categoryTypeId:
//                                                 //     e.categoryTypeId,
//                                                 // categoryId:"",
//                                               ),
//                                           variation: ProductVariation(
//                                             id: e.id,
//                                             isDefault: true,
//                                             // price: e.price,
//                                             name: e.name,
//                                             actualPrice: e.actualPrice,
//                                             unitPrice: e.actualPrice,
//                                             discount: e.discountPercentage,
//                                             stockCount: e.stockCount,
//                                             // productVariationBatchStocks:
//                                             //     (e.productDetails?.productVariations?.isNotEmpty ??
//                                             //             false)
//                                             //         ? e.productDetails?.productVariations?.first
//                                             //             .productVariationBatchStocks
//                                             //         : null,
//                                           ),
//                                         );
//                                       } else {
//                                         selectVarience(
//                                           context,
//                                           catTypeId: posPro.retailProductDetail
//                                               ?.categoryTypeId,
//                                           featuredProduct:
//                                               posPro.retailProductDetail!,
//                                           curSym:
//                                               widget.placeOrderPro!.curSym ??
//                                                   '',
//                                         );
//                                         return;
//                                       }
//                                     },
//                                     size: size,
//                                     // vName: posPro
//                                     //         .retailPosOrderRes
//                                     //         ?.products
//                                     //         ?.data?[index]
//                                     //         .productVariationName ??
//                                     //     '',
//                                   );
//                                 },
//                               ),
//                           ],
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             )
//           ],
//           SizedBox(
//             height: size.getH(24),
//           ),
//         ],
//       ),
//     );
//   }

//   static selectVarience(
//     BuildContext context, {
//     String? catTypeId,
//     FeaturedProduct? featuredProduct,
//     required String curSym,
//     PlaceOrderPro? placeOrderPro,
//   }) {
//     placeOrderPro?.productDetailView = null;
//     return showDialog(
//         context: context,
//         barrierDismissible: false,
//         builder: (builder) => SimpleDialog(
//               backgroundColor: kSecondaryColor,
//               titlePadding: EdgeInsets.zero,
//               contentPadding: EdgeInsets.zero,
//               shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(15)),
//               children: [
//                 Variance(
//                   product: featuredProduct,
//                   catTypeId: catTypeId,
//                   curSym: curSym,
//                   quantity: 1,
//                   isPosTab: true,
//                 ),
//               ],
//             ));
//   }
// }
