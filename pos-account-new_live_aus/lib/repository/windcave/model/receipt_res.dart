import 'tran_res.dart';

class WcReceiptRes {
  String? txnRef;
  String? txnType;
  String? rcptW;
  String? rcpt;
  Response? response; // Adding the Response object
  String? transactionIsComplete;

  WcReceiptRes({
    this.txnRef,
    this.txnType,
    this.rcptW,
    this.rcpt,
    this.response,
    this.transactionIsComplete,
  });

  factory WcReceiptRes.fromJson(Map<String, dynamic> json) => WcReceiptRes(
        txnRef: json["TxnRef"],
        txnType: json["TxnType"],
        rcptW: json["RcptW"],
        rcpt: json["Rcpt"],
        response: json["Response"] != null
            ? Response.fromJson(json["Response"])
            : null,
        transactionIsComplete: json["TransactionIsComplete"],
      );

  Map<String, dynamic> toJson() => {
        "TxnRef": txnRef,
        "TxnType": txnType,
        "RcptW": rcptW,
        "Rcpt": rcpt,
        if (response != null) "Response": response?.toJson(),
        "TransactionIsComplete": transactionIsComplete,
      };
}
