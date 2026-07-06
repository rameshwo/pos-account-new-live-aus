import 'package:pos_account/model/common/message.dart';

class AllSetMenuRes {
  AllSetMenuRes({
    this.data,
    this.message,
    this.total,
    this.status,
  });

  final List<AllSetMenuData>? data;
  final List<Message>? message;
  final int? total;
  final int? status;

  factory AllSetMenuRes.fromJson(Map<String, dynamic> json) => AllSetMenuRes(
        data: json["data"] == null
            ? null
            : List<AllSetMenuData>.from(
                json["data"].map((x) => AllSetMenuData.fromJson(x))),
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

class AllSetMenuData {
  AllSetMenuData({
    this.id,
    this.name,
    this.imagePath,
    this.total,
  });

  final String? id;
  final String? name;
  final String? imagePath;
  final int? total;

  factory AllSetMenuData.fromJson(Map<String, dynamic> json) => AllSetMenuData(
        id: json["id"],
        name: json["name"],
        imagePath: json["imagePath"],
        total: json["total"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "imagePath": imagePath,
        "total": total,
      };
}
