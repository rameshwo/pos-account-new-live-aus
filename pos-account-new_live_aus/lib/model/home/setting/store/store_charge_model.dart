import 'package:flutter/material.dart';

class StoreExtraChargeModel {
  String? id;
  List<PublicHolidayViewModel>? publicHolidayViewModels;
  List<PosCreditCardSurchargeAddViewModel>? posCreditCardSurchargeAddViewModels;
  List<WeekendSurchageViewModel>? weekendSurchageViewModels;
  ServiceChargeAddViewModel? serviceChargeAddViewModel;
  List<String>? publicHolidaysDeletedIds;

  StoreExtraChargeModel({
    this.id,
    this.publicHolidayViewModels,
    this.posCreditCardSurchargeAddViewModels,
    this.weekendSurchageViewModels,
    this.serviceChargeAddViewModel,
    this.publicHolidaysDeletedIds,
  });

  factory StoreExtraChargeModel.fromJson(Map<String, dynamic> json) =>
      StoreExtraChargeModel(
        id: json["id"],
        publicHolidayViewModels: json["publicHolidayViewModels"] == null
            ? []
            : List<PublicHolidayViewModel>.from(json["publicHolidayViewModels"]!
                .map((x) => PublicHolidayViewModel.fromJson(x))),
        posCreditCardSurchargeAddViewModels:
            json["posCreditCardSurchargeAddViewModels"] == null
                ? []
                : List<PosCreditCardSurchargeAddViewModel>.from(
                    json["posCreditCardSurchargeAddViewModels"]!.map(
                        (x) => PosCreditCardSurchargeAddViewModel.fromJson(x))),
        weekendSurchageViewModels: json["weekendSurchageViewModels"] == null
            ? []
            : List<WeekendSurchageViewModel>.from(
                json["weekendSurchageViewModels"]!
                    .map((x) => WeekendSurchageViewModel.fromJson(x))),
        serviceChargeAddViewModel: json["serviceChargeAddViewModel"] == null
            ? null
            : ServiceChargeAddViewModel.fromJson(
                json["serviceChargeAddViewModel"]),
        publicHolidaysDeletedIds: json["publicHolidaysDeletedIds"] == null
            ? []
            : List<String>.from(
                json["publicHolidaysDeletedIds"]!.map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "publicHolidayViewModels": publicHolidayViewModels == null
            ? []
            : List<dynamic>.from(
                publicHolidayViewModels!.map((x) => x.toJson())),
        "posCreditCardSurchargeAddViewModels":
            posCreditCardSurchargeAddViewModels == null
                ? []
                : List<dynamic>.from(posCreditCardSurchargeAddViewModels!
                    .map((x) => x.toJson())),
        "weekendSurchageViewModels": weekendSurchageViewModels == null
            ? []
            : List<dynamic>.from(
                weekendSurchageViewModels!.map((x) => x.toJson())),
        "serviceChargeAddViewModel": serviceChargeAddViewModel?.toJson(),
        "publicHolidaysDeletedIds": publicHolidaysDeletedIds == null
            ? []
            : List<dynamic>.from(publicHolidaysDeletedIds!.map((x) => x)),
      };
}

class PosCreditCardSurchargeAddViewModel {
  String? id;
  String? channelId;
  TextEditingController creditCardSurchargePercentage;
  bool autoEnableCreditSurchargePercentage;
  bool isActive;
  //
  String? channelName;

  PosCreditCardSurchargeAddViewModel({
    this.id,
    this.channelId,
    required this.creditCardSurchargePercentage,
    this.autoEnableCreditSurchargePercentage = false,
    this.isActive = false,
    //
    this.channelName,
  });

  factory PosCreditCardSurchargeAddViewModel.fromJson(
          Map<String, dynamic> json) =>
      PosCreditCardSurchargeAddViewModel(
        id: json["id"],
        channelId: json["channelId"],
        creditCardSurchargePercentage: TextEditingController(
            text: json["creditCardSurchargePercentage"]?.toString() ?? ''),
        autoEnableCreditSurchargePercentage:
            json["autoEnableCreditSurchargePercentage"] ?? false,
        isActive: json["isActive"] ?? false,
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "channelId": channelId,
        "creditCardSurchargePercentage": creditCardSurchargePercentage.text,
        "autoEnableCreditSurchargePercentage":
            autoEnableCreditSurchargePercentage,
        "isActive": isActive,
      };
}

class PublicHolidayViewModel {
  String? id;
  String? name;
  String? date;
  String? holidaySurchargePercentage;
  bool? autoEnableHolidaySurcharge;

  PublicHolidayViewModel({
    this.id,
    this.name,
    this.date,
    this.holidaySurchargePercentage,
    this.autoEnableHolidaySurcharge,
  });

  factory PublicHolidayViewModel.fromJson(Map<String, dynamic> json) =>
      PublicHolidayViewModel(
        id: json["id"],
        name: json["name"],
        date: json["date"],
        holidaySurchargePercentage: json["holidaySurchargePercentage"],
        autoEnableHolidaySurcharge: json["autoEnableHolidaySurcharge"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "date": date,
        "holidaySurchargePercentage": holidaySurchargePercentage,
        "autoEnableHolidaySurcharge": autoEnableHolidaySurcharge,
      };
}

class ServiceChargeAddViewModel {
  String? id;
  TextEditingController serviceChargePercentage;
  bool autoEnableServiceChargePercentage;
  bool? isActive;

  ServiceChargeAddViewModel({
    this.id,
    required this.serviceChargePercentage,
    this.autoEnableServiceChargePercentage = false,
    this.isActive,
  });

  factory ServiceChargeAddViewModel.fromJson(Map<String, dynamic> json) =>
      ServiceChargeAddViewModel(
        id: json["id"],
        serviceChargePercentage: TextEditingController(
            text: json["serviceChargePercentage"]?.toString() ?? ''),
        autoEnableServiceChargePercentage:
            json["autoEnableServiceChargePercentage"] ?? false,
        isActive: json["isActive"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "serviceChargePercentage": serviceChargePercentage.text,
        "autoEnableServiceChargePercentage": autoEnableServiceChargePercentage,
        "isActive": isActive,
      };
}

class WeekendSurchageViewModel {
  String? id;
  String? weekendSurchargePercentage;
  bool? autoEnableWeekendSurcharge;
  String? weekDayId;
  String? name;

  WeekendSurchageViewModel({
    this.id,
    this.weekendSurchargePercentage,
    this.autoEnableWeekendSurcharge,
    this.weekDayId,
    this.name,
  });

  factory WeekendSurchageViewModel.fromJson(Map<String, dynamic> json) =>
      WeekendSurchageViewModel(
        id: json["id"],
        weekendSurchargePercentage: json["weekendSurchargePercentage"],
        autoEnableWeekendSurcharge: json["autoEnableWeekendSurcharge"],
        weekDayId: json["weekDayId"],
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "weekendSurchargePercentage": weekendSurchargePercentage,
        "autoEnableWeekendSurcharge": autoEnableWeekendSurcharge,
        "weekDayId": weekDayId,
        "name": name,
      };
}
