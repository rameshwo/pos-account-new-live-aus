class WcReceiptReq {
  String? action;
  String? user;
  String? key;
  String? station;
  String? txnType;
  String? txnRef;
  String? duplicateFlag;
  String? receiptType;

  WcReceiptReq({
    this.action,
    this.user,
    this.key,
    this.station,
    this.txnType,
    this.txnRef,
    this.duplicateFlag,
    this.receiptType,
  });

  factory WcReceiptReq.fromJson(Map<String, dynamic> json) => WcReceiptReq(
        action: json["action"],
        user: json["user"],
        key: json["key"],
        station: json["Station"],
        txnType: json["TxnType"],
        txnRef: json["TxnRef"],
        duplicateFlag: json["DuplicateFlag"],
        receiptType: json["ReceiptType"],
      );

  Map<String, dynamic> toJson() => {
        "action": action,
        "user": user,
        "key": key,
        "Station": station,
        "TxnType": txnType,
        "TxnRef": txnRef,
        "DuplicateFlag": duplicateFlag,
        "ReceiptType": receiptType,
      };
}
