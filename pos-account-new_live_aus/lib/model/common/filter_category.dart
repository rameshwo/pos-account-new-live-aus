class FilterCategory {
  FilterCategory({
    this.filterCategoryName,
    this.filterCategoryId,
    this.childernCategories,
  });

  String? filterCategoryName;
  String? filterCategoryId;
  List<FilterCategory>? childernCategories;

  factory FilterCategory.fromJson(Map<String, dynamic> json) => FilterCategory(
        filterCategoryName: json["filterCategoryName"],
        filterCategoryId: json["filterCategoryId"],
        childernCategories: json["childernCategories"] == null
            ? []
            : List<FilterCategory>.from(json["childernCategories"]!
                .map((x) => FilterCategory.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "filterCategoryName": filterCategoryName,
        "filterCategoryId": filterCategoryId,
        "childernCategories": childernCategories == null
            ? []
            : List<dynamic>.from(childernCategories!.map((x) => x.toJson())),
      };
}
