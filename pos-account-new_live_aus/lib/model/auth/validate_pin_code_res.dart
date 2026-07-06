class ValidatePinCodeRes {
  String? userId;
  String? posTabDefaultScreenName;
  String? loginPinAutoLogOffInterval;

  ValidatePinCodeRes({
    this.userId,
    this.posTabDefaultScreenName,
    this.loginPinAutoLogOffInterval,
  });

  factory ValidatePinCodeRes.fromJson(Map<String, dynamic> json) =>
      ValidatePinCodeRes(
        userId: json["userId"],
        posTabDefaultScreenName: json["posTabDefaultScreenName"],
        loginPinAutoLogOffInterval: json["loginPinAutoLogOffInterval"],
      );

  Map<String, dynamic> toJson() => {
        "userId": userId,
        "posTabDefaultScreenName": posTabDefaultScreenName,
        "loginPinAutoLogOffInterval": loginPinAutoLogOffInterval,
      };
}
