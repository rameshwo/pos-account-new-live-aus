class ProductFilterOption {
  String? filterCategoryName;
  String? filterCategoryId;
  String? selectionType;
  bool? isProductCustomDescription;
  List<FilterTypeOption>? filterTypeOptions;
  List<ProductFilterOption>? childernCategories;

  /// only for [childernCategories]
  int? childSelectedIndex;

  // extra
  String? id;

  ProductFilterOption({
    this.filterCategoryName,
    this.filterCategoryId,
    this.selectionType,
    this.isProductCustomDescription,
    this.filterTypeOptions,
    this.childernCategories,
    this.childSelectedIndex,

    //
    this.id,
  });

  factory ProductFilterOption.fromJson(Map<String, dynamic> json) =>
      ProductFilterOption(
        filterCategoryName: json["filterCategoryName"],
        filterCategoryId: json["filterCategoryId"],
        selectionType: json["selectionType"],
        isProductCustomDescription: json["isProductCustomDescription"],
        filterTypeOptions: json["filterTypeOptions"] == null
            ? []
            : List<FilterTypeOption>.from(json["filterTypeOptions"]!
                .map((x) => FilterTypeOption.fromJson(x))),
        childernCategories: json["childernCategories"] == null
            ? []
            : List<ProductFilterOption>.from(json["childernCategories"]!
                .map((x) => ProductFilterOption.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "filterCategoryName": filterCategoryName,
        "filterCategoryId": filterCategoryId,
        "selectionType": selectionType,
        "isProductCustomDescription": isProductCustomDescription,
        "filterTypeOptions": filterTypeOptions == null
            ? []
            : List<dynamic>.from(filterTypeOptions!.map((x) => x.toJson())),
        "childernCategories": childernCategories == null
            ? []
            : List<dynamic>.from(childernCategories!.map((x) => x.toJson())),
      };
}

class FilterTypeOption {
  String? filterCategoryOptionId;
  String? filterCategoryOptionName;
  bool isSelected; // filter may multiselected

  FilterTypeOption({
    this.filterCategoryOptionId,
    this.filterCategoryOptionName,
    this.isSelected = false,
  });

  factory FilterTypeOption.fromJson(Map<String, dynamic> json) =>
      FilterTypeOption(
        filterCategoryOptionId: json["filterCategoryOptionId"],
        filterCategoryOptionName: json["filterCategoryOptionName"],
      );

  Map<String, dynamic> toJson() => {
        "filterCategoryOptionId": filterCategoryOptionId,
        "filterCategoryOptionName": filterCategoryOptionName,
      };
}
