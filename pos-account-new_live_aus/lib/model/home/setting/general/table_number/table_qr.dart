import 'package:flutter/material.dart';

class TableQr {
  TableQr({
    this.qrImageUrl,
    this.tableName,
    this.tableLocation,
    this.url,
    this.captureWidget,
  });

  String? qrImageUrl;
  String? tableName;
  String? tableLocation;
  String? url;
  Widget? captureWidget;

  factory TableQr.fromJson(Map<String, dynamic> json) => TableQr(
        qrImageUrl: json["qrImageUrl"],
        tableName: json["tableName"],
        tableLocation: json["tableLocation"],
        url: json["url"],
      );

  Map<String, dynamic> toJson() => {
        "qrImageUrl": qrImageUrl,
        "tableName": tableName,
        "tableLocation": tableLocation,
        "url": url,
      };
}
