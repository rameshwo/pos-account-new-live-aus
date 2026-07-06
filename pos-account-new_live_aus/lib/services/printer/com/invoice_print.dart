import 'package:flutter/material.dart';
import 'package:pos_account/config/utils/order_utils.dart';
import 'package:pos_account/config/utils/utils.dart';
import 'package:pos_account/config/validator.dart';
import 'package:pos_account/ln.dart';
import 'package:pos_account/model/home/menu/payment/make_pay_res.dart';
import 'package:pos_account/model/ui_model/amount_class.dart';
import 'package:pos_account/model/ui_model/print_invoice.dart';
import 'package:pos_account/providers/cus_val_pro.dart';
import 'package:pos_account/repository/if_exception.dart';
import 'package:pos_account/screens/home_screen/com/items/sidebar/pay_receipt/com/stk.dart';
import 'package:pos_account/services/database/shared_pref.dart';
import 'package:pos_account/services/printer/bluetooth/bluetooth_service.dart';
import 'package:pos_account/services/printer/printer_enum.dart';
import 'package:pos_account/services/printer/usb/usb_service.dart';
import 'package:pos_account/widgets/dialog/confirm_dialog.dart';

import '../../../screens/home_screen/com/items/sidebar/pay_receipt/pay_receipt.dart';
import '../bluetooth/blue_receipt.dart';
import '../printer_service.dart';
import 'image_print.dart';

class InvoicePrint {
  ///[Print_Data] pos order print invoice
  ///
  ///spd: show printer dialog

  static Future<void> spdPosInvoice(
    BuildContext context, {
    MakePaymentRes? paymentRes,
    ReceiptType receiptType = ReceiptType.Payment,
    bool isCashPayment = false,
  }) async {
    if (paymentRes?.isPaymentCompleted == null ||
        !paymentRes!.isPaymentCompleted!) return;

    if (paymentRes.askForPrintConfirmation ?? false) {
      showDialog(
          context: context,
          builder: (builder) => ConfirmDialog(
                title: LN.printReceipt,
                subTitle: LN.printReceipt,
                actionText: LN.print,
                onDelete: () async {
                  await pRprintInvoice(
                    paymentRes: paymentRes,
                    receiptType: receiptType,
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
      await pRprintInvoice(
        paymentRes: paymentRes,
        receiptType: receiptType,
        isCashPayment: isCashPayment,
      );
    }
  }

  ///print receipt print Invoice

  static Future<void> pRprintInvoice({
    MakePaymentRes? paymentRes,
    ReceiptType receiptType = ReceiptType.Payment,
    bool isCashPayment = false,
  }) async {
    if (paymentRes?.printingInvoiceDetailsResponseViewModels == null ||
        paymentRes!.printingInvoiceDetailsResponseViewModels!.isEmpty) return;

    final curSym = await SharedPrefs.curSym;

    for (final e in paymentRes.printingInvoiceDetailsResponseViewModels!) {
      final j = (e.printBillCustomerCopy ?? false) ? 2 : 1;

      final openCashDrawer = isCashPayment && (e.openCashRegister ?? false);

      for (int i = 0; i < j; i++) {
        final pi = cIPrintInvoice(
          e,
          curSym: curSym,
          url: paymentRes.url,
          receiptType: i == 0 ? receiptType : ReceiptType.CustomerCopy,
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

          // print('printing data check');

          // print("IP from server : ${_printInvoice.ipAddress}: ${_printInvoice.port}");
          // final _status = await PrinterService.checkDevice(
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
          //     // print("Ip print 4: ${_status1}");
          //   },
          // );

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
        }
      }
    }
  }

  ///Create Invoice Pos Invoice

  static PrintInvoice cIPrintInvoice(
    PrintingInvoiceDetailsResponseViewModel e, {
    String curSym = "",
    String? url,
    ReceiptType receiptType = ReceiptType.Payment,
  }) {
    final _taxType = OrderUtils.getTaxType(e.taxExclusiveInclusiveType);

    final _pI = PrintInvoice(
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
            SubtitleList(
                text: receiptType == ReceiptType.Print
                    ? LN.receipt
                    : LN.taxInvoice,
                style: PrinterTextStyle.Bold),
          if (receiptType == ReceiptType.CustomerCopy)
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
                !GlobalCVP.isRetailStore &&
                !GlobalCVP.isServiceStore)
              Footer(
                title: "${e.tableNumber}",
              ),
            Footer(
              title:
                  "${receiptType == ReceiptType.Print ? LN.receiptNo : LN.invoiceNo}: ${e.invoiceNumber ?? ''}",
            ),
            Footer(
              title:
                  "${GlobalCVP.isServiceStore ? '${LN.serviceNo}.' : LN.orderNo} ${e.orderNumber}",
            ),

            if (e.channel?.isNotEmpty ?? false)
              Footer(
                title: "${LN.channel}: ${e.channel}",
              ),
            if (e.orderType?.isNotEmpty ?? false)
              Footer(
                title:
                    "${GlobalCVP.isServiceStore ? LN.serviceType : LN.orderType}: ${e.orderType}",
              ),
            if ((e.paymentProcessBy?.isNotEmpty ?? false) &&
                !GlobalCVP.isServiceStore)
              Footer(
                title: "${LN.payProcessBy}: ${e.paymentProcessBy}",
              ),
            // if (e.paymentMethod?.isNotEmpty ?? false)
            //   Footer(
            //     title: "${LN.paymentMethod}: ${e.paymentMethod}",
            //     bold: true,
            //   ),
            if (e.customerName?.isNotEmpty ?? false)
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
                title: ((e.customerPhoneNumber?.isNotEmpty ?? false)
                    ? "${LN.phoneNumber}: ${e.customerPhoneNumber}"
                    : ""),
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
                body1: '-$curSym${e.discountWithTax!}',
              )
            else if (_taxType == TaxType.Exclusive && e.discount.hasAmount)
              Footer(
                title: LN.discount,
                body1: '-$curSym${e.discount!}',
              ),
            if (e.deliveryAmountWithTax.hasAmount)
              Footer(
                title: LN.deliAmt,
                body1: curSym + e.deliveryAmountWithTax!,
              ),
            if (e.publicHolidaySurChargeWithTax.hasAmount)
              Footer(
                title: "Surcharge",
                // (e.holidaySurchargeType?.toLowerCase().contains('week') ??
                //         false)
                //     ? LN.weekendSur
                //     : LN.publicHolidaySc,
                body1: curSym + e.publicHolidaySurChargeWithTax!,
              ),
            if (e.creditCardSurchargeAmountWithTax.hasAmount)
              Footer(
                title: LN.creditCardSurcharge,
                body1: curSym + e.creditCardSurchargeAmountWithTax!,
              ),
            if (e.serviceChargeAmount.hasAmount)
              Footer(
                title: "Service Charge",
                body1: curSym + e.serviceChargeAmount!,
              ),
            if (e.tipAmount.hasAmount)
              Footer(
                title: LN.tip,
                body1: curSym + e.tipAmount!,
              ),
            if (_taxType != TaxType.NoTax)
              Footer(
                title:
                    (_taxType == TaxType.Inclusive ? "${LN.included} " : "") +
                        LN.tax,
                body1: curSym + (e.tax ?? ''),
              ),
            Footer(
              title: LN.total,
              body1: curSym + (e.totalAmount ?? ''),
              bold: true,
            ),
            if (e.paymentMethodsSummary?.isNotEmpty ?? false) ...[
              Footer(
                title: ' ',
                body1: ' ',
                isDivider: true,
              ),
              Footer(
                title: 'PAYMENT METHOD',
                body1: ' ',
                alignRight: false,
                bold: true,
              ),
              ...List.generate(
                  e.paymentMethodsSummary!.length,
                  (i) => Footer(
                        title: e.paymentMethodsSummary![i].name,
                        body1: "$curSym${e.paymentMethodsSummary![i].amount}",
                        alignRight: false,
                      ))
            ],
          ],
        ),
        footerList: [
          if (receiptType == ReceiptType.Print) ...[
            "*${LN.ccChargeMayApply}",
            "*${LN.discountMayApply}",
            "   ",
          ] else ...[
            // "----------------------------------------------",
            // " ",
            // " ",
            // " ",
            // "------------------                          ", //------------------",
            // "${LN.customerSignature}                          ", //Business Signature",
            // " ",
            " ",
            if ((e.serviceChargePercentage?.inDouble ?? 0) != 0 &&
                ((e.serviceChargeAmount?.inDouble ?? 0) != 0)) ...[
              "A discretionary service charge of ${e.serviceChargePercentage.inDouble.formatDoubleN(digit: 2)}% has been added to your bill.",
              " ",
            ],
            if (e.loyaltyPointsResponseModel != null) ...[
              "==============================================",
              "${e.storeName ?? ''} REWARDS POINTS".toUpperCase(),
              "Points Earned This Purchase : ${e.loyaltyPointsResponseModel?.pointsEarned ?? '0.00'}",
              "Current Points Balance     : ${e.loyaltyPointsResponseModel?.balancePoints ?? '0.00'}",
              " ",
              "Redeem your points and save on your next purchase."
            ],
            " ",
            " ",
          ],
          "${LN.thankYou}!",
          if (e.abnNumber?.isNotEmpty ?? false) "${LN.abn}: ${e.abnNumber}",
          if (url?.isNotEmpty ?? false) url,
        ]);

    // setmenu
    int count = 0;
    final items = <ItemFooterElement>[];

    if (e.setMenuOrderOrderDetailsResponseViewModels?.isNotEmpty ?? false) {
      for (int i = 0;
          i < e.setMenuOrderOrderDetailsResponseViewModels!.length;
          i++) {
        final a = e.setMenuOrderOrderDetailsResponseViewModels![i];

        final qty = (double.tryParse(a.quantity ?? '1') ?? 1.0).round();

        count++;

        items.add(ItemFooterElement(
          title: "$count. ${a.setMenuName}",
          body2: "$qty",
          body3: (curSym + (a.price ?? '')),
        ));
      }
    }

    /// order detail
    if (e.orderItemsDetailsResponseViewModels != null &&
        e.orderItemsDetailsResponseViewModels!.isNotEmpty) {
      // final _items = <ItemFooterElement>[];

      // int _count = 0;

      for (int i = 0; i < e.orderItemsDetailsResponseViewModels!.length; i++) {
        final a = e.orderItemsDetailsResponseViewModels![i];
        final discountPer = a.discountPercentage.inDouble;
        String _discountText = discountPer <= 0
            ? ""
            : " (${Utils.formatNumber(discountPer)}% off)";

        final _qty = (double.tryParse(a.quantity ?? '1') ?? 1).round();

        count++;

        final _prodType = OrderUtils.prodType(a.productType);
        final _prodPriceType = OrderUtils.productPriceType(a.productPriceType);

        final _isDeal = _prodType == ProductType.Combo &&
            _prodPriceType == ProductPriceType.MakeYourOwn;

        items.add(ItemFooterElement(
          title: "$count. ${a.itemName}$_discountText",
          body2: "$_qty",
          body3: _isDeal ? null : (curSym + (a.price ?? '')),
        ));

        if (a.modifiers != null && a.modifiers!.isNotEmpty) {
          a.modifiers?.sort(
              (x, y) => (x.labelName ?? '').compareTo(y.labelName ?? ''));

          String _labelName = "";
          for (final b in a.modifiers!) {
            final _hideModiPrice = //(b.quantity?.inDouble ?? 0) == 1 &&
                (b.totalModifierPrice?.inDouble ?? 0) == 0;

            if (!_hideModiPrice) {
              if (_labelName != b.labelName) {
                _labelName = b.labelName ?? '';
                items.add(ItemFooterElement(
                  title: "   $_labelName",
                  body2: " ",
                  body3: " ",
                  size: 1,
                ));
              }
              final _modiQty = (_qty == 1
                      ? b.quantity.inDouble
                      : (b.quantity?.inDouble ?? 0) / _qty)
                  .formatDouble;
              final _modiName = _qty == 1
                  ? (b.modifierName ?? '')
                  : '${b.modifierName ?? ''}(each)';

              items.add(ItemFooterElement(
                title: "   + $_modiName",
                body2: _modiQty,
                body3: (curSym + (b.totalModifierPrice ?? '')),
              ));
            }

            if (b.modifierItemsModifierViewModels != null) {
              b.modifierItemsModifierViewModels?.sort(
                  (x, y) => (x.labelName ?? '').compareTo(y.labelName ?? ''));
              String _labelName2 = "";
              for (final c in b.modifierItemsModifierViewModels!) {
                final _hideDeepModiPrice = //(c.quantity?.inDouble ?? 0) == 1 &&
                    (c.totalModifierPrice?.inDouble ?? 0) == 0;

                if (!_hideDeepModiPrice) {
                  if (_labelName2 != c.labelName) {
                    _labelName2 = c.labelName ?? '';
                    items.add(ItemFooterElement(
                      title: "  * $_labelName2",
                      body2: " ",
                      body3: " ",
                    ));
                  }

                  final _deepModiQty = (_qty == 1
                          ? c.quantity.inDouble
                          : (c.quantity?.inDouble ?? 0) / _qty)
                      .formatDouble;
                  final _deepModiName = _qty == 1
                      ? (c.modifierName ?? '')
                      : '${c.modifierName ?? ''}(each)';

                  items.add(ItemFooterElement(
                    title: "    + $_deepModiName",
                    body2: _deepModiQty,
                    body3: (curSym + (c.totalModifierPrice ?? '')),
                  ));
                }

                if (c.modifierItemsModifierViewModels != null) {
                  c.modifierItemsModifierViewModels?.sort((x, y) =>
                      (x.labelName ?? '').compareTo(y.labelName ?? ''));

                  String _labelName3 = "";
                  for (final d in c.modifierItemsModifierViewModels!) {
                    final _hideDoubleDeepModiPrice = //(c.quantity?.inDouble ?? 0) == 1 &&
                        (d.totalModifierPrice?.inDouble ?? 0) == 0;

                    if (!_hideDoubleDeepModiPrice) {
                      if (_labelName3 != d.labelName) {
                        _labelName3 = d.labelName ?? '';
                        items.add(ItemFooterElement(
                          title: "  * $_labelName3",
                          body2: " ",
                          body3: " ",
                        ));
                      }

                      final _doubleDeepModiQty = (_qty == 1
                              ? d.quantity.inDouble
                              : (d.quantity?.inDouble ?? 0) / _qty)
                          .formatDouble;
                      final _doubleDeepModiName = _qty == 1
                          ? (d.modifierName ?? '')
                          : '${d.modifierName ?? ''}(each)';

                      items.add(ItemFooterElement(
                        title: "    + $_doubleDeepModiName",
                        body2: _doubleDeepModiQty,
                        body3: (curSym + (d.totalModifierPrice ?? '')),
                      ));
                    }
                  }
                }
              }
            }
          }
        }
      }
    }

    if (e.rawLooseOrderItemsDetailsResponseViewModels?.isNotEmpty ?? false) {
      for (int i = 0;
          i < e.rawLooseOrderItemsDetailsResponseViewModels!.length;
          i++) {
        final a = e.rawLooseOrderItemsDetailsResponseViewModels![i];

        final qty = (double.tryParse(a.quantity ?? '1') ?? 1.0);

        count++;

        items.add(ItemFooterElement(
          title: "$count. ${a.itemName ?? ''}",
          body2: "$qty",
          body3: (curSym + (a.price ?? '')),
        ));
      }
    }

    final length = (e.setMenuOrderOrderDetailsResponseViewModels?.length ?? 0) +
        (e.orderItemsDetailsResponseViewModels?.length ?? 0) +
        (e.rawLooseOrderItemsDetailsResponseViewModels?.length ?? 0);

    if (length != 0) {
      _pI.body!.item!.add(
        Item(
          itemHeader: ItemFooterElement(
              title:
                  "${GlobalCVP.isServiceStore ? LN.services : LN.items}($length)",
              body2: "${LN.qty}.",
              body3: LN.price),
          itemBody: items,
        ),
      );
    }
    // print('printing model created');
    return _pI;
  }

  static Footer _subTotal(
      {required PrintingInvoiceDetailsResponseViewModel e,
      required String curSym}) {
    if (e.orderItemsDetailsResponseViewModels == null) return Footer();

    double _value = 0;
    for (final a in e.orderItemsDetailsResponseViewModels!) {
      _value += double.tryParse(a.price ?? '0.0') ?? 0;
    }
    for (final b in e.setMenuOrderOrderDetailsResponseViewModels!) {
      _value += double.tryParse(b.price ?? '0.0') ?? 0;
    }
    return Footer(
      title: LN.subTotal,
      body1: curSym + _value.roundToNString(),
    );
  }
}

enum ReceiptType { Print, Payment, CustomerCopy }
