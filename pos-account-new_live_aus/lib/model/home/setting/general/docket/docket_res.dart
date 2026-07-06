import 'package:pos_account/model/common/message.dart';
import 'docket_req.dart';

class DocketGroupRes {
  List<DocketGroupReq>? data;
  List<Message>? message;
  int? total;
  bool? isError;
  int? status;

  DocketGroupRes({
    this.data,
    this.message,
    this.total,
    this.isError,
    this.status,
  });

  factory DocketGroupRes.fromJson(Map<String, dynamic> json) => DocketGroupRes(
        data: json["data"] == null
            ? []
            : List<DocketGroupReq>.from(
                json["data"]!.map((x) => DocketGroupReq.fromJson(x))),
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
