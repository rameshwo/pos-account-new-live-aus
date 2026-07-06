import 'package:pos_account/model/common/table_location.dart';
import 'package:pos_account/model/home/menu/place_order/pos_res/order_type_res.dart';

import 'store_information.dart';

class PosScreenAddSec {
  List<TableLocation>? staffs; // notInNew
  // StoreTaxSettings? storeTaxSettings;
  List<TableLocation>? tables;
  List<TableLocation>? brands;
  List<OrderTypeRes>? orderTypes;
  List<TableLocation>? docketGroups;
  // List<TableLocation>? alphabets;

  String? message; // notInNew
  bool? isSubscriptionActive; // notInNew
  // PosDeliveryStoreInformation? posDeliveryStoreInformation;
  // StoreStockDeductInformation? storeStockDeductInformation;
  List<TableLocation>? orderItemStatus;
  List<TableLocation>? menus;
  StoreInformation? storeInformation;

  PosScreenAddSec({
    this.staffs,
    // this.storeTaxSettings,
    this.tables,
    this.brands,
    this.orderTypes,
    this.docketGroups,
    this.message,
    this.isSubscriptionActive,
    // this.posDeliveryStoreInformation,
    // this.storeStockDeductInformation,
    // this.alphabets,
    this.orderItemStatus,
    this.menus,
    this.storeInformation,
  });

  factory PosScreenAddSec.fromJson(Map<String, dynamic> json) =>
      PosScreenAddSec(
        staffs: json["staffs"] == null
            ? []
            : List<TableLocation>.from(
                json["staffs"]!.map((x) => TableLocation.fromJson(x))),
        // storeTaxSettings: json["storeTaxSettings"] == null
        //     ? null
        //     : StoreTaxSettings.fromJson(json["storeTaxSettings"]),
        tables: json["tables"] == null
            ? []
            : List<TableLocation>.from(
                json["tables"]!.map((x) => TableLocation.fromJson(x))),
        brands: json["brands"] == null
            ? []
            : List<TableLocation>.from(
                json["brands"]!.map((x) => TableLocation.fromJson(x))),
        orderTypes: json["posOrderTypes"] == null
            ? []
            : List<OrderTypeRes>.from(
                json["posOrderTypes"]!.map((x) => OrderTypeRes.fromJson(x))),
        message: json["message"],
        isSubscriptionActive: json["isSubscriptionActive"],
        // posDeliveryStoreInformation: json["posDeliveryStoreInformation"] == null
        //     ? null
        //     : PosDeliveryStoreInformation.fromJson(
        //         json["posDeliveryStoreInformation"]),
        // storeStockDeductInformation: json["storeStockDeductInformation"] == null
        //     ? null
        //     : StoreStockDeductInformation.fromJson(
        //         json["storeStockDeductInformation"]),
        docketGroups: json["docketGroups"] == null
            ? []
            : List<TableLocation>.from(
                json["docketGroups"]!.map((x) => TableLocation.fromJson(x))),
        // alphabets: json["alphabets"] == null
        //     ? []
        //     : List<TableLocation>.from(
        //         json["alphabets"]!.map((x) => TableLocation.fromJson(x))),
        orderItemStatus: json["orderItemStatus"] == null
            ? []
            : List<TableLocation>.from(
                json["orderItemStatus"]!.map((x) => TableLocation.fromJson(x))),
        menus: json["menus"] == null
            ? []
            : List<TableLocation>.from(
                json["menus"]!.map((x) => TableLocation.fromJson(x))),
        storeInformation: json["storeInformation"] == null
            ? null
            : StoreInformation.fromJson(json["storeInformation"]),
      );

  Map<String, dynamic> toJson() => {
        "staffs": staffs == null
            ? []
            : List<dynamic>.from(staffs!.map((x) => x.toJson())),
        // "storeTaxSettings": storeTaxSettings?.toJson(),
        "tables": tables == null
            ? []
            : List<dynamic>.from(tables!.map((x) => x.toJson())),
        "brands": brands == null
            ? []
            : List<dynamic>.from(brands!.map((x) => x.toJson())),
        "posOrderTypes": orderTypes == null
            ? []
            : List<dynamic>.from(orderTypes!.map((x) => x.toJson())),
        "message": message,
        "isSubscriptionActive": isSubscriptionActive,
        // "posDeliveryStoreInformation": posDeliveryStoreInformation?.toJson(),
        // "storeStockDeductInformation": storeStockDeductInformation?.toJson(),
        "docketGroups": docketGroups == null
            ? []
            : List<dynamic>.from(docketGroups!.map((x) => x.toJson())),
        // "alphabets": alphabets == null
        //     ? []
        //     : List<dynamic>.from(alphabets!.map((x) => x.toJson())),
        "orderItemStatus": orderItemStatus == null
            ? []
            : List<dynamic>.from(orderItemStatus!.map((x) => x.toJson())),
        "menus": menus == null
            ? []
            : List<dynamic>.from(menus!.map((x) => x.toJson())),
        "storeInformation": storeInformation?.toJson(),
      };
}

// class StoreStockDeductInformation {
//   bool? isFiFo;
//   bool? isBatch;
//   bool? enableOutOfStockSales;

//   StoreStockDeductInformation({
//     this.isFiFo,
//     this.isBatch,
//     this.enableOutOfStockSales,
//   });

//   factory StoreStockDeductInformation.fromJson(Map<String, dynamic> json) =>
//       StoreStockDeductInformation(
//         isFiFo: json["isFiFo"],
//         isBatch: json["isBatch"],
//         enableOutOfStockSales: json["enableOutOfStockSales"],
//       );

//   Map<String, dynamic> toJson() => {
//         "isFiFo": isFiFo,
//         "isBatch": isBatch,
//         "enableOutOfStockSales": enableOutOfStockSales,
//       };
// }
