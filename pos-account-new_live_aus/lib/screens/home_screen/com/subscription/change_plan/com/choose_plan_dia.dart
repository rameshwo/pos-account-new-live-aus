import 'package:flutter/material.dart';
import 'package:pos_account/config/size_config.dart';
import 'package:pos_account/constant/constant.dart';
import 'package:pos_account/ln.dart';
import 'package:pos_account/model/billing_and_subs/billing_subs_plan.dart';
import 'package:pos_account/providers/subs_billing/sub_billing_pro.dart';
import 'package:pos_account/screens/home_screen/com/subscription/expiry/com/expiry_com.dart';
import 'package:pos_account/screens/home_screen/com/subscription/expiry/com/plan_group_tab.dart';
import 'package:pos_account/widgets/dialog/msg_dialog.dart';
import 'package:pos_account/widgets/input/dropdown/drop_down.dart';
import 'package:pos_account/widgets/load_btn.dart';
import 'package:pos_account/widgets/loading.dart';
import 'package:provider/provider.dart';

class ChoosePlanDia extends StatelessWidget {
  const ChoosePlanDia({
    super.key,
  });

  Container _totalAmount(
    Ssize size, {
    BillingSubsPlan? subsPlan,
    int? devicePlanIndex,
    Function(int?)? onChanged,
    String? curSym,
    bool isCommission = false,
  }) {
    return Container(
      margin: EdgeInsets.symmetric(
        vertical: size.getH(12),
      ),
      decoration: BoxDecoration(
        color: kSecondaryColor,
        borderRadius: BorderRadius.circular(5),
      ),
      padding: EdgeInsets.symmetric(
          vertical: size.getH(8), horizontal: size.getW(12)),
      child: SizedBox(
        child: Row(
          children: [
            Text(
              LN.npOfPos,
              style: TextStyle(
                fontSize: size.getS(16),
                fontFamily: kFontFMedium,
                color: Colors.white,
              ),
            ),
            SizedBox(
              width: size.getW(12),
            ),
            SizedBox(
              width: size.getW(60),
              child: DropDownList(
                list: subsPlan?.numberOfDevicePlanPrices == null ||
                        subsPlan!.numberOfDevicePlanPrices!.isEmpty
                    ? []
                    : subsPlan.numberOfDevicePlanPrices!
                        .map((e) => e.numberOfDevice ?? '')
                        .toList(),
                borderRadius: 5,
                borderColor: Colors.black12,
                hPad: 0,
                fontSize: 14,
                indexValue: devicePlanIndex,
                onChange: onChanged,
              ),
            ),
            Spacer(),
            Text(
              isCommission
                  ? LN.priceChargedSales
                  : "${LN.totalAmount}: ${curSym ?? ''}${subsPlan?.numberOfDevicePlanPrices == null || devicePlanIndex == null ? '0.00' : (subsPlan?.numberOfDevicePlanPrices?[devicePlanIndex].price ?? '0.00')} ${subsPlan?.currencyCode ?? ''}",
              style: TextStyle(
                fontSize: size.getS(16),
                fontFamily: kFontFMedium,
                color: Colors.white,
              ),
            ),
            SizedBox(
              width: size.getW(24),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = Ssize(context);
    final subBillPro = Provider.of<SubsBillingPro>(context);
    return Processing(
      loading: subBillPro.subPlanListLoad,
      child: Container(
        constraints: BoxConstraints(
          maxHeight: size.height / 1.15,
          minHeight: size.height / 5,
          minWidth: size.width / 3,
          maxWidth: size.width / 1.15,
        ),
        // width: size.width / 1.15,
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: size.getH(12)),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Stack(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          LN.chooseUrPlan,
                          style: TextStyle(
                            fontSize: size.getS(42),
                            fontFamily: kFontFMedium,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                    Positioned(
                      top: 0,
                      right: 0,
                      child: IconButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          icon: Icon(
                            Icons.close,
                            color: Colors.white,
                            size: size.getS(32),
                          )),
                    )
                  ],
                ),
                SizedBox(
                  height: size.getH(12),
                ),
                SingleChildScrollView(
                  physics: BouncingScrollPhysics(),
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // if (subBillPro.subsPlanList != null)
                      //   ...List.generate(
                      //       subBillPro.subsPlanList!.length,
                      //       (index) => PlanSection(
                      //             size: size,
                      //             showBuyBtn: false,
                      //             curSym: subBillPro.curSym,
                      //             onTap: () {
                      //               if (subBillPro.subsPlanList == null) return;

                      //               subBillPro.selectedPlanId = subBillPro
                      //                   .subsPlanList![index]
                      //                   .subscriptionPlanId;
                      //               if (subBillPro.subsPlanList![index]
                      //                           .numberOfDevicePlanPrices !=
                      //                       null &&
                      //                   subBillPro.subsPlanList![index]
                      //                       .numberOfDevicePlanPrices!
                      //                       .any((e) => e.isDefault ?? false)) {
                      //                 subBillPro.devicePlanIndex = subBillPro
                      //                     .subsPlanList?[index]
                      //                     .numberOfDevicePlanPrices!
                      //                     .indexWhere(
                      //                         (e) => e.isDefault ?? false);
                      //               } else {
                      //                 subBillPro.devicePlanIndex = null;
                      //               }

                      //               subBillPro.notify;
                      //             },
                      //             isSelected: subBillPro.selectedPlanId ==
                      //                 subBillPro.subsPlanList?[index]
                      //                     .subscriptionPlanId,
                      //             subsPlan: subBillPro.subsPlanList![index],
                      //           )),

                      if (subBillPro.subsPlanList != null)
                        Column(
                          children: [
                            PlanGroupTab(subsBillingPro: subBillPro),
                            SingleChildScrollView(
                              physics: BouncingScrollPhysics(),
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    if (subBillPro.subsPlanIndex == 0)
                                      ...List.generate(
                                          subBillPro.hospitalityPlanList.length,
                                          (index) => PlanSection(
                                                size: size,
                                                showBuyBtn: false,
                                                curSym: subBillPro.curSym,
                                                onTap: () {
                                                  if (subBillPro
                                                      .hospitalityPlanList
                                                      .isEmpty) return;

                                                  subBillPro.selectedPlanId =
                                                      subBillPro
                                                          .hospitalityPlanList[
                                                              index]
                                                          .subscriptionPlanId;
                                                  if (subBillPro
                                                              .hospitalityPlanList[
                                                                  index]
                                                              .numberOfDevicePlanPrices !=
                                                          null &&
                                                      subBillPro
                                                          .hospitalityPlanList[
                                                              index]
                                                          .numberOfDevicePlanPrices!
                                                          .any((e) =>
                                                              e.isDefault ??
                                                              false)) {
                                                    subBillPro.devicePlanIndex =
                                                        subBillPro
                                                            .hospitalityPlanList[
                                                                index]
                                                            .numberOfDevicePlanPrices!
                                                            .indexWhere((e) =>
                                                                e.isDefault ??
                                                                false);
                                                  } else {
                                                    subBillPro.devicePlanIndex =
                                                        null;
                                                  }

                                                  subBillPro.notify;
                                                },
                                                isSelected: subBillPro
                                                        .selectedPlanId ==
                                                    subBillPro
                                                        .hospitalityPlanList[
                                                            index]
                                                        .subscriptionPlanId,
                                                subsPlan: subBillPro
                                                    .hospitalityPlanList[index],
                                              )),
                                    if (subBillPro.subsPlanIndex == 1)
                                      ...List.generate(
                                          subBillPro.retailPlanList.length,
                                          (index) => PlanSection(
                                                size: size,
                                                showBuyBtn: false,
                                                curSym: subBillPro.curSym,
                                                onTap: () {
                                                  if (subBillPro.retailPlanList
                                                      .isEmpty) return;

                                                  subBillPro.selectedPlanId =
                                                      subBillPro
                                                          .retailPlanList[index]
                                                          .subscriptionPlanId;
                                                  if (subBillPro
                                                              .retailPlanList[
                                                                  index]
                                                              .numberOfDevicePlanPrices !=
                                                          null &&
                                                      subBillPro
                                                          .retailPlanList[index]
                                                          .numberOfDevicePlanPrices!
                                                          .any((e) =>
                                                              e.isDefault ??
                                                              false)) {
                                                    subBillPro.devicePlanIndex =
                                                        subBillPro
                                                            .retailPlanList[
                                                                index]
                                                            .numberOfDevicePlanPrices!
                                                            .indexWhere((e) =>
                                                                e.isDefault ??
                                                                false);
                                                  } else {
                                                    subBillPro.devicePlanIndex =
                                                        null;
                                                  }

                                                  subBillPro.notify;
                                                },
                                                isSelected: subBillPro
                                                        .selectedPlanId ==
                                                    subBillPro
                                                        .retailPlanList[index]
                                                        .subscriptionPlanId,
                                                subsPlan: subBillPro
                                                    .retailPlanList[index],
                                              )),
                                  ]),
                            )
                          ],
                        )
                    ],
                  ),
                ),
                Row(
                  children: [
                    Expanded(
                      flex: 3,
                      child: _totalAmount(size,
                          subsPlan: subBillPro.subsPlanList != null &&
                                  subBillPro.subsPlanList!.any((e) =>
                                      e.subscriptionPlanId?.toLowerCase() ==
                                      subBillPro.selectedPlanId?.toLowerCase())
                              ? subBillPro.subsPlanList!.firstWhere((e) =>
                                  e.subscriptionPlanId?.toLowerCase() ==
                                  subBillPro.selectedPlanId?.toLowerCase())
                              : null, onChanged: (s) {
                        subBillPro.devicePlanIndex = s;
                        subBillPro.notify;
                      },
                          devicePlanIndex: subBillPro.devicePlanIndex,
                          curSym: subBillPro.curSym,
                          isCommission: subBillPro.allBillAndSubs
                                  ?.isCommissionBasedPlanEnabled ??
                              false),
                    ),
                    SizedBox(
                      width: size.getW(24),
                    ),
                    Expanded(
                      flex: 2,
                      child: LoadButton(
                        vPad: 20,
                        btnText: LN.choosePlan,
                        btnColor: kTempColor,
                        loading: subBillPro.changePlanLoad,
                        onsave: subBillPro.selectedPlanId == null
                            ? () {
                                MsgDia.show(
                                  context,
                                  headerAnimation: false,
                                  diaType: DiaType.warning,
                                  title: LN.pleaseSePlan,
                                  autoHideSecond: 2,
                                );
                              }
                            : () {
                                subBillPro.changePlan(ctx: context);
                              },
                      ),
                    )
                  ],
                ),
                SizedBox(
                  height: size.getH(24),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
