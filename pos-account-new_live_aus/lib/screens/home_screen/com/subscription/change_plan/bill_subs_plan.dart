import 'package:flutter/material.dart';
import 'package:pos_account/config/size_config.dart';
import 'package:pos_account/constant/constant.dart';
import 'package:pos_account/ln.dart';
import 'package:pos_account/providers/cus_val_pro.dart';
import 'package:pos_account/providers/subs_billing/sub_billing_pro.dart';
import 'package:pos_account/widgets/load_btn.dart';
import 'package:pos_account/widgets/loading.dart';
import 'package:pos_account/widgets/message_widgets/trial_expire.dart';
import 'package:pos_account/widgets/no_items_sec.dart';
import 'package:provider/provider.dart';
import 'com/choose_plan_dia.dart';

class BillSubsPlan extends StatefulWidget {
  final PageController homePageCltr;
  final CusValuePro cvp;

  const BillSubsPlan({
    super.key,
    required this.cvp,
    required this.homePageCltr,
  });

  @override
  State<BillSubsPlan> createState() => _BillSubsPlanState();
}

class _BillSubsPlanState extends State<BillSubsPlan> {
  late SubsBillingPro _subBillPro;

  showDia() {
    _subBillPro.clearListData();
    _subBillPro.subPlanListLoad = true;
    _subBillPro.notify;
    _subBillPro.getSubPlans();
    return showDialog(
        context: context,
        builder: (builder) => SimpleDialog(
              backgroundColor: kPrimaryColor,
              titlePadding: EdgeInsets.zero,
              contentPadding: EdgeInsets.symmetric(horizontal: 24, vertical: 0),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15)),
              children: [ChoosePlanDia()],
            ));
  }

  @override
  void initState() {
    getData();
    super.initState();
  }

  getData() {
    _subBillPro = Provider.of<SubsBillingPro>(context, listen: false);
    _subBillPro.getAllBillAndSubs();
  }

  @override
  void dispose() {
    _subBillPro.clearBilSubs();
    _subBillPro.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = Ssize(context);
    final subBillPro = Provider.of<SubsBillingPro>(context);
    return Padding(
      padding:
          EdgeInsets.symmetric(horizontal: size.getW(size.isProt ? 60 : 160)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // TextButton(
          //     onPressed: () async {
          //       if (widget.cvp.getMainPage == MainPage.ProfilePage ||
          //           widget.cvp.getMainPage == MainPage.SubscriptionPlanPage) {
          //         widget.homePageCltr.animateToPage(0,
          //             duration: Duration(milliseconds: 350),
          //             curve: Curves.easeInOut);
          //         Future.delayed(Duration(milliseconds: 300), () {
          //           widget.cvp.setMainPage = MainPage.HomePage;
          //         });
          //       }
          //     },
          //     child: Padding(
          //       padding: const EdgeInsets.only(left: 20.0),
          //       child: Row(
          //         children: [
          //           Icon(
          //             Icons.arrow_back,
          //             size: size.getS(24),
          //             color: Colors.black,
          //           ),
          //           SizedBox(
          //             width: size.getW(8),
          //           ),
          //           Text(
          //             LN.back,
          //             style: TextStyle(
          //               fontSize: size.getS(16),
          //               color: Colors.black,
          //             ),
          //           ),
          //         ],
          //       ),
          //     )),
          Text(
            LN.billAndSubs,
            style: TextStyle(
              color: kPrimaryColor,
              fontFamily: kFontFMedium,
              fontSize: size.getS(24),
            ),
          ),
          Flexible(
            child: subBillPro.loading2
                ? Padding(
                    padding: EdgeInsets.only(bottom: 120.0),
                    child: Loading(),
                  )
                : subBillPro.allBillAndSubs == null
                    ? NoItemsSec(size: size, title: LN.somethingWentWrong)
                    : SingleChildScrollView(
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (subBillPro.allBillAndSubs?.message != null &&
                                  subBillPro
                                      .allBillAndSubs!.message!.isNotEmpty)
                                Padding(
                                  padding:
                                      EdgeInsets.only(bottom: size.getH(24)),
                                  child: TrialExpiryMsg(
                                    size: size,
                                    show: subBillPro.allBillAndSubs?.message !=
                                        null,
                                    message:
                                        subBillPro.allBillAndSubs?.message ??
                                            '',
                                    btnText: (subBillPro.allBillAndSubs
                                                ?.isCommissionBasedPlanEnabled ??
                                            false)
                                        ? null
                                        : LN.subsNow,
                                    width: size.getW(960),
                                    onTap: () {
                                      GlobalCVP.pathOfSubsBills =
                                          PathOfSubsBills.InApp;
                                      GlobalCVP.setMainPage =
                                          MainPage.SubscriptionPage;
                                    },
                                  ),
                                )
                              else
                                Card(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10)),
                                  child: SizedBox(
                                    width: size.getW(960),
                                    child: Column(
                                      children: [
                                        Padding(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: size.getW(36),
                                              vertical: size.getH(12)),
                                          child: Row(
                                            children: [
                                              Icon(
                                                Icons.credit_card,
                                                color: Colors.black54,
                                              ),
                                              SizedBox(
                                                width: size.getW(12),
                                              ),
                                              Text(
                                                LN.registeredCards,
                                                style: TextStyle(
                                                  color: kPrimaryColor,
                                                  fontFamily: kFontFMedium,
                                                  fontSize: size.getS(18),
                                                ),
                                              ),
                                              // Spacer(),
                                              // LoadButton(
                                              //   width: 200,
                                              //   btnText: LN.addNewCard,
                                              //   btnColor: kPrimaryColor
                                              //       .withAlpha(90),
                                              //   vPad: 12,
                                              //   onsave: () {},
                                              // )
                                            ],
                                          ),
                                        ),
                                        // SizedBox(
                                        //   height: size.getH(12),
                                        // ),
                                        Divider(
                                          color: Colors.black54,
                                        ),
                                        InkWell(
                                          highlightColor:
                                              kUserColor.withAlpha(50),
                                          splashColor: kUserColor.withAlpha(60),
                                          onTap: () {
                                            subBillPro.isCardSelected =
                                                !subBillPro.isCardSelected;
                                            subBillPro.notify;
                                          },
                                          child: Padding(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: size.getW(36),
                                                vertical: size.getH(12)),
                                            child: Column(
                                              children: [
                                                RegisteredCardSec(
                                                  size: size,
                                                  leading: CustomCheckBtn(
                                                    size: size,
                                                    checked: subBillPro
                                                        .isCardSelected,
                                                  ),
                                                  textList: [
                                                    LN.cardType,
                                                    LN.cardNum,
                                                    LN.expiryDate,
                                                  ],
                                                  isHeader: true,
                                                ),
                                                SizedBox(
                                                  height: size.getH(8),
                                                ),
                                                if (subBillPro.allBillAndSubs !=
                                                        null &&
                                                    subBillPro.allBillAndSubs!
                                                            .cardDetailsViewModels !=
                                                        null)
                                                  ...List.generate(
                                                      subBillPro
                                                          .allBillAndSubs!
                                                          .cardDetailsViewModels!
                                                          .length, (index) {
                                                    final subsPlan = subBillPro
                                                            .allBillAndSubs!
                                                            .cardDetailsViewModels![
                                                        index];
                                                    return RegisteredCardSec(
                                                      size: size,
                                                      leading: Padding(
                                                        padding: EdgeInsets.all(
                                                            size.getW(4)),
                                                        child: Icon(
                                                          Icons.credit_card,
                                                          color: Colors.black54,
                                                          size: size.getW(24),
                                                        ),
                                                      ),
                                                      textList: [
                                                        subsPlan.cardType ?? '',
                                                        subsPlan.cardNumber ??
                                                            '',
                                                        "${subsPlan.expiryMonth}/${subsPlan.expiryYear}",
                                                      ],
                                                      isHeader: false,
                                                    );
                                                  }),
                                              ],
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              if (subBillPro.allBillAndSubs?.message == null ||
                                  subBillPro.allBillAndSubs!.message!.isEmpty ||
                                  (subBillPro.allBillAndSubs
                                          ?.isCommissionBasedPlanEnabled ??
                                      false))
                                Card(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10)),
                                  child: SizedBox(
                                    width: size.getW(960),
                                    child: Padding(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: size.getW(36),
                                          vertical: size.getH(12)),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Container(
                                            decoration: BoxDecoration(
                                                border: Border.all(
                                                  color: Colors.black45,
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(10)),
                                            child: InkWell(
                                              // onTap: () {},
                                              child: Padding(
                                                padding: EdgeInsets.symmetric(
                                                    vertical: size.getH(10),
                                                    horizontal: size.getW(24)),
                                                child: Row(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: [
                                                    CustomCheckBtn(
                                                      size: size,
                                                      iconSize: 20,
                                                      checked: true,
                                                    ),
                                                    SizedBox(
                                                        width: size.getW(12)),
                                                    Text(
                                                      LN.mySubs,
                                                      style: TextStyle(
                                                        color: kPrimaryColor,
                                                        fontFamily:
                                                            kFontFMedium,
                                                        fontSize: size.getS(18),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            height: size.getH(12),
                                          ),
                                          Row(
                                            mainAxisSize: MainAxisSize.min,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.end,
                                            children: [
                                              _selectedPlanSec(
                                                  size, subBillPro),
                                              Flexible(
                                                child: Align(
                                                  alignment:
                                                      Alignment.centerRight,
                                                  child: Padding(
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                            vertical:
                                                                size.getH(12)),
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .end,
                                                      children: [
                                                        Text(
                                                          LN.wishToChangePlan,
                                                          style: TextStyle(
                                                            color: Colors.black,
                                                            fontFamily:
                                                                kFontFMedium,
                                                            fontSize:
                                                                size.getS(18),
                                                          ),
                                                        ),
                                                        SizedBox(
                                                          height: size.getH(16),
                                                        ),
                                                        LoadButton(
                                                          width: 200,
                                                          btnText:
                                                              LN.changePlan,
                                                          btnColor:
                                                              kPrimaryColor
                                                                  .withAlpha(
                                                                      220),
                                                          vPad: 12,
                                                          onsave: () {
                                                            showDia();
                                                          },
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              )
                                            ],
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                )
                            ]),
                      ),
          ),
        ],
      ),
    );
  }

  Container _selectedPlanSec(Ssize size, SubsBillingPro subBillPro) {
    return Container(
      width: size.width * 0.3,
      decoration: BoxDecoration(
          border: Border.all(
            color: kPrimaryColor.withAlpha(70),
            width: 2.5,
          ),
          borderRadius: BorderRadius.circular(10)),
      padding: EdgeInsets.symmetric(
          vertical: size.getH(48), horizontal: size.getW(32)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(10)),
            padding: EdgeInsets.symmetric(
                vertical: size.getH(8), horizontal: size.getW(24)),
            child: Text(
              subBillPro.allBillAndSubs?.subscriptionPlanDetails?.planName ??
                  '',
              style: TextStyle(
                color: Colors.black,
                fontFamily: kFontFMedium,
                fontWeight: FontWeight.bold,
                fontSize: size.getS(16),
              ),
            ),
          ),
          SizedBox(
            height: size.getH(12),
          ),
          if (subBillPro.allBillAndSubs?.isCommissionBasedPlanEnabled ??
              false) ...[
            Text(
              LN.commissionBasedSubsPlan,
              style: TextStyle(
                color: kPrimaryColor,
                fontFamily: kFontFRegular,
                fontWeight: FontWeight.bold,
                fontSize: size.getS(18),
              ),
            ),
            SizedBox(
              height: size.getH(16),
            ),
            Text(
              "${LN.numOfPosLocation} : ${subBillPro.allBillAndSubs?.subscriptionPlanDetails?.numberofPosLocation ?? ''}",
              style: TextStyle(
                color: kPrimaryColor,
                fontFamily: kFontFRegular,
                fontWeight: FontWeight.bold,
                fontSize: size.getS(18),
              ),
            )
          ] else ...[
            Text(
              LN.monthlySubsPlan,
              style: TextStyle(
                color: Colors.black,
                fontFamily: kFontFRegular,
                fontSize: size.getS(18),
              ),
            ),
            Text(
              subBillPro.allBillAndSubs?.subscriptionPlanDetails?.amount ?? '',
              style: TextStyle(
                color: kPrimaryColor,
                fontFamily: kFontFRegular,
                fontWeight: FontWeight.bold,
                fontSize: size.getS(72),
              ),
            ),
            Text(
              LN.perMemMon,
              style: TextStyle(
                color: kPrimaryColor,
                fontFamily: kFontFRegular,
                fontWeight: FontWeight.bold,
                fontSize: size.getS(18),
              ),
            )
          ],
        ],
      ),
    );
  }
}

class RegisteredCardSec extends StatelessWidget {
  final bool isHeader;
  final Widget leading;
  final List<String> textList;
  const RegisteredCardSec({
    super.key,
    required this.size,
    this.isHeader = false,
    required this.leading,
    required this.textList,
  });

  final Ssize size;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        SizedBox(
          width: size.getW(120),
          child: Align(
            alignment: Alignment.centerLeft,
            child: leading,
          ),
        ),
        ...List.generate(
            textList.length,
            (index) => SizedBox(
                  width: size.getW(200),
                  child: Text(
                    textList[index],
                    style: TextStyle(
                      fontFamily: isHeader ? kFontFMedium : kFontFRegular,
                      color: isHeader ? Colors.black : Colors.black54,
                      fontSize: size.getS(18),
                    ),
                    textAlign: TextAlign.start,
                  ),
                )),
      ],
    );
  }
}

class CustomCheckBtn extends StatelessWidget {
  const CustomCheckBtn({
    super.key,
    required this.size,
    this.checked = false,
    this.iconSize = 24,
    this.uncheckedBackColor = Colors.transparent,
  });
  final Ssize size;
  final bool checked;
  final double iconSize;
  final Color uncheckedBackColor;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 300),
      decoration: BoxDecoration(
        color: checked ? Colors.green.shade500 : uncheckedBackColor,
        border:
            Border.all(color: checked ? Colors.green.shade500 : Colors.black38),
        shape: BoxShape.circle,
      ),
      padding: EdgeInsets.all(size.getW(4)),
      child: Icon(
        Icons.check_sharp,
        color: checked ? Colors.white : Colors.grey,
        size: size.getW(iconSize),
      ),
    );
  }
}
