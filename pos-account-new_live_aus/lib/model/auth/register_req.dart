class RegisterReq {
  RegisterReq({
    this.fullName,
    this.email,
    this.password,
    this.confirmPassword,
    this.countryPhoneNumberPrefixId,
    this.countryId,
    this.phoneNumber,
    this.otp,
    this.cityId,
    this.stateId,
    this.suburbId,
    // this.channelPlatForm,
  });

  String? fullName;
  String? email;
  String? password;
  String? confirmPassword;
  String? countryPhoneNumberPrefixId;
  String? countryId;
  String? phoneNumber;
  String? otp;
  String? cityId;
  String? stateId;
  String? suburbId;
  // String? channelPlatForm;

  factory RegisterReq.fromJson(Map<String, dynamic> json) => RegisterReq(
        fullName: json["FullName"],
        email: json["Email"],
        password: json["Password"],
        confirmPassword: json["ConfirmPassword"],
        countryPhoneNumberPrefixId: json["CountryPhoneNumberPrefixId"],
        countryId: json["CountryId"],
        phoneNumber: json["PhoneNumber"],
        otp: json["OTP"],
        cityId: json["CityId"],
        stateId: json["StateId"],
        suburbId: json["SuburbId"],
        // channelPlatForm: json["ChannelPlatForm"],
      );

  Map<String, dynamic> toJson() => {
        "FullName": fullName,
        "Email": email,
        "Password": password,
        "ConfirmPassword": confirmPassword,
        "CountryPhoneNumberPrefixId": countryPhoneNumberPrefixId,
        "CountryId": countryId,
        "PhoneNumber": phoneNumber,
        "OTP": otp,
        "CityId": cityId,
        "StateId": stateId,
        "SuburbId": suburbId,
        // "ChannelPlatForm": channelPlatForm,
      };
}
