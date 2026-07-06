import 'feature_product.dart';

class ComboDetailById {
  String? id;
  String? taxExclusiveInclusiveValue;
  bool? isSetMenu;
  String? setMenuName;
  String? image;
  String? discountedPrice;
  String? discountPrice;
  String? actualPrice;
  String? discountPercentage;
  List<SetMenuProductListViewModelWithCategory>?
      setMenuProductListViewModelWithCategory;
  int quantity;
  String curSym;

  ComboDetailById({
    this.id,
    this.taxExclusiveInclusiveValue,
    this.isSetMenu,
    this.setMenuName,
    this.image,
    this.discountedPrice,
    this.discountPrice,
    this.actualPrice,
    this.discountPercentage,
    this.setMenuProductListViewModelWithCategory,
    this.quantity = 1,
    this.curSym = "",
  });

  factory ComboDetailById.fromJson(Map<String, dynamic> json) =>
      ComboDetailById(
        id: json["id"],
        taxExclusiveInclusiveValue: json["taxExclusiveInclusiveValue"],
        isSetMenu: json["isSetMenu"],
        setMenuName: json["setMenuName"],
        image: json["image"],
        discountedPrice: json["discountedPrice"],
        discountPrice: json["discountPrice"],
        actualPrice: json["actualPrice"],
        discountPercentage: json["discountPercentage"],
        setMenuProductListViewModelWithCategory:
            json["setMenuProductListViewModelWithCategory"] == null
                ? []
                : List<SetMenuProductListViewModelWithCategory>.from(
                    json["setMenuProductListViewModelWithCategory"]!.map((x) =>
                        SetMenuProductListViewModelWithCategory.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "taxExclusiveInclusiveValue": taxExclusiveInclusiveValue,
        "isSetMenu": isSetMenu,
        "setMenuName": setMenuName,
        "image": image,
        "discountedPrice": discountedPrice,
        "discountPrice": discountPrice,
        "actualPrice": actualPrice,
        "discountPercentage": discountPercentage,
        "setMenuProductListViewModelWithCategory":
            setMenuProductListViewModelWithCategory == null
                ? []
                : List<dynamic>.from(setMenuProductListViewModelWithCategory!
                    .map((x) => x.toJson())),
      };
}

class SetMenuProductListViewModelWithCategory {
  String? id;
  String? categoryName;
  String? categoryDescription;
  dynamic maxItemCount;
  List<FeaturedProduct>? setMenuProductListViewModels;

  SetMenuProductListViewModelWithCategory({
    this.id,
    this.categoryName,
    this.categoryDescription,
    this.maxItemCount,
    this.setMenuProductListViewModels,
  });

  factory SetMenuProductListViewModelWithCategory.fromJson(
          Map<String, dynamic> json) =>
      SetMenuProductListViewModelWithCategory(
        id: json["id"],
        categoryName: json["categoryName"],
        categoryDescription: json["categoryDescription"],
        maxItemCount: json["maxItemCount"],
        setMenuProductListViewModels: json["setMenuProductListViewModels"] ==
                null
            ? []
            : List<FeaturedProduct>.from(json["setMenuProductListViewModels"]!
                .map((x) => FeaturedProduct.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "categoryName": categoryName,
        "categoryDescription": categoryDescription,
        "maxItemCount": maxItemCount,
        "setMenuProductListViewModels": setMenuProductListViewModels == null
            ? []
            : List<dynamic>.from(
                setMenuProductListViewModels!.map((x) => x.toJson())),
      };
}
