class EmployeByCodeRes {
  String? id;
  String? jobTitle;
  String? fullName;
  // String? hourlyRate;

  EmployeByCodeRes({
    this.id,
    this.jobTitle,
    this.fullName,
    // this.hourlyRate,
  });

  factory EmployeByCodeRes.fromJson(Map<String, dynamic> json) =>
      EmployeByCodeRes(
        id: json["id"],
        jobTitle: json["jobTitle"],
        fullName: json["fullName"],
        // hourlyRate: json["hourlyRate"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "jobTitle": jobTitle,
        "fullName": fullName,
        // "hourlyRate": hourlyRate,
      };
}
