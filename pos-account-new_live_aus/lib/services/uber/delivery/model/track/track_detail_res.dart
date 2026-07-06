import 'package:pos_account/services/uber/delivery/model/delivery/create_deli_req.dart';
import 'dart:convert' as convert;

class TrackDetailRes {
  String? id;
  String? orderNumber;
  String? quoteId;
  String? deliveryId;
  String? deliveryName;
  String? deliveryLocation;
  String? deliveryLatitude;
  String? deliveryLongitude;
  String? deliveryPhoneNumber;
  String? deliveryTime;
  String? deliveryDropOffNotes;
  String? deliverableAction;
  List<ManifestItem>? deliveryItems;
  String? pickUpName;
  String? pickupLocation;
  String? pickUpPhoneNumber;
  String? pickUpDropOffNotes;
  String? pickUpLongitude;
  String? pickUpLatitude;
  String? pickUpTime;
  CourierInfo? courierInfo;
  String? trackingUrl;
  List<OrderDeliveryTrackingList>? orderDeliveryTrackingList;
  String? totalPrice;

  TrackDetailRes({
    this.id,
    this.orderNumber,
    this.quoteId,
    this.deliveryId,
    this.deliveryLocation,
    this.deliveryLatitude,
    this.deliveryLongitude,
    this.deliveryPhoneNumber,
    this.deliveryDropOffNotes,
    this.deliverableAction,
    this.deliveryItems,
    this.pickupLocation,
    this.pickUpPhoneNumber,
    this.pickUpDropOffNotes,
    this.pickUpLongitude,
    this.pickUpLatitude,
    this.pickUpTime,
    this.courierInfo,
    this.trackingUrl,
    this.orderDeliveryTrackingList,
    this.deliveryName,
    this.deliveryTime,
    this.totalPrice,
    this.pickUpName,
  });

  factory TrackDetailRes.fromJson(Map<String, dynamic> json) => TrackDetailRes(
        id: json["id"],
        orderNumber: json["orderNumber"],
        quoteId: json["quoteId"],
        deliveryId: json["deliveryId"],
        deliveryName: json["deliveryName"],
        deliveryLocation: json["deliveryLocation"],
        deliveryLatitude: json["deliveryLatitude"],
        deliveryLongitude: json["deliveryLongitude"],
        deliveryPhoneNumber: json["deliveryPhoneNumber"],
        deliveryDropOffNotes: json["deliveryDropOffNotes"],
        deliverableAction: json["deliverableAction"],
        //
        deliveryItems: json["deliveryItems"] == null
            ? null
            : List<ManifestItem>.from(convert.json
                .decode(json["deliveryItems"])!
                .map((x) => ManifestItem.fromJson(x))),
        pickUpName: json["pickUpName"],
        pickupLocation: json["pickupLocation"],
        pickUpPhoneNumber: json["pickUpPhoneNumber"],
        pickUpDropOffNotes: json["pickUpDropOffNotes"],
        pickUpLongitude: json["pickUpLongitude"],
        pickUpLatitude: json["pickUpLatitude"],
        pickUpTime: json["pickUpTime"],
        courierInfo: json["courierInfo"] == null
            ? null
            : CourierInfo.fromJson(convert.json.decode(json["courierInfo"])),
        trackingUrl: json["trackingUrl"],
        orderDeliveryTrackingList: json["orderDeliveryTrackingList"] == null
            ? []
            : List<OrderDeliveryTrackingList>.from(
                json["orderDeliveryTrackingList"]!
                    .map((x) => OrderDeliveryTrackingList.fromJson(x))),
        totalPrice: json["totalAmount"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "orderNumber": orderNumber,
        "quoteId": quoteId,
        "deliveryId": deliveryId,
        "deliveryName": deliveryName,
        "deliveryTime": deliveryTime,
        "deliveryLocation": deliveryLocation,
        "deliveryLatitude": deliveryLatitude,
        "deliveryLongitude": deliveryLongitude,
        "deliveryPhoneNumber": deliveryPhoneNumber,
        "deliveryDropOffNotes": deliveryDropOffNotes,
        "deliverableAction": deliverableAction,
        "deliveryItems":
            convert.json.encode(deliveryItems?.map((e) => e.toJson()).toList()),
        "pickUpName": pickUpName,
        "pickupLocation": pickupLocation,
        "pickUpPhoneNumber": pickUpPhoneNumber,
        "pickUpDropOffNotes": pickUpDropOffNotes,
        "pickUpLongitude": pickUpLongitude,
        "pickUpLatitude": pickUpLatitude,
        "pickUpTime": pickUpTime,
        "courierInfo": convert.json.encode(courierInfo?.toJson()),
        "trackingUrl": trackingUrl,
        "orderDeliveryTrackingList": orderDeliveryTrackingList == null
            ? []
            : List<dynamic>.from(
                orderDeliveryTrackingList!.map((x) => x.toJson())),
        "totalAmount": totalPrice,
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

class CourierInfo {
  Data? data;

  CourierInfo({
    this.data,
  });

  factory CourierInfo.fromJson(Map<String, dynamic> json) => CourierInfo(
        data: json["data"] == null ? null : Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "data": data?.toJson(),
      };
}

class Data {
  Courier? courier;

  Data({
    this.courier,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        courier:
            json["courier"] == null ? null : Courier.fromJson(json["courier"]),
      );

  Map<String, dynamic> toJson() => {
        "courier": courier?.toJson(),
      };
}

class Courier {
  String? name;
  String? phoneNumber;
  String? vehicleType;
  String? vehicleModel;
  String? vehicleMake;
  String? vehicleColor;
  String? rating;

  Courier({
    this.name,
    this.phoneNumber,
    this.vehicleType,
    this.vehicleModel,
    this.vehicleMake,
    this.vehicleColor,
    this.rating,
  });

  factory Courier.fromJson(Map<String, dynamic> json) => Courier(
        name: json["name"],
        phoneNumber: json["phone_number"],
        vehicleType: json["vehicle_type"],
        vehicleModel: json["vehicle_model"],
        vehicleMake: json["vehicle_make"],
        vehicleColor: json["vehicle_color"],
        rating: json["rating"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "phone_number": phoneNumber,
        "vehicle_type": vehicleType,
        "vehicle_model": vehicleModel,
        "vehicle_make": vehicleMake,
        "vehicle_color": vehicleColor,
        "rating": rating,
      };
}
