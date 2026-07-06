// import 'package:pos_account/model/profile/user_add_sec.dart';

class DashboardRes {
  DashboardRes({
    this.dashBoardStatisticsToday,
    this.salesByCategoryModel,
    this.salesChannelModel,
    this.salesByCurrentYear,
    this.salesByPreviousYear,
    this.paymentMethodModel,
    // this.dashboardInfoModel,
    this.recommendedProductsModel,
    this.availableChannels,
    this.employeeSalesModel,
  });

  DashBoardStatisticsToday? dashBoardStatisticsToday;
  List<SalesByCategoryModel>? salesByCategoryModel;
  List<SalesChannelModel>? salesChannelModel;
  List<SalesByYear>? salesByCurrentYear;
  List<SalesByYear>? salesByPreviousYear;
  List<PaymentMethodModel>? paymentMethodModel;
  // List<UserAddSecData>? dashboardInfoModel;
  List<RecommendedProductsModel>? recommendedProductsModel;
  List<AvailiableChannel>? availableChannels;
  List<EmployeeSalesModel>? employeeSalesModel;

  factory DashboardRes.fromJson(Map<String, dynamic> json) => DashboardRes(
        dashBoardStatisticsToday: json["dashBoardStatisticsToday"] == null
            ? null
            : DashBoardStatisticsToday.fromJson(
                json["dashBoardStatisticsToday"]),
        salesByCategoryModel: json["salesByCategoryModel"] == null
            ? []
            : List<SalesByCategoryModel>.from(json["salesByCategoryModel"]!
                .map((x) => SalesByCategoryModel.fromJson(x))),
        salesChannelModel: json["salesChannelModel"] == null
            ? []
            : List<SalesChannelModel>.from(json["salesChannelModel"]!
                .map((x) => SalesChannelModel.fromJson(x))),
        salesByCurrentYear: json["salesByCurrentYear"] == null
            ? []
            : List<SalesByYear>.from(json["salesByCurrentYear"]!
                .map((x) => SalesByYear.fromJson(x))),
        salesByPreviousYear: json["salesByPreviousYear"] == null
            ? []
            : List<SalesByYear>.from(json["salesByPreviousYear"]!
                .map((x) => SalesByYear.fromJson(x))),
        paymentMethodModel: json["paymentMethodModel"] == null
            ? []
            : List<PaymentMethodModel>.from(json["paymentMethodModel"]!
                .map((x) => PaymentMethodModel.fromJson(x))),
        // dashboardInfoModel: json["dashboardInfoModel"] == null
        //     ? []
        //     : List<UserAddSecData>.from(json["dashboardInfoModel"]!
        //         .map((x) => UserAddSecData.fromJson(x))),
        recommendedProductsModel: json["recommendedProductsModel"] == null
            ? []
            : List<RecommendedProductsModel>.from(
                json["recommendedProductsModel"]!
                    .map((x) => RecommendedProductsModel.fromJson(x))),
        availableChannels: json["availableChannels"] == null
            ? []
            : List<AvailiableChannel>.from(json["availableChannels"]!
                .map((x) => AvailiableChannel.fromJson(x))),
        employeeSalesModel: json["employeeSalesModel"] == null
            ? []
            : List<EmployeeSalesModel>.from(json["employeeSalesModel"]!
                .map((x) => EmployeeSalesModel.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "dashBoardStatisticsToday": dashBoardStatisticsToday?.toJson(),
        "salesByCategoryModel": salesByCategoryModel == null
            ? []
            : List<dynamic>.from(salesByCategoryModel!.map((x) => x.toJson())),
        "salesChannelModel": salesChannelModel == null
            ? []
            : List<dynamic>.from(salesChannelModel!.map((x) => x.toJson())),
        "salesByCurrentYear": salesByCurrentYear == null
            ? []
            : List<dynamic>.from(salesByCurrentYear!.map((x) => x.toJson())),
        "salesByPreviousYear": salesByPreviousYear == null
            ? []
            : List<dynamic>.from(salesByPreviousYear!.map((x) => x.toJson())),
        // "paymentMethodModel": paymentMethodModel == null
        //     ? []
        //     : List<dynamic>.from(paymentMethodModel!.map((x) => x.toJson())),
        // "dashboardInfoModel": dashboardInfoModel == null
        //     ? []
        //     : List<dynamic>.from(dashboardInfoModel!.map((x) => x.toJson())),
        "recommendedProductsModel": recommendedProductsModel == null
            ? []
            : List<dynamic>.from(
                recommendedProductsModel!.map((x) => x.toJson())),
        "availableChannels": availableChannels == null
            ? []
            : List<dynamic>.from(availableChannels!.map((x) => x.toJson())),
        "employeeSalesModel": employeeSalesModel == null
            ? []
            : List<dynamic>.from(employeeSalesModel!.map((x) => x.toJson())),
      };
}

class DashBoardStatisticsToday {
  DashBoardStatisticsToday({
    this.totalSales,
    this.totalOrders,
    this.totalRefund,
    this.totalCustomer,
    this.totalDiscount,
    this.totalTax,
  });

  String? totalSales;
  String? totalOrders;
  String? totalRefund;
  String? totalCustomer;
  String? totalDiscount;
  String? totalTax;

  factory DashBoardStatisticsToday.fromJson(Map<String, dynamic> json) =>
      DashBoardStatisticsToday(
        totalSales: json["totalSales"],
        totalOrders: json["totalOrders"],
        totalRefund: json["totalRefund"],
        totalCustomer: json["totalCustomer"],
        totalDiscount: json["totalDiscount"],
        totalTax: json["totalTax"],
      );

  Map<String, dynamic> toJson() => {
        "totalSales": totalSales,
        "totalOrders": totalOrders,
        "totalRefund": totalRefund,
        "totalCustomer": totalCustomer,
        "totalDiscount": totalDiscount,
        "totalTax": totalTax,
      };
}

class SalesByCategoryModel {
  SalesByCategoryModel({
    this.categoryName,
    this.totalSales,
  });

  String? categoryName;
  String? totalSales;

  factory SalesByCategoryModel.fromJson(Map<String, dynamic> json) =>
      SalesByCategoryModel(
        categoryName: json["categoryName"],
        totalSales: json["totalSales"],
      );

  Map<String, dynamic> toJson() => {
        "categoryName": categoryName,
        "totalSales": totalSales,
      };
}

class SalesByYear {
  SalesByYear({
    this.month,
    this.totalSales,
  });

  String? month;
  String? totalSales;

  factory SalesByYear.fromJson(Map<String, dynamic> json) => SalesByYear(
        month: json["month"],
        totalSales: json["totalSales"],
      );

  Map<String, dynamic> toJson() => {
        "month": month,
        "totalSales": totalSales,
      };
}

class SalesChannelModel {
  SalesChannelModel({
    this.channelName,
    this.salesChannelMonthModel,
  });

  String? channelName;
  List<SalesChannelMonthModel>? salesChannelMonthModel;

  factory SalesChannelModel.fromJson(Map<String, dynamic> json) =>
      SalesChannelModel(
        channelName: json["channelName"],
        salesChannelMonthModel: json["salesChannelMonthModel"] == null
            ? []
            : List<SalesChannelMonthModel>.from(json["salesChannelMonthModel"]!
                .map((x) => SalesChannelMonthModel.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "channelName": channelName,
        "salesChannelMonthModel": salesChannelMonthModel == null
            ? []
            : List<dynamic>.from(
                salesChannelMonthModel!.map((x) => x.toJson())),
      };
}

class SalesChannelMonthModel {
  SalesChannelMonthModel({
    this.channelName,
    this.totalSales,
    this.month,
    this.year,
  });

  String? channelName;
  String? totalSales;
  String? month;
  String? year;

  factory SalesChannelMonthModel.fromJson(Map<String, dynamic> json) =>
      SalesChannelMonthModel(
        channelName: json["channelName"],
        totalSales: json["totalSales"],
        month: json["monthName"],
        year: json["year"],
      );

  Map<String, dynamic> toJson() => {
        "channelName": channelName,
        "totalSales": totalSales,
        "monthName": month,
        "year": year,
      };
}

class PaymentMethodModel {
  PaymentMethodModel({
    this.paymentMethodName,
    this.totalSales,
    this.imageUrl,
  });

  String? paymentMethodName;
  String? totalSales;
  String? imageUrl;

  factory PaymentMethodModel.fromJson(Map<String, dynamic> json) =>
      PaymentMethodModel(
        paymentMethodName: json["paymentMethodName"],
        totalSales: json["totalSales"],
        imageUrl: json["imageUrl"],
      );

  Map<String, dynamic> toJson() => {
        "paymentMethodName": paymentMethodName,
        "totalSales": totalSales,
        "imageUrl": imageUrl,
      };
}

class RecommendedProductsModel {
  RecommendedProductsModel({
    this.productName,
    this.count,
    this.imageUrl,
    this.image,
  });

  String? productName;
  String? count;
  String? imageUrl;
  String? image;

  factory RecommendedProductsModel.fromJson(Map<String, dynamic> json) =>
      RecommendedProductsModel(
        productName: json["productName"] ?? json["name"],
        count: json["count"],
        imageUrl: json["imageUrl"],
        image: json["image"],
      );

  Map<String, dynamic> toJson() => {
        "productName": productName,
        "count": count,
        "imageUrl": imageUrl,
        "image": image,
      };
}

class AvailiableChannel {
  String? id;
  String? channelName;
  String? image;
  String? imageUrl;
  bool? isAvailableOnChannel;
  bool? isCentralizedChannel;
  bool? needSubscription;
  String? channelEnum;

  AvailiableChannel({
    this.id,
    this.channelName,
    this.image,
    this.imageUrl,
    this.isAvailableOnChannel,
    this.isCentralizedChannel,
    this.needSubscription,
    this.channelEnum,
  });

  factory AvailiableChannel.fromJson(Map<String, dynamic> json) =>
      AvailiableChannel(
        id: json["id"],
        channelName: json["channelName"],
        image: json["image"],
        imageUrl: json["imageUrl"],
        isAvailableOnChannel: json["isAvailableOnChannel"],
        isCentralizedChannel: json["isCentralizedChannel"],
        needSubscription: json["needSubscription"],
        channelEnum: json["channelEnum"].toString(),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "channelName": channelName,
        "image": image,
        "imageUrl": imageUrl,
        "isAvailableOnChannel": isAvailableOnChannel,
        "isCentralizedChannel": isCentralizedChannel,
        "needSubscription": needSubscription,
        "channelEnum": channelEnum,
      };
}

class EmployeeSalesModel {
  String? employeeName;
  String? netSales;
  String? orderItemCount;

  EmployeeSalesModel({
    this.employeeName,
    this.netSales,
    this.orderItemCount,
  });

  factory EmployeeSalesModel.fromJson(Map<String, dynamic> json) =>
      EmployeeSalesModel(
        employeeName: json["employeeName"],
        netSales: json["netSales"],
        orderItemCount: json["orderItemCount"],
      );

  Map<String, dynamic> toJson() => {
        "employeeName": employeeName,
        "netSales": netSales,
        "orderItemCount": orderItemCount,
      };
}
