import 'package:pos_account/model/common/table_id_name.dart';

class TableLayReq {
  TableLayReq({
    this.id = "",
    this.tableLocationId,
    this.tableSettings,
    this.tables,
  });

  String id;
  String? tableLocationId;
  String? tableSettings;
  List<TableIdName>? tables;

  factory TableLayReq.fromJson(Map<String, dynamic> json) => TableLayReq(
        id: json["id"],
        tableLocationId: json["tableLocationId"],
        tableSettings: json["tableLayoutSettings"],
        tables: json["tables"] == null
            ? []
            : List<TableIdName>.from(
                json["tables"]!.map((x) => TableIdName.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "tableLocationId": tableLocationId,
        "tableLayoutSettings": tableSettings,
        if (tables != null)
          "tables": List<dynamic>.from(tables!.map((x) => x.toJson())),
      };
}

// final ToolContraint = {
//   "topLeft": "0,0",
//   "topRight": "100,0",
//   "bottomLeft": "0,700",
//   "bottomRight": "100,700",
// };

// const middleSpace = 12;

// final DrawContraint = {
//   "topLeft": "112,0",
//   "topRight": "1200,0",
//   "bottomLeft": "112,700",
//   "bottomRight": "1200,700",
// };
