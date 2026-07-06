class PosTransactionRes {
  String? externalReference;
  String? im30Reference;
  int? state;
  String? errorMessage;

  PosTransactionRes({
    this.externalReference,
    this.im30Reference,
    this.state,
    this.errorMessage,
  });

  factory PosTransactionRes.fromJson(Map<String, dynamic> json) =>
      PosTransactionRes(
        externalReference: json["externalReference"],
        im30Reference: json["im30Reference"],
        state: json["state"],
        errorMessage: json["errorMessage"],
      );

  Map<String, dynamic> toJson() => {
        "externalReference": externalReference,
        "im30Reference": im30Reference,
        "state": state,
        "errorMessage": errorMessage,
      };
}
