import 'package:flutter/material.dart';
import 'package:pos_account/ln.dart';
import 'package:pos_account/model/home/menu/gift_card/image/gift_card_img_data.dart';
import 'package:pos_account/model/ui_model/tablelist_model.dart';
import 'package:pos_account/repository/handler.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../../model/home/menu/gift_card/template/gift_card_temp_data.dart';

class GiftCardTemplatePro extends ChangeNotifier {
  void get notify => notifyListeners();

// get All Products
  int pageIndex = 1;
  static const int _pageSize = 20;
  int _totalPage = 0;

  final searchCltr = TextEditingController();

  final cardImageList = <GiftCardImageData>[];

  bool pageLoad = true;

  final refreshCltr = RefreshController(initialRefresh: false);

  Future<void> getAllGiftCardTemplate({int page = 1}) async {
    if (page == 1 || pageIndex * _pageSize < _totalPage) {
      pageIndex = page;

      final res = await Handler.getAllGiftCardTemplate(
        page: page,
        pageSize: _pageSize,
        searchKey: searchCltr.text,
      );

      if (page == 1) {
        cardImageList.clear();
      }

      if (res?.data != null) {
        _totalPage = res?.total ?? 0;
        cardImageList.addAll(res!.data!);
      }
    }

    pageLoad = false;
    refreshCltr.loadComplete();
    refreshCltr.refreshCompleted();
    notify;
  }

  var tableData = <TLModel>[
    TLModel(
      title: LN.name,
      tableCltr: TextEditingController(),
      isReq: true,
    ),
    TLModel(
      title: "Sort Order",
      tableCltr: TextEditingController(),
      isReq: true,
      textInputType: TextInputType.number,
    ),
  ];

  bool activeStatus = false;

  bool isSaving = false;

  Future<void> addUpdate() async {
    final data = GiftCardTempData(
      id: editId,
      name: tableData[0].tableCltr.text,
      sortOrder: tableData[1].tableCltr.text,
      isActive: activeStatus,
    );
    isSaving = true;
    notify;

    final status = await Handler.createGiftCardTemplateGroup(
      giftCardTempData: data,
    );
    if (status ?? false) {
      clear();
      getAllGiftCardTemplate();
    }
    isSaving = false;
    notify;
  }

  //edit data
  Future<bool?> editImage(String? id) async {
    pageLoad = true;
    notify;
    final editData = await Handler.giftCardTempGroupEdit(id: id);
    if (editData != null) {
      pageLoad = false;
      editId = editData.id ?? "";
      tableData[0].tableCltr.text = editData.name ?? "";
      activeStatus = editData.isActive ?? false;
      tableData[1].tableCltr.text =
          editData.sortOrder == null ? "" : editData.sortOrder.toString();
      notify;
      return true;
    }
    pageLoad = false;
    notify;
    return null;
  }

  //
  void clear() {
    for (final e in tableData) {
      e.tableCltr.clear();
    }
    activeStatus = false;
    editId = "";
  }

  String editId = "";
}
