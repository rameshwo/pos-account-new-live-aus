import 'package:pos_account/model/home/setting/general/table_number/all_table_asl.dart';

class AllTableLayAddSecRes {
  AllTableLayAddSecRes({
    this.tableLocationsWithTables,
  });

  List<TableLocationsWithTable>? tableLocationsWithTables;

  factory AllTableLayAddSecRes.fromJson(Map<String, dynamic> json) =>
      AllTableLayAddSecRes(
        tableLocationsWithTables: json["tableLocationsWithTables"] == null
            ? null
            : List<TableLocationsWithTable>.from(
                json["tableLocationsWithTables"]
                    .map((x) => TableLocationsWithTable.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "tableLocationsWithTables": tableLocationsWithTables == null
            ? null
            : List<dynamic>.from(
                tableLocationsWithTables!.map((x) => x.toJson())),
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
  List<TableImageList>? tables;

  factory TableLocationsWithTable.fromJson(Map<String, dynamic> json) =>
      TableLocationsWithTable(
        id: json["id"],
        value: json["value"],
        tables: json["tables"] == null
            ? null
            : List<TableImageList>.from(
                json["tables"].map((x) => TableImageList.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "value": value,
        "tables": tables == null
            ? null
            : List<dynamic>.from(tables!.map((x) => x.toJson())),
      };
}
