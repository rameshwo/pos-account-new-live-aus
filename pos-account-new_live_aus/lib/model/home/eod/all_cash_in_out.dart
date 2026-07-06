import 'package:pos_account/model/common/message.dart';

class AllCashInOut {
  AllCashInOut({
    this.data,
    this.message,
    this.total,
    this.status,
  });

  List<CashInOutData>? data;
  List<Message>? message;
  int? total;
  int? status;

  factory AllCashInOut.fromJson(Map<String, dynamic> json) => AllCashInOut(
        data: json["data"] == null
            ? null
            : List<CashInOutData>.from(
                json["data"].map((x) => CashInOutData.fromJson(x))),
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

class CashInOutData {
  CashInOutData({
    this.id,
    this.amount,
    this.date,
    this.user,
    this.type,
    this.notes,
    this.total,
  });

  String? id;
  String? amount;
  String? date;
  String? user;
  String? type;
  String? notes;
  int? total;

  factory CashInOutData.fromJson(Map<String, dynamic> json) => CashInOutData(
        id: json["id"],
        amount: json["amount"],
        date: json["date"],
        user: json["user"],
        type: json["type"],
        notes: json["notes"],
        total: json["total"],
      );

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {
      "Id": id,
      "Amount": amount,
      "Type": type,
      "Notes": notes,
    };

    if (date != null) data.addAll({"Date": date});
    if (user != null) data.addAll({"User": user});
    if (total != null) data.addAll({"Total": total});
    return data;
  }
}
