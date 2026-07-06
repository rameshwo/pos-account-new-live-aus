import 'package:flutter/material.dart';
import 'package:oktoast/oktoast.dart';
import 'package:pos_account/config/validator.dart';
import 'package:pos_account/constant/date_format_keys.dart';
import 'package:pos_account/constant/strings.dart';
import 'package:pos_account/model/common/category.dart';
import 'package:pos_account/model/common/filter_category.dart';
import 'package:pos_account/model/common/table_location.dart';
import 'package:pos_account/model/home/booking/all_customer.dart';
import 'package:pos_account/model/home/menu/orders/order_detail_by_id.dart';
import 'package:pos_account/model/home/menu/orders/refund_order.dart';
import 'package:pos_account/model/home/menu/payment/cus_loyal_res.dart';
import 'package:pos_account/model/home/menu/place_order/place_order_req.dart';
import 'package:pos_account/model/home/menu/place_order/place_order_res.dart';
import 'package:pos_account/model/home/menu/place_order/po_make_pay_req.dart';
import 'package:pos_account/model/home/menu/place_order/pos_res/com/feature_product.dart';
import 'package:pos_account/model/home/product/product_data_req.dart';
import 'package:pos_account/model/ui_model/amount_class.dart';
import 'package:pos_account/providers/cus_val_pro.dart';

class OrderUtils {
  static TaxType getTaxType(String? taxTypeString) {
    var _taxType = TaxType.NoTax;
    if (taxTypeString != null) {
      if (taxTypeString.toLowerCase().contains(Strings.taxInc))
        _taxType = TaxType.Inclusive;
      else if (taxTypeString.toLowerCase().contains(Strings.taxExc))
        _taxType = TaxType.Exclusive;
    }
    return _taxType;
  }

  static String getTaxTypeString(TaxType? taxType) {
    String _taxType = Strings.taxNo;

    if (taxType == TaxType.Exclusive) {
      _taxType = Strings.taxExc;
    } else if (taxType == TaxType.Inclusive) {
      _taxType = Strings.taxInc;
    }
    return _taxType;
  }

  static AmountClass getDisAmtWithTax({
    required String discountPercent,
    required String? price,
    required String? taxTypeString,
    double disTaxCoff = 0.0,
  }) {
    final _taxType = getTaxType(taxTypeString);

    double _price = price?.inDouble ?? 0.0;
    double _disPercent = discountPercent.inDouble;

    double _disWithoutTax = 0.0;
    double _disWithTax = 0.0;

    final _disValue = _price * _disPercent / 100;

    final _disTax = _disValue * disTaxCoff;

    if (_taxType == TaxType.Inclusive) {
      _disWithTax = _disValue;
      _disWithoutTax = _disValue - _disTax;
    } else if (_taxType == TaxType.Exclusive) {
      _disWithoutTax = _disValue;
      _disWithTax = _disValue + _disTax;
    } else {
      _disWithoutTax = _disValue;
      _disWithTax = _disValue;
    }

    return AmountClass()
      ..itemPrice = _price
      ..taxType = _taxType
      ..totalTax = _disTax.roundToN()
      ..totalPrice = _price.roundToN()
      ..discount = _disWithoutTax.roundToN()
      ..discountWithTax = _disWithTax.roundToN();
  }

  static AmountClass orderAmount({
    required List<SetMenuOrderDetail> setMenuList,
    required List<OrderDetail> orderList,
    required List<RawIngredientOrderDetail> ingreList,
    required String taxTypeString,
    OnPayScreenFor onPayScreenFor = OnPayScreenFor.Payment,
    required String orderTypeId,
  }) {
    final _amount = AmountClass();

    double _finalTax = 0.0;
    double _finalPrice = 0.0;

    _amount.taxType = getTaxType(taxTypeString);

    for (final a in setMenuList) {
      final _statusEnum = getStatusEnum(a.statusId);
      final _blocked = (_statusEnum == OrderStatusEnum.hold &&
              onPayScreenFor != OnPayScreenFor.Cart) ||
          _statusEnum == OrderStatusEnum.cancel;
      if (a.totalSetMenuPrice != null && !_blocked) {
        double _taxValue = 0.0;
        if (a.taxType == TaxType.Inclusive) {
          _taxValue = a.taxPercent / (100 + a.taxPercent);
        } else if (a.taxType == TaxType.Exclusive) {
          _taxValue = a.taxPercent / 100;
        }

        final _mTotal = a.orderItemsViewModels?.fold<double>(
            0,
            (pV1, e1) =>
                pV1 +
                (e1.orderItemsPriceModifierViewModels?.fold<double>(
                        0,
                        (pV2, e2) =>
                            pV2 +
                            (e2.isActive ? (e2.totalModifierPrice ?? 0) : 0)) ??
                    0));

        double _totalSetmenuPrice = a.totalSetMenuPrice! + (_mTotal ?? 0);

        if (a.isSelected && a.initQty != a.paidQuantity) {
          // print("Item ${a.setMenuName} $_mTotal $_totalSetmenuPrice");
          _amount.itemPrice += _totalSetmenuPrice.roundToN();
          _amount.totalTax += (_totalSetmenuPrice * _taxValue).roundToN();
        }

        final int _finalQty = onPayScreenFor == OnPayScreenFor.Payment ||
                onPayScreenFor == OnPayScreenFor.Cart
            ? a.initQty
            : (a.setMenuQuantity ?? 1);

        final _mFinalPrice = a.orderItemsViewModels?.fold<double>(
            0,
            (pV1, e1) =>
                pV1 +
                (e1.orderItemsPriceModifierViewModels?.fold<double>(
                        0,
                        (pV2, e2) =>
                            pV2 +
                            (e2.isActive
                                ? ((e2.modifierPrice ?? 0) * (e2.quantity ?? 1))
                                : 0)) ??
                    0));

        double _finalTotalSetmenuPrice =
            (_finalQty * (a.setMenuPrice ?? 0)) + (_mFinalPrice ?? 0);

        if (a.taxType == TaxType.Inclusive) {
          _amount.finalItemPriceWithTax += _finalTotalSetmenuPrice.roundToN();
        } else {
          _amount.finalItemPriceWithTax +=
              (_finalTotalSetmenuPrice * (1 + _taxValue)).roundToN();
        }
        _amount.finalItemTax +=
            (_finalTotalSetmenuPrice * _taxValue).roundToN();

        _finalTax += (_finalTotalSetmenuPrice * _taxValue).roundToN();
        _finalPrice += _finalTotalSetmenuPrice.roundToN();

        // eod report
        a.finalTotalSellingAmount = _finalTotalSetmenuPrice.roundToN();
        a.finalTotalTax = (_finalTotalSetmenuPrice * _taxValue).roundToN();
      } else {
        // eod report
        a.finalTotalSellingAmount = 0;
        a.finalTotalTax = 0;
      }
    }

    for (final b in orderList) {
      final _statusEnum = getStatusEnum(b.statusId);
      final _blocked = (_statusEnum == OrderStatusEnum.hold &&
              onPayScreenFor != OnPayScreenFor.Cart) ||
          _statusEnum == OrderStatusEnum.cancel;
      if (b.total != null && !_blocked) {
        double _taxPercent = 0.0;

        if (b.taxRules == null || b.taxRules!.isEmpty) {
          _taxPercent = b.taxPercent;
        } else if (b.taxRules![b.taxRuleIndex].taxRuleConditions?.any((z) =>
                z.orderTypeId?.toLowerCase() == orderTypeId.toLowerCase()) ??
            false) {
          final _taxRuleCond = b.taxRules![b.taxRuleIndex].taxRuleConditions
              ?.firstWhere((z) =>
                  z.orderTypeId?.toLowerCase() == orderTypeId.toLowerCase());
          _taxPercent = _taxRuleCond?.salesTax?.inDouble ?? 0.0;
        } else {
          _taxPercent = b.taxPercent;
        }

        double _taxValue = 0.0;

        if (!b.isTaxExempt) {
          if (b.taxType == TaxType.Inclusive) {
            _taxValue = _taxPercent / (100 + _taxPercent);
          } else if (b.taxType == TaxType.Exclusive) {
            _taxValue = _taxPercent / 100;
          }
        }

        // kPrint("${b.productName} ${b.productType} ${b.productPriceType}");

        // print(
        //     '${b.productName} init:  ${b.initQty} qty: ${b.quantity} paid: ${b.paidQuantity} cond: ${b.paidQuantity != 0 ? b.initQty : b.quantity ?? 1}');

        final _mTotal = allMTotal(
          modiList: b.orderItemModifiersViewModels,
          itemQty: //b.paidQuantity != 0 ? b.initQty :
              b.quantity ?? 1,
          initQty: b.initQty,
        );

        // kPrint('${b.productName} ${b.total!} ${_mTotal.total}');

        // double _totalItemPrice = b.total! + (_mTotal);

        // print("---- ${b.productName} $_totalItemPrice $_mTotal");
        // print(
        //     "${b.productName} ${_halfGroupAmt / 2} / ${b.total!} $_mTotal $_totalItemPrice ");

        // print("${b.initQty} != ${b.paidQuantity} ");

        if (b.isSelected && b.initQty != b.paidQuantity) {
          // kPrint("Item ${b.productName} ${b.total!} ${_mTotal.total}");
          _amount.itemPrice += (b.total! + _mTotal.total).roundToN();
          _amount.totalTax += (b.total! * _taxValue).roundToN() + _mTotal.tax;
        }

        final double _finalQty = onPayScreenFor == OnPayScreenFor.Payment ||
                onPayScreenFor == OnPayScreenFor.Cart
            ? b.initQty
            : (b.quantity ?? 1);

        final _mFinalAmt = allMTotal(
          modiList: b.orderItemModifiersViewModels,
          itemQty: b.paidQuantity != 0 ? b.initQty : b.quantity ?? 1,
          initQty: b.paidQuantity != 0 ? b.initQty : b.quantity ?? 1,
        );

        double _finalItemPrice = ((b.productPrice ?? 0) * _finalQty);

        if (!b.isTaxExempt) {
          if (b.taxType == TaxType.Inclusive) {
            _amount.finalItemPriceWithTax +=
                (_finalItemPrice + _mFinalAmt.total).roundToN();
          } else {
            _amount.finalItemPriceWithTax +=
                (_finalItemPrice * (1 + _taxValue)).roundToN() +
                    (_mFinalAmt.total + _mFinalAmt.tax);
          }

          _amount.finalItemTax +=
              (_finalItemPrice * _taxValue).roundToN() + _mFinalAmt.tax;

          _finalTax +=
              (_finalItemPrice * _taxValue).roundToN() + _mFinalAmt.tax;
        }

        // print("${_halfGroupAmt / 2} $_mFinalAmt $_finalItemPrice ");

        _finalPrice += _finalItemPrice.roundToN() + _mFinalAmt.total;

        // eod report
        b.finalTotalSellingAmount =
            _finalItemPrice.roundToN() + _mFinalAmt.total;
        b.finalTotalTax =
            (_finalItemPrice * _taxValue).roundToN() + _mFinalAmt.tax;
      } else {
        // eod report
        b.finalTotalSellingAmount = 0.0;
        b.finalTotalTax = 0.0;
      }
    }

    // ingredients
    for (final b in ingreList) {
      final _statusEnum = getStatusEnum(b.statusId);
      final _blocked = (_statusEnum == OrderStatusEnum.hold &&
              onPayScreenFor != OnPayScreenFor.Cart) ||
          _statusEnum == OrderStatusEnum.cancel;
      if (b.totalSellingPrice != null && !_blocked) {
        double _taxValue = 0.0;
        if (b.taxType == TaxType.Inclusive) {
          _taxValue = b.taxPercent / (100 + b.taxPercent);
        } else if (b.taxType == TaxType.Exclusive) {
          _taxValue = b.taxPercent / 100;
        }

        final _totalItemPrice = double.tryParse(b.totalSellingPrice ?? '') ?? 0;

        if (b.isSelected && b.initQty != b.paidQuantity) {
          _amount.itemPrice += _totalItemPrice.roundToN();
          _amount.totalTax += (_totalItemPrice * _taxValue).roundToN();
        }

        final double _finalQty = onPayScreenFor == OnPayScreenFor.Payment ||
                onPayScreenFor == OnPayScreenFor.Cart
            ? b.initQty
            : (b.quantity ?? 1);

        double _finalItemPrice =
            (b.originalSellingPricePerUnit ?? 0) * _finalQty;

        if (b.taxType == TaxType.Inclusive) {
          _amount.finalItemPriceWithTax += _finalItemPrice.roundToN();
        } else {
          _amount.finalItemPriceWithTax +=
              (_finalItemPrice * (1 + _taxValue)).roundToN();
        }
        _amount.finalItemTax += (_finalItemPrice * _taxValue).roundToN();

        // print("${_halfGroupAmt / 2} $_mFinalAmt $_finalItemPrice ");

        _finalTax += (_finalItemPrice * _taxValue).roundToN();
        _finalPrice += _finalItemPrice.roundToN();

        // eod report
        b.finalTotalSellingAmount = _finalItemPrice.roundToN();
        b.finalTotalTax = (_finalItemPrice * _taxValue).roundToN();
      } else {
        // eod report
        b.finalTotalSellingAmount = 0.0;
        b.finalTotalTax = 0.0;
      }
    }

    ///////////////////////////////////////////////////////////////

    if (_amount.taxType == TaxType.Exclusive) {
      _amount.totalPrice = _amount.itemPrice + _amount.totalTax;
      // _amount.itemPriceWithOutTax = _amount.itemPrice;

      _amount.finalPrice = _finalPrice + _finalTax;
      _amount.finalItemPriceWithOutTax = _finalPrice;

      _amount.finalItemPriceWithTax += _amount.finalItemTax;
    } else if (_amount.taxType == TaxType.Inclusive) {
      _amount.totalPrice = _amount.itemPrice;
      // _amount.itemPriceWithOutTax = _amount.itemPrice - _amount.totalTax;

      _amount.finalPrice = _finalPrice;
      _amount.finalItemPriceWithOutTax = _finalPrice - _finalTax;
    } else {
      _amount.totalPrice = _amount.itemPrice;
      // _amount.itemPriceWithOutTax = _amount.itemPrice;

      _amount.finalPrice = _finalPrice;
      _amount.finalItemPriceWithOutTax = _finalPrice;
    }

    // _amount.finalPriceTax = _finalTax;

    // print('_amount.totalPrice: ${_amount.totalPrice}');

    // print(
    //     "${_amount.totalPrice} ${_amount.finalPrice} ${_amount.finalItemPriceWithOutTax}");

    return _amount;
  }

  static _ModiTotal allMTotal({
    List<OrderItemsPriceModifierViewModel>? modiList,
    double itemQty = 1,
    double initQty = 1,
  }) {
    double _modiTotal = 0;
    double _modiTax = 0.0;

    if (modiList != null) {
      for (final a in modiList) {
        if (a.isActive) {
          final _isItem = a.type?.toLowerCase().contains('item') ?? false;
          final _singleModiTotal = (a.isDealsHalf ?? false) ||
                  _isItem ||
                  (!(a.isDealModifier ?? false) &&
                      (a.modifierItemsModifierViewModels?.isNotEmpty ?? false))
              ? 0.0
              : (a.modifierPrice ?? 0) *
                  (itemQty == 0 ? 0 : ((a.quantity ?? 1) * itemQty / initQty));

          // if (a.isActive)
          //   kPrint(
          //       "${a.modifierName} ${a.type} ${a.isDealsHalf} ${a.isDealModifier} ${a.modifierPrice} $_singleModiTotal");

          _modiTotal += _singleModiTotal;
          if (!a.isTaxExempt) {
            _modiTax += a.totalTax ?? 0.0;
          }
          if (a.isHalforCombo ?? false) {
            final _allTotal = allMTotal(
              modiList: a.modifierItemsModifierViewModels,
              itemQty: itemQty,
              initQty: initQty,
            );
            _modiTotal += _allTotal.total;
            if (!a.isTaxExempt) {
              _modiTax += _allTotal.tax;
            }
          }
        }
      }
    }
    return _ModiTotal(total: _modiTotal.roundToN(), tax: _modiTax..roundToN());
    // return _modiTotal.roundToN();
  }

  static AmountClass getAmount({
    required String? taxTypeString,
    String? taxPercent,
    String? price,
    double? quantity,
    String? actualPrice,
    String orderTypeId = "",
    List<TaxRule>? taxRules,
    int taxRuleIndex = 0,
    bool isNoTax = false,
  }) {
    double _taxPercent = 0.0;
    double _taxValue = 0.0;
    double _price = price.inDouble;
    double _quantity = quantity ?? 0;

    final _taxType = getTaxType(taxTypeString);

    if (taxRules == null || taxRules.isEmpty) {
      _taxPercent = taxPercent.inDouble;
    } else if (taxRules[taxRuleIndex].taxRuleConditions?.any(
            (z) => z.orderTypeId?.toLowerCase() == orderTypeId.toLowerCase()) ??
        false) {
      final _taxRuleCond = taxRules[taxRuleIndex].taxRuleConditions?.firstWhere(
          (z) => z.orderTypeId?.toLowerCase() == orderTypeId.toLowerCase());
      _taxPercent = _taxRuleCond?.salesTax?.inDouble ?? 0.0;
    } else {
      _taxPercent = taxPercent.inDouble;
    }

    double _disWithoutTax = 0.0;
    double _disWithTax = 0.0;

    final _totalPrice = _price * _quantity;
    final _discountAmount =
        actualPrice == null ? 0.0 : (actualPrice.inDouble - _price) * _quantity;

    if (!isNoTax) {
      if (_taxType == TaxType.Inclusive) {
        _taxValue = _taxPercent / (100 + _taxPercent);
        _disWithoutTax = _discountAmount * (1 - _taxValue);
        _disWithTax = _discountAmount;
      } else if (_taxType == TaxType.Exclusive) {
        _taxValue = _taxPercent / 100;
        _disWithoutTax = _discountAmount;
        _disWithTax = _discountAmount * (1 + _taxValue);
      }
    }

    return AmountClass()
      ..taxPercent = _taxPercent
      ..itemPrice = _price
      ..taxType = _taxType
      ..totalTax = (_taxValue * _totalPrice).roundToN()
      ..totalPrice = _totalPrice.roundToN()
      ..discount = _disWithoutTax.roundToN()
      ..discountWithTax = _disWithTax.roundToN();
  }

  ///[withoutTaxCoff] TaxCofficient to get withouttax value

  static double withoutTaxCoff({
    required String taxTypeString,
    required double taxPercent,
  }) {
    final _taxType = getTaxType(taxTypeString);

    double _taxCoff = 0.0;
    if (_taxType == TaxType.Inclusive) {
      _taxCoff = taxPercent / (100 + taxPercent);
    } else if (_taxType == TaxType.Exclusive) {
      _taxCoff = taxPercent / 100;
    }

    return 1 - _taxCoff;
  }

  static double checkPayData(PoMakePaymentReq? _payReq,
      {OrderDetailById? orderDetailById}) {
    if (_payReq == null) return 0;

    if ((_payReq.paidAmount.inDouble - _payReq.totalPaymentAmount.inDouble)
            .abs() >
        0.01) return 0;

    // final _prevTipAmount = orderDetailById
    //     ?.orderPaymentDetailsWithPaymentStatusViewModel?.tipAmount;

    final _prevPaidAmount = orderDetailById
            ?.orderPaymentDetailsWithPaymentStatusViewModel
            ?.orderPaymentsDetailsViewModels
            ?.fold<double>(0, (pV, nV) => pV + nV.paidAmount.inDouble) ??
        0;

    final _totalAmountWithOutTax = _payReq.totalWithoutTaxAmount.inDouble +
            _payReq.deliveryAmount.inDouble -
            _payReq.discountAmount.inDouble +
            _payReq.publicHolidaySurChargeAmount.inDouble +
            _payReq.creditCardSurChargeAmount.inDouble +
            _payReq.taxAmount.inDouble
        // + (_prevTipAmount.inDouble + _payReq.paymentTipAmount.inDouble)
        ;

    final _variance = (_totalAmountWithOutTax -
            (_prevPaidAmount + _payReq.paidAmount.inDouble))
        .roundToN();

    // print("pay varinace $_variance");

    final _isCC = _payReq.creditCardSurChargeAmount.inDouble != 0;
    final _isPH = _payReq.publicHolidaySurChargeAmount.inDouble != 0;
    final _isDA = _payReq.discountAmount.inDouble != 0;

    // // print(
    // //     "before :: cc: ${_payReq.creditCardSurChargeAmount} | ph ${_payReq.publicHolidaySurChargeAmount} | dis: ${_payReq.discountAmount}");

    if (_variance.abs() == 0)
      return 0;
    else if (_variance.abs() < 0.03) {
      {
        if (_isCC) {
          _payReq.creditCardSurChargeAmount =
              (_payReq.creditCardSurChargeAmount.inDouble - _variance)
                  .roundToNString();
        } else if (_isPH) {
          _payReq.publicHolidaySurChargeAmount =
              (_payReq.publicHolidaySurChargeAmount.inDouble - _variance)
                  .roundToNString();
        } else if (_isDA) {
          _payReq.discountAmount =
              (_payReq.discountAmount.inDouble + _variance).roundToNString();
        }
      }
    } else {
      final _typeIndex = double.tryParse(
                  orderDetailById?.orderDetailsViewModel?.paymentType ?? '0')
              ?.floor() ??
          0;
      if (_typeIndex == 1 || _typeIndex == 3) {
        final _payCount = orderDetailById
                ?.orderPaymentDetailsWithPaymentStatusViewModel
                ?.orderPaymentsDetailsViewModels
                ?.length ??
            1;

        if (_variance.abs() <= 0.01 * (_payCount + 1)) {
          double _tx = 0.0, _cx = 0.0, _px = 0.0;

          if (_isCC && _isPH) {
            final _x = _variance / 5;
            _cx = (3 * _x).roundToN();
            _px = _x.roundToN();
            _tx = (_variance - _cx - _px).roundToN();
          } else if (_isCC || _isPH) {
            final _x = _variance / 2;
            _tx = (_variance - _x).roundToN();
            if (_isCC)
              _cx = _x.roundToN();
            else
              _px = _x.roundToN();
          }

          // print("_tx: $_tx, _cx: $_cx, _px: $_px");

          _payReq.creditCardSurChargeAmount =
              (_payReq.creditCardSurChargeAmount.inDouble - _cx)
                  .roundToNString();
          _payReq.publicHolidaySurChargeAmount =
              (_payReq.publicHolidaySurChargeAmount.inDouble - _px)
                  .roundToNString();
          _payReq.taxAmount =
              (_payReq.taxAmount.inDouble - _tx).roundToNString();
        }
      }
    }

    // print(
    //     "after :: cc: ${_payReq.creditCardSurChargeAmount} | ph ${_payReq.publicHolidaySurChargeAmount} | dis: ${_payReq.discountAmount}");

    return 0;
  }

  static int checkRefundData(RefundOrderReq _refundReq) {
    final _totalAmountWithOutTax = _refundReq.refundAmountWithoutTax.inDouble +
        _refundReq.refundDeliveryAmount.inDouble -
        _refundReq.refundDiscountAmount.inDouble +
        _refundReq.refundPublicHolidaySurChargeAmount.inDouble +
        _refundReq.refundCreditCardSurChargeAmount.inDouble +
        _refundReq.refundTaxAmount.inDouble;

    final _variance =
        (_totalAmountWithOutTax - _refundReq.refundAmount.inDouble).roundToN();

    // print("refund varinace $_variance");

    if (_variance.abs() == 0) return 1;

    if (_variance < -0.03 || _variance > 0.03) return 2;

    final _isCC = _refundReq.refundCreditCardSurChargeAmount.inDouble != 0;
    final _isPH = _refundReq.refundPublicHolidaySurChargeAmount.inDouble != 0;
    final _isDA = _refundReq.refundDiscountAmount.inDouble != 0;

    if (_isCC && _isPH && _isDA && _variance.abs() == 0.03) {
      final _subTemp = _variance / 3;
      _refundReq.refundCreditCardSurChargeAmount =
          (_refundReq.refundCreditCardSurChargeAmount.inDouble - _subTemp)
              .roundToNString();
      _refundReq.refundPublicHolidaySurChargeAmount =
          (_refundReq.refundPublicHolidaySurChargeAmount.inDouble - _subTemp)
              .roundToNString();
      _refundReq.refundDiscountAmount =
          (_refundReq.refundDiscountAmount.inDouble + _subTemp)
              .roundToNString();
    } else if (_refundReq.refundCreditCardSurChargeAmount.inDouble != 0) {
      _refundReq.refundCreditCardSurChargeAmount =
          (_refundReq.refundCreditCardSurChargeAmount.inDouble - _variance)
              .roundToNString();
    } else if (_refundReq.refundPublicHolidaySurChargeAmount.inDouble != 0) {
      _refundReq.refundPublicHolidaySurChargeAmount =
          (_refundReq.refundPublicHolidaySurChargeAmount.inDouble - _variance)
              .roundToNString();
    } else if (_refundReq.refundDiscountAmount.inDouble != 0) {
      _refundReq.refundDiscountAmount =
          (_refundReq.refundDiscountAmount.inDouble + _variance)
              .roundToNString();
    }

    return 3;
  }

  static List<Category>? getCatList(List<FilterCategory>? dataList) {
    if (dataList == null || dataList.isEmpty) return [];
    return List<Category>.generate(
      dataList.length,
      (index) => Category(
        categoryId: dataList[index].filterCategoryId,
        categoryName: dataList[index].filterCategoryName,
        childernCategories: getCatList(dataList[index].childernCategories),
      ),
    );
  }

  static CusData? convertCusForLoyaltyResToCusData(
      CusForLoyalityRes? cusForLoyaltyRes) {
    if (cusForLoyaltyRes == null) return null;
    return CusData(
      id: cusForLoyaltyRes.id,
      name: cusForLoyaltyRes.customerName,
      email: cusForLoyaltyRes.email,
      phoneNumber: cusForLoyaltyRes.phoneNumber,
      postalCode: cusForLoyaltyRes.postalCode,
      countryPhoneNumberPrefixId: cusForLoyaltyRes.countryPhoneNumberPrefixId,
      countryId: cusForLoyaltyRes.countryId,
      isLoyaltyEnabled: cusForLoyaltyRes.loyaltyEnabled,
      isMarketingPromotionEnabled: cusForLoyaltyRes.isMarketingPromotionEnabled,
      voucherGroup:
          null, // Set appropriate value based on your logic or leave it as null
      customerType: cusForLoyaltyRes.customerTypeId,
      total:
          null, // Set appropriate value based on your logic or leave it as null
    );
  }

  ////testing

  // static PromDiscount? getPromDiscount(
  //     List<DiscountedPromotion>? discountedPromotions) {
  //   final _currentDay = GET_DAY.format(DateTime.now());
  //   final _currentTime = GET_TIME.parse(GET_TIME.format(DateTime.now()));

  //   if (discountedPromotions != null) {
  //     PromDiscount? promDiscount;

  //     for (final a in discountedPromotions) {
  //       if (a.weekDays?.any(
  //               (b) => b.trim().toLowerCase() == _currentDay.toLowerCase()) ??
  //           false) {
  //         try {
  //           final _timeFrom = GET_TIME.parse(a.timeFrom ?? '');

  //           final _timeTo = GET_TIME.parse(a.timeTo ?? '');

  //           if (_currentTime.isAfter(_timeFrom) &&
  //               _currentTime.isBefore(_timeTo)) {
  //             // print("$_timeFrom<$_currentTime<$_timeTo");
  //             final _remainingTime = _timeTo.difference(_currentTime);
  //             return PromDiscount(
  //               discountPercent: a.discountPercentage,
  //               discountedPrice: a.discountedPrice,
  //               offerEndsIn: _remainingTime,
  //               isOfferStart: true,
  //               message: a.promotionalMessage,
  //               tsCount: a.discountThresholdCount,
  //             );
  //           } else {
  //             final _secondDiff = _timeFrom.difference(_currentTime).inSeconds;
  //             final _offerEndsIn = _timeTo.difference(_timeFrom);

  //             if (_secondDiff >= 0) {
  //               promDiscount ??= PromDiscount(
  //                 discountPercent: a.discountPercentage,
  //                 discountedPrice: a.discountedPrice,
  //                 offerStartsIn: Duration(seconds: _secondDiff),
  //                 offerEndsIn: _offerEndsIn,
  //                 isOfferStart: false,
  //                 message: a.promotionalMessage,
  //                 tsCount: a.discountThresholdCount,
  //               );

  //               if (_secondDiff < promDiscount.offerStartsIn!.inSeconds) {
  //                 promDiscount = PromDiscount(
  //                   discountPercent: a.discountPercentage,
  //                   discountedPrice: a.discountedPrice,
  //                   offerStartsIn: Duration(seconds: _secondDiff),
  //                   offerEndsIn: _offerEndsIn,
  //                   isOfferStart: false,
  //                   message: a.promotionalMessage,
  //                   tsCount: a.discountThresholdCount,
  //                 );
  //               }
  //             }
  //           }
  //         } catch (_) {
  //           return null;
  //         }
  //       }
  //     }

  //     return promDiscount;
  //   }
  //   return null;
  // }

  static void setNearestDate(
      {required List<ProductVariationBatchStock> batchList,
      required String dateFormat}) {
    if (batchList.isEmpty) return;

    String _nearestDate = "";
    int _nearDiff = -1;
    try {
      _nearestDate = batchList.first.expiryDate ?? "";

      _nearDiff = _nearestDate.isNotEmpty
          ? GET_DATE_FORMAT(dateFormat)
              .parse(_nearestDate)
              .difference(DateTime.now())
              .inDays
          : 0;
    } catch (e) {
      // print('issue 1');
    }

    for (final e in batchList) {
      DateTime? _d1;
      try {
        if ((e.expiryDate ?? _nearestDate).isNotEmpty)
          _d1 = GET_DATE_FORMAT(dateFormat).parse(e.expiryDate ?? _nearestDate);
      } catch (e) {
        // print('issue 2');
      }

      if (_d1 != null) {
        final _diff = _d1.difference(DateTime.now()).inDays;

        if ((_diff >= 0 && _diff <= _nearDiff) ||
            (_nearDiff < 0 && _diff >= 0)) {
          _nearestDate = e.expiryDate ?? _nearestDate;
          _nearDiff = _diff;
        }
      }
    }

    // for (final e in batchList) {
    //   if (e.expiryDate == _nearestDate) {
    //     {
    //       e.isActive = true;
    //     }
    //   } else
    //     e.isActive = false;
    // }

    //as two batch can have e.expiryDate == _nearestDate , so we need to set only one batch as active
    final _activeBatch = batchList.firstWhere(
        (e) => e.expiryDate == _nearestDate,
        orElse: () => batchList.first);

    for (final e in batchList) {
      e.isActive = e == _activeBatch;
    }
  }

  static bool outOfBatchStock({required ProductVariation? selectedVariance}) {
    if (!GlobalCVP.stockExceedRestriction) return false;
    if (selectedVariance == null) return false;

    if (selectedVariance.productVariationBatchStocks?.any((e) => e.isActive) ??
        false) {
      final _batchStock = selectedVariance.productVariationBatchStocks
          ?.firstWhere((e) => e.isActive)
          .stockCount;

      if ((_batchStock?.isNotEmpty ?? false) && _batchStock.inDouble <= 0) {
        showToast("Item is Out of Stock for current batch, Select other batch",
            backgroundColor: Colors.red.shade700, position: ToastPosition.top);
        return true;
      }
    }
    return false;
  }

  static ProductType prodType(String? type) {
    if (type == null) return ProductType.Item;

    if (type.toLowerCase().contains('combo')) {
      return ProductType.Combo;
    } else if (type.toLowerCase().contains('half') ||
        type.toLowerCase().contains('quarter')) {
      return ProductType.Half;
    }
    // else if (type.toLowerCase().contains('deal')) {
    //   return ProductType.Deal;
    // }
    return ProductType.Item;
  }

  static ProductPriceType? productPriceType(String? _priceType) {
    try {
      return ProductPriceType.values.firstWhere((a) =>
          a.name.toLowerCase() ==
          _priceType?.replaceAll(' ', '').toLowerCase());
    } catch (e) {
      return null;
    }
  }

  static bool doDirectAddToCart(
      {required FeaturedProduct? product, required String channelId}) {
    final _variation = product?.productVariations
        ?.where((a) => a.channelId?.toLowerCase() == channelId.toLowerCase())
        .toList();
    // kPrint("${product?.productVariations?.map((a) => a.channelId).toList()}");

    // kPrint('$channelId ${_variation?.length}');

    final _isDirectAddForStore = ((_variation?.isNotEmpty ?? false) &&
        _variation?.length == 1 &&
        ((_variation?.first.productVariationModifiers == null ||
                (_variation?.first.productVariationModifiers != null &&
                    _variation!.first.productVariationModifiers!.isEmpty)) ||
            (_variation!.first.productVariationModifiers!.every(
                (a) => a.modifierItems == null || a.modifierItems!.isEmpty))) &&
        // (_variation?.first.productSpiceChoices == null ||
        //     (_variation?.first.productSpiceChoices != null &&
        //         _variation!.first.productSpiceChoices!.isEmpty)) &&
        // (_variation?.first.productIngredients == null ||
        //     (_variation?.first.productIngredients != null &&
        //         _variation!.first.productIngredients!.isEmpty)) &&
        (product?.filterTypeFilterOptions == null ||
            (product?.filterTypeFilterOptions != null &&
                product!.filterTypeFilterOptions!.isEmpty)) &&
        (product?.taxRules == null ||
            ((product?.taxRules != null &&
                (product!.taxRules!.isEmpty ||
                    product.taxRules!.length == 1)))));

    final _isDirectAddForService = (_variation?.isNotEmpty ?? false) &&
        _variation?.length == 1 &&
        (_variation?.first.productVariationServiceEmployees == null ||
            (_variation?.first.productVariationServiceEmployees != null &&
                _variation!.first.productVariationServiceEmployees!.isEmpty));

    // kPrint(
    //     "_isDirectAddForStore: ${(_variation?.first.productVariationModifiers == null || (_variation?.first.productVariationModifiers != null && _variation!.first.productVariationModifiers!.isEmpty))}");

    if (GlobalCVP.isServiceStore)
      return _isDirectAddForService;
    else
      return _isDirectAddForStore;
  }

  // order status
  static List<TableLocation>? statusList;

  static String getStatusId(OrderStatusEnum status) {
    if (statusList?.any(
            (e) => e.name?.toLowerCase().contains(status.name) ?? false) ??
        false) {
      final _statusD = statusList?.firstWhere(
          (e) => e.name?.toLowerCase().contains(status.name) ?? false);

      return _statusD?.id ?? '';
    } else
      return '';
  }

  static OrderStatusEnum getStatusEnum(String? id) {
    if (statusList?.any((e) => e.id?.toLowerCase() == id?.toLowerCase()) ??
        false) {
      final _statusD = statusList
          ?.firstWhere((e) => e.id?.toLowerCase() == id?.toLowerCase());

      if (OrderStatusEnum.values.any(
          (f) => _statusD?.name?.toLowerCase().contains(f.name) ?? false)) {
        return OrderStatusEnum.values.firstWhere(
            (f) => _statusD?.name?.toLowerCase().contains(f.name) ?? false);
      }
    }
    return OrderStatusEnum.none;
  }

  static OrderStatusEnum getStatusEnumFromStr(String? status) {
    if (OrderStatusEnum.values
        .any((f) => status?.toLowerCase().contains(f.name) ?? false)) {
      return OrderStatusEnum.values
          .firstWhere((f) => status?.toLowerCase().contains(f.name) ?? false);
    }
    return OrderStatusEnum.none;
  }

  static ItemStatusEnum getItemStatusEnum(String? name) {
    if (ItemStatusEnum.values.any(
      (f) => name?.toLowerCase().contains(f.name) ?? false,
    )) {
      return ItemStatusEnum.values.firstWhere(
        (f) => name?.toLowerCase().contains(f.name) ?? false,
      );
    }

    return ItemStatusEnum.none;
  }

  static ModifierItem? getActiveModifierItem(
      ModifierItem? currentModifier, String title) {
    try {
      // Safely find the modifier that contains 'first'
      final modifier = currentModifier?.modifierItemModifiers?.firstWhere(
        (a) => (a.name?.toLowerCase().contains(title) ?? false),
      );

      // Safely find the first active modifier item
      final activeItem = modifier?.modifierItems?.firstWhere(
        (b) => (b.isActive ?? false),
      );

      return activeItem;
    } catch (e) {
      // In case of unexpected structure or nulls
      return null;
    }
  }

  static ModifierType getModifierType(String? type) {
    try {
      return ModifierType.values.firstWhere(
          (a) => type?.toLowerCase().contains(a.name) ?? false,
          orElse: () => ModifierType.modifier);
    } catch (e) {
      return ModifierType.modifier;
    }
  }

  static HalfProductType halfType(String? type) {
    if (type?.toLowerCase().contains('quarter') ?? false) {
      return HalfProductType.Quarter;
    }
    return HalfProductType.Half;
  }
}

extension FilterByType on List<ProductVariationModifier> {
  List<ProductVariationModifier> whereModiType(ModifierType type) {
    if (type != ModifierType.modifier)
      return where(
              (item) => item.type?.toLowerCase().contains(type.name) ?? false)
          .toList();
    else {
      return where((item) =>
          !(item.type?.toLowerCase().contains(ModifierType.rawingre.name) ??
              false) &&
          !(item.type?.toLowerCase().contains(ModifierType.spice.name) ??
              false)).toList();
    }
  }
}

extension FilterByType2 on List<OrderItemsPriceModifierViewModel> {
  List<OrderItemsPriceModifierViewModel> whereModiType2(ModifierType type) {
    if (type != ModifierType.modifier)
      return where(
              (item) => item.type?.toLowerCase().contains(type.name) ?? false)
          .toList();
    else {
      final _list = where((item) =>
          !(item.type?.toLowerCase().contains(ModifierType.rawingre.name) ??
              false) &&
          !(item.type?.toLowerCase().contains(ModifierType.spice.name) ??
              false)).toList();
      _list.sort((a, b) => (a.labelName ?? '').compareTo(b.labelName ?? ''));
      return _list;
    }
  }
}

extension FilterByType3 on List<Modifier> {
  List<Modifier> whereModiType3(ModifierType type) {
    if (type != ModifierType.modifier)
      return where(
              (item) => item.type?.toLowerCase().contains(type.name) ?? false)
          .toList();
    else {
      final _list = where((item) =>
          !(item.type?.toLowerCase().contains(ModifierType.rawingre.name) ??
              false) &&
          !(item.type?.toLowerCase().contains(ModifierType.spice.name) ??
              false)).toList();
      _list.sort((a, b) => (a.labelName ?? '').compareTo(b.labelName ?? ''));
      return _list;
    }
  }
}

extension InventoryModifierFilterByType4
    on List<ProductVariationModifierGroupModifierItem> {
  List<ProductVariationModifierGroupModifierItem> get getProductssOnly {
    return where(
            (item) => item.type?.toLowerCase().contains('product') ?? false)
        .toList();
  }

  List<ProductVariationModifierGroupModifierItem> get getCustomOnly {
    return where((item) => item.type?.toLowerCase().contains('custom') ?? false)
        .toList();
  }

  List<ProductVariationModifierGroupModifierItem> get getIngredientsOnly {
    return where(
            (item) => item.type?.toLowerCase().contains('ingredie') ?? false)
        .toList();
  }
}

class _ModiTotal {
  final double total;
  final double tax;

  _ModiTotal({required this.total, required this.tax});
}

enum OnPayScreenFor { Payment, Refund, Cart }

// enum HalfPriceType { Higher, Fixed, Average }

enum ProductPriceType {
  FixedPrice,
  VariablePrice,
  WeightedAveragePrice,
  MakeYourOwn,
  FixedPriceFixedProduct
}

// {
//     FixedPrice = 1, current
//     VariablePrice = 2,
//     WeightedAveragePrice = 3,
//     HighestPrice = 4,
//     FixedPriceFixedProduct=5

enum ProductType { Item, Combo, Half, Ingre }

// {
//     Items = 1,
//     Services = 2,
//     ComboDeals = 3,
//     HalfnHalfs = 4,
//     FoodAndBeverages = 5,
//     RawLooseItems = 6,
//     GiftCards = 7,
//     FourQuarter=8,
// }

enum OrderStatusEnum { hold, release, cancel, none }

enum ModifierType { modifier, rawingre, spice }

enum ItemStatusEnum { pending, preparing, prepared, none }

enum HalfProductType { Half, Quarter }
