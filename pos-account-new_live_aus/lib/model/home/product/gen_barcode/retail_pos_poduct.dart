import 'package:pos_account/model/common/message.dart';

class RetailPosProduct {
  List<RetailPosProductData>? data;
  List<Message>? message;
  int? total;
  bool? isError;
  int? status;

  RetailPosProduct({
    this.data,
    this.message,
    this.total,
    this.isError,
    this.status,
  });

  factory RetailPosProduct.fromJson(Map<String, dynamic> json) =>
      RetailPosProduct(
        data: json["data"] == null
            ? []
            : List<RetailPosProductData>.from(
                json["data"]!.map((x) => RetailPosProductData.fromJson(x))),
        message: json["message"] == null
            ? []
            : List<Message>.from(
                json["message"]!.map((x) => Message.fromJson(x))),
        total: json["total"],
        isError: json["isError"],
        status: json["status"],
      );

  Map<String, dynamic> toJson() => {
        "data": data == null
            ? []
            : List<dynamic>.from(data!.map((x) => x.toJson())),
        "message":
            message == null ? [] : List<dynamic>.from(message!.map((x) => x)),
        "total": total,
        "isError": isError,
        "status": status,
      };
}

class RetailPosProductData {
  String? id;
  String? productId;
  String? productImage;
  String? productName;
  String? productVariationName;
  String? retailProductName;
  String? salesTaxValue;
  // String? categoryTypeId;
  String? barCodeNumber;
  String? barCodeImage;
  String? code;
  String? category;
  String? brand;
  String? actualPrice;
  dynamic price;
  String? discount;
  String? stockCount;
  String? productType;

  RetailPosProductData({
    this.id,
    this.productId,
    this.productImage,
    this.productName,
    this.productVariationName,
    this.retailProductName,
    this.salesTaxValue,
    // this.categoryTypeId,
    this.barCodeNumber,
    this.barCodeImage,
    this.code,
    this.category,
    this.brand,
    this.actualPrice,
    this.price,
    this.discount,
    this.stockCount,
    this.productType,
  });

  factory RetailPosProductData.fromJson(Map<String, dynamic> json) =>
      RetailPosProductData(
        id: json["id"],
        productId: json["productId"],
        productImage: json["productImage"],
        productName: json["productName"] ?? json["name"],
        productVariationName: json["productVariationName"],
        retailProductName: json["retailProductName"],
        salesTaxValue: json["salesTaxValue"],
        // categoryTypeId: json["categoryTypeId"],
        barCodeNumber: json["barCodeNumber"] ?? json["barcodeNumber"],
        barCodeImage: json["barCodeImage"],
        code: json["code"],
        category: json["category"],
        brand: json["brand"],
        actualPrice: json["actualPrice"],
        price: json["price"],
        discount: json["discount"],
        stockCount: json["stockCount"],
        productType: json["productType"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "productId": productId,
        "productImage": productImage,
        "productName": productName,
        "name": productName,
        "productVariationName": productVariationName,
        "retailProductName": retailProductName,
        "salesTaxValue": salesTaxValue,
        // "categoryTypeId": categoryTypeId,
        "barCodeNumber": barCodeNumber,
        "barcodeNumber": barCodeNumber,
        "barCodeImage": barCodeImage,
        "code": code,
        "category": category,
        "brand": brand,
        "actualPrice": actualPrice,
        "price": price,
        "discount": discount,
        "stockCount": stockCount,
        "productType": productType,
      };
}
