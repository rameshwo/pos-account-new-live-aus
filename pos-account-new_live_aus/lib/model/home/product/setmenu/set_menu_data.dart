class SetMenuData {
  SetMenuData({
    this.id = "",
    this.name,
    this.description,
    this.isActive,
    this.price,
    this.discountPercentage,
    this.salesTaxId,
    // this.taxExclusiveInclusiveId,
    this.productCatgories,
    this.productVariations,
    this.imagePath,
    this.isImageDeleted,
    this.code,
    this.productCategoryId,
    this.barcodeNumber,
    this.slug,
    this.link,
    this.discountPrice,
    this.promotionalMessage,
    this.setMenuCustomDescriptions,
    this.setMenuQuestionAnswers,
  });

  String id;
  String? name;
  String? description;
  bool? isActive;
  String? price;
  String? discountPercentage;
  String? salesTaxId;
  // String? taxExclusiveInclusiveId;
  List<ProductCatgory>? productCatgories;
  List<ProductVariationData>? productVariations;
  String? imagePath;
  bool? isImageDeleted;
  String? code;
  String? productCategoryId;
  String? barcodeNumber;
  String? slug;
  String? link;
  String? discountPrice;
  String? promotionalMessage;
  List<dynamic>? setMenuCustomDescriptions;
  List<dynamic>? setMenuQuestionAnswers;

  factory SetMenuData.fromJson(Map<String, dynamic> json) => SetMenuData(
        id: json["id"],
        name: json["name"],
        description: json["description"],
        isActive: json["isActive"],
        price: json["price"],
        discountPercentage: json["discountPercentage"],
        salesTaxId: json["salesTaxId"],
        // taxExclusiveInclusiveId: json["taxExclusiveInclusiveId"],
        productCatgories: json["productCatgories"] == null
            ? null
            : List<ProductCatgory>.from(json["productCatgories"]
                .map((x) => ProductCatgory.fromJson(x))),
        productVariations: json["productVariations"] == null
            ? []
            : List<ProductVariationData>.from(json["productVariations"]!
                .map((x) => ProductVariationData.fromJson(x))),
        imagePath: json["imagePath"],
        isImageDeleted: json["isImageDeleted"],
        code: json["code"],
        productCategoryId: json["productCategoryId"],
        barcodeNumber: json["barcodeNumber"],
        slug: json["slug"],
        link: json["link"],
        discountPrice: json["discountPrice"],
        promotionalMessage: json["promotionalMessage"],
        setMenuCustomDescriptions: json["setMenuCustomDescriptions"] == null
            ? []
            : List<dynamic>.from(
                json["setMenuCustomDescriptions"]!.map((x) => x)),
        setMenuQuestionAnswers: json["setMenuQuestionAnswers"] == null
            ? []
            : List<dynamic>.from(json["setMenuQuestionAnswers"]!.map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "Id": id,
        "Name": name,
        "Description": description,
        "isActive": isActive,
        "Price": price,
        "DiscountPercentage": discountPercentage,
        "SalesTaxId": salesTaxId,
        // "TaxExclusiveInclusiveId": taxExclusiveInclusiveId,
        "ProductCatgories": productCatgories == null
            ? null
            : List<dynamic>.from(productCatgories!.map((x) => x.toJson())),
        "ProductVariations": productVariations == null
            ? []
            : List<dynamic>.from(productVariations!.map((x) => x.toJson())),
        "IsImageDeleted": isImageDeleted,
        // "Code": code,
        "ProductCategoryId": productCategoryId,
        // "BarcodeNumber": barcodeNumber,
        // "Slug": slug,
        // "Link": link,
        // "DiscountPrice": discountPrice,
        // "PromotionalMessage": promotionalMessage,
        // "SetMenuCustomDescriptions": setMenuCustomDescriptions == null
        //     ? []
        //     : List<dynamic>.from(setMenuCustomDescriptions!.map((x) => x)),
        // "SetMenuQuestionAnswers": setMenuQuestionAnswers == null
        //     ? []
        //     : List<dynamic>.from(setMenuQuestionAnswers!.map((x) => x)),
      };
}

class ProductCatgory {
  ProductCatgory({
    this.id,
    this.description,
    this.maxItemCount,
  });

  String? id;
  String? description;
  String? maxItemCount;

  factory ProductCatgory.fromJson(Map<String, dynamic> json) => ProductCatgory(
        id: json["id"],
        description: json["description"],
        maxItemCount: json["maxItemCount"],
      );

  Map<String, dynamic> toJson() => {
        "Id": id,
        "Description": description,
        "MaxItemCount": maxItemCount,
      };
}

class ProductVariationData {
  String? id;
  String? stockCount;

  ProductVariationData({
    this.id,
    this.stockCount,
  });

  factory ProductVariationData.fromJson(Map<String, dynamic> json) =>
      ProductVariationData(
        id: json["id"],
        stockCount: json["stockCount"],
      );

  Map<String, dynamic> toJson() => {
        "Id": id,
        "StockCount": stockCount,
      };
}
