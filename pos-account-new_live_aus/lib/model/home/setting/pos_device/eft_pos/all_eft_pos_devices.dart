import 'package:pos_account/model/common/message.dart';

class AllEfotPosDevices {
  List<EftPosData>? data;
  List<Message>? message;
  int? total;
  int? status;

  AllEfotPosDevices({
    this.data,
    this.message,
    this.total,
    this.status,
  });

  factory AllEfotPosDevices.fromJson(Map<String, dynamic> json) =>
      AllEfotPosDevices(
        data: json["data"] == null
            ? []
            : List<EftPosData>.from(
                json["data"]!.map((x) => EftPosData.fromJson(x))),
        message: json["message"] == null
            ? []
            : List<Message>.from(
                json["message"]!.map((x) => Message.fromJson(x))),
        total: json["total"],
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
        "status": status,
      };
}

class EftPosData {
  String? id;
  String? eftposTerminalName;
  String? merchant;
  String? merchantPaymentProvider;
  String? merchantPaymentProviderIdentifier;
  String? ipAddress;
  String? serialNumber;
  int? total;

  EftPosData({
    this.id,
    this.eftposTerminalName,
    this.merchant,
    this.merchantPaymentProvider,
    this.merchantPaymentProviderIdentifier,
    this.ipAddress,
    this.serialNumber,
    this.total,
  });

  factory EftPosData.fromJson(Map<String, dynamic> json) => EftPosData(
        id: json["id"],
        eftposTerminalName: json["eftposTerminalName"],
        merchant: json["merchant"],
        merchantPaymentProvider: json["merchantPaymentProvider"],
        merchantPaymentProviderIdentifier:
            json["merchantPaymentProviderIdentifier"],
        ipAddress: json["ipAddress"],
        serialNumber: json["serialNumber"],
        total: json["total"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "eftposTerminalName": eftposTerminalName,
        "merchant": merchant,
        "merchantPaymentProvider": merchantPaymentProvider,
        "merchantPaymentProviderIdentifier": merchantPaymentProviderIdentifier,
        "ipAddress": ipAddress,
        "serialNumber": serialNumber,
        "total": total,
      };
}
