import 'package:flutter/material.dart';
import 'package:pos_account/model/home/menu/payment/eftpos/eftpos_merchant_log_res.dart';
import 'package:pos_account/model/ui_model/print_invoice.dart';

class InvoicePro extends ChangeNotifier {
  void get notify => notifyListeners();

  PrintInvoice? printInvoice;
  // PrintInvoice? printInvoiceSecond;

  final merchantInvoice = <List<PrintInvoice>>[];
  // final customerInvoice = <PrintInvoice>[];

  InvoiceType? invoiceType = InvoiceType.Payment;

  EftposMerchantLogRes? eftposMerchantLogRes;

  void clear() {
    printInvoice = null;
    invoiceType = InvoiceType.Payment;
    eftposMerchantLogRes = null;
    merchantInvoice.clear();
    // customerInvoice.clear();
  }

  // bool isOnInvoiceScreen = false;
}

enum InvoiceType {
  SendToKit,
  Payment,
  Refund,
  PaymentMerchant,
  RefundMerchant,
  ErrorMerchant
}
