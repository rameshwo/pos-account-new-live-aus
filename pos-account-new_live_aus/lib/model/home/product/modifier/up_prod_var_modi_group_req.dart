import '../product_data_req.dart';

class UpProdVarModiGroupReq {
  String? id;
  String? name;
  List<ProductVariationModifierGroup>? modifierGroups;

  UpProdVarModiGroupReq({
    this.id,
    this.name,
    this.modifierGroups,
  });

  factory UpProdVarModiGroupReq.fromJson(Map<String, dynamic> json) =>
      UpProdVarModiGroupReq(
        id: json["Id"],
        name: json["Name"],
        modifierGroups: json["ModifierGroups"] == null
            ? []
            : List<ProductVariationModifierGroup>.from(json["ModifierGroups"]!
                .map((x) => ProductVariationModifierGroup.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "Id": id,
        "Name": name,
        "ModifierGroups": modifierGroups == null
            ? []
            : List<dynamic>.from(modifierGroups!.map((x) => x.toJson())),
      };
}
