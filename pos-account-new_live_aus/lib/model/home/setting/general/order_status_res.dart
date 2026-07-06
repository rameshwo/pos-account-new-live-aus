import 'package:flutter/material.dart';

class AllOrderStatusRes {
  String? id;
  TextEditingController? name;
  bool? isActive;
  TextEditingController? sortOrder;

  AllOrderStatusRes({
    this.id,
    this.name,
    this.isActive,
    this.sortOrder,
  });

  factory AllOrderStatusRes.fromJson(Map<String, dynamic> json) =>
      AllOrderStatusRes(
        id: json["id"],
        name: TextEditingController(text: json["name"]?.toString() ?? ''),
        isActive: json["isActive"],
        sortOrder:
            TextEditingController(text: json["sortOrder"]?.toString() ?? ''),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name?.text ?? '',
        "isActive": isActive,
        "sortOrder": int.tryParse(sortOrder?.text ?? '') ?? 0,
      };
}
