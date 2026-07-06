class TableSlotAvaiRes {
  List<String>? bookingSlotsAvailable;

  TableSlotAvaiRes({
    this.bookingSlotsAvailable,
  });

  factory TableSlotAvaiRes.fromJson(Map<String, dynamic> json) =>
      TableSlotAvaiRes(
        bookingSlotsAvailable: json["bookingSlotsAvailable"] == null
            ? []
            : List<String>.from(json["bookingSlotsAvailable"]!.map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "bookingSlotsAvailable": bookingSlotsAvailable == null
            ? []
            : List<dynamic>.from(bookingSlotsAvailable!.map((x) => x)),
      };
}
