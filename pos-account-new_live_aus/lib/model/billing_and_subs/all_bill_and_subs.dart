class AllBillAndSubs {
  AllBillAndSubs({
    this.message,
    this.isCommissionBasedPlanEnabled,
    this.cardDetailsViewModels,
    this.subscriptionPlanDetails,
  });
  String? message;
  bool? isCommissionBasedPlanEnabled;
  List<CardDetailsViewModel>? cardDetailsViewModels;
  SubscriptionPlanDetails? subscriptionPlanDetails;

  factory AllBillAndSubs.fromJson(Map<String, dynamic> json) => AllBillAndSubs(
        message: json["message"],
        isCommissionBasedPlanEnabled: json["isCommissionBasedPlanEnabled"],
        cardDetailsViewModels: json["cardDetailsViewModels"] == null
            ? null
            : List<CardDetailsViewModel>.from(json["cardDetailsViewModels"]
                .map((x) => CardDetailsViewModel.fromJson(x))),
        subscriptionPlanDetails: json["subscriptionPlanDetails"] == null
            ? null
            : SubscriptionPlanDetails.fromJson(json["subscriptionPlanDetails"]),
      );

  Map<String, dynamic> toJson() => {
        "message": message,
        "isCommissionBasedPlanEnabled": isCommissionBasedPlanEnabled,
        "cardDetailsViewModels": cardDetailsViewModels == null
            ? null
            : List<dynamic>.from(cardDetailsViewModels!.map((x) => x.toJson())),
        "subscriptionPlanDetails": subscriptionPlanDetails?.toJson(),
      };
}

class CardDetailsViewModel {
  CardDetailsViewModel({
    this.cardNumber,
    this.expiryMonth,
    this.expiryYear,
    this.cardType,
  });

  String? cardNumber;
  String? expiryMonth;
  String? expiryYear;
  String? cardType;

  factory CardDetailsViewModel.fromJson(Map<String, dynamic> json) =>
      CardDetailsViewModel(
        cardNumber: json["cardNumber"],
        expiryMonth: json["expiryMonth"],
        expiryYear: json["expiryYear"],
        cardType: json["cardType"],
      );

  Map<String, dynamic> toJson() => {
        "cardNumber": cardNumber,
        "expiryMonth": expiryMonth,
        "expiryYear": expiryYear,
        "cardType": cardType,
      };
}

class SubscriptionPlanDetails {
  SubscriptionPlanDetails({
    this.planName,
    this.amount,
    this.storeSubscriptionPlanId,
    this.numberofPosLocation,
  });

  String? planName;
  String? amount;
  String? storeSubscriptionPlanId;
  String? numberofPosLocation;

  factory SubscriptionPlanDetails.fromJson(Map<String, dynamic> json) =>
      SubscriptionPlanDetails(
        planName: json["planName"],
        amount: json["amount"],
        storeSubscriptionPlanId: json["storeSubscriptionPlanId"],
        numberofPosLocation: json["numberofPOSLocation"],
      );

  Map<String, dynamic> toJson() => {
        "planName": planName,
        "amount": amount,
        "storeSubscriptionPlanId": storeSubscriptionPlanId,
        "numberofPOSLocation": numberofPosLocation,
      };
}
