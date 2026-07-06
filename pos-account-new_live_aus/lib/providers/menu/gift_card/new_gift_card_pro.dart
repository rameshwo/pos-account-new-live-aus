import 'package:flutter/material.dart';
import 'package:pos_account/model/home/booking/all_customer.dart';
import 'package:pos_account/model/home/menu/gift_card/gift_card_add_sec.dart';
import 'package:pos_account/model/home/menu/gift_card/gift_card_req.dart';
import 'package:pos_account/repository/handler.dart';
import 'package:pos_account/services/database/shared_pref.dart';

class NewGiftCardPro extends ChangeNotifier {
  void get notify => notifyListeners();

  int? payOptionIndex;
  bool pageLoad = true;

  String? dateFormat;

  GiftCardAddSec? addSec;

  final giftCardNoCltr = TextEditingController();
  final giftCardAmountCltr = TextEditingController();

  final senderNameCltr = TextEditingController();
  final senderEmailCltr = TextEditingController();
  final senderPhoneCltr = TextEditingController();
  final senderPostalCltr = TextEditingController();
  int? senderCountryIndex;
  int? senderPhoneCodeIndex;
  final senderMessageCltr = TextEditingController();

  final receiveNameCltr = TextEditingController();
  final receiveEmailCltr = TextEditingController();
  final receivePhoneCltr = TextEditingController();
  final receivePostalCltr = TextEditingController();
  int? recCountryIndex;
  int? recPhoneCodeIndex;

  final makePayDateCltr = TextEditingController();
  final paidAmountCltr = TextEditingController();

  bool isScheduledForFuture = false;

  String? selectedGiftCardId;
  String? selectedGiftCardImage;

  void clear() {
    payOptionIndex = null;
    pageLoad = true;
    dateFormat = null;
    addSec = null;
    giftCardNoCltr.clear();
    giftCardAmountCltr.clear();
    senderNameCltr.clear();
    senderEmailCltr.clear();
    senderPhoneCltr.clear();
    senderPostalCltr.clear();
    senderCountryIndex = null;
    senderPhoneCodeIndex = null;
    senderMessageCltr.clear();
    receiveNameCltr.clear();
    receiveEmailCltr.clear();
    receivePhoneCltr.clear();
    receivePostalCltr.clear();
    recCountryIndex = null;
    recPhoneCodeIndex = null;
    makePayDateCltr.clear();
    paidAmountCltr.clear();
    isScheduledForFuture = false;
    selectedGiftCardId = null;
    selectedGiftCardImage = null;
    senderId = "";
    receiverId = "";
  }

  Future<void> getData() async {
    dateFormat = await SharedPrefs.dateFormat;

    addSec = await Handler.giftCardAddSec();
    setData();
    pageLoad = false;
    notify;
  }

  // final _giftCardList = <String>[];

  setData() {
    if (addSec?.countries != null &&
        addSec!.countries!.any((e) => e.isSelected ?? false)) {
      final initCountryIndex =
          addSec!.countries!.indexWhere((e) => e.isSelected ?? false);
      senderPhoneCodeIndex = senderCountryIndex =
          recCountryIndex = recPhoneCodeIndex = initCountryIndex;
    }
    giftCardNoCltr.text = addSec?.code ?? '';
    // _giftCardList.add(giftCardNoCltr.text);
    // print(_giftCardList);

    if (addSec?.paymentMethods != null &&
        addSec!.paymentMethods!.any((e) => e.isSelected ?? false)) {
      payOptionIndex =
          addSec!.paymentMethods!.indexWhere((e) => e.isSelected ?? false);
    }
  }

  String senderId = "";

  void setSenderCustomerData(dynamic cusData) {
    if (cusData != null && cusData is CusData) {
      senderId = cusData.id ?? "";
      senderNameCltr.text = cusData.name ?? "";
      senderPhoneCltr.text = cusData.phoneNumber ?? "";
      senderEmailCltr.text = cusData.email ?? "";
      senderPostalCltr.text = cusData.postalCode ?? '';
      if (addSec?.countries != null) {
        if (addSec!.countries!.any((e) => e.id == cusData.countryId)) {
          senderCountryIndex =
              addSec!.countries!.indexWhere((e) => e.id == cusData.countryId);
        }

        if (addSec!.countries!
            .any((e) => e.id == cusData.countryPhoneNumberPrefixId)) {
          senderPhoneCodeIndex = addSec!.countries!
              .indexWhere((e) => e.id == cusData.countryPhoneNumberPrefixId);
        }
      }
      notify;
    }
  }

  String receiverId = "";

  void setReceiverCustomerData(dynamic cusData) {
    if (cusData != null && cusData is CusData) {
      receiverId = cusData.id ?? "";
      receiveNameCltr.text = cusData.name ?? "";
      receivePhoneCltr.text = cusData.phoneNumber ?? "";
      receiveEmailCltr.text = cusData.email ?? "";

      receivePostalCltr.text = cusData.postalCode ?? '';
      if (addSec?.countries != null) {
        if (addSec!.countries!.any((e) => e.id == cusData.countryId)) {
          recCountryIndex =
              addSec!.countries!.indexWhere((e) => e.id == cusData.countryId);
        }

        if (addSec!.countries!
            .any((e) => e.id == cusData.countryPhoneNumberPrefixId)) {
          recPhoneCodeIndex = addSec!.countries!
              .indexWhere((e) => e.id == cusData.countryPhoneNumberPrefixId);
        }
      }
      notify;
    }
  }

  bool payLoad = false;

  Future<bool?> addUpData() async {
    final req = GiftcardReq(
        id: "",
        code: giftCardNoCltr.text,
        amount: giftCardAmountCltr.text,
        message: senderMessageCltr.text,
        giftCardTemplateId: selectedGiftCardId,
        senderViewModel: ErViewModel(
          id: senderId,
          name: senderNameCltr.text,
          email: senderEmailCltr.text,
          phoneNumber: senderPhoneCltr.text,
          postalCode: senderPostalCltr.text,
        ),
        receiverViewModel: ErViewModel(
          id: receiverId,
          name: receiveNameCltr.text,
          email: receiveEmailCltr.text,
          phoneNumber: receivePhoneCltr.text,
          postalCode: receivePostalCltr.text,
        ),
        giftCardPaymentModel: GiftCardPaymentModel(
          isScheduledForFuture: isScheduledForFuture,
          giftCardScheduledDate: makePayDateCltr.text,
          paidAmount: paidAmountCltr.text,
        ));

    if (addSec?.countries != null) {
      if (senderPhoneCodeIndex != null)
        req.senderViewModel!.countryPhoneNumberPrefixId =
            addSec!.countries![senderPhoneCodeIndex!].id;

      if (senderCountryIndex != null)
        req.senderViewModel!.countryId =
            addSec!.countries![senderCountryIndex!].id;

      if (recPhoneCodeIndex != null)
        req.receiverViewModel!.countryPhoneNumberPrefixId =
            addSec!.countries![recPhoneCodeIndex!].id;

      if (recCountryIndex != null)
        req.receiverViewModel!.countryId =
            addSec!.countries![recCountryIndex!].id;
    }

    if (addSec?.paymentMethods != null && payOptionIndex != null) {
      req.giftCardPaymentModel!.paymentMethodId =
          addSec!.paymentMethods![payOptionIndex!].id;
    }

    payLoad = true;
    notify;

    final status = await Handler.addUpGiftCards(req: req);

    payLoad = false;
    notify;

    if (status ?? false) {
      // TODO: infinite gift card, enable 212 and disable below 213 and 214
      // getData().then((_) => addUpData());
      clear();
      getData();
    }
    return null;
  }
}
