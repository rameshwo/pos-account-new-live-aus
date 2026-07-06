class BillingSubsPlan {
  BillingSubsPlan({
    this.subscriptionPlanId,
    this.countryId,
    this.subscriptionPlanName,
    this.currencyCode,
    this.amount,
    this.numberofDevice,
    this.planItems,
    this.numberOfDevicePlanPrices,
    this.subscripitonPlanGroup,
  });

  String? subscriptionPlanId;
  String? countryId;
  String? subscriptionPlanName;
  String? currencyCode;
  String? amount;
  String? numberofDevice;
  List<String>? planItems;
  List<NumberOfDevicePlanPrice>? numberOfDevicePlanPrices;
  String? subscripitonPlanGroup;

  factory BillingSubsPlan.fromJson(Map<String, dynamic> json) =>
      BillingSubsPlan(
        subscriptionPlanId: json["subscriptionPlanId"],
        countryId: json["countryId"],
        subscriptionPlanName: json["subscriptionPlanName"],
        currencyCode: json["currencyCode"],
        amount: json["amount"],
        numberofDevice: json["numberofDevice"],
        planItems: json["planItems"] == null
            ? null
            : List<String>.from(json["planItems"]!.map((x) => x)),
        numberOfDevicePlanPrices: json["numberOfDevicePlanPrices"] == null
            ? null
            : List<NumberOfDevicePlanPrice>.from(
                json["numberOfDevicePlanPrices"]!
                    .map((x) => NumberOfDevicePlanPrice.fromJson(x))),
        subscripitonPlanGroup: json["subscripitonPlanGroup"],
      );

  Map<String, dynamic> toJson() => {
        "subscriptionPlanId": subscriptionPlanId,
        "countryId": countryId,
        "subscriptionPlanName": subscriptionPlanName,
        "currencyCode": currencyCode,
        "amount": amount,
        "numberofDevice": numberofDevice,
        "planItems": planItems == null
            ? null
            : List<dynamic>.from(planItems!.map((x) => x)),
        "numberOfDevicePlanPrices": numberOfDevicePlanPrices == null
            ? null
            : List<dynamic>.from(
                numberOfDevicePlanPrices!.map((x) => x.toJson())),
        "subscripitonPlanGroup": subscripitonPlanGroup,
      };
}

class NumberOfDevicePlanPrice {
  NumberOfDevicePlanPrice({
    this.numberOfDevice,
    this.price,
    this.subscriptionPlanEnum,
    this.isDefault,
  });

  String? numberOfDevice;
  String? price;
  int? subscriptionPlanEnum;
  bool? isDefault;

  factory NumberOfDevicePlanPrice.fromJson(Map<String, dynamic> json) =>
      NumberOfDevicePlanPrice(
        numberOfDevice: json["numberOfDevice"],
        price: json["price"],
        subscriptionPlanEnum: json["subscriptionPlanEnum"],
        isDefault: json["isDefault"],
      );

  Map<String, dynamic> toJson() => {
        "numberOfDevice": numberOfDevice,
        "price": price,
        "subscriptionPlanEnum": subscriptionPlanEnum,
        "isDefault": isDefault,
      };
}
