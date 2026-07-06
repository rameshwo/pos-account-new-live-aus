import 'package:pos_account/model/common/table_location.dart';

class EftPosAddSec {
  List<EftPosMerchantWithPayment>?
      eftPosMerchantWithPaymentProviderListViewModels;

  EftPosAddSec({
    this.eftPosMerchantWithPaymentProviderListViewModels,
  });

  factory EftPosAddSec.fromJson(Map<String, dynamic> json) => EftPosAddSec(
        eftPosMerchantWithPaymentProviderListViewModels:
            json["eftPosMerchantWithPaymentProviderListViewModels"] == null
                ? []
                : List<EftPosMerchantWithPayment>.from(
                    json["eftPosMerchantWithPaymentProviderListViewModels"]!
                        .map((x) => EftPosMerchantWithPayment.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "eftPosMerchantWithPaymentProviderListViewModels":
            eftPosMerchantWithPaymentProviderListViewModels == null
                ? []
                : List<dynamic>.from(
                    eftPosMerchantWithPaymentProviderListViewModels!
                        .map((x) => x.toJson())),
      };
}

class EftPosMerchantWithPayment {
  String? id;
  String? value;
  String? name;
  List<TableLocation>? eFtPosPaymentProviders;

  EftPosMerchantWithPayment({
    this.id,
    this.value,
    this.name,
    this.eFtPosPaymentProviders,
  });

  factory EftPosMerchantWithPayment.fromJson(Map<String, dynamic> json) =>
      EftPosMerchantWithPayment(
        id: json["id"],
        value: json["value"],
        name: json["name"],
        eFtPosPaymentProviders: json["eFtPosPaymentProviders"] == null
            ? []
            : List<TableLocation>.from(json["eFtPosPaymentProviders"]!
                .map((x) => TableLocation.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "value": value,
        "name": name,
        "eFtPosPaymentProviders": eFtPosPaymentProviders == null
            ? []
            : List<dynamic>.from(
                eFtPosPaymentProviders!.map((x) => x.toJson())),
      };
}
