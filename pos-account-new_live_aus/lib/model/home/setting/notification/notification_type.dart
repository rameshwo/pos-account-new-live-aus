import 'package:pos_account/model/common/message.dart';

class NotificationType {
  NotificationType({
    this.data,
    this.message,
    this.total,
    this.status,
  });

  List<NotifyData>? data;
  List<Message>? message;
  int? total;
  int? status;

  factory NotificationType.fromJson(Map<String, dynamic> json) =>
      NotificationType(
        data: json["data"] == null
            ? null
            : List<NotifyData>.from(
                json["data"].map((x) => NotifyData.fromJson(x))),
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
        "message": message == null
            ? null
            : List<dynamic>.from(message!.map((x) => x.toJson())),
        "total": total,
        "status": status,
      };
}

class NotifyData {
  NotifyData({
    this.id,
    this.name,
    this.isActive,
    this.description,
    this.total,
  });

  String? id;
  String? name;
  bool? isActive;
  String? description;
  int? total;

  factory NotifyData.fromJson(Map<String, dynamic> json) => NotifyData(
        id: json["id"],
        name: json["name"],
        isActive: json["isActive"],
        description: json["description"],
        total: json["total"],
      );

  Map<String, dynamic> toJson() => {
        "Id": id,
        "Name": name,
        "IsActive": isActive,
        "Description": description,
        "Total": total,
      };
}
