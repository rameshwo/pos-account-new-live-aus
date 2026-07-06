import 'package:pos_account/model/common/message.dart';

class AllEmployees {
  List<AllEmployeesData>? data;
  List<Message>? message;
  int? total;
  bool? isError;
  int? status;

  AllEmployees(
      {this.data, this.message, this.total, this.isError, this.status});

  AllEmployees.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <AllEmployeesData>[];
      json['data'].forEach((v) {
        data!.add(AllEmployeesData.fromJson(v));
      });
    }
    if (json['message'] != null) {
      message = <Message>[];
      json['message'].forEach((v) {
        message!.add(Message.fromJson(v));
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

class AllEmployeesData {
  String? id;
  String? code;
  String? fullName;
  String? preferredName;
  String? phoneNumber;
  String? email;
  String? jobTitle;
  String? employmentType;
  String? postalCode;
  int? total;

  AllEmployeesData(
      {this.id,
      this.code,
      this.fullName,
      this.phoneNumber,
      this.preferredName,
      this.email,
      this.jobTitle,
      this.employmentType,
      this.postalCode,
      this.total});

  AllEmployeesData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    code = json['code'];
    fullName = json['fullName'];
    phoneNumber = json['phoneNumber'];
    email = json['email'];
    jobTitle = json['jobTitle'];
    employmentType = json['employmentType'];
    preferredName = json['preferredName'];
    postalCode = json['postalCode'];
    total = json['total'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['code'] = code;
    data['fullName'] = fullName;
    data['phoneNumber'] = phoneNumber;
    data['email'] = email;
    data['jobTitle'] = jobTitle;
    data['preferredName'] = preferredName;
    data['employmentType'] = employmentType;
    data['postalCode'] = postalCode;
    data['total'] = total;
    return data;
  }
}
