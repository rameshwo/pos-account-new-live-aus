import 'package:pos_account/model/common/table_location.dart';
import 'package:pos_account/model/profile/user_add_sec.dart';

class StoreRes {
  StoreRes({
    this.franchises,
    this.businessTypeCategoriesWithBussinessTypes,
    this.templates,
    this.countryCityStates,
    this.timeZones,
    this.weekDays,
    this.distanceKmsMiles,
    this.storeTypes,
    this.taxExclusiveInclusiveTypes,
    this.languages,
    this.dateFormats,
    this.onlineThemeColorSettings,
    this.timeRanges,
    this.templateCategoriesWithTemplates,
    this.centralizedChannels,
    this.posChannels,
    this.fileUploadFolderName,
    this.socialMedias,
    this.pickUpDeliveryTimeIntervals,
    this.posProductDetailScreenTypes,
  });

  List<TableLocation>? franchises;
  List<BusinessTypeCategoriesWithBussinessType>?
      businessTypeCategoriesWithBussinessTypes;
  List<TableLocation>? templates;
  List<CountryCityState>? countryCityStates;
  List<TableLocation>? timeZones;
  List<TableLocation>? weekDays;
  List<TableLocation>? distanceKmsMiles;
  List<TableLocation>? storeTypes;
  List<TableLocation>? taxExclusiveInclusiveTypes;
  List<TableLocation>? languages;
  List<TableLocation>? dateFormats;
  List<TableLocation>? onlineThemeColorSettings;
  List<TableLocation>? timeRanges;
  List<TemplateCategoriesWithTemplates>? templateCategoriesWithTemplates;
  List<TableLocation>? centralizedChannels;
  List<TableLocation>? posChannels;
  String? fileUploadFolderName;
  List<TableLocation>? socialMedias;
  List<TableLocation>? pickUpDeliveryTimeIntervals;
  List<TableLocation>? posProductDetailScreenTypes;

  factory StoreRes.fromJson(Map<String, dynamic> json) => StoreRes(
        franchises: json["franchises"] == null
            ? null
            : List<TableLocation>.from(
                json["franchises"].map((x) => TableLocation.fromJson(x))),
        businessTypeCategoriesWithBussinessTypes:
            json["businessTypeCategoriesWithBussinessTypes"] == null
                ? []
                : List<BusinessTypeCategoriesWithBussinessType>.from(
                    json["businessTypeCategoriesWithBussinessTypes"]!.map((x) =>
                        BusinessTypeCategoriesWithBussinessType.fromJson(x))),
        templates: json["templates"] == null
            ? null
            : List<TableLocation>.from(
                json["templates"].map((x) => TableLocation.fromJson(x))),
        countryCityStates: json["countryCityStates"] == null
            ? null
            : List<CountryCityState>.from(json["countryCityStates"]
                .map((x) => CountryCityState.fromJson(x))),
        timeZones: json["timeZones"] == null
            ? null
            : List<TableLocation>.from(
                json["timeZones"].map((x) => TableLocation.fromJson(x))),
        weekDays: json["weekDays"] == null
            ? null
            : List<TableLocation>.from(
                json["weekDays"].map((x) => TableLocation.fromJson(x))),
        distanceKmsMiles: json["distanceKmsMiles"] == null
            ? null
            : List<TableLocation>.from(
                json["distanceKmsMiles"].map((x) => TableLocation.fromJson(x))),
        storeTypes: json["storeTypes"] == null
            ? null
            : List<TableLocation>.from(
                json["storeTypes"].map((x) => TableLocation.fromJson(x))),
        taxExclusiveInclusiveTypes: json["taxExclusiveInclusiveTypes"] == null
            ? null
            : List<TableLocation>.from(json["taxExclusiveInclusiveTypes"]
                .map((x) => TableLocation.fromJson(x))),
        languages: json["languages"] == null
            ? null
            : List<TableLocation>.from(
                json["languages"].map((x) => TableLocation.fromJson(x))),
        dateFormats: json["dateFormats"] == null
            ? null
            : List<TableLocation>.from(
                json["dateFormats"].map((x) => TableLocation.fromJson(x))),
        onlineThemeColorSettings: json["onlineThemeColorSettings"] == null
            ? null
            : List<TableLocation>.from(json["onlineThemeColorSettings"]
                .map((x) => TableLocation.fromJson(x))),
        timeRanges: json["timeRanges"] == null
            ? null
            : List<TableLocation>.from(
                json["timeRanges"].map((x) => TableLocation.fromJson(x))),
        templateCategoriesWithTemplates:
            json["templateCategoriesWithTemplates"] == null
                ? null
                : List<TemplateCategoriesWithTemplates>.from(
                    json["templateCategoriesWithTemplates"]!.map(
                        (x) => TemplateCategoriesWithTemplates.fromJson(x))),
        centralizedChannels: json["centralizedChannels"] == null
            ? []
            : List<TableLocation>.from(json["centralizedChannels"]!
                .map((x) => TableLocation.fromJson(x))),
        posChannels: json["posChannels"] == null
            ? []
            : List<TableLocation>.from(
                json["posChannels"]!.map((x) => TableLocation.fromJson(x))),
        fileUploadFolderName: json["fileUploadFolderName"],
        socialMedias: json["socialMedias"] == null
            ? []
            : List<TableLocation>.from(
                json["socialMedias"]!.map((x) => TableLocation.fromJson(x))),
        pickUpDeliveryTimeIntervals: json["pickUpDeliveryTimeIntervals"] == null
            ? []
            : List<TableLocation>.from(json["pickUpDeliveryTimeIntervals"]!
                .map((x) => TableLocation.fromJson(x))),
        posProductDetailScreenTypes: json["posProductDetailScreenTypes"] == null
            ? []
            : List<TableLocation>.from(json["posProductDetailScreenTypes"]!
                .map((x) => TableLocation.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "franchises": franchises == null
            ? null
            : List<dynamic>.from(franchises!.map((x) => x.toJson())),
        "businessTypeCategoriesWithBussinessTypes":
            businessTypeCategoriesWithBussinessTypes == null
                ? []
                : List<dynamic>.from(businessTypeCategoriesWithBussinessTypes!
                    .map((x) => x.toJson())),
        "templates": templates == null
            ? null
            : List<dynamic>.from(templates!.map((x) => x.toJson())),
        "countryCityStates": countryCityStates == null
            ? null
            : List<dynamic>.from(countryCityStates!.map((x) => x.toJson())),
        "timeZones": timeZones == null
            ? null
            : List<dynamic>.from(timeZones!.map((x) => x.toJson())),
        "weekDays": weekDays == null
            ? null
            : List<dynamic>.from(weekDays!.map((x) => x.toJson())),
        "distanceKmsMiles": distanceKmsMiles == null
            ? null
            : List<dynamic>.from(distanceKmsMiles!.map((x) => x.toJson())),
        "storeTypes": storeTypes == null
            ? null
            : List<dynamic>.from(storeTypes!.map((x) => x.toJson())),
        "taxExclusiveInclusiveTypes": taxExclusiveInclusiveTypes == null
            ? null
            : List<dynamic>.from(
                taxExclusiveInclusiveTypes!.map((x) => x.toJson())),
        "languages": languages == null
            ? null
            : List<dynamic>.from(languages!.map((x) => x.toJson())),
        "dateFormats": dateFormats == null
            ? null
            : List<dynamic>.from(dateFormats!.map((x) => x.toJson())),
        "onlineThemeColorSettings": onlineThemeColorSettings == null
            ? null
            : List<dynamic>.from(
                onlineThemeColorSettings!.map((x) => x.toJson())),
        "timeRanges": timeRanges == null
            ? null
            : List<dynamic>.from(timeRanges!.map((x) => x.toJson())),
        "templateCategoriesWithTemplates":
            templateCategoriesWithTemplates == null
                ? null
                : List<dynamic>.from(
                    templateCategoriesWithTemplates!.map((x) => x.toJson())),
        "centralizedChannels": centralizedChannels == null
            ? []
            : List<dynamic>.from(centralizedChannels!.map((x) => x.toJson())),
        "posChannels": posChannels == null
            ? []
            : List<dynamic>.from(posChannels!.map((x) => x.toJson())),
        "fileUploadFolderName": fileUploadFolderName,
        "socialMedias": socialMedias == null
            ? []
            : List<dynamic>.from(socialMedias!.map((x) => x.toJson())),
        "pickUpDeliveryTimeIntervals": pickUpDeliveryTimeIntervals == null
            ? []
            : List<dynamic>.from(
                pickUpDeliveryTimeIntervals!.map((x) => x.toJson())),
        "posProductDetailScreenTypes": posProductDetailScreenTypes == null
            ? []
            : List<dynamic>.from(
                posProductDetailScreenTypes!.map((x) => x.toJson())),
      };
}

class TemplateCategoriesWithTemplates {
  String? id;
  String? value;
  String? name;
  List<TableLocation>? templates;

  TemplateCategoriesWithTemplates({
    this.id,
    this.value,
    this.name,
    this.templates,
  });

  factory TemplateCategoriesWithTemplates.fromJson(Map<String, dynamic> json) =>
      TemplateCategoriesWithTemplates(
        id: json["id"],
        value: json["value"],
        name: json["name"],
        templates: json["templates"] == null
            ? null
            : List<TableLocation>.from(
                json["templates"]!.map((x) => TableLocation.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "value": value,
        "name": name,
        "templates": templates == null
            ? null
            : List<dynamic>.from(templates!.map((x) => x.toJson())),
      };
}

class BusinessTypeCategoriesWithBussinessType {
  String? id;
  String? value;
  String? name;
  String? description;
  List<TableLocation>? businessTypes;

  BusinessTypeCategoriesWithBussinessType({
    this.id,
    this.value,
    this.name,
    this.description,
    this.businessTypes,
  });

  factory BusinessTypeCategoriesWithBussinessType.fromJson(
          Map<String, dynamic> json) =>
      BusinessTypeCategoriesWithBussinessType(
        id: json["id"],
        value: json["value"],
        name: json["name"],
        description: json["description"],
        businessTypes: json["businessTypes"] == null
            ? []
            : List<TableLocation>.from(
                json["businessTypes"]!.map((x) => TableLocation.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "value": value,
        "name": name,
        "description": description,
        "businessTypes": businessTypes == null
            ? []
            : List<dynamic>.from(businessTypes!.map((x) => x.toJson())),
      };
}
