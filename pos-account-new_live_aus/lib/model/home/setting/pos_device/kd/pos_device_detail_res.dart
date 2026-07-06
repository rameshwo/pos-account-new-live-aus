import 'package:pos_account/model/home/setting/pos_device/printer_product/printer_prod_detail_res.dart';

class PosDeviceDetailsRes {
  String? posDeviceId;
  String? posDeviceName;
  bool? sendAllProductToKitchenDisplay;
  List<ProductCategoryVariationList>? productCategoryVariationList;

  PosDeviceDetailsRes({
    this.posDeviceId,
    this.posDeviceName,
    this.sendAllProductToKitchenDisplay,
    this.productCategoryVariationList,
  });

  factory PosDeviceDetailsRes.fromJson(Map<String, dynamic> json) =>
      PosDeviceDetailsRes(
        posDeviceId: json["posDeviceId"],
        posDeviceName: json["posDeviceName"],
        sendAllProductToKitchenDisplay: json["sendAllProductToKitchenDisplay"],
        productCategoryVariationList:
            json["productCategoryVariationList"] == null
                ? []
                : List<ProductCategoryVariationList>.from(
                    json["productCategoryVariationList"]!
                        .map((x) => ProductCategoryVariationList.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "posDeviceId": posDeviceId,
        "posDeviceName": posDeviceName,
        "sendAllProductToKitchenDisplay": sendAllProductToKitchenDisplay,
        "productCategoryVariationList": productCategoryVariationList == null
            ? []
            : List<dynamic>.from(
                productCategoryVariationList!.map((x) => x.toJson())),
      };
}
