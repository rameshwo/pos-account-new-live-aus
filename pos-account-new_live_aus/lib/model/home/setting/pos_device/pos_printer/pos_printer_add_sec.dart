class PosPrinterAddSec {
  List<PrinterType>? printerTypes;

  PosPrinterAddSec({
    this.printerTypes,
  });

  factory PosPrinterAddSec.fromJson(Map<String, dynamic> json) =>
      PosPrinterAddSec(
        printerTypes: json["printerTypes"] == null
            ? []
            : List<PrinterType>.from(
                json["printerTypes"]!.map((x) => PrinterType.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "printerTypes": printerTypes == null
            ? []
            : List<dynamic>.from(printerTypes!.map((x) => x.toJson())),
      };
}

class PrinterType {
  String? id;
  String? value;
  String? additionalValue;
  bool? isSelected;
  String? name;

  PrinterType({
    this.id,
    this.value,
    this.additionalValue,
    this.isSelected,
    this.name,
  });

  factory PrinterType.fromJson(Map<String, dynamic> json) => PrinterType(
        id: json["id"],
        value: json["value"],
        additionalValue: json["additionalValue"],
        isSelected: json["isSelected"],
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "value": value,
        "additionalValue": additionalValue,
        "isSelected": isSelected,
        "name": name,
      };
}
