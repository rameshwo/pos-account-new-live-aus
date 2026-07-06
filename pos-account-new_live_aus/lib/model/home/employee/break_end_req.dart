class EmployeBreakEndReq {
  String? breakId;
  String? breakEndTime;
  String? latitude;
  String? longitude;

  EmployeBreakEndReq({
    this.breakId,
    this.breakEndTime,
    this.latitude,
    this.longitude,
  });

  factory EmployeBreakEndReq.fromJson(Map<String, dynamic> json) =>
      EmployeBreakEndReq(
        breakId: json["BreakId"],
        breakEndTime: json["BreakEndTime"],
        latitude: json["Latitude"],
        longitude: json["Longitude"],
      );

  Map<String, dynamic> toJson() => {
        "BreakId": breakId,
        "BreakEndTime": breakEndTime,
        "Latitude": latitude,
        "Longitude": longitude,
      };
}
