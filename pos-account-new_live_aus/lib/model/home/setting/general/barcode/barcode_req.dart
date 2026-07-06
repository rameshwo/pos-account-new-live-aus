class BarCodeReq {
  BarCodeReq({
    this.id,
    this.barCodeTypeId,
    this.isDefault,
  });

  String? id;
  String? barCodeTypeId;
  bool? isDefault;

  factory BarCodeReq.fromJson(Map<String, dynamic> json) => BarCodeReq(
        id: json["Id"],
        barCodeTypeId: json["BarCodeTypeId"],
        isDefault: json["IsDefault"],
      );

  Map<String, dynamic> toJson() => {
        "Id": id,
        "BarCodeTypeId": barCodeTypeId,
        "IsDefault": isDefault,
      };
}
