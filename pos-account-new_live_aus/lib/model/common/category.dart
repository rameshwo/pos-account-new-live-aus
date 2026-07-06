class Category {
  Category({
    this.categoryName,
    this.categoryId,
    this.childernCategories,
  });

  String? categoryName;
  String? categoryId;
  List<Category>? childernCategories;

  factory Category.fromJson(Map<String, dynamic> json) => Category(
        categoryName: json["categoryName"],
        categoryId: json["categoryId"],
        childernCategories: json["childernCategories"] == null
            ? []
            : List<Category>.from(
                json["childernCategories"]!.map((x) => Category.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "categoryName": categoryName,
        "categoryId": categoryId,
        "childernCategories": childernCategories == null
            ? []
            : List<dynamic>.from(childernCategories!.map((x) => x.toJson())),
      };
}

// class TreeList {
//   TreeList({
//     this.name,
//     this.id,
//     this.children,
//   });

//   String? name;
//   String? id;
//   List<TreeList>? children;

//   factory TreeList.fromJson(Map<String, dynamic> json) => TreeList(
//         name: json["name"],
//         id: json["id"],
//         children: json["children"] == null
//             ? []
//             : List<TreeList>.from(
//                 json["children"]!.map((x) => TreeList.fromJson(x))),
//       );

//   Map<String, dynamic> toJson() => {
//         "name": name,
//         "id": id,
//         "children": children == null
//             ? []
//             : List<dynamic>.from(children!.map((x) => x.toJson())),
//       };
// }
