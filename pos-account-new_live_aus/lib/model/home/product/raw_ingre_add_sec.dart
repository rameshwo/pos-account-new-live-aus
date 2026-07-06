import 'package:pos_account/model/common/table_location.dart';

import '../../common/filter_category.dart';

class RawIngreAddSectionList {
  String? code;
  List<TableLocation>? unitOfMeasurements;
  List<TableLocation>? salesTaxes;
  List<TableLocation>? purchaseTaxes;
  List<TableLocation>? suppliers;
  List<FilterCategory>? filterCategories;

  RawIngreAddSectionList(
      {this.code,
      this.unitOfMeasurements,
      this.salesTaxes,
      this.purchaseTaxes,
      this.suppliers,
      this.filterCategories});

  RawIngreAddSectionList.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    if (json['unitOfMeasurements'] != null) {
      unitOfMeasurements = <TableLocation>[];
      json['unitOfMeasurements'].forEach((v) {
        unitOfMeasurements!.add(TableLocation.fromJson(v));
      });
    }
    if (json['salesTaxes'] != null) {
      salesTaxes = <TableLocation>[];
      json['salesTaxes'].forEach((v) {
        salesTaxes!.add(TableLocation.fromJson(v));
      });
    }
    if (json['purchaseTaxes'] != null) {
      purchaseTaxes = <TableLocation>[];
      json['purchaseTaxes'].forEach((v) {
        purchaseTaxes!.add(TableLocation.fromJson(v));
      });
    }
    if (json['suppliers'] != null) {
      suppliers = <TableLocation>[];
      json['suppliers'].forEach((v) {
        suppliers!.add(TableLocation.fromJson(v));
      });
    }
    if (json['filterCategories'] != null) {
      filterCategories = <FilterCategory>[];
      json['filterCategories'].forEach((v) {
        filterCategories!.add(FilterCategory.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['code'] = code;
    if (unitOfMeasurements != null) {
      data['unitOfMeasurements'] =
          unitOfMeasurements!.map((v) => v.toJson()).toList();
    }
    if (salesTaxes != null) {
      data['salesTaxes'] = salesTaxes!.map((v) => v.toJson()).toList();
    }
    if (purchaseTaxes != null) {
      data['purchaseTaxes'] = purchaseTaxes!.map((v) => v.toJson()).toList();
    }
    if (suppliers != null) {
      data['suppliers'] = suppliers!.map((v) => v.toJson()).toList();
    }
    if (filterCategories != null) {
      data['filterCategories'] =
          filterCategories!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class FilterCategories {
  String? filterCategoryName;
  String? filterCategoryId;
  List<TableLocation>? childernCategories;

  FilterCategories(
      {this.filterCategoryName,
      this.filterCategoryId,
      this.childernCategories});

  FilterCategories.fromJson(Map<String, dynamic> json) {
    filterCategoryName = json['filterCategoryName'];
    filterCategoryId = json['filterCategoryId'];
    if (json['childernCategories'] != null) {
      childernCategories = <TableLocation>[];
      json['childernCategories'].forEach((v) {
        childernCategories!.add(TableLocation.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['filterCategoryName'] = filterCategoryName;
    data['filterCategoryId'] = filterCategoryId;
    if (childernCategories != null) {
      data['childernCategories'] =
          childernCategories!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
