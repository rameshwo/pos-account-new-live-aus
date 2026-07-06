class CreateDeliPosReq {
  String? orderId;
  String? quoteId;
  String? deliveryId;
  String? deliveryLocation;
  String? deliveryLatitude;
  String? deliveryLongitude;
  String? deliveryPhoneNumber;
  String? deliveryDropOffNotes;
  String? deliverableAction;
  String? pickupLocation;
  String? pickUpPhoneNumber;
  String? pickUpDropOffNotes;
  String? pickUpLongitude;
  String? pickUpLatitude;
  String? deliveryItems;
  String? trackingUrl;
  String? pickUpTime;
  String? courierInfo;
  String? deliveryTrackingRequest;
  String? deliveryTrackingResponse;
  String? totalAmount;

  CreateDeliPosReq({
    this.orderId,
    this.quoteId,
    this.deliveryId,
    this.deliveryLocation,
    this.deliveryLatitude,
    this.deliveryLongitude,
    this.deliveryPhoneNumber,
    this.deliveryDropOffNotes,
    this.deliverableAction,
    this.pickupLocation,
    this.pickUpPhoneNumber,
    this.pickUpDropOffNotes,
    this.pickUpLongitude,
    this.pickUpLatitude,
    this.deliveryItems,
    this.trackingUrl,
    this.pickUpTime,
    this.courierInfo,
    this.deliveryTrackingRequest,
    this.deliveryTrackingResponse,
    this.totalAmount,
  });

  factory CreateDeliPosReq.fromJson(Map<String, dynamic> json) =>
      CreateDeliPosReq(
        orderId: json["OrderId"],
        quoteId: json["QuoteId"],
        deliveryId: json["DeliveryId"],
        deliveryLocation: json["DeliveryLocation"],
        deliveryLatitude: json["DeliveryLatitude"],
        deliveryLongitude: json["DeliveryLongitude"],
        deliveryPhoneNumber: json["DeliveryPhoneNumber"],
        deliveryDropOffNotes: json["DeliveryDropOffNotes"],
        deliverableAction: json["DeliverableAction"],
        pickupLocation: json["PickupLocation"],
        pickUpPhoneNumber: json["PickUpPhoneNumber"],
        pickUpDropOffNotes: json["PickUpDropOffNotes"],
        pickUpLongitude: json["PickUpLongitude"],
        pickUpLatitude: json["PickUpLatitude"],
        deliveryItems: json["DeliveryItems"],
        trackingUrl: json["TrackingUrl"],
        pickUpTime: json["PickUpTime"],
        courierInfo: json["CourierInfo"],
        deliveryTrackingRequest: json["DeliveryTrackingRequest"],
        deliveryTrackingResponse: json["DeliveryTrackingResponse"],
        totalAmount: json["totalAmount"],
      );

  Map<String, dynamic> toJson() => {
        "OrderId": orderId,
        "QuoteId": quoteId,
        "DeliveryId": deliveryId,
        "DeliveryLocation": deliveryLocation,
        "DeliveryLatitude": deliveryLatitude,
        "DeliveryLongitude": deliveryLongitude,
        "DeliveryPhoneNumber": deliveryPhoneNumber,
        "DeliveryDropOffNotes": deliveryDropOffNotes,
        "DeliverableAction": deliverableAction,
        "PickupLocation": pickupLocation,
        "PickUpPhoneNumber": pickUpPhoneNumber,
        "PickUpDropOffNotes": pickUpDropOffNotes,
        "PickUpLongitude": pickUpLongitude,
        "PickUpLatitude": pickUpLatitude,
        "DeliveryItems": deliveryItems,
        "TrackingUrl": trackingUrl,
        "PickUpTime": pickUpTime,
        "CourierInfo": courierInfo,
        "DeliveryTrackingRequest": deliveryTrackingRequest,
        "DeliveryTrackingResponse": deliveryTrackingResponse,
        "totalAmount": totalAmount,
      };
}
