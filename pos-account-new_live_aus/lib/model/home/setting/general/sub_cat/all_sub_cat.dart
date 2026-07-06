import 'package:pos_account/model/common/message.dart';

class AllSubCat {
  AllSubCat({
    this.data,
    this.message,
    this.total,
    this.status,
  });

  List<SubCatData>? data;
  List<Message>? message;
  int? total;
  int? status;

  factory AllSubCat.fromJson(Map<String, dynamic> json) => AllSubCat(
        data: json["data"] == null
            ? []
            : List<SubCatData>.from(
                json["data"]!.map((x) => SubCatData.fromJson(x))),
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

class SubCatData {
  SubCatData({
    this.id,
    this.categoryName,
    this.subCateogryName,
    this.sortOrder,
    this.isActive,
    this.total,
  });

  String? id;
  String? categoryName;
  String? subCateogryName;
  int? sortOrder;
  bool? isActive;
  int? total;

  factory SubCatData.fromJson(Map<String, dynamic> json) => SubCatData(
        id: json["id"],
        categoryName: json["categoryName"],
        subCateogryName: json["subCateogryName"],
        sortOrder: json["sortOrder"],
        isActive: json["isActive"],
        total: json["total"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "categoryName": categoryName,
        "subCateogryName": subCateogryName,
        "sortOrder": sortOrder,
        "isActive": isActive,
        "total": total,
      };
}
