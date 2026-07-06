import 'package:flutter/material.dart';
import 'package:pos_account/constant/constant.dart';
import 'package:pos_account/ln.dart';
import 'package:pos_account/providers/cus_val_pro.dart';
import 'package:pos_account/providers/setting/store/store_pro.dart';
import 'package:pos_account/widgets/load_btn.dart';
import 'package:pos_account/widgets/loading.dart';
import 'package:provider/provider.dart';
import '../../../../../../../../../config/size_config.dart';
import '../general/common/common_header.dart';
import 'com/store_calender.dart';
import 'com/store_deli_distance.dart';
import 'com/store_general.dart';
import 'com/store_open_hours.dart';
import 'com/store_loyality.dart';
import 'com/store_other_setting.dart';

class StoreSetting extends StatefulWidget {
  final Function() onBack;
  const StoreSetting({super.key, required this.onBack});

  @override
  State<StoreSetting> createState() => _StoreSettingState();
}

class _StoreSettingState extends State<StoreSetting>
    with TickerProviderStateMixin {
  List<_StoreTab> get _storeTabs => [
        if (GlobalCVP.viewWidget.viewStoreGeneralTab)
          _StoreTab(title: LN.general, child: StoreGeneral()),
        if (GlobalCVP.viewWidget.viewStoreLoyaltyTab)
          _StoreTab(
              title: (_storePro.curSym == null || _storePro.curSym!.isEmpty)
                  ? LN.loyalty
                  : """${LN.loyalty} (${_storePro.curSym})""",
              child: StoreLoyality(
                cancel: widget.onBack,
              )),
        if (GlobalCVP.viewWidget.viewStoreDeliveryDistanceTab &&
            !GlobalCVP.isServiceStore)
          _StoreTab(title: LN.deliveryDistance, child: StoreDeliDistance()),
        if (GlobalCVP.viewWidget.viewStoreOpeningTimeTab)
          _StoreTab(title: LN.openingHours, child: StoreOpenHours()),
        _StoreTab(title: "Surcharges", child: StoreCalenderSetting()),
        _StoreTab(
            title: LN.otherSettings,
            child: StoreOtherSetting(
              cancel: widget.onBack,
            )),
      ];

  late StorePro _storePro;

  void _setTab() {
    StoreTabCltr = TabController(length: _storeTabs.length, vsync: this);
  }

  @override
  void initState() {
    super.initState();
    setData();
  }

  setData() async {
    _storePro = Provider.of<StorePro>(context, listen: false);
    _storePro.tabCltrFunction = _setTab;
    _setTab();
    await _storePro.getCurSym();

    _storePro.getAllData();
  }

  @override
  void dispose() {
    super.dispose();
    if (StoreTabCltr != null) StoreTabCltr!.dispose();
    _storePro.reset();
  }

  @override
  Widget build(BuildContext context) {
    final size = Ssize(context);
    final storePro = Provider.of<StorePro>(context);

    return Processing(
      align: Alignment.topLeft,
      loading: storePro.loading || storePro.updateLoad,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CommonHeader(
            padding: 0,
            child: Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: size.getW(12), vertical: size.getH(6)),
              child: Row(
                children: [
                  IconButton(
                      visualDensity: VisualDensity.compact,
                      onPressed: widget.onBack,
                      icon: Icon(Icons.arrow_back)),
                  SizedBox(width: size.getW(8)),
                  Text(
                    LN.storeSettings,
                    style: TextStyle(
                      fontSize: size.getS(18),
                      // fontFamily: ,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  Spacer(),
                  if (GlobalCVP.viewWidget.viewStoreGeneralTabSaveButton)
                    LoadButton(
                      vPad: 10,
                      hPad: 4,
                      loading: storePro.updateLoad,
                      btnText: "Update",
                      loadingText: "Updating",
                      onsave: storePro.updateLoad
                          ? null
                          : () {
                              FocusScope.of(context).unfocus();
                              storePro.addData(context);
                            },
                    ),
                  SizedBox(width: size.getW(24)),
                ],
              ),
            ),
          ),
          SizedBox(
            height: size.getH(8),
          ),
          if (StoreTabCltr != null && StoreTabCltr!.length == _storeTabs.length)
            Flexible(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: size.getW(12)),
                child: DefaultTabController(
                    length: _storeTabs.length,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        IntrinsicWidth(
                          child: Container(
                            decoration: BoxDecoration(
                              color: kTempColor,
                            ),
                            child: TabBar(
                              tabAlignment: TabAlignment.start,
                              indicatorWeight: 0,
                              tabs: List.generate(
                                  _storeTabs.length,
                                  (index) => Container(
                                        decoration: BoxDecoration(
                                          border: Border.symmetric(
                                            vertical: BorderSide(
                                              color: Colors.white,
                                              width: 2,
                                            ),
                                          ),
                                        ),
                                        padding: EdgeInsets.symmetric(
                                          horizontal: size.getW(32),
                                        ),
                                        child: Tab(
                                          iconMargin: EdgeInsets.zero,
                                          child: Text(_storeTabs[index].title),
                                        ),
                                      )),
                              indicatorColor: Colors.transparent,
                              labelColor: Colors.white,
                              controller: StoreTabCltr,
                              isScrollable: true,
                              indicator: BoxDecoration(
                                color: kPrimaryColor,
                              ),
                              labelStyle: TextStyle(
                                fontSize: size.getS(18),
                                fontFamily: kFontFMedium,
                              ),
                              labelPadding: EdgeInsets.zero,
                              indicatorPadding: EdgeInsets.zero,
                              padding: EdgeInsets.zero,
                              unselectedLabelColor: Colors.white,
                            ),
                          ),
                        ),
                        Flexible(
                          child: Form(
                            key: storePro.formKey,
                            child: TabBarView(
                              controller: StoreTabCltr,
                              children: List.generate(_storeTabs.length,
                                  (index) => _storeTabs[index].child),
                            ),
                          ),
                        )
                      ],
                    )),
              ),
            ),
        ],
      ),
    );
  }
}

class _StoreTab {
  final String title;
  final Widget child;

  _StoreTab({required this.title, required this.child});
}
