import 'package:flutter_esc_pos_utils/flutter_esc_pos_utils.dart';
import 'package:pos_account/config/utils/utils.dart';
import 'package:pos_account/config/validator.dart';
import 'package:pos_account/ln.dart';
import 'package:pos_account/model/home/eod/eod_report.dart';
import 'package:pos_account/services/printer/bluetooth/bluetooth_service.dart';
import 'package:pos_account/services/printer/usb/usb_service.dart';

/// bluetooth
///
class EodBluetooth {
  static Future<bool?> printEodReport({
    EodReportRes? e,
  }) async {
    if (e == null) return null;

    if (await BluetoothService.getConnectionStatus(
        macAddress: (e.posPrinterResponseViewModels?.isNotEmpty ?? false)
            ? e.posPrinterResponseViewModels?.first.ipAddress
            : null)) {
      final bytes = await _getBluetoothData(
        e: e,
      );
      if (bytes == null) return null;

      final _status = await BluetoothService.writeBytes(bytes);
      return _status;
    } else {
      return null;
      // return await BluetoothService.showDeviceList(
      //   function: () async => await printEodReport(e: e),
      // );
    }
  }

  static Future<bool?> printEodReportViaUsb({
    EodReportRes? e,
  }) async {
    if (e == null) return null;

    if (UsbService.connectedDevice != null &&
        UsbService.connectedDevice?.vendorId ==
            e.posPrinterResponseViewModels?.first.ipAddress) {
      final bytes = await _getBluetoothData(
        e: e,
      );
      if (bytes == null) return null;

      final status = await UsbService.printByte(bytes: bytes);
      return status;
    } else {
      final status = await UsbService.checkConnection(
          vendorId: e.posPrinterResponseViewModels?.first.ipAddress,
          productId: e.posPrinterResponseViewModels?.first.port);
      if (status) {
        return printEodReportViaUsb(e: e);
      }
      return null;
    }
  }

  static Future<List<int>?> _getBluetoothData({
    required EodReportRes e,
    PaperSize paperSize = PaperSize.mm80,
    String curSym = "",
  }) async {
    List<int> bytes = [];

    final profile = await CapabilityProfile.load();
    final printer = Generator(paperSize, profile);

    bytes += _titleData(
      printer: printer,
      title: LN.zReportCap,
      textSize: PosTextSize.size3,
    );

    if (e.eodReportStoreInformationViewModel?.name?.isNotEmpty ?? false) {
      bytes += printer.text("");
      bytes += _titleData(
          printer: printer,
          title: e.eodReportStoreInformationViewModel?.name,
          textSize: PosTextSize.size2);
    }
    if (e.eodReportStoreInformationViewModel?.address?.isNotEmpty ?? false) {
      bytes += printer.text("");
      bytes += _titleData(
        printer: printer,
        title: e.eodReportStoreInformationViewModel?.address,
        textSize: PosTextSize.size1,
        bold: false,
      );
    }

    if (e.eodReportStoreInformationViewModel?.dateTime?.isNotEmpty ?? false) {
      bytes += printer.text("");
      final dateTime =
          "${LN.dateTime}: ${e.eodReportStoreInformationViewModel?.dateTime}";

      bytes += _titleData(
        printer: printer,
        title: dateTime,
        textSize: PosTextSize.size1,
        bold: false,
      );
    }

    bytes += printer.hr(ch: '-', linesAfter: 1);

    double total = 0.0;

    if (e.eodSalesSummaryViewModel != null) {
      final double netSales =
          (e.eodSalesSummaryViewModel?.totalGrossSales?.inDouble ?? 0) -
              (e.eodSalesSummaryViewModel?.totalDiscount?.inDouble.abs() ?? 0) -
              (e.eodSalesSummaryViewModel?.totalRefund?.inDouble.abs() ?? 0);

      total = netSales +
          (e.eodSalesSummaryViewModel?.totalCreditCardSurcharge?.inDouble ??
              0) +
          (e.eodSalesSummaryViewModel?.totalHolidaySurcharge?.inDouble ?? 0) +
          (e.eodSalesSummaryViewModel?.totalServiceCharge?.inDouble ?? 0) +
          (e.eodSalesSummaryViewModel?.totalDeliveryCharge?.inDouble ?? 0) +
          (e.eodSalesSummaryViewModel?.totalGiftCardSales?.inDouble ?? 0) +
          (e.eodSalesSummaryViewModel?.totalTip?.inDouble ?? 0) +
          (e.eodSalesSummaryViewModel?.totalTax?.inDouble ?? 0);

      bytes += _titleData(
        printer: printer,
        title: LN.salesSummaryCap,
        textSize: PosTextSize.size2,
      );
      bytes += printer.hr();

      bytes += _getPosColData(
        printer: printer,
        title: LN.grossSales,
        value: "$curSym${e.eodSalesSummaryViewModel?.totalGrossSales ?? '0.00'}"
            .negPrice(),
      );
      bytes += _getPosColData(
        printer: printer,
        title: LN.discounts,
        value:
            "-$curSym${e.eodSalesSummaryViewModel?.totalDiscount?.inDouble.abs() ?? '0.00'}",
      );
      bytes += _getPosColData(
        printer: printer,
        title: LN.refunds,
        value:
            "-$curSym${e.eodSalesSummaryViewModel?.totalRefund?.inDouble.abs() ?? '0.00'}",
      );

      //  _bytes +=printer.text("");
      bytes += _underline(printer: printer);

      bytes += _getPosColData(
        printer: printer,
        title: LN.netSales,
        value: "$curSym${netSales.roundToNString()}".negPrice(),
        bold: true,
        // textSize: PosTextSize.size1,
      );

      bytes += printer.hr();

      bytes += _getPosColData(
        printer: printer,
        title: LN.giftCardSales,
        value:
            "$curSym${e.eodSalesSummaryViewModel?.totalGiftCardSales ?? '0.00'}"
                .negPrice(),
      );

      bytes += _getPosColData(
        printer: printer,
        title: LN.crCardSur,
        value:
            "$curSym${e.eodSalesSummaryViewModel?.totalCreditCardSurcharge ?? '0.00'}"
                .negPrice(),
      );
      bytes += _getPosColData(
        printer: printer,
        title: "Surcharge", // LN.publicHolidaySc,
        value:
            "$curSym${e.eodSalesSummaryViewModel?.totalHolidaySurcharge ?? '0.00'}"
                .negPrice(),
      );

      if ((e.eodSalesSummaryViewModel?.totalServiceCharge?.inDouble ?? 0) != 0)
        bytes += _getPosColData(
          printer: printer,
          title: "Service Charge", // LN.publicHolidaySc,
          value:
              "$curSym${e.eodSalesSummaryViewModel?.totalServiceCharge ?? '0.00'}"
                  .negPrice(),
        );
      // _bytes += _getPosColData(
      //   printer: printer,
      //   title: "Weekend Surcharge",
      //   value: e.eodSalesSummaryViewModel?.totalWeekendSurcharge,
      // );
      bytes += _getPosColData(
        printer: printer,
        title: LN.deliCharge,
        value:
            "$curSym${e.eodSalesSummaryViewModel?.totalDeliveryCharge ?? '0.00'}"
                .negPrice(),
      );
      bytes += _getPosColData(
        printer: printer,
        title: LN.tip,
        value: "$curSym${e.eodSalesSummaryViewModel?.totalTip ?? '0.00'}"
            .negPrice(),
      );
      bytes += _getPosColData(
        printer: printer,
        title: LN.totalTax,
        value: "$curSym${e.eodSalesSummaryViewModel?.totalTax ?? '0.00'}"
            .negPrice(),
      );
      // _bytes += printer.text("");
      bytes += _underline(printer: printer);
      bytes += _getPosColData(
        printer: printer,
        title: LN.total,
        value: "$curSym${total.roundToNString()}".negPrice(),
        bold: true,
        // textSize: PosTextSize.size2,
      );
      bytes += printer.hr();
      bytes += printer.text("");
      final _unitSales = e.eodSalesByChannelViewModel
              ?.fold<double>(0, (pV, eV) => pV + eV.quantity.inDouble) ??
          0;
      bytes += _getPosColData(
        printer: printer,
        title: LN.totalUnitSales,
        value: _unitSales.roundToNString(),
        bold: true,
        // textSize: PosTextSize.size2,
      );
      bytes += printer.text("");
    }

    if (e.eodSalesByChannelViewModel?.isNotEmpty ?? false) {
      bytes += printer.hr(linesAfter: 1);
      bytes += _titleData(
        printer: printer,
        title: LN.salesByChannel,
        textSize: PosTextSize.size2,
      );
      bytes += printer.hr();

      bytes += _getPosColData(
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
        bytes += _getPosColData(
          printer: printer,
          title: f.channelName,
          unit: f.quantity,
          value: "$curSym${f.totalSales ?? '0.00'}",
        );
      }
      // _bytes += printer.text("");
      bytes += _underline(printer: printer);

      bytes += _getPosColData(
        printer: printer,
        title: LN.totalNetSales,
        unit: "$_totalUnit",
        value: "$curSym${_totalNetSales.roundToNString()}",
        bold: true,
      );
      bytes += printer.text("");
    }

    if (e.eodSalesByCategoryViewModel?.isNotEmpty ?? false) {
      bytes += printer.hr(linesAfter: 1);
      bytes += _titleData(
        printer: printer,
        title: LN.salesByCat,
        textSize: PosTextSize.size2,
      );
      bytes += printer.hr();

      bytes += _getPosColData(
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
        bytes += _getPosColData(
          printer: printer,
          title: f.categoryName,
          unit: f.quantity,
          value: "$curSym${f.totalSales ?? '0.00'}",
        );
      }
      // _bytes += printer.text("");
      bytes += _underline(printer: printer);

      bytes += _getPosColData(
        printer: printer,
        title: LN.total,
        unit: "$_totalUnit",
        value: "$curSym${_totalNetSales.roundToNString()}",
        bold: true,
      );
      bytes += printer.text("");
    }

    if (e.eodSalesByCategoryTypeViewModel?.isNotEmpty ?? false) {
      bytes += printer.hr(linesAfter: 1);
      bytes += _titleData(
        printer: printer,
        title: LN.salesByCatType,
        textSize: PosTextSize.size2,
      );
      bytes += printer.hr();

      bytes += _getPosColData(
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
        bytes += _getPosColData(
          printer: printer,
          title: f.categoryTypeName,
          unit: f.quantity,
          value: "$curSym${f.totalSales ?? '0.00'}",
        );
      }
      // _bytes += printer.text("");
      bytes += _underline(printer: printer);

      bytes += _getPosColData(
        printer: printer,
        title: LN.total,
        unit: "$_totalUnit",
        value: "$curSym${_totalNetSales.roundToNString()}",
        bold: true,
      );
      bytes += printer.text("");
    }

    double totalPayment = 0.0;

    if (e.eodSalesByPaymentMethodViewModel?.isNotEmpty ?? false) {
      bytes += printer.hr();
      bytes += _titleData(
        printer: printer,
        title: LN.paymentMethods,
        textSize: PosTextSize.size2,
      );
      bytes += printer.hr();

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
        bytes += _getPosColData(
          printer: printer,
          title: f.paymentMethodName,
          value: "$curSym${f.totalSales ?? '0.00'}",
          bold: true,
        );
      }
      // _bytes += printer.text("");
      bytes += _underline(printer: printer);

      bytes += _getPosColData(
        printer: printer,
        title: LN.totalPayment,
        value: "$curSym${totalPayment.roundToNString()}",
        bold: true,
      );
      bytes += printer.text("");
    }
    bytes += printer.hr();
    bytes += printer.text("");
    final _vari = totalPayment - total;
    bytes += _getPosColData(
      printer: printer,
      title: LN.variance,
      value: "$curSym${_vari.roundToNString()}".negPrice(),
      bold: true,
    );

    bytes += printer.text("");
    bytes += printer.text("");
    bytes += printer.feed(2);
    bytes += printer.cut();

    return bytes;
  }

  static List<int> _titleData({
    required Generator printer,
    String? title,
    PosFontType fontType = PosFontType.fontA,
    PosTextSize textSize = PosTextSize.size2,
    bool bold = true,
  }) {
    List<int> bytes = [];

    final lineLength = textSize == PosTextSize.size1
        ? 47
        : textSize == PosTextSize.size2
            ? 24
            : 12;

    if (title?.isNotEmpty ?? false) {
      for (final t in Utils.splitBySpace(title!,
          lineLength: lineLength, lineSpace: '')) {
        bytes += printer.text(t,
            styles: PosStyles(
              align: PosAlign.center,
              height: textSize,
              width: textSize,
              bold: bold,
              fontType: fontType,
            ));
      }
    }

    return bytes;
  }

  static List<int> _getPosColData({
    required Generator printer,
    String? title,
    String? unit,
    String? value,
    bool bold = false,
    PosFontType fontType = PosFontType.fontA,
    PosTextSize textSize = PosTextSize.size1,
    bool isHeader = false,
  }) {
    List<int> bytes = [];

    final splitText = (title?.trim().isNotEmpty ?? false)
        ? Utils.splitBySpace(title!,
            lineLength: textSize == PosTextSize.size1
                ? (unit == null ? 35 : 23)
                : (unit == null ? 15 : 11),
            lineSpace: '')
        : [' '];
    for (int g = 0; g < splitText.length; g++) {
      bytes += printer.row([
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
    return bytes;
  }

  static List<int> _underline({
    required Generator printer,
  }) {
    List<int> bytes = [];

    bytes += printer.row([
      PosColumn(
        text:
            "                                                                                                                ",
        width: 12,
        styles: PosStyles(underline: true),
      )
    ]);
    bytes += printer.text("");

    return bytes;
  }
}
