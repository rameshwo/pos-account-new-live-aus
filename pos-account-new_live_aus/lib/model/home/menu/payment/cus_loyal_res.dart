class CusForLoyalityRes {
  CusForLoyalityRes({
    this.id = "",
    this.customerName,
    this.email,
    this.phoneNumber,
    this.eligibleLoyaltyPoints = "0",
    this.accquiredPoints = "0",
    this.eligibleAmount = "0",
    this.message,
    this.loyaltyEnabled,
    this.customerTypeId,
    this.isMarketingPromotionEnabled,
    this.countryPhoneNumberPrefixId,
    this.countryId,
    this.postalCode,
    this.line,
    this.totalRemainingPoints,
    this.loyaltyPaymentAllowed,
    this.orderSummary,
  });

  String id;
  String? customerName;
  String? email;
  String? phoneNumber;
  String eligibleLoyaltyPoints;
  String accquiredPoints;
  String eligibleAmount;
  String? message;
  bool? loyaltyEnabled;
  String? customerTypeId;
  bool? isMarketingPromotionEnabled;
  String? countryPhoneNumberPrefixId;
  String? countryId;
  String? postalCode;
  // for caller id
  String? line;
  String? totalRemainingPoints;
  bool? loyaltyPaymentAllowed;
  OrderSummary? orderSummary;

  factory CusForLoyalityRes.fromJson(Map<String, dynamic> json) =>
      CusForLoyalityRes(
        id: json["id"] ?? '',
        customerName: json["customerName"],
        email: json["email"],
        phoneNumber: json["phoneNumber"],
        eligibleLoyaltyPoints: json["eligibleLoyaltyPoints"] ?? '0',
        accquiredPoints: json["accquiredPoints"] ?? '0',
        eligibleAmount: json["eligibleAmount"] ?? '0',
        message: json["message"],
        loyaltyEnabled: json["loyaltyEnabled"],
        customerTypeId: json["customerTypeId"],
        isMarketingPromotionEnabled: json["isMarketingPromotionEnabled"],
        countryPhoneNumberPrefixId: json["countryPhoneNumberPrefixId"],
        countryId: json["countryId"],
        postalCode: json["postalCode"],
        totalRemainingPoints: json["totalRemainingPoints"],
        loyaltyPaymentAllowed: json["loyaltyPaymentAllowed"],
        orderSummary: json["orderSummary"] == null
            ? null
            : OrderSummary.fromJson(json["orderSummary"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "customerName": customerName,
        "email": email,
        "phoneNumber": phoneNumber,
        "eligibleLoyaltyPoints": eligibleLoyaltyPoints,
        "accquiredPoints": accquiredPoints,
        "eligibleAmount": eligibleAmount,
        "message": message,
        "loyaltyEnabled": loyaltyEnabled,
        "customerTypeId": customerTypeId,
        "isMarketingPromotionEnabled": isMarketingPromotionEnabled,
        "countryPhoneNumberPrefixId": countryPhoneNumberPrefixId,
        "countryId": countryId,
        "postalCode": postalCode,
        "totalRemainingPoints": totalRemainingPoints,
        "loyaltyPaymentAllowed": loyaltyPaymentAllowed,
        "orderSummary": orderSummary?.toJson(),
      };
}

class OrderSummary {
  String? netSales;
  String? discounts;
  String? totalOrders;

  OrderSummary({
    this.netSales,
    this.discounts,
    this.totalOrders,
  });

  factory OrderSummary.fromJson(Map<String, dynamic> json) => OrderSummary(
        netSales: json["netSales"],
        discounts: json["discounts"],
        totalOrders: json["totalOrders"],
      );

  Map<String, dynamic> toJson() => {
        "netSales": netSales,
        "discounts": discounts,
        "totalOrders": totalOrders,
      };
}
