import 'package:flutter/material.dart';
import 'package:pos_account/config/size_config.dart';
import 'package:pos_account/constant/constant.dart';
import 'package:pos_account/ln.dart';
import 'package:pos_account/providers/cus_val_pro.dart';
import 'package:pos_account/providers/menu/place_order_pro.dart';
import 'package:pos_account/screens/home_screen/com/items/tabs/dashboard/dashboard.dart';
import 'package:pos_account/screens/home_screen/com/items/tabs/end_of_day_tab/end_of_day_tab.dart';
import 'package:pos_account/screens/home_screen/com/items/tabs/integration_tab/integration_tab.dart';
import 'package:pos_account/screens/home_screen/com/items/tabs/service_tab/service_tab.dart';
import 'package:pos_account/screens/home_screen/com/items/tabs/sync_tab.dart';
import 'package:pos_account/screens/home_screen/com/subscription/subs_screen.dart';
import 'package:pos_account/services/uber/delivery/view/track_delivery/track_delivery_view.dart';
import 'package:provider/provider.dart';
import '../../../config/dual_display/dual_display_config.dart';
import '../../custom_drawer/custom_drawer.dart';
import 'add_organization/add_organization.dart';
import 'gift_card_screen/gift_card_screen.dart';
import 'header/punch_in_out/punch_lock_screen.dart';
import 'items/item_section.dart';
import 'items/sidebar/sidebar_section/sidebar_section.dart';
import 'items/tabs/product_tab/product_tab.dart';
import 'items/tabs/setting_tab/setting_tab.dart';
import 'notification/notification_page.dart';
import 'pos_orders/pos_orders_section.dart';
import 'profile/profile_screen.dart';
import 'recent_call/recent_call_page.dart';
import 'table_arrange/table_arrange.dart';

class SubHome extends StatelessWidget {
  const SubHome({
    super.key,
    required this.cvp,
    required GlobalKey<ScaffoldState> scafKey,
    required this.homeProfilePageCltr,
  }) : _scafKey = scafKey;

  final CusValuePro cvp;
  final GlobalKey<ScaffoldState> _scafKey;
  final PageController homeProfilePageCltr;

  @override
  Widget build(BuildContext context) {
    final isFlexLand = ((cvp.tabs.isNotEmpty &&
            cvp.tabs.length > cvp.currentPage &&
            cvp.tabs[cvp.currentPage].title != LN.pos &&
            cvp.tabs[cvp.currentPage].title != "Keypad") ||
        cvp.getMainPage == MainPage.OrderPage ||
        cvp.getMainPage == MainPage.GiftCardPage ||
        cvp.getMainPage == MainPage.PunchInOutPage ||
        cvp.getMainPage == MainPage.NotificationPage ||
        cvp.getMainPage == MainPage.RecentCallPage ||
        cvp.getMainPage == MainPage.DeliveryPage ||
        !cvp.viewWidget.viewPosModule);
    final size = Ssize(context);
    final placeOrderPro = Provider.of<PlaceOrderPro>(context);

    return PageView(
      physics: const NeverScrollableScrollPhysics(),
      controller: GlobalCVP.PageCltr,
      onPageChanged: (index) {
        cvp.setCurrentPage(index);
        placeOrderPro.showManageTab = false;
        placeOrderPro.notify;
      },
      children: List.generate(
        cvp.tabs.length,
        (index) => Row(
          children: [
            Expanded(
              flex: isFlexLand
                  ? kFlexLeft + kFlexMiddleProt
                  : kFlexLeft + kFlexMiddleLand,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        !size.isProt &&
                                !cvp.DontShowLeftSide &&
                                cvp.tabs.isNotEmpty &&
                                cvp.tabs.length > cvp.currentPage &&
                                ((cvp.tabs[cvp.currentPage].title !=
                                    LN.floorPlan)) &&
                                !placeOrderPro.showManageTab &&
                                cvp.tabs[cvp.currentPage].title != "Manage" &&
                                cvp.tabs[cvp.currentPage].title !=
                                    "Kitchen Display"
                            ? Expanded(
                                flex: kFlexLeft,
                                child: CustomDrawer(
                                  homeProfilePageCltr: homeProfilePageCltr,
                                ))
                            : SizedBox.shrink(),
                        Expanded(
                          flex: isFlexLand ? kFlexMiddleProt : kFlexMiddleLand,
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: size.getW(0),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Flexible(
                                  child: AnimatedSwitcher(
                                    duration: const Duration(milliseconds: 500),
                                    transitionBuilder: (child, animation) =>
                                        FadeTransition(
                                      opacity: animation,
                                      child: child,
                                    ),
                                    child: _buildContentForPage(
                                        cvp.currentPage, placeOrderPro),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            (cvp.tabs.isNotEmpty &&
                    cvp.tabs.length > cvp.currentPage &&
                    (cvp.tabs[cvp.currentPage].title == LN.pos ||
                        cvp.tabs[cvp.currentPage].title == "Keypad") &&
                    !size.isProt &&
                    cvp.getMainPage == MainPage.HomePage &&
                    cvp.viewWidget.viewPosModule)
                ? Expanded(
                    flex: kFlexRightLand,
                    child: SideBarSection(
                      scafKey: _scafKey,
                      placeOrder: () async {
                        cvp.setOrPath = PathOfOrder.MENUPATH;
                        cvp.setEndDValue = 1;
                        if (_scafKey.currentState != null) {
                          await Future.delayed(Duration(milliseconds: 300), () {
                            _scafKey.currentState!.openEndDrawer();
                          });
                        }
                      },
                      placeOrderPro: placeOrderPro,
                    ),
                  )
                : SizedBox.shrink(),
          ],
        ),
      ),
    );
  }

  Widget _buildContentForPage(int index, PlaceOrderPro placeOrderPro) {
    // if (cvp.getMainPage != MainPage.HomePage) {
    //   return buildMainPageContent();
    // }
    return ItemsSection(
      key: ValueKey<MainPage>(MainPage.HomePage),
      cvp: cvp,
      scafKey: _scafKey,
      placeOrderPro: placeOrderPro,
      homePageController: homeProfilePageCltr,
    );
  }

  static Widget buildMainPageContent(
    CusValuePro cvp,
    GlobalKey<ScaffoldState> _scafKey,
    PageController homeProfilePageCltr,
  ) {
    switch (cvp.getMainPage) {
      case MainPage.OrderPage:
        return OrdersSection(
          key: ValueKey<MainPage>(MainPage.OrderPage),
          scafKey: _scafKey,
        );
      case MainPage.GiftCardPage:
        return GiftCardScreen(
          key: ValueKey<MainPage>(MainPage.GiftCardPage),
        );
      case MainPage.NotificationPage:
        return NotificationPage(
          key: ValueKey<MainPage>(MainPage.NotificationPage),
        );
      case MainPage.RecentCallPage:
        return RecentCallPage(
          key: ValueKey<MainPage>(MainPage.RecentCallPage),
        );
      case MainPage.DeliveryPage:
        return TrackDeliveryView(
          key: ValueKey<MainPage>(MainPage.DeliveryPage),
        );
      case MainPage.PunchInOutPage:
        return PunchLockScreen(
          key: ValueKey<MainPage>(MainPage.PunchInOutPage),
        );
      case MainPage.SettingsPage:
        return SettingTab(
          pageCltr: homeProfilePageCltr,
          key: ValueKey<MainPage>(MainPage.ManagePage),
        );
      case MainPage.SubscriptionPlanPage:
        return SubscriptionScreen(
          cvp: cvp,
          key: ValueKey<MainPage>(MainPage.SubscriptionPlanPage),
        );
      case MainPage.ProfilePage:
        return ProfileScreen(
          key: ValueKey<MainPage>(MainPage.ProfilePage),
          cvp: cvp,
          homePageCltr: homeProfilePageCltr,
        );
      case MainPage.ProductPage:
        return ProductTab(
          key: ValueKey<MainPage>(MainPage.ProductPage),
        );
      case MainPage.ServicePage:
        return ServiceTab(
          key: ValueKey<MainPage>(MainPage.ServicePage),
        );
      case MainPage.EODPage:
        return EndOfDayTab(
          key: ValueKey<MainPage>(MainPage.EODPage),
          scafKey: _scafKey,
        );
      case MainPage.SyncPage:
        return SyncTab(
          key: ValueKey<MainPage>(MainPage.SyncPage),
        );
      case MainPage.IntegrationPage:
        return IntegrationTab(
          key: ValueKey<MainPage>(MainPage.IntegrationPage),
        );
      case MainPage.Report:
        return Dashboard(
          key: ValueKey<MainPage>(MainPage.Report),
        );

      case MainPage.SubscriptionPage:
        return SubscriptionScreen(
          key: ValueKey<MainPage>(MainPage.SubscriptionPage),
          cvp: cvp,
        );

      // case MainPage.ActivatePosPage:
      //   return ActivateDeviceSec(
      //     key: ValueKey<MainPage>(MainPage.ActivatePosPage),
      //     cvp: cvp,
      //   );

      case MainPage.BookingPage:
        return TableArrangeUI(
          key: ValueKey<MainPage>(MainPage.BookingPage),
          onBack: () {
            cvp.setMainPage = MainPage.SettingsPage;
            Future.delayed(Duration(milliseconds: 300), () {
              cvp.isForBooking = false;
            });
          },
        );

      case MainPage.NewOrgPage:
        return AddNewOrg(
          key: ValueKey<MainPage>(MainPage.NewOrgPage),
          cvp: cvp,
        );

      default:
        {
          if (cvp.tabs.isNotEmpty &&
                  cvp.tabs.length > cvp.currentPage &&
                  cvp.tabs[cvp.currentPage].title ==
                      LN.pos //&& _cvp.isDualMainScreen
              ) {
            if (DualDisplayConfig.adsPattern?.pattern != null &&
                DualDisplayConfig.adsPattern?.pattern != DualDisPattern.none) {
              // print('home_page 300');
              DualDisplayConfig.sendData();
            }
          }

          return SubHome(
            key: ValueKey<MainPage>(MainPage.HomePage),
            cvp: cvp,
            scafKey: _scafKey,
            homeProfilePageCltr: homeProfilePageCltr,
          );
        }
    }
  }
}
