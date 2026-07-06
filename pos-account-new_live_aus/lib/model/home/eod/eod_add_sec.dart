import 'package:pos_account/model/common/table_location.dart';

class EodAddSec {
  EodAddSec({
    this.accountingPlatforms,
    this.taxExclusiveInclusives,
  });

  List<AccountingPlatform>? accountingPlatforms;
  List<TableLocation>? taxExclusiveInclusives;

  factory EodAddSec.fromJson(Map<String, dynamic> json) => EodAddSec(
        accountingPlatforms: json["accountingPlatforms"] == null
            ? null
            : List<AccountingPlatform>.from(json["accountingPlatforms"]
                .map((x) => AccountingPlatform.fromJson(x))),
        taxExclusiveInclusives: json["taxExclusiveInclusives"] == null
            ? []
            : List<TableLocation>.from(json["taxExclusiveInclusives"]!
                .map((x) => TableLocation.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "accountingPlatforms": accountingPlatforms == null
            ? null
            : List<dynamic>.from(accountingPlatforms!.map((x) => x.toJson())),
        "taxExclusiveInclusives": taxExclusiveInclusives == null
            ? []
            : List<dynamic>.from(
                taxExclusiveInclusives!.map((x) => x.toJson())),
      };
}

class AccountingPlatform {
  AccountingPlatform({
    this.id,
    this.name,
    this.image,
    this.description,
  });

  String? id;
  String? name;
  String? image;
  String? description;

  factory AccountingPlatform.fromJson(Map<String, dynamic> json) =>
      AccountingPlatform(
        id: json["id"],
        name: json["name"],
        image: json["image"],
        description: json["description"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "image": image,
        "description": description,
      };
}
