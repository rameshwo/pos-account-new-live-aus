import 'package:pos_account/model/common/table_location.dart';

import '../new_product/all_prod_add_sec.dart';
import '../product_data_req.dart';

class TagModiAddSecRes {
  List<TableLocation>? selectionTypes;
  List<ModifierGroup>? modifierGroups;
  List<ProductVariationModifierGroupModifierItem>? modifierItems;

  TagModiAddSecRes({
    this.selectionTypes,
    this.modifierGroups,
    this.modifierItems,
  });

  factory TagModiAddSecRes.fromJson(Map<String, dynamic> json) =>
      TagModiAddSecRes(
        selectionTypes: json["selectionTypes"] == null
            ? []
            : List<TableLocation>.from(
                json["selectionTypes"]!.map((x) => TableLocation.fromJson(x))),
        modifierGroups: json["modifierGroups"] == null
            ? []
            : List<ModifierGroup>.from(
                json["modifierGroups"]!.map((x) => ModifierGroup.fromJson(x))),
        modifierItems: json["modifierItems"] == null
            ? []
            : List<ProductVariationModifierGroupModifierItem>.from(
                json["modifierItems"]!.map((x) =>
                    ProductVariationModifierGroupModifierItem.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "selectionTypes": selectionTypes == null
            ? []
            : List<dynamic>.from(selectionTypes!.map((x) => x.toJson())),
        "modifierGroups": modifierGroups == null
            ? []
            : List<dynamic>.from(modifierGroups!.map((x) => x.toJson())),
        "modifierItems": modifierItems == null
            ? []
            : List<dynamic>.from(modifierItems!.map((x) => x.toJson())),
      };
}
