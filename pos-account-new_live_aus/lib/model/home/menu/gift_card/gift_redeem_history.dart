class GiftRedeemHistory {
  GiftRedeemHistory({
    this.giftCardCode,
    this.amount,
    this.senderName,
    this.receiverName,
    this.remainingAmount,
    this.purchasedDate,
    this.expiryDate,
    this.status,
    this.statusEnum,
    this.giftCardReedemSummaryDetails,
  });

  String? giftCardCode;
  String? amount;
  String? senderName;
  String? receiverName;
  String? remainingAmount;
  String? purchasedDate;
  String? expiryDate;
  String? status;
  String? statusEnum;
  List<GiftCardReedemSummaryDetail>? giftCardReedemSummaryDetails;

  factory GiftRedeemHistory.fromJson(Map<String, dynamic> json) =>
      GiftRedeemHistory(
        giftCardCode: json["giftCardCode"],
        amount: json["amount"],
        senderName: json["senderName"],
        receiverName: json["receiverName"],
        remainingAmount: json["remainingAmount"],
        purchasedDate: json["purchasedDate"],
        expiryDate: json["expiryDate"],
        status: json["status"],
        statusEnum: json["statusEnum"],
        giftCardReedemSummaryDetails:
            json["giftCardReedemSummaryDetails"] == null
                ? []
                : List<GiftCardReedemSummaryDetail>.from(
                    json["giftCardReedemSummaryDetails"]!
                        .map((x) => GiftCardReedemSummaryDetail.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "giftCardCode": giftCardCode,
        "amount": amount,
        "senderName": senderName,
        "receiverName": receiverName,
        "remainingAmount": remainingAmount,
        "purchasedDate": purchasedDate,
        "expiryDate": expiryDate,
        "status": status,
        "statusEnum": statusEnum,
        "giftCardReedemSummaryDetails": giftCardReedemSummaryDetails == null
            ? []
            : List<dynamic>.from(
                giftCardReedemSummaryDetails!.map((x) => x.toJson())),
      };
}

class GiftCardReedemSummaryDetail {
  GiftCardReedemSummaryDetail({
    this.spendAmount,
    this.reedemDate,
    this.customerName,
  });

  String? spendAmount;
  String? reedemDate;
  String? customerName;

  factory GiftCardReedemSummaryDetail.fromJson(Map<String, dynamic> json) =>
      GiftCardReedemSummaryDetail(
        spendAmount: json["spendAmount"],
        reedemDate: json["reedemDate"],
        customerName: json["customerName"],
      );

  Map<String, dynamic> toJson() => {
        "spendAmount": spendAmount,
        "reedemDate": reedemDate,
        "customerName": customerName,
      };
}
