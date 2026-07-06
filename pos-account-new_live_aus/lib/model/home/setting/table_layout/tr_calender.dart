import 'package:pos_account/model/common/message.dart';

class TableReservationCalender {
  List<TRCalenderData>? data;
  List<Message>? message;
  int? total;
  bool? isError;
  int? status;

  TableReservationCalender({
    this.data,
    this.message,
    this.total,
    this.isError,
    this.status,
  });

  factory TableReservationCalender.fromJson(Map<String, dynamic> json) =>
      TableReservationCalender(
        data: json["data"] == null
            ? []
            : List<TRCalenderData>.from(
                json["data"]!.map((x) => TRCalenderData.fromJson(x))),
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

class TRCalenderData {
  String? id;
  String? tableName;
  String? tableId;
  String? customerName;
  String? adult;
  String? child;
  String? channel;
  String? reservationNumber;
  String? dateTimeFrom;
  String? dateTimeTo;
  String? status;

  TRCalenderData({
    this.id,
    this.tableName,
    this.tableId,
    this.customerName,
    this.adult,
    this.child,
    this.channel,
    this.reservationNumber,
    this.dateTimeFrom,
    this.dateTimeTo,
    this.status,
  });

  factory TRCalenderData.fromJson(Map<String, dynamic> json) => TRCalenderData(
        id: json["id"],
        tableName: json["tableName"],
        tableId: json["tableId"],
        customerName: json["customerName"],
        adult: json["adult"],
        child: json["child"],
        channel: json["channel"],
        reservationNumber: json["reservationNumber"],
        dateTimeFrom: json["dateTimeFrom"],
        dateTimeTo: json["dateTimeTo"],
        status: json["status"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "tableName": tableName,
        "tableId": tableId,
        "customerName": customerName,
        "adult": adult,
        "child": child,
        "channel": channel,
        "reservationNumber": reservationNumber,
        "dateTimeFrom": dateTimeFrom,
        "dateTimeTo": dateTimeTo,
        "status": status,
      };
}
