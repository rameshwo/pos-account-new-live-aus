import 'package:flutter/material.dart';
import 'package:pos_account/config/size_config.dart';
import 'package:pos_account/constant/constant.dart';
import 'package:pos_account/ln.dart';
import 'package:pos_account/providers/product/combo_pack_pro.dart';
import 'package:pos_account/screens/home_screen/com/items/tabs/product_tab/com/new_product/com/price_v_section/price_section_dia.dart';
import 'package:pos_account/screens/home_screen/com/items/tabs/setting_tab/com/general/common/common_header.dart';
import 'package:pos_account/widgets/dialog/confirm_dialog.dart';
import 'package:pos_account/widgets/input/text_form/text_form_widget.dart';
import 'package:pos_account/widgets/load_btn.dart';
import 'package:pos_account/widgets/loading.dart';
import 'package:pos_account/widgets/no_items_sec.dart';
import 'package:pos_account/widgets/title_pop.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import 'com/comb_item.dart';

class AllComboTab extends StatefulWidget {
  final Function()? onBack;
  final Function() onCreate;
  const AllComboTab({
    super.key,
    this.onBack,
    required this.onCreate,
  });

  @override
  State<AllComboTab> createState() => _AllComboTabState();
}

class _AllComboTabState extends State<AllComboTab> {
  @override
  void initState() {
    super.initState();
    _getData();
  }

  late ComboPackPro _combPro;
  final refreshCltr = RefreshController(initialRefresh: false);

  void _getData() async {
    _combPro = Provider.of<ComboPackPro>(context, listen: false);
    _combPro.getAllCombo();
  }

  void paginate(int page) {
    _combPro.getAllCombo(page: page).then((_) {
      if (page == 1) {
        refreshCltr.refreshCompleted();
      } else {
        refreshCltr.loadComplete();
      }
    });
  }

  showPriceUpdateDia(BuildContext context, {required String id}) {
    return showDialog(
        context: context,
        builder: (builder) => SimpleDialog(
              backgroundColor: Colors.white,
              titlePadding: EdgeInsets.zero,
              contentPadding: EdgeInsets.zero,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15)),
              children: [
                PriceSectionDia(
                  productId: id,
                )
              ],
            ));
  }

  @override
  void dispose() {
    refreshCltr.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final comboPro = Provider.of<ComboPackPro>(context);
    final size = Ssize(context);
    final _comboList = comboPro.comboList
        .where((e) => comboPro.searchCltr.text.isEmpty
            ? true
            : (e.name
                    ?.toLowerCase()
                    .contains(comboPro.searchCltr.text.toLowerCase()) ??
                true))
        .toList();
    return Processing(
      loading: comboPro.loading,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CommonHeader(
            child: Row(
              // mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TitlePop(
                  title: "Combo/Deals",
                  size: size,
                  onTap: () {
                    // setMenuPro.clear();
                    // setMenuPro.setMenuRes = null;
                    // _setMenuPro?.loading = true;
                    // _setMenuPro?.setCatList.clear();
                    if (widget.onBack != null) {
                      widget.onBack!();
                    }
                  },
                ),
                SizedBox(width: size.getW(24)),
                SizedBox(
                  width: size.getW(400),
                  child: TextFormWidget(
                    suffixIcon: Icon(Icons.search, size: size.getS(28)),
                    vPad: 12,
                    borderColor: Colors.black26,
                    isReq: false,
                    cltr: comboPro.searchCltr,
                    hintText: 'Search combo/deals products',
                    onChanged: (val) => comboPro.notify,
                  ),
                ),
                Spacer(),
                LoadButton(
                  btnColor: Colors.white,
                  btnText: "Add Combo/Deals",
                  hPad: 4,
                  vPad: 10,
                  width: 240,
                  textColor: kSecondaryColor,
                  fontSize: 18,
                  icon: Padding(
                    padding: EdgeInsets.only(right: size.getW(8)),
                    child: Icon(
                      Icons.add,
                      color: kSecondaryColor,
                      size: size.getS(25),
                    ),
                  ),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                      side: BorderSide(
                        color: kSecondaryColor,
                        width: 1.5,
                      )),
                  onsave: widget.onCreate,
                ),
              ],
            ),
          ),
          Flexible(
            child: Card(
              margin: EdgeInsets.zero,
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(horizontal: size.getW(12)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // SizedBox(height: size.getH(8)),
                    // Text(
                    //   "Combo packs help increase average order value and provide value to customers. Use this page to create, edit, and manage your combo offerings.",
                    //   style: TextStyle(
                    //     fontSize: size.getS(16),
                    //     fontFamily: kFontFRegular,
                    //     color: Colors.black,
                    //   ),
                    // ),
                    // SizedBox(height: size.getH(8)),
                    // _infoSection(size),
                    // SizedBox(height: size.getH(12)),

                    Flexible(
                      child: Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.black12),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          padding: EdgeInsets.symmetric(
                              horizontal: size.getW(12),
                              vertical: size.getH(8)),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // SizedBox(
                              //   width: size.getW(400),
                              //   child: TextFormWidget(
                              //     suffixIcon:
                              //         Icon(Icons.search, size: size.getS(28)),
                              //     vPad: 12,
                              //     borderColor: Colors.black26,
                              //     isReq: false,
                              //     cltr: comboPro.searchCltr,
                              //     hintText: 'Search combo products',
                              //     onChanged: (val) => comboPro.notify,
                              //   ),
                              // ),
                              // Padding(
                              //   padding: EdgeInsets.symmetric(
                              //       vertical: size.getH(2)),
                              //   child: Divider(color: Colors.black26),
                              // ),
                              Flexible(
                                child: SmartRefresher(
                                  controller: refreshCltr,
                                  enablePullUp: true,
                                  onLoading: () {
                                    paginate(comboPro.pageIndex + 1);
                                  },
                                  onRefresh: () {
                                    paginate(1);
                                  },
                                  child: !comboPro.loading && _comboList.isEmpty
                                      ? NoItemsSec(
                                          size: size,
                                          title: "No Combo/Deals Product Found")
                                      : GridView.count(
                                          crossAxisCount: 5,
                                          mainAxisSpacing: size.getW(12),
                                          crossAxisSpacing: size.getH(12),
                                          childAspectRatio: 1.25,
                                          physics: BouncingScrollPhysics(),
                                          children: List.generate(
                                              _comboList.length, (i) {
                                            return ComboItemSection(
                                              combo: _comboList[i],
                                              size: size,
                                              action: (ActionEnum ae) async {
                                                if (_comboList[i].id == null)
                                                  return;

                                                if (ae == ActionEnum.Edit) {
                                                  final _status = await comboPro
                                                      .getEditData(
                                                          id: _comboList[i]
                                                              .id!);
                                                  if (_status)
                                                    widget.onCreate();
                                                } else if (ae ==
                                                    ActionEnum.Delete) {
                                                  await showDialog(
                                                      context: context,
                                                      builder: (builder) =>
                                                          ConfirmDialog(
                                                            title:
                                                                "Remove ${_comboList[i].name}",
                                                            subTitle:
                                                                "Are you sure you want to remove ${_comboList[i].name}?",
                                                            actionText: LN.yes,
                                                            cancelText:
                                                                LN.cancel,
                                                            onDelete: () async {
                                                              final _status = await comboPro
                                                                  .deleteCombo(
                                                                      id: _comboList[
                                                                              i]
                                                                          .id!,
                                                                      name: _comboList[
                                                                              i]
                                                                          .name);
                                                              if (_status) {
                                                                _comboList
                                                                    .removeAt(
                                                                        i);
                                                                comboPro.notify;
                                                              }
                                                              return null;
                                                            },
                                                          ));
                                                } else if (ae ==
                                                    ActionEnum.PriceUpdate) {
                                                  showPriceUpdateDia(context,
                                                      id: _comboList[i].id!);
                                                }
                                              },
                                            );
                                          }),
                                        ),
                                ),
                              )
                            ],
                          )),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Container _infoSection(Ssize size) {
  //   return Container(
  //     decoration: BoxDecoration(
  //       color: kSecondaryColor.withOpacity(0.05),
  //       border: Border.all(color: Colors.black12),
  //       borderRadius: BorderRadius.circular(10),
  //     ),
  //     padding: EdgeInsets.symmetric(
  //         horizontal: size.getW(12), vertical: size.getH(16)),
  //     child: Row(
  //       children: [
  //         Icon(
  //           Icons.info,
  //           color: kSecondaryColor,
  //           size: size.getS(36),
  //         ),
  //         SizedBox(width: size.getW(12)),
  //         Flexible(
  //             child: Column(
  //           crossAxisAlignment: CrossAxisAlignment.start,
  //           children: [
  //             Text(
  //               "Manage Your Combo Pack",
  //               style: TextStyle(
  //                 fontSize: size.getS(18),
  //                 // fontFamily: kFontFMedium,
  //                 fontWeight: FontWeight.bold,
  //                 color: Colors.black,
  //               ),
  //             ),
  //             Text(
  //               "Combo packs help increase average order value and provide value to customers. Use this page to create, edit, and manage your combo offerings.",
  //               style: TextStyle(
  //                 fontSize: size.getS(16),
  //                 fontFamily: kFontFRegular,
  //                 color: Colors.black,
  //               ),
  //             ),
  //           ],
  //         ))
  //       ],
  //     ),
  //   );
  // }
}
