class SignatureRes {
  String? message;
  bool? askForPrintConfirmation;
  List<PosPrinterResponseViewModel>? posPrinterResponseViewModels;

  SignatureRes({
    this.message,
    this.askForPrintConfirmation,
    this.posPrinterResponseViewModels,
  });

  factory SignatureRes.fromJson(Map<String, dynamic> json) => SignatureRes(
        message: json["message"],
        askForPrintConfirmation: json["askForPrintConfirmation"],
        posPrinterResponseViewModels:
            json["posPrinterResponseViewModels"] == null
                ? []
                : List<PosPrinterResponseViewModel>.from(
                    json["posPrinterResponseViewModels"]!
                        .map((x) => PosPrinterResponseViewModel.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "message": message,
        "askForPrintConfirmation": askForPrintConfirmation,
        "posPrinterResponseViewModels": posPrinterResponseViewModels == null
            ? []
            : List<dynamic>.from(
                posPrinterResponseViewModels!.map((x) => x.toJson())),
      };
}

class PosPrinterResponseViewModel {
  String? message;
  String? ipAddress;
  String? port;
  bool? isBluetoothPrinter;
  bool? orderPrintCopy;
  bool? printBillCustomerCopy;
  bool? openCashRegister;
  bool? printEftPosSignature;
  String? printerType;

  PosPrinterResponseViewModel({
    this.message,
    this.ipAddress,
    this.port,
    this.isBluetoothPrinter,
    this.orderPrintCopy,
    this.printBillCustomerCopy,
    this.openCashRegister,
    this.printEftPosSignature,
    this.printerType,
  });

  factory PosPrinterResponseViewModel.fromJson(Map<String, dynamic> json) =>
      PosPrinterResponseViewModel(
        message: json["message"],
        ipAddress: json["ipAddress"],
        port: json["port"],
        isBluetoothPrinter: json["isBluetoothPrinter"],
        orderPrintCopy: json["orderPrintCopy"],
        printBillCustomerCopy: json["printBillCustomerCopy"],
        openCashRegister: json["openCashRegister"],
        printEftPosSignature: json["printEftPosSignature"],
        printerType: json["printerType"],
      );

  Map<String, dynamic> toJson() => {
        "message": message,
        "ipAddress": ipAddress,
        "port": port,
        "isBluetoothPrinter": isBluetoothPrinter,
        "orderPrintCopy": orderPrintCopy,
        "printBillCustomerCopy": printBillCustomerCopy,
        "openCashRegister": openCashRegister,
        "printEftPosSignature": printEftPosSignature,
        "printerType": printerType,
      };
}
