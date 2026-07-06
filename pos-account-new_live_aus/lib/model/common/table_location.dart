class TableLocation {
  TableLocation(
      {this.id,
      this.value,
      this.additionalValue,
      this.isSelected,
      this.name,
      this.isActive,
      this.isStoreActive});

  String? id;
  String? value;
  dynamic additionalValue;
  bool? isSelected;
  String? name;
  String? giftCardTemplateGroupId;
  bool? isActive;
  bool? isStoreActive;

  factory TableLocation.fromJson(Map<String, dynamic> json) => TableLocation(
        id: json["id"],
        value: json["value"],
        additionalValue: json["additionalValue"],
        isSelected: json["isSelected"],
        name: json["name"],
        isActive: json["isActive"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "value": value,
        "additionalValue": additionalValue,
        "isSelected": isSelected,
        "name": name,
      };
}
