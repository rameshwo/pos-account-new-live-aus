import 'package:flutter/material.dart';
import 'package:pos_account/model/common/message.dart';

class EmailSetupRes {
  List<EmailSetupData>? data;
  List<Message>? message;
  int? total;
  bool? isError;
  int? status;

  EmailSetupRes({
    this.data,
    this.message,
    this.total,
    this.isError,
    this.status,
  });

  factory EmailSetupRes.fromJson(Map<String, dynamic> json) => EmailSetupRes(
        data: json["data"] == null
            ? []
            : List<EmailSetupData>.from(
                json["data"]!.map((x) => EmailSetupData.fromJson(x))),
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

class EmailSetupData {
  String? id;
  TextEditingController? mailServer;
  TextEditingController? senderName;
  TextEditingController? email;
  TextEditingController? password;
  TextEditingController? port;
  bool? isActive;
  bool? enableTls;
  bool? enableSSlOnCOnnect;
  // extra
  bool showPassword;

  EmailSetupData({
    this.id,
    this.mailServer,
    this.senderName,
    this.email,
    this.password,
    this.port,
    this.isActive,
    this.enableTls,
    this.enableSSlOnCOnnect,
    this.showPassword = false,
  });

  factory EmailSetupData.fromJson(Map<String, dynamic> json) => EmailSetupData(
        id: json["id"],
        mailServer: TextEditingController(text: json["mailServer"]?.toString()),
        senderName: TextEditingController(text: json["senderName"]?.toString()),
        email: TextEditingController(text: json["email"]?.toString()),
        password: TextEditingController(text: json["password"]?.toString()),
        port: TextEditingController(text: json["port"]?.toString()),
        isActive: json["isActive"],
        enableTls: json["enableTls"],
        enableSSlOnCOnnect: json["enableSSlOnCOnnect"],
      );

  Map<String, dynamic> toJson() => {
        "Id": id,
        "MailServer": mailServer?.text,
        "SenderName": senderName?.text,
        "Email": email?.text,
        "Password": password?.text,
        "Port": port?.text,
        "IsActive": isActive,
        "EnableTls": enableTls,
        "EnableSSlOnConnect": enableSSlOnCOnnect,
      };
}
