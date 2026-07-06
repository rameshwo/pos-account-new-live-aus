import 'package:pos_account/model/common/message.dart';

class KitAllOrders {
  List<KitOrderData>? data;
  List<Message>? message;
  int? total;
  bool? isError;
  int? status;

  KitAllOrders({
    this.data,
    this.message,
    this.total,
    this.isError,
    this.status,
  });

  factory KitAllOrders.fromJson(Map<String, dynamic> json) => KitAllOrders(
        data: json["data"] == null
            ? []
            : List<KitOrderData>.from(
                json["data"]!.map((x) => KitOrderData.fromJson(x))),
        message: json["message"] == null
            ? []
            : List<Message>.from(
                json["message"]!.map((x) => Message.fromJson(x))),
        total: json["total"],
        isError: json["isError"],
        status: json["status"],
      );

  Map<String, dynamic> toJson() => {
        "data": data == null
            ? []
            : List<dynamic>.from(data!.map((x) => x.toJson())),
        "message": message == null
            ? []
            : List<dynamic>.from(message!.map((x) => x.toJson())),
        "total": total,
        "isError": isError,
        "status": status,
      };
}

class KitOrderData {
  String? id;
  String? customerName;
  String? orderType;
  String? orderNumber;
  String? orderedDate;
  String? pickUpDeliveryDate;
  String? servedBy;
  List<OrderItem>? orderItems;
  List<SetMenuOrder>? setMenuOrders;
  int? total;
  String? tableNumber;
  String? prioritizeSortOrder;
  String? orderStatus;

  KitOrderData({
    this.id,
    this.customerName,
    this.orderType,
    this.orderNumber,
    this.orderedDate,
    this.pickUpDeliveryDate,
    this.servedBy,
    this.orderItems,
    this.setMenuOrders,
    this.total,
    this.tableNumber,
    this.prioritizeSortOrder,
    this.orderStatus,
  });

  factory KitOrderData.fromJson(Map<String, dynamic> json) => KitOrderData(
        id: json["id"],
        customerName: json["customerName"],
        orderType: json["orderType"],
        orderNumber: json["orderNumber"],
        orderedDate: json["orderedDate"],
        pickUpDeliveryDate: json["pickUpDeliveryDate"],
        servedBy: json["servedBy"],
        orderItems: json["orderItems"] == null
            ? []
            : List<OrderItem>.from(
                json["orderItems"]!.map((x) => OrderItem.fromJson(x))),
        setMenuOrders: json["setMenuOrders"] == null
            ? []
            : List<SetMenuOrder>.from(
                json["setMenuOrders"]!.map((x) => SetMenuOrder.fromJson(x))),
        total: json["total"],
        tableNumber: json["tableNumber"],
        prioritizeSortOrder: json["prioritizeSortOrder"],
        orderStatus: json["orderStatus"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "customerName": customerName,
        "orderType": orderType,
        "orderNumber": orderNumber,
        "orderedDate": orderedDate,
        "pickUpDeliveryDate": pickUpDeliveryDate,
        "servedBy": servedBy,
        "orderItems": orderItems == null
            ? []
            : List<dynamic>.from(orderItems!.map((x) => x.toJson())),
        "setMenuOrders": setMenuOrders == null
            ? []
            : List<dynamic>.from(setMenuOrders!.map((x) => x.toJson())),
        "total": total,
        "tableNumber": tableNumber,
        "prioritizeSortOrder": prioritizeSortOrder,
        "orderStatus": orderStatus,
      };
}

class OrderItem {
  String? id;
  String? itemName;
  String? quantity;
  String? price;
  String? description;
  String? docketGroupName;
  bool? isCancelled;
  bool? enableDocketGroupSpliter;
  String? docketGroupSortOrder;
  List<OrderItemModifier>? orderItemModifiers;
  List<OrderItemSpiceChoice>? orderItemSpiceChoices;
  List<OrderItemRemovedIngredient>? orderItemRemovedIngredients;
  bool? isPrepared;
  String? itemStatus;

  OrderItem({
    this.id,
    this.itemName,
    this.quantity,
    this.price,
    this.description,
    this.docketGroupName,
    this.isCancelled,
    this.enableDocketGroupSpliter,
    this.docketGroupSortOrder,
    this.orderItemModifiers,
    this.orderItemSpiceChoices,
    this.orderItemRemovedIngredients,
    this.isPrepared,
    this.itemStatus,
  });

  factory OrderItem.fromJson(Map<String, dynamic> json) => OrderItem(
        id: json["id"],
        itemName: json["itemName"],
        quantity: json["quantity"],
        price: json["price"],
        description: json["description"],
        docketGroupName: json["docketGroupName"],
        isCancelled: json["isCancelled"],
        enableDocketGroupSpliter: json["enableDocketGroupSpliter"],
        docketGroupSortOrder: json["docketGroupSortOrder"],
        orderItemModifiers: json["orderItemModifiers"] == null
            ? []
            : List<OrderItemModifier>.from(json["orderItemModifiers"]!
                .map((x) => OrderItemModifier.fromJson(x))),
        orderItemSpiceChoices: json["orderItemSpiceChoices"] == null
            ? []
            : List<OrderItemSpiceChoice>.from(json["orderItemSpiceChoices"]!
                .map((x) => OrderItemSpiceChoice.fromJson(x))),
        orderItemRemovedIngredients: json["orderItemRemovedIngredients"] == null
            ? []
            : List<OrderItemRemovedIngredient>.from(
                json["orderItemRemovedIngredients"]!
                    .map((x) => OrderItemRemovedIngredient.fromJson(x))),
        isPrepared: json["isPrepared"],
        itemStatus: json["itemStatus"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "itemName": itemName,
        "quantity": quantity,
        "price": price,
        "description": description,
        "docketGroupName": docketGroupName,
        "isCancelled": isCancelled,
        "enableDocketGroupSpliter": enableDocketGroupSpliter,
        "docketGroupSortOrder": docketGroupSortOrder,
        "orderItemModifiers": orderItemModifiers == null
            ? []
            : List<dynamic>.from(orderItemModifiers!.map((x) => x.toJson())),
        "orderItemSpiceChoices": orderItemSpiceChoices == null
            ? []
            : List<dynamic>.from(orderItemSpiceChoices!.map((x) => x.toJson())),
        "orderItemRemovedIngredients": orderItemRemovedIngredients == null
            ? []
            : List<dynamic>.from(
                orderItemRemovedIngredients!.map((x) => x.toJson())),
        "isPrepared": isPrepared,
        "itemStatus": itemStatus,
      };
}

class OrderItemRemovedIngredient {
  String? id;
  String? name;

  OrderItemRemovedIngredient({
    this.id,
    this.name,
  });

  factory OrderItemRemovedIngredient.fromJson(Map<String, dynamic> json) =>
      OrderItemRemovedIngredient(
        id: json["id"],
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
      };
}

class OrderItemSpiceChoice {
  String? name;

  OrderItemSpiceChoice({
    this.name,
  });

  factory OrderItemSpiceChoice.fromJson(Map<String, dynamic> json) =>
      OrderItemSpiceChoice(
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
      };
}

class OrderItemModifier {
  String? labelName;
  String? modifierName;
  String? modifierPrice;
  String? totalModifierPrice;
  String? quantity;
  String? totalTax;

  OrderItemModifier({
    this.labelName,
    this.modifierName,
    this.modifierPrice,
    this.totalModifierPrice,
    this.quantity,
    this.totalTax,
  });

  factory OrderItemModifier.fromJson(Map<String, dynamic> json) =>
      OrderItemModifier(
        labelName: json["labelName"],
        modifierName: json["modifierName"],
        modifierPrice: json["modifierPrice"],
        totalModifierPrice: json["totalModifierPrice"],
        quantity: json["quantity"],
        totalTax: json["totalTax"],
      );

  Map<String, dynamic> toJson() => {
        "labelName": labelName,
        "modifierName": modifierName,
        "modifierPrice": modifierPrice,
        "totalModifierPrice": totalModifierPrice,
        "quantity": quantity,
        "totalTax": totalTax,
      };
}

class SetMenuOrder {
  String? setMenuName;
  String? quantity;
  String? price;
  String? description;
  bool? isCancelled;
  List<SetMenuOrderItem>? setMenuOrderItems;

  SetMenuOrder({
    this.setMenuName,
    this.quantity,
    this.price,
    this.description,
    this.isCancelled,
    this.setMenuOrderItems,
  });

  factory SetMenuOrder.fromJson(Map<String, dynamic> json) => SetMenuOrder(
        setMenuName: json["setMenuName"],
        quantity: json["quantity"],
        price: json["price"],
        description: json["description"],
        isCancelled: json["isCancelled"],
        setMenuOrderItems: json["setMenuOrderItems"] == null
            ? []
            : List<SetMenuOrderItem>.from(json["setMenuOrderItems"]!
                .map((x) => SetMenuOrderItem.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "setMenuName": setMenuName,
        "quantity": quantity,
        "price": price,
        "description": description,
        "isCancelled": isCancelled,
        "setMenuOrderItems": setMenuOrderItems == null
            ? []
            : List<dynamic>.from(setMenuOrderItems!.map((x) => x.toJson())),
      };
}

class SetMenuOrderItem {
  String? id;
  String? itemName;
  String? quantity;
  String? description;
  List<OrderItemModifier>? setMenuOrderItemModifiers;
  List<OrderItemSpiceChoice>? setMenuOrderItemRemovedIngredients;
  bool? isPrepared;

  SetMenuOrderItem({
    this.id,
    this.itemName,
    this.quantity,
    this.description,
    this.setMenuOrderItemModifiers,
    this.setMenuOrderItemRemovedIngredients,
    this.isPrepared,
  });

  factory SetMenuOrderItem.fromJson(Map<String, dynamic> json) =>
      SetMenuOrderItem(
        id: json["id"],
        itemName: json["itemName"],
        quantity: json["quantity"],
        description: json["description"],
        setMenuOrderItemModifiers: json["setMenuOrderItemModifiers"] == null
            ? []
            : List<OrderItemModifier>.from(json["setMenuOrderItemModifiers"]!
                .map((x) => OrderItemModifier.fromJson(x))),
        setMenuOrderItemRemovedIngredients:
            json["setMenuOrderItemRemovedIngredients"] == null
                ? []
                : List<OrderItemSpiceChoice>.from(
                    json["setMenuOrderItemRemovedIngredients"]!
                        .map((x) => OrderItemSpiceChoice.fromJson(x))),
        isPrepared: json["isPrepared"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "itemName": itemName,
        "quantity": quantity,
        "description": description,
        "setMenuOrderItemModifiers": setMenuOrderItemModifiers == null
            ? []
            : List<dynamic>.from(
                setMenuOrderItemModifiers!.map((x) => x.toJson())),
        "setMenuOrderItemRemovedIngredients":
            setMenuOrderItemRemovedIngredients == null
                ? []
                : List<dynamic>.from(
                    setMenuOrderItemRemovedIngredients!.map((x) => x.toJson())),
        "isPrepared": isPrepared,
      };
}
