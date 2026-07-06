class ProductDataReq {
  ProductDataReq({
    this.id,
    this.name,
    this.slug,
    this.code,
    this.barCodeTypeStoreId,
    this.allergens,
    this.productMacros,
    this.productCategoryId,
    this.productSubCategoryId,
    // this.taxExclusiveInclusiveId,
    this.description,
    // this.channelId,
    this.brandId,
    this.addOnProducts,
    this.deletedAddOnProductsIds,
    // this.deletedProductVariationsIds,
    this.deletedProductMacrosIds,
    // this.orderTypeProductPriceWithVariations,
    this.productVariations,
    this.productImageFileName,
    this.imageUrl,
    this.isActive,
    // this.supplierId,
    this.isImageDeleted,
    this.productCustomDescriptions,
    this.deletedProductBatchIds,
    this.deletedProductVariationSuppliersIds,
    this.priceRange,
    this.enablePriceRange,
    this.salesTaxId,
    this.purchaseTaxId,
    this.productFilterOptions,
    this.docketGroupId,
    this.estimatedTimeRange,
    this.enableTimeRange,
    this.deletedServiceItemsIds,
    this.deletedProductVariationSpiceChoicesIds,
    this.deletedProductVariationIngredientsIds,
    this.productTypeId,
    this.productPriceTypeId,
  });

  String? id;
  String? name;
  String? slug;
  String? code;
  String? barCodeTypeStoreId;
  String? allergens;
  List<ProductMacro>? productMacros;
  String? productCategoryId;
  String? productSubCategoryId;
  // String? taxExclusiveInclusiveId;
  String? description;
  // String? channelId;
  String? brandId;
  List<AddOnProduct>? addOnProducts;
  List<String>? deletedAddOnProductsIds;
  // List<String>? deletedProductVariationsIds;
  List<String>? deletedProductMacrosIds;
  List<String>? deletedProductBatchIds;
  List<String>? deletedProductVariationSuppliersIds;
  List<String>? deletedServiceItemsIds;
  List<String>? deletedProductVariationSpiceChoicesIds;
  List<String>? deletedProductVariationIngredientsIds;
  // List<OrderTypeProductPriceWithVariation>? orderTypeProductPriceWithVariations;
  List<InventoryProductVariation>? productVariations;
  String? productImageFileName;
  String? imageUrl;
  // String? supplierId;
  bool? isActive;
  bool? isImageDeleted;
  List<ProductCustomDescription>? productCustomDescriptions;
  String? priceRange;
  bool? enablePriceRange;
  String? salesTaxId;
  String? purchaseTaxId;
  List<ProductFilterOptions>? productFilterOptions;
  String? docketGroupId;
  String? estimatedTimeRange;
  bool? enableTimeRange;
  String? productTypeId;
  String? productPriceTypeId;

  factory ProductDataReq.fromJson(Map<String, dynamic> json) => ProductDataReq(
        id: json["id"],
        name: json["name"], slug: json["slug"],
        code: json["code"],
        barCodeTypeStoreId: json["barCodeTypeStoreId"],
        allergens: json["allergens"],
        priceRange: json["priceRange"],
        enablePriceRange: json["enablePriceRange"],
        productMacros: json["productMacros"] == null
            ? null
            : List<ProductMacro>.from(
                json["productMacros"].map((x) => ProductMacro.fromJson(x))),
        productCategoryId: json["productCategoryId"],
        productSubCategoryId: json["productSubCategoryId"],
        // taxExclusiveInclusiveId: json["taxExclusiveInclusiveId"],
        description: json["description"],
        // channelId: json["channelId"],
        brandId: json["brandId"],
        addOnProducts: json["addOnProducts"] == null
            ? null
            : List<AddOnProduct>.from(
                json["addOnProducts"].map((x) => AddOnProduct.fromJson(x))),
        deletedProductVariationSpiceChoicesIds:
            json["deletedProductVariationSpiceChoicesIds"] == null
                ? []
                : List<String>.from(
                    json["deletedProductVariationSpiceChoicesIds"]!
                        .map((x) => x)),
        deletedAddOnProductsIds: json["deletedAddOnProductsIds"] == null
            ? null
            : List<String>.from(json["deletedAddOnProductsIds"].map((x) => x)),
        // deletedProductVariationsIds: json["deletedProductVariationsIds"] == null
        //     ? null
        //     : List<String>.from(
        //         json["deletedProductVariationsIds"].map((x) => x)),
        deletedProductMacrosIds: json["deletedProductMacrosIds"] == null
            ? null
            : List<String>.from(json["deletedProductMacrosIds"].map((x) => x)),
        // orderTypeProductPriceWithVariations:
        //     json["orderTypeProductPriceWithVariations"] == null
        //         ? null
        //         : List<OrderTypeProductPriceWithVariation>.from(
        //             json["orderTypeProductPriceWithVariations"].map(
        //                 (x) => OrderTypeProductPriceWithVariation.fromJson(x))),
        productVariations: json["productVariations"] == null
            ? null
            : List<InventoryProductVariation>.from(json["productVariations"]
                .map((x) => InventoryProductVariation.fromJson(x))),
        productImageFileName: json["productImageFileName"],
        imageUrl: json["imageUrl"],
        isActive: json["isActive"],
        // supplierId: json["supplierId"],
        isImageDeleted: json["IsImageDeleted"],
        productCustomDescriptions: json["productCustomDescription"] == null
            ? []
            : List<ProductCustomDescription>.from(
                json["productCustomDescription"]!
                    .map((x) => ProductCustomDescription.fromJson(x))),
        salesTaxId: json["salesTaxId"],
        purchaseTaxId: json["purchaseTaxId"],
        productFilterOptions: json["productFilterOptions"] == null
            ? null
            : List<ProductFilterOptions>.from(json["productFilterOptions"]
                .map((x) => ProductFilterOptions.fromJson(x))),
        docketGroupId: json["docketGroupId"],

        deletedProductBatchIds: json["deletedProductBatchIds"] == null
            ? null
            : List<String>.from(json["deletedProductBatchIds"].map((x) => x)),
        deletedProductVariationSuppliersIds:
            json["deletedProductVariationSuppliersIds"] == null
                ? []
                : List<String>.from(
                    json["deletedProductVariationSuppliersIds"]!.map((x) => x)),
        estimatedTimeRange: json["estimatedTimeRange"],
        enableTimeRange: json["enableTimeRange"],
        deletedServiceItemsIds: json["deletedServiceItemsIds"] == null
            ? []
            : List<String>.from(json["deletedServiceItemsIds"]!.map((x) => x)),
        deletedProductVariationIngredientsIds:
            json["deletedProductVariationIngredientsIds"] == null
                ? []
                : List<String>.from(
                    json["deletedProductVariationIngredientsIds"]!
                        .map((x) => x)),
        productTypeId: json["productTypeId"],
        productPriceTypeId: json["productPriceTypeId"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name, "slug": slug,
        "code": code,
        "barCodeTypeStoreId": barCodeTypeStoreId,
        "allergens": allergens,
        "priceRange": priceRange,
        "enablePriceRange": enablePriceRange,
        "ProductMacros": productMacros == null
            ? null
            : List<dynamic>.from(productMacros!.map((x) => x.toJson())),
        "productCategoryId": productCategoryId,
        "productSubCategoryId": productSubCategoryId,
        // "taxExclusiveInclusiveId": taxExclusiveInclusiveId,
        "Description": description,
        // "ChannelId": channelId,
        "brandId": brandId,
        "addOnProducts": addOnProducts == null
            ? null
            : List<dynamic>.from(addOnProducts!.map((x) => x.toJson())),
        "deletedProductBatchIds": deletedProductBatchIds == null
            ? null
            : List<dynamic>.from(deletedProductBatchIds!.map((x) => x)),
        "deletedProductVariationSpiceChoicesIds":
            deletedProductVariationSpiceChoicesIds == null
                ? []
                : List<dynamic>.from(
                    deletedProductVariationSpiceChoicesIds!.map((x) => x)),
        "DeletedProductVariationSuppliersIds":
            deletedProductVariationSuppliersIds == null
                ? []
                : List<dynamic>.from(
                    deletedProductVariationSuppliersIds!.map((x) => x)),

        "DeletedAddOnProductsIds": deletedAddOnProductsIds == null
            ? null
            : List<dynamic>.from(deletedAddOnProductsIds!.map((x) => x)),
        // "DeletedProductVariationsIds": deletedProductVariationsIds == null
        //     ? null
        //     : List<dynamic>.from(deletedProductVariationsIds!.map((x) => x)),
        "DeletedProductMacrosIds": deletedProductMacrosIds == null
            ? null
            : List<dynamic>.from(deletedProductMacrosIds!.map((x) => x)),
        // "orderTypeProductPriceWithVariations":
        //     orderTypeProductPriceWithVariations == null
        //         ? null
        //         : List<dynamic>.from(orderTypeProductPriceWithVariations!
        //             .map((x) => x.toJson())),
        "productVariations": productVariations == null
            ? null
            : List<dynamic>.from(productVariations!.map((x) => x.toJson())),
        "isActive": isActive,
        // "supplierId": supplierId,
        "IsImageDeleted": isImageDeleted,
        "productCustomDescription": productCustomDescriptions == null
            ? []
            : List<dynamic>.from(
                productCustomDescriptions!.map((x) => x.toJson())),
        "SalesTaxId": salesTaxId,
        "PurchaseTaxId": purchaseTaxId,
        "ProductFilterOptions": productFilterOptions == null
            ? null
            : List<dynamic>.from(productFilterOptions!.map((x) => x.toJson())),
        "DocketGroupId": docketGroupId,
        "EstimatedTimeRange": estimatedTimeRange,
        "EnableTimeRange": enableTimeRange,
        "DeletedServiceItemsIds": deletedServiceItemsIds == null
            ? []
            : List<dynamic>.from(deletedServiceItemsIds!.map((x) => x)),
        "deletedProductVariationIngredientsIds":
            deletedProductVariationIngredientsIds == null
                ? []
                : List<dynamic>.from(
                    deletedProductVariationIngredientsIds!.map((x) => x)),
        "productTypeId": productTypeId,
        "productPriceTypeId": productPriceTypeId,
        "productImageFileName": productImageFileName,
        "imageUrl": imageUrl,
      };
}

class AddOnProduct {
  AddOnProduct({
    this.id,
    this.productId,
    this.name,
  });

  String? id;
  String? productId;
  String? name;

  factory AddOnProduct.fromJson(Map<String, dynamic> json) => AddOnProduct(
        id: json["id"],
        productId: json["productId"],
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "Id": id,
        "ProductId": productId,
        "Name": name,
      };
}

// class OrderTypeProductPriceWithVariation {
//   OrderTypeProductPriceWithVariation({
//     this.id,
//     this.orderTypeId,
//     this.orderTypeName,
//     this.isActive,
//     this.productVariations,
//   });

//   String? id;
//   String? orderTypeId;
//   String? orderTypeName;
//   bool? isActive;
//   List<InventoryProductVariation>? productVariations;

//   factory OrderTypeProductPriceWithVariation.fromJson(
//           Map<String, dynamic> json) =>
//       OrderTypeProductPriceWithVariation(
//         id: json["id"],
//         orderTypeId: json["orderTypeId"],
//         orderTypeName: json["orderTypeName"],
//         isActive: json["isActive"],
// productVariations: json["productVariations"] == null
//     ? null
//     : List<InventoryProductVariation>.from(json["productVariations"]
//         .map((x) => InventoryProductVariation.fromJson(x))),
//       );

//   Map<String, dynamic> toJson() => {
//         "id": id,
//         "OrderTypeId": orderTypeId,
//         "orderTypeName": orderTypeName,
//         "IsActive": isActive,
// "productVariations": productVariations == null
//     ? null
//     : List<dynamic>.from(productVariations!.map((x) => x.toJson())),
//       };
// }

class InventoryProductVariation {
  InventoryProductVariation({
    this.id,
    // this.price,
    this.name,
    this.stockCount,
    this.unitPrice,
    this.minimumStockAlertCount,
    this.maximumStockAlertCount,
    this.calories,
    this.isDefault,
    // this.discount,
    this.labelName,
    this.code,
    this.barCodeImage,
    this.barCodeNumber,
    this.imagePath,
    this.batches,
    this.productVariationSuppliers,

    // this.actualPrice,
    // this.discountPrice,
    // this.discountedPrice,
    // this.discountPercentage,
    this.isActive = false,
    this.expiryDate,
    this.productVariationChannelPrices,
    // this.productVariationPriceGroupModifiers,
    this.estimatedTime,
    // this.productVariationServiceItems,
    this.serviceGender,
    // this.productVariationSpiceChoices,
    this.productVariationRawIngredientModifierGroup,
    this.productVariationSpiceChoiceModifierGroup,
    this.productVariationModifierGroups,
    this.sortOrder,
  });

  String? id;
  // String? price;
  String? name;
  String? stockCount;
  String? unitPrice;
  String? minimumStockAlertCount;
  String? maximumStockAlertCount;
  String? calories;
  bool? isDefault;
  List<ProductBatch>? batches;
  List<ProductVariationSupplier>? productVariationSuppliers;
  // String? discount;
  String? labelName;
  String? code;
  String? barCodeImage;
  String? barCodeNumber;
  String? imagePath;
  // String? actualPrice;
  // String? discountPrice;
  // String? discountedPrice;
  // String? discountPercentage;
  bool isActive;
  String? expiryDate;
  int? sortOrder;

  List<ProductVariationChannelPrice>? productVariationChannelPrices;
  // List<ProductVariationPriceGroupModifier>? productVariationPriceGroupModifiers;
  String? estimatedTime;
  // List<ProductVariationServiceItem>? productVariationServiceItems;
  String? serviceGender;
  // List<SelectedSpices>? productVariationSpiceChoices;
  ProductVariationRawIngredientModifierGroup?
      productVariationRawIngredientModifierGroup;
  ProductVariationSpiceChoiceModifierGroup?
      productVariationSpiceChoiceModifierGroup;
  List<ProductVariationModifierGroup>? productVariationModifierGroups;

  factory InventoryProductVariation.fromJson(Map<String, dynamic> json) =>
      InventoryProductVariation(
        id: json["id"],
        // price: json["price"],
        name: json["name"],
        stockCount: json["stockCount"],
        unitPrice: json["unitPrice"],
        minimumStockAlertCount: json["minimumStockAlertCount"],
        maximumStockAlertCount: json["maximumStockAlertCount"],
        calories: json["calories"],
        isDefault: json["isDefault"],
        // discount: json["discount"],
        labelName: json["labelName"],
        code: json["code"],
        // productVariationSpiceChoices:
        //     json["productVariationSpiceChoices"] == null
        //         ? []
        //         : List<SelectedSpices>.from(json["productVariationSpiceChoices"]
        //             .map((x) => SelectedSpices.fromJson(x))),
        batches: json["productVariationBatchStocks"] == null
            ? []
            : List<ProductBatch>.from(json["productVariationBatchStocks"]
                .map((x) => ProductBatch.fromJson(x))),
        productVariationSuppliers: json["productVariationSuppliers"] == null
            ? []
            : List<ProductVariationSupplier>.from(
                json["productVariationSuppliers"]!
                    .map((x) => ProductVariationSupplier.fromJson(x))),

        barCodeImage: json["barCodeImage"],
        barCodeNumber: json["barCodeNumber"],
        imagePath: json["imagePath"],
        // actualPrice: json["actualPrice"],
        // discountPrice: json["discountPrice"],
        // discountedPrice: json["discountedPrice"],
        // discountPercentage: json["discountPercentage"],
        isActive: json["isActive"],
        expiryDate: json["expiryDate"],
        productVariationChannelPrices:
            json["productVariationChannelPrices"] == null
                ? []
                : List<ProductVariationChannelPrice>.from(
                    json["productVariationChannelPrices"]!
                        .map((x) => ProductVariationChannelPrice.fromJson(x))),
        // productVariationPriceGroupModifiers:
        //     json["productVariationPriceGroupModifiers"] == null
        //         ? []
        //         : List<ProductVariationPriceGroupModifier>.from(
        //             json["productVariationPriceGroupModifiers"]!.map(
        //                 (x) => ProductVariationPriceGroupModifier.fromJson(x))),
        estimatedTime: json["estimatedTime"],
        // productVariationServiceItems:
        //     json["productVariationServiceItems"] == null
        //         ? []
        //         : List<ProductVariationServiceItem>.from(
        //             json["productVariationServiceItems"]!
        //                 .map((x) => ProductVariationServiceItem.fromJson(x))),
        serviceGender: json["serviceGender"],
        productVariationRawIngredientModifierGroup:
            json["productVariationRawIngredientModifierGroup"] == null
                ? null
                : ProductVariationRawIngredientModifierGroup.fromJson(
                    json["productVariationRawIngredientModifierGroup"]),
        productVariationSpiceChoiceModifierGroup:
            json["productVariationSpiceChoiceModifierGroup"] == null
                ? null
                : ProductVariationSpiceChoiceModifierGroup.fromJson(
                    json["productVariationSpiceChoiceModifierGroup"]),
        productVariationModifierGroups:
            json["productVariationModifierGroups"] == null
                ? []
                : List<ProductVariationModifierGroup>.from(
                    json["productVariationModifierGroups"]!
                        .map((x) => ProductVariationModifierGroup.fromJson(x))),
        sortOrder: json["sortOrder"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        // "price": price,
        "name": name,
        "stockCount": stockCount,
        "UnitPrice": unitPrice,
        "minimumStockAlertCount": minimumStockAlertCount,
        "maximumStockAlertCount": maximumStockAlertCount,
        "calories": calories,
        "isDefault": isDefault,
        // "productVariationSpiceChoices": productVariationSpiceChoices == null
        //     ? []
        //     : List<dynamic>.from(
        //         productVariationSpiceChoices!.map((x) => x.toJson())),
        "productVariationBatchStocks": batches == null
            ? []
            : List<dynamic>.from(batches!.map((x) => x.toJson())),
        "productVariationSuppliers": productVariationSuppliers == null
            ? []
            : List<dynamic>.from(
                productVariationSuppliers!.map((x) => x.toJson())),

        // "Discount": discount,
        "LabelName": labelName,
        "code": code,
        // "barCodeImage": barCodeImage,
        "barCodeNumber": barCodeNumber,
        // "imagePath": imagePath,
        // "actualPrice": actualPrice,
        // "discountPrice": discountPrice,
        // "discountedPrice": discountedPrice,
        // "discountPercentage": discountPercentage,
        "isActive": isActive,
        "expiryDate": expiryDate,
        "productVariationChannelPrices": productVariationChannelPrices == null
            ? []
            : List<dynamic>.from(
                productVariationChannelPrices!.map((x) => x.toJson())),
        // "productVariationPriceGroupModifiers":
        //     productVariationPriceGroupModifiers == null
        //         ? []
        //         : List<dynamic>.from(productVariationPriceGroupModifiers!
        //             .map((x) => x.toJson())),
        "estimatedTime": estimatedTime,
        // "productVariationServiceItems": productVariationServiceItems == null
        //     ? []
        //     : List<dynamic>.from(
        //         productVariationServiceItems!.map((x) => x.toJson())),
        "serviceGender": serviceGender,
        "productVariationRawIngredientModifierGroup":
            productVariationRawIngredientModifierGroup?.toJson(),
        "productVariationSpiceChoiceModifierGroup":
            productVariationSpiceChoiceModifierGroup?.toJson(),
        "productVariationModifierGroups": productVariationModifierGroups == null
            ? []
            : List<dynamic>.from(
                productVariationModifierGroups!.map((x) => x.toJson())),
        "sortOrder": sortOrder,
      };
}

class ProductBatch {
  ProductBatch({
    this.id = "",
    this.batchNo,
    this.stock,
    this.expiryDate,
    this.runningStock,
    this.additionalStock,
  });

  String? id;
  String? batchNo;
  String? stock;
  String? expiryDate;
  String? runningStock;
  String? additionalStock;

  factory ProductBatch.fromJson(Map<String, dynamic> json) => ProductBatch(
        id: json["id"],
        batchNo: json["batchNumber"],
        stock: json["stockCount"],
        expiryDate: json["expiryDate"],
        runningStock: json["runningStockCount"],
        additionalStock: json["additionalStockCount"],
      );

  Map<String, dynamic> toJson() => {
        "Id": id,
        "BatchNumber": batchNo,
        "StockCount": stock,
        "ExpiryDate": expiryDate,
        "RunningStockCount": runningStock,
        "AdditionalStockCount": additionalStock,
      };
}

class ProductMacro {
  ProductMacro({
    this.id,
    this.name,
    this.value,
  });

  String? id;
  String? name;
  String? value;

  factory ProductMacro.fromJson(Map<String, dynamic> json) => ProductMacro(
        id: json["id"],
        name: json["name"],
        value: json["value"],
      );

  Map<String, dynamic> toJson() => {
        "Id": id,
        "Name": name,
        "Value": value,
      };
}

class ProductCustomDescription {
  ProductCustomDescription({
    this.labelName,
    this.isActive,
    this.descripiton,
    this.sortOrder,
    this.identifier,
  });

  String? labelName;
  bool? isActive;
  String? descripiton;
  int? sortOrder;
  String? identifier;

  factory ProductCustomDescription.fromJson(Map<String, dynamic> json) =>
      ProductCustomDescription(
        labelName: json["labelName"],
        isActive: json["isActive"],
        descripiton: json["description"],
        sortOrder: json["sortOrder"],
        identifier: json["identifier"],
      );

  Map<String, dynamic> toJson() => {
        "labelName": labelName,
        "isActive": isActive,
        "description": descripiton,
        "sortOrder": sortOrder,
        "identifier": identifier,
      };
}

class ProductFilterOptions {
  String? id;
  String? filterTypeId;
  String? filterTypeOptionsId;
  String? type;

  ProductFilterOptions({
    this.id,
    this.filterTypeId,
    this.filterTypeOptionsId,
    this.type,
  });

  factory ProductFilterOptions.fromJson(Map<String, dynamic> json) =>
      ProductFilterOptions(
        id: json["id"],
        filterTypeId: json["filterTypeId"],
        filterTypeOptionsId: json["filterTypeOptionsId"],
        type: json["type"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "filterTypeId": filterTypeId,
        "filterTypeOptionsId": filterTypeOptionsId,
        "type": type,
      };
}

class ProductVariationChannelPrice {
  String? id;
  String? channelId;
  String? actualPrice;
  String? discountPrice;
  String? discountedPrice;
  dynamic discountPercentage;
  bool? isActive;
  // bool? variablePriceMode;

  ProductVariationChannelPrice({
    this.id,
    this.channelId,
    this.actualPrice,
    this.discountPrice,
    this.discountedPrice,
    this.discountPercentage,
    this.isActive,
    // this.variablePriceMode,
  });

  factory ProductVariationChannelPrice.fromJson(Map<String, dynamic> json) =>
      ProductVariationChannelPrice(
        id: json["id"],
        channelId: json["channelId"],
        actualPrice: json["actualPrice"],
        discountPrice: json["discountPrice"],
        discountedPrice: json["discountedPrice"],
        discountPercentage: json["discountPercentage"],
        isActive: json["isActive"],
        // variablePriceMode: json["variablePriceMode"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "channelId": channelId,
        "actualPrice": actualPrice,
        "discountPrice": discountPrice,
        "discountedPrice": discountedPrice,
        "discountPercentage": discountPercentage,
        "isActive": isActive,
        // "variablePriceMode": variablePriceMode,
      };
}

class ProductVariationPriceGroupModifier {
  String? productPriceModifierGroupId;
  List<ProductVariationPriceModifier>? productVariationPriceModifiers;

  ProductVariationPriceGroupModifier({
    this.productPriceModifierGroupId,
    this.productVariationPriceModifiers,
  });

  factory ProductVariationPriceGroupModifier.fromJson(
          Map<String, dynamic> json) =>
      ProductVariationPriceGroupModifier(
        productPriceModifierGroupId: json["productPriceModifierGroupId"],
        productVariationPriceModifiers:
            json["productVariationPriceModifiers"] == null
                ? []
                : List<ProductVariationPriceModifier>.from(
                    json["productVariationPriceModifiers"]!
                        .map((x) => ProductVariationPriceModifier.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "productPriceModifierGroupId": productPriceModifierGroupId,
        "productVariationPriceModifiers": productVariationPriceModifiers == null
            ? []
            : List<dynamic>.from(
                productVariationPriceModifiers!.map((x) => x.toJson())),
      };
}

class ProductVariationPriceModifier {
  String? id;
  String? productPriceModifierId;
  String? productPriceModifierGroupId;
  dynamic labelName;
  String? name;
  String? price;
  bool? isActive;
  String? estimatedTime;

  ProductVariationPriceModifier({
    this.id,
    this.productPriceModifierId,
    this.productPriceModifierGroupId,
    this.labelName,
    this.name,
    this.price,
    this.isActive,
    this.estimatedTime,
  });

  factory ProductVariationPriceModifier.fromJson(Map<String, dynamic> json) =>
      ProductVariationPriceModifier(
        id: json["id"],
        productPriceModifierId: json["productPriceModifierId"],
        productPriceModifierGroupId: json["productPriceModifierGroupId"],
        labelName: json["labelName"],
        name: json["name"],
        price: json["price"],
        isActive: json["isActive"],
        estimatedTime: json["estimatedTime"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "productPriceModifierId": productPriceModifierId,
        "productPriceModifierGroupId": productPriceModifierGroupId,
        "labelName": labelName,
        "name": name,
        "price": price,
        "isActive": isActive,
        "estimatedTime": estimatedTime,
      };
}

class ProductVariationSupplier {
  String? id;
  String? supplierId;
  String? supplierItemCode;

  ProductVariationSupplier({
    this.id,
    this.supplierId,
    this.supplierItemCode,
  });

  factory ProductVariationSupplier.fromJson(Map<String, dynamic> json) =>
      ProductVariationSupplier(
        id: json["id"],
        supplierId: json["supplierId"],
        supplierItemCode: json["supplierItemCode"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "supplierId": supplierId,
        "supplierItemCode": supplierItemCode,
      };
}

class ProductVariationServiceItem {
  String? id;
  String? name;

  ProductVariationServiceItem({
    this.id,
    this.name,
  });

  factory ProductVariationServiceItem.fromJson(Map<String, dynamic> json) =>
      ProductVariationServiceItem(
        id: json["id"],
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
      };
}

class ProductVariationRawIngredientModifierGroup {
  String? id;
  List<ModifierRawSpiceItem>? modifierItems;

  ProductVariationRawIngredientModifierGroup({
    this.id,
    this.modifierItems,
  });

  factory ProductVariationRawIngredientModifierGroup.fromJson(
          Map<String, dynamic> json) =>
      ProductVariationRawIngredientModifierGroup(
        id: json["id"],
        modifierItems: json["modifierItems"] == null
            ? []
            : List<ModifierRawSpiceItem>.from(json["modifierItems"]!
                .map((x) => ModifierRawSpiceItem.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "modifierItems": modifierItems == null
            ? []
            : List<dynamic>.from(modifierItems!.map((x) => x.toJson())),
      };
}

class ModifierRawSpiceItem {
  String? id;
  String? name;
  String? rawIngredientId;
  bool? isActive;
  String? quantity;

  ModifierRawSpiceItem({
    this.id,
    this.name,
    this.rawIngredientId,
    this.isActive,
    this.quantity,
  });

  factory ModifierRawSpiceItem.fromJson(Map<String, dynamic> json) =>
      ModifierRawSpiceItem(
        id: json["id"],
        name: json["name"],
        rawIngredientId: json["rawIngredientId"],
        isActive: json["isActive"],
        quantity: json["quantity"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "rawIngredientId": rawIngredientId,
        "isActive": isActive,
        "quantity": quantity,
      };
}

class ProductVariationModifierGroup {
  String? id;
  bool? isRequired;
  String? modifierGroupId;
  String? selectionTypeId;
  String? maxThresholdQuantity;
  bool? isActive;
  int? sortOrder;
  List<ProductVariationModifierGroupModifierItem>? modifierItems;

  ProductVariationModifierGroup({
    this.id,
    this.isRequired,
    this.modifierGroupId,
    this.selectionTypeId,
    this.maxThresholdQuantity,
    this.isActive,
    this.sortOrder,
    this.modifierItems,
  });

  factory ProductVariationModifierGroup.fromJson(Map<String, dynamic> json) =>
      ProductVariationModifierGroup(
        id: json["id"],
        isRequired: json["isRequired"],
        modifierGroupId: json["modifierGroupId"],
        selectionTypeId: json["selectionTypeId"],
        maxThresholdQuantity: json["maxThresholdQuantity"],
        isActive: json["isActive"],
        sortOrder: json["sortOrder"],
        modifierItems: json["modifierItems"] == null
            ? []
            : List<ProductVariationModifierGroupModifierItem>.from(
                json["modifierItems"]!.map((x) =>
                    ProductVariationModifierGroupModifierItem.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        if (id != null) "id": id,
        if (isRequired != null) "isRequired": isRequired,
        "modifierGroupId": modifierGroupId,
        "selectionTypeId": selectionTypeId,
        "maxThresholdQuantity": maxThresholdQuantity,
        if (isActive != null) "isActive": isActive,
        "sortOrder": sortOrder,
        "modifierItems": modifierItems == null
            ? []
            : List<dynamic>.from(modifierItems!.map((x) => x.toJson())),
      };
}

class ProductVariationModifierGroupModifierItem {
  String? id;
  String? name;
  String? modifierItemId;
  String? productVariationId;
  String? rawLooseIngredientId;
  String? price;
  String? maxThresholdQuantity;
  String? minMeasurementName;
  dynamic rawLooseIngredientQuantity;
  String? type;
  bool? isActive;
  bool? isrequired;
  int? sortOrder;

  ProductVariationModifierGroupModifierItem({
    this.id,
    this.name,
    this.modifierItemId,
    this.productVariationId,
    this.rawLooseIngredientId,
    this.price,
    this.maxThresholdQuantity,
    this.minMeasurementName,
    this.rawLooseIngredientQuantity,
    this.type,
    this.isActive,
    this.isrequired,
    this.sortOrder,
  });

  factory ProductVariationModifierGroupModifierItem.fromJson(
          Map<String, dynamic> json) =>
      ProductVariationModifierGroupModifierItem(
        id: json["id"],
        name: json["name"],
        modifierItemId: json["modifierItemId"],
        productVariationId: json["productVariationId"],
        rawLooseIngredientId: json["rawLooseIngredientId"],
        price: json["price"],
        maxThresholdQuantity: json["maxThresholdQuantity"],
        minMeasurementName: json["minMeasurementName"],
        rawLooseIngredientQuantity: json["rawLooseIngredientQuantity"],
        type: json["type"],
        isActive: json["isActive"],
        isrequired: json["isrequired"],
        sortOrder: json["sortOrder"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "modifierItemId": modifierItemId,
        "productVariationId": productVariationId,
        "rawLooseIngredientId": rawLooseIngredientId,
        "price": price,
        "maxThresholdQuantity": maxThresholdQuantity,
        if (minMeasurementName != null)
          "minMeasurementName": minMeasurementName,
        "rawLooseIngredientQuantity": rawLooseIngredientQuantity,
        "type": type,
        "isActive": isActive,
        if (isrequired != null) "isrequired": isrequired,
        "sortOrder": sortOrder,
      };
}

class ProductVariationSpiceChoiceModifierGroup {
  String? id;
  List<ModifierRawSpiceItem>? modifierItems;

  ProductVariationSpiceChoiceModifierGroup({
    this.id,
    this.modifierItems,
  });

  factory ProductVariationSpiceChoiceModifierGroup.fromJson(
          Map<String, dynamic> json) =>
      ProductVariationSpiceChoiceModifierGroup(
        id: json["id"],
        modifierItems: json["modifierItems"] == null
            ? []
            : List<ModifierRawSpiceItem>.from(json["modifierItems"]!
                .map((x) => ModifierRawSpiceItem.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "modifierItems": modifierItems == null
            ? []
            : List<dynamic>.from(modifierItems!.map((x) => x.toJson())),
      };
}
