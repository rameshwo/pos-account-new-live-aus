import 'com/feature_product.dart';

class PosComboRes {
  List<SubCategory>? subCategories;
  List<ComboProduct>? comboProducts;

  PosComboRes({
    this.subCategories,
    this.comboProducts,
  });

  factory PosComboRes.fromJson(Map<String, dynamic> json) => PosComboRes(
        subCategories: json["subCategories"] == null
            ? []
            : List<SubCategory>.from(
                json["subCategories"]!.map((x) => SubCategory.fromJson(x))),
        comboProducts: json["comboProducts"] == null
            ? []
            : List<ComboProduct>.from(
                json["comboProducts"]!.map((x) => ComboProduct.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "subCategories": subCategories == null
            ? []
            : List<dynamic>.from(subCategories!.map((x) => x.toJson())),
        "comboProducts": comboProducts == null
            ? []
            : List<dynamic>.from(comboProducts!.map((x) => x.toJson())),
      };
}

class ComboProduct {
  String? id;
  String? name;
  String? imageUrl;
  String? actualPrice;
  String? discountedPrice;
  String? discountPercentage;
  String? promotionalMessage;
  String curSym;

  ComboProduct({
    this.id,
    this.name,
    this.imageUrl,
    this.actualPrice,
    this.discountedPrice,
    this.discountPercentage,
    this.promotionalMessage,
    this.curSym = "",
  });

  factory ComboProduct.fromJson(Map<String, dynamic> json) => ComboProduct(
        id: json["id"],
        name: json["name"],
        imageUrl: json["imageUrl"],
        actualPrice: json["actualPrice"],
        discountedPrice: json["discountedPrice"],
        discountPercentage: json["discountPercentage"],
        promotionalMessage: json["promotionalMessage"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "imageUrl": imageUrl,
        "actualPrice": actualPrice,
        "discountedPrice": discountedPrice,
        "discountPercentage": discountPercentage,
        "promotionalMessage": promotionalMessage,
      };
}
