import '../home/menu/place_order/po_make_pay_req.dart';

class KeyPadCheckOutRequestModel {
  String description = "";
  String totalAmount = "";
  String taxAmount = "";
  String totalWithoutTaxAmount = "";
  String discountAmount = "";
  String discountPercentage = "";
  String discountAmountWithTax = "";
  String publicHolidaySurchargeAmount = "";
  String publicHolidaySurchargeAmountWithTax = "";
  String creditCardSurchargeAmount = "";
  String creditCardSurchargeAmountWithTax = "";
  String creditCardSurchargePercentage = "";
  String customerName = "";
  CustomerViewModel? customerAddRequestModel;
  String orderTypeId = "";

  KeyPadCheckOutRequestModel({
    this.description = "",
    this.totalAmount = "",
    this.taxAmount = "",
    this.totalWithoutTaxAmount = "",
    this.discountAmount = "",
    this.discountPercentage = "",
    this.discountAmountWithTax = "",
    this.publicHolidaySurchargeAmount = "",
    this.publicHolidaySurchargeAmountWithTax = "",
    this.creditCardSurchargeAmount = "",
    this.creditCardSurchargeAmountWithTax = "",
    this.creditCardSurchargePercentage = "",
    this.customerName = "",
    this.customerAddRequestModel,
    this.orderTypeId = "",
  });

  //to convert json to model
  factory KeyPadCheckOutRequestModel.fromJson(Map<String, dynamic> json) {
    return KeyPadCheckOutRequestModel(
      description: json['description'] ?? "",
      totalAmount: json['totalAmount'] ?? "",
      taxAmount: json['taxAmount'] ?? "",
      totalWithoutTaxAmount: json['totalWithoutTaxAmount'] ?? "",
      discountAmount: json['discountAmount'] ?? "",
      discountPercentage: json['discountPercentage'] ?? "",
      discountAmountWithTax: json['discountAmountWithTax'] ?? "",
      publicHolidaySurchargeAmount: json['publicHolidaySurchargeAmount'] ?? "",
      publicHolidaySurchargeAmountWithTax:
          json['publicHolidaySurchargeAmountWithTax'] ?? "",
      creditCardSurchargeAmount: json['creditCardSurchargeAmount'] ?? "",
      creditCardSurchargeAmountWithTax:
          json['creditCardSurchargeAmountWithTax'] ?? "",
      creditCardSurchargePercentage:
          json['creditCardSurchargePercentage'] ?? "",
      customerName: json['customerName'] ?? "",
      customerAddRequestModel: json['customerAddRequestModel'] != null
          ? CustomerViewModel.fromJson(json['customerAddRequestModel'])
          : null,
      orderTypeId: json['orderTypeId'] ?? "",
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['description'] = description;
    data['totalAmount'] = totalAmount;
    data['taxAmount'] = taxAmount;
    data['totalWithoutTaxAmount'] = totalWithoutTaxAmount;
    data['discountAmount'] = discountAmount;
    data['discountPercentage'] = discountPercentage;
    data['discountAmountWithTax'] = discountAmountWithTax;
    data['publicHolidaySurchargeAmount'] = publicHolidaySurchargeAmount;
    data['publicHolidaySurchargeAmountWithTax'] =
        publicHolidaySurchargeAmountWithTax;
    data['creditCardSurchargeAmount'] = creditCardSurchargeAmount;
    data['creditCardSurchargeAmountWithTax'] = creditCardSurchargeAmountWithTax;
    data['creditCardSurchargePercentage'] = creditCardSurchargePercentage;
    data['customerName'] = customerName;
    data['customerAddRequestModel'] = customerAddRequestModel;
    data['orderTypeId'] = orderTypeId;
    return data;
  }
}
