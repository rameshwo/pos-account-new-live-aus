import 'package:flutter/material.dart';
import 'package:pos_account/config/size_config.dart';
import 'package:pos_account/constant/constant.dart';
import 'package:pos_account/ln.dart';
import 'package:pos_account/providers/cus_val_pro.dart';
import 'package:pos_account/providers/integration/integration_pro.dart';
import 'package:pos_account/screens/home_screen/com/items/tabs/setting_tab/com/general/common/common_header.dart';
import 'package:pos_account/widgets/image/network_image_sec.dart';
import 'ac_mapping_sec.dart';
import 'connect_sec.dart';
// import 'contact_sec.dart';

class IntegrateSetting extends StatelessWidget {
  final Function() onBack;
  final Ssize size;
  final IntegrationPro intePro;
  final PageController tabCltr;
  const IntegrateSetting({
    super.key,
    required this.onBack,
    required this.size,
    required this.intePro,
    required this.tabCltr,
  });

  // static final _mainScrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    final kTabs = <String>[
      if (GlobalCVP.viewWidget.viewConnectXeroTab)
        "${LN.connect} ${intePro.selectedAccount?.name}",
      if (GlobalCVP.viewWidget.viewChartOfAccountMappingTab) LN.chartAcMap,
      // LN.contactSetting,
    ];
    return Column(
      children: [
        CommonHeader(
          child: Row(
            children: [
              IconButton(
                  onPressed: onBack,
                  icon: Icon(Icons.arrow_back, size: size.getS(24))),
              SizedBox(width: size.getW(8)),
              Text(
                intePro.selectedAccount?.name ?? '',
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
        SizedBox(height: size.getH(8)),
        Flexible(
          // height: size.getH(740),
          child: Card(
            margin: EdgeInsets.symmetric(
                horizontal: size.getW(12), vertical: size.getH(0)),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            child: SizedBox(
              width: double.infinity,
              child: Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: size.getW(24), vertical: size.getH(12)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // SizedBox(
                    //   height: size.getH(12),
                    // ),
                    Row(
                      children: [
                        ...List.generate(
                            kTabs.length,
                            (index) => AnimatedContainer(
                                  duration: Duration(milliseconds: 350),
                                  margin: EdgeInsets.only(right: size.getW(16)),
                                  decoration: BoxDecoration(
                                      border: Border.all(color: Colors.black12),
                                      color: intePro.selectedTab == index
                                          ? kUserColor.withOpacity(0.15)
                                          : kBackgroundColor,
                                      borderRadius: BorderRadius.circular(5)),
                                  child: InkWell(
                                    onTap: () {
                                      intePro.selectedTab = index;
                                      intePro.notify;
                                      tabCltr.animateToPage(index,
                                          duration: Duration(milliseconds: 400),
                                          curve: Curves.easeInOut);
                                    },
                                    child: Padding(
                                      padding: EdgeInsets.symmetric(
                                          vertical: size.getH(8),
                                          horizontal: size.getW(24)),
                                      child: Text(
                                        kTabs[index],
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontFamily: kFontFMedium,
                                          fontSize: size.getS(16),
                                        ),
                                      ),
                                    ),
                                  ),
                                )),
                        Expanded(
                          child: Align(
                            alignment: Alignment.centerRight,
                            child: NetworkImageSec(
                              image: intePro.selectedAccount?.image,
                              height: 64,
                              boxFit: BoxFit.fitHeight,
                            ),
                          ),
                        )
                      ],
                    ),
                    // SizedBox(
                    //   height: size.getH(16),
                    // ),
                    Flexible(
                      child: PageView(
                        controller: tabCltr,
                        physics: NeverScrollableScrollPhysics(),
                        children: [
                          if (GlobalCVP.viewWidget.viewConnectXeroTab)
                            ConnectSection(
                              intePro: intePro,
                              size: size,
                            ),
                          if (GlobalCVP.viewWidget.viewChartOfAccountMappingTab)
                            AcMappingSecion(
                              size: size,
                              intePro: intePro,
                              // parentScrollCltr: _mainScrollController,
                            ),
                          // ContactSection(
                          //   size: size,
                          //   intePro: intePro,
                          // )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        )
      ],
    );
  }
}
