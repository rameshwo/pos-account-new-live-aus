import 'package:pos_account/model/common/filter_category.dart';
import 'package:pos_account/model/common/table_location.dart';

class GenBarAddSec {
  List<FilterCategory>? productCategories;
  List<TableLocation>? suppliers;
  List<TableLocation>? brands;
  List<TableLocation>? status;
  List<TableLocation>? channels;
  List<TableLocation>? productPriceModifierGroups;
  List<TableLocation>? productTypes;

  GenBarAddSec({
    this.productCategories,
    this.suppliers,
    this.brands,
    this.status,
    this.channels,
    this.productPriceModifierGroups,
    this.productTypes,
  });

  factory GenBarAddSec.fromJson(Map<String, dynamic> json) => GenBarAddSec(
        productCategories: json["productCategories"] == null
            ? []
            : List<FilterCategory>.from(json["productCategories"]!
                .map((x) => FilterCategory.fromJson(x))),
        suppliers: json["suppliers"] == null
            ? []
            : List<TableLocation>.from(
                json["suppliers"]!.map((x) => TableLocation.fromJson(x))),
        brands: json["brands"] == null
            ? []
            : List<TableLocation>.from(
                json["brands"]!.map((x) => TableLocation.fromJson(x))),
        status: json["status"] == null
            ? []
            : List<TableLocation>.from(
                json["status"]!.map((x) => TableLocation.fromJson(x))),
        channels: json["channels"] == null
            ? []
            : List<TableLocation>.from(
                json["channels"]!.map((x) => TableLocation.fromJson(x))),
        productPriceModifierGroups: json["productPriceModifierGroups"] == null
            ? []
            : List<TableLocation>.from(json["productPriceModifierGroups"]!
                .map((x) => TableLocation.fromJson(x))),
        productTypes: json["productTypes"] == null
            ? []
            : List<TableLocation>.from(
                json["productTypes"]!.map((x) => TableLocation.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "productCategories": productCategories == null
            ? []
            : List<dynamic>.from(productCategories!.map((x) => x.toJson())),
        "suppliers": suppliers == null
            ? []
            : List<dynamic>.from(suppliers!.map((x) => x.toJson())),
        "brands": brands == null
            ? []
            : List<dynamic>.from(brands!.map((x) => x.toJson())),
        "status": status == null
            ? []
            : List<dynamic>.from(status!.map((x) => x.toJson())),
        "channels": channels == null
            ? []
            : List<dynamic>.from(channels!.map((x) => x.toJson())),
        "productPriceModifierGroups": productPriceModifierGroups == null
            ? []
            : List<dynamic>.from(
                productPriceModifierGroups!.map((x) => x.toJson())),
        "productTypes": productTypes == null
            ? []
            : List<dynamic>.from(productTypes!.map((x) => x.toJson())),
      };
}
