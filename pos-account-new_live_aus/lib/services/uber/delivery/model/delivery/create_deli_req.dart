class CreateDeliveryReq {
  String? pickupName;
  String? pickupAddress;
  // UberDeliAddress? pickupAddress;
  String? pickupPhoneNumber;
  String? dropoffName;
  String? dropoffAddress;
  // UberDeliAddress? dropoffAddress;
  String? dropoffPhoneNumber;
  List<ManifestItem>? manifestItems;
  String? pickupBusinessName;
  double? pickupLatitude;
  double? pickupLongitude;
  String? pickupNotes;
  Verification? pickupVerification;
  String? dropoffBusinessName;
  double? dropoffLatitude;
  double? dropoffLongitude;
  String? dropoffNotes;
  String? dropoffSellerNotes;
  Verification? dropoffVerification;
  String? deliverableAction;
  String? manifestReference;
  int? manifestTotalValue;
  String? quoteId;
  String? pickupReadyDt;
  String? pickupDeadlineDt;
  String? dropoffReadyDt;
  String? dropoffDeadlineDt;
  bool? requiresDropoffSignature;
  bool? requiresId;
  int? tip;
  String? idempotencyKey;
  String? externalStoreId;
  Verification? returnVerification;
  ExternalUserInfo? externalUserInfo;
  String? externalId;

  CreateDeliveryReq({
    this.pickupName,
    this.pickupAddress,
    this.pickupPhoneNumber,
    this.dropoffName,
    this.dropoffAddress,
    this.dropoffPhoneNumber,
    this.manifestItems,
    this.pickupBusinessName,
    this.pickupLatitude,
    this.pickupLongitude,
    this.pickupNotes,
    this.pickupVerification,
    this.dropoffBusinessName,
    this.dropoffLatitude,
    this.dropoffLongitude,
    this.dropoffNotes,
    this.dropoffSellerNotes,
    this.dropoffVerification,
    this.deliverableAction,
    this.manifestReference,
    this.manifestTotalValue,
    this.quoteId,
    this.pickupReadyDt,
    this.pickupDeadlineDt,
    this.dropoffReadyDt,
    this.dropoffDeadlineDt,
    this.requiresDropoffSignature,
    this.requiresId,
    this.tip,
    this.idempotencyKey,
    this.externalStoreId,
    this.returnVerification,
    this.externalUserInfo,
    this.externalId,
  });

  factory CreateDeliveryReq.fromJson(Map<String, dynamic> json) =>
      CreateDeliveryReq(
        pickupName: json["pickup_name"],
        pickupAddress: json["pickup_address"],
        //  == null
        //     ? null
        //     : UberDeliAddress.fromJson(
        //         _json.json.decode(json["pickup_address"])),
        pickupPhoneNumber: json["pickup_phone_number"],
        dropoffName: json["dropoff_name"],
        dropoffAddress: json["dropoff_address"],
        // == null
        //     ? null
        //     : UberDeliAddress.fromJson(
        //         _json.json.decode(json["dropoff_address"])),
        dropoffPhoneNumber: json["dropoff_phone_number"],
        manifestItems: json["manifest_items"] == null
            ? []
            : List<ManifestItem>.from(
                json["manifest_items"]!.map((x) => ManifestItem.fromJson(x))),
        pickupBusinessName: json["pickup_business_name"],
        pickupLatitude: json["pickup_latitude"]?.toDouble(),
        pickupLongitude: json["pickup_longitude"]?.toDouble(),
        pickupNotes: json["pickup_notes"],
        pickupVerification: json["pickup_verification"] == null
            ? null
            : Verification.fromJson(json["pickup_verification"]),
        dropoffBusinessName: json["dropoff_business_name"],
        dropoffLatitude: json["dropoff_latitude"]?.toDouble(),
        dropoffLongitude: json["dropoff_longitude"]?.toDouble(),
        dropoffNotes: json["dropoff_notes"],
        dropoffSellerNotes: json["dropoff_seller_notes"],
        dropoffVerification: json["dropoff_verification"] == null
            ? null
            : Verification.fromJson(json["dropoff_verification"]),
        deliverableAction: json["deliverable_action"],
        manifestReference: json["manifest_reference"],
        manifestTotalValue: json["manifest_total_value"],
        quoteId: json["quote_id"],
        pickupReadyDt: json["pickup_ready_dt"],
        pickupDeadlineDt: json["pickup_deadline_dt"],
        dropoffReadyDt: json["dropoff_ready_dt"],
        dropoffDeadlineDt: json["dropoff_deadline_dt"],
        requiresDropoffSignature: json["requires_dropoff_signature"],
        requiresId: json["requires_id"],
        tip: json["tip"],
        idempotencyKey: json["idempotency_key"],
        externalStoreId: json["external_store_id"],
        returnVerification: json["return_verification"] == null
            ? null
            : Verification.fromJson(json["return_verification"]),
        externalUserInfo: json["external_user_info"] == null
            ? null
            : ExternalUserInfo.fromJson(json["external_user_info"]),
        externalId: json["external_id"],
      );

  Map<String, dynamic> toJson() => {
        "pickup_name": pickupName,
        "pickup_address": pickupAddress,
        // != null
        //     ? _json.json.encode(pickupAddress?.toJson())
        //     : "",
        "pickup_phone_number": pickupPhoneNumber,
        "dropoff_name": dropoffName,
        "dropoff_address": dropoffAddress,
        // != null
        //     ? _json.json.encode(dropoffAddress?.toJson())
        //     : "",
        "dropoff_phone_number": dropoffPhoneNumber,
        "manifest_items": manifestItems == null
            ? []
            : List<dynamic>.from(manifestItems!.map((x) => x.toJson())),
        "pickup_business_name": pickupBusinessName,
        "pickup_latitude": pickupLatitude,
        "pickup_longitude": pickupLongitude,
        "pickup_notes": pickupNotes,
        "pickup_verification": pickupVerification?.toJson(),
        "dropoff_business_name": dropoffBusinessName,
        "dropoff_latitude": dropoffLatitude,
        "dropoff_longitude": dropoffLongitude,
        "dropoff_notes": dropoffNotes,
        "dropoff_seller_notes": dropoffSellerNotes,
        "dropoff_verification": dropoffVerification?.toJson(),
        "deliverable_action": deliverableAction,
        "manifest_reference": manifestReference,
        "manifest_total_value": manifestTotalValue,
        "quote_id": quoteId,
        "pickup_ready_dt": pickupReadyDt,
        "pickup_deadline_dt": pickupDeadlineDt,
        "dropoff_ready_dt": dropoffReadyDt,
        "dropoff_deadline_dt": dropoffDeadlineDt,
        "requires_dropoff_signature": requiresDropoffSignature,
        "requires_id": requiresId,
        "tip": tip,
        "idempotency_key": idempotencyKey,
        "external_store_id": externalStoreId,
        "return_verification": returnVerification?.toJson(),
        "external_user_info": externalUserInfo?.toJson(),
        "external_id": externalId,
      };
}

class Verification {
  bool? signature;
  SignatureRequirement? signatureRequirement;
  List<Barcode>? barcodes;
  Identification? identification;
  bool? picture;

  Verification({
    this.signature,
    this.signatureRequirement,
    this.barcodes,
    this.identification,
    this.picture,
  });

  factory Verification.fromJson(Map<String, dynamic> json) => Verification(
        signature: json["signature"],
        signatureRequirement: json["signature_requirement"] == null
            ? null
            : SignatureRequirement.fromJson(json["signature_requirement"]),
        barcodes: json["barcodes"] == null
            ? []
            : List<Barcode>.from(
                json["barcodes"]!.map((x) => Barcode.fromJson(x))),
        identification: json["identification"] == null
            ? null
            : Identification.fromJson(json["identification"]),
        picture: json["picture"],
      );

  Map<String, dynamic> toJson() => {
        "signature": signature,
        "signature_requirement": signatureRequirement?.toJson(),
        "barcodes": barcodes == null
            ? []
            : List<dynamic>.from(barcodes!.map((x) => x.toJson())),
        "identification": identification?.toJson(),
        "picture": picture,
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

class Identification {
  int? minAge;

  Identification({
    this.minAge,
  });

  factory Identification.fromJson(Map<String, dynamic> json) => Identification(
        minAge: json["min_age"],
      );

  Map<String, dynamic> toJson() => {
        "min_age": minAge,
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

class ExternalUserInfo {
  MerchantAccount? merchantAccount;
  Device? device;

  ExternalUserInfo({
    this.merchantAccount,
    this.device,
  });

  factory ExternalUserInfo.fromJson(Map<String, dynamic> json) =>
      ExternalUserInfo(
        merchantAccount: json["merchant_account"] == null
            ? null
            : MerchantAccount.fromJson(json["merchant_account"]),
        device: json["device"] == null ? null : Device.fromJson(json["device"]),
      );

  Map<String, dynamic> toJson() => {
        "merchant_account": merchantAccount?.toJson(),
        "device": device?.toJson(),
      };
}

class Device {
  String? id;

  Device({
    this.id,
  });

  factory Device.fromJson(Map<String, dynamic> json) => Device(
        id: json["id"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
      };
}

class MerchantAccount {
  String? accountCreatedAt;
  String? email;

  MerchantAccount({
    this.accountCreatedAt,
    this.email,
  });

  factory MerchantAccount.fromJson(Map<String, dynamic> json) =>
      MerchantAccount(
        accountCreatedAt: json["account_created_at"],
        email: json["email"],
      );

  Map<String, dynamic> toJson() => {
        "account_created_at": accountCreatedAt,
        "email": email,
      };
}

class ManifestItem {
  String? name;
  int? quantity;
  String? size;
  Dimensions? dimensions;
  int? price;
  bool? mustBeUpright;
  int? weight;
  int? vatPercentage;

  ManifestItem({
    this.name,
    this.quantity,
    this.size,
    this.dimensions,
    this.price,
    this.mustBeUpright,
    this.weight,
    this.vatPercentage,
  });

  factory ManifestItem.fromJson(Map<String, dynamic> json) => ManifestItem(
        name: json["name"],
        quantity: json["quantity"],
        size: json["size"],
        dimensions: json["dimensions"] == null
            ? null
            : Dimensions.fromJson(json["dimensions"]),
        price: json["price"],
        mustBeUpright: json["must_be_upright"],
        weight: json["weight"],
        vatPercentage: json["vat_percentage"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "quantity": quantity,
        "size": size,
        "dimensions": dimensions?.toJson(),
        "price": price,
        "must_be_upright": mustBeUpright,
        "weight": weight,
        "vat_percentage": vatPercentage,
      };
}

class Dimensions {
  int? length;
  int? height;
  int? depth;

  Dimensions({
    this.length,
    this.height,
    this.depth,
  });

  factory Dimensions.fromJson(Map<String, dynamic> json) => Dimensions(
        length: json["length"],
        height: json["height"],
        depth: json["depth"],
      );

  Map<String, dynamic> toJson() => {
        "length": length,
        "height": height,
        "depth": depth,
      };
}
