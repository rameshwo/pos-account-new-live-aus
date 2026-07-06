import 'package:flutter/material.dart';
import 'package:pos_account/config/size_config.dart';
import 'package:pos_account/constant/constant.dart';
import 'package:pos_account/ln.dart';
import 'package:pos_account/providers/cus_val_pro.dart';
import 'package:pos_account/providers/setting/store/store_pro_v2.dart';
import 'package:pos_account/screens/home_screen/com/items/tabs/setting_tab/com/storeV2/com/general/com/general_tab.dart';
import 'package:pos_account/screens/home_screen/com/items/tabs/setting_tab/com/storeV2/com/general/com/location_tab.dart';
import 'package:pos_account/screens/home_screen/com/items/tabs/setting_tab/com/storeV2/com/general/com/logo_image_tab.dart';
import 'package:pos_account/screens/home_screen/com/items/tabs/setting_tab/com/storeV2/com/general/com/other_tab.dart';
import 'package:pos_account/screens/home_screen/com/items/tabs/setting_tab/com/storeV2/com/general/com/tax_tab.dart';
import 'package:pos_account/screens/home_screen/com/items/tabs/setting_tab/com/storeV2/com/general/com/urls_tab.dart';
import 'package:pos_account/widgets/load_btn.dart';
import 'package:pos_account/widgets/loading.dart';
import 'package:provider/provider.dart';
import '../../../general/common/common_header.dart';

class GeneralStoreV2 extends StatefulWidget {
  final PageController pageController;
  const GeneralStoreV2({super.key, required this.pageController});

  @override
  State<GeneralStoreV2> createState() => _GeneralStoreV2State();
}

class _GeneralStoreV2State extends State<GeneralStoreV2>
    with TickerProviderStateMixin {
  final formKey = GlobalKey<FormState>();

  TabController? StoreTabCltr;

  late StoreProV2 _storePro;

  List<_StoreTab> get _storeTabs => [
        _StoreTab(
          title: LN.general,
          iconData: Icons.store_outlined,
          child: GeneralTab(),
        ),
        _StoreTab(
          title: "Location",
          iconData: Icons.location_on_outlined,
          child: LocationTab(),
        ),
        _StoreTab(
          title: "Tax",
          iconData: Icons.percent,
          child: TaxTab(),
        ),
        _StoreTab(
          title: "Urls",
          iconData: Icons.link,
          child: UrlTab(),
        ),
        _StoreTab(
          title: "Logo and Images",
          iconData: Icons.photo_camera_back,
          child: LogoImageTab(),
        ),
        _StoreTab(
          title: LN.others,
          iconData: Icons.settings_outlined,
          child: OtherTab(),
        ),
      ];

  void _setTab() {
    StoreTabCltr = TabController(length: _storeTabs.length, vsync: this);
  }

  @override
  void initState() {
    super.initState();
    setData();
  }

  void setData() {
    _setTab();
    _storePro = Provider.of<StoreProV2>(context, listen: false);
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await _storePro.getAddSec();
      _storePro.getGeneralData();
    });
  }

  @override
  void dispose() {
    super.dispose();
    _storePro.loading = true;
    if (StoreTabCltr != null) StoreTabCltr!.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = Ssize(context);
    final storePro = Provider.of<StoreProV2>(context);
    return Processing(
      loading: storePro.loading || storePro.updateLoadGeneral,
      child: Form(
        key: formKey,
        child: Column(
          children: [
            CommonHeader(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  IconButton(
                      onPressed: () {
                        widget.pageController.jumpToPage(0);
                      },
                      icon: Icon(Icons.arrow_back)),
                  Text(
                    LN.generalSettings,
                    style: TextStyle(
                      fontSize: size.getS(18),
                      fontFamily: kFontFMedium,
                    ),
                  ),
                  Spacer(),
                  if (GlobalCVP.viewWidget.viewStoreGeneralTabSaveButton)
                    LoadButton(
                      vPad: 10,
                      hPad: 4,
                      loading: storePro.updateLoadGeneral,
                      btnText: "Update",
                      loadingText: "Updating",
                      onsave: storePro.updateLoadGeneral
                          ? null
                          : () {
                              FocusScope.of(context).unfocus();
                              if (formKey.currentState?.validate() ?? false) {
                                storePro.updateGeneral();
                              }
                            },
                    ),
                  SizedBox(width: size.getW(12)),
                ],
              ),
            ),
            SizedBox(
              height: size.getH(12),
            ),
            Expanded(
                child: Container(
              padding: EdgeInsets.symmetric(horizontal: size.getW(12)),
              child: DefaultTabController(
                length: _storeTabs.length,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Stack(
                      children: [
                        Padding(
                          padding: EdgeInsets.only(top: size.getH(30)),
                          child: Divider(
                            color: Colors.black45,
                          ),
                        ),
                        IntrinsicWidth(
                          child: TabBar(
                            tabAlignment: TabAlignment.start,
                            indicatorWeight: 0,
                            tabs: List.generate(
                                _storeTabs.length,
                                (index) => Container(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: size.getW(32),
                                      ),
                                      child: Tab(
                                        iconMargin: EdgeInsets.zero,
                                        child: Row(
                                          children: [
                                            Icon(_storeTabs[index].iconData),
                                            SizedBox(width: size.getW(8)),
                                            Text(_storeTabs[index].title),
                                          ],
                                        ),
                                      ),
                                    )),
                            controller: StoreTabCltr,
                            isScrollable: true,
                            indicator: BoxDecoration(
                              color: kSecondaryColor,
                            ),
                            labelStyle: TextStyle(
                              fontSize: size.getS(18),
                              fontFamily: kFontFMedium,
                              color: Colors.white,
                            ),
                            labelPadding: EdgeInsets.zero,
                            indicatorPadding: EdgeInsets.zero,
                            padding: EdgeInsets.zero,
                            unselectedLabelColor: Colors.black87,
                          ),
                        ),
                      ],
                    ),
                    Flexible(
                      child: TabBarView(
                        controller: StoreTabCltr,
                        physics: NeverScrollableScrollPhysics(),
                        children: List.generate(_storeTabs.length,
                            (index) => _storeTabs[index].child),
                      ),
                    )
                  ],
                ),
              ),
            ))
          ],
        ),
      ),
    );
  }
}

class _StoreTab {
  final IconData iconData;
  final String title;
  final Widget child;

  _StoreTab({
    required this.title,
    required this.child,
    required this.iconData,
  });
}
