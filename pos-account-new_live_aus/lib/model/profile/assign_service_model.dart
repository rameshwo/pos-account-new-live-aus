import '../home/setting/pos_device/printer_product/printer_prod_detail_res.dart';

class AssignServiceTypeModel {
  List<ParentProductCategory>? parentProductCategories;

  AssignServiceTypeModel({this.parentProductCategories});

  AssignServiceTypeModel.fromJson(Map<String, dynamic> json) {
    if (json['parentProductCategories'] != null) {
      parentProductCategories = <ParentProductCategory>[];
      json['parentProductCategories'].forEach((v) {
        parentProductCategories!.add(ParentProductCategory.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (parentProductCategories != null) {
      data['parentProductCategories'] =
          parentProductCategories!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ParentProductCategory {
  String? id;
  String? value;
  String? additionalValue;
  bool? isSelected;
  String? name;

  ParentProductCategory(
      {this.id, this.value, this.additionalValue, this.isSelected, this.name});

  ParentProductCategory.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    value = json['value'];
    additionalValue = json['additionalValue'];
    isSelected = json['isSelected'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['value'] = value;
    data['additionalValue'] = additionalValue;
    data['isSelected'] = isSelected;
    data['name'] = name;
    return data;
  }
}

class AssignedServiceRes {
  String? employeeId;
  String? employeeName;
  List<String>? deletedEmployeeServiceItemIds;
  List<ProductCategoryVariationList>? serviceCategoryVariationList;

  AssignedServiceRes({
    this.employeeId,
    this.employeeName,
    this.deletedEmployeeServiceItemIds,
    this.serviceCategoryVariationList,
  });

  factory AssignedServiceRes.fromJson(Map<String, dynamic> json) =>
      AssignedServiceRes(
        employeeId: json["employeeId"],
        employeeName: json["employeeName"],
        deletedEmployeeServiceItemIds:
            json["deletedEmployeeServiceItemIds"] == null
                ? []
                : List<String>.from(
                    json["deletedEmployeeServiceItemIds"]!.map((x) => x)),
        serviceCategoryVariationList:
            json["serviceCategoryVariationList"] == null
                ? []
                : List<ProductCategoryVariationList>.from(
                    json["serviceCategoryVariationList"]!
                        .map((x) => ProductCategoryVariationList.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "employeeId": employeeId,
        "employeeName": employeeName,
        "deletedEmployeeServiceItemIds": deletedEmployeeServiceItemIds,
        "serviceCategoryVariationList": serviceCategoryVariationList == null
            ? []
            : List<dynamic>.from(
                serviceCategoryVariationList!.map((x) => x.toJson())),
      };
}
