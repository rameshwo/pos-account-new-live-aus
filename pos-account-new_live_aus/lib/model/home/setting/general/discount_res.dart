class DiscountSetRes {
  List<Data>? data;
  List<dynamic>? message;
  int? total;
  bool? isError;
  int? status;

  DiscountSetRes(
      {this.data, this.message, this.total, this.isError, this.status});

  DiscountSetRes.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(Data.fromJson(v));
      });
    }
    if (json['message'] != null) {
      message = <Null>[];
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
      data['message'] = message!.map((v) => v.toJson()).toList();
    }
    data['total'] = total;
    data['isError'] = isError;
    data['status'] = status;
    return data;
  }
}

class Data {
  String? id;
  String? name;
  bool? isActive;
  int? total;

  Data({this.id, this.name, this.isActive, this.total});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    isActive = json['isActive'];
    total = json['total'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['isActive'] = isActive;
    data['total'] = total;
    return data;
  }
}
