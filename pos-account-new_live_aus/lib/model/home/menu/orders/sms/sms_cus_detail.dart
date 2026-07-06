class SmsCusDetail {
  String? phoneNumber;
  String? phoneNumberPrefix;
  String? customerName;

  SmsCusDetail({
    this.phoneNumber,
    this.phoneNumberPrefix,
    this.customerName,
  });

  factory SmsCusDetail.fromJson(Map<String, dynamic> json) => SmsCusDetail(
        phoneNumber: json["phoneNumber"],
        phoneNumberPrefix: json["phoneNumberPrefix"],
        customerName: json["customerName"],
      );

  Map<String, dynamic> toJson() => {
        "phoneNumber": phoneNumber,
        "phoneNumberPrefix": phoneNumberPrefix,
        "customerName": customerName,
      };
}
