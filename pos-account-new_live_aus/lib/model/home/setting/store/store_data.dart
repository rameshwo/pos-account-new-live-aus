import 'package:flutter/material.dart';

class StoreData {
  StoreData({
    this.id,
    this.name,
    this.email,
    this.url,
    this.languageId,
    this.holidaySurgePercentage,
    this.phoneNumber,
    this.address,
    this.businessTypeCategoryId,
    this.businessTypeId,
    this.storeTypeId,
    this.cityId,
    this.stateId,
    this.suburbId,
    this.taxExclusiveInclusiveTypeId,
    this.countryId,
    this.templateId,
    this.franchiseId,
    this.timeZoneId,
    this.dateFormatId,
    this.latitude,
    this.longitude,
    this.abnNumber,
    this.channel,
    this.websiteUrl,
    this.qrUrl,
    this.currencySymbol,
    this.imagePath,
    // this.loyaltySettingsAddViewModels,
    this.loyaltyClaimsSettingsAddViewModel,
    this.deliveryDistanceCostSettingsAddViewModels,
    this.loyaltySettingsDeletedIds,
    this.deliveryDistanceCostSettingsDeletedIds,
    this.pickUpHoursSettingsAddViewModels,
    this.deliveryHoursSettingsAddViewModels,
    this.description,
    this.isImageDeleted,
    this.countryPhoneNumberPrefixId,
    this.creditCardSurgePercentage,
    // this.isRetailScreen,
    this.promotionalOfferDiscountPercentage,
    this.promotionalOfferDiscountAmountThreshold,
    this.promotionalImageFileName,
    this.promotionalImageBase64,
    this.templateCategoryId,
    this.otherInformationViewModels,
    this.publicHolidayViewModels,
    this.autoEnableHoliaySurchargePercentage,
    this.autoEnableCreditCardSurgePercentage,
    this.weekendSurgePercentage,
    this.autoEnableWeekendSurgePercentage,
    this.publicHolidaysDeletedIds,
    this.weekendSurchageDeletedIds,
    this.loyaltySettingsViewModel,
    this.pickUpHoursDeletedIds,
    this.deliveryHoursDeletedIds,
    this.weekendSurchageViewModels,
    this.shippingMethodViewModels,
    this.channelCreditCardSurchargePercentageViewModels,
    this.taxPercentage,
  });

  String? id;
  String? name;
  String? email;
  String? url;
  String? languageId;
  String? holidaySurgePercentage;
  String? phoneNumber;
  String? address;
  String? businessTypeCategoryId;
  String? businessTypeId;
  String? storeTypeId;
  String? cityId;
  String? stateId;
  String? suburbId;
  String? taxExclusiveInclusiveTypeId;
  String? countryId;
  String? templateId;
  String? franchiseId;
  String? timeZoneId;
  String? dateFormatId;
  double? latitude;
  double? longitude;
  String? abnNumber;
  String? channel;
  String? websiteUrl;
  String? qrUrl;
  String? currencySymbol;
  String? imagePath;
  // List<LoyaltySettingsAddViewModel>? loyaltySettingsAddViewModels;
  LoyaltyClaimsSettingsAddViewModel? loyaltyClaimsSettingsAddViewModel;
  List<DeliveryDistanceCostSettingsAddViewModel>?
      deliveryDistanceCostSettingsAddViewModels;
  List<String>? loyaltySettingsDeletedIds;
  List<String>? deliveryDistanceCostSettingsDeletedIds;
  List<HoursSettingsAddViewModel>? pickUpHoursSettingsAddViewModels;
  List<HoursSettingsAddViewModel>? deliveryHoursSettingsAddViewModels;
  String? description;
  bool? isImageDeleted;
  String? countryPhoneNumberPrefixId;
  String? creditCardSurgePercentage;
  // bool? isRetailScreen;
  String? promotionalOfferDiscountPercentage;
  String? promotionalOfferDiscountAmountThreshold;
  String? promotionalImageFileName;
  String? promotionalImageBase64;
  String? templateCategoryId;
  OtherInformationViewModels? otherInformationViewModels;
  List<PublicHolidayViewModel>? publicHolidayViewModels;
  bool? autoEnableHoliaySurchargePercentage;
  bool? autoEnableCreditCardSurgePercentage;
  String? weekendSurgePercentage;
  bool? autoEnableWeekendSurgePercentage;
  List<String>? publicHolidaysDeletedIds;
  List<String>? weekendSurchageDeletedIds;
  LoyaltySettingsViewModel? loyaltySettingsViewModel;
  List<String>? pickUpHoursDeletedIds;
  List<String>? deliveryHoursDeletedIds;
  List<WeekendSurchageViewModels>? weekendSurchageViewModels;
  List<ShippingMethodViewModels>? shippingMethodViewModels;
  List<ChannelCreditCardSurchargePercentageViewModel>?
      channelCreditCardSurchargePercentageViewModels;
  String? taxPercentage;

  factory StoreData.fromJson(Map<String, dynamic> json) => StoreData(
        id: json["id"],
        name: json["name"],
        email: json["email"],
        url: json["url"],
        languageId: json["languageId"],
        holidaySurgePercentage: json["holidaySurgePercentage"],
        phoneNumber: json["phoneNumber"],
        address: json["address"],
        businessTypeCategoryId: json["businessTypeCategoryId"],
        businessTypeId: json["businessTypeId"],
        storeTypeId: json["storeTypeId"],
        cityId: json["cityId"],
        stateId: json["stateId"],
        suburbId: json["suburbId"],
        taxExclusiveInclusiveTypeId: json["taxExclusiveInclusiveTypeId"],
        countryId: json["countryId"],
        templateId: json["templateId"],
        franchiseId: json["franchiseId"],
        timeZoneId: json["timeZoneId"],
        dateFormatId: json["dateFormatId"],
        latitude:
            json["latitude"] == null ? null : double.tryParse(json["latitude"]),
        longitude: json["longitude"] == null
            ? null
            : double.tryParse(json["longitude"]),
        abnNumber: json["abnNumber"],
        channel: json["channel"],
        currencySymbol: json["currencySymbol"],
        imagePath: json["imagePath"],
        // loyaltySettingsAddViewModels:
        //     json["loyaltySettingsAddViewModels"] == null
        //         ? null
        //         : List<LoyaltySettingsAddViewModel>.from(
        //             json["loyaltySettingsAddViewModels"]
        //                 .map((x) => LoyaltySettingsAddViewModel.fromJson(x))),
        loyaltyClaimsSettingsAddViewModel:
            json["loyaltyClaimsSettingsAddViewModel"] == null
                ? null
                : LoyaltyClaimsSettingsAddViewModel.fromJson(
                    json["loyaltyClaimsSettingsAddViewModel"]),
        deliveryDistanceCostSettingsAddViewModels:
            json["deliveryDistancePriceAddViewModels"] == null
                ? null
                : List<DeliveryDistanceCostSettingsAddViewModel>.from(
                    json["deliveryDistancePriceAddViewModels"].map((x) =>
                        DeliveryDistanceCostSettingsAddViewModel.fromJson(x))),
        loyaltySettingsDeletedIds: json["loyaltySettingsDeletedIds"] == null
            ? null
            : List<String>.from(
                json["loyaltySettingsDeletedIds"].map((x) => x)),
        deliveryDistanceCostSettingsDeletedIds:
            json["deliveryDistanceCostSettingsDeletedIds"] == null
                ? null
                : List<String>.from(
                    json["deliveryDistanceCostSettingsDeletedIds"]
                        .map((x) => x)),
        pickUpHoursSettingsAddViewModels:
            json["pickUpHoursAddViewModels"] == null
                ? null
                : List<HoursSettingsAddViewModel>.from(
                    json["pickUpHoursAddViewModels"]
                        .map((x) => HoursSettingsAddViewModel.fromJson(x))),
        deliveryHoursSettingsAddViewModels:
            json["deliveryHoursAddViewModels"] == null
                ? null
                : List<HoursSettingsAddViewModel>.from(
                    json["deliveryHoursAddViewModels"]
                        .map((x) => HoursSettingsAddViewModel.fromJson(x))),
        description: json["description"],
        websiteUrl: json["websiteUrl"],
        qrUrl: json["qrUrl"],
        isImageDeleted: json["IsImageDeleted"],
        countryPhoneNumberPrefixId: json["countryPhoneNumberPrefixId"],
        creditCardSurgePercentage: json["creditCardSurgePercentage"],
        // isRetailScreen: json["isRetailScreen"],
        promotionalOfferDiscountPercentage:
            json["promotionalOfferDiscountPercentage"],
        promotionalOfferDiscountAmountThreshold:
            json["promotionalOfferDiscountAmountThreshold"],
        promotionalImageFileName: json["promotionalImageFileName"],
        promotionalImageBase64: json["promotionalImageBase64"],
        templateCategoryId: json["templateCategoryId"],
        otherInformationViewModels: json["otherInformationViewModels"] == null
            ? null
            : OtherInformationViewModels.fromJson(
                json["otherInformationViewModels"]),
        publicHolidayViewModels: json["publicHolidayViewModels"] == null
            ? []
            : List<PublicHolidayViewModel>.from(json["publicHolidayViewModels"]!
                .map((x) => PublicHolidayViewModel.fromJson(x))),
        autoEnableHoliaySurchargePercentage:
            json["autoEnableHoliaySurchargePercentage"],
        autoEnableCreditCardSurgePercentage:
            json["autoEnableCreditCardSurgePercentage"],
        weekendSurgePercentage: json["weekendSurgePercentage"],
        autoEnableWeekendSurgePercentage:
            json["autoEnableWeekendSurgePercentage"],
        publicHolidaysDeletedIds: json["publicHolidaysDeletedIds"] == null
            ? []
            : List<String>.from(
                json["publicHolidaysDeletedIds"]!.map((x) => x)),
        loyaltySettingsViewModel: json["loyaltySettingsViewModel"] == null
            ? null
            : LoyaltySettingsViewModel.fromJson(
                json["loyaltySettingsViewModel"]),
        pickUpHoursDeletedIds: json["pickUpHoursDeletedIds"] == null
            ? []
            : List<String>.from(json["pickUpHoursDeletedIds"]!.map((x) => x)),
        deliveryHoursDeletedIds: json["deliveryHoursDeletedIds"] == null
            ? []
            : List<String>.from(json["deliveryHoursDeletedIds"]!.map((x) => x)),
        weekendSurchageViewModels: json["weekendSurchageViewModels"] == null
            ? []
            : List<WeekendSurchageViewModels>.from(
                json["weekendSurchageViewModels"]
                    .map((x) => WeekendSurchageViewModels.fromJson(x))),
        shippingMethodViewModels: json["shippingMethodViewModels"] == null
            ? []
            : List<ShippingMethodViewModels>.from(
                json["shippingMethodViewModels"]
                    .map((x) => ShippingMethodViewModels.fromJson(x))),

        weekendSurchageDeletedIds: json["weekendSurchageDeletedIds"] == null
            ? []
            : List<String>.from(
                json["weekendSurchageDeletedIds"].map((x) => x)),
        channelCreditCardSurchargePercentageViewModels:
            json["posCreditCardSurchargeAddViewModels"] == null
                ? []
                : List<ChannelCreditCardSurchargePercentageViewModel>.from(
                    json["posCreditCardSurchargeAddViewModels"]!.map((x) =>
                        ChannelCreditCardSurchargePercentageViewModel.fromJson(
                            x))),
        taxPercentage: json["taxPercentage"],
      );

  Map<String, dynamic> toJson() => {
        "Id": id,
        "Name": name,
        "Email": email,
        "Url": url,
        "LanguageId": languageId,
        "HolidaySurgePercentage": holidaySurgePercentage,
        "PhoneNumber": phoneNumber,
        "Address": address,
        "BusinessTypeCategoryId": businessTypeCategoryId,
        "BusinessTypeId": businessTypeId,
        "StoreTypeId": storeTypeId,
        "CityId": cityId,
        "StateId": stateId,
        "SuburbId": suburbId,
        "TaxExclusiveInclusiveTypeId": taxExclusiveInclusiveTypeId,
        "CountryId": countryId,
        "TemplateId": templateId,
        "FranchiseId": franchiseId,
        "TimeZoneId": timeZoneId,
        "DateFormatId": dateFormatId,
        "Latitude": latitude,
        "Longitude": longitude,
        "ABNNumber": abnNumber,
        // "LoyaltySettingsAddViewModels": loyaltySettingsAddViewModels == null
        //     ? null
        //     : List<dynamic>.from(
        //         loyaltySettingsAddViewModels!.map((x) => x.toJson())),
        "LoyaltyClaimsSettingsAddViewModel":
            loyaltyClaimsSettingsAddViewModel?.toJson(),
        "deliveryDistancePriceAddViewModels":
            deliveryDistanceCostSettingsAddViewModels == null
                ? null
                : List<dynamic>.from(deliveryDistanceCostSettingsAddViewModels!
                    .map((x) => x.toJson())),
        "LoyaltySettingsDeletedIds": loyaltySettingsDeletedIds == null
            ? []
            : List<dynamic>.from(loyaltySettingsDeletedIds!.map((x) => x)),
        "DeliveryDistanceCostSettingsDeletedIds":
            deliveryDistanceCostSettingsDeletedIds == null
                ? []
                : List<dynamic>.from(
                    deliveryDistanceCostSettingsDeletedIds!.map((x) => x)),
        "pickUpHoursAddViewModels": pickUpHoursSettingsAddViewModels == null
            ? null
            : List<dynamic>.from(
                pickUpHoursSettingsAddViewModels!.map((x) => x.toJson())),
        "deliveryHoursAddViewModels": deliveryHoursSettingsAddViewModels == null
            ? null
            : List<dynamic>.from(
                deliveryHoursSettingsAddViewModels!.map((x) => x.toJson())),
        "Description": description,
        "WebsiteUrl": websiteUrl,
        "qrUrl": qrUrl,
        "IsImageDeleted": isImageDeleted,
        "CountryPhoneNumberPrefixId": countryPhoneNumberPrefixId,
        "CreditCardSurgePercentage": creditCardSurgePercentage,
        // "IsRetailScreen": isRetailScreen,
        "PromotionalOfferDiscountPercentage":
            promotionalOfferDiscountPercentage,
        "PromotionalOfferDiscountAmountThreshold":
            promotionalOfferDiscountAmountThreshold,
        "PromotionalImageFileName": promotionalImageFileName,
        "PromotionalImageBase64": promotionalImageBase64,
        "TemplateCategoryId": templateCategoryId,
        "OtherInformationViewModels": otherInformationViewModels?.toJson(),
        "PublicHolidayViewModels": publicHolidayViewModels == null
            ? []
            : List<dynamic>.from(
                publicHolidayViewModels!.map((x) => x.toJson())),
        "AutoEnableHoliaySurchargePercentage":
            autoEnableHoliaySurchargePercentage,
        "AutoEnableCreditCardSurgePercentage":
            autoEnableCreditCardSurgePercentage,
        "WeekendSurgePercentage": weekendSurgePercentage,
        "AutoEnableWeekendSurgePercentage": autoEnableWeekendSurgePercentage,
        "PublicHolidaysDeletedIds": publicHolidaysDeletedIds == null
            ? []
            : List<dynamic>.from(publicHolidaysDeletedIds!.map((x) => x)),
        "LoyaltySettingsViewModel": loyaltySettingsViewModel?.toJson(),
        "PickUpHoursDeletedIds": pickUpHoursDeletedIds == null
            ? []
            : List<dynamic>.from(pickUpHoursDeletedIds!.map((x) => x)),
        "DeliveryHoursDeletedIds": deliveryHoursDeletedIds == null
            ? []
            : List<dynamic>.from(deliveryHoursDeletedIds!.map((x) => x)),
        "WeekendSurchageViewModels": weekendSurchageViewModels == null
            ? []
            : List<dynamic>.from(
                weekendSurchageViewModels!.map((x) => x.toJson())),
        "ShippingMethodViewModels": shippingMethodViewModels == null
            ? []
            : List<dynamic>.from(
                shippingMethodViewModels!.map((x) => x.toJson())),
        "WeekendSurchageDeletedIds": weekendSurchageDeletedIds == null
            ? []
            : List<dynamic>.from(weekendSurchageDeletedIds!.map((x) => x)),
        "posCreditCardSurchargeAddViewModels":
            channelCreditCardSurchargePercentageViewModels == null
                ? []
                : List<dynamic>.from(
                    channelCreditCardSurchargePercentageViewModels!
                        .map((x) => x.toJson())),
        "taxPercentage": taxPercentage,
      };
}

class DeliveryDistanceCostSettingsAddViewModel {
  DeliveryDistanceCostSettingsAddViewModel({
    this.id = "",
    this.mileKmId,
    this.distanceFrom,
    this.distanceTo,
    this.price,
  });

  String id;
  String? mileKmId;
  String? distanceFrom;
  String? distanceTo;
  String? price;

  factory DeliveryDistanceCostSettingsAddViewModel.fromJson(
          Map<String, dynamic> json) =>
      DeliveryDistanceCostSettingsAddViewModel(
        id: json["id"],
        mileKmId: json["mileKmId"],
        distanceFrom: json["distanceFrom"],
        distanceTo: json["distanceTo"],
        price: json["price"],
      );

  Map<String, dynamic> toJson() => {
        "Id": id,
        "MileKmId": mileKmId,
        "DistanceFrom": distanceFrom,
        "DistanceTo": distanceTo,
        "Price": price,
      };
}

class HoursSettingsAddViewModel {
  HoursSettingsAddViewModel({
    this.id = "",
    this.weekDayId,
    this.weekDayName,
    this.openHour,
    this.closeHour,
    this.isOpened,
  });

  String id;
  String? weekDayId;
  String? weekDayName;
  String? openHour;
  String? closeHour;
  bool? isOpened;

  factory HoursSettingsAddViewModel.fromJson(Map<String, dynamic> json) =>
      HoursSettingsAddViewModel(
        id: json["id"],
        weekDayId: json["weekDayId"],
        weekDayName: json["weekDayName"],
        openHour: json["openHour"],
        closeHour: json["closeHour"],
        isOpened: json["isOpened"],
      );

  Map<String, dynamic> toJson() => {
        "Id": id,
        "WeekDayId": weekDayId,
        "WeekDayName": weekDayName,
        "OpenHour": openHour,
        "CloseHour": closeHour,
        "IsOpened": isOpened,
      };
}

class LoyaltyClaimsSettingsAddViewModel {
  LoyaltyClaimsSettingsAddViewModel({
    this.id = "",
    this.maxClaimPoint,
    this.maxClaimAmount,
    this.enableAmountToUnitPoint,
  });

  String id;
  String? maxClaimPoint;
  String? maxClaimAmount;
  bool? enableAmountToUnitPoint;

  factory LoyaltyClaimsSettingsAddViewModel.fromJson(
          Map<String, dynamic> json) =>
      LoyaltyClaimsSettingsAddViewModel(
        id: json["id"],
        maxClaimPoint: json["maxClaimPoint"],
        maxClaimAmount: json["maxClaimAmount"],
        enableAmountToUnitPoint: json["enableAmountToUnitPoint"],
      );

  Map<String, dynamic> toJson() => {
        "Id": id,
        "MaxClaimPoint": maxClaimPoint,
        "MaxClaimAmount": maxClaimAmount,
        "EnableAmountToUnitPoint": enableAmountToUnitPoint,
      };
}

class LoyaltySettingsAddViewModel {
  LoyaltySettingsAddViewModel({
    this.id = "",
    this.amountFrom,
    this.amountTo,
    this.points,
  });

  String id;
  String? amountFrom;
  String? amountTo;
  String? points;

  factory LoyaltySettingsAddViewModel.fromJson(Map<String, dynamic> json) =>
      LoyaltySettingsAddViewModel(
        id: json["id"],
        amountFrom: json["amountFrom"],
        amountTo: json["amountTo"],
        points: json["points"],
      );

  Map<String, dynamic> toJson() => {
        "Id": id,
        "AmountFrom": amountFrom,
        "AmountTo": amountTo,
        "Points": points,
      };
}

class OtherInformationViewModels {
  bool? enableUnderMaintenance;
  String? tableQrOrderChannel;
  String? updateOrderChannel;
  // bool? enablePosRetailScreen;
  bool? enableReserveTable;
  bool? enableGuestCheckout;
  bool? enableOrderGiftReceiverForm;
  bool? enableCopyRightFooter;
  // bool? orderPrintAutomatically;
  // bool? printBillAutomatically;
  bool? enableFooter;
  bool? enablePaymentOnPickUp;
  bool? enablePaymentOnDineIn;
  bool? enablePaymentOnDelivery;
  // bool? enableStripeLivePaymentMode;
  String? copyRightFooterDescription;
  bool? enableAutoSendToKitchenOnlineOrder;
  bool? enablePayWithPairing;
  bool? enableAutoSendToKitchenDisplayOnlineOrder;
  bool? enableUberDelivery;
  bool? enablePaymentOnQrOrder;
  bool? kioskEnablePayAtCounter;

  OtherInformationViewModels({
    this.enableUnderMaintenance,
    this.tableQrOrderChannel,
    this.updateOrderChannel,
    // this.enablePosRetailScreen,
    this.enableReserveTable,
    this.enableGuestCheckout,
    this.enableOrderGiftReceiverForm,
    this.enableCopyRightFooter,
    // this.orderPrintAutomatically,
    // this.printBillAutomatically,
    this.enableFooter,
    this.enablePaymentOnPickUp,
    this.enablePaymentOnDineIn,
    this.enablePaymentOnDelivery,
    // this.enableStripeLivePaymentMode,
    this.copyRightFooterDescription,
    this.enableAutoSendToKitchenOnlineOrder,
    this.enablePayWithPairing,
    this.enableAutoSendToKitchenDisplayOnlineOrder,
    this.enableUberDelivery,
    this.enablePaymentOnQrOrder,
    this.kioskEnablePayAtCounter,
  });

  factory OtherInformationViewModels.fromJson(Map<String, dynamic> json) =>
      OtherInformationViewModels(
        enableUnderMaintenance: json["enableUnderMaintenance"],
        tableQrOrderChannel: json["tableQROrderChannel"],
        updateOrderChannel: json["updateOrderChannel"],
        // enablePosRetailScreen: json["enablePOSRetailScreen"],
        enableReserveTable: json["enableReserveTable"],
        enableGuestCheckout: json["enableGuestCheckout"],
        enableOrderGiftReceiverForm: json["enableOrderGiftReceiverForm"],
        enableCopyRightFooter: json["enableCopyRightFooter"],
        // orderPrintAutomatically: json["orderPrintAutomatically"],
        // printBillAutomatically: json["printBillAutomatically"],
        enableFooter: json["enableFooter"],
        enablePaymentOnPickUp: json["enablePaymentOnPickUp"],
        enablePaymentOnDineIn: json["enablePaymentOnDineIn"],
        enablePaymentOnDelivery: json["enablePaymentOnDelivery"],
        // enableStripeLivePaymentMode: json["enableStripeLivePaymentMode"],
        copyRightFooterDescription: json["copyRightFooterDescription"],
        enableAutoSendToKitchenOnlineOrder:
            json["enableAutoSendToKitchenOnlineOrder"],
        enablePayWithPairing: json["enablePayWithPairing"],
        enableAutoSendToKitchenDisplayOnlineOrder:
            json["enableAutoSendToKitchenDisplayOnlineOrder"],
        enableUberDelivery: json["enableUberDelivery"],
        enablePaymentOnQrOrder: json["enablePaymentOnQROrder"],
        kioskEnablePayAtCounter: json["kioskEnablePayAtCounter"],
      );

  Map<String, dynamic> toJson() => {
        "EnableUnderMaintenance": enableUnderMaintenance,
        "TableQROrderChannel": tableQrOrderChannel,
        "UpdateOrderChannel": updateOrderChannel,
        // "EnablePOSRetailScreen": enablePosRetailScreen,
        "EnableReserveTable": enableReserveTable,
        "EnableGuestCheckout": enableGuestCheckout,
        "EnableOrderGiftReceiverForm": enableOrderGiftReceiverForm,
        "EnableCopyRightFooter": enableCopyRightFooter,
        // "OrderPrintAutomatically": orderPrintAutomatically,
        // "PrintBillAutomatically": printBillAutomatically,
        "EnableFooter": enableFooter,
        "EnablePaymentOnPickUp": enablePaymentOnPickUp,
        "EnablePaymentOnDineIn": enablePaymentOnDineIn,
        "EnablePaymentOnDelivery": enablePaymentOnDelivery,
        // "EnableStripeLivePaymentMode": enableStripeLivePaymentMode,
        "CopyRightFooterDescription": copyRightFooterDescription,
        "EnableAutoSendToKitchenOnlineOrder":
            enableAutoSendToKitchenOnlineOrder,
        "EnablePayWithPairing": enablePayWithPairing,
        "EnableAutoSendToKitchenDisplayOnlineOrder":
            enableAutoSendToKitchenDisplayOnlineOrder,
        "EnableUberDelivery": enableUberDelivery,
        "enablePaymentOnQROrder": enablePaymentOnQrOrder,
        "kioskEnablePayAtCounter": kioskEnablePayAtCounter,
      };
}

class PublicHolidayViewModel {
  String? id;
  String? name;
  String? date;
  String? holidaySurchargePercentage;
  bool? autoEnableHolidaySurcharge;

  PublicHolidayViewModel({
    this.id,
    this.name,
    this.date,
    this.holidaySurchargePercentage,
    this.autoEnableHolidaySurcharge,
  });

  factory PublicHolidayViewModel.fromJson(Map<String, dynamic> json) =>
      PublicHolidayViewModel(
        id: json["id"],
        name: json["name"],
        date: json["date"],
        holidaySurchargePercentage: json["holidaySurchargePercentage"],
        autoEnableHolidaySurcharge: json["autoEnableHolidaySurcharge"],
      );

  Map<String, dynamic> toJson() => {
        "Id": id,
        "Name": name,
        "Date": date,
        "HolidaySurchargePercentage": holidaySurchargePercentage,
        "AutoEnableHolidaySurcharge": autoEnableHolidaySurcharge,
      };
}

class LoyaltySettingsViewModel {
  String? id;
  String? amountSpend;
  String? accuredPoints;
  bool? isActive;

  LoyaltySettingsViewModel({
    this.id,
    this.amountSpend,
    this.accuredPoints,
    this.isActive,
  });

  factory LoyaltySettingsViewModel.fromJson(Map<String, dynamic> json) =>
      LoyaltySettingsViewModel(
        id: json["id"],
        amountSpend: json["amountSpend"],
        accuredPoints: json["accuredPoints"],
        isActive: json["isActive"],
      );

  Map<String, dynamic> toJson() => {
        "Id": id,
        "AmountSpend": amountSpend,
        "AccuredPoints": accuredPoints,
        "IsActive": isActive,
      };
}

class WeekendSurchageViewModels {
  String? id;
  String? weekendSurchargePercentage;
  bool? autoEnableWeekendSurcharge;
  String? weekDayId;
  String? name;

  WeekendSurchageViewModels(
      {this.id,
      this.weekendSurchargePercentage,
      this.autoEnableWeekendSurcharge,
      this.weekDayId,
      this.name});

  WeekendSurchageViewModels.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    weekendSurchargePercentage = json['weekendSurchargePercentage'];
    autoEnableWeekendSurcharge = json['autoEnableWeekendSurcharge'];
    weekDayId = json['weekDayId'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['weekendSurchargePercentage'] = weekendSurchargePercentage;
    data['autoEnableWeekendSurcharge'] = autoEnableWeekendSurcharge;
    data['weekDayId'] = weekDayId;
    data['name'] = name;
    return data;
  }
}

class ShippingMethodViewModels {
  String? id;
  String? name;
  String? notes;
  String? price;
  bool? isActive;

  ShippingMethodViewModels(
      {this.id, this.name, this.notes, this.price, this.isActive});

  ShippingMethodViewModels.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    notes = json['notes'];
    price = json['price'];
    isActive = json['isActive'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['notes'] = notes;
    data['price'] = price;
    data['isActive'] = isActive;
    return data;
  }
}

class ChannelCreditCardSurchargePercentageViewModel {
  String id;
  String? channelId;
  TextEditingController creditCardSurchargePercentage;
  bool autoEnableCreditSurchargePercentage;
  bool isActive;
  //
  String? channelName;

  ChannelCreditCardSurchargePercentageViewModel({
    this.id = "",
    this.channelId,
    required this.creditCardSurchargePercentage,
    this.autoEnableCreditSurchargePercentage = false,
    this.isActive = false,
    //
    this.channelName,
  });

  factory ChannelCreditCardSurchargePercentageViewModel.fromJson(
          Map<String, dynamic> json) =>
      ChannelCreditCardSurchargePercentageViewModel(
        id: json["id"] ?? '',
        channelId: json["channelId"],
        creditCardSurchargePercentage: TextEditingController(
            text: json["creditCardSurchargePercentage"]?.toString() ?? ''),
        autoEnableCreditSurchargePercentage:
            json["autoEnableCreditSurchargePercentage"] ?? false,
        isActive: json["isActive"] ?? false,
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "channelId": channelId,
        "creditCardSurchargePercentage": creditCardSurchargePercentage.text,
        "autoEnableCreditSurchargePercentage":
            autoEnableCreditSurchargePercentage,
        "isActive": isActive,
      };
}
