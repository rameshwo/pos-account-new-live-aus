class PosScreenCatRes {
  List<CategoryData>? comboCategories;
  List<CategoryData>? rawLooseCategories;
  List<CategoryData>? productCategories;

  PosScreenCatRes({
    this.comboCategories,
    this.rawLooseCategories,
    this.productCategories,
  });

  factory PosScreenCatRes.fromJson(Map<String, dynamic> json) =>
      PosScreenCatRes(
        comboCategories: json["comboCategories"] == null
            ? []
            : List<CategoryData>.from(
                json["comboCategories"]!.map((x) => CategoryData.fromJson(x))),
        rawLooseCategories: json["rawLooseCategories"] == null
            ? []
            : List<CategoryData>.from(json["rawLooseCategories"]!
                .map((x) => CategoryData.fromJson(x))),
        productCategories: json["itemServiceCategories"] == null
            ? []
            : List<CategoryData>.from(json["itemServiceCategories"]!
                .map((x) => CategoryData.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "comboCategories": comboCategories == null
            ? []
            : List<dynamic>.from(comboCategories!.map((x) => x.toJson())),
        "rawLooseCategories": rawLooseCategories == null
            ? []
            : List<dynamic>.from(rawLooseCategories!.map((x) => x.toJson())),
        "itemServiceCategories": productCategories == null
            ? []
            : List<dynamic>.from(productCategories!.map((x) => x.toJson())),
      };
}

class CategoryData {
  String? id;
  String? name;
  String? type;
  String? defaultBackGroundColor;
  String? defaultTextColor;
  String? onFocusBackGroundColor;
  String? onFocusTextColor;
  String? imageUrl;
  ItemViewType? itemViewType;

  CategoryData({
    this.id,
    this.name,
    this.type,
    this.defaultBackGroundColor,
    this.defaultTextColor,
    this.onFocusBackGroundColor,
    this.onFocusTextColor,
    this.imageUrl,
    this.itemViewType,
  });

  factory CategoryData.fromJson(Map<String, dynamic> json) => CategoryData(
        id: json["id"],
        name: json["name"],
        type: json["type"],
        defaultBackGroundColor: json["defaultBackGroundColor"],
        defaultTextColor: json["defaultTextColor"],
        onFocusBackGroundColor: json["onFocusBackGroundColor"],
        onFocusTextColor: json["onFocusTextColor"],
        imageUrl: json["imageUrl"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "type": type,
        "defaultBackGroundColor": defaultBackGroundColor,
        "defaultTextColor": defaultTextColor,
        "onFocusBackGroundColor": onFocusBackGroundColor,
        "onFocusTextColor": onFocusTextColor,
        "imageUrl": imageUrl,
      };
}

enum ItemViewType { combo, ingre, product, promotion }
