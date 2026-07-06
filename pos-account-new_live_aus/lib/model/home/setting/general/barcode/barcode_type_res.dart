import 'package:pos_account/model/common/message.dart';

class BarCodeTypeList {
  BarCodeTypeList({
    this.data,
    this.message,
    this.total,
    this.status,
  });

  List<BarcodeData>? data;
  List<Message>? message;
  int? total;
  int? status;

  factory BarCodeTypeList.fromJson(Map<String, dynamic> json) =>
      BarCodeTypeList(
        data: json["data"] == null
            ? []
            : List<BarcodeData>.from(
                json["data"]!.map((x) => BarcodeData.fromJson(x))),
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

class BarcodeData {
  BarcodeData({
    this.id,
    this.name,
    this.isDefault,
  });

  String? id;
  String? name;
  bool? isDefault;

  factory BarcodeData.fromJson(Map<String, dynamic> json) => BarcodeData(
        id: json["id"],
        name: json["name"],
        isDefault: json["isDefault"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "isDefault": isDefault,
      };
}
