import 'package:pos_account/model/common/message.dart';

class AllCustomer {
  AllCustomer({
    this.data,
    this.message,
    this.total,
    this.status,
  });

  List<CusData>? data;
  List<Message>? message;
  int? total;
  int? status;

  factory AllCustomer.fromJson(Map<String, dynamic> json) => AllCustomer(
        data: json["data"] == null
            ? null
            : List<CusData>.from(json["data"].map((x) => CusData.fromJson(x))),
        message: json["message"] == null
            ? null
            : List<Message>.from(
                json["message"].map((x) => Message.fromJson(x))),
        total: json["total"],
        status: json["status"],
      );

  Map<String, dynamic> toJson() => {
        "data": data == null
            ? null
            : List<dynamic>.from(data!.map((x) => x.toJson())),
        "message": message == null
            ? null
            : List<dynamic>.from(message!.map((x) => x.toJson())),
        "total": total,
        "status": status,
      };
}

class CusData {
  CusData({
    this.id,
    this.name,
    this.email,
    this.phoneNumber,
    this.postalCode,
    this.countryPhoneNumberPrefixId,
    this.countryId,
    this.isLoyaltyEnabled,
    this.isMarketingPromotionEnabled,
    this.voucherGroup,
    this.customerType,
    this.customerTypeId,
    this.total,
    this.customerGroupId,
    this.hasUserCreatedAccount,
  });

  String? id;
  String? name;
  String? email;
  String? phoneNumber;
  String? postalCode;
  String? countryPhoneNumberPrefixId;
  String? countryId;
  bool? isLoyaltyEnabled;
  bool? isMarketingPromotionEnabled;
  String? voucherGroup;
  String? customerType;
  String? customerTypeId;
  int? total;
  String? customerGroupId;
  bool? hasUserCreatedAccount;

  factory CusData.fromJson(Map<String, dynamic> json) => CusData(
        id: json["id"],
        name: json["name"],
        email: json["email"],
        phoneNumber: json["phoneNumber"],
        postalCode: json["postalCode"],
        countryPhoneNumberPrefixId: json["countryPhoneNumberPrefixId"],
        countryId: json["countryId"],
        isLoyaltyEnabled: json["isLoyaltyEnabled"],
        isMarketingPromotionEnabled: json["isMarketingPromotionEnabled"],
        voucherGroup: json["voucherGroup"],
        customerType: json["customerType"],
        customerTypeId: json["customerTypeId"],
        total: json["total"],
        customerGroupId: json["customerGroupId"],
        hasUserCreatedAccount: json["hasUserCreatedAccount"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "email": email,
        "phoneNumber": phoneNumber,
        "postalCode": postalCode,
        "countryPhoneNumberPrefixId": countryPhoneNumberPrefixId,
        "countryId": countryId,
        "isLoyaltyEnabled": isLoyaltyEnabled,
        "isMarketingPromotionEnabled": isMarketingPromotionEnabled,
        "voucherGroup": voucherGroup,
        "customerType": customerType,
        "customerTypeId": customerTypeId,
        "total": total,
        "customerGroupId": customerGroupId,
        // "hasUserCreatedAccount": hasUserCreatedAccount,
      };
}
