class InvoicePrinterDetail {
  String? message;
  String? ipAddress;
  String? port;
  String? printerType;
  bool? orderPrintCopy;
  bool? printBillCustomerCopy;
  bool? openCashRegister;
  bool? printEftPosSignature;

  InvoicePrinterDetail({
    this.message,
    this.ipAddress,
    this.port,
    this.printerType,
    this.orderPrintCopy,
    this.printBillCustomerCopy,
    this.openCashRegister,
    this.printEftPosSignature,
  });

  factory InvoicePrinterDetail.fromJson(Map<String, dynamic> json) =>
      InvoicePrinterDetail(
        message: json["message"],
        ipAddress: json["ipAddress"],
        port: json["port"],
        printerType: json["printerType"],
        orderPrintCopy: json["orderPrintCopy"],
        printBillCustomerCopy: json["printBillCustomerCopy"],
        openCashRegister: json["openCashRegister"],
        printEftPosSignature: json["printEftPosSignature"],
      );

  Map<String, dynamic> toJson() => {
        "message": message,
        "ipAddress": ipAddress,
        "port": port,
        "printerType": printerType,
        "orderPrintCopy": orderPrintCopy,
        "printBillCustomerCopy": printBillCustomerCopy,
        "openCashRegister": openCashRegister,
        "printEftPosSignature": printEftPosSignature,
      };
}
