import 'package:flutter/material.dart';
import 'package:pos_account/config/size_config.dart';
import 'package:pos_account/config/validator.dart';
import 'package:pos_account/constant/constant.dart';
import 'package:pos_account/ln.dart';
import 'package:pos_account/model/home/eod/eod_report.dart';
import 'package:pos_account/providers/eod/eod_pro.dart';
import 'package:pos_account/services/image/image_service.dart';
import 'package:pos_account/services/printer/com/eod_print/eod_print.dart';
import 'package:pos_account/widgets/dialog/confirm_dialog.dart';
import 'package:pos_account/widgets/loading.dart';
import 'package:pos_account/widgets/no_items_sec.dart';
import 'package:provider/provider.dart';
import 'pay_receipt/com/bottom_sec.dart';
import 'pay_receipt/com/widget_to_image.dart';

class EodReportView extends StatefulWidget {
  final String curSym;
  const EodReportView({
    super.key,
    this.curSym = "",
  });

  @override
  State<EodReportView> createState() => _EodReportViewState();

  static Widget view(
    Ssize size, {
    required EodReportRes e,
    String curSym = "",
  }) {
    final dateTime = e.eodReportStoreInformationViewModel?.dateTime ?? '';
    final _dateOnly = dateTime.split(' ').first;

    final double netSales =
        (e.eodSalesSummaryViewModel?.totalGrossSales?.inDouble ?? 0) -
            (e.eodSalesSummaryViewModel?.totalDiscount?.inDouble.abs() ?? 0) -
            (e.eodSalesSummaryViewModel?.totalRefund?.inDouble.abs() ?? 0);

    final total = netSales +
        (e.eodSalesSummaryViewModel?.totalCreditCardSurcharge?.inDouble ?? 0) +
        (e.eodSalesSummaryViewModel?.totalHolidaySurcharge?.inDouble ?? 0) +
        (e.eodSalesSummaryViewModel?.totalServiceCharge?.inDouble ?? 0) +
        (e.eodSalesSummaryViewModel?.totalGiftCardSales?.inDouble ?? 0) +
        (e.eodSalesSummaryViewModel?.totalDeliveryCharge?.inDouble ?? 0) +
        (e.eodSalesSummaryViewModel?.totalTip?.inDouble ?? 0) +
        (e.eodSalesSummaryViewModel?.totalTax?.inDouble ?? 0);

    final unitSales = e.eodSalesByChannelViewModel
            ?.fold<double>(0, (pV, eV) => pV + eV.quantity.inDouble) ??
        0;

    double tsByChannel = 0.0; //total Sales by channel
    double usByChannel = 0.0; // unit sales by channel
//
    double tsByCat = 0.0;
    double usByCat = 0.0;
    //
    double tsByCatType = 0.0;
    double usByCatType = 0.0;
    //
    double totalPayment = 0.0;

    return Container(
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(10)),
      padding: EdgeInsets.symmetric(
          vertical: size.getH(12.0), horizontal: size.getW(12)),
      width: double.infinity,
      child: Column(
        children: [
          SizedBox(
            height: size.getH(12),
          ),
          Text(
            LN.zReport,
            style: TextStyle(
              fontSize: size.getS(32),
              fontFamily: kFontFMedium,
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(
            height: size.getH(2),
          ),
          Text(
            _dateOnly,
            style: TextStyle(
              fontSize: size.getS(18),
              color: Colors.black,
              fontWeight: FontWeight.bold,
              height: 1.2,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(
            height: size.getH(4),
          ),
          Text(
            e.eodReportStoreInformationViewModel?.name ?? '',
            style: TextStyle(
              fontSize: size.getS(24),
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          Text(
            e.eodReportStoreInformationViewModel?.address ?? '',
            style: TextStyle(
              fontSize: size.getS(20),
              color: Colors.black,
              fontWeight: FontWeight.bold,
              height: 1.2,
            ),
            textAlign: TextAlign.center,
          ),
          // SizedBox(
          //   height: size.getH(12),
          // ),
          // Text(
          //   dateTime,
          //   style: TextStyle(
          //     fontSize: size.getS(18),
          //     color: Colors.black,
          //     fontWeight: FontWeight.bold,
          //     height: 1.2,
          //   ),
          //   textAlign: TextAlign.center,
          // ),
          _dotHoriDivider(size),
          _titleData(size, title: LN.salesSum),
          _underline(),
          _listTile(
            size,
            title: LN.grossSales,
            value:
                "$curSym${e.eodSalesSummaryViewModel?.totalGrossSales ?? '0.00'}"
                    .negPrice(),
          ),
          _listTile(
            size,
            title: LN.discounts,
            value:
                "-$curSym${e.eodSalesSummaryViewModel?.totalDiscount?.inDouble.abs() ?? '0.00'}",
          ),
          _listTile(
            size,
            title: LN.refunds,
            value:
                "-$curSym${e.eodSalesSummaryViewModel?.totalRefund?.inDouble.abs() ?? '0.00'}",
          ),
          _underline(),
          _listTile(
            size,
            title: LN.netSales,
            value: "$curSym${netSales.roundToNString()}".negPrice(),
            bold: true,
          ),
          _dotHoriDivider(size),
          _listTile(
            size,
            title: LN.giftSales,
            value:
                "$curSym${e.eodSalesSummaryViewModel?.totalGiftCardSales ?? '0.00'}"
                    .negPrice(),
          ),
          _listTile(
            size,
            title: LN.crCardSur,
            value:
                "$curSym${e.eodSalesSummaryViewModel?.totalCreditCardSurcharge ?? '0.00'}"
                    .negPrice(),
          ),
          _listTile(
            size,
            title: "Surcharge", // LN.publicHolidaySc,
            value:
                "$curSym${e.eodSalesSummaryViewModel?.totalHolidaySurcharge ?? '0.00'}"
                    .negPrice(),
          ),
          if ((e.eodSalesSummaryViewModel?.totalServiceCharge?.inDouble ?? 0) !=
              0)
            _listTile(
              size,
              title: "Service Charge", // LN.publicHolidaySc,
              value:
                  "$curSym${e.eodSalesSummaryViewModel?.totalServiceCharge ?? '0.00'}"
                      .negPrice(),
            ),
          _listTile(
            size,
            title: LN.deliCharge,
            value:
                "$curSym${e.eodSalesSummaryViewModel?.totalDeliveryCharge ?? '0.00'}"
                    .negPrice(),
          ),
          _listTile(
            size,
            title: LN.tip,
            value: "$curSym${e.eodSalesSummaryViewModel?.totalTip ?? '0.00'}"
                .negPrice(),
          ),
          _listTile(
            size,
            title: LN.totalTax,
            value: "$curSym${e.eodSalesSummaryViewModel?.totalTax ?? '0.00'}"
                .negPrice(),
          ),
          _underline(),
          _listTile(
            size,
            title: LN.total,
            value: "$curSym${total.roundToNString()}".negPrice(),
            bold: true,
          ),
          _dotHoriDivider(size),
          _listTile(
            size,
            title: LN.totalUnitSales,
            value: unitSales.roundToNString(),
            bold: true,
          ),
          _dotHoriDivider(size),
          _titleData(
            size,
            title: LN.salesChannel,
          ),
          _underline(),
          _listTile(
            size,
            title: LN.channel,
            unit: LN.unit,
            value: LN.amount,
            bold: true,
            isHeader: true,
          ),
          ...List.generate(e.eodSalesByChannelViewModel!.length, (i) {
            final f = e.eodSalesByChannelViewModel![i];
            tsByChannel += f.totalSales?.inDouble ?? 0;
            usByChannel += f.quantity?.inDouble ?? 0;
            return _listTile(
              size,
              title: f.channelName,
              unit: f.quantity,
              value: "$curSym${f.totalSales ?? '0.00'}",
            );
          }),
          _underline(),
          _listTile(
            size,
            title: LN.totalUnitSales,
            unit: usByChannel.roundToNString(),
            value: "$curSym${tsByChannel.roundToNString()}",
            bold: true,
          ),
          _dotHoriDivider(size),
          _titleData(
            size,
            title: LN.salesByCat,
          ),
          _underline(),
          _listTile(
            size,
            title: LN.category,
            unit: LN.unit,
            value: LN.sales,
            bold: true,
            isHeader: true,
          ),
          ...List.generate(e.eodSalesByCategoryViewModel!.length, (i) {
            final f = e.eodSalesByCategoryViewModel![i];
            tsByCat += f.totalSales?.inDouble ?? 0;
            usByCat += f.quantity?.inDouble ?? 0;
            return _listTile(
              size,
              title: f.categoryName,
              unit: f.quantity,
              value: "$curSym${f.totalSales ?? '0.00'}",
            );
          }),
          _underline(),
          _listTile(
            size,
            title: LN.total,
            unit: usByCat.roundToNString(),
            value: "$curSym${tsByCat.roundToNString()}",
            bold: true,
          ),
          _dotHoriDivider(size),
          _titleData(
            size,
            title: LN.salesByCatType,
          ),
          _underline(),
          _listTile(
            size,
            title: LN.catType,
            unit: LN.unit,
            value: LN.sales,
            bold: true,
            isHeader: true,
          ),
          ...List.generate(e.eodSalesByCategoryTypeViewModel!.length, (i) {
            final f = e.eodSalesByCategoryTypeViewModel![i];
            tsByCatType += f.totalSales?.inDouble ?? 0;
            usByCatType += f.quantity?.inDouble ?? 0;
            return _listTile(
              size,
              title: f.categoryTypeName,
              unit: f.quantity,
              value: "$curSym${f.totalSales ?? '0.00'}",
            );
          }),
          _underline(),
          _listTile(
            size,
            title: LN.total,
            unit: usByCatType.roundToNString(),
            value: "$curSym${tsByCatType.roundToNString()}",
            bold: true,
          ),
          _dotHoriDivider(size),
          _titleData(
            size,
            title: LN.payMethods,
          ),
          _underline(),
          ...List.generate(e.eodSalesByPaymentMethodViewModel!.length, (i) {
            final f = e.eodSalesByPaymentMethodViewModel![i];

            if (f.paymentMethodName?.toLowerCase().contains('gift') ?? false) {
              f.totalSales =
                  e.eodSalesReedemptionViewModel?.totalGiftCardReedemption;
            } else if (f.paymentMethodName?.toLowerCase().contains('loyal') ??
                false) {
              f.totalSales =
                  e.eodSalesReedemptionViewModel?.totalLoyaltyReedemption;
            }
            totalPayment += f.totalSales?.inDouble ?? 0;

            return _listTile(
              size,
              title: f.paymentMethodName,
              value: "$curSym${f.totalSales ?? '0.00'}",
              bold: true,
            );
          }),
          _underline(),
          _listTile(
            size,
            title: LN.totalPayment,
            value: "$curSym${totalPayment.roundToNString()}",
            bold: true,
          ),
          _dotHoriDivider(size),
          Builder(builder: (context) {
            final vari = totalPayment - total;
            return _listTile(
              size,
              title: LN.variance,
              value: "$curSym${vari.roundToNString()}".negPrice(),
              bold: true,
            );
          }),
          SizedBox(
            height: size.getH(32),
          ),
        ],
      ),
    );
  }

  static Widget _listTile(
    Ssize size, {
    String? title,
    String? unit,
    String? value,
    bool bold = false,
    bool isHeader = false,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: size.getH(8)),
      child: Row(
        children: [
          Expanded(
            flex: unit == null ? 3 : 2,
            child: Text(
              title ?? '',
              style: TextStyle(
                fontSize: size.getS(18),
                color: Colors.black,
                fontWeight: bold ? FontWeight.bold : null,
                height: 1.2,
                decoration: isHeader ? TextDecoration.underline : null,
              ),
              textAlign: TextAlign.left,
            ),
          ),
          if (unit != null)
            Expanded(
              flex: 1,
              child: Text(
                unit,
                style: TextStyle(
                  fontSize: size.getS(18),
                  color: Colors.black,
                  fontWeight: bold ? FontWeight.bold : null,
                  height: 1.2,
                  decoration: isHeader ? TextDecoration.underline : null,
                ),
                textAlign: TextAlign.right,
              ),
            ),
          Expanded(
            flex: 1,
            child: Text(
              value ?? '',
              style: TextStyle(
                fontSize: size.getS(18),
                color: Colors.black,
                fontWeight: bold ? FontWeight.bold : null,
                height: 1.2,
                decoration: isHeader ? TextDecoration.underline : null,
              ),
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }

  static Widget _titleData(
    Ssize size, {
    String? title,
    bool bold = true,
  }) {
    return Text(
      title ?? '',
      style: TextStyle(
        fontSize: size.getS(24),
        color: Colors.black,
        fontFamily: bold ? kFontFMedium : kFontFRegular,
        fontWeight: bold ? FontWeight.bold : null,
        height: 1.2,
      ),
      textAlign: TextAlign.center,
    );
  }

  static Widget _dotHoriDivider(Ssize size) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: size.getH(12)),
      child: Text(
        '---------------------------------------------------------------------------------------------------',
        maxLines: 1,
        textAlign: TextAlign.center,
      ),
    );
  }

  static Widget _underline() {
    return Divider(color: Colors.black54);
  }
}

class _EodReportViewState extends State<EodReportView> {
  GlobalKey? _receiptKey;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _getData();
    });
  }

  Future<void> _getData() async {
    final _eodPro = Provider.of<EodPro>(context, listen: false);
    if (mounted) {
      if (_eodPro.eodReportRes == null) return;
      await showDialog(
          context: context,
          builder: (ctx) {
            return ConfirmDialog(
              title: "${LN.printEod} ?",
              subTitle: LN.printEod,
              actionText: LN.print,
              onDelete: () async {
                final byte = await ImageService.capture(key: _receiptKey);
                await EodPrint.print(
                  eodReportRes: _eodPro.eodReportRes,
                  staticByte: byte,
                );
                return null;
              },
            );
          });
    }
  }

  // final _screenshotCltr = ScreenshotController();

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = Ssize(context);
    final eodPro = Provider.of<EodPro>(context);
    final e = eodPro.eodReportRes;
    if (e == null)
      return Card(
          child: Padding(
        padding: EdgeInsets.symmetric(horizontal: size.getW(8.0)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              LN.eodReport,
              style: TextStyle(
                fontSize: size.getS(24),
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
            Divider(
              color: Colors.black87,
            ),
            NoItemsSec(size: size, title: LN.eodReportNotFound),
          ],
        ),
      ));

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: size.getW(8.0)),
        child: Processing(
          loading: eodPro.eodPreviewLoad,
          child: SingleChildScrollView(
              child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: size.getH(4),
              ),
              Text(
                LN.eodReport,
                style: TextStyle(
                  fontSize: size.getS(24),
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: size.getH(4.0)),
                child: Divider(
                  color: Colors.black,
                  thickness: 1,
                ),
              ),
              Card(
                color: kPrimaryColor,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: size.getH(8.0)),
                  child: Column(
                    children: [
                      Container(
                        margin: EdgeInsets.symmetric(
                            vertical: size.getH(16.0),
                            horizontal: size.getW(16)),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10)),
                        child: WidgetToImage(builder: (key) {
                          _receiptKey = key;
                          return EodReportView.view(size,
                              e: e, curSym: widget.curSym);
                        }),
                      ),
                      PayReBottomSec(
                        downloadKey: _receiptKey,
                        receiptName: "EOD_REPORT",
                        loadFun: eodPro.eodPreviewLoad
                            ? null
                            : (bool val) {
                                if (val) {
                                  eodPro.eodPreviewLoad = true;
                                } else {
                                  eodPro.eodPreviewLoad = false;
                                }
                                eodPro.notify;
                              },
                        orderId: '',
                      ),
                      SizedBox(
                        height: size.getH(24),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          )),
        ),
      ),
    );
  }
}
