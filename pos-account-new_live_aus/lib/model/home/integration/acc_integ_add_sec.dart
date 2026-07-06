import '../../common/table_location.dart';

class AccIntegAddSec {
  AccIntegAddSec({
    this.accountingPlatForms,
    this.posDevices,
  });

  List<AccountingPlatForm>? accountingPlatForms;
  List<TableLocation>? posDevices;

  factory AccIntegAddSec.fromJson(Map<String, dynamic> json) => AccIntegAddSec(
        accountingPlatForms: json["integrationPlatforms"] == null
            ? null
            : List<AccountingPlatForm>.from(json["integrationPlatforms"]
                .map((x) => AccountingPlatForm.fromJson(x))),
        posDevices: json["posDevices"] == null
            ? []
            : List<TableLocation>.from(
                json["posDevices"]!.map((x) => TableLocation.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "integrationPlatforms": accountingPlatForms == null
            ? null
            : List<dynamic>.from(accountingPlatForms!.map((x) => x.toJson())),
        "posDevices": posDevices == null
            ? []
            : List<dynamic>.from(posDevices!.map((x) => x.toJson())),
      };
}

class AccountingPlatForm {
  AccountingPlatForm({
    this.id,
    this.name,
    this.image,
    this.description,
    this.integrationPlatformEnum,
  });

  String? id;
  String? name;
  String? image;
  String? description;
  String? integrationPlatformEnum;

  factory AccountingPlatForm.fromJson(Map<String, dynamic> json) =>
      AccountingPlatForm(
        id: json["id"],
        name: json["name"],
        image: json["image"],
        description: json["description"],
        integrationPlatformEnum: json["integrationPlatformEnum"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "image": image,
        "description": description,
        "integrationPlatformEnum": integrationPlatformEnum,
      };
}
