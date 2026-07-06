import 'package:esc_pos_printer/esc_pos_printer.dart';
import 'package:flutter/material.dart';
import 'package:pos_account/ln.dart';
import 'package:pos_account/model/home/menu/payment/eftpos/eftpos_merchant_log_res.dart';
import 'package:pos_account/model/home/menu/payment/make_pay_res.dart';
import 'package:pos_account/model/ui_model/print_invoice.dart';
import 'package:pos_account/services/printer/bluetooth/bluetooth_service.dart';
import 'package:pos_account/services/printer/printer_enum.dart';
import 'package:pos_account/services/printer/printer_service.dart';
import 'package:pos_account/services/printer/usb/usb_service.dart';
import 'package:pos_account/widgets/dialog/confirm_dialog.dart';

class MerchantPrint {
  //// Payment Merchant Receipt ///////
  ///
  static void spdPosMerchant(
    BuildContext context, {
    required bool? askForPrintConfirmation,
    required MerchantDetails invoiceData,
    required PrintInvoice pI,
  }) {
    if (askForPrintConfirmation ?? false) {
      showDialog(
          context: context,
          builder: (builder) => ConfirmDialog(
                title: invoiceData == MerchantDetails.Merchant
                    ? "${LN.printMerchantCopy}?"
                    : "${LN.printCustomerCopy}?",
                subTitle: invoiceData == MerchantDetails.Merchant
                    ? LN.printMerchantCopy
                    : LN.printCustomerCopy,
                actionText: LN.print,
                onDelete: () async {
                  printMerchant(
                    pI: pI,
                  );
                  return null;
                },
                onCancel: () async {
                  if (context.mounted) Navigator.pop(context);
                  await Future.delayed(Duration(milliseconds: 300));
                  if (Navigator.canPop(context)) {
                    Navigator.pop(context);
                  }
                },
              ));
    } else {
      printMerchant(
        pI: pI,
      );
    }
  }

  static Future<void> printMerchant({
    PrintInvoice? pI,
  }) async {
    if (pI?.printerType == PrinterTypeEnum.Bluetooth.name) {
      await BluetoothService.bluetoothPrint(pI: pI);
    } else if (pI?.printerType == PrinterTypeEnum.USB.name) {
      await UsbService.usbPrint(pI: pI);
    } else {
      await PrinterService.checkDevice(
        ip: pI?.ipAddress,
        port: int.tryParse(pI?.port ?? '9100') ?? 9100,
        paperSize: pI?.paperSize ?? 'mm80',
        doPrint: true,
        run: ({required NetworkPrinter printer}) async {
          await PrinterService.printReceipt(
            printer: printer,
            pI: pI,
          );
        },
      );
    }
  }

  ///Create Invoice Pos Invoice

  static PrintInvoice cIPrintMerchant(
    PrintingMerchantInvoiceDetailsResponseViewModel e, {
    String? url,
    required MerchantDetails invoiceData,
  }) {
    final pI = PrintInvoice(
      title: e.storeName,
      subtitle: e.storeAddress,
      subtitleList: [
        // SubtitleList(text: ""),
        SubtitleList(
            text: invoiceData == MerchantDetails.Merchant
                ? e.merchantInvoiceData ?? ''
                : e.customerInvoiceData ?? ''),
        // SubtitleList(text: ""),
      ],
      footerList: [
        "${LN.thankYou}!",
        url,
      ],
      ipAddress: e.ipAddress,
      port: e.port,
      paperSize: e.paperSize,
      printerType: e.printerType,
    );
    // print('printing model created');
    return pI;
  }

  static PrintInvoice printErrorMerchant(
    EftPosMerchantInvoiceResponseViewModel e, {
    required MerchantDetails invoiceData,
    EftposMerchantLogRes? mL,
  }) {
    return PrintInvoice(
      // title: e.storeName,
      // subtitle: e.storeAddress,
      subtitleList: [
        // SubtitleList(text: ""),
        SubtitleList(
            text: invoiceData == MerchantDetails.Merchant
                ? e.merchantInvoiceData ?? ''
                : e.customerInvoiceData ?? ''),
        // SubtitleList(text: ""),
      ],
      // footerList: [
      //   "${LN.thankYou}!",
      // ],
      ipAddress: mL?.ipAddress,
      port: mL?.port,
      paperSize: mL?.paperSize,
      // isBluetoothPrinter: mL?.isBluetoothPrinter,
      printerType: mL?.printerType,
    );
  }
}

enum MerchantDetails { Merchant, Customer }
