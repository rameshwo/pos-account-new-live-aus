import 'package:flutter/material.dart';
import 'package:pos_account/config/size_config.dart';
import 'package:pos_account/ln.dart';
import 'package:pos_account/providers/setting/store/store_pro_v2.dart';
import 'package:pos_account/screens/home_screen/com/items/tabs/setting_tab/com/storeV2/com/general/general_v2.dart';
import 'package:provider/provider.dart';

import '../../../../../../../../widgets/setting_card.dart';
import '../general/common/common_header.dart';
import 'com/color_v2.dart';
import 'com/delivery_dis_v2.dart';
import 'com/extra_charge_v2.dart';
import 'com/open_hour_v2.dart';
import 'com/other_v2.dart';

class StoreSettingV2 extends StatefulWidget {
  final Function() onBack;
  const StoreSettingV2({
    super.key,
    required this.onBack,
  });

  @override
  State<StoreSettingV2> createState() => _StoreSettingV2State();
}

class _StoreSettingV2State extends State<StoreSettingV2> {
  final pageController = PageController();

  late StoreProV2 _storePro;

  @override
  void initState() {
    super.initState();
    setData();
  }

  setData() {
    _storePro = Provider.of<StoreProV2>(context, listen: false);
  }

  @override
  void dispose() {
    _storePro.reset();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = Ssize(context);
    return PageView(
      controller: pageController,
      physics: NeverScrollableScrollPhysics(),
      children: [
        _generalSet(size),
        GeneralStoreV2(
          pageController: pageController,
        ),
        OpenHourStoreV2(
          pageController: pageController,
        ),
        DeliveryStoreV2(
          pageController: pageController,
        ),
        ExChargeStoreV2(
          pageController: pageController,
        ),
        ColorStoreV2(
          pageController: pageController,
        ),
        OtherSetStoreV2(
          pageController: pageController,
        ),
      ],
    );
  }

  Widget _generalSet(Ssize size) {
    return Column(
      children: [
        CommonHeader(
          child: Row(
            children: [
              IconButton(
                  onPressed: widget.onBack, icon: Icon(Icons.arrow_back)),
              Text(
                LN.storeSettings,
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
        // SizedBox(
        //   height: size.getH(8),
        // ),
        Flexible(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: double.infinity,
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                        vertical: size.getH(12), horizontal: size.getW(12)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        GridView.count(
                          mainAxisSpacing: size.getW(10),
                          crossAxisSpacing: size.getH(10),
                          crossAxisCount: 3,
                          physics: NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          childAspectRatio: 3,
                          children: [
                            NewCard(
                              iconWidget: Icon(
                                Icons.store_mall_directory_outlined,
                                color: Colors.grey,
                                size: size.getW(36),
                              ),
                              title: LN.general,
                              onTap: () {
                                pageController.jumpToPage(1);
                              },
                              subTitle:
                                  "Configure your business's general informations",
                            ),
                            NewCard(
                              iconWidget: Icon(
                                Icons.watch_later_outlined,
                                color: Colors.grey,
                                size: size.getW(36),
                              ),
                              title: LN.openingHours,
                              onTap: () {
                                pageController.jumpToPage(2);
                              },
                              subTitle:
                                  "Configure your store's opening hours for pickup and delivery.",
                            ),
                            NewCard(
                              iconWidget: Icon(
                                Icons.delivery_dining_outlined,
                                color: Colors.grey,
                                size: size.getW(36),
                              ),
                              title: LN.deliveryDistance,
                              onTap: () {
                                pageController.jumpToPage(3);
                              },
                              subTitle:
                                  "Configure delivery distance settings for your online ordering website.",
                            ),
                            NewCard(
                              iconWidget: Icon(
                                Icons.show_chart_rounded,
                                color: Colors.grey,
                                size: size.getW(36),
                              ),
                              title: "Extra Charge",
                              onTap: () {
                                pageController.jumpToPage(4);
                              },
                              subTitle:
                                  "Configure additional charge settings for credit cards, holidays, and weekends.",
                            ),
                            NewCard(
                              iconWidget: Icon(
                                Icons.color_lens_outlined,
                                color: Colors.grey,
                                size: size.getW(36),
                              ),
                              title: "Color Settings",
                              onTap: () {
                                pageController.jumpToPage(5);
                              },
                              subTitle:
                                  "Customize your online ordering website's color scheme.",
                            ),
                            NewCard(
                              iconWidget: Icon(
                                Icons.settings_applications_outlined,
                                color: Colors.grey,
                                size: size.getW(36),
                              ),
                              title: LN.otherSettings,
                              onTap: () {
                                pageController.jumpToPage(6);
                              },
                              subTitle:
                                  "Configure additional settings for your store, including maintenance mode, checkout options, and more.",
                            ),
                          ],
                        ),
                        SizedBox(
                          height: size.getH(24),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ],
    );
  }
}
