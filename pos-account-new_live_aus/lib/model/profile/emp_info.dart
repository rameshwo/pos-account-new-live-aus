class EmployeeInfo {
  String? code;
  String? fullName;
  String? preferredName;
  String? jobTitle;
  String? countryId;
  String? stateId;
  String? cityId;
  String? postalCode;
  String? genderId;
  String? employmentTypeId;
  String? annualsalary;
  String? hourlyRate;
  String? email;
  String? countryPhoneNumberPrefixId;
  String? phoneNumber;
  String? loginPinCode;
  String? confirmLoginPinCode;
  String? roleId;
  bool? isActive;
  String? posTabDefaultScreenName;
  String? loginPinAutoLogOffInterval;
  bool? enableLoginPinCodePopUpScreen;
  String? emergencyContactName;
  String? emergencyPhone;
  String? emergencyEmail;
  bool? isPushNotificationEnabled;
  String? id;
  String? userId;
  String? password;
  String? confirmPassword;
  String? imagePath;

  EmployeeInfo({
    this.code,
    this.fullName,
    this.preferredName,
    this.jobTitle,
    this.countryId,
    this.stateId,
    this.cityId,
    this.postalCode,
    this.genderId,
    this.employmentTypeId,
    this.annualsalary,
    this.hourlyRate,
    this.email,
    this.countryPhoneNumberPrefixId,
    this.phoneNumber,
    this.loginPinCode,
    this.confirmLoginPinCode,
    this.roleId,
    this.isActive,
    this.posTabDefaultScreenName,
    this.loginPinAutoLogOffInterval,
    this.enableLoginPinCodePopUpScreen,
    this.emergencyContactName,
    this.emergencyPhone,
    this.emergencyEmail,
    this.isPushNotificationEnabled,
    this.id,
    this.userId,
    this.password,
    this.confirmPassword,
    this.imagePath,
  });

  factory EmployeeInfo.fromJson(Map<String, dynamic> json) => EmployeeInfo(
        code: json["code"],
        fullName: json["fullName"],
        preferredName: json["preferredName"],
        jobTitle: json["jobTitle"],
        countryId: json["countryId"],
        stateId: json["stateId"],
        cityId: json["cityId"],
        postalCode: json["postalCode"],
        genderId: json["genderId"],
        employmentTypeId: json["employmentTypeId"],
        annualsalary: json["annualsalary"],
        hourlyRate: json["hourlyRate"],
        email: json["email"],
        countryPhoneNumberPrefixId: json["countryPhoneNumberPrefixId"],
        phoneNumber: json["phoneNumber"],
        loginPinCode: json["loginPinCode"],
        confirmLoginPinCode: json["confirmLoginPinCode"],
        roleId: json["roleId"],
        isActive: json["isActive"],
        posTabDefaultScreenName: json["posTabDefaultScreenName"],
        loginPinAutoLogOffInterval: json["loginPinAutoLogOffInterval"],
        enableLoginPinCodePopUpScreen: json["enableLoginPinCodePopUpScreen"],
        emergencyContactName: json["emergencyContactName"],
        emergencyPhone: json["emergencyPhone"],
        emergencyEmail: json["emergencyEmail"],
        isPushNotificationEnabled: json["isPushNotificationEnabled"],
        id: json["id"],
        userId: json["userId"],
        password: json["password"],
        confirmPassword: json["confirmPassword"],
        imagePath: json["imagePath"],
      );

  Map<String, dynamic> toJson() => {
        "code": code,
        "fullName": fullName,
        "preferredName": preferredName,
        "jobTitle": jobTitle,
        "countryId": countryId,
        "stateId": stateId,
        "cityId": cityId,
        "postalCode": postalCode,
        "genderId": genderId,
        "employmentTypeId": employmentTypeId,
        "annualsalary": annualsalary,
        "hourlyRate": hourlyRate,
        "email": email,
        "countryPhoneNumberPrefixId": countryPhoneNumberPrefixId,
        "phoneNumber": phoneNumber,
        "loginPinCode": loginPinCode,
        "confirmLoginPinCode": confirmLoginPinCode,
        "roleId": roleId,
        "isActive": isActive,
        "posTabDefaultScreenName": posTabDefaultScreenName,
        "loginPinAutoLogOffInterval": loginPinAutoLogOffInterval,
        "enableLoginPinCodePopUpScreen": enableLoginPinCodePopUpScreen,
        "emergencyContactName": emergencyContactName,
        "emergencyPhone": emergencyPhone,
        "emergencyEmail": emergencyEmail,
        "isPushNotificationEnabled": isPushNotificationEnabled,
        "id": id,
        "userId": userId,
        "password": password,
        "confirmPassword": confirmPassword,
      };
}
