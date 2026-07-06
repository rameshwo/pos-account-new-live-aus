import 'package:pos_account/model/profile/user_add_sec.dart';

class BillingSubsAddSec {
  BillingSubsAddSec({
    this.countries,
    // this.cities,
    // this.states,
  });

  List<CountryCityState>? countries;
  // List<TableLocation>? cities;
  // List<TableLocation>? states;

  factory BillingSubsAddSec.fromJson(Map<String, dynamic> json) =>
      BillingSubsAddSec(
        countries: json["countries"] == null
            ? null
            : List<CountryCityState>.from(
                json["countries"].map((x) => CountryCityState.fromJson(x))),
        // cities: json["cities"] == null
        //     ? null
        //     : List<TableLocation>.from(
        //         json["cities"].map((x) => TableLocation.fromJson(x))),
        // states: json["states"] == null
        //     ? null
        //     : List<TableLocation>.from(
        //         json["states"].map((x) => TableLocation.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "countries": countries == null
            ? null
            : List<dynamic>.from(countries!.map((x) => x.toJson())),
        // "cities": cities == null
        //     ? null
        //     : List<dynamic>.from(cities!.map((x) => x.toJson())),
        // "states": states == null
        //     ? null
        //     : List<dynamic>.from(states!.map((x) => x.toJson())),
      };
}
