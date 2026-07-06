class StoreInformation {
  bool? isFiFo;
  bool? isBatch;
  bool? enableOutOfStockSales;
  bool? isSendToKitchenPrinter;
  bool? isSendToKitchenDisplay;
  bool? enableDocketGroupSplitPrint;
  String? productDetailScreen;
  bool? enablePayWithPairing;
  bool? autoSendToKitchenOnlineOrder;
  ServiceCharge? serviceCharge;
  CreditCardSurCharge? creditCardSurCharge;
  HolidaySurcharge? holidaySurcharge;
  String? id;
  String? name;
  String? email;
  String? currencySymbol;
  String? dateFormat;
  String? noProductImageUrl;
  String? address;
  String? latitude;
  String? longitude;
  String? phoneNumber;
  String? taxPercentage;
  String? taxExclusiveInclusiveType;

  StoreInformation({
    this.isFiFo,
    this.isBatch,
    this.enableOutOfStockSales,
    this.isSendToKitchenPrinter,
    this.isSendToKitchenDisplay,
    this.enableDocketGroupSplitPrint,
    this.productDetailScreen,
    this.enablePayWithPairing,
    this.autoSendToKitchenOnlineOrder,
    this.serviceCharge,
    this.creditCardSurCharge,
    this.holidaySurcharge,
    this.id,
    this.name,
    this.email,
    this.currencySymbol,
    this.dateFormat,
    this.noProductImageUrl,
    this.address,
    this.latitude,
    this.longitude,
    this.phoneNumber,
    this.taxPercentage,
    this.taxExclusiveInclusiveType,
  });

  factory StoreInformation.fromJson(Map<String, dynamic> json) =>
      StoreInformation(
        isFiFo: json["isFiFo"],
        isBatch: json["isBatch"],
        enableOutOfStockSales: json["enableOutOfStockSales"],
        isSendToKitchenPrinter: json["isSendToKitchenPrinter"],
        isSendToKitchenDisplay: json["isSendToKitchenDisplay"],
        enableDocketGroupSplitPrint: json["enableDocketGroupSplitPrint"],
        productDetailScreen: json["productDetailScreen"],
        enablePayWithPairing: json["enablePayWithPairing"],
        autoSendToKitchenOnlineOrder: json["autoSendToKitchenOnlineOrder"],
        serviceCharge: json["serviceCharge"] == null
            ? null
            : ServiceCharge.fromJson(json["serviceCharge"]),
        creditCardSurCharge: json["creditCardSurCharge"] == null
            ? null
            : CreditCardSurCharge.fromJson(json["creditCardSurCharge"]),
        holidaySurcharge: json["holidaySurcharge"] == null
            ? null
            : HolidaySurcharge.fromJson(json["holidaySurcharge"]),
        id: json["id"],
        name: json["name"],
        email: json["email"],
        currencySymbol: json["currencySymbol"],
        dateFormat: json["dateFormat"],
        noProductImageUrl: json["noProductImageUrl"],
        address: json["address"],
        latitude: json["latitude"],
        longitude: json["longitude"],
        phoneNumber: json["phoneNumber"],
        taxPercentage: json["taxPercentage"],
        taxExclusiveInclusiveType: json["taxExclusiveInclusiveType"],
      );

  Map<String, dynamic> toJson() => {
        "isFiFo": isFiFo,
        "isBatch": isBatch,
        "enableOutOfStockSales": enableOutOfStockSales,
        "isSendToKitchenPrinter": isSendToKitchenPrinter,
        "isSendToKitchenDisplay": isSendToKitchenDisplay,
        "enableDocketGroupSplitPrint": enableDocketGroupSplitPrint,
        "productDetailScreen": productDetailScreen,
        "enablePayWithPairing": enablePayWithPairing,
        "autoSendToKitchenOnlineOrder": autoSendToKitchenOnlineOrder,
        "serviceCharge": serviceCharge?.toJson(),
        "creditCardSurCharge": creditCardSurCharge?.toJson(),
        "holidaySurcharge": holidaySurcharge?.toJson(),
        "id": id,
        "name": name,
        "email": email,
        "currencySymbol": currencySymbol,
        "dateFormat": dateFormat,
        "noProductImageUrl": noProductImageUrl,
        "address": address,
        "latitude": latitude,
        "longitude": longitude,
        "phoneNumber": phoneNumber,
        "taxPercentage": taxPercentage,
        "taxExclusiveInclusiveType": taxExclusiveInclusiveType,
      };
}

class CreditCardSurCharge {
  bool? isActive;
  String? creditCardSurgePercentage;
  bool? autoEnableCreditCardSurgePercentage;

  CreditCardSurCharge({
    this.isActive,
    this.creditCardSurgePercentage,
    this.autoEnableCreditCardSurgePercentage,
  });

  factory CreditCardSurCharge.fromJson(Map<String, dynamic> json) =>
      CreditCardSurCharge(
        isActive: json["isActive"],
        creditCardSurgePercentage: json["creditCardSurgePercentage"],
        autoEnableCreditCardSurgePercentage:
            json["autoEnableCreditCardSurgePercentage"],
      );

  Map<String, dynamic> toJson() => {
        "isActive": isActive,
        "creditCardSurgePercentage": creditCardSurgePercentage,
        "autoEnableCreditCardSurgePercentage":
            autoEnableCreditCardSurgePercentage,
      };
}

class HolidaySurcharge {
  bool? isActive;
  String? holidaySurgePercentage;
  bool? autoEnableHoliaySurgePercentage;
  String? holidaySurchargeType;

  HolidaySurcharge({
    this.isActive,
    this.holidaySurgePercentage,
    this.autoEnableHoliaySurgePercentage,
    this.holidaySurchargeType,
  });

  factory HolidaySurcharge.fromJson(Map<String, dynamic> json) =>
      HolidaySurcharge(
        isActive: json["isActive"],
        holidaySurgePercentage: json["holidaySurgePercentage"],
        autoEnableHoliaySurgePercentage:
            json["autoEnableHoliaySurgePercentage"],
        holidaySurchargeType: json["holidaySurchargeType"],
      );

  Map<String, dynamic> toJson() => {
        "isActive": isActive,
        "holidaySurgePercentage": holidaySurgePercentage,
        "autoEnableHoliaySurgePercentage": autoEnableHoliaySurgePercentage,
        "holidaySurchargeType": holidaySurchargeType,
      };
}

class ServiceCharge {
  bool? isActive;
  String? serviceChargePercentage;
  bool? autoEnableServiceChargePercentage;

  ServiceCharge({
    this.isActive,
    this.serviceChargePercentage,
    this.autoEnableServiceChargePercentage,
  });

  factory ServiceCharge.fromJson(Map<String, dynamic> json) => ServiceCharge(
        isActive: json["isActive"],
        serviceChargePercentage: json["serviceChargePercentage"],
        autoEnableServiceChargePercentage:
            json["autoEnableServiceChargePercentage"],
      );

  Map<String, dynamic> toJson() => {
        "isActive": isActive,
        "serviceChargePercentage": serviceChargePercentage,
        "autoEnableServiceChargePercentage": autoEnableServiceChargePercentage,
      };
}
