import 'package:flutter/material.dart';
import 'package:pos_account/ln.dart';
import 'package:pos_account/model/home/menu/gift_card/image/gift_card_img_ad_sec.dart';
import 'package:pos_account/model/home/menu/gift_card/image/gift_card_img_data.dart';
import 'package:pos_account/model/ui_model/tablelist_model.dart';
import 'package:pos_account/repository/handler.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class GiftCardImagePro extends ChangeNotifier {
  void get notify => notifyListeners();

// get All Products
  int pageIndex = 1;
  static const int _pageSize = 500;
  int _totalPage = 0;

  final searchCltr = TextEditingController();

  final cardImageList = <GiftCardImageData>[];

  bool pageLoad = true;

  final refreshCltr = RefreshController(initialRefresh: false);

  Future<void> getGiftCardAll({int page = 1}) async {
    pageLoad = true;
    notify;
    if (page == 1 || pageIndex * _pageSize < _totalPage) {
      pageIndex = page;

      final res = await Handler.getAllGiftCardImage(
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

  // Get Add Section and Add New / Edit Image

  GiftCardImageAddSec? giftCardImageAddSec;
  int? templateIndex;

  var tableData = <TLModel>[
    TLModel(
      title: LN.name,
      tableCltr: TextEditingController(),
      isReq: true,
    ),
    TLModel(
      title: LN.amount,
      tableCltr: TextEditingController(),
      textInputType: TextInputType.number,
      isReq: true,
    )
  ];

  bool activeStatus = false;

  Future<void> getAdSec() async {
    pageLoad = true;
    giftCardImageAddSec = await Handler.giftCardImageAddSec().then((value) {
      pageLoad = false;
      return value;
    });
    notify;
  }

  bool isSaving = false;

  String? customGiftCardImagePath;

  Future<void> addUpdate() async {
    final data = GiftCardImageData(
      id: editId,
      name: tableData[0].tableCltr.text,
      amount: tableData[1].tableCltr.text,
      isActive: activeStatus,
    );

    if (giftCardImageAddSec?.giftCardTemplates != null &&
        templateIndex != null) {
      data.templateName =
          giftCardImageAddSec?.giftCardTemplates![templateIndex!].name;
      data.giftCardTemplateGroupId =
          giftCardImageAddSec?.giftCardTemplates![templateIndex!].id;
    }

    isSaving = true;
    notify;

    final status = await Handler.createUpGiftCardImage(
      giftCardImageData: data,
      imagePath: customGiftCardImagePath,
    );

    if (status ?? false) {
      clear();
      getGiftCardAll();
    }

    isSaving = false;
    notify;
  }

  //
  void clear() {
    for (final e in tableData) {
      e.tableCltr.clear();
    }
    templateIndex = null;
    activeStatus = false;
    customGiftCardImagePath = null;
    editId = "";
  }

  //edit data

  String editId = "";

  Future<bool?> editImage(String? id) async {
    if (id == null) return null;

    editId = id;
    pageLoad = true;
    notify;

    final editData = await Handler.giftCardImageEdit(id: id);

    pageLoad = false;
    notify;

    if (editData != null) {
      editId = editData.id ?? '';

      tableData[0].tableCltr.text = editData.name ?? '';
      tableData[1].tableCltr.text = editData.amount ?? '';

      activeStatus = editData.isActive ?? false;
      customGiftCardImagePath = editData.imagePath;

      if (giftCardImageAddSec?.giftCardTemplates?.isNotEmpty ?? false) {
        templateIndex = giftCardImageAddSec?.giftCardTemplates?.indexWhere(
            (element) => element.id == editData.giftCardTemplateGroupId);
        // print(templateIndex);
      }
      return true;
    }
    return null;
  }
}
