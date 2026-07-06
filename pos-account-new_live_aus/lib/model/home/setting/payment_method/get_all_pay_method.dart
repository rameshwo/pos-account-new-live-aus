import 'package:flutter/material.dart';
import 'package:pos_account/model/common/message.dart';

class GetAllPaymentMethod {
  GetAllPaymentMethod({
    this.data,
    this.message,
    this.total,
    this.status,
  });

  List<PayMethodData>? data;
  List<Message>? message;
  int? total;
  int? status;

  factory GetAllPaymentMethod.fromJson(Map<String, dynamic> json) =>
      GetAllPaymentMethod(
        data: json["data"] == null
            ? null
            : List<PayMethodData>.from(
                json["data"].map((x) => PayMethodData.fromJson(x))),
        message: json["message"] == null
            ? null
            : List<Message>.from(
                json["message"].map((x) => Message.fromJson(x))),
        total: json["total"],
        status: json["status"],
      );

  Map<String, dynamic> toJson() => {
        "data": data == null
            ? null
            : List<dynamic>.from(data!.map((x) => x.toJson())),
        "message":
            message == null ? null : List<dynamic>.from(message!.map((x) => x)),
        "total": total,
        "status": status,
      };
}

class PayMethodData {
  PayMethodData({
    this.id,
    this.paymentMethodName,
    this.isActive,
    this.surchargePercentage,
    this.enableSurcharge,
    this.paymentCredentials,
    this.total,
  });

  String? id;
  String? paymentMethodName;
  bool? isActive;
  TextEditingController? surchargePercentage;
  bool? enableSurcharge;
  PaymentCredentials? paymentCredentials;
  int? total;

  factory PayMethodData.fromJson(Map<String, dynamic> json) => PayMethodData(
        id: json["id"],
        paymentMethodName: json["paymentMethodName"],
        isActive: json["isActive"],
        surchargePercentage: TextEditingController(
            text: json["surchargePercentage"]?.toString() ?? ''),
        enableSurcharge: json["enableSurcharge"],
        paymentCredentials: json["paymentCredentials"] == null
            ? null
            : PaymentCredentials.fromJson(json["paymentCredentials"]),
        total: json["total"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "paymentMethodName": paymentMethodName,
        "isActive": isActive,
        "surchargePercentage": surchargePercentage?.text ?? '',
        "enableSurcharge": enableSurcharge,
        "paymentCredentials": paymentCredentials?.toJson(),
        "total": total,
      };
}

class PaymentCredentials {
  PaymentCredentials({
    this.keyOrId,
    this.secret,
    // this.stripeConnectedId,
    this.id,
  });

  TextEditingController? keyOrId;
  TextEditingController? secret;
  // String? stripeConnectedId;
  String? id;

  factory PaymentCredentials.fromJson(Map<String, dynamic> json) =>
      PaymentCredentials(
        keyOrId: TextEditingController(text: json["keyOrId"]?.toString() ?? ''),
        secret: TextEditingController(text: json["secret"]?.toString() ?? ''),
        // stripeConnectedId: json["stripeConnectedId"],
        id: json["id"],
      );

  Map<String, dynamic> toJson() => {
        "keyOrId": keyOrId?.text ?? '',
        "secret": secret?.text ?? '',
        // "StripeConnectedId": stripeConnectedId,
        if (id != null) "id": id,
      };
}
