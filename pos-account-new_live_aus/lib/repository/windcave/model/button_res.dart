import 'tran_res.dart';

class WcButtonRes {
  String? txnType;
  String? txnRef;
  String? success;
  String? rc;
  Response? response; // Adding the Response object
  String? transactionIsComplete;

  WcButtonRes({
    this.txnType,
    this.txnRef,
    this.success,
    this.rc,
    this.response,
    this.transactionIsComplete,
  });

  factory WcButtonRes.fromJson(Map<String, dynamic> json) => WcButtonRes(
        txnType: json["TxnType"],
        txnRef: json["TxnRef"],
        success: json["Success"],
        rc: json["RC"],
        response: json["Response"] != null
            ? Response.fromJson(json["Response"])
            : null,
        transactionIsComplete: json["TransactionIsComplete"],
      );

  Map<String, dynamic> toJson() => {
        "TxnType": txnType,
        "TxnRef": txnRef,
        "Success": success,
        "RC": rc,
        if (response != null) "Response": response?.toJson(),
        "TransactionIsComplete": transactionIsComplete,
      };
}
