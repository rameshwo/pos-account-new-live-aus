class EftPosSetup {
  String? id;
  String? eftPosMerchantId;
  String? eftPosMerchantPaymentProviderId;
  String? serialNumber;
  String? ipAddress;
  String? port;
  String? name;

  EftPosSetup({
    this.id,
    this.eftPosMerchantId,
    this.eftPosMerchantPaymentProviderId,
    this.serialNumber,
    this.ipAddress,
    this.port,
    this.name,
  });

  factory EftPosSetup.fromJson(Map<String, dynamic> json) => EftPosSetup(
        id: json["id"],
        eftPosMerchantId: json["eftPosMerchantId"],
        eftPosMerchantPaymentProviderId:
            json["eftPosMerchantPaymentProviderId"],
        serialNumber: json["serialNumber"],
        ipAddress: json["ipAddress"],
        port: json["port"],
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "Id": id,
        "EFTPosMerchantId": eftPosMerchantId,
        "EFTPosMerchantPaymentProviderId": eftPosMerchantPaymentProviderId,
        "SerialNumber": serialNumber,
        "IpAddress": ipAddress,
        "Port": port,
        "Name": name,
      };
}
