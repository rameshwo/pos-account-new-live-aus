import 'package:flutter/material.dart';
import 'package:oktoast/oktoast.dart';
import 'package:pos_account/ln.dart';
import 'package:pos_account/model/billing_and_subs/all_bill_and_subs.dart';
import 'package:pos_account/model/billing_and_subs/billing_subs_add_sec.dart';
import 'package:pos_account/model/billing_and_subs/billing_subs_plan.dart';
import 'package:pos_account/model/billing_and_subs/subs_and_billing.dart';
import 'package:pos_account/repository/handler.dart';
import 'package:pos_account/services/database/shared_pref.dart';

class SubsBillingPro extends ChangeNotifier {
  List<BillingSubsPlan>? subsPlanList;

  List<BillingSubsPlan> hospitalityPlanList = [];
  List<BillingSubsPlan> retailPlanList = [];

  // bool loading = true;

  void get notify => notifyListeners();

  String? selectedPlanId;

  BillingSubsAddSec? billingSubsAddSec;

  bool subPlanListLoad = true;
  String? curSym;
  List<String> subsPlanGroup = [LN.hospitalityPricing, LN.retailPricing];
  int subsPlanIndex = 0;
  Future<void> getSubPlans() async {
    subsPlanList = await Handler.getBillingSubsPlan();
    if (subsPlanList != null) {
      subsPlanList!.forEach((element) {
        if (element.subscripitonPlanGroup == "Hospitality") {
          hospitalityPlanList.add(element);
        } else if (element.subscripitonPlanGroup == "Retail") {
          retailPlanList.add(element);
        }
      });
    }

    curSym = await SharedPrefs.curSym;
    selectedPlanId = null;
    devicePlanIndex = null;
    subPlanListLoad = false;
    notify;
  }

  Future<void> getBillingAddSec() async {
    subPlanListLoad = true;
    notify;

    billingSubsAddSec = await Handler.getBillingSubsAddSec();
    curSym = await SharedPrefs.curSym;
    setData();
    subPlanListLoad = false;
    notify;
  }

  setData() {
    if (billingSubsAddSec?.countries != null &&
        billingSubsAddSec!.countries!.any((e) => e.isSelected == true))
      countryIndex =
          billingSubsAddSec!.countries!.indexWhere((e) => e.isSelected!);
  }

  bool isAddNewCard = true;

  final cardNumCltr = TextEditingController();
  final expiryDateCltr1 = TextEditingController();
  final expiryDateCltr2 = TextEditingController();
  final cvvCltr = TextEditingController();
  final nameCardCltr = TextEditingController();
  final emailCltr = TextEditingController();

  int? countryIndex;
  int? cityIndex;
  int? stateIndex;
  int? suburbIndex;
  final streetCltr = TextEditingController();
  final postalCodeCltr = TextEditingController();
  bool acceptTerm = false;
  // final noOfPlanCltr = TextEditingController(text: '1');

  bool saveLoad = false;
  int? devicePlanIndex;

  // String get getTotalAmount {
  //   final val = double.tryParse(noOfPlanCltr.text);
  //   final int intVal = (val ?? 0.0).round();
  //   final _amountString = (subsPlanList != null &&
  //           subsPlanList!.any((e) => e.subscriptionPlanId == selectedPlanId))
  //       ? subsPlanList!
  //           .firstWhere((e) => e.subscriptionPlanId == selectedPlanId)
  //           .amount
  //       : '0.0';
  //   final double _amountDouble = double.tryParse(_amountString ?? '0.0') ?? 0.0;
  //   return (intVal * _amountDouble).roundToNString();
  // }

  Future<bool?> createPlan() async {
    if (!acceptTerm) {
      showToast(LN.acceptTerms);
      return null;
    }
    final subsPlan = SubsAndBilling()
      ..isTermsAndConditionAccepted = acceptTerm
      ..subscriptionPlanId = selectedPlanId
      ..isCommissionBasedPlan = selectedTab == 1
      ..creditCardDetails = selectedTab == 1
          ? null
          : CreditCardDetails(
              nameOnCard: nameCardCltr.text,
              cardNumber: cardNumCltr.text,
              cvcNumber: cvvCltr.text,
              expiryMonth: expiryDateCltr1.text,
              expiryYear: expiryDateCltr2.text,
              email: emailCltr.text,
            );
    if (subsPlanList != null &&
        subsPlanList!.any((e) => e.subscriptionPlanId == selectedPlanId) &&
        devicePlanIndex != null) {
      final subsPlan0 = subsPlanList!
          .firstWhere((e) => e.subscriptionPlanId == selectedPlanId)
          .numberOfDevicePlanPrices?[devicePlanIndex!];
      subsPlan.numberofPosLocation = subsPlan0?.numberOfDevice;
      if (selectedTab == 0) {
        subsPlan.totalAmount = subsPlan0?.price;
      }
    }
    subsPlan.billingAddressDetails = BillingAddressDetails();

    if (countryIndex != null) {
      subsPlan.billingAddressDetails?.countryId =
          billingSubsAddSec!.countries![countryIndex!].id;

      if (stateIndex != null) {
        subsPlan.billingAddressDetails?.stateId = billingSubsAddSec!
            .countries![countryIndex!].states![stateIndex!].id;

        if (cityIndex != null) {
          subsPlan.billingAddressDetails?.cityId = billingSubsAddSec!
              .countries![countryIndex!]
              .states![stateIndex!]
              .cities![cityIndex!]
              .id;

          if (suburbIndex != null) {
            subsPlan.billingAddressDetails?.suburbId = billingSubsAddSec!
                .countries![countryIndex!]
                .states![stateIndex!]
                .cities![cityIndex!]
                .suburbs![suburbIndex!]
                .id;
          }
        }
      }
    }

    subsPlan.billingAddressDetails?.street = streetCltr.text;
    subsPlan.billingAddressDetails?.postCode = postalCodeCltr.text;

    saveLoad = true;
    notify;

    final status = await Handler.createSubsAndBilling(subsAndBilling: subsPlan);

    saveLoad = false;
    notify;
    return status;
  }

  /// choose new plan
  bool isCardSelected = false;
  AllBillAndSubs? allBillAndSubs;

  bool loading2 = true;

  Future<void> getAllBillAndSubs() async {
    allBillAndSubs = await Handler.getAllBillAndSubs();
    curSym = await SharedPrefs.curSym;
    devicePlanIndex = null;
    selectedPlanId = null;
    // selectedPlanId =
    //     allBillAndSubs?.subscriptionPlanDetails?.storeSubscriptionPlanId;
    loading2 = false;
    notify;
  }

  bool changePlanLoad = false;

  Future<void> changePlan({BuildContext? ctx}) async {
    if (subsPlanList == null || allBillAndSubs == null) return;

    final billingPlan =
        subsPlanList!.firstWhere((e) => e.subscriptionPlanId == selectedPlanId);

    changePlanLoad = true;
    notify;

    final status = await Handler.changeBillSubsPlan(
      ssPlanId:
          allBillAndSubs?.subscriptionPlanDetails?.storeSubscriptionPlanId ??
              '',
      subsPlanId: billingPlan.subscriptionPlanId ?? '',
      numOfPosLoc: billingPlan
              .numberOfDevicePlanPrices![devicePlanIndex!].numberOfDevice ??
          '',
      ctx: ctx,
    );

    changePlanLoad = false;
    notify;

    if (status ?? false) {
      getAllBillAndSubs();
    }
  }

  void clearBilSubs() {
    isAddNewCard = true;
    cardNumCltr.clear();
    expiryDateCltr1.clear();
    expiryDateCltr2.clear();
    cvvCltr.clear();
    nameCardCltr.clear();
    emailCltr.clear();
    countryIndex = null;
    cityIndex = null;
    stateIndex = null;
    suburbIndex = null;
    streetCltr.clear();
    postalCodeCltr.clear();
    acceptTerm = false;
  }

  clear() {
    loading2 = true;
    allBillAndSubs = null;
    isCardSelected = false;
  }

  void clearListData() {
    hospitalityPlanList.clear();
    retailPlanList.clear();
    subsPlanIndex = 0;
  }

  // commision model
  int selectedTab = 0;
}
