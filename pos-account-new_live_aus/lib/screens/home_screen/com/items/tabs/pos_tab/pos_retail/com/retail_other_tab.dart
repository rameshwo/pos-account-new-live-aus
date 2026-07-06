// import 'package:flutter/material.dart';
// import 'package:pos_account/config/size_config.dart';
// import 'package:pos_account/config/utils.dart';
// import 'package:pos_account/ln.dart';
// import 'package:pos_account/model/home/menu/place_order/pos_res/pos_cat_res.dart';
// import 'package:pos_account/providers/menu/place_order_pro.dart';
// import 'package:pos_account/screens/home_screen/com/items/tabs/pos_tab/pos_non_retail/com/raw_ingre/raw_ingre_item.dart';
// import 'package:pos_account/screens/home_screen/com/items/tabs/pos_tab/pos_non_retail/com/set_menu_item.dart';
// import 'package:pos_account/screens/home_screen/com/items/tabs/pos_tab/pos_non_retail/com/title_section.dart';
// import 'package:pos_account/widgets/input/dropdown/drop_down.dart';
// import 'package:pos_account/widgets/input/text_form/text_form_widget.dart';
// import 'package:pos_account/widgets/loading.dart';
// import 'package:pos_account/widgets/no_items_sec.dart';
// import 'package:provider/provider.dart';
// import 'package:pull_to_refresh/pull_to_refresh.dart';

// import '../../../../../../../../constant/constant.dart';
// import '../../../../../../../../providers/cus_val_pro.dart';
// import '../../../../../../../../providers/menu/pos_retail_pro.dart';
// import '../../../../../../../../widgets/refresh_btn.dart';
// import '../../../../sidebar/order_section/com/pay_method/com/cash_drawer_button.dart';

// class RetailOtherTab extends StatefulWidget {
//   final PlaceOrderPro placeOrderPro;
//   final ItemViewType itemViewType;
//   const RetailOtherTab({
//     Key? key,
//     required this.placeOrderPro,
//     required this.itemViewType,
//   }) : super(key: key);

//   @override
//   State<RetailOtherTab> createState() => _RetailOtherTabState();
// }

// class _RetailOtherTabState extends State<RetailOtherTab> {
//   final scrollCltr = ScrollController();
//   final refreshCltr = RefreshController(initialRefresh: false);

//   @override
//   void initState() {
//     super.initState();
//     // _getData();
//   }

//   // Future<void> _getData() async {
//   //   widget.placeOrderPro.itemViewType = widget.itemViewType;
//   //   widget.placeOrderPro.loading = true;
//   //   widget.placeOrderPro.selectedCatId = "";
//   //   // await widget.placeOrderPro.getRetailCats();

//   //   widget.placeOrderPro.getInitData();
//   // }

//   void paginate(int page) {
//     // widget.placeOrderPro.loading = true;
//     // widget.placeOrderPro.notify;
//     widget.placeOrderPro
//         .getInitData(
//             page: page, searchKey: widget.placeOrderPro.searchCltr.text)
//         .then((_) {
//       if (page == 1) {
//         refreshCltr.refreshCompleted();
//       } else {
//         refreshCltr.loadComplete();
//       }
//     });
//   }

//   @override
//   void dispose() {
//     WidgetsBinding.instance?.addPostFrameCallback((_) {
//       widget.placeOrderPro.searchCltr.clear();
//     });
//     scrollCltr.dispose();
//     refreshCltr.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final size = Ssize(context);
//     final placeOrderPro = widget.placeOrderPro;

//     final posPro = Provider.of<PosRetailPro>(context);

//     final _catDataList = widget.itemViewType == ItemViewType.combo
//         ? placeOrderPro.posCatRes?.comboCategories
//         : widget.itemViewType == ItemViewType.ingre
//             ? placeOrderPro.posCatRes?.rawLooseCategories
//             : <CategoryData>[];
//     final _catIndex = (_catDataList?.any((e) =>
//                 e.id?.toLowerCase() ==
//                 placeOrderPro.selectedCatId.toLowerCase()) ??
//             false)
//         ? _catDataList?.indexWhere((e) =>
//             e.id?.toLowerCase() == placeOrderPro.selectedCatId.toLowerCase())
//         : null;

//     return Processing(
//       // loading: placeOrderPro.loading,
//       child: Column(
//         children: [
//           SizedBox(
//             height: size.getH(4),
//           ),
//           Row(
//             children: [
//               SizedBox(
//                 width: size.getW(360),
//                 child: DropDownList(
//                   list: _catDataList == null
//                       ? []
//                       : _catDataList.map((e) => e.name ?? '').toList(),
//                   indexValue: _catIndex,
//                   hint: LN.chooseCategory,
//                   borderColor: Colors.black12,
//                   onChange: (p0) {
//                     if (p0 == null) return;
//                     placeOrderPro.selectedCatId = _catDataList?[p0].id ?? '';
//                     placeOrderPro.loading = true;
//                     placeOrderPro.notify;
//                     paginate(1);
//                   },
//                 ),
//               ),
//               SizedBox(width: size.getW(12)),
//               // Spacer(),
//               Flexible(
//                 child: TextFormWidget(
//                   isReq: false,
//                   prefixIcon: Icon(
//                     Icons.search,
//                     size: size.getS(24),
//                   ),
//                   textStyle: TextStyle(fontSize: size.getS(16)),
//                   borderRadius: 5,
//                   vPad: 12,
//                   borderColor: Colors.black12,
//                   cltr: placeOrderPro.searchCltr,
//                   hintText: widget.itemViewType == ItemViewType.combo
//                       ? LN.searchComboProduct
//                       : LN.searchNewIngre,
//                   onChanged: (p0) {
//                     Utils.handleSearch(callback: () async {
//                       placeOrderPro.loading = true;
//                       placeOrderPro.notify;
//                       paginate(1);
//                     });
//                   },
//                   suffixIconWidth: 40,
//                   suffixIcon: InkWell(
//                     onTap: () {
//                       placeOrderPro.searchCltr.clear();
//                       Utils.handleSearch(callback: () async {
//                         placeOrderPro.loading = true;
//                         placeOrderPro.notify;
//                         paginate(1);
//                       });
//                     },
//                     child: Icon(
//                       Icons.close,
//                       size: size.getS(24),
//                       color: Colors.black,
//                     ),
//                   ),
//                 ),
//               ),
//               SizedBox(width: size.getW(12)),
//               if (GlobalCVP.viewWidget.viewCashRegisterButton)
//                 CashDrawerButton(),
//               if (GlobalCVP.viewWidget.viewProductRefreshButton)
//                 Padding(
//                   padding: EdgeInsets.only(left: size.getW(12)),
//                   child: RefreshBtn(
//                     size: size,
//                     onTap: () async {
//                       widget.placeOrderPro.loading = true;
//                       widget.placeOrderPro.selectedCatId = "";
//                       widget.placeOrderPro.alphaId = "";
//                       widget.placeOrderPro.notify;
//                       widget.placeOrderPro.searchCltr.clear();
//                       await widget.placeOrderPro.getRetailCats();
//                       widget.placeOrderPro.getInitData();
//                     },
//                   ),
//                 ),
//             ],
//           ),
//           if (placeOrderPro.loading) LinearProgressIndicator(),
//           if (posPro.retailPosOrderRes?.alphabets?.isNotEmpty ?? false)
//             SizedBox(
//               height: size.getH(48),
//               child: Align(
//                 alignment: Alignment.center,
//                 child: ListView.builder(
//                     scrollDirection: Axis.horizontal,
//                     itemBuilder: (context, index) {
//                       return Padding(
//                         padding: EdgeInsets.symmetric(
//                             horizontal: size.getW(4), vertical: size.getH(4)),
//                         child: InkWell(
//                           onTap: () {
//                             posPro.alphaId = posPro.retailPosOrderRes
//                                     ?.alphabets?[index].name ??
//                                 '';
//                             widget.placeOrderPro.alphaId = posPro
//                                     .retailPosOrderRes
//                                     ?.alphabets?[index]
//                                     .name ??
//                                 '';
//                             widget.placeOrderPro.notify;
//                             widget.placeOrderPro.loading = true;
//                             paginate(1);
//                           },
//                           child: Container(
//                             padding: EdgeInsets.symmetric(
//                                 horizontal: size.getW(18),
//                                 vertical: size.getH(0)),
//                             decoration: BoxDecoration(
//                               color: widget.placeOrderPro.alphaId ==
//                                       posPro.retailPosOrderRes
//                                           ?.alphabets?[index].name
//                                   ? kUserColor
//                                   : Colors.white,
//                               borderRadius: BorderRadius.circular(8),
//                             ),
//                             child: Center(
//                               child: Text(
//                                 posPro.retailPosOrderRes?.alphabets?[index]
//                                         .name ??
//                                     '',
//                                 style: TextStyle(
//                                   color: widget.placeOrderPro.alphaId ==
//                                           posPro.retailPosOrderRes
//                                               ?.alphabets?[index].name
//                                       ? Colors.white
//                                       : kPrimaryColor,
//                                   fontSize: size.getH(16),
//                                   fontFamily: kFontFMedium,
//                                 ),
//                               ),
//                             ),
//                           ),
//                         ),
//                       );
//                     },
//                     itemCount: posPro.retailPosOrderRes?.alphabets?.length ?? 0,
//                     shrinkWrap: true),
//               ),
//             ),
//           TitleSection(
//             placeOrderPro: widget.placeOrderPro,
//             isRetail: true,
//           ),
//           Flexible(
//             child: Scrollbar(
//               controller: scrollCltr,
//               isAlwaysShown: false,
//               showTrackOnHover: true,
//               interactive: true,
//               thickness: 10,
//               radius: Radius.circular(40),
//               child: SmartRefresher(
//                 controller: refreshCltr,
//                 scrollController: scrollCltr,
//                 enablePullUp: true,
//                 onLoading: () {
//                   paginate(placeOrderPro.pageIndex + 1);
//                 },
//                 onRefresh: () {
//                   paginate(1);
//                 },
//                 child: ListView(
//                   shrinkWrap: true,
//                   controller: scrollCltr,
//                   children: [
//                     SizedBox(
//                       height: size.getH(8),
//                     ),
//                     if (placeOrderPro.itemViewType == ItemViewType.combo) ...[
//                       if (placeOrderPro.comboViewList.isNotEmpty)
//                         SetMenuItem(
//                           setMenuList: placeOrderPro.comboViewList,
//                           curSym: placeOrderPro.curSym,
//                           size: size,
//                           placeOrderPro: placeOrderPro,
//                         )
//                       else if (!placeOrderPro.loading)
//                         NoItemsSec(
//                           size: size,
//                           title: LN.noProductFound,
//                         )
//                     ] else if (placeOrderPro.itemViewType ==
//                         ItemViewType.ingre) ...[
//                       if (placeOrderPro.ingreViewList.isNotEmpty)
//                         RawIngreItems(
//                           dataList: placeOrderPro.ingreViewList,
//                           curSym: placeOrderPro.curSym,
//                         )
//                       else if (!placeOrderPro.loading)
//                         NoItemsSec(
//                           size: size,
//                           title: LN.noProductFound,
//                         )
//                     ]
//                   ],
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
