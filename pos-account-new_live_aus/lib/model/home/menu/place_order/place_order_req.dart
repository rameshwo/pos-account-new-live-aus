import 'package:pos_account/config/validator.dart';
import 'package:pos_account/model/common/table_id_name.dart';
import 'package:pos_account/model/ui_model/amount_class.dart';
import 'po_make_pay_req.dart';
import 'pos_res/com/feature_product.dart';

class PlaceOrderReq {
  PlaceOrderReq({
    this.orderId,
    // this.tableId,
    this.tables,
    this.staffId,
    // this.customerName,
    this.totalAmount,
    this.taxAmount,
    this.totalWithoutTaxAmount,
    this.description,
    // this.channelPlatForm,
    this.orderTypeStoreId,
    this.isRetail = false,
    this.isSendToKitchen,
    this.noOfCustomerOnTable,
    this.stockDeductType,
    this.orderDetails,
    this.setMenuOrderDetails,
    this.orderDeliveryRequestModel,
    this.customerAddRequestModel,
    this.rawIngredientOrderDetails,
    this.isItemQuantiyChangeFromPaymentScreen = false,
    this.orderTabId,
    this.deviceIdentifierId,
    this.isSendToKitchenPrinter,
    this.isSendToKitchenDisplay,
  });

  String? orderId;
  // String? tableId;
  List<TableIdName>? tables;
  String? staffId;
  // String? customerName;
  String? totalAmount;
  String? taxAmount;
  String? totalWithoutTaxAmount;
  String? description;
  // String? channelPlatForm;
  String? orderTypeStoreId;
  bool isRetail;
  bool? isSendToKitchen;
  String? noOfCustomerOnTable;
  String? stockDeductType;
  List<OrderDetail>? orderDetails;
  List<SetMenuOrderDetail>? setMenuOrderDetails;
  OrderDeliveryRequestModel? orderDeliveryRequestModel;
  CustomerViewModel? customerAddRequestModel;
  List<RawIngredientOrderDetail>? rawIngredientOrderDetails;
  bool isItemQuantiyChangeFromPaymentScreen;
  String? orderTabId;
  String? deviceIdentifierId;
  bool? isSendToKitchenPrinter;
  bool? isSendToKitchenDisplay;

  factory PlaceOrderReq.fromJson(Map<String, dynamic> json) => PlaceOrderReq(
        orderId: json["OrderId"],
        // tableId: json["TableId"],
        tables: json["tables"] == null
            ? []
            : List<TableIdName>.from(
                json["tables"]!.map((x) => TableIdName.fromJson(x))),
        staffId: json["StaffId"],
        // customerName: json["CustomerName"],
        totalAmount: json["TotalAmount"],
        taxAmount: json["TaxAmount"],
        totalWithoutTaxAmount: json["TotalWithoutTaxAmount"],
        description: json["Description"],
        // channelPlatForm: json["ChannelPlatForm"],
        orderTypeStoreId: json["OrderTypeId"],
        isRetail: json["IsRetail"],
        isSendToKitchen: json["IsSendToKitchen"],
        noOfCustomerOnTable: json["NoOfCustomerOnTable"],
        stockDeductType: json["StockDeductType"],
        orderDetails: json["OrderItemsViewModels"] == null
            ? null
            : List<OrderDetail>.from(json["OrderItemsViewModels"]
                .map((x) => OrderDetail.fromJson(x))),
        setMenuOrderDetails: json["SetMenuOrderDetails"] == null
            ? null
            : List<SetMenuOrderDetail>.from(json["SetMenuOrderDetails"]
                .map((x) => SetMenuOrderDetail.fromJson(x))),
        orderDeliveryRequestModel: json["OrderDeliveryRequestModel"] == null
            ? null
            : OrderDeliveryRequestModel.fromJson(
                json["OrderDeliveryRequestModel"]),
        customerAddRequestModel: json["CustomerAddRequestModel"] == null
            ? null
            : CustomerViewModel.fromJson(json["CustomerAddRequestModel"]),
        rawIngredientOrderDetails:
            json["RawLooseIngredientOrderDetails"] == null
                ? []
                : List<RawIngredientOrderDetail>.from(
                    json["RawLooseIngredientOrderDetails"]!
                        .map((x) => RawIngredientOrderDetail.fromJson(x))),
        isItemQuantiyChangeFromPaymentScreen:
            json["IsItemQuantiyChangeFromPaymentScreen"],
        orderTabId: json["orderTabId"],
        deviceIdentifierId: json["DeviceIdentifierId"],
        isSendToKitchenPrinter: json["IsSendToKitchenPrinter"],
        isSendToKitchenDisplay: json["IsSendToKitchenDisplay"],
      );

  Map<String, dynamic> toJson() => {
        "OrderId": orderId,
        // "TableId": tableId,
        "tables": tables == null
            ? []
            : List<dynamic>.from(tables!.map((x) => x.toJson())),
        "StaffId": staffId,
        // "CustomerName": customerName,
        "TotalAmount": totalAmount,
        "TaxAmount": taxAmount,
        "TotalWithoutTaxAmount": totalWithoutTaxAmount,
        "Description": description,
        // "ChannelPlatForm": channelPlatForm,
        "OrderTypeId": orderTypeStoreId,
        "IsRetail": isRetail,
        "IsSendToKitchen": isSendToKitchen,
        "NoOfCustomerOnTable": noOfCustomerOnTable,
        "StockDeductType": stockDeductType,
        "OrderItemsViewModels": orderDetails == null
            ? null
            : List<dynamic>.from(orderDetails!.map((x) => x.toJson())),
        "SetMenuOrderDetails": setMenuOrderDetails == null
            ? null
            : List<dynamic>.from(setMenuOrderDetails!.map((x) => x.toJson())),
        "OrderDeliveryRequestModel": orderDeliveryRequestModel?.toJson(),
        "CustomerAddRequestModel": customerAddRequestModel?.toJson(),
        "RawLooseIngredientOrderDetails": rawIngredientOrderDetails == null
            ? []
            : List<dynamic>.from(
                rawIngredientOrderDetails!.map((x) => x.toJson())),
        "IsItemQuantiyChangeFromPaymentScreen":
            isItemQuantiyChangeFromPaymentScreen,
        "orderTabId": orderTabId,
        "DeviceIdentifierId": deviceIdentifierId,
        "IsSendToKitchenPrinter": isSendToKitchenPrinter,
        "IsSendToKitchenDisplay": isSendToKitchenDisplay,
      };
}

class OrderDetail {
  OrderDetail({
    this.id,
    this.productId,
    this.productName,
    this.description = "",
    this.productPrice,
    this.quantity,
    this.productVariationId,
    this.total,
    this.productVariationName,
    this.originalSellingAmount,
    this.discountWithoutTax,
    this.totalTax,
    this.unitCost,
    // this.categoryTypeId,
    // this.isCancelled,
    this.orderItemModifiersViewModels,
    this.orderItemSelectOptionsViewModels,
    this.deletedOrderItemModifierIds,
    this.deletedOrderItemSelectOptionsIds,
    // this.orderItemSpiceChoiceViewModel,
    this.docketGroupId,
    this.docketGroupName,
    this.docketGroupSort,
    this.paymentType,
    this.enableDocketGroupSpliter = false,
    this.discountWithTax,
    this.discountPercentage,
    this.statusId,
    // this.halfGroupKey,
    // this.halfGroupAmount,
    // this.removedOrderItemsIngredientsViewModels,
    // this.deletedRemovedOrderItemIngredientsIds,
    this.deletedModifierItemModifierIds,
    // this.isHalfItem = false,

    ///
    this.imgPath,
    this.taxPercent = 0.0,
    this.taxType,
    this.catId,
    // this.drawerI,
    // this.orderTypeI,
    this.curSym = "",
    this.actualPrice,
    this.initQty = 1,
    this.key,
    this.stockCount,
    this.isSelected = true,
    this.paidQuantity = 0,
    this.currentPayQty = 0,
    this.partialPayQty = 0,
    this.disabled = false,
    // this.halfGroupTotalAmount = 0.0,
    this.isRawIngre = false,
    //
    this.finalTotalSellingAmount = 0.0,
    this.finalTotalTax = 0.0,
    this.finalReTotalSellingAmount,
    this.finalReTotalTax,
    this.finalReTotalDiscount,
    this.finalReTotalDiscountWithTax,
    this.preparationType,
    this.isTaxExempt = false,
    //
    // this.promDiscount,
    this.nonPromPrice,
    this.batchNumber,
    this.isBatchExpired = false,
    this.batchStock,
    this.batchId,
    this.orderItemsServiceEmployeeViewModels,
    this.deletedOrderItemServiceEmployeeIds,
    this.outOfStockMessage,
    this.bookedTime,
    this.productType,
    this.productPriceType,
    this.isPubChargeEnable,
    this.isCreditChargeEnable,
    this.isServiceChargeEnable,
    this.kitchenStatus,
    this.customPrice,
    this.taxRules,
    this.taxRuleIndex = 0,
    this.groupSelect = false,
  });

  String? id;
  String? productId;
  String? productName;
  String description;
  double? productPrice;
  double? quantity;
  String? productVariationId;
  double? total;
  String? productVariationName;
  String? originalSellingAmount;
  String? discountWithoutTax;
  String? totalTax;
  int? paymentType;
  String? unitCost;
  // String? categoryTypeId;
  // bool? isCancelled;
  List<OrderItemsPriceModifierViewModel>? orderItemModifiersViewModels;
  List<OrderItemSelectOptionsViewModels>? orderItemSelectOptionsViewModels;
  List<DeletedOrderItemId>? deletedOrderItemModifierIds;
  List<DeletedOrderItemId>? deletedOrderItemSelectOptionsIds;
  // OrderItemSpiceChoiceViewModel? orderItemSpiceChoiceViewModel;
  String? docketGroupName;
  String? docketGroupId;
  String? docketGroupSort;
  bool enableDocketGroupSpliter;
  String? discountWithTax;
  String? discountPercentage;
  // String? halfGroupKey;
  // String? halfGroupAmount;
  // List<RemovedOrderItemsIngredientsViewModel>?
  //     removedOrderItemsIngredientsViewModels;
  // List<DeletedOrderItemId>? deletedRemovedOrderItemIngredientsIds;
  // bool isHalfItem;
  // eod report
  String? finalReTotalSellingAmount;
  String? finalReTotalTax;
  String? finalReTotalDiscount;
  String? finalReTotalDiscountWithTax;
  String? batchNumber;
  String? batchId;
  List<OrderItemsServiceEmployeeViewModel>? orderItemsServiceEmployeeViewModels;
  List<DeletedOrderItemId>? deletedOrderItemServiceEmployeeIds;
  List<DeletedOrderItemId>? deletedModifierItemModifierIds;
  String? statusId;
  String? preparationType;
  bool isTaxExempt;

  // not in use for server request
  String? imgPath;
  double taxPercent;
  TaxType? taxType;
  //to use in place order
  String? catId;
  // int? drawerI;
  // int? orderTypeI;
  String curSym;
  String? actualPrice;
  double initQty;
  String? key;
  final int? stockCount;
  // to view only paid product
  bool isSelected;
  double paidQuantity;
  double partialPayQty;
  double currentPayQty;
  //to show in orders
  bool disabled;

  // double halfGroupTotalAmount;
  bool isRawIngre;
  //  // eod report
  double finalTotalSellingAmount;
  double finalTotalTax;
  // discount prom
  // PromDiscount? promDiscount;
  String? nonPromPrice;
  bool isBatchExpired;
  final int? batchStock;
  String? outOfStockMessage;
  String? bookedTime;
  String? productType;
  String? productPriceType;
  bool? isPubChargeEnable;
  bool? isCreditChargeEnable;
  bool? isServiceChargeEnable;
  String? kitchenStatus;
  String? customPrice;
  List<TaxRule>? taxRules;
  int taxRuleIndex;
  bool groupSelect;

  factory OrderDetail.fromJson(Map<String, dynamic> json) => OrderDetail(
        id: json["Id"],
        productId: json["ProductId"],
        productName: json["ProductName"],
        description: json["Description"],
        productPrice: json["ProductPrice"] is String
            ? double.tryParse(json["ProductPrice"])
            : json["ProductPrice"],
        quantity: json["Quantity"] is String
            ? double.tryParse(json["Quantity"])
            : json["Quantity"],
        productVariationId: json["ProductVariationId"],
        total: json["Total"] is String
            ? double.tryParse(json["Total"])
            : json["Total"],
        productVariationName: json["ProductVariationName"],
        originalSellingAmount: json["OriginalSellingAmount"],
        discountWithoutTax: json["DiscountWithoutTax"],
        totalTax: json["TotalTax"],
        unitCost: json["UnitCost"],
        // categoryTypeId: json["CategoryTypeId"],
        // isCancelled: json["IsCancelled"],
        docketGroupId: json["DocketGroupId"],
        orderItemModifiersViewModels: json["OrderItemModifiersViewModels"] ==
                null
            ? null
            : List<OrderItemsPriceModifierViewModel>.from(
                json["OrderItemModifiersViewModels"]!
                    .map((x) => OrderItemsPriceModifierViewModel.fromJson(x))),
        orderItemSelectOptionsViewModels:
            json["OrderItemsSelectOptionsViewModels"] == null
                ? []
                : List<OrderItemSelectOptionsViewModels>.from(
                    json["OrderItemsSelectOptionsViewModels"]!.map(
                        (x) => OrderItemSelectOptionsViewModels.fromJson(x))),
        deletedOrderItemModifierIds: json["DeletedOrderItemModifierIds"] == null
            ? []
            : List<DeletedOrderItemId>.from(json["DeletedOrderItemModifierIds"]!
                .map((x) => DeletedOrderItemId.fromJson(x))),
        deletedOrderItemSelectOptionsIds:
            json["DeletedOrderItemSelectOptionsIds"] == null
                ? []
                : List<DeletedOrderItemId>.from(
                    json["DeletedOrderItemSelectOptionsIds"]!
                        .map((x) => DeletedOrderItemId.fromJson(x))),
        // orderItemSpiceChoiceViewModel:
        //     json["OrderItemSpiceChoiceViewModel"] == null
        //         ? null
        //         : OrderItemSpiceChoiceViewModel.fromJson(
        //             json["OrderItemSpiceChoiceViewModel"]),
        docketGroupName: json["DocketGroupName"],
        docketGroupSort: json["DocketGroupSort"],
        enableDocketGroupSpliter: json["EnableDocketGroupSpliter"],
        discountWithTax: json["DiscountWithTax"],
        discountPercentage: json["DiscountPercentage"],
        // halfGroupKey: json["HalfGroupKey"],
        // halfGroupAmount: json["HalfGroupAmount"],
        // removedOrderItemsIngredientsViewModels:
        //     json["RemovedOrderItemsIngredientsViewModels"] == null
        //         ? []
        //         : List<RemovedOrderItemsIngredientsViewModel>.from(
        //             json["RemovedOrderItemsIngredientsViewModels"]!.map((x) =>
        //                 RemovedOrderItemsIngredientsViewModel.fromJson(x))),
        // deletedRemovedOrderItemIngredientsIds:
        //     json["DeletedRemovedOrderItemIngredientsIds"] == null
        //         ? []
        //         : List<DeletedOrderItemId>.from(
        //             json["DeletedRemovedOrderItemIngredientsIds"]!
        //                 .map((x) => DeletedOrderItemId.fromJson(x))),
        // isHalfItem: json["IsHalfGroup"],
        imgPath: json["imgPath"],
        finalReTotalSellingAmount: json["FinalTotalSellingAmount"],
        finalReTotalTax: json["FinalTotalTax"],
        finalReTotalDiscount: json["FinalTotalDiscount"],
        finalReTotalDiscountWithTax: json["FinalTotalDiscountWithTax"],
        taxPercent: json["taxPercentage"] == null
            ? 0.0
            : double.tryParse(json["taxPercentage"]) ?? 0.0,
        batchNumber: json["BatchNumber"],
        batchId: json["BatchId"],
        orderItemsServiceEmployeeViewModels:
            json["OrderItemsServiceEmployeeViewModels"] == null
                ? []
                : List<OrderItemsServiceEmployeeViewModel>.from(
                    json["OrderItemsServiceEmployeeViewModels"]!.map(
                        (x) => OrderItemsServiceEmployeeViewModel.fromJson(x))),
        deletedOrderItemServiceEmployeeIds:
            json["DeletedOrderItemServiceEmployeeIds"] == null
                ? []
                : List<DeletedOrderItemId>.from(
                    json["DeletedOrderItemServiceEmployeeIds"]!
                        .map((x) => DeletedOrderItemId.fromJson(x))),
        deletedModifierItemModifierIds:
            json["DeletedModifierItemModifierIds"] == null
                ? []
                : List<DeletedOrderItemId>.from(
                    json["DeletedModifierItemModifierIds"]!
                        .map((x) => DeletedOrderItemId.fromJson(x))),

        bookedTime: json["BookedTime"],
        productType: json["productType"],
        productPriceType: json["productPriceType"],
        statusId: json["statusId"],
        preparationType: json["preparationType"],
        isTaxExempt: json["isTaxExempt"] ?? false,
      );

  Map<String, dynamic> toJson() => {
        "Id": id ?? "",
        "ProductId": productId,
        "ProductName": productName,
        "Description": description,
        "ProductPrice": productPrice?.roundToNString(),
        "Quantity": quantity.toString(),
        if (productVariationId != null)
          "ProductVariationId": productVariationId,
        "Total": total?.roundToNString(),
        if (productVariationName != null)
          "ProductVariationName": productVariationName,
        if (originalSellingAmount != null)
          "OriginalSellingAmount": originalSellingAmount,
        "DiscountWithoutTax": discountWithoutTax,
        "TotalTax": totalTax,
        if (unitCost != null) "UnitCost": unitCost,
        // if (categoryTypeId != null) "CategoryTypeId": categoryTypeId,
        // if (isCancelled != null) "IsCancelled": isCancelled,
        if (orderItemModifiersViewModels != null)
          "OrderItemModifiersViewModels": List<dynamic>.from(
              orderItemModifiersViewModels!.map((x) => x.toJson())),
        if (orderItemSelectOptionsViewModels != null)
          "OrderItemsSelectOptionsViewModels": List<dynamic>.from(
              orderItemSelectOptionsViewModels!.map((x) => x.toJson())),
        "DeletedOrderItemModifierIds": deletedOrderItemModifierIds == null
            ? []
            : List<dynamic>.from(
                deletedOrderItemModifierIds!.map((x) => x.toJson())),
        "DeletedOrderItemSelectOptionsIds":
            deletedOrderItemSelectOptionsIds == null
                ? []
                : List<dynamic>.from(
                    deletedOrderItemSelectOptionsIds!.map((x) => x.toJson())),
        // "OrderItemSpiceChoiceViewModel":
        //     orderItemSpiceChoiceViewModel?.toJson(),
        "DocketGroupName": docketGroupName,
        "DocketGroupId": docketGroupId,
        "DocketGroupSort": docketGroupSort,
        "EnableDocketGroupSpliter": enableDocketGroupSpliter,
        "DiscountWithTax": discountWithTax,
        "DiscountPercentage": discountPercentage,
        // "HalfGroupKey": halfGroupKey,
        // "HalfGroupAmount": halfGroupAmount,
        // "RemovedOrderItemsIngredientsViewModels":
        //     removedOrderItemsIngredientsViewModels == null
        //         ? []
        //         : List<dynamic>.from(removedOrderItemsIngredientsViewModels!
        //             .map((x) => x.toJson())),
        // "DeletedRemovedOrderItemIngredientsIds":
        //     deletedRemovedOrderItemIngredientsIds == null
        //         ? []
        //         : List<dynamic>.from(deletedRemovedOrderItemIngredientsIds!
        //             .map((x) => x.toJson())),
        // "IsHalfGroup": isHalfItem,
        "imgPath": imgPath,
        "FinalTotalSellingAmount": finalReTotalSellingAmount,
        "FinalTotalTax": finalReTotalTax,
        "FinalTotalDiscount": finalReTotalDiscount,
        "FinalTotalDiscountWithTax": finalReTotalDiscountWithTax,
        "taxPercentage": taxPercent.toString(),
        "BatchNumber": batchNumber,
        "BatchId": batchId,
        "OrderItemsServiceEmployeeViewModels":
            orderItemsServiceEmployeeViewModels == null
                ? []
                : List<dynamic>.from(orderItemsServiceEmployeeViewModels!
                    .map((x) => x.toJson())),
        "DeletedOrderItemServiceEmployeeIds":
            deletedOrderItemServiceEmployeeIds == null
                ? []
                : List<dynamic>.from(
                    deletedOrderItemServiceEmployeeIds!.map((x) => x.toJson())),
        "DeletedModifierItemModifierIds": deletedModifierItemModifierIds == null
            ? []
            : List<dynamic>.from(
                deletedModifierItemModifierIds!.map((x) => x.toJson())),

        "BookedTime": bookedTime,
        "productType": productType,
        "productPriceType": productPriceType,
        "statusId": statusId ?? '',
        "preparationType": preparationType,
        "isTaxExempt": isTaxExempt,
      };
}

class SetMenuOrderDetail {
  SetMenuOrderDetail({
    this.id,
    this.setMenuId,
    this.setMenuName,
    this.setMenuQuantity,
    this.setMenuPrice,
    this.totalSetMenuPrice,
    this.description = "",
    // this.isCancelled,
    this.orderItemsViewModels,
    this.originalSellingAmount,
    this.totalTax,
    this.discountWithoutTax,
    this.discountWithTax,
    this.discountPercentage,
    this.statusId,

    // not used for server request
    this.imgPath,
    this.docketGroupName,
    this.taxPercent = 0.0,
    this.paymentType,
    this.taxType,
    this.initQty = 1,
    this.actualPrice,
    this.isSelected = true,
    this.paidQuantity = 0,
    this.currentPayQty = 0,
    this.disabled = false,
    this.partialPayQty = 0,
    this.finalTotalSellingAmount = 0.0,
    this.finalTotalTax = 0.0,
    this.finalReTotalSellingAmount,
    this.finalReTotalTax,
    this.finalReTotalDiscount,
    this.finalReTotalDiscountWithTax,
    this.outOfStockMessage,
    this.isPubChargeEnable,
    this.isCreditChargeEnable,
    this.isServiceChargeEnable,
    this.kitchenStatus,
  });

  String? id;
  String? setMenuId;
  String? setMenuName;
  int? setMenuQuantity;
  double? setMenuPrice;
  double? totalSetMenuPrice;
  String description;
  // bool? isCancelled;
  List<OrderItemsViewModel>? orderItemsViewModels;
  String? originalSellingAmount;
  String? totalTax;
  String? discountWithoutTax;
  String? discountWithTax;
  String? discountPercentage;
  // eod report
  String? finalReTotalSellingAmount;
  String? finalReTotalTax;
  String? finalReTotalDiscount;
  String? finalReTotalDiscountWithTax;
  String? statusId;

  // not used for server request
  String? imgPath;
  String? docketGroupName;
  double taxPercent;
  TaxType? taxType;
  int initQty;
  String? actualPrice;
  // to view only paid product
  bool isSelected;
  double paidQuantity;
  double currentPayQty;
  double partialPayQty;
  int? paymentType;
  //to show in orders
  bool disabled;
  //   eod report
  double finalTotalSellingAmount;
  double finalTotalTax;
  String? outOfStockMessage;
  bool? isPubChargeEnable;
  bool? isCreditChargeEnable;
  bool? isServiceChargeEnable;
  String? kitchenStatus;

  factory SetMenuOrderDetail.fromJson(Map<String, dynamic> json) =>
      SetMenuOrderDetail(
        id: json["Id"],
        setMenuId: json["SetMenuId"],
        setMenuName: json["SetMenuName"],
        setMenuQuantity: int.tryParse(json["SetMenuQuantity"]),
        setMenuPrice: double.tryParse(json["SetMenuPrice"]),
        totalSetMenuPrice: double.tryParse(json["TotalSetMenuPrice"]),
        description: json["Description"],
        // isCancelled: json["IsCancelled"],
        orderItemsViewModels: json["OrderItemsViewModels"] == null
            ? null
            : List<OrderItemsViewModel>.from(json["OrderItemsViewModels"]
                .map((x) => OrderItemsViewModel.fromJson(x))),
        originalSellingAmount: json["OriginalSellingAmount"],
        totalTax: json["TotalTax"],
        discountWithoutTax: json["DiscountWithoutTax"],
        discountWithTax: json["DiscountWithTax"],
        discountPercentage: json["DiscountPercentage"],
        imgPath: json["imgPath"],
        finalReTotalSellingAmount: json["FinalTotalSellingAmount"],
        finalReTotalTax: json["FinalTotalTax"],
        finalReTotalDiscount: json["FinalTotalDiscount"],
        finalReTotalDiscountWithTax: json["FinalTotalDiscountWithTax"],
        taxPercent: json["TaxPercentage"] == null
            ? 0.0
            : double.tryParse(json["TaxPercentage"]) ?? 0.0,
        statusId: json["statusId"],
      );

  Map<String, dynamic> toJson() => {
        "Id": id,
        if (setMenuId != null) "SetMenuId": setMenuId,
        "SetMenuName": setMenuName,
        "SetMenuQuantity": setMenuQuantity.toString(),
        "SetMenuPrice": setMenuPrice?.roundToNString(),
        "TotalSetMenuPrice": totalSetMenuPrice?.roundToNString(),
        "Description": description,
        // if (isCancelled != null) "IsCancelled": isCancelled,
        if (orderItemsViewModels != null)
          "OrderItemsViewModels":
              List<dynamic>.from(orderItemsViewModels!.map((x) => x.toJson())),
        "OriginalSellingAmount": originalSellingAmount,
        "TotalTax": totalTax,
        "DiscountWithoutTax": discountWithoutTax,
        "DiscountWithTax": discountWithTax,
        "DiscountPercentage": discountPercentage,
        "imgPath": imgPath,
        "FinalTotalSellingAmount": finalReTotalSellingAmount,
        "FinalTotalTax": finalReTotalTax,
        "FinalTotalDiscount": finalReTotalDiscount,
        "FinalTotalDiscountWithTax": finalReTotalDiscountWithTax,
        "TaxPercentage": taxPercent.toString(),
        "statusId": statusId ?? '',
      };
}

class OrderItemsViewModel {
  OrderItemsViewModel({
    this.productVariationId,
    this.productName,
    this.productVariationName,
    this.orderItemsPriceModifierViewModels,
    this.deletedOrderItemModifierIds,
    this.removedOrderItemsIngredientsViewModels,
    this.deletedRemovedOrderItemIngredientsIds,
    this.quantity,
    //
    this.id,
    this.name,
    this.isCancelled = false,
  });

  String? productVariationId;
  String? productName;
  String? productVariationName;
  List<OrderItemsPriceModifierViewModel>? orderItemsPriceModifierViewModels;
  List<DeletedOrderItemId>? deletedOrderItemModifierIds;
  List<RemovedOrderItemsIngredientsViewModel>?
      removedOrderItemsIngredientsViewModels;
  List<DeletedOrderItemId>? deletedRemovedOrderItemIngredientsIds;
  String? quantity;

  /// for setmenu update
  String? id;
  String? name;
  bool isCancelled = false;

  factory OrderItemsViewModel.fromJson(Map<String, dynamic> json) =>
      OrderItemsViewModel(
        id: json["Id"],
        productVariationId: json["ProductVariationId"],
        productName: json["ProductName"],
        productVariationName: json["ProductVariationName"],
        orderItemsPriceModifierViewModels:
            json["OrderItemsPriceModifierViewModels"] == null
                ? null
                : List<OrderItemsPriceModifierViewModel>.from(
                    json["OrderItemsPriceModifierViewModels"]!.map(
                        (x) => OrderItemsPriceModifierViewModel.fromJson(x))),
        deletedOrderItemModifierIds: json["DeletedOrderItemModifierIds"] == null
            ? []
            : List<DeletedOrderItemId>.from(json["DeletedOrderItemModifierIds"]!
                .map((x) => DeletedOrderItemId.fromJson(x))),
        removedOrderItemsIngredientsViewModels:
            json["RemovedOrderItemsIngredientsViewModels"] == null
                ? []
                : List<RemovedOrderItemsIngredientsViewModel>.from(
                    json["RemovedOrderItemsIngredientsViewModels"]!.map((x) =>
                        RemovedOrderItemsIngredientsViewModel.fromJson(x))),
        deletedRemovedOrderItemIngredientsIds:
            json["DeletedRemovedOrderItemIngredientsIds"] == null
                ? []
                : List<DeletedOrderItemId>.from(
                    json["DeletedRemovedOrderItemIngredientsIds"]!
                        .map((x) => DeletedOrderItemId.fromJson(x))),
        quantity: json["Quantity"],
      );

  Map<String, dynamic> toJson() => {
        "Id": id,
        "ProductVariationId": productVariationId,
        "ProductName": productName,
        "ProductVariationName": productVariationName,
        if (orderItemsPriceModifierViewModels != null)
          "OrderItemsPriceModifierViewModels": List<dynamic>.from(
              orderItemsPriceModifierViewModels!.map((x) => x.toJson())),
        "DeletedOrderItemModifierIds": deletedOrderItemModifierIds == null
            ? []
            : List<dynamic>.from(
                deletedOrderItemModifierIds!.map((x) => x.toJson())),
        "RemovedOrderItemsIngredientsViewModels":
            removedOrderItemsIngredientsViewModels == null
                ? []
                : List<dynamic>.from(removedOrderItemsIngredientsViewModels!
                    .map((x) => x.toJson())),
        "DeletedRemovedOrderItemIngredientsIds":
            deletedRemovedOrderItemIngredientsIds == null
                ? []
                : List<dynamic>.from(deletedRemovedOrderItemIngredientsIds!
                    .map((x) => x.toJson())),
        "Quantity": quantity,
      };
}

class OrderItemsPriceModifierViewModel {
  OrderItemsPriceModifierViewModel({
    this.id,
    this.modifierName,
    this.modifierPrice,
    this.totalModifierPrice,
    this.totalTax,
    this.quantity,
    this.priceVariationModifierId,
    this.labelName,
    this.isActive = true,
    this.estimatedTime,
    this.modifierItemsModifierViewModels,
    this.isHalforCombo,
    this.isDealsHalf,
    this.kitchenStatus,
    this.isCancelled,
    this.taxRules,
    this.taxPercent,
    this.isTaxExempt = false,
    //
    this.type,
    this.isDealModifier,
    this.variationName,
  });

  String? id;
  String? modifierName;
  double? modifierPrice;
  double? totalModifierPrice;
  double? totalTax;
  double? quantity;
  String? priceVariationModifierId;
  String? labelName;
  bool isActive;
  String? estimatedTime;
  List<OrderItemsPriceModifierViewModel>? modifierItemsModifierViewModels;
  bool? isHalforCombo;
  bool? isDealsHalf;
  String? kitchenStatus;
  bool? isCancelled;
  String? taxPercent;
  bool isTaxExempt;
  //
  String? type;
  List<TaxRule>? taxRules;
  bool? isDealModifier;
  String? variationName;

  factory OrderItemsPriceModifierViewModel.fromJson(
          Map<String, dynamic> json) =>
      OrderItemsPriceModifierViewModel(
        id: json["id"],
        modifierName: json["modifierName"],
        modifierPrice: (json["modifierPrice"] is String
            ? double.tryParse(json["modifierPrice"])
            : json["modifierPrice"]),
        totalModifierPrice: (json["totalModifierPrice"] is String
            ? double.tryParse(json["totalModifierPrice"])
            : json["totalModifierPrice"]),
        quantity: (json["quantity"] is String
            ? double.tryParse(json["quantity"])
            : json["quantity"]),
        priceVariationModifierId: json["productVariationModifierItemId"],
        totalTax: (json["totalTax"] is String
            ? double.tryParse(json["totalTax"])
            : json["totalTax"]),
        labelName: json["labelName"],
        isActive: json["isActive"] ?? true,
        modifierItemsModifierViewModels:
            json["modifierItemsModifierViewModels"] == null
                ? null
                : List<OrderItemsPriceModifierViewModel>.from(
                    json["modifierItemsModifierViewModels"]!.map(
                        (x) => OrderItemsPriceModifierViewModel.fromJson(x))),
        isHalforCombo: json['isHalforCombo'],
        type: json['type'],
        kitchenStatus: json["kitchenStatus"],
        isCancelled: json["isCancelled"],
        taxPercent: json["taxPercentage"],
        isTaxExempt: json["isTaxExempt"] ?? false,
        // taxRules: json["taxRules"] == null
        //     ? []
        //     : List<TaxRule>.from(
        //         json["taxRules"]!.map((x) => TaxRule.fromJson(x))),
        isDealModifier: json["isDealModifier"],
        isDealsHalf: json['isDealsHalf'],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "modifierName": modifierName,
        "modifierPrice": modifierPrice?.roundToNString(),
        "totalModifierPrice": totalModifierPrice?.roundToNString(),
        "quantity": quantity.toString(),
        "productVariationModifierItemId": priceVariationModifierId,
        "totalTax": totalTax?.roundToNString(),
        "labelName": labelName,
        "isActive": isActive,
        if (modifierItemsModifierViewModels != null)
          "modifierItemsModifierViewModels": List<dynamic>.from(
              modifierItemsModifierViewModels!.map((x) => x.toJson())),
        if (isHalforCombo != null) "isHalforCombo": isHalforCombo,
        "type": type,
        "taxPercentage": taxPercent,
        "isTaxExempt": isTaxExempt,
        // if (taxRules != null)
        //   "taxRules": List<dynamic>.from(taxRules!.map((x) => x.toJson())),

        if (isDealModifier != null) "isDealModifier": isDealModifier,
        if (isDealsHalf != null) "isDealsHalf": isDealsHalf,
        // "kitchenStatus": kitchenStatus,
        // "isCancelled": isCancelled,
      };
}

class OrderItemSelectOptionsViewModels {
  String? id;
  String? filterTypeId;
  String? selectOptionName;
  String? selectOptionValue;
  String? filterTypeOptionsId;
  //
  bool? isDeleted;

  OrderItemSelectOptionsViewModels({
    this.id,
    this.filterTypeId,
    this.selectOptionName,
    this.selectOptionValue,
    this.filterTypeOptionsId,
    //
    this.isDeleted,
  });

  factory OrderItemSelectOptionsViewModels.fromJson(
          Map<String, dynamic> json) =>
      OrderItemSelectOptionsViewModels(
        id: json["id"] ?? json["Id"],
        filterTypeId: json["filterTypeId"] ?? json["FilterTypeId"],
        selectOptionName: json["selectOptionName"] ?? json["SelectOptionName"],
        selectOptionValue:
            json["selectOptionValue"] ?? json["SelectOptionValue"],
        filterTypeOptionsId:
            json["filterTypeOptionsId"] ?? json["FilterTypeOptionsId"],
      );

  Map<String, dynamic> toJson() => {
        "Id": id,
        "FilterTypeId": filterTypeId,
        "SelectOptionName": selectOptionName,
        "SelectOptionValue": selectOptionValue,
        "FilterTypeOptionsId": filterTypeOptionsId,
      };
}

class DeletedOrderItemId {
  String? id;

  DeletedOrderItemId({
    this.id,
  });

  factory DeletedOrderItemId.fromJson(Map<String, dynamic> json) =>
      DeletedOrderItemId(
        id: json["Id"],
      );

  Map<String, dynamic> toJson() => {
        "Id": id,
      };
}

class OrderItemSpiceChoiceViewModel {
  String? id;
  String? spiceChoiceId;
  String? name;

  OrderItemSpiceChoiceViewModel({
    this.id,
    this.spiceChoiceId,
    this.name,
  });

  factory OrderItemSpiceChoiceViewModel.fromJson(Map<String, dynamic> json) =>
      OrderItemSpiceChoiceViewModel(
        id: json["id"] ?? json["Id"],
        spiceChoiceId: json["spiceChoiceId"] ?? json["SpiceChoiceId"],
        name: json["name"] ?? json["Name"],
      );

  Map<String, dynamic> toJson() => {
        "Id": id,
        "SpiceChoiceId": spiceChoiceId,
        "Name": name,
      };
}

class OrderDeliveryRequestModel {
  String? id;
  String? latitude;
  String? longitude;
  String? deliveryLocation;
  String? deliveryAmount;
  String? deliveryAmountWithTax;
  String? pickUpDeliveryDateTime;
  String? distanceInKm;
  String? distanceInMile;
  String? pickUpDeliveryNote;

  OrderDeliveryRequestModel({
    this.id,
    this.latitude,
    this.longitude,
    this.deliveryLocation,
    this.deliveryAmount,
    this.deliveryAmountWithTax,
    this.pickUpDeliveryDateTime,
    this.distanceInKm,
    this.distanceInMile,
    this.pickUpDeliveryNote,
  });

  factory OrderDeliveryRequestModel.fromJson(Map<String, dynamic> json) =>
      OrderDeliveryRequestModel(
        id: json["Id"],
        latitude: json["Latitude"],
        longitude: json["Longitude"],
        deliveryLocation: json["DeliveryLocation"],
        deliveryAmount: json["DeliveryAmount"],
        deliveryAmountWithTax: json["DeliveryAmountWithTax"],
        pickUpDeliveryDateTime: json["PickUpDeliveryDateTime"],
        distanceInKm: json["DistanceInKm"],
        distanceInMile: json["DistanceInMile"],
        pickUpDeliveryNote: json["PickUpDeliveryNote"],
      );

  Map<String, dynamic> toJson() => {
        "Id": id,
        "Latitude": latitude,
        "Longitude": longitude,
        "DeliveryLocation": deliveryLocation,
        "DeliveryAmount": deliveryAmount,
        "DeliveryAmountWithTax": deliveryAmountWithTax,
        "PickUpDeliveryDateTime": pickUpDeliveryDateTime,
        "DistanceInKm": distanceInKm,
        "DistanceInMile": distanceInMile,
        "PickUpDeliveryNote": pickUpDeliveryNote,
      };
}

class RemovedOrderItemsIngredientsViewModel {
  String id;
  String? name;
  bool isActive;

  RemovedOrderItemsIngredientsViewModel({
    this.id = "",
    this.name,
    this.isActive = true,
  });

  factory RemovedOrderItemsIngredientsViewModel.fromJson(
          Map<String, dynamic> json) =>
      RemovedOrderItemsIngredientsViewModel(
        id: json["id"] ?? '',
        name: json["name"],
        isActive: json["isActive"] ?? true,
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "isActive": isActive,
      };
}

class RawIngredientOrderDetail {
  String? id;
  String? unitOfMeasurementId;
  String? rawIngredientId;
  double? quantity;
  String? totalSellingPrice;
  String? totalTax;
  double? originalSellingPricePerUnit;
  // bool? isCancelled;
  // extra
  String? name;
  double? stockCount;
  double taxPercent;
  TaxType? taxType;
  bool isSelected;
  double paidQuantity;
  double currentPayQty;
  double partialPayQty;
  int? paymentType;
  String? statusId;

  double initQty;
  //to show in orders
  bool disabled;
  String? maxToMinConversionFactor;
  // // eod report
  double finalTotalSellingAmount;
  double finalTotalTax;
  // eod report
  String? finalReTotalDiscount;
  String? finalReTotalDiscountWithTax;
  String? outOfStockMessage;
  bool? isPubChargeEnable;
  bool? isCreditChargeEnable;
  bool? isServiceChargeEnable;
  String? discountPercentage;
  String? customPrice;

  RawIngredientOrderDetail({
    this.id,
    this.unitOfMeasurementId,
    this.rawIngredientId,
    this.quantity,
    this.totalSellingPrice,
    this.totalTax,
    this.originalSellingPricePerUnit,
    // this.isCancelled,
    //
    this.name,
    this.stockCount,
    this.taxPercent = 0.0,
    this.taxType,
    this.isSelected = true,
    this.paymentType,
    this.initQty = 1,
    this.paidQuantity = 0,
    this.currentPayQty = 0.0,
    this.disabled = false,
    this.maxToMinConversionFactor,
    this.partialPayQty = 0,
    this.discountPercentage,

    //
    this.finalTotalSellingAmount = 0.0,
    this.finalTotalTax = 0.0,
    this.finalReTotalDiscount,
    this.finalReTotalDiscountWithTax,
    this.outOfStockMessage,
    this.isPubChargeEnable,
    this.isCreditChargeEnable,
    this.isServiceChargeEnable,
    this.statusId,
    this.customPrice,
  });

  factory RawIngredientOrderDetail.fromJson(Map<String, dynamic> json) =>
      RawIngredientOrderDetail(
        id: json["Id"],
        unitOfMeasurementId: json["UnitOfMeasurementId"],
        rawIngredientId: json["RawLooseIngredientId"],
        quantity: (json["Quantity"] != null && json["Quantity"] is String)
            ? double.tryParse(json["Quantity"])
            : json["Quantity"],
        totalSellingPrice: json["TotalSellingPrice"],
        totalTax: json["TotalTax"],
        originalSellingPricePerUnit:
            (json["OriginalSellingPricePerUnit"] != null &&
                    json["OriginalSellingPricePerUnit"] is String)
                ? double.tryParse(json["OriginalSellingPricePerUnit"])
                : json["OriginalSellingPricePerUnit"],
        // isCancelled: json["IsCancelled"],
        name: json["Name"],
        finalReTotalDiscount: json["FinalTotalDiscount"],
        finalReTotalDiscountWithTax: json["FinalTotalDiscountWithTax"],
        taxPercent: json["TaxPercentage"] == null
            ? 0.0
            : double.tryParse(json["TaxPercentage"]) ?? 0.0,
        discountPercentage: json["DiscountPercentage"],
        statusId: json["statusId"],
      );

  Map<String, dynamic> toJson() => {
        "Id": id,
        "UnitOfMeasurementId": unitOfMeasurementId,
        "RawLooseIngredientId": rawIngredientId,
        "Quantity": quantity.toString(),
        "TotalSellingPrice": totalSellingPrice,
        "TotalTax": totalTax,
        "OriginalSellingPricePerUnit":
            originalSellingPricePerUnit?.roundToNString(),
        // if (isCancelled != null) "IsCancelled": isCancelled,
        "Name": name,
        if (finalReTotalDiscount != null)
          "FinalTotalDiscount": finalReTotalDiscount,
        if (finalReTotalDiscountWithTax != null)
          "FinalTotalDiscountWithTax": finalReTotalDiscountWithTax,
        "TaxPercentage": taxPercent.toString(),
        "DiscountPercentage": discountPercentage,
        "statusId": statusId ?? '',
      };
}

class OrderItemsServiceEmployeeViewModel {
  String id;
  String? employeeId;
  String? employeeName;
  bool isSelected;

  OrderItemsServiceEmployeeViewModel({
    this.id = "",
    this.employeeId,
    this.employeeName,
    this.isSelected = true,
  });

  factory OrderItemsServiceEmployeeViewModel.fromJson(
          Map<String, dynamic> json) =>
      OrderItemsServiceEmployeeViewModel(
        id: json["id"],
        employeeId: json["employeeId"],
        employeeName: json["employeeName"],
        isSelected: json["isSelected"] ?? true,
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "employeeId": employeeId,
        "employeeName": employeeName,
        "isSelected": isSelected,
      };
}

enum ItemCancelType { order, setmenu, rawingre }
