class PosTransactionReq {
  String externalDeviceToken;
  String externalReference;
  int transactionAmount;
  int transactionCurrency;
  int processType;

  PosTransactionReq({
    required this.externalDeviceToken,
    required this.externalReference,
    required this.transactionAmount,
    required this.transactionCurrency,
    required this.processType,
  });

  factory PosTransactionReq.fromJson(Map<String, dynamic> json) =>
      PosTransactionReq(
        externalDeviceToken: json["externalDeviceToken"],
        externalReference: json["externalReference"],
        transactionAmount: json["transactionAmount"],
        transactionCurrency: json["transactionCurrency"],
        processType: json["processType"],
      );

  Map<String, dynamic> toJson() => {
        "externalDeviceToken": externalDeviceToken,
        "externalReference": externalReference,
        "transactionAmount": transactionAmount,
        "transactionCurrency": transactionCurrency,
        "processType": processType,
      };
}
