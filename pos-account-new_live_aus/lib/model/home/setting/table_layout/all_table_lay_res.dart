import 'package:pos_account/model/common/message.dart';

class AllTableLayRes {
  AllTableLayRes({
    this.data,
    this.message,
    this.total,
    this.status,
  });

  List<AllTableData>? data;
  List<Message>? message;
  int? total;
  int? status;

  factory AllTableLayRes.fromJson(Map<String, dynamic> json) => AllTableLayRes(
        data: json["data"] == null
            ? null
            : List<AllTableData>.from(
                json["data"].map((x) => AllTableData.fromJson(x))),
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

class AllTableData {
  AllTableData({
    this.id,
    this.tableLocationName,
  });

  String? id;
  String? tableLocationName;

  factory AllTableData.fromJson(Map<String, dynamic> json) => AllTableData(
        id: json["id"],
        tableLocationName: json["tableLocationName"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "tableLocationName": tableLocationName,
      };
}
