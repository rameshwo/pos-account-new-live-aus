import 'package:pos_account/model/home/product/product_data_req.dart';

class ProdVarModiGroupRes {
  String? id;
  String? name;
  List<ProductVariationModifierGroup>? modifierGroups;

  ProdVarModiGroupRes({
    this.id,
    this.name,
    this.modifierGroups,
  });

  factory ProdVarModiGroupRes.fromJson(Map<String, dynamic> json) =>
      ProdVarModiGroupRes(
        id: json["id"],
        name: json["name"],
        modifierGroups: json["modifierGroups"] == null
            ? []
            : List<ProductVariationModifierGroup>.from(json["modifierGroups"]!
                .map((x) => ProductVariationModifierGroup.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "modifierGroups": modifierGroups == null
            ? []
            : List<dynamic>.from(modifierGroups!.map((x) => x.toJson())),
      };
}
