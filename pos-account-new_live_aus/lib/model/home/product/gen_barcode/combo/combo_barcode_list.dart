import 'package:pos_account/model/common/message.dart';

class RetailPosComboBarcodeRes {
  List<RetailPosComboBarcodeData>? data;
  List<Message>? message;
  int? total;
  bool? isError;
  int? status;

  RetailPosComboBarcodeRes({
    this.data,
    this.message,
    this.total,
    this.isError,
    this.status,
  });

  factory RetailPosComboBarcodeRes.fromJson(Map<String, dynamic> json) =>
      RetailPosComboBarcodeRes(
        data: json["data"] == null
            ? []
            : List<RetailPosComboBarcodeData>.from(json["data"]!
                .map((x) => RetailPosComboBarcodeData.fromJson(x))),
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
        "message":
            message == null ? [] : List<dynamic>.from(message!.map((x) => x)),
        "total": total,
        "isError": isError,
        "status": status,
      };
}

class RetailPosComboBarcodeData {
  String? id;
  String? name;
  String? category;
  String? code;
  String? barCodeNumber;
  int? total;

  RetailPosComboBarcodeData({
    this.id,
    this.name,
    this.category,
    this.code,
    this.barCodeNumber,
    this.total,
  });

  factory RetailPosComboBarcodeData.fromJson(Map<String, dynamic> json) =>
      RetailPosComboBarcodeData(
        id: json["id"],
        name: json["name"],
        category: json["category"],
        code: json["code"],
        barCodeNumber: json["barCodeNumber"],
        total: json["total"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "category": category,
        "code": code,
        "barCodeNumber": barCodeNumber,
        "total": total,
      };
}
