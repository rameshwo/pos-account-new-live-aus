class RawIngreHistoryResponse {
  List<Data>? data;
  List<String>? message;
  int? total;
  bool? isError;
  int? status;

  RawIngreHistoryResponse(
      {this.data, this.message, this.total, this.isError, this.status});

  RawIngreHistoryResponse.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(Data.fromJson(v));
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

class Data {
  String? id;
  int? total;
  String? actualStock;
  String? wastageStock;
  String? wastagePercentage;
  String? date;
  String? description;

  Data(
      {this.id,
      this.total,
      this.actualStock,
      this.wastageStock,
      this.wastagePercentage,
      this.date,
      this.description});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    total = json['total'];
    actualStock = json['actualStock'];
    wastageStock = json['wastageStock'];
    wastagePercentage = json['wastagePercentage'];
    date = json['date'];
    description = json['description'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['total'] = total;
    data['actualStock'] = actualStock;
    data['wastageStock'] = wastageStock;
    data['wastagePercentage'] = wastagePercentage;
    data['date'] = date;
    data['description'] = description;
    return data;
  }
}
