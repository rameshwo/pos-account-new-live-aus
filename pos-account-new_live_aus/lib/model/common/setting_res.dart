import 'message.dart';
import 'res_datum.dart';

class SettingRes {
  SettingRes({
    this.data,
    this.message,
    this.total,
    this.status,
  });

  List<SRDatum>? data;
  dynamic message; // Dynamic to handle List, String, or Object
  int? total;
  int? status;

  factory SettingRes.fromJson(Map<String, dynamic> json) => SettingRes(
        data: json["data"] == null
            ? null
            : List<SRDatum>.from(json["data"].map((x) => SRDatum.fromJson(x))),
        message: json["message"] == null
            ? null
            : json["message"] is List
                ? List<Message>.from(
                    json["message"].map((x) => Message.fromJson(x)))
                : json["message"] is String
                    ? json["message"]
                    : Message.fromJson(json["message"]),
        total: json["total"],
        status: json["status"],
      );

  Map<String, dynamic> toJson() {
    dynamic formattedMessage;

    if (message == null) {
      formattedMessage = null;
    } else if (message is List<Message>) {
      formattedMessage = List<dynamic>.from(message.map((x) => x.toJson()));
    } else if (message is Message) {
      formattedMessage = message.toJson();
    } else if (message is String) {
      formattedMessage = message;
    }

    return {
      "data":
          data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
      "message": formattedMessage,
      "total": total,
      "status": status,
    };
  }
}
