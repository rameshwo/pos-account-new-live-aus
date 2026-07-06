import 'package:flutter/material.dart';
import 'package:pos_account/config/size_config.dart';
import 'package:pos_account/constant/constant.dart';
import 'package:pos_account/ln.dart';
import 'package:pos_account/providers/cus_val_pro.dart';
import 'package:pos_account/screens/home_screen/com/gift_card_screen/com/template_group/gift_template_group_tab.dart';
import 'package:pos_account/screens/home_screen/com/items/tabs/setting_tab/com/general/common/common_header.dart';
import '../../../../widgets/title_pop.dart';
import '../cus_button_tabs.dart';
import 'com/custom_image/gift_card_cus_image_tab.dart';
import 'com/enquiry/gift_card_enquiry.dart';
import 'com/gift_card_list/gift_card_list_page.dart';
import 'com/new_gift_card/new_gift_card_page.dart';

class GiftCardScreen extends StatefulWidget {
  const GiftCardScreen({super.key});

  @override
  State<GiftCardScreen> createState() => _GiftCardScreenState();
}

class _GiftCardScreenState extends State<GiftCardScreen>
    with TickerProviderStateMixin {
  TabController? _tabCltr;
  int _selectedtab = 0;

  final _kTabs = <String>[
    LN.newGiftCard,
    LN.giftCardList,
    LN.giftCardTemplateGroup,
    LN.giftCardTemplate,
    // LN.giftCardImg,
    LN.giftCardEnquiry
  ];

  @override
  void initState() {
    super.initState();
    _tabCltr = TabController(length: _kTabs.length, vsync: this);
  }

  @override
  void dispose() {
    _tabCltr?.dispose();
    super.dispose();
  }

  void load() {
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final size = Ssize(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CommonHeader(
          child: TitlePop(
            title: LN.giftCard,
            size: size,
            onTap: () {
              GlobalCVP.setMainPage = MainPage.ManagePage;
            },
          ),
        ),
        // Text(
        //   LN.giftCard,
        //   style: TextStyle(
        //     fontSize: size.getS(22),
        //     fontWeight: FontWeight.bold,
        //     color: Colors.black,
        //   ),
        // ),
        SizedBox(
          height: size.getH(8),
        ),
        CusButtonTabs(
          kTabs: _kTabs,
          size: size,
          unSelectedColor: Colors.white,
          selectedColor: kPrimaryColor,
          selectedTextColor: Colors.white,
          selectedIndex: _selectedtab,
          onTap: (p0) {
            _selectedtab = p0;
            load();
            _tabCltr?.animateTo(p0,
                duration: Duration(milliseconds: 200), curve: Curves.easeInOut);
          },
        ),
        SizedBox(
          height: size.getH(8),
        ),
        Flexible(
          child: TabBarView(
            physics: NeverScrollableScrollPhysics(),
            controller: _tabCltr,
            children: [
              NewGiftCardPage(),
              GiftCardListPage(),
              GiftCardTempGroupTab(),
              GiftCardCusImageTab(),
              GiftCardEnquirySec(),
            ],
          ),
        )
      ],
    );
  }
}
