import 'package:flutter/material.dart';
import 'package:pos_account/config/size_config.dart';
import 'package:pos_account/constant/constant.dart';
import 'package:pos_account/ln.dart';
import 'package:pos_account/model/ui_model/print_invoice.dart';
import 'package:pos_account/providers/common/invoice_pro.dart';
import 'package:pos_account/providers/menu/payment_pro.dart';
import 'package:pos_account/screens/home_screen/com/items/sidebar/pay_receipt/com/widget_to_image.dart';
import 'package:pos_account/services/printer/com/merchant_print.dart';
import 'package:pos_account/widgets/dashline_widget.dart';
import 'package:pos_account/widgets/loading.dart';
import 'package:pos_account/widgets/no_items_sec.dart';
import 'package:provider/provider.dart';
import 'com/bottom_sec.dart';

class PayReceipt extends StatefulWidget {
  const PayReceipt({
    super.key,
  });

  @override
  State<PayReceipt> createState() => _PayReceiptState();

  static Widget receiptSection(
    Ssize size, {
    required PrintInvoice pI,
    required GlobalKey<State<StatefulWidget>>? receiptKey,
    Widget? bottomWidget,
    Color backColor = kPrimaryColor,
    EdgeInsetsGeometry? padding,
    EdgeInsetsGeometry? margin,
    ShapeBorder? shape,
  }) {
    final _pI = pI;

    padding ??= EdgeInsets.symmetric(
        vertical: size.getH(8.0), horizontal: size.getW(12));

    margin ??= EdgeInsets.symmetric(
        vertical: size.getH(16.0), horizontal: size.getW(16));

    shape ??= RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(10), topRight: Radius.circular(10)));

    return Card(
      color: backColor,
      margin: EdgeInsets.zero,
      elevation: 10,
      shape: shape,
      child: SizedBox(
        width: double.infinity,
        child: Padding(
          padding: padding,
          child: Column(
            children: [
              Container(
                margin: margin,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10)),
                padding: EdgeInsets.symmetric(
                    vertical: size.getH(12.0), horizontal: size.getW(12)),
                child: WidgetToImage(builder: (key) {
                  receiptKey = key;
                  return Container(
                    decoration: BoxDecoration(color: Colors.white),
                    padding: EdgeInsets.symmetric(
                        vertical: size.getH(0.0), horizontal: size.getW(0)),
                    width: double.infinity,
                    child: Column(
                      children: [
                        SizedBox(
                          height: size.getH(12),
                        ),
                        if (_pI.title != null)
                          Text(
                            _pI.title!,
                            style: TextStyle(
                              fontSize: size.getS(28),
                              color: Colors.black,
                              fontFamily: kFontFMedium,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        if (_pI.subtitle != null)
                          Text(
                            _pI.subtitle!,
                            style: TextStyle(
                              fontSize: size.getS(14),
                              color: Colors.black,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        if (_pI.subtitleList != null)
                          for (final e in _pI.subtitleList!)
                            Text(
                              e.text,
                              style: TextStyle(
                                fontSize: size.getS(14),
                                color: Colors.black,
                                fontWeight: e.style == PrinterTextStyle.Bold
                                    ? FontWeight.bold
                                    : null,
                              ),
                              textAlign: TextAlign.center,
                            ),
                        SizedBox(
                          height: size.getH(24),
                        ),
                        if (_pI.body?.header != null)
                          for (final e in _pI.body!.header!)
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  flex: 8,
                                  child: Text(
                                    e.title ?? '',
                                    style: TextStyle(
                                        fontSize:
                                            size.getS(e.size == 1 ? 14 : 15),
                                        color: Colors.black,
                                        fontWeight:
                                            e.bold ? FontWeight.bold : null),
                                  ),
                                ),
                                if (e.body1 != null)
                                  Expanded(
                                    flex: 4,
                                    child: Align(
                                      alignment: Alignment.centerRight,
                                      child: Text(
                                        e.body1!,
                                        style: TextStyle(
                                          fontSize: size.getS(14),
                                          color: Colors.black,
                                        ),
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                        Padding(
                          padding:
                              EdgeInsets.symmetric(vertical: size.getH(8.0)),
                          child: HDashDivider(
                            dashWidth: 6,
                          ),
                        ),
                        if (_pI.body?.item != null)
                          for (final a in _pI.body!.item!) ...[
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  flex: 7,
                                  child: Text(
                                    a.itemHeader?.title ?? '',
                                    style: TextStyle(
                                      fontSize: size.getS(14),
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 2,
                                  child: Align(
                                    alignment: Alignment.centerRight,
                                    child: Text(
                                      a.itemHeader?.body2 ?? '',
                                      style: TextStyle(
                                        fontSize: size.getS(14),
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 3,
                                  child: Align(
                                    alignment: Alignment.centerRight,
                                    child: Text(
                                      a.itemHeader?.body3 ?? '',
                                      style: TextStyle(
                                        fontSize: size.getS(14),
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            if (a.itemBody != null)
                              for (final b in a.itemBody!)
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      flex: b.body2._hasData ? 7 : 9,
                                      child: Text(
                                        b.title ?? '',
                                        style: b.body2._hasData
                                            ? TextStyle(
                                                fontSize: size.getS(14),
                                                color: Colors.black,
                                                fontWeight: b.bold
                                                    ? FontWeight.bold
                                                    : null,
                                              )
                                            : TextStyle(
                                                fontSize: size.getS(20),
                                                color: Colors.black,
                                                fontFamily: kFontFMedium,
                                              ),
                                      ),
                                    ),
                                    if (b.body2._hasData)
                                      Expanded(
                                        flex: 2,
                                        child: Align(
                                          alignment: Alignment.centerRight,
                                          child: Text(
                                            b.body2 ?? '',
                                            style: TextStyle(
                                              fontSize: size.getS(14),
                                              color: Colors.black,
                                            ),
                                          ),
                                        ),
                                      ),
                                    Expanded(
                                      flex: 3,
                                      child: Align(
                                        alignment: Alignment.centerRight,
                                        child: Text(
                                          b.body3 ?? '',
                                          style: b.body2._hasData
                                              ? TextStyle(
                                                  fontSize: size.getS(14),
                                                  color: Colors.black,
                                                )
                                              : TextStyle(
                                                  fontSize: size.getS(20),
                                                  color: Colors.black,
                                                  fontFamily: kFontFMedium,
                                                ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                            Padding(
                              padding: EdgeInsets.symmetric(
                                  vertical: size.getH(8.0)),
                              child: HDashDivider(
                                dashWidth: 6,
                              ),
                            ),
                          ],
                        if (_pI.body?.itemFooter != null)
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                flex: 8,
                                child: Text(
                                  _pI.body?.itemFooter?.title ?? '',
                                  style: TextStyle(
                                    fontSize: size.getS(18),
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 4,
                                child: Align(
                                  alignment: Alignment.centerRight,
                                  child: Text(
                                    _pI.body?.itemFooter?.body2 ?? '',
                                    style: TextStyle(
                                      fontSize: size.getS(18),
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        if (_pI.body?.itemFooter != null)
                          Padding(
                            padding:
                                EdgeInsets.symmetric(vertical: size.getH(8.0)),
                            child: Column(
                              children: [
                                HDashDivider(
                                  dashWidth: 6,
                                  strokeWidth: 0.7,
                                ),
                                SizedBox(
                                  height: size.getH(3),
                                ),
                                HDashDivider(
                                  dashWidth: 6,
                                  strokeWidth: 0.7,
                                )
                              ],
                            ),
                          ),
                        if (_pI.body?.footer != null)
                          for (final e in _pI.body!.footer!)
                            if (e.isDivider)
                              Padding(
                                padding: EdgeInsets.symmetric(
                                    vertical: size.getH(8.0)),
                                child: HDashDivider(
                                  dashWidth: 6,
                                  strokeWidth: 0.7,
                                ),
                              )
                            else
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    flex: 8,
                                    child: Align(
                                      alignment: e.alignRight
                                          ? Alignment.centerRight
                                          : Alignment.centerLeft,
                                      child: Text(
                                        e.title ?? '',
                                        style: TextStyle(
                                          fontSize: size.getS(14),
                                          fontWeight:
                                              e.bold ? FontWeight.bold : null,
                                          color: Colors.black,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 4,
                                    child: Align(
                                      alignment: Alignment.centerRight,
                                      child: Text(
                                        e.body1 ?? '',
                                        style: TextStyle(
                                          fontSize: size.getS(14),
                                          color: Colors.black,
                                          fontWeight:
                                              e.bold ? FontWeight.bold : null,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                        SizedBox(
                          height: size.getH(24),
                        ),
                        if (_pI.footerList != null)
                          for (final e in _pI.footerList!)
                            if (e != null)
                              Text(
                                e,
                                style: TextStyle(
                                  fontSize: size.getS(13),
                                  color: Colors.black,
                                  fontWeight: FontWeight.w600,
                                ),
                                maxLines: 2,
                                textAlign: TextAlign.center,
                              ),
                      ],
                    ),
                  );
                }),
              ),
              if (bottomWidget != null) ...[
                SizedBox(
                  height: size.getH(24),
                ),
                bottomWidget,
                SizedBox(
                  height: size.getH(24),
                )
              ],
            ],
          ),
        ),
      ),
    );
  }

  static Widget invoiceWidget({
    required PrintInvoice pI,
  }) {
    final _pI = pI;

    return Container(
      decoration: const BoxDecoration(color: Colors.white),
      width: 560,
      child: Column(
        children: [
          SizedBox(
            height: 12.h,
          ),
          if (_pI.title != null)
            Text(
              _pI.title!,
              style: TextStyle(
                fontSize: 28.sp,
                color: Colors.black,
                fontFamily: kFontFMedium,
              ),
              textAlign: TextAlign.center,
            ),
          if (_pI.subtitle != null)
            Text(
              _pI.subtitle!,
              style: TextStyle(
                fontSize: 14.sp,
                color: Colors.black,
              ),
              textAlign: TextAlign.center,
            ),
          if (_pI.subtitleList != null)
            for (final e in _pI.subtitleList!)
              Text(
                e.text,
                style: TextStyle(
                  fontSize: 14.sp,
                  color: Colors.black,
                  fontWeight:
                      e.style == PrinterTextStyle.Bold ? FontWeight.bold : null,
                ),
                textAlign: TextAlign.center,
              ),
          SizedBox(
            height: 24.h,
          ),
          if (_pI.body?.header != null)
            for (final e in _pI.body!.header!)
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 8,
                    child: Text(
                      e.title ?? '',
                      style: TextStyle(
                          fontSize: (e.size == 1 ? 14 : 15).sp,
                          color: Colors.black,
                          fontWeight: e.bold ? FontWeight.bold : null),
                    ),
                  ),
                  if (e.body1 != null)
                    Expanded(
                      flex: 4,
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: Text(
                          e.body1!,
                          style: TextStyle(
                            fontSize: 14.sp,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 8.h),
            child: const HDashDivider(
              dashWidth: 6,
            ),
          ),
          if (_pI.body?.item != null)
            for (final a in _pI.body!.item!) ...[
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 7,
                    child: Text(
                      a.itemHeader?.title ?? '',
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                        a.itemHeader?.body2 ?? '',
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 3,
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                        a.itemHeader?.body3 ?? '',
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              if (a.itemBody != null)
                for (final b in a.itemBody!)
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: b.body2._hasData ? 7 : 9,
                        child: Text(
                          b.title ?? '',
                          style: b.body2._hasData
                              ? TextStyle(
                                  fontSize: 14.sp,
                                  color: Colors.black,
                                  fontWeight: b.bold ? FontWeight.bold : null,
                                )
                              : TextStyle(
                                  fontSize: 20.sp,
                                  color: Colors.black,
                                  fontFamily: kFontFMedium,
                                ),
                        ),
                      ),
                      if (b.body2._hasData)
                        Expanded(
                          flex: 2,
                          child: Align(
                            alignment: Alignment.centerRight,
                            child: Text(
                              b.body2 ?? '',
                              style: TextStyle(
                                fontSize: 14.sp,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ),
                      Expanded(
                        flex: 3,
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: Text(
                            b.body3 ?? '',
                            style: b.body2._hasData
                                ? TextStyle(
                                    fontSize: 14.sp,
                                    color: Colors.black,
                                  )
                                : TextStyle(
                                    fontSize: 20.sp,
                                    color: Colors.black,
                                    fontFamily: kFontFMedium,
                                  ),
                          ),
                        ),
                      ),
                    ],
                  ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 8.h),
                child: const HDashDivider(
                  dashWidth: 6,
                ),
              ),
            ],
          if (_pI.body?.itemFooter != null)
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 8,
                  child: Text(
                    _pI.body?.itemFooter?.title ?? '',
                    style: TextStyle(
                      fontSize: 18.sp,
                      color: Colors.black,
                    ),
                  ),
                ),
                Expanded(
                  flex: 4,
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      _pI.body?.itemFooter?.body2 ?? '',
                      style: TextStyle(
                        fontSize: 18.sp,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          if (_pI.body?.itemFooter != null)
            Padding(
              padding: EdgeInsets.symmetric(vertical: 8.h),
              child: Column(
                children: [
                  const HDashDivider(
                    dashWidth: 6,
                    strokeWidth: 0.7,
                  ),
                  SizedBox(
                    height: 3.h,
                  ),
                  const HDashDivider(
                    dashWidth: 6,
                    strokeWidth: 0.7,
                  )
                ],
              ),
            ),
          if (_pI.body?.footer != null)
            for (final e in _pI.body!.footer!)
              if (e.isDivider)
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 8.h),
                  child: const HDashDivider(
                    dashWidth: 6,
                    strokeWidth: 0.7,
                  ),
                )
              else
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 8,
                      child: Align(
                        alignment: e.alignRight
                            ? Alignment.centerRight
                            : Alignment.centerLeft,
                        child: Text(
                          e.title ?? '',
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: e.bold ? FontWeight.bold : null,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 4,
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: Text(
                          e.body1 ?? '',
                          style: TextStyle(
                            fontSize: 14.sp,
                            color: Colors.black,
                            fontWeight: e.bold ? FontWeight.bold : null,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
          SizedBox(
            height: 24.h,
          ),
          if (_pI.footerList != null)
            for (final e in _pI.footerList!)
              if (e != null)
                Text(
                  e,
                  style: TextStyle(
                    fontSize: 13.sp,
                    color: Colors.black,
                    fontWeight: FontWeight.w600,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 3,
                ),
        ],
      ),
    );
  }
}

class _PayReceiptState extends State<PayReceipt> {
  GlobalKey? _receiptKey;

  InvoicePro? invoicePro;

  @override
  void initState() {
    invoicePro = Provider.of<InvoicePro>(context, listen: false);
    // if (invoicePro != null)
    Future.delayed(Duration(milliseconds: 500), () {
      if (mounted) setState(() {});
    });

    // printViaBluetooth();
    super.initState();
  }

  @override
  void dispose() {
    if (invoicePro != null) {
      invoicePro?.clear();
    }
    super.dispose();
  }

  _printMerchant({
    required MerchantDetails invoiceData,
    InvoiceType? invoiceType,
    required PrintInvoice printInvoice,
  }) {
    if (invoiceType == InvoiceType.PaymentMerchant)
      MerchantPrint.spdPosMerchant(context,
          askForPrintConfirmation:
              payPro.makePaymentRes?.askForPrintConfirmation,
          invoiceData: invoiceData,
          pI: printInvoice);
    else if (invoiceType == InvoiceType.RefundMerchant)
      MerchantPrint.spdPosMerchant(context,
          askForPrintConfirmation:
              payPro.refundPaymentRes?.askForPrintConfirmation,
          invoiceData: invoiceData,
          pI: printInvoice);
    else if (invoiceType == InvoiceType.ErrorMerchant)
      MerchantPrint.printMerchant(
        pI: printInvoice,
      );
  }

  late PaymentPro payPro;

  @override
  Widget build(BuildContext context) {
    final _pI = invoicePro?.printInvoice;
    final _merchantInvoice = invoicePro?.merchantInvoice;

    payPro = Provider.of<PaymentPro>(context);

    final size = Ssize(context);

    final _isReceipt = _pI != null &&
        (invoicePro?.invoiceType == InvoiceType.Payment ||
            invoicePro?.invoiceType == InvoiceType.Refund ||
            invoicePro?.invoiceType == InvoiceType.SendToKit);

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: size.getW(24.0)),
        child: Processing(
          loading: payPro.loadingInvoice,
          child: Column(
            children: [
              Flexible(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      invoicePro?.invoiceType == InvoiceType.Payment
                          ? LN.payReceipt
                          : invoicePro?.invoiceType == InvoiceType.SendToKit
                              ? LN.sendToKit
                              : invoicePro?.invoiceType == InvoiceType.Refund
                                  ? LN.refundReceipt
                                  : invoicePro?.invoiceType ==
                                          InvoiceType.PaymentMerchant
                                      ? LN.purchaseReceipt
                                      : invoicePro?.invoiceType ==
                                              InvoiceType.RefundMerchant
                                          ? LN.refundReceipt
                                          : "EFTPOS Logs",
                      style: TextStyle(
                        fontSize: size.getS(24),
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: size.getH(8.0)),
                      child: Divider(
                        color: Colors.black,
                        thickness: 1,
                      ),
                    ),
                    Flexible(
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (_isReceipt)
                              PayReceipt.receiptSection(size,
                                  pI: _pI, receiptKey: _receiptKey)
                            else if (_merchantInvoice != null) ...[
                              if (_merchantInvoice.isNotEmpty)
                                ...List.generate(_merchantInvoice.length, (i) {
                                  return Column(
                                    // crossAxisAlignment:
                                    //     CrossAxisAlignment.start,
                                    children: [
                                      if (i != 0) ...[
                                        SizedBox(height: size.getH(24)),
                                        Divider(
                                          color: Colors.black,
                                          thickness: 1,
                                        ),
                                        SizedBox(height: size.getH(12)),
                                      ],
                                      Text(
                                        LN.merchantCopy,
                                        style: TextStyle(
                                          fontSize: size.getS(20),
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      // Divider(
                                      //   color: Colors.black,
                                      //   thickness: 1,
                                      // ),
                                      SizedBox(height: size.getH(12)),
                                      PayReceipt.receiptSection(size,
                                          pI: _merchantInvoice[i].first,
                                          bottomWidget: _eleButton(size,
                                              onTap: () => _printMerchant(
                                                    invoiceData: MerchantDetails
                                                        .Merchant,
                                                    invoiceType:
                                                        invoicePro?.invoiceType,
                                                    printInvoice:
                                                        _merchantInvoice[i]
                                                            .first,
                                                  )),
                                          receiptKey: _receiptKey),
                                      SizedBox(height: size.getH(18)),
                                      Text(
                                        LN.customerCopy,
                                        style: TextStyle(
                                          fontSize: size.getS(20),
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      // Divider(
                                      //   color: Colors.black,
                                      //   thickness: 1,
                                      // ),
                                      SizedBox(height: size.getH(12)),
                                      PayReceipt.receiptSection(size,
                                          pI: _merchantInvoice[i].last,
                                          bottomWidget: _eleButton(size,
                                              onTap: () => _printMerchant(
                                                    invoiceData: MerchantDetails
                                                        .Customer,
                                                    invoiceType:
                                                        invoicePro?.invoiceType,
                                                    printInvoice:
                                                        _merchantInvoice[i]
                                                            .last,
                                                  )),
                                          receiptKey: _receiptKey)
                                    ],
                                  );
                                })
                              else
                                NoItemsSec(
                                    size: size,
                                    title: invoicePro
                                            ?.eftposMerchantLogRes?.message ??
                                        "No Receipt Found")
                            ]
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              if (_isReceipt)
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(vertical: size.getH(12)),
                  decoration: BoxDecoration(
                      color: kPrimaryColor,
                      borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(10),
                          bottomRight: Radius.circular(10))),
                  child: PayReBottomSec(
                    downloadKey: _receiptKey,
                    receiptName: invoicePro?.invoiceType == InvoiceType.Refund
                        ? "REFUND_RECEIPT"
                        : "PAYMENT_RECEIPT",
                    loadFun: payPro.loadingInvoice
                        ? null
                        : (bool val) {
                            if (val) {
                              payPro.loadingInvoice = true;
                            } else {
                              payPro.loadingInvoice = false;
                            }
                            payPro.notify;
                          },
                    getEmailDetail: () {
                      payPro.loadEmail = true;
                      payPro.clearEmailData();
                      payPro.notify;
                      payPro.setEmailData(
                          email: payPro.orderDetailById?.customerUserViewModel
                                  ?.email ??
                              '',
                          cusName: payPro
                              .orderDetailById?.customerUserViewModel?.name);
                      // payPro
                      //     .getPayDetailInvoice(
                      //         orderId: payPro.makePaymentRes?.orderId)
                      //     .then((_) => payPro.setEmailData());
                    },
                    orderId: payPro.makePaymentRes?.orderId,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _eleButton(Ssize size, {Function()? onTap}) {
    return ElevatedButton(
        style:
            ButtonStyle(backgroundColor: MaterialStateProperty.all(kTempColor)),
        onPressed: onTap,
        child: Text(
          LN.printReceipt,
          style: TextStyle(
            fontSize: size.getS(16),
            color: Colors.white,
            fontFamily: kFontFMedium,
          ),
        ));
  }
}

extension BoolExtension on String? {
  bool get _hasData {
    return this != null && this!.isNotEmpty;
  }
}

extension DoubleExtension on int {
  double get h => this * 2;
  double get sp => this * 2;
}
