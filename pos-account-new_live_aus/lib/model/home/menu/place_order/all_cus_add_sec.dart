import 'package:pos_account/model/common/table_location.dart';
import 'package:pos_account/model/profile/user_add_sec.dart';

class CustomerAddSecRes {
  CustomerAddSecRes({
    this.customerType,
    this.countries,
    this.customerGroups,
  });

  List<TableLocation>? customerType;
  List<UserAddSecData>? countries;
  List<TableLocation>? customerGroups;

  factory CustomerAddSecRes.fromJson(Map<String, dynamic> json) =>
      CustomerAddSecRes(
        customerType: json["customerTypes"] == null
            ? null
            : List<TableLocation>.from(
                json["customerTypes"].map((x) => TableLocation.fromJson(x))),
        countries: json["countries"] == null
            ? null
            : List<UserAddSecData>.from(
                json["countries"].map((x) => UserAddSecData.fromJson(x))),
        customerGroups: json["customerGroups"] == null
            ? []
            : List<TableLocation>.from(
                json["customerGroups"]!.map((x) => TableLocation.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "customerTypes": customerType == null
            ? null
            : List<dynamic>.from(customerType!.map((x) => x.toJson())),
        "countries": countries == null
            ? null
            : List<dynamic>.from(countries!.map((x) => x.toJson())),
        "customerGroups": customerGroups == null
            ? []
            : List<dynamic>.from(customerGroups!.map((x) => x.toJson())),
      };
}
