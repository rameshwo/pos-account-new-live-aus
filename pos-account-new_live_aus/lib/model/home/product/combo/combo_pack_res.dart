import 'package:pos_account/model/common/message.dart';

class ComboPackRes {
  List<ComboPackData>? data;
  List<Message>? message;
  int? total;
  bool? isError;
  int? status;

  ComboPackRes({
    this.data,
    this.message,
    this.total,
    this.isError,
    this.status,
  });

  factory ComboPackRes.fromJson(Map<String, dynamic> json) => ComboPackRes(
        data: json["data"] == null
            ? []
            : List<ComboPackData>.from(
                json["data"]!.map((x) => ComboPackData.fromJson(x))),
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

class ComboPackData {
  String? id;
  String? name;
  String? code;
  String? image;
  bool? status;
  int? total;

  ComboPackData({
    this.id,
    this.name,
    this.code,
    this.image,
    this.status,
    this.total,
  });

  factory ComboPackData.fromJson(Map<String, dynamic> json) => ComboPackData(
        id: json["id"],
        name: json["name"],
        code: json["code"],
        image: json["image"],
        status: json["status"],
        total: json["total"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "code": code,
        "image": image,
        "status": status,
        "total": total,
      };
}
