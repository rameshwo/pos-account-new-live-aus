import 'package:pos_account/model/common/message.dart';

class RecentCallRes {
  List<RecentCallData>? data;
  List<Message>? message;
  int? total;
  bool? isError;
  int? status;

  RecentCallRes({
    this.data,
    this.message,
    this.total,
    this.isError,
    this.status,
  });

  factory RecentCallRes.fromJson(Map<String, dynamic> json) => RecentCallRes(
        data: json["data"] == null
            ? []
            : List<RecentCallData>.from(
                json["data"]!.map((x) => RecentCallData.fromJson(x))),
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
        "message":
            message == null ? [] : List<dynamic>.from(message!.map((x) => x)),
        "total": total,
        "isError": isError,
        "status": status,
      };
}

class RecentCallData {
  String? number;
  bool? isAccepted;
  String? dateTime;
  int? total;

  RecentCallData({
    this.number,
    this.isAccepted,
    this.dateTime,
    this.total,
  });

  factory RecentCallData.fromJson(Map<String, dynamic> json) => RecentCallData(
        number: json["phoneNumber"],
        isAccepted: json["isAccepted"],
        dateTime: json["dateTime"],
        total: json["total"],
      );

  Map<String, dynamic> toJson() => {
        "phoneNumber": number,
        "isAccepted": isAccepted,
        "dateTime": dateTime,
        "total": total,
      };
}
