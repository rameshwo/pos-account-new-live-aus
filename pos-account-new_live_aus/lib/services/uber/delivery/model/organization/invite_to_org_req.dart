class InviteToOrg {
  UserDetails? userDetails;
  List<String>? roles;

  InviteToOrg({
    this.userDetails,
    this.roles,
  });

  factory InviteToOrg.fromJson(Map<String, dynamic> json) => InviteToOrg(
        userDetails: json["user_details"] == null
            ? null
            : UserDetails.fromJson(json["user_details"]),
        roles: json["roles"] == null
            ? []
            : List<String>.from(json["roles"]!.map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "user_details": userDetails?.toJson(),
        "roles": roles == null ? [] : List<dynamic>.from(roles!.map((x) => x)),
      };
}

class UserDetails {
  String? email;
  String? firstName;
  String? lastName;
  PhoneDetails? phoneDetails;

  UserDetails({
    this.email,
    this.firstName,
    this.lastName,
    this.phoneDetails,
  });

  factory UserDetails.fromJson(Map<String, dynamic> json) => UserDetails(
        email: json["email"],
        firstName: json["first_name"],
        lastName: json["last_name"],
        phoneDetails: json["phone_details"] == null
            ? null
            : PhoneDetails.fromJson(json["phone_details"]),
      );

  Map<String, dynamic> toJson() => {
        "email": email,
        "first_name": firstName,
        "last_name": lastName,
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
