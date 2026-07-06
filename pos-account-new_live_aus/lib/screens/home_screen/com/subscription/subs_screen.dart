import 'package:flutter/material.dart';
import 'package:pos_account/config/size_config.dart';
import 'package:pos_account/providers/cus_val_pro.dart';
import 'package:pos_account/providers/subs_billing/sub_billing_pro.dart';
import 'package:pos_account/widgets/loading.dart';
import 'package:provider/provider.dart';
import '../../../../model/billing_and_subs/billing_subs_plan.dart';
import '../../../../widgets/title_pop.dart';
import '../items/tabs/setting_tab/com/general/common/common_header.dart';
import 'billing_subs/billing_subs_screen.dart';
import 'expiry/expiry_screen.dart';

class SubscriptionScreen extends StatefulWidget {
  final CusValuePro cvp;
  const SubscriptionScreen({super.key, required this.cvp});

  @override
  State<SubscriptionScreen> createState() => _SubscriptionScreenState();
}

class _SubscriptionScreenState extends State<SubscriptionScreen> {
  final _pageCltr = PageController();
  SubsBillingPro? _subBillPro;

  @override
  void initState() {
    getData();
    super.initState();
  }

  getData() {
    _subBillPro = Provider.of<SubsBillingPro>(context, listen: false);
    if (_subBillPro != null) {
      _subBillPro?.getSubPlans();
    }
  }

  @override
  void dispose() {
    _subBillPro?.clearListData();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = Ssize(context);
    final subBillPro = Provider.of<SubsBillingPro>(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Stack(
        //   children: [
        //     Padding(
        //       padding: EdgeInsets.only(bottom: size.isProt ? size.getH(40) : 0),
        //       child: HeaderSection(
        //         cvp: widget.cvp,
        //         placeOrderPro: widget.placeOrderPro,
        //         showEndDrawer: false,
        //       ),
        //     ),
        //     if (widget.cvp.pathOfSubsBills == PathOfSubsBills.InApp)
        //       Positioned(
        //         bottom: 0,
        //         right: size.getW(12),
        //         child: IconButton(
        //             onPressed: () {
        //               widget.cvp.setMainPage = MainPage.HomePage;
        //               // widget.cvp.setDashboard = true;
        //             },
        //             icon: Icon(
        //               Icons.close,
        //               size: size.getS(28),
        //             )),
        //       )
        //   ],
        // ),
        CommonHeader(
          child: TitlePop(
            title: "Billing & Subscription",
            size: size,
            onTap: () {
              GlobalCVP.setMainPage = MainPage.ManagePage;
            },
          ),
        ),
        // SizedBox(
        //   height: size.getH(8),
        // ),
        Flexible(
          child: Processing(
            loading: subBillPro.subPlanListLoad,
            child: PageView(
              physics: NeverScrollableScrollPhysics(),
              controller: _pageCltr,
              children: [
                ExpiryScreen(
                  size: size,
                  subsBillingPro: subBillPro,
                  curSym: subBillPro.curSym,
                  subsPlan: subBillPro.subsPlanList,
                  hospitalityPlanList: subBillPro.hospitalityPlanList,
                  retailPlanList: subBillPro.retailPlanList,
                  isInIt: widget.cvp.pathOfSubsBills == PathOfSubsBills.OnInit,
                  signUp: subBillPro.subPlanListLoad
                      ? null
                      : (int index) async {
                          // if (subBillPro.subsPlanList == null) return;
                          // subBillPro.selectedPlanId = subBillPro
                          //     .subsPlanList![index].subscriptionPlanId;

                          // if (subBillPro.subsPlanList![index]
                          //             .numberOfDevicePlanPrices !=
                          //         null &&
                          //     subBillPro.subsPlanList![index]
                          //         .numberOfDevicePlanPrices!
                          //         .any((e) => e.isDefault ?? false)) {
                          //   subBillPro.devicePlanIndex = subBillPro
                          //       .subsPlanList?[index].numberOfDevicePlanPrices!
                          //       .indexWhere((e) => e.isDefault ?? false);
                          // } else {
                          //   subBillPro.devicePlanIndex = null;
                          // }

                          // subBillPro.notify;
                          // await subBillPro.getBillingAddSec();
                          // subBillPro.selectedTab = 0;
                          // if (subBillPro.billingSubsAddSec != null)
                          //   _pageCltr.animateToPage(1,
                          //       duration: Duration(milliseconds: 300),
                          //       curve: Curves.easeInOut);

                          // final _subsPlanList = (subBillPro.subsPlanIndex == 0)
                          //     ? subBillPro.hospitalityPlanList
                          //     : subBillPro.retailPlanList;

                          List<BillingSubsPlan>? subsPlanList;
                          if (subBillPro.subsPlanIndex == 0) {
                            subsPlanList = subBillPro.hospitalityPlanList;
                          } else if (subBillPro.subsPlanIndex == 1) {
                            subsPlanList = subBillPro.retailPlanList;
                          }
                          if (subsPlanList == null) return;
                          subBillPro.selectedPlanId =
                              subsPlanList[index].subscriptionPlanId;

                          if (subsPlanList[index].numberOfDevicePlanPrices !=
                                  null &&
                              subsPlanList[index]
                                  .numberOfDevicePlanPrices!
                                  .any((e) => e.isDefault ?? false)) {
                            subBillPro.devicePlanIndex = subsPlanList[index]
                                .numberOfDevicePlanPrices!
                                .indexWhere((e) => e.isDefault ?? false);
                          } else {
                            subBillPro.devicePlanIndex = null;
                          }

                          subBillPro.notify;
                          await subBillPro.getBillingAddSec();
                          subBillPro.selectedTab = 0;
                          if (subBillPro.billingSubsAddSec != null)
                            _pageCltr.animateToPage(1,
                                duration: Duration(milliseconds: 300),
                                curve: Curves.easeInOut);
                        },
                  selectedId: subBillPro.subPlanListLoad
                      ? subBillPro.selectedPlanId
                      : null,
                ),
                BillingSubsScreen(
                  subsPro: subBillPro,
                  onBack: () {
                    _pageCltr.animateToPage(0,
                        duration: Duration(milliseconds: 300),
                        curve: Curves.easeInOut);
                  },
                )
              ],
            ),
          ),
        ),
      ],
    );
  }
}
