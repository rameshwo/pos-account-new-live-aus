import 'package:pos_account/model/common/category.dart';
import 'package:pos_account/model/common/table_location.dart';

class AllSettings {
  AllSettings({
    this.brand,
    this.productCategories,
    this.tableLocationsWithTables,
    this.orderTypes,
    this.taxTypes,
    this.categoryTypes,
    this.productSubCategories,
    this.barCodeTypes,
    this.docketGroups,
  });

  List<TableLocation>? brand;
  List<TableLocation>? productCategories;
  List<TableLocationsWithTable>? tableLocationsWithTables;
  List<AllSettingsOrderType>? orderTypes;
  List<TaxType>? taxTypes;
  List<TableLocation>? categoryTypes;
  List<Category>? productSubCategories;
  List<TableLocation>? barCodeTypes;
  List<TableLocation>? docketGroups;

  factory AllSettings.fromJson(Map<String, dynamic> json) => AllSettings(
        brand: json["brand"] == null
            ? null
            : List<TableLocation>.from(
                json["brand"].map((x) => TableLocation.fromJson(x))),
        productCategories: json["productCategories"] == null
            ? null
            : List<TableLocation>.from(json["productCategories"]
                .map((x) => TableLocation.fromJson(x))),
        tableLocationsWithTables: json["tableLocationsWithTables"] == null
            ? null
            : List<TableLocationsWithTable>.from(
                json["tableLocationsWithTables"]
                    .map((x) => TableLocationsWithTable.fromJson(x))),
        orderTypes: json["orderTypes"] == null
            ? null
            : List<AllSettingsOrderType>.from(json["orderTypes"]
                .map((x) => AllSettingsOrderType.fromJson(x))),
        taxTypes: json["taxTypes"] == null
            ? []
            : List<TaxType>.from(
                json["taxTypes"]!.map((x) => TaxType.fromJson(x))),
        categoryTypes: json["categoryTypes"] == null
            ? null
            : List<TableLocation>.from(
                json["categoryTypes"].map((x) => TableLocation.fromJson(x))),
        productSubCategories: json["productSubCategories"] == null
            ? []
            : List<Category>.from(
                json["productSubCategories"]!.map((x) => Category.fromJson(x))),
        barCodeTypes: json["barCodeTypes"] == null
            ? []
            : List<TableLocation>.from(
                json["barCodeTypes"]!.map((x) => TableLocation.fromJson(x))),
        docketGroups: json["docketGroups"] == null
            ? []
            : List<TableLocation>.from(
                json["docketGroups"]!.map((x) => TableLocation.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "brand": brand == null
            ? null
            : List<dynamic>.from(brand!.map((x) => x.toJson())),
        "productCategories": productCategories == null
            ? null
            : List<dynamic>.from(productCategories!.map((x) => x.toJson())),
        "tableLocationsWithTables": tableLocationsWithTables == null
            ? null
            : List<dynamic>.from(
                tableLocationsWithTables!.map((x) => x.toJson())),
        "orderTypes": orderTypes == null
            ? null
            : List<dynamic>.from(orderTypes!.map((x) => x.toJson())),
        "taxTypes": taxTypes == null
            ? []
            : List<dynamic>.from(taxTypes!.map((x) => x.toJson())),
        "categoryTypes": categoryTypes == null
            ? null
            : List<dynamic>.from(categoryTypes!.map((x) => x.toJson())),
        "productSubCategories": productSubCategories == null
            ? []
            : List<dynamic>.from(productSubCategories!.map((x) => x.toJson())),
        "barCodeTypes": barCodeTypes == null
            ? []
            : List<dynamic>.from(barCodeTypes!.map((x) => x.toJson())),
        "docketGroups": docketGroups == null
            ? []
            : List<dynamic>.from(docketGroups!.map((x) => x.toJson())),
      };
}

class TableLocationsWithTable {
  TableLocationsWithTable({
    this.id,
    this.value,
    this.tables,
  });

  String? id;
  String? value;
  List<TableLocation>? tables;

  factory TableLocationsWithTable.fromJson(Map<String, dynamic> json) =>
      TableLocationsWithTable(
        id: json["id"],
        value: json["value"],
        tables: json["tables"] == null
            ? null
            : List<TableLocation>.from(
                json["tables"].map((x) => TableLocation.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "value": value,
        "tables": tables == null
            ? null
            : List<dynamic>.from(tables!.map((x) => x.toJson())),
      };
}

class AllSettingsOrderType {
  AllSettingsOrderType({
    this.channelName,
    this.orderTypes,
  });

  String? channelName;
  List<TableLocation>? orderTypes;

  factory AllSettingsOrderType.fromJson(Map<String, dynamic> json) =>
      AllSettingsOrderType(
        channelName: json["channelName"],
        orderTypes: json["orderTypes"] == null
            ? []
            : List<TableLocation>.from(
                json["orderTypes"]!.map((x) => TableLocation.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "channelName": channelName,
        "orderTypes": orderTypes == null
            ? []
            : List<dynamic>.from(orderTypes!.map((x) => x.toJson())),
      };
}

class TaxType {
  TaxType({
    this.taxType,
    this.taxes,
  });

  String? taxType;
  List<TableLocation>? taxes;

  factory TaxType.fromJson(Map<String, dynamic> json) => TaxType(
        taxType: json["taxType"],
        taxes: json["taxes"] == null
            ? []
            : List<TableLocation>.from(
                json["taxes"]!.map((x) => TableLocation.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "taxType": taxType,
        "taxes": taxes == null
            ? []
            : List<dynamic>.from(taxes!.map((x) => x.toJson())),
      };
}
