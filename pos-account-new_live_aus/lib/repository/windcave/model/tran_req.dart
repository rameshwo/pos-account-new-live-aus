class WcTransactionReq {
  String? user;
  String? key;
  String? station;
  String? amount;
  String? amountCash;
  String? cur;
  TxnType? txnType;
  String? txnRef;
  String? deviceId;
  String? posName;
  String? posVersion;
  String? vendorId;
  String? mRef;
  String? urlSuccess;
  String? urlFail;
  String? dpsTxnRef;

  WcTransactionReq({
    this.user,
    this.key,
    this.station,
    this.amount,
    this.amountCash,
    this.cur,
    this.txnType,
    this.txnRef,
    this.deviceId,
    this.posName,
    this.posVersion,
    this.vendorId,
    this.mRef,
    this.urlSuccess,
    this.urlFail,
    this.dpsTxnRef,
  });

  factory WcTransactionReq.fromJson(Map<String, dynamic> json) =>
      WcTransactionReq(
        user: json["user"],
        key: json["key"],
        station: json["Station"],
        amount: json["Amount"],
        amountCash: json["AmountCash"],
        cur: json["Cur"],
        txnType: TxnType.values.any((e) => e.name == json["TxnType"])
            ? TxnType.values.firstWhere((e) => e.name == json["TxnType"])
            : null,
        txnRef: json["TxnRef"],
        deviceId: json["DeviceId"],
        posName: json["PosName"],
        posVersion: json["PosVersion"],
        vendorId: json["VendorId"],
        mRef: json["MRef"],
        urlSuccess: json["UrlSuccess"],
        urlFail: json["UrlFail"],
        dpsTxnRef: json["DpsTxnRef"],
      );

  Map<String, dynamic> toJson() => {
        "user": user,
        "key": key,
        "Station": station,
        "Amount": amount,
        "AmountCash": amountCash,
        "Cur": cur,
        "TxnType": txnType?.name,
        "TxnRef": txnRef,
        "DeviceId": deviceId,
        "PosName": posName,
        "PosVersion": posVersion,
        "VendorId": vendorId,
        "MRef": mRef,
        "UrlSuccess": urlSuccess,
        "UrlFail": urlFail,
        "DpsTxnRef": dpsTxnRef,
      };
}

enum TxnType { Purchase, Auth, Refund, Status }
