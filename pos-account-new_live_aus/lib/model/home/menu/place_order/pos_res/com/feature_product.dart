import 'package:pos_account/config/utils/promo_utils.dart';
import 'package:pos_account/model/home/menu/place_order/product_filter_option.dart';

class FeaturedProduct {
  FeaturedProduct({
    this.id,
    this.categoryId,
    // this.productName,
    // this.categoryTypeId,
    this.docketGroupName,
    this.docketGroupSort,
    this.enableDocketGroupSpliter = false,
    this.productVariationName,
    this.productVariationLabelName,
    this.productDescription,
    // this.taxExclusiveInclusiveType,
    // this.taxExclusiveInclusiveValue,
    // this.productImage,
    this.productVariations,
    this.addOns,
    // this.isHalfCategory,
    this.productVariationModifiers,
    this.name,
    this.imageUrl,
    this.variationCount,
    this.salesTax,
    this.taxRules,
    this.priceRange,
    this.productType,
    this.productPriceType,
    this.filterTypeFilterOptions,
    this.isTaxExempt = false,

    ///
    this.quantity = 1.0,
    this.productIngredients,

    ///
    this.isSelected = false,
    // this.selectedSpiceId,
    // this.spiceUpdateId,
    //
    this.updateId,
    this.docketGroupId,
    //
    this.maxSelectCount,
    this.selectedComboCatIndex,
    this.selectedItemQtyIndex = 0,
    this.tempComboProduct,
    this.loadItemDetail = false,
    this.variablePrice = "0.0",
    this.varId,
    this.parentCatId,
    this.taxRuleIndex = 0,
    this.preparationType,
    this.sortOrder,
  });

  String? id;
  String? categoryId;
  // String? productName;
  // String? categoryTypeId;
  String? docketGroupName;
  String? docketGroupId;
  String? variablePrice;
  String? docketGroupSort;
  bool? enableDocketGroupSpliter;
  String? productVariationName;
  String? productVariationLabelName;
  String? productDescription;
  // String? taxExclusiveInclusiveType;
  // String? taxExclusiveInclusiveValue;
  // String? productImage;
  List<ProductVariation>? productVariations;
  List<FeaturedProduct>? addOns;

  // bool? isHalfCategory;
  List<ProductVariationModifier>? productVariationModifiers;
  List<ProductIngredient>? productIngredients;
  String? name;
  String? imageUrl;
  String? variationCount;
  String? salesTax;
  List<TaxRule>? taxRules;
  String? priceRange;
  String? productType;
  String? productPriceType;
  List<ProductFilterOption>? filterTypeFilterOptions;
  bool isTaxExempt;

  // extra
  double quantity;
  bool isSelected;
  // String? selectedSpiceId;
  // String? spiceUpdateId;
  //for setmenu itemDelete
  String? updateId;
  // for setmenu max selected item
  double? maxSelectCount;
  int? selectedComboCatIndex;
  int selectedItemQtyIndex;
  List<FeaturedProduct?>? tempComboProduct;
  bool loadItemDetail;
  String? varId;
  String? parentCatId;

  int taxRuleIndex;
  String? preparationType;
  int? sortOrder;

  factory FeaturedProduct.fromJson(Map<String, dynamic> json) =>
      FeaturedProduct(
        id: json["id"],
        categoryId: json["categoryId"],
        // productName: json["productName"]?? json["name"],
        // categoryTypeId: json["categoryTypeId"],
        docketGroupName: json["docketGroupName"],
        docketGroupSort: json["docketGroupSort"],
        enableDocketGroupSpliter: json["enableDocketGroupSpliter"],
        productVariationName: json["productVariationName"],
        productVariationLabelName: json["productVariationLabelName"],
        productDescription: json["productDescription"],
        // taxExclusiveInclusiveType: json["taxExclusiveInclusiveType"],
        // taxExclusiveInclusiveValue: json["taxExclusiveInclusiveValue"],
        // productImage: json["productImage"],
        productVariations: json["productVariations"] == null
            ? null
            : List<ProductVariation>.from(json["productVariations"]
                .map((x) => ProductVariation.fromJson(x))),
        addOns: json["addOns"] == null
            ? null
            : List<FeaturedProduct>.from(
                json["addOns"].map((x) => FeaturedProduct.fromJson(x))),

        // isHalfCategory: json["isHalfCategory"],
        productVariationModifiers: json["productVariationModifiers"] == null
            ? []
            : List<ProductVariationModifier>.from(
                json["productVariationModifiers"]!
                    .map((x) => ProductVariationModifier.fromJson(x))),

        productIngredients: json["productIngredients"] == null
            ? []
            : List<ProductIngredient>.from(json["productIngredients"]!
                .map((x) => ProductIngredient.fromJson(x))),
        name: json["name"] ?? json["productName"],
        imageUrl: json["imageUrl"] ?? json["productImage"],
        variationCount: json["variationCount"],
        salesTax: json["salesTax"],
        taxRules: json["taxRules"] == null
            ? []
            : List<TaxRule>.from(
                json["taxRules"]!.map((x) => TaxRule.fromJson(x))),

        quantity: json["quantity"] == null
            ? 1.0
            : json["quantity"] is String
                ? (double.tryParse(json["quantity"]) ?? 1.0)
                : json["quantity"],
        priceRange: json["priceRange"],
        productType: json["productType"],
        productPriceType: json["productPriceType"],
        filterTypeFilterOptions: json["filterTypeFilterOptions"] == null
            ? []
            : List<ProductFilterOption>.from(json["filterTypeFilterOptions"]!
                .map((x) => ProductFilterOption.fromJson(x))),
        isTaxExempt: json["isTaxExempt"] ?? false,
        sortOrder: json["sortOrder"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "categoryId": categoryId,
        "productName": name,
        // "categoryTypeId": categoryTypeId,
        "docketGroupName": docketGroupName,
        "docketGroupSort": docketGroupSort,
        "enableDocketGroupSpliter": enableDocketGroupSpliter,
        "productVariationName": productVariationName,
        "productVariationLabelName": productVariationLabelName,
        "productDescription": productDescription,
        // "taxExclusiveInclusiveType": taxExclusiveInclusiveType,
        // "taxExclusiveInclusiveValue": taxExclusiveInclusiveValue,
        // "productImage": productImage,
        "productVariations": productVariations == null
            ? null
            : List<dynamic>.from(productVariations!.map((x) => x.toJson())),
        "addOns": addOns == null
            ? null
            : List<dynamic>.from(addOns!.map((x) => x.toJson())),

        // "isHalfCategory": isHalfCategory,
        "productVariationModifiers": productVariationModifiers == null
            ? []
            : List<dynamic>.from(
                productVariationModifiers!.map((x) => x.toJson())),

        "productIngredients": productIngredients == null
            ? []
            : List<dynamic>.from(productIngredients!.map((x) => x.toJson())),
        "name": name,
        "imageUrl": imageUrl,
        "productImage": imageUrl,
        "variationCount": variationCount,
        "salesTax": salesTax,
        "taxRules": taxRules == null
            ? []
            : List<dynamic>.from(taxRules!.map((x) => x.toJson())),

        "quantity": quantity,
        "priceRange": priceRange,
        "productType": productType,
        "productPriceType": productPriceType,
        "filterTypeFilterOptions": filterTypeFilterOptions == null
            ? []
            : List<dynamic>.from(
                filterTypeFilterOptions!.map((x) => x.toJson())),
        "isTaxExempt": isTaxExempt,
        "sortOrder": sortOrder,
      };
}

class ProductVariation {
  ProductVariation({
    this.name,
    this.id,
    this.isDefault,
    // this.price,
    this.unitPrice,
    this.actualPrice,
    this.discount,
    this.stockCount,
    this.outOfStockMessage,
    this.productVariationModifiers,
    // this.productIngredients,
    this.discountedPrice,
    this.discountPercentage,
    // this.discountedPromotions,
    this.buyXGetXyPromotions,
    this.productVariationBatchStocks,
    this.productVariationServiceEmployees,
    this.estimatedTime,
    this.serviceGender,
    this.productVariationServiceItems,
    // this.productSpiceChoices,
    this.additionalPrice,
    this.channelId,

    //
    this.quantity = 1.0,
    this.barcodeNumber,
    // this.isSelect = false,
    this.promoModel,
  });

  String? name;
  String? id;
  bool? isDefault;
  // String? price;
  String? unitPrice;
  String? actualPrice;
  String? discount;
  String? stockCount;
  String? outOfStockMessage;
  List<ProductVariationModifier>? productVariationModifiers;
  // List<ProductIngredient>? productIngredients;
  String? discountedPrice;
  String? discountPercentage;
  // List<DiscountedPromotion>? discountedPromotions;
  dynamic buyXGetXyPromotions;
  List<ProductVariationBatchStock>? productVariationBatchStocks;
  List<ProductSpiceChoice>? productVariationServiceEmployees;
  String? estimatedTime;
  String? serviceGender;
  List<ProductVariationServiceItem>? productVariationServiceItems;
  // List<ProductSpiceChoice>? productSpiceChoices;
  String? additionalPrice;
  String? channelId;
  //
  double quantity;
  String? barcodeNumber;
  PromoModel? promoModel;

  factory ProductVariation.fromJson(Map<String, dynamic> json) =>
      ProductVariation(
        name: json["name"],
        id: json["id"],
        isDefault: json["isDefault"],
        // price: json["price"],
        unitPrice: json["unitPrice"],
        actualPrice: json["actualPrice"],
        discount: json["discount"],
        stockCount: json["stockCount"],
        outOfStockMessage: json["outOfStockMessage"],
        productVariationModifiers: json["productVariationModifiers"] == null
            ? []
            : List<ProductVariationModifier>.from(
                json["productVariationModifiers"]!
                    .map((x) => ProductVariationModifier.fromJson(x))),

        // productIngredients: json["productVariationIngredients"] == null
        //     ? []
        //     : List<ProductIngredient>.from(json["productVariationIngredients"]!
        //         .map((x) => ProductIngredient.fromJson(x))),
        discountedPrice: json["discountedPrice"],
        discountPercentage: json["discountPercentage"],
        // discountedPromotions: json["discountedPromotions"] == null
        //     ? []
        //     : List<DiscountedPromotion>.from(json["discountedPromotions"]!
        //         .map((x) => DiscountedPromotion.fromJson(x))),
        buyXGetXyPromotions: json["buyXGetXYPromotions"],
        productVariationBatchStocks: json["productVariationBatchStocks"] == null
            ? []
            : List<ProductVariationBatchStock>.from(
                json["productVariationBatchStocks"]!
                    .map((x) => ProductVariationBatchStock.fromJson(x))),
        productVariationServiceEmployees:
            json["productVariationServiceEmployees"] == null
                ? []
                : List<ProductSpiceChoice>.from(
                    json["productVariationServiceEmployees"]!
                        .map((x) => ProductSpiceChoice.fromJson(x))),
        estimatedTime: json["estimatedTime"],
        serviceGender: json["serviceGender"],
        productVariationServiceItems:
            json["productVariationServiceItems"] == null
                ? []
                : List<ProductVariationServiceItem>.from(
                    json["productVariationServiceItems"]!
                        .map((x) => ProductVariationServiceItem.fromJson(x))),
        // productSpiceChoices: json["productVariationSpiceChoices"] == null
        //     ? []
        //     : List<ProductSpiceChoice>.from(
        //         json["productVariationSpiceChoices"]!
        //             .map((x) => ProductSpiceChoice.fromJson(x))),
        quantity: json["quantity"] == null
            ? 1.0
            : json["quantity"] is String
                ? (double.tryParse(json["quantity"]) ?? 1.0)
                : json["quantity"],
        additionalPrice: json["additionalPrice"],
        channelId: json["channelId"],
        barcodeNumber: json["barcodeNumber"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "id": id,
        "isDefault": isDefault,
        // "price": price,
        "unitPrice": unitPrice,
        "actualPrice": actualPrice,
        "discount": discount,
        "stockCount": stockCount,
        "outOfStockMessage": outOfStockMessage,
        "productVariationModifiers": productVariationModifiers == null
            ? []
            : List<dynamic>.from(
                productVariationModifiers!.map((x) => x.toJson())),

        // "productVariationIngredients": productIngredients == null
        //     ? []
        //     : List<dynamic>.from(productIngredients!.map((x) => x.toJson())),
        "discountedPrice": discountedPrice,
        "discountPercentage": discountPercentage,
        // "discountedPromotions": discountedPromotions == null
        //     ? []
        //     : List<dynamic>.from(discountedPromotions!.map((x) => x.toJson())),
        "buyXGetXYPromotions": buyXGetXyPromotions,
        "productVariationBatchStocks": productVariationBatchStocks == null
            ? []
            : List<dynamic>.from(
                productVariationBatchStocks!.map((x) => x.toJson())),
        "productVariationServiceEmployees":
            productVariationServiceEmployees == null
                ? []
                : List<dynamic>.from(
                    productVariationServiceEmployees!.map((x) => x.toJson())),
        "estimatedTime": estimatedTime,
        "serviceGender": serviceGender,
        "productVariationServiceItems": productVariationServiceItems == null
            ? []
            : List<dynamic>.from(
                productVariationServiceItems!.map((x) => x.toJson())),
        // "productVariationSpiceChoices": productSpiceChoices == null
        //     ? []
        //     : List<dynamic>.from(productSpiceChoices!.map((x) => x.toJson())),
        "quantity": quantity,
        "additionalPrice": additionalPrice,
        "channelId": channelId,
        "barcodeNumber": barcodeNumber,
      };
}

class ProductVariationModifier {
  String? name;
  String? selectionType;
  String? maxThresholdQuantity;
  List<ModifierItem>? modifierItems;
  bool? isRequired;
  String? productVariationId;
  String? type;

  ProductVariationModifier({
    this.name,
    this.selectionType,
    this.maxThresholdQuantity,
    this.modifierItems,
    this.isRequired,
    this.productVariationId,
    this.type,
  });

  factory ProductVariationModifier.fromJson(Map<String, dynamic> json) =>
      ProductVariationModifier(
        name: json["name"],
        selectionType: json["selectionType"],
        maxThresholdQuantity: (json["maxThresholdQuantity"] ?? '').toString(),
        modifierItems: json["modifierItems"] == null
            ? []
            : List<ModifierItem>.from(
                json["modifierItems"]!.map((x) => ModifierItem.fromJson(x))),
        isRequired: json["isRequired"],
        productVariationId: json["productVariationId"],
        type: json["type"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "selectionType": selectionType,
        "maxThresholdQuantity": maxThresholdQuantity,
        "modifierItems": modifierItems == null
            ? []
            : List<dynamic>.from(modifierItems!.map((x) => x.toJson())),
        "isRequired": isRequired,
        "productVariationId": productVariationId,
        "type": type,
      };
}

class ModifierItem {
  String? id;
  String? productName;
  String? variationName;
  // String? name;
  String? maxThresholdQuantity;
  String? actualPrice;
  String? discountedPrice;
  String? salesTax;
  List<TaxRule>? taxRules;
  bool? isFree;
  String updateId;
  double quantity;
  bool? isActive;
  String? estimatedTime;
  String? imageUrl;
  List<ProductVariationModifier>? modifierItemModifiers;
  String? channelId;
  bool isTaxExempt;
  bool? isDefault;
  String? productType;
  // show product name only when half n half & deal, else show both

  String? variationId;
  String? productPriceType;
  String? productId;
  bool? isRequired;
  String? additionalPrice;
  String? availableQuantity;

  //
  List<ModifierItem?>? multipleCombo;
  double? maxSelectCount;
  int selectedItemQtyIndex;
  bool loadItemDetail;
  bool? isSelected;
  double? halfItemPrice;
  PromoModel? promoModel;

  ModifierItem({
    this.id,
    this.productName,
    this.variationName,
    // this.name,
    this.maxThresholdQuantity,
    this.actualPrice,
    this.discountedPrice,
    this.salesTax,
    this.taxRules,
    this.isFree,
    this.updateId = "",
    this.quantity = 1.0,
    this.isActive,
    this.estimatedTime,
    this.imageUrl,
    this.modifierItemModifiers,
    this.channelId,
    this.isTaxExempt = false,
    this.isDefault,
    this.productType,
    this.variationId,
    this.productPriceType,
    this.productId,
    this.isRequired,
    this.additionalPrice,
    this.availableQuantity,
    //
    this.multipleCombo,
    this.maxSelectCount,
    this.selectedItemQtyIndex = 0,
    this.loadItemDetail = false,
    this.isSelected,
    this.halfItemPrice,
    this.promoModel,
  });

  factory ModifierItem.fromJson(Map<String, dynamic> json) => ModifierItem(
        id: json["id"],
        productName: json["productName"],
        variationName: json["variationName"],
        // name: json["name"],
        maxThresholdQuantity: json["maxThresholdQuantity"],
        actualPrice: json["actualPrice"],
        discountedPrice: json["discountedPrice"],
        salesTax: json["salesTax"],
        taxRules: json["taxRules"] == null
            ? []
            : List<TaxRule>.from(
                json["taxRules"]!.map((x) => TaxRule.fromJson(x))),
        isFree: json["isFree"],
        quantity: json['quantity'] ?? 1,
        isActive: json["isActive"],
        estimatedTime: json["estimatedTime"],
        imageUrl: json["imageUrl"],
        modifierItemModifiers: json["modifierItemModifiers"] == null
            ? []
            : List<ProductVariationModifier>.from(json["modifierItemModifiers"]!
                .map((x) => ProductVariationModifier.fromJson(x))),
        channelId: json["channelId"],
        isTaxExempt: json["isTaxExempt"] ?? false,
        isDefault: json["isDefault"],
        productType: json["productType"],
        variationId: json["variationId"],
        productPriceType: json["productPriceType"],
        isSelected: json["isSelected"],
        productId: json["productId"],
        isRequired: json["isRequired"],
        additionalPrice: json["additionalPrice"],
        availableQuantity: json["availableQuantity"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "productName": productName,
        "variationName": variationName,
        // "name": name,
        "maxThresholdQuantity": maxThresholdQuantity,
        "actualPrice": actualPrice,
        "discountedPrice": discountedPrice,
        "salesTax": salesTax,
        "taxRules": taxRules == null
            ? []
            : List<dynamic>.from(taxRules!.map((x) => x.toJson())),
        "isFree": isFree,
        "quantity": quantity,
        "isActive": isActive,
        "estimatedTime": estimatedTime,
        "imageUrl": imageUrl,
        "modifierItemModifiers": modifierItemModifiers == null
            ? []
            : List<dynamic>.from(modifierItemModifiers!.map((x) => x.toJson())),
        "channelId": channelId,
        "isTaxExempt": isTaxExempt,
        "isDefault": isDefault,
        "productType": productType,
        "variationId": variationId,
        "productPriceType": productPriceType,
        "isSelected": isSelected,
        "productId": productId,
        "isRequired": isRequired,
        "additionalPrice": additionalPrice,
        "availableQuantity": availableQuantity,
      };
}

// class ProductPriceModifier {
//   ProductPriceModifier({
//     this.id,
//     this.price,
//     this.name,
//     this.isActive,
//     this.labelName,
//     this.productPriceModifierId,
//     this.productPriceModifierGroupId,
//     this.estimatedTime,
//     this.updateId = "",
//     this.quantity = 1,
//   });

//   String? id;
//   String? price;
//   String? name;
//   bool? isActive;
//   String? labelName;
//   String? productPriceModifierId;
//   String? productPriceModifierGroupId;
//   String? estimatedTime;
//   String updateId;
//   int quantity;

//   factory ProductPriceModifier.fromJson(Map<String, dynamic> json) =>
//       ProductPriceModifier(
//         id: json["id"],
//         price: json["price"],
//         name: json["name"],
//         isActive: json["isActive"],
//         labelName: json["labelName"],
//         productPriceModifierId: json["productPriceModifierId"],
//         productPriceModifierGroupId: json["productPriceModifierGroupId"],
//         estimatedTime: json["estimatedTime"],
//         quantity: json['quantity'] ?? 1,
//       );

//   Map<String, dynamic> toJson() => {
//         "id": id,
//         "price": price,
//         "name": name,
//         "isActive": isActive,
//         "labelName": labelName,
//         "productPriceModifierId": productPriceModifierId,
//         "productPriceModifierGroupId": productPriceModifierGroupId,
//         "estimatedTime": estimatedTime,
//         "quantity": quantity,
//       };
// }

// class ProductsWithCategory {
//   ProductsWithCategory({
//     this.isSetMenuCategory,
//     this.categoryId,
//     this.categoryTypeId,
//     this.isSetMenu,
//     this.isFeatured,
//     this.isHalfCategory,
//     this.isRawInGredient,
//     this.categoryName,
//     this.categoryImage,
//     this.products,
//     this.subCategories,
//   });

//   bool? isSetMenuCategory;
//   String? categoryId;
//   String? categoryTypeId;
//   bool? isSetMenu;
//   bool? isFeatured;
//   bool? isHalfCategory;
//   bool? isRawInGredient;
//   String? categoryName;
//   String? categoryImage;
//   List<FeaturedProduct>? products;
//   List<SubCategory>? subCategories;

//   factory ProductsWithCategory.fromJson(Map<String, dynamic> json) =>
//       ProductsWithCategory(
//         isSetMenuCategory: json["isSetMenuCategory"],
//         categoryId: json["categoryId"],
//         categoryTypeId: json["categoryTypeId"],
//         isSetMenu: json["isSetMenu"],
//         isFeatured: json["isFeatured"],
//         isRawInGredient: json["isRawInGredient"],
//         isHalfCategory: json["isHalfCategory"],
//         categoryName: json["categoryName"],
//         categoryImage: json["categoryImage"],
//         products: json["products"] == null
//             ? null
//             : List<FeaturedProduct>.from(
//                 json["products"].map((x) => FeaturedProduct.fromJson(x))),
//         subCategories: json["subCategories"] == null
//             ? []
//             : List<SubCategory>.from(
//                 json["subCategories"]!.map((x) => SubCategory.fromJson(x))),
//       );

//   Map<String, dynamic> toJson() => {
//         "isSetMenuCategory": isSetMenuCategory,
//         "categoryId": categoryId,
//         "categoryTypeId": categoryTypeId,
//         "isSetMenu": isSetMenu,
//         "isFeatured": isFeatured,
//         "isHalfCategory": isHalfCategory,
//         "isRawInGredient": isRawInGredient,
//         "categoryName": categoryName,
//         "categoryImage": categoryImage,
//         "products": products == null
//             ? null
//             : List<dynamic>.from(products!.map((x) => x.toJson())),
//         "subCategories": subCategories == null
//             ? []
//             : List<dynamic>.from(subCategories!.map((x) => x.toJson())),
//       };
// }

// class SetMenu {
//   SetMenu({
//     this.id,
//     this.taxExclusiveInclusiveType,
//     this.taxExclusiveInclusiveValue,
//     this.isSetMenu,
//     this.setMenuName,
//     this.image,
//     this.setMenuPrice,
//     this.setMenuProductListViewModelWithCategory,
//     this.setMenuActualPrice,
//     this.discountPercentage,
//     this.quantity = 1,
//     this.curSym = "",
//   });

//   String? id;
//   String? taxExclusiveInclusiveType;
//   String? taxExclusiveInclusiveValue;
//   bool? isSetMenu;
//   String? setMenuName;
//   String? image;
//   String? setMenuPrice;
//   List<SetMenuProductListViewModelWithCategory>?
//       setMenuProductListViewModelWithCategory;
//   String? setMenuActualPrice;
//   String? discountPercentage;
//   // extra
//   int quantity;
//   String curSym;

//   factory SetMenu.fromJson(Map<String, dynamic> json) => SetMenu(
//         id: json["id"],
//         taxExclusiveInclusiveType: json["taxExclusiveInclusiveType"],
//         taxExclusiveInclusiveValue: json["taxExclusiveInclusiveValue"],
//         isSetMenu: json["isSetMenu"],
//         setMenuName: json["setMenuName"],
//         image: json["image"],
//         setMenuPrice: json["setMenuPrice"],
//         setMenuProductListViewModelWithCategory:
//             json["setMenuProductListViewModelWithCategory"] == null
//                 ? null
//                 : List<SetMenuProductListViewModelWithCategory>.from(
//                     json["setMenuProductListViewModelWithCategory"].map((x) =>
//                         SetMenuProductListViewModelWithCategory.fromJson(x))),
//         setMenuActualPrice: json["setMenuActualPrice"],
//         discountPercentage: json["discountPercentage"],
//       );

//   Map<String, dynamic> toJson() => {
//         "id": id,
//         "taxExclusiveInclusiveType": taxExclusiveInclusiveType,
//         "taxExclusiveInclusiveValue": taxExclusiveInclusiveValue,
//         "isSetMenu": isSetMenu,
//         "setMenuName": setMenuName,
//         "image": image,
//         "setMenuPrice": setMenuPrice,
//         "setMenuProductListViewModelWithCategory":
//             setMenuProductListViewModelWithCategory == null
//                 ? null
//                 : List<dynamic>.from(setMenuProductListViewModelWithCategory!
//                     .map((x) => x.toJson())),
//         "setMenuActualPrice": setMenuActualPrice,
//         "discountPercentage": discountPercentage,
//       };
// }

// class SetMenuProductListViewModelWithCategory {
//   SetMenuProductListViewModelWithCategory({
//     this.id,
//     this.categoryName,
//     this.categoryDescription,
//     this.maxItemCount,
//     this.setMenuProductListViewModels,
//   });

//   String? id;
//   String? categoryName;
//   String? categoryDescription;
//   String? maxItemCount;
//   List<FeaturedProduct>? setMenuProductListViewModels;

//   factory SetMenuProductListViewModelWithCategory.fromJson(
//           Map<String, dynamic> json) =>
//       SetMenuProductListViewModelWithCategory(
//         id: json["id"],
//         categoryName: json["categoryName"],
//         categoryDescription: json["categoryDescription"],
//         maxItemCount: json["maxItemCount"],
//         setMenuProductListViewModels: json["setMenuProductListViewModels"] ==
//                 null
//             ? null
//             : List<FeaturedProduct>.from(json["setMenuProductListViewModels"]
//                 .map((x) => FeaturedProduct.fromJson(x))),
//       );

//   Map<String, dynamic> toJson() => {
//         "id": id,
//         "categoryName": categoryName,
//         "categoryDescription": categoryDescription,
//         "maxItemCount": maxItemCount,
//         "setMenuProductListViewModels": setMenuProductListViewModels == null
//             ? null
//             : List<dynamic>.from(
//                 setMenuProductListViewModels!.map((x) => x.toJson())),
//       };
// }

// class SubCategory {
//   String? name;
//   String? id;

//   SubCategory({
//     this.name,
//     this.id,
//   });

//   factory SubCategory.fromJson(Map<String, dynamic> json) => SubCategory(
//         name: json["name"],
//         id: json["id"],
//       );

//   Map<String, dynamic> toJson() => {
//         "name": name,
//         "id": id,
//       };
// }

class ProductSpiceChoice {
  String? id;
  String? name;
  String? imageUrl;
  bool isSelected;
  String? updateId;

  ProductSpiceChoice({
    this.id,
    this.name,
    this.imageUrl,
    this.isSelected = false,
    this.updateId,
  });

  factory ProductSpiceChoice.fromJson(Map<String, dynamic> json) =>
      ProductSpiceChoice(
        id: json["id"],
        name: json["name"],
        imageUrl: json["imageUrl"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "imageUrl": imageUrl,
      };
}

class ProductIngredient {
  String? name;
  String? id;
  bool isActive;

  ProductIngredient({
    this.name,
    this.id,
    this.isActive = false,
  });

  factory ProductIngredient.fromJson(Map<String, dynamic> json) =>
      ProductIngredient(
        name: json["name"],
        id: json["id"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "id": id,
      };
}

// class RawIngredient {
//   String? id;
//   String? name;
//   String? sellingPricePerUnit;
//   String? maxMeasurementName;
//   String? minMeasurementName;
//   String? unitOfMeasurementId;
//   String? availiableStock;
//   String? taxValue;
//   String? maxToMinConversionFactor;
//   // String? updateId;

//   RawIngredient({
//     this.id,
//     this.name,
//     this.sellingPricePerUnit,
//     this.maxMeasurementName,
//     this.minMeasurementName,
//     this.unitOfMeasurementId,
//     this.availiableStock,
//     this.taxValue,
//     this.maxToMinConversionFactor,
//     // this.updateId,
//   });

//   factory RawIngredient.fromJson(Map<String, dynamic> json) => RawIngredient(
//         id: json["id"],
//         name: json["name"],
//         sellingPricePerUnit: json["sellingPricePerUnit"],
//         maxMeasurementName: json["maxMeasurementName"],
//         minMeasurementName: json["minMeasurementName"],
//         unitOfMeasurementId: json["unitOfMeasurementId"],
//         availiableStock: json["availiableStock"],
//         taxValue: json["taxValue"],
//         maxToMinConversionFactor: json["maxToMinConversionFactor"],
//       );

//   Map<String, dynamic> toJson() => {
//         "id": id,
//         "name": name,
//         "sellingPricePerUnit": sellingPricePerUnit,
//         "maxMeasurementName": maxMeasurementName,
//         "minMeasurementName": minMeasurementName,
//         "unitOfMeasurementId": unitOfMeasurementId,
//         "availiableStock": availiableStock,
//         "taxValue": taxValue,
//         "maxToMinConversionFactor": maxToMinConversionFactor,
//       };
// }

class SubCategory {
  // bool? isHalfCategory;
  String? name;
  String? id;

  SubCategory({
    // this.isHalfCategory,
    this.name,
    this.id,
  });

  factory SubCategory.fromJson(Map<String, dynamic> json) => SubCategory(
        // isHalfCategory: json["isHalfCategory"],
        name: json["name"],
        id: json["id"],
      );

  Map<String, dynamic> toJson() => {
        // "isHalfCategory": isHalfCategory,
        "name": name,
        "id": id,
      };
}

class DiscountedPromotion {
  String? recurringFrequency;
  List<String>? weekDays;
  String? timeFrom;
  String? timeTo;
  String? discountPercentage;
  String? discountPrice;
  String? discountedPrice;
  String? discountThresholdCount;
  String? promotionalMessage;
  bool? isFree;

  DiscountedPromotion({
    this.recurringFrequency,
    this.weekDays,
    this.timeFrom,
    this.timeTo,
    this.discountPercentage,
    this.discountPrice,
    this.discountedPrice,
    this.discountThresholdCount,
    this.promotionalMessage,
    this.isFree,
  });

  factory DiscountedPromotion.fromJson(Map<String, dynamic> json) =>
      DiscountedPromotion(
        recurringFrequency: json["recurringFrequency"],
        weekDays: json["weekDays"] == null
            ? []
            : List<String>.from(json["weekDays"]!.map((x) => x)),
        timeFrom: json["timeFrom"],
        timeTo: json["timeTo"],
        discountPercentage: json["discountPercentage"],
        discountPrice: json["discountPrice"],
        discountedPrice: json["discountedPrice"],
        discountThresholdCount: json["discountThresholdCount"],
        promotionalMessage: json["promotionalMessage"],
        isFree: json["isFree"],
      );

  Map<String, dynamic> toJson() => {
        "recurringFrequency": recurringFrequency,
        "weekDays":
            weekDays == null ? [] : List<dynamic>.from(weekDays!.map((x) => x)),
        "timeFrom": timeFrom,
        "timeTo": timeTo,
        "discountPercentage": discountPercentage,
        "discountPrice": discountPrice,
        "discountedPrice": discountedPrice,
        "discountThresholdCount": discountThresholdCount,
        "promotionalMessage": promotionalMessage,
        "isFree": isFree,
      };
}

class ProductVariationBatchStock {
  String? batchId;
  String? batchNumber;
  String? stockCount;
  String? expiryDate;
  bool isActive;

  ProductVariationBatchStock({
    this.batchId,
    this.batchNumber,
    this.stockCount,
    this.expiryDate,
    this.isActive = false,
  });

  factory ProductVariationBatchStock.fromJson(Map<String, dynamic> json) =>
      ProductVariationBatchStock(
        batchId: json["batchId"],
        batchNumber: json["batchNumber"],
        stockCount: json["stockCount"],
        expiryDate: json["expiryDate"],
      );

  Map<String, dynamic> toJson() => {
        "batchId": batchId,
        "batchNumber": batchNumber,
        "stockCount": stockCount,
        "expiryDate": expiryDate,
      };
}

class ProductVariationServiceItem {
  String? name;

  ProductVariationServiceItem({
    this.name,
  });

  factory ProductVariationServiceItem.fromJson(Map<String, dynamic> json) =>
      ProductVariationServiceItem(
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
      };
}

class TaxRule {
  String? taxRuleName;
  List<TaxRuleCondition>? taxRuleConditions;

  TaxRule({
    this.taxRuleName,
    this.taxRuleConditions,
  });

  factory TaxRule.fromJson(Map<String, dynamic> json) => TaxRule(
        taxRuleName: json["taxRuleName"],
        taxRuleConditions: json["taxRuleConditions"] == null
            ? []
            : List<TaxRuleCondition>.from(json["taxRuleConditions"]!
                .map((x) => TaxRuleCondition.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "taxRuleName": taxRuleName,
        "taxRuleConditions": taxRuleConditions == null
            ? []
            : List<dynamic>.from(taxRuleConditions!.map((x) => x.toJson())),
      };
}

class TaxRuleCondition {
  String? orderTypeId;
  String? salesTax;

  TaxRuleCondition({
    this.orderTypeId,
    this.salesTax,
  });

  factory TaxRuleCondition.fromJson(Map<String, dynamic> json) =>
      TaxRuleCondition(
        orderTypeId: json["orderTypeId"],
        salesTax: json["salesTax"],
      );

  Map<String, dynamic> toJson() => {
        "orderTypeId": orderTypeId,
        "salesTax": salesTax,
      };
}
