class ProductTagToDocketRes {
  String? categoryId;
  String? productVariationIds;
  List<String>? productIds;

  ProductTagToDocketRes({
    this.categoryId,
    this.productVariationIds,
    this.productIds,
  });

  factory ProductTagToDocketRes.fromJson(Map<String, dynamic> json) =>
      ProductTagToDocketRes(
        categoryId: json["categoryId"],
        productVariationIds: json["productVariationIds"],
        productIds: json["productIds"] == null
            ? []
            : List<String>.from(json["productIds"]!.map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "categoryId": categoryId,
        "productVariationIds": productVariationIds,
        "productIds": productIds == null
            ? []
            : List<dynamic>.from(productIds!.map((x) => x)),
      };
}
