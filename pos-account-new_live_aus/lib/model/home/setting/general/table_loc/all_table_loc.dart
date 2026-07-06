import 'package:pos_account/model/common/message.dart';

class AllTableLocationModel {
  List<TableLocData>? data;
  List<Message>? message;
  int? total;
  int? status;

  AllTableLocationModel({
    this.data,
    this.message,
    this.total,
    this.status,
  });

  factory AllTableLocationModel.fromJson(Map<String, dynamic> json) =>
      AllTableLocationModel(
        data: json["data"] == null
            ? []
            : List<TableLocData>.from(
                json["data"]!.map((x) => TableLocData.fromJson(x))),
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

class TableLocData {
  String? id;
  String? name;
  String? description;
  bool? isActive;
  String? tableLayoutId;
  int? total;

  TableLocData({
    this.id,
    this.name,
    this.description,
    this.isActive,
    this.tableLayoutId,
    this.total,
  });

  factory TableLocData.fromJson(Map<String, dynamic> json) => TableLocData(
        id: json["id"],
        name: json["name"],
        description: json["description"],
        isActive: json["isActive"],
        tableLayoutId: json["tableLayoutId"],
        total: json["total"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "description": description,
        "isActive": isActive,
        "tableLayoutId": tableLayoutId,
        "total": total,
      };
}
