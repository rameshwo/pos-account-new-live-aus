class TaxInExReq {
  String? id;
  String? taxTypeId;
  String? name;
  String? value;
  bool? isActive;
  bool? isDefault;
  List<TaxRule>? taxRules;

  TaxInExReq({
    this.id,
    this.taxTypeId,
    this.name,
    this.value,
    this.isActive,
    this.isDefault,
    this.taxRules,
  });

  factory TaxInExReq.fromJson(Map<String, dynamic> json) => TaxInExReq(
        id: json["id"],
        taxTypeId: json["taxTypeId"],
        name: json["name"],
        value: json["value"],
        isActive: json["isActive"],
        isDefault: json["isDefault"],
        taxRules: json["taxRules"] == null
            ? []
            : List<TaxRule>.from(
                json["taxRules"]!.map((x) => TaxRule.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "taxTypeId": taxTypeId,
        "name": name,
        "value": value,
        "isActive": isActive,
        "isDefault": isDefault,
        "taxRules": taxRules == null
            ? []
            : List<dynamic>.from(taxRules!.map((x) => x.toJson())),
      };
}

class TaxRule {
  String? id;
  String? name;
  List<TaxRuleCondition>? taxRuleConditions;

  TaxRule({
    this.id,
    this.name,
    this.taxRuleConditions,
  });

  factory TaxRule.fromJson(Map<String, dynamic> json) => TaxRule(
        id: json["id"],
        name: json["name"],
        taxRuleConditions: json["taxRuleConditions"] == null
            ? []
            : List<TaxRuleCondition>.from(json["taxRuleConditions"]!
                .map((x) => TaxRuleCondition.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "taxRuleConditions": taxRuleConditions == null
            ? []
            : List<dynamic>.from(taxRuleConditions!.map((x) => x.toJson())),
      };
}

class TaxRuleCondition {
  String? id;
  String? orderTypeId;
  String? value;

  TaxRuleCondition({
    this.id,
    this.orderTypeId,
    this.value,
  });

  factory TaxRuleCondition.fromJson(Map<String, dynamic> json) =>
      TaxRuleCondition(
        id: json["id"],
        orderTypeId: json["orderTypeId"],
        value: json["value"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "orderTypeId": orderTypeId,
        "value": value,
      };
}
