import 'package:flutter/material.dart';
import 'package:pos_account/model/home/setting/payment_method/get_all_pay_method.dart';
import 'package:pos_account/model/home/setting/payment_method/pay_method_model.dart';
import 'package:pos_account/repository/handler.dart';

class PayMethodPro extends ChangeNotifier {
  bool loading = true;
  bool updateLoad = false;

  GetAllPaymentMethod? getAllPaymentMethod;

  void get notify => notifyListeners();

  Future<void> getAllPayMethod() async {
    getAllPaymentMethod = await Handler.getAllPayMethod();
    loading = false;
    notify;
  }

  Future<void> addUpPayMethod() async {
    if (getAllPaymentMethod == null) return;
    updateLoad = true;
    notify;

    final payModel = <PayMethodModel>[];
    for (final e in getAllPaymentMethod!.data!) {
      payModel.add(PayMethodModel(
        id: e.id,
        isActive: e.isActive,
        surchargePercentage: e.surchargePercentage?.text,
        enableSurcharge: e.enableSurcharge,
        paymentCredentials: PaymentCredentials(
          keyOrId: e.paymentCredentials?.keyOrId,
          secret: e.paymentCredentials?.secret,
          // stripeConnectedId: e.paymentCredentials?.stripeConnectedId,
        ),
      ));
    }

    final status = await Handler.addUpPayMethod(payMethod: payModel);
    if (status ?? false) {}

    updateLoad = false;
    notify;
  }

  void clear() {
    loading = true;
    updateLoad = false;
    getAllPaymentMethod = null;
  }
}

enum PayMethodEnum { GooglePay, Paypal, WindCavePay, Stripe }
