class OrderItemDetailsOnFloor {
  String? id;
  String? itemName;
  String? docketGroupName;
  int? docketGroupSort;
  bool? enableDocketGroupSpliter;
  String? kitchenStatus;
  String? quantity;
  String? productType;
  String? status;
  List<Modifiermodifier>? modifiers;

  OrderItemDetailsOnFloor({
    this.id,
    this.itemName,
    this.docketGroupName,
    this.docketGroupSort,
    this.enableDocketGroupSpliter,
    this.kitchenStatus,
    this.quantity,
    this.productType,
    this.status,
    this.modifiers,
  });

  factory OrderItemDetailsOnFloor.fromJson(Map<String, dynamic> json) =>
      OrderItemDetailsOnFloor(
        id: json["id"],
        itemName: json["itemName"],
        docketGroupName: json["docketGroupName"],
        docketGroupSort: json["docketGroupSort"],
        enableDocketGroupSpliter: json["enableDocketGroupSpliter"],
        kitchenStatus: json["kitchenStatus"],
        quantity: json["quantity"],
        productType: json["productType"],
        status: json["status"],
        modifiers: json["modifiers"] == null
            ? []
            : List<Modifiermodifier>.from(
                json["modifiers"]!.map((x) => Modifiermodifier.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "itemName": itemName,
        "docketGroupName": docketGroupName,
        "docketGroupSort": docketGroupSort,
        "enableDocketGroupSpliter": enableDocketGroupSpliter,
        "kitchenStatus": kitchenStatus,
        "quantity": quantity,
        "productType": productType,
        "status": status,
        "modifiers": modifiers == null
            ? []
            : List<dynamic>.from(modifiers!.map((x) => x.toJson())),
      };
}

class Modifiermodifier {
  String? id;
  String? labelName;
  String? modifierName;
  String? quantity;
  Type? type;
  String? kitchenStatus;
  List<Modifiermodifier>? modifierItemModifiers;
  String? productType;

  Modifiermodifier({
    this.id,
    this.labelName,
    this.modifierName,
    this.quantity,
    this.type,
    this.kitchenStatus,
    this.modifierItemModifiers,
    this.productType,
  });

  factory Modifiermodifier.fromJson(Map<String, dynamic> json) =>
      Modifiermodifier(
        id: json["id"],
        labelName: json["labelName"],
        modifierName: json["modifierName"],
        quantity: json["quantity"],
        type: typeValues.map[json["type"]]!,
        kitchenStatus: json["kitchenStatus"],
        modifierItemModifiers: json["modifierItemModifiers"] == null
            ? []
            : List<Modifiermodifier>.from(json["modifierItemModifiers"]!
                .map((x) => Modifiermodifier.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "labelName": labelName,
        "modifierName": modifierName,
        "quantity": quantity,
        "type": typeValues.reverse[type],
        "kitchenStatus": kitchenStatus,
        "modifierItemModifiers": modifierItemModifiers == null
            ? []
            : List<dynamic>.from(modifierItemModifiers!.map((x) => x.toJson())),
      };
}

enum Type { GENERAL, RAW_INGREDIENT, SPICE_CHOICE }

final typeValues = EnumValues({
  "General": Type.GENERAL,
  "RawIngredient": Type.RAW_INGREDIENT,
  "SpiceChoice": Type.SPICE_CHOICE
});

class EnumValues<T> {
  Map<String, T> map;
  late Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    reverseMap = map.map((k, v) => MapEntry(v, k));
    return reverseMap;
  }
}
