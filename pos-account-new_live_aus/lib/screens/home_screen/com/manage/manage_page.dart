import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pos_account/config/encrypt_config.dart';
import 'package:pos_account/config/utils/menu_schedule_utils.dart';
import 'package:pos_account/config/utils/promo_utils.dart';
import 'package:pos_account/config/size_config.dart';
import 'package:pos_account/env.dart';
import 'package:pos_account/model/home/menu/place_order/pos_res/pos_cat_res.dart';
import 'package:pos_account/providers/menu/payment_pro.dart';
import 'package:pos_account/providers/menu/place_order_pro.dart';
import 'package:pos_account/providers/menu/pos_retail_pro.dart';
import 'package:pos_account/services/signal_core/signalr_core.dart';
import 'package:pos_account/services/web_view/inapp_web_screen.dart';
import 'package:pos_account/widgets/load_btn.dart';
import 'package:pos_account/widgets/loading.dart';
import 'package:provider/provider.dart';
import '../../../../constant/constant.dart';
import '../../../../ln.dart';
import '../../../../providers/auth/auth_pro.dart';
import '../../../../providers/cus_val_pro.dart';
import '../../../../providers/z_multi_pro.dart';
import '../../../../repository/if_exception.dart';
import '../../../../services/database/database/db_local_data.dart';
import '../../../../widgets/dialog/confirm_dialog.dart';
import '../../../../widgets/dialog/loading_dia.dart';
import '../header_section.dart';

class ManageScreen extends StatefulWidget {
  final PageController? pageController;
  const ManageScreen({
    super.key,
    this.pageController,
  });

  @override
  State<ManageScreen> createState() => _ManageScreenState();
}

class _ManageScreenState extends State<ManageScreen> {
  final _totalSteps = [
    "Fetching synchronized data",
    "Retrieving device details",
    "Loading all products",
    "Fetching menu scheduling data",
    "Finalizing setup",
  ];

  int _completedSteps = 0;
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    final placeOrderPro = Provider.of<PlaceOrderPro>(context);
    final _authProvider = Provider.of<AuthProvider>(context);
    final cvp = GlobalCVP;
    final posPro = Provider.of<PosRetailPro>(context);
    return LoadingDialog(
      totalSteps: _totalSteps,
      completedSteps: _completedSteps,
      onDone: () {
        _isLoading = false;
        placeOrderPro.notify;
      },
      isLoading: _isLoading,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (cvp.getMainPage != MainPage.SubscriptionPlanPage)
            HeaderSection(
              cvp: cvp,
              // showEndDrawer: cvp.tabs.isNotEmpty &&
              //     cvp.tabs.length > cvp.currentPage &&
              //     (cvp.tabs[cvp.currentPage].title == LN.pos ||
              //         cvp.tabs[cvp.currentPage].title == "Keypad") &&
              //     cvp.viewWidget.viewPosModule,
              placeOrderPro: placeOrderPro,
            ),
          // SizedBox(height: size.getH(12)),
          Card(
            child: BakeryInfoCard(
              onTap: () async {
                if (GlobalCVP.storeList.isEmpty) {
                  final _storeListDb = await DbLocalData.getAllStores();
                  if (_storeListDb?.userStores != null) {
                    GlobalCVP.storeList.addAll(_storeListDb!.userStores!);
                  }
                }

                if (GlobalCVP.currentStore == null ||
                    GlobalCVP.storeList.isEmpty) return;

                final _selectedStore = GlobalCVP.storeList.firstWhere((a) =>
                    a.id?.toLowerCase() ==
                    GlobalCVP.currentStore?.id?.toLowerCase());

                GlobalCVP.storeList.removeWhere((a) =>
                    a.id?.toLowerCase() ==
                    GlobalCVP.currentStore?.id?.toLowerCase());

                GlobalCVP.storeList.insert(0, _selectedStore);

                final _mediaQuerySize = MediaQuery.of(context).size;
                showCupertinoDialog(
                    context: context,
                    builder: (_) {
                      return SimpleDialog(
                        insetPadding: EdgeInsets.zero,
                        contentPadding: EdgeInsets.zero,
                        titlePadding: EdgeInsets.zero,
                        children: [
                          if (mounted)
                            SizedBox(
                              height: _mediaQuerySize.height * 0.9,
                              width: _mediaQuerySize.width * 0.5,
                              child: storeContainer(
                                context: context,
                                placeOrderPro: placeOrderPro,
                              ),
                            )
                        ],
                      );
                    });
                // showCupertinoModalPopup(
                //   context: context,
                //   builder: (BuildContext context) {
                //     return Padding(
                //       padding: const EdgeInsets.only(top: 0.0),
                //       child: SizedBox(
                //         height: MediaQuery.of(context).size.height * 0.8,
                //         width: MediaQuery.of(context).size.width * 0.5,
                //         child: storeContainer(
                //           context: context,
                //           placeOrderPro: placeOrderPro,
                //         ),
                //       ),
                //     );
                //   },
                // );
              },
            ),
          ),
          Expanded(
            child: Card(
              child: ListView(
                padding: const EdgeInsets.symmetric(vertical: 8),
                children: [
                  MenuListItem(
                      icon: Icons.help_outline_rounded,
                      title: "Have any issues?",
                      color: kSecondaryColor,
                      trail: LoadButton(
                        btnText: LN.refresh,
                        vPad: 8,
                        hPad: 8,
                        width: 100,
                        onsave: () async {
                          _completedSteps = 0;
                          _isLoading = true;

                          if (GlobalCVP.isRetailStore) {
                            posPro.pageLoad = true;

                            posPro.selectedCatId = "";
                            posPro.selectedBrandId = "";
                            posPro.searchCltr.clear();
                            posPro.notify;
                          } else {
                            placeOrderPro.loading = true;
                            placeOrderPro.notify;
                            placeOrderPro.selectedCatId = "";
                            placeOrderPro.categoryTitle = null;
                            placeOrderPro.selectedAlpha = null;
                            placeOrderPro.selectedSubCatIndex = null;
                            placeOrderPro.searchCltr.clear();
                            placeOrderPro.brandIndex = null;
                            placeOrderPro.promoId = null;
                          }
                          // Loading.dialog(
                          //   context,
                          //   title: "Refreshing ..",
                          //   width: 200,
                          //   height: 200,
                          // );

                          await GlobalCVP.getAllAddSection(isServerCall: true);
                          _completedSteps = 1;
                          placeOrderPro.notify;

                          await GlobalCVP.getDeviceDetailById();
                          _completedSteps = 2;
                          placeOrderPro.notify;

                          if (GlobalCVP.isRetailStore) {
                            await posPro.getAllRetailProducts(
                                isServerCall: true);
                            placeOrderPro.getCusAddSec();

                            _completedSteps = 3;
                            placeOrderPro.notify;

                            await posPro
                                .getOrderAddSection(placeOr: placeOrderPro)
                                .then((value) => posPro.getAllPromotions());

                            posPro.pageLoad = false;
                            placeOrderPro.loading = false;
                            posPro.itemViewType = ItemViewType.product;
                          } else {
                            await placeOrderPro.getAllProducts(
                                isServerCall: true);

                            _completedSteps = 3;
                            placeOrderPro.notify;

                            MenuScheduleUtils.listen((slot) async {
                              placeOrderPro.menuslot = slot;
                              placeOrderPro.getItemData();
                            });

                            _completedSteps = 4;
                            placeOrderPro.notify;

                            placeOrderPro.getOrderAddSection().then(
                                (value) => placeOrderPro.getAllPromotions());
                            placeOrderPro.setOrderNotes();
                            placeOrderPro.getCusAddSec();
                          }

                          if (mounted) {
                            final _payPro =
                                Provider.of<PaymentPro>(context, listen: false);
                            _payPro.getData(
                                // initLoad: true
                                );
                          }

                          // if (mounted && Navigator.canPop(context)) {
                          //   Navigator.pop(context);
                          // }

                          if (GlobalCVP.isRetailStore) {
                            posPro.getItemData();
                            posPro.notify;
                          } else {
                            placeOrderPro.init();
                          }

                          _completedSteps = 5;
                          placeOrderPro.notify;
                        },
                      )

                      // onTap: () {},
                      ),
                  MenuListItem(
                    icon: Icons.person_outline,
                    title: LN.profile,
                    onTap: () {
                      GlobalCVP.setMainPage = MainPage.ProfilePage;
                    },
                  ),
                  if (GlobalCVP.viewWidget.viewProductModule &&
                      !GlobalCVP.isServiceStore)
                    MenuListItem(
                      icon: Icons.storefront_outlined,
                      title: "Inventory",
                      onTap: () {
                        GlobalCVP.setMainPage = MainPage.ProductPage;
                      },
                    ),
                  if (GlobalCVP.viewWidget.viewProductModule &&
                      GlobalCVP.isServiceStore)
                    MenuListItem(
                      icon: Icons.storefront_outlined,
                      title: "Inventory",
                      onTap: () {
                        GlobalCVP.setMainPage = MainPage.ServicePage;
                      },
                    ),

                  MenuListItem(
                    icon: Icons.attach_money_outlined,
                    title: LN.billsNSubs,
                    onTap: () {
                      GlobalCVP.pathOfSubsBills = PathOfSubsBills.InApp;
                      GlobalCVP.setMainPage = MainPage.SubscriptionPlanPage;
                    },
                  ),
                  MenuListItem(
                    icon: Icons.web,
                    title: "Switch to Web",
                    onTap: () async {
                      final _loginData = await EncryptConfig.getEncLoginData();
                      if (_loginData == null) return;

                      final _url =
                          '${AppEnviro.adminUrl}login-with-tab?email=${_loginData.email}&&password=${_loginData.encPassword}';
                      // kPrint(_url);
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (ctx) => InAppWebViewScreen(
                                  transparentBackground: false,
                                  showBackButton: true,
                                  directBackToApp: true,
                                  webContent: WebContent(
                                    title: "",
                                    url: _url,
                                  ))));
                    },
                  ),
                  MenuListItem(
                    icon: Icons.card_giftcard_outlined,
                    title: LN.giftCard,
                    onTap: () async {
                      if (GlobalCVP.getMainPage != MainPage.GiftCardPage)
                        GlobalCVP.setMainPage = MainPage.GiftCardPage;
                      else
                        GlobalCVP.setMainPage = MainPage.HomePage;
                    },
                  ),
                  // MenuListItem(
                  //   icon: Icons.call_outlined,
                  //   title: 'Recent Calls',
                  //   onTap: () {
                  //     if (GlobalCVP.getMainPage != MainPage.RecentCallPage)
                  //       GlobalCVP.setMainPage = MainPage.RecentCallPage;
                  //     if (widget.pageController != null &&
                  //         widget.pageController!.page != 0) {}
                  //   },
                  // ),

                  MenuListItem(
                    icon: Icons.settings_outlined,
                    title: LN.settings,
                    onTap: () {
                      GlobalCVP.setMainPage = MainPage.SettingsPage;
                    },
                  ),
                  // if (viewWidget.viewSyncModule) LN.sync,
                  // if (viewWidget.viewEodModule) LN.eod,
                  // if (viewWidget.viewAccountingIntegrationModule) LN.integration,
                  if (GlobalCVP.viewWidget.viewAccountingIntegrationModule)
                    MenuListItem(
                      icon: Icons.integration_instructions_outlined,
                      title: LN.integration,
                      onTap: () {
                        GlobalCVP.setMainPage = MainPage.IntegrationPage;
                      },
                    ),

                  if (GlobalCVP.viewWidget.viewEodModule)
                    MenuListItem(
                      icon: Icons.data_exploration_outlined,
                      title: LN.eod,
                      onTap: () {
                        GlobalCVP.setMainPage = MainPage.EODPage;
                      },
                    ),
                  if (GlobalCVP.viewWidget.viewSyncModule)
                    MenuListItem(
                      icon: Icons.sync_outlined,
                      title: LN.sync,
                      onTap: () {
                        GlobalCVP.setMainPage = MainPage.SyncPage;
                      },
                    ),
                  MenuListItem(
                    icon: Icons.dashboard,
                    title: "Report",
                    onTap: () {
                      GlobalCVP.setMainPage = MainPage.Report;
                    },
                  ),
                  MenuListItem(
                    icon: Icons.logout_outlined,
                    title: LN.logout,
                    onTap: () {
                      showDialog(
                          context: context,
                          builder: (builder) => ConfirmDialog(
                                title: LN.logout,
                                subTitle: LN.sureToLogout,
                                actionText: LN.logout,
                                onDelete: () async {
                                  _authProvider.logOut();
                                  return null;
                                },
                              ));
                    },
                  ),
                  // MenuListItem(
                  //   icon: Icons.attach_money_outlined,
                  //   title: "WebView",
                  //   onTap: () {
                  //     Navigator.push(
                  //         context,
                  //         MaterialPageRoute(
                  //             builder: (ctx) => InAppWebViewScreen(
                  //                 transparentBackground: false,
                  //                 showBackButton: true,
                  //                 webContent: WebContent(
                  //                   title: "POSApt",
                  //                   url: "https://uatapp.posapt.au/",
                  //                 ))));
                  //   },
                  // ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget storeContainer({
    required BuildContext context,
    required PlaceOrderPro placeOrderPro,
  }) {
    final size = Ssize(context);
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      padding:
          EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(height: size.getH(16.0)),
          // Padding(
          //   padding: EdgeInsets.only(top: size.getH(16.0)),
          //   child: Center(
          //     child: Container(
          //       width: size.getW(40),
          //       height: size.getH(4),
          //       decoration: BoxDecoration(
          //         color: Colors.grey[400],
          //         borderRadius: BorderRadius.circular(2),
          //       ),
          //     ),
          //   ),
          // ),
          Padding(
            padding: EdgeInsets.fromLTRB(
                size.getW(24), size.getH(12), size.getW(24), 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Select Store',
                  style: CupertinoTextThemeData(
                    textStyle: TextStyle(
                      fontSize: size.getS(18),
                      fontWeight: FontWeight.w500,
                    ),
                  ).navLargeTitleTextStyle.copyWith(
                        color: Colors.black,
                      ),
                ),
                CupertinoButton(
                  padding: EdgeInsets.zero,
                  child: Icon(CupertinoIcons.xmark),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
          ),
          Flexible(
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: GlobalCVP.storeList.length,
              itemBuilder: (context, index) {
                final store = GlobalCVP.storeList[index];
                final _selected = GlobalCVP.currentStore?.id?.toLowerCase() ==
                    store.id?.toLowerCase();
                return Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: size.getW(24), vertical: size.getH(8)),
                  child: CupertinoButton(
                    padding: EdgeInsets.zero,
                    onPressed: () {
                      Navigator.pop(context);
                      _changeStore(CUS_CTX!,
                          id: store.id, placeOrderPro: placeOrderPro);
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: _selected
                            ? kPrimaryColor.withOpacity(0.25)
                            : Colors.white,
                        border: Border.all(color: Colors.grey[300]!),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: size.getW(8.0),
                            vertical: size.getH(_selected ? 12 : 8)),
                        child: Row(
                          children: [
                            Container(
                              width: size.getS(50),
                              height: size.getS(50),
                              decoration: BoxDecoration(
                                color: Colors.grey[200],
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Center(
                                child: Text(
                                  store.name?.substring(0, 2).toUpperCase() ??
                                      'NA',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: size.getS(18),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(width: size.getW(16)),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    store.name ?? 'Unnamed Store',
                                    style: TextStyle(
                                      fontSize: size.getS(20),
                                      fontWeight: FontWeight.w500,
                                      color: Colors.black,
                                    ),
                                  ),
                                  // SizedBox(height: size.getH(4)),
                                  // Row(
                                  //   children: [
                                  //     Container(
                                  //       decoration: BoxDecoration(
                                  //         color: store.isStoreActive == true
                                  //             ? Colors.green[300]
                                  //             : Colors.red[300],
                                  //         borderRadius:
                                  //             BorderRadius.circular(4),
                                  //       ),
                                  //       padding: EdgeInsets.symmetric(
                                  //         horizontal: size.getW(16),
                                  //         vertical: size.getH(4),
                                  //       ),
                                  //       child: Text(
                                  //         store.isStoreActive == true
                                  //             ? 'Active'
                                  //             : 'Inactive',
                                  //         style: TextStyle(
                                  //             fontSize: size.getS(14),
                                  //             color: Colors.white,
                                  //             fontFamily: kFontFMedium),
                                  //       ),
                                  //     ),
                                  //   ],
                                  // ),
                                ],
                              ),
                            ),
                            // Action icon
                            Container(
                              width: size.getS(40),
                              height: size.getS(40),
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey[300]!),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Icon(
                                CupertinoIcons.forward,
                                color: Colors.black54,
                                size: size.getS(24),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          // Bottom buttons
          Padding(
            padding: EdgeInsets.all(size.getS(24.0)),
            child: CupertinoButton(
              minSize: 0,
              onPressed: () {
                GlobalCVP.setMainPage = MainPage.NewOrgPage;
                Navigator.pop(context);
              },
              color: kSecondaryColor,
              borderRadius: BorderRadius.circular(8),
              padding: EdgeInsets.symmetric(
                  vertical: size.getH(16), horizontal: size.getW(24)),
              child: Text(
                LN.addNewOrg,
                style: TextStyle(
                  fontSize: size.getS(16),
                  fontFamily: kFontFMedium,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _changeStore(BuildContext context,
      {required String? id, required PlaceOrderPro placeOrderPro}) {
    Loading.dialog(
      context,
      title: "Switching store",
      width: 200,
      height: 200,
    );
    placeOrderPro.onChangeStore(storeId: id).then((_store) async {
      GlobalCVP.currentStore = _store;

      if (Navigator.canPop(context)) {
        Navigator.pop(context);
      }
      if (_store != null) {
        GlobalCVP.permissionLoad = true;
        GlobalCVP.setCurrentPage(0);
        PromoUtils.clear();
        MultiPro.reset;
        await DbLocalData.clear(isAuth: false);
        await SignalRCore.stop();
        // placeOrderPro.clear();
        // placeOrderPro.clearInitData();

        // await DbLocalData.deleteMenuRes();

        IfException.showMessage(
            message: LN.storeChangedSuccess, isError: false);

        Navigator.pushNamedAndRemoveUntil(
          context,
          '/splash-screen',
          (route) => false,
          arguments: LN.storeChangedSuccess,
        );
      } else {
        // GlobalCVP.selectedStore = _previousIndex;
        GlobalCVP.notify;
      }
    });
  }
}

class BakeryInfoCard extends StatelessWidget {
  final Function() onTap;
  const BakeryInfoCard({
    super.key,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final size = Ssize(context);
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(size.getS(16.0)),
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(color: Colors.grey[200]!),
            bottom: BorderSide(color: Colors.grey[200]!),
          ),
        ),
        child: Row(
          children: [
            // BA Circle
            Container(
              width: size.getS(48),
              height: size.getS(48),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Center(
                child: Text(
                  GlobalCVP.currentStore != null
                      ? GlobalCVP.currentStore!.name!
                          .substring(0, 2)
                          .toUpperCase()
                      : 'NA',
                  style: TextStyle(
                    fontSize: size.getS(16),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            SizedBox(width: size.getW(12)),
            // Bakery Info
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  (GlobalCVP.currentStore?.name?.isNotEmpty ?? false)
                      ? GlobalCVP.currentStore!.name!
                      : 'Unnamed Store',
                  style: TextStyle(
                    fontSize: size.getS(18),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                // SizedBox(height: size.getH(4)),
                // Row(
                //   children: [
                //     Container(
                //       padding: EdgeInsets.symmetric(
                //           horizontal: size.getW(8), vertical: size.getW(6)),
                //       decoration: BoxDecoration(
                //         color: GlobalCVP.selectedStore != null
                //             ? GlobalCVP.storeList[GlobalCVP.selectedStore!]
                //                         .isStoreActive ??
                //                     false
                //                 ? Colors.green[300]
                //                 : Colors.red[300]
                //             : Colors.grey[200],
                //         borderRadius: BorderRadius.circular(4),
                //       ),
                //       child: Text(
                //         GlobalCVP.selectedStore != null
                //             ? GlobalCVP.storeList[GlobalCVP.selectedStore!]
                //                         .isStoreActive ??
                //                     false
                //                 ? 'Active'
                //                 : 'Inactive'
                //             : 'Inactive',
                //         style: TextStyle(
                //             fontSize: size.getS(12),
                //             fontWeight: FontWeight.w500,
                //             color: Colors.white),
                //       ),
                //     ),
                //     //  SizedBox(width: size.getW(8)),
                //     // Container(
                //     //   padding:  EdgeInsets.symmetric(
                //     //       horizontal: size.getW(8), vertical: size.getH(4)),
                //     //   decoration: BoxDecoration(
                //     //     color: Colors.grey[200],
                //     //     borderRadius: BorderRadius.circular(4),
                //     //   ),
                //     //   child:  Text(
                //     //     'Role: SuperAdmin',
                //     //     style: TextStyle(
                //     //       fontSize: size.getS(12),
                //     //       fontWeight: FontWeight.w500,
                //     //     ),
                //     //   ),
                //     // ),
                //   ],
                // ),
              ],
            ),
            const Spacer(),
            // RefreshBtn(
            //   size: size,
            //   onTap: GlobalCVP.loadGetstoreDetail
            //       ? null
            //       : () async {
            //           // BusinessType _businessType = cvp.businessType;
            //           GlobalCVP.loadGetstoreDetail = true;
            //           GlobalCVP.notify;
            //           GlobalCVP.jumpToTabOnSetPage = false;
            //           await GlobalCVP.getStoreDetails();
            //           await GlobalCVP.getAllUserPermission(isFromLocal: false);
            //           final _screenSavPro =
            //               Provider.of<ScreenSaverPro>(context, listen: false);
            //           _screenSavPro.setInterval(
            //               GlobalCVP.deviceDetailRes?.screenSaverLogoffInterval);

            //           GlobalCVP.jumpToTabOnSetPage = true;
            //           // if (_businessType != cvp.businessType &&
            //           //     cvp.tabCltrFunction != null) {

            //           // }
            //         },
            // ),

            // SizedBox(width: size.getW(24)),

            Icon(
              Icons.keyboard_arrow_down,
              color: Colors.grey[600],
              size: size.getS(24),
            ),
          ],
        ),
      ),
    );
  }
}

class MenuListItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final bool hasNewTag;
  final Function()? onTap;
  final Widget? trail;
  final Color? color;

  const MenuListItem({
    super.key,
    required this.icon,
    required this.title,
    this.hasNewTag = false,
    this.onTap,
    this.trail,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final size = Ssize(context);
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(
            horizontal: size.getW(16),
            vertical: size.getW(trail != null ? 6 : 12)),
        decoration: BoxDecoration(
          color: color?.withOpacity(0.15),
          border: Border(
            bottom: BorderSide(color: Colors.grey[200]!),
          ),
        ),
        child: Row(
          children: [
            Icon(icon, size: size.getS(24), color: color ?? Colors.grey[800]),
            SizedBox(width: size.getW(12)),
            Text(
              title,
              style: TextStyle(
                fontSize: size.getS(18),
                fontWeight: color != null ? FontWeight.bold : FontWeight.w500,
                color: color,
              ),
            ),
            const Spacer(),
            trail ??
                Icon(
                  Icons.chevron_right,
                  color: Colors.grey[400],
                  size: size.getS(30),
                ),
          ],
        ),
      ),
    );
  }
}
