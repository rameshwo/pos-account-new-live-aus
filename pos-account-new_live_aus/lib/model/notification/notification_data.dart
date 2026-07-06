import 'new_order_notifi.dart';

class NotificationData {
  List<NewOrderNotifi>? data;
  List<dynamic>? message;
  int? total;
  int? status;

  NotificationData({
    this.data,
    this.message,
    this.total,
    this.status,
  });

  factory NotificationData.fromJson(Map<String, dynamic> json) =>
      NotificationData(
        data: json["data"] == null
            ? []
            : List<NewOrderNotifi>.from(
                json["data"]!.map((x) => NewOrderNotifi.fromJson(x))),
        message: json["message"] == null
            ? []
            : List<dynamic>.from(json["message"]!.map((x) => x)),
        total: json["total"],
        status: json["status"],
      );

  Map<String, dynamic> toJson() => {
        "data": data == null
            ? []
            : List<dynamic>.from(data!.map((x) => x.toJson())),
        "message":
            message == null ? [] : List<dynamic>.from(message!.map((x) => x)),
        "total": total,
        "status": status,
      };
}
