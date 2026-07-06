import 'package:flutter/material.dart';

class StoreGeneralModel {
  String? id;
  bool? isActive;
  String? name;
  String? email;
  String? url;
  String? phoneNumber;
  String? blogUrl;
  String? bookingUrl;
  String? qrUrl;
  String? signageUrl;
  String? menuQrUrl;
  String? freeDeliveryMessage;
  String? freeDeliveryDiscountPercentage;
  String? freeDeliveryDiscountAmountThreshold;
  bool? isFreeDelivery;
  String? storeImageUrl;
  String? storeImageFileName;
  String? favIconImageFileName;
  String? noProductImageFileName;
  String? favIconImageUrl;
  String? noProductImageUrl;
  String? trackingUrl;
  String? address;
  String? description;
  String? alertDescription;
  String? footerDescription;
  String? latitude;
  String? longitude;
  String? languageId;
  String? businessTypeId;
  String? dateFormatId;
  String? storeTypeId;
  String? timeZoneId;
  String? franchiseId;
  String? templateCategoryId;
  String? businessTypeCategoryId;
  String? taxExclusiveInclusiveTypeId;
  String? taxPercentage;
  String? countryId;
  String? stateId;
  String? cityId;
  String? suburbId;
  String? abnNumber;
  String? channel;
  String? websiteUrl;
  String? currencySymbol;
  String? googlePinnedLocation;
  bool? isImageDeleted;
  List<ChannelThumbNailImageAddViewModel>? channelThumbNailImageAddViewModels;
  List<SecondaryEmailAddViewModel>? secondaryEmailAddViewModels;
  List<ChannelNoteAddViewModel>? channelNoteAddViewModels;
  List<ScheduleReportJobAddViewModel>? scheduleReportJobAddViewModels;
  List<SocialMediasAddViewModel>? socialMediasAddViewModels;
  List<String>? secondaryEmailDeletedIds;

  StoreGeneralModel({
    this.id,
    this.isActive,
    this.name,
    this.email,
    this.url,
    this.phoneNumber,
    this.blogUrl,
    this.bookingUrl,
    this.qrUrl,
    this.signageUrl,
    this.menuQrUrl,
    this.freeDeliveryMessage,
    this.freeDeliveryDiscountPercentage,
    this.freeDeliveryDiscountAmountThreshold,
    this.isFreeDelivery,
    this.storeImageUrl,
    this.storeImageFileName,
    this.favIconImageFileName,
    this.noProductImageFileName,
    this.favIconImageUrl,
    this.noProductImageUrl,
    this.trackingUrl,
    this.address,
    this.description,
    this.alertDescription,
    this.footerDescription,
    this.latitude,
    this.longitude,
    this.languageId,
    this.businessTypeId,
    this.dateFormatId,
    this.storeTypeId,
    this.timeZoneId,
    this.franchiseId,
    this.templateCategoryId,
    this.businessTypeCategoryId,
    this.taxExclusiveInclusiveTypeId,
    this.taxPercentage,
    this.countryId,
    this.stateId,
    this.cityId,
    this.suburbId,
    this.abnNumber,
    this.channel,
    this.websiteUrl,
    this.currencySymbol,
    this.googlePinnedLocation,
    this.isImageDeleted,
    this.channelThumbNailImageAddViewModels,
    this.channelNoteAddViewModels,
    this.scheduleReportJobAddViewModels,
    this.secondaryEmailAddViewModels,
    this.socialMediasAddViewModels,
    this.secondaryEmailDeletedIds,
  });

  factory StoreGeneralModel.fromJson(Map<String, dynamic> json) =>
      StoreGeneralModel(
        id: json["id"],
        isActive: json["isActive"],
        name: json["name"],
        email: json["email"],
        url: json["url"],
        phoneNumber: json["phoneNumber"],
        blogUrl: json["blogUrl"],
        bookingUrl: json["bookingUrl"],
        qrUrl: json["qrUrl"],
        signageUrl: json["signageUrl"],
        menuQrUrl: json["menuQrUrl"],
        freeDeliveryMessage: json["freeDeliveryMessage"],
        freeDeliveryDiscountPercentage: json["freeDeliveryDiscountPercentage"],
        freeDeliveryDiscountAmountThreshold:
            json["freeDeliveryDiscountAmountThreshold"],
        isFreeDelivery: json["isFreeDelivery"],
        storeImageUrl: json["storeImageUrl"],
        storeImageFileName: json["storeImageFileName"],
        favIconImageFileName: json["favIconImageFileName"],
        noProductImageFileName: json["noProductImageFileName"],
        favIconImageUrl: json["favIconImageUrl"],
        noProductImageUrl: json["noProductImageUrl"],
        trackingUrl: json["trackingUrl"],
        address: json["address"],
        description: json["description"],
        alertDescription: json["alertDescription"],
        footerDescription: json["footerDescription"],
        latitude: json["latitude"],
        longitude: json["longitude"],
        languageId: json["languageId"],
        businessTypeId: json["businessTypeId"],
        dateFormatId: json["dateFormatId"],
        storeTypeId: json["storeTypeId"],
        timeZoneId: json["timeZoneId"],
        franchiseId: json["franchiseId"],
        templateCategoryId: json["templateCategoryId"],
        businessTypeCategoryId: json["businessTypeCategoryId"],
        taxExclusiveInclusiveTypeId: json["taxExclusiveInclusiveTypeId"],
        taxPercentage: json["taxPercentage"],
        countryId: json["countryId"],
        stateId: json["stateId"],
        cityId: json["cityId"],
        suburbId: json["suburbId"],
        abnNumber: json["abnNumber"],
        channel: json["channel"],
        websiteUrl: json["websiteUrl"],
        currencySymbol: json["currencySymbol"],
        googlePinnedLocation: json["googlePinnedLocation"],
        isImageDeleted: json["isImageDeleted"],
        channelThumbNailImageAddViewModels:
            json["channelThumbNailImageAddViewModels"] == null
                ? []
                : List<ChannelThumbNailImageAddViewModel>.from(
                    json["channelThumbNailImageAddViewModels"]!.map(
                        (x) => ChannelThumbNailImageAddViewModel.fromJson(x))),
        secondaryEmailAddViewModels: json["secondaryEmailAddViewModels"] == null
            ? []
            : List<SecondaryEmailAddViewModel>.from(
                json["secondaryEmailAddViewModels"]!
                    .map((x) => SecondaryEmailAddViewModel.fromJson(x))),
        channelNoteAddViewModels: json["channelNoteAddViewModels"] == null
            ? []
            : List<ChannelNoteAddViewModel>.from(
                json["channelNoteAddViewModels"]!
                    .map((x) => ChannelNoteAddViewModel.fromJson(x))),
        scheduleReportJobAddViewModels:
            json["scheduleReportJobAddViewModels"] == null
                ? []
                : List<ScheduleReportJobAddViewModel>.from(
                    json["scheduleReportJobAddViewModels"]!
                        .map((x) => ScheduleReportJobAddViewModel.fromJson(x))),
        socialMediasAddViewModels: json["socialMediasAddViewModels"] == null
            ? []
            : List<SocialMediasAddViewModel>.from(
                json["socialMediasAddViewModels"]!
                    .map((x) => SocialMediasAddViewModel.fromJson(x))),
        secondaryEmailDeletedIds: json["secondaryEmailDeletedIds"] == null
            ? []
            : List<String>.from(
                json["secondaryEmailDeletedIds"]!.map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "isActive": isActive,
        "name": name,
        "email": email,
        "url": url,
        "phoneNumber": phoneNumber,
        "blogUrl": blogUrl,
        "bookingUrl": bookingUrl,
        "qrUrl": qrUrl,
        "signageUrl": signageUrl,
        "menuQrUrl": menuQrUrl,
        "freeDeliveryMessage": freeDeliveryMessage,
        "freeDeliveryDiscountPercentage": freeDeliveryDiscountPercentage,
        "freeDeliveryDiscountAmountThreshold":
            freeDeliveryDiscountAmountThreshold,
        "isFreeDelivery": isFreeDelivery,
        // "storeImageUrl": storeImageUrl,
        "storeImageFileName": storeImageFileName,
        "favIconImageFileName": favIconImageFileName,
        "noProductImageFileName": noProductImageFileName,
        // "favIconImageUrl": favIconImageUrl,
        // "noProductImageUrl": noProductImageUrl,
        "trackingUrl": trackingUrl,
        "address": address,
        "description": description,
        "alertDescription": alertDescription,
        "footerDescription": footerDescription,
        "latitude": latitude,
        "longitude": longitude,
        "languageId": languageId,
        "businessTypeId": businessTypeId,
        "dateFormatId": dateFormatId,
        "storeTypeId": storeTypeId,
        "timeZoneId": timeZoneId,
        "franchiseId": franchiseId,
        "templateCategoryId": templateCategoryId,
        "businessTypeCategoryId": businessTypeCategoryId,
        "taxExclusiveInclusiveTypeId": taxExclusiveInclusiveTypeId,
        "taxPercentage": taxPercentage,
        "countryId": countryId,
        "stateId": stateId,
        "cityId": cityId,
        "suburbId": suburbId,
        "abnNumber": abnNumber,
        "channel": channel,
        "websiteUrl": websiteUrl,
        "currencySymbol": currencySymbol,
        "googlePinnedLocation": googlePinnedLocation,
        "isImageDeleted": isImageDeleted,
        "channelThumbNailImageAddViewModels":
            channelThumbNailImageAddViewModels == null
                ? []
                : List<dynamic>.from(
                    channelThumbNailImageAddViewModels!.map((x) => x.toJson())),
        "scheduleReportJobAddViewModels": scheduleReportJobAddViewModels == null
            ? []
            : List<dynamic>.from(
                scheduleReportJobAddViewModels!.map((x) => x.toJson())),
        "secondaryEmailAddViewModels": secondaryEmailAddViewModels == null
            ? []
            : List<dynamic>.from(
                secondaryEmailAddViewModels!.map((x) => x.toJson())),
        "channelNoteAddViewModels": channelNoteAddViewModels == null
            ? []
            : List<dynamic>.from(
                channelNoteAddViewModels!.map((x) => x.toJson())),
        "socialMediasAddViewModels": socialMediasAddViewModels == null
            ? []
            : List<dynamic>.from(
                socialMediasAddViewModels!.map((x) => x.toJson())),

        "secondaryEmailDeletedIds": secondaryEmailDeletedIds == null
            ? []
            : List<dynamic>.from(secondaryEmailDeletedIds!.map((x) => x)),
      };
}

class ChannelThumbNailImageAddViewModel {
  String? id;
  String? channelId;
  String? fileName;
  String? imageUrl;

  ChannelThumbNailImageAddViewModel({
    this.id,
    this.channelId,
    this.fileName,
    this.imageUrl,
  });

  factory ChannelThumbNailImageAddViewModel.fromJson(
          Map<String, dynamic> json) =>
      ChannelThumbNailImageAddViewModel(
        id: json["id"],
        channelId: json["channelId"],
        fileName: json["fileName"],
        imageUrl: json["imageUrl"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "channelId": channelId,
        "fileName": fileName,
        // "imageUrl": imageUrl,
      };
}

class ScheduleReportJobAddViewModel {
  String? id;
  TextEditingController name;
  String? time;
  bool? isActive;

  ScheduleReportJobAddViewModel({
    this.id,
    required this.name,
    this.time,
    this.isActive,
  });

  factory ScheduleReportJobAddViewModel.fromJson(Map<String, dynamic> json) =>
      ScheduleReportJobAddViewModel(
        id: json["id"],
        name: TextEditingController(text: json["name"]?.toString() ?? ''),
        time: json["time"],
        isActive: json["isActive"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name.text,
        "time": time,
        "isActive": isActive,
      };
}

class SocialMediasAddViewModel {
  String? id;
  String? socialMediaId;
  String? link;
  bool? isActive;

  SocialMediasAddViewModel({
    this.id,
    this.socialMediaId,
    this.link,
    this.isActive,
  });

  factory SocialMediasAddViewModel.fromJson(Map<String, dynamic> json) =>
      SocialMediasAddViewModel(
        id: json["id"],
        socialMediaId: json["socialMediaId"],
        link: json["link"],
        isActive: json["isActive"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "socialMediaId": socialMediaId,
        "link": link,
        "isActive": isActive,
      };
}

class ChannelNoteAddViewModel {
  String? id;
  String? channelId;
  String? description;

  ChannelNoteAddViewModel({
    this.id,
    this.channelId,
    this.description,
  });

  factory ChannelNoteAddViewModel.fromJson(Map<String, dynamic> json) =>
      ChannelNoteAddViewModel(
        id: json["id"],
        channelId: json["channelId"],
        description: json["description"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "channelId": channelId,
        "description": description,
      };
}

class SecondaryEmailAddViewModel {
  String? id;
  String? email;
  bool? isActive;

  SecondaryEmailAddViewModel({
    this.id,
    this.email,
    this.isActive,
  });

  factory SecondaryEmailAddViewModel.fromJson(Map<String, dynamic> json) =>
      SecondaryEmailAddViewModel(
        id: json["id"],
        email: json["email"],
        isActive: json["isActive"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "email": email,
        "isActive": isActive,
      };
}
