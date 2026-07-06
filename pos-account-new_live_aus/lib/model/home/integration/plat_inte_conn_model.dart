class PlatInteConnById {
  String? integrationPlatFormId;
  String? integrationPlatFormName;
  List<IntegrationPlatformConnectionCredential>?
      integrationPlatformConnectionCredentials;

  PlatInteConnById({
    this.integrationPlatFormId,
    this.integrationPlatFormName,
    this.integrationPlatformConnectionCredentials,
  });

  factory PlatInteConnById.fromJson(Map<String, dynamic> json) =>
      PlatInteConnById(
        integrationPlatFormId: json["integrationPlatFormId"],
        integrationPlatFormName: json["integrationPlatFormName"],
        integrationPlatformConnectionCredentials:
            json["integrationPlatformConnectionCredentials"] == null
                ? []
                : List<IntegrationPlatformConnectionCredential>.from(
                    json["integrationPlatformConnectionCredentials"]!.map((x) =>
                        IntegrationPlatformConnectionCredential.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "integrationPlatFormId": integrationPlatFormId,
        "integrationPlatFormName": integrationPlatFormName,
        "integrationPlatformConnectionCredentials":
            integrationPlatformConnectionCredentials == null
                ? []
                : List<dynamic>.from(integrationPlatformConnectionCredentials!
                    .map((x) => x.toJson())),
      };
}

class IntegrationPlatformConnectionCredential {
  String? id;
  String? integrationPlatformId;
  String? customerId;
  String? keyOrId;
  String? secret;
  String? serialNumber;
  String? posNameOrId;
  String? currency;
  // bool? isDefault;
  String? posDeviceId;
  String? name;
  String? merchantName;
  String? merchantType;

  IntegrationPlatformConnectionCredential({
    this.id,
    this.integrationPlatformId,
    this.customerId,
    this.keyOrId,
    this.secret,
    this.serialNumber,
    this.posNameOrId,
    this.currency,
    // this.isDefault,
    this.posDeviceId,
    this.name,
    this.merchantName,
    this.merchantType,
  });

  factory IntegrationPlatformConnectionCredential.fromJson(
          Map<String, dynamic> json) =>
      IntegrationPlatformConnectionCredential(
        id: json["id"],
        integrationPlatformId: json["integrationPlatformId"],
        customerId: json["customerId"],
        keyOrId: json["keyOrId"],
        secret: json["secret"],
        serialNumber: json["serialNumber"],
        posNameOrId: json["posNameOrId"],
        currency: json["currency"],
        // isDefault: json["isDefault"],
        posDeviceId: json["posDeviceId"],
        name: json["name"],
        merchantName: json["merchantName"],
        merchantType: json["merchantType"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "integrationPlatformId": integrationPlatformId,
        "customerId": customerId,
        "keyOrId": keyOrId,
        "secret": secret,
        "serialNumber": serialNumber,
        "posNameOrId": posNameOrId,
        "currency": currency,
        // "isDefault": isDefault,
        "posDeviceId": posDeviceId,
        "name": name,
        "merchantName": merchantName,
        "merchantType": merchantType,
      };
}
