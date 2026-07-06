import 'package:pos_account/model/common/table_location.dart';
import 'package:pos_account/model/home/setting/store/store_res.dart';
import 'package:pos_account/model/profile/user_add_sec.dart';

class BoardStoreAddSec {
  BoardStoreAddSec({
    this.countries,
    this.timeZones,
    this.businessTypes,
    this.businessTypeCategoriesWithBussinessTypes,
  });

  List<CountryCityState>? countries;
  List<TableLocation>? timeZones;
  List<TableLocation>? businessTypes;
  List<BusinessTypeCategoriesWithBussinessType>?
      businessTypeCategoriesWithBussinessTypes;

  factory BoardStoreAddSec.fromJson(Map<String, dynamic> json) =>
      BoardStoreAddSec(
        countries: json["countries"] == null
            ? []
            : List<CountryCityState>.from(
                json["countries"]!.map((x) => CountryCityState.fromJson(x))),
        timeZones: json["timeZones"] == null
            ? []
            : List<TableLocation>.from(
                json["timeZones"]!.map((x) => TableLocation.fromJson(x))),
        businessTypes: json["businessTypes"] == null
            ? []
            : List<TableLocation>.from(
                json["businessTypes"]!.map((x) => TableLocation.fromJson(x))),
        businessTypeCategoriesWithBussinessTypes:
            json["businessTypeCategoriesWithBussinessTypes"] == null
                ? []
                : List<BusinessTypeCategoriesWithBussinessType>.from(
                    json["businessTypeCategoriesWithBussinessTypes"]!.map((x) =>
                        BusinessTypeCategoriesWithBussinessType.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "countries": countries == null
            ? []
            : List<dynamic>.from(countries!.map((x) => x.toJson())),
        "timeZones": timeZones == null
            ? []
            : List<dynamic>.from(timeZones!.map((x) => x.toJson())),
        "businessTypes": businessTypes == null
            ? []
            : List<dynamic>.from(businessTypes!.map((x) => x.toJson())),
        "businessTypeCategoriesWithBussinessTypes":
            businessTypeCategoriesWithBussinessTypes == null
                ? []
                : List<dynamic>.from(businessTypeCategoriesWithBussinessTypes!
                    .map((x) => x.toJson())),
      };
}
