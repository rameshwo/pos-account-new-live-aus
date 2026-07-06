import 'package:flutter/material.dart';
import 'package:pos_account/repository/handler.dart';

///[SHORT_TERM_CASH_FLOW] for luca pay
///
class StcfPro extends ChangeNotifier {
  final formKey = GlobalKey<FormState>();

  final nameCltr = TextEditingController();
  final numberCltr = TextEditingController();
  final emailCltr = TextEditingController();
  final abnCltr = TextEditingController();
  final accSoftCltr = TextEditingController();

  bool submitLoad = false;

  Future<bool> applyStcf() async {
    final Map<String, dynamic> body = {
      "ContactName": nameCltr.text,
      "ContactNumber": numberCltr.text,
      "BusinessEmailAdress": emailCltr.text,
      "ABNNumber": abnCltr.text,
      "AccountingSoftWare": accSoftCltr.text,
      // "ChannelPlatform": "POSMobile",
    };
    submitLoad = true;
    notify;

    final status = await Handler.applyLucaPay(body: body);

    submitLoad = false;
    notify;

    return status ?? false;
  }

  void get clear {
    nameCltr.clear();
    numberCltr.clear();
    emailCltr.clear();
    abnCltr.clear();
    accSoftCltr.clear();
  }

  void get notify => notifyListeners();
}
