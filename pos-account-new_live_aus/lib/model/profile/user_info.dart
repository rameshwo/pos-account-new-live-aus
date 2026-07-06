class UserInfo {
  UserInfo({
    this.countryId,
    this.countryPhoneNumberPrefixId,
    this.id,
    this.cityId,
    this.stateId,
    this.suburbId,
    this.userId,
    this.name,
    this.email,
    this.phoneNumber,
    this.isAdmin,
    this.image,
    this.googleImage,
    this.isTwoFaEnabled,
    this.address,
    this.postalCode,
    this.isPushNotificationEnabled,
    this.roleId,
    this.userTypeId,
    this.isActive,
    this.posTabDefaultScreenName,
    this.enableLoginPinCodePopUpScreen,
    this.loginPinAutoLogOffInterval,
    this.loginPinCode,
    this.confirmLoginPinCode,
  });

  String? countryId;
  String? countryPhoneNumberPrefixId;
  String? id;
  String? cityId;
  String? stateId;
  String? suburbId;
  String? userId;
  String? name;
  String? email;
  String? phoneNumber;
  bool? isAdmin;
  String? image;
  String? googleImage;
  bool? isTwoFaEnabled;
  String? address;
  String? postalCode;
  bool? isPushNotificationEnabled;
  String? roleId;
  String? userTypeId;
  bool? isActive;
  String? posTabDefaultScreenName;
  bool? enableLoginPinCodePopUpScreen;
  String? loginPinAutoLogOffInterval;
  String? loginPinCode;
  String? confirmLoginPinCode;

  factory UserInfo.fromJson(Map<String, dynamic> json) => UserInfo(
        countryId: json["countryId"],
        countryPhoneNumberPrefixId: json["countryPhoneNumberPrefixId"],
        id: json["id"],
        cityId: json["cityId"],
        stateId: json["stateId"],
        suburbId: json["suburbId"],
        userId: json["userId"],
        name: json["name"],
        email: json["email"],
        phoneNumber: json["phoneNumber"],
        isAdmin: json["isAdmin"],
        image: json["image"],
        googleImage: json["googleImage"],
        isTwoFaEnabled: json["isTwoFAEnabled"],
        address: json["address"],
        postalCode: json["postalCode"],
        isPushNotificationEnabled: json["isPushNotificationEnabled"],
        roleId: json["roleId"],
        userTypeId: json["userTypeId"],
        isActive: json["isActive"],
        posTabDefaultScreenName: json["posTabDefaultScreenName"],
        enableLoginPinCodePopUpScreen: json["enableLoginPinCodePopUpScreen"],
        loginPinAutoLogOffInterval: json["loginPinAutoLogOffInterval"],
        loginPinCode: json["loginPinCode"],
        confirmLoginPinCode: json["confirmLoginPinCode"],
      );

  Map<String, dynamic> toJson() => {
        "countryId": countryId,
        "countryPhoneNumberPrefixId": countryPhoneNumberPrefixId,
        "id": id,
        "cityId": cityId,
        "stateId": stateId,
        "suburbId": suburbId,
        "userId": userId,
        "name": name,
        "email": email,
        "phoneNumber": phoneNumber,
        "isAdmin": isAdmin,
        "image": image,
        "googleImage": googleImage,
        "isTwoFAEnabled": isTwoFaEnabled,
        "address": address,
        "postalCode": postalCode,
        "isPushNotificationEnabled": isPushNotificationEnabled,
        "roleId": roleId,
        "userTypeId": userTypeId,
        "isActive": isActive,
        "posTabDefaultScreenName": posTabDefaultScreenName,
        "enableLoginPinCodePopUpScreen": enableLoginPinCodePopUpScreen,
        "loginPinAutoLogOffInterval": loginPinAutoLogOffInterval,
        "loginPinCode": loginPinCode,
        "confirmLoginPinCode": confirmLoginPinCode,
      };
}
