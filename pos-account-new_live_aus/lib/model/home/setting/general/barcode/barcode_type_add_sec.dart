import 'package:pos_account/model/common/table_location.dart';

class BarCodeTypeAddSec {
  BarCodeTypeAddSec({
    this.barCodeTypes,
  });

  List<TableLocation>? barCodeTypes;

  factory BarCodeTypeAddSec.fromJson(Map<String, dynamic> json) =>
      BarCodeTypeAddSec(
        barCodeTypes: json["barCodeTypes"] == null
            ? []
            : List<TableLocation>.from(
                json["barCodeTypes"]!.map((x) => TableLocation.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "barCodeTypes": barCodeTypes == null
            ? []
            : List<dynamic>.from(barCodeTypes!.map((x) => x.toJson())),
      };
}
