import 'package:pos_account/model/common/table_location.dart';
import 'package:pos_account/model/home/menu/place_order/pos_res/order_type_res.dart';

class OrderDetailSecRes {
  OrderDetailSecRes({
    this.tables,
    this.orderTypes,
    this.orderChannels,
    this.orderStatus,
    // this.channelWithOrderTypes,
  });

  List<TableLocation>? tables;
  List<OrderTypeRes>? orderTypes;
  List<TableLocation>? orderChannels;
  List<TableLocation>? orderStatus;
  // List<ChannelWithOrderType>? channelWithOrderTypes; // notInNew

  factory OrderDetailSecRes.fromJson(Map<String, dynamic> json) =>
      OrderDetailSecRes(
        tables: json["tables"] == null
            ? null
            : List<TableLocation>.from(
                json["tables"].map((x) => TableLocation.fromJson(x))),
        orderTypes: json["allOrdersOrderTypes"] == null
            ? null
            : List<OrderTypeRes>.from(json["allOrdersOrderTypes"]
                .map((x) => OrderTypeRes.fromJson(x))),
        orderChannels: json["channels"] == null
            ? null
            : List<TableLocation>.from(
                json["channels"].map((x) => TableLocation.fromJson(x))),
        orderStatus: json["orderStatus"] == null
            ? null
            : List<TableLocation>.from(
                json["orderStatus"].map((x) => TableLocation.fromJson(x))),
        // channelWithOrderTypes: json["channelWithOrderTypes"] == null
        //     ? []
        //     : List<ChannelWithOrderType>.from(json["channelWithOrderTypes"]!
        //         .map((x) => ChannelWithOrderType.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "tables": tables == null
            ? null
            : List<dynamic>.from(tables!.map((x) => x.toJson())),
        "allOrdersOrderTypes": orderTypes == null
            ? null
            : List<dynamic>.from(orderTypes!.map((x) => x.toJson())),
        "channels": orderChannels == null
            ? null
            : List<dynamic>.from(orderChannels!.map((x) => x.toJson())),
        "orderStatus": orderStatus == null
            ? null
            : List<dynamic>.from(orderStatus!.map((x) => x.toJson())),
        // "channelWithOrderTypes": channelWithOrderTypes == null
        //     ? []
        //     : List<dynamic>.from(channelWithOrderTypes!.map((x) => x.toJson())),
      };
}

// class ChannelWithStatus {
//   ChannelWithStatus({
//     this.id,
//     this.channelName,
//     this.channelStatus,
//   });

//   String? id;
//   String? channelName;
//   List<TableLocation>? channelStatus;

//   factory ChannelWithStatus.fromJson(Map<String, dynamic> json) =>
//       ChannelWithStatus(
//         id: json["id"],
//         channelName: json["channelName"],
//         channelStatus: json["channelStatus"] == null
//             ? null
//             : List<TableLocation>.from(
//                 json["channelStatus"].map((x) => TableLocation.fromJson(x))),
//       );

//   Map<String, dynamic> toJson() => {
//         "id": id,
//         "channelName": channelName,
//         "channelStatus": channelStatus == null
//             ? null
//             : List<dynamic>.from(channelStatus!.map((x) => x.toJson())),
//       };
// }

class ChannelWithOrderType {
  ChannelWithOrderType({
    this.id,
    this.channelName,
    this.orderTypes,
  });

  String? id;
  String? channelName;
  List<OrderTypeRes>? orderTypes;

  factory ChannelWithOrderType.fromJson(Map<String, dynamic> json) =>
      ChannelWithOrderType(
        id: json["id"],
        channelName: json["channelName"],
        orderTypes: json["orderTypes"] == null
            ? null
            : List<OrderTypeRes>.from(
                json["orderTypes"].map((x) => OrderTypeRes.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "channelName": channelName,
        "orderTypes": orderTypes == null
            ? null
            : List<dynamic>.from(orderTypes!.map((x) => x.toJson())),
      };
}
