import 'dart:io';

import 'package:flutter/material.dart';
import 'package:pos_account/config/responsive.dart';
import 'package:pos_account/config/size_config.dart';
import 'package:pos_account/config/validator.dart';
import 'package:pos_account/constant/constant.dart';
import 'package:pos_account/ln.dart';
import 'package:pos_account/model/home/menu/orders/all_orders_res.dart';
import 'package:pos_account/providers/common/invoice_pro.dart';
import 'package:pos_account/providers/cus_val_pro.dart';
import 'package:pos_account/providers/menu/orders_pro.dart';
import 'package:pos_account/providers/menu/payment_pro.dart';
import 'package:pos_account/screens/home_screen/com/items/sidebar/order_section/com/pay_method/com/choose_eft_pay_dia.dart';
import 'package:pos_account/screens/home_screen/com/items/sidebar/pay_receipt/com/email_dia.dart';
import 'package:pos_account/services/printer/com/invoice_print.dart';
import 'package:pos_account/services/printer/com/merchant_print.dart';
import 'package:pos_account/services/printer/com/refund_print.dart';
import 'package:pos_account/services/printer/com/send_to_kitchen_print.dart';
import 'package:pos_account/widgets/dashline_widget.dart';
import 'package:pos_account/widgets/dialog/confirm_dialog.dart';
import 'package:provider/provider.dart';
import '../../../../show_status.dart';
import 'send_sms_dia.dart';

class PendingOrderTile extends StatelessWidget {
  final Function(OBAction)? onTapOrderBtn;
  final AllOrderData? allOrder;
  final OrderPro? orderPro;
  final GlobalKey<ScaffoldState>? scafKey;
  final bool viewOnly;
  const PendingOrderTile({
    super.key,
    this.onTapOrderBtn,
    this.allOrder,
    this.orderPro,
    this.scafKey,
    this.viewOnly = false,
  });

  OrderStatus? get _orderStatus {
    return OrderStatusModel.getStatus(allOrder?.status);
  }

  Future<void> showEmailD(BuildContext context) async {
    final payPro = Provider.of<PaymentPro>(context, listen: false);

    await Future.delayed(Duration(milliseconds: 300), () {
      payPro.loadEmail = true;
      payPro.clearEmailData();
      payPro.notify;
      payPro.setEmailData(
          cusName: allOrder?.customerName, email: allOrder?.email ?? '');
      // payPro.getPayDetailInvoice(orderId: allOrder?.orderId).then((_) {
      //   payPro.setEmailData(cusName: allOrder?.customerName);
      // });
    });

    return showDialog(
        context: context,
        builder: (builder) => SimpleDialog(
              titlePadding: EdgeInsets.zero,
              contentPadding:
                  EdgeInsets.symmetric(horizontal: 24, vertical: 24),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15)),
              children: [DoEmailDia(orderId: allOrder?.orderId)],
            ));
  }

  Future<void> getSmsDia(BuildContext context) async {
    if (allOrder?.orderId == null || orderPro?.loading == true) return;

    await orderPro?.getSmsCusDetails(allOrder!.orderId!);

    return showDialog(
        context: context,
        builder: (builder) => SimpleDialog(
              titlePadding: EdgeInsets.zero,
              contentPadding:
                  EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15)),
              children: [SendSmsDia()],
            ));
  }

  Future<void> sendToKitchen(BuildContext context) async {
    Future<void> _stk({bool printAllItem = true}) async {
      await orderPro!
          .orderSendToKitchen(
              orderId: allOrder?.orderId, printAllItem: printAllItem)
          .then((value) {
        if (value != null) {
          // Navigator.push(
          //     context,
          //     MaterialPageRoute(
          //         builder: (_) => PrintUITest(
          //               order: value,
          //             )));
          SendToKitchenPrint.stkPos(context, order: value,
              runSuccessFun: () async {
            orderPro!.confirmOrderStk(orderId: value.orderId);
          });
        }
      });
    }

    await Future.delayed(Duration(milliseconds: 400));

    final size = Ssize(context);
    showDialog(
        context: context,
        builder: (_) => ConfirmDialog(
            title: "Print Order Items",
            titleSize: 18,
            subTitle: "Select the item's type you want to print.",
            actionText: "Print Failed Items",
            cancelText: LN.no,
            onDelete: () async {
              Future.delayed(Duration(milliseconds: 400), () {
                _stk(printAllItem: false);
              });
              return null;
            },
            bottomRightWidget: ElevatedButton(
                style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(kSecondaryColor),
                    padding: MaterialStateProperty.all(EdgeInsets.symmetric(
                        horizontal: size.getW(12), vertical: size.getH(8)))),
                onPressed: () {
                  Future.delayed(Duration(milliseconds: 400), () {
                    _stk(printAllItem: true);
                  });
                  Navigator.pop(context);
                },
                child: Text(
                  "Print All Items",
                  style: TextStyle(
                    fontSize: size.getS(15),
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ))));
  }

  void paymentInvoice(BuildContext context) {
    orderPro!.orderPrintInvoice(allOrder?.orderId).then((value) {
      if (value != null) {
        final payPro = Provider.of<PaymentPro>(context, listen: false);
        payPro.makePaymentRes = value;
        InvoicePrint.spdPosInvoice(context, paymentRes: value);
        if (scafKey != null) {
          final invoicePro = Provider.of<InvoicePro>(context, listen: false);
          if (value.printingInvoiceDetailsResponseViewModels?.isNotEmpty ??
              false)
            invoicePro.printInvoice = InvoicePrint.cIPrintInvoice(
              value.printingInvoiceDetailsResponseViewModels!.first,
              curSym: orderPro?.curSym ?? '',
              url: value.url,
            );
          invoicePro.invoiceType = InvoiceType.Payment;
          if (invoicePro.printInvoice != null) {
            GlobalCVP.setOrPath = PathOfOrder.ORDERPATH;
            GlobalCVP.setEndDValue = 2;
            Future.delayed(Duration(milliseconds: 300), () {
              scafKey!.currentState!.openEndDrawer();
            });
          }
        }
      }
    });
  }

  void _paymentMerchant(BuildContext context) {
    orderPro!.orderPrintInvoice(allOrder?.orderId).then((value) {
      if (value != null) {
        final payPro = Provider.of<PaymentPro>(context, listen: false);
        payPro.makePaymentRes = value;

        if (scafKey != null) {
          final invoicePro = Provider.of<InvoicePro>(context, listen: false);
          invoicePro.merchantInvoice.clear();

          if (value.printingMerchantInvoiceDetailsResponseViewModels
                  ?.isNotEmpty ??
              false) {
            for (final e
                in value.printingMerchantInvoiceDetailsResponseViewModels!) {
              invoicePro.merchantInvoice.add([
                MerchantPrint.cIPrintMerchant(
                  e,
                  invoiceData: MerchantDetails.Merchant,
                ),
                MerchantPrint.cIPrintMerchant(
                  e,
                  invoiceData: MerchantDetails.Customer,
                )
              ]);
            }
          }

          invoicePro.invoiceType = InvoiceType.PaymentMerchant;

          GlobalCVP.setOrPath = PathOfOrder.ORDERPATH;
          GlobalCVP.setEndDValue = 2;
          Future.delayed(Duration(milliseconds: 300), () {
            scafKey!.currentState!.openEndDrawer();
          });
        }
      }
    });
  }

  void _refundInvoice(BuildContext context) {
    orderPro!.orderRefundInvoice(allOrder?.orderId).then((value) {
      if (value != null) {
        final payPro = Provider.of<PaymentPro>(context, listen: false);
        payPro.refundPaymentRes = value;
        RefundPrint.askToPrintRefund(context, refundRes: value);
        if (scafKey != null) {
          final invoicePro = Provider.of<InvoicePro>(context, listen: false);
          if (value.printingRefundDetailsResponseViewModels?.isNotEmpty ??
              false)
            invoicePro.printInvoice = RefundPrint.cRefundInvoice(
              value.printingRefundDetailsResponseViewModels!.first,
              curSym: orderPro?.curSym ?? '',
              url: value.url,
            );
          invoicePro.invoiceType = InvoiceType.Refund;
          if (invoicePro.printInvoice != null) {
            GlobalCVP.setOrPath = PathOfOrder.ORDERPATH;
            GlobalCVP.setEndDValue = 2;
            Future.delayed(Duration(milliseconds: 300), () {
              scafKey!.currentState!.openEndDrawer();
            });
          }
        }
      }
    });
  }

  void _refundMerchant(BuildContext context) {
    orderPro!.orderRefundInvoice(allOrder?.orderId).then((value) {
      if (value != null) {
        final payPro = Provider.of<PaymentPro>(context, listen: false);
        payPro.refundPaymentRes = value;
        if (scafKey != null) {
          final invoicePro = Provider.of<InvoicePro>(context, listen: false);
          invoicePro.merchantInvoice.clear();

          if (value.printingMerchantInvoiceDetailsResponseViewModels
                  ?.isNotEmpty ??
              false) {
            for (final e
                in value.printingMerchantInvoiceDetailsResponseViewModels!) {
              invoicePro.merchantInvoice.add([
                MerchantPrint.cIPrintMerchant(
                  e,
                  invoiceData: MerchantDetails.Merchant,
                ),
                MerchantPrint.cIPrintMerchant(
                  e,
                  invoiceData: MerchantDetails.Customer,
                )
              ]);
            }
          }

          invoicePro.invoiceType = InvoiceType.RefundMerchant;

          GlobalCVP.setOrPath = PathOfOrder.ORDERPATH;
          GlobalCVP.setEndDValue = 2;
          Future.delayed(Duration(milliseconds: 300), () {
            scafKey!.currentState!.openEndDrawer();
          });
        }
      }
    });
  }

  void _eftPosLogs(BuildContext context) {
    orderPro!.eftPosLog(allOrder?.orderId).then((value) {
      if (value != null) {
        if (scafKey != null) {
          final invoicePro = Provider.of<InvoicePro>(context, listen: false);
          invoicePro.eftposMerchantLogRes = value;
          invoicePro.merchantInvoice.clear();

          if (value.eftPosMerchantInvoiceResponseViewModels?.isNotEmpty ??
              false) {
            for (final e in value.eftPosMerchantInvoiceResponseViewModels!) {
              invoicePro.merchantInvoice.add([
                MerchantPrint.printErrorMerchant(
                  e,
                  invoiceData: MerchantDetails.Merchant,
                  mL: value,
                ),
                MerchantPrint.printErrorMerchant(
                  e,
                  invoiceData: MerchantDetails.Customer,
                  mL: value,
                )
              ]);
            }
          }

          invoicePro.invoiceType = InvoiceType.ErrorMerchant;

          GlobalCVP.setOrPath = PathOfOrder.ORDERPATH;
          GlobalCVP.setEndDValue = 2;
          Future.delayed(Duration(milliseconds: 300), () {
            scafKey!.currentState!.openEndDrawer();
          });
        }
      }
    });
  }

  Future<void> revokeOrder(BuildContext context) async {
    await Future.delayed(Duration(milliseconds: 300));
    await showDialog(
        context: context,
        builder: (builder) {
          return ConfirmDialog(
            title: "Reopen Order?",
            subTitle: "Are you sure you want to reopen order?",
            onDelete: () async {
              orderPro?.revokeOrder(orderId: allOrder?.orderId);
              return null;
            },
            actionText: LN.yes,
            cancelText: LN.no,
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    final size = Ssize(context);
    final orderData = <_ODList>[
      // _ODList(title: LN.orderNumber, subTitle: allOrder?.orderNumber ?? ''),
      _ODList(
          title: GlobalCVP.isServiceStore ? LN.serviceDate : LN.orderDate,
          subTitle: (allOrder?.orderDate ?? '')),
      if (_orderStatus == OrderStatus.Refund &&
          (allOrder?.refundDate?.isNotEmpty ?? false))
        _ODList(title: "Refund Date", subTitle: allOrder?.refundDate ?? ''),
      _ODList(
          title: GlobalCVP.isServiceStore ? LN.serviceStatus : LN.orderStatus,
          subTitle: allOrder?.status ?? '',
          type: _ItemType.STATUS),
      if (allOrder?.paymentMethod?.isNotEmpty ?? false)
        _ODList(
          title: LN.paymentMethod,
          subTitle: allOrder?.paymentMethod
                  ?.split(',')
                  .map((e) => e.trim())
                  .toSet()
                  .toString()
                  .replaceAll('{', '')
                  .replaceAll('}', '') ??
              '',
        ),
      if (GlobalCVP.isHospitality)
        _ODList(title: LN.tableName, subTitle: allOrder?.tableName ?? ''),
      // if (GlobalCVP.isServiceStore)
      //   _ODList(title: LN.serviceChannel, subTitle: allOrder?.channel ?? '')
      // else
      _ODList(title: LN.orderChannel, subTitle: allOrder?.orderChannel ?? ''),
      _ODList(
          title: _orderStatus == OrderStatus.Refund
              ? LN.refundAmount
              : LN.totalAmount,
          subTitle: ((orderPro?.curSym ?? '') + (allOrder?.totalAmount ?? ''))
              .negPrice())
    ];
    final List<_OrderButton> orderButtons = viewOnly
        ? []
        : _orderStatus == OrderStatus.Pending
            ? [
                if (GlobalCVP.viewWidget.viewOrderDetailButton)
                  _OrderButton(
                      oba: OBAction.View,
                      title: GlobalCVP.isServiceStore
                          ? LN.viewService
                          : LN.viewOrder,
                      color: kPrimaryColor),
                if (orderPro != null &&
                    // !orderPro!.isRetail &&
                    GlobalCVP.viewWidget.viewAcceptOrderButton)
                  _OrderButton(
                      oba: OBAction.Accept,
                      title:
                          GlobalCVP.isServiceStore ? LN.accept : LN.acceptOrder,
                      color: kSecondaryColor),
                if (GlobalCVP.viewWidget.viewCanelOrderButton)
                  _OrderButton(
                      oba: OBAction.Cancel,
                      title:
                          GlobalCVP.isServiceStore ? LN.cancel : LN.cancelOrder,
                      color: Colors.red.shade700),
              ]
            : _orderStatus == OrderStatus.PaymentPending
                ? [
                    if (GlobalCVP.viewWidget.viewOrderDetailButton)
                      _OrderButton(
                          oba: OBAction.View,
                          title: GlobalCVP.isServiceStore
                              ? LN.viewService
                              : LN.viewOrder,
                          color: kPrimaryColor),
                    if (orderPro != null &&
                        GlobalCVP.viewWidget.viewOrderPayButton)
                      _OrderButton(
                          oba: OBAction.Pay,
                          title: LN.pay,
                          color: Colors.green),
                    // if (GlobalCVP.viewWidget("ViewCanelOrderButton"))
                    // _OrderButton(
                    //     oba: OBAction.Cancel,
                    //     title: LN.cancelOrder,
                    //     color: Colors.red.shade700),
                    if (GlobalCVP.viewWidget.viewOrderUpdateButton)
                      _OrderButton(
                        oba: OBAction.Update,
                        title: GlobalCVP.isServiceStore
                            ? LN.update
                            : LN.updateOrder,
                        color: kSecondaryColor,
                      ),
                  ]
                : _orderStatus == OrderStatus.PaymentCompleted
                    ? [
                        if (GlobalCVP.viewWidget.viewOrderDetailButton)
                          _OrderButton(
                              oba: OBAction.View,
                              title: GlobalCVP.isServiceStore
                                  ? LN.viewService
                                  : LN.viewOrder,
                              color: kPrimaryColor),
                        if (GlobalCVP.viewWidget.viewCreateUberDeliveryButton &&
                            (allOrder?.orderType
                                    ?.toLowerCase()
                                    .contains('delivery') ??
                                false))
                          _OrderButton(
                            oba: OBAction.Delivery,
                            title: LN.delivery,
                            color: Colors.green,
                          ),
                        if (GlobalCVP.viewWidget.viewOrderRefundButton)
                          _OrderButton(
                              oba: OBAction.Refund,
                              title: LN.refund,
                              color: kSecondaryColor),
                        // if (GlobalCVP.viewWidget.viewPayRevokeButton)
                        //   _OrderButton(
                        //     oba: OBAction.Revoke,
                        //     title: LN.revoke,
                        //     color: kTempColor,
                        //   ),
                      ]
                    : _orderStatus == OrderStatus.OnTheWay
                        ? [
                            if (GlobalCVP.viewWidget.viewOrderDetailButton)
                              _OrderButton(
                                  oba: OBAction.View,
                                  title: GlobalCVP.isServiceStore
                                      ? LN.viewService
                                      : LN.viewOrder,
                                  color: kPrimaryColor),
                            if (GlobalCVP.viewWidget.viewOrderDeliverButton)
                              _OrderButton(
                                  oba: OBAction.Delivery,
                                  title: GlobalCVP.isServiceStore
                                      ? LN.delivery
                                      : LN.deliverOrder,
                                  color: kSecondaryColor),
                          ]
                        : (_orderStatus == OrderStatus.Delivered ||
                                _orderStatus == OrderStatus.Cancel ||
                                _orderStatus == OrderStatus.Refund)
                            ? [
                                if (GlobalCVP.viewWidget.viewOrderDetailButton)
                                  _OrderButton(
                                      oba: OBAction.View,
                                      title: GlobalCVP.isServiceStore
                                          ? LN.viewService
                                          : LN.viewOrder,
                                      color: kPrimaryColor),
                              ]
                            : [];
    return Container(
      width: size.getW((Platform.isIOS ? 0.9 : 1) *
          (Responsive.isDesktop(context) ? 405 : 374)),
      height: size.getH(
          GlobalCVP.isServiceStore || GlobalCVP.isRetailStore ? 360 : 394),
      padding: EdgeInsets.symmetric(
          horizontal: size.getW(8), vertical: size.getH(8)),
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(10)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      ((allOrder?.orderNumber
                                      ?.toLowerCase()
                                      .contains('order') ??
                                  false)
                              ? ''
                              : (GlobalCVP.isServiceStore
                                  ? '${LN.serviceNo}. '
                                  : '${LN.orderNo} ')) +
                          (allOrder?.orderNumber ?? ''),
                      style: TextStyle(
                        fontSize: size.getS(18),
                        fontFamily: kFontFMedium,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    // if (allOrder?.customerName != null)
                    Text(
                      allOrder?.customerName ?? '',
                      style: TextStyle(
                        fontSize: size.getS(17),
                        fontFamily: kFontFMedium,
                        color: kTempColor,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.fade,
                    ),
                  ],
                ),
              ),

              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  if (_orderStatus == OrderStatus.Pending ||
                      _orderStatus == OrderStatus.PaymentPending ||
                      _orderStatus == OrderStatus.PaymentCompleted ||
                      _orderStatus == OrderStatus.OnTheWay ||
                      _orderStatus == OrderStatus.Delivered ||
                      _orderStatus == OrderStatus.Refund)
                    PopupMenuButton(
                        padding: EdgeInsets.all(12),
                        child: Stack(
                          alignment: Alignment.topRight,
                          children: [
                            Container(
                              width: size.getS(60),
                              height: size.getS(32),
                              color: Colors.white,
                            ),
                            Icon(Icons.more_vert, size: size.getS(28)),
                          ],
                        ),
                        itemBuilder: (_) {
                          final _showSms =
                              _orderStatus == OrderStatus.PaymentCompleted ||
                                  _orderStatus == OrderStatus.OnTheWay ||
                                  _orderStatus == OrderStatus.Delivered ||
                                  _orderStatus == OrderStatus.Refund;
                          return [
                            if (_showSms &&
                                GlobalCVP.viewWidget.viewOrderReadySmsButton)
                              PopupMenuItem(
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      Icons.sms_rounded,
                                      color: kPrimaryColor,
                                      size: size.getS(28),
                                    ),
                                    SizedBox(
                                      width: size.getW(12),
                                    ),
                                    Expanded(
                                      child: Text(
                                        LN.sendSms,
                                        style: TextStyle(
                                          fontSize: size.getS(18),
                                          fontFamily: kFontFRegular,
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                                onTap: () {
                                  getSmsDia(context);
                                },
                              ),
                            if (!viewOnly &&
                                    _orderStatus ==
                                        OrderStatus.PaymentCompleted ||
                                _orderStatus == OrderStatus.OnTheWay ||
                                _orderStatus == OrderStatus.Delivered ||
                                _orderStatus == OrderStatus.Refund)
                              PopupMenuItem(
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      Icons.email_outlined,
                                      color: kPrimaryColor,
                                      size: size.getS(28),
                                    ),
                                    SizedBox(
                                      width: size.getW(12),
                                    ),
                                    Expanded(
                                      child: Text(
                                        LN.sendEmail,
                                        style: TextStyle(
                                          fontSize: size.getS(18),
                                          fontFamily: kFontFRegular,
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                                onTap: () {
                                  showEmailD(context);
                                },
                              ),
                            if (!viewOnly) ...[
                              if (!GlobalCVP.isServiceStore)
                                PopupMenuItem(
                                  onTap: orderPro!.loading
                                      ? null
                                      : () {
                                          sendToKitchen(context);
                                        },
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(
                                        Icons.print_outlined,
                                        color: kPrimaryColor,
                                        size: size.getS(28),
                                      ),
                                      SizedBox(
                                        width: size.getW(12),
                                      ),
                                      Flexible(
                                        child: Text(
                                          "Print Docket",
                                          style: TextStyle(
                                            fontSize: size.getS(18),
                                            fontFamily: kFontFRegular,
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              if (_orderStatus ==
                                      OrderStatus.PaymentCompleted ||
                                  _orderStatus == OrderStatus.OnTheWay ||
                                  _orderStatus == OrderStatus.Delivered)
                                PopupMenuItem(
                                  onTap: orderPro!.loading
                                      ? null
                                      : () {
                                          paymentInvoice(context);
                                        },
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(
                                        Icons.print,
                                        color: kPrimaryColor,
                                        size: size.getS(28),
                                      ),
                                      SizedBox(
                                        width: size.getW(12),
                                      ),
                                      Expanded(
                                        child: Text(
                                          "Print Invoice",
                                          style: TextStyle(
                                            fontSize: size.getS(18),
                                            fontFamily: kFontFRegular,
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                )
                              else if (_orderStatus == OrderStatus.Refund)
                                PopupMenuItem(
                                  onTap: orderPro!.loading
                                      ? null
                                      : () {
                                          _refundInvoice(context);
                                        },
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(
                                        Icons.print_outlined,
                                        color: kPrimaryColor,
                                        size: size.getS(28),
                                      ),
                                      SizedBox(
                                        width: size.getW(12),
                                      ),
                                      Expanded(
                                        child: Text(
                                          LN.printRefundInvoice,
                                          style: TextStyle(
                                            fontSize: size.getS(18),
                                            fontFamily: kFontFRegular,
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                )
                            ],
                            if (!_showSms &&
                                GlobalCVP.viewWidget.viewOrderReadySmsButton)
                              PopupMenuItem(
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      Icons.sms_rounded,
                                      color: kPrimaryColor,
                                      size: size.getS(28),
                                    ),
                                    SizedBox(
                                      width: size.getW(12),
                                    ),
                                    Expanded(
                                      child: Text(
                                        LN.sendSms,
                                        style: TextStyle(
                                          fontSize: size.getS(18),
                                          fontFamily: kFontFRegular,
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                                onTap: () {
                                  getSmsDia(context);
                                },
                              ),
                            if (_orderStatus == OrderStatus.PaymentCompleted ||
                                _orderStatus == OrderStatus.OnTheWay ||
                                _orderStatus == OrderStatus.Delivered)
                              PopupMenuItem(
                                onTap: orderPro!.loading
                                    ? null
                                    : () {
                                        revokeOrder(context);
                                      },
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      Icons.error_outline,
                                      color: kPrimaryColor,
                                      size: size.getS(28),
                                    ),
                                    SizedBox(
                                      width: size.getW(12),
                                    ),
                                    Expanded(
                                      child: Text(
                                        "Reopen Order",
                                        style: TextStyle(
                                          fontSize: size.getS(18),
                                          fontFamily: kFontFRegular,
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            if (GlobalCVP.eftPosEnable) ...[
                              if (!viewOnly &&
                                  (_orderStatus ==
                                          OrderStatus.PaymentCompleted ||
                                      _orderStatus == OrderStatus.OnTheWay ||
                                      _orderStatus == OrderStatus.Delivered ||
                                      _orderStatus == OrderStatus.Refund)) ...[
                                if (allOrder?.eftPosMerchantType ==
                                    EftPayMethod.Mx51.name) ...[
                                  PopupMenuItem(
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(
                                          Icons.print_outlined,
                                          color: kPrimaryColor,
                                          size: size.getS(28),
                                        ),
                                        SizedBox(
                                          width: size.getW(12),
                                        ),
                                        Expanded(
                                          child: Text(
                                            LN.printMerchant,
                                            style: TextStyle(
                                              fontSize: size.getS(18),
                                              fontFamily: kFontFRegular,
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                    onTap: () {
                                      if (_orderStatus ==
                                              OrderStatus.PaymentCompleted ||
                                          _orderStatus ==
                                              OrderStatus.OnTheWay ||
                                          _orderStatus == OrderStatus.Delivered)
                                        _paymentMerchant(context);
                                      else if (_orderStatus ==
                                          OrderStatus.Refund)
                                        _refundMerchant(context);
                                    },
                                  ),
                                  PopupMenuItem(
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(
                                          Icons.print_outlined,
                                          color: kPrimaryColor,
                                          size: size.getS(28),
                                        ),
                                        SizedBox(
                                          width: size.getW(12),
                                        ),
                                        Expanded(
                                          child: Text(
                                            LN.viewEftposLogs,
                                            style: TextStyle(
                                              fontSize: size.getS(18),
                                              fontFamily: kFontFRegular,
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                    onTap: () {
                                      _eftPosLogs(context);
                                    },
                                  ),
                                ]
                                // else if (allOrder?.eftPosMerchantType ==
                                //     Strings.linkyMerchant)
                                //   PopupMenuItem(
                                //     child: Row(
                                //       mainAxisSize: MainAxisSize.min,
                                //       children: [
                                //         Icon(
                                //           Icons.print_outlined,
                                //           color: kPrimaryColor,
                                //           size: size.getS(28),
                                //         ),
                                //         SizedBox(
                                //           width: size.getW(12),
                                //         ),
                                //         Text(LN.printMerchant)
                                //       ],
                                //     ),
                                //     onTap: () {
                                //       _linkyReprintReceipt(context);
                                //     },
                                //   )
                              ],
                            ]
                          ];
                        }),
                  if (allOrder?.isOrderRevoked ?? false)
                    Container(
                      decoration: BoxDecoration(
                          color: Colors.pink,
                          borderRadius: BorderRadius.circular(20)),
                      padding: EdgeInsets.symmetric(
                          horizontal: size.getW(8), vertical: size.getH(2)),
                      child: Text(
                        'Reopened',
                        style: TextStyle(
                          fontSize: size.getS(12),
                          fontFamily: kFontFMedium,
                          color: Colors.white,
                        ),
                        maxLines: 1,
                        // overflow: TextOverflow.fade,
                      ),
                    )
                ],
              ),

              // if (!viewOnly && _orderStatus == OrderStatus.PaymentCompleted)
              //   InkWell(
              //     onTap: () {
              //       showEmailD(context);
              //     },
              //     child: Tooltip(
              //         message: LN.sendEmail,
              //         child: Icon(
              //           Icons.email_outlined,
              //           color: kPrimaryColor,
              //           size: size.getS(28),
              //         )),
              //   ),
              // if (!viewOnly)
              //   Container(
              //     height: size.getH(32),
              //     width: size.getW(40),
              //     alignment: Alignment.topRight,
              //     child: _orderStatus == OrderStatus.Pending ||
              //             _orderStatus == OrderStatus.PaymentPending
              //         ? InkWell(
              //             onTap: orderPro!.loading
              //                 ? null
              //                 : () => sendToKitchen(context),
              //             radius: 10,
              //             child: Tooltip(
              //                 message: LN.sendToKit,
              //                 child: Icon(
              //                   Icons.print,
              //                   color: kPrimaryColor,
              //                   size: size.getS(28),
              //                 )),
              //           )
              //         : _orderStatus == OrderStatus.PaymentCompleted
              //             ? InkWell(
              //                 onTap: orderPro!.loading
              //                     ? null
              //                     : () => paymentInvoice(context),
              //                 radius: 10,
              //                 child: Tooltip(
              //                     message: LN.payInvoice,
              //                     child: Icon(
              //                       Icons.print,
              //                       color: kPrimaryColor,
              //                       size: size.getS(28),
              //                     )),
              //               )
              //             : _orderStatus == OrderStatus.Refund
              //                 ? InkWell(
              //                     onTap: orderPro!.loading
              //                         ? null
              //                         : () => _refundInvoice(context),
              //                     radius: 10,
              //                     child: Tooltip(
              //                         message: LN.refundInvoice,
              //                         child: Icon(
              //                           Icons.print,
              //                           color: kPrimaryColor,
              //                           size: size.getS(28),
              //                         )),
              //                   )
              //                 : SizedBox.shrink(),
              //   ),
              // if (!viewOnly && _orderStatus == OrderStatus.PaymentCompleted)
              //   Padding(
              //     padding: EdgeInsets.only(left: size.getW(6)),
              //     child: InkWell(
              //       onTap: () {
              //         paymentMerchant(context);
              //       },
              //       child: Tooltip(
              //           message: "Print Merchant",
              //           child: Icon(
              //             Icons.print_outlined,
              //             color: kPrimaryColor,
              //             size: size.getS(28),
              //           )),
              //     ),
              //   ),
            ],
          ),
          if (orderData.isNotEmpty) ...[
            Expanded(
              child: SingleChildScrollView(
                physics: BouncingScrollPhysics(),
                child: Column(
                  children: List.generate(orderData.length - 1,
                      (index) => _tileSection(size, odData: orderData[index])),
                ),
              ),
            ),
            // Spacer(),
            Padding(
              padding: EdgeInsets.only(bottom: size.getH(6.0)),
              child: HDashDivider(),
            ),
            _tileSection(size, odData: orderData.last),
          ],
          if (orderPro != null)
            Padding(
              padding: EdgeInsets.symmetric(vertical: size.getH(8.0)),
              child: Row(
                children: [
                  ...List.generate(
                    3,
                    (index) => Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: index < orderButtons.length
                            ? ElevatedButton(
                                style: ButtonStyle(
                                  backgroundColor: WidgetStateProperty.all(
                                      orderButtons[index].color),
                                  padding: WidgetStateProperty.all(
                                    EdgeInsets.symmetric(
                                      horizontal: size.getW(4),
                                      vertical: size.getH(8.0),
                                    ),
                                  ),
                                ),
                                onPressed: onTapOrderBtn != null
                                    ? () =>
                                        onTapOrderBtn!(orderButtons[index].oba)
                                    : null,
                                child: Text(
                                  orderButtons[index].title,
                                  style: TextStyle(
                                    fontSize: size.getS(14),
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ))
                            : SizedBox.shrink(),
                      ),
                    ),
                  ),
                ],
              ),
            )
        ],
      ),
    );
  }

  Widget _tileSection(Ssize size, {required _ODList odData}) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: size.getH(6.0)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            odData.title,
            style: TextStyle(
              fontSize: size.getS(17),
              color: Colors.black,
            ),
          ),
          Flexible(
              child: odData.type == _ItemType.STATUS
                  ? ShowStatus(
                      title: odData.subTitle,
                      size: size,
                      fontSize: 12.5,
                    )
                  : Text(
                      odData.subTitle,
                      style: TextStyle(
                        fontSize: size.getS(17),
                        color: Colors.black,
                        fontFamily: kFontFMedium,
                      ),
                      textAlign: TextAlign.right,
                    ))
        ],
      ),
    );
  }
}

enum OBAction {
  View,
  Accept,
  Cancel,
  Pay,
  Update,
  Refund,
  Delivery,
  Revoke,
}

class _OrderButton {
  final OBAction oba;
  final String title;
  final Color color;

  _OrderButton({required this.oba, required this.title, required this.color});
}

enum _ItemType { TEXT, STATUS }

class _ODList {
  final String title;
  final String subTitle;
  final _ItemType type;

  _ODList({
    required this.title,
    required this.subTitle,
    this.type = _ItemType.TEXT,
  });
}
