import 'package:pos_account/model/common/message.dart';

class CateTypeRes {
  List<CatTypeData>? data;
  List<Message>? message;
  int? total;
  bool? isError;
  int? status;

  CateTypeRes({
    this.data,
    this.message,
    this.total,
    this.isError,
    this.status,
  });

  factory CateTypeRes.fromJson(Map<String, dynamic> json) => CateTypeRes(
        data: json["data"] == null
            ? []
            : List<CatTypeData>.from(
                json["data"]!.map((x) => CatTypeData.fromJson(x))),
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

class CatTypeData {
  String? id;
  String? name;
  bool? isActive;
  int? sortOrder;
  bool? isDeleteEnabled;
  bool? isEditEnabled;
  int? total;

  CatTypeData({
    this.id,
    this.name,
    this.isActive,
    this.sortOrder,
    this.isDeleteEnabled,
    this.isEditEnabled,
    this.total,
  });

  factory CatTypeData.fromJson(Map<String, dynamic> json) => CatTypeData(
        id: json["id"],
        name: json["name"],
        isActive: json["isActive"],
        sortOrder: json["sortOrder"],
        isDeleteEnabled: json["isDeleteEnabled"],
        isEditEnabled: json["isEditEnabled"],
        total: json["total"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "isActive": isActive,
        "sortOrder": sortOrder,
        "isDeleteEnabled": isDeleteEnabled,
        "isEditEnabled": isEditEnabled,
        "total": total,
      };
}
