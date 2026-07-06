import 'package:flutter/material.dart';

class ChartOfAccModel {
  ChartOfAccModel({
    this.id,
    this.accountingPlatFormId,
    required this.codes,
    this.name,
  });

  String? id;
  String? accountingPlatFormId;
  final TextEditingController codes;
  String? name;

  factory ChartOfAccModel.fromJson(Map<String, dynamic> json) =>
      ChartOfAccModel(
        id: json["id"],
        accountingPlatFormId: json["accountingPlatFormId"],
        codes: TextEditingController(
            text: json["codes"] != null ? json["codes"].toString() : ''),
        name: json["name"],
      );

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data.addAll({
      "Id": id,
      "AccountingPlatFormId": accountingPlatFormId,
      "Codes": codes.text,
    });

    // if (name != null)
    //   _data.addAll({
    //     "name": name,
    //   });
    return data;
  }
}
