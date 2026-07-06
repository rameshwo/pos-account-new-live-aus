import 'package:pos_account/model/common/table_location.dart';

class PCatImages {
  PCatImages({
    // this.fileUploadFolderName,
    this.productCategoriesImages,
    this.categoryTypes,
    this.filterTypes,
    this.channels,
    this.posDevices,
  });
  // String? fileUploadFolderName;
  List<ProductCategoriesImage>? productCategoriesImages;
  List<TableLocation>? categoryTypes;
  List<TableLocation>? filterTypes;
  List<TableLocation>? channels;
  List<TableLocation>? posDevices;

  factory PCatImages.fromJson(Map<String, dynamic> json) => PCatImages(
        // fileUploadFolderName: json["fileUploadFolderName"],
        productCategoriesImages: json["productCategoriesImages"] == null
            ? null
            : List<ProductCategoriesImage>.from(json["productCategoriesImages"]
                .map((x) => ProductCategoriesImage.fromJson(x))),
        categoryTypes: json["categoryTypes"] == null
            ? null
            : List<TableLocation>.from(
                json["categoryTypes"].map((x) => TableLocation.fromJson(x))),
        filterTypes: json["filterTypes"] == null
            ? []
            : List<TableLocation>.from(
                json["filterTypes"]!.map((x) => TableLocation.fromJson(x))),
        channels: json["channels"] == null
            ? null
            : List<TableLocation>.from(
                json["channels"]!.map((x) => TableLocation.fromJson(x))),
        posDevices: json["posDevices"] == null
            ? []
            : List<TableLocation>.from(
                json["posDevices"]!.map((x) => TableLocation.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        // "fileUploadFolderName": fileUploadFolderName,
        "productCategoriesImages": productCategoriesImages == null
            ? null
            : List<dynamic>.from(
                productCategoriesImages!.map((x) => x.toJson())),
        "categoryTypes": categoryTypes == null
            ? null
            : List<dynamic>.from(categoryTypes!.map((x) => x.toJson())),
        "filterTypes": filterTypes == null
            ? []
            : List<dynamic>.from(filterTypes!.map((x) => x.toJson())),
        "channels": channels == null
            ? null
            : List<dynamic>.from(channels!.map((x) => x.toJson())),
        "posDevices": posDevices == null
            ? []
            : List<dynamic>.from(posDevices!.map((x) => x.toJson())),
      };
}

class ProductCategoriesImage {
  ProductCategoriesImage({
    this.id,
    this.name,
    this.imageUrl,
    this.isDefaultImage,
  });

  String? id;
  String? name;
  String? imageUrl;
  bool? isDefaultImage;

  factory ProductCategoriesImage.fromJson(Map<String, dynamic> json) =>
      ProductCategoriesImage(
        id: json["id"],
        name: json["name"],
        imageUrl: json["imageUrl"],
        isDefaultImage: json["isDefaultImage"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "imageUrl": imageUrl,
        "isDefaultImage": isDefaultImage,
      };
}
