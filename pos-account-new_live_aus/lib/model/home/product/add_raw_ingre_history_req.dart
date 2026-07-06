class AddRawIngreHistoryRequest {
  String? id;
  String? actualStock;
  String? wastagePercentage;
  String? wastageStock;
  String? date;
  String? description;
  String? rawLooseIngredientId;

  AddRawIngreHistoryRequest(
      {this.id,
      this.actualStock,
      this.wastagePercentage,
      this.wastageStock,
      this.date,
      this.description,
      this.rawLooseIngredientId});

  AddRawIngreHistoryRequest.fromJson(Map<String, dynamic> json) {
    id = json['Id'];
    actualStock = json['ActualStock'];
    wastagePercentage = json['WastagePercentage'];
    wastageStock = json['WastageStock'];
    date = json['Date'];
    description = json['Description'];
    rawLooseIngredientId = json['RawLooseIngredientId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['Id'] = id;
    data['ActualStock'] = actualStock;
    data['WastagePercentage'] = wastagePercentage;
    data['WastageStock'] = wastageStock;
    data['Date'] = date;
    data['Description'] = description;
    data['RawLooseIngredientId'] = rawLooseIngredientId;
    return data;
  }
}
