class EmployeeCheckOutReq {
  String? attendanceId;
  String? checkOutTime;
  String? latitude;
  String? longitude;
  bool? isCompleted;
  String? shiftId;

  EmployeeCheckOutReq({
    this.attendanceId,
    this.checkOutTime,
    this.latitude,
    this.longitude,
    this.isCompleted,
    this.shiftId,
  });

  factory EmployeeCheckOutReq.fromJson(Map<String, dynamic> json) =>
      EmployeeCheckOutReq(
        attendanceId: json["AttendanceId"],
        checkOutTime: json["CheckOutTime"],
        latitude: json["Latitude"],
        longitude: json["Longitude"],
        isCompleted: json["IsCompleted"],
        shiftId: json["ShiftId"],
      );

  Map<String, dynamic> toJson() => {
        "AttendanceId": attendanceId,
        "CheckOutTime": checkOutTime,
        "Latitude": latitude,
        "Longitude": longitude,
        "IsCompleted": isCompleted,
        "ShiftId": shiftId,
      };
}
