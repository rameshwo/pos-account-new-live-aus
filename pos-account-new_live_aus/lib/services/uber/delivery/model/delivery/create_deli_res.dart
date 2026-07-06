import 'create_deli_req.dart';

class CreateDeliveryRes {
  String? id;
  String? quoteId;
  bool? complete;
  Courier? courier;
  bool? courierImminent;
  String? created;
  String? currency;
  String? deliverableAction;
  Dropoff? dropoff;
  String? dropoffDeadline;
  String? dropoffEta;
  String? dropoffIdentifier;
  String? dropoffReady;
  String? externalId;
  int? fee;
  String? kind;
  bool? liveMode;
  Manifest? manifest;
  List<ManifestItem>? manifestItems;
  Dropoff? pickup;
  String? pickupDeadline;
  String? pickupEta;
  String? pickupReady;
  RelatedDeliveries? relatedDeliveries;
  String? status;
  int? tip;
  String? trackingUrl;
  String? undeliverableAction;
  String? undeliverableReason;
  String? updated;
  String? uuid;
  Dropoff? createDeliveryResReturn;
  String? batchId;

  CreateDeliveryRes({
    this.id,
    this.quoteId,
    this.complete,
    this.courier,
    this.courierImminent,
    this.created,
    this.currency,
    this.deliverableAction,
    this.dropoff,
    this.dropoffDeadline,
    this.dropoffEta,
    this.dropoffIdentifier,
    this.dropoffReady,
    this.externalId,
    this.fee,
    this.kind,
    this.liveMode,
    this.manifest,
    this.manifestItems,
    this.pickup,
    this.pickupDeadline,
    this.pickupEta,
    this.pickupReady,
    this.relatedDeliveries,
    this.status,
    this.tip,
    this.trackingUrl,
    this.undeliverableAction,
    this.undeliverableReason,
    this.updated,
    this.uuid,
    this.createDeliveryResReturn,
    this.batchId,
  });

  factory CreateDeliveryRes.fromJson(Map<String, dynamic> json) =>
      CreateDeliveryRes(
        id: json["id"],
        quoteId: json["quote_id"],
        complete: json["complete"],
        courier:
            json["courier"] == null ? null : Courier.fromJson(json["courier"]),
        courierImminent: json["courier_imminent"],
        created: json["created"],
        currency: json["currency"],
        deliverableAction: json["deliverable_action"],
        dropoff:
            json["dropoff"] == null ? null : Dropoff.fromJson(json["dropoff"]),
        dropoffDeadline: json["dropoff_deadline"],
        dropoffEta: json["dropoff_eta"],
        dropoffIdentifier: json["dropoff_identifier"],
        dropoffReady: json["dropoff_ready"],
        externalId: json["external_id"],
        fee: json["fee"],
        kind: json["kind"],
        liveMode: json["live_mode"],
        manifest: json["manifest"] == null
            ? null
            : Manifest.fromJson(json["manifest"]),
        manifestItems: json["manifest_items"] == null
            ? []
            : List<ManifestItem>.from(
                json["manifest_items"]!.map((x) => ManifestItem.fromJson(x))),
        pickup:
            json["pickup"] == null ? null : Dropoff.fromJson(json["pickup"]),
        pickupDeadline: json["pickup_deadline"],
        pickupEta: json["pickup_eta"],
        pickupReady: json["pickup_ready"],
        relatedDeliveries: json["related_deliveries"] == null
            ? null
            : RelatedDeliveries.fromJson(json["related_deliveries"]),
        status: json["status"],
        tip: json["tip"],
        trackingUrl: json["tracking_url"],
        undeliverableAction: json["undeliverable_action"],
        undeliverableReason: json["undeliverable_reason"],
        updated: json["updated"],
        uuid: json["uuid"],
        createDeliveryResReturn:
            json["return"] == null ? null : Dropoff.fromJson(json["return"]),
        batchId: json["batch_id"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "quote_id": quoteId,
        "complete": complete,
        "courier": courier?.toJson(),
        "courier_imminent": courierImminent,
        "created": created,
        "currency": currency,
        "deliverable_action": deliverableAction,
        "dropoff": dropoff?.toJson(),
        "dropoff_deadline": dropoffDeadline,
        "dropoff_eta": dropoffEta,
        "dropoff_identifier": dropoffIdentifier,
        "dropoff_ready": dropoffReady,
        "external_id": externalId,
        "fee": fee,
        "kind": kind,
        "live_mode": liveMode,
        "manifest": manifest?.toJson(),
        "manifest_items": manifestItems == null
            ? []
            : List<dynamic>.from(manifestItems!.map((x) => x.toJson())),
        "pickup": pickup?.toJson(),
        "pickup_deadline": pickupDeadline,
        "pickup_eta": pickupEta,
        "pickup_ready": pickupReady,
        "related_deliveries": relatedDeliveries?.toJson(),
        "status": status,
        "tip": tip,
        "tracking_url": trackingUrl,
        "undeliverable_action": undeliverableAction,
        "undeliverable_reason": undeliverableReason,
        "updated": updated,
        "uuid": uuid,
        "return": createDeliveryResReturn?.toJson(),
        "batch_id": batchId,
      };
}

class Courier {
  String? name;
  int? rating;
  String? vehicleType;
  String? phoneNumber;
  Location? location;
  String? imgHref;

  Courier({
    this.name,
    this.rating,
    this.vehicleType,
    this.phoneNumber,
    this.location,
    this.imgHref,
  });

  factory Courier.fromJson(Map<String, dynamic> json) => Courier(
        name: json["name"],
        rating: json["rating"],
        vehicleType: json["vehicle_type"],
        phoneNumber: json["phone_number"],
        location: json["location"] == null
            ? null
            : Location.fromJson(json["location"]),
        imgHref: json["img_href"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "rating": rating,
        "vehicle_type": vehicleType,
        "phone_number": phoneNumber,
        "location": location?.toJson(),
        "img_href": imgHref,
      };
}

class Location {
  double? lat;
  double? lng;

  Location({
    this.lat,
    this.lng,
  });

  factory Location.fromJson(Map<String, dynamic> json) => Location(
        lat: json["lat"]?.toDouble(),
        lng: json["lng"]?.toDouble(),
      );

  Map<String, dynamic> toJson() => {
        "lat": lat,
        "lng": lng,
      };
}

class Dropoff {
  String? name;
  String? phoneNumber;
  String? address;
  DetailedAddress? detailedAddress;
  String? notes;
  String? sellerNotes;
  String? courierNotes;
  Location? location;
  VerificationRequirements? verificationRequirements;
  String? status;
  String? statusTimestamp;
  String? externalStoreId;
  Verification? verification;

  Dropoff({
    this.name,
    this.phoneNumber,
    this.address,
    this.detailedAddress,
    this.notes,
    this.sellerNotes,
    this.courierNotes,
    this.location,
    this.verificationRequirements,
    this.status,
    this.statusTimestamp,
    this.externalStoreId,
    this.verification,
  });

  factory Dropoff.fromJson(Map<String, dynamic> json) => Dropoff(
        name: json["name"],
        phoneNumber: json["phone_number"],
        address: json["address"],
        detailedAddress: json["detailed_address"] == null
            ? null
            : DetailedAddress.fromJson(json["detailed_address"]),
        notes: json["notes"],
        sellerNotes: json["seller_notes"],
        courierNotes: json["courier_notes"],
        location: json["location"] == null
            ? null
            : Location.fromJson(json["location"]),
        verificationRequirements: json["verification_requirements"] == null
            ? null
            : VerificationRequirements.fromJson(
                json["verification_requirements"]),
        status: json["status"],
        statusTimestamp: json["status_timestamp"],
        externalStoreId: json["external_store_id"],
        verification: json["verification"] == null
            ? null
            : Verification.fromJson(json["verification"]),
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "phone_number": phoneNumber,
        "address": address,
        "detailed_address": detailedAddress?.toJson(),
        "notes": notes,
        "seller_notes": sellerNotes,
        "courier_notes": courierNotes,
        "location": location?.toJson(),
        "verification_requirements": verificationRequirements?.toJson(),
        "status": status,
        "status_timestamp": statusTimestamp,
        "external_store_id": externalStoreId,
        "verification": verification?.toJson(),
      };
}

class DetailedAddress {
  String? streetAddress1;
  String? streetAddress2;
  String? city;
  String? state;
  String? zipCode;
  String? country;

  DetailedAddress({
    this.streetAddress1,
    this.streetAddress2,
    this.city,
    this.state,
    this.zipCode,
    this.country,
  });

  factory DetailedAddress.fromJson(Map<String, dynamic> json) =>
      DetailedAddress(
        streetAddress1: json["street_address_1"],
        streetAddress2: json["street_address_2"],
        city: json["city"],
        state: json["state"],
        zipCode: json["zip_code"],
        country: json["country"],
      );

  Map<String, dynamic> toJson() => {
        "street_address_1": streetAddress1,
        "street_address_2": streetAddress2,
        "city": city,
        "state": state,
        "zip_code": zipCode,
        "country": country,
      };
}

class Verification {
  Signature? signature;
  List<VerificationBarcode>? barcodes;
  Picture? picture;
  VerificationIdentification? identification;
  PinCode? pinCode;
  Location? completionLocation;

  Verification({
    this.signature,
    this.barcodes,
    this.picture,
    this.identification,
    this.pinCode,
    this.completionLocation,
  });

  factory Verification.fromJson(Map<String, dynamic> json) => Verification(
        signature: json["signature"] == null
            ? null
            : Signature.fromJson(json["signature"]),
        barcodes: json["barcodes"] == null
            ? []
            : List<VerificationBarcode>.from(
                json["barcodes"]!.map((x) => VerificationBarcode.fromJson(x))),
        picture:
            json["picture"] == null ? null : Picture.fromJson(json["picture"]),
        identification: json["identification"] == null
            ? null
            : VerificationIdentification.fromJson(json["identification"]),
        pinCode: json["pin_code"] == null
            ? null
            : PinCode.fromJson(json["pin_code"]),
        completionLocation: json["completion_location"] == null
            ? null
            : Location.fromJson(json["completion_location"]),
      );

  Map<String, dynamic> toJson() => {
        "signature": signature?.toJson(),
        "barcodes": barcodes == null
            ? []
            : List<dynamic>.from(barcodes!.map((x) => x.toJson())),
        "picture": picture?.toJson(),
        "identification": identification?.toJson(),
        "pin_code": pinCode?.toJson(),
        "completion_location": completionLocation?.toJson(),
      };
}

class VerificationBarcode {
  String? type;
  String? value;
  ScanResult? scanResult;

  VerificationBarcode({
    this.type,
    this.value,
    this.scanResult,
  });

  factory VerificationBarcode.fromJson(Map<String, dynamic> json) =>
      VerificationBarcode(
        type: json["type"],
        value: json["value"],
        scanResult: json["scan_result"] == null
            ? null
            : ScanResult.fromJson(json["scan_result"]),
      );

  Map<String, dynamic> toJson() => {
        "type": type,
        "value": value,
        "scan_result": scanResult?.toJson(),
      };
}

class ScanResult {
  String? outcome;
  String? timestamp;

  ScanResult({
    this.outcome,
    this.timestamp,
  });

  factory ScanResult.fromJson(Map<String, dynamic> json) => ScanResult(
        outcome: json["outcome"],
        timestamp: json["timestamp"],
      );

  Map<String, dynamic> toJson() => {
        "outcome": outcome,
        "timestamp": timestamp,
      };
}

class VerificationIdentification {
  bool? minAgeVerified;

  VerificationIdentification({
    this.minAgeVerified,
  });

  factory VerificationIdentification.fromJson(Map<String, dynamic> json) =>
      VerificationIdentification(
        minAgeVerified: json["min_age_verified"],
      );

  Map<String, dynamic> toJson() => {
        "min_age_verified": minAgeVerified,
      };
}

class Picture {
  String? imageUrl;

  Picture({
    this.imageUrl,
  });

  factory Picture.fromJson(Map<String, dynamic> json) => Picture(
        imageUrl: json["image_url"],
      );

  Map<String, dynamic> toJson() => {
        "image_url": imageUrl,
      };
}

class PinCode {
  String? entered;

  PinCode({
    this.entered,
  });

  factory PinCode.fromJson(Map<String, dynamic> json) => PinCode(
        entered: json["entered"],
      );

  Map<String, dynamic> toJson() => {
        "entered": entered,
      };
}

class Signature {
  String? imageUrl;
  String? name;
  String? signerRelationship;

  Signature({
    this.imageUrl,
    this.name,
    this.signerRelationship,
  });

  factory Signature.fromJson(Map<String, dynamic> json) => Signature(
        imageUrl: json["image_url"],
        name: json["name"],
        signerRelationship: json["signer_relationship"],
      );

  Map<String, dynamic> toJson() => {
        "image_url": imageUrl,
        "name": name,
        "signer_relationship": signerRelationship,
      };
}

class VerificationRequirements {
  bool? signature;
  SignatureRequirement? signatureRequirement;
  List<VerificationRequirementsBarcode>? barcodes;
  Pincode? pincode;
  VerificationRequirementsIdentification? identification;
  bool? picture;

  VerificationRequirements({
    this.signature,
    this.signatureRequirement,
    this.barcodes,
    this.pincode,
    this.identification,
    this.picture,
  });

  factory VerificationRequirements.fromJson(Map<String, dynamic> json) =>
      VerificationRequirements(
        signature: json["signature"],
        signatureRequirement: json["signature_requirement"] == null
            ? null
            : SignatureRequirement.fromJson(json["signature_requirement"]),
        barcodes: json["barcodes"] == null
            ? []
            : List<VerificationRequirementsBarcode>.from(json["barcodes"]!
                .map((x) => VerificationRequirementsBarcode.fromJson(x))),
        pincode:
            json["pincode"] == null ? null : Pincode.fromJson(json["pincode"]),
        identification: json["identification"] == null
            ? null
            : VerificationRequirementsIdentification.fromJson(
                json["identification"]),
        picture: json["picture"],
      );

  Map<String, dynamic> toJson() => {
        "signature": signature,
        "signature_requirement": signatureRequirement?.toJson(),
        "barcodes": barcodes == null
            ? []
            : List<dynamic>.from(barcodes!.map((x) => x.toJson())),
        "pincode": pincode?.toJson(),
        "identification": identification?.toJson(),
        "picture": picture,
      };
}

class VerificationRequirementsBarcode {
  String? value;
  String? type;

  VerificationRequirementsBarcode({
    this.value,
    this.type,
  });

  factory VerificationRequirementsBarcode.fromJson(Map<String, dynamic> json) =>
      VerificationRequirementsBarcode(
        value: json["value"],
        type: json["type"],
      );

  Map<String, dynamic> toJson() => {
        "value": value,
        "type": type,
      };
}

class VerificationRequirementsIdentification {
  int? minAge;

  VerificationRequirementsIdentification({
    this.minAge,
  });

  factory VerificationRequirementsIdentification.fromJson(
          Map<String, dynamic> json) =>
      VerificationRequirementsIdentification(
        minAge: json["min_age"],
      );

  Map<String, dynamic> toJson() => {
        "min_age": minAge,
      };
}

class Pincode {
  bool? enabled;
  String? value;

  Pincode({
    this.enabled,
    this.value,
  });

  factory Pincode.fromJson(Map<String, dynamic> json) => Pincode(
        enabled: json["enabled"],
        value: json["value"],
      );

  Map<String, dynamic> toJson() => {
        "enabled": enabled,
        "value": value,
      };
}

class SignatureRequirement {
  bool? enabled;
  bool? collectSignerName;
  bool? collectSignerRelationship;

  SignatureRequirement({
    this.enabled,
    this.collectSignerName,
    this.collectSignerRelationship,
  });

  factory SignatureRequirement.fromJson(Map<String, dynamic> json) =>
      SignatureRequirement(
        enabled: json["enabled"],
        collectSignerName: json["collect_signer_name"],
        collectSignerRelationship: json["collect_signer_relationship"],
      );

  Map<String, dynamic> toJson() => {
        "enabled": enabled,
        "collect_signer_name": collectSignerName,
        "collect_signer_relationship": collectSignerRelationship,
      };
}

class Manifest {
  String? reference;
  String? description;
  int? totalValue;

  Manifest({
    this.reference,
    this.description,
    this.totalValue,
  });

  factory Manifest.fromJson(Map<String, dynamic> json) => Manifest(
        reference: json["reference"],
        description: json["description"],
        totalValue: json["total_value"],
      );

  Map<String, dynamic> toJson() => {
        "reference": reference,
        "description": description,
        "total_value": totalValue,
      };
}

class RelatedDeliveries {
  String? id;
  String? relationship;

  RelatedDeliveries({
    this.id,
    this.relationship,
  });

  factory RelatedDeliveries.fromJson(Map<String, dynamic> json) =>
      RelatedDeliveries(
        id: json["id"],
        relationship: json["relationship"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "relationship": relationship,
      };
}
