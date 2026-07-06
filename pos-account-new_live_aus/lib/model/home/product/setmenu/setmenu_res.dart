import 'package:pos_account/model/common/filter_category.dart';
import 'package:pos_account/model/common/table_location.dart';

class SetMenuRes {
  SetMenuRes({
    this.productCategories,
    // this.taxExclusiveInclusive,
    this.salesTaxes,
    this.filterCategories,
  });

  List<TableLocation>? productCategories;
  // List<TableLocation>? taxExclusiveInclusive;
  List<TableLocation>? salesTaxes;
  List<FilterCategory>? filterCategories;

  factory SetMenuRes.fromJson(Map<String, dynamic> json) => SetMenuRes(
        productCategories: json["productCategories"] == null
            ? null
            : List<TableLocation>.from(json["productCategories"]
                .map((x) => TableLocation.fromJson(x))),
        // taxExclusiveInclusive: json["taxExclusiveInclusive"] == null
        //     ? null
        //     : List<TableLocation>.from(json["taxExclusiveInclusive"]
        //         .map((x) => TableLocation.fromJson(x))),
        salesTaxes: json["salesTaxes"] == null
            ? []
            : List<TableLocation>.from(
                json["salesTaxes"]!.map((x) => TableLocation.fromJson(x))),
        filterCategories: json["filterCategories"] == null
            ? []
            : List<FilterCategory>.from(json["filterCategories"]!
                .map((x) => FilterCategory.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "productCategories": productCategories == null
            ? null
            : List<dynamic>.from(productCategories!.map((x) => x.toJson())),
        // "taxExclusiveInclusive": taxExclusiveInclusive == null
        //     ? null
        //     : List<dynamic>.from(taxExclusiveInclusive!.map((x) => x.toJson())),
        "salesTaxes": salesTaxes == null
            ? []
            : List<dynamic>.from(salesTaxes!.map((x) => x.toJson())),
        "filterCategories": filterCategories == null
            ? []
            : List<dynamic>.from(filterCategories!.map((x) => x.toJson())),
      };
}
