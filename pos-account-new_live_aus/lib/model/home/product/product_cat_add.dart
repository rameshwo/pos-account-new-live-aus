import 'package:pos_account/model/common/message.dart';

class CatAddReq {
  CatAddReq({
    this.id = "",
    this.name,
    this.productCategoryImageId = "",
    this.description = "",
    this.isActive = false,
    this.sortOrder,
    this.categoryTypeId,
    this.categoryType,
    this.isImageDeleted = false,
    this.filterTypes,
    this.imageUrl,
    this.identifier,
    this.icon,
    this.slug,
    this.parentProductCategoryId,
    this.isHalfCategory,
    this.aspectRatio,
    this.linkText,
    this.link,
    this.imageLink,
    this.channels,
    this.posDevices,
    this.productCategoryBackgroundColorViewModel,
    this.fileName,
  });

  String? id;
  String? name;
  String productCategoryImageId;
  String? description;
  bool isActive;
  int? sortOrder;
  String? categoryTypeId;
  String? categoryType;
  bool? isImageDeleted;
  List<FilterType>? filterTypes;
  List<Channel>? channels;
  String? imageUrl;
  String? identifier;
  String? icon;
  String? slug;
  String? parentProductCategoryId;
  bool? isHalfCategory;
  String? aspectRatio;
  String? linkText;
  String? link;
  String? imageLink;
  List<PosDevice>? posDevices;
  ProductCategoryBackgroundColorViewModel?
      productCategoryBackgroundColorViewModel;
  String? fileName;

  factory CatAddReq.fromJson(Map<String, dynamic> json) => CatAddReq(
        id: json["id"],
        name: json["name"],
        productCategoryImageId: json["productCategoryImageId"] ?? "",
        description: json["description"] ?? "",
        isActive: json["isActive"] ?? false,
        sortOrder: json["sortOrder"],
        categoryTypeId: json["categoryTypeId"],
        categoryType: json["categoryType"],
        isImageDeleted: json["isImageDeleted"],
        filterTypes: json["filterTypes"] == null
            ? null
            : List<FilterType>.from(
                json["filterTypes"]!.map((x) => FilterType.fromJson(x))),
        channels: json["channels"] == null
            ? null
            : List<Channel>.from(
                json["channels"]!.map((x) => Channel.fromJson(x))),
        imageUrl: json["imageUrl"],
        identifier: json["identifier"],
        icon: json["icon"],
        slug: json["slug"],
        parentProductCategoryId: json["parentProductCategoryId"],
        isHalfCategory: json["isHalfCategory"],
        aspectRatio: json["aspectRatio"],
        linkText: json["linkText"],
        link: json["link"],
        imageLink: json["imageLink"],
        posDevices: json["posDevices"] == null
            ? []
            : List<PosDevice>.from(
                json["posDevices"]!.map((x) => PosDevice.fromJson(x))),
        productCategoryBackgroundColorViewModel:
            json["productCategoryBackgroundColorViewModel"] == null
                ? null
                : ProductCategoryBackgroundColorViewModel.fromJson(
                    json["productCategoryBackgroundColorViewModel"]),
        fileName: json["fileName"],
      );

  Map<String, dynamic> toJson() => {
        "Id": id,
        "Name": name,
        "ProductCategoryImageId": productCategoryImageId,
        "Description": description,
        "IsActive": isActive,
        "SortOrder": sortOrder,
        "CategoryTypeId": categoryTypeId,
        if (categoryType != null) "CategoryType": categoryType,
        "IsImageDeleted": isImageDeleted,
        "FilterTypes": filterTypes == null
            ? []
            : List<dynamic>.from(filterTypes!.map((x) => x.toJson())),
        "Channels": channels == null
            ? []
            : List<dynamic>.from(channels!.map((x) => x.toJson())),
        if (imageUrl != null) "imageUrl": imageUrl,
        "Identifier": identifier,
        "Icon": icon,
        "Slug": slug,
        if (parentProductCategoryId != null)
          "parentProductCategoryId": parentProductCategoryId,
        if (isHalfCategory != null) "isHalfCategory": isHalfCategory,
        if (aspectRatio != null) "aspectRatio": aspectRatio,
        if (linkText != null) "linkText": linkText,
        if (link != null) "link": link,
        if (imageLink != null) "imageLink": imageLink,
        "posDevices": posDevices == null
            ? []
            : List<dynamic>.from(posDevices!.map((x) => x.toJson())),
        "productCategoryBackgroundColorViewModel":
            productCategoryBackgroundColorViewModel?.toJson(),
        "fileName": fileName,
      };
}

class AllProductCat {
  AllProductCat({
    this.data,
    this.message,
    this.total,
    this.status,
  });

  List<CatAddReq>? data;
  List<Message>? message;
  int? total;
  int? status;

  factory AllProductCat.fromJson(Map<String, dynamic> json) => AllProductCat(
        data: json["data"] == null
            ? null
            : List<CatAddReq>.from(
                json["data"].map((x) => CatAddReq.fromJson(x))),
        message: json["message"] == null
            ? null
            : List<Message>.from(
                json["message"].map((x) => Message.fromJson(x))),
        total: json["total"],
        status: json["status"],
      );

  Map<String, dynamic> toJson() => {
        "data": data == null
            ? null
            : List<dynamic>.from(data!.map((x) => x.toJson())),
        "message":
            message == null ? null : List<dynamic>.from(message!.map((x) => x)),
        "total": total,
        "status": status,
      };
}

class FilterType {
  FilterType({
    this.id,
    this.filterTypeId,
    this.name,
  });

  String? id;
  String? filterTypeId;
  String? name;

  factory FilterType.fromJson(Map<String, dynamic> json) => FilterType(
        id: json["id"],
        filterTypeId: json["filterTypeId"],
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "Id": id,
        "FilterTypeId": filterTypeId,
        "Name": name,
      };
}

class Channel {
  Channel({
    this.id,
    this.channelId,
  });

  String? id;
  String? channelId;

  factory Channel.fromJson(Map<String, dynamic> json) => Channel(
        id: json["id"],
        channelId: json["channelId"],
      );

  Map<String, dynamic> toJson() => {
        "Id": id,
        "ChannelId": channelId,
      };
}

class PosDevice {
  String? id;
  String? posDeviceId;

  PosDevice({
    this.id,
    this.posDeviceId,
  });

  factory PosDevice.fromJson(Map<String, dynamic> json) => PosDevice(
        id: json["id"],
        posDeviceId: json["posDeviceId"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "posDeviceId": posDeviceId,
      };
}

class ProductCategoryBackgroundColorViewModel {
  String? defaultBackGroundColor;
  String? defaultTextColor;
  String? onFocusBackGroundColor;
  String? onFocusTextColor;

  ProductCategoryBackgroundColorViewModel({
    this.defaultBackGroundColor,
    this.defaultTextColor,
    this.onFocusBackGroundColor,
    this.onFocusTextColor,
  });

  factory ProductCategoryBackgroundColorViewModel.fromJson(
          Map<String, dynamic> json) =>
      ProductCategoryBackgroundColorViewModel(
        defaultBackGroundColor: json["defaultBackGroundColor"],
        defaultTextColor: json["defaultTextColor"],
        onFocusBackGroundColor: json["onFocusBackGroundColor"],
        onFocusTextColor: json["onFocusTextColor"],
      );

  Map<String, dynamic> toJson() => {
        "defaultBackGroundColor": defaultBackGroundColor,
        "defaultTextColor": defaultTextColor,
        "onFocusBackGroundColor": onFocusBackGroundColor,
        "onFocusTextColor": onFocusTextColor,
      };
}
