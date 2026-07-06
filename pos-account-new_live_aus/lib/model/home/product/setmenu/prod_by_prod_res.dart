class ProdByProdCatRes {
  ProdByProdCatRes({
    this.categoryId,
    this.categoryName,
    this.productVariations,
    this.subCategories,
  });

  String? categoryId;
  String? categoryName;

  List<SubCategory>? subCategories;

  List<PrinterProductVariation>? productVariations;

  factory ProdByProdCatRes.fromJson(Map<String, dynamic> json) =>
      ProdByProdCatRes(
        categoryId: json["categoryId"],
        categoryName: json["categoryName"],
        subCategories: json["subCategories"] == null
            ? []
            : List<SubCategory>.from(
                json["subCategories"].map((x) => SubCategory.fromJson(x))),
        productVariations: json["productVariations"] == null
            ? (json["productList"] == null
                ? null
                : List<PrinterProductVariation>.from(json["productList"]
                    .map((x) => PrinterProductVariation.fromJson(x))))
            : List<PrinterProductVariation>.from(json["productVariations"]
                .map((x) => PrinterProductVariation.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "categoryId": categoryId,
        "categoryName": categoryName,
        "productVariations": productVariations == null
            ? null
            : List<dynamic>.from(productVariations!.map((x) => x.toJson())),
        "productList": productVariations == null
            ? null
            : List<dynamic>.from(productVariations!.map((x) => x.toJson())),
        "subCategories": subCategories == null
            ? null
            : List<dynamic>.from(subCategories!.map((x) => x.toJson())),
      };
}

class PrinterProductVariation {
  PrinterProductVariation({
    this.name,
    this.image,
    this.id,
    this.stockCount,
    this.productCategoryId,
    this.brandId,
    this.supplierId,
    this.isSelected = false,
    this.customStock,
    this.isFromRes = false,
    this.productCategoryName,
    this.barcodeNumber,
  });

  String? name;
  String? image;
  String? id;
  String? stockCount;
  String? productCategoryId;
  String? brandId;
  String? supplierId;
  String? productCategoryName;

  bool isSelected;
  String? customStock;
  bool? isFromRes;
  String? barcodeNumber;

  factory PrinterProductVariation.fromJson(Map<String, dynamic> json) =>
      PrinterProductVariation(
        name: json["name"],
        image: json["image"],
        id: json["id"],
        stockCount: json["stockCount"],
        productCategoryId: json["productCategoryId"],
        brandId: json["brandId"],
        supplierId: json["supplierId"],
        productCategoryName: json["productCategoryName"],
        barcodeNumber: json["barcodeNumber"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "image": image,
        "id": id,
        "stockCount": stockCount,
        "productCategoryId": productCategoryId,
        "brandId": brandId,
        "supplierId": supplierId,
        "productCategoryName": productCategoryName,
        "barcodeNumber": barcodeNumber,
      };
}

class SubCategory {
  bool? isHalfCategory;
  String? name;
  String? id;

  SubCategory({
    this.isHalfCategory,
    this.name,
    this.id,
  });

  factory SubCategory.fromJson(Map<String, dynamic> json) => SubCategory(
        isHalfCategory: json["isHalfCategory"],
        name: json["name"],
        id: json["id"],
      );

  Map<String, dynamic> toJson() => {
        "isHalfCategory": isHalfCategory,
        "name": name,
        "id": id,
      };
}
