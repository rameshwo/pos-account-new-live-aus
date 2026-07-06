import 'package:flutter/material.dart';
import 'package:pos_account/config/utils/order_utils.dart';
import 'package:pos_account/config/validator.dart';
import 'package:pos_account/ln.dart';
import 'package:pos_account/model/home/menu/payment/make_pay_res.dart';
import 'package:pos_account/model/home/menu/payment/refund_pay_res.dart';
import 'package:pos_account/model/ui_model/amount_class.dart';
import 'package:pos_account/model/ui_model/print_invoice.dart';
import 'package:pos_account/providers/cus_val_pro.dart';
import 'package:pos_account/services/database/shared_pref.dart';
import 'package:pos_account/services/printer/bluetooth/bluetooth_service.dart';
import 'package:pos_account/services/printer/printer_enum.dart';
import 'package:pos_account/services/printer/usb/usb_service.dart';
import 'package:pos_account/widgets/dialog/confirm_dialog.dart';

import '../../../repository/if_exception.dart';
import '../../../screens/home_screen/com/items/sidebar/pay_receipt/com/stk.dart';
import '../../../screens/home_screen/com/items/sidebar/pay_receipt/pay_receipt.dart';
import '../bluetooth/blue_receipt.dart';
import '../printer_service.dart';
import 'image_print.dart';

class RefundPrint {
  ///[Print_Data] pos order print refund invoice
  ///

  static Future<void> askToPrintRefund(
    BuildContext context, {
    RefundPaymentRes? refundRes,
    bool isCashPayment = false,
  }) async {
    if (refundRes == null) return;

    if (refundRes.askForPrintConfirmation ?? false) {
      showDialog(
          context: context,
          builder: (builder) => ConfirmDialog(
                title: LN.printRefundReceipt,
                subTitle: LN.printRefundReceipt,
                actionText: LN.print,
                onDelete: () async {
                  await pRprintReundInvoice(
                    refundRes: refundRes,
                    isCashPayment: isCashPayment,
                  );
                  return null;
                },
                onCancel: () async {
                  Navigator.pop(context);
                  await Future.delayed(Duration(milliseconds: 300));
                  if (Navigator.canPop(context)) {
                    Navigator.pop(context);
                  }
                },
              ));
    } else {
      await pRprintReundInvoice(
        refundRes: refundRes,
        isCashPayment: isCashPayment,
      );
    }
  }

  ///print receipt print Invoice

  static Future<void> pRprintReundInvoice({
    RefundPaymentRes? refundRes,
    bool isCashPayment = false,
  }) async {
    if (refundRes?.printingRefundDetailsResponseViewModels == null ||
        refundRes!.printingRefundDetailsResponseViewModels!.isEmpty) return;

    final curSym = await SharedPrefs.curSym;

    for (final e in refundRes.printingRefundDetailsResponseViewModels!) {
      final j = (e.printBillCustomerCopy ?? false) ? 2 : 1;

      final openCashDrawer = isCashPayment && (e.openCashRegister ?? false);

      for (int i = 0; i < j; i++) {
        final pi = cRefundInvoice(
          e,
          curSym: curSym,
          url: refundRes.url,
          refundType: i == 0 ? RefundType.Refund : RefundType.CustomerCopy,
        );

        final _printWidget = PayReceipt.invoiceWidget(
          pI: pi,
        );

        final _printModel = await Stk.captureAny(child: _printWidget);

        if (e.printerType == PrinterTypeEnum.Bluetooth.name) {
          final _status = await BluetoothService.printImage(
            data: _printModel,
            macAddress: e.ipAddress,
            //open cash drawer :TODO
          );
          if (openCashDrawer) {
            BluetoothService.cashDrawerOpenFromPrinter();
          }
          if (!(_status ?? false))
            IfException.showMessage(message: LN.failedToPrint);
        } else if (e.printerType == PrinterTypeEnum.USB.name) {
          final _status = await UsbService.printImage(
              data: _printModel, vendorId: e.ipAddress, productId: e.port);

          if (openCashDrawer) {
            UsbService.cashDrawerOpenFromPrinter();
          }
          if (!(_status ?? false))
            IfException.showMessage(message: LN.failedToPrint);
        } else {
          final bytes = await BlueReceipt.getByteDataServer(
            data: _printModel,
          );

          if (bytes == null) return;

          final _status = await ImagePrint.sendToEthernetPrinter(
            bytes: bytes,
            port: int.tryParse(e.port ?? '') ?? 9100,
            ip: e.ipAddress ?? '',
            // chunkSize: 512,
          );

          if (openCashDrawer) {
            PrinterService.cashDrawerOpenFromPrinter(
              printerIp: e.ipAddress ?? '',
              port: int.tryParse(e.port ?? '') ?? 9100,
            );
          }

          if (!_status) IfException.showMessage(message: LN.failedToPrint);

          // print("IP from server : ${_printInvoice.ipAddress}: ${_printInvoice.port}");
          // await PrinterService.checkDevice(
          //   ip: e.ipAddress,
          //   port: int.tryParse(e.port ?? '9100') ?? 9100,
          //   paperSize: e.paperSize ?? 'mm80',
          //   doPrint: true,
          //   run: ({required NetworkPrinter printer}) async {
          //     // print("run functio working");
          //     await PrinterService.printReceipt(
          //       printer: printer,
          //       openCashDrawer: openCashDrawer,
          //       pI: pi,
          //     );
          //   },
          // );
        }
      }
    }
  }

  ///Create Refund Invoice Pos Invoice

  static PrintInvoice cRefundInvoice(
    PrintingInvoiceDetailsResponseViewModel e, {
    String curSym = "",
    String? url,
    RefundType refundType = RefundType.Refund,
  }) {
    final _taxType = OrderUtils.getTaxType(e.taxExclusiveInclusiveType);

    final pI = PrintInvoice(
        ipAddress: e.ipAddress,
        port: e.port,
        printerType: e.printerType,
        // image: 'assets/png/lototop.png',
        title: e.storeName,
        subtitle: e.storeAddress,
        subtitleList: [
          SubtitleList(
            text: "${LN.dateTime}:${e.date ?? ''}",
          ),
          if (_taxType != TaxType.NoTax)
            SubtitleList(text: LN.refundInvoice, style: PrinterTextStyle.Bold),
          if (refundType == RefundType.CustomerCopy)
            SubtitleList(
              text: "**${LN.cusCopy}**",
              style: PrinterTextStyle.Bold,
              size: 2,
            ),
        ],
        body: Body(
          header: [
            if (e.tableNumber != null &&
                e.tableNumber!.isNotEmpty &&
                e.tableNumber?.toLowerCase().toString() != 'n/a' &&
                !GlobalCVP.isRetailStore)
              Footer(
                title: " ${e.tableNumber}",
              ),
            Footer(
              title: "${LN.invoiceNo}: ${e.invoiceNumber ?? ''}",
            ),
            Footer(
              title:
                  "${GlobalCVP.isServiceStore ? '${LN.serviceNo}.' : LN.orderNo} ${e.orderNumber}",
            ),
            if (e.channel != null && e.channel!.isNotEmpty)
              Footer(
                title: "${LN.channel}: ${e.channel}",
              ),
            if (e.orderType != null && e.orderType!.isNotEmpty)
              Footer(
                title: "${LN.orderType}: ${e.orderType}",
              ),
            if (e.paymentMethod != null && e.paymentMethod!.isNotEmpty)
              Footer(
                title: "${LN.paymentMethod}: ${e.paymentMethod}",
              ),
            if (e.paymentProcessBy?.isNotEmpty ?? false)
              Footer(
                title: "${LN.payProcessBy}: ${e.paymentProcessBy}",
              ),
            if (e.customerName != null && e.customerName!.isNotEmpty)
              Footer(
                title: ((e.customerName?.isNotEmpty ?? false)
                    ? "${LN.customer}: ${e.customerName}"
                    : ""),
                // ((e.customerPhoneNumber?.isNotEmpty ?? false)
                //     ? "\n${LN.phoneNumber}: ${e.customerPhoneNumber}"
                //     : ""),
                // ((e.deliveryLocation?.isNotEmpty ?? false)
                //     ? "\n${LN.deliveryAdd}: ${e.deliveryLocation}"
                //     : ""),
                bold: true,
              ),
            if (e.customerPhoneNumber?.isNotEmpty ?? false)
              Footer(
                title: "${LN.phoneNumber}: ${e.customerPhoneNumber}",
                bold: true,
              ),
            if (e.deliveryLocation?.isNotEmpty ?? false)
              Footer(
                title: "${LN.deliveryAdd}: ${e.deliveryLocation}",
                bold: true,
              ),
          ],
          item: [],
          footer: [
            if (_taxType == TaxType.Exclusive) _subTotal(e: e, curSym: curSym),
            if (_taxType == TaxType.Inclusive && e.discountWithTax.hasAmount)
              Footer(
                title: LN.discount,
                body1: (curSym + e.discountWithTax!).negPrice(),
              )
            else if (_taxType == TaxType.Exclusive && e.discount.hasAmount)
              Footer(
                title: LN.discount,
                body1: (curSym + e.discount!).negPrice(),
              ),
            if (e.deliveryAmountWithTax.hasAmount)
              Footer(
                title: LN.deliAmt,
                body1: (curSym + e.deliveryAmountWithTax!).negPrice(),
              ),
            if (e.publicHolidaySurChargeWithTax.hasAmount)
              Footer(
                title: "Surcharge",
                // (e.holidaySurchargeType?.toLowerCase().contains('week') ??
                //         false)
                //     ? LN.weekendSur
                //     : LN.publicHolidaySc,
                body1: (curSym + e.publicHolidaySurChargeWithTax!).negPrice(),
              ),
            if (e.creditCardSurchargeAmountWithTax.hasAmount)
              Footer(
                title: LN.creditCardSurcharge,
                body1:
                    (curSym + e.creditCardSurchargeAmountWithTax!).negPrice(),
              ),
            if (e.serviceChargeAmount.hasAmount)
              Footer(
                title: "Service Charge",
                body1: (curSym + e.serviceChargeAmount!).negPrice(),
              ),
            if (e.tipAmount.hasAmount)
              Footer(
                title: LN.tip,
                body1: (curSym + e.tipAmount!).negPrice(),
              ),
            if (_taxType != TaxType.NoTax)
              Footer(
                title:
                    (_taxType == TaxType.Inclusive ? "${LN.included} " : "") +
                        LN.tax,
                body1: (curSym + (e.tax ?? '')).negPrice(),
              ),
            Footer(
              title: LN.total,
              body1: (curSym + (e.totalAmount ?? '')).negPrice(),
            )
          ],
        ),
        footerList: [
          " ",
          if ((e.serviceChargePercentage?.inDouble ?? 0) != 0 &&
              ((e.serviceChargeAmount?.inDouble ?? 0) != 0)) ...[
            "A discretionary service charge of ${e.serviceChargePercentage.inDouble.formatDoubleN(digit: 2)}% has been added to your bill.",
            " ",
          ],
          "${LN.thankYou}!",
          if (e.abnNumber?.isNotEmpty ?? false) "${LN.abn}: ${e.abnNumber}",
          url,
        ]);
    if (e.orderItemsDetailsResponseViewModels != null &&
        e.orderItemsDetailsResponseViewModels!.isNotEmpty) {
      final items = <ItemFooterElement>[];

      for (int i = 0; i < e.orderItemsDetailsResponseViewModels!.length; i++) {
        final a = e.orderItemsDetailsResponseViewModels![i];

        final qty = double.tryParse(a.quantity ?? '1') ?? 1;
        items.add(ItemFooterElement(
          title: "${i + 1}. ${a.itemName}",
          body2: qty == 0.5 ? "0.5" : "${qty.toInt()}",
          body3: (curSym + (a.price ?? '')).negPrice(),
        ));
        if (a.modifiers != null && a.modifiers!.isNotEmpty)
          for (final b in a.modifiers!) {
            items.add(ItemFooterElement(
              title: "   -${b.modifierName ?? ''}",
              body2: "${(double.tryParse(b.quantity ?? '1') ?? 1).toInt()}",
              body3: (curSym + (b.totalModifierPrice ?? '')).negPrice(),
            ));
          }
      }
      pI.body!.item!.add(
        Item(
          itemHeader: ItemFooterElement(
              title:
                  "${LN.items}(${e.orderItemsDetailsResponseViewModels!.length})",
              body2: "${LN.qty}.",
              body3: LN.price),
          itemBody: items,
        ),
      );
    }
    // print('printing model created');
    return pI;
  }

  static Footer _subTotal(
      {required PrintingInvoiceDetailsResponseViewModel e,
      required String curSym}) {
    if (e.orderItemsDetailsResponseViewModels == null) return Footer();

    double _value = 0;
    for (final a in e.orderItemsDetailsResponseViewModels!) {
      _value += (double.tryParse(a.price ?? '0.0') ?? 0) *
          (double.tryParse(a.quantity ?? '0') ?? 0);
    }
    return Footer(
      title: LN.subTotal,
      body1: (curSym + _value.roundToNString()).negPrice(),
    );
  }
}

enum RefundType { Refund, CustomerCopy }
