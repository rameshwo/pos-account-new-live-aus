class WcButtonReq {
  String? user;
  String? key;
  String? station;
  String? txnType;
  String? uiType;
  String? name;
  String? val;
  String? txnRef;

  WcButtonReq({
    this.user,
    this.key,
    this.station,
    this.txnType,
    this.uiType,
    this.name,
    this.val,
    this.txnRef,
  });

  factory WcButtonReq.fromJson(Map<String, dynamic> json) => WcButtonReq(
        user: json["user"],
        key: json["key"],
        station: json["Station"],
        txnType: json["TxnType"],
        uiType: json["UiType"],
        name: json["Name"],
        val: json["Val"],
        txnRef: json["TxnRef"],
      );

  Map<String, dynamic> toJson() => {
        "user": user,
        "key": key,
        "Station": station,
        "TxnType": txnType,
        "UiType": uiType,
        "Name": name,
        "Val": val,
        "TxnRef": txnRef,
      };
}
