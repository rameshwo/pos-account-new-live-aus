import 'package:flutter/material.dart';

class PrintProdDetailRes {
  String? printerId;
  String? printerName;
  bool? printAllProductToKitchen;
  List<ProductCategoryVariationList>? productCategoryVariationList;

  PrintProdDetailRes({
    this.printerId,
    this.printerName,
    this.printAllProductToKitchen,
    this.productCategoryVariationList,
  });

  factory PrintProdDetailRes.fromJson(Map<String, dynamic> json) =>
      PrintProdDetailRes(
        printerId: json["printerId"],
        printerName: json["printerName"],
        printAllProductToKitchen: json["printAllProductToKitchen"],
        productCategoryVariationList:
            json["productCategoryVariationList"] == null
                ? []
                : List<ProductCategoryVariationList>.from(
                    json["productCategoryVariationList"]!
                        .map((x) => ProductCategoryVariationList.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "printerId": printerId,
        "printerName": printerName,
        "printAllProductToKitchen": printAllProductToKitchen,
        "productCategoryVariationList": productCategoryVariationList == null
            ? []
            : List<dynamic>.from(
                productCategoryVariationList!.map((x) => x.toJson())),
      };
}

class ProductCategoryVariationList {
  String? categoryId;
  List<String>? productVariationIds;
  List<ComboGroupProduct>? modifierList;

  ProductCategoryVariationList({
    this.categoryId,
    this.productVariationIds,
    this.modifierList,
  });

  factory ProductCategoryVariationList.fromJson(Map<String, dynamic> json) =>
      ProductCategoryVariationList(
        categoryId: json["categoryId"],
        productVariationIds: json["productVariationIds"] == null
            ? []
            : List<String>.from(json["productVariationIds"]!.map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "categoryId": categoryId,
        "productVariationIds": productVariationIds == null
            ? []
            : List<dynamic>.from(productVariationIds!.map((x) => x)),
      };
}

class ComboGroupProduct {
  final String id;
  final String productId;
  final String name;
  final TextEditingController? qtyCltr;
  final TextEditingController? priceCltr;
  bool isActive;
  bool isReq;
  bool prevIsReqVal;
  // final String? catId;

  ComboGroupProduct({
    this.id = "",
    required this.productId,
    required this.name,
    this.qtyCltr,
    this.isActive = true,
    this.priceCltr,
    this.isReq = false,
    this.prevIsReqVal = true,
    // this.catId,
  });
}
