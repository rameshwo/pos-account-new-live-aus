import 'package:flutter/material.dart';
import 'package:pos_account/repository/handler.dart';

class GiftCardCheckPro extends ChangeNotifier {
  void get notify => notifyListeners();

  final giftCardNoCltr = TextEditingController(
    text: "",
  );

  bool loading = false;
  GiftCardCheckModel? giftCardCheckModel = GiftCardCheckModel();

  Future<void> checkBalance() async {
    loading = true;
    notify;
    giftCardCheckModel =
        await Handler.checkGiftBalance(code: giftCardNoCltr.text);

    loading = false;
    notify;
  }
}

//model for this response {"amount": "1000.50"}

class GiftCardCheckModel {
  String amount;
  String? message;

  GiftCardCheckModel({
    this.amount = "",
    this.message,
  });

  factory GiftCardCheckModel.fromJson(Map<String, dynamic> json) {
    return GiftCardCheckModel(
      amount: json['amount'],
      message: json['message'],
    );
  }
}

class GiftCardCheckErrorModel {
  List<ErrorMessage> message;
  int total;
  bool isError;
  int status;

  GiftCardCheckErrorModel({
    this.message = const [],
    this.total = 0,
    this.isError = false,
    this.status = 0,
  });

  factory GiftCardCheckErrorModel.fromJson(Map<String, dynamic> json) {
    return GiftCardCheckErrorModel(
      message: List<ErrorMessage>.from(
          json['message'].map((x) => ErrorMessage.fromJson(x))),
      total: json['total'],
      isError: json['isError'],
      status: json['status'],
    );
  }
}

class ErrorMessage {
  String title;
  String message;

  ErrorMessage({
    this.title = "",
    this.message = "",
  });

  factory ErrorMessage.fromJson(Map<String, dynamic> json) {
    return ErrorMessage(
      title: json['title'],
      message: json['message'],
    );
  }
}
