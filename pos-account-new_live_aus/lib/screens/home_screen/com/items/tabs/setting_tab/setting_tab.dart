import 'package:flutter/material.dart';
import 'package:pos_account/ln.dart';
import 'package:pos_account/providers/cus_val_pro.dart';
import 'package:pos_account/providers/setting/setting_pro.dart';
import 'package:provider/provider.dart';
import 'com/cus_display/cus_display.dart';
import 'com/general/general_set.dart';
import 'com/notifications/notifications_set.dart';
import 'com/payment_method/payment_method.dart';
import 'com/pos_setting/pos_printer_setting.dart';
import 'com/setting_section.dart';
import 'com/storeV2/store_settings_v2.dart';
import 'com/user_manage/user_manage.dart';

class SettingTab extends StatefulWidget {
  final PageController pageCltr;
  const SettingTab({
    super.key,
    required this.pageCltr,
  });

  @override
  State<SettingTab> createState() => _SettingTabState();
}

class _SettingTabState extends State<SettingTab> {
  late PageController _pageCltr;

  void onBack({int i = 0}) {
    if (i == 0) FocusManager.instance.primaryFocus?.unfocus();
    _pageCltr.animateToPage(i,
        duration: Duration(milliseconds: 300), curve: Curves.easeInOut);
  }

  @override
  void initState() {
    setData();
    super.initState();
  }

  setData() {
    final setPro = Provider.of<SettingProvider>(context, listen: false);
    final cvp = Provider.of<CusValuePro>(context, listen: false);
    if (cvp.isForBooking)
      _pageCltr = PageController(initialPage: setPro.getSPTabIndex);
    else
      _pageCltr = PageController();
  }

  List<SettingCardWidget> get cardWidgets => <SettingCardWidget>[
        if (GlobalCVP.viewWidget.viewGeneralSettingsModule)
          SettingCardWidget(
            id: 1,
            title: LN.generalSettings,
            subTitle: LN.generalSetSubtitle,
            asset: "assets/svg/icons/general.svg",
            screenWidget: GeneralSetting(
              onBack: onBack,
            ),
          ),
        if (GlobalCVP.viewWidget.viewPosDeviceSettingsModule)
          SettingCardWidget(
            id: 2,
            title: LN.posDeviceSet,
            subTitle: LN.posDeviceSetSubtitle,
            asset: "assets/svg/icons/printer.svg",
            screenWidget: POSPrinterSetting(
              onBack: onBack,
              onNext: () => onBack(i: 2),
            ),
          ),
        if (GlobalCVP.viewWidget.viewStoreSettingsModule)
          SettingCardWidget(
            id: 3,
            title: LN.storeSettings,
            subTitle: LN.storeSetSubtitle,
            asset: "assets/svg/icons/store.svg",
            screenWidget: StoreSettingV2(
              onBack: onBack,
            ),
          ),
        // if (GlobalCVP.viewWidget.viewStoreSettingsModule)
        //   SettingCardWidget(
        //     id: 3,
        //     title: LN.storeSettings,
        //     subTitle: LN.storeSetSubtitle,
        //     asset: "assets/svg/icons/store.svg",
        //     screenWidget: StoreSetting(
        //       onBack: onBack,
        //     ),
        //   ),
        if (GlobalCVP.viewWidget.viewNotificationSettingsModule)
          SettingCardWidget(
            id: 4,
            title: LN.notifiSet,
            subTitle: LN.notifySetSubtitle,
            asset: "assets/svg/icons/notofication.svg",
            screenWidget: NotificationSetting(
              onBack: onBack,
            ),
          ),
        if (GlobalCVP.viewWidget.viewPaymentMethodSettingsModule)
          SettingCardWidget(
            id: 5,
            title: LN.payMethodSetting,
            subTitle: LN.payMethodSetSubtitle,
            asset: "assets/svg/icons/payment.svg",
            screenWidget: PaymentMethod(
              onBack: onBack,
            ),
          ),
        if (GlobalCVP.viewWidget.viewUserManagementModule)
          SettingCardWidget(
            id: 6,
            title: LN.userManagement,
            subTitle: LN.userManageSetSubtitle,
            asset: "assets/svg/icons/user.svg",
            screenWidget: UserManagement(
              onBack: onBack,
            ),
          ),
        // SettingCardWidget(
        //   id: 7,
        //   title: LN.tableLayout,
        //   subTitle: LN.tableLayout,
        //   screenWidget: TableLayout(
        //     onBack: onBack,
        //   ),
        //   asset: "assets/svg/icons/store.svg",
        // ),
        // SettingCardWidget(
        //   id: 7,
        //   title: "Customer Display Setting",
        //   subTitle: "",
        //   asset: "assets/svg/icons/user.svg",
        //   screenWidget: CusDisplaySec(
        //     onBack: onBack,
        //   ),
        // ),
      ];

  @override
  Widget build(BuildContext context) {
    final setPro = Provider.of<SettingProvider>(context);
    return PageView(
      physics: NeverScrollableScrollPhysics(),
      controller: _pageCltr,
      children: [
        SettingSection(
          cardList: cardWidgets,
          onTap: (int i) {
            setPro.setSPTabIndex = i;
            _pageCltr.animateToPage(1,
                duration: Duration(milliseconds: 300), curve: Curves.easeInOut);
          },
        ),
        if (cardWidgets.any((e) => e.id == setPro.getSPTabIndex))
          cardWidgets
              .firstWhere((e) => e.id == setPro.getSPTabIndex)
              .screenWidget,
        // if (GlobalCVP.eftPosEnable)
        //   EftposPairingSec(
        //     onBack: () {
        //       onBack(i: 1);
        //       final _eftPro = Provider.of<EftPro>(context, listen: false);
        //       _eftPro.loadUrl(AppEnviro.eftposPay);
        //     },
        //   ),
        CusDisplaySec(
          onBack: () {
            onBack(i: 1);
          },
        )
      ],
    );
  }
}
