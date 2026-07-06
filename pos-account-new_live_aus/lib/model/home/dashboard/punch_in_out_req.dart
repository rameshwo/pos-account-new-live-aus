class PunchInOutReq {
  String? name;
  String? code;
  String? email;
  String? phoneNumber;
  String? date;
  bool? isPunchedInAlready;
  String? currentDate;
  List<PunchInPunchOutList>? punchInPunchOutList;
  //
  String? timeDiff;

  PunchInOutReq({
    this.name,
    this.code,
    this.email,
    this.phoneNumber,
    this.date,
    this.isPunchedInAlready,
    this.currentDate,
    this.punchInPunchOutList,
    //
    this.timeDiff,
  });

  factory PunchInOutReq.fromJson(Map<String, dynamic> json) => PunchInOutReq(
        name: json["name"],
        code: json["code"],
        email: json["email"],
        phoneNumber: json["phoneNumber"],
        date: json["date"],
        isPunchedInAlready: json["isPunchedInAlready"],
        currentDate: json["currentDate"],
        punchInPunchOutList: json["punchInPunchOutList"] == null
            ? []
            : List<PunchInPunchOutList>.from(json["punchInPunchOutList"]!
                .map((x) => PunchInPunchOutList.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "code": code,
        "email": email,
        "phoneNumber": phoneNumber,
        "date": date,
        "isPunchedInAlready": isPunchedInAlready,
        "currentDate": currentDate,
        "punchInPunchOutList": punchInPunchOutList == null
            ? []
            : List<dynamic>.from(punchInPunchOutList!.map((x) => x.toJson())),
      };
}

class PunchInPunchOutList {
  String? date;
  String? type;

  PunchInPunchOutList({
    this.date,
    this.type,
  });

  factory PunchInPunchOutList.fromJson(Map<String, dynamic> json) =>
      PunchInPunchOutList(
        date: json["date"],
        type: json["type"],
      );

  Map<String, dynamic> toJson() => {
        "date": date,
        "type": type,
      };
}
