import 'package:pos_account/model/common/message.dart';

class QuickNoteRes {
  List<QuickNoteData>? data;
  List<Message>? message;
  int? total;
  bool? isError;
  int? status;

  QuickNoteRes({
    this.data,
    this.message,
    this.total,
    this.isError,
    this.status,
  });

  factory QuickNoteRes.fromJson(Map<String, dynamic> json) => QuickNoteRes(
        data: json["data"] == null
            ? []
            : List<QuickNoteData>.from(
                json["data"]!.map((x) => QuickNoteData.fromJson(x))),
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

class QuickNoteData {
  String? id;
  String? name;
  bool? isActive;
  int? total;

  QuickNoteData({
    this.id,
    this.name,
    this.isActive,
    this.total,
  });

  factory QuickNoteData.fromJson(Map<String, dynamic> json) => QuickNoteData(
        id: json["id"],
        name: json["name"],
        isActive: json["isActive"],
        total: json["total"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "isActive": isActive,
        "total": total,
      };
}
