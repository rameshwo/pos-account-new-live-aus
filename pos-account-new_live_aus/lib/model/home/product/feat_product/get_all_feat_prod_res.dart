import 'package:pos_account/model/common/message.dart';

class FeatProRes {
  FeatProRes({
    this.data,
    this.message,
    this.total,
    this.status,
  });

  final List<FeatProdData>? data;
  final List<Message>? message;
  final int? total;
  final int? status;

  factory FeatProRes.fromJson(Map<String, dynamic> json) => FeatProRes(
        data: json["data"] == null
            ? null
            : List<FeatProdData>.from(
                json["data"].map((x) => FeatProdData.fromJson(x))),
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

class FeatProdData {
  FeatProdData({
    this.id,
    this.productId,
    this.name,
    this.image,
    this.total,
  });

  final String? id;
  final String? productId;
  final String? name;
  final String? image;
  final int? total;

  factory FeatProdData.fromJson(Map<String, dynamic> json) => FeatProdData(
        id: json["id"],
        productId: json["productId"],
        name: json["name"],
        image: json["image"],
        total: json["total"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "productId": productId,
        "name": name,
        "image": image,
        "total": total,
      };
}
