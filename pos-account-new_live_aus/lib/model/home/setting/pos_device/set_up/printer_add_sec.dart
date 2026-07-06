import 'package:pos_account/model/common/table_location.dart';

class PrinterSetupAddSec {
  PrinterSetupAddSec({
    this.cateogoryTypes,
    this.posPrinters,
    this.categories,
    this.posDevices,
  });

  List<TableLocation>? cateogoryTypes;
  List<TableLocation>? posPrinters;
  List<TableLocation>? categories;
  List<TableLocation>? posDevices;

  factory PrinterSetupAddSec.fromJson(Map<String, dynamic> json) =>
      PrinterSetupAddSec(
        cateogoryTypes: json["cateogoryTypes"] == null
            ? null
            : List<TableLocation>.from(
                json["cateogoryTypes"].map((x) => TableLocation.fromJson(x))),
        posPrinters: json["posPrinters"] == null
            ? null
            : List<TableLocation>.from(
                json["posPrinters"].map((x) => TableLocation.fromJson(x))),
        categories: json["categories"] == null
            ? []
            : List<TableLocation>.from(
                json["categories"]!.map((x) => TableLocation.fromJson(x))),
        posDevices: json["posDevices"] == null
            ? null
            : List<TableLocation>.from(
                json["posDevices"].map((x) => TableLocation.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "cateogoryTypes": cateogoryTypes == null
            ? null
            : List<dynamic>.from(cateogoryTypes!.map((x) => x.toJson())),
        "posPrinters": posPrinters == null
            ? null
            : List<dynamic>.from(posPrinters!.map((x) => x.toJson())),
        "categories": categories == null
            ? []
            : List<dynamic>.from(categories!.map((x) => x.toJson())),
        "posDevices": posDevices == null
            ? null
            : List<dynamic>.from(posDevices!.map((x) => x.toJson())),
      };
}
