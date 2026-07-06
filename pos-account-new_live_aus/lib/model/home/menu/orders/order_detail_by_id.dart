import 'package:pos_account/model/common/table_id_name.dart';
import 'package:pos_account/model/home/menu/place_order/place_order_req.dart';
import 'package:pos_account/model/home/menu/place_order/po_make_pay_req.dart';

class OrderDetailById {
  OrderDetailById({
    this.staffName,
    this.customerUserViewModel,
    this.receiverUserViewModel,
    // this.posDeliveryStoreInformation,
    // this.storeTaxSettings,
    this.orderDetailsViewModel,
    this.orderPaymentDetailsWithPaymentStatusViewModel,
    this.productWithPriceDetailsViewModel,
    this.setMenuWithPriceDetailsViewModel,
    this.productWithGroupPriceDetailsViewModel,
    this.rawIngredientWithPriceDetailsViewModel,
    this.orderTabViewModel,
    this.orderDiscounts,
  });
  String? staffName;
  CustomerUserViewModel? customerUserViewModel;
  CustomerUserViewModel? receiverUserViewModel;
  // PosDeliveryStoreInformation? posDeliveryStoreInformation;
  // StoreTaxSettings? storeTaxSettings;
  OrderTabViewModel? orderTabViewModel;
  OrderDetailsViewModel? orderDetailsViewModel;
  OrderPaymentDetailsWithPaymentStatusViewModel?
      orderPaymentDetailsWithPaymentStatusViewModel;
  List<ViewModel>? productWithPriceDetailsViewModel;
  List<ProductWithGroupPriceDetailsViewModel>?
      productWithGroupPriceDetailsViewModel;
  List<SetMenuWithPriceDetailsViewModel>? setMenuWithPriceDetailsViewModel;
  List<RawIngredientWithPriceDetailsViewModel>?
      rawIngredientWithPriceDetailsViewModel;
  List<OrderDiscountModel>? orderDiscounts;

  factory OrderDetailById.fromJson(Map<String, dynamic> json) =>
      OrderDetailById(
        staffName: json["staffName"],
        customerUserViewModel: json["customerUserViewModel"] == null
            ? null
            : CustomerUserViewModel.fromJson(json["customerUserViewModel"]),
        receiverUserViewModel: json["receiverUserViewModel"] == null
            ? null
            : CustomerUserViewModel.fromJson(json["receiverUserViewModel"]),
        // posDeliveryStoreInformation: json["posDeliveryStoreInformation"] == null
        //     ? null
        //     : PosDeliveryStoreInformation.fromJson(
        //         json["posDeliveryStoreInformation"]),
        // storeTaxSettings: json["storeTaxSettings"] == null
        //     ? null
        //     : StoreTaxSettings.fromJson(json["storeTaxSettings"]),
        orderDetailsViewModel: json["orderDetailsViewModel"] == null
            ? null
            : OrderDetailsViewModel.fromJson(json["orderDetailsViewModel"]),
        orderPaymentDetailsWithPaymentStatusViewModel:
            json["orderPaymentDetailsWithPaymentStatusViewModel"] == null
                ? null
                : OrderPaymentDetailsWithPaymentStatusViewModel.fromJson(
                    json["orderPaymentDetailsWithPaymentStatusViewModel"]),
        productWithPriceDetailsViewModel:
            json["productWithPriceDetailsViewModel"] == null
                ? null
                : List<ViewModel>.from(json["productWithPriceDetailsViewModel"]
                    .map((x) => ViewModel.fromJson(x))),
        setMenuWithPriceDetailsViewModel:
            json["setMenuWithPriceDetailsViewModel"] == null
                ? null
                : List<SetMenuWithPriceDetailsViewModel>.from(
                    json["setMenuWithPriceDetailsViewModel"].map(
                        (x) => SetMenuWithPriceDetailsViewModel.fromJson(x))),
        productWithGroupPriceDetailsViewModel:
            json["productWithGroupPriceDetailsViewModel"] == null
                ? []
                : List<ProductWithGroupPriceDetailsViewModel>.from(
                    json["productWithGroupPriceDetailsViewModel"]!.map((x) =>
                        ProductWithGroupPriceDetailsViewModel.fromJson(x))),
        rawIngredientWithPriceDetailsViewModel: json[
                    "rawLooseIngredientWithPriceDetailsViewModel"] ==
                null
            ? []
            : List<RawIngredientWithPriceDetailsViewModel>.from(
                json["rawLooseIngredientWithPriceDetailsViewModel"]!.map(
                    (x) => RawIngredientWithPriceDetailsViewModel.fromJson(x))),
        orderTabViewModel: json["orderTabViewModel"] == null
            ? null
            : OrderTabViewModel.fromJson(json["orderTabViewModel"]),
        orderDiscounts: json["orderDiscounts"] == null
            ? []
            : List<OrderDiscountModel>.from(json["orderDiscounts"]!
                .map((x) => OrderDiscountModel.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "staffName": staffName,
        "customerUserViewModel": customerUserViewModel?.toJson(),
        "receiverUserViewModel": receiverUserViewModel?.toJson(),
        // "posDeliveryStoreInformation": posDeliveryStoreInformation?.toJson(),
        // "storeTaxSettings": storeTaxSettings?.toJson(),
        "orderDetailsViewModel": orderDetailsViewModel?.toJson(),
        "orderPaymentDetailsWithPaymentStatusViewModel":
            orderPaymentDetailsWithPaymentStatusViewModel?.toJson(),
        "productWithPriceDetailsViewModel":
            productWithPriceDetailsViewModel == null
                ? null
                : List<dynamic>.from(
                    productWithPriceDetailsViewModel!.map((x) => x.toJson())),
        "setMenuWithPriceDetailsViewModel":
            setMenuWithPriceDetailsViewModel == null
                ? null
                : List<dynamic>.from(
                    setMenuWithPriceDetailsViewModel!.map((x) => x.toJson())),
        "productWithGroupPriceDetailsViewModel":
            productWithGroupPriceDetailsViewModel == null
                ? []
                : List<dynamic>.from(productWithGroupPriceDetailsViewModel!
                    .map((x) => x.toJson())),
        "rawLooseIngredientWithPriceDetailsViewModel":
            rawIngredientWithPriceDetailsViewModel == null
                ? []
                : List<dynamic>.from(rawIngredientWithPriceDetailsViewModel!
                    .map((x) => x.toJson())),
        "orderTabViewModel": orderTabViewModel?.toJson(),
        "orderDiscounts": orderDiscounts == null
            ? []
            : List<dynamic>.from(orderDiscounts!.map((x) => x.toJson())),
      };
}

class CustomerUserViewModel {
  CustomerUserViewModel({
    this.id,
    this.name,
    this.phoneNumber,
    this.email,
    this.country,
    this.message,
  });

  String? id;
  String? name;
  String? phoneNumber;
  String? email;
  String? country;
  String? message;

  factory CustomerUserViewModel.fromJson(Map<String, dynamic> json) =>
      CustomerUserViewModel(
        id: json["id"],
        name: json["name"],
        phoneNumber: json["phoneNumber"],
        email: json["email"],
        country: json["country"],
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "phoneNumber": phoneNumber,
        "email": email,
        "country": country,
        "message": message,
      };
}

class OrderTabViewModel {
  String? id;
  String? tabIndentification;
  String? noOfCustomer;
  String? tabLimit;

  OrderTabViewModel(
      {this.tabIndentification, this.noOfCustomer, this.tabLimit, this.id});

  OrderTabViewModel.fromJson(Map<String, dynamic> json) {
    tabIndentification = json['tabIndentification'];
    noOfCustomer = json['noOfCustomer'];
    tabLimit = json['tabLimit'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['tabIndentification'] = tabIndentification;
    data['noOfCustomer'] = noOfCustomer;
    data['tabLimit'] = tabLimit;
    data['id'] = id;
    return data;
  }
}

class OrderDetailsViewModel {
  OrderDetailsViewModel({
    this.orderId,
    this.orderNumber,
    this.taxAmount,
    // this.tipAmount,
    // this.discount,
    this.totalAmount,
    this.totalWithoutTaxAmount,
    this.deliveryAddress,
    // this.orderedBy,
    this.email,
    this.phoneNumber,
    // this.tableId,
    this.tables,
    this.staffId,
    this.tableNumber,
    this.orderType,
    this.orderStatus,
    this.orderChannel,
    this.orderChannelEnum,
    this.orderedDate,
    this.pickUpDeliveryDate,
    this.pickUpDeliveryNote,
    this.taxExclusiveInclusiveType,
    this.description,
    this.paymentStatus,
    this.paymentType,
    this.trackingNumber,
    this.comments,
    this.isDeliveryEnable,
    this.noOfCustomerOnTable,
    this.orderTypeId,
    this.orderProcessBy,
    this.paymentProcessBy,
    this.remainingAmountOnGiftPay,
    this.stockDeductType,
    this.eftPosMerchantType,
    this.kitchenStatus,
    this.customerId,
  });

  String? orderId;
  String? orderNumber;
  String? taxAmount;
  // String? tipAmount;
  // String? discount;
  String? totalAmount;
  String? totalWithoutTaxAmount;
  String? deliveryAddress;
  // String? orderedBy;
  String? email;
  String? phoneNumber;
  // String? tableId;
  List<TableIdName>? tables;
  String? staffId;
  String? tableNumber;
  String? orderType;
  String? orderStatus;
  String? orderChannel;
  String? orderChannelEnum;
  String? orderedDate;
  String? pickUpDeliveryDate;
  String? orderTypeId;
  String? pickUpDeliveryNote;
  String? taxExclusiveInclusiveType;
  String? description;
  String? paymentStatus;
  String? paymentType;
  String? trackingNumber;
  String? comments;
  bool? isDeliveryEnable;
  String? noOfCustomerOnTable;
  String? orderProcessBy;
  String? paymentProcessBy;
  String? remainingAmountOnGiftPay;
  String? stockDeductType;
  String? eftPosMerchantType;
  String? kitchenStatus;
  String? customerId;

  factory OrderDetailsViewModel.fromJson(Map<String, dynamic> json) =>
      OrderDetailsViewModel(
        orderId: json["orderId"],
        orderNumber: json["orderNumber"],
        taxAmount: json["taxAmount"],
        // tipAmount: json["tipAmount"],
        // discount: json["discount"],
        totalAmount: json["totalAmount"],
        totalWithoutTaxAmount: json["totalWithoutTaxAmount"],
        deliveryAddress: json["deliveryAddress"],
        // orderedBy: json["orderedBy"],
        email: json["email"],
        phoneNumber: json["phoneNumber"],
        // tableId: json["tableId"],
        tables: json["tables"] == null
            ? []
            : List<TableIdName>.from(
                json["tables"]!.map((x) => TableIdName.fromJson(x))),
        staffId: json["staffId"],
        tableNumber: json["tableNumber"],
        orderType: json["orderType"],
        orderStatus: json["orderStatus"],
        orderTypeId: json["orderTypeId"],
        orderChannel: json["orderChannel"],
        orderChannelEnum: json["orderChannelEnum"],
        orderedDate: json["orderedDate"],
        pickUpDeliveryDate: json["pickUpDeliveryDate"],
        pickUpDeliveryNote: json["pickUpDeliveryNote"],
        taxExclusiveInclusiveType: json["taxExclusiveInclusiveType"],
        description: json["description"],
        paymentStatus: json["paymentStatus"],
        paymentType: json["paymentType"],
        trackingNumber: json["trackingNumber"],
        comments: json["comments"],
        isDeliveryEnable: json["isDeliveryEnable"],
        noOfCustomerOnTable: json["noOfCustomerOnTable"],
        orderProcessBy: json["orderProcessBy"],
        paymentProcessBy: json["paymentProcessBy"],
        remainingAmountOnGiftPay: json["remainingAmountOnGiftPay"],
        stockDeductType: json["stockDeductType"],
        eftPosMerchantType: json["eftPOSMerchantType"],
        kitchenStatus: json["kitchenStatus"],
        customerId: json["customerId"],
      );

  Map<String, dynamic> toJson() => {
        "orderId": orderId,
        "orderNumber": orderNumber,
        "taxAmount": taxAmount,
        // "tipAmount": tipAmount,
        // "discount": discount,
        "totalAmount": totalAmount,
        "totalWithoutTaxAmount": totalWithoutTaxAmount,
        "deliveryAddress": deliveryAddress,
        // "orderedBy": orderedBy,
        "email": email,
        "phoneNumber": phoneNumber,
        // "tableId": tableId,
        "tables": tables == null
            ? []
            : List<dynamic>.from(tables!.map((x) => x.toJson())),
        "staffId": staffId,
        "tableNumber": tableNumber,
        "orderType": orderType,
        "orderStatus": orderStatus,
        "orderChannel": orderChannel,
        "orderChannelEnum": orderChannelEnum,
        "orderedDate": orderedDate,
        "pickUpDeliveryDate": pickUpDeliveryDate,
        "pickUpDeliveryNote": pickUpDeliveryNote,
        "orderTypeId": orderTypeId,
        "taxExclusiveInclusiveType": taxExclusiveInclusiveType,
        "description": description,
        "paymentStatus": paymentStatus,
        "paymentType": paymentType,
        "trackingNumber": trackingNumber,
        "comments": comments,
        "isDeliveryEnable": isDeliveryEnable,
        "noOfCustomerOnTable": noOfCustomerOnTable,
        "orderProcessBy": orderProcessBy,
        "paymentProcessBy": paymentProcessBy,
        "remainingAmountOnGiftPay": remainingAmountOnGiftPay,
        "stockDeductType": stockDeductType,
        "eftPOSMerchantType": eftPosMerchantType,
        "kitchenStatus": kitchenStatus,
        "customerId": customerId,
      };
}

class ViewModel {
  ViewModel({
    this.id,
    this.productId,
    this.productVariationId,
    // this.categoryTypeId,
    this.productCategoryId,
    this.name,
    this.quantity,
    this.paidQuantity,
    this.currentPaidQuantity,
    this.paidAmount,
    this.surChargeAmount,
    this.stockcount,
    this.total,
    this.image,
    this.description,
    this.taxPercentage,
    // this.isCancelled,
    this.productPrice,
    this.orderItemModifiersViewModels,
    this.orderItemSelectOptionsViewModels,
    // this.orderItemSpiceChoiceViewModel,
    this.isPublicHolidaySurchargeUsed,
    this.isCreditCardSurchargeUsed,
    this.docketGroupName,
    this.docketGroupSort,
    this.enableDocketGroupSpliter = false,
    this.productName,
    this.productVariationName,
    // this.halfGroupKey,
    // this.halfGroupAmount,
    // this.removedOrderItemIngredientViewModels,
    this.batchNumber,
    this.batchId,
    this.orderItemsServiceEmployeeViewModels,
    this.bookedTime,
    this.productType,
    this.productPriceType,
    this.discountPercentage,
    this.statusId,
    this.kitchenStatus,
    this.preparationType,
    this.isTaxExempt = false,
  });

  String? id;
  String? productId;
  String? productVariationId;
  // String? categoryTypeId;
  String? productCategoryId;
  String? name;
  String? quantity;
  String? paidQuantity;
  String? currentPaidQuantity;
  String? paidAmount;
  String? surChargeAmount;
  String? stockcount;
  String? total;
  String? image;
  String? description;
  String? taxPercentage;
  // bool? isCancelled;
  String? productPrice;
  List<OrderItemsPriceModifierViewModel>? orderItemModifiersViewModels;
  List<OrderItemSelectOptionsViewModels>? orderItemSelectOptionsViewModels;
  // OrderItemSpiceChoiceViewModel? orderItemSpiceChoiceViewModel;
  String? docketGroupName;
  int? docketGroupSort;
  bool enableDocketGroupSpliter;
  String? productName;
  String? productVariationName;
  String? batchNumber;
  String? batchId;
  List<OrderItemsServiceEmployeeViewModel>? orderItemsServiceEmployeeViewModels;

  /// this keys are used to know either the charges are used in previous payment or not, if yes then it will be added in total amount of the item to get correct value
  bool? isPublicHolidaySurchargeUsed;
  bool? isCreditCardSurchargeUsed;
  String? discountPercentage;
  //
  // String? halfGroupKey;
  // String? halfGroupAmount;
  // List<RemovedOrderItemsIngredientsViewModel>?
  //     removedOrderItemIngredientViewModels;
  String? bookedTime;
  String? productType;
  String? productPriceType;
  String? statusId;
  String? kitchenStatus;
  String? preparationType;
  bool isTaxExempt;

  factory ViewModel.fromJson(Map<String, dynamic> json) => ViewModel(
        id: json["id"],
        productId: json["productId"],
        productVariationId: json["productVariationId"],
        productCategoryId: json["productCategoryId"],
        // categoryTypeId: json["categoryTypeId"],
        name: json["name"],
        quantity: json["quantity"],
        paidQuantity: json["paidQuantity"],
        currentPaidQuantity: json["currentPaidQuantity"],
        paidAmount: json["paidAmount"],
        surChargeAmount: json["surChargeAmount"],
        stockcount: json["stockcount"],
        total: json["total"],
        image: json["image"],
        description: json["description"],
        taxPercentage: json["taxPercentage"],
        // isCancelled: json["isCancelled"],
        productPrice: json["productPrice"],
        orderItemModifiersViewModels: json["orderItemModifiersViewModels"] ==
                null
            ? []
            : List<OrderItemsPriceModifierViewModel>.from(
                json["orderItemModifiersViewModels"]!
                    .map((x) => OrderItemsPriceModifierViewModel.fromJson(x))),
        orderItemSelectOptionsViewModels:
            json["orderItemSelectOptionsViewModels"] == null
                ? []
                : List<OrderItemSelectOptionsViewModels>.from(
                    json["orderItemSelectOptionsViewModels"]!.map(
                        (x) => OrderItemSelectOptionsViewModels.fromJson(x))),
        // orderItemSpiceChoiceViewModel:
        //     json["orderItemSpiceChoiceViewModel"] == null
        //         ? null
        //         : OrderItemSpiceChoiceViewModel.fromJson(
        //             json["orderItemSpiceChoiceViewModel"]),
        isPublicHolidaySurchargeUsed: json["isPublicHolidaySurchargeUsed"],
        isCreditCardSurchargeUsed: json["isCreditCardSurchargeUsed"],
        docketGroupName: json["docketGroupName"],
        docketGroupSort: json["docketGroupSort"],
        enableDocketGroupSpliter: json["enableDocketGroupSpliter"],
        productName: json["productName"],
        productVariationName: json["productVariationName"],
        // halfGroupKey: json["halfGroupKey"],
        // halfGroupAmount: json["halfGroupAmount"],
        // removedOrderItemIngredientViewModels:
        //     json["removedOrderItemIngredientViewModels"] == null
        //         ? []
        //         : List<RemovedOrderItemsIngredientsViewModel>.from(
        //             json["removedOrderItemIngredientViewModels"]!.map((x) =>
        //                 RemovedOrderItemsIngredientsViewModel.fromJson(x))),
        batchNumber: json["batchNumber"],
        batchId: json["batchId"],
        orderItemsServiceEmployeeViewModels:
            json["orderItemsServiceEmployeeViewModels"] == null
                ? []
                : List<OrderItemsServiceEmployeeViewModel>.from(
                    json["orderItemsServiceEmployeeViewModels"]!.map(
                        (x) => OrderItemsServiceEmployeeViewModel.fromJson(x))),
        bookedTime: json["bookedTime"],
        productType: json["productType"],
        productPriceType: json["productPriceType"],
        discountPercentage: json["discountPercentage"],
        statusId: json["statusId"],
        kitchenStatus: json["kitchenStatus"],
        preparationType: json["preparationType"],
        isTaxExempt: json["isTaxExempt"] ?? false,
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "productId": productId,
        "productVariationId": productVariationId,
        // "categoryTypeId": categoryTypeId,
        "productCategoryId": productCategoryId,
        "name": name,
        "quantity": quantity,
        "paidQuantity": paidQuantity,
        "currentPaidQuantity": currentPaidQuantity,
        "paidAmount": paidAmount,
        "surChargeAmount": surChargeAmount,
        "stockcount": stockcount,
        "total": total,
        "image": image,
        "description": description,
        "taxPercentage": taxPercentage,
        // "isCancelled": isCancelled,
        "productPrice": productPrice,
        "orderItemModifiersViewModels": orderItemModifiersViewModels == null
            ? []
            : List<dynamic>.from(
                orderItemModifiersViewModels!.map((x) => x.toJson())),
        "orderItemSelectOptionsViewModels":
            orderItemSelectOptionsViewModels == null
                ? []
                : List<dynamic>.from(
                    orderItemSelectOptionsViewModels!.map((x) => x.toJson())),
        // "orderItemSpiceChoiceViewModel":
        //     orderItemSpiceChoiceViewModel?.toJson(),
        "isPublicHolidaySurchargeUsed": isPublicHolidaySurchargeUsed,
        "isCreditCardSurchargeUsed": isCreditCardSurchargeUsed,
        "docketGroupName": docketGroupName,
        "docketGroupSort": docketGroupSort,
        "enableDocketGroupSpliter": enableDocketGroupSpliter,
        "productName": productName,
        "productVariationName": productVariationName,
        // "halfGroupKey": halfGroupKey,
        // "halfGroupAmount": halfGroupAmount,
        // "removedOrderItemIngredientViewModels":
        //     removedOrderItemIngredientViewModels == null
        //         ? []
        //         : List<dynamic>.from(removedOrderItemIngredientViewModels!
        //             .map((x) => x.toJson())),
        "batchNumber": batchNumber,
        "batchId": batchId,
        "orderItemsServiceEmployeeViewModels":
            orderItemsServiceEmployeeViewModels == null
                ? []
                : List<dynamic>.from(orderItemsServiceEmployeeViewModels!
                    .map((x) => x.toJson())),
        "bookedTime": bookedTime,
        "productType": productType,
        "productPriceType": productPriceType,
        "discountPercentage": discountPercentage,
        "statusId": statusId,
        "kitchenStatus": kitchenStatus,
        "preparationType": preparationType,
        "isTaxExempt": isTaxExempt,
      };
}

class SetMenuWithPriceDetailsViewModel {
  SetMenuWithPriceDetailsViewModel({
    this.id,
    this.setMenuName,
    this.image,
    this.quantity,
    this.description,
    this.taxExclusiveInclusiveValue,
    this.total,
    this.setMenuProductViewModel,
    // this.isCancelled,
    this.setMenuPrice,

    ///
    this.setMenuId,
    this.paidQuantity,
    this.paidAmount,
    this.currentPaidQuantity,
    this.surChargeAmount,
    this.isPublicHolidaySurchargeUsed,
    this.isCreditCardSurchargeUsed,
    this.discountPercentage,
    this.statusId,
    this.kitchenStatus,
  });
  String? id;
  String? setMenuName;
  String? image;
  String? quantity;
  String? description;
  String? taxExclusiveInclusiveValue;
  String? total;
  // bool? isCancelled;
  List<ViewModel>? setMenuProductViewModel;
  String? setMenuPrice;

  /// addition for pay by item
  String? setMenuId;
  String? paidQuantity;
  String? paidAmount;
  String? currentPaidQuantity;
  String? surChargeAmount;
  bool? isPublicHolidaySurchargeUsed;
  bool? isCreditCardSurchargeUsed;
  String? discountPercentage;
  String? statusId;
  String? kitchenStatus;

  factory SetMenuWithPriceDetailsViewModel.fromJson(
          Map<String, dynamic> json) =>
      SetMenuWithPriceDetailsViewModel(
        id: json["id"],
        setMenuName: json["setMenuName"],
        image: json["image"],
        quantity: json["quantity"],
        description: json["description"],
        taxExclusiveInclusiveValue: json["salesTax"],
        total: json["total"],
        // isCancelled: json["isCancelled"],
        setMenuProductViewModel: json["setMenuProductViewModel"] == null
            ? null
            : List<ViewModel>.from(json["setMenuProductViewModel"]
                .map((x) => ViewModel.fromJson(x))),
        setMenuPrice: json["setMenuPrice"],
        setMenuId: json["setMenuId"],
        paidQuantity: json["paidQuantity"],
        paidAmount: json["paidAmount"],
        currentPaidQuantity: json["currentPaidQuantity"],
        surChargeAmount: json["surChargeAmount"],
        isPublicHolidaySurchargeUsed: json["isPublicHolidaySurchargeUsed"],
        isCreditCardSurchargeUsed: json["isCreditCardSurchargeUsed"],
        discountPercentage: json["discountPercentage"],
        statusId: json["statusId"], kitchenStatus: json["kitchenStatus"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "setMenuName": setMenuName,
        "image": image,
        "quantity": quantity,
        "description": description,
        "salesTax": taxExclusiveInclusiveValue,
        "total": total,
        // "isCancelled": isCancelled,
        "setMenuProductViewModel": setMenuProductViewModel == null
            ? null
            : List<dynamic>.from(
                setMenuProductViewModel!.map((x) => x.toJson())),
        "setMenuPrice": setMenuPrice,
        "setMenuId": setMenuId,
        "paidQuantity": paidQuantity,
        "paidAmount": paidAmount,
        "currentPaidQuantity": currentPaidQuantity,
        "surChargeAmount": surChargeAmount,
        "isPublicHolidaySurchargeUsed": isPublicHolidaySurchargeUsed,
        "isCreditCardSurchargeUsed": isCreditCardSurchargeUsed,
        "discountPercentage": discountPercentage,
        "statusId": statusId, "kitchenStatus": kitchenStatus,
      };
}

class OrderPaymentDetailsWithPaymentStatusViewModel {
  OrderPaymentDetailsWithPaymentStatusViewModel({
    this.paymentStatus,
    // this.paidAmount,
    this.remainingAmount,
    // this.discountPercentage,
    // this.voucherDiscountPercentage,
    this.discount,
    this.deliveryAmount,
    this.holidaySurgeAmount,
    this.creditCardSurgeAmount,
    this.creditCardSurchargePercentage,
    this.serviceChargePercentage,
    this.discountWithTax,
    this.deliveryAmountWithTax,
    this.holidaySurgeAmountWithTax,
    this.creditCardSurgeAmountWithTax,
    this.serviceChargeAmount,
    this.tipAmount,
    this.orderPaymentsDetailsViewModels,
  });

  String? paymentStatus;
  // String? paidAmount;
  String? remainingAmount;
  // String? discountPercentage;
  // String? voucherDiscountPercentage;
  String? discount;
  String? deliveryAmount;
  String? holidaySurgeAmount;
  String? creditCardSurgeAmount;
  String? creditCardSurchargePercentage;
  String? serviceChargePercentage;
  String? discountWithTax;
  String? deliveryAmountWithTax;
  String? holidaySurgeAmountWithTax;
  String? creditCardSurgeAmountWithTax;
  String? serviceChargeAmount;
  String? tipAmount;
  List<OrderPaymentsDetailsViewModel>? orderPaymentsDetailsViewModels;

  factory OrderPaymentDetailsWithPaymentStatusViewModel.fromJson(
          Map<String, dynamic> json) =>
      OrderPaymentDetailsWithPaymentStatusViewModel(
        paymentStatus: json["paymentStatus"],
        // paidAmount: json["paidAmount"],
        remainingAmount: json["remainingAmount"],
        // discountPercentage: json["discountPercentage"],
        // voucherDiscountPercentage: json["voucherDiscountPercentage"],
        discount: json["discount"],
        deliveryAmount: json["deliveryAmount"],
        holidaySurgeAmount: json["holidaySurgeAmount"],
        creditCardSurgeAmount: json["creditCardSurgeAmount"],
        creditCardSurchargePercentage: json["creditCardSurchargePercentage"],
        serviceChargePercentage: json["serviceChargePercentage"],
        discountWithTax: json["discountWithTax"],
        deliveryAmountWithTax: json["deliveryAmountWithTax"],
        holidaySurgeAmountWithTax: json["holidaySurgeAmountWithTax"],
        serviceChargeAmount: json["serviceChargeAmount"],
        creditCardSurgeAmountWithTax: json["creditCardSurgeAmountWithTax"],
        tipAmount: json["tipAmount"],
        orderPaymentsDetailsViewModels:
            json["orderPaymentsDetailsViewModels"] == null
                ? null
                : List<OrderPaymentsDetailsViewModel>.from(
                    json["orderPaymentsDetailsViewModels"]
                        .map((x) => OrderPaymentsDetailsViewModel.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "paymentStatus": paymentStatus,
        // "paidAmount": paidAmount,
        "remainingAmount": remainingAmount,
        // "discountPercentage": discountPercentage,
        // "voucherDiscountPercentage": voucherDiscountPercentage,
        "discount": discount,
        "deliveryAmount": deliveryAmount,
        "holidaySurgeAmount": holidaySurgeAmount,
        "creditCardSurgeAmount": creditCardSurgeAmount,
        "creditCardSurchargePercentage": creditCardSurchargePercentage,
        "serviceChargePercentage": serviceChargePercentage,
        "discountWithTax": discountWithTax,
        "deliveryAmountWithTax": deliveryAmountWithTax,
        "holidaySurgeAmountWithTax": holidaySurgeAmountWithTax,
        "creditCardSurgeAmountWithTax": creditCardSurgeAmountWithTax,
        "serviceChargeAmount": serviceChargeAmount,
        "tipAmount": tipAmount,
        "orderPaymentsDetailsViewModels": orderPaymentsDetailsViewModels == null
            ? null
            : List<dynamic>.from(
                orderPaymentsDetailsViewModels!.map((x) => x.toJson())),
      };
}

class OrderPaymentsDetailsViewModel {
  OrderPaymentsDetailsViewModel({
    this.id,
    this.paymentMethod,
    this.customerName,
    this.paidAmount,
    // this.holidaySurgeAmount,
    // this.creditCardSurgeAmount,
    this.tipAmount,
    // this.discount,
    // this.deliveryAmount,
    this.eftPosTransactionRefId,
    this.paymentDate,
  });

  String? id;
  String? paymentMethod;
  String? customerName;
  String? paidAmount;
  // String? holidaySurgeAmount;
  // String? creditCardSurgeAmount;
  String? tipAmount;
  // String? discount;
  // String? deliveryAmount;
  String? eftPosTransactionRefId;
  String? paymentDate;

  factory OrderPaymentsDetailsViewModel.fromJson(Map<String, dynamic> json) =>
      OrderPaymentsDetailsViewModel(
        id: json["id"],
        paymentMethod: json["paymentMethod"],
        customerName: json["customerName"],
        paidAmount: json["paidAmount"],
        // holidaySurgeAmount: json["holidaySurgeAmount"],
        // creditCardSurgeAmount: json["creditCardSurgeAmount"],
        tipAmount: json["tipAmount"],
        // discount: json["discount"],
        // deliveryAmount: json["deliveryAmount"],
        eftPosTransactionRefId: json["eftPOSTransactionRefId"],
        paymentDate: json["paymentDate"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "paymentMethod": paymentMethod,
        "customerName": customerName,
        "paidAmount": paidAmount,
        // "holidaySurgeAmount": holidaySurgeAmount,
        // "creditCardSurgeAmount": creditCardSurgeAmount,
        "tipAmount": tipAmount,
        // "discount": discount,
        // "deliveryAmount": deliveryAmount,
        "eftPOSTransactionRefId": eftPosTransactionRefId,
        "paymentDate": paymentDate,
      };
}

class ProductWithGroupPriceDetailsViewModel {
  String? groupKey;
  String? groupAmount;
  List<ViewModel>? productWithPriceDetailsViewModel;

  ProductWithGroupPriceDetailsViewModel({
    this.groupKey,
    this.groupAmount,
    this.productWithPriceDetailsViewModel,
  });

  factory ProductWithGroupPriceDetailsViewModel.fromJson(
          Map<String, dynamic> json) =>
      ProductWithGroupPriceDetailsViewModel(
        groupKey: json["groupKey"],
        groupAmount: json["groupAmount"],
        productWithPriceDetailsViewModel:
            json["productWithPriceDetailsViewModel"] == null
                ? []
                : List<ViewModel>.from(json["productWithPriceDetailsViewModel"]!
                    .map((x) => ViewModel.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "groupKey": groupKey,
        "groupAmount": groupAmount,
        "productWithPriceDetailsViewModel":
            productWithPriceDetailsViewModel == null
                ? []
                : List<dynamic>.from(
                    productWithPriceDetailsViewModel!.map((x) => x.toJson())),
      };
}

class RawIngredientWithPriceDetailsViewModel {
  String? id;
  String? unitOfMeasurementId;
  String? unitOfMeasurement;
  String? rawIngredientId;
  String? name;
  String? quantity;
  String? totalSellingPrice;
  String? totalTax;
  String? originalSellingPricePerUnit;
  String? maxToMinConversionFactor;
  //
  String? stockCount;
  // bool? isCancelled;
  String? taxValue;
  String? paidQuantity;
  String? paidAmount;
  String? currentPaidQuantity;
  String? surChargeAmount;
  bool? isPublicHolidaySurchargeUsed;
  bool? isCreditCardSurchargeUsed;
  String? discountPercentage;
  String? statusId;

  RawIngredientWithPriceDetailsViewModel({
    this.id,
    this.unitOfMeasurementId,
    this.unitOfMeasurement,
    this.rawIngredientId,
    this.name,
    this.quantity,
    this.totalSellingPrice,
    this.totalTax,
    this.originalSellingPricePerUnit,
    this.maxToMinConversionFactor,
    //
    this.stockCount,
    // this.isCancelled,
    this.taxValue,
    this.paidQuantity,
    this.paidAmount,
    this.currentPaidQuantity,
    this.surChargeAmount,
    this.isPublicHolidaySurchargeUsed,
    this.isCreditCardSurchargeUsed,
    this.discountPercentage,
    this.statusId,
  });

  factory RawIngredientWithPriceDetailsViewModel.fromJson(
          Map<String, dynamic> json) =>
      RawIngredientWithPriceDetailsViewModel(
        id: json["id"],
        unitOfMeasurementId: json["unitOfMeasurementId"],
        unitOfMeasurement: json["unitOfMeasurement"],
        rawIngredientId: json["rawLooseIngredientId"],
        name: json["name"],
        quantity: json["quantity"],
        totalSellingPrice: json["totalSellingPrice"],
        totalTax: json["totalTax"],
        originalSellingPricePerUnit: json["originalSellingPricePerUnit"],
        maxToMinConversionFactor: json["maxToMinConversionFactor"],
        //
        stockCount: json["stockCount"],
        // isCancelled: json["isCancelled"],
        taxValue: json["taxValue"],
        paidQuantity: json["paidQuantity"],
        paidAmount: json["paidAmount"],
        currentPaidQuantity: json["currentPaidQuantity"],
        surChargeAmount: json["surChargeAmount"],
        isPublicHolidaySurchargeUsed: json["isPublicHolidaySurchargeUsed"],
        isCreditCardSurchargeUsed: json["isCreditCardSurchargeUsed"],
        discountPercentage: json["discountPercentage"],
        statusId: json["statusId"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "unitOfMeasurementId": unitOfMeasurementId,
        "unitOfMeasurement": unitOfMeasurement,
        "rawLooseIngredientId": rawIngredientId,
        "name": name,
        "quantity": quantity,
        "totalSellingPrice": totalSellingPrice,
        "totalTax": totalTax,
        "originalSellingPricePerUnit": originalSellingPricePerUnit,
        "maxToMinConversionFactor": maxToMinConversionFactor,
        //
        "stockCount": stockCount,
        // "isCancelled": isCancelled,
        "taxValue": taxValue,
        "paidQuantity": paidQuantity,
        "paidAmount": paidAmount,
        "currentPaidQuantity": currentPaidQuantity,
        "surChargeAmount": surChargeAmount,
        "isPublicHolidaySurchargeUsed": isPublicHolidaySurchargeUsed,
        "isCreditCardSurchargeUsed": isCreditCardSurchargeUsed,
        "discountPercentage": discountPercentage,
        "statusId": statusId,
      };
}

// class PosDeliveryStoreInformation {
//   String? name;
//   String? address;
//   String? latitude;
//   String? longitude;
//   String? phoneNumber;
//   String? currencyCode;

//   PosDeliveryStoreInformation({
//     this.name,
//     this.address,
//     this.latitude,
//     this.longitude,
//     this.phoneNumber,
//     this.currencyCode,
//   });

//   factory PosDeliveryStoreInformation.fromJson(Map<String, dynamic> json) =>
//       PosDeliveryStoreInformation(
//         name: json["name"],
//         address: json["address"],
//         latitude: json["latitude"],
//         longitude: json["longitude"],
//         phoneNumber: json["phoneNumber"],
//         currencyCode: json["currencyCode"],
//       );

//   Map<String, dynamic> toJson() => {
//         "name": name,
//         "address": address,
//         "latitude": latitude,
//         "longitude": longitude,
//         "phoneNumber": phoneNumber,
//         "currencyCode": currencyCode,
//       };
// }
