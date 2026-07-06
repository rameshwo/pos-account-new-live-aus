import 'package:pos_account/config/utils/promo_utils.dart';

import 'pos_res/com/feature_product.dart';
import 'pos_res/pos_ingre_res.dart';

class RetailProductRes {
  String? id;
  String? name;
  String? type;
  List<SubCategory>? subCategories;
  List<ProductData>? products;
  List<RawLooseIngredientProduct>? rawLooseProducts;
  List<String>? alphaList;

  RetailProductRes({
    this.id,
    this.name,
    this.type,
    this.subCategories,
    this.products,
    this.rawLooseProducts,
    this.alphaList,
  });

  factory RetailProductRes.fromJson(Map<String, dynamic> json) =>
      RetailProductRes(
        id: json["id"],
        name: json["name"],
        type: json["type"],
        subCategories: json["subCategories"] == null
            ? []
            : List<SubCategory>.from(
                json["subCategories"]!.map((x) => SubCategory.fromJson(x))),
        products: json["products"] == null
            ? []
            : List<ProductData>.from(
                json["products"]!.map((x) => ProductData.fromJson(x))),
        rawLooseProducts: json["rawLooseProducts"] == null
            ? []
            : List<RawLooseIngredientProduct>.from(json["rawLooseProducts"]!
                .map((x) => RawLooseIngredientProduct.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "type": type,
        "subCategories": subCategories == null
            ? []
            : List<dynamic>.from(subCategories!.map((x) => x.toJson())),
        "products": products == null
            ? []
            : List<dynamic>.from(products!.map((x) => x.toJson())),
        "rawLooseProducts": rawLooseProducts == null
            ? []
            : List<dynamic>.from(rawLooseProducts!.map((x) => x.toJson())),
      };
}

class ProductData {
  ProductData({
    this.id,
    this.productId,
    this.categoryId,
    this.name,
    this.code,
    this.salesTax,
    this.stockCount,
    this.barcodeNumber,
    this.actualPrice,
    this.unitPrice,
    this.discountPercentage,
    this.discountedPrice,
    this.discountPrice,
    this.imageUrl,
    this.comboProducts,
    this.brandId,

    //additional

    this.quantity = 1,
    this.parentCatId,
    this.productType,
    this.promoModel,
  });

  String? id; // variation ID
  String? productId;
  String? categoryId;
  String? name;
  dynamic code;
  String? salesTax;
  String? stockCount;
  String? barcodeNumber;
  String? actualPrice;
  String? unitPrice;
  String? discountPercentage;
  String? discountedPrice;
  String? discountPrice;
  String? imageUrl;
  List<ComboProduct>? comboProducts;
  String? brandId;

  //additional
  int quantity;
  String? parentCatId;
  String? productType;
  PromoModel? promoModel;

  factory ProductData.fromJson(Map<String, dynamic> json) => ProductData(
        // id & productId has been swapped to fix issue shortly
        productId: json["productId"],
        id: json["id"],
        categoryId: json["categoryId"],
        name: json["name"],
        code: json["code"],
        salesTax: json["salesTax"],
        stockCount: json["stockCount"],
        barcodeNumber: json["barcodeNumber"],
        actualPrice: json["actualPrice"], unitPrice: json["unitPrice"],
        discountPercentage: json["discountPercentage"],
        discountedPrice: json["discountedPrice"],
        discountPrice: json["discountPrice"],
        imageUrl: json["imageUrl"],
        comboProducts: json["comboProducts"] == null
            ? []
            : List<ComboProduct>.from(
                json["comboProducts"]!.map((x) => ComboProduct.fromJson(x))),
        brandId: json["brandId"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "productId": productId,
        "categoryId": categoryId,
        "name": name,
        "code": code,
        "salesTax": salesTax,
        "stockCount": stockCount,
        "barcodeNumber": barcodeNumber,
        "actualPrice": actualPrice,
        "unitPrice": unitPrice,
        "discountPercentage": discountPercentage,
        "discountedPrice": discountedPrice,
        "discountPrice": discountPrice,
        "imageUrl": imageUrl,
        "comboProducts": comboProducts == null
            ? []
            : List<dynamic>.from(comboProducts!.map((x) => x.toJson())),
        "brandId": brandId,
      };
}

class ComboProduct {
  String? name;
  String? quantity;
  String? imageUrl;

  ComboProduct({
    this.name,
    this.quantity,
    this.imageUrl,
  });

  factory ComboProduct.fromJson(Map<String, dynamic> json) => ComboProduct(
        name: json["name"],
        quantity: json["quantity"],
        imageUrl: json["imageUrl"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "quantity": quantity,
        "imageUrl": imageUrl,
      };
}
