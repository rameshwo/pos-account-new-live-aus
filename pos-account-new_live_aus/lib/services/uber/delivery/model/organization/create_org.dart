class CreateOrg {
  String? organizationId;
  Info? info;
  HierarchyInfo? hierarchyInfo;
  Options? options;

  CreateOrg({
    this.organizationId,
    this.info,
    this.hierarchyInfo,
    this.options,
  });

  factory CreateOrg.fromJson(Map<String, dynamic> json) => CreateOrg(
        organizationId: json["organization_id"],
        info: json["info"] == null ? null : Info.fromJson(json["info"]),
        hierarchyInfo: json["hierarchy_info"] == null
            ? null
            : HierarchyInfo.fromJson(json["hierarchy_info"]),
        options:
            json["options"] == null ? null : Options.fromJson(json["options"]),
      );

  Map<String, dynamic> toJson() => {
        if (organizationId != null) "organization_id": organizationId,
        "info": info?.toJson(),
        "hierarchy_info": hierarchyInfo?.toJson(),
        "options": options?.toJson(),
      };
}

class HierarchyInfo {
  String? parentOrganizationId;

  HierarchyInfo({
    this.parentOrganizationId,
  });

  factory HierarchyInfo.fromJson(Map<String, dynamic> json) => HierarchyInfo(
        parentOrganizationId: json["parent_organization_id"],
      );

  Map<String, dynamic> toJson() => {
        "parent_organization_id": parentOrganizationId,
      };
}

class Info {
  String? name;
  String? billingType;
  String? merchantType;
  PointOfContact? pointOfContact;
  Address? address;

  Info({
    this.name,
    this.billingType,
    this.merchantType,
    this.pointOfContact,
    this.address,
  });

  factory Info.fromJson(Map<String, dynamic> json) => Info(
        name: json["name"],
        billingType: json["billing_type"],
        merchantType: json["merchant_type"],
        pointOfContact: json["point_of_contact"] == null
            ? null
            : PointOfContact.fromJson(json["point_of_contact"]),
        address:
            json["address"] == null ? null : Address.fromJson(json["address"]),
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "billing_type": billingType,
        "merchant_type": merchantType,
        "point_of_contact": pointOfContact?.toJson(),
        "address": address?.toJson(),
      };
}

class Address {
  String? street1;
  String? street2;
  String? city;
  String? state;
  String? zipcode;
  String? countryIso2;

  Address({
    this.street1,
    this.street2,
    this.city,
    this.state,
    this.zipcode,
    this.countryIso2,
  });

  factory Address.fromJson(Map<String, dynamic> json) => Address(
        street1: json["street1"],
        street2: json["street2"],
        city: json["city"],
        state: json["state"],
        zipcode: json["zipcode"],
        countryIso2: json["country_iso2"],
      );

  Map<String, dynamic> toJson() => {
        "street1": street1,
        "street2": street2,
        "city": city,
        "state": state,
        "zipcode": zipcode,
        "country_iso2": countryIso2,
      };
}

class PointOfContact {
  String? email;
  PhoneDetails? phoneDetails;

  PointOfContact({
    this.email,
    this.phoneDetails,
  });

  factory PointOfContact.fromJson(Map<String, dynamic> json) => PointOfContact(
        email: json["email"],
        phoneDetails: json["phone_details"] == null
            ? null
            : PhoneDetails.fromJson(json["phone_details"]),
      );

  Map<String, dynamic> toJson() => {
        "email": email,
        "phone_details": phoneDetails?.toJson(),
      };
}

class PhoneDetails {
  String? phoneNumber;
  String? countryCode;
  String? subscriberNumber;

  PhoneDetails({
    this.phoneNumber,
    this.countryCode,
    this.subscriberNumber,
  });

  factory PhoneDetails.fromJson(Map<String, dynamic> json) => PhoneDetails(
        phoneNumber: json["phone_number"],
        countryCode: json["country_code"],
        subscriberNumber: json["subscriber_number"],
      );

  Map<String, dynamic> toJson() => {
        "phone_number": phoneNumber,
        "country_code": countryCode,
        "subscriber_number": subscriberNumber,
      };
}

class Options {
  String? onboardingInviteType;

  Options({
    this.onboardingInviteType,
  });

  factory Options.fromJson(Map<String, dynamic> json) => Options(
        onboardingInviteType: json["onboarding_invite_type"],
      );

  Map<String, dynamic> toJson() => {
        "onboarding_invite_type": onboardingInviteType,
      };
}
