import 'package:pos_account/model/common/message.dart';

//create for tax inclusive and exclusive get data

class SettingResTyp2 {
  SettingResTyp2({
    this.data,
    this.message,
    this.total,
    this.status,
  });

  List<SRT2Data>? data;
  List<Message>? message;
  int? total;
  int? status;

  factory SettingResTyp2.fromJson(Map<String, dynamic> json) => SettingResTyp2(
        data:
            List<SRT2Data>.from(json["data"].map((x) => SRT2Data.fromJson(x))),
        message:
            List<Message>.from(json["message"].map((x) => Message.fromJson(x))),
        total: json["total"],
        status: json["status"],
      );

  Map<String, dynamic> toJson() => {
        "data": data == null
            ? null
            : List<dynamic>.from(data!.map((x) => x.toJson())),
        "message": message == null
            ? null
            : List<dynamic>.from(message!.map((x) => x.toJson())),
        "total": total,
        "status": status,
      };
}

class SRT2Data {
  SRT2Data({
    this.id,
    this.name,
    this.value,
    this.isActive,
    this.isDefault,
    this.taxType,
    this.productCount,
    this.total,
  });

  String? id;
  String? name;
  String? value;
  bool? isActive;
  bool? isDefault;
  String? taxType;
  int? productCount;
  int? total;

  factory SRT2Data.fromJson(Map<String, dynamic> json) => SRT2Data(
        id: json["id"],
        name: json["name"],
        value: json["value"],
        isActive: json["isActive"],
        isDefault: json["isDefault"],
        taxType: json["taxType"],
        productCount: json["productCount"],
        total: json["total"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "value": value,
        "isActive": isActive,
        "isDefault": isDefault,
        "taxType": taxType,
        "productCount": productCount,
        "total": total,
      };
}
