import 'package:flutter/material.dart';
import 'package:html_editor_enhanced/html_editor.dart';
import 'package:pos_account/config/size_config.dart';
import 'package:pos_account/constant/constant.dart';
import 'package:pos_account/ln.dart';
import 'package:pos_account/providers/product/combo_pack_pro.dart';
import 'package:pos_account/screens/home_screen/com/items/tabs/setting_tab/com/general/common/common_header.dart';
import 'package:pos_account/widgets/load_btn.dart';
import 'package:pos_account/widgets/loading.dart';
import 'package:pos_account/widgets/title_pop.dart';
import 'package:provider/provider.dart';

import 'com/general_info_sec.dart';
import 'com/products_sec.dart';

class CreateUpCombo extends StatefulWidget {
  final Function()? onBack;
  const CreateUpCombo({super.key, this.onBack});

  @override
  State<CreateUpCombo> createState() => _CreateUpComboState();
}

class _CreateUpComboState extends State<CreateUpCombo>
    with SingleTickerProviderStateMixin {
  final _tabList = <String>["General Information", "Products"];
  TabController? _tabCltr;

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _getData();
    });

    setUp();
  }

  void setUp() {
    _tabCltr = TabController(length: _tabList.length, vsync: this);
  }

  late ComboPackPro _combPro;

  void _getData() async {
    _combPro = Provider.of<ComboPackPro>(context, listen: false);
    _combPro.htmlController = HtmlEditorController();
    _combPro.getAddSec();
  }

  @override
  void dispose() {
    if (_tabCltr != null) _tabCltr!.dispose();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _combPro.clear();
    });

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final comboPro = Provider.of<ComboPackPro>(context);
    final size = Ssize(context);
    return Processing(
      loading: comboPro.createPageLoad,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CommonHeader(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TitlePop(
                  title: "Combo/Deals Details",
                  size: size,
                  onTap: () {
                    if (widget.onBack != null) {
                      widget.onBack!();
                    }
                  },
                ),
                Spacer(),
                LoadButton(
                  textColor: Colors.black,
                  btnColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5),
                    side: BorderSide(color: Colors.black12),
                  ),
                  btnText: LN.clear,
                  hPad: 4,
                  onsave: () {
                    comboPro.clear(doAllClear: false);
                    comboPro.notify;
                  },
                ),
                SizedBox(width: size.getW(12)),
                LoadButton(
                  width: 200,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5),
                    side: BorderSide(color: Colors.black12),
                  ),
                  btnText: comboPro.editData?.id == null ? LN.save : LN.update,
                  loadingText:
                      comboPro.editData?.id == null ? "Saving" : "Updating",
                  hPad: 4,
                  icon: Padding(
                    padding: EdgeInsets.only(right: size.getW(12)),
                    child: Icon(
                      Icons.save,
                      size: size.getS(24),
                      color: Colors.white,
                    ),
                  ),
                  loading: comboPro.btnLoad,
                  onsave: () async {
                    if (_formKey.currentState!.validate()) {
                      final _status = await comboPro.addUpCombo();
                      if (_status) {
                        if (comboPro.editData?.id != null) {
                          if (widget.onBack != null) widget.onBack!();
                          comboPro.clear(doAllClear: false);
                        } else {
                          comboPro.clear(doAllClear: false);
                          comboPro.getAddSec();
                        }
                      }
                    }
                  },
                )
              ],
            ),
          ),
          Flexible(
              child: Form(
            key: _formKey,
            child: Card(
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black12),
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: EdgeInsets.symmetric(
                    horizontal: size.getW(24), vertical: size.getH(12)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Row(
                    //   children: [
                    // Text(
                    //   "Combo Pack Details",
                    //   style: TextStyle(
                    //     fontSize: size.getS(22),
                    //     // fontFamily: kFontFMedium,
                    //     fontWeight: FontWeight.bold,
                    //     color: Colors.black,
                    //   ),
                    // ),
                    // Spacer(),
                    // LoadButton(
                    //   textColor: Colors.black,
                    //   btnColor: Colors.white,
                    //   shape: RoundedRectangleBorder(
                    //     borderRadius: BorderRadius.circular(5),
                    //     side: BorderSide(color: Colors.black12),
                    //   ),
                    //   btnText: LN.clear,
                    //   hPad: 4,
                    //   onsave: () {
                    //     comboPro.clear(doAllClear: false);
                    //     comboPro.notify;
                    //   },
                    // ),
                    // SizedBox(width: size.getW(12)),
                    // LoadButton(
                    //   shape: RoundedRectangleBorder(
                    //     borderRadius: BorderRadius.circular(5),
                    //     side: BorderSide(color: Colors.black12),
                    //   ),
                    //   btnText: comboPro.editData?.id == null
                    //       ? LN.save
                    //       : LN.update,
                    //   hPad: 4,
                    //   icon: Padding(
                    //     padding: EdgeInsets.only(right: size.getW(12)),
                    //     child: Icon(
                    //       Icons.save,
                    //       size: size.getS(24),
                    //       color: Colors.white,
                    //     ),
                    //   ),
                    //   onsave: () async {
                    //     if (_formKey.currentState!.validate()) {
                    //       final _status = await comboPro.addUpCombo();
                    //       if (_status) {
                    //         if (comboPro.editData?.id != null) {
                    //           if (widget.onBack != null) widget.onBack!();
                    //           comboPro.clear(doAllClear: false);
                    //         } else {
                    //           comboPro.clear(doAllClear: false);
                    //           comboPro.getAddSec();
                    //         }
                    //       }
                    //     }
                    //   },
                    // )
                    //   ],
                    // ),
                    Flexible(
                        child: DefaultTabController(
                      length: _tabList.length,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: size.getH(40),
                            // decoration: BoxDecoration(
                            //   color: Colors.grey.shade200,
                            // ),
                            child: TabBar(
                              // indicatorWeight: 4,
                              tabs: List.generate(
                                  _tabList.length,
                                  (index) => _tabWidget(
                                        size,
                                        title: _tabList[index],
                                        iconData: index == 0
                                            ? Icons.info
                                            : Icons.inventory_2,
                                      )),
                              indicatorColor: kSecondaryColor,
                              labelColor: kSecondaryColor,
                              controller: _tabCltr,
                              isScrollable: true,
                              // indicator: BoxDecoration(
                              //     // color: kPrimaryColor,
                              //     ),
                              labelStyle: TextStyle(
                                fontSize: size.getS(20),
                                fontFamily: kFontFMedium,
                              ),
                              // labelPadding: EdgeInsets.zero,
                              // indicatorPadding: EdgeInsets.zero,
                              padding: EdgeInsets.zero,
                              unselectedLabelColor: Colors.black,
                            ),
                          ),
                          if (_tabCltr != null)
                            Flexible(
                                child: TabBarView(
                                    controller: _tabCltr,
                                    physics: NeverScrollableScrollPhysics(),
                                    children: [
                                  GeneralInfoSec(
                                    comboPro: comboPro,
                                  ),
                                  ProductSection(
                                    comboPro: comboPro,
                                  ),
                                ])),
                        ],
                      ),
                    ))
                  ],
                ),
              ),
            ),
          ))
        ],
      ),
    );
  }

  Widget _tabWidget(Ssize size, {String? title, IconData? iconData}) {
    return Container(
      // decoration: BoxDecoration(
      //   border: Border.symmetric(
      //     vertical: BorderSide(
      //       color: Colors.white,
      //       width: 2,
      //     ),
      //   ),
      // ),
      padding: EdgeInsets.symmetric(
        horizontal: size.getW(16),
      ),
      child: Tab(
        iconMargin: EdgeInsets.zero,
        child: Row(
          children: [
            if (iconData != null) ...[
              Icon(iconData, size: size.getS(24)),
              SizedBox(width: size.getW(12))
            ],
            Text(
              title ?? '',
            ),
          ],
        ),
      ),
    );
  }
}
