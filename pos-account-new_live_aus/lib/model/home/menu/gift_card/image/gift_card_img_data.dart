class GiftCardImageData {
  String? id;
  String? name;
  bool? isActive;
  String? templateName;
  String? imagePath;
  String? giftCardTemplateGroupId;
  String? amount;
  String? giftCardTemplateGroupName;

  GiftCardImageData({
    this.id,
    this.name,
    this.isActive,
    this.templateName,
    this.amount,
    this.imagePath,
    this.giftCardTemplateGroupId,
    this.giftCardTemplateGroupName,
  });

  factory GiftCardImageData.fromJson(Map<String, dynamic> json) =>
      GiftCardImageData(
        id: json["id"],
        name: json["name"],
        isActive: json["isActive"],
        giftCardTemplateGroupId: json["giftCardTemplateGroupId"],
        giftCardTemplateGroupName: json["giftCardTemplateGroupName"],
        amount: json["amount"],
        imagePath: json["imagePath"],
      );

  Map<String, dynamic> toJson() => {
        "Id": id,
        "Name": name,
        "IsActive": isActive,
        "GiftCardTemplateGroupId": giftCardTemplateGroupId,
        "GiftCardTemplateGroupName": giftCardTemplateGroupName,
        "ImagePath": imagePath,
        "Amount": amount,
      };
}
