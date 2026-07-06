import 'package:pos_account/model/common/table_location.dart';

class PosDeviceAddSec {
  // List<TableLocation>? departments;
  // List<TableLocation>? tables;
  List<TableLocation>? posPrinters;
  List<TableLocation>? posDeviceTypes;
  List<TableLocation>? posDefaultScreens;

  PosDeviceAddSec({
    // this.departments,
    // this.tables,
    this.posPrinters,
    this.posDeviceTypes,
    this.posDefaultScreens,
  });

  factory PosDeviceAddSec.fromJson(Map<String, dynamic> json) =>
      PosDeviceAddSec(
        // departments: json["departments"] == null
        //     ? []
        //     : List<TableLocation>.from(
        //         json["departments"]!.map((x) => TableLocation.fromJson(x))),
        // tables: json["tables"] == null
        //     ? []
        //     : List<TableLocation>.from(
        //         json["tables"]!.map((x) => TableLocation.fromJson(x))),
        posPrinters: json["posPrinters"] == null
            ? []
            : List<TableLocation>.from(
                json["posPrinters"]!.map((x) => TableLocation.fromJson(x))),
        posDeviceTypes: json["posDeviceTypes"] == null
            ? []
            : List<TableLocation>.from(
                json["posDeviceTypes"]!.map((x) => TableLocation.fromJson(x))),
        posDefaultScreens: json["posDefaultScreens"] == null
            ? []
            : List<TableLocation>.from(json["posDefaultScreens"]!
                .map((x) => TableLocation.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        // "departments": departments == null
        //     ? []
        //     : List<dynamic>.from(departments!.map((x) => x.toJson())),
        // "tables": tables == null
        //     ? []
        //     : List<dynamic>.from(tables!.map((x) => x.toJson())),
        "posPrinters": posPrinters == null
            ? []
            : List<dynamic>.from(posPrinters!.map((x) => x.toJson())),
        "posDeviceTypes": posDeviceTypes == null
            ? []
            : List<dynamic>.from(posDeviceTypes!.map((x) => x.toJson())),
        "posDefaultScreens": posDefaultScreens == null
            ? []
            : List<dynamic>.from(posDefaultScreens!.map((x) => x.toJson())),
      };
}
