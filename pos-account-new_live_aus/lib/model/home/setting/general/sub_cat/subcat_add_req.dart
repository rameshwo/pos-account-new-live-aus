import 'package:pos_account/model/home/product/product_cat_add.dart';

class SubCatAddReq {
  String? id;
  String? name;
  String? title;
  String? parentProductCategoryId;
  String? categoryTypeId;
  String? imagePath;
  String? icon;
  String? slug;
  String? identifier;
  String? aspectRatio;
  bool? isImageDeleted;
  String? description;
  int? sortOrder;
  String? linkText;
  String? link;
  bool? isActive;
  String? productCategoryImageId;
  String? deletedProductCategoriesAdsImageIds;
  List<FilterType>? filterTypes;
  List<Channel>? channels;
  List<dynamic>? productCategoriesAdsImages;
  String? imageLink;
  String? fileName;

  SubCatAddReq({
    this.id,
    this.name,
    this.title,
    this.parentProductCategoryId,
    this.categoryTypeId,
    this.imagePath,
    this.icon,
    this.slug,
    this.identifier,
    this.aspectRatio,
    this.isImageDeleted,
    this.description,
    this.sortOrder,
    this.linkText,
    this.link,
    this.isActive,
    this.productCategoryImageId,
    this.deletedProductCategoriesAdsImageIds,
    this.filterTypes,
    this.productCategoriesAdsImages,
    this.channels,
    this.imageLink,
    this.fileName,
  });

  factory SubCatAddReq.fromJson(Map<String, dynamic> json) => SubCatAddReq(
        id: json["id"],
        name: json["name"],
        title: json["title"],
        parentProductCategoryId: json["parentProductCategoryId"],
        categoryTypeId: json["categoryTypeId"],
        imagePath: json["imagePath"],
        icon: json["icon"],
        slug: json["slug"],
        identifier: json["identifier"],
        aspectRatio: json["aspectRatio"],
        isImageDeleted: json["isImageDeleted"],
        description: json["description"],
        sortOrder: json["sortOrder"],
        linkText: json["linkText"],
        link: json["link"],
        isActive: json["isActive"],
        productCategoryImageId: json["productCategoryImageId"],
        deletedProductCategoriesAdsImageIds:
            json["deletedProductCategoriesAdsImageIds"],
        filterTypes: json["filterTypes"] == null
            ? []
            : List<FilterType>.from(
                json["filterTypes"]!.map((x) => FilterType.fromJson(x))),
        channels: json["channels"] == null
            ? []
            : List<Channel>.from(
                json["channels"]!.map((x) => Channel.fromJson(x))),
        productCategoriesAdsImages: json["productCategoriesAdsImages"] == null
            ? []
            : List<dynamic>.from(
                json["productCategoriesAdsImages"]!.map((x) => x)),
        imageLink: json["imageLink"],
        fileName: json["fileName"],
      );

  Map<String, dynamic> toJson() => {
        "Id": id,
        "Name": name,
        "Title": title,
        "ParentProductCategoryId": parentProductCategoryId,
        "CategoryTypeId": categoryTypeId,
        "ImagePath": imagePath,
        "Icon": icon,
        "Slug": slug,
        "Identifier": identifier,
        "AspectRatio": aspectRatio,
        "IsImageDeleted": isImageDeleted,
        "Description": description,
        "SortOrder": sortOrder,
        "LinkText": linkText,
        "Link": link,
        "IsActive": isActive,
        "ProductCategoryImageId": productCategoryImageId,
        "DeletedProductCategoriesAdsImageIds":
            deletedProductCategoriesAdsImageIds,
        "FilterTypes": filterTypes == null
            ? []
            : List<dynamic>.from(filterTypes!.map((x) => x.toJson())),
        "Channels": channels == null
            ? []
            : List<dynamic>.from(channels!.map((x) => x.toJson())),
        "ProductCategoriesAdsImages": productCategoriesAdsImages == null
            ? []
            : List<dynamic>.from(productCategoriesAdsImages!.map((x) => x)),
        if (imageLink != null) "imageLink": imageLink,
        "fileName": fileName,
      };
}
