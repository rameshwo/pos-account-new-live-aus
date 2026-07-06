import 'package:flutter/material.dart';

class StoreColorModel {
  String? id;
  List<ThemeColorAddViewModel>? themeColorAddViewModels;
  List<String>? onlineThemeColorDeletedIds;

  StoreColorModel({
    this.id,
    this.themeColorAddViewModels,
    this.onlineThemeColorDeletedIds,
  });

  factory StoreColorModel.fromJson(Map<String, dynamic> json) =>
      StoreColorModel(
        id: json["id"],
        themeColorAddViewModels: json["themeColorAddViewModels"] == null
            ? []
            : List<ThemeColorAddViewModel>.from(json["themeColorAddViewModels"]!
                .map((x) => ThemeColorAddViewModel.fromJson(x))),
        onlineThemeColorDeletedIds: json["onlineThemeColorDeletedIds"] == null
            ? []
            : List<String>.from(
                json["onlineThemeColorDeletedIds"]!.map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "themeColorAddViewModels": themeColorAddViewModels == null
            ? []
            : List<dynamic>.from(
                themeColorAddViewModels!.map((x) => x.toJson())),
        "onlineThemeColorDeletedIds": onlineThemeColorDeletedIds == null
            ? []
            : List<dynamic>.from(onlineThemeColorDeletedIds!.map((x) => x)),
      };
}

class ThemeColorAddViewModel {
  String? id;
  TextEditingController name;
  TextEditingController displayName;
  TextEditingController value;

  ThemeColorAddViewModel({
    this.id,
    required this.name,
    required this.displayName,
    required this.value,
  });

  factory ThemeColorAddViewModel.fromJson(Map<String, dynamic> json) =>
      ThemeColorAddViewModel(
        id: json["id"],
        name: TextEditingController(text: json["name"]?.toString() ?? ''),
        displayName:
            TextEditingController(text: json["displayName"]?.toString() ?? ''),
        value: TextEditingController(text: json["value"]?.toString() ?? ''),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name.text,
        "displayName": displayName.text,
        "value": value.text,
      };
}
