import '../home/menu/place_order/po_pay_sec_list_res.dart';

class KeyPadAddSectionListModel {
  List<OrderTypes>? orderTypes;
  List<PaymentMethods>? paymentMethods;
  String? taxInclusiveExclusiveType;
  List<EftposMerchantList>? eftposMerchantList;

  KeyPadAddSectionListModel(
      {this.orderTypes,
      this.paymentMethods,
      this.taxInclusiveExclusiveType,
      this.eftposMerchantList});

  KeyPadAddSectionListModel.fromJson(Map<String, dynamic> json) {
    if (json['orderTypes'] != null) {
      orderTypes = <OrderTypes>[];
      json['orderTypes'].forEach((v) {
        orderTypes!.add(OrderTypes.fromJson(v));
      });
    }
    if (json['paymentMethods'] != null) {
      paymentMethods = <PaymentMethods>[];
      json['paymentMethods'].forEach((v) {
        paymentMethods!.add(PaymentMethods.fromJson(v));
      });
    }
    taxInclusiveExclusiveType = json['taxInclusiveExclusiveType'];
    eftposMerchantList = json['eftposMerchantList'] != null
        ? (json['eftposMerchantList'] as List)
            .map((i) => EftposMerchantList.fromJson(i))
            .toList()
        : [];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (orderTypes != null) {
      data['orderTypes'] = orderTypes!.map((v) => v.toJson()).toList();
    }
    if (paymentMethods != null) {
      data['paymentMethods'] = paymentMethods!.map((v) => v.toJson()).toList();
    }
    data['taxInclusiveExclusiveType'] = taxInclusiveExclusiveType;
    if (eftposMerchantList != null) {
      data['eftposMerchantList'] =
          eftposMerchantList!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class OrderTypes {
  String? id;
  String? value;
  dynamic additionalValue;
  bool? isSelected;
  String? name;

  OrderTypes(
      {this.id, this.value, this.additionalValue, this.isSelected, this.name});

  OrderTypes.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    value = json['value'];
    additionalValue = json['additionalValue'];
    isSelected = json['isSelected'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['value'] = value;
    data['additionalValue'] = additionalValue;
    data['isSelected'] = isSelected;
    data['name'] = name;
    return data;
  }
}

class PaymentMethods {
  String? id;
  dynamic value;
  dynamic additionalValue;
  bool? isSelected;
  String? name;

  PaymentMethods(
      {this.id, this.value, this.additionalValue, this.isSelected, this.name});

  PaymentMethods.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    value = json['value'];
    additionalValue = json['additionalValue'];
    isSelected = json['isSelected'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['value'] = value;
    data['additionalValue'] = additionalValue;
    data['isSelected'] = isSelected;
    data['name'] = name;
    return data;
  }
}
