import 'package:pos_account/model/common/table_location.dart';

class AllPrinterSettingRes {
  AllPrinterSettingRes({
    this.departments,
    this.posDevices,
    this.posPrinters,
  });

  List<TableLocation>? departments;
  List<TableLocation>? posDevices;
  List<TableLocation>? posPrinters;

  factory AllPrinterSettingRes.fromJson(Map<String, dynamic> json) =>
      AllPrinterSettingRes(
        departments: json["departments"] == null
            ? null
            : List<TableLocation>.from(
                json["departments"].map((x) => TableLocation.fromJson(x))),
        posDevices: json["posDevices"] == null
            ? null
            : List<TableLocation>.from(
                json["posDevices"].map((x) => TableLocation.fromJson(x))),
        posPrinters: json["posPrinters"] == null
            ? null
            : List<TableLocation>.from(
                json["posPrinters"].map((x) => TableLocation.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "departments": departments == null
            ? null
            : List<dynamic>.from(departments!.map((x) => x.toJson())),
        "posDevices": posDevices == null
            ? null
            : List<dynamic>.from(posDevices!.map((x) => x.toJson())),
        "posPrinters": posPrinters == null
            ? null
            : List<dynamic>.from(posPrinters!.map((x) => x.toJson())),
      };
}
