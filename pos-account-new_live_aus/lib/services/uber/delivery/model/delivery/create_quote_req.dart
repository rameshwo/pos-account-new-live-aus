class CreateQuoteReq {
  // UberDeliAddress? pickupAddress;
  // UberDeliAddress? dropoffAddress;
  String? pickupAddress;
  String? dropoffAddress;
  double? pickupLatitude;
  double? pickupLongitude;
  double? dropoffLatitude;
  double? dropoffLongitude;
  String? pickupReadyDt;
  String? pickupDeadlineDt;
  String? dropoffReadyDt;
  String? dropoffDeadlineDt;
  String? pickupPhoneNumber;
  String? dropoffPhoneNumber;
  int? manifestTotalValue;
  String? externalStoreId;

  CreateQuoteReq({
    this.pickupAddress,
    this.dropoffAddress,
    this.pickupLatitude,
    this.pickupLongitude,
    this.dropoffLatitude,
    this.dropoffLongitude,
    this.pickupReadyDt,
    this.pickupDeadlineDt,
    this.dropoffReadyDt,
    this.dropoffDeadlineDt,
    this.pickupPhoneNumber,
    this.dropoffPhoneNumber,
    this.manifestTotalValue,
    this.externalStoreId,
  });

  factory CreateQuoteReq.fromJson(Map<String, dynamic> json) => CreateQuoteReq(
        pickupAddress: json["pickup_address"],
        // json["pickup_address"] == null
        //     ? null
        //     : UberDeliAddress.fromJson(
        //         _json.json.decode(json["pickup_address"])),
        dropoffAddress: json["dropoff_address"],
        //  json["dropoff_address"] == null
        //     ? null
        //     : UberDeliAddress.fromJson(
        //         _json.json.decode(json["dropoff_address"])),
        pickupLatitude: json["pickup_latitude"]?.toDouble(),
        pickupLongitude: json["pickup_longitude"]?.toDouble(),
        dropoffLatitude: json["dropoff_latitude"]?.toDouble(),
        dropoffLongitude: json["dropoff_longitude"]?.toDouble(),
        pickupReadyDt: json["pickup_ready_dt"],
        pickupDeadlineDt: json["pickup_deadline_dt"],
        dropoffReadyDt: json["dropoff_ready_dt"],
        dropoffDeadlineDt: json["dropoff_deadline_dt"],
        pickupPhoneNumber: json["pickup_phone_number"],
        dropoffPhoneNumber: json["dropoff_phone_number"],
        manifestTotalValue: json["manifest_total_value"],
        externalStoreId: json["external_store_id"],
      );

  Map<String, dynamic> toJson() => {
        "pickup_address": pickupAddress,
        // != null
        //     ? _json.json.encode(pickupAddress?.toJson())
        //     : "",
        "dropoff_address": dropoffAddress,
        //  != null
        //     ? _json.json.encode(dropoffAddress?.toJson())
        //     : "",
        "pickup_latitude": pickupLatitude,
        "pickup_longitude": pickupLongitude,
        "dropoff_latitude": dropoffLatitude,
        "dropoff_longitude": dropoffLongitude,
        "pickup_ready_dt": pickupReadyDt,
        "pickup_deadline_dt": pickupDeadlineDt,
        "dropoff_ready_dt": dropoffReadyDt,
        "dropoff_deadline_dt": dropoffDeadlineDt,
        "pickup_phone_number": pickupPhoneNumber,
        "dropoff_phone_number": dropoffPhoneNumber,
        "manifest_total_value": manifestTotalValue,
        "external_store_id": externalStoreId,
      };
}
