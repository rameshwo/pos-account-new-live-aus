import 'package:pos_account/model/profile/user_add_sec.dart';

class GiftCardAddSec {
  GiftCardAddSec({
    this.code,
    this.giftCardTemplatesLists,
    this.countries,
    this.paymentMethods,
  });

  String? code;
  List<GiftCardTemplatesList>? giftCardTemplatesLists;
  List<UserAddSecData>? countries;
  List<UserAddSecData>? paymentMethods;

  factory GiftCardAddSec.fromJson(Map<String, dynamic> json) => GiftCardAddSec(
        code: json["code"],
        giftCardTemplatesLists: json["giftCardTemplatesLists"] == null
            ? []
            : List<GiftCardTemplatesList>.from(json["giftCardTemplatesLists"]!
                .map((x) => GiftCardTemplatesList.fromJson(x))),
        countries: json["countries"] == null
            ? []
            : List<UserAddSecData>.from(
                json["countries"]!.map((x) => UserAddSecData.fromJson(x))),
        paymentMethods: json["paymentMethods"] == null
            ? []
            : List<UserAddSecData>.from(
                json["paymentMethods"]!.map((x) => UserAddSecData.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "code": code,
        "giftCardTemplatesLists": giftCardTemplatesLists == null
            ? []
            : List<dynamic>.from(
                giftCardTemplatesLists!.map((x) => x.toJson())),
        "countries": countries == null
            ? []
            : List<dynamic>.from(countries!.map((x) => x.toJson())),
        "paymentMethods": paymentMethods == null
            ? []
            : List<dynamic>.from(paymentMethods!.map((x) => x.toJson())),
      };
}

class GiftCardTemplatesList {
  GiftCardTemplatesList({
    this.type,
    this.giftCardTemplateImages,
  });

  String? type;
  List<UserAddSecData>? giftCardTemplateImages;

  factory GiftCardTemplatesList.fromJson(Map<String, dynamic> json) =>
      GiftCardTemplatesList(
        type: json["type"],
        giftCardTemplateImages: json["giftCardTemplateImages"] == null
            ? []
            : List<UserAddSecData>.from(json["giftCardTemplateImages"]!
                .map((x) => UserAddSecData.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "type": type,
        "giftCardTemplateImages": giftCardTemplateImages == null
            ? []
            : List<dynamic>.from(
                giftCardTemplateImages!.map((x) => x.toJson())),
      };
}
