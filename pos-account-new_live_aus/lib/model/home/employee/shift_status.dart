class EmployeShiftStatus {
  bool? isShiftInToday;
  bool? isLate;
  bool? isEarly;
  String? shiftStartTime;
  String? shiftEndTime;
  String? shiftId;
  String? checkInTime;
  String? breakInTime;
  String? attendanceId;
  String? breakId;
  List<ShiftBreak>? shiftBreaks;
  List<StoreBreak>? storeBreaks;
  List<TakenBreak>? takenBreaks;

  EmployeShiftStatus({
    this.isShiftInToday,
    this.isLate,
    this.isEarly,
    this.shiftStartTime,
    this.shiftEndTime,
    this.shiftId,
    this.checkInTime,
    this.breakInTime,
    this.attendanceId,
    this.breakId,
    this.shiftBreaks,
    this.storeBreaks,
    this.takenBreaks,
  });

  factory EmployeShiftStatus.fromJson(Map<String, dynamic> json) =>
      EmployeShiftStatus(
        isShiftInToday: json["isShiftInToday"],
        isLate: json["isLate"],
        isEarly: json["isEarly"],
        shiftStartTime: json["shiftStartTime"],
        shiftEndTime: json["shiftEndTime"],
        shiftId: json["shiftId"],
        checkInTime: json["checkInTime"],
        breakInTime: json["breakInTime"],
        attendanceId: json["attendanceId"],
        breakId: json["breakId"],
        shiftBreaks: json["shiftBreaks"] == null
            ? []
            : List<ShiftBreak>.from(
                json["shiftBreaks"]!.map((x) => ShiftBreak.fromJson(x))),
        storeBreaks: json["storeBreaks"] == null
            ? []
            : List<StoreBreak>.from(
                json["storeBreaks"]!.map((x) => StoreBreak.fromJson(x))),
        takenBreaks: json["takenBreaks"] == null
            ? []
            : List<TakenBreak>.from(
                json["takenBreaks"]!.map((x) => TakenBreak.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "isShiftInToday": isShiftInToday,
        "isLate": isLate,
        "isEarly": isEarly,
        "shiftStartTime": shiftStartTime,
        "shiftEndTime": shiftEndTime,
        "shiftId": shiftId,
        "checkInTime": checkInTime,
        "breakInTime": breakInTime,
        "attendanceId": attendanceId,
        "breakId": breakId,
        "shiftBreaks": shiftBreaks == null
            ? []
            : List<dynamic>.from(shiftBreaks!.map((x) => x.toJson())),
        "storeBreaks": storeBreaks == null
            ? []
            : List<dynamic>.from(storeBreaks!.map((x) => x.toJson())),
        "takenBreaks": takenBreaks == null
            ? []
            : List<dynamic>.from(takenBreaks!.map((x) => x.toJson())),
      };
}

class StoreBreak {
  String? id;
  String? name;
  bool? isPaid;

  StoreBreak({
    this.id,
    this.name,
    this.isPaid,
  });

  factory StoreBreak.fromJson(Map<String, dynamic> json) => StoreBreak(
        id: json["id"],
        name: json["name"],
        isPaid: json["isPaid"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "isPaid": isPaid,
      };
}

class ShiftBreak {
  String? interval;
  String? name;
  bool? isPaid;

  ShiftBreak({
    this.interval,
    this.name,
    this.isPaid,
  });

  factory ShiftBreak.fromJson(Map<String, dynamic> json) => ShiftBreak(
        interval: json["interval"],
        name: json["name"],
        isPaid: json["isPaid"],
      );

  Map<String, dynamic> toJson() => {
        "interval": interval,
        "name": name,
        "isPaid": isPaid,
      };
}

class TakenBreak {
  String? name;
  String? start;
  String? end;

  TakenBreak({
    this.name,
    this.start,
    this.end,
  });

  factory TakenBreak.fromJson(Map<String, dynamic> json) => TakenBreak(
        name: json["name"],
        start: json["start"],
        end: json["end"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "start": start,
        "end": end,
      };
}
