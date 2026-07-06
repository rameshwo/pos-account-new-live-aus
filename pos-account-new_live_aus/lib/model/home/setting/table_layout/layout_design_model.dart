import 'dart:convert';
import 'package:flutter/material.dart';

enum ObjectType { Table, Line }

enum FloorTblStatus { Available, Reserved, Occupied }

enum DialogFrom { PosPage, BookingPage }

class PDataElements {
  String? reservedType;
  String? cusName;
  int? reservedTime;
  String? amount;
  String? orderId;
  int? adult;
  String? reservId;
  FloorTblStatus status;
  Color statusColor;
  String? orderNo;
  String? mergeId;

  PDataElements({
    this.reservedType,
    this.cusName,
    this.reservedTime,
    this.amount,
    this.orderId,
    this.adult,
    this.reservId,
    this.status = FloorTblStatus.Available,
    this.statusColor = Colors.green,
    this.orderNo,
    this.mergeId,
  });
}

class PData {
  String? id;

  double left;
  double top;
  double size;
  double angle;
  ObjectType? objectType;
  LineData? lineData;
  // not in map

  String? title;
  String? image;
  String? adult;
  String? child;
  GlobalKey? key;

  List<PDataElements> pElements;

  PData({
    this.id,
    this.left = 12.0,
    this.top = 0.0,
    this.size = 80,
    this.angle = 0.0,
    this.objectType,
    this.lineData,

    // not in map
    this.title,
    this.image,
    this.adult,
    this.child,
    this.key,
    this.pElements = const [],
  });

  factory PData.fromJson(Map<String, dynamic> json) => PData(
        id: json["id"],
        // title: json["title"],
        // image: json["image"],
        left: json["left"],
        top: json["top"],
        size: json["size"],
        angle: json["angle"],
        objectType: json["objectType"] != null && json["objectType"] is int
            ? ObjectType.values[json["objectType"]]
            : null,
        lineData: json["line_data"] == null
            ? null
            : LineData.fromJson(json["line_data"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        // "title": title,
        // "image": image,
        "left": left,
        "top": top,
        "size": size,
        "angle": angle,
        "objectType": objectType?.index,
        "line_data": lineData?.toJson(),
      };
}

class LineData {
  List<double>? startPoint;
  List<double>? endPoint;
  double? strokeWidth;
  int? lineColor;

  LineData({
    this.startPoint,
    this.endPoint,
    this.strokeWidth,
    this.lineColor,
  });

  factory LineData.fromJson(Map<String, dynamic> json) => LineData(
        startPoint: json["start_point"] == null
            ? []
            : List<double>.from(json["start_point"]!.map((x) => x?.toDouble())),
        endPoint: json["end_point"] == null
            ? []
            : List<double>.from(json["end_point"]!.map((x) => x?.toDouble())),
        strokeWidth: json["stroke_width"]?.toDouble(),
        lineColor: json["line_color"],
      );

  Map<String, dynamic> toJson() => {
        "start_point": startPoint == null
            ? []
            : List<dynamic>.from(startPoint!.map((x) => x)),
        "end_point":
            endPoint == null ? [] : List<dynamic>.from(endPoint!.map((x) => x)),
        "stroke_width": strokeWidth,
        "line_color": lineColor,
      };
}

LayoutDesignModel layoutDesignModelFromJson(String str) =>
    LayoutDesignModel.fromJson(json.decode(str));

String layoutDesignModelToJson(LayoutDesignModel data) =>
    json.encode(data.toJson());

class LayoutDesignModel {
  TableSize? tableSize;
  TableArea? tableArea;
  List<PData>? pDataList;

  LayoutDesignModel({
    this.tableSize,
    this.tableArea,
    this.pDataList,
  });

  factory LayoutDesignModel.fromJson(Map<String, dynamic> json) =>
      LayoutDesignModel(
        tableSize: json["table_size"] == null
            ? null
            : TableSize.fromJson(json["table_size"]),
        tableArea: json["table_area"] == null
            ? null
            : TableArea.fromJson(json["table_area"]),
        pDataList: json["p_data_list"] == null
            ? []
            : List<PData>.from(
                json["p_data_list"]!.map((x) => PData.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "table_size": tableSize?.toJson(),
        "table_area": tableArea?.toJson(),
        "p_data_list": pDataList == null
            ? []
            : List<dynamic>.from(pDataList!.map((x) => x.toJson())),
      };
}

class TableArea {
  double? minWidth;
  double? minHeight;
  double? maxWidth;
  double? maxHeight;

  TableArea({
    this.minWidth,
    this.minHeight,
    this.maxWidth,
    this.maxHeight,
  });

  factory TableArea.fromJson(Map<String, dynamic> json) => TableArea(
        minWidth: json["min_width"]?.toDouble(),
        minHeight: json["min_height"]?.toDouble(),
        maxWidth: json["max_width"]?.toDouble(),
        maxHeight: json["max_height"]?.toDouble(),
      );

  Map<String, dynamic> toJson() => {
        "min_width": minWidth,
        "min_height": minHeight,
        "max_width": maxWidth,
        "max_height": maxHeight,
      };
}

class TableSize {
  double? height;
  double? width;

  TableSize({
    this.height,
    this.width,
  });

  factory TableSize.fromJson(Map<String, dynamic> json) => TableSize(
        height: json["height"]?.toDouble(),
        width: json["width"]?.toDouble(),
      );

  Map<String, dynamic> toJson() => {
        "height": height,
        "width": width,
      };
}
