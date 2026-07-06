import 'get_all_pay_method.dart';

class PayMethodModel {
  PayMethodModel({
    this.id,
    this.isActive,
    this.surchargePercentage,
    this.enableSurcharge,
    this.paymentCredentials,
  });

  String? id;
  bool? isActive;
  String? surchargePercentage;
  bool? enableSurcharge;
  PaymentCredentials? paymentCredentials;

  factory PayMethodModel.fromJson(Map<String, dynamic> json) => PayMethodModel(
        id: json["Id"],
        isActive: json["IsActive"],
        surchargePercentage: json["surchargePercentage"],
        enableSurcharge: json["enableSurcharge"],
        paymentCredentials: json["PaymentCredentials"] == null
            ? null
            : PaymentCredentials.fromJson(json["PaymentCredentials"]),
      );

  Map<String, dynamic> toJson() => {
        "Id": id,
        "IsActive": isActive,
        "surchargePercentage": surchargePercentage,
        "enableSurcharge": enableSurcharge,
        "PaymentCredentials": paymentCredentials?.toJson(),
      };
}
