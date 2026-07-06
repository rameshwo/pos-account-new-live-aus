import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:oktoast/oktoast.dart';
import 'package:pos_account/config/utils/promo_utils.dart';
import 'package:pos_account/config/size_config.dart';
import 'package:pos_account/config/utils/order_utils.dart';
import 'package:pos_account/config/utils/utils.dart';
import 'package:pos_account/config/validator.dart';
import 'package:pos_account/constant/constant.dart';
import 'package:pos_account/constant/text_formatter.dart';
import 'package:pos_account/ln.dart';
import 'package:pos_account/model/home/menu/place_order/place_order_req.dart';
import 'package:pos_account/model/home/menu/place_order/po_make_pay_req.dart';
import 'package:pos_account/model/ui_model/amount_class.dart';
import 'package:pos_account/providers/cus_val_pro.dart';
import 'package:pos_account/providers/menu/payment_pro.dart';
import 'package:pos_account/screens/home_screen/com/items/com/price_update_dia.dart';
import 'package:pos_account/screens/home_screen/com/items/sidebar/sidebar_section/com/order_total.dart';
import 'package:pos_account/screens/home_screen/com/pos_orders/com/pending_order/pending_order.dart';
import 'package:pos_account/widgets/dialog/confirm_dialog.dart';
import 'package:pos_account/widgets/dialog/custom_dialog.dart';
import 'package:pos_account/widgets/load_btn.dart';
import 'package:pos_account/widgets/loading.dart';
import 'package:pos_account/widgets/input/text_form/text_form_widget.dart';
import 'package:provider/provider.dart';
import '../../../../../../../model/common/table_location.dart';
import '../../../com/cus_expansion.dart';

class OrderDetailSec extends StatelessWidget {
  final PaymentPro payPro;
  final bool isPrimary;
  final Function()? refresh;

  const OrderDetailSec({
    super.key,
    required this.payPro,
    this.isPrimary = true,
    this.refresh,
  });

  static final scrollCltr = ScrollController();

  void updateDiscount({bool updatePaidAmt = true}) {
    payPro.setData(doUpdate: false, totalAmount: payPro.getAllAmount.itemPrice);
    payPro.onChangedPayAmount(isUpdatePaidAmount: updatePaidAmt);
  }

  Widget _disableSection({bool readOnly = false, required Widget child}) {
    return IgnorePointer(
      ignoring: readOnly,
      child: Opacity(
        opacity: readOnly ? 0.5 : 1,
        child: child,
      ),
    );
  }

  bool get _isSplitPay {
    return payPro.onPayScreenFor != OnPayScreenFor.Refund &&
        payPro.paymentType != PaymentType.SplitByItem &&
        (payPro.remainingAmount ?? 0) != 0;
  }

  void updateOrderDetail(
      {required final OrderDetail order, required double qty}) {
    final _amount = OrderUtils.getAmount(
      taxTypeString: OrderUtils.getTaxTypeString(order.taxType),
      taxPercent: order.taxPercent.toString(),
      price: order.productPrice.toString(),
      quantity: qty,
      actualPrice: order.actualPrice,
      // discountPercent: order.discountPercentage,
    );

    order.quantity = qty;
    order.total = _amount.totalPrice;
    order.totalTax = _amount.totalTax.roundToNString();
    order.discountWithoutTax = _amount.discount.roundToNString();
    order.discountWithTax = _amount.discountWithTax.roundToNString();

    if (order.orderItemModifiersViewModels != null) {
      // final double _modiQty = qty == 0.5 ? 1 : qty;
      order.orderItemModifiersViewModels?.forEach((a) {
        final _modiferAmt = OrderUtils.getAmount(
          taxTypeString: OrderUtils.getTaxTypeString(order.taxType),
          taxPercent: order.taxPercent.toString(),
          price: a.modifierPrice.toString(),
          quantity: a.quantity ?? 1,
        );
        // a.quantity = _modiQty;
        a.totalTax = _modiferAmt.totalTax;
        a.totalModifierPrice = _modiferAmt.totalPrice;
      });
    }
  }

  void _updateOrderQty(BuildContext context) {
    showDialog(
        context: context,
        builder: (builder) => ConfirmDialog(
              title: LN.updateOrder,
              titleSize: 18,
              subTitle: LN.sureUpdateOrder,
              actionText: LN.update,
              onDelete: () async {
                Utils.handleSearch(callback: () async {
                  await payPro
                      .updatePlaceOrder(
                    orderTypeId: payPro
                        .orderDetailById?.orderDetailsViewModel?.orderTypeId,
                  )
                      .then((value) {
                    if (value ?? false) {
                      payPro.setUniSearchData();
                    }
                  });
                });
                return null;
              },
            ));
  }

  _updateSetmenuQty(int i, {bool? p0}) {
    final minQty = payPro.onPayScreenFor == OnPayScreenFor.Refund ? 0 : 1;

    int qty = payPro.setMenuList[i].setMenuQuantity ?? 1;
    if (p0 != null) {
      if (p0) {
        qty++;
      } else {
        if (qty < 1 + minQty) return;
        qty--;
      }
    }
    final _amount = OrderUtils.getAmount(
      taxTypeString: OrderUtils.getTaxTypeString(payPro.setMenuList[i].taxType),
      taxPercent: payPro.setMenuList[i].taxPercent.toString(),
      price: payPro.setMenuList[i].setMenuPrice.toString(),
      quantity: qty.toDouble(),
      actualPrice: payPro.setMenuList[i].actualPrice,
      // discountPercent: payPro.setMenuList[i].discountPercentage,
    );

    payPro.setMenuList[i].setMenuQuantity = qty;
    // payPro.setMenuList[i].initQty = _quantity;
    payPro.setMenuList[i].totalSetMenuPrice = qty * _amount.itemPrice;

    payPro.setMenuList[i].discountWithoutTax =
        _amount.discount.roundToNString();
    payPro.setMenuList[i].discountWithTax =
        _amount.discountWithTax.roundToNString();
    payPro.setMenuList[i].totalTax = _amount.totalTax.roundToNString();

    payPro.setMenuList[i].orderItemsViewModels?.forEach((e) {
      e.orderItemsPriceModifierViewModels?.forEach((f) {
        final _modiferAmt = OrderUtils.getAmount(
          taxTypeString:
              OrderUtils.getTaxTypeString(payPro.setMenuList[i].taxType),
          taxPercent: payPro.setMenuList[i].taxPercent.toString(),
          price: f.modifierPrice.toString(),
          quantity: f.quantity,
        );

        // f.quantity = _qty.toDouble();
        f.totalModifierPrice = _modiferAmt.totalPrice;
        f.totalTax = _modiferAmt.totalTax;
      });
    });

    if (payPro.onPayScreenFor == OnPayScreenFor.Refund) {
      payPro.updateRefundOrder(setMenuOrderDetail: payPro.setMenuList[i]);
    } else {
      if (payPro.setMenuList.any((f) => f.setMenuQuantity != f.initQty) &&
          payPro.paymentType != PaymentType.SplitByItem) {
        payPro.isItemUpdated = true; //TODO
      } else {
        if (payPro.setMenuList[i].orderItemsViewModels?.any((f) =>
                f.orderItemsPriceModifierViewModels?.isNotEmpty ?? false) ??
            false) {
          payPro.isItemUpdated = true;
        } else {
          payPro.isItemUpdated = false;
        }
      }
    }
    updateDiscount();
    payPro.notify;
  }

  _updateRawIngreQty(int i, {bool? p0}) {
    final double minQty =
        payPro.onPayScreenFor == OnPayScreenFor.Refund ? 0 : 1;

    double qty = payPro.ingreList[i].quantity ?? 0;
    if (p0 != null) {
      if (p0) {
        qty++;
        if (qty > payPro.ingreList[i].initQty)
          qty = payPro.ingreList[i].initQty;
      } else {
        if (qty < 1 + minQty) {
          qty = minQty;
          // return;
        } else {
          qty--;
        }
      }
    }

    qty = qty.roundToN(n: 3);

    final _amount = OrderUtils.getAmount(
      taxTypeString: OrderUtils.getTaxTypeString(payPro.ingreList[i].taxType),
      taxPercent: payPro.ingreList[i].taxPercent.toString(),
      price: payPro.ingreList[i].originalSellingPricePerUnit.toString(),
      quantity: qty.toDouble(),
      // actualPrice: payPro.ingreList[i].actualPrice,
      // discountPercent: payPro.ingreList[i].discountPercentage,
    );

    payPro.ingreList[i].quantity = qty;
    payPro.ingreList[i].totalSellingPrice =
        (qty * _amount.itemPrice).roundToNString();

    // payPro.ingreList[i].discountWithoutTax =
    //     _amount.discount.roundToNString();
    // payPro.ingreList[i].discountWithTax =
    //     _amount.discountWithTax.roundToNString();
    payPro.ingreList[i].totalTax = _amount.totalTax.roundToNString();

    if (payPro.onPayScreenFor == OnPayScreenFor.Refund) {
      payPro.updateRefundOrder(rawIngredientOrderDetail: payPro.ingreList[i]);
    } else {
      if (payPro.ingreList.any((f) => f.quantity != f.initQty) &&
          payPro.paymentType != PaymentType.SplitByItem) {
        payPro.isItemUpdated = true;
      } else {
        payPro.isItemUpdated = false;
      }
    }
    updateDiscount();
    payPro.notify;
  }

  Future<void> _cancelItem(int i, BuildContext context) async {
    final _itemId = payPro.orderList[i].id;
    if (_itemId != null &&
        _itemId.isNotEmpty &&
        payPro.orderId != null &&
        payPro.orderId!.isNotEmpty) {
      // payPro.orderList[i].isCancelled = true;
      payPro.orderList[i].statusId =
          OrderUtils.getStatusId(OrderStatusEnum.cancel);

      payPro
          .cancelPlaceOrderItem(
        type: ItemCancelType.order,
        itemIds: [_itemId],
        orderId: payPro.orderId!,
        setmenuId: [],
      )
          .then((value) async {
        if (value ?? false) {
          if (i >= 0 && i < payPro.orderList.length) {
            payPro.orderList.removeAt(i);
          }

          if (context.mounted) {
            payPro.notify;

            payPro.setUniSearchData();
            await payPro.cancelOrderIfNoItem(context);
            updateDiscount();
          }
        }
      });
    } else {
      if (i >= 0 && i < payPro.orderList.length) {
        payPro.orderList.removeAt(i);
      }
      if (context.mounted) {
        payPro.notify;

        payPro.setUniSearchData();
        updateDiscount();
      }
    }
  }

  List<String> _modiList({
    List<OrderItemsPriceModifierViewModel>? orderItemsPriceModifierViewModels,
    required double itemQty,
  }) {
    String _labelName = "";
    final _modifiers = <String>[];
    if (orderItemsPriceModifierViewModels != null)
      for (final m in orderItemsPriceModifierViewModels) {
        if (m.isActive && (m.modifierName?.isNotEmpty ?? false)) {
          String _modifierText = "";
          // deal_sec
          final _modiType = OrderUtils.getModifierType(m.type);
          final _hidePrice =
              ((m.isHalforCombo ?? false) && !(m.isDealModifier ?? false)) ||
                  _modiType == ModifierType.rawingre;

          // kPrint(
          //     "${m.modifierName} ${m.type} ${m.isHalforCombo} ${m.isDealModifier}");

          if (_labelName != m.labelName) {
            _labelName = m.labelName ?? '';
            _modifierText = "$_labelName\n";
          }
          final _qtyString = ((m.quantity ?? 0.0) / itemQty).formatDouble;
          final _totalString =
              ((m.totalModifierPrice ?? 0) / itemQty).formatDouble;

          _modifierText +=
              " ${_modiType == ModifierType.rawingre ? '-' : '+'} ${_hidePrice ? '' : '$_qtyString x '}${m.modifierName!}${_hidePrice ? '' : '(${payPro.curSym}$_totalString)${itemQty != 1 ? ' (each)' : ''}'}";
          _modifiers.add(_modifierText);

          if (_hidePrice && m.modifierItemsModifierViewModels != null) {
            _modifiers.addAll(_modiList(
              orderItemsPriceModifierViewModels:
                  m.modifierItemsModifierViewModels!,
              itemQty: itemQty,
            ));
          }
        }
      }

    return _modifiers;
  }

  Widget _updateOrderButton(BuildContext context) {
    if (payPro.orderDetailById == null
        // ||(payPro.paymentType == PaymentType.PartialPayment &&
        //         payPro.isSplitPerPerson)
        ) return SizedBox.shrink();
    // final size = Ssize(context);
    // return Container(
    //   width: size.getW(150),
    //   decoration: BoxDecoration(
    //       border: Border.all(color: Colors.red.withOpacity(0.2)),
    //       color: Colors.red.withOpacity(0.2),
    //       borderRadius: BorderRadius.circular(20)),
    //   child: InkWell(
    //     onTap: payPro.orderDetailById == null
    //         ? null
    //         : () async {
    //             final _status = await showCupertinoDialog(
    //                 context: CUS_CTX!,
    //                 builder: (_) => ConfirmDialog(
    //                       title: "Update Order",
    //                       titleSize: 18,
    //                       subTitle: "Are you sure you want to update order?",
    //                       actionText: LN.yes,
    //                       cancelText: LN.cancel,
    //                       onDelete: () async {
    //                         return true;
    //                       },
    //                     ));

    //             if (_status && payPro.orderDetailById != null) {
    //               payPro.isUpdatingOrder = true;

    //               final _order = OrderDetailById.fromJson(
    //                   payPro.orderDetailById!.toJson());
    //               GlobalCVP.setMainPage = MainPage.HomePage;
    //               GlobalCVP.setCurrentPage(
    //                 GlobalCVP.tabs
    //                     .indexWhere((element) => element.title == LN.pos),
    //               );
    //               GlobalCVP.notify;
    //               Future.delayed(Duration(milliseconds: 100));

    //               Navigator.pop(context);

    //               await PendingOrder.updateOrder(CUS_CTX!,
    //                   orderId: payPro.orderId, oDById: _order);
    //             }
    //           },
    //     borderRadius: BorderRadius.circular(20),
    //     child: Padding(
    //       padding: EdgeInsets.symmetric(
    //           horizontal: size.getW(8), vertical: size.getH(8)),
    //       child: Row(
    //         mainAxisAlignment: MainAxisAlignment.center,
    //         children: [
    //           Icon(
    //             Icons.edit,
    //             size: size.getS(18),
    //             color: Colors.red,
    //           ),
    //           SizedBox(width: size.getW(4)),
    //           Text(
    //             "Update Order",
    //             style: TextStyle(
    //               color: Colors.red.shade800,
    //               fontFamily: kFontFMedium,
    //               fontSize: size.getS(14),
    //             ),
    //           ),
    //         ],
    //       ),
    //     ),
    //   ),
    // );

    return LoadButton(
      vPad: 12,
      hPad: 4,
      width: double.infinity,
      shape: RoundedRectangleBorder(
        side: BorderSide(
          color: payPro.updateOrderLoad || payPro.loading || payPro.loadingPay
              ? Colors.grey.shade400
              : Colors.white,
        ),
        borderRadius: BorderRadius.circular(10),
      ),
      btnColor: payPro.updateOrderLoad || payPro.loading || payPro.loadingPay
          ? Colors.grey.shade400
          : Colors.amber.shade400,
      textColor: payPro.updateOrderLoad || payPro.loading || payPro.loadingPay
          ? Colors.white
          : Colors.black,
      btnText: "Update Order",
      fontSize: 16,
      onsave: payPro.updateOrderLoad || payPro.loading || payPro.loadingPay
          ? null
          : () async {
              final _status = await showCupertinoDialog(
                  context: CUS_CTX!,
                  builder: (_) => ConfirmDialog(
                        title: "Update Order",
                        titleSize: 18,
                        subTitle: "Are you sure you want to update order?",
                        actionText: LN.yes,
                        cancelText: LN.cancel,
                        onDelete: () async {
                          return true;
                        },
                      ));

              if (_status != null &&
                  _status &&
                  payPro.orderDetailById != null) {
                payPro.isUpdatingOrder = true;
                payPro.updateOrderLoad = true;
                payPro.notify;

                final _order = await payPro.getOrderDetailById(
                    orderId: payPro.orderId ?? '');
                // OrderDetailById.fromJson(payPro.orderDetailById!.toJson());

                payPro.updateOrderLoad = false;
                payPro.notify;

                GlobalCVP.setMainPage = MainPage.HomePage;
                GlobalCVP.setCurrentPage(
                  GlobalCVP.tabs
                      .indexWhere((element) => element.title == LN.pos),
                );
                GlobalCVP.notify;
                Future.delayed(Duration(milliseconds: 100));

                if (Navigator.maybeOf(context)?.canPop() ?? false) {
                  Navigator.pop(context);
                }

                await PendingOrder.updateOrder(CUS_CTX!,
                    orderId: payPro.orderId, oDById: _order);
              }
            },
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = Ssize(context);
    final _minQty = payPro.onPayScreenFor == OnPayScreenFor.Refund ? 0 : 1;
    final _hasPaidOnce = (payPro.orderDetailById?.orderDetailsViewModel
                ?.paymentType?.isNotEmpty ??
            false) &&
        payPro.onPayScreenFor == OnPayScreenFor.Payment;

    final delAMt = double.tryParse(payPro
                .orderDetailById
                ?.orderPaymentDetailsWithPaymentStatusViewModel
                ?.deliveryAmount ??
            '0') ??
        0;

    final _isDelivery = (payPro
                .orderDetailById?.orderDetailsViewModel?.orderType
                ?.toLowerCase()
                .contains('deliver') ??
            false) ||
        delAMt != 0;
    // final _amount = payPro.getAllAmount;

    // final _discountText = _amount.discount == 0
    //     ? ""
    //     : (_amount.taxType == TaxType.Inclusive
    //         ? _amount.discountWithTax.roundToNString()
    //         : _amount.discount.roundToNString());

    final _taxType =
        OrderUtils.getTaxType(GlobalCVP.storeInfo?.taxExclusiveInclusiveType);

    OrderDiscountModel? _generalDiscount;
    OrderDiscountModel? _voucherDiscount;

    if (payPro.discountList != null) {
      for (final a in payPro.discountList!) {
        if (a.discountType?.toLowerCase() ==
            DiscountType.General.name.toLowerCase()) {
          _generalDiscount = a;
        } else if (a.discountType?.toLowerCase() ==
            DiscountType.Voucher.name.toLowerCase()) {
          _voucherDiscount = a;
        }
      }
    }
    final _generalDiscountValue = _generalDiscount == null
        ? ""
        : _taxType == TaxType.Inclusive
            ? (_generalDiscount.discountAmountWithTax ?? "")
            : (_generalDiscount.discountAmount ?? "");

    final _voucherDiscountValue = _voucherDiscount == null
        ? ""
        : _taxType == TaxType.Inclusive
            ? (_voucherDiscount.discountAmountWithTax ?? "")
            : (_voucherDiscount.discountAmount ?? "");

    return Processing(
      loading: payPro.updateOrderLoad,
      child: Padding(
        padding: EdgeInsets.only(left: size.getW(0.0)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (isPrimary) ...[
              Row(
                children: [
                  Text(
                    "Order Summary",
                    style: TextStyle(
                      fontSize: size.getS(20),
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 1,
                  ),
                  SizedBox(
                    width: size.getW(12),
                  ),
                  // SizedBox(
                  //   height: size.getH(40),
                  //   child: RefreshBtn(
                  //     size: size,
                  //     icon: Icon(
                  //       Icons.refresh_outlined,
                  //       color: Colors.white,
                  //       size: size.getS(24),
                  //     ),
                  //     onTap: refresh,
                  //   ),
                  // ),
                  Spacer(),

                  // SizedBox(
                  //     height: size.getH(32), child: _updateOrderButton(context))
                ],
              ),
              Divider(
                color: Colors.black38,
                thickness: 1,
              ),
            ],
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (isPrimary) ...[
                    if (payPro.onPayScreenFor != OnPayScreenFor.Refund)
                      _disableSection(
                        readOnly: _hasPaidOnce,
                        child: Row(
                          children: List.generate(
                              payPro.PAY_TYPE_LIST.length,
                              (index) => Expanded(
                                    child: _isDelivery &&
                                            payPro.PAY_TYPE_LIST[index].id == 2
                                        ? SizedBox.shrink()
                                        : Card(
                                            color: payPro.paymentType ==
                                                    PaymentType.values[index]
                                                ? kSecondaryColor
                                                : Colors.white,
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(5),
                                                side: BorderSide(
                                                    width: 1.6,
                                                    color: kSecondaryColor)),
                                            margin: EdgeInsets.symmetric(
                                                vertical: size.getH(4),
                                                horizontal: size.getW(4)),
                                            child: InkWell(
                                              onTap: () {
                                                if (payPro.paymentType ==
                                                    PaymentType.values[index])
                                                  return;
                                                payPro.paymentType =
                                                    PaymentType.values[index];
                                                if (payPro.paymentType ==
                                                    PaymentType
                                                        .PartialPayment) {
                                                  payPro.isCheckCreCarCharge =
                                                      false;
                                                  payPro.isCheckPubHoCharge =
                                                      false;
                                                  payPro.isCheckServiceCharge =
                                                      false;
                                                }

                                                payPro.orderList.forEach((e) {
                                                  e.isSelected = payPro
                                                          .paymentType !=
                                                      PaymentType.SplitByItem;
                                                  e.quantity = e.initQty;
                                                  updateOrderDetail(
                                                      order: e, qty: e.initQty);
                                                });
                                                payPro.setMenuList.forEach((e) {
                                                  e.isSelected = payPro
                                                          .paymentType !=
                                                      PaymentType.SplitByItem;
                                                  e.setMenuQuantity = e.initQty;
                                                  e.totalSetMenuPrice =
                                                      (e.setMenuPrice ?? 0) *
                                                          e.initQty;
                                                });
                                                payPro.ingreList.forEach((e) {
                                                  e.isSelected = payPro
                                                          .paymentType !=
                                                      PaymentType.SplitByItem;
                                                  e.quantity = e.initQty;
                                                  e.totalSellingPrice =
                                                      ((e.originalSellingPricePerUnit ??
                                                                  0) *
                                                              e.initQty)
                                                          .roundToNString();
                                                });

                                                payPro.notify;
                                                payPro.onChangedPayAmount();
                                              },
                                              child: Padding(
                                                padding: EdgeInsets.symmetric(
                                                    vertical: size.getH(8.0),
                                                    horizontal: size.getW(2)),
                                                child: Text(
                                                  payPro.PAY_TYPE_LIST[index]
                                                      .title
                                                      .toUpperCase(),
                                                  style: TextStyle(
                                                    fontSize: size.getS(16),
                                                    color: payPro.paymentType ==
                                                            PaymentType
                                                                .values[index]
                                                        ? Colors.white
                                                        : kSecondaryColor,
                                                    fontFamily: kFontFMedium,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                  textAlign: TextAlign.center,
                                                  maxLines: 1,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                              ),
                                            ),
                                          ),
                                  )),
                        ),
                      )
                  ],
                  Expanded(
                    child: _disableSection(
                      readOnly: _isSplitPay,
                      child: Padding(
                        padding: EdgeInsets.only(left: size.getW(4)),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (isPrimary) ...[
                              if (!payPro.loading) ...[
                                if (payPro.paymentType ==
                                        PaymentType.SplitByItem &&
                                    payPro.isItemUpdated)
                                  _helperMessage(
                                    size,
                                    text:
                                        "You can change the quantity to update your order. However, if the item includes modifier items, you cannot reduce the quantity to make a payment.",
                                  )
                                else if (payPro.onPayScreenFor ==
                                    OnPayScreenFor.Refund)
                                  _helperMessage(
                                    size,
                                    text: LN.slelectItemNumRefund,
                                  )
                                else if ((payPro.remainingAmount ?? 0) == 0)
                                  _helperMessage(
                                    size,
                                    text: LN.updateBeforePay,
                                  )
                                else if (payPro
                                        .remainingOnGiftPay?.isNotEmpty ??
                                    false)
                                  _helperMessage(
                                    size,
                                    text: LN.completePrevPayToNextPay,
                                  )
                              ]
                            ],
                            _itemHeader(size,
                                isChecked: !payPro.orderList.any((e) =>
                                        e.initQty != e.paidQuantity &&
                                        !e.isSelected) &&
                                    !payPro.setMenuList.any((e) =>
                                        e.initQty != e.paidQuantity &&
                                        !e.isSelected) &&
                                    !payPro.ingreList.any((e) =>
                                        e.initQty != e.paidQuantity &&
                                        !e.isSelected),
                                onSelect: payPro.paymentType ==
                                        PaymentType.SplitByItem
                                    ? payPro.orderList.any((e) => e.disabled) ||
                                            payPro.setMenuList
                                                .any((e) => e.disabled) ||
                                            payPro.ingreList
                                                .any((e) => e.disabled)
                                        ? null
                                        : (val) {
                                            if (val == null) return;

                                            payPro.orderList.forEach(
                                                (e) => e.isSelected = val);
                                            payPro.setMenuList.forEach(
                                                (e) => e.isSelected = val);
                                            payPro.ingreList.forEach(
                                                (e) => e.isSelected = val);
                                            payPro.notify;
                                            payPro.onChangedPayAmount();
                                          }
                                    : null,
                                isPrimary: isPrimary),
                            SizedBox(
                              height: size.getH(4),
                            ),
                            Expanded(
                              child: Scrollbar(
                                controller: scrollCltr,
                                thumbVisibility: true,
                                trackVisibility: true,
                                thickness: 10,
                                radius: Radius.circular(40),
                                interactive: true,
                                child: Padding(
                                  padding:
                                      EdgeInsets.only(right: size.getW(18)),
                                  child: SingleChildScrollView(
                                    controller: scrollCltr,
                                    child: Column(
                                      children: [
                                        ...List.generate(
                                          payPro.setMenuList.length,
                                          (i) {
                                            if (payPro.setMenuList[i].initQty <=
                                                payPro.setMenuList[i]
                                                    .paidQuantity)
                                              return SizedBox.shrink();

                                            final mTotal = payPro.setMenuList[i]
                                                    .orderItemsViewModels
                                                    ?.fold<double>(
                                                        0,
                                                        (pV1, e1) =>
                                                            pV1 +
                                                            (e1.orderItemsPriceModifierViewModels?.fold<
                                                                        double>(
                                                                    0,
                                                                    (pV2, e2) =>
                                                                        pV2 +
                                                                        (e2.totalModifierPrice ??
                                                                            0)) ??
                                                                0)) ??
                                                0;
                                            final setMenuTotalPrice = ((payPro
                                                        .setMenuList[i]
                                                        .totalSetMenuPrice ??
                                                    0) +
                                                mTotal);

                                            final _disPercent = payPro
                                                    .setMenuList[i]
                                                    .discountPercentage
                                                    ?.inDouble ??
                                                0;
                                            return _disableSection(
                                              readOnly: payPro
                                                  .setMenuList[i].disabled,
                                              child: ItemInfo(
                                                size: size,
                                                isPriamry: isPrimary,
                                                isForRefund:
                                                    payPro.onPayScreenFor ==
                                                        OnPayScreenFor.Refund,
                                                imgPath: payPro
                                                    .setMenuList[i].imgPath,
                                                title: (payPro.setMenuList[i]
                                                            .setMenuName ??
                                                        '') +
                                                    (_disPercent == 0
                                                        ? ''
                                                        : ' (${_disPercent.formatDouble}% OFF)'),
                                                description: payPro
                                                    .setMenuList[i].description,
                                                quantity: payPro.setMenuList[i]
                                                    .setMenuQuantity
                                                    ?.toDouble(),
                                                initQty: (payPro.setMenuList[i]
                                                            .initQty -
                                                        (_isSplitPay
                                                            ? 0
                                                            : payPro
                                                                .setMenuList[i]
                                                                .paidQuantity))
                                                    .toDouble(),
                                                price: (payPro.curSym ?? '') +
                                                    (setMenuTotalPrice
                                                        .nonNan()
                                                        .roundToNString()),
                                                canQtyUp: (payPro.setMenuList[i]
                                                            .setMenuQuantity ??
                                                        1) <
                                                    (payPro.setMenuList[i]
                                                            .initQty -
                                                        (_isSplitPay
                                                            ? 0
                                                            : payPro
                                                                .setMenuList[i]
                                                                .paidQuantity)),
                                                canQtyDown: (payPro
                                                            .setMenuList[i]
                                                            .setMenuQuantity ??
                                                        1) >
                                                    _minQty,
                                                updateQuan: (p0) =>
                                                    _updateSetmenuQty(i,
                                                        p0: p0),
                                                trailing: isPrimary
                                                    ? _trailing(
                                                        size,
                                                        onTap: payPro
                                                                .updateOrderLoad
                                                            ? null
                                                            : () {
                                                                // if (!GlobalCVP
                                                                //     .viewWidget
                                                                //     .deleteOrderItem) {
                                                                //   return CustomDialog.showPermissionErrorDialog(
                                                                //       context:
                                                                //           context);
                                                                // }
                                                                //     if (payPro.onPayScreenFor ==
                                                                //         OnPayScreenFor.Refund) {
                                                                //       showDialog(
                                                                //           context: context,
                                                                //           builder: (builder) => ConfirmDialog(
                                                                //                 title:
                                                                //                     "${LN.refundOrder} '${payPro.setMenuList[i].setMenuName ?? ''}'?",
                                                                //                 titleSize: 18,
                                                                //                 subTitle: LN.sureRefund,
                                                                //                 actionText: LN.yes,
                                                                //                 cancelText: LN.no,
                                                                //                 onDelete: () {
                                                                //                   payPro.updateRefundOrder(
                                                                //                     setMenuOrderDetail:
                                                                //                         payPro.setMenuList[i],
                                                                //                     isFullRefunded: true,
                                                                //                   );
                                                                //                   payPro.setMenuList
                                                                //                       .removeAt(i);
                                                                //                   updateDiscount();
                                                                //                   payPro.notify;
                                                                //                 },
                                                                //               ));
                                                                // } else

                                                                showDialog(
                                                                    context:
                                                                        context,
                                                                    builder:
                                                                        (builder) =>
                                                                            ConfirmDialog(
                                                                              title: "${LN.cancel} '${payPro.setMenuList[i].setMenuName ?? ''}' ?",
                                                                              titleSize: 18,
                                                                              subTitle: "Are you sure to cancel ${payPro.setMenuList[i].setMenuName ?? ''} ?",
                                                                              actionText: LN.cancel,
                                                                              cancelText: LN.no,
                                                                              onDelete: () async {
                                                                                final _itemId = payPro.setMenuList[i].id;
                                                                                if (_itemId != null && _itemId.isNotEmpty && payPro.orderId != null && payPro.orderId!.isNotEmpty) {
                                                                                  payPro.setMenuList[i].statusId = OrderUtils.getStatusId(OrderStatusEnum.cancel);
                                                                                  // payPro.setMenuList[i].isCancelled = true;
                                                                                  payPro
                                                                                      .cancelPlaceOrderItem(
                                                                                    type: ItemCancelType.setmenu,
                                                                                    itemIds: [],
                                                                                    orderId: payPro.orderId!,
                                                                                    setmenuId: [
                                                                                      _itemId
                                                                                    ],
                                                                                  )
                                                                                      .then((value) {
                                                                                    if (value ?? false) {
                                                                                      payPro.setMenuList.removeAt(i);
                                                                                      payPro.notify;
                                                                                      payPro.setUniSearchData();
                                                                                      payPro.cancelOrderIfNoItem(context);
                                                                                      updateDiscount();
                                                                                    }
                                                                                  });
                                                                                } else {
                                                                                  payPro.setMenuList.removeAt(i);
                                                                                  payPro.notify;
                                                                                  payPro.setUniSearchData();
                                                                                  updateDiscount();
                                                                                }
                                                                                return null;
                                                                              },
                                                                            ));
                                                              },
                                                      )
                                                    : null,
                                                isSelected: payPro
                                                    .setMenuList[i].isSelected,
                                                onSelect: payPro.paymentType ==
                                                        PaymentType.SplitByItem
                                                    ? (val) {
                                                        if (val == null) return;

                                                        payPro.setMenuList[i]
                                                            .isSelected = val;
                                                        payPro.notify;
                                                        updateDiscount();
                                                      }
                                                    : null,
                                                updateOrder: (payPro.remainingAmount ??
                                                                0) ==
                                                            0 &&
                                                        payPro.setMenuList[i]
                                                                .initQty !=
                                                            payPro
                                                                .setMenuList[i]
                                                                .setMenuQuantity && //payPro.isItemUpdated &&
                                                        payPro.onPayScreenFor ==
                                                            OnPayScreenFor
                                                                .Payment
                                                    ? () {
                                                        _updateOrderQty(
                                                            context);
                                                      }
                                                    : null,
                                                comboItem: payPro.setMenuList[i]
                                                    .orderItemsViewModels
                                                    ?.map((e) {
                                                  List<String>? modifiers;

                                                  // modifiers

                                                  if (e.orderItemsPriceModifierViewModels !=
                                                      null) {
                                                    modifiers = [];

                                                    String labelName = "";

                                                    for (final m in e
                                                        .orderItemsPriceModifierViewModels!) {
                                                      if (m.isActive &&
                                                          (m.modifierName
                                                                  ?.isNotEmpty ??
                                                              false)) {
                                                        String modifierText =
                                                            "";

                                                        if (labelName !=
                                                            m.labelName) {
                                                          labelName =
                                                              m.labelName ?? '';
                                                          modifierText =
                                                              "$labelName\n";
                                                        }

                                                        modifierText +=
                                                            " + ${m.quantity.formatDouble} x ${m.modifierName!} (${payPro.curSym}${(payPro.onPayScreenFor == OnPayScreenFor.Refund ? ((m.modifierPrice ?? 0) * payPro.setMenuList[i].initQty) : m.totalModifierPrice)?.roundToNString()})";

                                                        modifiers
                                                            .add(modifierText);
                                                      }
                                                    }
                                                  }

                                                  // ingredents

                                                  List<String>? ingredients;

                                                  if (e.removedOrderItemsIngredientsViewModels !=
                                                      null) {
                                                    ingredients = [];
                                                    for (final p in e
                                                        .removedOrderItemsIngredientsViewModels!) {
                                                      if (p.isActive) {
                                                        ingredients
                                                            .add(p.name ?? '');
                                                      }
                                                    }
                                                  }
                                                  return ComboItem(
                                                    title: e.name ?? '',
                                                    modifier: modifiers,
                                                    ingredients: ingredients,
                                                    quantity: e.quantity,
                                                  );
                                                }).toList(),
                                              ),
                                            );
                                          },
                                        ),
                                        ...List.generate(
                                          payPro.orderList.length,
                                          (i) {
                                            if (payPro.orderList[i].initQty <=
                                                payPro
                                                    .orderList[i].paidQuantity)
                                              return SizedBox.shrink();

                                            final _prodType =
                                                OrderUtils.prodType(payPro
                                                    .orderList[i].productType);

                                            List<String>? _rootModifiers;

                                            // modifiers

                                            if (payPro.orderList[i]
                                                    .orderItemModifiersViewModels !=
                                                null) {
                                              _rootModifiers = [];

                                              _rootModifiers.addAll(_modiList(
                                                  orderItemsPriceModifierViewModels:
                                                      payPro.orderList[i]
                                                          .orderItemModifiersViewModels
                                                          ?.whereModiType2(
                                                              ModifierType
                                                                  .modifier),
                                                  itemQty: payPro
                                                      .orderList[i].initQty));
                                            }

                                            final _modifierPrice =
                                                OrderUtils.allMTotal(
                                              modiList: payPro.orderList[i]
                                                  .orderItemModifiersViewModels
                                                  ?.whereModiType2(
                                                      ModifierType.modifier),
                                              itemQty: payPro
                                                      .orderList[i].quantity ??
                                                  1,
                                              initQty:
                                                  payPro.orderList[i].initQty,
                                            );

                                            // final _modifierTotalPrice = payPro
                                            //     .orderList[i]
                                            //     .orderItemModifiersViewModels
                                            //     ?.fold<double>(
                                            //         0,
                                            //         (previousValue, element) =>
                                            //             previousValue +
                                            //             (element.totalModifierPrice ??
                                            //                 0));
                                            final _itemTotalPrice =
                                                ((payPro.orderList[i].total ??
                                                        0) +
                                                    _modifierPrice.total);

                                            // ingredents

                                            List<String>? _ingredients;
                                            final _ingre = payPro.orderList[i]
                                                .orderItemModifiersViewModels
                                                ?.whereModiType2(
                                                    ModifierType.rawingre);

                                            if (_ingre != null) {
                                              _ingredients = [];
                                              for (final p in _ingre) {
                                                if (p.isActive) {
                                                  _ingredients.add(
                                                      p.modifierName ?? '');
                                                }
                                              }
                                            }

                                            final _spiceList = payPro
                                                .orderList[i]
                                                .orderItemModifiersViewModels
                                                ?.whereModiType2(
                                                    ModifierType.spice);

                                            final _disPercent = payPro
                                                    .orderList[i]
                                                    .discountPercentage
                                                    ?.inDouble ??
                                                0;

                                            // final _kitStatus =
                                            //     OrderUtils.getItemStatusEnum(
                                            //         payPro.orderList[i]
                                            //             .kitchenStatus);
                                            // final _canUpdate = _kitStatus !=
                                            //         ItemStatusEnum.preparing &&
                                            //     _kitStatus !=
                                            //         ItemStatusEnum.prepared;

                                            ///

                                            // String _labelName = "";

                                            // print(
                                            //     """${(payPro.orderList[i].quantity ?? 1)} < (${payPro.orderList[i].initQty} - ($_isSplitPay? 0: ${payPro.orderList[i].paidQuantity}))}""");
                                            return _disableSection(
                                              readOnly:
                                                  payPro.orderList[i].disabled,
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Row(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Expanded(
                                                        child: Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            ItemInfo(
                                                              size: size,
                                                              isPriamry:
                                                                  isPrimary,
                                                              status: // _canUpdate ? null:
                                                                  payPro
                                                                      .orderList[
                                                                          i]
                                                                      .kitchenStatus,

                                                              isForRefund: payPro
                                                                      .onPayScreenFor ==
                                                                  OnPayScreenFor
                                                                      .Refund,

                                                              imgPath: payPro
                                                                  .orderList[i]
                                                                  .imgPath,
                                                              title: (payPro
                                                                          .orderList[
                                                                              i]
                                                                          .productName ??
                                                                      '') +
                                                                  (payPro.orderList[i].productVariationName !=
                                                                              null &&
                                                                          payPro
                                                                              .orderList[
                                                                                  i]
                                                                              .productVariationName!
                                                                              .isNotEmpty
                                                                      ? "-${payPro.orderList[i].productVariationName ?? ''}"
                                                                      : "") +
                                                                  ((_spiceList?.any((a) => a
                                                                              .isActive) ??
                                                                          false)
                                                                      ? "\n- ${_spiceList?.firstWhere((a) => a.isActive).modifierName ?? ''}"
                                                                      : "") +
                                                                  (_disPercent ==
                                                                          0
                                                                      ? ''
                                                                      : ' (${_disPercent.formatDouble}% OFF)'),
                                                              modifier: !(_prodType ==
                                                                      ProductType
                                                                          .Item)
                                                                  ? null
                                                                  : _rootModifiers,
                                                              comboItem: !(_prodType ==
                                                                      ProductType
                                                                          .Item)
                                                                  ? payPro
                                                                      .orderList[
                                                                          i]
                                                                      .orderItemModifiersViewModels
                                                                      ?.where((q) =>
                                                                          q.isActive)
                                                                      .toList()
                                                                      .map((m) {
                                                                      final _deepSpiceList = m
                                                                          .modifierItemsModifierViewModels
                                                                          ?.whereModiType2(
                                                                              ModifierType.spice);

                                                                      final _deepSpice = ((_deepSpiceList?.any((a) => a.isActive) ??
                                                                              false)
                                                                          ? "\n- ${_deepSpiceList?.firstWhere((a) => a.isActive).modifierName ?? ''}"
                                                                          : "");

                                                                      final _modifiers =
                                                                          <String>[];
                                                                      final _qtyString =
                                                                          ((m.quantity ?? 0.0) / payPro.orderList[i].initQty)
                                                                              .formatDouble;
                                                                      _modifiers
                                                                          .add(
                                                                              " + $_qtyString X ${m.modifierName ?? ''}${payPro.orderList[i].initQty != 1 ? ' (each)' : ''}$_deepSpice");

                                                                      _modifiers
                                                                          .addAll(
                                                                              _modiList(
                                                                        orderItemsPriceModifierViewModels: m
                                                                            .modifierItemsModifierViewModels
                                                                            ?.whereModiType2(ModifierType.modifier),
                                                                        itemQty: payPro
                                                                            .orderList[i]
                                                                            .initQty,
                                                                      ));

                                                                      // ingredents

                                                                      List<String>?
                                                                          _deepIngredients;

                                                                      final _deepIngre = m
                                                                          .modifierItemsModifierViewModels
                                                                          ?.whereModiType2(
                                                                              ModifierType.rawingre);

                                                                      if (_deepIngre !=
                                                                          null) {
                                                                        _deepIngredients =
                                                                            [];
                                                                        for (final q
                                                                            in _deepIngre) {
                                                                          if (q
                                                                              .isActive) {
                                                                            _deepIngredients.add(q.modifierName ??
                                                                                '');
                                                                          }
                                                                        }
                                                                      }

                                                                      return ComboItem(
                                                                        title: _prodType ==
                                                                                ProductType.Half
                                                                            ? m.labelName
                                                                            : null,
                                                                        modifier:
                                                                            _modifiers,
                                                                        ingredients:
                                                                            _deepIngredients,
                                                                        quantity:
                                                                            null,
                                                                        rootName: _prodType ==
                                                                                ProductType.Half
                                                                            ? null
                                                                            : _prodType == ProductType.Combo
                                                                                ? m.labelName
                                                                                : LN.modifiers,
                                                                      );
                                                                    }).toList()
                                                                  : null,
                                                              // modifier: payPro
                                                              //                 .orderList[
                                                              //                     i]
                                                              //                 .orderItemModifiersViewModels ==
                                                              //             null ||
                                                              //         payPro
                                                              //             .orderList[
                                                              //                 i]
                                                              //             .orderItemModifiersViewModels!
                                                              //             .isEmpty
                                                              //     ? null
                                                              //     : payPro
                                                              //         .orderList[
                                                              //             i]
                                                              //         .orderItemModifiersViewModels!
                                                              //         .map((e) {
                                                              //         String
                                                              //             _modifierText =
                                                              //             "";
                                                              //         if (_prodType !=
                                                              //                 ProductType
                                                              //                     .Combo &&
                                                              //             _labelName !=
                                                              //                 e.labelName) {
                                                              //           _labelName =
                                                              //               e.labelName ??
                                                              //                   '';
                                                              //           _modifierText =
                                                              //               "$_labelName\n";
                                                              //         }

                                                              //         if (e.modifierName
                                                              //                 ?.isNotEmpty ??
                                                              //             false) {
                                                              //           final _hideModiPrice = (e.quantity ?? 0) ==
                                                              //                   1 &&
                                                              //               (e.totalModifierPrice ?? 0) ==
                                                              //                   0;
                                                              //           _modifierText +=
                                                              //               " + ${_hideModiPrice ? '' : '${e.quantity.formatDouble} x '}${e.modifierName}${_hideModiPrice ? '' : ' (${payPro.curSym}${((payPro.onPayScreenFor == OnPayScreenFor.Refund ? ((e.modifierPrice ?? 0) * payPro.orderList[i].initQty) : e.totalModifierPrice)?.roundToNString())})'}";
                                                              //         }

                                                              //         return _modifierText;
                                                              //       }).toList(),
                                                              ingredients:
                                                                  _ingredients,
                                                              // vName: payPro.orderList[i].variationName,
                                                              description: payPro
                                                                  .orderList[i]
                                                                  .description,
                                                              quantity: payPro
                                                                  .orderList[i]
                                                                  .quantity,
                                                              initQty: payPro
                                                                      .orderList[
                                                                          i]
                                                                      .initQty -
                                                                  (_isSplitPay
                                                                      ? 0
                                                                      : payPro
                                                                          .orderList[
                                                                              i]
                                                                          .paidQuantity),
                                                              canQtyUp: //_canUpdate &&
                                                                  (payPro.orderList[i].quantity ??
                                                                          1) <
                                                                      (payPro.orderList[i].initQty -
                                                                          (_isSplitPay
                                                                              ? 0
                                                                              : payPro.orderList[i].paidQuantity)),
                                                              canQtyDown: // _canUpdate &&
                                                                  (payPro.orderList[i]
                                                                              .quantity ??
                                                                          1) >
                                                                      _minQty,
                                                              updateQuan: (p0) {
                                                                double _qty = payPro
                                                                        .orderList[
                                                                            i]
                                                                        .quantity ??
                                                                    1;
                                                                if (p0) {
                                                                  _qty++;
                                                                } else {
                                                                  if (_qty <
                                                                      1 + _minQty)
                                                                    return;
                                                                  _qty--;
                                                                }

                                                                updateOrderDetail(
                                                                    order: payPro
                                                                        .orderList[i],
                                                                    qty: _qty);

                                                                if (payPro
                                                                        .onPayScreenFor ==
                                                                    OnPayScreenFor
                                                                        .Refund) {
                                                                  payPro
                                                                      .updateRefundOrder(
                                                                    orderDetail:
                                                                        payPro.orderList[
                                                                            i],
                                                                  );
                                                                } else {
                                                                  if (payPro.orderList.any((f) =>
                                                                          f.quantity !=
                                                                          f
                                                                              .initQty) &&
                                                                      payPro.paymentType !=
                                                                          PaymentType
                                                                              .SplitByItem) {
                                                                    payPro.isItemUpdated =
                                                                        true; //TODO
                                                                  } else {
                                                                    payPro.isItemUpdated =
                                                                        false;

                                                                    // if (payPro.orderList.any((z) =>
                                                                    //     (z.orderItemModifiersViewModels
                                                                    //             ?.isNotEmpty ??
                                                                    //         false) &&
                                                                    //     z.initQty !=
                                                                    //         z.quantity &&
                                                                    //     z.isSelected)) {
                                                                    //   payPro.isItemUpdated =
                                                                    //       true;
                                                                    // } else {
                                                                    //   payPro.isItemUpdated =
                                                                    //       false;
                                                                    // }
                                                                    // if ((payPro
                                                                    //             .orderList[
                                                                    //                 i]
                                                                    //             .orderItemModifiersViewModels
                                                                    //             ?.isNotEmpty ??
                                                                    //         false) &&
                                                                    //     payPro.orderList[i].initQty !=
                                                                    //         payPro
                                                                    //             .orderList[i]
                                                                    //             .quantity) {
                                                                    //   payPro.isItemUpdated =
                                                                    //       true;
                                                                    // } else {
                                                                    //   payPro.isItemUpdated =
                                                                    //       false;
                                                                    // }
                                                                  }
                                                                }
                                                                updateDiscount();
                                                                payPro.notify;
                                                              },
                                                              trailing:
                                                                  // _canUpdate &&
                                                                  isPrimary
                                                                      ? _trailing(
                                                                          size,
                                                                          onTap: payPro.updateOrderLoad
                                                                              ? null
                                                                              : () {
                                                                                  // if (!GlobalCVP.viewWidget.deleteOrderItem) {
                                                                                  //   return CustomDialog.showPermissionErrorDialog(
                                                                                  //     context: context,
                                                                                  //   );
                                                                                  // }

                                                                                  showDialog(
                                                                                      context: context,
                                                                                      builder: (builder) => ConfirmDialog(
                                                                                            title: "${LN.cancel} '${payPro.orderList[i].productName ?? ''}' ?",
                                                                                            titleSize: 18,
                                                                                            subTitle: "${LN.areYouSureCancel} ${payPro.orderList[i].productName ?? ''} ?",
                                                                                            actionText: LN.cancel,
                                                                                            cancelText: LN.no,
                                                                                            onDelete: () async {
                                                                                              await _cancelItem(i, context);
                                                                                              return null;
                                                                                            },
                                                                                          ));
                                                                                },
                                                                        )
                                                                      : null,
                                                              price: (payPro
                                                                          .curSym ??
                                                                      '') +
                                                                  _itemTotalPrice
                                                                      .nonNan()
                                                                      .toStringAsFixed(
                                                                          2),
                                                              isSelected: payPro
                                                                  .orderList[i]
                                                                  .isSelected,
                                                              onSelect: payPro
                                                                          .paymentType ==
                                                                      PaymentType
                                                                          .SplitByItem
                                                                  ? (val) {
                                                                      if (val ==
                                                                          null)
                                                                        return;

                                                                      payPro
                                                                          .orderList[
                                                                              i]
                                                                          .isSelected = val;

                                                                      // if (payPro.paymentType ==
                                                                      //         PaymentType
                                                                      //             .SplitByItem &&
                                                                      //     payPro.orderList.any((z) =>
                                                                      //         (z.orderItemModifiersViewModels?.isNotEmpty ??
                                                                      //             false) &&
                                                                      //         z.initQty !=
                                                                      //             z.quantity &&
                                                                      //         z.isSelected)) {
                                                                      //   payPro.isItemUpdated =
                                                                      //       true;
                                                                      // } else {
                                                                      //   payPro.isItemUpdated =
                                                                      //       false;
                                                                      // }
                                                                      payPro
                                                                          .notify;
                                                                      updateDiscount();
                                                                    }
                                                                  : null,
                                                              updateOrder: (payPro.remainingAmount ??
                                                                              0) ==
                                                                          0 &&
                                                                      payPro.orderList[i].initQty !=
                                                                          payPro
                                                                              .orderList[
                                                                                  i]
                                                                              .quantity && //payPro.isItemUpdated &&
                                                                      payPro.onPayScreenFor ==
                                                                          OnPayScreenFor
                                                                              .Payment
                                                                  ? () {
                                                                      _updateOrderQty(
                                                                          context);
                                                                    }
                                                                  : null,
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            );
                                          },
                                        ),
                                        // ingredients
                                        ...List.generate(
                                          payPro.ingreList.length,
                                          (i) {
                                            if (payPro.ingreList[i].initQty <=
                                                payPro
                                                    .ingreList[i].paidQuantity)
                                              return SizedBox.shrink();

                                            final String totalPrice = (payPro
                                                    .ingreList[i]
                                                    .totalSellingPrice ??
                                                '');

                                            final _disPercent = payPro
                                                    .ingreList[i]
                                                    .discountPercentage
                                                    ?.inDouble ??
                                                0;

                                            return _disableSection(
                                              readOnly:
                                                  payPro.ingreList[i].disabled,
                                              child: ItemInfo(
                                                size: size,
                                                isPriamry: isPrimary,
                                                isForRefund:
                                                    payPro.onPayScreenFor ==
                                                        OnPayScreenFor.Refund,
                                                imgPath: "",
                                                title: (payPro.ingreList[i]
                                                            .name ??
                                                        '') +
                                                    (_disPercent == 0
                                                        ? ''
                                                        : ' (${_disPercent.formatDouble}% OFF)'),
                                                // description: payPro
                                                //     .ingreList[i].description,
                                                quantity: payPro
                                                    .ingreList[i].quantity
                                                    ?.toDouble(),
                                                initQty: (payPro.ingreList[i]
                                                            .initQty -
                                                        (_isSplitPay
                                                            ? 0
                                                            : payPro
                                                                .ingreList[i]
                                                                .paidQuantity))
                                                    .toDouble(),
                                                price: (payPro.curSym ?? '') +
                                                    totalPrice,
                                                canQtyUp: (payPro.ingreList[i]
                                                            .quantity ??
                                                        1) <
                                                    (payPro.ingreList[i]
                                                            .initQty -
                                                        (_isSplitPay
                                                            ? 0
                                                            : payPro
                                                                .ingreList[i]
                                                                .paidQuantity)),
                                                canQtyDown: (payPro.ingreList[i]
                                                            .quantity ??
                                                        1) >
                                                    _minQty,
                                                updateQuan: (p0) =>
                                                    _updateRawIngreQty(i,
                                                        p0: p0),
                                                trailing: isPrimary
                                                    ? _trailing(
                                                        size,
                                                        onTap: payPro
                                                                .updateOrderLoad
                                                            ? null
                                                            : () {
                                                                // if (!GlobalCVP
                                                                //     .viewWidget
                                                                //     .deleteOrderItem) {
                                                                //   return CustomDialog
                                                                //       .showPermissionErrorDialog(
                                                                //     context:
                                                                //         context,
                                                                //   );
                                                                // }

                                                                showDialog(
                                                                    context:
                                                                        context,
                                                                    builder:
                                                                        (builder) =>
                                                                            ConfirmDialog(
                                                                              title: "${LN.cancel} '${payPro.ingreList[i].name ?? ''}' ?",
                                                                              titleSize: 18,
                                                                              subTitle: "${LN.areYouSureCancel} ${payPro.ingreList[i].name ?? ''} ?",
                                                                              actionText: LN.cancel,
                                                                              cancelText: LN.no,
                                                                              onDelete: () async {
                                                                                final _itemId = payPro.ingreList[i].id;
                                                                                if (_itemId != null && _itemId.isNotEmpty && payPro.orderId != null && payPro.orderId!.isNotEmpty) {
                                                                                  payPro.ingreList[i].statusId = OrderUtils.getStatusId(OrderStatusEnum.cancel);
                                                                                  // payPro.ingreList[i].isCancelled = true;
                                                                                  payPro
                                                                                      .cancelPlaceOrderItem(
                                                                                    type: ItemCancelType.rawingre,
                                                                                    itemIds: [
                                                                                      _itemId
                                                                                    ],
                                                                                    orderId: payPro.orderId!,
                                                                                    setmenuId: [],
                                                                                  )
                                                                                      .then((value) {
                                                                                    if (value ?? false) {
                                                                                      payPro.ingreList.removeAt(i);
                                                                                      payPro.notify;
                                                                                      payPro.setUniSearchData();
                                                                                      payPro.cancelOrderIfNoItem(context);
                                                                                      updateDiscount();
                                                                                    }
                                                                                  });
                                                                                } else {
                                                                                  payPro.ingreList.removeAt(i);
                                                                                  payPro.notify;
                                                                                  payPro.setUniSearchData();
                                                                                  updateDiscount();
                                                                                }
                                                                                return null;
                                                                              },
                                                                            ));
                                                              },
                                                      )
                                                    : null,
                                                isSelected: payPro
                                                    .ingreList[i].isSelected,
                                                onSelect: payPro.paymentType ==
                                                        PaymentType.SplitByItem
                                                    ? (val) {
                                                        if (val == null) return;

                                                        payPro.ingreList[i]
                                                            .isSelected = val;
                                                        payPro.notify;
                                                        updateDiscount();
                                                      }
                                                    : null,
                                                updateOrder: (payPro.remainingAmount ??
                                                                0) ==
                                                            0 &&
                                                        payPro.ingreList[i]
                                                                .initQty !=
                                                            payPro.ingreList[i]
                                                                .quantity && //payPro.isItemUpdated &&
                                                        payPro.onPayScreenFor ==
                                                            OnPayScreenFor
                                                                .Payment
                                                    ? () {
                                                        _updateOrderQty(
                                                            context);
                                                      }
                                                    : null,
                                              ),
                                            );
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            if (payPro.onPayScreenFor == OnPayScreenFor.Payment &&
                Navigator.canPop(context))
              _updateOrderButton(context),
            Divider(color: Colors.black38, thickness: 1),
            // if (!payPro.isItemUpdated ||
            //     payPro.onPayScreenFor == OnPayScreenFor.Refund)
            ...[
              if (isPrimary && PromoUtils.promoOnTotalOrder != null)
                Row(
                  children: [
                    Container(
                      margin: EdgeInsets.only(left: size.getW(8)),
                      padding: EdgeInsets.symmetric(
                          horizontal: size.getW(12), vertical: size.getH(8)),
                      decoration: BoxDecoration(
                          color: Colors.green,
                          borderRadius: BorderRadius.circular(10)),
                      child: Text(
                        "● Promotion applied",
                        style: TextStyle(
                          fontSize: size.getS(14),
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          height: 1.1,
                        ),
                      ),
                    ),
                    Spacer(),
                    Container(
                      decoration: BoxDecoration(
                          // color: kSecondaryColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(20)),
                      padding: EdgeInsets.symmetric(
                          horizontal: size.getW(12), vertical: size.getH(8)),
                      child: Text(
                        'You saved total ${payPro.curSym}${PromoUtils.promoOnTotalOrder?.discountAmount} on this order',
                        style: TextStyle(
                          fontSize: size.getS(14),
                          fontWeight: FontWeight.bold,
                          color: kSecondaryColor,
                          height: 1.1,
                        ),
                      ),
                    ),
                  ],
                ),
              if (isPrimary &&
                  (_voucherDiscountValue.isNotEmpty &&
                      _voucherDiscountValue.inDouble != 0))
                Padding(
                  padding:
                      EdgeInsets.only(top: size.getH(8), left: size.getW(10)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              "Voucher Discount",
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: size.getS(16),
                                fontFamily: kFontFMedium,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(width: size.getW(8)),
                      Text(
                        (payPro.curSym ?? '') + _voucherDiscountValue,
                        style: TextStyle(
                          fontSize: size.getS(16),
                          color: Colors.black,
                          fontFamily: kFontFMedium,
                        ),
                      ),
                    ],
                  ),
                ),
              if (isPrimary &&
                  (_generalDiscountValue.isEmpty ||
                      _generalDiscountValue.inDouble == 0))
                TextButton(
                  onPressed: () async {
                    showDiscountDialog(
                      size: size,
                      context: context,
                    );
                  },
                  child: Text(
                    "Add Discount",
                    style: TextStyle(
                      color: kSecondaryColor,
                      fontSize: size.getS(16),
                      fontFamily: kFontFMedium,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                )
              else
                InkWell(
                  onTap: isPrimary
                      ? () async {
                          showDiscountDialog(
                            size: size,
                            context: context,
                          );
                        }
                      : null,
                  child: Padding(
                    padding:
                        EdgeInsets.only(top: size.getH(8), left: size.getW(10)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                LN.discount,
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: size.getS(16),
                                  fontFamily: kFontFMedium,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(width: size.getW(4)),
                              Flexible(
                                child: Text(
                                  "(${payPro.paySecListRes?.discounts?.firstWhere(
                                        (discount) =>
                                            discount.isSelected ?? false,
                                        orElse: () => TableLocation(),
                                      ).name ?? '${payPro.discountPercentCltr.text.inDouble.formatDouble}%'})",
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontSize: size.getS(15),
                                    fontFamily: kFontFRegular,
                                    fontWeight: FontWeight.normal,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        if (isPrimary)
                          Icon(
                            Icons.edit,
                            size: size.getS(24),
                            color: kSecondaryColor,
                          ),
                        SizedBox(width: size.getW(8)),
                        Text(
                          '-${payPro.curSym ?? ''}${_generalDiscountValue.isEmpty ? '0.00' : _generalDiscountValue}',
                          style: TextStyle(
                            fontSize: size.getS(16),
                            color: Colors.black,
                            fontFamily: kFontFMedium,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              if (isPrimary && payPro.isOrderTypeDelivery)
                _disableSection(
                    readOnly: _hasPaidOnce ||
                        (payPro.onPayScreenFor == OnPayScreenFor.Refund &&
                            payPro.refundDeliveryDisable),
                    child: Padding(
                      padding: EdgeInsets.only(
                          bottom: size.getH(4),
                          top: size.getH(4),
                          left: size.getW(10)),
                      child: Row(
                        children: [
                          if (payPro.onPayScreenFor ==
                              OnPayScreenFor.Refund) ...[
                            // _cusCheckBox(
                            //   size,
                            //   isCheck: payPro.isDeliveryCheck,
                            //   onTap: () {
                            //     payPro.isDeliveryCheck =
                            //         !payPro.isDeliveryCheck;
                            //     payPro.onChangedPayAmount(
                            //         isUpdatePaidAmount: false);
                            //   },
                            // ),
                            // SizedBox(width: size.getW(8)),
                            Checkbox(
                                // fillColor: MaterialStateProperty.all(
                                //     kSecondaryColor),
                                value: payPro.isDeliveryCheck,
                                onChanged: (bool? val) {
                                  if (val == null) return;
                                  payPro.isDeliveryCheck = val;
                                  payPro.onChangedPayAmount(
                                      isUpdatePaidAmount: false);
                                }),
                          ],
                          Text(
                            LN.deliAmt,
                            style: TextStyle(
                              fontSize: size.getS(16),
                              color: Colors.black,
                            ),
                          ),
                          Spacer(),
                          SizedBox(
                            width: size.getW(100),
                            child: TextFormWidget(
                              borderRadius: 5,
                              vPad: 6,
                              borderColor: Colors.black12,
                              isReq: false,
                              initValidate: true,
                              fillColor: kBackgroundColor,
                              cltr: payPro.deliveryTextCltr,
                              hintText: "0",
                              textInputType: TextInputType.number,
                              onChanged: (_) => payPro.onChangedPayAmount(
                                isUpdatePaidAmount: payPro.paymentType !=
                                    PaymentType.PartialPayment,
                                hasDiscountOnPartial: payPro.paymentType ==
                                    PaymentType.PartialPayment,
                              ),
                              textAlign: TextAlign.right,
                              inputFormatters: [
                                NonNegativeTextInputFormatter()
                              ],
                              prefix: Text(
                                "${payPro.curSym ?? ''} ",
                                style: TextStyle(
                                  fontSize: size.getS(16),
                                  color: Colors.black,
                                  fontFamily: kFontFMedium,
                                ),
                              ),
                              validator: (p0) {
                                if (p0 == null || p0.isEmpty) return null;
                                final _data = double.tryParse(p0);
                                if (_data == null || _data > 100) {
                                  showToast(LN.invalidDisChar);
                                  return '';
                                }
                                // if (payPro.getAllAmount.totalPrice < 0) {
                                //   showToast(LN.discountHigher);
                                //   return '';
                                // }
                                return null;
                              },
                              errH: 0,
                            ),
                          ),
                        ],
                      ),
                    )),
              if (isPrimary &&
                  (GlobalCVP.storeInfo?.holidaySurcharge?.isActive ??
                      false)) ...[
                _disableSection(
                  readOnly: _hasPaidOnce,
                  child: Padding(
                    padding: EdgeInsets.only(top: size.getH(4)),
                    child: Row(
                      children: [
                        // _cusCheckBox(
                        //   size,
                        //   isCheck: payPro.isCheckPubHoCharge,
                        //   onTap: () {
                        //     payPro.isCheckPubHoCharge =
                        //         !payPro.isCheckPubHoCharge;
                        //     payPro.onChangedPayAmount(isUpdatePaidAmount: false);
                        //   },
                        // ),
                        // SizedBox(width: size.getW(8)),
                        Checkbox(
                            // fillColor:
                            //     MaterialStateProperty.all(kSecondaryColor),
                            visualDensity: VisualDensity.compact,
                            value: payPro.isCheckPubHoCharge,
                            onChanged: (bool? val) {
                              if (val == null) return;
                              payPro.isCheckPubHoCharge = val;
                              payPro.onChangedPayAmount(
                                  isUpdatePaidAmount: false);
                            }),
                        InkWell(
                          onTap: () {
                            payPro.isCheckPubHoCharge =
                                !payPro.isCheckPubHoCharge;
                            payPro.onChangedPayAmount(
                                isUpdatePaidAmount: false);
                          },
                          child: Text(
                            "Surcharge",
                            // (payPro.orderDetailById?.storeTaxSettings
                            //             ?.taxExclusiveInclusiveType
                            //             ?.toLowerCase()
                            //             .contains('week') ??
                            //         false)
                            //     ? LN.weekendSur
                            //     : LN.publicHolidaySc,
                            style: TextStyle(
                              fontSize: size.getS(16),
                              color: Colors.black,
                            ),
                          ),
                        ),
                        if (payPro.isCheckPubHoCharge)
                          Expanded(
                            child: SizedBox(
                              width: size.getW(102),
                              child: Text(
                                (payPro.curSym ?? '') +
                                    // payPro.getAllAmount.pHSurCharge
                                    (payPro.getAllAmount.paidAmount *
                                            (payPro.holidaySurCharge ?? 0) /
                                            100)
                                        .roundToNString(),
                                style: TextStyle(
                                  fontSize: size.getS(16),
                                  color: Colors.black,
                                  fontFamily: kFontFMedium,
                                ),
                                textAlign: TextAlign.right,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: size.getH(6))
              ],
              if (isPrimary &&
                  (GlobalCVP.storeInfo?.creditCardSurCharge?.isActive ?? false))
                AnimatedSwitcher(
                  duration: Duration(milliseconds: 300),
                  transitionBuilder: (child, animation) => FadeTransition(
                    opacity: animation,
                    child: child,
                  ),
                  child: payPro.PAY_METHOD == PayMethodEnum.Cash
                      ? SizedBox.shrink(key: ValueKey(payPro.PAY_METHOD))
                      : Row(
                          key: ValueKey(payPro.PAY_METHOD),
                          children: [
                            // _cusCheckBox(
                            //   size,
                            //   isCheck: payPro.isCheckCreCarCharge,
                            //   onTap: () {
                            //     payPro.isCheckCreCarCharge = !payPro.isCheckCreCarCharge;
                            //     payPro.onChangedPayAmount(isUpdatePaidAmount: false);
                            //   },
                            // ),

                            // SizedBox(width: size.getW(8)),
                            Checkbox(
                                // fillColor:
                                //     MaterialStateProperty.all(kSecondaryColor),
                                value: payPro.isCheckCreCarCharge,
                                visualDensity: VisualDensity.compact,
                                onChanged: (bool? val) {
                                  if (val == null) return;
                                  payPro.isCheckCreCarCharge = val;
                                  payPro.onChangedPayAmount(
                                      isUpdatePaidAmount: false);
                                }),
                            InkWell(
                              onTap: () {
                                payPro.isCheckCreCarCharge =
                                    !payPro.isCheckCreCarCharge;
                                payPro.onChangedPayAmount(
                                    isUpdatePaidAmount: false);
                              },
                              child: Text(
                                "${LN.creditCardSc} ",
                                style: TextStyle(
                                  fontSize: size.getS(16),
                                  color: Colors.black,
                                ),
                              ),
                            ),
                            SizedBox(
                              width: size.getW(84),
                              child: TextFormWidget(
                                borderRadius: 5,
                                vPad: 6,
                                borderColor: Colors.black12,
                                isReq: true,
                                initValidate: true,
                                fillColor: kBackgroundColor,
                                cltr: payPro.creCardCltr,
                                hintText: "0",
                                textInputType: TextInputType.number,
                                inputFormatters: [
                                  Between0And100TextInputFormatter()
                                ],
                                // onChanged: (_) =>
                                //     payPro.onChangedPayAmount(isUpdatePaidAmount: false),
                                textAlign: TextAlign.right,
                                errH: 0,
                                suffix: Text(
                                  "%",
                                  style: TextStyle(
                                    fontSize: size.getS(16),
                                    color: Colors.black,
                                    fontFamily: kFontFMedium,
                                  ),
                                ),
                                validator: (p0) {
                                  if (p0 == null || p0.isEmpty) return null;
                                  final _data = double.tryParse(p0);
                                  if (_data == null || _data > 100) {
                                    showToast(LN.invalidCardSurchargePer);
                                    return '';
                                  }
                                  return null;
                                },
                                readOnly: true,
                                onTap: () async {
                                  final _cc = await PriceUpdateDia.showDia(
                                    context,
                                    number: payPro.creCardCltr.text.inDouble,
                                    title: "${LN.creditCardSurcharge}(%)",
                                    max: 100,
                                  );
                                  payPro.creCardCltr.text =
                                      _cc.roundToNString();
                                  payPro.onChangedPayAmount(
                                      isUpdatePaidAmount: false);
                                },
                              ),
                            ),
                            if (payPro.isCheckCreCarCharge)
                              Expanded(
                                child: SizedBox(
                                  width: size.getW(102),
                                  child: Text(
                                    (payPro.curSym ?? '') +
                                        payPro.getAllAmount.ccSurCharge
                                            .roundToNString(),
                                    style: TextStyle(
                                      fontSize: size.getS(16),
                                      color: Colors.black,
                                      fontFamily: kFontFMedium,
                                    ),
                                    textAlign: TextAlign.right,
                                  ),
                                ),
                              ),
                          ],
                        ),
                ),
              if (isPrimary &&
                  payPro.isDineIn &&
                  (GlobalCVP.storeInfo?.serviceCharge?.isActive ?? false))
                _disableSection(
                  readOnly: _hasPaidOnce,
                  child: Padding(
                    padding: EdgeInsets.only(top: size.getH(4)),
                    child: Row(
                      children: [
                        Checkbox(
                            visualDensity: VisualDensity.compact,
                            value: payPro.isCheckServiceCharge,
                            onChanged: (bool? val) {
                              if (val == null) return;
                              payPro.isCheckServiceCharge = val;
                              payPro.onChangedPayAmount(
                                  isUpdatePaidAmount: false);
                            }),
                        InkWell(
                          onTap: () {
                            payPro.isCheckServiceCharge =
                                !payPro.isCheckServiceCharge;
                            payPro.onChangedPayAmount(
                                isUpdatePaidAmount: false);
                          },
                          child: Text(
                            "Service Charge(%)  ",
                            style: TextStyle(
                              fontSize: size.getS(16),
                              color: Colors.black,
                            ),
                          ),
                        ),
                        SizedBox(
                          width: size.getW(84),
                          child: TextFormWidget(
                            borderRadius: 5,
                            vPad: 6,
                            borderColor: Colors.black12,
                            isReq: true,
                            initValidate: true,
                            fillColor: kBackgroundColor,
                            cltr: payPro.serviceChargePerCltr,
                            hintText: "0",
                            textInputType: TextInputType.number,
                            inputFormatters: [
                              Between0And100TextInputFormatter()
                            ],
                            textAlign: TextAlign.right,
                            errH: 0,
                            suffix: Text(
                              "%",
                              style: TextStyle(
                                fontSize: size.getS(16),
                                color: Colors.black,
                                fontFamily: kFontFMedium,
                              ),
                            ),
                            validator: (p0) {
                              if (p0 == null || p0.isEmpty) return null;
                              final _data = double.tryParse(p0);
                              if (_data == null || _data > 100) {
                                showToast("Invalid Service Charge Percentage");
                                return '';
                              }
                              return null;
                            },
                            readOnly: true,
                            onTap: () async {
                              final _sc = await PriceUpdateDia.showDia(
                                context,
                                number:
                                    payPro.serviceChargePerCltr.text.inDouble,
                                title: "Service Charge(%)",
                                max: 100,
                              );
                              payPro.serviceChargePerCltr.text =
                                  _sc.roundToNString();
                              payPro.onChangedPayAmount(
                                  isUpdatePaidAmount: false);
                            },
                          ),
                        ),
                        if (payPro.isCheckServiceCharge)
                          Expanded(
                            child: SizedBox(
                              width: size.getW(102),
                              child: Text(
                                (payPro.curSym ?? '') +
                                    payPro.getAllAmount.serviceCharge
                                        .roundToNString(),
                                style: TextStyle(
                                  fontSize: size.getS(16),
                                  color: Colors.black,
                                  fontFamily: kFontFMedium,
                                ),
                                textAlign: TextAlign.right,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
            ],
            OrderTotalSection(
              amount: payPro.getAllAmount,
              curSym: payPro.curSym ?? '',
              taxType: payPro.getAllAmount.taxType,
            ),
            // if (payPro.isItemUpdated &&
            //     payPro.onPayScreenFor == OnPayScreenFor.Payment)
            //   Row(
            //     mainAxisAlignment: MainAxisAlignment.center,
            //     children: [
            //       Expanded(
            //           child: Padding(
            //         padding: EdgeInsets.only(right: size.getW(16)),
            //         child: LoadButton(
            //           loading: payPro.updateOrderLoad,
            //           btnColor: payPro.updateOrderLoad
            //               ? Colors.grey.shade400
            //               : kSecondaryColor,
            //           vPad: size.isDesktop ? 12 : 8,
            //           onsave: payPro.updateOrderLoad
            //               ? null
            //               : () async {
            //                   payPro.updatePlaceOrder().then((value) {
            //                     if (value ?? false) {
            //                       payPro.setUniSearchData();
            //                     }
            //                   });
            //                 },
            //           btnText: LN.updateOrder,
            //           textColor: Colors.white,
            //         ),
            //       )),
            //     ],
            //   )
          ],
        ),
      ),
    );
  }

  Container _helperMessage(
    Ssize size, {
    required String text,
  }) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
          color: Colors.red.withOpacity(0.1),
          borderRadius: BorderRadius.circular(20)),
      padding: EdgeInsets.symmetric(
          horizontal: size.getW(8), vertical: size.getH(8)),
      child: Row(
        children: [
          Icon(
            Icons.info_outline,
            size: size.getS(18),
            color: Colors.red,
          ),
          SizedBox(width: size.getW(8)),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                color: Colors.red.shade800,
                fontSize: size.getS(14),
              ),
            ),
          ),
          // _updateOrderButton(context),
        ],
      ),
    );
  }

  Widget _itemHeader(
    Ssize size, {
    final Function(bool?)? onSelect,
    final bool isChecked = false,
    bool isPrimary = true,
  }) {
    return Row(
      // crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 10,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (onSelect != null)
                Row(
                  children: [
                    SizedBox(
                      width: size.getS(36),
                      height: size.getS(36),
                      child: FittedBox(
                        child: Checkbox(
                          visualDensity: VisualDensity.compact,
                          activeColor: kPrimaryColor,
                          value: isChecked,
                          onChanged: onSelect,
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        onSelect(!isChecked);
                      },
                      child: Text(
                        "All Items",
                        style: TextStyle(
                          fontSize: size.getS(14),
                          color: kTempColor,
                          fontFamily: kFontFMedium,
                        ),
                      ),
                    ),
                  ],
                ),
              // SizedBox(
              //   width: size.getW(onSelect != null ? 42 : 60),
              // ),
              if (onSelect == null)
                Text(
                  LN.items,
                  style: TextStyle(
                    fontSize: size.getS(16),
                    color: Colors.black,
                    fontFamily: kFontFMedium,
                    fontWeight: FontWeight.bold,
                  ),
                ),
            ],
          ),
        ),
        // Expanded(
        //   flex: 2,
        //   child: Text(
        //     LN.qty,
        //     style: TextStyle(
        //       fontSize: size.getS(16),
        //       color: Colors.black,
        //       fontFamily: kFontFMedium,
        //       fontWeight: FontWeight.bold,
        //     ),
        //     textAlign: TextAlign.center,
        //   ),
        // ),
        Expanded(
          flex: 3,
          child: Text(
            LN.price,
            style: TextStyle(
              fontSize: size.getS(16),
              color: Colors.black,
              fontFamily: kFontFMedium,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.end,
          ),
        ),
        Expanded(
            flex: isPrimary
                ? (payPro.onPayScreenFor != OnPayScreenFor.Refund &&
                        (payPro.remainingAmount ?? 0) == 0
                    ? 2
                    : 1)
                : 1,
            child: Container()),
        if (isPrimary)
          SizedBox(
            width: size.getW(6),
          ),
      ],
    );
  }

  showDiscountDialog({
    required Ssize size,
    required BuildContext context,
  }) async {
    final _hasPaidOnce = (payPro
            .orderDetailById?.orderDetailsViewModel?.paymentType?.isNotEmpty ??
        false);

    CustomDialog.showCustomDialog(
      context: context,
      title: "Add Discount",
      actions: [
        Padding(
          padding: EdgeInsets.only(right: size.getH(20.0)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              if (!_hasPaidOnce)
                LoadButton(
                  width: 160,
                  btnText: "${LN.clear} ${LN.discount}",
                  hPad: 4,
                  btnColor: Colors.red.shade700,
                  textColor: Colors.white,
                  onsave: () {
                    //clear
                    payPro.discountPercentCltr.text = "0.00";
                    for (int j = 0;
                        j < payPro.paySecListRes!.discounts!.length;
                        j++) {
                      payPro.paySecListRes!.discounts![j].isSelected = false;
                    }
                    payPro.onChangedPayAmount(
                      isUpdatePaidAmount:
                          payPro.paymentType != PaymentType.PartialPayment,
                      hasDiscountOnPartial:
                          payPro.paymentType == PaymentType.PartialPayment,
                      isDisountPath: true,
                    );
                    Navigator.of(context).pop();
                  },
                ),
              SizedBox(
                width: size.getW(20),
              ),
              LoadButton(
                width: 200,
                btnText: LN.ok,
                hPad: 4,
                btnColor: kSecondaryColor,
                textColor: Colors.white,
                onsave: () {
                  payPro.onChangedPayAmount(
                    isUpdatePaidAmount:
                        payPro.paymentType != PaymentType.PartialPayment,
                    hasDiscountOnPartial:
                        payPro.paymentType == PaymentType.PartialPayment,
                    isDisountPath: true,
                  );
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        ),
      ],
      content: SizedBox(
        width: size.width * 0.45,
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: PayDiscountSec(),
        ),
      ),
    );
  }

  Widget? _trailing(Ssize size, {Function()? onTap}) {
    final _payTypeIndex =
        payPro.orderDetailById?.orderDetailsViewModel?.paymentType;

    if (payPro.onPayScreenFor == OnPayScreenFor.Refund) return null;

    if (payPro.onPayScreenFor == OnPayScreenFor.Payment &&
        (_payTypeIndex?.isNotEmpty ?? false
        //TODO: for delete item in middle of payment in split by item case
        // &&
        //     _payTypeIndex != "3" &&
        //     payPro.PAY_TYPE_LIST[_payTypeIndex.inDouble.toInt()] !=
        //         "Split By Items"
        )) return null;

    return Card(
      elevation: 4,
      margin: EdgeInsets.zero,
      shadowColor: Colors.grey[200],
      color:
          //  payPro.onPayScreenFor == OnPayScreenFor.Refund
          //     ? Colors.white
          //     :
          onTap == null ? Colors.grey.shade100 : kIconBackColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: EdgeInsets.all(
            size.getW(6),
          ),
          child:
              // payPro.onPayScreenFor == OnPayScreenFor.Refund
              //     ? Image.asset(
              //         "assets/png/refund.png",
              //         color: onTap == null ? Colors.black45 : null,
              //       )
              //     :
              SvgPicture.asset(
            "assets/svg/icons/Delete.svg",
            color: onTap == null ? Colors.black45 : null,
          ),
        ),
      ),
    );
  }

  // Widget _cusCheckBox(
  //   Ssize size, {
  //   required bool isCheck,
  //   Function()? onTap,
  // }) {
  //   return InkWell(
  //     onTap: onTap,
  //     child: AnimatedContainer(
  //       duration: Duration(milliseconds: 300),
  //       width: size.getS(16),
  //       height: size.getS(16),
  //       decoration: BoxDecoration(
  //         color: isCheck ? kSecondaryColor : Colors.white,
  //         border: Border.all(color: kSecondaryColor, width: 2),
  //         borderRadius: BorderRadius.circular(5),
  //       ),
  //       alignment: Alignment.center,
  //       child: isCheck
  //           ? Icon(
  //               Icons.check,
  //               color: Colors.white,
  //               size: size.getS(14),
  //             )
  //           : SizedBox.shrink(),
  //     ),
  //   );
  // }
}

class ItemInfo extends StatelessWidget {
  final Ssize size;
  final String? imgPath;
  final String? title;
  final List<String?>? modifier;
  final List<String?>? ingredients;
  final String? description;
  final double? quantity;
  final double? initQty;
  final String? price;
  final bool canQtyUp;
  final bool canQtyDown;
  final Function(bool)? updateQuan;
  // final Function()? onDelete;
  final Widget? trailing;
  final bool isForRefund;
  final bool isSelected;
  final Function(bool?)? onSelect;
  final Function()? updateOrder;
  // final bool isHalfItem;
  final List<ComboItem>? comboItem;
  final bool isPriamry;
  final String? status;

  const ItemInfo({
    super.key,
    required this.size,
    this.imgPath,
    this.title,
    this.description,
    this.quantity,
    this.initQty,
    this.price,
    this.updateQuan,
    // this.onDelete,
    this.trailing,
    this.canQtyUp = true,
    this.canQtyDown = true,
    this.modifier,
    this.isForRefund = false,
    this.isSelected = false,
    this.onSelect,
    this.updateOrder,
    // this.isHalfItem = false,
    this.ingredients,
    this.comboItem,
    this.isPriamry = true,
    this.status,
  });

  @override
  Widget build(BuildContext context) {
    final String? qty = quantity != null &&
            (quantity! / quantity!.round() == 1 || quantity == 0)
        ? quantity!.round().toString()
        : quantity?.toString();

    String _comboProductRootName = "";

    return Padding(
      padding: EdgeInsets.only(
          top: size.getH(8.0), bottom: size.getH(8.0), right: size.getW(18)),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 10,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (onSelect != null)
                      SizedBox(
                        width: size.getS(36),
                        height: size.getS(36),
                        child: FittedBox(
                          child: Checkbox(
                              visualDensity: VisualDensity.compact,
                              activeColor: kPrimaryColor,
                              value: isSelected,
                              onChanged: onSelect),
                        ),
                      ),
                    //   )
                    // if (imgPath != null)
                    //   InkWell(
                    //     onTap: onSelect == null
                    //         ? null
                    //         : () => onSelect!(!isSelected),
                    //     child: ClipRRect(
                    //         borderRadius: BorderRadius.circular(100),
                    //         child: CachedNetworkImage(
                    //             imageUrl: imgPath!,
                    //             height: size.getW(48),
                    //             width: size.getW(48),
                    //             fit: BoxFit.fitHeight,
                    //             placeholder: ImageError.load,
                    //             errorWidget: ImageError.notSupportIcon)),
                    //   ),
                    // SizedBox(
                    //   width: size.getW(12),
                    // ),
                    Flexible(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (comboItem == null)
                            _itemDetail(
                              onTap: onSelect == null
                                  ? null
                                  : () => onSelect!(!isSelected),
                              itemTitle: title ?? '',
                              itemModifier: modifier,
                              itemIngreList: ingredients,
                            )
                          else
                            CusExpansion(
                                title: _itemDetail(
                                  onTap: onSelect == null
                                      ? null
                                      : () => onSelect!(!isSelected),
                                  itemTitle: title ?? '',
                                  itemModifier: modifier,
                                  itemIngreList: ingredients,
                                ),
                                showMoreText: "View Items",
                                showLessText: "Hide Items",
                                children: List.generate(comboItem!.length, (i) {
                                  bool _isComboProductRootNameSame =
                                      _comboProductRootName.isNotEmpty &&
                                          _comboProductRootName ==
                                              comboItem![i].rootName;
                                  if (_comboProductRootName !=
                                      comboItem![i].rootName) {
                                    _comboProductRootName =
                                        comboItem![i].rootName ?? '';
                                  }

                                  return Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Align(
                                        alignment: Alignment.centerLeft,
                                        child: _itemDetail(
                                          itemTitle: comboItem![i].title == null
                                              ? null
                                              : "${i + 1}. ${comboItem![i].title}",
                                          itemModifier: comboItem![i].modifier,
                                          itemIngreList:
                                              comboItem![i].ingredients,
                                          isCombo: true,
                                          quantity: comboItem![i].quantity,
                                          rootName: _isComboProductRootNameSame
                                              ? null
                                              : comboItem![i].rootName,
                                        ),
                                      ),
                                      if (comboItem!.length - 1 != i)
                                        Divider(
                                          color: Colors.black87,
                                          thickness: 0.5,
                                        ),
                                    ],
                                  );
                                })),
                          if (description != null && description!.isNotEmpty)
                            Text(
                              description!,
                              style: TextStyle(
                                fontSize: size.getS(14),
                                color: Colors.black54,
                              ),
                            ),
                          SizedBox(
                            height: size.getH(4),
                          ),
                          if (isForRefund && initQty != null)
                            Text(
                              "${LN.totalQty} : $initQty",
                              style: TextStyle(
                                fontSize: size.getS(16),
                                color: Colors.black87,
                                fontFamily: kFontFMedium,
                              ),
                            ),
                          // if (!isHalfItem)
                          if (isPriamry)
                            Row(
                              // crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                if (isForRefund)
                                  Text(
                                    "${LN.refundQty} : ",
                                    style: TextStyle(
                                      fontSize: size.getS(16),
                                      color: Colors.black87,
                                      fontFamily: kFontFMedium,
                                    ),
                                  ),
                                Card(
                                  margin: EdgeInsets.zero,
                                  color: canQtyDown
                                      ? kSecondaryColor
                                      : Colors.grey.shade400,
                                  shape: const CircleBorder(),
                                  elevation: 2,
                                  child: InkWell(
                                    customBorder: const CircleBorder(),
                                    onTap: canQtyDown
                                        ? () {
                                            if (updateQuan != null)
                                              updateQuan!(false);
                                          }
                                        : null,
                                    child: SizedBox(
                                      width: size
                                          .getW(36), // Adjust size as needed
                                      height: size.getW(36),
                                      child: Center(
                                        child: Text(
                                          '-',
                                          style: TextStyle(
                                            fontSize: size.getS(20),
                                            fontFamily: kFontFBold,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: size.getW(16.0)),
                                  child: Text(
                                    qty ?? '',
                                    style: TextStyle(
                                      fontSize: size.getS(18),
                                      color: Colors.black,
                                      fontFamily: kFontFMedium,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                                Card(
                                  margin: EdgeInsets.zero,
                                  color: canQtyUp
                                      ? kSecondaryColor
                                      : Colors.grey.shade400,
                                  shape: const CircleBorder(),
                                  elevation: 2,
                                  child: InkWell(
                                    customBorder: const CircleBorder(),
                                    onTap: canQtyUp
                                        ? () {
                                            if (updateQuan != null)
                                              updateQuan!(true);
                                          }
                                        : null,
                                    child: SizedBox(
                                      width: size
                                          .getW(36), // Adjust size as needed
                                      height: size.getW(36), // Keep it circular
                                      child: Center(
                                        child: Text(
                                          '+',
                                          style: TextStyle(
                                            fontSize: size.getS(20),
                                            fontFamily: kFontFBold,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                if (updateOrder != null) ...[
                                  SizedBox(
                                    width: size.getW(16),
                                  ),
                                  InkWell(
                                    onTap: updateOrder,
                                    child: Padding(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: size.getW(12),
                                          vertical: size.getH(2)),
                                      child: Text(
                                        LN.update,
                                        style: TextStyle(
                                          fontSize: size.getS(14),
                                          color: kTempColor,
                                          fontFamily: kFontFMedium,
                                          decoration: TextDecoration.underline,
                                        ),
                                      ),
                                    ),
                                  )
                                ],
                                if (status?.isNotEmpty ?? false)
                                  Padding(
                                    padding:
                                        EdgeInsets.only(left: size.getW(16)),
                                    child: Text(
                                      status ?? '',
                                      style: TextStyle(
                                        fontSize: size.getS(14),
                                        color: status
                                                    ?.toLowerCase()
                                                    .contains('ring') ??
                                                false
                                            ? Colors.orange
                                            : Colors.green,
                                        fontFamily: kFontFMedium,
                                      ),
                                    ),
                                  ),
                              ],
                            )
                          else
                            Text(
                              "${LN.totalQty} : $qty",
                              style: TextStyle(
                                fontSize: size.getS(16),
                                color: Colors.black87,
                                fontFamily: kFontFMedium,
                              ),
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // if (!isHalfItem)
              Expanded(
                flex: 3,
                child: Text(
                  price ?? '',
                  style: TextStyle(
                    fontSize: size.getS(16),
                    color: Colors.black,
                    fontFamily: kFontFMedium,
                  ),
                  textAlign: TextAlign.end,
                ),
              ),
              SizedBox(
                width: size.getW(4),
              ),
              // if ((isLastHalfItem && isHalfItem) ||
              //     (!isLastHalfItem && !isHalfItem))
              // if (!isHalfItem)
              if (trailing != null) Expanded(child: trailing!)
            ],
          ),
        ],
      ),
    );
  }

  Widget _itemDetail({
    final Function()? onTap,
    String? itemTitle,
    List<String?>? itemModifier,
    List<String?>? itemIngreList,
    bool isCombo = false,
    String? quantity,
    String? rootName,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (itemTitle != null)
          InkWell(
            onTap: onTap,
            child: Text(itemTitle,
                style: TextStyle(
                  fontSize: size.getS(isCombo ? 15 : 16),
                  color: Colors.black,
                  fontFamily: kFontFMedium,
                )),
          ),
        if ((double.tryParse(quantity ?? '') ?? 0) == 0.5)
          Container(
            decoration: BoxDecoration(
              color: kSecondaryColor.withAlpha(100),
              borderRadius: BorderRadius.circular(10),
            ),
            padding: EdgeInsets.symmetric(horizontal: size.getW(16)),
            child: Text(
              LN.half,
              style: TextStyle(
                fontSize: size.getS(15),
                fontFamily: kFontFMedium,
                color: Colors.white,
              ),
            ),
          ),
        if (itemModifier?.isNotEmpty ?? false) ...[
          if (rootName != null)
            Text(
              rootName,
              style: TextStyle(
                fontSize: size.getS(isCombo ? 14.5 : 15),
                color: kTempColor,
                fontFamily: kFontFMedium,
                decoration: TextDecoration.underline,
              ),
            ),
          // SizedBox(height: size.getH(8)),
          ...List.generate(
              itemModifier!.length,
              (i) => Padding(
                    padding: EdgeInsets.only(
                      top: size.getH(
                          itemModifier[i]!.contains('\n') ? size.getH(8) : 0),
                    ),
                    child: Text(
                      itemModifier[i] ?? '',
                      style: TextStyle(
                        fontSize: size.getS(isCombo ? 14.5 : 15),
                        color: (itemModifier[i]?.contains(' - ') ?? false)
                            ? Colors.amber.shade900
                            : kTempColor,
                        fontFamily: kFontFMedium,
                        height: 1.3,
                      ),
                    ),
                  ))
        ],
        if (itemIngreList?.isNotEmpty ?? false) ...[
          Text(
            LN.removeIngredients,
            style: TextStyle(
              fontSize: size.getS(isCombo ? 14.5 : 15),
              color: Colors.amber.shade900,
              fontFamily: kFontFMedium,
              decoration: TextDecoration.underline,
            ),
          ),
          ...List.generate(
              itemIngreList!.length,
              (index) => Text(
                    " - ${itemIngreList[index]}",
                    style: TextStyle(
                      fontSize: size.getS(isCombo ? 14.5 : 15),
                      color: Colors.amber.shade900,
                      fontFamily: kFontFMedium,
                    ),
                  ))
        ],
      ],
    );
  }
}

class ComboItem {
  final String? imgPath;
  final String? title;
  final List<String?>? modifier;
  final List<String?>? ingredients;
  final String? quantity;
  final String? rootName;

  ComboItem({
    this.imgPath,
    this.title,
    this.modifier,
    this.ingredients,
    this.quantity,
    this.rootName,
  });
}

class PercentageDollarToggle extends StatelessWidget {
  final bool value;
  final ValueChanged<bool> onToggle;
  final String leftText;
  final String rightText;
  final Ssize size;

  const PercentageDollarToggle(
      {required this.value,
      required this.onToggle,
      this.leftText = '%',
      this.rightText = '\$',
      required this.size,
      super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onToggle(!value),
      child: Container(
        width: double.maxFinite,
        height: size.getH(50),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          border: Border.all(color: kSecondaryColor),
          color: Colors.white,
        ),
        child: Row(
          children: [
            // Left text (Percentage)
            Expanded(
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(5),
                    bottomLeft: Radius.circular(5),
                  ),
                  color: value ? kSecondaryColor : Colors.white,
                ),
                child: Center(
                  child: Text(
                    leftText,
                    style: TextStyle(
                      fontSize: size.getS(20),
                      fontWeight: FontWeight.bold,
                      color: !value ? kSecondaryColor : Colors.white,
                    ),
                  ),
                ),
              ),
            ),
            // Right text (Dollar)
            Expanded(
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(5),
                    bottomRight: Radius.circular(5),
                  ),
                  color: !value ? kSecondaryColor : Colors.white,
                ),
                child: Center(
                  child: Text(
                    rightText,
                    style: TextStyle(
                      fontSize: size.getS(20),
                      fontWeight: FontWeight.bold,
                      color: !value ? Colors.white : kSecondaryColor,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class PayDiscountSec extends StatefulWidget {
  const PayDiscountSec({super.key});

  @override
  State<PayDiscountSec> createState() => _PayDiscountSecState();
}

class _PayDiscountSecState extends State<PayDiscountSec> {
  late PaymentPro payPro;
  final scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    payPro = Provider.of<PaymentPro>(context, listen: false);
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  Widget _disableSection({bool readOnly = false, required Widget child}) {
    return IgnorePointer(
      ignoring: readOnly,
      child: Opacity(
        opacity: readOnly ? 0.5 : 1,
        child: child,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final Ssize size = Ssize(context);
    final _percentList = ["0", "5", "10", "20", "25", "50", "75", "100"];
    final payPro = Provider.of<PaymentPro>(context);
    final _hasPaidOnce = (payPro.orderDetailById?.orderDetailsViewModel
                ?.paymentType?.isNotEmpty ??
            false) &&
        payPro.onPayScreenFor == OnPayScreenFor.Payment;
    final _amount = payPro.getAllAmount;
    // final _discountText = _amount.discount == 0
    //     ? ""
    //     : (_amount.taxType == TaxType.Inclusive
    //         ? _amount.discountWithTax.roundToNString()
    //         : _amount.discount.roundToNString());

    OrderDiscountModel? _generalDiscount;

    if (payPro.discountList != null) {
      for (final a in payPro.discountList!) {
        if (a.discountType?.toLowerCase() ==
            DiscountType.General.name.toLowerCase()) {
          _generalDiscount = a;
        }
      }
    }
    final _discountText = _generalDiscount == null
        ? ""
        : _amount.taxType == TaxType.Inclusive
            ? (_generalDiscount.discountAmountWithTax ?? "")
            : (_generalDiscount.discountAmount ?? "");

    return _disableSection(
      readOnly: _hasPaidOnce,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: size.getW(12)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            PercentageDollarToggle(
              size: size,
              value: payPro.isDisPercentTab,
              leftText: '%',
              rightText: payPro.curSym ?? '\$',
              onToggle: (value) {
                payPro.isDisPercentTab = !payPro.isDisPercentTab;
                payPro.notify;
              },
            ),
            SizedBox(height: size.getH(12)),
            TextFormWidget(
              vPad: 12,
              borderRadius: 5,
              borderColor: Colors.black12,
              isReq: false,
              readOnly: true,
              initValidate: true,
              fillColor: kBackgroundColor,
              cltr: payPro.isDisPercentTab
                  ? payPro.discountPercentCltr
                  : TextEditingController(text: _discountText),
              hintText: "0.00",
              textInputType: TextInputType.number,
              textAlign: TextAlign.right,
              focusBorderColor: Colors.black12,
              inputFormatters: [Between0And100TextInputFormatter()],
              errH: 0,
              suffix: payPro.isDisPercentTab
                  ? Text(
                      "%",
                      style: TextStyle(
                        fontSize: size.getS(16),
                        color: Colors.black,
                        fontFamily: kFontFMedium,
                      ),
                    )
                  : null,
              prefix: payPro.isDisPercentTab
                  ? null
                  : Text(
                      "${payPro.curSym ?? ''} ",
                      style: TextStyle(
                        fontSize: size.getS(16),
                        color: Colors.black,
                        fontFamily: kFontFMedium,
                      ),
                    ),
              onTap: () async {
                if (payPro.isDisPercentTab) {
                  final _discountPer = await PriceUpdateDia.showDia(
                    context,
                    number: double.tryParse(payPro.discountPercentCltr.text),
                    title: "Discount Percent(%)",
                    max: 100,
                  );
                  payPro.discountPercentCltr.text =
                      _discountPer.roundToNString();
                  payPro.onChangedPayAmount(
                    isUpdatePaidAmount:
                        payPro.paymentType != PaymentType.PartialPayment,
                    hasDiscountOnPartial:
                        payPro.paymentType == PaymentType.PartialPayment,
                    isDisountPath: true,
                  );
                } else {
                  final _discount = await PriceUpdateDia.showDia(
                    context,
                    number: _discountText.inDouble,
                    title: "Discount Amount",
                  );
                  final double _deliveryAmount = payPro.isOrderTypeDelivery
                      ? (double.tryParse(payPro.deliveryTextCltr.text) ?? 0)
                      : 0;

                  final _itemPrice = _amount.itemPrice + _deliveryAmount;
                  if (_discount <= _itemPrice) {
                    _amount.discount = _discount;
                    payPro.discountPercentCltr.text =
                        (_discount * 100 / _itemPrice).formatDoubleN(digit: 3);
                    payPro.onChangedPayAmount(
                      isUpdatePaidAmount:
                          payPro.paymentType != PaymentType.PartialPayment,
                      hasDiscountOnPartial:
                          payPro.paymentType == PaymentType.PartialPayment,
                      isDisountPath: true,
                    );
                  } else {
                    showToast("Discount amount is higher than total Amount");
                  }
                }
              },
            ),
            SizedBox(height: size.getH(12)),
            if (payPro.isDisPercentTab)
              Wrap(
                alignment: WrapAlignment.center,
                spacing: size.getW(12),
                runSpacing: size.getH(10),
                children: _percentList.map((percent) {
                  return InkWell(
                    onTap: () {
                      payPro.discountPercentCltr.text = percent;
                      payPro.onChangedPayAmount(
                        isUpdatePaidAmount:
                            payPro.paymentType != PaymentType.PartialPayment,
                        hasDiscountOnPartial:
                            payPro.paymentType == PaymentType.PartialPayment,
                        isDisountPath: true,
                      );
                    },
                    child: Container(
                      width: size.getW(60),
                      height: size.getH(50),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(
                          color: payPro.discountPercentCltr.text.inDouble ==
                                  percent.inDouble
                              ? kSecondaryColor
                              : Colors.grey.shade400,
                          width: payPro.discountPercentCltr.text.inDouble ==
                                  percent.inDouble
                              ? 2
                              : 1,
                        ),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Center(
                        child: Text(
                          "$percent%",
                          style: TextStyle(
                            color: kPrimaryColor,
                            fontSize: size.getS(18),
                            fontFamily: kFontFMedium,
                          ),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            SizedBox(height: size.getH(12)),
            if (payPro.discountPercentCltr.text.isNotEmpty &&
                payPro.discountPercentCltr.text != "0.00")
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Discount(%): ${payPro.discountPercentCltr.text}%",
                    style: TextStyle(
                      fontSize: size.getS(16),
                      color: Colors.black,
                      fontFamily: kFontFMedium,
                    ),
                  ),
                  SizedBox(height: size.getH(6)),
                  Text(
                    "Discount Amount: ${(payPro.curSym ?? '')}${(_amount.taxType == TaxType.Inclusive ? _amount.discountWithTax : _amount.discount).roundToNString()}",
                    style: TextStyle(
                      fontSize: size.getS(16),
                      color: Colors.black,
                      fontFamily: kFontFMedium,
                    ),
                  ),
                ],
              ),
            SizedBox(height: size.getH(12)),
            if (payPro.paySecListRes?.discounts?.isNotEmpty ?? false)
              SizedBox(
                height: size.height * 0.35,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Choose Discount Reason",
                      style: TextStyle(
                        fontSize: size.getS(18),
                        fontWeight: FontWeight.bold,
                        fontFamily: kFontFMedium,
                      ),
                    ),
                    SizedBox(height: size.getH(8)),
                    Expanded(
                      child: MediaQuery.removePadding(
                        context: context,
                        removeTop: true,
                        child: Scrollbar(
                          thickness: 8,
                          // isAlwaysShown: true,
                          trackVisibility: true,
                          controller: scrollController,
                          radius: const Radius.circular(10),
                          child: ListView.separated(
                            controller: scrollController,
                            itemBuilder: (_, i) {
                              final discount =
                                  payPro.paySecListRes!.discounts![i];
                              return InkWell(
                                onTap: () {
                                  for (var d
                                      in payPro.paySecListRes!.discounts!) {
                                    d.isSelected = false;
                                  }
                                  discount.isSelected = true;
                                  payPro.notify;
                                },
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                      vertical: size.getH(14),
                                      horizontal: size.getW(12)),
                                  decoration: BoxDecoration(
                                    color: discount.isSelected ?? false
                                        ? kSecondaryColor
                                        : Colors.transparent,
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  child: Text(
                                    discount.name ?? '',
                                    style: TextStyle(
                                      fontSize: size.getS(16),
                                      color: discount.isSelected ?? false
                                          ? Colors.white
                                          : Colors.black,
                                      fontFamily: kFontFMedium,
                                    ),
                                  ),
                                ),
                              );
                            },
                            separatorBuilder: (_, __) => Divider(height: 0),
                            itemCount:
                                payPro.paySecListRes?.discounts?.length ?? 0,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
