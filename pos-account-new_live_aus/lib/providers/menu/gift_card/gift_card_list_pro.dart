import 'package:flutter/material.dart';
import 'package:pos_account/ln.dart';
import 'package:pos_account/model/home/menu/gift_card/gift_card_res.dart';
import 'package:pos_account/model/home/menu/gift_card/gift_card_search_sec.dart';
import 'package:pos_account/model/home/menu/gift_card/gift_redeem_history.dart';
import 'package:pos_account/model/home/setting/general/category/restro_table_model.dart';
import 'package:pos_account/repository/handler.dart';
import 'package:pos_account/screens/home_screen/com/gift_card_screen/com/gift_card_list/gift_card_list_page.dart';
import 'package:pos_account/services/database/shared_pref.dart';

class GiftCardListPro extends ChangeNotifier {
  void get notify => notifyListeners();

  static List<String> get _headerList => [
        LN.giftCardNo,
        LN.senderName,
        LN.receiverName,
        LN.purDate,
        LN.expiryDate,
        LN.status,
        LN.action,
      ];

  final tableList = RTableData(
    headerList: _headerList,
    hasAction: false,
    showCheckBox: false,
    // hasActionButton: true,
  );

  void init() {
    tableList.headerList = _headerList;
  }

  String? dateFormat;

  bool pageLoad = true;
  GiftCardSearchSec? giftCardSearchSec;
  int? giftStatusIndex;

  final giftCardCltr = TextEditingController();
  final receiverNameCltr = TextEditingController();
  final expiryDateCltr = TextEditingController();

  AllGiftCardRes? allGiftCardRes;
  int pageIndex = 1;

  bool isSearching = false;

  Future<void> getData({
    int page = 1,
  }) async {
    pageIndex = page;

    String statusId = "";
    if (giftCardSearchSec?.giftCardStatus != null && giftStatusIndex != null) {
      statusId = giftCardSearchSec!.giftCardStatus![giftStatusIndex!].id ?? "";
    }

    String dateFrom = "";
    String dateTo = "";

    if (expiryDateCltr.text.split(' - ').isNotEmpty) {
      dateFrom = expiryDateCltr.text.split(' - ').first;
      dateTo = expiryDateCltr.text.split(' - ').last;
    }

    allGiftCardRes = await Handler.getAllGiftCard(
      page: page,
      code: giftCardCltr.text,
      reName: receiverNameCltr.text,
      statusId: statusId,
      dateFrom: dateFrom,
      dateTo: dateTo,
    );

    if (allGiftCardRes?.data != null) {
      tableList.tableDataList = [];

      for (final e in allGiftCardRes!.data!) {
        tableList.tableDataList.add(TableDataList(
          id: e.id ?? '',
          itemList: [
            e.giftCardCode ?? '',
            e.senderName ?? '',
            e.receiverName ?? '',
            e.purchaseDate ?? '',
            e.expiryDate ?? '',
          ],
          statusList: [],
          actionWidget: GiftCardListPage.actionWidget(e),
        ));
      }
    }
    pageLoad = false;
    isSearching = false;
    notify;
  }

  Future<void> getSearchData() async {
    dateFormat = await SharedPrefs.dateFormat;
    giftCardSearchSec = await Handler.giftCardSearchList();
    notify;
  }

  void clear() {
    dateFormat = null;
    pageLoad = true;
    giftCardSearchSec = null;
    giftStatusIndex = null;
    giftCardCltr.clear();
    receiverNameCltr.clear();
    expiryDateCltr.clear();
    allGiftCardRes = null;
    pageIndex = 1;
    isSearching = false;
    tableList.tableDataList = [];
  }

  // Redeem History

  GiftRedeemHistory? giftRedeemHistory;
  bool diaLoad = true;
  String curSym = "";

  Future<void> getRedeemHistory(String id) async {
    curSym = await SharedPrefs.curSym;
    giftRedeemHistory = await Handler.getGiftCardDetail(id: id);
    diaLoad = false;
    notify;
  }

  void diaClear() {
    giftRedeemHistory = null;
    diaLoad = true;
  }

  bool deactivateLoad = false;

  Future<bool> deactivateRedeem(String id) async {
    deactivateLoad = true;
    notify;
    final status = await Handler.deactivateGiftCard(id: id);

    deactivateLoad = false;
    notify;
    return status ?? false;
  }
}
