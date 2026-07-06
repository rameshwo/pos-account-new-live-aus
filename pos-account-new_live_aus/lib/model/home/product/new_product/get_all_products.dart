import 'package:pos_account/model/common/message.dart';

class GetAllProductRes {
  GetAllProductRes({
    this.data,
    this.message,
    this.total,
    this.status,
  });

  final List<ProductData>? data;
  final List<Message>? message;
  final int? total;
  final int? status;

  factory GetAllProductRes.fromJson(Map<String, dynamic> json) =>
      GetAllProductRes(
        data: json["data"] == null
            ? null
            : List<ProductData>.from(
                json["data"].map((x) => ProductData.fromJson(x))),
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

class ProductData {
  ProductData({
    this.id,
    this.name,
    this.code,
    // this.orderType,
    this.category,
    this.image,
    // this.orderTypeProductPriceId,
    // this.isActive,
    this.status,
    this.brand,
    this.supplierName,
    this.isSelected = false,
  });

  String? id;
  String? name;
  String? code;
  // String? orderType;
  String? category;
  String? image;
  // String? orderTypeProductPriceId;
  // bool? isActive;
  bool? status;
  String? brand;
  String? supplierName;
  bool isSelected;

  factory ProductData.fromJson(Map<String, dynamic> json) => ProductData(
        id: json["id"],
        name: json["name"],
        code: json["code"],
        // orderType: json["orderType"],
        category: json["category"],
        image: json["image"],
        // orderTypeProductPriceId: json["orderTypeProductPriceId"],
        // isActive: json["isActive"],
        status: json["status"] is bool
            ? json["status"]
            : json["status"] == "1"
                ? true
                : false,
        brand: json["brand"],
        supplierName: json["supplierName"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "code": code,
        // "orderType": orderType,
        "category": category,
        "image": image,
        // "orderTypeProductPriceId": orderTypeProductPriceId,
        // "isActive": isActive,
        "status": status,
        "brand": brand,
        "supplierName": supplierName,
      };
}
