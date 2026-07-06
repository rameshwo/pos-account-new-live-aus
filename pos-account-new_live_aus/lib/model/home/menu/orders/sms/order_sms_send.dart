class OrderSmsSendReq {
  String? orderId;
  String? message;
  String? phoneNumber;
  String? phoneNumberPrefix;

  OrderSmsSendReq({
    this.orderId,
    this.message,
    this.phoneNumber,
    this.phoneNumberPrefix,
  });

  factory OrderSmsSendReq.fromJson(Map<String, dynamic> json) =>
      OrderSmsSendReq(
        orderId: json["OrderId"],
        message: json["Message"],
        phoneNumber: json["PhoneNumber"],
        phoneNumberPrefix: json["PhoneNumberPrefix"],
      );

  Map<String, dynamic> toJson() => {
        "OrderId": orderId,
        "Message": message,
        "PhoneNumber": phoneNumber,
        "PhoneNumberPrefix": phoneNumberPrefix,
      };
}
