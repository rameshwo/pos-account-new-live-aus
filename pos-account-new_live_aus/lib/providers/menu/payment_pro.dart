// import 'dart:convert';
// import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:pos_account/config/utils/order_utils.dart';
import 'package:pos_account/config/utils/promo_utils.dart';
import 'package:pos_account/config/validator.dart';
import 'package:pos_account/constant/strings.dart';
import 'package:pos_account/ln.dart';
import 'package:pos_account/model/common/table_id_name.dart';
import 'package:pos_account/model/home/menu/orders/order_detail_by_id.dart';
import 'package:pos_account/model/home/menu/orders/refund_order.dart';
import 'package:pos_account/model/home/menu/payment/cus_loyal_res.dart';
import 'package:pos_account/model/home/menu/payment/make_pay_res.dart';
import 'package:pos_account/model/home/menu/payment/refund_pay_res.dart';
import 'package:pos_account/model/home/menu/payment/uni_by_pay_res.dart';
import 'package:pos_account/model/home/menu/place_order/all_cus_add_sec.dart';
import 'package:pos_account/model/home/menu/place_order/pos_res/order_type_res.dart';
import 'package:pos_account/model/home/menu/place_order/pay_invoice_send_email_req.dart';
import 'package:pos_account/model/home/menu/place_order/place_order_req.dart';
import 'package:pos_account/model/home/menu/place_order/po_make_pay_req.dart';
import 'package:pos_account/model/home/menu/place_order/po_pay_sec_list_res.dart';
import 'package:pos_account/model/ui_model/amount_class.dart';
import 'package:pos_account/providers/cus_val_pro.dart';
import 'package:pos_account/repository/handler.dart';
import 'package:pos_account/repository/if_exception.dart';
import 'package:pos_account/services/database/shared_pref.dart';
import 'package:pos_account/services/payment/eft_payment.dart';

class PaymentPro extends ChangeNotifier {
  bool loading = true;
  bool loadingPay = false;
  bool loadingPayStk = false;
  bool loadReceiptPay = false;
  OnPayScreenFor onPayScreenFor = OnPayScreenFor.Payment;
  bool isOnPaymentScreen = false;

  String? curSym;

// retrieving previous data
  List<OrderTypeRes>? orderTypes;
  int? orderTypeIndex;
  final setMenuList = <SetMenuOrderDetail>[];
  final orderList = <OrderDetail>[];
  final ingreList = <RawIngredientOrderDetail>[];
  String? orderId;
  double? holidaySurCharge;

  // prev data //

  final discountPercentCltr = TextEditingController();
  final creCardCltr = TextEditingController();
  final serviceChargePerCltr = TextEditingController();
  bool isCheckPubHoCharge = false;
  bool isCheckCreCarCharge = false;
  bool isCheckServiceCharge = false;

  OrderDetailById? orderDetailById;

  CustomerAddSecRes? customerAddSecRes;
  PoPaySecListRes? paySecListRes;

  int? customerTypeIndex;
  int? customerGroupIndex;
  final formKey = GlobalKey<FormState>();
  bool loyalityEnable = false;

  final cusNameCltr = TextEditingController();
  final cusEmailCltr = TextEditingController();
  final cusPhoneCltr = TextEditingController();
  final postalCodeCltr = TextEditingController();
  int? phoneCodeIndex;
  int? countryIndex;

  bool recieveMarketMat = false;

  MakePaymentRes? makePaymentRes;

  CusForLoyalityRes? cusForLoyalityRes;
  final searchCusCltr = TextEditingController();

  final unicodeCltr = TextEditingController();
  UniByPayRes? uniByPayRes;
  String? voucherDiscountPercent;

  // PayInvoiceDetailRes? payInvoiceDetailRes;
  bool loadingInvoice = false;

  // Payment section
  final paidAmountCltr = TextEditingController();
  final tipCltr = TextEditingController();
  final commentCltr = TextEditingController();
  double? totalPayableAmount;

  //paid by user
  final amountPaidByUserCltr = TextEditingController();

  //credit card
  final nameOnCardCltr = TextEditingController();
  final cardNumberCltr = TextEditingController();
  final cVCNumberCltr = TextEditingController();
  final expiryMonthCltr = TextEditingController();
  final expiryYearCltr = TextEditingController();

  double? remainingAmount;

  bool isItemUpdated = false;

  int? cashIndex;

  String? doPayOrRefundFlag;

  set amountPaidByUser(String val) {
    amountPaidByUserCltr.text = val;
  }

  set setCashIndex(int index) {
    cashIndex = index;
  }

  final deliveryTextCltr = TextEditingController();

  /// This key is mainly used for refund either delivery amount is refund or not. if it's refund then
  /// make it false forever else it's true until delivery amount refund once.
  bool isDeliveryCheck = false;
  // bool isRevokePayment = false;

  String? taxExclusiveInclusiveType;
  double get taxPercentDDS =>
      GlobalCVP.storeInfo?.taxPercentage?.inDouble ??
      10; // tax percent for delivery, discount and surcharges
  // split amount case
  bool isSplitPerPerson = false;
  final splitPerPersonCltr = TextEditingController(text: '1');
  String? _remainingAfterGiftPay;
  String? remainingOnGiftPay;
  bool isSplitPayFinal = false;

  bool loyaltyRedeem = false;

  clear() {
    loading = true;
    cashIndex = null;
    deliveryTextCltr.clear();
    amountPaidByUserCltr.clear();
    tipCltr.clear();
    commentCltr.clear();
    paidAmountCltr.clear();
    discountPercentCltr.clear();
    creCardCltr.clear();
    serviceChargePerCltr.clear();
    totalPayableAmount = null;
    cusNameCltr.clear();
    cusEmailCltr.clear();
    cusPhoneCltr.clear();
    postalCodeCltr.clear();
    cusForLoyalityRes = null;
    searchCusCltr.clear();
    loadingInvoice = false;
    recieveMarketMat = false;
    customerTypeIndex = null;
    customerGroupIndex = null;
    uniByPayRes = null;
    voucherDiscountPercent = null;
    remainingAmount = null;
    phoneCodeIndex = null;
    countryIndex = null;
    onPayScreenFor = OnPayScreenFor.Payment;
    unicodeCltr.clear();
    //refund
    _refundOrderDetails.clear();
    _refundSetMenuDetails.clear();
    _refundRawIngreDetails.clear();
    refundTextCltr.clear();
    loadingPay = false;
    loadingPayStk = false;
    loadReceiptPay = false;
    nameOnCardCltr.clear();
    cardNumberCltr.clear();
    cVCNumberCltr.clear();
    expiryMonthCltr.clear();
    expiryYearCltr.clear();
    paymentType = PaymentType.FullPayment;
    orderId = null;
    // orderDetailById = null;
    eftReturnValue = null;
    eftIncompletePayReqData = null;
    eftIncompleteRefundReqData = null;
    refundDeliveryDisable = false;
    // isRevokePayment = false;
    doPayOrRefundFlag = null;
    taxExclusiveInclusiveType = null;
    isSplitPerPerson = false;
    isSplitPayFinal = false;
    splitPerPersonCltr.text = "1";
    _remainingAfterGiftPay = null;
    remainingOnGiftPay = null;
    loyaltyRedeem = false;
    customerTab = 0;
    showCusKeyPad = true;
    KeyPadfocusNode = null;
    isDisPercentTab = true;
    keyPadValue = '';
    focusKeyPad = null;
    searchLoad = false;
    payOnZeroSplitByItem = null;
    _finalItemPriceWithTax = 0.0;
    _finalItemPriceWithOutTax = 0.0;
    _finalPaidAmount = 0.0;
  }

  Future<void> getCurSym() async {
    curSym = await SharedPrefs.curSym;
    notify;
  }

  bool cusAddSecPageLoading = false;

  Future<void> cusAddSec() async {
    customerAddSecRes ??= CustomerAddSecRes.fromJson(GlobalCVP.allAddSection);
    //await Handler.getAllCusAddSecList();
    // cusAddSecPageLoading = false;
    setData(doUpdate: false);
    notify;
  }

  PoPaySecListRes? _initPaySecRes;

  Future<void> getData() async {
    getCurSym();
    // if (initLoad)
    _initPaySecRes = PoPaySecListRes.fromJson(GlobalCVP.allAddSection);
    //await Handler.getPosOrderPaySecList();
    // else
    //   _initPaySecRes ??= PoPaySecListRes.fromJson(GlobalCVP.allAddSection);
    //  await Handler.getPosOrderPaySecList();

    if (_initPaySecRes != null)
      paySecListRes = PoPaySecListRes.fromJson(_initPaySecRes!.toJson());

    // MxApi.apiKey =
    //     _initPaySecRes?.paymentIntegrationCredentials?.keyOrId?.text ?? '';
    // MxApi.secretKeyA =
    //     _initPaySecRes?.paymentIntegrationCredentials?.secret?.text ?? '';

    loading = false;
    notify;
  }

  setData({bool doUpdate = true, double totalAmount = 0.0}) {
    if (customerAddSecRes?.customerType != null &&
        customerAddSecRes!.customerType!.any((e) => e.isSelected ?? false)) {
      customerTypeIndex = customerAddSecRes!.customerType!
          .indexWhere((e) => e.isSelected ?? false);
    }
    if (customerAddSecRes?.customerGroups != null &&
        customerAddSecRes!.customerGroups!.any((e) => e.isSelected ?? false)) {
      customerGroupIndex = customerAddSecRes!.customerGroups!
          .indexWhere((e) => e.isSelected ?? false);
    }
    if (customerAddSecRes?.countries != null &&
        customerAddSecRes!.countries!.any((e) => e.isSelected ?? false)) {
      phoneCodeIndex = customerAddSecRes!.countries!
          .indexWhere((e) => e.isSelected ?? false);
      countryIndex = customerAddSecRes!.countries!
          .indexWhere((e) => e.isSelected ?? false);
    }

    // final _promoAmount = double.tryParse(paySecListRes
    //             ?.promotionalOfferViewModel?.promotionalOfferThresholdAmount ??
    //         '') ??
    //     0;

    // final _paymentType = orderDetailById?.orderDetailsViewModel?.paymentType;

    // if ((_paymentType == null || _paymentType.isEmpty) &&
    //     _promoAmount != 0 &&
    //     _promoAmount <= totalAmount) {
    //   discountPercentCltr.text = paySecListRes
    //           ?.promotionalOfferViewModel?.promotionalOfferDiscountPercentage ??
    //       '';
    // } else {
    //   // discountPercentCltr.clear();
    // }
    loading = false;

    if (doUpdate) onChangedPayAmount(isUpdatePaidAmount: false);
  }

  void onChangedPayAmount({
    bool isUpdatePaidAmount = true,
    bool hasDiscountOnPartial = false,
    bool isDisountPath = false,
  }) {
    final paidOrderDetail =
        orderDetailById?.orderPaymentDetailsWithPaymentStatusViewModel;

    if (remainingAmount != null &&
        (paidOrderDetail?.remainingAmount?.isNotEmpty ?? false)) {
      remainingAmount =
          (double.tryParse(paidOrderDetail!.remainingAmount!) ?? 0);
      if (remainingAmount == 0) remainingAmount = null;
    }

    // print('remaining amount server --- $remainingAmount $isUpdatePaidAmount');

    // final _giftAmount = double.tryParse(uniByPayRes?.amount ?? '');
    final _amount = getAllAmount;

    if (paymentType != PaymentType.SplitByItem) {
      PromoUtils.orderPromoAdvance(totalPrice: _finalItemPriceWithTax);
    } else {
      PromoUtils.promoOnTotalOrder = null;
    }

    if (isUpdatePaidAmount) {
      if (remainingAmount != null && paymentType != PaymentType.SplitByItem) {
        if (paymentType == PaymentType.PartialPayment && !isSplitPayFinal) {
          paidAmountCltr.text = "0.00";
        } else {
          paidAmountCltr.text = remainingAmount!.roundToNString();
        }
      } else if (remainingAmount != null &&
          paymentType == PaymentType.SplitByItem) {
        if (remainingOnGiftPay != null) {
          if ((remainingAmount! - remainingOnGiftPay.inDouble).abs() < 0.03) {
            paidAmountCltr.text = remainingAmount!.roundToNString();
          } else {
            paidAmountCltr.text = remainingOnGiftPay ?? '';
          }
        } else {
          // print(" _amount.paidAmount : ${_amount.paidAmount}");
          paidAmountCltr.text = _amount.paidAmount.roundToNString();
        }
      } else {
        paidAmountCltr.text = _amount.paidAmount.roundToNString();
      }
    } else if (_isCompletePayAfterSplit) {
      paidAmountCltr.text = remainingAmount!.roundToNString();
    } else if (hasDiscountOnPartial) {
      paidAmountCltr.text = _amount.paidAmount.roundToNString();
    }

    if (_giftAmount != 0 && _giftAmount < paidAmountCltr.text.inDouble) {
      paidAmountCltr.text = _giftAmount.roundToNString();
      // uniByPayRes?.amount ?? '0.00';
    } else if (remainingOnGiftPay?.isNotEmpty ?? false) {
      paidAmountCltr.text = remainingOnGiftPay ?? '';
    }

    if (remainingAmount != null) {
      double surcharges = (isCheckPubHoCharge ? _amount.pHSurCharge : 0.0) +
          (isCheckCreCarCharge ? _amount.ccSurCharge : 0) +
          (isCheckServiceCharge ? _amount.serviceCharge : 0.0);
      remainingAmount = remainingAmount! +
          surcharges -
          (paymentType == PaymentType.SplitByItem
              ? _amount.discountWithTax
              : 0);

      // kPrint(
      //     "remainingAmount: $remainingAmount || ${surcharges} ${_amount.discountWithTax} ");

      if (paymentType == PaymentType.PartialPayment && isSplitPerPerson) {
        // final _noOfPerson =
        //     double.tryParse(splitPerPersonCltr.text)?.floor() ?? 1;

        final _noOfPerson = orderDetailById
                ?.orderPaymentDetailsWithPaymentStatusViewModel
                ?.orderPaymentsDetailsViewModels
                ?.fold<int>(
                    0,
                    (pV, eV) =>
                        pV +
                        ((eV.paymentMethod?.toLowerCase().contains('loyal') ??
                                    false) ||
                                (eV.paymentMethod
                                        ?.toLowerCase()
                                        .contains('gift') ??
                                    false)
                            ? 0
                            : 1)) ??
            1;

        if (remainingOnGiftPay?.isNotEmpty ?? false) {
          final remainGift = (remainingOnGiftPay?.inDouble ?? 0) + surcharges;

          if ((remainingAmount! - remainGift).abs() <= 0.01 * _noOfPerson) {
            remainingAmount = remainGift;
          }
        }
      } else if (_isZeroTwo) {
        double _paidAmt = double.tryParse(paidAmountCltr.text) ?? 0.0;
        _paidAmt += remainingAmount! - payableAmount;
        paidAmountCltr.text = _paidAmt.roundToNString();

        if (_isZeroTwo) {
          remainingAmount = payableAmount;
        }
      }
      // print('new remaining amount server --- $remainingAmount');
    }

    if (onPayScreenFor == OnPayScreenFor.Refund) {
      refundTextCltr.text = _amount.paidAmount.nonNan().roundToNString();
      notify;
      return;
    }
    final tip = double.tryParse(tipCltr.text);

    double totalAmount = _amount.paidAmount.nonNan();
    // kPrint("isDisountPath: $isDisountPath totalAmount: $totalAmount");
    if (0 > totalAmount) {
      if (isDisountPath) {
        discountPercentCltr.clear();
        onChangedPayAmount(
            isUpdatePaidAmount: isUpdatePaidAmount,
            hasDiscountOnPartial: hasDiscountOnPartial);
        IfException.showMessage(
            message: "Discount amount exceeds the total amount");
      } else {
        IfException.showMessage(message: LN.somethingWentWrong);
      }
      return;
    }

    if (tip != null) totalAmount += tip;

    if (totalAmount < 0) totalAmount = 0;

    totalPayableAmount =
        _amount.finalPrice; //+ (double.tryParse(tipCltr.text) ?? 0);

    amountPaidByUserCltr.text = payableAmount.roundToNString();

    notify;
  }

  double get _taxCoff => OrderUtils.withoutTaxCoff(
      taxTypeString: taxExclusiveInclusiveType ?? '',
      taxPercent: taxPercentDDS);

  double get _disPercent => double.tryParse(discountPercentCltr.text) ?? 0;

  PoMakePaymentReq? get getPaymentRequest {
    if (orderId == null) return null;

    final _isSplitItemNLowGiftPay =
        (_remainingAfterGiftPay?.isNotEmpty ?? false);

    final _payReq = PoMakePaymentReq();
    _payReq.orderId = orderId;
    _payReq.paymentType =
        (paymentType == PaymentType.PartialPayment && isSplitPerPerson)
            ? "3"
            : paymentType.index.toString();

    if (paymentType == PaymentType.PartialPayment && isSplitPerPerson) {
      if (_isSplitItemNLowGiftPay) {
        _payReq.noOfCustomerOnTable = splitPerPersonCltr.text;
      } else {
        final _noOfPerson =
            double.tryParse(splitPerPersonCltr.text)?.floor() ?? 1;
        _payReq.noOfCustomerOnTable = _noOfPerson.toString();
      }
    } else {
      _payReq.noOfCustomerOnTable = splitPerPersonCltr.text;
    }

    if (paySecListRes != null &&
        paySecListRes!.paymentMethods != null &&
        paySecListRes!.paymentMethods!.isNotEmpty &&
        paySecListRes!.paymentMethods!
            .any((a) => a.isSelected != null && a.isSelected!))
      _payReq.paymentMethodId = paySecListRes!.paymentMethods!
          .firstWhere((e) => e.isSelected != null && e.isSelected!)
          .id;
    else
      _payReq.paymentMethodId = "";

    _payReq.paymentTipAmount = tipCltr.text;

    _payReq.isComplimentary = paySecListRes?.isComplimentary ?? false;

    final amount = getAllAmount;

    double surcharges = (isCheckPubHoCharge ? amount.pHSurCharge : 0.0) +
        (isCheckCreCarCharge ? amount.ccSurCharge : 0) +
        (isCheckServiceCharge ? amount.serviceCharge : 0.0);

    double charges = 0.0;

    if (paymentType != PaymentType.PartialPayment || _isCompletePayAfterSplit) {
      charges = surcharges;
    }

    final _paidAmount = (double.tryParse(paidAmountCltr.text) ?? 0) + charges;

    if (paymentType == PaymentType.PartialPayment && isSplitPerPerson) {
      _payReq.paidAmount = readOnlyPaidAmount;
    } else if (_isCompletePayAfterSplit) {
      _payReq.paidAmount = remainingAmount!.roundToNString();
    } else {
      _payReq.paidAmount = _paidAmount.roundToNString();
    }

    // final _giftAmount = double.tryParse(uniByPayRes?.amount ?? '');

    if (_giftAmount != 0 && _giftAmount < _paidAmount) {
      _payReq.paidAmount = _giftAmount.roundToNString();
    }

    double _totalPaymentAmount = 0.0;

    final paidOrderDetail =
        orderDetailById?.orderPaymentDetailsWithPaymentStatusViewModel;

    final paid_PHSurchargeWithTax =
        double.tryParse(paidOrderDetail?.holidaySurgeAmountWithTax ?? '0') ?? 0;

    final paid_ccSurChargeWithTax =
        double.tryParse(paidOrderDetail?.creditCardSurgeAmountWithTax ?? '0') ??
            0;

    final paid_ServiceCharge =
        double.tryParse(paidOrderDetail?.serviceChargeAmount ?? '0') ?? 0;

    if (remainingAmount !=
            null //|| (remainingAmount == null && paymentType == PaymentType.SplitByItem)
        ) {
      _totalPaymentAmount = (remainingAmount ?? 0);
    } else {
      final _pAMt = double.tryParse(_payReq.paidAmount ?? '') ?? 0;
      // print('remainingAmount: $remainingAmount ${_amount.finalPrice} - $_pAMt');
      if ((amount.finalPrice - _pAMt).abs() <= 0.01) {
        _totalPaymentAmount = _pAMt;
      } else {
        _totalPaymentAmount = amount.finalPrice.nonNan();
      }

      if (paymentType == PaymentType.SplitByItem &&
          orderDetailById?.orderPaymentDetailsWithPaymentStatusViewModel
                  ?.remainingAmount?.inDouble ==
              0 &&
          _pAMt == 0) {
        final _unPaidItemCount = (orderDetailById?.productWithPriceDetailsViewModel
                    ?.fold<double>(
                        0.0,
                        (a, b) =>
                            a +
                            (OrderUtils.getStatusEnum(b.statusId) ==
                                        OrderStatusEnum.release &&
                                    (b.quantity?.inDouble ?? 0) != 0 &&
                                    ((b.quantity?.inDouble ?? 0) !=
                                        (b.paidQuantity?.inDouble ?? 0))
                                ? 1.0
                                : 0.0)) ??
                0) +
            (orderDetailById?.setMenuWithPriceDetailsViewModel?.fold<double>(0.0, (a, b) => a + (OrderUtils.getStatusEnum(b.statusId) == OrderStatusEnum.release && (b.quantity?.inDouble ?? 0) != 0 && ((b.quantity?.inDouble ?? 0) != (b.paidQuantity?.inDouble ?? 0)) ? 1.0 : 0.0)) ??
                0) +
            (orderDetailById?.rawIngredientWithPriceDetailsViewModel?.fold<double>(
                    0.0,
                    (a, b) =>
                        a + (OrderUtils.getStatusEnum(b.statusId) == OrderStatusEnum.release && (b.quantity?.inDouble ?? 0) != 0 && ((b.quantity?.inDouble ?? 0) != (b.paidQuantity?.inDouble ?? 0)) ? 1.0 : 0.0)) ??
                0) +
            (orderDetailById?.productWithGroupPriceDetailsViewModel?.fold<double>(0.0, (a, c) => a + (c.productWithPriceDetailsViewModel?.fold<double>(0.0, (d, b) => d + (OrderUtils.getStatusEnum(b.statusId) == OrderStatusEnum.release && (b.quantity?.inDouble ?? 0) != 0 && ((b.quantity?.inDouble ?? 0) != (b.paidQuantity?.inDouble ?? 0)) ? 1.0 : 0.0)) ?? 0)) ?? 0);

        if (_unPaidItemCount == 0) {
          _totalPaymentAmount = 0;
        }
      }
    }
    _payReq.totalPaymentAmount = _totalPaymentAmount.roundToNString();

    // _payReq.discountPercentage = discountPercentCltr.text;

    ///////////////////// *delivery amount* /////////////////////
    ///
    double deliveryAmtWithoutTax = 0.0;
    double deliveryAmt = 0.0;

    _payReq.isDeliveryEnable = isDeliveryCheck;
    _payReq.isPaymentRevoked = false; // isRevokePayment;

    if (isOrderTypeDelivery && isDeliveryCheck) {
      deliveryAmt = double.tryParse(deliveryTextCltr.text) ?? 0;

      if (amount.taxType == TaxType.Inclusive) {
        deliveryAmtWithoutTax = deliveryAmt * _taxCoff;
        _payReq.deliveryAmountWithTax = deliveryAmt.nonNan().roundToNString();
      } else {
        deliveryAmtWithoutTax = deliveryAmt;
        _payReq.deliveryAmountWithTax =
            (deliveryAmt * (2 - _taxCoff)).nonNan().roundToNString();
      }

      _payReq.deliveryAmount = deliveryAmtWithoutTax.nonNan().roundToNString();
    } else {
      _payReq.deliveryAmount = "0.00";
      _payReq.deliveryAmountWithTax = "0.00";
    }

    ///////////////////// *public holiday surcharge* /////////////////////
    ///

    double pHSurchargeWithTax = 0.0;

    if (isCheckPubHoCharge) {
      if (amount.taxType == TaxType.Inclusive) {
        pHSurchargeWithTax = amount.pHSurCharge;
      } else {
        pHSurchargeWithTax = amount.pHSurCharge * (2 - _taxCoff);
      }
    }

    final _pSChargeWithTax = pHSurchargeWithTax + paid_PHSurchargeWithTax;

    _payReq.publicHolidaySurChargeAmount =
        (_pSChargeWithTax * _taxCoff).nonNan().roundToNString();
    _payReq.publicHolidaySurChargeAmoutWithTax =
        _pSChargeWithTax.nonNan().roundToNString();

    ///////////////////// ** /////////////////////
    ///
    /// ///////////////////// *credit card surcharge* /////////////////////
    ///

    _payReq.creditCardSurchargePercentage = creCardCltr.text;
    _payReq.serviceChargePercentage = serviceChargePerCltr.text;

    double cCSurchargeWithTax = 0.0;

    if (isCheckCreCarCharge) {
      if (amount.taxType == TaxType.Inclusive) {
        cCSurchargeWithTax = amount.ccSurCharge;
      } else {
        cCSurchargeWithTax = amount.ccSurCharge * (2 - _taxCoff);
      }
    }

    final _ccWithTax = cCSurchargeWithTax + paid_ccSurChargeWithTax;

    _payReq.creditCardSurChargeAmount =
        (_ccWithTax * _taxCoff).nonNan().roundToNString();
    _payReq.creditCardSurChargeAmountWithTax =
        _ccWithTax.nonNan().roundToNString();

    ///////////////////// ** /////////////////////

    ///////////////////// *service charge* /////////////////////
    ///

    double _serviceCharge = 0.0;

    if (isCheckServiceCharge) {
      _serviceCharge = amount.serviceCharge;
    }

    final _pServiceCharge = _serviceCharge + paid_ServiceCharge;

    _payReq.serviceChargeAmount = _pServiceCharge.nonNan().roundToNString();

    /// ///////////////////// *discount* /////////////////////

    // final itemPriceWithDeli = (amount.taxType == TaxType.Inclusive
    //         ? amount.finalItemPriceWithTax
    //         : amount.finalItemPriceWithOutTax) +
    //     deliveryAmt;

    // print("_itemPrice: $_itemPrice");
    // Promo discount
    // final _promoDiscount =
    //     PromoUtils.orderPromoAdvance(totalPrice: amount.totalPrice);
    // if (_promoDiscount?.discountPercent?.isNotEmpty ?? false) {
    //   if (discountPercentCltr.text.isNotEmpty &&
    //       discountPercentCltr.text != _promoDiscount?.discountPercent) {
    //     discountPercentCltr.text = _promoDiscount?.discountPercent ?? '';
    //   }
    // } else {
    //   final discount1 = orderDetailById
    //       ?.orderPaymentDetailsWithPaymentStatusViewModel
    //       ?.discountPercentage
    //       ?.inDouble;
    //   final discount2 = orderDetailById
    //       ?.orderPaymentDetailsWithPaymentStatusViewModel
    //       ?.voucherDiscountPercentage
    //       ?.inDouble;

    //   final _disValue = discount1 != 0
    //       ? (orderDetailById?.orderPaymentDetailsWithPaymentStatusViewModel
    //               ?.discountPercentage ??
    //           '')
    //       : discount2 != 0
    //           ? (orderDetailById?.orderPaymentDetailsWithPaymentStatusViewModel
    //                   ?.voucherDiscountPercentage ??
    //               '')
    //           : '';
    //   if (discountPercentCltr.text.isNotEmpty &&
    //       discountPercentCltr.text != _disValue) {
    //     discountPercentCltr.text = _disValue;
    //   }
    // }

    // final disValue = itemPriceWithDeli * _disPercent / 100;
    // final disTax = disValue *
    //     ((amount.finalItemTax + (deliveryAmt - deliveryAmtWithoutTax)) /
    //         itemPriceWithDeli);

    // _payReq.discountAmount =
    //     (disValue - (amount.taxType == TaxType.Inclusive ? disTax : 0))
    //         .nonNan()
    //         .roundToNString();
    // _payReq.discountAmountWithTax =
    //     (disValue + (amount.taxType == TaxType.Exclusive ? disTax : 0))
    //         .nonNan()
    //         .roundToNString();

    double disTax = 0.0;
    double _discountAmount = 0.0;
    double discountAmountWithTax = 0.0;
    double _allDiscountPercent = 0.0;

    if (discountList != null) {
      for (final a in discountList!) {
        if (a.discountType != DiscountType.GiftCard.name) {
          // log("dis: ${a.name} ${a.discountType} ${a.discountTax}");
          disTax += a.discountTax;
          _discountAmount += a.discountAmount.inDouble;
          discountAmountWithTax += a.discountAmountWithTax.inDouble;
          _allDiscountPercent += a.discountPercentage.inDouble;
        }
      }
    }

    final paid_DiscountWithTax =
        double.tryParse(paidOrderDetail?.discountWithTax ?? '0') ?? 0;
    final paid_Discount =
        double.tryParse(paidOrderDetail?.discount ?? '0') ?? 0;

    if (paymentType == PaymentType.SplitByItem) {
      _payReq.discountAmountWithTax =
          (discountAmountWithTax + paid_DiscountWithTax)
              .nonNan()
              .roundToNString();
      _payReq.discountAmount =
          (_discountAmount + paid_Discount).nonNan().roundToNString();
    } else {
      _payReq.discountAmount = _discountAmount.roundToNString();
      _payReq.discountAmountWithTax = discountAmountWithTax.roundToNString();
    }

    double totalPaidTipAmount = (double.tryParse(tipCltr.text) ?? 0);
    if (paidOrderDetail?.orderPaymentsDetailsViewModels?.isNotEmpty ?? false)
      for (final e in paidOrderDetail!.orderPaymentsDetailsViewModels!) {
        totalPaidTipAmount += double.tryParse(e.tipAmount ?? '0') ?? 0;
      }

    final finalAmountWIthoutTip = (totalPayableAmount ?? 0) +
        (paid_PHSurchargeWithTax +
            paid_ccSurChargeWithTax +
            paid_ServiceCharge -
            (paymentType == PaymentType.SplitByItem
                ? paid_DiscountWithTax
                : 0));

    // log("------= ${amount.taxFromItemToDel} - $disTax + ${(_payReq.publicHolidaySurChargeAmoutWithTax.inDouble - _payReq.publicHolidaySurChargeAmount.inDouble)} + ${(_payReq.creditCardSurChargeAmountWithTax.inDouble - _payReq.creditCardSurChargeAmount.inDouble)}");

    double _totalTax = amount.taxFromItemToDel -
        (paymentType == PaymentType.SplitByItem
            ? (_payReq.discountAmountWithTax.inDouble -
                _payReq.discountAmount.inDouble)
            : disTax) +
        (_payReq.publicHolidaySurChargeAmoutWithTax.inDouble -
            _payReq.publicHolidaySurChargeAmount.inDouble) +
        (_payReq.creditCardSurChargeAmountWithTax.inDouble -
            _payReq.creditCardSurChargeAmount.inDouble);

    _payReq.taxAmount = _totalTax.nonNan().roundToNString();

    final _finalTotal = (finalAmountWIthoutTip + totalPaidTipAmount);

    _payReq.finalTotalAmount = _finalTotal.roundToNString();

    _payReq.totalWithoutTaxAmount =
        amount.finalItemPriceWithOutTax.nonNan().roundToNString();

    if (remainingAmount == null ||
        orderDetailById?.orderDetailsViewModel?.paymentType == null ||
        paymentType == PaymentType.SplitByItem) {
      _payReq.orderDiscounts = discountList;
    }
    if (_getPayMethod == PayMethodEnum.GiftCard) {
      final _giftCardDiscount = _getGiftCardDiscount();
      if (_giftCardDiscount != null) {
        _payReq.orderDiscounts ??= [];
        _payReq.orderDiscounts!.add(_giftCardDiscount);
      }
    }

    // _payReq.channel = "POSMobile";

    if (cusForLoyalityRes != null) {
      _payReq.customerViewModel = CustomerViewModel();
      _payReq.customerViewModel!.id = cusForLoyalityRes!.id;
      _payReq.customerViewModel!.name = cusForLoyalityRes!.customerName;
      _payReq.customerViewModel!.email = cusForLoyalityRes!.email;
      _payReq.customerViewModel!.phoneNumber = cusForLoyalityRes!.phoneNumber;
      _payReq.customerViewModel!.postalCode = cusForLoyalityRes!.postalCode;

      if (cusForLoyalityRes?.id == null || cusForLoyalityRes!.id.isEmpty) {
        if (customerAddSecRes?.countries != null && phoneCodeIndex != null)
          _payReq.customerViewModel!.countryPhoneNumberPrefixId =
              customerAddSecRes!.countries![phoneCodeIndex!].id;
        if (customerAddSecRes?.countries != null && countryIndex != null)
          _payReq.customerViewModel!.countryId =
              customerAddSecRes!.countries![countryIndex!].id;

        if (customerTypeIndex != null &&
            customerAddSecRes?.customerType != null &&
            customerAddSecRes!.customerType!.isNotEmpty)
          _payReq.customerViewModel!.customerTypeId =
              customerAddSecRes!.customerType![customerTypeIndex!].id;

        if (customerGroupIndex != null &&
            customerAddSecRes?.customerGroups != null &&
            customerAddSecRes!.customerGroups!.isNotEmpty)
          _payReq.customerViewModel!.customerGroupId =
              customerAddSecRes!.customerGroups![customerGroupIndex!].id;

        _payReq.customerViewModel!.isMarketingPromotionEnabled =
            recieveMarketMat;
        _payReq.customerViewModel!.isLoyaltyEnabled = loyalityEnable;
      } else {
        _payReq.customerViewModel!.customerTypeId =
            cusForLoyalityRes?.customerTypeId;

        _payReq.customerViewModel!.isMarketingPromotionEnabled =
            cusForLoyalityRes?.isMarketingPromotionEnabled ?? false;

        _payReq.customerViewModel!.isLoyaltyEnabled =
            cusForLoyalityRes?.loyaltyEnabled ?? false;

        _payReq.customerViewModel!.countryPhoneNumberPrefixId =
            cusForLoyalityRes?.countryPhoneNumberPrefixId;

        _payReq.customerViewModel!.countryId = cusForLoyalityRes?.countryId;
      }
    }

    //credit card
    // _payReq.creditCardViewModel = CreditCardViewModel();
    // _payReq.creditCardViewModel!.nameOnCard = nameOnCardCltr.text;
    // _payReq.creditCardViewModel!.cardNumber = cardNumberCltr.text;
    // _payReq.creditCardViewModel!.cVCNumber = cVCNumberCltr.text;
    // _payReq.creditCardViewModel!.expiryMonth = expiryMonthCltr.text;
    // _payReq.creditCardViewModel!.expiryYear = expiryYearCltr.text;

    //redeem code
    if (_getPayMethod == PayMethodEnum.GiftCard) {
      _payReq.reedemCode = uniByPayRes?.uniqueCode;
    } else if ((remainingAmount ?? 0) == 0) {
      _payReq.reedemCode = uniByPayRes?.uniqueCode;
    }
    ///////////////////// * split by Item * /////////////////////
    ///

    final orderItemList = <OrderDetailsModel>[];

    // if (paymentType == PaymentType.SplitByItem) {
    for (final e in orderList) {
      final itemDiscountValue =
          e.finalTotalSellingAmount * _allDiscountPercent / 100;
      final itemDisTax = itemDiscountValue * (1 - _taxCoff);

      final _finalTotalDiscount = amount.taxType == TaxType.Inclusive
          ? itemDiscountValue - itemDisTax
          : itemDiscountValue;

      final _finalTotalDiscountWithTax = amount.taxType == TaxType.Inclusive
          ? itemDiscountValue
          : itemDiscountValue + itemDisTax;

      final item = OrderDetailsModel(
        id: e.id,
        productId: e.productId,
        productVariationId: e.productVariationId,
        isPublicHolidaySurchargeUsed:
            e.isSelected && paymentType == PaymentType.SplitByItem
                ? isCheckPubHoCharge
                : e.isPubChargeEnable,
        isCreditCardSurchargeUsed:
            e.isSelected && paymentType == PaymentType.SplitByItem
                ? isCheckCreCarCharge
                : e.isCreditChargeEnable,
        isServiceChargeUsed:
            e.isSelected && paymentType == PaymentType.SplitByItem
                ? isCheckServiceCharge
                : e.isServiceChargeEnable,
        // eod report
        finalTotalSellingAmount: e.finalTotalSellingAmount.roundToNString(),
        finalTotalTax: e.finalTotalTax.roundToNString(),
        finalTotalDiscount: _finalTotalDiscount.roundToNString(),
        finalTotalDiscountWithTax: _finalTotalDiscountWithTax.roundToNString(),
      );
      if (e.isSelected && paymentType == PaymentType.SplitByItem) {
        item.paidQuantity = _isSplitItemNLowGiftPay ? "0" : "${e.quantity}";
        item.currentPaidQuantity =
            _isSplitItemNLowGiftPay ? "${e.quantity}" : "0";
      }
      if (paymentType != PaymentType.SplitByItem) {
        item.paidAmount = readOnlyPaidAmount;
      }

      orderItemList.add(item);
    }

    _payReq.orderDetailsModel = orderItemList;

    // setMenu details

    final setMenuListt = <SetMenuDetailModel>[];

    for (final e in setMenuList) {
      final itemDiscountValue0 =
          e.finalTotalSellingAmount * _allDiscountPercent / 100;
      final itemDisTax0 = itemDiscountValue0 * (1 - _taxCoff);

      final _finalTotalDiscount = amount.taxType == TaxType.Inclusive
          ? itemDiscountValue0 - itemDisTax0
          : itemDiscountValue0;

      final _finalTotalDiscountWithTax = amount.taxType == TaxType.Inclusive
          ? itemDiscountValue0
          : itemDiscountValue0 + itemDisTax0;

      final item0 = SetMenuDetailModel(
        id: e.id,
        setMenuId: e.setMenuId,
        isPublicHolidaySurchargeUsed:
            e.isSelected && paymentType == PaymentType.SplitByItem
                ? isCheckPubHoCharge
                : e.isPubChargeEnable,
        isCreditCardSurchargeUsed:
            e.isSelected && paymentType == PaymentType.SplitByItem
                ? isCheckCreCarCharge
                : e.isCreditChargeEnable,
        isServiceChargeUsed:
            e.isSelected && paymentType == PaymentType.SplitByItem
                ? isCheckServiceCharge
                : e.isServiceChargeEnable,
        // eod report
        finalTotalSellingAmount: e.finalTotalSellingAmount.roundToNString(),
        finalTotalTax: e.finalTotalTax.roundToNString(),
        finalTotalDiscount: _finalTotalDiscount.roundToNString(),
        finalTotalDiscountWithTax: _finalTotalDiscountWithTax.roundToNString(),
      );

      if (e.isSelected && paymentType == PaymentType.SplitByItem) {
        item0.paidQuantity =
            _isSplitItemNLowGiftPay ? "0" : "${e.setMenuQuantity}";
        item0.currentPaidQuantity =
            _isSplitItemNLowGiftPay ? "${e.setMenuQuantity}" : "0";
      }
      if (paymentType != PaymentType.SplitByItem) {
        item0.paidAmount = readOnlyPaidAmount;
      }

      setMenuListt.add(item0);
    }

    _payReq.setMenuDetails = setMenuListt;

    // order details

    final rawIngreList = <RawLooseIngredientDetail>[];

    for (final e in ingreList) {
      final itemDiscountValue0 =
          e.finalTotalSellingAmount * _allDiscountPercent / 100;
      final itemDisTax0 = itemDiscountValue0 * (1 - _taxCoff);

      final _finalTotalDiscount = amount.taxType == TaxType.Inclusive
          ? itemDiscountValue0 - itemDisTax0
          : itemDiscountValue0;

      final _finalTotalDiscountWithTax = amount.taxType == TaxType.Inclusive
          ? itemDiscountValue0
          : itemDiscountValue0 + itemDisTax0;

      final item0 = RawLooseIngredientDetail(
        id: e.id,
        isPublicHolidaySurchargeUsed:
            e.isSelected && paymentType == PaymentType.SplitByItem
                ? isCheckPubHoCharge
                : e.isPubChargeEnable,
        isCreditCardSurchargeUsed:
            e.isSelected && paymentType == PaymentType.SplitByItem
                ? isCheckCreCarCharge
                : e.isCreditChargeEnable,
        isServiceChargeUsed:
            e.isSelected && paymentType == PaymentType.SplitByItem
                ? isCheckServiceCharge
                : e.isServiceChargeEnable,
        // eod report
        finalTotalSellingAmount: e.finalTotalSellingAmount.roundToNString(),
        finalTotalTax: e.finalTotalTax.roundToNString(),
        finalTotalDiscount: _finalTotalDiscount.roundToNString(),
        finalTotalDiscountWithTax: _finalTotalDiscountWithTax.roundToNString(),
      );

      if (e.isSelected &&
          e.initQty != e.paidQuantity &&
          paymentType == PaymentType.SplitByItem) {
        item0.paidQuantity = _isSplitItemNLowGiftPay ? "0" : "${e.quantity}";
        item0.currentPaidQuantity =
            _isSplitItemNLowGiftPay ? "${e.quantity}" : "0";
      }

      if (paymentType != PaymentType.SplitByItem) {
        item0.paidAmount = readOnlyPaidAmount;
      }

      rawIngreList.add(item0);
    }

    _payReq.rawLooseIngredientDetails = rawIngreList;
    // }
////

    _payReq.comments = commentCltr.text;
    _payReq.remainingAmountOnGiftPay = _remainingAfterGiftPay ?? '';
    _payReq.holidaySurchargeType =
        GlobalCVP.storeInfo?.holidaySurcharge?.holidaySurchargeType;

    /// to get variance 0, we use cc surcharge as variable to get variance 0

    OrderUtils.checkPayData(_payReq, orderDetailById: orderDetailById);

    // print("--------------------------");

    // Utils.checkPayData(_payReq, orderDetailById: orderDetailById);

    return _payReq;
  }

  PoMakePaymentReq? _setPayReqWithEftVal(
    final PoMakePaymentReq? payReq, {
    EFTReturnValue? eftValue,
  }) {
    if (eftValue != null) {
      payReq?.transactionRefId = eftValue.refId;
      payReq?.eftPosMerchantType = eftValue.merchantType;
      payReq?.integrationPlatformTerminalId = eftValue.terminalId;
      payReq?.merchantCardSurchargeAmount =
          eftValue.merchantSurcharge.formatDouble;
      // _payReq?.transactionSessionId = eftValue.sessionIdLinky;

      payReq?.eftposSerialNumber = eftValue.serialNumber;
      payReq?.merchantInvoiceRequestViewModel = MerchantInvoiceRequestViewModel(
        merchantInvoiceData: eftValue.merchantReceipt,
        // Utils.decodeAndFormatData(eftValue.merchantReceipt),
        customerInvoiceData: eftValue.customerReceipt,
        //  eftValue.merchantType == Strings.linkyMerchant ? eftValue.customerReceipt :
        // Utils.decodeAndFormatData(eftValue.customerReceipt),
      );
    }

    return payReq;
  }

  Future<bool?> makePayment({
    EFTReturnValue? eftValue,
    bool isEftIncomplete = false,
    bool isLoadStk = false,
  }) async {
    makePaymentRes = null;
    if (cusForLoyalityRes == null && customerTab == 1) {
      cusForLoyalityRes = CusForLoyalityRes();
      cusForLoyalityRes!.loyaltyEnabled = loyalityEnable;
      cusForLoyalityRes!.customerName = cusNameCltr.text;
      cusForLoyalityRes!.phoneNumber = cusPhoneCltr.text;
      cusForLoyalityRes!.email = cusEmailCltr.text;
      cusForLoyalityRes!.postalCode = postalCodeCltr.text;
    }

    final _payReq = _setPayReqWithEftVal(
        isEftIncomplete ? eftIncompletePayReqData : getPaymentRequest,
        eftValue: eftValue);

    //TODO: make payment
    // log(json.encode(_payReq?.toJson()));
    // return null;

    if (_payReq == null) return null;

    _payReq.isSendToKitchen = isLoadStk;

    if (isLoadStk)
      loadingPayStk = true;
    else
      loadingPay = true;
    notify;
    final _payRes = await Handler.placeOrderMakePays(paymentReq: _payReq);
    makePaymentRes =
        _payRes != null ? MakePaymentRes.fromJson(_payRes.toJson()) : null;

    if (_payRes?.isPaymentCompleted ?? false) {
      final _printRes =
          await Handler.orderPayInvoice(orderId: _payReq.orderId ?? '');
      if (_printRes != null) {
        makePaymentRes = _printRes;
      }
      // makePaymentRes?.sendToKitchenPrinter = _payRes?.sendToKitchenPrinter;
      // makePaymentRes?.sendToKitchenDisplay = _payRes?.sendToKitchenDisplay;
    }
    if (isLoadStk)
      loadingPayStk = false;
    else
      loadingPay = false;
    eftReturnValue = null;
    eftIncompletePayReqData = null;
    _remainingAfterGiftPay = null;
    if (makePaymentRes != null) {
      loyaltyRedeem = false;
      if (paymentType == PaymentType.PartialPayment)
        isSplitPayFinal = true;
      else
        isSplitPayFinal = false;
    }
    _ifIncompletePayment();
    notify;
    return makePaymentRes != null;
  }

  Future<MakePaymentRes?> printReceipt() async {
    final payReq = getPaymentRequest;
    if (payReq == null) return null;

    loadReceiptPay = true;
    loading = true;
    notify;
    final _status = await Handler.printReceipt(paymentReq: payReq);
    MakePaymentRes? _res;
    if (_status != null) {
      _res = await Handler.orderPayInvoice(orderId: payReq.orderId ?? '');
    }
    loadReceiptPay = false;
    loading = false;
    notify;

    return _res;
  }

  _ifIncompletePayment() {
    if (makePaymentRes == null) return;

    if (makePaymentRes?.remainingAmount == null) {
      remainingAmount = null;
      return;
    }
    unicodeCltr.clear();
    uniByPayRes = null;

    tipCltr.clear();
    commentCltr.clear();
    _remainingAfterGiftPay = null;
    remainingOnGiftPay = null;
  }

  // search customer seciton
  bool searchLoad = false;

  Future<void> searchCustomer(String val,
      {String? cusId, bool showMsg = false}) async {
    if (cusId != null) {
      cusForLoyalityRes =
          await Handler.searchCustomer(cusId: cusId, showMessage: showMsg);
    } else {
      cusForLoyalityRes =
          await Handler.searchCustomer(phoneNumber: val, showMessage: showMsg);

      // cusForLoyalityRes ??=
      //     await Handler.searchCustomer(email: val, showMessage: showMsg);
    }
    orderDetailById?.customerUserViewModel = CustomerUserViewModel(
      email: cusForLoyalityRes?.email,
      name: cusForLoyalityRes?.customerName,
      phoneNumber: cusForLoyalityRes?.phoneNumber,
      message: cusForLoyalityRes?.message,
    );
    setSearchCusData();
    if (cusForLoyalityRes != null) showCusKeyPad = false;
    notify;
  }

  setSearchCusData() {
    if (cusForLoyalityRes == null) return;
    loyalityEnable = cusForLoyalityRes!.loyaltyEnabled ?? false;
  }

  Future<void> uniCodeSearch(String? val) async {
    final _payMethoId = paySecListRes!.paymentMethods!
            .firstWhere((e) => e.isSelected != null && e.isSelected!)
            .id ??
        '';
    uniByPayRes = await Handler.searchUnicode(
        uniCode: unicodeCltr.text, payMenthod: _payMethoId);

    if ((uniByPayRes?.discountPercentage?.isNotEmpty ?? false) &&
        _getPayMethod != PayMethodEnum.GiftCard) {
      voucherDiscountPercent = uniByPayRes?.discountPercentage;
    }
    if (uniByPayRes?.receiverCustomerId?.isNotEmpty ?? false) {
      await searchCustomer('',
          cusId: uniByPayRes?.receiverCustomerId, showMsg: true);
    } else if (uniByPayRes?.receiverEmail != null &&
        uniByPayRes!.receiverEmail!.isNotEmpty) {
      // searchCusCltr.text = uniByPayRes!.receiverEmail!;
      await searchCustomer(uniByPayRes!.receiverPhoneNumber!, showMsg: true);
      if (cusForLoyalityRes == null) {
        await searchCustomer(uniByPayRes!.receiverEmail!, showMsg: true);
      }
    }
    setUniSearchData();
    // notifyListeners();
  }

  void setUniSearchData({bool isUpdatePaidAmt = true}) {
    if (uniByPayRes != null) {
      if (uniByPayRes!.isDiscount != null && uniByPayRes!.isDiscount!) {
        if (uniByPayRes!.discountPercentage != null) {
          // TODO: may remove later
          if ((remainingAmount ?? 0) != 0) {
            IfException.showMessage(message: LN.disCantApplied);
            return;
          }
          //////
          ///DIS_REMOVE
          // discountPercentCltr.text = uniByPayRes!.discountPercentage ?? '';

          onChangedPayAmount(isUpdatePaidAmount: isUpdatePaidAmt);
        }
      } else {
        onChangedPayAmount(isUpdatePaidAmount: isUpdatePaidAmt);
      }
    } else {
      onChangedPayAmount(isUpdatePaidAmount: isUpdatePaidAmt);
    }
    onChangedPayAmount(isUpdatePaidAmount: false);
  }

  // Future<void> getPayDetailInvoice({String? orderId}) async {
  //   if (orderId == null) return;
  //   payInvoiceDetailRes =
  //       await Handler.getPaymentInvoiceDetail(orderId: orderId);
  //   loadEmail = false;
  //   notifyListeners();
  // }

  void get notify => notifyListeners();

//calculating with discount
  AmountClass get getAllAmount {
    final _amount = OrderUtils.orderAmount(
      setMenuList: setMenuList,
      orderList: orderList,
      ingreList: ingreList,
      taxTypeString: taxExclusiveInclusiveType ?? '',
      onPayScreenFor: onPayScreenFor,
      orderTypeId: (orderTypes?.isNotEmpty ?? false) &&
              orderTypeIndex != null &&
              orderTypes!.length > orderTypeIndex!
          ? (orderTypes?[orderTypeIndex!].id ?? '')
          : '',
    );

    // print("finalPrice : ${_amount.finalPrice}");

    if (isItemUpdated) {
      return _amount;
    }

    if (onPayScreenFor == OnPayScreenFor.Refund) {
      _amount.taxFromItemToDel = _amount.totalTax;
    } else {
      _amount.taxFromItemToDel = _amount.finalItemTax;
    }

    final _tempTaxRate = 1 -
        OrderUtils.withoutTaxCoff(
            taxTypeString: taxExclusiveInclusiveType ?? '',
            taxPercent: taxPercentDDS);

    ///

    ///discount//////
    _finalPaidAmount = _amount.totalPrice;
    _finalItemPriceWithTax = _amount.finalItemPriceWithTax;
    _finalItemPriceWithOutTax = _amount.finalItemPriceWithOutTax;
    setDiscountList();

    if (discountList != null) {
      for (final a in discountList!) {
        // kPrint("${a.discountType} ${a.discountAmountWithTax}");
        _amount.totalTax -= a.discountTax.roundToN();
        // kPrint("totalTax: ${_amount.totalTax} ${a.discountTax}");

        _amount.discount += a.discountAmount.inDouble;
        _amount.discountWithTax += a.discountAmountWithTax.inDouble;

        _amount.totalPrice -= a.discountAmountWithTax.inDouble;

        if (_amount.taxType == TaxType.Inclusive) {
          _amount.finalPrice -= a.discountAmountWithTax.inDouble;
        } else {
          _amount.finalPrice -= a.discountAmount.inDouble;
        }
      }
    }

    /// delivery ////////
    ///

    final _deliveryAmt = isOrderTypeDelivery && isDeliveryCheck
        ? (double.tryParse(deliveryTextCltr.text) ?? 0)
        : 0.0;
    final _deliveryTax = _deliveryAmt * _tempTaxRate;

    if (isOrderTypeDelivery && isDeliveryCheck) {
      _amount.totalTax += _deliveryTax.roundToN();
      _amount.taxFromItemToDel += _deliveryTax.roundToN();

      if (_amount.taxType == TaxType.Inclusive) {
        _amount.totalPrice += _deliveryAmt.roundToN();
        _amount.finalPrice += _deliveryAmt.roundToN();
      } else {
        _amount.totalPrice += (_deliveryAmt + _deliveryTax).roundToN();
        _amount.finalPrice += (_deliveryAmt + _deliveryTax).roundToN();
      }
    }

    // kPrint(
    //     "finalPrice : ${_amount.finalPrice} || discountWithTax : ${_amount.discountWithTax}");

    // final discountPercent =
    //     _disPercent; // double.tryParse(discountPercentCltr.text) ?? 0;
    // if (discountPercent != 0) {
    //   final _discountValue = _amount.totalPrice * discountPercent / 100;

    //   // this discount tax value is to show only

    //   final _discountTax =
    //       _discountValue * _amount.totalTax / _amount.totalPrice;
    //   _amount.totalTax -= _discountTax.roundToN();

    //   double _finalDiscount = _amount.finalPrice * discountPercent / 100;

    //   if (_amount.taxType == TaxType.Inclusive) {
    //     _amount.discount = (_discountValue - _discountTax).roundToN();
    //     _amount.discountWithTax = _discountValue.roundToN();
    //   } else {
    //     _amount.discount = _discountValue.roundToN();
    //     _amount.discountWithTax = (_discountValue + _discountTax).roundToN();
    //   }

    //   _amount.totalPrice -= _amount.discountWithTax.roundToN();
    //   _amount.finalPrice -= _finalDiscount.roundToN();
    // }

    // print("finalPrice : ${_amount.finalPrice}");

    _amount.paidAmount = _amount.totalPrice;

    double tempTotal = 0.0;

    double chargeOnMiddleCase = 0.0;

    if (onPayScreenFor == OnPayScreenFor.Refund) {
      tempTotal = double.tryParse(refundTextCltr.text) ?? 0;
    } else {
      // final _giftAmount = uniByPayRes?.amount.inDouble ?? 0;
      _remainingAfterGiftPay = null;

      if (paymentType == PaymentType.PartialPayment) {
        if (_giftAmount != 0) {
          if (isSplitPerPerson) {
            final _noOfPerson =
                double.tryParse(splitPerPersonCltr.text)?.floor() ?? 1;

            double? _totalPaidWithoutCharge =
                getPaidAmtWthOutChargeOnSplitPerPerson;

            double _paidPerPerson = 0.0;

            if (_totalPaidWithoutCharge != null) {
              _paidPerPerson =
                  (_amount.paidAmount - _totalPaidWithoutCharge) / _noOfPerson;
            } else {
              _paidPerPerson = _amount.paidAmount / _noOfPerson;
            }

            final _tAmount = _tempAmountWSurcharge(tempAmount: _paidPerPerson);

            if (_paidPerPerson < _giftAmount && _tAmount > _giftAmount) {
              tempTotal = _paidPerPerson;
              final _remainWIthoutSur =
                  getSplitAmountTemp(_tAmount - _giftAmount);
              _remainingAfterGiftPay = _remainWIthoutSur.roundToNString();
              chargeOnMiddleCase = _remainWIthoutSur;
            } else if (_paidPerPerson < _giftAmount) {
              if ((remainingOnGiftPay?.isNotEmpty ?? false) &&
                  remainingOnGiftPay.inDouble < _giftAmount) {
                tempTotal = remainingOnGiftPay.inDouble;
              } else {
                tempTotal = _paidPerPerson;
              }
            } else if ((remainingOnGiftPay?.isNotEmpty ?? false) &&
                remainingOnGiftPay.inDouble < _giftAmount) {
              tempTotal = remainingOnGiftPay.inDouble;
            } else {
              tempTotal = getGiftSplitAmountTemp;

              if (remainingOnGiftPay?.isNotEmpty ?? false) {
                _remainingAfterGiftPay =
                    (remainingOnGiftPay.inDouble - tempTotal).roundToNString();
              } else {
                _remainingAfterGiftPay =
                    (_paidPerPerson - tempTotal).roundToNString();
              }
            }
          } else {
            final paidAmt = double.tryParse(paidAmountCltr.text) ?? 0.0;
            final tAmount = _tempAmountWSurcharge(tempAmount: paidAmt);

            if (paidAmt < _giftAmount && _giftAmount < tAmount) {
              tempTotal = paidAmt;
              chargeOnMiddleCase = getSplitAmountTemp(tAmount - _giftAmount);
            } else if (_giftAmount < paidAmt) {
              tempTotal = getSplitAmountTemp(_giftAmount);
            } else {
              tempTotal = paidAmt;
            }

            // print("_tempTotal : $_tempTotal");
          }
        } else {
          if (isSplitPerPerson) {
            if (remainingOnGiftPay?.isNotEmpty ?? false) {
              tempTotal = remainingOnGiftPay!.inDouble;
            } else {
              final _noOfPerson =
                  double.tryParse(splitPerPersonCltr.text)?.floor() ?? 1;

              double? _totalPaidWithoutCharge =
                  getPaidAmtWthOutChargeOnSplitPerPerson;
              if (_totalPaidWithoutCharge != null) {
                tempTotal = (_amount.paidAmount - _totalPaidWithoutCharge) /
                    _noOfPerson;
              } else {
                tempTotal = _amount.paidAmount / _noOfPerson;
              }
            }
          } else if (_isCompletePayAfterSplit)
            tempTotal = double.tryParse(paidAmountCltr.text) ?? 0;
          else
            tempTotal =
                getSplitAmountTemp(double.tryParse(paidAmountCltr.text) ?? 0.0);
        }
      } else {
        if (_giftAmount != 0) {
          if (paymentType == PaymentType.FullPayment) {
            final paidAmt = double.tryParse(paidAmountCltr.text) ?? 0;
            final tempPaidAmtWithCharge =
                _tempAmountWSurcharge(tempAmount: paidAmt);

            if (paidAmt < _giftAmount && _giftAmount < tempPaidAmtWithCharge) {
              final remainWIthoutSur =
                  getSplitAmountTemp(tempPaidAmtWithCharge - _giftAmount);
              chargeOnMiddleCase = remainWIthoutSur;
              tempTotal = paidAmt;
            } else if (_giftAmount < paidAmt) {
              tempTotal = getGiftSplitAmountTemp;
            } else {
              tempTotal = paidAmt;
            }
          } else {
            if (paymentType == PaymentType.SplitByItem) {
              final totalTempAmount = remainingOnGiftPay.inDouble != 0
                  ? _tempAmountWSurcharge(
                      tempAmount: remainingOnGiftPay.inDouble)
                  : _tempAmountWSurcharge(tempAmount: _amount.paidAmount);

              if (_giftAmount < totalTempAmount) {
                tempTotal = getGiftSplitAmountTemp;
                if (remainingOnGiftPay?.isNotEmpty ?? false) {
                  _remainingAfterGiftPay =
                      (remainingOnGiftPay.inDouble - tempTotal)
                          .roundToNString();
                } else {
                  _remainingAfterGiftPay =
                      (_amount.paidAmount - tempTotal).roundToNString();
                }
              } else {
                if (remainingOnGiftPay?.isNotEmpty ?? false) {
                  tempTotal = remainingOnGiftPay.inDouble;
                } else {
                  tempTotal = _amount.paidAmount;
                }
              }
            }
          }
        } else if (paymentType == PaymentType.FullPayment) {
          tempTotal = double.tryParse(paidAmountCltr.text) ?? 0;
        } else if (remainingOnGiftPay?.isNotEmpty ?? false) {
          tempTotal = remainingOnGiftPay!.inDouble;
        } else {
          tempTotal = _amount.paidAmount;
        }
      }
    }

    if (tempTotal <= 0) return _amount;

    double holidaySurChargeAmt = 0.0;

    double _holiSurchargeWithTax = 0.0;
    double _holiSurChargeTax = 0.0;

    if (holidaySurCharge != null && isCheckPubHoCharge) {
      holidaySurChargeAmt =
          ((tempTotal - chargeOnMiddleCase) * holidaySurCharge! / 100);
      _holiSurChargeTax = holidaySurChargeAmt * _tempTaxRate;
      _amount.totalTax += _holiSurChargeTax.roundToN();

      if (_amount.taxType == TaxType.Inclusive) {
        _holiSurchargeWithTax = holidaySurChargeAmt;
      } else if (_amount.taxType == TaxType.Exclusive) {
        _holiSurchargeWithTax = (holidaySurChargeAmt * (1 + _tempTaxRate));
      } else {
        _holiSurchargeWithTax = holidaySurChargeAmt;
      }
    }

    _amount.pHSurCharge = holidaySurChargeAmt.roundToN();

    _amount.totalPrice += _holiSurchargeWithTax.roundToN();
    _amount.finalPrice += _holiSurchargeWithTax.roundToN();

    final ccCharge = double.tryParse(creCardCltr.text);
    double _ccSurchargeWithTax = 0.0;
    double _ccSurChargeAmt = 0.0;

    double _ccSurChargeTax = 0.0;

    if (ccCharge != null && isCheckCreCarCharge) {
      _ccSurChargeAmt =
          ((tempTotal - chargeOnMiddleCase) + holidaySurChargeAmt) *
              ccCharge /
              100;
      _ccSurChargeTax = _ccSurChargeAmt * _tempTaxRate;
      _amount.totalTax += _ccSurChargeTax.roundToN();

      if (_amount.taxType == TaxType.Inclusive) {
        _ccSurchargeWithTax = _ccSurChargeAmt;
      } else if (_amount.taxType == TaxType.Exclusive) {
        _ccSurchargeWithTax = (_ccSurChargeAmt * (1 + _tempTaxRate));
      } else {
        _ccSurchargeWithTax = _ccSurChargeAmt;
      }
    }

    _amount.ccSurCharge = _ccSurChargeAmt.roundToN();

    _amount.totalPrice += _ccSurchargeWithTax.roundToN();
    _amount.finalPrice += _ccSurchargeWithTax.roundToN();

    double serviceChargeAmt = 0.0;

    final sCPercent = double.tryParse(serviceChargePerCltr.text);

    if (sCPercent != null && isCheckServiceCharge) {
      serviceChargeAmt = (((tempTotal - chargeOnMiddleCase) +
              holidaySurChargeAmt +
              _ccSurChargeAmt) *
          sCPercent /
          100);
    }
    // kPrint(
    //     "serviceChargeAmt: $tempTotal- $chargeOnMiddleCase+ $holidaySurChargeAmt +$_ccSurChargeAmt* $sCPercent = $serviceChargeAmt");

    _amount.serviceCharge = serviceChargeAmt.roundToN();

    _amount.totalPrice += serviceChargeAmt.roundToN();
    _amount.finalPrice += serviceChargeAmt.roundToN();

    // kPrint(
    //     "finalPrice : ${_amount.finalPrice} || tempTotal: $tempTotal _ccSurchargeWithTax : $_ccSurchargeWithTax");

    return _amount;
  }

  // send email section
  final fromCltr = TextEditingController();
  final toCltr = TextEditingController();
  final ccCltr = TextEditingController();
  final subCltr = TextEditingController();
  final msgCltr = TextEditingController();

  final toEmailList = <String>[];
  final ccEmailList = <String>[];

  bool loadEmail = false;

  void clearEmailData() {
    toCltr.clear();
    ccCltr.clear();
    subCltr.clear();
    msgCltr.clear();
    toEmailList.clear();
    ccEmailList.clear();
  }

  setEmailData({String? cusName, required String email}) {
    fromCltr.text = GlobalCVP.storeInfo?.email ?? '';
    //  payInvoiceDetailRes?.fromEmail?.email ?? "";

    // if (payInvoiceDetailRes?.tosEmail != null) {
    // final emailList = <String>[];
    toEmailList.clear();
    // for (final e in payInvoiceDetailRes!.tosEmail!) {
    //   if (e.email != null && e.email!.isNotEmpty) {
    //     emailList.add(e.email!);
    //   }
    // }
    // toEmailList.addAll(emailList.toSet().toList());
    if (email.isNotEmpty) toEmailList.add(email);
    // }

    subCltr.text = LN.thankPur;
    msgCltr.text = """
${LN.dear} ${cusName ?? ''},

${LN.thanksForChoosing} 

${LN.emailText1}

${LN.emailText2}

${LN.bestRegards}
${GlobalCVP.storeInfo?.name ?? ''}
""";

    loadEmail = false;
    notify;
  }

  Future<bool?> sendEmail({required String? orderId}) async {
    loadEmail = true;
    notify;
    final emailData = PayInvoiceSendEmailReq(
      orderId: orderId,
      emailViewModel: EmailViewModel(
        to: toEmailList,
        cc: ccEmailList,
        senderEmail: fromCltr.text,
        senderName: GlobalCVP.storeInfo?.name,
        subject: subCltr.text,
        message: msgCltr.text,
      ),
    );
    final status = await Handler.pOPayInvoiceSendEmail(reqData: emailData);
    loadEmail = false;
    notify;
    return status;
  }

  // Update Orders

  bool updateOrderLoad = false;
  PrevPlaceReqData? placeReqData;

  Future<bool?> updatePlaceOrder({dynamic orderTypeId}) async {
    if (placeReqData == null) return null;

    final phoneNumber = placeReqData?.customerUserViewModel?.phoneNumber;
    final email = placeReqData?.customerUserViewModel?.email;

    final placeOrder = PlaceOrderReq(
      isItemQuantiyChangeFromPaymentScreen: true,
      orderId: orderId,
      deviceIdentifierId: GlobalCVP.userStoresRes?.id,
      isSendToKitchenPrinter: GlobalCVP.storeInfo?.isSendToKitchenPrinter,
      isSendToKitchenDisplay: GlobalCVP.storeInfo?.isSendToKitchenDisplay,
      // customerName: placeReqData?.customerUserViewModel,

      customerAddRequestModel: CustomerViewModel(
        name: placeReqData?.customerUserViewModel?.name,
        phoneNumber: phoneNumber?.toLowerCase() == 'n/a' ? "" : phoneNumber,
        email: email?.toLowerCase() == 'n/a' ? "" : email,
        customerTypeId: customerTypeIndex == null
            ? ""
            : customerAddSecRes?.customerType?[customerTypeIndex!].id ?? '',
        customerGroupId: customerGroupIndex == null
            ? ""
            : customerAddSecRes?.customerGroups?[customerGroupIndex!].id ?? '',
        countryId: countryIndex == null
            ? ""
            : customerAddSecRes?.countries?[countryIndex!].id ?? '',
        countryPhoneNumberPrefixId: countryIndex == null
            ? ""
            : customerAddSecRes?.countries?[countryIndex!].id ?? '',
        postalCode: "",
      ),
      tables: placeReqData?.tableIdName,
      staffId: placeReqData?.staffId,
      description: placeReqData?.description,
      // channelPlatForm: placeReqData?.channelPlatform,
      isRetail: placeReqData?.isRetail ?? false,
      isSendToKitchen: placeReqData?.isSendToKitchen,
    );

    if (orderTypes != null &&
        orderTypeIndex != null &&
        orderTypes!.length > orderTypeIndex!) {
      placeOrder.orderTypeStoreId =
          orderTypeId ?? orderTypes?[orderTypeIndex!].id;
    }
    final amount = getAllAmount;

    placeOrder.totalAmount = amount.itemPrice.nonNan().roundToNString();

    double taxCoff = 0.0;
    if (amount.taxType == TaxType.Inclusive) {
      taxCoff = amount.taxPercent / (100 + amount.taxPercent);
    } else if (amount.taxType == TaxType.Exclusive) {
      taxCoff = amount.taxPercent / 100;
    }

    final _taxValue = amount.itemPrice * taxCoff;

    placeOrder.taxAmount = _taxValue.nonNan().roundToNString();

    placeOrder.totalWithoutTaxAmount =
        (amount.itemPrice - _taxValue).nonNan().roundToNString();

    for (final a in orderList) {
      if (a.quantity != null) {
        a.orderItemModifiersViewModels?.forEach((b) {
          b.quantity = (b.quantity ?? 1) * a.quantity! / a.initQty;
          b.totalModifierPrice =
              (b.totalModifierPrice ?? 1) * a.quantity! / a.initQty;
          b.totalTax = (b.totalTax ?? 1) * a.quantity! / a.initQty;

          b.modifierItemsModifierViewModels?.forEach((c) {
            c.quantity = (c.quantity ?? 1) * a.quantity! / a.initQty;
            c.totalModifierPrice =
                (c.totalModifierPrice ?? 1) * a.quantity! / a.initQty;
            c.totalTax = (c.totalTax ?? 1) * a.quantity! / a.initQty;
          });
        });
        a.initQty = a.quantity!;
      }
    }
    for (final b in setMenuList) {
      if (b.setMenuQuantity != null) {
        b.initQty = b.setMenuQuantity!;
      }
    }

    for (final c in ingreList) {
      if (c.quantity != null) {
        c.initQty = c.quantity!;
      }
    }

    placeOrder.orderDetails = orderList;
    placeOrder.setMenuOrderDetails = setMenuList;
    placeOrder.rawIngredientOrderDetails = ingreList;

    //TODO: check place order request
    // log(jsonEncode(_placeOrder.toJson()));
    // return null;

    updateOrderLoad = true;
    notify;

    final pOrderRes = await Handler.placeOrder(placeOrderRes: placeOrder);
    if (pOrderRes != null) {
      isItemUpdated = false;
    }

    updateOrderLoad = false;
    notify;

    return pOrderRes != null;
  }

  Future<bool?> cancelPlaceOrderItem({
    required String orderId,
    required ItemCancelType type,
    required List<String> itemIds,
    required List<String> setmenuId,
  }) async {
    updateOrderLoad = true;
    notify;

    // final _status = await Handler.cancelPlaceOrderItem(
    //   orderId: orderId,
    //   type: type,
    //   itemIds: itemIds,
    //   setmenuId: setmenuId,
    // );

    bool? orderStatus;
    // if (_status ?? false) {
    orderStatus = await updatePlaceOrder(
        orderTypeId: orderDetailById?.orderDetailsViewModel?.orderTypeId);
    // }

    updateOrderLoad = false;
    notify;

    return orderStatus;
  }

  Future<bool?> cancelOrderIfNoItem(BuildContext ctx) async {
    if (setMenuList.isEmpty &&
        orderList.isEmpty &&
        ingreList.isEmpty &&
        orderId != null &&
        placeReqData?.cancelStatusId != null) {
      final _status = await Handler.changeOrderStatus(
        orderId: orderId!,
        orderStatusId: placeReqData!.cancelStatusId!,
        // onPopMsg: (bool val) {
        //   Navigator.pop(ctx);
        // },
      );

      if (ctx.mounted && (_status ?? false)) {
        Navigator.pop(ctx);
      }

      return _status;
    }
    return null;
  }

  double get payableAmount {
    final _amt = getAllAmount;

    double _surcharges = (isCheckPubHoCharge ? _amt.pHSurCharge : 0.0) +
        (isCheckCreCarCharge ? _amt.ccSurCharge : 0) +
        (isCheckServiceCharge ? _amt.serviceCharge : 0.0);

    double charges = 0.0;

    // print("payableAmount surcharge $_surcharges");

    if ((paymentType != PaymentType.PartialPayment ||
        _isCompletePayAfterSplit)) {
      charges = _surcharges;
    }

    final tipAmount = (double.tryParse(tipCltr.text) ?? 0);

    if (paymentType == PaymentType.PartialPayment && isSplitPerPerson) {
      final _noOfPerson =
          double.tryParse(splitPerPersonCltr.text)?.floor() ?? 1;

      double? _totalPaidWithoutCharge = getPaidAmtWthOutChargeOnSplitPerPerson;

      double _payAmount = 0.0;

      if (_totalPaidWithoutCharge != null) {
        _payAmount =
            ((_amt.paidAmount - _totalPaidWithoutCharge) / _noOfPerson) +
                _surcharges;
      } else {
        _payAmount = (_amt.paidAmount / _noOfPerson) + _surcharges;
      }

      // final _giftAmount = uniByPayRes?.amount.inDouble;

      if ((remainingOnGiftPay?.isNotEmpty ?? false) &&
          _giftAmount != 0 &&
          remainingOnGiftPay!.inDouble < _giftAmount) {
        return remainingOnGiftPay!.inDouble + _surcharges + tipAmount;
      }

      if (_giftAmount != 0 && _giftAmount < _payAmount) return _giftAmount;

      if (remainingOnGiftPay != null && remainingOnGiftPay!.isNotEmpty) {
        return remainingOnGiftPay!.inDouble + _surcharges + tipAmount;
      }

      if (remainingAmount != null &&
          (remainingAmount! - _payAmount).abs() <= 0.01 * _payAmount)
        return remainingAmount! + tipAmount;
      else
        return _payAmount + tipAmount;
    }

    final payAmt =
        (double.tryParse(paidAmountCltr.text) ?? 0) + charges + tipAmount;

    // print("_payAMt ${paidAmountCltr.text} $_charges ");

    // final _giftAmount = double.tryParse(uniByPayRes?.amount ?? '');

    if (_giftAmount != 0 && _giftAmount < payAmt) {
      return _giftAmount;
    }

    if (_isCompletePayAfterSplit) {
      return remainingAmount! + tipAmount;
    }

    return payAmt.roundToN();
  }

  String get readOnlyPaidAmount {
    final _amt = getAllAmount;

    double _surcharges = (isCheckPubHoCharge ? _amt.pHSurCharge : 0.0) +
        (isCheckCreCarCharge ? _amt.ccSurCharge : 0) +
        (isCheckServiceCharge ? _amt.serviceCharge : 0.0);

    // print(" readOnlyPaidAmount surcharge $_surcharges");

    if (paymentType == PaymentType.PartialPayment && isSplitPerPerson) {
      final _noOfPerson =
          double.tryParse(splitPerPersonCltr.text)?.floor() ?? 1;

      double _payAmount = 0.0;

      double? _totalPaidWithoutCharge = getPaidAmtWthOutChargeOnSplitPerPerson;

      if (_totalPaidWithoutCharge != null) {
        _payAmount =
            ((_amt.paidAmount - _totalPaidWithoutCharge) / _noOfPerson) +
                _surcharges;
      } else {
        _payAmount = (_amt.paidAmount / _noOfPerson) + _surcharges;
      }

      // final _giftAmount = uniByPayRes?.amount.inDouble;

      // print(
      //     '------------$_payAmount = ${_amt.paidAmount}/ $_noOfPerson + $_surcharges');

      // print("remainingOnGiftPay: $remainingOnGiftPay");

      if ((remainingOnGiftPay?.isNotEmpty ?? false) &&
          _giftAmount != 0 &&
          remainingOnGiftPay!.inDouble < _giftAmount) {
        return (remainingOnGiftPay!.inDouble + _surcharges).roundToNString();
      }

      if (_giftAmount != 0 && _giftAmount < _payAmount)
        return _giftAmount.roundToNString();

      if (remainingOnGiftPay != null && remainingOnGiftPay!.isNotEmpty) {
        return (remainingOnGiftPay!.inDouble + _surcharges).roundToNString();
      }

      // print("_payAmount $_payAmount | remain : $remainingAmount");

      if (remainingAmount != null &&
          (remainingAmount! - _payAmount).abs() <= 0.01 * _payAmount)
        return remainingAmount!.roundToNString();
      else
        return _payAmount.roundToNString();
    }

    double charges = 0.0;

    if (paymentType != PaymentType.PartialPayment || _isCompletePayAfterSplit) {
      charges = (_surcharges);
    }

    final _payAmt = (double.tryParse(paidAmountCltr.text) ?? 0) + charges;

    // final _giftAmount = double.tryParse(uniByPayRes?.amount ?? '');

    if (_giftAmount != 0 && _giftAmount < _payAmt) {
      return _giftAmount.roundToNString();
    }

    if (_isCompletePayAfterSplit) {
      return remainingAmount!.roundToNString();
    }

    return _payAmt.roundToNString();
  }

  bool get _isCompletePayAfterSplit {
    if (remainingAmount == null || paymentType != PaymentType.PartialPayment)
      return false;

    final paidOrderDetail =
        orderDetailById?.orderPaymentDetailsWithPaymentStatusViewModel;

    final _remainAmount =
        (double.tryParse(paidOrderDetail?.remainingAmount ?? '') ?? 0);

    final payingAmt = (double.tryParse(paidAmountCltr.text) ?? 0);
    if ((payingAmt - _remainAmount).abs() <= 0.03)
      return true;
    else
      return false;
  }

  bool get isCompletePayAfterSplit => _isCompletePayAfterSplit;

  bool get _isZeroTwo {
    final diff = (payableAmount - (remainingAmount ?? 0)).abs();
    if (diff == 0) return false;
    return diff.roundToN() <= 0.02;
  }

  // Refund Payment

  bool refundLoad = false;
  final refundTextCltr = TextEditingController();

  final _refundOrderDetails = <OrderDetail>[];
  final _refundSetMenuDetails = <SetMenuOrderDetail>[];
  final _refundRawIngreDetails = <RawIngredientOrderDetail>[];

  void updateRefundOrder({
    OrderDetail? orderDetail,
    SetMenuOrderDetail? setMenuOrderDetail,
    RawIngredientOrderDetail? rawIngredientOrderDetail,
  }) {
    getAllAmount;
    if (orderDetail != null) {
      final itemDiscountValue =
          orderDetail.finalTotalSellingAmount * _disPercent / 100;
      final itemDisTax = itemDiscountValue * (1 - _taxCoff);

      final _finalTotalDiscount = orderDetail.taxType == TaxType.Inclusive
          ? itemDiscountValue - itemDisTax
          : itemDiscountValue;

      final _finalTotalDiscountWithTax =
          orderDetail.taxType == TaxType.Inclusive
              ? itemDiscountValue
              : itemDiscountValue + itemDisTax;

      if (!_refundOrderDetails.any((e) => e.id == orderDetail.id)) {
        final orderDetail0 = OrderDetail(
          id: orderDetail.id,
          productId: orderDetail.productId,
          productName: orderDetail.productName,
          description: orderDetail.description,
          productPrice: orderDetail.productPrice,
          quantity: orderDetail.quantity,
          productVariationId: orderDetail.productVariationId,
          total: orderDetail.total,
          productVariationName: orderDetail.productVariationName,
          originalSellingAmount: orderDetail.originalSellingAmount,
          discountWithoutTax: orderDetail.discountWithoutTax,
          totalTax: orderDetail.totalTax,
          unitCost: orderDetail.unitCost,
          // categoryTypeId: orderDetail.categoryTypeId,
          statusId: orderDetail.statusId,
          // isCancelled: orderDetail.isCancelled,
          taxType: orderDetail.taxType,
          taxPercent: orderDetail.taxPercent,
          orderItemModifiersViewModels:
              orderDetail.orderItemModifiersViewModels,
          orderItemSelectOptionsViewModels:
              orderDetail.orderItemSelectOptionsViewModels,
          // removedOrderItemsIngredientsViewModels:
          //     orderDetail.removedOrderItemsIngredientsViewModels,
          // orderItemSpiceChoiceViewModel:
          //     orderDetail.orderItemSpiceChoiceViewModel,
          // eod report
          finalReTotalSellingAmount:
              orderDetail.finalTotalSellingAmount.roundToNString(),
          finalReTotalTax: orderDetail.finalTotalTax.roundToNString(),
          finalReTotalDiscount: _finalTotalDiscount.roundToNString(),
          finalReTotalDiscountWithTax:
              _finalTotalDiscountWithTax.roundToNString(),
          batchId: orderDetail.batchId,
        );
        _refundOrderDetails.add(orderDetail0);
      }

      _refundOrderDetails.firstWhere((e) => e.id == orderDetail.id)
        ..quantity = orderDetail.quantity
        ..total = orderDetail.total
        ..totalTax = orderDetail.totalTax
        ..orderItemModifiersViewModels =
            orderDetail.orderItemModifiersViewModels
        ..finalReTotalSellingAmount =
            orderDetail.finalTotalSellingAmount.roundToNString()
        ..finalReTotalTax = orderDetail.finalTotalTax.roundToNString()
        ..finalReTotalDiscount = _finalTotalDiscount.roundToNString()
        ..finalReTotalDiscountWithTax =
            _finalTotalDiscountWithTax.roundToNString()
        ..batchId = orderDetail.batchId;

      if (orderDetail.quantity == 0) {
        _refundOrderDetails.removeWhere((e) => e.id == orderDetail.id);
      }
    } else if (setMenuOrderDetail != null) {
      final itemDiscountValue =
          setMenuOrderDetail.finalTotalSellingAmount * _disPercent / 100;
      final itemDisTax = itemDiscountValue * (1 - _taxCoff);

      final _finalTotalDiscount =
          setMenuOrderDetail.taxType == TaxType.Inclusive
              ? itemDiscountValue - itemDisTax
              : itemDiscountValue;

      final _finalTotalDiscountWithTax =
          setMenuOrderDetail.taxType == TaxType.Inclusive
              ? itemDiscountValue
              : itemDiscountValue + itemDisTax;

      if (!_refundSetMenuDetails.any((e) => e.id == setMenuOrderDetail.id)) {
        final setMenu = SetMenuOrderDetail(
          id: setMenuOrderDetail.id,
          setMenuId: setMenuOrderDetail.setMenuId,
          setMenuName: setMenuOrderDetail.setMenuName,
          setMenuQuantity: setMenuOrderDetail.setMenuQuantity,
          setMenuPrice: setMenuOrderDetail.setMenuPrice,
          totalSetMenuPrice: setMenuOrderDetail.totalSetMenuPrice,
          description: setMenuOrderDetail.description,
          statusId: setMenuOrderDetail.statusId,
          // isCancelled: setMenuOrderDetail.isCancelled,
          orderItemsViewModels: setMenuOrderDetail.orderItemsViewModels,
          taxType: setMenuOrderDetail.taxType,
          taxPercent: setMenuOrderDetail.taxPercent,
          originalSellingAmount: setMenuOrderDetail.originalSellingAmount,
          discountWithoutTax: setMenuOrderDetail.discountWithoutTax,
          totalTax: setMenuOrderDetail.totalTax,
          // eod report
          finalReTotalSellingAmount:
              setMenuOrderDetail.finalTotalSellingAmount.roundToNString(),
          finalReTotalTax: setMenuOrderDetail.finalTotalTax.roundToNString(),
          finalReTotalDiscount: _finalTotalDiscount.roundToNString(),
          finalReTotalDiscountWithTax:
              _finalTotalDiscountWithTax.roundToNString(),
        );
        _refundSetMenuDetails.add(setMenu);
      }

      _refundSetMenuDetails.firstWhere((e) => e.id == setMenuOrderDetail.id)
        ..setMenuQuantity = setMenuOrderDetail.setMenuQuantity ?? 0
        ..totalSetMenuPrice = setMenuOrderDetail.totalSetMenuPrice
        ..totalTax = setMenuOrderDetail.totalTax
        ..orderItemsViewModels = setMenuOrderDetail.orderItemsViewModels
        ..finalReTotalSellingAmount =
            setMenuOrderDetail.finalTotalSellingAmount.roundToNString()
        ..finalReTotalTax = setMenuOrderDetail.finalTotalTax.roundToNString()
        ..finalReTotalDiscount = _finalTotalDiscount.roundToNString()
        ..finalReTotalDiscountWithTax =
            _finalTotalDiscountWithTax.roundToNString();

      if (setMenuOrderDetail.setMenuQuantity == 0) {
        _refundSetMenuDetails.removeWhere((e) => e.id == setMenuOrderDetail.id);
      }
    } else if (rawIngredientOrderDetail != null) {
      final itemDiscountValue =
          rawIngredientOrderDetail.finalTotalSellingAmount * _disPercent / 100;
      final itemDisTax = itemDiscountValue * (1 - _taxCoff);

      final _finalTotalDiscount =
          rawIngredientOrderDetail.taxType == TaxType.Inclusive
              ? itemDiscountValue - itemDisTax
              : itemDiscountValue;

      final _finalTotalDiscountWithTax =
          rawIngredientOrderDetail.taxType == TaxType.Inclusive
              ? itemDiscountValue
              : itemDiscountValue + itemDisTax;

      if (!_refundRawIngreDetails
          .any((e) => e.id == rawIngredientOrderDetail.id)) {
        final rawIngreDetail = RawIngredientOrderDetail(
          id: rawIngredientOrderDetail.id,
          unitOfMeasurementId: rawIngredientOrderDetail.unitOfMeasurementId,
          rawIngredientId: rawIngredientOrderDetail.rawIngredientId,
          quantity: rawIngredientOrderDetail.quantity,
          totalSellingPrice: rawIngredientOrderDetail.totalSellingPrice,
          totalTax: rawIngredientOrderDetail.totalTax,
          originalSellingPricePerUnit:
              rawIngredientOrderDetail.originalSellingPricePerUnit,
          name: rawIngredientOrderDetail.name,
          statusId: rawIngredientOrderDetail.statusId,
          // isCancelled: rawIngredientOrderDetail.isCancelled,
          taxType: rawIngredientOrderDetail.taxType,
          taxPercent: rawIngredientOrderDetail.taxPercent,
          // eod report
          finalReTotalDiscount: _finalTotalDiscount.roundToNString(),
          finalReTotalDiscountWithTax:
              _finalTotalDiscountWithTax.roundToNString(),
        );
        _refundRawIngreDetails.add(rawIngreDetail);
      }

      _refundRawIngreDetails
          .firstWhere((e) => e.id == rawIngredientOrderDetail.id)
        ..quantity = rawIngredientOrderDetail.quantity
        ..totalSellingPrice =
            rawIngredientOrderDetail.totalSellingPrice //_total.roundToNString()
        ..totalTax = rawIngredientOrderDetail.totalTax
        ..finalReTotalDiscount = _finalTotalDiscount.roundToNString()
        ..finalReTotalDiscountWithTax =
            _finalTotalDiscountWithTax.roundToNString();

      if (rawIngredientOrderDetail.quantity == 0) {
        _refundRawIngreDetails
            .removeWhere((e) => e.id == rawIngredientOrderDetail.id);
      }
    }
  }

  RefundPaymentRes? refundPaymentRes;
  bool refundDeliveryDisable = false;

  RefundOrderReq? get getRefundRequest {
    final refundReq = RefundOrderReq(
      orderDetails: _refundOrderDetails,
      setMenuOrderDetails: _refundSetMenuDetails,
      rawIngredientOrderDetails: _refundRawIngreDetails,
    );

    refundReq.orderId = orderId;
    if (paySecListRes?.paymentMethods != null &&
        paySecListRes!.paymentMethods!
            .any((a) => a.isSelected != null && a.isSelected!)) {
      refundReq.paymentMethodId = paySecListRes!.paymentMethods!
          .firstWhere((e) => e.isSelected != null && e.isSelected!)
          .id;
    }

    final amount = getAllAmount;

    double _discountAmount = 0.0;
    double discountAmountWithTax = 0.0;

    if (discountList != null) {
      for (final a in discountList!) {
        _discountAmount += a.discountAmount.inDouble;
        discountAmountWithTax += a.discountAmountWithTax.inDouble;
      }
    }

    refundReq.refundDiscountAmount = _discountAmount.roundToNString();
    refundReq.refundDiscountAmountWithTax =
        discountAmountWithTax.roundToNString();

    final double deliveryAmt = isOrderTypeDelivery && isDeliveryCheck
        ? (double.tryParse(deliveryTextCltr.text) ?? 0.0)
        : 0.0;

    final _taxCoff = OrderUtils.withoutTaxCoff(
        taxTypeString: taxExclusiveInclusiveType ?? '',
        taxPercent: taxPercentDDS);

    refundReq.isDeliveryEnable = true;

    if (isOrderTypeDelivery && isDeliveryCheck) {
      double _deliveryAmtWithoutTax = 0.0;
      double _deliveryAmtWithTax = 0.0;

      if (amount.taxType == TaxType.Inclusive) {
        _deliveryAmtWithoutTax = deliveryAmt * _taxCoff;
        _deliveryAmtWithTax = deliveryAmt;
      } else {
        _deliveryAmtWithoutTax = deliveryAmt;
        _deliveryAmtWithTax = deliveryAmt * (2 - _taxCoff);
      }
      refundReq.refundDeliveryAmount =
          _deliveryAmtWithoutTax.nonNan().roundToNString();
      refundReq.refundDeliveryAmountWithTax =
          _deliveryAmtWithTax.nonNan().roundToNString();
      refundReq.isDeliveryEnable = false;
    } else {
      refundReq.refundDeliveryAmount = "0.00";
      refundReq.refundDeliveryAmountWithTax = "0.00";
    }

    if (refundDeliveryDisable) {
      refundReq.isDeliveryEnable = false;
      refundReq.refundDeliveryAmount = null;
      refundReq.refundDeliveryAmountWithTax = null;
    }

    // if (amount.taxType == TaxType.Inclusive) {
    //   refundReq.refundDiscountAmountWithTax =
    //       amount.discountWithTax.roundToNString();
    //   refundReq.refundDiscountAmount = amount.discount.roundToNString();
    // } else {
    //   refundReq.refundDiscountAmount = amount.discount.roundToNString();

    //   refundReq.refundDiscountAmountWithTax =
    //       amount.discountWithTax.roundToNString();
    // }

    refundReq.refundCreditCardSurchargePercentage = creCardCltr.text;
    refundReq.refundServiceChargePercentage = serviceChargePerCltr.text;

    if (isCheckPubHoCharge) {
      double _pHSCOnly = 0.0;
      double _pHSCWithTax = 0.0;

      if (amount.taxType == TaxType.Inclusive) {
        _pHSCOnly = amount.pHSurCharge * _taxCoff;
        _pHSCWithTax = amount.pHSurCharge;
      } else {
        _pHSCOnly = amount.pHSurCharge;
        _pHSCWithTax = amount.pHSurCharge * (2 - _taxCoff);
      }

      refundReq.refundPublicHolidaySurChargeAmoutWithTax =
          _pHSCWithTax.nonNan().roundToNString();

      refundReq.refundPublicHolidaySurChargeAmount =
          _pHSCOnly.nonNan().roundToNString();
    }

    if (isCheckCreCarCharge) {
      double _cCSCOnly = 0.0;
      double _cCSCWithTax = 0.0;

      if (amount.taxType == TaxType.Inclusive) {
        _cCSCOnly = amount.ccSurCharge * _taxCoff;
        _cCSCWithTax = amount.ccSurCharge;
      } else {
        _cCSCOnly = amount.ccSurCharge;
        _cCSCWithTax = amount.ccSurCharge * (2 - _taxCoff);
      }

      refundReq.refundCreditCardSurChargeAmountWithTax =
          _cCSCWithTax.nonNan().roundToNString();
      refundReq.refundCreditCardSurChargeAmount =
          _cCSCOnly.nonNan().roundToNString();
    }

    if (isCheckServiceCharge) {
      double _serviceChargeOnly = amount.serviceCharge;

      refundReq.refundServiceChargeAmount =
          _serviceChargeOnly.nonNan().roundToNString();
    }

    refundReq.refundAmount = amount.totalPrice.nonNan().roundToNString();
    refundReq.refundTaxAmount = amount.totalTax.nonNan().roundToNString();

    refundReq.refundAmountWithoutTax = (amount.itemPrice -
            (amount.taxFromItemToDel - (deliveryAmt * (1 - _taxCoff))))
        .nonNan()
        .roundToNString();

    refundReq.stockDeductType =
        orderDetailById?.orderDetailsViewModel?.stockDeductType;
    refundReq.holidaySurchargeType =
        GlobalCVP.storeInfo?.holidaySurcharge?.holidaySurchargeType;

    return refundReq;
  }

  RefundOrderReq? _setRefundReqWithEftVal(final RefundOrderReq? refundReq,
      {EFTReturnValue? eftValue}) {
    if (eftValue != null) {
      refundReq?.transactionRefId = eftValue.refId;
      refundReq?.eftPosMerchantType = eftValue.merchantType;
      // _refundReq?.transactionSessionId = eftValue.sessionIdLinky;

      refundReq?.eftposSerialNumber = eftValue.serialNumber;
      refundReq?.merchantInvoiceRequestViewModel =
          MerchantInvoiceRequestViewModel(
        merchantInvoiceData: eftValue.merchantReceipt,
        // Utils.decodeAndFormatData(eftValue.merchantReceipt),
        customerInvoiceData: eftValue.customerReceipt,
        // Utils.decodeAndFormatData(eftValue.customerReceipt),
      );
    }
    return refundReq;
  }

  Future<bool?> refundPayment({
    EFTReturnValue? eftValue,
    bool isEftIncomplete = false,
  }) async {
    refundPaymentRes = null;

    final refundReq = _setRefundReqWithEftVal(
        isEftIncomplete ? eftIncompleteRefundReqData : getRefundRequest,
        eftValue: eftValue);

    if (refundReq == null) return null;

    // final _status =
    OrderUtils.checkRefundData(refundReq);
    // print("variance status = $_status----------");

    // TODO: make refund
    // log(json.encode(refundReq));
    // return null;
    refundLoad = true;
    notify;

    final _refundRes = await Handler.makeRefund(refundOrderReq: refundReq);

    refundPaymentRes = _refundRes != null
        ? RefundPaymentRes.fromJson(_refundRes.toJson())
        : null;

    if (_refundRes != null) {
      refundPaymentRes =
          await Handler.orderRefundInvoice(orderId: _refundRes.orderId ?? '');
      refundPaymentRes?.sendToKitchenPrinter = _refundRes.sendToKitchenPrinter;
      refundPaymentRes?.sendToKitchenDisplay = _refundRes.sendToKitchenDisplay;

      _refundOrderDetails.clear();
      _refundSetMenuDetails.clear();
      eftIncompleteRefundReqData = null;
      _refundRawIngreDetails.clear();
    }

    refundLoad = false;
    notify;
    return refundPaymentRes != null;
  }

  // split payment
  final PAY_TYPE_LIST = <PayTypeTab>[
    PayTypeTab(id: 0, title: LN.fullAmount),
    PayTypeTab(id: 1, title: LN.splitAmount),
    PayTypeTab(id: 2, title: LN.splitByItems),
  ];
  // ["Pay Full Amount", "Split Amount", ""]

  PaymentType paymentType = PaymentType.FullPayment;

  onChangePayType(int index) {
    paymentType = PaymentType.values[index];
  }

  double _tempAmountWSurcharge({
    required double tempAmount,
  }) {
    final pHSurCharge = holidaySurCharge != null && isCheckPubHoCharge
        ? (tempAmount * holidaySurCharge! / 100)
        : 0;

    final ccCharge = double.tryParse(creCardCltr.text);
    final _scPercent = double.tryParse(serviceChargePerCltr.text);

    final cCSurCharge = ccCharge != null && isCheckCreCarCharge
        ? (tempAmount + pHSurCharge) * ccCharge / 100
        : 0;

    final _serviceCharge = _scPercent != null && isCheckServiceCharge
        ? (tempAmount * _scPercent / 100)
        : 0;

    return tempAmount + pHSurCharge + cCSurCharge + _serviceCharge;
  }

  EFTReturnValue? eftReturnValue;
  PoMakePaymentReq? eftIncompletePayReqData;
  RefundOrderReq? eftIncompleteRefundReqData;

  bool get isOrderTypeDelivery {
    final delAMt = double.tryParse(orderDetailById
                ?.orderPaymentDetailsWithPaymentStatusViewModel
                ?.deliveryAmount ??
            '0') ??
        0;
    return (orderDetailById?.orderDetailsViewModel?.orderType
                ?.toLowerCase()
                .contains('deliver') ??
            false) ||
        delAMt != 0;
  }

  PayMethodEnum? get PAY_METHOD {
    final _selectedMethod = paySecListRes?.paymentMethods != null &&
            paySecListRes!.paymentMethods!.any((e) => e.isSelected ?? false)
        ? paySecListRes!.paymentMethods!
            .firstWhere((e) => e.isSelected ?? false)
        : null;

    if (_selectedMethod != null) {
      return PayMethodClass.getMethod(_selectedMethod.name);
    }
    return null;
  }

  double getSplitAmountTemp(double paidAmt) {
    final pHSurCharge = holidaySurCharge != null && isCheckPubHoCharge
        ? holidaySurCharge! / 100
        : 0;

    final ccCharge = double.tryParse(creCardCltr.text);
    final _scPercent = double.tryParse(serviceChargePerCltr.text);

    final cCSurCharge =
        ccCharge != null && isCheckCreCarCharge ? ccCharge / 100 : 0;

    final _serviceChargePerValue =
        _scPercent != null && isCheckServiceCharge ? _scPercent / 100 : 0;

    final tempAmount = paidAmt /
        ((1 + pHSurCharge) * (1 + cCSurCharge) * (1 + _serviceChargePerValue));

    return tempAmount;
  }

  double get getGiftSplitAmountTemp {
    final paidAmt = _giftAmount;
    if (paidAmt == 0) return 0.0;

    final pHSurCharge = holidaySurCharge != null && isCheckPubHoCharge
        ? holidaySurCharge! / 100
        : 0;

    final ccCharge = double.tryParse(creCardCltr.text);
    final _scPercent = double.tryParse(serviceChargePerCltr.text);

    final cCSurCharge =
        ccCharge != null && isCheckCreCarCharge ? ccCharge / 100 : 0;

    final _serviceChargePerValue =
        _scPercent != null && isCheckServiceCharge ? _scPercent / 100 : 0;

    final tempAmount = paidAmt /
        ((1 + pHSurCharge) * (1 + cCSurCharge) * (1 + _serviceChargePerValue));

    // print('---- paidAmt : $_paidAmt _tempAmount: $_tempAmount');

    return tempAmount;
  }

  double get _giftAmount {
    final payMethod = getPayMethod;

    if (payMethod == PayMethodEnum.Loyalty && loyaltyRedeem) {
      return cusForLoyalityRes?.eligibleAmount.inDouble ?? 0;
    } else if (payMethod == PayMethodEnum.GiftCard) {
      return uniByPayRes?.amount.inDouble ?? 0;
    }

    return 0;
  }

  PayMethodEnum get getPayMethod {
    if (paySecListRes?.paymentMethods?.any((e) => e.isSelected ?? false) ??
        false) {
      return PayMethodClass.getMethod(paySecListRes!.paymentMethods!
          .firstWhere((e) => e.isSelected ?? false)
          .name);
    } else
      return PayMethodEnum.None;
  }

  double? get getPaidAmtWthOutChargeOnSplitPerPerson {
    final _ifPayInit = (remainingAmount ?? 0) != 0 &&
        orderDetailById?.orderDetailsViewModel?.paymentType != null;

    if (_ifPayInit) {
      final _payDetails =
          orderDetailById?.orderPaymentDetailsWithPaymentStatusViewModel;

      final _totalPaidAmount = _payDetails?.orderPaymentsDetailsViewModels
              ?.fold<double>(
                  0, (pV, ev) => pV + (ev.paidAmount?.inDouble ?? 0)) ??
          0;
      final _taxType =
          OrderUtils.getTaxType(GlobalCVP.storeInfo?.taxExclusiveInclusiveType);

      final _totalPaidCharges = (_taxType == TaxType.Inclusive
              ? (_payDetails?.holidaySurgeAmountWithTax?.inDouble ?? 0)
              : (_payDetails?.holidaySurgeAmount?.inDouble ?? 0)) +
          (_taxType == TaxType.Inclusive
              ? (_payDetails?.creditCardSurgeAmountWithTax?.inDouble ?? 0)
              : (_payDetails?.creditCardSurgeAmount?.inDouble ?? 0)) +
          (_payDetails?.serviceChargeAmount?.inDouble ?? 0);

      return _totalPaidAmount - _totalPaidCharges;
    } else
      return null;
  }

  // qr scan get data

  bool qrLoading = false;

  Future<bool> listenQrScanData() async {
    cusForLoyalityRes = await Handler.searchCusForLoyaltyQr();
    setSearchCusData();
    notify;
    return cusForLoyalityRes != null;
  }

  Future<bool> scanCusQr({required String cusId}) async {
    cusForLoyalityRes =
        await Handler.searchCusForLoyaltyFromCusQr(cusId: cusId);
    setSearchCusData();
    notify;
    return cusForLoyalityRes != null;
  }

  // new design
  int customerTab = 0;
  bool showCusKeyPad = true;
  FocusNode? KeyPadfocusNode;
  bool isDisPercentTab = true;
  //
  String keyPadValue = '';
  FocusKeyPad? focusKeyPad;

  // updating order
  bool isUpdatingOrder = false;

  // zero item on split by item
  bool? payOnZeroSplitByItem;

  Future<OrderDetailById?> getOrderDetailById({required String orderId}) async {
    if (orderId.isEmpty) return null;

    final _oDById = await Handler.getOrderTranById(orderId: orderId);

    return _oDById;
  }

  List<OrderDiscountModel>? discountList;
  double _finalItemPriceWithTax = 0.0;
  double _finalItemPriceWithOutTax = 0.0;
  double _finalPaidAmount = 0.0;

  void setDiscountList() {
    final _discountDataList = <OrderDiscountModel>[];

    final _taxType = OrderUtils.getTaxType(taxExclusiveInclusiveType);

    double _deliveryAmtWithoutTax = 0.0;
    double _deliveryAmt = 0.0;

    // if (isOrderTypeDelivery && isDeliveryCheck) {
    //   final _deliveryValue = double.tryParse(deliveryTextCltr.text) ?? 0;

    //   if (_taxType == TaxType.Inclusive) {
    //     _deliveryAmt = _deliveryValue;
    //     _deliveryAmtWithoutTax = _deliveryValue * _taxCoff;
    //   } else {
    //     _deliveryAmtWithoutTax = _deliveryValue;
    //     _deliveryAmt = (_deliveryValue * (2 - _taxCoff)).nonNan();
    //   }
    // }

    double _paidAmtWithTax = 0.0;
    double _paidAmtWithoutTax = 0.0;

    if (paymentType == PaymentType.SplitByItem) {
      if (_taxType == TaxType.Inclusive) {
        _paidAmtWithTax = _finalPaidAmount;
        _paidAmtWithoutTax = _finalPaidAmount * _taxCoff;
      } else {
        _paidAmtWithoutTax = _finalPaidAmount;
        _paidAmtWithTax = (_finalPaidAmount * (2 - _taxCoff)).nonNan();
      }
    } else {
      _paidAmtWithTax = _finalItemPriceWithTax;
      _paidAmtWithoutTax = _finalItemPriceWithOutTax;
    }
    // kPrint(
    //     "taxPercentDDS: $taxPercentDDS _taxCoff: $_taxCoff _paidAmtWithTax: $_paidAmtWithTax | _paidAmtWithoutTax: $_paidAmtWithoutTax");

    final _itemPriceWithDeli = (_taxType == TaxType.Inclusive
        ? _paidAmtWithTax + _deliveryAmt
        : _paidAmtWithoutTax + _deliveryAmtWithoutTax);

    final _disTaxCoff = 1 -
        OrderUtils.withoutTaxCoff(
            taxTypeString: taxExclusiveInclusiveType ?? '',
            taxPercent: taxPercentDDS);

    OrderDiscountModel? _disModel;

    if (paySecListRes?.discounts?.any((e) => e.isSelected ?? false) ?? false) {
      final _disData =
          paySecListRes?.discounts?.firstWhere((e) => e.isSelected ?? false);

      final _disAmt1 = OrderUtils.getDisAmtWithTax(
        discountPercent: discountPercentCltr.text,
        price: _itemPriceWithDeli.toString(),
        taxTypeString: taxExclusiveInclusiveType,
        disTaxCoff: _disTaxCoff,
      );

      _disModel = OrderDiscountModel(
        discountTypeId: _disData?.id ?? '',
        discountPercentage: discountPercentCltr.text,
        discountType: DiscountType.General.name,
        name: _disData?.name,
        discountAmount: _disAmt1.discount.formatDouble,
        discountAmountWithTax: _disAmt1.discountWithTax.formatDouble,
        discountTax: _disAmt1.totalTax,
        code: '',
      );
    } else {
      final _disAmt1 = OrderUtils.getDisAmtWithTax(
        discountPercent: discountPercentCltr.text,
        price: _itemPriceWithDeli.toString(),
        taxTypeString: taxExclusiveInclusiveType,
        disTaxCoff: _disTaxCoff,
      );

      _disModel = OrderDiscountModel(
        discountTypeId: "",
        discountPercentage: discountPercentCltr.text,
        discountType: DiscountType.General.name,
        name: '',
        discountAmount: _disAmt1.discount.formatDouble,
        discountAmountWithTax: _disAmt1.discountWithTax.formatDouble,
        discountTax: _disAmt1.totalTax,
        code: '',
      );
    }

    _discountDataList.add(_disModel);

    if (PromoUtils.promoOnTotalOrder != null &&
        paymentType != PaymentType.SplitByItem) {
      final _disAmt2 = OrderUtils.getDisAmtWithTax(
        discountPercent: PromoUtils.promoOnTotalOrder?.discountPercent ?? '',
        price: _itemPriceWithDeli.toString(),
        taxTypeString: taxExclusiveInclusiveType,
        disTaxCoff: _disTaxCoff,
      );

      final _promoDisModel = OrderDiscountModel(
        discountTypeId: PromoUtils.promoOnTotalOrder?.promoId,
        discountPercentage: PromoUtils.promoOnTotalOrder?.discountPercent,
        discountType: DiscountType.Promotion.name,
        name: PromoUtils.promoOnTotalOrder?.name,
        discountAmount: _disAmt2.discount.formatDouble,
        discountAmountWithTax: _disAmt2.discountWithTax.formatDouble,
        discountTax: _disAmt2.totalTax,
        code: '',
      );

      _discountDataList.add(_promoDisModel);
    }

    if (((uniByPayRes?.uniqueCode?.isNotEmpty ?? false) ||
                voucherDiscountPercent != null) &&
            _getPayMethod != PayMethodEnum.GiftCard

        // && (remainingAmount ?? 0) == 0
        ) {
      final _disAmt3 = OrderUtils.getDisAmtWithTax(
        discountPercent:
            voucherDiscountPercent ?? (uniByPayRes?.discountPercentage ?? ''),
        price: _itemPriceWithDeli.toString(),
        taxTypeString: taxExclusiveInclusiveType,
        disTaxCoff: _disTaxCoff,
      );

      final _voucherDisModel = OrderDiscountModel(
        discountTypeId: "",
        discountPercentage:
            voucherDiscountPercent ?? uniByPayRes?.discountPercentage,
        discountType: DiscountType.Voucher.name,
        name: uniByPayRes?.senderName,
        discountAmount: _disAmt3.discount.formatDouble,
        discountAmountWithTax: _disAmt3.discountWithTax.formatDouble,
        discountTax: _disAmt3.totalTax,
        code: uniByPayRes?.uniqueCode,
      );

      _discountDataList.add(_voucherDisModel);
    }

    discountList = _discountDataList;
  }

  OrderDiscountModel? _getGiftCardDiscount() {
    final _discountAmt = uniByPayRes?.amount?.inDouble ?? 0.0;

    if (_discountAmt == 0) return null;

    final _taxType = OrderUtils.getTaxType(taxExclusiveInclusiveType);

    double _disAmt = 0.0;
    double _disAmtWithTax = 0.0;

    if (_taxType == TaxType.Inclusive) {
      _disAmtWithTax = _discountAmt;
      _disAmt = _discountAmt * _taxCoff;
    } else {
      _disAmt = _discountAmt;
      _disAmtWithTax = _discountAmt * (2 - _taxCoff);
    }

    final _voucherDisModel = OrderDiscountModel(
      discountTypeId: "",
      discountType: DiscountType.GiftCard.name,
      name: uniByPayRes?.senderName,
      discountAmount: _disAmt.formatDouble,
      discountAmountWithTax: _disAmtWithTax.formatDouble,
      discountTax: _disAmtWithTax - _disAmt,
      code: uniByPayRes?.uniqueCode,
    );

    return _voucherDisModel;
  }

  PayMethodEnum? get _getPayMethod {
    try {
      final _selectedPaymethod = paySecListRes?.paymentMethods
          ?.firstWhere((e) => e.isSelected ?? false);
      return PayMethodClass.getMethod(_selectedPaymethod?.name);
    } catch (e) {
      return null;
    }
  }

  bool get isDineIn => (orderDetailById?.orderDetailsViewModel?.orderType
          .toString()
          .toLowerCase()
          .contains('dine') ??
      false);
}

class PrevPlaceReqData {
  CustomerUserViewModel? customerUserViewModel;
  List<TableIdName>? tableIdName;
  String? staffId;
  String? description;
  // String? channelPlatform;
  bool? isRetail;
  bool isSendToKitchen;
  String? cancelStatusId;

  PrevPlaceReqData({
    this.customerUserViewModel,
    this.tableIdName,
    this.staffId,
    this.description,
    // this.channelPlatform,
    this.isRetail,
    this.isSendToKitchen = false,
    this.cancelStatusId,
  });
}

enum PaymentType {
  FullPayment,
  PartialPayment,
  SplitByItem,
  SplitByPerson // don't remove splitby person it causes issue
}

enum PayMethodEnum { Loyalty, GiftCard, Cash, FPOS, Bank, None }

class PayMethodClass {
  static PayMethodEnum getMethod(String? val) {
    if (val == Strings.loyalty)
      return PayMethodEnum.Loyalty;
    else if (val == Strings.giftCard)
      return PayMethodEnum.GiftCard;
    else if (val == Strings.Cash)
      return PayMethodEnum.Cash;
    else if (val == Strings.fpos)
      return PayMethodEnum.FPOS;
    else if (val == Strings.bank)
      return PayMethodEnum.Bank;
    else
      return PayMethodEnum.None;
  }
}

//2691

class PayTypeTab {
  final int id;
  final String title;

  PayTypeTab({required this.id, required this.title});
}

enum FocusKeyPad { PaidByUser, PaidAmount, TipAmount, NoOfUser }

class PaySummary {
  final String totalAmount;
  final String paidAmountByUser;
  final PayMethodEnum payMethod;
  // bool? isSendToKit;
  // bool? isSentToKitDisplay;
  String? orderId;

  PaySummary({
    required this.totalAmount,
    required this.paidAmountByUser,
    required this.payMethod,
    // this.isSendToKit = false,
    // this.isSentToKitDisplay = false,
    this.orderId,
  });
}
