class PlaceOrderRes {
  PlaceOrderRes({
    this.orderId,
    this.askForPrintConfirmation,
    this.message,
    this.url,
    this.printingDetailsResponseViewModels,
    // this.posThermalPrintTypeSetupResponseModels,
  });

  String? orderId;
  bool? askForPrintConfirmation;
  String? message;
  String? url;
  List<PrintingDetailsResponseViewModel>? printingDetailsResponseViewModels;
  // List<PosThermalPrintTypeSetupResponseModel>?
  //     posThermalPrintTypeSetupResponseModels;

  factory PlaceOrderRes.fromJson(Map<String, dynamic> json) => PlaceOrderRes(
        orderId: json["orderId"],
        askForPrintConfirmation: json["askForPrintConfirmation"],
        message: json["message"],
        url: json["url"],
        printingDetailsResponseViewModels:
            List<PrintingDetailsResponseViewModel>.from(
                json["printingDetailsResponseViewModels"]
                    .map((x) => PrintingDetailsResponseViewModel.fromJson(x))),
        // posThermalPrintTypeSetupResponseModels:
        //     json["posThermalPrintTypeSetupResponseModels"] == null
        //         ? []
        //         : List<PosThermalPrintTypeSetupResponseModel>.from(
        //             json["posThermalPrintTypeSetupResponseModels"]!.map((x) =>
        //                 PosThermalPrintTypeSetupResponseModel.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "orderId": orderId,
        "askForPrintConfirmation": askForPrintConfirmation,
        "message": message,
        "url": url,
        "printingDetailsResponseViewModels":
            printingDetailsResponseViewModels == null
                ? null
                : List<dynamic>.from(
                    printingDetailsResponseViewModels!.map((x) => x.toJson())),
        // "posThermalPrintTypeSetupResponseModels":
        //     posThermalPrintTypeSetupResponseModels == null
        //         ? []
        //         : List<dynamic>.from(posThermalPrintTypeSetupResponseModels!
        //             .map((x) => x.toJson())),
      };
}

class PrintingDetailsResponseViewModel {
  PrintingDetailsResponseViewModel({
    this.storeName,
    this.storeAddress,
    this.tableNumber,
    this.noOfCustomerOnTable,
    this.orderNumber,
    this.invoiceNumber,
    this.pickupDeliveryDate,
    this.abnNumber,
    this.deliveryLocation,
    this.date,
    this.posName,
    this.paperSize,
    this.orderType,
    this.servedBy,
    this.paymentProcessBy,
    this.channel,
    this.customerName,
    this.customerPhoneNumber,
    this.paymentMethod,
    this.taxExclusiveInclusiveType,
    this.description,
    this.discountWithTax,
    this.discount,
    this.totalAmount,
    this.publicHolidaySurCharge,
    this.creditCardSurchargeAmount,
    this.publicHolidaySurChargeWithTax,
    this.creditCardSurchargeAmountWithTax,
    this.deliveryAmount,
    this.deliveryAmountWithTax,
    this.tax,
    this.tipAmount,
    this.message,
    this.ipAddress,
    this.port,
    this.isBluetoothPrinter,
    this.orderPrintCopy,
    this.printBillCustomerCopy,
    this.openCashRegister,
    this.printEftPosSignature,
    this.orderItemsDetailsResponseViewModels,
    this.orderItemsDetailsResponseDocketGroupViewModels,
    this.setMenuOrderOrderDetailsResponseViewModels,
    this.printerType,
    this.docketNumber,
    this.tabName,
    this.printerName,
  });

  String? storeName;
  String? storeAddress;
  String? tableNumber;
  String? noOfCustomerOnTable;
  String? orderNumber;
  String? invoiceNumber;
  String? pickupDeliveryDate;
  String? abnNumber;
  String? deliveryLocation;
  String? date;
  String? posName;
  String? paperSize;
  String? orderType;
  String? servedBy;
  String? paymentProcessBy;
  String? channel;
  String? customerName;
  String? customerPhoneNumber;
  String? paymentMethod;
  String? taxExclusiveInclusiveType;
  String? description;
  String? discountWithTax;
  String? discount;
  String? totalAmount;
  String? publicHolidaySurCharge;
  String? creditCardSurchargeAmount;
  String? publicHolidaySurChargeWithTax;
  String? creditCardSurchargeAmountWithTax;
  String? deliveryAmount;
  String? deliveryAmountWithTax;
  String? tax;
  String? tipAmount;
  String? message;
  String? ipAddress;
  String? port;
  bool? isBluetoothPrinter;
  bool? orderPrintCopy;
  bool? printBillCustomerCopy;
  bool? openCashRegister;
  bool? printEftPosSignature;
  String? printerType;
  int? docketNumber;
  String? tabName;
  String? printerName;

  List<OrderItemsDetailsResponseViewModel>? orderItemsDetailsResponseViewModels;
  List<OrderItemsDetailsResponseDocketGroupViewModel>?
      orderItemsDetailsResponseDocketGroupViewModels;
  List<SetMenuOrderOrderDetailsResponseViewModel>?
      setMenuOrderOrderDetailsResponseViewModels;

  factory PrintingDetailsResponseViewModel.fromJson(
          Map<String, dynamic> json) =>
      PrintingDetailsResponseViewModel(
        storeName: json["storeName"],
        storeAddress: json["storeAddress"],
        tableNumber: json["tableNumber"],
        noOfCustomerOnTable: json["noOfCustomerOnTable"],
        orderNumber: json["orderNumber"],
        invoiceNumber: json["invoiceNumber"],
        pickupDeliveryDate: json["pickupDeliveryDate"],
        abnNumber: json["abnNumber"],
        deliveryLocation: json["deliveryLocation"],
        date: json["date"],
        posName: json["posName"],
        paperSize: json["paperSize"],
        orderType: json["orderType"],
        servedBy: json["servedBy"],
        paymentProcessBy: json["paymentProcessBy"],
        channel: json["channel"],
        customerName: json["customerName"],
        customerPhoneNumber: json["customerPhoneNumber"],
        paymentMethod: json["paymentMethod"],
        taxExclusiveInclusiveType: json["taxExclusiveInclusiveType"],
        description: json["description"],
        discountWithTax: json["discountWithTax"],
        discount: json["discount"],
        totalAmount: json["totalAmount"],
        publicHolidaySurCharge: json["publicHolidaySurCharge"],
        creditCardSurchargeAmount: json["creditCardSurchargeAmount"],
        publicHolidaySurChargeWithTax: json["publicHolidaySurChargeWithTax"],
        creditCardSurchargeAmountWithTax:
            json["creditCardSurchargeAmountWithTax"],
        deliveryAmount: json["deliveryAmount"],
        deliveryAmountWithTax: json["deliveryAmountWithTax"],
        tax: json["tax"],
        tipAmount: json["tipAmount"],
        message: json["message"],
        ipAddress: json["ipAddress"],
        port: json["port"],
        isBluetoothPrinter: json["isBluetoothPrinter"],
        orderPrintCopy: json["orderPrintCopy"],
        printBillCustomerCopy: json["printBillCustomerCopy"],
        openCashRegister: json["openCashRegister"],
        printEftPosSignature: json["printEftPosSignature"],
        orderItemsDetailsResponseViewModels:
            json["orderItemsDetailsResponseViewModels"] == null
                ? null
                : List<OrderItemsDetailsResponseViewModel>.from(
                    json["orderItemsDetailsResponseViewModels"].map(
                        (x) => OrderItemsDetailsResponseViewModel.fromJson(x))),
        orderItemsDetailsResponseDocketGroupViewModels:
            json["orderItemsDetailsResponseDocketGroupViewModels"] == null
                ? []
                : List<OrderItemsDetailsResponseDocketGroupViewModel>.from(
                    json["orderItemsDetailsResponseDocketGroupViewModels"]!.map(
                        (x) => OrderItemsDetailsResponseDocketGroupViewModel
                            .fromJson(x))),
        setMenuOrderOrderDetailsResponseViewModels:
            json["setMenuOrderOrderDetailsResponseViewModels"] == null
                ? null
                : List<SetMenuOrderOrderDetailsResponseViewModel>.from(json[
                        "setMenuOrderOrderDetailsResponseViewModels"]
                    .map((x) =>
                        SetMenuOrderOrderDetailsResponseViewModel.fromJson(x))),
        printerType: json["printerType"],
        docketNumber: json["docketNumber"],
        tabName: json["tabName"],
        printerName: json["printerName"],
      );

  Map<String, dynamic> toJson() => {
        "storeName": storeName,
        "storeAddress": storeAddress,
        "tableNumber": tableNumber,
        "noOfCustomerOnTable": noOfCustomerOnTable,
        "orderNumber": orderNumber,
        "invoiceNumber": invoiceNumber,
        "pickupDeliveryDate": pickupDeliveryDate,
        "abnNumber": abnNumber,
        "deliveryLocation": deliveryLocation,
        "date": date,
        "posName": posName,
        "paperSize": paperSize,
        "orderType": orderType,
        "servedBy": servedBy,
        "paymentProcessBy": paymentProcessBy,
        "channel": channel,
        "customerName": customerName,
        "customerPhoneNumber": customerPhoneNumber,
        "paymentMethod": paymentMethod,
        "taxExclusiveInclusiveType": taxExclusiveInclusiveType,
        "description": description,
        "discountWithTax": discountWithTax,
        "discount": discount,
        "totalAmount": totalAmount,
        "publicHolidaySurCharge": publicHolidaySurCharge,
        "creditCardSurchargeAmount": creditCardSurchargeAmount,
        "publicHolidaySurChargeWithTax": publicHolidaySurChargeWithTax,
        "creditCardSurchargeAmountWithTax": creditCardSurchargeAmountWithTax,
        "deliveryAmount": deliveryAmount,
        "deliveryAmountWithTax": deliveryAmountWithTax,
        "tax": tax,
        "tipAmount": tipAmount,
        "message": message,
        "ipAddress": ipAddress,
        "port": port,
        "isBluetoothPrinter": isBluetoothPrinter,
        "orderPrintCopy": orderPrintCopy,
        "printBillCustomerCopy": printBillCustomerCopy,
        "openCashRegister": openCashRegister,
        "printEftPosSignature": printEftPosSignature,
        "orderItemsDetailsResponseViewModels":
            orderItemsDetailsResponseViewModels == null
                ? null
                : List<dynamic>.from(orderItemsDetailsResponseViewModels!
                    .map((x) => x.toJson())),
        "orderItemsDetailsResponseDocketGroupViewModels":
            orderItemsDetailsResponseDocketGroupViewModels == null
                ? []
                : List<dynamic>.from(
                    orderItemsDetailsResponseDocketGroupViewModels!
                        .map((x) => x.toJson())),
        "setMenuOrderOrderDetailsResponseViewModels":
            setMenuOrderOrderDetailsResponseViewModels == null
                ? null
                : List<dynamic>.from(setMenuOrderOrderDetailsResponseViewModels!
                    .map((x) => x.toJson())),
        "printerType": printerType,
        "docketNumber": docketNumber,
        "tabName": tabName,
        "printerName": printerName,
      };
}

class OrderItemsDetailsResponseViewModel {
  OrderItemsDetailsResponseViewModel({
    this.itemName,
    this.docketGroupName,
    this.docketGroupSort,
    this.enableDocketGroupSpliter = false,
    this.quantity,
    this.originalQuantity,
    this.price,
    this.description,
    // this.isCancelled,
    this.modifiers,
    // this.spiceChoice,
    this.discountWithTax,
    this.discountWithoutTax,
    this.discountPercentage,
    this.halfGroupKey,
    this.halfGroupAmount,
    this.productType,
    this.productPriceType,
    // this.removeIngredients,
    this.status,
    this.updatedItemMessage,
    this.preparationType,
  });

  String? itemName;
  String? docketGroupName;
  int? docketGroupSort;
  bool enableDocketGroupSpliter;
  String? quantity;
  String? originalQuantity;
  String? price;
  String? description;
  // bool? isCancelled;
  List<Modifier>? modifiers;
  // OrderItemSpiceChoiceViewModel? spiceChoice;
  String? discountWithTax;
  String? discountWithoutTax;
  String? discountPercentage;
  String? halfGroupKey;
  String? halfGroupAmount;
  String? productType;
  // List<RemoveIngredient>? removeIngredients;
  String? status;
  String? updatedItemMessage;
  String? productPriceType;
  String? preparationType;

  factory OrderItemsDetailsResponseViewModel.fromJson(
          Map<String, dynamic> json) =>
      OrderItemsDetailsResponseViewModel(
        itemName: json["itemName"],
        docketGroupName: json["docketGroupName"],
        docketGroupSort: json["docketGroupSort"],
        enableDocketGroupSpliter: json["enableDocketGroupSpliter"],
        quantity: json["quantity"],
        originalQuantity: json["originalQuantity"],
        price: json["price"],
        description: json["description"],
        // isCancelled: json["isCancelled"],
        modifiers: json["modifiers"] == null
            ? null
            : List<Modifier>.from(
                json["modifiers"]!.map((x) => Modifier.fromJson(x))),
        // spiceChoice: json["spiceChoice"] == null
        //     ? null
        //     : OrderItemSpiceChoiceViewModel.fromJson(json["spiceChoice"]),
        discountWithTax: json["discountWithTax"],
        discountWithoutTax: json["discountWithoutTax"],
        discountPercentage: json["discountPercentage"],
        halfGroupKey: json["halfGroupKey"],
        halfGroupAmount: json["halfGroupAmount"],
        productType: json["productType"],
        productPriceType: json["productPriceType"],
        // removeIngredients: json["removeIngredients"] == null
        //     ? []
        //     : List<RemoveIngredient>.from(json["removeIngredients"]!
        //         .map((x) => RemoveIngredient.fromJson(x))),
        status: json["status"],
        updatedItemMessage: json["updatedItemMessage"],
        preparationType: json["preparationType"],
      );

  Map<String, dynamic> toJson() => {
        "itemName": itemName,
        "docketGroupName": docketGroupName,
        "docketGroupSort": docketGroupSort,
        "enableDocketGroupSpliter": enableDocketGroupSpliter,
        "quantity": quantity,
        "originalQuantity": originalQuantity,
        "price": price,
        "description": description,
        // "isCancelled": isCancelled,
        "modifiers": modifiers == null
            ? null
            : List<dynamic>.from(modifiers!.map((x) => x.toJson())),
        // "spiceChoice": spiceChoice?.toJson(),
        "discountWithTax": discountWithTax,
        "discountWithoutTax": discountWithoutTax,
        "discountPercentage": discountPercentage,
        "halfGroupKey": halfGroupKey,
        "halfGroupAmount": halfGroupAmount,
        "productType": productType,
        "productPriceType": productPriceType,
        // "removeIngredients": removeIngredients == null
        //     ? []
        //     : List<dynamic>.from(removeIngredients!.map((x) => x.toJson())),
        "status": status,
        "updatedItemMessage": updatedItemMessage,
        "preparationType": preparationType,
      };
}

class SetMenuOrderOrderDetailsResponseViewModel {
  SetMenuOrderOrderDetailsResponseViewModel({
    this.setMenuName,
    this.quantity,
    this.originalQuantity,
    // this.isCancelled,
    this.orderItemsDetailsResponseViewModels,
    this.description,
    this.price,
    this.status,
  });

  String? setMenuName;
  String? quantity;
  String? originalQuantity;
  // bool? isCancelled;
  String? description;
  List<OrderItemsDetailsResponseViewModel>? orderItemsDetailsResponseViewModels;
  String? price;
  String? status;

  factory SetMenuOrderOrderDetailsResponseViewModel.fromJson(
          Map<String, dynamic> json) =>
      SetMenuOrderOrderDetailsResponseViewModel(
        setMenuName: json["setMenuName"],
        quantity: json["quantity"],
        originalQuantity: json["originalQuantity"],
        // isCancelled: json["isCancelled"],
        description: json["description"],
        price: json["price"],
        orderItemsDetailsResponseViewModels:
            json["orderItemsDetailsResponseViewModels"] == null
                ? null
                : List<OrderItemsDetailsResponseViewModel>.from(
                    json["orderItemsDetailsResponseViewModels"].map(
                        (x) => OrderItemsDetailsResponseViewModel.fromJson(x))),
        status: json["status"],
      );

  Map<String, dynamic> toJson() => {
        "setMenuName": setMenuName,
        "quantity": quantity,
        "originalQuantity": originalQuantity,
        // "isCancelled": isCancelled,
        "description": description,
        "price": price,
        "orderItemsDetailsResponseViewModels":
            orderItemsDetailsResponseViewModels == null
                ? null
                : List<dynamic>.from(orderItemsDetailsResponseViewModels!
                    .map((x) => x.toJson())),
        "status": status,
      };
}

class Modifier {
  String? id;
  String? modifierName;
  String? modifierPrice;
  String? totalModifierPrice;
  String? quantity;
  dynamic priceVariationModifierId;
  String? totalTax;
  String? labelName;
  bool? isCancelled;
  String? type;
  String? kitchenStatus;
  List<Modifier>? modifierItemsModifierViewModels;

  Modifier({
    this.id,
    this.modifierName,
    this.modifierPrice,
    this.totalModifierPrice,
    this.quantity,
    this.priceVariationModifierId,
    this.totalTax,
    this.labelName,
    this.isCancelled,
    this.type,
    this.kitchenStatus,
    this.modifierItemsModifierViewModels,
  });

  factory Modifier.fromJson(Map<String, dynamic> json) => Modifier(
        id: json["id"],
        modifierName: json["modifierName"],
        modifierPrice: json["modifierPrice"],
        totalModifierPrice: json["totalModifierPrice"],
        quantity: json["quantity"],
        priceVariationModifierId: json["productVariationModifierItemId"],
        totalTax: json["totalTax"],
        labelName: json["labelName"],
        isCancelled: json["isCancelled"],
        type: json["type"],
        kitchenStatus: json["kitchenStatus"],
        modifierItemsModifierViewModels:
            json["modifierItemsModifierViewModels"] == null
                ? null
                : List<Modifier>.from(json["modifierItemsModifierViewModels"]!
                    .map((x) => Modifier.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "modifierName": modifierName,
        "modifierPrice": modifierPrice,
        "totalModifierPrice": totalModifierPrice,
        "quantity": quantity,
        "productVariationModifierItemId": priceVariationModifierId,
        "totalTax": totalTax,
        "labelName": labelName,
        "isCancelled": isCancelled,
        "type": type,
        "kitchenStatus": kitchenStatus,
        "modifierItemsModifierViewModels":
            modifierItemsModifierViewModels == null
                ? null
                : List<dynamic>.from(
                    modifierItemsModifierViewModels!.map((x) => x.toJson())),
      };
}

class OrderItemsDetailsResponseDocketGroupViewModel {
  String? docketGroupName;
  bool? enableDocketGroupSpliter;
  List<OrderItemsDetailsResponseViewModel>? orderItemsDetailsResponseViewModels;

  OrderItemsDetailsResponseDocketGroupViewModel({
    this.docketGroupName,
    this.enableDocketGroupSpliter,
    this.orderItemsDetailsResponseViewModels,
  });

  factory OrderItemsDetailsResponseDocketGroupViewModel.fromJson(
          Map<String, dynamic> json) =>
      OrderItemsDetailsResponseDocketGroupViewModel(
        docketGroupName: json["docketGroupName"],
        enableDocketGroupSpliter: json["enableDocketGroupSpliter"],
        orderItemsDetailsResponseViewModels:
            json["orderItemsDetailsResponseViewModels"] == null
                ? []
                : List<OrderItemsDetailsResponseViewModel>.from(
                    json["orderItemsDetailsResponseViewModels"]!.map(
                        (x) => OrderItemsDetailsResponseViewModel.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "docketGroupName": docketGroupName,
        "enableDocketGroupSpliter": enableDocketGroupSpliter,
        "orderItemsDetailsResponseViewModels":
            orderItemsDetailsResponseViewModels == null
                ? []
                : List<dynamic>.from(orderItemsDetailsResponseViewModels!
                    .map((x) => x.toJson())),
      };
}

class RemoveIngredient {
  String? name;
  String? id;

  RemoveIngredient({
    this.name,
    this.id,
  });

  factory RemoveIngredient.fromJson(Map<String, dynamic> json) =>
      RemoveIngredient(
        name: json["name"],
        id: json["id"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "id": id,
      };
}

class PosThermalPrintTypeSetupResponseModel {
  String? id;
  String? name;
  bool isActive;
  bool? enableAmount;
  int? fontSize;
  String? fontStyle;
  int? sortOrder;
  String? group;

  PosThermalPrintTypeSetupResponseModel({
    this.id,
    this.name,
    this.isActive = true,
    this.enableAmount,
    this.fontSize,
    this.fontStyle,
    this.sortOrder,
    this.group,
  });

  factory PosThermalPrintTypeSetupResponseModel.fromJson(
          Map<String, dynamic> json) =>
      PosThermalPrintTypeSetupResponseModel(
        id: json["id"],
        name: json["name"],
        isActive: json["isActive"] ?? true,
        enableAmount: json["enableAmount"],
        fontSize: json["fontSize"],
        fontStyle: json["fontStyle"],
        sortOrder: json["sortOrder"],
        group: json["group"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "isActive": isActive,
        "enableAmount": enableAmount,
        "fontSize": fontSize,
        "fontStyle": fontStyle,
        "sortOrder": sortOrder,
        "group": group,
      };
}
