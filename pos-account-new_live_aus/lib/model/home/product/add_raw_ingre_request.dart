class AddRawIngreRequest {
  String? code;
  String? name;
  String? productCategoryId;
  String? unitPricePerUnit;
  String? sellingPricePerUnit;
  String? purchaseTaxId;
  String? salesTaxId;
  String? wastagePercentage;
  String? unitOfMeasurementId;
  bool? isActive;
  List<RawLooseIngredientSupplier>? rawLooseIngredientSupplier;
  String? id;
  List<String>? deletedRawLooseIngredientSuppliersIds;

  AddRawIngreRequest(
      {this.code,
      this.name,
      this.productCategoryId,
      this.unitPricePerUnit,
      this.sellingPricePerUnit,
      this.purchaseTaxId,
      this.salesTaxId,
      this.wastagePercentage,
      this.unitOfMeasurementId,
      this.isActive,
      this.rawLooseIngredientSupplier,
      this.id,
      this.deletedRawLooseIngredientSuppliersIds});

  AddRawIngreRequest.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    name = json['name'];
    productCategoryId = json['productCategoryId'];
    unitPricePerUnit = json['unitPricePerUnit'];
    sellingPricePerUnit = json['sellingPricePerUnit'];
    purchaseTaxId = json['purchaseTaxId'];
    salesTaxId = json['salesTaxId'];
    wastagePercentage = json['wastagePercentage'];
    unitOfMeasurementId = json['unitOfMeasurementId'];
    isActive = json['isActive'];
    if (json['rawLooseIngredientSupplier'] != null) {
      rawLooseIngredientSupplier = <RawLooseIngredientSupplier>[];
      json['rawLooseIngredientSupplier'].forEach((v) {
        rawLooseIngredientSupplier!.add(RawLooseIngredientSupplier.fromJson(v));
      });
    }
    id = json['id'];
    if (json['deletedRawLooseIngredientSuppliersIds'] != null) {
      deletedRawLooseIngredientSuppliersIds = <String>[];
      json['deletedRawLooseIngredientSuppliersIds'].forEach((v) {
        deletedRawLooseIngredientSuppliersIds!.add(v);
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['code'] = code;
    data['name'] = name;
    data['productCategoryId'] = productCategoryId;
    data['unitPricePerUnit'] = unitPricePerUnit;
    data['sellingPricePerUnit'] = sellingPricePerUnit;
    data['purchaseTaxId'] = purchaseTaxId;
    data['salesTaxId'] = salesTaxId;
    data['wastagePercentage'] = wastagePercentage;
    data['unitOfMeasurementId'] = unitOfMeasurementId;
    data['isActive'] = isActive;
    if (rawLooseIngredientSupplier != null) {
      data['rawLooseIngredientSupplier'] =
          rawLooseIngredientSupplier!.map((v) => v.toJson()).toList();
    }
    data['id'] = id;
    if (deletedRawLooseIngredientSuppliersIds != null) {
      data['deletedRawLooseIngredientSuppliersIds'] =
          deletedRawLooseIngredientSuppliersIds;
    }
    return data;
  }
}

class RawLooseIngredientSupplier {
  String? supplierItemCode;

  RawLooseIngredientSupplier({this.supplierItemCode});

  RawLooseIngredientSupplier.fromJson(Map<String, dynamic> json) {
    supplierItemCode = json['supplierItemCode'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['supplierItemCode'] = supplierItemCode;
    return data;
  }
}
