class StoreOtherSettingModel {
  String? id;
  bool? enableUnderMaintenance;
  bool? enableReserveTable;
  bool? enableGuestCheckout;
  bool? enableOrderGiftReceiverForm;
  bool? enableCopyRightFooter;
  String? copyRightFooterDescription;
  bool? enableFooter;
  bool? enablePaymentOnPickUp;
  bool? enablePaymentOnDelivery;
  bool? enablePaymentOnQrOrder;
  // bool? enableSelectTableOnQrOrder;
  bool? enableAutoSendToKitchenOnlineOrder;
  bool? enablePayWithPairing;
  // bool? enableUberDelivery;
  bool? enablePhoneNumberVerification;
  bool? enableGoogleLogin;
  bool? kioskEnablePayAtCounter;
  int? pickUpDeliveryTimeInterval;
  String? productDetailScreen;
  bool? enableDocketGroupSplitPrint;

  StoreOtherSettingModel({
    this.id,
    this.enableUnderMaintenance,
    this.enableReserveTable,
    this.enableGuestCheckout,
    this.enableOrderGiftReceiverForm,
    this.enableCopyRightFooter,
    this.copyRightFooterDescription,
    this.enableFooter,
    this.enablePaymentOnPickUp,
    this.enablePaymentOnDelivery,
    this.enablePaymentOnQrOrder,
    // this.enableSelectTableOnQrOrder,
    this.enableAutoSendToKitchenOnlineOrder,
    this.enablePayWithPairing,
    // this.enableUberDelivery,
    this.enablePhoneNumberVerification,
    this.enableGoogleLogin,
    this.kioskEnablePayAtCounter,
    this.pickUpDeliveryTimeInterval,
    this.productDetailScreen,
    this.enableDocketGroupSplitPrint,
  });

  factory StoreOtherSettingModel.fromJson(Map<String, dynamic> json) =>
      StoreOtherSettingModel(
        id: json["id"],
        enableUnderMaintenance: json["enableUnderMaintenance"],
        enableReserveTable: json["enableReserveTable"],
        enableGuestCheckout: json["enableGuestCheckout"],
        enableOrderGiftReceiverForm: json["enableOrderGiftReceiverForm"],
        enableCopyRightFooter: json["enableCopyRightFooter"],
        copyRightFooterDescription: json["copyRightFooterDescription"],
        enableFooter: json["enableFooter"],
        enablePaymentOnPickUp: json["enablePaymentOnPickUp"],
        enablePaymentOnDelivery: json["enablePaymentOnDelivery"],
        enablePaymentOnQrOrder: json["enablePaymentOnQROrder"],
        // enableSelectTableOnQrOrder: json["enableSelectTableOnQROrder"],
        enableAutoSendToKitchenOnlineOrder:
            json["enableAutoSendToKitchenOnlineOrder"],
        enablePayWithPairing: json["enablePayWithPairing"],
        // enableUberDelivery: json["enableUberDelivery"],
        enablePhoneNumberVerification: json["enablePhoneNumberVerification"],
        enableGoogleLogin: json["enableGoogleLogin"],
        kioskEnablePayAtCounter: json["kioskEnablePayAtCounter"],
        pickUpDeliveryTimeInterval: json["pickUpDeliveryTimeInterval"],
        productDetailScreen: json["productDetailScreen"],
        enableDocketGroupSplitPrint: json["enableDocketGroupSplitPrint"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "enableUnderMaintenance": enableUnderMaintenance,
        "enableReserveTable": enableReserveTable,
        "enableGuestCheckout": enableGuestCheckout,
        "enableOrderGiftReceiverForm": enableOrderGiftReceiverForm,
        "enableCopyRightFooter": enableCopyRightFooter,
        "copyRightFooterDescription": copyRightFooterDescription,
        "enableFooter": enableFooter,
        "enablePaymentOnPickUp": enablePaymentOnPickUp,
        "enablePaymentOnDelivery": enablePaymentOnDelivery,
        "enablePaymentOnQROrder": enablePaymentOnQrOrder,
        // "enableSelectTableOnQROrder": enableSelectTableOnQrOrder,
        "enableAutoSendToKitchenOnlineOrder":
            enableAutoSendToKitchenOnlineOrder,
        "enablePayWithPairing": enablePayWithPairing,
        // "enableUberDelivery": enableUberDelivery,
        "enablePhoneNumberVerification": enablePhoneNumberVerification,
        "enableGoogleLogin": enableGoogleLogin,
        "kioskEnablePayAtCounter": kioskEnablePayAtCounter,
        "pickUpDeliveryTimeInterval": pickUpDeliveryTimeInterval,
        "productDetailScreen": productDetailScreen,
        "enableDocketGroupSplitPrint": enableDocketGroupSplitPrint,
      };
}
