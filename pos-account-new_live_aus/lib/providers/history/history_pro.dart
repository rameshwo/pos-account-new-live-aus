import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pos_account/ln.dart';
import 'package:pos_account/model/home/history/history_report.dart';
import 'package:pos_account/model/home/history/report_add_sec.dart';
import 'package:pos_account/model/home/setting/general/category/restro_table_model.dart';
import 'package:pos_account/repository/handler.dart';
import 'package:pos_account/services/database/shared_pref.dart';

class HistoryPro extends ChangeNotifier {
  bool loading = true;

  ReportAddSec? reportAddSec;

  final startEndDateCltr = TextEditingController();
  String? dateOnlyFormat;

  int? payMethodIndex = 0;
  int? storeChannelIndex = 0;

  bool searchLoad = false;

  int pagiPage = 1;
  int pageSize = 5;

  HistoryReport? report;
  String? curSym;

  // clear all data
  void clear() {
    report = null;
    tableList.tableDataList = [];
    notify;
  }

  Future<void> getData() async {
    final dateFormat = await SharedPrefs.dateFormat;
    curSym = await SharedPrefs.curSym;
    dateOnlyFormat = dateFormat.split(' ').first;

    reportAddSec = await Handler.getReportAddSec();
    setData();
    loading = false;
    notify;
  }

  setData() {
    startEndDateCltr.text =
        "${DateFormat(dateOnlyFormat).format(DateTime.now().subtract(Duration(days: 30)))} - ${DateFormat(dateOnlyFormat).format(DateTime.now())}";
  }

  Future<void> searchHistory({int page = 1}) async {
    if (reportAddSec == null) return;
    pagiPage = page;
    String paymentMethodId = "";
    String channelId = "";

    if (reportAddSec!.paymentMethodStore != null && payMethodIndex != null) {
      paymentMethodId =
          reportAddSec!.paymentMethodStore![payMethodIndex!].id ?? '';
    }

    if (reportAddSec!.storeChannelId != null && storeChannelIndex != null) {
      channelId = reportAddSec!.storeChannelId![storeChannelIndex!].id ?? '';
    }

    searchLoad = true;
    notify;

    report = await Handler.historyReport(
      paymentMethodId: paymentMethodId,
      fromDate: startEndDateCltr.text.split(" - ").first,
      toDate: startEndDateCltr.text.split(" - ").last,
      channelId: channelId,
      page: page,
      pageSize: pageSize,
    );
    tableList.tableDataList = [];
    if (report?.data != null) {
      for (final e in report!.data!) {
        tableList.tableDataList.add(TableDataList(
          id: e.receiptNumber ?? '',
          itemList: [
            e.date ?? '',
            e.receiptNumber ?? '',
            e.paymentMethod ?? '',
            (e.salesAmount == null || e.salesAmount == '0.00'
                    ? ''
                    : (curSym ?? '')) +
                (e.salesAmount ?? ''),
            (e.taxAmount == null || e.taxAmount == '0.00'
                    ? ''
                    : (curSym ?? '')) +
                (e.taxAmount ?? ''),
            (e.discountAmount == null || e.discountAmount == '0.00'
                    ? ''
                    : (curSym ?? '')) +
                (e.discountAmount ?? ''),
            (e.tipAmount == null || e.tipAmount == '0.00'
                    ? ''
                    : (curSym ?? '')) +
                (e.tipAmount ?? ''),
            (e.holidayChargeAmount == null || e.holidayChargeAmount == '0.00'
                    ? ''
                    : (curSym ?? '')) +
                (e.holidayChargeAmount ?? ''),
            (e.creditCardSurchargeAmount == null ||
                        e.creditCardSurchargeAmount == '0.00'
                    ? ''
                    : (curSym ?? '')) +
                (e.creditCardSurchargeAmount ?? ''),
          ],
          statusList: [],
        ));
      }
    }

    searchLoad = false;
    loading = false;
    notify;
  }

  //data table integration

  final tableList = RTableData(
    headerList: [
      LN.date,
      '${LN.receiptNo}.',
      LN.paymentMethod,
      LN.salesAmount,
      LN.taxAmount,
      LN.discountAmt,
      LN.tipAmount,
      LN.holidayChargeAmt,
      LN.creditSurchargeAmt,
    ],
    hasAction: false,
    showCheckBox: false,
  );

  void get notify => notifyListeners();
}
