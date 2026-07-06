import 'package:pos_account/model/common/filter_category.dart';
import 'package:pos_account/model/common/table_location.dart';

class AllProductAddSecRes {
  AllProductAddSecRes({
    this.brands,
    // this.productCategories,
    // this.taxInclusiveExclusive,
    this.orderTypes,
    this.suppliers,
    // this.barCodeTypes,
    this.code,
    this.filterCategories,
    this.purchaseTaxes,
    this.salesTaxes,
    this.docketGroups,
    this.channels,
    this.spiceChoices,
    this.rawLooseIngredients,
    // this.productPriceModifers,
    // this.productPriceModifierGroups,
    this.productTypes,
    this.productPriceTypes,
    this.spiceChoiceModifierGroup,
    this.rawIngredientModifierGroup,
    this.selectionTypes,
    this.modifierGroups,
  });

  List<TableLocation>? brands;
  // List<Category>? productCategories;
  // List<TableLocation>? taxInclusiveExclusive;
  List<TableLocation>? orderTypes;
  List<TableLocation>? suppliers;
  // List<TableLocation>? barCodeTypes;
  String? code;
  List<FilterCategory>? filterCategories;
  List<TableLocation>? purchaseTaxes;
  List<TableLocation>? salesTaxes;
  List<TableLocation>? docketGroups;
  List<TableLocation>? channels;
  List<TableLocation>? spiceChoices;
  List<RawLooseIngredient>? rawLooseIngredients;
  // List<TableLocation>? productPriceModifers;
  // List<TableLocation>? productPriceModifierGroups;
  List<TableLocation>? productTypes;
  List<TableLocation>? productPriceTypes;
  ModifierGroup? spiceChoiceModifierGroup;
  ModifierGroup? rawIngredientModifierGroup;
  List<TableLocation>? selectionTypes;
  List<TableLocation>? modifierGroups;

  factory AllProductAddSecRes.fromJson(Map<String, dynamic> json) =>
      AllProductAddSecRes(
        brands: json["brands"] == null
            ? null
            : List<TableLocation>.from(
                json["brands"].map((x) => TableLocation.fromJson(x))),
        // productCategories: json["productCategories"] == null
        //     ? null
        //     : List<Category>.from(
        //         json["productCategories"].map((x) => Category.fromJson(x))),
        // taxInclusiveExclusive: json["taxInclusiveExclusive"] == null
        //     ? null
        //     : List<TableLocation>.from(json["taxInclusiveExclusive"]
        //         .map((x) => TableLocation.fromJson(x))),
        orderTypes: json["orderTypes"] == null
            ? null
            : List<TableLocation>.from(
                json["orderTypes"].map((x) => TableLocation.fromJson(x))),
        suppliers: json["suppliers"] == null
            ? null
            : List<TableLocation>.from(
                json["suppliers"].map((x) => TableLocation.fromJson(x))),
        // barCodeTypes: json["barCodeTypes"] == null
        //     ? []
        //     : List<TableLocation>.from(
        //         json["barCodeTypes"]!.map((x) => TableLocation.fromJson(x))),
        code: json["code"],
        filterCategories: json["filterCategories"] == null
            ? []
            : List<FilterCategory>.from(json["filterCategories"]!
                .map((x) => FilterCategory.fromJson(x))),
        purchaseTaxes: json["purchaseTaxes"] == null
            ? []
            : List<TableLocation>.from(
                json["purchaseTaxes"]!.map((x) => TableLocation.fromJson(x))),
        salesTaxes: json["salesTaxes"] == null
            ? []
            : List<TableLocation>.from(
                json["salesTaxes"]!.map((x) => TableLocation.fromJson(x))),
        docketGroups: json["docketGroups"] == null
            ? []
            : List<TableLocation>.from(
                json["docketGroups"]!.map((x) => TableLocation.fromJson(x))),
        channels: json["channels"] == null
            ? []
            : List<TableLocation>.from(
                json["channels"]!.map((x) => TableLocation.fromJson(x))),
        spiceChoices: json["spiceChoices"] == null
            ? []
            : List<TableLocation>.from(
                json["spiceChoices"]!.map((x) => TableLocation.fromJson(x))),
        rawLooseIngredients: json["rawLooseIngredients"] == null
            ? []
            : List<RawLooseIngredient>.from(json["rawLooseIngredients"]!
                .map((x) => RawLooseIngredient.fromJson(x))),
        // productPriceModifers: json["productPriceModifers"] == null
        //     ? []
        //     : List<TableLocation>.from(json["productPriceModifers"]!
        //         .map((x) => TableLocation.fromJson(x))),
        // productPriceModifierGroups: json["productPriceModifierGroups"] == null
        //     ? []
        //     : List<TableLocation>.from(json["productPriceModifierGroups"]!
        //         .map((x) => TableLocation.fromJson(x))),
        productTypes: json["productTypes"] == null
            ? []
            : List<TableLocation>.from(
                json["productTypes"]!.map((x) => TableLocation.fromJson(x))),
        productPriceTypes: json["productPriceTypes"] == null
            ? []
            : List<TableLocation>.from(json["productPriceTypes"]!
                .map((x) => TableLocation.fromJson(x))),
        spiceChoiceModifierGroup: json["spiceChoiceModifierGroup"] == null
            ? null
            : ModifierGroup.fromJson(json["spiceChoiceModifierGroup"]),
        rawIngredientModifierGroup: json["rawIngredientModifierGroup"] == null
            ? null
            : ModifierGroup.fromJson(json["rawIngredientModifierGroup"]),
        selectionTypes: json["selectionTypes"] == null
            ? []
            : List<TableLocation>.from(
                json["selectionTypes"]!.map((x) => TableLocation.fromJson(x))),
        modifierGroups: json["modifierGroups"] == null
            ? []
            : List<TableLocation>.from(
                json["modifierGroups"]!.map((x) => TableLocation.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "brands": brands == null
            ? null
            : List<dynamic>.from(brands!.map((x) => x.toJson())),
        // "productCategories": productCategories == null
        //     ? null
        //     : List<dynamic>.from(productCategories!.map((x) => x.toJson())),
        // "taxInclusiveExclusive": taxInclusiveExclusive == null
        //     ? null
        //     : List<dynamic>.from(taxInclusiveExclusive!.map((x) => x.toJson())),
        "orderTypes": orderTypes == null
            ? null
            : List<dynamic>.from(orderTypes!.map((x) => x.toJson())),
        "suppliers": suppliers == null
            ? null
            : List<dynamic>.from(suppliers!.map((x) => x.toJson())),
        // "barCodeTypes": barCodeTypes == null
        //     ? []
        //     : List<dynamic>.from(barCodeTypes!.map((x) => x.toJson())),
        "code": code,
        "filterCategories": filterCategories == null
            ? []
            : List<dynamic>.from(filterCategories!.map((x) => x.toJson())),
        "purchaseTaxes": purchaseTaxes == null
            ? []
            : List<dynamic>.from(purchaseTaxes!.map((x) => x.toJson())),
        "salesTaxes": salesTaxes == null
            ? []
            : List<dynamic>.from(salesTaxes!.map((x) => x.toJson())),
        "docketGroups": docketGroups == null
            ? []
            : List<dynamic>.from(docketGroups!.map((x) => x.toJson())),
        "channels": channels == null
            ? []
            : List<dynamic>.from(channels!.map((x) => x.toJson())),
        "spiceChoices": spiceChoices == null
            ? []
            : List<dynamic>.from(spiceChoices!.map((x) => x.toJson())),
        "rawLooseIngredients": rawLooseIngredients == null
            ? []
            : List<dynamic>.from(rawLooseIngredients!.map((x) => x.toJson())),
        // "productPriceModifers": productPriceModifers == null
        //     ? []
        //     : List<dynamic>.from(productPriceModifers!.map((x) => x.toJson())),
        // "productPriceModifierGroups": productPriceModifierGroups == null
        //     ? []
        //     : List<dynamic>.from(
        //         productPriceModifierGroups!.map((x) => x.toJson())),
        "productTypes": productTypes == null
            ? []
            : List<dynamic>.from(productTypes!.map((x) => x.toJson())),
        "productPriceTypes": productPriceTypes == null
            ? []
            : List<dynamic>.from(productPriceTypes!.map((x) => x.toJson())),
        "spiceChoiceModifierGroup": spiceChoiceModifierGroup?.toJson(),
        "rawIngredientModifierGroup": rawIngredientModifierGroup?.toJson(),
        "selectionTypes": selectionTypes == null
            ? []
            : List<dynamic>.from(selectionTypes!.map((x) => x.toJson())),
        "modifierGroups": modifierGroups == null
            ? []
            : List<dynamic>.from(modifierGroups!.map((x) => x.toJson())),
      };
}

class RawLooseIngredient {
  String? id;
  String? name;
  String? sellingPricePerUnit;
  String? maxMeasurementName;
  String? minMeasurementName;
  String? unitOfMeasurementId;
  String? availiableStock;
  String? taxValue;
  String? maxToMinConversionFactor;
  String? unitCostPerUnit;

  RawLooseIngredient({
    this.id,
    this.name,
    this.sellingPricePerUnit,
    this.maxMeasurementName,
    this.minMeasurementName,
    this.unitOfMeasurementId,
    this.availiableStock,
    this.taxValue,
    this.maxToMinConversionFactor,
    this.unitCostPerUnit,
  });

  factory RawLooseIngredient.fromJson(Map<String, dynamic> json) =>
      RawLooseIngredient(
        id: json["id"],
        name: json["name"],
        sellingPricePerUnit: json["sellingPricePerUnit"],
        maxMeasurementName: json["maxMeasurementName"],
        minMeasurementName: json["minMeasurementName"],
        unitOfMeasurementId: json["unitOfMeasurementId"],
        availiableStock: json["availiableStock"],
        taxValue: json["taxValue"],
        maxToMinConversionFactor: json["maxToMinConversionFactor"],
        unitCostPerUnit: json["unitCostPerUnit"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "sellingPricePerUnit": sellingPricePerUnit,
        "maxMeasurementName": maxMeasurementName,
        "minMeasurementName": minMeasurementName,
        "unitOfMeasurementId": unitOfMeasurementId,
        "availiableStock": availiableStock,
        "taxValue": taxValue,
        "maxToMinConversionFactor": maxToMinConversionFactor,
        "unitCostPerUnit": unitCostPerUnit,
      };
}

// class FilterCategoriesWithFilterType {
//   FilterCategoriesWithFilterType({
//     this.labelName,
//     this.identifier,
//     this.childernCategories,
//   });

//   String? labelName;
//   String? identifier;
//   List<FilterCategory>? childernCategories;

//   factory FilterCategoriesWithFilterType.fromJson(Map<String, dynamic> json) =>
//       FilterCategoriesWithFilterType(
//         labelName: json["labelName"],
//         identifier: json["identifier"],
//         childernCategories: json["childernCategories"] == null
//             ? []
//             : List<FilterCategory>.from(json["childernCategories"]!
//                 .map((x) => FilterCategory.fromJson(x))),
//       );

//   Map<String, dynamic> toJson() => {
//         "labelName": labelName,
//         "identifier": identifier,
//         "childernCategories": childernCategories == null
//             ? []
//             : List<dynamic>.from(childernCategories!.map((x) => x.toJson())),
//       };
// }

class ModifierGroup {
  String? id;
  String? name;
  String? selectionTypeId;
  String? maxThresholdQuantity;

  ModifierGroup({
    this.id,
    this.name,
    this.selectionTypeId,
    this.maxThresholdQuantity,
  });

  factory ModifierGroup.fromJson(Map<String, dynamic> json) => ModifierGroup(
        id: json["id"],
        name: json["name"],
        selectionTypeId: json["selectionTypeId"],
        maxThresholdQuantity: json["maxThresholdQuantity"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "selectionTypeId": selectionTypeId,
        "maxThresholdQuantity": maxThresholdQuantity,
      };
}
