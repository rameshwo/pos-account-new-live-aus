import 'package:flutter/material.dart';
import 'package:pos_account/model/home/product/modifier/prod_var_modi_req.dart';
import 'package:pos_account/model/home/product/modifier/prod_with_variation_res.dart';
import 'package:pos_account/model/home/product/modifier/tag_modi_add_sec_res.dart';
import 'package:pos_account/model/home/product/product_data_req.dart';
import 'package:pos_account/model/ui_model/tag_modifier_model.dart';
import 'package:pos_account/repository/handler.dart';
import 'package:pos_account/repository/if_exception.dart';

class AssignModiPro extends ChangeNotifier {
  void get notify => notifyListeners();

  bool pageLoad = true;

  TagModiAddSecRes? addSec;

  List<ProdWithVarData>? prodVarDataList;

  String? selectedModifierGroupId;

  final searchCltr = TextEditingController();

  final modiItemGroupList = <ModiItemGroupModel>[];

  Future<void> getAddSec() async {
    addSec = await Handler.getAllTagModiAddSec();
    modiItemGroupList.clear();

    if (addSec?.modifierGroups?.isNotEmpty ?? false) {
      selectedModifierGroupId = addSec?.modifierGroups?.first.id;
      for (final e in addSec!.modifierGroups!) {
        if (addSec?.modifierItems != null) {
          final _modiItemList = <ModiItemModel>[];
          for (final a in addSec!.modifierItems!) {
            _modiItemList.add(ModiItemModel(
              updatedId: "",
              id: a.id ?? '',
              nameCltr: TextEditingController(text: a.name),
              priceCltr: TextEditingController(text: a.price),
              maxThredQtyCltr:
                  TextEditingController(text: a.maxThresholdQuantity),
              qtyCltr:
                  TextEditingController(text: a.rawLooseIngredientQuantity),
              type: a.type,
              prodVarId: a.productVariationId,
              rawIngreId: a.rawLooseIngredientId,
              // isSelected: a.isActive ?? false,
            ));
          }
          modiItemGroupList.add(ModiItemGroupModel(
            id: e.id ?? '',
            name: e.name ?? '',
            maxThQtyCltr: TextEditingController(text: e.maxThresholdQuantity),
            sortOrderCltr: TextEditingController(text: "1"),
            selectionTypeIndex: (addSec?.selectionTypes?.any((b) =>
                        b.id?.toLowerCase() ==
                        e.selectionTypeId?.toLowerCase()) ??
                    false)
                ? addSec?.selectionTypes?.indexWhere((b) =>
                    b.id?.toLowerCase() == e.selectionTypeId?.toLowerCase())
                : null,
            modiItemList: _modiItemList,
          ));
        }
      }
    }

    pageLoad = false;
    notify;
  }

  void clear() {
    pageLoad = true;
    prodVarDataList = null;
    searchCltr.clear();
    modiItemGroupList.clear();
    buttonLoad = false;
  }

  bool buttonLoad = false;

  Future<bool> createData() async {
    final _modiGroupList = <ProductVariationModifierGroup>[];

    for (int i = 0; i < modiItemGroupList.length; i++) {
      final _modiItemList = <ProductVariationModifierGroupModifierItem>[];

      for (int j = 0; j < modiItemGroupList[i].modiItemList.length; j++) {
        final _modiItem = modiItemGroupList[i].modiItemList[j];
        if (_modiItem.isSelected) {
          _modiItemList.add(ProductVariationModifierGroupModifierItem(
            id: "",
            name: _modiItem.nameCltr.text,
            modifierItemId: _modiItem.id,
            productVariationId: _modiItem.prodVarId,
            rawLooseIngredientId: _modiItem.rawIngreId,
            price: _modiItem.priceCltr.text,
            maxThresholdQuantity: _modiItem.maxThredQtyCltr.text,
            rawLooseIngredientQuantity: _modiItem.qtyCltr.text,
            sortOrder: j + 1,
            isActive: _modiItem.isSelected,
            type: _modiItem.type,
          ));
        }
      }

      if (_modiItemList.isNotEmpty) {
        final _selectTypeId = (addSec?.selectionTypes?.isNotEmpty ?? false) &&
                modiItemGroupList[i].selectionTypeIndex != null
            ? (addSec!.selectionTypes![modiItemGroupList[i].selectionTypeIndex!]
                    .id ??
                '')
            : "";
        if (_selectTypeId.isEmpty) {
          IfException.showMessage(
              message:
                  "Selection Type is required on Modifier Group '${modiItemGroupList[i].name}'");
          return false;
        }
        _modiGroupList.add(ProductVariationModifierGroup(
          modifierGroupId: modiItemGroupList[i].id,
          selectionTypeId: _selectTypeId,
          maxThresholdQuantity: modiItemGroupList[i].maxThQtyCltr.text,
          sortOrder: int.tryParse(modiItemGroupList[i].sortOrderCltr.text) ?? 1,
          modifierItems: _modiItemList,
        ));
      }
    }

    final _req = ProdVarModiReq(
      productVariations: prodVarDataList
          ?.expand((item) => item.productVariations ?? <ModifierVarData>[])
          .map((v) => v.id)
          .where((id) => id != null && id.isNotEmpty)
          .cast<String>()
          .toList(),
      modifiers: _modiGroupList,
    );

    buttonLoad = true;
    pageLoad = true;
    notify;

    final _res = await Handler.createProdVarModi(request: _req);

    buttonLoad = false;
    pageLoad = false;
    notify;

    return _res != null;
  }
}
