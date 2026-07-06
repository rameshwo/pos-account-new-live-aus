class WcTransactionRes {
  String? txnType;
  String? txnRef;
  String? statusId;
  String? txnStatusId;
  String? complete;
  String? rcptW;
  String? rcpt;
  Result? result;
  String? reCo;
  String? tmo;
  String? dl1;
  String? dl2;
  B1? b1;
  B1? b2;
  String? station;
  Response? response; // Adding the Response object
  String? transactionIsComplete;

  WcTransactionRes({
    this.txnType,
    this.txnRef,
    this.statusId,
    this.txnStatusId,
    this.complete,
    this.rcptW,
    this.rcpt,
    this.result,
    this.reCo,
    this.tmo,
    this.dl1,
    this.dl2,
    this.b1,
    this.b2,
    this.station,
    this.response,
    this.transactionIsComplete,
  });

  factory WcTransactionRes.fromJson(Map<String, dynamic> json) =>
      WcTransactionRes(
        txnType: json["TxnType"],
        txnRef: json["TxnRef"],
        statusId: json["StatusId"],
        txnStatusId: json["TxnStatusId"],
        complete: json["Complete"],
        rcptW: json["RcptW"],
        rcpt: json["Rcpt"],
        result: json["Result"] == null ? null : Result.fromJson(json["Result"]),
        reCo: json["ReCo"],
        tmo: json["Tmo"],
        dl1: json["DL1"],
        dl2: json["DL2"],
        b1: json["B1"] == null ? null : B1.fromJson(json["B1"]),
        b2: json["B2"] == null ? null : B1.fromJson(json["B2"]),
        response: json["Response"] != null
            ? Response.fromJson(json["Response"])
            : null,
        transactionIsComplete: json["TransactionIsComplete"],
      );

  Map<String, dynamic> toJson() => {
        "TxnType": txnType,
        "TxnRef": txnRef,
        "StatusId": statusId,
        "TxnStatusId": txnStatusId,
        "Complete": complete,
        "RcptW": rcptW,
        "Rcpt": rcpt,
        "Result": result?.toJson(),
        "ReCo": reCo,
        "Tmo": tmo,
        "DL1": dl1,
        "DL2": dl2,
        "B1": b1?.toJson(),
        "B2": b2?.toJson(),
        if (response != null) "Response": response?.toJson(),
        "TransactionIsComplete": transactionIsComplete,
      };
}

class B1 {
  String? en;
  String? text;

  B1({
    this.en,
    this.text,
  });

  factory B1.fromJson(Map<String, dynamic> json) => B1(
        en: json["en"],
        text: json["text"],
      );

  Map<String, dynamic> toJson() => {
        "en": en,
        "text": text,
      };
}

class Result {
  String? ac;
  String? ap;
  String? cn;
  String? ct;
  String? ch;
  String? dt;
  String? dtTz;
  String? ds;
  String? dsTz;
  String? pix;
  String? rid;
  String? rrn;
  String? st;
  String? tr;
  String? dbid;
  String? rc;
  String? rt;
  String? rtt;
  String? amtA;
  String? amtS;
  String? amtT;
  String? amtC;
  String? mid;
  String? tid;
  String? autoSig;
  String? caStan;
  String? cid;
  String? ced;
  String? accountId;
  String? accountType;
  String? amtMd;
  String? pane;
  String? pine;
  String? eov;

  Result({
    this.ac,
    this.ap,
    this.cn,
    this.ct,
    this.ch,
    this.dt,
    this.dtTz,
    this.ds,
    this.dsTz,
    this.pix,
    this.rid,
    this.rrn,
    this.st,
    this.tr,
    this.dbid,
    this.rc,
    this.rt,
    this.rtt,
    this.amtA,
    this.amtS,
    this.amtT,
    this.amtC,
    this.mid,
    this.tid,
    this.autoSig,
    this.caStan,
    this.cid,
    this.ced,
    this.accountId,
    this.accountType,
    this.amtMd,
    this.pane,
    this.pine,
    this.eov,
  });

  factory Result.fromJson(Map<String, dynamic> json) => Result(
        ac: json["AC"],
        ap: json["AP"],
        cn: json["CN"],
        ct: json["CT"],
        ch: json["CH"],
        dt: json["DT"],
        dtTz: json["DT_TZ"],
        ds: json["DS"],
        dsTz: json["DS_TZ"],
        pix: json["PIX"],
        rid: json["RID"],
        rrn: json["RRN"],
        st: json["ST"],
        tr: json["TR"],
        dbid: json["DBID"],
        rc: json["RC"],
        rt: json["RT"],
        rtt: json["RTT"],
        amtA: json["AmtA"],
        amtS: json["AmtS"],
        amtT: json["AmtT"],
        amtC: json["AmtC"],
        mid: json["MID"],
        tid: json["TID"],
        autoSig: json["AutoSig"],
        caStan: json["CaStan"],
        cid: json["CID"],
        ced: json["CED"],
        accountId: json["AccountId"],
        accountType: json["AccountType"],
        amtMd: json["AmtMD"],
        pane: json["PANE"],
        pine: json["PINE"],
        eov: json["EOV"],
      );

  Map<String, dynamic> toJson() => {
        "AC": ac,
        "AP": ap,
        "CN": cn,
        "CT": ct,
        "CH": ch,
        "DT": dt,
        "DT_TZ": dtTz,
        "DS": ds,
        "DS_TZ": dsTz,
        "PIX": pix,
        "RID": rid,
        "RRN": rrn,
        "ST": st,
        "TR": tr,
        "DBID": dbid,
        "RC": rc,
        "RT": rt,
        "RTT": rtt,
        "AmtA": amtA,
        "AmtS": amtS,
        "AmtT": amtT,
        "AmtC": amtC,
        "MID": mid,
        "TID": tid,
        "AutoSig": autoSig,
        "CaStan": caStan,
        "CID": cid,
        "CED": ced,
        "AccountId": accountId,
        "AccountType": accountType,
        "AmtMD": amtMd,
        "PANE": pane,
        "PINE": pine,
        "EOV": eov,
      };
}

class Response {
  String? code;
  String? message;

  Response({this.code, this.message});

  factory Response.fromJson(Map<String, dynamic> json) => Response(
        code: json["Code"],
        message: json["Message"],
      );

  Map<String, dynamic> toJson() => {
        "Code": code,
        "Message": message,
      };
}
