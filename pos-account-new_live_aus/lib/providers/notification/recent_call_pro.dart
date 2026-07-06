import 'package:flutter/material.dart';
import 'package:pos_account/model/notification/recent_call_res.dart';
import 'package:pos_account/repository/handler.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class RecentCallPro extends ChangeNotifier {
  void get notify => notifyListeners();

  bool loading = false;
  bool dataLoad = false;
  RefreshController? refreshCltr;
  int pageIndex = 1;
  final int _pageSize = 10;
  int _totalPage = 0;

  final recentCallList = <RecentCallData>[];

  void init() {
    refreshCltr = RefreshController(initialRefresh: false);
    WidgetsBinding.instance.addPostFrameCallback((_) {});
  }

  void clear() {
    loading = false;
    pageIndex = 1;
    _totalPage = 0;
    dataLoad = false;
    recentCallList.clear();
    if (refreshCltr != null) refreshCltr!.dispose();
  }

  Future<void> getData({int page = 1}) async {
    if (page == 1 || pageIndex * _pageSize < _totalPage) {
      pageIndex = page;
      final data = await Handler.getRecentCalls(
        page: page,
        pageSize: _pageSize,
      );

      if (page == 1) {
        recentCallList.clear();
      }

      if (data?.data != null) {
        _totalPage = data?.total ?? 0;
        recentCallList.addAll(data!.data!);
      }
    }

    refreshCltr?.loadComplete();
    refreshCltr?.refreshCompleted();
    loading = false;
    notify;
  }
}
