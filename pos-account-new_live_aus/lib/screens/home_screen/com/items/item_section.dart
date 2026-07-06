// import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:pos_account/config/size_config.dart';
import 'package:pos_account/providers/cus_val_pro.dart';
import 'package:pos_account/providers/menu/place_order_pro.dart';
import 'package:pos_account/screens/home_screen/com/kitchen_screen/kitchen_screen.dart';
import 'package:pos_account/widgets/no_items_sec.dart';
import '../../../../ln.dart';
import '../keypad/calculator_section.dart';
import '../manage/manage_page.dart';
import '../pos_orders/pos_orders_section.dart';
import 'tabs/floor_tab/booking_tab/booking_tab.dart';
import 'tabs/floor_tab/table_layout/floor_plan_tab.dart';
import 'tabs/pos_tab/pos_tab_page.dart';

class ItemsSection extends StatelessWidget {
  final CusValuePro cvp;
  final GlobalKey<ScaffoldState>? scafKey;
  final PlaceOrderPro placeOrderPro;
  final PageController homePageController;

  const ItemsSection(
      {required this.cvp,
      this.scafKey,
      required this.placeOrderPro,
      required this.homePageController,
      super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (cvp.tabs.isEmpty)
          SizedBox(
            width: double.infinity,
            child: NoItemsSec(
              size: Ssize(context),
              title: "Please allow user permission to view all screens",
            ),
          )
        else
          Flexible(child: _buildTabPages(context)
              // : AnimatedSwitcher(
              //     duration: Duration(milliseconds: 500),
              //     transitionBuilder: (child, animation) => FadeTransition(
              //       opacity: animation,
              //       child: child,
              //     ),
              //     child: _buildTabPages(context),
              //   ),
              ),
      ],
    );
  }

  Widget _buildTabPages(BuildContext context) {
    final title = cvp.tabs.length > cvp.currentPage
        ? cvp.tabs[cvp.currentPage].title
        : "";
    // if (title == LN.dashboard) {
    //   return Dashboard(key: ValueKey('dashboard_tab'));
    // } else
    if (title == LN.pos) {
      return PosTabPage(
        key: ValueKey('pos_tab'),
        scafKey: scafKey ?? GlobalKey<ScaffoldState>(),
      );
    } else if (title == "Keypad") {
      return CalculatorSection(
        placeOrderPro: placeOrderPro,
        key: ValueKey('keypad_tab'),
        size: Ssize(context),
      );
    } else if (title == LN.orders || title == LN.services) {
      return OrdersSection(
        scafKey: scafKey ?? GlobalKey<ScaffoldState>(),
        key: ValueKey('orders_tab'),
      );
    } else if (title == 'Appointments') {
      return Container(
        key: ValueKey('appointments'),
        child: NoItemsSec(size: Ssize(context), title: "Under Construction"),
      );
    } else if (title == "Kitchen Display") {
      return KitchenScreen(
        key: ValueKey("Kitchen Display"),
        cvp: cvp,
        placeOrderPro: placeOrderPro,
      );
    } else if (title == LN.floorPlan) {
      return FloorPlanTab(
        scafKey: scafKey,
      );
    } else if (title == "Booking") {
      return BookingTab(
        scafKey: scafKey,
      );
    } else if (title == "Manage") {
      return ManageScreen(
        key: ValueKey('manage_tab'),
        pageController: homePageController,
      );
    } else {
      return Container();
    }
  }
}
