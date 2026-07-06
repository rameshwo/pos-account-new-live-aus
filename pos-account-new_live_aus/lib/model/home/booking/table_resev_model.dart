// ignore_for_file: must_be_immutable

import 'package:equatable/equatable.dart';
import 'package:pos_account/model/common/table_id_name.dart';

class TableResvModel extends Equatable {
  TableResvModel({
    this.id,
    this.reservationNumber,
    this.adult,
    this.child,
    this.orderChannelId,
    this.tables,
    this.dateTimeFrom,
    this.dateTimeTo,
    this.occasionId,
    this.message,
    this.customerViewModel,
  });

  String? id;
  String? reservationNumber;
  String? adult;
  String? child;
  String? orderChannelId;
  List<TableIdName>? tables;
  String? dateTimeFrom;
  String? dateTimeTo;
  String? occasionId;
  String? message;
  CustomerViewModel? customerViewModel;

  factory TableResvModel.fromJson(Map<String, dynamic> json) => TableResvModel(
        id: json["id"],
        reservationNumber: json["ReservationNumber"],
        adult: json["Adult"],
        child: json["Child"],
        orderChannelId: json["OrderChannelId"],
        tables: json["tables"] == null
            ? []
            : List<TableIdName>.from(
                json["tables"]!.map((x) => TableIdName.fromJson(x))),
        dateTimeFrom: json["DateTimeFrom"],
        dateTimeTo: json["DateTimeTo"],
        occasionId: json["OccasionId"],
        message: json["Message"],
        customerViewModel: json["CustomerViewModel"] == null
            ? null
            : CustomerViewModel.fromJson(json["CustomerViewModel"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "ReservationNumber": reservationNumber,
        "Adult": adult,
        "Child": child,
        "OrderChannelId": orderChannelId,
        "tables": tables == null
            ? []
            : List<dynamic>.from(tables!.map((x) => x.toJson())),
        "DateTimeFrom": dateTimeFrom,
        "DateTimeTo": dateTimeTo,
        "OccasionId": occasionId,
        "Message": message,
        "CustomerViewModel": customerViewModel?.toJson(),
      };

  @override
  List<Object?> get props => [
        id,
        reservationNumber,
        adult,
        child,
        orderChannelId,
        tables,
        dateTimeFrom,
        dateTimeTo,
        customerViewModel
      ];
}

class CustomerViewModel extends Equatable {
  CustomerViewModel({
    this.id = "",
    this.name,
    this.email,
    this.phoneNumber,
    this.countryId,
    this.countryPhoneNumberPrefixId,
  });

  String id;
  String? name;
  String? email;
  String? phoneNumber;
  String? countryId;
  String? countryPhoneNumberPrefixId;

  factory CustomerViewModel.fromJson(Map<String, dynamic> json) =>
      CustomerViewModel(
        id: json["Id"],
        name: json["Name"],
        email: json["Email"],
        phoneNumber: json["PhoneNumber"],
        countryId: json["CountryId"],
        countryPhoneNumberPrefixId: json["CountryPhoneNumberPrefixId"],
      );

  Map<String, dynamic> toJson() => {
        "Id": id,
        "Name": name,
        "Email": email,
        "PhoneNumber": phoneNumber,
        "CountryId": countryId,
        "CountryPhoneNumberPrefixId": countryPhoneNumberPrefixId,
      };

  @override
  List<Object?> get props =>
      [id, name, email, phoneNumber, countryId, countryPhoneNumberPrefixId];
}
