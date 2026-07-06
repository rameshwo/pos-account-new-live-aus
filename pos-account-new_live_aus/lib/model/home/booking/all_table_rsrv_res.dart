import 'package:pos_account/model/common/message.dart';

class AllTableRsrv {
  AllTableRsrv({
    this.data,
    this.message,
    this.total,
    this.status,
  });

  List<AllTableResvData>? data;
  List<Message>? message;
  int? total;
  int? status;

  factory AllTableRsrv.fromJson(Map<String, dynamic> json) => AllTableRsrv(
        data: json["data"] == null
            ? null
            : List<AllTableResvData>.from(
                json["data"].map((x) => AllTableResvData.fromJson(x))),
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

class AllTableResvData {
  AllTableResvData({
    this.id,
    this.tableName,
    this.customerName,
    this.adult,
    this.child,
    this.channel,
    this.reservationNumber,
    this.dateTimeFrom,
    this.dateTimeTo,
    this.status,
    this.occasion,
    this.message,
    this.hasArrived,
  });

  String? id;
  String? tableName;
  String? customerName;
  String? adult;
  String? child;
  String? channel;
  String? reservationNumber;
  String? dateTimeFrom;
  String? dateTimeTo;
  String? status;
  String? occasion;
  String? message;
  bool? hasArrived;

  factory AllTableResvData.fromJson(Map<String, dynamic> json) =>
      AllTableResvData(
        id: json["id"],
        tableName: json["tableName"],
        customerName: json["customerName"],
        adult: json["adult"],
        child: json["child"],
        channel: json["channel"],
        reservationNumber: json["reservationNumber"],
        dateTimeFrom: json["dateTimeFrom"],
        dateTimeTo: json["dateTimeTo"],
        status: json["status"],
        occasion: json["occasion"],
        message: json["message"],
        hasArrived: json["hasArrived"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "tableName": tableName,
        "customerName": customerName,
        "adult": adult,
        "child": child,
        "channel": channel,
        "reservationNumber": reservationNumber,
        "dateTimeFrom": dateTimeFrom,
        "dateTimeTo": dateTimeTo,
        "status": status,
        "occasion": occasion,
        "message": message,
        "hasArrived": hasArrived,
      };
}
