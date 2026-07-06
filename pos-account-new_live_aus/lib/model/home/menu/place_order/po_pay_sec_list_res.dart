import 'package:pos_account/model/common/table_location.dart';
import 'package:pos_account/model/home/integration/plat_inte_conn_model.dart';
import 'package:pos_account/model/home/setting/payment_method/get_all_pay_method.dart';
import 'package:pos_account/model/profile/user_add_sec.dart';

class PoPaySecListRes {
  PoPaySecListRes({
    this.paymentMethods,
    this.availiableCurrencies,
    this.posQrImageUrl,
    // this.promotionalOfferViewModel,
    this.eftposMerchantList,
    this.discounts,
    this.isComplimentary,
    this.paymentIntegrationCredentials,
  });

  List<PaymentMethodSec>? paymentMethods;
  List<UserAddSecData>? availiableCurrencies;
  String? posQrImageUrl; // notInNew
  // PromotionalOfferViewModel? promotionalOfferViewModel; // notInNew
  List<EftposMerchant>? eftposMerchantList;
  List<TableLocation>? discounts;
  bool? isComplimentary; // notInNew
  PaymentCredentials? paymentIntegrationCredentials;

  factory PoPaySecListRes.fromJson(Map<String, dynamic> json) =>
      PoPaySecListRes(
        paymentMethods: json["paymentMethods"] == null
            ? null
            : List<PaymentMethodSec>.from(json["paymentMethods"]
                .map((x) => PaymentMethodSec.fromJson(x))),
        availiableCurrencies: json["currencies"] == null
            ? null
            : List<UserAddSecData>.from(
                json["currencies"].map((x) => UserAddSecData.fromJson(x))),
        posQrImageUrl: json["posQrImageUrl"],
        // promotionalOfferViewModel: json["promotionalOfferViewModel"] == null
        //     ? null
        //     : PromotionalOfferViewModel.fromJson(
        //         json["promotionalOfferViewModel"]),
        eftposMerchantList: json["eftPosMerchants"] == null
            ? []
            : List<EftposMerchant>.from(json["eftPosMerchants"]!
                .map((x) => EftposMerchant.fromJson(x))),
        discounts: json["discounts"] == null
            ? null
            : List<TableLocation>.from(
                json["discounts"].map((x) => TableLocation.fromJson(x))),
        paymentIntegrationCredentials:
            json["paymentIntegrationCredentials"] == null
                ? null
                : PaymentCredentials.fromJson(
                    json["paymentIntegrationCredentials"]),
      );

  Map<String, dynamic> toJson() => {
        "paymentMethods": paymentMethods == null
            ? null
            : List<dynamic>.from(paymentMethods!.map((x) => x.toJson())),
        "currencies": availiableCurrencies == null
            ? null
            : List<dynamic>.from(availiableCurrencies!.map((x) => x.toJson())),
        "posQrImageUrl": posQrImageUrl,
        // "promotionalOfferViewModel": promotionalOfferViewModel?.toJson(),
        "eftPosMerchants": eftposMerchantList == null
            ? []
            : List<dynamic>.from(eftposMerchantList!.map((x) => x.toJson())),
        "discounts": discounts == null
            ? null
            : List<dynamic>.from(discounts!.map((x) => x.toJson())),
        "paymentIntegrationCredentials":
            paymentIntegrationCredentials?.toJson(),
      };
}

// class PromotionalOfferViewModel {
//   String? promotionalOfferThresholdAmount;
//   String? promotionalOfferDiscountPercentage;
//   String? promotionalOfferMessage;

//   PromotionalOfferViewModel({
//     this.promotionalOfferThresholdAmount,
//     this.promotionalOfferDiscountPercentage,
//     this.promotionalOfferMessage,
//   });

//   factory PromotionalOfferViewModel.fromJson(Map<String, dynamic> json) =>
//       PromotionalOfferViewModel(
//         promotionalOfferThresholdAmount:
//             json["promotionalOfferThresholdAmount"],
//         promotionalOfferDiscountPercentage:
//             json["promotionalOfferDiscountPercentage"],
//         promotionalOfferMessage: json["promotionalOfferMessage"],
//       );

//   Map<String, dynamic> toJson() => {
//         "promotionalOfferThresholdAmount": promotionalOfferThresholdAmount,
//         "promotionalOfferDiscountPercentage":
//             promotionalOfferDiscountPercentage,
//         "promotionalOfferMessage": promotionalOfferMessage,
//       };
// }

class EftposMerchantList {
  String? merchantName;
  String? merchantType;
  List<IntegrationPlatformConnectionCredential>?
      eftposPaymentProviderListModels;

  EftposMerchantList({
    this.merchantName,
    this.merchantType,
    this.eftposPaymentProviderListModels,
  });

  factory EftposMerchantList.fromJson(Map<String, dynamic> json) =>
      EftposMerchantList(
        merchantName: json["merchantName"],
        merchantType: json["merchantType"],
        eftposPaymentProviderListModels:
            json["eftposPaymentProviderListModels"] == null
                ? []
                : List<IntegrationPlatformConnectionCredential>.from(
                    json["eftposPaymentProviderListModels"]!.map((x) =>
                        IntegrationPlatformConnectionCredential.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "merchantName": merchantName,
        "merchantType": merchantType,
        "eftposPaymentProviderListModels":
            eftposPaymentProviderListModels == null
                ? []
                : List<dynamic>.from(
                    eftposPaymentProviderListModels!.map((x) => x.toJson())),
      };
}

class PaymentMethodSec {
  String? defaultBackGroundColor;
  String? defaultTextColor;
  String? onFocusBackGroundColor;
  String? onFocusTextColor;
  String? id;
  String? value;
  String? additionalValue;
  bool? isSelected;
  String? name;

  PaymentMethodSec({
    this.defaultBackGroundColor,
    this.defaultTextColor,
    this.onFocusBackGroundColor,
    this.onFocusTextColor,
    this.id,
    this.value,
    this.additionalValue,
    this.isSelected,
    this.name,
  });

  factory PaymentMethodSec.fromJson(Map<String, dynamic> json) =>
      PaymentMethodSec(
        defaultBackGroundColor: json["defaultBackGroundColor"],
        defaultTextColor: json["defaultTextColor"],
        onFocusBackGroundColor: json["onFocusBackGroundColor"],
        onFocusTextColor: json["onFocusTextColor"],
        id: json["id"],
        value: json["value"],
        additionalValue: json["additionalValue"],
        isSelected: json["isSelected"],
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "defaultBackGroundColor": defaultBackGroundColor,
        "defaultTextColor": defaultTextColor,
        "onFocusBackGroundColor": onFocusBackGroundColor,
        "onFocusTextColor": onFocusTextColor,
        "id": id,
        "value": value,
        "additionalValue": additionalValue,
        "isSelected": isSelected,
        "name": name,
      };
}

class EftposMerchant {
  String? id;
  String? name;
  String? customerId;
  String? keyOrId;
  String? secret;
  String? serialNumber;
  String? posNameOrId;
  String? currency;
  String? posDeviceId;
  String? merchantName;
  String? merchantType;
  String? integrationPlatformId;
  bool isSelected;
  bool statusCheck;

  EftposMerchant({
    this.id,
    this.name,
    this.customerId,
    this.keyOrId,
    this.secret,
    this.serialNumber,
    this.posNameOrId,
    this.currency,
    this.posDeviceId,
    this.merchantName,
    this.merchantType,
    this.integrationPlatformId,
    this.isSelected = false,
    this.statusCheck = false,
  });

  factory EftposMerchant.fromJson(Map<String, dynamic> json) => EftposMerchant(
        id: json["id"],
        name: json["name"],
        customerId: json["customerId"],
        keyOrId: json["keyOrId"],
        secret: json["secret"],
        serialNumber: json["serialNumber"],
        posNameOrId: json["posNameOrId"],
        currency: json["currency"],
        // isDefault: json["isDefault"],
        posDeviceId: json["posDeviceId"],
        merchantName: json["merchantName"],
        merchantType: json["merchantType"],
        integrationPlatformId: json["integrationPlatformId"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "customerId": customerId,
        "keyOrId": keyOrId,
        "secret": secret,
        "serialNumber": serialNumber,
        "posNameOrId": posNameOrId,
        "currency": currency,
        // "isDefault": isDefault,
        "posDeviceId": posDeviceId,
        "merchantName": merchantName,
        "merchantType": merchantType,
        "integrationPlatformId": integrationPlatformId,
      };
}
