import 'package:pos_account/model/common/table_id_name.dart';

class EditTableResv {
  EditTableResv({
    this.id,
    this.reservationNumber,
    this.customerViewModel,
    this.adult,
    this.child,
    this.tables,
    this.orderChannelId,
    this.dateTimeFrom,
    this.dateTimeTo,
    this.occasionId,
    this.message,
  });

  String? id;
  String? reservationNumber;
  CustomerViewModel? customerViewModel;
  String? adult;
  String? child;
  List<TableIdName>? tables;
  String? orderChannelId;
  String? dateTimeFrom;
  String? dateTimeTo;
  String? occasionId;
  String? message;

  factory EditTableResv.fromJson(Map<String, dynamic> json) => EditTableResv(
        id: json["id"],
        reservationNumber: json["reservationNumber"],
        customerViewModel: json["customerViewModel"] == null
            ? null
            : CustomerViewModel.fromJson(json["customerViewModel"]),
        adult: json["adult"],
        child: json["child"],
        tables: json["tables"] == null
            ? []
            : List<TableIdName>.from(
                json["tables"]!.map((x) => TableIdName.fromJson(x))),
        orderChannelId: json["orderChannelId"],
        dateTimeFrom: json["dateTimeFrom"],
        dateTimeTo: json["dateTimeTo"],
        occasionId: json["occasionId"],
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "reservationNumber": reservationNumber,
        "customerViewModel": customerViewModel?.toJson(),
        "adult": adult,
        "child": child,
        "tables": tables == null
            ? []
            : List<dynamic>.from(tables!.map((x) => x.toJson())),
        "orderChannelId": orderChannelId,
        "dateTimeFrom": dateTimeFrom,
        "dateTimeTo": dateTimeTo,
        "occasionId": occasionId,
        "message": message,
      };
}

class CustomerViewModel {
  CustomerViewModel({
    this.id,
    this.countryPhoneNumberPrefixId,
    this.countryId,
    this.customerTypeId,
    this.name,
    this.email,
    this.phoneNumber,
    this.isMarketingPromotionEnabled,
    this.isLoyaltyEnabled,
  });

  String? id;
  String? countryPhoneNumberPrefixId;
  String? countryId;
  String? customerTypeId;
  String? name;
  String? email;
  String? phoneNumber;
  bool? isMarketingPromotionEnabled;
  bool? isLoyaltyEnabled;

  factory CustomerViewModel.fromJson(Map<String, dynamic> json) =>
      CustomerViewModel(
        id: json["id"],
        countryPhoneNumberPrefixId: json["countryPhoneNumberPrefixId"],
        countryId: json["countryId"],
        customerTypeId: json["customerTypeId"],
        name: json["name"],
        email: json["email"],
        phoneNumber: json["phoneNumber"],
        isMarketingPromotionEnabled: json["isMarketingPromotionEnabled"],
        isLoyaltyEnabled: json["isLoyaltyEnabled"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "countryPhoneNumberPrefixId": countryPhoneNumberPrefixId,
        "countryId": countryId,
        "customerTypeId": customerTypeId,
        "name": name,
        "email": email,
        "phoneNumber": phoneNumber,
        "isMarketingPromotionEnabled": isMarketingPromotionEnabled,
        "isLoyaltyEnabled": isLoyaltyEnabled,
      };
}
