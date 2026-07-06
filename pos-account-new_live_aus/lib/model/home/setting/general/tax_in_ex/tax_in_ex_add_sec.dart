import 'package:pos_account/model/common/table_location.dart';

class TaxInExAddSec {
  List<TableLocation>? taxTypes;
  List<TableLocation>? orderTypes;
  List<TableLocation>? productCategories;

  TaxInExAddSec({
    this.taxTypes,
    this.orderTypes,
    this.productCategories,
  });

  factory TaxInExAddSec.fromJson(Map<String, dynamic> json) => TaxInExAddSec(
        taxTypes: json["taxTypes"] == null
            ? []
            : List<TableLocation>.from(
                json["taxTypes"]!.map((x) => TableLocation.fromJson(x))),
        orderTypes: json["orderTypes"] == null
            ? []
            : List<TableLocation>.from(
                json["orderTypes"]!.map((x) => TableLocation.fromJson(x))),
        productCategories: json["productCategories"] == null
            ? []
            : List<TableLocation>.from(json["productCategories"]!
                .map((x) => TableLocation.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "taxTypes": taxTypes == null
            ? []
            : List<dynamic>.from(taxTypes!.map((x) => x.toJson())),
        "orderTypes": orderTypes == null
            ? []
            : List<dynamic>.from(orderTypes!.map((x) => x.toJson())),
        "productCategories": productCategories == null
            ? []
            : List<dynamic>.from(productCategories!.map((x) => x.toJson())),
      };
}
