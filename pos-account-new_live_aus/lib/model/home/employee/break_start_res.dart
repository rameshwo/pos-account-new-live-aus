class EmployeBreakStartRes {
  String? message;
  String? breakId;
  String? breakStartTime;

  EmployeBreakStartRes({
    this.message,
    this.breakId,
    this.breakStartTime,
  });

  factory EmployeBreakStartRes.fromJson(Map<String, dynamic> json) =>
      EmployeBreakStartRes(
        message: json["message"],
        breakId: json["breakId"],
        breakStartTime: json["breakStartTime"],
      );

  Map<String, dynamic> toJson() => {
        "message": message,
        "breakId": breakId,
        "breakStartTime": breakStartTime,
      };
}
