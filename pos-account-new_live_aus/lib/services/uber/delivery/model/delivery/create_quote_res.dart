class CreateQuoteRes {
  String? kind;
  String? id;
  String? created;
  String? expires;
  int? fee;
  String? currency;
  String? currencyType;
  String? dropoffEta;
  int? duration;
  int? pickupDuration;
  String? dropoffDeadline;

  CreateQuoteRes({
    this.kind,
    this.id,
    this.created,
    this.expires,
    this.fee,
    this.currency,
    this.currencyType,
    this.dropoffEta,
    this.duration,
    this.pickupDuration,
    this.dropoffDeadline,
  });

  factory CreateQuoteRes.fromJson(Map<String, dynamic> json) => CreateQuoteRes(
        kind: json["kind"],
        id: json["id"],
        created: json["created"],
        expires: json["expires"],
        fee: json["fee"],
        currency: json["currency"],
        currencyType: json["currency_type"],
        dropoffEta: json["dropoff_eta"],
        duration: json["duration"],
        pickupDuration: json["pickup_duration"],
        dropoffDeadline: json["dropoff_deadline"],
      );

  Map<String, dynamic> toJson() => {
        "kind": kind,
        "id": id,
        "created": created,
        "expires": expires,
        "fee": fee,
        "currency": currency,
        "currency_type": currencyType,
        "dropoff_eta": dropoffEta,
        "duration": duration,
        "pickup_duration": pickupDuration,
        "dropoff_deadline": dropoffDeadline,
      };
}
