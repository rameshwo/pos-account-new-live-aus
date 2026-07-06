import 'package:flutter/material.dart';
import 'package:pos_account/model/common/message.dart';

class SmsSetupRes {
  List<SmsSetupData>? data;
  List<Message>? message;
  int? total;
  bool? isError;
  int? status;

  SmsSetupRes({
    this.data,
    this.message,
    this.total,
    this.isError,
    this.status,
  });

  factory SmsSetupRes.fromJson(Map<String, dynamic> json) => SmsSetupRes(
        data: json["data"] == null
            ? []
            : List<SmsSetupData>.from(
                json["data"]!.map((x) => SmsSetupData.fromJson(x))),
        message: json["message"] == null
            ? []
            : List<Message>.from(
                json["message"]!.map((x) => Message.fromJson(x))),
        total: json["total"],
        isError: json["isError"],
        status: json["status"],
      );

  Map<String, dynamic> toJson() => {
        "data": data == null
            ? []
            : List<dynamic>.from(data!.map((x) => x.toJson())),
        "message": message == null
            ? []
            : List<dynamic>.from(message!.map((x) => x.toJson())),
        "total": total,
        "isError": isError,
        "status": status,
      };
}

class SmsSetupData {
  int? total;
  String? id;
  TextEditingController? clientId;
  TextEditingController? clientSecret;
  TextEditingController? fromNumber;
  bool? isActive;

  SmsSetupData({
    this.total,
    this.id,
    this.clientId,
    this.clientSecret,
    this.fromNumber,
    this.isActive,
  });

  factory SmsSetupData.fromJson(Map<String, dynamic> json) => SmsSetupData(
        total: json["total"],
        id: json["id"],
        clientId: TextEditingController(text: json["clientId"]?.toString()),
        clientSecret:
            TextEditingController(text: json["clientSecret"]?.toString()),
        fromNumber: TextEditingController(text: json["fromNumber"]?.toString()),
        isActive: json["isActive"],
      );

  Map<String, dynamic> toJson() => {
        // "total": total,
        "Id": id,
        "ClientId": clientId?.text,
        "ClientSecret": clientSecret?.text,
        "FromNumber": fromNumber?.text,
        "IsActive": isActive,
      };
}
