import 'package:pos_account/model/common/table_location.dart';

class OrderTypeAddSecRes {
  OrderTypeAddSecRes({
    this.channels,
    this.orderTypes,
  });

  List<TableLocation>? channels;
  List<TableLocation>? orderTypes;

  factory OrderTypeAddSecRes.fromJson(Map<String, dynamic> json) =>
      OrderTypeAddSecRes(
        channels: json["channels"] == null
            ? null
            : List<TableLocation>.from(
                json["channels"].map((x) => TableLocation.fromJson(x))),
        orderTypes: json["orderTypes"] == null
            ? null
            : List<TableLocation>.from(
                json["orderTypes"].map((x) => TableLocation.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "channels": channels == null
            ? null
            : List<dynamic>.from(channels!.map((x) => x.toJson())),
        "orderTypes": orderTypes == null
            ? null
            : List<dynamic>.from(orderTypes!.map((x) => x.toJson())),
      };
}
