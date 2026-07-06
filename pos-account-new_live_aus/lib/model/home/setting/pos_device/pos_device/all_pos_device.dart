import 'package:pos_account/model/common/message.dart';

class AllPosDevices {
  AllPosDevices({
    this.data,
    this.message,
    this.total,
    this.status,
  });

  List<PosDeviceData>? data;
  List<Message>? message;
  int? total;
  int? status;

  factory AllPosDevices.fromJson(Map<String, dynamic> json) => AllPosDevices(
        data: json["data"] == null
            ? null
            : List<PosDeviceData>.from(
                json["data"].map((x) => PosDeviceData.fromJson(x))),
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

class PosDeviceData {
  String? id;
  String? deviceType;
  String? posDeviceNameOrLocation;
  String? deviceIdentifier;
  String? subscriptionPlanName;
  bool? isPlanSubscribed;
  String? imageUrl;
  bool? isActive;
  int? total;

  PosDeviceData({
    this.id,
    this.deviceType,
    this.posDeviceNameOrLocation,
    this.deviceIdentifier,
    this.subscriptionPlanName,
    this.isPlanSubscribed,
    this.imageUrl,
    this.isActive,
    this.total,
  });

  factory PosDeviceData.fromJson(Map<String, dynamic> json) => PosDeviceData(
        id: json["id"],
        deviceType: json["deviceType"],
        posDeviceNameOrLocation: json["posDeviceNameOrLocation"],
        deviceIdentifier: json["deviceIdentifier"],
        subscriptionPlanName: json["subscriptionPlanName"],
        isPlanSubscribed: json["isPlanSubscribed"],
        imageUrl: json["imageUrl"],
        isActive: json["isActive"],
        total: json["total"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "deviceType": deviceType,
        "posDeviceNameOrLocation": posDeviceNameOrLocation,
        "deviceIdentifier": deviceIdentifier,
        "subscriptionPlanName": subscriptionPlanName,
        "isPlanSubscribed": isPlanSubscribed,
        "imageUrl": imageUrl,
        "isActive": isActive,
        "total": total,
      };
}
