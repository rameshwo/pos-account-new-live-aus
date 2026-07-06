class EmployeeBreakStartReq {
  String? employeeId;
  String? attendanceId;
  String? notes;
  String? latitude;
  String? longitude;
  String? storeBreakId;
  String? breakStartTime;

  EmployeeBreakStartReq({
    this.employeeId,
    this.attendanceId,
    this.notes,
    this.latitude,
    this.longitude,
    this.storeBreakId,
    this.breakStartTime,
  });

  factory EmployeeBreakStartReq.fromJson(Map<String, dynamic> json) =>
      EmployeeBreakStartReq(
        employeeId: json["EmployeeId"],
        attendanceId: json["AttendanceId"],
        notes: json["Notes"],
        latitude: json["Latitude"],
        longitude: json["Longitude"],
        storeBreakId: json["StoreBreakId"],
        breakStartTime: json["BreakStartTime"],
      );

  Map<String, dynamic> toJson() => {
        "EmployeeId": employeeId,
        "AttendanceId": attendanceId,
        "Notes": notes,
        "Latitude": latitude,
        "Longitude": longitude,
        "StoreBreakId": storeBreakId,
        "BreakStartTime": breakStartTime,
      };
}
