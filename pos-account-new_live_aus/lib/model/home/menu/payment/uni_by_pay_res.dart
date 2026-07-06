class UniByPayRes {
  UniByPayRes({
    this.senderName,
    this.senderPhoneNumber,
    this.uniqueCode,
    this.amount,
    this.isDiscount,
    this.receiverName,
    this.receiverPhoneNumber,
    this.actualAmount,
    this.discountPercentage,
    this.receiverEmail,
    this.receiverCustomerId,
  });

  String? senderName;
  String? senderPhoneNumber;
  String? uniqueCode;
  String? amount;
  bool? isDiscount;
  String? receiverName;
  String? receiverPhoneNumber;
  String? actualAmount;
  String? discountPercentage;
  String? receiverEmail;
  String? receiverCustomerId;

  factory UniByPayRes.fromJson(Map<String, dynamic> json) => UniByPayRes(
        senderName: json["senderName"],
        senderPhoneNumber: json["senderPhoneNumber"],
        uniqueCode: json["uniqueCode"],
        amount: json["amount"],
        isDiscount: json["isDiscount"],
        receiverName: json["receiverName"],
        receiverPhoneNumber: json["receiverPhoneNumber"],
        actualAmount: json["actualAmount"],
        discountPercentage: json["discountPercentage"],
        receiverEmail: json["receiverEmail"],
        receiverCustomerId: json["receiverCustomerId"],
      );

  Map<String, dynamic> toJson() => {
        "senderName": senderName,
        "senderPhoneNumber": senderPhoneNumber,
        "uniqueCode": uniqueCode,
        "amount": amount,
        "isDiscount": isDiscount,
        "receiverName": receiverName,
        "receiverPhoneNumber": receiverPhoneNumber,
        "actualAmount": actualAmount,
        "discountPercentage": discountPercentage,
        "receiverEmail": receiverEmail,
        "receiverCustomerId": receiverCustomerId,
      };
}
