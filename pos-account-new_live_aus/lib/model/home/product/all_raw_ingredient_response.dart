class AllRawIngredientResponse {
  List<RawIngredientData>? data;
  List<String>? message;
  int? total;
  bool? isError;
  int? status;

  AllRawIngredientResponse(
      {this.data, this.message, this.total, this.isError, this.status});

  AllRawIngredientResponse.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <RawIngredientData>[];
      json['data'].forEach((v) {
        data!.add(RawIngredientData.fromJson(v));
      });
    }
    if (json['message'] != null) {
      message = <String>[];
      json['message'].forEach((v) {
        message!.add(v);
      });
    }
    total = json['total'];
    isError = json['isError'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    if (message != null) {
      data['message'] = message;
    }
    data['total'] = total;
    data['isError'] = isError;
    data['status'] = status;
    return data;
  }
}

class RawIngredientData {
  String? id;
  String? name;
  String? unitOfMeasurement;
  String? wastagePercentage;
  String? unitPricePerUnit;
  String? sellingPricePerUnit;
  String? availiableStock;
  String? wastageStock;
  dynamic stock;
  int? total;
  String? category;

  RawIngredientData(
      {this.id,
      this.name,
      this.unitOfMeasurement,
      this.wastagePercentage,
      this.unitPricePerUnit,
      this.sellingPricePerUnit,
      this.availiableStock,
      this.wastageStock,
      this.stock,
      this.category,
      this.total});

  RawIngredientData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    unitOfMeasurement = json['unitOfMeasurement'];
    wastagePercentage = json['wastagePercentage'];
    unitPricePerUnit = json['unitPricePerUnit'];
    sellingPricePerUnit = json['sellingPricePerUnit'];
    availiableStock = json['availiableStock'];
    category = json['category'];
    wastageStock = json['wastageStock'];
    stock = json['stock'];
    total = json['total'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['unitOfMeasurement'] = unitOfMeasurement;
    data['wastagePercentage'] = wastagePercentage;
    data['unitPricePerUnit'] = unitPricePerUnit;
    data['sellingPricePerUnit'] = sellingPricePerUnit;
    data['availiableStock'] = availiableStock;
    data['category'] = category;
    data['wastageStock'] = wastageStock;
    data['stock'] = stock;
    data['total'] = total;
    return data;
  }
}
