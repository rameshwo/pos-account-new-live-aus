class MxPairModel {
  String? serialNumber;
  String? posId;
  bool? isDefault;

  MxPairModel({
    this.serialNumber,
    this.posId,
    this.isDefault,
  });

  factory MxPairModel.fromJson(Map<String, dynamic> json) => MxPairModel(
      serialNumber: json["serial_number"],
      posId: json["pos_id"],
      isDefault: json["is_default"]);

  Map<String, dynamic> toJson() => {
        "serial_number": serialNumber,
        "pos_id": posId,
        "is_default": isDefault,
      };
}
