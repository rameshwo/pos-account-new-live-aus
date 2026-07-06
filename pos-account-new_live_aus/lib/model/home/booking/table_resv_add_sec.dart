import 'package:pos_account/model/common/table_location.dart';
import 'package:pos_account/model/profile/user_add_sec.dart';

class TableResvAddSec {
  TableResvAddSec({
    this.reservationNumber,
    this.tables,
    this.orderChannels,
    this.tableReservationStatus,
    this.countries,
    this.occasions,
  });

  String? reservationNumber;
  List<TableLocation>? tables;
  List<TableLocation>? orderChannels;
  List<TableLocation>? tableReservationStatus;
  List<UserAddSecData>? countries;
  List<TableLocation>? occasions;

  factory TableResvAddSec.fromJson(Map<String, dynamic> json) =>
      TableResvAddSec(
        reservationNumber: json["reservationNumber"],
        tables: json["tables"] == null
            ? null
            : List<TableLocation>.from(
                json["tables"].map((x) => TableLocation.fromJson(x))),
        orderChannels: json["channels"] == null
            ? null
            : List<TableLocation>.from(
                json["channels"].map((x) => TableLocation.fromJson(x))),
        tableReservationStatus: json["tableReservationStatus"] == null
            ? null
            : List<TableLocation>.from(json["tableReservationStatus"]
                .map((x) => TableLocation.fromJson(x))),
        countries: json["countries"] == null
            ? null
            : List<UserAddSecData>.from(
                json["countries"].map((x) => UserAddSecData.fromJson(x))),
        occasions: json["occasions"] == null
            ? []
            : List<TableLocation>.from(
                json["occasions"]!.map((x) => TableLocation.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "reservationNumber": reservationNumber,
        "tables": tables == null
            ? null
            : List<dynamic>.from(tables!.map((x) => x.toJson())),
        "channels": orderChannels == null
            ? null
            : List<dynamic>.from(orderChannels!.map((x) => x.toJson())),
        "tableReservationStatus": tableReservationStatus == null
            ? null
            : List<dynamic>.from(
                tableReservationStatus!.map((x) => x.toJson())),
        "countries": countries == null
            ? null
            : List<dynamic>.from(countries!.map((x) => x.toJson())),
        "occasions": occasions == null
            ? []
            : List<dynamic>.from(occasions!.map((x) => x.toJson())),
      };
}
