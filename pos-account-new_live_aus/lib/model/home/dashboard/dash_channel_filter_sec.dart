import 'package:pos_account/model/common/table_location.dart';

class DashChannelFilterSec {
  List<StoreChannelCuisineType>? storeChannelCuisineTypes;
  List<StoreChannelFilterOption>? storeChannelFilterOptions;
  List<TableLocation>? cuisineTypes;
  List<ChannelFilter>? channelFilters;

  DashChannelFilterSec({
    this.storeChannelCuisineTypes,
    this.storeChannelFilterOptions,
    this.cuisineTypes,
    this.channelFilters,
  });

  factory DashChannelFilterSec.fromJson(Map<String, dynamic> json) =>
      DashChannelFilterSec(
        storeChannelCuisineTypes: json["storeChannelCuisineTypes"] == null
            ? []
            : List<StoreChannelCuisineType>.from(
                json["storeChannelCuisineTypes"]!
                    .map((x) => StoreChannelCuisineType.fromJson(x))),
        storeChannelFilterOptions: json["storeChannelFilterOptions"] == null
            ? []
            : List<StoreChannelFilterOption>.from(
                json["storeChannelFilterOptions"]!
                    .map((x) => StoreChannelFilterOption.fromJson(x))),
        cuisineTypes: json["cuisineTypes"] == null
            ? []
            : List<TableLocation>.from(
                json["cuisineTypes"]!.map((x) => TableLocation.fromJson(x))),
        channelFilters: json["channelFilters"] == null
            ? []
            : List<ChannelFilter>.from(
                json["channelFilters"]!.map((x) => ChannelFilter.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "storeChannelCuisineTypes": storeChannelCuisineTypes == null
            ? []
            : List<dynamic>.from(
                storeChannelCuisineTypes!.map((x) => x.toJson())),
        "storeChannelFilterOptions": storeChannelFilterOptions == null
            ? []
            : List<dynamic>.from(
                storeChannelFilterOptions!.map((x) => x.toJson())),
        "cuisineTypes": cuisineTypes == null
            ? []
            : List<dynamic>.from(cuisineTypes!.map((x) => x.toJson())),
        "channelFilters": channelFilters == null
            ? []
            : List<dynamic>.from(channelFilters!.map((x) => x.toJson())),
      };
}

class ChannelFilter {
  String? id;
  String? name;
  List<TableLocation>? channelFilterOptions;

  ChannelFilter({
    this.id,
    this.name,
    this.channelFilterOptions,
  });

  factory ChannelFilter.fromJson(Map<String, dynamic> json) => ChannelFilter(
        id: json["id"],
        name: json["name"],
        channelFilterOptions: json["channelFilterOptions"] == null
            ? []
            : List<TableLocation>.from(json["channelFilterOptions"]!
                .map((x) => TableLocation.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "channelFilterOptions": channelFilterOptions == null
            ? []
            : List<dynamic>.from(channelFilterOptions!.map((x) => x.toJson())),
      };
}

class StoreChannelCuisineType {
  String? cuisineTypeId;

  StoreChannelCuisineType({
    this.cuisineTypeId,
  });

  factory StoreChannelCuisineType.fromJson(Map<String, dynamic> json) =>
      StoreChannelCuisineType(
        cuisineTypeId: json["cuisineTypeId"],
      );

  Map<String, dynamic> toJson() => {
        "cuisineTypeId": cuisineTypeId,
      };
}

class StoreChannelFilterOption {
  String? channelFilterOptionId;

  StoreChannelFilterOption({
    this.channelFilterOptionId,
  });

  factory StoreChannelFilterOption.fromJson(Map<String, dynamic> json) =>
      StoreChannelFilterOption(
        channelFilterOptionId: json["channelFilterOptionId"],
      );

  Map<String, dynamic> toJson() => {
        "channelFilterOptionId": channelFilterOptionId,
      };
}
