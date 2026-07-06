class CreateUpUser {
  CreateUpUser({
    this.id,
    this.fullName,
    this.phoneNumber,
    this.countryPhoneNumberPrefixId,
    this.email,
    this.countryId,
    this.cityId,
    this.stateId,
    this.suburbId,
    this.address,
    this.postalCode,
    this.password,
    this.confirmPassword,
    this.userTypeId,
    this.isPushNotificationEnabled,
    // this.channelPlatform,
    this.roleId,
    this.isActive,
    this.isImageDeleted,
    this.posTabDefaultScreenName,
    this.enableLoginPinCodePopUpScreen,
    this.loginPinAutoLogOffInterval,
    this.loginPinCode,
    this.confirmLoginPinCode,
  });

  String? id;
  String? fullName;
  String? phoneNumber;
  String? countryPhoneNumberPrefixId;
  String? email;
  String? countryId;
  String? cityId;
  String? stateId;
  String? suburbId;
  String? address;
  String? postalCode;
  String? password;
  String? confirmPassword;
  String? userTypeId;
  bool? isPushNotificationEnabled;
  // String? channelPlatform;
  String? roleId;
  bool? isActive;
  bool? isImageDeleted;
  String? posTabDefaultScreenName;
  bool? enableLoginPinCodePopUpScreen;
  String? loginPinAutoLogOffInterval;
  String? loginPinCode;
  String? confirmLoginPinCode;

  factory CreateUpUser.fromJson(Map<String, dynamic> json) => CreateUpUser(
        id: json["Id"],
        fullName: json["FullName"],
        phoneNumber: json["PhoneNumber"],
        countryPhoneNumberPrefixId: json["CountryPhoneNumberPrefixId"],
        email: json["Email"],
        countryId: json["CountryId"],
        cityId: json["CityId"],
        stateId: json["StateId"],
        suburbId: json["SuburbId"],
        address: json["Address"],
        postalCode: json["PostalCode"],
        password: json["Password"],
        confirmPassword: json["ConfirmPassword"],
        userTypeId: json["UserTypeId"],
        isPushNotificationEnabled: json["IsPushNotificationEnabled"],
        // channelPlatform: json["ChannelPlatform"],
        roleId: json["RoleId"],
        isActive: json["IsActive"],
        isImageDeleted: json["IsImageDeleted"],
        posTabDefaultScreenName: json["posTabDefaultScreenName"],
        enableLoginPinCodePopUpScreen: json["enableLoginPinCodePopUpScreen"],
        loginPinAutoLogOffInterval: json["loginPinAutoLogOffInterval"],
        loginPinCode: json["loginPinCode"],
        confirmLoginPinCode: json["confirmLoginPinCode"],
      );

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {
      "Id": id,
      "FullName": fullName,
      "PhoneNumber": phoneNumber,
      "CountryPhoneNumberPrefixId": countryPhoneNumberPrefixId,
      "Email": email,
      "CountryId": countryId,
      "CityId": cityId,
      "StateId": stateId,
      "SuburbId": suburbId,
      "Address": address,
      "PostalCode": postalCode,
      "IsPushNotificationEnabled": isPushNotificationEnabled,
      "IsActive": isActive,
      "IsImageDeleted": isImageDeleted,
      "posTabDefaultScreenName": posTabDefaultScreenName,
      "enableLoginPinCodePopUpScreen": enableLoginPinCodePopUpScreen,
      "loginPinAutoLogOffInterval": loginPinAutoLogOffInterval,
      "loginPinCode": loginPinCode,
      if (confirmLoginPinCode?.isNotEmpty ?? false)
        "confirmLoginPinCode": confirmLoginPinCode,
    };

    if (password != null && password!.isNotEmpty) {
      data.addAll({
        "Password": password,
      });
    }
    if (confirmPassword != null && confirmPassword!.isNotEmpty) {
      data.addAll({
        "ConfirmPassword": confirmPassword,
      });
    }
    if (userTypeId != null && userTypeId!.isNotEmpty) {
      data.addAll({
        "UserTypeId": userTypeId,
      });
    }

    if (roleId != null && roleId!.isNotEmpty) {
      data.addAll({
        "RoleId": roleId,
      });
    }

    // if (channelPlatform != null) {
    //   _data.addAll({
    //     "ChannelPlatform": channelPlatform,
    //   });
    // }

    return data;
  }
}
