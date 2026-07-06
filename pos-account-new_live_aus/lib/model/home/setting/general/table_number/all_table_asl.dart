//get all table add section list

import 'package:pos_account/model/common/table_location.dart';

class GaTableAsl {
  GaTableAsl({
    this.tableLocations,
    this.tableImageList,
  });

  List<TableLocation>? tableLocations;
  List<TableImageList>? tableImageList;

  factory GaTableAsl.fromJson(Map<String, dynamic> json) => GaTableAsl(
        tableLocations: json["tableLocations"] == null
            ? null
            : List<TableLocation>.from(
                json["tableLocations"].map((x) => TableLocation.fromJson(x))),
        tableImageList: json["tableImageList"] == null
            ? null
            : List<TableImageList>.from(
                json["tableImageList"].map((x) => TableImageList.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "tableLocations": tableLocations == null
            ? null
            : List<dynamic>.from(tableLocations!.map((x) => x.toJson())),
        "tableImageList": tableImageList == null
            ? null
            : List<dynamic>.from(tableImageList!.map((x) => x.toJson())),
      };
}

class TableImageList {
  TableImageList({
    this.id,
    this.value,
    this.name,
    this.image,
    this.childCapacity,
    this.adultCapacity,
    this.isSelect = false,
  });

  String? id;
  String? value;
  String? name;
  String? image;
  String? childCapacity;
  String? adultCapacity;
  bool isSelect;

  factory TableImageList.fromJson(Map<String, dynamic> json) => TableImageList(
        id: json["id"],
        value: json["value"],
        name: json["name"],
        image: json["image"],
        childCapacity: json["childCapacity"],
        adultCapacity: json["adultCapacity"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "value": value,
        "name": name,
        "image": image,
        "childCapacity": childCapacity,
        "adultCapacity": adultCapacity,
      };
}
