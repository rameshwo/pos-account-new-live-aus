import 'package:flutter/material.dart';

class ProductItemModel {
  final String id;
  String? prodMame;
  String? modiName;
  // int? modifierCount;
  final List<ModiItemGroupModel> groupList;

  ProductItemModel({
    required this.id,
    this.prodMame,
    this.modiName,
    // this.modifierCount,
    required this.groupList,
  });
}

class ModiItemGroupModel {
  final String id;
  final String name;
  final TextEditingController maxThQtyCltr;
  final TextEditingController sortOrderCltr;
  int? selectionTypeIndex;
  final List<ModiItemModel> modiItemList;

  ModiItemGroupModel({
    required this.id,
    required this.name,
    required this.maxThQtyCltr,
    required this.sortOrderCltr,
    this.selectionTypeIndex,
    required this.modiItemList,
  });
}

class ModiItemModel {
  final String id;
  final String updatedId;
  final TextEditingController nameCltr;
  final TextEditingController priceCltr;
  final TextEditingController maxThredQtyCltr;
  final TextEditingController qtyCltr;
  final String? type;
  final String? prodVarId;
  final String? rawIngreId;
  bool isSelected;
  // bool isActive;

  ModiItemModel({
    required this.id,
    required this.updatedId,
    required this.nameCltr,
    required this.priceCltr,
    required this.maxThredQtyCltr,
    required this.qtyCltr,
    this.type,
    this.prodVarId,
    this.rawIngreId,
    this.isSelected = false,
    // required this.isActive,
  });
}

enum ModiItemType { Custom, Products, RawLooseIngredient }
