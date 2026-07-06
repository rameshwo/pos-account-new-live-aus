import 'package:flutter/material.dart';
import 'package:pos_account/constant/constant.dart';
import 'package:pos_account/ln.dart';
import 'package:pos_account/providers/cus_val_pro.dart';
import 'package:pos_account/providers/setting/setting_pro.dart';
import 'package:pos_account/screens/home_screen/com/items/tabs/setting_tab/com/general/com/discounts_set/discount_set.dart';
import 'package:pos_account/screens/home_screen/com/items/tabs/setting_tab/com/general/com/quick_notes/quick_note_set.dart';
import 'package:pos_account/screens/home_screen/com/items/tabs/setting_tab/com/general/com/tax_ie_set.dart';
import 'package:pos_account/widgets/input/dropdown/drop_down.dart';
import 'package:pos_account/widgets/setting_card.dart';
import 'package:provider/provider.dart';
import '../../../../../../../../config/size_config.dart';
import 'com/barcode_set/barcode_set.dart';
import 'com/brand_set/brand_set.dart';
import 'com/category_set/category_set.dart';
import 'com/docket_set/docket_group_set.dart';
import 'com/order_status_set.dart';
import 'com/order_type_set/order_type_set.dart';
import 'com/sub_cat_set/sub_cat_set.dart';
import 'com/table_loc_set.dart';
import 'com/table_no_set/table_no_set.dart';
import 'common/common_header.dart';

class GeneralSetting extends StatefulWidget {
  final Function() onBack;
  const GeneralSetting({super.key, required this.onBack});

  @override
  State<GeneralSetting> createState() => _GeneralSettingState();
}

class _GeneralSettingState extends State<GeneralSetting> {
  final pageController = PageController();

  @override
  void initState() {
    // setData();
    super.initState();
  }

  setData() {
    final settingProvider =
        Provider.of<SettingProvider>(context, listen: false);
    settingProvider.getAllSetting();
  }

  @override
  Widget build(BuildContext context) {
    final size = Ssize(context);
    return PageView(
      controller: pageController,
      physics: NeverScrollableScrollPhysics(),
      children: [
        _generalSet(
          size,
        ),
        CategorySet(
          pageController: pageController,
        ),
        BrandSet(
          pageController: pageController,
        ),
        TableLocationSet(
          pageController: pageController,
        ),
        TableNumberSet(
          pageController: pageController,
        ),
        OrderTypeSet(
          pageController: pageController,
        ),
        TaxIESet(
          pageController: pageController,
        ),
        Container(),
        // CatTypeSet(
        //   pageController: pageController,
        // ),
        SubCatSet(
          pageController: pageController,
        ),
        BarCodeSet(
          pageController: pageController,
        ),
        DocketGroupSet(
          pageController: pageController,
        ),
        DiscountSet(pageController: pageController),
        QuickNoteSet(pageController: pageController),
        OrderStatusSet(pageController: pageController)
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
                LN.generalSettings,
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
                        Wrap(
                          spacing: size.getW(10),
                          runSpacing: size.getH(10),
                          children: [
                            // NewCard(
                            //   asset:
                            //       "assets/svg/icons/general/category_types.svg",
                            //   title: "Category Types",
                            //   onTap: () {
                            //     pageController.jumpToPage(7);
                            //   },
                            //   subTitle: "View and manage category types",
                            // ),
                            NewCard(
                              asset: "assets/svg/icons/general/categories.svg",
                              title: LN.categories,
                              onTap: () {
                                pageController.jumpToPage(1);
                              },
                              subTitle: "View and manage categories",
                            ),
                            NewCard(
                              asset:
                                  "assets/svg/icons/general/subcategories.svg",
                              title: "Sub Categories",
                              onTap: () {
                                pageController.jumpToPage(8);
                              },
                              subTitle: "View and manage sub categories",
                            ),
                            if (!GlobalCVP.isServiceStore) ...[
                              NewCard(
                                asset: "assets/svg/icons/general/brand.svg",
                                title: "Brands",
                                onTap: () {
                                  pageController.jumpToPage(2);
                                },
                                subTitle: "View and manage brands",
                              ),
                              if (!GlobalCVP.isRetailStore) ...[
                                NewCard(
                                  asset:
                                      "assets/svg/icons/general/table_location.svg",
                                  title: "Table Locations",
                                  onTap: () {
                                    pageController.jumpToPage(3);
                                  },
                                  subTitle: "View and manage table locations",
                                ),
                                NewCard(
                                  asset:
                                      "assets/svg/icons/general/table_number.svg",
                                  title: "Table Numbers",
                                  onTap: () {
                                    pageController.jumpToPage(4);
                                  },
                                  subTitle: "View and manage table numbers",
                                )
                              ]
                            ],
                            NewCard(
                              asset: "assets/svg/icons/general/ordertypes.svg",
                              title: "Order Types",
                              onTap: () {
                                pageController.jumpToPage(5);
                              },
                              subTitle: "View and manage order types",
                            ),
                            NewCard(
                              asset: "assets/svg/icons/general/tax.svg",
                              title: "Taxes",
                              onTap: () {
                                pageController.jumpToPage(6);
                              },
                              subTitle: "View and manage taxes",
                            ),
                            if (!GlobalCVP.isRetailStore &&
                                !GlobalCVP.isServiceStore)
                              NewCard(
                                asset:
                                    "assets/svg/icons/general/docket_froup.svg",
                                title: "Docket Groups",
                                onTap: () {
                                  pageController.jumpToPage(10);
                                },
                                subTitle: "View and manage docket groups",
                              ),
                            NewCard(
                              title: LN.discounts,
                              onTap: () {
                                pageController.jumpToPage(11);
                              },
                              asset: "assets/svg/icons/general/tax.svg",
                              subTitle: "View and manage discounts",
                            ),
                            NewCard(
                              title: "Quick Notes",
                              onTap: () {
                                pageController.jumpToPage(12);
                              },
                              asset:
                                  "assets/svg/icons/general/docket_froup.svg",
                              subTitle: "View and manage quick notes",
                            ),
                            NewCard(
                              title: "Manage Order Status",
                              onTap: () {
                                pageController.jumpToPage(13);
                              },
                              asset:
                                  "assets/svg/icons/general/table_location.svg",
                              subTitle:
                                  "Manage the available order statuses for POS",
                            )
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

class SettingsTabRow extends StatelessWidget {
  final PageController pageController;
  final TabController tabController;
  final String addTitle;
  final String viewTitle;
  final Function(int)? onTap;
  const SettingsTabRow({
    super.key,
    required this.pageController,
    required this.tabController,
    required this.addTitle,
    required this.viewTitle,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return CommonHeader(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          IconButton(
              onPressed: () {
                pageController.jumpToPage(0);
              },
              icon: Icon(Icons.arrow_back)),
          IntrinsicWidth(
            child: Align(
              alignment: Alignment.topLeft,
              child: TabBar(
                controller: tabController,
                indicatorSize: TabBarIndicatorSize.label,
                // tabAlignment: TabAlignment.center,
                labelStyle: TextStyle(
                  fontSize: Ssize(context).getS(18),
                  fontFamily: kFontFMedium,
                ),
                labelColor: Colors.black,
                tabs: [
                  Tab(text: viewTitle),
                  Tab(text: addTitle),
                ],
                onTap: onTap,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class GSTextSection extends StatelessWidget {
  final String title;
  final Function()? onTap;
  final List<String> list;
  final String hintText;
  final int? indexVal;
  final Function(int?)? onChanged;
  final bool isReq;
  final double? width;
  final Widget? sufIcon;
  const GSTextSection({
    super.key,
    required this.title,
    this.onTap,
    required this.list,
    this.hintText = "",
    this.onChanged,
    this.indexVal,
    this.isReq = false,
    this.width,
    this.sufIcon,
  });

  @override
  Widget build(BuildContext context) {
    final size = Ssize(context);
    final double widthh = width ?? size.width / 3;
    return SizedBox(
      width: widthh,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text.rich(
                TextSpan(
                    text: title,
                    style: TextStyle(
                      fontSize: size.getS(16),
                      color: Colors.black,
                      fontFamily: kFontFMedium,
                    ),
                    children: isReq
                        ? [
                            TextSpan(
                              text: " *",
                              style: TextStyle(
                                fontSize: size.getS(18),
                                color: Colors.red,
                              ),
                            )
                          ]
                        : null),
              ),
              if (onTap != null)
                InkWell(
                  onTap: onTap,
                  child: CircleAvatar(
                    backgroundColor: Colors.black,
                    radius: size.getW(12),
                    child: Icon(
                      Icons.add,
                      color: Colors.white,
                      size: size.getS(18),
                    ),
                  ),
                )
            ],
          ),
          SizedBox(
            height: size.getH(6),
          ),
          DropDownList(
            list: list,
            hint: hintText,
            indexValue: indexVal,
            onChange: onChanged,
            isReq: isReq,
            borderColor: Colors.black54,
            borderRadius: 5,
            vPad: 8,
            hPad: 12,
            sufIcon: sufIcon,
          ),
        ],
      ),
    );
  }
}
