import 'package:flutter/material.dart';
import 'package:oktoast/oktoast.dart';
import 'package:pos_account/ln.dart';
import 'package:pos_account/model/home/sync/sync_sec_res.dart';
import 'package:pos_account/repository/handler.dart';

class SyncPro extends ChangeNotifier {
  bool loading = true;

  SyncSecListRes? syncSecRes;
  int? syncFromIndex;
  int? syncToIndex;

  Future<void> getData() async {
    syncSecRes = await Handler.syncSecList();
    loading = false;
    notify;
  }

  bool syncLoad = false;

  Future<void> syncProduct() async {
    if (syncSecRes == null ||
        syncSecRes!.channels == null ||
        syncSecRes!.channels!.isEmpty) return;

    if (syncFromIndex == null) {
      showToast(LN.syncFromIsNotSelected);
      return;
    }
    if (syncToIndex == null) {
      showToast(LN.syncToIsNotSelected);
      return;
    }
    loading = true;
    syncLoad = true;
    notify;

    await Handler.syncProduct(
        syncFromChannelId: syncSecRes!.channels![syncFromIndex!].id ?? "",
        syncToChannelId: syncSecRes!.channels![syncToIndex!].id ?? "");

    loading = false;
    syncLoad = false;
    notify;
  }

  void clear() {
    loading = true;
    syncSecRes = null;
    syncFromIndex = null;
    syncToIndex = null;
  }

  void get notify => notifyListeners();
}
