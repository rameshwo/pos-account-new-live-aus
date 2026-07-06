class GiftCardTempData {
  String? id;
  String? name;
  bool? isActive;
  dynamic sortOrder;

  GiftCardTempData({
    this.id,
    this.name,
    this.isActive,
    this.sortOrder,
  });

  factory GiftCardTempData.fromJson(Map<String, dynamic> json) =>
      GiftCardTempData(
        id: json["id"],
        name: json["name"],
        isActive: json["isActive"],
        sortOrder: json["sortOrder"],
      );

  Map<String, dynamic> toJson() => {
        "Id": id,
        "Name": name,
        "IsActive": isActive,
        "SortOrder": sortOrder,
      };
}
