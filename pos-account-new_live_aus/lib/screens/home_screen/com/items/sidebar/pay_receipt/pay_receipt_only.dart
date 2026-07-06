import 'package:flutter/material.dart';
import 'package:pos_account/config/size_config.dart';
import 'package:pos_account/config/validator.dart';
import 'package:pos_account/constant/constant.dart';
import 'package:pos_account/ln.dart';
import 'package:pos_account/model/home/menu/payment/make_pay_res.dart';
import 'package:pos_account/model/home/menu/payment/refund_pay_res.dart';
import 'package:pos_account/providers/common/invoice_pro.dart';
import 'package:pos_account/providers/menu/payment_pro.dart';
import 'package:pos_account/providers/setting/pos_device/printer_setting_pro.dart';
import 'package:pos_account/services/printer/com/invoice_print.dart';
import 'package:pos_account/services/printer/com/merchant_print.dart';
import 'package:pos_account/services/printer/com/refund_print.dart';
import 'package:pos_account/widgets/load_btn.dart';
import 'package:pos_account/widgets/loading.dart';
import 'package:provider/provider.dart';
import 'com/email_dia.dart';
import 'pay_receipt.dart';

class PayReceiptOnly extends StatefulWidget {
  const PayReceiptOnly({
    super.key,
  });

  static PaySummary? paySummary;

  @override
  State<PayReceiptOnly> createState() => _PayReceiptOnlyState();
}

class _PayReceiptOnlyState extends State<PayReceiptOnly> {
  GlobalKey? _receiptKey;

  InvoicePro? invoicePro;

  static Future<void> autoPrintInvoice({
    MakePaymentRes? paymentRes,
    ReceiptType receiptType = ReceiptType.Payment,
    bool isCashPayment = false,
  }) async {
    if (paymentRes?.isPaymentCompleted == null ||
        !paymentRes!.isPaymentCompleted!) return;

    if (!(paymentRes.askForPrintConfirmation ?? false)) {
      await InvoicePrint.pRprintInvoice(
        paymentRes: paymentRes,
        receiptType: receiptType,
        isCashPayment: isCashPayment,
      );
    }
  }

  static Future<void> autoPrintRefundInvoice({
    RefundPaymentRes? refundRes,
    bool isCashPayment = false,
  }) async {
    if (refundRes == null) return;

    if (!(refundRes.askForPrintConfirmation ?? false)) {
      await RefundPrint.pRprintReundInvoice(
        refundRes: refundRes,
        isCashPayment: isCashPayment,
      );
    }
  }

  @override
  void initState() {
    super.initState();
    invoicePro = Provider.of<InvoicePro>(context, listen: false);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      load();

      if (invoicePro?.invoiceType == InvoiceType.Refund) {
        autoPrintRefundInvoice(
            refundRes: payPro.refundPaymentRes,
            isCashPayment: payPro.PAY_METHOD == PayMethodEnum.Cash);
      } else {
        autoPrintInvoice(
            paymentRes: payPro.makePaymentRes,
            isCashPayment: payPro.PAY_METHOD == PayMethodEnum.Cash);
      }

      if (PayReceiptOnly.paySummary?.payMethod == PayMethodEnum.Cash) {
        final _printSettingPro =
            Provider.of<PrinterSettingPro>(context, listen: false);
        _printSettingPro.openCashDrawer();
      }
    });
  }

  void load() {
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    if (invoicePro != null) {
      invoicePro?.clear();
    }
    payPro.orderDetailById = null;
    super.dispose();
  }

  late PaymentPro payPro;

  bool printing = false;

  Future<void> _printInvoice() async {
    printing = true;
    load();
    // to print invoice from thermal printer
    if (invoicePro?.invoiceType == InvoiceType.Payment)
      await InvoicePrint.pRprintInvoice(
          paymentRes: payPro.makePaymentRes,
          isCashPayment: payPro.PAY_METHOD == PayMethodEnum.Cash);
    else if (invoicePro?.invoiceType == InvoiceType.Refund)
      await RefundPrint.pRprintReundInvoice(
          refundRes: payPro.refundPaymentRes,
          isCashPayment: payPro.PAY_METHOD == PayMethodEnum.Cash);

    printing = false;
    load();
  }

  MerchantDetails? _printReceipt;

  Future<void> _printMxReceipt({required MerchantDetails invoiceData}) async {
    final _printMerchant = invoicePro?.invoiceType == InvoiceType.Refund
        ? payPro
            .refundPaymentRes?.printingMerchantInvoiceDetailsResponseViewModels
        : payPro
            .makePaymentRes?.printingMerchantInvoiceDetailsResponseViewModels;

    if (_printMerchant == null) return;

    _printReceipt = invoiceData;
    payPro.notify;

    for (final a in _printMerchant) {
      final _pIMx = MerchantPrint.cIPrintMerchant(a, invoiceData: invoiceData);

      await MerchantPrint.printMerchant(pI: _pIMx);
    }
    _printReceipt = null;
    payPro.notify;
  }

  @override
  Widget build(BuildContext context) {
    final _pI = invoicePro?.printInvoice;

    payPro = Provider.of<PaymentPro>(context);

    final size = Ssize(context);

    final _paySummary = PayReceiptOnly.paySummary;

    final _returnAmount = (_paySummary?.paidAmountByUser.inDouble ?? 0.0) -
        (_paySummary?.totalAmount.inDouble ?? 0);

    final _returnAmountText = invoicePro?.invoiceType == InvoiceType.Payment &&
            _paySummary?.payMethod == PayMethodEnum.Cash
        ? (payPro.curSym ?? '') +
            (_returnAmount <= 0 ? "0.00" : _returnAmount.roundToNString())
        : null;

    final _merchantReceipt = invoicePro?.invoiceType == InvoiceType.Refund
        ? (payPro.refundPaymentRes
                ?.printingMerchantInvoiceDetailsResponseViewModels
                ?.map((e) => e.merchantInvoiceData ?? '')
                .toList() ??
            [])
        : (payPro.makePaymentRes
                ?.printingMerchantInvoiceDetailsResponseViewModels
                ?.map((e) => e.merchantInvoiceData ?? '')
                .toList() ??
            []);

    final _customerReceipt = invoicePro?.invoiceType == InvoiceType.Refund
        ? (payPro.refundPaymentRes
                ?.printingMerchantInvoiceDetailsResponseViewModels
                ?.map((e) => e.customerInvoiceData ?? '')
                .toList() ??
            [])
        : (payPro.makePaymentRes
                ?.printingMerchantInvoiceDetailsResponseViewModels
                ?.map((e) => e.customerInvoiceData ?? '')
                .toList() ??
            []);

    return Card(
      // color: kBackgroundColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Processing(
        loading: payPro.loadingInvoice,
        child: Row(
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.01),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: size.getW(24.0)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: size.getH(8)),
                      Text(
                        invoicePro?.invoiceType == InvoiceType.Refund
                            ? "REFUND SUMMARY"
                            : "PAYMENT SUMMARY",
                        style: TextStyle(
                          fontSize: size.getS(24),
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: size.getH(8.0)),
                        child: Divider(
                          color: Colors.black26,
                          thickness: 1,
                        ),
                      ),
                      SizedBox(height: size.getH(12)),

                      // Payment completed status
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: size.getW(12),
                          vertical: size.getH(8),
                        ),
                        decoration: BoxDecoration(
                            color: Colors.green[50],
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: Colors.green.shade100,
                            )),
                        child: Row(
                          children: [
                            Container(
                              width: size.getS(12),
                              height: size.getS(12),
                              decoration: BoxDecoration(
                                color: Colors.green[500],
                                shape: BoxShape.circle,
                              ),
                            ),
                            SizedBox(width: size.getW(8)),
                            Text(
                              invoicePro?.invoiceType == InvoiceType.Refund
                                  ? 'Refund Completed'
                                  : 'Payment Completed',
                              style: TextStyle(
                                fontSize: size.getS(20),
                                fontFamily: kFontFMedium,
                                fontWeight: FontWeight.w500,
                                color: Colors.green[700],
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: size.getH(24)),

                      // Total amount
                      Text(
                        LN.totalAmount,
                        style: TextStyle(
                          fontSize: size.getS(20),
                          color: Colors.grey.shade700,
                        ),
                      ),
                      SizedBox(height: size.getH(4)),
                      Text(
                        '${invoicePro?.invoiceType == InvoiceType.Refund ? '-' : ''}${payPro.curSym}${_paySummary?.totalAmount ?? '0.00'}',
                        style: TextStyle(
                          fontSize: size.getS(32),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      if (_returnAmountText != null) ...[
                        SizedBox(height: size.getH(12)),

                        // Divider
                        Divider(),
                        SizedBox(height: size.getH(12)),

                        // Return amount
                        Text(
                          'Change Amount to Customer',
                          style: TextStyle(
                            fontSize: size.getS(20),
                            color: Colors.grey.shade700,
                          ),
                        ),
                        SizedBox(height: size.getH(4)),
                        Text(
                          _returnAmountText,
                          style: TextStyle(
                            fontSize: size.getS(32),
                            fontWeight: FontWeight.bold,
                            color: Colors.green.shade700,
                          ),
                        )
                      ],
                      SizedBox(height: size.getH(12)),

                      // Divider
                      Divider(),
                      SizedBox(height: size.getH(12)),

                      // Action buttons
                      LoadButton(
                        btnText: LN.print,
                        loading: printing,
                        loadingText: LN.printing,
                        width: 400,
                        fontSize: 18,
                        onsave: _printInvoice,
                        textColor: Colors.white,
                        icon: Padding(
                          padding: EdgeInsets.only(right: size.getW(12)),
                          child: Icon(
                            Icons.print_outlined,
                            size: size.getW(24),
                            color: Colors.white,
                          ),
                        ),
                        btnColor: Colors.red.shade700,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5),
                        ),
                      ),

                      if (_merchantReceipt.any((a) => a.isNotEmpty))
                        Padding(
                          padding: EdgeInsets.only(top: size.getH(12)),
                          child: LoadButton(
                            btnText: "Print Merchant Receipt",
                            loading: _printReceipt == MerchantDetails.Merchant,
                            loadingText: LN.printing,
                            width: 400,
                            fontSize: 18,
                            onsave: () {
                              _printMxReceipt(
                                  invoiceData: MerchantDetails.Merchant);
                            },
                            textColor: kSecondaryColor,
                            icon: Padding(
                              padding: EdgeInsets.only(right: size.getW(12)),
                              child: Icon(
                                Icons.print_outlined,
                                size: size.getW(24),
                                color: kSecondaryColor,
                              ),
                            ),
                            btnColor: Colors.white,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5),
                                side: BorderSide(color: kSecondaryColor)),
                          ),
                        ),

                      if (_customerReceipt.any((a) => a.isNotEmpty))
                        Padding(
                          padding: EdgeInsets.only(top: size.getH(12)),
                          child: LoadButton(
                            btnText: "Print Customer Receipt",
                            loading: _printReceipt == MerchantDetails.Customer,
                            loadingText: LN.printing,
                            width: 400,
                            fontSize: 18,
                            onsave: () {
                              _printMxReceipt(
                                  invoiceData: MerchantDetails.Customer);
                            },
                            textColor: kSecondaryColor,
                            icon: Padding(
                              padding: EdgeInsets.only(right: size.getW(12)),
                              child: Icon(
                                Icons.print_outlined,
                                size: size.getW(24),
                                color: kSecondaryColor,
                              ),
                            ),
                            btnColor: Colors.white,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5),
                                side: BorderSide(color: kSecondaryColor)),
                          ),
                        ),

                      SizedBox(height: size.getH(12)),

                      LoadButton(
                        btnText: LN.email,
                        width: 400,
                        fontSize: 18,
                        onsave: () {
                          payPro.loadEmail = true;
                          payPro.clearEmailData();
                          payPro.notify;
                          payPro.setEmailData(
                              email: payPro.orderDetailById
                                      ?.customerUserViewModel?.email ??
                                  '',
                              cusName: payPro.orderDetailById
                                  ?.customerUserViewModel?.name);
                          // payPro
                          //     .getPayDetailInvoice(
                          //         orderId: payPro.makePaymentRes?.orderId)
                          //     .then((_) => payPro.setEmailData());
                          showDialog(
                              context: context,
                              builder: (builder) => SimpleDialog(
                                    titlePadding: EdgeInsets.zero,
                                    contentPadding: EdgeInsets.symmetric(
                                        horizontal: 24, vertical: 24),
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(15)),
                                    children: [
                                      DoEmailDia(
                                          orderId:
                                              payPro.makePaymentRes?.orderId)
                                    ],
                                  ));
                        },
                        textColor: Colors.white,
                        icon: Padding(
                          padding: EdgeInsets.only(right: size.getW(12)),
                          child: Icon(
                            Icons.email,
                            size: size.getW(24),
                            color: Colors.white,
                          ),
                        ),
                        btnColor: kPrimaryColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5),
                        ),
                      ),
                      // SizedBox(height: size.getH(12)),
                      // LoadButton(
                      //   btnText: LN.download,
                      //   width: 400,
                      //   fontSize: 18,
                      //   onsave: () {},
                      //   textColor: Colors.black,
                      //   icon: Padding(
                      //     padding: EdgeInsets.only(right: size.getW(12)),
                      //     child: Icon(
                      //       Icons.download_outlined,
                      //       size: size.getW(24),
                      //       color: Colors.black,
                      //     ),
                      //   ),
                      //   btnColor: Colors.white,
                      //   shape: RoundedRectangleBorder(
                      //     borderRadius: BorderRadius.circular(5),
                      //     side: BorderSide(color: Colors.black26),
                      //   ),
                      // ),
                    ],
                  ),
                ),
              ),
            ),
            // SizedBox(
            //     height: double.maxFinite,
            //     child: VerticalDivider(
            //       color: Colors.black26,
            //     )),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: size.getW(24.0)),
              child: SizedBox(
                width: size.getW(424),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: size.getH(8)),
                    Text(
                      (invoicePro?.invoiceType == InvoiceType.Refund
                              ? LN.refundReceipt
                              : LN.payReceipt)
                          .toUpperCase(),
                      style: TextStyle(
                        fontSize: size.getS(24),
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: size.getH(8.0)),
                      child: Divider(
                        color: Colors.black26,
                        thickness: 1,
                      ),
                    ),
                    if (_pI != null)
                      Flexible(
                        child: SingleChildScrollView(
                          child: PayReceipt.receiptSection(size,
                              pI: _pI,
                              receiptKey: _receiptKey,
                              backColor: Colors.black12,
                              padding: EdgeInsets.zero,
                              margin: EdgeInsets.zero,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  side: BorderSide(
                                    color: Colors.black26,
                                  ))),
                        ),
                      )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
