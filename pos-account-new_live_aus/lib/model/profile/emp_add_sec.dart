import 'package:pos_account/model/common/table_location.dart';
import 'package:pos_account/model/profile/user_add_sec.dart';

class EmpAddSec {
  String? employeeCode;
  List<TableLocation>? employees;
  List<TableLocation>? roles;
  List<TableLocation>? genders;
  List<TableLocation>? employmentTypes;
  List<TableLocation>? posTabDefaultScreens;
  List<CountryCityState>? countryCityStates;

  EmpAddSec({
    this.employeeCode,
    this.employees,
    this.roles,
    this.genders,
    this.employmentTypes,
    this.posTabDefaultScreens,
    this.countryCityStates,
  });

  factory EmpAddSec.fromJson(Map<String, dynamic> json) => EmpAddSec(
        employeeCode: json["employeeCode"],
        employees: json["employees"] == null
            ? []
            : List<TableLocation>.from(
                json["employees"]!.map((x) => TableLocation.fromJson(x))),
        roles: json["roles"] == null
            ? []
            : List<TableLocation>.from(
                json["roles"]!.map((x) => TableLocation.fromJson(x))),
        genders: json["genders"] == null
            ? []
            : List<TableLocation>.from(
                json["genders"]!.map((x) => TableLocation.fromJson(x))),
        employmentTypes: json["employmentTypes"] == null
            ? []
            : List<TableLocation>.from(
                json["employmentTypes"]!.map((x) => TableLocation.fromJson(x))),
        posTabDefaultScreens: json["posTabDefaultScreens"] == null
            ? []
            : List<TableLocation>.from(json["posTabDefaultScreens"]!
                .map((x) => TableLocation.fromJson(x))),
        countryCityStates: json["countryCityStates"] == null
            ? []
            : List<CountryCityState>.from(json["countryCityStates"]!
                .map((x) => CountryCityState.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "employeeCode": employeeCode,
        "employees": employees == null
            ? []
            : List<dynamic>.from(employees!.map((x) => x.toJson())),
        "roles": roles == null
            ? []
            : List<dynamic>.from(roles!.map((x) => x.toJson())),
        "genders": genders == null
            ? []
            : List<dynamic>.from(genders!.map((x) => x.toJson())),
        "employmentTypes": employmentTypes == null
            ? []
            : List<dynamic>.from(employmentTypes!.map((x) => x.toJson())),
        "posTabDefaultScreens": posTabDefaultScreens == null
            ? []
            : List<dynamic>.from(posTabDefaultScreens!.map((x) => x.toJson())),
        "countryCityStates": countryCityStates == null
            ? []
            : List<dynamic>.from(countryCityStates!.map((x) => x.toJson())),
      };
}
