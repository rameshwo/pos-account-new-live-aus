import 'package:pos_account/model/common/filter_category.dart';
import 'package:pos_account/model/common/message.dart';
import 'package:pos_account/model/common/table_location.dart';
import 'package:pos_account/model/home/menu/place_order/pos_res/order_type_res.dart';

import '../place_order/pos_res/store_information.dart';
import '../place_order/retail_pos_res.dart';

class RetailPosOrderRes {
  RetailPosOrderRes({
    this.staffs,
    this.orderTypes,
    this.productCategories,
    // this.storeTaxSettings,
    this.products,
    this.brands,
    this.tables,
    this.message,
    this.isSubscriptionActive,
    // this.storeStockDeductInformation,
    this.alphabets,
    this.orderItemStatus,
    this.storeInformation,
  });

  List<TableLocation>? staffs;
  List<OrderTypeRes>? orderTypes;
  List<FilterCategory>? productCategories;
  // StoreTaxSettings? storeTaxSettings;
  Products? products;
  List<TableLocation>? brands;
  List<TableLocation>? tables;
  List<TableLocation>? alphabets;
  String? message;
  bool? isSubscriptionActive;
  // StoreStockDeductInformation? storeStockDeductInformation;
  List<TableLocation>? orderItemStatus;
  StoreInformation? storeInformation;

  factory RetailPosOrderRes.fromJson(Map<String, dynamic> json) =>
      RetailPosOrderRes(
        staffs: json["staffs"] == null
            ? []
            : List<TableLocation>.from(
                json["staffs"]!.map((x) => TableLocation.fromJson(x))),
        orderTypes: json["posOrderTypes"] == null
            ? []
            : List<OrderTypeRes>.from(
                json["posOrderTypes"]!.map((x) => OrderTypeRes.fromJson(x))),
        productCategories: json["productCategories"] == null
            ? []
            : List<FilterCategory>.from(json["productCategories"]!
                .map((x) => FilterCategory.fromJson(x))),
        // storeTaxSettings: json["storeTaxSettings"] == null
        //     ? null
        //     : StoreTaxSettings.fromJson(json["storeTaxSettings"]),
        products: json["products"] == null
            ? null
            : Products.fromJson(json["products"]),
        brands: json["brands"] == null
            ? []
            : List<TableLocation>.from(
                json["brands"]!.map((x) => TableLocation.fromJson(x))),
        tables: json["tables"] == null
            ? []
            : List<TableLocation>.from(
                json["tables"]!.map((x) => TableLocation.fromJson(x))),
        message: json["message"],
        isSubscriptionActive: json["isSubscriptionActive"],
        // storeStockDeductInformation: json["storeStockDeductInformation"] == null
        //     ? null
        //     : StoreStockDeductInformation.fromJson(
        //         json["storeStockDeductInformation"]),
        alphabets: json["alphabets"] == null
            ? []
            : List<TableLocation>.from(
                json["alphabets"]!.map((x) => TableLocation.fromJson(x))),
        orderItemStatus: json["orderItemStatus"] == null
            ? []
            : List<TableLocation>.from(
                json["orderItemStatus"]!.map((x) => TableLocation.fromJson(x))),
        storeInformation: json["storeInformation"] == null
            ? null
            : StoreInformation.fromJson(json["storeInformation"]),
      );

  Map<String, dynamic> toJson() => {
        "staffs": staffs == null
            ? []
            : List<dynamic>.from(staffs!.map((x) => x.toJson())),
        "posOrderTypes": orderTypes == null
            ? []
            : List<dynamic>.from(orderTypes!.map((x) => x.toJson())),
        "productCategories": productCategories == null
            ? []
            : List<dynamic>.from(productCategories!.map((x) => x.toJson())),
        // "storeTaxSettings": storeTaxSettings?.toJson(),
        "products": products?.toJson(),
        "brands": brands == null
            ? []
            : List<dynamic>.from(brands!.map((x) => x.toJson())),
        "tables": tables == null
            ? []
            : List<dynamic>.from(tables!.map((x) => x.toJson())),
        "message": message,
        "isSubscriptionActive": isSubscriptionActive,
        // "storeStockDeductInformation": storeStockDeductInformation?.toJson(),
        "alphabets": alphabets == null
            ? []
            : List<dynamic>.from(alphabets!.map((x) => x.toJson())),
        "orderItemStatus": orderItemStatus == null
            ? []
            : List<dynamic>.from(orderItemStatus!.map((x) => x.toJson())),
        "storeInformation": storeInformation?.toJson(),
      };
}

class Products {
  Products({
    this.data,
    this.message,
    this.total,
    this.status,
  });

  List<ProductData>? data;
  List<Message>? message;
  int? total;
  int? status;

  factory Products.fromJson(Map<String, dynamic> json) => Products(
        data: json["data"] == null
            ? []
            : List<ProductData>.from(
                json["data"]!.map((x) => ProductData.fromJson(x))),
        message: json["message"] == null
            ? []
            : List<Message>.from(
                json["message"]!.map((x) => Message.fromJson(x))),
        total: json["total"],
        status: json["status"],
      );

  Map<String, dynamic> toJson() => {
        "data": data == null
            ? []
            : List<dynamic>.from(data!.map((x) => x.toJson())),
        "message":
            message == null ? [] : List<dynamic>.from(message!.map((x) => x)),
        "total": total,
        "status": status,
      };
}

// class ProductData {
//   ProductData({
//     this.id,
//     this.productId,
//     this.productImage,
//     this.productName,
//     this.salesTaxValue,
//     this.categoryTypeId,
//     this.barCodeNumber,
//     this.barCodeImage,
//     this.code,
//     this.category,
//     this.brand,
//     this.actualPrice,
//     this.price,
//     this.discount,
//     this.productDetails,
//     this.stockCount,
//     this.productVariationName,
//     this.retailProductName,

//     //additional
//     this.quantity = 1,
//   });

//   String? id;
//   String? productId;
//   String? productImage;
//   String? productName;
//   String? salesTaxValue;
//   String? categoryTypeId;
//   String? barCodeNumber;
//   String? barCodeImage;
//   String? code;
//   String? category;
//   String? brand;
//   String? actualPrice;
//   String? price;
//   String? discount;
//   FeaturedProduct? productDetails;
//   String? stockCount;
//   String? productVariationName;
//   String? retailProductName;
//   //additional
//   int quantity;

//   factory ProductData.fromJson(Map<String, dynamic> json) => ProductData(
//         id: json["id"],
//         productId: json["productId"],
//         productImage: json["productImage"],
//         productName: json["productName"],
//         salesTaxValue: json["salesTaxValue"],
//         categoryTypeId: json["categoryTypeId"],
//         barCodeNumber: json["barCodeNumber"],
//         barCodeImage: json["barCodeImage"],
//         code: json["code"],
//         category: json["category"],
//         brand: json["brand"],
//         actualPrice: json["actualPrice"],
//         price: json["price"],
//         discount: json["discount"],
//         productDetails: json["productDetails"] == null
//             ? null
//             : FeaturedProduct.fromJson(json["productDetails"]),
//         stockCount: json["stockCount"],
//         productVariationName: json["productVariationName"],
//         retailProductName: json["retailProductName"],
//       );

//   Map<String, dynamic> toJson() => {
//         "id": id,
//         "productId": productId,
//         "productImage": productImage,
//         "productName": productName,
//         "salesTaxValue": salesTaxValue,
//         "categoryTypeId": categoryTypeId,
//         "barCodeNumber": barCodeNumber,
//         "barCodeImage": barCodeImage,
//         "code": code,
//         "category": category,
//         "brand": brand,
//         "actualPrice": actualPrice,
//         "price": price,
//         "discount": discount,
//         "productDetails": productDetails?.toJson(),
//         "stockCount": stockCount,
//         "productVariationName": productVariationName,
//         "retailProductName": retailProductName,
//       };
// }

class StoreTaxSettings {
  StoreTaxSettings({
    this.taxExclusiveInclusiveType,
    this.isSelected,
    this.holidaySurgePercentage,
    this.creditCardSurgePercentage,
    this.autoEnableHoliaySurgePercentage,
    this.autoEnableCreditCardSurgePercentage,
    this.holidaySurchargeType,
    this.taxPercentage,
  });

  String? taxExclusiveInclusiveType;
  bool? isSelected;
  String? holidaySurgePercentage;
  String? creditCardSurgePercentage;
  bool? autoEnableHoliaySurgePercentage;
  bool? autoEnableCreditCardSurgePercentage;
  String? holidaySurchargeType;
  String? taxPercentage;

  factory StoreTaxSettings.fromJson(Map<String, dynamic> json) =>
      StoreTaxSettings(
        taxExclusiveInclusiveType: json["taxExclusiveInclusiveType"],
        isSelected: json["isSelected"],
        holidaySurgePercentage: json["holidaySurgePercentage"],
        creditCardSurgePercentage: json["creditCardSurgePercentage"],
        autoEnableHoliaySurgePercentage:
            json["autoEnableHoliaySurgePercentage"],
        autoEnableCreditCardSurgePercentage:
            json["autoEnableCreditCardSurgePercentage"],
        holidaySurchargeType: json["holidaySurchargeType"],
        taxPercentage: json["taxPercentage"],
      );

  Map<String, dynamic> toJson() => {
        "taxExclusiveInclusiveType": taxExclusiveInclusiveType,
        "isSelected": isSelected,
        "holidaySurgePercentage": holidaySurgePercentage,
        "creditCardSurgePercentage": creditCardSurgePercentage,
        "autoEnableHoliaySurgePercentage": autoEnableHoliaySurgePercentage,
        "autoEnableCreditCardSurgePercentage":
            autoEnableCreditCardSurgePercentage,
        "holidaySurchargeType": holidaySurchargeType,
        "taxPercentage": taxPercentage,
      };
}
