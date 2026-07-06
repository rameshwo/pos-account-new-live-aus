import 'package:flutter/material.dart';

class PrintInvoice {
  PrintInvoice({
    this.image,
    this.title,
    this.subtitle,
    this.subtitleList,
    this.body,
    this.footerList,
    this.ipAddress,
    this.port,
    this.paperSize,
    // this.isBluetoothPrinter,
    this.isDocket = false,
    this.printerType,
    this.captureKey,
  });

  String? image;
  String? title;
  String? subtitle;
  List<SubtitleList>? subtitleList;
  Body? body;
  List<String?>? footerList;
  String? ipAddress;
  String? port;
  String? paperSize;
  // bool? isBluetoothPrinter;
  bool isDocket;
  String? printerType;
  GlobalKey? captureKey;

  factory PrintInvoice.fromJson(Map<String, dynamic> json) => PrintInvoice(
        isDocket: json["is_docket"],
        image: json["image"],
        title: json["title"],
        subtitle: json["subtitle"],
        subtitleList: json["subtitle_list"] == null
            ? null
            : List<SubtitleList>.from(
                json["subtitle_list"].map((x) => SubtitleList.fromJson(x))),
        body: json["body"] == null ? null : Body.fromJson(json["body"]),
        footerList: json["footer_list"] == null
            ? null
            : List<String>.from(json["footer_list"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "is_docket": isDocket,
        "image": image,
        "title": title,
        "subtitle": subtitle,
        "subtitle_list": subtitleList == null
            ? null
            : List<dynamic>.from(subtitleList!.map((x) => x.toJson())),
        "body": body?.toJson(),
        "footer_list": footerList == null
            ? null
            : List<dynamic>.from(footerList!.map((x) => x)),
      };
}

class Body {
  Body({
    this.header,
    this.item,
    this.itemFooter,
    this.footer,
  });

  List<Footer>? header;
  List<Item>? item;
  ItemFooterElement? itemFooter;
  List<Footer>? footer;

  factory Body.fromJson(Map<String, dynamic> json) => Body(
        header: json["header"] == null
            ? null
            : List<Footer>.from(json["header"].map((x) => Footer.fromJson(x))),
        item: json["item"] == null
            ? null
            : List<Item>.from(json["item"].map((x) => Item.fromJson(x))),
        itemFooter: json["item_footer"] == null
            ? null
            : ItemFooterElement.fromJson(json["item_footer"]),
        footer: json["footer"] == null
            ? null
            : List<Footer>.from(json["footer"].map((x) => Footer.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "header": header == null
            ? null
            : List<dynamic>.from(header!.map((x) => x.toJson())),
        "item": item == null
            ? null
            : List<dynamic>.from(item!.map((x) => x.toJson())),
        "item_footer": itemFooter?.toJson(),
        "footer": footer == null
            ? null
            : List<dynamic>.from(footer!.map((x) => x.toJson())),
      };
}

class Footer {
  Footer({
    this.title,
    this.body1,
    this.bold = false,
    this.size = 1,
    this.style,
    this.sortOrder,
    this.alignRight = true,
    this.isDivider = false,
  });

  String? title;
  String? body1;
  bool bold;
  int size;
  String? style;
  int? sortOrder;
  bool alignRight;
  bool isDivider;

  factory Footer.fromJson(Map<String, dynamic> json) => Footer(
        title: json["title"],
        body1: json["body1"],
      );

  Map<String, dynamic> toJson() => {
        "title": title,
        "body1": body1,
      };
}

enum StkViewFontStyle { Bold, Normal, Italic }

class Item {
  Item({
    this.itemHeader,
    this.itemBody,
    this.sortNumber,
    this.isSpliter,
    this.groupItem,
  });

  ItemFooterElement? itemHeader;
  List<ItemFooterElement>? itemBody;

  /// print either itemBody or group item, whereever the data | try to print both, only one will have the data
  int? sortNumber;
  bool? isSpliter;
  List<Item>? groupItem;

  factory Item.fromJson(Map<String, dynamic> json) => Item(
        itemHeader: json["item_header"] == null
            ? null
            : ItemFooterElement.fromJson(json["item_header"]),
        itemBody: json["item_body"] == null
            ? null
            : List<ItemFooterElement>.from(
                json["item_body"].map((x) => ItemFooterElement.fromJson(x))),
        isSpliter: json["is_spliter"],
        sortNumber: json["sort_number"],
        groupItem: json["group_item"] == null
            ? null
            : List<Item>.from(json["group_item"].map((x) => Item.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "item_header": itemHeader?.toJson(),
        "item_body": itemBody == null
            ? null
            : List<dynamic>.from(itemBody!.map((x) => x.toJson())),
        "is_spliter": isSpliter,
        "sort_number": sortNumber,
        "group_item": groupItem == null
            ? null
            : List<dynamic>.from(groupItem!.map((x) => x.toJson())),
      };
}

class ItemFooterElement {
  ItemFooterElement({
    this.title,
    // this.body1,
    this.body2,
    this.body3,
    this.isFirstLine,
    this.isReverseText,
    this.bold = false,
    this.size = 1,
    this.underline = false,
    this.itemSpace,
    this.doubleUpDivider = false,
  });

  String? title;
  // String? body1;
  String? body2;
  String? body3;
  bool? isFirstLine;
  bool? isReverseText;
  bool bold;
  int size;
  bool underline;
  double? itemSpace;
  bool doubleUpDivider;

  factory ItemFooterElement.fromJson(Map<String, dynamic> json) =>
      ItemFooterElement(
        title: json["title"],
        // body1: json["body1"],
        body2: json["body2"],
        body3: json["body3"],
      );

  Map<String, dynamic> toJson() => {
        "title": title,
        // "body1": body1,
        "body2": body2,
        "body3": body3,
      };
}

enum PrinterTextStyle { Normal, Bold }

class SubtitleList {
  SubtitleList({
    required this.text,
    this.style = PrinterTextStyle.Normal,
    this.size = 1,
  });

  String text;
  PrinterTextStyle style;
  int size;

  factory SubtitleList.fromJson(Map<String, dynamic> json) => SubtitleList(
        text: json["text"],
        style:
            PrinterTextStyle.values.firstWhere((e) => e.name == json["style"]),
      );

  Map<String, dynamic> toJson() => {
        "text": text,
        "style": style.name,
      };
}

final printerData = {
  "image": "",
  "title": "",
  "subtitle": "",
  "subtitle_list": [
    {
      "text": "",
      "style": "bold",
    },
    {
      "text": "",
      "style": "bold",
    },
  ],
  "body": {
    "header": [
      {"title": "", "body1": ""}
    ],
    "item": [
      {
        "item_header": {"title": "1", "body1": "", "body2": "", "body3": ""},
        "item_body": [
          {"title": "1", "body1": "", "body2": "", "body3": ""},
          {"title": "1", "body1": "", "body2": "", "body3": ""}
        ]
      }
    ],
    "item_footer": {"title": "1", "body1": "", "body2": "", "body3": ""},
    "footer": [
      {"title": "", "body1": ""}
    ]
  },
  "footer_list": ["", ""]
};
