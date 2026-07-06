import 'com/feature_product.dart';

class PosIngreRes {
  List<SubCategory>? subCategories;
  List<RawLooseIngredientProduct>? rawLooseIngredientProducts;

  PosIngreRes({
    this.subCategories,
    this.rawLooseIngredientProducts,
  });

  factory PosIngreRes.fromJson(Map<String, dynamic> json) => PosIngreRes(
        subCategories: json["subCategories"] == null
            ? []
            : List<SubCategory>.from(
                json["subCategories"]!.map((x) => SubCategory.fromJson(x))),
        rawLooseIngredientProducts: json["rawLooseIngredientProducts"] == null
            ? []
            : List<RawLooseIngredientProduct>.from(
                json["rawLooseIngredientProducts"]!
                    .map((x) => RawLooseIngredientProduct.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "subCategories": subCategories == null
            ? []
            : List<dynamic>.from(subCategories!.map((x) => x.toJson())),
        "rawLooseIngredientProducts": rawLooseIngredientProducts == null
            ? []
            : List<dynamic>.from(
                rawLooseIngredientProducts!.map((x) => x.toJson())),
      };
}

class RawLooseIngredientProduct {
  String? id;
  String? name;
  String? unitPricePerUnit;
  String? sellingPricePerUnit;
  String? maxMeasurementName;
  String? minMeasurementName;
  String? unitOfMeasurementId;
  String? availiableStock;
  String? salesTax;
  String? maxToMinConversionFactor;
  String? categoryId;

  //additional
  int quantity;
  String? parentCatId;
  String? productType;

  RawLooseIngredientProduct({
    this.id,
    this.name,
    this.unitPricePerUnit,
    this.sellingPricePerUnit,
    this.maxMeasurementName,
    this.minMeasurementName,
    this.unitOfMeasurementId,
    this.availiableStock,
    this.salesTax,
    this.maxToMinConversionFactor,
    this.categoryId,

    //
    this.quantity = 1,
    this.parentCatId,
    this.productType,
  });

  factory RawLooseIngredientProduct.fromJson(Map<String, dynamic> json) =>
      RawLooseIngredientProduct(
        id: json["id"],
        name: json["name"],
        unitPricePerUnit: json["unitPricePerUnit"],
        sellingPricePerUnit: json["sellingPricePerUnit"],
        maxMeasurementName: json["maxMeasurementName"],
        minMeasurementName: json["minMeasurementName"],
        unitOfMeasurementId: json["unitOfMeasurementId"],
        availiableStock: json["availiableStock"],
        salesTax: json["salesTax"],
        maxToMinConversionFactor: json["maxToMinConversionFactor"],
        categoryId: json["categoryId"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "unitPricePerUnit": unitPricePerUnit,
        "sellingPricePerUnit": sellingPricePerUnit,
        "maxMeasurementName": maxMeasurementName,
        "minMeasurementName": minMeasurementName,
        "unitOfMeasurementId": unitOfMeasurementId,
        "availiableStock": availiableStock,
        "salesTax": salesTax,
        "maxToMinConversionFactor": maxToMinConversionFactor,
        "categoryId": categoryId,
      };
}
