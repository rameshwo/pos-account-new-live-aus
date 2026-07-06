import 'com/feature_product.dart';

class PosProductRes {
  List<SubCategory>? subCategories;
  List<FeaturedProduct>? products;
  List<String>? alphaList;
  List<String>? docketList;

  PosProductRes({
    this.subCategories,
    this.products,
    this.alphaList,
    this.docketList,
  });

  factory PosProductRes.fromJson(Map<String, dynamic> json) => PosProductRes(
        subCategories: json["subCategories"] == null
            ? []
            : List<SubCategory>.from(
                json["subCategories"]!.map((x) => SubCategory.fromJson(x))),
        products: json["products"] == null
            ? []
            : List<FeaturedProduct>.from(
                json["products"]!.map((x) => FeaturedProduct.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "subCategories": subCategories == null
            ? []
            : List<dynamic>.from(subCategories!.map((x) => x.toJson())),
        "products": products == null
            ? []
            : List<dynamic>.from(products!.map((x) => x.toJson())),
      };
}
