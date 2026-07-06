class ItemModel {
  final String title;
  final String assetPath;
  final String price;

  ItemModel({
    required this.title,
    required this.assetPath,
    required this.price,
  });
}

class ProductItems {
  final String title;
  final List<ItemModel> itemList;

  ProductItems({required this.title, required this.itemList});
}

// final itemList = <ItemModel>[
//   ItemModel(
//       title: "Big Burger extra brisket",
//       assetPath: "assets/png/food_items/2.png",
//       price: "\$50.00"),
//   ItemModel(
//       title: "Big Burger extra brisket",
//       assetPath: "assets/png/food_items/2.png",
//       price: "\$50.00"),
//   ItemModel(
//       title: "Mix fruits 3 varient",
//       assetPath: "assets/png/food_items/6.png",
//       price: "\$100.00"),
//   ItemModel(
//       title: "Pineapple juice",
//       assetPath: "assets/png/food_items/1.png",
//       price: "\$20.00"),
//   ItemModel(
//       title: "Dunot",
//       assetPath: "assets/png/food_items/4.png",
//       price: "\$40.00"),
//   ItemModel(
//       title: "Big Burger extra brisket",
//       assetPath: "assets/png/food_items/2.png",
//       price: "\$50.00"),
//   ItemModel(
//       title: "Mix fruits 3 varient",
//       assetPath: "assets/png/food_items/6.png",
//       price: "\$100.00"),
//   ItemModel(
//       title: "Pineapple juice",
//       assetPath: "assets/png/food_items/1.png",
//       price: "\$20.00"),
//   ItemModel(
//       title: "Dunot",
//       assetPath: "assets/png/food_items/4.png",
//       price: "\$40.00"),
//   ItemModel(
//       title: "Big Burger extra brisket",
//       assetPath: "assets/png/food_items/2.png",
//       price: "\$50.00"),
//   ItemModel(
//       title: "Mix fruits 3 varient",
//       assetPath: "assets/png/food_items/6.png",
//       price: "\$100.00"),
//   ItemModel(
//       title: "Pineapple juice",
//       assetPath: "assets/png/food_items/1.png",
//       price: "\$20.00"),
//   ItemModel(
//       title: "Dunot",
//       assetPath: "assets/png/food_items/4.png",
//       price: "\$40.00"),
//   ItemModel(
//       title: "Big Burger extra brisket",
//       assetPath: "assets/png/food_items/2.png",
//       price: "\$50.00"),
//   ItemModel(
//       title: "Mix fruits 3 varient",
//       assetPath: "assets/png/food_items/6.png",
//       price: "\$100.00"),
//   ItemModel(
//       title: "Pineapple juice",
//       assetPath: "assets/png/food_items/1.png",
//       price: "\$20.00"),
//   ItemModel(
//       title: "Dunot",
//       assetPath: "assets/png/food_items/4.png",
//       price: "\$40.00"),
//   ItemModel(
//       title: "Dunot",
//       assetPath: "assets/png/food_items/4.png",
//       price: "\$40.00"),
//   ItemModel(
//       title: "Big Burger extra brisket",
//       assetPath: "assets/png/food_items/2.png",
//       price: "\$50.00"),
//   ItemModel(
//       title: "Mix fruits 3 varient",
//       assetPath: "assets/png/food_items/6.png",
//       price: "\$100.00"),
//   ItemModel(
//       title: "Big Burger extra brisket",
//       assetPath: "assets/png/food_items/2.png",
//       price: "\$50.00"),
//   ItemModel(
//       title: "Mix fruits 3 varient",
//       assetPath: "assets/png/food_items/6.png",
//       price: "\$100.00"),
//   ItemModel(
//       title: "Pineapple juice",
//       assetPath: "assets/png/food_items/1.png",
//       price: "\$20.00"),
//   ItemModel(
//       title: "Dunot",
//       assetPath: "assets/png/food_items/4.png",
//       price: "\$40.00"),
//   ItemModel(
//       title: "Big Burger extra brisket",
//       assetPath: "assets/png/food_items/2.png",
//       price: "\$50.00"),
//   ItemModel(
//       title: "Mix fruits 3 varient",
//       assetPath: "assets/png/food_items/6.png",
//       price: "\$100.00"),
//   ItemModel(
//       title: "Pineapple juice",
//       assetPath: "assets/png/food_items/1.png",
//       price: "\$20.00"),
//   ItemModel(
//       title: "Mix fruits 3 varient",
//       assetPath: "assets/png/food_items/6.png",
//       price: "\$100.00"),
//   ItemModel(
//       title: "Pineapple juice",
//       assetPath: "assets/png/food_items/1.png",
//       price: "\$20.00"),
//   ItemModel(
//       title: "Dunot",
//       assetPath: "assets/png/food_items/4.png",
//       price: "\$40.00"),
//   ItemModel(
//       title: "Big Burger extra brisket",
//       assetPath: "assets/png/food_items/2.png",
//       price: "\$50.00"),
//   ItemModel(
//       title: "Mix fruits 3 varient",
//       assetPath: "assets/png/food_items/6.png",
//       price: "\$100.00"),
//   ItemModel(
//       title: "Pineapple juice",
//       assetPath: "assets/png/food_items/1.png",
//       price: "\$20.00"),
//   ItemModel(
//       title: "Dunot",
//       assetPath: "assets/png/food_items/4.png",
//       price: "\$40.00"),
//   ItemModel(
//       title: "Big Burger extra brisket",
//       assetPath: "assets/png/food_items/2.png",
//       price: "\$50.00"),
//   ItemModel(
//       title: "Mix fruits 3 varient",
//       assetPath: "assets/png/food_items/6.png",
//       price: "\$100.00"),
//   ItemModel(
//       title: "Pineapple juice",
//       assetPath: "assets/png/food_items/1.png",
//       price: "\$20.00"),
//   ItemModel(
//       title: "Dunot",
//       assetPath: "assets/png/food_items/4.png",
//       price: "\$40.00"),
//   ItemModel(
//       title: "Big Burger extra brisket",
//       assetPath: "assets/png/food_items/2.png",
//       price: "\$50.00"),
//   ItemModel(
//       title: "Mix fruits 3 varient",
//       assetPath: "assets/png/food_items/6.png",
//       price: "\$100.00"),
//   ItemModel(
//       title: "Pineapple juice",
//       assetPath: "assets/png/food_items/1.png",
//       price: "\$20.00"),
//   ItemModel(
//       title: "Dunot",
//       assetPath: "assets/png/food_items/4.png",
//       price: "\$40.00"),
//   ItemModel(
//       title: "Dunot",
//       assetPath: "assets/png/food_items/4.png",
//       price: "\$40.00"),
//   ItemModel(
//       title: "Big Burger extra brisket",
//       assetPath: "assets/png/food_items/2.png",
//       price: "\$50.00"),
//   ItemModel(
//       title: "Mix fruits 3 varient",
//       assetPath: "assets/png/food_items/6.png",
//       price: "\$100.00"),
//   ItemModel(
//       title: "Pineapple juice",
//       assetPath: "assets/png/food_items/1.png",
//       price: "\$20.00"),
// ];

// final productItemList = <ProductItems>[
//   ProductItems(
//       title: "Home Dishes", itemList: itemList.getRange(10, 20).toList()),
//   ProductItems(
//       title: "Cold Dishes",
//       itemList: itemList.getRange(4, itemList.length - 20).toList()),
//   ProductItems(
//       title: "Soup",
//       itemList: itemList.getRange(10, itemList.length - 15).toList()),
//   ProductItems(
//       title: "Appetizer",
//       itemList: itemList.getRange(20, itemList.length).toList()),
//   ProductItems(
//       title: "Cold Dishes",
//       itemList: itemList.getRange(7, itemList.length - 25).toList()),
//   ProductItems(
//       title: "Soup",
//       itemList: itemList.getRange(1, itemList.length - 20).toList()),
//   ProductItems(
//       title: "Home Dishes",
//       itemList: itemList.getRange(4, itemList.length - 12).toList()),
//   ProductItems(
//       title: "Appetizer",
//       itemList: itemList.getRange(6, itemList.length - 19).toList()),
//   ProductItems(
//       title: "Cold Dishes",
//       itemList: itemList.getRange(9, itemList.length - 16).toList()),
//   ProductItems(
//       title: "Appetizer",
//       itemList: itemList.getRange(0, itemList.length - 12).toList()),
// ];
