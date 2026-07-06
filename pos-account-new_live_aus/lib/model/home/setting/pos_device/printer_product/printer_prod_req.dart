class PrintProdReq {
  String? printerId;
  String? printerName;

  PrintProdReq({
    this.printerId,
    this.printerName,
  });

  factory PrintProdReq.fromJson(Map<String, dynamic> json) => PrintProdReq(
        printerId: json["PrinterId"],
        printerName: json["PrinterName"],
      );

  Map<String, dynamic> toJson() => {
        "PrinterId": printerId,
        "PrinterName": printerName,
      };
}
