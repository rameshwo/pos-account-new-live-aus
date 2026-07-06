class ServiceCommissionDetailsModel {
  String? serviceCommissionTypeId;
  String? employeeId;
  List<EmployeeServiceCommissionSettingViewModels>?
      employeeServiceCommissionSettingViewModels;

  ServiceCommissionDetailsModel(
      {this.serviceCommissionTypeId,
      this.employeeId,
      this.employeeServiceCommissionSettingViewModels});

  ServiceCommissionDetailsModel.fromJson(Map<String, dynamic> json) {
    serviceCommissionTypeId = json['serviceCommissionTypeId'];
    employeeId = json['employeeId'];
    if (json['employeeServiceCommissionSettingViewModels'] != null) {
      employeeServiceCommissionSettingViewModels =
          <EmployeeServiceCommissionSettingViewModels>[];
      json['employeeServiceCommissionSettingViewModels'].forEach((v) {
        employeeServiceCommissionSettingViewModels!
            .add(EmployeeServiceCommissionSettingViewModels.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['serviceCommissionTypeId'] = serviceCommissionTypeId;
    data['employeeId'] = employeeId;
    if (employeeServiceCommissionSettingViewModels != null) {
      data['employeeServiceCommissionSettingViewModels'] =
          employeeServiceCommissionSettingViewModels!
              .map((v) => v.toJson())
              .toList();
    }
    return data;
  }
}

class EmployeeServiceCommissionSettingViewModels {
  String? amountFrom;
  String? amountTo;
  String? commissionPercentage;

  EmployeeServiceCommissionSettingViewModels(
      {this.amountFrom, this.amountTo, this.commissionPercentage});

  EmployeeServiceCommissionSettingViewModels.fromJson(
      Map<String, dynamic> json) {
    amountFrom = json['amountFrom'];
    amountTo = json['amountTo'];
    commissionPercentage = json['commissionPercentage'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['amountFrom'] = amountFrom;
    data['amountTo'] = amountTo;
    data['commissionPercentage'] = commissionPercentage;
    return data;
  }
}
