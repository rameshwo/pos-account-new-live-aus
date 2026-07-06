class ConfirmTabRes {
  ConfirmTabRes({
    this.type,
    this.reservationId,
  });

  String? type;
  String? reservationId;

  factory ConfirmTabRes.fromJson(Map<String, dynamic> json) => ConfirmTabRes(
        type: json["Type"],
        reservationId: json["ReservationId"],
      );

  Map<String, dynamic> toJson() => {
        "Type": type,
        "ReservationId": reservationId,
      };
}
