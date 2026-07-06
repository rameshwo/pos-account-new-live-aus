import 'com/feature_product.dart';

class AllPosProductRes {
  final String? id;
  final String? name;
  final String? type;
  final String? defaultBackGroundColor;
  final String? defaultTextColor;
  final String? onFocusBackGroundColor;
  final String? onFocusTextColor;
  final List<SubCategory>? subCategories;
  final List<FeaturedProduct>? products;

  AllPosProductRes({
    this.id,
    this.name,
    this.type,
    this.defaultBackGroundColor,
    this.defaultTextColor,
    this.onFocusBackGroundColor,
    this.onFocusTextColor,
    this.subCategories,
    this.products,
  });

  factory AllPosProductRes.fromJson(Map<String, dynamic> json) =>
      AllPosProductRes(
        id: json["id"],
        name: json["name"],
        type: json["type"],
        defaultBackGroundColor: json["defaultBackGroundColor"],
        defaultTextColor: json["defaultTextColor"],
        onFocusBackGroundColor: json["onFocusBackGroundColor"],
        onFocusTextColor: json["onFocusTextColor"],
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
        "id": id,
        "name": name,
        "type": type,
        "defaultBackGroundColor": defaultBackGroundColor,
        "defaultTextColor": defaultTextColor,
        "onFocusBackGroundColor": onFocusBackGroundColor,
        "onFocusTextColor": onFocusTextColor,
        "subCategories": subCategories == null
            ? []
            : List<dynamic>.from(subCategories!.map((x) => x.toJson())),
        "products": products == null
            ? []
            : List<dynamic>.from(products!.map((x) => x.toJson())),
      };
}
