import 'dart:typed_data';

import 'package:esc_pos_printer/esc_pos_printer.dart';
import 'package:flutter_esc_pos_utils/flutter_esc_pos_utils.dart';
import 'package:pos_account/config/utils/utils.dart';
import 'package:pos_account/config/validator.dart';
import 'package:pos_account/ln.dart';
import 'package:pos_account/model/home/eod/eod_report.dart';
import 'package:pos_account/repository/if_exception.dart';
import 'package:pos_account/services/database/shared_pref.dart';
import 'package:pos_account/services/printer/com/eod_print/eod_bluetooth.dart';
import 'package:pos_account/services/printer/printer_enum.dart';
import 'package:pos_account/services/printer/printer_service.dart';
import '../../bluetooth/blue_receipt.dart';
import '../../bluetooth/bluetooth_service.dart';
import '../../usb/usb_service.dart';
import '../barcode_qr_print.dart';
import '../image_print.dart';

class EodPrint {
  static Future<void> print({
    EodReportRes? eodReportRes,
    Uint8List? staticByte,
  }) async {
    if (eodReportRes == null) return;

    final e = eodReportRes;
    // final _printModel = await Stk.captureAny(
    //     child: EodReportView.view(size, e: e, curSym: widget.curSym));

    final _printModel = ImagePrintModel(
      staticByte: staticByte,
      width: 0,
      height: 0,
    );

    if (e.posPrinterResponseViewModels?.isNotEmpty ?? false) {
      final printerData = e.posPrinterResponseViewModels?.first;

      if (printerData?.printerType == PrinterTypeEnum.Bluetooth.name) {
        final _status = await BluetoothService.printImage(
          data: _printModel,
          macAddress: printerData?.ipAddress,
        );

        if (!(_status ?? false))
          IfException.showMessage(message: LN.failedToPrint);
      } else if (printerData?.printerType == PrinterTypeEnum.USB.name) {
        final _status = await UsbService.printImage(
            data: _printModel,
            vendorId: printerData?.ipAddress,
            productId: printerData?.port);

        if (!(_status ?? false))
          IfException.showMessage(message: LN.failedToPrint);
      } else {
        final bytes = await BlueReceipt.getByteDataServer(
          data: _printModel,
        );

        if (bytes == null) return;

        final _status = await ImagePrint.sendToEthernetPrinter(
          bytes: bytes,
          port: int.tryParse(printerData?.port ?? '') ?? 9100,
          ip: printerData?.ipAddress ?? '',
          // chunkSize: 512,
        );

        if (!_status) IfException.showMessage(message: LN.failedToPrint);
      }
    }
  }

  static Future<void> printEodReport({
    EodReportRes? e,
  }) async {
    // return;
    if (e == null) return;

    final curSym = await SharedPrefs.curSym;

    if (e.posPrinterResponseViewModels?.isNotEmpty ?? false) {
      final printerData = e.posPrinterResponseViewModels?.first;

      if (printerData?.printerType == PrinterTypeEnum.Bluetooth.name) {
        await EodBluetooth.printEodReport(e: e);
      } else if (printerData?.printerType == PrinterTypeEnum.USB.name) {
        await EodBluetooth.printEodReportViaUsb(e: e);
      } else {
        await PrinterService.checkDevice(
          ip: printerData?.ipAddress,
          port: int.tryParse(printerData?.port ?? '9100') ?? 9100,
          // paperSize: _printerData?.paperSize ?? 'mm80',
          doPrint: true,
          run: ({required NetworkPrinter printer}) async {
            // print("run functio working");
            _printEod(printer: printer, e: e, curSym: curSym);
          },
        );
      }
    }
  }

  static void _printEod({
    required NetworkPrinter printer,
    required EodReportRes e,
    String curSym = "",
  }) {
    try {
      _titleData(
        printer: printer,
        title: LN.zReportCap,
        textSize: PosTextSize.size3,
      );

      if (e.eodReportStoreInformationViewModel?.dateTime?.isNotEmpty ?? false) {
        printer.text("");
        final dateTime =
            e.eodReportStoreInformationViewModel?.dateTime?.split(' ').first ??
                '';

        _titleData(
          printer: printer,
          title: dateTime,
          textSize: PosTextSize.size1,
          bold: false,
        );
      }

      if (e.eodReportStoreInformationViewModel?.name?.isNotEmpty ?? false) {
        printer.text("");
        _titleData(
            printer: printer,
            title: e.eodReportStoreInformationViewModel?.name,
            textSize: PosTextSize.size2);
      }
      if (e.eodReportStoreInformationViewModel?.address?.isNotEmpty ?? false) {
        printer.text("");
        _titleData(
          printer: printer,
          title: e.eodReportStoreInformationViewModel?.address,
          textSize: PosTextSize.size1,
          bold: false,
        );
      }

      // printer.hr(ch: '-', linesAfter: 1);
      // printer.text("");
      printer.text("");
      printer.text("");

      double total = 0.0;

      if (e.eodSalesSummaryViewModel != null) {
        final double netSales =
            (e.eodSalesSummaryViewModel?.totalGrossSales?.inDouble ?? 0) -
                (e.eodSalesSummaryViewModel?.totalDiscount?.inDouble.abs() ??
                    0) -
                (e.eodSalesSummaryViewModel?.totalRefund?.inDouble.abs() ?? 0);

        total = netSales +
            (e.eodSalesSummaryViewModel?.totalCreditCardSurcharge?.inDouble ??
                0) +
            (e.eodSalesSummaryViewModel?.totalHolidaySurcharge?.inDouble ?? 0) +
            (e.eodSalesSummaryViewModel?.totalServiceCharge?.inDouble ?? 0) +
            (e.eodSalesSummaryViewModel?.totalGiftCardSales?.inDouble ?? 0) +
            (e.eodSalesSummaryViewModel?.totalDeliveryCharge?.inDouble ?? 0) +
            (e.eodSalesSummaryViewModel?.totalTip?.inDouble ?? 0) +
            (e.eodSalesSummaryViewModel?.totalTax?.inDouble ?? 0);

        _titleData(
          printer: printer,
          title: LN.salesSummaryCap,
          textSize: PosTextSize.size2,
        );
        printer.hr();

        _getPosColData(
          printer: printer,
          title: LN.grossSales,
          value:
              "$curSym${e.eodSalesSummaryViewModel?.totalGrossSales ?? '0.00'}"
                  .negPrice(),
        );

        _getPosColData(
          printer: printer,
          title: LN.discounts,
          value:
              "-$curSym${e.eodSalesSummaryViewModel?.totalDiscount?.inDouble.abs() ?? '0.00'}",
        );
        _getPosColData(
          printer: printer,
          title: LN.refunds,
          value:
              "-$curSym${e.eodSalesSummaryViewModel?.totalRefund?.inDouble.abs() ?? '0.00'}",
        );

        // printer.divider();

        // printer.text("");
        _underline(printer: printer);

        _getPosColData(
          printer: printer,
          title: LN.netSales,
          value: "$curSym${netSales.roundToNString()}".negPrice(),
          bold: true,
          // textSize: PosTextSize.size1,
        );
        // printer.hr();
        printer.text("");
        printer.text("");
        _getPosColData(
          printer: printer,
          title: LN.giftCardSales,
          value:
              "$curSym${e.eodSalesSummaryViewModel?.totalGiftCardSales ?? '0.00'}"
                  .negPrice(),
        );
        _getPosColData(
          printer: printer,
          title: LN.crCardSur,
          value:
              "$curSym${e.eodSalesSummaryViewModel?.totalCreditCardSurcharge ?? '0.00'}"
                  .negPrice(),
        );

        _getPosColData(
          printer: printer,
          title: "Surcharge", // LN.publicHolidaySc,
          value:
              "$curSym${e.eodSalesSummaryViewModel?.totalHolidaySurcharge ?? '0.00'}"
                  .negPrice(),
        );

        if ((e.eodSalesSummaryViewModel?.totalServiceCharge?.inDouble ?? 0) !=
            0)
          _getPosColData(
            printer: printer,
            title: "Service Charge", // LN.publicHolidaySc,
            value:
                "$curSym${e.eodSalesSummaryViewModel?.totalServiceCharge ?? '0.00'}"
                    .negPrice(),
          );

        // _getPosColData(
        //   printer: printer,
        //   title: "Weekend Surcharge",
        //   value: e.eodSalesSummaryViewModel?.totalWeekendSurcharge,
        // );
        _getPosColData(
          printer: printer,
          title: LN.deliCharge,
          value:
              "$curSym${e.eodSalesSummaryViewModel?.totalDeliveryCharge ?? '0.00'}"
                  .negPrice(),
        );
        _getPosColData(
          printer: printer,
          title: LN.tip,
          value: "$curSym${e.eodSalesSummaryViewModel?.totalTip ?? '0.00'}"
              .negPrice(),
        );
        _getPosColData(
          printer: printer,
          title: LN.totalTax,
          value: "$curSym${e.eodSalesSummaryViewModel?.totalTax ?? '0.00'}"
              .negPrice(),
        );
        // printer.text("");
        _underline(printer: printer);
        _getPosColData(
          printer: printer,
          title: LN.total,
          value: "$curSym${total.roundToNString()}".negPrice(),
          bold: true,
          // textSize: PosTextSize.size2,
        );
        // printer.hr();
        // printer.text("");
        // printer.text("");

        final _unitSales = e.eodSalesByChannelViewModel
                ?.fold<double>(0, (pV, eV) => pV + eV.quantity.inDouble) ??
            0;
        _getPosColData(
          printer: printer,
          title: LN.totalUnitSales,

          value: _unitSales.roundToNString(),
          bold: true,
          // textSize: PosTextSize.size2,
        );
        printer.text("");
        printer.text("");
        printer.text("");
      }

      if (e.eodSalesByChannelViewModel?.isNotEmpty ?? false) {
        // printer.hr(linesAfter: 1);
        _titleData(
          printer: printer,
          title: LN.salesByChannel,
          textSize: PosTextSize.size2,
        );
        printer.hr();

        _getPosColData(
          printer: printer,
          title: LN.channel,
          unit: LN.unit,
          value: LN.amount,
          bold: true,
          isHeader: true,
        );

        double _totalNetSales = 0.0;
        double _totalUnit = 0.0;

        for (final f in e.eodSalesByChannelViewModel!) {
          _totalNetSales += f.totalSales?.inDouble ?? 0;
          _totalUnit += f.quantity?.inDouble ?? 0;
          _getPosColData(
            printer: printer,
            title: f.channelName,
            unit: f.quantity,
            value: "$curSym${f.totalSales ?? '0.00'}",
          );
        }
        // printer.text("");
        _underline(printer: printer);

        _getPosColData(
          printer: printer,
          title: LN.totalNetSales,
          unit: _totalUnit.roundToNString(),
          value: "$curSym${_totalNetSales.roundToNString()}",
          bold: true,
        );
        printer.text("");
        printer.text("");
        printer.text("");
      }

      if (e.eodSalesByCategoryViewModel?.isNotEmpty ?? false) {
        // printer.hr(linesAfter: 1);
        _titleData(
          printer: printer,
          title: LN.salesByCat,
          textSize: PosTextSize.size2,
        );
        printer.hr();

        _getPosColData(
          printer: printer,
          title: LN.category,
          unit: LN.unit,
          value: LN.sales,
          bold: true,
          isHeader: true,
        );

        double _totalNetSales = 0.0;
        double _totalUnit = 0.0;

        for (final f in e.eodSalesByCategoryViewModel!) {
          _totalNetSales += f.totalSales?.inDouble ?? 0;
          _totalUnit += f.quantity?.inDouble ?? 0;
          _getPosColData(
            printer: printer,
            title: f.categoryName,
            unit: f.quantity,
            value: "$curSym${f.totalSales ?? '0.00'}",
          );
        }
        // printer.text("");
        _underline(printer: printer);

        _getPosColData(
          printer: printer,
          title: LN.total,
          unit: _totalUnit.roundToNString(),
          value: "$curSym${_totalNetSales.roundToNString()}",
          bold: true,
        );
        printer.text("");
        printer.text("");
        printer.text("");
      }

      if (e.eodSalesByCategoryTypeViewModel?.isNotEmpty ?? false) {
        // printer.hr(linesAfter: 1);
        _titleData(
          printer: printer,
          title: LN.salesByCatType,
          textSize: PosTextSize.size2,
        );
        printer.hr();

        _getPosColData(
          printer: printer,
          title: LN.catType,
          unit: LN.unit,
          value: LN.sales,
          bold: true,
          isHeader: true,
        );

        double _totalNetSales = 0.0;
        double _totalUnit = 0.0;

        for (final f in e.eodSalesByCategoryTypeViewModel!) {
          _totalNetSales += f.totalSales?.inDouble ?? 0;
          _totalUnit += f.quantity?.inDouble ?? 0;
          _getPosColData(
            printer: printer,
            title: f.categoryTypeName,
            unit: f.quantity,
            value: "$curSym${f.totalSales ?? '0.00'}",
          );
        }
        // printer.text("");
        _underline(printer: printer);

        _getPosColData(
          printer: printer,
          title: LN.total,
          unit: "$_totalUnit",
          value: "$curSym${_totalNetSales.roundToNString()}",
          bold: true,
        );
        printer.text("");
        printer.text("");
        printer.text("");
      }

      double totalPayment = 0.0;

      if (e.eodSalesByPaymentMethodViewModel?.isNotEmpty ?? false) {
        // printer.hr();
        _titleData(
          printer: printer,
          title: LN.paymentMethods,
          textSize: PosTextSize.size2,
        );
        printer.hr();

        for (final f in e.eodSalesByPaymentMethodViewModel!) {
          if (f.paymentMethodName?.toLowerCase().contains('gift') ?? false) {
            f.totalSales =
                e.eodSalesReedemptionViewModel?.totalGiftCardReedemption;
          } else if (f.paymentMethodName?.toLowerCase().contains('loyal') ??
              false) {
            f.totalSales =
                e.eodSalesReedemptionViewModel?.totalLoyaltyReedemption;
          }
          totalPayment += f.totalSales?.inDouble ?? 0;
          _getPosColData(
            printer: printer,
            title: f.paymentMethodName,
            value: "$curSym${f.totalSales ?? '0.00'}",
            bold: true,
          );
        }
        // printer.text("");
        _underline(printer: printer);

        _getPosColData(
          printer: printer,
          title: LN.totalPayment,
          value: "$curSym${totalPayment.roundToNString()}",
          bold: true,
        );
        printer.text("");
      }
      printer.hr();
      printer.text("");
      final vari = totalPayment - total;
      _getPosColData(
        printer: printer,
        title: LN.variance,
        value: "$curSym${vari.roundToNString()}".negPrice(),
        bold: true,
      );

      printer.text("");
      printer.text("");
      printer.feed(2);
      printer.cut();
      printer.disconnect(delayMs: 1);
    } on ArgumentError catch (e) {
      printer.cut();
      printer.disconnect(delayMs: 1);
      PrinterService.printError(e);
    } catch (e) {
      printer.cut();
      printer.disconnect(delayMs: 1);
    }
  }

  static void _getPosColData({
    required NetworkPrinter printer,
    String? title,
    String? unit,
    String? value,
    bool bold = false,
    PosFontType fontType = PosFontType.fontA,
    PosTextSize textSize = PosTextSize.size1,
    bool isHeader = false,
  }) {
    final splitText = (title?.trim().isNotEmpty ?? false)
        ? Utils.splitBySpace(title!,
            lineLength: textSize == PosTextSize.size1
                ? (unit == null ? 35 : 23)
                : (unit == null ? 15 : 11),
            lineSpace: '')
        : [' '];
    for (int g = 0; g < splitText.length; g++) {
      printer.row([
        PosColumn(
            text: splitText[g],
            width: unit == null ? 9 : 6,
            styles: PosStyles(
              align: PosAlign.left,
              fontType: fontType,
              height: textSize,
              width: textSize,
              bold: bold,
              underline: isHeader,
            )),
        if (g == 0) ...[
          if (unit != null)
            PosColumn(
                text: unit,
                width: 3,
                styles: PosStyles(
                  align: PosAlign.right,
                  bold: bold,
                  fontType: fontType,
                  height: textSize,
                  width: textSize,
                  underline: isHeader,
                )),
          PosColumn(
              text: value ?? '',
              width: 3,
              styles: PosStyles(
                align: PosAlign.right,
                bold: bold,
                fontType: fontType,
                height: textSize,
                width: textSize,
                underline: isHeader,
              ))
        ] else
          PosColumn(
              text: "",
              width: unit == null ? 3 : 6,
              styles: PosStyles(
                align: PosAlign.right,
                bold: bold,
                fontType: fontType,
                height: textSize,
                width: textSize,
              ))
      ]);
    }
  }

  static void _titleData({
    required NetworkPrinter printer,
    String? title,
    PosFontType fontType = PosFontType.fontA,
    PosTextSize textSize = PosTextSize.size2,
    bool bold = true,
  }) {
    final lineLength = textSize == PosTextSize.size1
        ? 47
        : textSize == PosTextSize.size2
            ? 24
            : 12;

    if (title?.isNotEmpty ?? false) {
      for (final t in Utils.splitBySpace(title!,
          lineLength: lineLength, lineSpace: '')) {
        printer.text(t,
            styles: PosStyles(
              align: PosAlign.center,
              height: textSize,
              width: textSize,
              bold: bold,
              fontType: fontType,
            ));
      }
    }
  }

  static void _underline({
    required NetworkPrinter printer,
  }) {
    printer.text(
      "_______________________________________________",
      styles: PosStyles(
        fontType: PosFontType.fontA,
        align: PosAlign.left,
      ),
    );
    printer.text("");
  }
}
