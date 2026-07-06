class AllPromotionRes {
  List<Promotion>? promotions;
  List<PromotionProduct>? promotionProducts;

  AllPromotionRes({
    this.promotions,
    this.promotionProducts,
  });

  factory AllPromotionRes.fromJson(Map<String, dynamic> json) =>
      AllPromotionRes(
        promotions: json["promotions"] == null
            ? []
            : List<Promotion>.from(
                json["promotions"]!.map((x) => Promotion.fromJson(x))),
        promotionProducts: json["promotionProducts"] == null
            ? []
            : List<PromotionProduct>.from(json["promotionProducts"]!
                .map((x) => PromotionProduct.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "promotions": promotions == null
            ? []
            : List<dynamic>.from(promotions!.map((x) => x.toJson())),
        "promotionProducts": promotionProducts == null
            ? []
            : List<dynamic>.from(promotionProducts!.map((x) => x.toJson())),
      };
}

class PromotionProduct {
  String? promotionId;
  List<PromotionConditionProduct>? promotionConditionProducts;
  List<dynamic>? promotionActionProducts;
  List<PromotionSchedule>? promotionSchedules;

  PromotionProduct({
    this.promotionId,
    this.promotionConditionProducts,
    this.promotionActionProducts,
    this.promotionSchedules,
  });

  factory PromotionProduct.fromJson(Map<String, dynamic> json) =>
      PromotionProduct(
        promotionId: json["promotionId"],
        promotionConditionProducts: json["promotionConditionProducts"] == null
            ? []
            : List<PromotionConditionProduct>.from(
                json["promotionConditionProducts"]!
                    .map((x) => PromotionConditionProduct.fromJson(x))),
        promotionActionProducts: json["promotionActionProducts"] == null
            ? []
            : List<dynamic>.from(
                json["promotionActionProducts"]!.map((x) => x)),
        promotionSchedules: json["promotionSchedules"] == null
            ? []
            : List<PromotionSchedule>.from(json["promotionSchedules"]!
                .map((x) => PromotionSchedule.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "promotionId": promotionId,
        "promotionConditionProducts": promotionConditionProducts == null
            ? []
            : List<dynamic>.from(
                promotionConditionProducts!.map((x) => x.toJson())),
        "promotionActionProducts": promotionActionProducts == null
            ? []
            : List<dynamic>.from(promotionActionProducts!.map((x) => x)),
        "promotionSchedules": promotionSchedules == null
            ? []
            : List<dynamic>.from(promotionSchedules!.map((x) => x.toJson())),
      };
}

class PromotionConditionProduct {
  String? id;
  // String? discountType;
  // String? amountDiscountValue;
  List<ProductVariationId>? productVariations;

  PromotionConditionProduct({
    this.id,
    // this.discountType,
    // this.amountDiscountValue,
    this.productVariations,
  });

  factory PromotionConditionProduct.fromJson(Map<String, dynamic> json) =>
      PromotionConditionProduct(
        id: json["id"],
        // discountType: json["discountType"],
        // amountDiscountValue: json["amountDiscountValue"],
        productVariations: json["productVariations"] == null
            ? []
            : List<ProductVariationId>.from(json["productVariations"]!
                .map((x) => ProductVariationId.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        // "discountType": discountType,
        // "amountDiscountValue": amountDiscountValue,
        "productVariations": productVariations == null
            ? []
            : List<dynamic>.from(productVariations!.map((x) => x.toJson())),
      };
}

class Promotion {
  String? id;
  String? name;
  String? description;
  bool? isActive;
  String? promotionType;
  String? promotionScheduleType;
  String? startDate;
  String? endDate;
  String? customerTargetGroup;
  String? customerGroupId;
  String? customerGroupName;
  bool? isRecurring;
  String? conditionName;
  String? conditionProductGroupType;
  String? conditionDiscountType;
  String? conditionAmountQuantityDiscountValue;
  String? conditionProductIncludeExcludeType;
  String? actionName;
  String? actionProductGroupType;
  String? actionDiscountType;
  String? actionAmountDiscountValue;
  String? actionProductIncludeExcludeType;
  String? actionEligibilityType;
  String? actionQuantity;

  Promotion({
    this.id,
    this.name,
    this.description,
    this.isActive,
    this.promotionType,
    this.promotionScheduleType,
    this.startDate,
    this.endDate,
    this.customerTargetGroup,
    this.customerGroupId,
    this.customerGroupName,
    this.isRecurring,
    this.conditionName,
    this.conditionProductGroupType,
    this.conditionDiscountType,
    this.conditionAmountQuantityDiscountValue,
    this.conditionProductIncludeExcludeType,
    this.actionName,
    this.actionProductGroupType,
    this.actionDiscountType,
    this.actionAmountDiscountValue,
    this.actionProductIncludeExcludeType,
    this.actionEligibilityType,
    this.actionQuantity,
  });

  factory Promotion.fromJson(Map<String, dynamic> json) => Promotion(
        id: json["id"],
        name: json["name"],
        description: json["description"],
        isActive: json["isActive"],
        promotionType: json["promotionType"],
        promotionScheduleType: json["promotionScheduleType"],
        startDate: json["startDate"],
        endDate: json["endDate"],
        customerTargetGroup: json["customerTargetGroup"],
        customerGroupId: json["customerGroupId"],
        customerGroupName: json["customerGroupName"],
        isRecurring: json["isRecurring"],
        conditionName: json["conditionName"],
        conditionProductGroupType: json["conditionProductGroupType"],
        conditionDiscountType: json["conditionDiscountType"],
        conditionAmountQuantityDiscountValue:
            json["conditionAmountQuantityDiscountValue"],
        conditionProductIncludeExcludeType:
            json["conditionProductIncludeExcludeType"],
        actionName: json["actionName"],
        actionProductGroupType: json["actionProductGroupType"],
        actionDiscountType: json["actionDiscountType"],
        actionAmountDiscountValue: json["actionAmountDiscountValue"],
        actionProductIncludeExcludeType:
            json["actionProductIncludeExcludeType"],
        actionEligibilityType: json["actionEligibilityType"],
        actionQuantity: json["actionQuantity"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "description": description,
        "isActive": isActive,
        "promotionType": promotionType,
        "promotionScheduleType": promotionScheduleType,
        "startDate": startDate,
        "endDate": endDate,
        "customerTargetGroup": customerTargetGroup,
        "customerGroupId": customerGroupId,
        "customerGroupName": customerGroupName,
        "isRecurring": isRecurring,
        "conditionName": conditionName,
        "conditionProductGroupType": conditionProductGroupType,
        "conditionDiscountType": conditionDiscountType,
        "conditionAmountQuantityDiscountValue":
            conditionAmountQuantityDiscountValue,
        "conditionProductIncludeExcludeType":
            conditionProductIncludeExcludeType,
        "actionName": actionName,
        "actionProductGroupType": actionProductGroupType,
        "actionDiscountType": actionDiscountType,
        "actionAmountDiscountValue": actionAmountDiscountValue,
        "actionProductIncludeExcludeType": actionProductIncludeExcludeType,
        "actionEligibilityType": actionEligibilityType,
        "actionQuantity": actionQuantity,
      };
}

class PromotionSchedule {
  String? scheduledDay;
  String? timeFrom;
  String? timeTo;

  PromotionSchedule({
    this.scheduledDay,
    this.timeFrom,
    this.timeTo,
  });

  factory PromotionSchedule.fromJson(Map<String, dynamic> json) =>
      PromotionSchedule(
        scheduledDay: json["scheduledDay"],
        timeFrom: json["timeFrom"],
        timeTo: json["timeTo"],
      );

  Map<String, dynamic> toJson() => {
        "scheduledDay": scheduledDay,
        "timeFrom": timeFrom,
        "timeTo": timeTo,
      };
}

class ProductVariationId {
  String? id;
  String? name;
  String? amountDiscountValue;
  String? discountType;

  ProductVariationId({
    this.id,
    this.name,
    this.amountDiscountValue,
    this.discountType,
  });

  factory ProductVariationId.fromJson(Map<String, dynamic> json) =>
      ProductVariationId(
        id: json["id"],
        name: json["name"],
        amountDiscountValue: json["amountDiscountValue"],
        discountType: json["discountType"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "amountDiscountValue": amountDiscountValue,
        "discountType": discountType,
      };
}
