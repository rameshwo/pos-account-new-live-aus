class ReceiptMessage {
  String? cardSignature;
  String? completedUtcDateTime;
  String? createdUtcDateTime;
  int? receiptState;

  ReceiptMessage({
    this.cardSignature,
    this.completedUtcDateTime,
    this.createdUtcDateTime,
    this.receiptState,
  });

  factory ReceiptMessage.fromJson(Map<String, dynamic> json) => ReceiptMessage(
        cardSignature: json["cardSignature"],
        completedUtcDateTime: json["completedUTCDateTime"],
        createdUtcDateTime: json["createdUTCDateTime"],
        receiptState: json["receiptState"],
      );

  Map<String, dynamic> toJson() => {
        "cardSignature": cardSignature,
        "completedUTCDateTime": completedUtcDateTime,
        "createdUTCDateTime": createdUtcDateTime,
        "receiptState": receiptState,
      };
}
