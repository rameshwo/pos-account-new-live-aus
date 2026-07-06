class GiftCardSearchSec {
  GiftCardSearchSec({
    this.giftCardStatus,
  });

  List<GiftCardStatus>? giftCardStatus;

  factory GiftCardSearchSec.fromJson(Map<String, dynamic> json) =>
      GiftCardSearchSec(
        giftCardStatus: json["giftCardStatus"] == null
            ? []
            : List<GiftCardStatus>.from(
                json["giftCardStatus"]!.map((x) => GiftCardStatus.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "giftCardStatus": giftCardStatus == null
            ? []
            : List<dynamic>.from(giftCardStatus!.map((x) => x.toJson())),
      };
}

class GiftCardStatus {
  GiftCardStatus({
    this.id,
    this.value,
    this.additionalValue,
    this.isSelected,
    this.name,
  });

  String? id;
  String? value;
  dynamic additionalValue;
  bool? isSelected;
  String? name;

  factory GiftCardStatus.fromJson(Map<String, dynamic> json) => GiftCardStatus(
        id: json["id"],
        value: json["value"],
        additionalValue: json["additionalValue"],
        isSelected: json["isSelected"],
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "value": value,
        "additionalValue": additionalValue,
        "isSelected": isSelected,
        "name": name,
      };
}
