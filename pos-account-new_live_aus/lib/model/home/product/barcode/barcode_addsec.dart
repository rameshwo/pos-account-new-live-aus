import 'package:pos_account/model/common/table_location.dart';

class BarcodeAddSec {
  BarcodeAddSec({
    this.posPrinters,
    this.barCodeTypes,
  });

  List<TableLocation>? posPrinters;
  List<TableLocation>? barCodeTypes;

  factory BarcodeAddSec.fromJson(Map<String, dynamic> json) => BarcodeAddSec(
        posPrinters: json["posPrinters"] == null
            ? []
            : List<TableLocation>.from(
                json["posPrinters"]!.map((x) => TableLocation.fromJson(x))),
        barCodeTypes: json["barCodeTypes"] == null
            ? []
            : List<TableLocation>.from(
                json["barCodeTypes"]!.map((x) => TableLocation.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "posPrinters": posPrinters == null
            ? []
            : List<dynamic>.from(posPrinters!.map((x) => x.toJson())),
        "barCodeTypes": barCodeTypes == null
            ? []
            : List<dynamic>.from(barCodeTypes!.map((x) => x.toJson())),
      };
}
