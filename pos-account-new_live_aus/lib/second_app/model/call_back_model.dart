import 'package:pos_account/config/dual_display/dual_display_config.dart';
import 'package:pos_account/model/common/table_location.dart';
import 'package:pos_account/model/home/menu/place_order/place_order_req.dart';
import 'package:pos_account/providers/menu/place_order_pro.dart';
import '../../model/ui_model/amount_class.dart';

class CallBackModel {
  final String curSym;
  final bool isPaymentScreen;
  final double scrollValue;
  //
  final List<OrderDetail> orderList;
  final List<SetMenuOrderDetail> setMenuList;
  final List<RawIngredientOrderDetail> ingreList;
  //
  final ReOrder? reOrder;
  //
  final String descText;
  final bool isDelivery;
  final String delivertAmtText;
  final double itemPrice;
  // final double taxPercent;
  final double taxAmount;
  final double totalAmount;
  final TaxType taxType;

  //
  final String? discountPercent;
  final String? discountAmount;
  final String? pubSurAmount;
  final String? creSurPercent;
  final String? sCPercent;
  final String? creSurAmount;
  final String? serviceChargeAmount;
  final String? paidAmount;
  final String? comments;

  // qr image
  final String? qrImageUrl;

  //
  List<String> screenImageList;

  //
  AdsPattern? adsPattern;

  // item status
  List<TableLocation>? statusList;

  CallBackModel({
    this.curSym = '',
    this.isPaymentScreen = false,
    this.scrollValue = 0.0,
    //
    this.orderList = const [],
    this.setMenuList = const [],
    this.ingreList = const [],
    //
    this.reOrder,
    //
    this.descText = "",
    this.isDelivery = false,
    this.delivertAmtText = "",
    this.itemPrice = 0.0,
    // this.taxPercent = 0.0,
    this.taxAmount = 0.0,
    this.totalAmount = 0.0,
    this.taxType = TaxType.NoTax,

    //
    this.discountPercent,
    this.discountAmount,
    this.pubSurAmount,
    this.creSurPercent,
    this.sCPercent,
    this.creSurAmount,
    this.serviceChargeAmount,
    this.paidAmount,
    this.comments,

    //
    this.qrImageUrl,

    //
    this.screenImageList = const [],
    //
    this.adsPattern,
    //
    this.statusList,
  });

  factory CallBackModel.fromJson(Map<String, dynamic> json) => CallBackModel(
        curSym: json["curSym"],
        isPaymentScreen: json["isPaymentScreen"],
        descText: json["descText"],
        isDelivery: json["isDelivery"],
        delivertAmtText: json["delivertAmtText"],
        orderList: json["orderList"] == null
            ? []
            : List<OrderDetail>.from(
                json["orderList"]!.map((x) => OrderDetail.fromJson(x))),
        setMenuList: json["setMenuList"] == null
            ? []
            : List<SetMenuOrderDetail>.from(json["setMenuList"]!
                .map((x) => SetMenuOrderDetail.fromJson(x))),
        ingreList: json["ingreList"] == null
            ? []
            : List<RawIngredientOrderDetail>.from(json["ingreList"]!
                .map((x) => RawIngredientOrderDetail.fromJson(x))),
        reOrder:
            json["reOrder"] == null ? null : ReOrder.fromJson(json["reOrder"]),
        discountPercent: json["discountPercent"],
        discountAmount: json["discountAmount"],
        pubSurAmount: json["pubSurAmount"],
        creSurPercent: json["creSurPercent"],
        sCPercent: json["sCPercent"],
        creSurAmount: json["creSurAmount"],
        serviceChargeAmount: json["serviceChargeAmount"],
        // taxPercent: json["taxPercent"]?.toDouble(),
        taxAmount: json["taxAmount"]?.toDouble(),
        itemPrice: json["itemPrice"]?.toDouble(),
        totalAmount: json["totalAmount"]?.toDouble(),
        paidAmount: json["paidAmount"],
        comments: json["comments"],
        taxType: TaxType.values.firstWhere((e) => e.name == json["taxType"]),
        scrollValue: json["scrollValue"]?.toDouble(),
        screenImageList: json["screenImageList"] == null
            ? []
            : List<String>.from(json["screenImageList"]!.map((x) => x)),
        adsPattern: json["adsPattern"] == null
            ? null
            : AdsPattern.fromJson(json["adsPattern"]),
        qrImageUrl: json["qrImageUrl"],
        statusList: json["statusList"] == null
            ? []
            : List<TableLocation>.from(
                json["statusList"]!.map((x) => TableLocation.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "curSym": curSym,
        "isPaymentScreen": isPaymentScreen,
        "descText": descText,
        "isDelivery": isDelivery,
        "delivertAmtText": delivertAmtText,
        "orderList": List<dynamic>.from(orderList.map((x) => x.toJson())),
        "setMenuList": List<dynamic>.from(setMenuList.map((x) => x.toJson())),
        "ingreList": List<dynamic>.from(ingreList.map((x) => x.toJson())),
        "reOrder": reOrder?.toJson(),
        "discountPercent": discountPercent,
        "discountAmount": discountAmount,
        "pubSurAmount": pubSurAmount,
        "creSurPercent": creSurPercent,
        "sCPercent": sCPercent,
        "creSurAmount": creSurAmount,
        "serviceChargeAmount": serviceChargeAmount,
        // "taxPercent": taxPercent,
        "taxAmount": taxAmount,
        "itemPrice": itemPrice,
        "totalAmount": totalAmount,
        "paidAmount": paidAmount,
        "comments": comments,
        "taxType": taxType.name,
        "scrollValue": scrollValue,
        "screenImageList": List<dynamic>.from(screenImageList.map((x) => x)),
        "adsPattern": adsPattern?.toJson(),
        "qrImageUrl": qrImageUrl,
        "statusList": statusList == null
            ? []
            : List<dynamic>.from(statusList!.map((x) => x.toJson())),
      };
}

class AdsPattern {
  DualDisPattern? pattern;
  List<String>? imagePathList;
  String? videoPath;
  AdProductData? adProductData;

  AdsPattern({
    this.pattern,
    this.imagePathList,
    this.videoPath,
    this.adProductData,
  });

  factory AdsPattern.fromJson(Map<String, dynamic> json) => AdsPattern(
        pattern: json["pattern"] == null ||
                !DualDisPattern.values.any((e) => e.name == json["pattern"])
            ? null
            : DualDisPattern.values
                .firstWhere((e) => e.name == json["pattern"]),
        imagePathList: json["imagePathList"] == null
            ? []
            : List<String>.from(json["imagePathList"]!.map((x) => x)),
        videoPath: json["videoPath"],
        adProductData: json["adProductData"] == null
            ? null
            : AdProductData.fromJson(json["adProductData"]),
      );

  Map<String, dynamic> toJson() => {
        "pattern": pattern?.name,
        "imagePathList": imagePathList == null
            ? []
            : List<dynamic>.from(imagePathList!.map((x) => x)),
        "videoPath": videoPath,
        "adProductData": adProductData?.toJson(),
      };
}

class AdProductData {
  String? productId;
  String? productName;
  String? price;
  String? quantity;
  String? image;

  AdProductData({
    this.productId,
    this.productName,
    this.price,
    this.quantity,
    this.image,
  });

  factory AdProductData.fromJson(Map<String, dynamic> json) => AdProductData(
        productId: json["productId"],
        productName: json["productName"],
        price: json["price"]?.toDouble(),
        quantity: json["quantity"]?.toDouble(),
        image: json["image"],
      );

  Map<String, dynamic> toJson() => {
        "productId": productId,
        "productName": productName,
        "price": price,
        "quantity": quantity,
        "image": image,
      };
}
