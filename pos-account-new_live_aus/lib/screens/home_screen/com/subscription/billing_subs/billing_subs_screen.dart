import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pos_account/config/size_config.dart';
import 'package:pos_account/config/validator.dart';
import 'package:pos_account/constant/constant.dart';
import 'package:pos_account/constant/strings.dart';
import 'package:pos_account/ln.dart';
import 'package:pos_account/model/billing_and_subs/billing_subs_plan.dart';
import 'package:pos_account/providers/cus_val_pro.dart';
import 'package:pos_account/providers/menu/place_order_pro.dart';
import 'package:pos_account/providers/subs_billing/sub_billing_pro.dart';
import 'package:pos_account/services/web_view/inapp_web_screen.dart';
// import 'package:pos_account/services/web_view/webview_screen.dart';
import 'package:pos_account/widgets/agreement_sec.dart';
import 'package:pos_account/widgets/input/dropdown/drop_down.dart';
import 'package:pos_account/widgets/input/text_form/text_form_widget.dart';
import 'package:pos_account/widgets/input/dropdown/title_drop_down.dart';
import 'package:pos_account/widgets/input/text_form/title_text_form.dart';
import 'package:pos_account/widgets/load_btn.dart';
import 'package:provider/provider.dart';

import '../../cus_button_tabs.dart';

class BillingSubsScreen extends StatefulWidget {
  final Function()? onBack;
  final SubsBillingPro subsPro;
  const BillingSubsScreen({
    super.key,
    this.onBack,
    required this.subsPro,
  });

  @override
  State<BillingSubsScreen> createState() => _BillingSubsScreenState();
}

class _BillingSubsScreenState extends State<BillingSubsScreen> {
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    widget.subsPro.clearBilSubs();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final subsBillingPro = widget.subsPro;
    final size = Ssize(context);
    final leftCardWidth = size.isProt ? size.getW(600) : size.getW(700);
    const double pWidth = 0.28;
    const int cardTextFlex = 7;
    const int cardFieldFlex = 12;
    final kTabs = [
      LN.monthlySubs,
      LN.commission,
    ];
    return Form(
      key: _formKey,
      child: Padding(
        padding: EdgeInsets.symmetric(
            horizontal: size.getW(24), vertical: size.getH(12)),
        child: Column(
          children: [
            Row(
              children: [
                IconButton(
                    onPressed: widget.onBack, icon: Icon(Icons.arrow_back)),
                Text(
                  LN.billAndSubs,
                  style: TextStyle(
                    fontSize: size.getS(20),
                    // fontFamily: ,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
            Flexible(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SingleChildScrollView(
                    child: Column(
                      children: [
                        Card(
                          margin: EdgeInsets.zero,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          color: Color(0xffdcf2ee),
                          shadowColor: Colors.transparent,
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                                vertical: size.getH(16),
                                horizontal: size.getW(18)),
                            child: SizedBox(
                              width: leftCardWidth,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  CusButtonTabs(
                                    kTabs: kTabs,
                                    size: size,
                                    selectedColor: kSecondaryColor,
                                    selectedColorOpacity: 1,
                                    selectedTextColor: Colors.white,
                                    selectedIndex: subsBillingPro.selectedTab,
                                    onTap: (p0) {
                                      subsBillingPro.selectedTab = p0;
                                      subsBillingPro.notify;
                                    },
                                  ),
                                  if (subsBillingPro.selectedTab == 0) ...[
                                    Row(
                                      children: [
                                        Checkbox(
                                          value: subsBillingPro.isAddNewCard,
                                          onChanged: (val) {
                                            if (val == null) return;
                                            subsBillingPro.isAddNewCard = val;
                                            subsBillingPro.notify;
                                          },
                                          activeColor: Colors.green,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(40),
                                          ),
                                        ),
                                        Text(
                                          LN.addNewCard,
                                          style: TextStyle(
                                            fontSize: size.getS(16),
                                            // fontFamily: ,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black,
                                          ),
                                        ),
                                      ],
                                    ),
                                    _cardNumber(
                                      size,
                                      cardTextFlex,
                                      cardFieldFlex,
                                      textCltr: subsBillingPro.cardNumCltr,
                                    ),
                                    SizedBox(
                                      height: size.getH(24),
                                    ),
                                    _expiryDate(
                                      size,
                                      cardTextFlex,
                                      cardFieldFlex,
                                      cvvCltr: subsBillingPro.cvvCltr,
                                      textCltr1: subsBillingPro.expiryDateCltr1,
                                      textCltr2: subsBillingPro.expiryDateCltr2,
                                    ),
                                    SizedBox(
                                      height: size.getH(24),
                                    ),
                                    _cardSection(
                                      size,
                                      cardTextFlex,
                                      cardFieldFlex,
                                      textCltr: subsBillingPro.nameCardCltr,
                                      title: LN.nameOnCard,
                                      subTitle: LN.enterNameCard,
                                      textInputType: TextInputType.name,
                                    ),
                                    SizedBox(
                                      height: size.getH(24),
                                    ),
                                    _cardSection(
                                      size,
                                      cardTextFlex,
                                      cardFieldFlex,
                                      textCltr: subsBillingPro.emailCltr,
                                      title: LN.emailAddress,
                                      subTitle: LN.enterTheEmail,
                                      textInputType: TextInputType.emailAddress,
                                    ),
                                    SizedBox(
                                      height: size.getH(24),
                                    ),
                                    Align(
                                      alignment: Alignment.centerRight,
                                      child: Text(
                                        LN.poweredByStripe,
                                        style: TextStyle(
                                          fontSize: size.getS(12),
                                          fontFamily: kFontFMedium,
                                          color: Colors.black,
                                          fontStyle: FontStyle.italic,
                                        ),
                                      ),
                                    )
                                  ],
                                ],
                              ),
                            ),
                          ),
                        ),
                        if (subsBillingPro.subsPlanList != null &&
                            subsBillingPro.subsPlanList!.any((e) =>
                                e.subscriptionPlanId?.toLowerCase() ==
                                subsBillingPro.selectedPlanId?.toLowerCase()))
                          _totalAmount(
                            context,
                            size,
                            leftCardWidth,
                            subsPlan: subsBillingPro.subsPlanList != null &&
                                    subsBillingPro.subsPlanList!.any((e) =>
                                        e.subscriptionPlanId?.toLowerCase() ==
                                        subsBillingPro.selectedPlanId
                                            ?.toLowerCase())
                                ? subsBillingPro.subsPlanList!.firstWhere((e) =>
                                    e.subscriptionPlanId?.toLowerCase() ==
                                    subsBillingPro.selectedPlanId
                                        ?.toLowerCase())
                                : null,
                            curSym: subsBillingPro.curSym,
                            onChanged: (s) {
                              subsBillingPro.devicePlanIndex = s;
                              subsBillingPro.notify;
                            },
                            devicePlanIndex: subsBillingPro.devicePlanIndex,
                          ),
                        SizedBox(
                          width: leftCardWidth,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                height: size.getH(12),
                              ),
                              Row(
                                children: [
                                  Checkbox(
                                    value: subsBillingPro.acceptTerm,
                                    onChanged: (val) {
                                      if (val == null) return;
                                      subsBillingPro.acceptTerm = val;
                                      subsBillingPro.notify;
                                    },
                                    activeColor: kSecondaryColor,
                                  ),
                                  Flexible(
                                      child: AgreementSec(
                                    text: LN.agreeTermsOnBilling,
                                    fontSize: 16,
                                    onTap: (p0) {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (ctx) =>
                                                  InAppWebViewScreen(
                                                      transparentBackground:
                                                          false,
                                                      webContent: WebContent(
                                                        title: LN.termOfService,
                                                        url: Strings
                                                            .termsOfServiceUrl,
                                                      ))));
                                    },
                                  )),
                                ],
                              ),
                              LoadButton(
                                onsave: subsBillingPro.saveLoad
                                    ? null
                                    : () async {
                                        if (_formKey.currentState!.validate()) {
                                          final status =
                                              await subsBillingPro.createPlan();
                                          if (status ?? false) {
                                            GlobalCVP.setMainPage =
                                                MainPage.HomePage;
                                            final placeOrderPro =
                                                Provider.of<PlaceOrderPro>(
                                                    context,
                                                    listen: false);
                                            placeOrderPro.init();

                                            // await _placeOrderPro
                                            //     .getListOrderType();
                                            // _placeOrderPro.getData(
                                            //     initLoad: true);
                                          }
                                        }
                                      },
                                loading: subsBillingPro.saveLoad,
                                btnText: LN.saveAndUse,
                              ),
                              // ElevatedButton(
                              //     style: ButtonStyle(
                              //         backgroundColor: WidgetStateProperty.all(
                              //             Color(0xff344d8f)),
                              //         padding: WidgetStateProperty.all(
                              //             EdgeInsets.symmetric(
                              //                 horizontal: size.getW(48),
                              //                 vertical: size.getH(8)))),
                              //     onPressed: subsBillingPro.createPlan,
                              //     child: Text(
                              //       "Save and Use",
                              //       style: TextStyle(
                              //         fontSize: size.getS(16),
                              //         color: Colors.white,
                              //         fontWeight: FontWeight.bold,
                              //       ),
                              //     )),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    width: size.getW(8),
                  ),
                  Flexible(
                    child: Card(
                      margin: EdgeInsets.zero,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                            vertical: size.getH(16), horizontal: size.getW(18)),
                        child: SizedBox(
                          // width: size.getW(700),
                          child: SingleChildScrollView(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Row(
                                  children: [
                                    Icon(
                                      Icons.credit_card,
                                      color: Colors.black54,
                                    ),
                                    SizedBox(
                                      width: size.getW(12),
                                    ),
                                    Text(
                                      LN.biilingAddress,
                                      style: TextStyle(
                                        fontSize: size.getS(16),
                                        // fontFamily: ,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: size.getH(12),
                                ),
                                Wrap(
                                  spacing: size.getW(16),
                                  runSpacing: size.getW(16),
                                  children: [
                                    SearchTitleDropDown(
                                      title: LN.country,
                                      pWidth: pWidth,
                                      borderColor: Colors.black26,
                                      isReq: true,
                                      list: subsBillingPro.billingSubsAddSec
                                                  ?.countries ==
                                              null
                                          ? []
                                          : subsBillingPro
                                              .billingSubsAddSec!.countries!
                                              .map((e) => e.name ?? '')
                                              .toList(),
                                      indexVal: subsBillingPro.countryIndex,
                                      onChanged: (p0) {
                                        subsBillingPro.countryIndex = p0;
                                        subsBillingPro.stateIndex = null;
                                        subsBillingPro.cityIndex = null;
                                        subsBillingPro.suburbIndex = null;
                                        subsBillingPro.notify;
                                      },
                                    ),

                                    SearchTitleDropDown(
                                      title: LN.state,
                                      pWidth: pWidth,
                                      isReq: true,
                                      borderColor: Colors.black38,
                                      indexVal: subsBillingPro.stateIndex,
                                      list: subsBillingPro.countryIndex ==
                                                  null ||
                                              subsBillingPro
                                                      .billingSubsAddSec
                                                      ?.countries?[
                                                          subsBillingPro
                                                              .countryIndex!]
                                                      .states ==
                                                  null ||
                                              subsBillingPro
                                                  .billingSubsAddSec!
                                                  .countries![subsBillingPro
                                                      .countryIndex!]
                                                  .states!
                                                  .isEmpty
                                          ? []
                                          : subsBillingPro
                                              .billingSubsAddSec!
                                              .countries![
                                                  subsBillingPro.countryIndex!]
                                              .states!
                                              .map((e) => e.name ?? '')
                                              .toList(),
                                      onChanged: (p0) {
                                        subsBillingPro.stateIndex = p0;
                                        subsBillingPro.cityIndex = null;
                                        subsBillingPro.suburbIndex = null;
                                        subsBillingPro.notify;
                                      },
                                    ),
                                    SearchTitleDropDown(
                                      title: LN.city,
                                      pWidth: pWidth,
                                      isReq: true,
                                      borderColor: Colors.black38,
                                      indexVal: subsBillingPro.cityIndex,
                                      list:
                                          subsBillingPro.countryIndex == null ||
                                                  subsBillingPro.stateIndex ==
                                                      null ||
                                                  subsBillingPro
                                                          .billingSubsAddSec
                                                          ?.countries?[
                                                              subsBillingPro
                                                                  .countryIndex!]
                                                          .states?[
                                                              subsBillingPro
                                                                  .stateIndex!]
                                                          .cities ==
                                                      null ||
                                                  subsBillingPro
                                                      .billingSubsAddSec!
                                                      .countries![subsBillingPro
                                                          .countryIndex!]
                                                      .states![subsBillingPro
                                                          .stateIndex!]
                                                      .cities!
                                                      .isEmpty
                                              ? []
                                              : subsBillingPro
                                                  .billingSubsAddSec!
                                                  .countries![subsBillingPro
                                                      .countryIndex!]
                                                  .states![subsBillingPro
                                                      .stateIndex!]
                                                  .cities!
                                                  .map((e) => e.name ?? '')
                                                  .toList(),
                                      onChanged: (p0) {
                                        subsBillingPro.cityIndex = p0;
                                        subsBillingPro.suburbIndex = null;
                                        subsBillingPro.notify;
                                      },
                                    ),
                                    SearchTitleDropDown(
                                      title: "Suburb",
                                      pWidth: pWidth,
                                      isReq: true,
                                      borderColor: Colors.black38,
                                      indexVal: subsBillingPro.suburbIndex,
                                      list:
                                          subsBillingPro.countryIndex == null ||
                                                  subsBillingPro.stateIndex ==
                                                      null ||
                                                  subsBillingPro.cityIndex ==
                                                      null ||
                                                  subsBillingPro
                                                          .billingSubsAddSec
                                                          ?.countries?[
                                                              subsBillingPro
                                                                  .countryIndex!]
                                                          .states?[
                                                              subsBillingPro
                                                                  .stateIndex!]
                                                          .cities?[
                                                              subsBillingPro
                                                                  .cityIndex!]
                                                          .suburbs ==
                                                      null ||
                                                  subsBillingPro
                                                      .billingSubsAddSec!
                                                      .countries![subsBillingPro
                                                          .countryIndex!]
                                                      .states![subsBillingPro
                                                          .stateIndex!]
                                                      .cities![subsBillingPro
                                                          .cityIndex!]
                                                      .suburbs!
                                                      .isEmpty
                                              ? []
                                              : subsBillingPro
                                                  .billingSubsAddSec!
                                                  .countries![subsBillingPro
                                                      .countryIndex!]
                                                  .states![subsBillingPro
                                                      .stateIndex!]
                                                  .cities![
                                                      subsBillingPro.cityIndex!]
                                                  .suburbs!
                                                  .map((e) => e.name ?? '')
                                                  .toList(),
                                      onChanged: (p0) {
                                        subsBillingPro.suburbIndex = p0;
                                        subsBillingPro.notify;
                                      },
                                    ),
                                    TitleTextForm(
                                      title: LN.street,
                                      pWidth: pWidth,
                                      borderColor: Colors.black26,
                                      textCltr: subsBillingPro.streetCltr,
                                    ),
                                    // SearchTitleDropDown(
                                    //   title: LN.city,
                                    //   pWidth: pWidth,
                                    //   isReq: true,
                                    //   borderColor: Colors.black26,
                                    //   list: subsBillingPro.countryIndex ==
                                    //               null ||
                                    //           subsBillingPro
                                    //                   .billingSubsAddSec
                                    //                   ?.countries?[
                                    //                       subsBillingPro
                                    //                           .countryIndex!]
                                    //                   .cities ==
                                    //               null
                                    //       ? []
                                    //       : subsBillingPro
                                    //           .billingSubsAddSec!
                                    //           .countries![
                                    //               subsBillingPro.countryIndex!]
                                    //           .cities!
                                    //           .map((e) => e.value ?? '')
                                    //           .toList(),
                                    //   indexVal: subsBillingPro.cityIndex,
                                    //   onChanged: (p0) {
                                    //     subsBillingPro.cityIndex = p0;
                                    //     subsBillingPro.notify;
                                    //   },
                                    // ),
                                    TitleTextForm(
                                      title: LN.postalCode,
                                      pWidth: pWidth,
                                      borderColor: Colors.black26,
                                      textCltr: subsBillingPro.postalCodeCltr,
                                      textInputType: TextInputType.number,
                                    ),
                                    // SearchTitleDropDown(
                                    //   title: LN.state,
                                    //   pWidth: pWidth,
                                    //   borderColor: Colors.black26,
                                    //   isReq: true,
                                    //   list: subsBillingPro.countryIndex ==
                                    //               null ||
                                    //           subsBillingPro
                                    //                   .billingSubsAddSec
                                    //                   ?.countries?[
                                    //                       subsBillingPro
                                    //                           .countryIndex!]
                                    //                   .states ==
                                    //               null
                                    //       ? []
                                    //       : subsBillingPro
                                    //           .billingSubsAddSec!
                                    //           .countries![
                                    //               subsBillingPro.countryIndex!]
                                    //           .states!
                                    //           .map((e) => e.value ?? '')
                                    //           .toList(),
                                    //   indexVal: subsBillingPro.stateIndex,
                                    //   onChanged: (p0) {
                                    //     subsBillingPro.stateIndex = p0;
                                    //     subsBillingPro.notify;
                                    //   },
                                    // ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Container _totalAmount(
    BuildContext context,
    Ssize size,
    double leftCard, {
    BillingSubsPlan? subsPlan,
    int? devicePlanIndex,
    Function(int?)? onChanged,
    String? curSym,
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
        width: leftCard,
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
                vPad: 8,
                fontSize: 14,
                indexValue: devicePlanIndex,
                onChange: onChanged,
              ),
            ),
            Spacer(),
            Text(
              widget.subsPro.selectedTab == 1
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

  Row _cardSection(
    Ssize size,
    int cardTextFlex,
    int cardFieldFlex, {
    required String title,
    required String subTitle,
    required TextEditingController textCltr,
    required TextInputType textInputType,
  }) {
    return Row(
      children: [
        Expanded(
          flex: cardTextFlex,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: size.getS(16),
                  fontFamily: kFontFMedium,
                  color: Colors.black,
                ),
              ),
              Text(
                subTitle,
                style: TextStyle(
                  fontSize: size.getS(14),
                  fontFamily: kFontFMedium,
                  color: Colors.black54,
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          width: size.getW(8),
        ),
        Expanded(
          flex: cardFieldFlex,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Expanded(
                child: TextFormWidget(
                  borderRadius: 5,
                  cltr: textCltr,
                  hintText: "",
                  textInputType: textInputType,
                  validator: textInputType == TextInputType.emailAddress
                      ? emailValidator
                      : null,
                  borderColor: Colors.black12,
                ),
              ),
              // SizedBox(
              //   width: size.getW(50),
              // )
            ],
          ),
        ),
      ],
    );
  }

  Row _expiryDate(
    Ssize size,
    int cardTextFlex,
    int cardFieldFlex, {
    required TextEditingController textCltr1,
    required TextEditingController textCltr2,
    required TextEditingController cvvCltr,
  }) {
    return Row(
      children: [
        Expanded(
          flex: cardTextFlex,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                LN.expiryDate,
                style: TextStyle(
                  fontSize: size.getS(16),
                  fontFamily: kFontFMedium,
                  color: Colors.black,
                ),
              ),
              Text(
                LN.expiryDateCard,
                style: TextStyle(
                  fontSize: size.getS(14),
                  fontFamily: kFontFMedium,
                  color: Colors.black54,
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          width: size.getW(8),
        ),
        Expanded(
          flex: cardFieldFlex,
          child: Row(
            children: [
              SizedBox(
                width: size.getW(56),
                child: TextFormWidget(
                  borderRadius: 5,
                  cltr: textCltr1,
                  hintText: "MM",
                  errH: 0,
                  textInputType: TextInputType.number,
                  maxLength: 2,
                  borderColor: Colors.black12,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                ),
              ),
              SizedBox(
                width: size.getW(24),
                child: Text(
                  "/",
                  style: TextStyle(
                    fontSize: size.getS(32),
                    fontFamily: kFontFMedium,
                    color: Colors.black,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(
                width: size.getW(72),
                child: TextFormWidget(
                  borderRadius: 5,
                  cltr: textCltr2,
                  hintText: "YY",
                  errH: 0,
                  textInputType: TextInputType.number,
                  maxLength: 4,
                  borderColor: Colors.black12,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                ),
              ),
              SizedBox(
                width: size.getW(24),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    LN.cvv,
                    style: TextStyle(
                      fontSize: size.getS(18),
                      fontFamily: kFontFMedium,
                      color: Colors.black,
                    ),
                  ),
                  Text(
                    LN.securityCode,
                    style: TextStyle(
                      fontSize: size.getS(14),
                      fontFamily: kFontFMedium,
                      color: Colors.black54,
                    ),
                  ),
                ],
              ),
              SizedBox(
                width: size.getW(12),
              ),
              Flexible(
                child: TextFormWidget(
                  borderRadius: 5,
                  cltr: cvvCltr,
                  hintText: "",
                  errH: 0,
                  textInputType: TextInputType.number,
                  borderColor: Colors.black12,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Row _cardNumber(
    Ssize size,
    int cardTextFlex,
    int cardFieldFlex, {
    required TextEditingController textCltr,
  }) {
    return Row(
      children: [
        Expanded(
          flex: cardTextFlex,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                LN.cardNum,
                style: TextStyle(
                  fontSize: size.getS(16),
                  fontFamily: kFontFMedium,
                  color: Colors.black,
                ),
              ),
              Text(
                LN.cardNumSub,
                style: TextStyle(
                  fontSize: size.getS(14),
                  fontFamily: kFontFMedium,
                  color: Colors.black54,
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          width: size.getW(8),
        ),
        Expanded(
          flex: cardFieldFlex,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Expanded(
                child: TextFormWidget(
                  borderRadius: 5,
                  borderColor: Colors.black12,
                  cltr: textCltr,
                  prefixIcon: Icon(
                    Icons.credit_card,
                    color: Colors.black54,
                  ),
                  hintText: "",
                  errH: 0,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(16),
                    CardNumberInputFormatter()
                  ],
                ),
              ),
              SizedBox(
                width: size.getW(12),
              ),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
                padding: EdgeInsets.all(size.getW(8)),
                child: Icon(
                  Icons.check,
                  color: Colors.grey,
                  size: size.getW(24),
                ),
              )
            ],
          ),
        ),
      ],
    );
  }
}

class CardNumberInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    var text = newValue.text;

    if (newValue.selection.baseOffset == 0) {
      return newValue;
    }

    var buffer = StringBuffer();
    for (int i = 0; i < text.length; i++) {
      buffer.write(text[i]);
      var nonZeroIndex = i + 1;
      if (nonZeroIndex % 4 == 0 && nonZeroIndex != text.length) {
        buffer.write('  '); // Add double spaces.
      }
    }

    var string = buffer.toString();
    return newValue.copyWith(
        text: string,
        selection: TextSelection.collapsed(offset: string.length));
  }
}
