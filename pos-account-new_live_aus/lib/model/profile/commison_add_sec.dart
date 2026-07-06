class CommissionAddSec {
  List<ServiceCommissionTypes>? serviceCommissionTypes;

  CommissionAddSec({this.serviceCommissionTypes});

  CommissionAddSec.fromJson(Map<String, dynamic> json) {
    if (json['serviceCommissionTypes'] != null) {
      serviceCommissionTypes = <ServiceCommissionTypes>[];
      json['serviceCommissionTypes'].forEach((v) {
        serviceCommissionTypes!.add(ServiceCommissionTypes.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (serviceCommissionTypes != null) {
      data['serviceCommissionTypes'] =
          serviceCommissionTypes!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ServiceCommissionTypes {
  String? id;
  String? value;
  String? additionalValue;
  bool? isSelected;
  String? name;

  ServiceCommissionTypes(
      {this.id, this.value, this.additionalValue, this.isSelected, this.name});

  ServiceCommissionTypes.fromJson(Map<String, dynamic> json) {
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
