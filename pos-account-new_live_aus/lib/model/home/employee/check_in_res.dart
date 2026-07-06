class EmployeCheckInRes {
  String? message;
  String? attendanceId;
  String? checkInTime;

  EmployeCheckInRes({
    this.message,
    this.attendanceId,
    this.checkInTime,
  });

  factory EmployeCheckInRes.fromJson(Map<String, dynamic> json) =>
      EmployeCheckInRes(
        message: json["message"],
        attendanceId: json["attendanceId"],
        checkInTime: json["checkInTime"],
      );

  Map<String, dynamic> toJson() => {
        "message": message,
        "attendanceId": attendanceId,
        "checkInTime": checkInTime,
      };
}
