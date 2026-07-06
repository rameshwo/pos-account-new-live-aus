class EftposMerchantLogRes {
  List<EftPosMerchantInvoiceResponseViewModel>?
      eftPosMerchantInvoiceResponseViewModels;
  String? message;
  String? ipAddress;
  String? port;
  String? paperSize;
  bool? isBluetoothPrinter;
  bool? askForPrintConfirmation;
  String? printerType;

  EftposMerchantLogRes({
    this.eftPosMerchantInvoiceResponseViewModels,
    this.message,
    this.ipAddress,
    this.port,
    this.paperSize,
    this.isBluetoothPrinter,
    this.askForPrintConfirmation,
    this.printerType,
  });

  factory EftposMerchantLogRes.fromJson(Map<String, dynamic> json) =>
      EftposMerchantLogRes(
        eftPosMerchantInvoiceResponseViewModels:
            json["eftPosMerchantInvoiceResponseViewModels"] == null
                ? []
                : List<EftPosMerchantInvoiceResponseViewModel>.from(
                    json["eftPosMerchantInvoiceResponseViewModels"]!.map((x) =>
                        EftPosMerchantInvoiceResponseViewModel.fromJson(x))),
        message: json["message"],
        ipAddress: json["ipAddress"],
        port: json["port"],
        paperSize: json["paperSize"],
        isBluetoothPrinter: json["isBluetoothPrinter"],
        askForPrintConfirmation: json["askForPrintConfirmation"],
        printerType: json["printerType"],
      );

  Map<String, dynamic> toJson() => {
        "eftPosMerchantInvoiceResponseViewModels":
            eftPosMerchantInvoiceResponseViewModels == null
                ? []
                : List<dynamic>.from(eftPosMerchantInvoiceResponseViewModels!
                    .map((x) => x.toJson())),
        "message": message,
        "ipAddress": ipAddress,
        "port": port,
        "paperSize": paperSize,
        "isBluetoothPrinter": isBluetoothPrinter,
        "askForPrintConfirmation": askForPrintConfirmation,
        "printerType": printerType,
      };
}

class EftPosMerchantInvoiceResponseViewModel {
  String? tid;
  String? mid;
  String? rrn;
  String? stan;
  String? auth;
  String? amex;
  String? tvr;
  String? arqc;
  String? purchase;
  String? approved;
  String? merchant;
  String? merchantInvoiceData;
  String? customerInvoiceData;

  EftPosMerchantInvoiceResponseViewModel({
    this.tid,
    this.mid,
    this.rrn,
    this.stan,
    this.auth,
    this.amex,
    this.tvr,
    this.arqc,
    this.purchase,
    this.approved,
    this.merchant,
    this.merchantInvoiceData,
    this.customerInvoiceData,
  });

  factory EftPosMerchantInvoiceResponseViewModel.fromJson(
          Map<String, dynamic> json) =>
      EftPosMerchantInvoiceResponseViewModel(
        tid: json["tid"],
        mid: json["mid"],
        rrn: json["rrn"],
        stan: json["stan"],
        auth: json["auth"],
        amex: json["amex"],
        tvr: json["tvr"],
        arqc: json["arqc"],
        purchase: json["purchase"],
        approved: json["approved"],
        merchant: json["merchant"],
        merchantInvoiceData: json["merchantInvoiceData"],
        customerInvoiceData: json["customerInvoiceData"],
      );

  Map<String, dynamic> toJson() => {
        "tid": tid,
        "mid": mid,
        "rrn": rrn,
        "stan": stan,
        "auth": auth,
        "amex": amex,
        "tvr": tvr,
        "arqc": arqc,
        "purchase": purchase,
        "approved": approved,
        "merchant": merchant,
        "merchantInvoiceData": merchantInvoiceData,
        "customerInvoiceData": customerInvoiceData,
      };
}
