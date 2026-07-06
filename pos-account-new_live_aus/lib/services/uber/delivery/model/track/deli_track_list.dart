import 'package:pos_account/model/common/message.dart';

class DeliTrackRes {
  List<DeliTrackData>? data;
  List<Message>? message;
  int? total;
  bool? isError;
  int? status;

  DeliTrackRes({
    this.data,
    this.message,
    this.total,
    this.isError,
    this.status,
  });

  factory DeliTrackRes.fromJson(Map<String, dynamic> json) => DeliTrackRes(
        data: json["data"] == null
            ? []
            : List<DeliTrackData>.from(
                json["data"]!.map((x) => DeliTrackData.fromJson(x))),
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

class DeliTrackData {
  String? id;
  String? orderNumber;
  String? deliveryLocation;
  String? pickUpTime;
  String? trackingStatus;
  List<OrderDeliveryTrackingList>? orderDeliveryTrackingList;
  int? total;

  DeliTrackData({
    this.id,
    this.orderNumber,
    this.deliveryLocation,
    this.pickUpTime,
    this.trackingStatus,
    this.orderDeliveryTrackingList,
    this.total,
  });

  factory DeliTrackData.fromJson(Map<String, dynamic> json) => DeliTrackData(
        id: json["id"],
        orderNumber: json["orderNumber"],
        deliveryLocation: json["deliveryLocation"],
        pickUpTime: json["pickUpTime"],
        trackingStatus: json["trackingStatus"],
        orderDeliveryTrackingList: json["orderDeliveryTrackingList"] == null
            ? []
            : List<OrderDeliveryTrackingList>.from(
                json["orderDeliveryTrackingList"]!
                    .map((x) => OrderDeliveryTrackingList.fromJson(x))),
        total: json["total"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "orderNumber": orderNumber,
        "deliveryLocation": deliveryLocation,
        "pickUpTime": pickUpTime,
        "trackingStatus": trackingStatus,
        "orderDeliveryTrackingList": orderDeliveryTrackingList == null
            ? []
            : List<dynamic>.from(
                orderDeliveryTrackingList!.map((x) => x.toJson())),
        "total": total,
      };
}

class OrderDeliveryTrackingList {
  String? trackingStatus;
  String? trackingStatusDescription;

  OrderDeliveryTrackingList({
    this.trackingStatus,
    this.trackingStatusDescription,
  });

  factory OrderDeliveryTrackingList.fromJson(Map<String, dynamic> json) =>
      OrderDeliveryTrackingList(
        trackingStatus: json["trackingStatus"],
        trackingStatusDescription: json["trackingStatusDescription"],
      );

  Map<String, dynamic> toJson() => {
        "trackingStatus": trackingStatus,
        "trackingStatusDescription": trackingStatusDescription,
      };
}
