import 'package:pos_account/model/common/message.dart';

class AllTableRes {
  AllTableRes({
    this.data,
    this.message,
    this.total,
    this.status,
  });

  List<DataAllTable>? data;
  List<Message>? message;
  int? total;
  int? status;

  factory AllTableRes.fromJson(Map<String, dynamic> json) => AllTableRes(
        data: json["data"] == null
            ? []
            : List<DataAllTable>.from(
                json["data"].map((x) => DataAllTable.fromJson(x))),
        message: json["message"] == null
            ? []
            : List<Message>.from(
                json["message"].map((x) => Message.fromJson(x))),
        total: json["total"],
        status: json["status"],
      );

  Map<String, dynamic> toJson() => {
        "data": data == null
            ? null
            : List<dynamic>.from(data!.map((x) => x.toJson())),
        "message": message == null
            ? []
            : List<dynamic>.from(message!.map((x) => x.toJson())),
        "total": total,
        "status": status,
      };
}

class DataAllTable {
  DataAllTable({
    this.id,
    this.name,
    this.description,
    this.tableQrImageUrl,
    this.isActive,
    this.adultCapacity,
    this.childCapacity,
  });

  String? id;
  String? name;
  String? tableQrImageUrl;
  String? description;
  bool? isActive;
  dynamic adultCapacity;
  dynamic childCapacity;

  factory DataAllTable.fromJson(Map<String, dynamic> json) => DataAllTable(
        id: json["id"],
        name: json["name"],
        tableQrImageUrl: json["tableQrImageUrl"],
        description: json["description"],
        isActive: json["isActive"],
        adultCapacity: json["adultCapacity"],
        childCapacity: json["childCapacity"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "description": description,
        "isActive": isActive,
        "tableQrImageUrl": tableQrImageUrl,
        "adultCapacity": adultCapacity,
        "childCapacity": childCapacity,
      };
}
