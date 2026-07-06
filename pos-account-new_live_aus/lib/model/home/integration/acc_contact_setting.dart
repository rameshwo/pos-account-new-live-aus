class AccContactSetting {
  AccContactSetting({
    this.id,
    this.name,
    this.accountingPlatFormId,
  });

  String? id;
  dynamic name;
  String? accountingPlatFormId;

  factory AccContactSetting.fromJson(Map<String, dynamic> json) =>
      AccContactSetting(
        id: json["id"],
        name: json["name"],
        accountingPlatFormId: json["accountingPlatFormId"],
      );

  Map<String, dynamic> toJson() => {
        "Id": id,
        "Name": name,
        "AccountingPlatFormId": accountingPlatFormId,
      };
}
