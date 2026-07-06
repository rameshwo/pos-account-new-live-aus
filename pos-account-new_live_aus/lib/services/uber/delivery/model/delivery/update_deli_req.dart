class UpdateDeliverytReq {
  String? dropoffNotes;
  Verification? dropoffVerification;
  String? manifestReference;
  String? pickupNotes;
  Verification? pickupVerification;
  bool? requiresDropoffSignature;
  bool? requiresId;
  int? tipByCustomer;
  double? dropoffLatitude;
  double? dropoffLongitude;

  UpdateDeliverytReq({
    this.dropoffNotes,
    this.dropoffVerification,
    this.manifestReference,
    this.pickupNotes,
    this.pickupVerification,
    this.requiresDropoffSignature,
    this.requiresId,
    this.tipByCustomer,
    this.dropoffLatitude,
    this.dropoffLongitude,
  });

  factory UpdateDeliverytReq.fromJson(Map<String, dynamic> json) =>
      UpdateDeliverytReq(
        dropoffNotes: json["dropoff_notes"],
        dropoffVerification: json["dropoff_verification"] == null
            ? null
            : Verification.fromJson(json["dropoff_verification"]),
        manifestReference: json["manifest_reference"],
        pickupNotes: json["pickup_notes"],
        pickupVerification: json["pickup_verification"] == null
            ? null
            : Verification.fromJson(json["pickup_verification"]),
        requiresDropoffSignature: json["requires_dropoff_signature"],
        requiresId: json["requires_id"],
        tipByCustomer: json["tip_by_customer"],
        dropoffLatitude: json["dropoff_latitude"]?.toDouble(),
        dropoffLongitude: json["dropoff_longitude"]?.toDouble(),
      );

  Map<String, dynamic> toJson() => {
        "dropoff_notes": dropoffNotes,
        "dropoff_verification": dropoffVerification?.toJson(),
        "manifest_reference": manifestReference,
        "pickup_notes": pickupNotes,
        "pickup_verification": pickupVerification?.toJson(),
        "requires_dropoff_signature": requiresDropoffSignature,
        "requires_id": requiresId,
        "tip_by_customer": tipByCustomer,
        "dropoff_latitude": dropoffLatitude,
        "dropoff_longitude": dropoffLongitude,
      };
}

class Verification {
  List<Barcode>? barcodes;

  Verification({
    this.barcodes,
  });

  factory Verification.fromJson(Map<String, dynamic> json) => Verification(
        barcodes: json["barcodes"] == null
            ? []
            : List<Barcode>.from(
                json["barcodes"]!.map((x) => Barcode.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "barcodes": barcodes == null
            ? []
            : List<dynamic>.from(barcodes!.map((x) => x.toJson())),
      };
}

class Barcode {
  String? value;
  String? type;

  Barcode({
    this.value,
    this.type,
  });

  factory Barcode.fromJson(Map<String, dynamic> json) => Barcode(
        value: json["value"],
        type: json["type"],
      );

  Map<String, dynamic> toJson() => {
        "value": value,
        "type": type,
      };
}
