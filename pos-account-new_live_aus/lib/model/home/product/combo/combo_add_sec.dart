import 'package:pos_account/model/common/filter_category.dart';
import 'package:pos_account/model/common/table_location.dart';

class ComboAddSec {
  String? code;
  List<TableLocation>? modifierGroups;
  List<TableLocation>? selectionTypes;
  List<TableLocation>? salesTaxes;
  List<TableLocation>? channels;
  List<TableLocation>? productCategories;
  List<FilterCategory>? filterCategories;
  List<TableLocation>? productPriceTypes;

  ComboAddSec({
    this.code,
    this.modifierGroups,
    this.selectionTypes,
    this.salesTaxes,
    this.channels,
    this.productCategories,
    this.filterCategories,
    this.productPriceTypes,
  });

  factory ComboAddSec.fromJson(Map<String, dynamic> json) => ComboAddSec(
        code: json["code"],
        modifierGroups: json["modifierGroups"] == null
            ? []
            : List<TableLocation>.from(
                json["modifierGroups"]!.map((x) => TableLocation.fromJson(x))),
        selectionTypes: json["selectionTypes"] == null
            ? []
            : List<TableLocation>.from(
                json["selectionTypes"]!.map((x) => TableLocation.fromJson(x))),
        salesTaxes: json["salesTaxes"] == null
            ? []
            : List<TableLocation>.from(
                json["salesTaxes"]!.map((x) => TableLocation.fromJson(x))),
        channels: json["channels"] == null
            ? []
            : List<TableLocation>.from(
                json["channels"]!.map((x) => TableLocation.fromJson(x))),
        productCategories: json["productCategories"] == null
            ? []
            : List<TableLocation>.from(json["productCategories"]!
                .map((x) => TableLocation.fromJson(x))),
        filterCategories: json["filterCategories"] == null
            ? []
            : List<FilterCategory>.from(json["filterCategories"]!
                .map((x) => FilterCategory.fromJson(x))),
        productPriceTypes: json["productPriceTypes"] == null
            ? []
            : List<TableLocation>.from(json["productPriceTypes"]!
                .map((x) => TableLocation.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "code": code,
        "modifierGroups": modifierGroups == null
            ? []
            : List<dynamic>.from(modifierGroups!.map((x) => x.toJson())),
        "selectionTypes": selectionTypes == null
            ? []
            : List<dynamic>.from(selectionTypes!.map((x) => x.toJson())),
        "salesTaxes": salesTaxes == null
            ? []
            : List<dynamic>.from(salesTaxes!.map((x) => x.toJson())),
        "channels": channels == null
            ? []
            : List<dynamic>.from(channels!.map((x) => x.toJson())),
        "productCategories": productCategories == null
            ? []
            : List<dynamic>.from(productCategories!.map((x) => x.toJson())),
        "filterCategories": filterCategories == null
            ? []
            : List<dynamic>.from(filterCategories!.map((x) => x.toJson())),
        "productPriceTypes": productPriceTypes == null
            ? []
            : List<dynamic>.from(productPriceTypes!.map((x) => x.toJson())),
      };
}
