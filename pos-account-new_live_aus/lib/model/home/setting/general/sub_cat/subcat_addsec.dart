import 'package:pos_account/model/common/filter_category.dart';
import 'package:pos_account/model/common/table_location.dart';

class SubCatAddSec {
  List<FilterCategory>? filterCategories;
  List<TableLocation>? filterTypes;
  List<TableLocation>? categoryTypes;

  SubCatAddSec({
    this.filterCategories,
    this.filterTypes,
    this.categoryTypes,
  });

  factory SubCatAddSec.fromJson(Map<String, dynamic> json) => SubCatAddSec(
        filterCategories: json["filterCategories"] == null
            ? []
            : List<FilterCategory>.from(json["filterCategories"]!
                .map((x) => FilterCategory.fromJson(x))),
        filterTypes: json["filterTypes"] == null
            ? []
            : List<TableLocation>.from(
                json["filterTypes"]!.map((x) => TableLocation.fromJson(x))),
        categoryTypes: json["categoryTypes"] == null
            ? []
            : List<TableLocation>.from(
                json["categoryTypes"]!.map((x) => TableLocation.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "filterCategories": filterCategories == null
            ? []
            : List<dynamic>.from(filterCategories!.map((x) => x.toJson())),
        "filterTypes": filterTypes == null
            ? []
            : List<dynamic>.from(filterTypes!.map((x) => x.toJson())),
        "categoryTypes": categoryTypes == null
            ? []
            : List<dynamic>.from(categoryTypes!.map((x) => x.toJson())),
      };
}
