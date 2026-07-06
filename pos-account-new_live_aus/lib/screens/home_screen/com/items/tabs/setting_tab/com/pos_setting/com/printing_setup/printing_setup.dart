import 'package:flutter/material.dart';
import 'package:pos_account/config/size_config.dart';
import 'package:pos_account/constant/constant.dart';
import 'package:pos_account/ln.dart';
import 'package:pos_account/providers/setting/pos_device/printer_setting_pro.dart';
import 'package:pos_account/widgets/load_btn.dart';
import 'package:pos_account/widgets/message_widgets/trial_expire.dart';
import 'package:pos_account/widgets/no_items_sec.dart';
import 'package:pos_account/widgets/refresh_btn.dart';
import 'package:pos_account/widgets/switch_adap.dart';
import 'kit_display/kit_display_config.dart';
import 'printer/printer_type_sec.dart';

class PrintingSetup extends StatelessWidget {
  final Ssize size;
  final PrinterSettingPro pro;
  final TabController tabController;
  final List<String> tabList;
  final Function()? refresh;
  const PrintingSetup({
    super.key,
    required this.size,
    required this.pro,
    required this.tabController,
    required this.tabList,
    this.refresh,
  });

  @override
  Widget build(BuildContext context) {
    final _printerLength = (pro.addSec?.posPrinters?.isNotEmpty ?? false)
        ? pro.addSec!.posPrinters!.length
        : 1;
    final _deviceLength = (pro.addSec?.posDevices?.isNotEmpty ?? false)
        ? pro.addSec!.posDevices!.length
        : 1;
    return DefaultTabController(
      length: tabList.length,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: size.getH(40),
            child: TabBar(
              tabs: List.generate(
                  tabList.length,
                  (index) => _tabWidget(
                        size,
                        title: tabList[index],
                        iconData:
                            index == 0 ? Icons.print_outlined : Icons.monitor,
                      )),
              indicatorColor: kSecondaryColor,
              labelColor: kSecondaryColor,
              controller: tabController,
              isScrollable: true,
              labelStyle: TextStyle(
                fontSize: size.getS(18),
                fontFamily: kFontFMedium,
              ),
              padding: EdgeInsets.zero,
              unselectedLabelColor: Colors.black,
              onTap: (_) => pro.notify,
            ),
          ),
          SizedBox(
            height: size.getH(tabController.index == 0
                ? (150 + _printerLength * 150)
                : (200 + _deviceLength * 180)),
            child: TabBarView(
                controller: tabController,
                physics: NeverScrollableScrollPhysics(),
                children: [
                  SingleChildScrollView(
                    physics: NeverScrollableScrollPhysics(),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (pro.editData?.message != null &&
                            pro.editData!.message!.isNotEmpty)
                          TrialExpiryMsg(
                            size: size,
                            show: pro.editData!.message!.isNotEmpty,
                            message: pro.editData!.message!,
                          )
                        else if (!(pro.addSec?.posPrinters?.isNotEmpty ??
                                false) &&
                            pro.loading)
                          Container()
                        else if (pro.addSec?.posPrinters?.isNotEmpty ?? false)
                          Card(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                            child: SizedBox(
                              width: double.infinity,
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                    vertical: size.getH(24.0),
                                    horizontal: size.getW(24)),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Expanded(
                                          child: Wrap(
                                            spacing: size.getW(24),
                                            runSpacing: size.getH(16),
                                            children: [
                                              _switchTextInRow(
                                                title:
                                                    "Order Print Automatically",
                                                value: pro.editData
                                                        ?.orderPrintAutomatically ??
                                                    false,
                                                onChanged: (p0) {
                                                  pro.editData
                                                      ?.orderPrintAutomatically = p0;
                                                  pro.notify;
                                                },
                                              ),
                                              _switchTextInRow(
                                                title:
                                                    "Invoice Print Automatically",
                                                value: pro.editData
                                                        ?.printBillAutomatically ??
                                                    false,
                                                onChanged: (p0) {
                                                  pro.editData
                                                      ?.printBillAutomatically = p0;
                                                  pro.notify;
                                                },
                                              ),
                                            ],
                                          ),
                                        ),
                                        RefreshBtn(
                                          size: size,
                                          onTap: refresh,
                                        ),
                                        SizedBox(width: size.getW(16)),
                                        LoadButton(
                                          btnText: LN.update,
                                          loading: pro.updateLoad,
                                          onsave: () {
                                            pro.addUpdatePrinter();
                                          },
                                        )
                                      ],
                                    ),
                                    Divider(
                                      color: Colors.black26,
                                      thickness: 0.7,
                                    ),
                                    ...List.generate(
                                        pro.addSec!.posPrinters!.length,
                                        (index) => PrinterTypeSec(
                                              size: size,
                                              pro: pro,
                                              printerIndex: index,
                                            )),
                                  ],
                                ),
                              ),
                            ),
                          )
                        else
                          Center(
                            child: NoItemsSec(
                                size: size,
                                title: LN.printerNotSetup,
                                iconHeight: 200),
                          )
                      ],
                    ),
                  ),
                  KitchenDisplayConfiguration(
                    pro: pro,
                  )
                ]),
          ),
          // Text(
          //   LN.posPrinterSetup,
          //   style: TextStyle(
          //     fontSize: size.getS(18),
          //     // fontFamily: ,
          //     fontWeight: FontWeight.bold,
          //     color: Colors.black,
          //   ),
          // ),
          // SizedBox(
          //   height: size.getH(12),
          // ),
        ],
      ),
    );
  }

  Widget _switchTextInRow({
    required bool value,
    Function(bool)? onChanged,
    required String title,
  }) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        SwitchAdap(
            height: 36,
            size: size,
            value: value,
            activeColor: kSecondaryColor,
            onChanged: onChanged),
        SizedBox(
          width: size.getW(12),
        ),
        Text(
          title,
          style: TextStyle(
            fontSize: size.getS(16),
            fontFamily: kFontFRegular,
            // fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
      ],
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
