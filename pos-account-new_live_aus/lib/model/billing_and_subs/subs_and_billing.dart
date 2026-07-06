class SubsAndBilling {
  SubsAndBilling({
    this.subscriptionPlanId,
    this.numberofPosLocation,
    this.isTermsAndConditionAccepted,
    this.totalAmount,
    this.creditCardDetails,
    this.billingAddressDetails,
    this.isCommissionBasedPlan,
  });

  String? subscriptionPlanId;
  String? numberofPosLocation;
  bool? isTermsAndConditionAccepted;
  String? totalAmount;
  CreditCardDetails? creditCardDetails;
  BillingAddressDetails? billingAddressDetails;
  bool? isCommissionBasedPlan;

  factory SubsAndBilling.fromJson(Map<String, dynamic> json) => SubsAndBilling(
        subscriptionPlanId: json["SubscriptionPlanId"],
        numberofPosLocation: json["NumberofPOSLocation"],
        isTermsAndConditionAccepted: json["IsTermsAndConditionAccepted"],
        totalAmount: json["TotalAmount"],
        creditCardDetails: json["CreditCardDetails"] == null
            ? null
            : CreditCardDetails.fromJson(json["CreditCardDetails"]),
        billingAddressDetails: json["BillingAddressDetails"] == null
            ? null
            : BillingAddressDetails.fromJson(json["BillingAddressDetails"]),
        isCommissionBasedPlan: json["IsCommissionBasedPlan"],
      );

  Map<String, dynamic> toJson() => {
        "SubscriptionPlanId": subscriptionPlanId,
        "NumberofPOSLocation": numberofPosLocation,
        "TotalAmount": totalAmount,
        "IsTermsAndConditionAccepted": isTermsAndConditionAccepted,
        "CreditCardDetails": creditCardDetails?.toJson(),
        "BillingAddressDetails": billingAddressDetails?.toJson(),
        "IsCommissionBasedPlan": isCommissionBasedPlan,
      };
}

class BillingAddressDetails {
  BillingAddressDetails({
    this.countryId,
    this.cityId,
    this.stateId,
    this.suburbId,
    this.street,
    this.postCode,
  });

  String? countryId;
  String? cityId;
  String? stateId;
  String? suburbId;
  String? street;
  String? postCode;

  factory BillingAddressDetails.fromJson(Map<String, dynamic> json) =>
      BillingAddressDetails(
        countryId: json["CountryId"],
        cityId: json["CityId"],
        stateId: json["StateId"],
        suburbId: json["SuburbId"],
        street: json["Street"],
        postCode: json["PostCode"],
      );

  Map<String, dynamic> toJson() => {
        "CountryId": countryId,
        "CityId": cityId,
        "StateId": stateId,
        "SuburbId": suburbId,
        "Street": street,
        "PostCode": postCode,
      };
}

class CreditCardDetails {
  CreditCardDetails({
    this.nameOnCard,
    this.cardNumber,
    this.cvcNumber,
    this.expiryMonth,
    this.expiryYear,
    this.email,
  });

  String? nameOnCard;
  String? cardNumber;
  String? cvcNumber;
  String? expiryMonth;
  String? expiryYear;
  String? email;

  factory CreditCardDetails.fromJson(Map<String, dynamic> json) =>
      CreditCardDetails(
        nameOnCard: json["NameOnCard"],
        cardNumber: json["CardNumber"],
        cvcNumber: json["CVCNumber"],
        expiryMonth: json["ExpiryMonth"],
        expiryYear: json["ExpiryYear"],
        email: json["Email"],
      );

  Map<String, dynamic> toJson() => {
        "NameOnCard": nameOnCard,
        "CardNumber": cardNumber,
        "CVCNumber": cvcNumber,
        "ExpiryMonth": expiryMonth,
        "ExpiryYear": expiryYear,
        "Email": email,
      };
}
