import 'package:flutter/material.dart';
import 'package:pos_account/screens/home_screen/com/items/tabs/product_tab/com/new_product/com/recent_add_product/recent_add_p.dart';

import '../../../../../../providers/cus_val_pro.dart';
import 'com/add_service.dart';

class ServiceTab extends StatefulWidget {
  const ServiceTab({super.key});

  @override
  State<ServiceTab> createState() => _ServiceTabState();
}

class _ServiceTabState extends State<ServiceTab>
    with SingleTickerProviderStateMixin {
  late final PageController _pageCltr;
  late final TabController _tabCltr;

  @override
  void initState() {
    super.initState();
    _pageCltr = PageController();
    _tabCltr = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _pageCltr.dispose();
    _tabCltr.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TabBarView(
      physics: NeverScrollableScrollPhysics(),
      controller: _tabCltr,
      children: [
        RecentAddedProducts(
          addNewProduct: () {
            _tabCltr.animateTo(1);
          },
          onBack: () {
            GlobalCVP.setMainPage = MainPage.ManagePage;
          },
        ),
        ServiceAddUp(
          onBack: () {
            _tabCltr.animateTo(0);
          },
        ),
      ],
    );
  }
}
