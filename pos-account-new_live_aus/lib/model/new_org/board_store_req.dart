class BoardStoreReq {
  BoardStoreReq({
    this.name,
    this.email,
    this.countryPhoneNumberPrefixId,
    this.phoneNumber,
    this.address,
    this.businessTypeCategoryId,
    this.businessTypeId,
    this.timeZoneId,
    this.countryId,
    this.cityId,
    this.abnNumber,
    this.isTermsAndConditionsAccepted,
    this.isPrivacyPolicyAccepted,
    this.channelType,
    this.latitude,
    this.longitude,
    this.stateId,
    this.suburbId,
  });

  String? name;
  String? email;
  String? countryPhoneNumberPrefixId;
  String? phoneNumber;
  String? address;
  String? businessTypeCategoryId;
  String? businessTypeId;
  String? timeZoneId;
  String? countryId;
  String? cityId;
  String? abnNumber;
  bool? isTermsAndConditionsAccepted;
  bool? isPrivacyPolicyAccepted;
  String? channelType;
  String? latitude;
  String? longitude;
  String? stateId;
  String? suburbId;

  factory BoardStoreReq.fromJson(Map<String, dynamic> json) => BoardStoreReq(
        name: json["Name"],
        email: json["Email"],
        countryPhoneNumberPrefixId: json["CountryPhoneNumberPrefixId"],
        phoneNumber: json["PhoneNumber"],
        address: json["Address"],
        businessTypeCategoryId: json["businessTypeCategoryId"],
        businessTypeId: json["BusinessTypeId"],
        timeZoneId: json["TimeZoneId"],
        countryId: json["CountryId"],
        cityId: json["CityId"],
        abnNumber: json["ABNNumber"],
        isTermsAndConditionsAccepted: json["IsTermsAndConditionsAccepted"],
        isPrivacyPolicyAccepted: json["IsPrivacyPolicyAccepted"],
        channelType: json["ChannelType"],
        latitude: json["Latitude"],
        longitude: json["Longitude"],
        stateId: json["StateId"],
        suburbId: json["SuburbId"],
      );

  Map<String, dynamic> toJson() => {
        "Name": name,
        "Email": email,
        "CountryPhoneNumberPrefixId": countryPhoneNumberPrefixId,
        "PhoneNumber": phoneNumber,
        "Address": address,
        "BusinessTypeCategoryId": businessTypeCategoryId,
        "BusinessTypeId": businessTypeId,
        "TimeZoneId": timeZoneId,
        "CountryId": countryId,
        "CityId": cityId,
        "ABNNumber": abnNumber,
        "IsTermsAndConditionsAccepted": isTermsAndConditionsAccepted,
        "IsPrivacyPolicyAccepted": isPrivacyPolicyAccepted,
        "ChannelType": channelType,
        "Latitude": latitude,
        "Longitude": longitude,
        "StateId": stateId,
        "SuburbId": suburbId,
      };
}
