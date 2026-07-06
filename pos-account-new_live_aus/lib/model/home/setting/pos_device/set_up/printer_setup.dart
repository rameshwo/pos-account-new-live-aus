class PosPrinterSetup {
  PosPrinterSetup({
    this.id,
    this.message,
    this.posDeviceIdentifier,
    this.orderPrintAutomatically,
    this.printBillAutomatically,
    this.printerCategoryTypeAddViewModels,
  });

  String? id;
  String? message;
  String? posDeviceIdentifier;
  bool? orderPrintAutomatically;
  bool? printBillAutomatically;

  List<PrinterCategoryTypeAddViewModel>? printerCategoryTypeAddViewModels;

  factory PosPrinterSetup.fromJson(Map<String, dynamic> json) =>
      PosPrinterSetup(
        id: json["id"],
        message: json["message"],
        posDeviceIdentifier: json["posDeviceIdentifier"],
        orderPrintAutomatically: json["orderPrintAutomatically"],
        printBillAutomatically: json["invoicePrintAutomatically"],
        printerCategoryTypeAddViewModels:
            json["printerCategoryTypeAddViewModels"] == null
                ? null
                : List<PrinterCategoryTypeAddViewModel>.from(
                    json["printerCategoryTypeAddViewModels"].map(
                        (x) => PrinterCategoryTypeAddViewModel.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "Id": id,
        "PosDeviceIdentifier": posDeviceIdentifier,
        "orderPrintAutomatically": orderPrintAutomatically,
        "invoicePrintAutomatically": printBillAutomatically,
        "PrinterCategoryTypeAddViewModels":
            printerCategoryTypeAddViewModels == null
                ? null
                : List<dynamic>.from(
                    printerCategoryTypeAddViewModels!.map((x) => x.toJson())),
      };
}

class PrinterCategoryTypeAddViewModel {
  PrinterCategoryTypeAddViewModel({
    this.posPrinterId,
    // this.printSetMenuKit,
    this.categoryTypeIds,
    this.paperSize,
    this.printInvoice,
    this.printEftPosSignature,
    this.printEftPosLog,
    this.printBillCustomerCopy,
    this.orderPrintCopy,
    // this.openCashRegister,
    this.ipAddress,
    this.port,
    this.printEodSummary,
    this.printerType,
  });

  String? posPrinterId;
  // bool? printSetMenuKit;
  List<String>? categoryTypeIds;
  String? paperSize;
  bool? printInvoice;
  bool? printEftPosSignature;
  bool? printEftPosLog;
  bool? printBillCustomerCopy;
  bool? orderPrintCopy;
  // bool? openCashRegister;
  String? ipAddress;
  String? port;
  bool? printEodSummary;
  String? printerType;

  factory PrinterCategoryTypeAddViewModel.fromJson(Map<String, dynamic> json) =>
      PrinterCategoryTypeAddViewModel(
        posPrinterId: json["posPrinterId"],
        // printSetMenuKit: json["printSetMenuKit"],
        categoryTypeIds: json["categoryTypeIds"] == null
            ? null
            : List<String>.from(json["categoryTypeIds"].map((x) => x)),
        paperSize: json["paperSize"],
        printInvoice: json["printInvoice"],
        printEftPosSignature: json["printEftPosSignature"],
        printEftPosLog: json["printEftPosLog"],
        printBillCustomerCopy: json["printBillCustomerCopy"],
        orderPrintCopy: json["orderPrintCopy"],
        // openCashRegister: json["openCashRegister"],
        ipAddress: json["ipAddress"],
        port: json["port"],
        printEodSummary: json["printEODSummary"],
        printerType: json["printerType"],
      );

  Map<String, dynamic> toJson() => {
        "PosPrinterId": posPrinterId,
        // "PrintSetMenuKit": printSetMenuKit,
        "CategoryTypeIds": categoryTypeIds == null
            ? null
            : List<dynamic>.from(categoryTypeIds!.map((x) => x)),
        "PaperSize": paperSize,
        "PrintInvoice": printInvoice,
        "PrintEftPosSignature": printEftPosSignature,
        "PrintBillCustomerCopy": printBillCustomerCopy,
        "OrderPrintCopy": orderPrintCopy,
        "PrintEftPosLog": printEftPosLog,
        // "OpenCashRegister": openCashRegister,
        "PrintEODSummary": printEodSummary,
        // if(printerType!=null)
        // "PrinterType": printerType,
      };
}
