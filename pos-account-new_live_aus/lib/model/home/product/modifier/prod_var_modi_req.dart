import 'package:pos_account/model/home/product/product_data_req.dart';

class ProdVarModiReq {
  List<String>? productVariations;
  List<ProductVariationModifierGroup>? modifiers;

  ProdVarModiReq({
    this.productVariations,
    this.modifiers,
  });

  factory ProdVarModiReq.fromJson(Map<String, dynamic> json) => ProdVarModiReq(
        productVariations: json["productVariations"] == null
            ? []
            : List<String>.from(json["productVariations"]!.map((x) => x)),
        modifiers: json["modifiers"] == null
            ? []
            : List<ProductVariationModifierGroup>.from(json["modifiers"]!
                .map((x) => ProductVariationModifierGroup.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "productVariations": productVariations == null
            ? []
            : List<dynamic>.from(productVariations!.map((x) => x)),
        "modifiers": modifiers == null
            ? []
            : List<dynamic>.from(modifiers!.map((x) => x.toJson())),
      };
}
