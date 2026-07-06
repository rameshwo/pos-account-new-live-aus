import 'package:flutter/material.dart';
import 'package:pos_account/config/size_config.dart';
import 'package:pos_account/screens/home_screen/com/items/tabs/product_tab/com/raw_ingre/raw_ingre_section.dart';
import '../../../../../../providers/cus_val_pro.dart';
import '../../../../../../widgets/title_pop.dart';
import '../setting_tab/com/general/common/common_header.dart';
import '../setting_tab/com/setting_section.dart';
import 'com/combo/combo_screen.dart';
import 'com/manage_menu/manage_menu_screen.dart';
import 'com/modifier/modifier_screen.dart';
import 'com/new_product/com/dialog/barcode_gen_dia.dart';
import 'com/new_product/com/product_list_page.dart';

class ProductTab extends StatefulWidget {
  const ProductTab({super.key});

  @override
  ProductTabState createState() => ProductTabState();
}

class ProductTabState extends State<ProductTab>
    with SingleTickerProviderStateMixin {
  late final TabController _tabCltr;

  @override
  void initState() {
    super.initState();
    _tabCltr = TabController(length: 1 + cardWidgets.length, vsync: this);
  }

  @override
  void dispose() {
    _tabCltr.dispose();
    super.dispose();
  }

  List<SettingCardWidget> get cardWidgets => <SettingCardWidget>[
        SettingCardWidget(
          id: 1,
          title: "Products",
          subTitle: "View, add, and update products in your catalog.",
          asset: "assets/png/product.png",
          screenWidget: ProductListPage(
            onBack: () {
              _tabCltr.animateTo(0);
            },
          ),
        ),
        if (GlobalCVP.isHospitality)
          SettingCardWidget(
            id: 2,
            title: "Combo/Deals",
            subTitle:
                "Manage combo products, including adding and updating bundles.",
            asset: "assets/png/combo.png",
            screenWidget: ComboScreen(
              onBackMain: () {
                _tabCltr.animateTo(0);
              },
            ),
          ),
        if (GlobalCVP.isHospitality)
          SettingCardWidget(
            id: 2,
            title: "Tag Modifiers",
            subTitle:
                "Assign modifiers to your products to allow customization options during ordering.",
            asset: "assets/png/modifier.png",
            screenWidget: ModifierScreen(
              onBack: () {
                _tabCltr.animateTo(0);
              },
            ),
          ),
        if (!GlobalCVP.isServiceStore)
          SettingCardWidget(
            id: 3,
            title: "Raw Ingredient",
            subTitle: "Add, update, and organize ingredient items efficiently.",
            asset: "assets/png/raw.png",
            screenWidget: RawIngreSection(
              onBack: () {
                _tabCltr.animateTo(0);
              },
            ),
          ),
        if (!GlobalCVP.isServiceStore)
          SettingCardWidget(
            id: 4,
            title: "Barcode Generator",
            subTitle:
                "Search and select products, generate barcodes, and print them for labeling.",
            asset: "assets/png/barcode.png",
            screenWidget: BarCodeGenDia(
              onBack: () {
                _tabCltr.animateTo(0);
              },
            ),
          ),
        if (!GlobalCVP.isServiceStore)
          SettingCardWidget(
            id: 5,
            title: "Manage Menu",
            subTitle:
                "Organize your menu by sorting items with easy drag-and-drop to quickly adjust layout and order.",
            asset: "assets/svg/icons/general.svg",
            screenWidget: ManageMenuScreen(
              onBack: () {
                _tabCltr.animateTo(0);
              },
            ),
          ),
      ];

  @override
  Widget build(BuildContext context) {
    final size = Ssize(context);
    return DefaultTabController(
      length: 1 + cardWidgets.length,
      child: TabBarView(
        physics: NeverScrollableScrollPhysics(),
        controller: _tabCltr,
        children: [
          _header(
            size,
            cardList: cardWidgets,
            onTap: (int i) {
              _tabCltr.animateTo(i + 1);
            },
          ),
          ...List.generate(
              cardWidgets.length, (i) => cardWidgets[i].screenWidget)
          // if (cardWidgets.any((e) => e.id == _tabIndex))
          //   cardWidgets.firstWhere((e) => e.id == _tabIndex).screenWidget,
        ],
      ),
    );
  }

  Widget _header(
    Ssize size, {
    required List<SettingCardWidget> cardList,
    required Function(int) onTap,
  }) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CommonHeader(
            child: TitlePop(
              title: "Inventory",
              size: Ssize(context),
              onTap: () {
                GlobalCVP.setMainPage = MainPage.ManagePage;
              },
            ),
          ),
          SizedBox(
            height: size.getH(8),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: size.getW(12)),
            child: Wrap(
              spacing: size.getW(12),
              runSpacing: size.getH(12),
              children: List.generate(
                cardList.length,
                (index) => SettingCard(
                  title: cardList[index].title,
                  asset: cardList[index].asset,
                  subTitle: cardList[index].subTitle,
                  onTap: () => onTap(index),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
