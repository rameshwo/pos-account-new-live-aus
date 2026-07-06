import 'package:pos_account/model/common/message.dart';

class GetAllPosLocBdRes {
  GetAllPosLocBdRes({
    this.data,
    this.message,
    this.total,
    this.status,
  });

  List<PosData>? data;
  List<Message>? message;
  int? total;
  int? status;

  factory GetAllPosLocBdRes.fromJson(Map<String, dynamic> json) =>
      GetAllPosLocBdRes(
        data: json["data"] == null
            ? null
            : List<PosData>.from(json["data"].map((x) => PosData.fromJson(x))),
        message: json["message"] == null
            ? null
            : List<Message>.from(json["message"].map((x) => x)),
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

class PosData {
  PosData({
    this.id,
    this.name,
    this.description,
    this.ipAddress,
    this.port,
    this.isDefault,
    this.isActive,
  });

  String? id;
  String? name;
  String? description;
  String? ipAddress;
  String? port;
  bool? isDefault;
  bool? isActive;

  factory PosData.fromJson(Map<String, dynamic> json) => PosData(
        id: json["id"],
        name: json["name"],
        description: json["description"],
        ipAddress: json["ipAddress"],
        port: json["port"],
        isDefault: json["isDefault"],
        isActive: json["isActive"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "description": description,
        "ipAddress": ipAddress,
        "port": port,
        "isDefault": isDefault,
        "isActive": isActive,
      };
}
