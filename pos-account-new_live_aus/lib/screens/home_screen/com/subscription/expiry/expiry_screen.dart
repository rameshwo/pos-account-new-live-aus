import 'package:flutter/material.dart';
import 'package:pos_account/config/size_config.dart';
import 'package:pos_account/constant/constant.dart';
import 'package:pos_account/ln.dart';
import 'package:pos_account/model/billing_and_subs/billing_subs_plan.dart';
import 'package:pos_account/providers/subs_billing/sub_billing_pro.dart';
import 'package:pos_account/screens/home_screen/com/subscription/expiry/com/plan_group_tab.dart';
import 'com/expiry_com.dart';

class ExpiryScreen extends StatelessWidget {
  final Ssize size;
  final Function(int)? signUp;
  final List<BillingSubsPlan>? subsPlan;
  final String? selectedId;
  final bool isInIt;
  final String? curSym;
  final SubsBillingPro subsBillingPro;
  final List<BillingSubsPlan>? hospitalityPlanList;
  final List<BillingSubsPlan>? retailPlanList;

  const ExpiryScreen({
    super.key,
    required this.size,
    required this.subsBillingPro,
    required this.hospitalityPlanList,
    required this.retailPlanList,
    this.signUp,
    this.subsPlan,
    this.selectedId,
    this.isInIt = true,
    this.curSym,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(
          vertical: size.getH(12), horizontal: size.getW(24)),
      padding: EdgeInsets.symmetric(horizontal: size.getW(12)),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(),
      ),
      child: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: size.getH(24),
            ),
            // Container(
            //   padding: EdgeInsets.all(size.getW(8)),
            //   decoration: BoxDecoration(
            //       color: Colors.white, borderRadius: BorderRadius.circular(15)),
            //   child: SvgPicture.asset(
            //     "assets/svg/icons/warning.svg",
            //     height: size.getW(60),
            //     width: size.getW(60),
            //   ),
            // ),
            if (isInIt) ...[
              SizedBox(
                height: size.getH(12),
              ),
              Text(
                LN.trialExpired,
                style: TextStyle(
                  fontSize: size.getS(42),
                  fontFamily: kFontFMedium,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
                textAlign: TextAlign.center,
              ),
            ],
            SizedBox(
              height: size.getH(4),
            ),
            Text(
              LN.choosePlanThatFits,
              style: TextStyle(
                fontSize: size.getS(isInIt ? 20 : 42),
                fontFamily: kFontFMedium,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(
              height: size.getH(12),
            ),
            //
            if (subsPlan != null && subsPlan!.isNotEmpty)
              Column(
                children: [
                  PlanGroupTab(subsBillingPro: subsBillingPro),
                  SingleChildScrollView(
                    physics: BouncingScrollPhysics(),
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // ...List.generate(
                        //   subsPlan!.length,
                        //   (index) => PlanSection(
                        //     size: size,
                        //     curSym: curSym,
                        //     buyNow:
                        //         signUp == null ? null : () => signUp!(index),
                        //     subsPlan: subsPlan![index],
                        //     load: selectedId ==
                        //         subsPlan![index].subscriptionPlanId,
                        //   ),
                        // ),
                        if (subsBillingPro.subsPlanIndex == 0)
                          ...List.generate(
                              subsBillingPro.hospitalityPlanList.length,
                              (index) => PlanSection(
                                    size: size,
                                    curSym: curSym,
                                    buyNow: signUp == null
                                        ? null
                                        : () => signUp!(index),
                                    subsPlan: subsBillingPro
                                        .hospitalityPlanList[index],
                                    load: selectedId ==
                                        subsBillingPro
                                            .hospitalityPlanList[index]
                                            .subscriptionPlanId,
                                  )),
                        if (subsBillingPro.subsPlanIndex == 1)
                          ...List.generate(
                              subsBillingPro.retailPlanList.length,
                              (index) => PlanSection(
                                    size: size,
                                    curSym: curSym,
                                    buyNow: signUp == null
                                        ? null
                                        : () => signUp!(index),
                                    subsPlan:
                                        subsBillingPro.retailPlanList[index],
                                    load: selectedId ==
                                        subsBillingPro.retailPlanList[index]
                                            .subscriptionPlanId,
                                  )),
                      ],
                    ),
                  ),
                ],
              ),
            SizedBox(
              height: size.getH(24),
            ),
          ],
        ),
      ),
    );
  }

  // Widget _pricingTab() {
  //   return Row(
  //     crossAxisAlignment: CrossAxisAlignment.start,
  //     mainAxisSize: MainAxisSize.min,
  //     children: List.generate(
  //       subsBillingPro.subsPlanGroup.length,
  //       (index) => Padding(
  //         padding:
  //             EdgeInsets.only(right: size.getW(12.0), bottom: size.getH(12)),
  //         child: ElevatedButton(
  //             style: ButtonStyle(
  //                 backgroundColor: WidgetStateProperty.all(
  //                     subsBillingPro.subsPlanIndex == index
  //                         ? kSecondaryColor
  //                         : kTempColor),
  //                 padding: WidgetStateProperty.all(EdgeInsets.symmetric(
  //                     horizontal: size.getW(12), vertical: size.getH(8)))),
  //             onPressed: () {
  //               subsBillingPro.subsPlanIndex = index;
  //               subsBillingPro.notify;
  //             },
  //             child: Text(
  //               subsBillingPro.subsPlanGroup[index],
  //               style: TextStyle(
  //                 fontSize: size.getS(14),
  //                 color: Colors.white,
  //                 fontWeight: FontWeight.bold,
  //               ),
  //             )),
  //       ),
  //     ),
  //   );
  // }
}
