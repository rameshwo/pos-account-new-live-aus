import 'package:flutter/material.dart';
import 'package:pos_account/config/size_config.dart';
import 'package:pos_account/ln.dart';
import 'package:pos_account/providers/setting/pos_device/printer_setting_pro.dart';
import 'package:pos_account/widgets/loading.dart';
import 'package:pos_account/widgets/setting_card.dart';
import 'package:provider/provider.dart';
import '../general/common/common_header.dart';
import 'com/pos_device_set.dart';
import 'com/printer_location_set.dart';
import 'com/printing_setup/printing_setup.dart';

class POSPrinterSetting extends StatefulWidget {
  final Function() onBack;
  final Function()? onNext;
  const POSPrinterSetting({super.key, required this.onBack, this.onNext});

  @override
  State<POSPrinterSetting> createState() => _POSPrinterSettingState();
}

class _POSPrinterSettingState extends State<POSPrinterSetting>
    with SingleTickerProviderStateMixin {
  // showTableDia({required BuildContext ctx, required int index}) {
  //   showDialog(
  //       context: ctx,
  //       builder: (builder) => SimpleDialog(
  //             backgroundColor: kBackgroundColor,
  //             titlePadding: EdgeInsets.zero,
  //             contentPadding: EdgeInsets.symmetric(horizontal: 24, vertical: 0),
  //             shape: RoundedRectangleBorder(
  //                 borderRadius: BorderRadius.circular(15)),
  //             children: [
  //               if (index == 0) DepartmentSet(),
  //               if (index == 1) PrinterLocationSet(),
  //               if (index == 2) PosDeviceSet(),
  //               // if (index == 3) EftposSet(),
  //             ],
  //           )).then((_) => getData());
  // }

  @override
  void initState() {
    _tabCltr = TabController(length: _tabList.length, vsync: this);
    getData();
    super.initState();
  }

  PrinterSettingPro? _pro;
  // EftPosPro? _eftPosPro;

  getData() async {
    _pro = Provider.of<PrinterSettingPro>(context, listen: false);
    // _eftPosPro = Provider.of<EftPosPro>(context, listen: false);
    // _eftPosPro?.getAddSec();
    await _pro?.getData();
    // pageCltr.addListener(() {
    // if (_prevPage == 2 && pageCltr.page == 0) {
    //   getData();
    // }

    // _prevPage = pageCltr.page?.toInt() ?? 0;
    // });
  }

  // int _prevPage = 0;

  final _tabList = <String>[
    "Printer Configuration",
    "Kitchen Display Configuration"
  ];
  TabController? _tabCltr;

  @override
  void dispose() {
    _pro?.clear();
    // _prevPage = 0;

    if (_tabCltr != null) _tabCltr!.dispose();
    super.dispose();
  }

  final PageController pageCltr = PageController();
  @override
  Widget build(BuildContext context) {
    final size = Ssize(context);
    final pro = Provider.of<PrinterSettingPro>(context);
    return PageView(
      controller: pageCltr,
      children: [
        _View(
          pro: pro,
          size: size,
        ),
        // DepartmentSet(
        //   pageController: pageCltr,
        // ),
        PrinterLocationSet(
          pageController: pageCltr,
        ),
        PosDeviceSet(
          pageController: pageCltr,
        ),
      ],
    );
  }

  Widget _View({
    required PrinterSettingPro pro,
    required Ssize size,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CommonHeader(
          child: Row(
            children: [
              IconButton(
                  onPressed: widget.onBack, icon: Icon(Icons.arrow_back)),
              SizedBox(width: size.getW(8)),
              Text(
                LN.posDeviceSet,
                style: TextStyle(
                  fontSize: size.getS(18),
                  // fontFamily: ,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ],
          ),
        ),
        Flexible(
          child: Processing(
            loading: pro.loading || pro.updateLoad,
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(
                  vertical: size.getH(8.0), horizontal: size.getW(20)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // SizedBox(
                  //   height: size.getH(8),
                  // ),
                  SizedBox(
                    width: double.infinity,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Wrap(
                          spacing: size.getW(10),
                          runSpacing: size.getH(10),
                          children: [
                            // NewCard(
                            //   asset:
                            //       "assets/svg/icons/pos_device/department.svg",
                            //   height: size.getH(120),
                            //   subTitle: "View and manage your departments",
                            //   onTap: () {
                            //     pageCltr.jumpToPage(1);
                            //   },
                            //   title: LN.department,
                            // ),
                            NewCard(
                              asset:
                                  "assets/svg/icons/pos_device/printer_loc.svg",
                              height: size.getH(120),
                              subTitle:
                                  "View and manage your printer locations",
                              onTap: () {
                                pageCltr.jumpToPage(1);
                              },
                              title: LN.printerLocation,
                            ),
                            NewCard(
                              asset:
                                  "assets/svg/icons/pos_device/posdevice.svg",
                              height: size.getH(120),
                              subTitle: "View and manage your POS devices",
                              onTap: () {
                                pageCltr.jumpToPage(2);
                              },
                              title: LN.posDevice,
                            ),

                            // Hide EFTPOS Terminal Section. It's under construction
                            // if (GlobalCVP.eftPosEnable)
                            //   GSTextSection(
                            //     width: size.width / 4.5,
                            //     title: LN.eftDevicePair,
                            //     onTap: () =>
                            //         widget.onNext!(DeviceSetType.eft),
                            //     list: [],
                            //     hintText: LN.eftDevicePair,
                            //   ),
                            NewCard(
                              asset: "assets/svg/icons/pos_device/display.svg",
                              height: size.getH(120),
                              subTitle:
                                  "View and manage your dual display settings",
                              onTap: () {
                                widget.onNext!();
                              },
                              title: LN.dualDisSet,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: size.getH(16),
                    child: Divider(),
                  ),
                  if (_tabCltr != null)
                    PrintingSetup(
                      size: size,
                      pro: pro,
                      tabController: _tabCltr!,
                      tabList: _tabList,
                      refresh: pro.loading
                          ? null
                          : () {
                              pro.loading = true;
                              pro.notify;

                              pro.getData();
                            },
                    ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
