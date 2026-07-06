import 'package:flutter/material.dart';
import 'package:pos_account/model/common/res_datum.dart';
import 'package:pos_account/model/home/product/modifier/prod_var_modi_group_res.dart';
import 'package:pos_account/model/home/product/modifier/prod_with_variation_res.dart';
import 'package:pos_account/model/home/product/modifier/tag_modi_add_sec_res.dart';
import 'package:pos_account/model/home/product/modifier/up_prod_var_modi_group_req.dart';
import 'package:pos_account/model/home/product/product_data_req.dart';
import 'package:pos_account/model/ui_model/tag_modifier_model.dart';
import 'package:pos_account/repository/handler.dart';
import 'package:pos_account/repository/if_exception.dart';

class EditModiPro extends ChangeNotifier {
  void get notify => notifyListeners();

  bool pageLoad = true;

  TagModiAddSecRes? addSec;

  List<ProdWithVarData>? prodVarDataList;
  bool isEdit = false;

  String? selectedModifierGroupId;

  final searchCltr = TextEditingController();

  final productItemList = <ProductItemModel>[];

  Future<void> getAddSec() async {
    addSec = await Handler.getAllTagModiAddSec();
  }

  void clear() {
    isEdit = false;
    pageLoad = true;
    prodVarDataList = null;
    searchCltr.clear();
    editModiGroupList = null;
    selectedModiItemId = null;
    buttonLoad = false;
    selectedModifierGroupId = null;
    productItemList.clear();
  }

  bool buttonLoad = false;

  Future<bool> updateData() async {
    final _data = <UpProdVarModiGroupReq>[];

    for (int i = 0; i < productItemList.length; i++) {
      final _prodItem = productItemList[i];

      final _modifierGroups = <ProductVariationModifierGroup>[];

      if (editModiGroupList != null) {
        if (editModiGroupList?.any(
                (a) => a.id?.toLowerCase() == _prodItem.id.toLowerCase()) ??
            false) {
          final _editModiGroup = editModiGroupList?.firstWhere(
              (a) => a.id?.toLowerCase() == _prodItem.id.toLowerCase());

          for (final _groupItem in _prodItem.groupList) {
            ProductVariationModifierGroup? _editGroup;

            if (_editModiGroup!.modifierGroups!.any((b) =>
                b.modifierGroupId?.toLowerCase() ==
                _groupItem.id.toLowerCase())) {
              _editGroup = _editModiGroup.modifierGroups!.firstWhere((b) =>
                  b.modifierGroupId?.toLowerCase() ==
                  _groupItem.id.toLowerCase());
            }

            final _modifierItems =
                <ProductVariationModifierGroupModifierItem>[];

            for (int j = 0; j < _groupItem.modiItemList.length; j++) {
              final c = _groupItem.modiItemList[j];

              // ProductVariationModifierGroupModifierItem? _modiItem;

              // if (_editGroup?.modifierItems?.any((b) =>
              //         b.id?.toLowerCase() == c.updatedId.toLowerCase()) ??
              //     false) {
              //   _modiItem = _editGroup?.modifierItems?.firstWhere(
              //       (b) => b.id?.toLowerCase() == c.updatedId.toLowerCase());
              // }

              // kPrint('FromEdit ${_modiItem?.name} | ${_modiItem?.id}');

              if (c.isSelected) {
                _modifierItems.add(ProductVariationModifierGroupModifierItem(
                  id: c.updatedId,
                  name: c.nameCltr.text,
                  modifierItemId: c.id,
                  productVariationId: c.prodVarId,
                  rawLooseIngredientId: c.rawIngreId,
                  price: c.priceCltr.text,
                  maxThresholdQuantity: c.maxThredQtyCltr.text,
                  rawLooseIngredientQuantity: c.qtyCltr.text,
                  sortOrder: j + 1,
                  isActive: c.isSelected,
                  type: c.type,
                ));
              }

              //  else if (c.isSelected) {
              //   // kPrint('FromNew ${c.nameCltr.text} | =-----');
              //   _modifierItems.add(ProductVariationModifierGroupModifierItem(
              //     id: "",
              //     name: c.nameCltr.text,
              //     modifierItemId: c.id,
              //     productVariationId: c.prodVarId,
              //     rawLooseIngredientId: c.rawIngreId,
              //     price: c.priceCltr.text,
              //     maxThresholdQuantity: c.maxThredQtyCltr.text,
              //     rawLooseIngredientQuantity: c.qtyCltr.text,
              //     sortOrder: j + 1,
              //     isActive: c.isSelected,
              //     type: c.type,
              //   ));
              // }
            }

//
            if (_modifierItems.isNotEmpty) {
              final _selectTypeId =
                  (addSec?.selectionTypes?.isNotEmpty ?? false) &&
                          _groupItem.selectionTypeIndex != null
                      ? (addSec!.selectionTypes![_groupItem.selectionTypeIndex!]
                              .id ??
                          '')
                      : "";
              if (_selectTypeId.isEmpty) {
                IfException.showMessage(
                    message:
                        "Selection Type is required on Modifier Group '${_groupItem.name}'");
                return false;
              }

              _modifierGroups.add(ProductVariationModifierGroup(
                id: _editGroup?.id ?? '',
                modifierGroupId: _groupItem.id,
                selectionTypeId: _selectTypeId,
                maxThresholdQuantity: _groupItem.maxThQtyCltr.text,
                sortOrder: int.tryParse(_groupItem.sortOrderCltr.text),
                modifierItems: _modifierItems,
              ));
            }
          }
        }
      }

      _data.add(UpProdVarModiGroupReq(
        id: _prodItem.id,
        name: _prodItem.modiName,
        modifierGroups: _modifierGroups,
      ));
    }

    // log(json.encode(_data.map((a) => a.toJson()).toList()));
    // return false;

    buttonLoad = true;
    pageLoad = true;
    notify;

    final _res = await Handler.updateProdVar(data: _data);

    buttonLoad = false;
    pageLoad = false;
    notify;

    return _res != null;
  }

  List<ProdVarModiGroupRes>? editModiGroupList;
  String? selectedModiItemId;

  Future<void> editModifier() async {
    if (prodVarDataList == null || !isEdit) {
      pageLoad = false;
      notify;
      return;
    }
    final _dataList = <SRDatum>[];
    for (final a in prodVarDataList!) {
      if (a.productVariations != null)
        for (final b in a.productVariations!) {
          if (b.id?.isNotEmpty ?? false)
            _dataList.add(SRDatum(id: b.id, name: b.name ?? ''));
        }
    }

    if ((prodVarDataList?.isNotEmpty ?? false) &&
        (prodVarDataList?.first.productVariations?.isNotEmpty ?? false))
      selectedModiItemId = prodVarDataList?.first.productVariations?.first.id;

    pageLoad = true;
    notify;

    editModiGroupList = await Handler.getProdVarModiGroup(dataList: _dataList);
    setData();

    pageLoad = false;
    notify;
  }

  void setData() {
    if (addSec?.modifierGroups?.isNotEmpty ?? false) {
      selectedModifierGroupId = addSec?.modifierGroups?.first.id;
    }

    if (editModiGroupList != null) {
      productItemList.clear();

      for (final a in editModiGroupList!) {
        final _data1 = (prodVarDataList?.any((b) =>
                    b.productVariations?.any(
                        (c) => c.id?.toLowerCase() == a.id?.toLowerCase()) ??
                    false) ??
                false)
            ? prodVarDataList?.firstWhere((b) =>
                b.productVariations
                    ?.any((c) => c.id?.toLowerCase() == a.id?.toLowerCase()) ??
                false)
            : null;

        final _data2 = (_data1?.productVariations
                    ?.any((d) => d.id?.toLowerCase() == a.id?.toLowerCase()) ??
                false)
            ? _data1?.productVariations
                ?.firstWhere((d) => d.id?.toLowerCase() == a.id?.toLowerCase())
            : null;

        final _groupList = <ModiItemGroupModel>[];

        if (addSec?.modifierGroups != null) {
          for (final e in addSec!.modifierGroups!) {
            if (a.modifierGroups?.any((f) =>
                    f.modifierGroupId?.toLowerCase() == e.id?.toLowerCase()) ??
                false) {
              final _groupSec = a.modifierGroups?.firstWhere((f) =>
                  f.modifierGroupId?.toLowerCase() == e.id?.toLowerCase());

              final _modiItemList = <ModiItemModel>[];

              if (addSec?.modifierItems != null) {
                for (final g in addSec!.modifierItems!) {
                  if (_groupSec?.modifierItems?.any((h) =>
                          h.modifierItemId?.toLowerCase() ==
                          g.id?.toLowerCase()) ??
                      false) {
                    final _modiItem = _groupSec?.modifierItems?.firstWhere(
                        (h) =>
                            h.modifierItemId?.toLowerCase() ==
                            g.id?.toLowerCase());

                    _modiItemList.add(ModiItemModel(
                      updatedId: _modiItem?.id ?? '',
                      id: g.id ?? '',
                      nameCltr: TextEditingController(text: g.name),
                      priceCltr: TextEditingController(text: _modiItem?.price),
                      maxThredQtyCltr: TextEditingController(
                          text: _modiItem?.maxThresholdQuantity),
                      qtyCltr: TextEditingController(
                          text: _modiItem?.rawLooseIngredientQuantity),
                      type: _modiItem?.type,
                      prodVarId: _modiItem?.productVariationId,
                      rawIngreId: _modiItem?.rawLooseIngredientId,
                      isSelected: true,
                      // isActive: _modiItem?.isActive ?? false,
                    ));
                  } else {
                    _modiItemList.add(ModiItemModel(
                      updatedId: "",
                      id: g.id ?? '',
                      nameCltr: TextEditingController(text: g.name),
                      priceCltr: TextEditingController(text: g.price),
                      maxThredQtyCltr:
                          TextEditingController(text: g.maxThresholdQuantity),
                      qtyCltr: TextEditingController(
                          text: g.rawLooseIngredientQuantity),
                      type: g.type,
                      prodVarId: g.productVariationId,
                      rawIngreId: g.rawLooseIngredientId,
                      isSelected: false,
                      // isActive: g.isActive ?? false,
                    ));
                  }
                }
              }

              _groupList.add(ModiItemGroupModel(
                id: e.id ?? '',
                name: e.name ?? '',
                maxThQtyCltr: TextEditingController(
                    text: _groupSec?.maxThresholdQuantity),
                sortOrderCltr:
                    TextEditingController(text: "${_groupSec?.sortOrder}"),
                selectionTypeIndex: (addSec?.selectionTypes?.any((h) =>
                            h.id?.toLowerCase() ==
                            _groupSec?.selectionTypeId?.toLowerCase()) ??
                        false)
                    ? addSec?.selectionTypes?.indexWhere((h) =>
                        h.id?.toLowerCase() ==
                        _groupSec?.selectionTypeId?.toLowerCase())
                    : null,
                modiItemList: _modiItemList,
              ));
            } else {
              final _modiItemList2 = <ModiItemModel>[];

              for (final i in addSec!.modifierItems!) {
                _modiItemList2.add(ModiItemModel(
                  updatedId: "",
                  id: i.id ?? '',
                  nameCltr: TextEditingController(text: i.name),
                  priceCltr: TextEditingController(text: i.price),
                  maxThredQtyCltr:
                      TextEditingController(text: i.maxThresholdQuantity),
                  qtyCltr:
                      TextEditingController(text: i.rawLooseIngredientQuantity),
                  type: i.type,
                  prodVarId: i.productVariationId,
                  rawIngreId: i.rawLooseIngredientId,
                  // isActive: i.isActive ?? false,
                ));
              }

              _groupList.add(ModiItemGroupModel(
                id: e.id ?? '',
                name: e.name ?? '',
                maxThQtyCltr:
                    TextEditingController(text: e.maxThresholdQuantity),
                sortOrderCltr: TextEditingController(text: "1"),
                selectionTypeIndex: (addSec?.selectionTypes?.any((h) =>
                            h.id?.toLowerCase() ==
                            e.selectionTypeId?.toLowerCase()) ??
                        false)
                    ? addSec?.selectionTypes?.indexWhere((h) =>
                        h.id?.toLowerCase() == e.selectionTypeId?.toLowerCase())
                    : null,
                modiItemList: _modiItemList2,
              ));
            }
          }
        }

        productItemList.add(
          ProductItemModel(
            id: a.id ?? '',
            prodMame: _data1?.name,
            modiName: _data2?.name,
            // modifierCount: _data2?.modifierCount,
            groupList: _groupList,
          ),
        );
      }
    }
  }

  void copyToOthers(String copyFromId, List<String> copyToIdList) {
    final _prodData = productItemList
        .firstWhere((a) => a.id.toLowerCase() == copyFromId.toLowerCase());

    final _copyData2 = _prodData.groupList.firstWhere(
        (a) => a.id.toLowerCase() == selectedModifierGroupId?.toLowerCase());

    final _copyModiList = _copyData2.modiItemList;

    for (final a in productItemList) {
      if (a.id.toLowerCase() != copyFromId.toLowerCase() &&
          copyToIdList.any((d) => d.toLowerCase() == a.id.toLowerCase())) {
        final _groupData = a.groupList.firstWhere((x) =>
            x.id.toLowerCase() == selectedModifierGroupId?.toLowerCase());

        _groupData.maxThQtyCltr.text = _copyData2.maxThQtyCltr.text;
        _groupData.selectionTypeIndex = _copyData2.selectionTypeIndex;
        _groupData.sortOrderCltr.text = _copyData2.sortOrderCltr.text;

        for (final b in _groupData.modiItemList) {
          final _copyModi = _copyModiList
              .firstWhere((c) => c.id.toLowerCase() == b.id.toLowerCase());
          b.isSelected = _copyModi.isSelected;
          b.maxThredQtyCltr.text = _copyModi.maxThredQtyCltr.text;
          b.nameCltr.text = _copyModi.nameCltr.text;
          b.priceCltr.text = _copyModi.priceCltr.text;
          b.qtyCltr.text = _copyModi.qtyCltr.text;
        }
      }
    }
  }
}
