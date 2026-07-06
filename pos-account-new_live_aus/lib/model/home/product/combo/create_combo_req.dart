class CreateUpComboReq {
  String? code;
  String? name;
  String? productCategoryId;
  bool? isActive;
  String? salesTaxId;
  String? productPriceTypeId;
  String? barcodeNumber;
  String? slug;
  String? link;
  String? calories;
  String? description;
  String? id;
  List<DealChannelPrice>? dealChannelPrices;
  bool? isImageDeleted;
  List<DealModifier>? dealModifiers;
  String? promotionalMessage;
  String? imagePath;
  String? thumbNailImagePath;
  bool? enableAutoCartDetection;
  String? image;
  dynamic productCatgories;
  dynamic setMenuCustomDescriptions;
  dynamic setMenuQuestionAnswers;
  dynamic productVariations;

  CreateUpComboReq({
    this.code,
    this.name,
    this.productCategoryId,
    this.isActive,
    this.salesTaxId,
    this.productPriceTypeId,
    this.barcodeNumber,
    this.slug,
    this.link,
    this.calories,
    this.description,
    this.id,
    this.dealChannelPrices,
    this.isImageDeleted = false,
    this.dealModifiers,
    this.promotionalMessage,
    this.imagePath,
    this.thumbNailImagePath,
    this.enableAutoCartDetection,
    this.image,
    this.productCatgories,
    this.setMenuCustomDescriptions,
    this.setMenuQuestionAnswers,
    this.productVariations,
  });

  factory CreateUpComboReq.fromJson(Map<String, dynamic> json) =>
      CreateUpComboReq(
        code: json["code"],
        name: json["name"],
        productCategoryId: json["productCategoryId"],
        isActive: json["isActive"],
        salesTaxId: json["salesTaxId"],
        productPriceTypeId: json["productPriceTypeId"],
        barcodeNumber: json["barcodeNumber"],
        slug: json["slug"],
        link: json["link"],
        calories: json["calories"],
        description: json["description"],
        id: json["id"],
        dealChannelPrices: json["dealChannelPrices"] == null
            ? []
            : List<DealChannelPrice>.from(json["dealChannelPrices"]!
                .map((x) => DealChannelPrice.fromJson(x))),
        isImageDeleted: json["isImageDeleted"] ?? false,
        dealModifiers: json["dealModifiers"] == null
            ? []
            : List<DealModifier>.from(
                json["dealModifiers"]!.map((x) => DealModifier.fromJson(x))),
        promotionalMessage: json["promotionalMessage"],
        imagePath: json["imagePath"],
        thumbNailImagePath: json["thumbNailImagePath"],
        enableAutoCartDetection: json["enableAutoCartDetection"],
        image: json["image"],
        productCatgories: json["productCatgories"],
        setMenuCustomDescriptions: json["setMenuCustomDescriptions"],
        setMenuQuestionAnswers: json["setMenuQuestionAnswers"],
        productVariations: json["productVariations"],
      );

  Map<String, dynamic> toJson() => {
        "code": code,
        "name": name,
        "productCategoryId": productCategoryId,
        "isActive": isActive,
        "salesTaxId": salesTaxId,
        "productPriceTypeId": productPriceTypeId,
        "barcodeNumber": barcodeNumber,
        "slug": slug,
        "link": link,
        "calories": calories,
        "description": description,
        "id": id,
        "enableAutoCartDetection": enableAutoCartDetection,
        "image": image,
        "dealChannelPrices": dealChannelPrices == null
            ? []
            : List<dynamic>.from(dealChannelPrices!.map((x) => x.toJson())),
        "isImageDeleted": isImageDeleted ?? false,
        "dealModifiers": dealModifiers == null
            ? []
            : List<dynamic>.from(dealModifiers!.map((x) => x.toJson())),
        // "promotionalMessage": promotionalMessage,
        // "imagePath": imagePath,
        // "thumbNailImagePath": thumbNailImagePath,
        // "productCatgories": productCatgories,
        // "setMenuCustomDescriptions": setMenuCustomDescriptions,
        // "setMenuQuestionAnswers": setMenuQuestionAnswers,
        // "productVariations": productVariations,
      };
}

class DealChannelPrice {
  String? id;
  String? channelId;
  // String? channel;
  String? actualPrice;
  String? discountPrice;
  String? discountPercentage;
  String? discountedPrice;
  bool? isActive;
  bool? isDefault;

  DealChannelPrice({
    this.id,
    this.channelId,
    // this.channel,
    this.actualPrice,
    this.discountPrice,
    this.discountPercentage,
    this.discountedPrice,
    this.isActive,
    this.isDefault,
  });

  factory DealChannelPrice.fromJson(Map<String, dynamic> json) =>
      DealChannelPrice(
        id: json["id"],
        channelId: json["channelId"],
        // channel: json["channel"],
        actualPrice: json["actualPrice"],
        discountPrice: json["discountPrice"],
        discountPercentage: json["discountPercentage"],
        discountedPrice: json["discountedPrice"],
        isActive: json["isActive"],
        isDefault: json["isDefault"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "channelId": channelId,
        // "channel": channel,
        "actualPrice": actualPrice,
        "discountPrice": discountPrice,
        "discountPercentage": discountPercentage,
        "discountedPrice": discountedPrice,
        "isActive": isActive,
        // "isDefault": isDefault,
      };
}

class DealModifier {
  String? id;
  String? modifierGroupId;
  String? selectionTypeId;
  String? maxThresholdQuantity;
  List<ModifierItem>? modifierItems;
  bool? isActive;
  bool? isRequired;
  int? sortOrder;

  DealModifier({
    this.id,
    this.modifierGroupId,
    this.selectionTypeId,
    this.maxThresholdQuantity,
    this.modifierItems,
    this.isActive,
    this.isRequired,
    this.sortOrder,
  });

  factory DealModifier.fromJson(Map<String, dynamic> json) => DealModifier(
        id: json["id"],
        modifierGroupId: json["modifierGroupId"],
        selectionTypeId: json["selectionTypeId"],
        maxThresholdQuantity: json["maxThresholdQuantity"],
        modifierItems: json["modifierItems"] == null
            ? []
            : List<ModifierItem>.from(
                json["modifierItems"]!.map((x) => ModifierItem.fromJson(x))),
        isActive: json["isActive"],
        isRequired: json["isRequired"],
        sortOrder: json["sortOrder"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "modifierGroupId": modifierGroupId,
        "selectionTypeId": selectionTypeId,
        "maxThresholdQuantity": maxThresholdQuantity,
        "modifierItems": modifierItems == null
            ? []
            : List<dynamic>.from(modifierItems!.map((x) => x.toJson())),
        // "isActive": isActive,
        "isRequired": isRequired,
        // "sortOrder": sortOrder,
      };
}

class ModifierItem {
  String? id;
  String? name;
  String? productVariationId;
  String? rawLooseIngredientId;
  String? rawLooseIngredientQuantity;
  String? modifierItemId;
  String? type;
  String? minMeasurementName;
  String? price;
  String? maxThresholdQuantity;
  bool? isActive;
  // bool? isDefault;
  bool? isRequired;
  String? availableQuantity;
  String? additionalPrice;

  ModifierItem({
    this.id,
    this.name,
    this.productVariationId,
    this.rawLooseIngredientId,
    this.rawLooseIngredientQuantity,
    this.modifierItemId,
    this.type,
    this.minMeasurementName,
    this.price,
    this.maxThresholdQuantity,
    this.isActive,
    // this.isDefault,
    this.isRequired,
    this.availableQuantity,
    this.additionalPrice,
  });

  factory ModifierItem.fromJson(Map<String, dynamic> json) => ModifierItem(
        id: json["id"],
        name: json["name"],
        productVariationId: json["productVariationId"],
        rawLooseIngredientId: json["rawLooseIngredientId"],
        rawLooseIngredientQuantity: json["rawLooseIngredientQuantity"],
        modifierItemId: json["modifierItemId"],
        type: json["type"],
        minMeasurementName: json["minMeasurementName"],
        price: json["price"],
        maxThresholdQuantity: json["maxThresholdQuantity"],
        isActive: json["isActive"],
        // isDefault: json["isDefault"],
        isRequired: json["isRequired"],
        availableQuantity: json["availableQuantity"],
        additionalPrice: json["additionalPrice"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "productVariationId": productVariationId,
        "rawLooseIngredientId": rawLooseIngredientId ?? '',
        "rawLooseIngredientQuantity": rawLooseIngredientQuantity ?? '',
        "modifierItemId": modifierItemId ?? '',
        "type": type ?? '',
        "minMeasurementName": minMeasurementName ?? '',
        "price": price,
        "maxThresholdQuantity": maxThresholdQuantity,
        "isActive": isActive ?? true,
        // "isDefault": isDefault,
        "isRequired": isRequired,
        "availableQuantity": availableQuantity,
        "additionalPrice": additionalPrice,
      };
}
