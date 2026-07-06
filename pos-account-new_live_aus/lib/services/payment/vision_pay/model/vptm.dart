class VisionPayTransactionMessage {
  String? applicationId;
  String? applicationLabel;
  int? applicationTransactionCounter;
  String? authorizationId;
  int? authorizationType;
  String? cardExpiryDate;
  String? cardSequenceNumber;
  String? cardSignature;
  String? cardType;
  int? cardVerificationMethod;
  String? completedUtcDateTime;
  String? createdUtcDateTime;
  String? externalReference;
  String? gatewayResponse;
  String? gatewayResponseCode;
  String? im30Reference;
  int? im30State;
  String? im30TerminalId;
  String? merchantId;
  String? stan;
  int? transactionAmount;
  int? transactionCurency;
  int? transactionStatus;
  int? transactionType;

  VisionPayTransactionMessage({
    this.applicationId,
    this.applicationLabel,
    this.applicationTransactionCounter,
    this.authorizationId,
    this.authorizationType,
    this.cardExpiryDate,
    this.cardSequenceNumber,
    this.cardSignature,
    this.cardType,
    this.cardVerificationMethod,
    this.completedUtcDateTime,
    this.createdUtcDateTime,
    this.externalReference,
    this.gatewayResponse,
    this.gatewayResponseCode,
    this.im30Reference,
    this.im30State,
    this.im30TerminalId,
    this.merchantId,
    this.stan,
    this.transactionAmount,
    this.transactionCurency,
    this.transactionStatus,
    this.transactionType,
  });

  factory VisionPayTransactionMessage.fromJson(Map<String, dynamic> json) =>
      VisionPayTransactionMessage(
        applicationId: json["applicationId"],
        applicationLabel: json["applicationLabel"],
        applicationTransactionCounter: json["applicationTransactionCounter"],
        authorizationId: json["authorizationId"],
        authorizationType: json["authorizationType"],
        cardExpiryDate: json["cardExpiryDate"],
        cardSequenceNumber: json["cardSequenceNumber"],
        cardSignature: json["cardSignature"],
        cardType: json["cardType"],
        cardVerificationMethod: json["cardVerificationMethod"],
        completedUtcDateTime: json["completedUTCDateTime"],
        createdUtcDateTime: json["createdUTCDateTime"],
        externalReference: json["externalReference"],
        gatewayResponse: json["gatewayResponse"],
        gatewayResponseCode: json["gatewayResponseCode"],
        im30Reference: json["im30Reference"],
        im30State: json["im30State"],
        im30TerminalId: json["im30TerminalId"],
        merchantId: json["merchantId"],
        stan: json["stan"],
        transactionAmount: json["transactionAmount"],
        transactionCurency: json["transactionCurency"],
        transactionStatus: json["transactionStatus"],
        transactionType: json["transactionType"],
      );

  Map<String, dynamic> toJson() => {
        "applicationId": applicationId,
        "applicationLabel": applicationLabel,
        "applicationTransactionCounter": applicationTransactionCounter,
        "authorizationId": authorizationId,
        "authorizationType": authorizationType,
        "cardExpiryDate": cardExpiryDate,
        "cardSequenceNumber": cardSequenceNumber,
        "cardSignature": cardSignature,
        "cardType": cardType,
        "cardVerificationMethod": cardVerificationMethod,
        "completedUTCDateTime": completedUtcDateTime,
        "createdUTCDateTime": createdUtcDateTime,
        "externalReference": externalReference,
        "gatewayResponse": gatewayResponse,
        "gatewayResponseCode": gatewayResponseCode,
        "im30Reference": im30Reference,
        "im30State": im30State,
        "im30TerminalId": im30TerminalId,
        "merchantId": merchantId,
        "stan": stan,
        "transactionAmount": transactionAmount,
        "transactionCurency": transactionCurency,
        "transactionStatus": transactionStatus,
        "transactionType": transactionType,
      };
}
