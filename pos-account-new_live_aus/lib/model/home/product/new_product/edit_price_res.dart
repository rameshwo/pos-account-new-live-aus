import 'package:flutter/material.dart';

class EditPriceRes {
  EditPriceRes({
    this.channelStoreId,
    this.channelName,
    this.productVariationsPriceViewModel,
  });

  String? channelStoreId;
  String? channelName;
  List<ProductVariationsPriceViewModel>? productVariationsPriceViewModel;

  factory EditPriceRes.fromJson(Map<String, dynamic> json) => EditPriceRes(
        channelStoreId: json["channelId"],
        channelName: json["channelName"],
        productVariationsPriceViewModel:
            json["productVariationsPriceViewModel"] == null
                ? null
                : List<ProductVariationsPriceViewModel>.from(
                    json["productVariationsPriceViewModel"].map(
                        (x) => ProductVariationsPriceViewModel.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "ChannelId": channelStoreId,
        "ChannelName": channelName,
        "ProductVariationsPriceViewModel":
            productVariationsPriceViewModel == null
                ? null
                : List<dynamic>.from(
                    productVariationsPriceViewModel!.map((x) => x.toJson())),
      };
}

class ProductVariationsPriceViewModel {
  ProductVariationsPriceViewModel({
    this.id,
    this.price,
    this.name,
    this.isActive,
    // this.variablePriceMode,
    this.discountPercentage,
    this.discountPrice,
    this.discountedPrice,
    //
    this.priceCltr,
  });

  String? id;
  String? price;
  String? name;
  bool? isActive;
  // bool? variablePriceMode;
  String? discountPercentage;
  String? discountPrice;
  String? discountedPrice;
  //
  TextEditingController? priceCltr;
  TextEditingController? disPriceCltr;
  TextEditingController? disPercentCltr;
  TextEditingController? newPriceCltr;

  factory ProductVariationsPriceViewModel.fromJson(Map<String, dynamic> json) =>
      ProductVariationsPriceViewModel(
        id: json["id"],
        price: json["price"],
        name: json["name"],
        isActive: json["isActive"],
        discountPercentage: json["discountPercentage"],
        discountPrice: json["discountPrice"],
        discountedPrice: json["discountedPrice"],
        // variablePriceMode: json["variablePriceMode"],
      );

  Map<String, dynamic> toJson() => {
        "Id": id,
        "Price": price,
        "Name": name,
        "IsActive": isActive,
        "DiscountPercentage": discountPercentage,
        "DiscountPrice": discountPrice,
        "DiscountedPrice": discountedPrice,
        // "VariablePriceMode": variablePriceMode,
      };
}
