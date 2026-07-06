class EmployeeCheckInReq {
  String? employeeId;
  String? checkInTime;
  String? notes;
  String? shiftId;
  String? latitude;
  String? longitude;

  EmployeeCheckInReq({
    this.employeeId,
    this.checkInTime,
    this.notes,
    this.shiftId,
    this.latitude,
    this.longitude,
  });

  factory EmployeeCheckInReq.fromJson(Map<String, dynamic> json) =>
      EmployeeCheckInReq(
        employeeId: json["EmployeeId"],
        checkInTime: json["CheckInTime"],
        notes: json["Notes"],
        shiftId: json["ShiftId"],
        latitude: json["Latitude"],
        longitude: json["Longitude"],
      );

  Map<String, dynamic> toJson() => {
        "EmployeeId": employeeId,
        "CheckInTime": checkInTime,
        "Notes": notes,
        "ShiftId": shiftId,
        "Latitude": latitude,
        "Longitude": longitude,
      };
}
