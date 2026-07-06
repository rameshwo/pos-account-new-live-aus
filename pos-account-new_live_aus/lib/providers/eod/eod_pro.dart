import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pos_account/config/utils/utils.dart';
import 'package:pos_account/config/validator.dart';
import 'package:pos_account/constant/strings.dart';
import 'package:pos_account/ln.dart';
import 'package:pos_account/model/home/eod/all_eod_data.dart';
import 'package:pos_account/model/home/eod/eod_add_sec.dart';
import 'package:pos_account/model/home/eod/eod_report.dart';
import 'package:pos_account/model/home/eod/finalize_eod_req.dart';
import 'package:pos_account/repository/handler.dart';
import 'package:pos_account/services/database/shared_pref.dart';

class EodPro extends ChangeNotifier {
  void get notify => notifyListeners();

  /// FINALIZE EOD

  bool screenLoad = true;

  int pageIndex = 1;

  String? curSym;
  String? dateFormat;
  final dateCltr = TextEditingController();

  void clear() {
    screenLoad = true;
    allEodData = null;
    dateCltr.clear();
    keyValList.clear();
    platformIndex = 0;
    taxTypeIndex = null;
  }

  Future<void> getDateFor() async {
    curSym = await SharedPrefs.curSym;
    dateFormat = await SharedPrefs.dateFormat;

    dateCltr.text = DateFormat(dateFormat).format(DateTime.now());
    notify;
    // dateCltr.text = DateFormat(dateFormat).format(DateTime.now());
  }

  EodAddSec? eodAddSec;
  int? platformIndex = 0;
  int? taxTypeIndex = 0;

  Future<void> getAddSec() async {
    eodAddSec = await Handler.allEodSecList();
    if (eodAddSec?.taxExclusiveInclusives != null &&
        eodAddSec!.taxExclusiveInclusives!.isNotEmpty) {
      if (eodAddSec!.taxExclusiveInclusives!
          .any((e) => e.isSelected ?? false)) {
        taxTypeIndex = eodAddSec!.taxExclusiveInclusives!
            .indexWhere((e) => e.isSelected ?? false);
      }
    }
    notify;
  }

  AllEodData? allEodData;
  final keyValList = <KeyValue>[];

  Future<void> getData({int page = 1}) async {
    pageIndex = page;
    String? platformId = "";
    String? taxtTypeId = "";
    if (eodAddSec?.accountingPlatforms != null &&
        eodAddSec!.accountingPlatforms!.isNotEmpty) {
      platformId = eodAddSec!.accountingPlatforms![platformIndex!].id;
    }

    if (eodAddSec?.taxExclusiveInclusives != null &&
        eodAddSec!.taxExclusiveInclusives!.isNotEmpty) {
      taxtTypeId = eodAddSec!.taxExclusiveInclusives![taxTypeIndex!].id;
    }

    allEodData = await Handler.allEodFinalized(
      date: dateCltr.text,
      page: page,
      platId: platformId,
      taxTypeId: taxtTypeId,
    );
    setData();
    screenLoad = false;
    // calculateLoad = false;
    notify;
  }

  void setData() {
    keyValList.clear();

    if (allEodData?.eodSaleReconcilation != null &&
        allEodData!.eodSaleReconcilation!
            .toJson()
            .entries
            .toList()
            .isNotEmpty) {
      final _entries = allEodData!.eodSaleReconcilation!.toJson().entries;
      for (final e in _entries) {
        if (e.value != null) {
          keyValList.add(KeyValue(
              key: Utils.formatCamelCaseKey(e.key), value: e.value ?? ''));
        }
      }
    }

    if (allEodData?.eodChartOfAccountPayment != null)
      for (var e in allEodData!.eodChartOfAccountPayment!) {
        e.readOnly = e.chartOfAccountNameEnum != null &&
                (e.chartOfAccountNameEnum?.toLowerCase() == Strings.cash ||
                    e.chartOfAccountNameEnum?.toLowerCase() == Strings.float)
            ? false
            : true;

        e.textCltr = TextEditingController(
          text: e.readOnly
              ? e.formattedAmount?.replaceFirst('-', '')
              : e.amount?.replaceFirst('-', ''),
        );
      }
    setEodResult(null);
  }

  //Eod Result

  void setEodResult(String? name) {
    if (allEodData?.eodChartOfAccountPayment == null ||
        allEodData!.eodChartOfAccountPayment!.isEmpty) return;
    double variance = 0;
    double total = 0;

    for (var e in allEodData!.eodChartOfAccountPayment!) {
      final amount = (double.tryParse(e.amount ?? '0.00') ?? 0.00);
      if (e.chartOfAccountNameEnum?.toLowerCase() != Strings.variance &&
          e.chartOfAccountNameEnum != null) {
        variance += amount;
        total += amount;
      }

      if (name != e.name) {
        e.textCltr?.text = amount.roundToNString().replaceFirst('-', '');
      }
    }

    variance = variance * -1;

    total += variance;

    if (allEodData!.eodChartOfAccountPayment!.any(
        (e) => e.chartOfAccountNameEnum?.toLowerCase() == Strings.variance)) {
      final varAmount = allEodData!.eodChartOfAccountPayment!.firstWhere(
          (e) => e.chartOfAccountNameEnum?.toLowerCase() == Strings.variance);
      varAmount.amount = variance.roundToNString();
      varAmount.textCltr!.text =
          variance.roundToNString().replaceFirst('-', '');
    }

    if (allEodData!.eodChartOfAccountPayment!
        .any((e) => e.chartOfAccountNameEnum == null)) {
      final _totalAmount = allEodData!.eodChartOfAccountPayment!
          .firstWhere((e) => e.chartOfAccountNameEnum == null);
      _totalAmount.amount = total.roundToNString();
      _totalAmount.textCltr!.text =
          total.roundToNString().replaceFirst('-', '');
    }

    notify;
  }

  // finalize EOD

  final emailList = <String>[];
  final subCltr = TextEditingController();
  final messageCltr = TextEditingController();
  // bool isCheckedSendEmail = false;
  FinalizeAction? finalizeAction;
  bool loadFinalizeButton = false;
  Color toBorderColor = Colors.black12;

  Future<void> finalizeEod() async {
    final reqData = FinalizeEodReq();

    reqData.date = dateCltr.text;
    if (eodAddSec?.taxExclusiveInclusives != null &&
        eodAddSec!.taxExclusiveInclusives!.isNotEmpty) {
      reqData.taxExclusiveInclusiveId =
          eodAddSec!.taxExclusiveInclusives![taxTypeIndex!].id;
    }

    if (eodAddSec?.accountingPlatforms != null &&
        eodAddSec!.accountingPlatforms!.isNotEmpty) {
      reqData.accountingPlatformId =
          eodAddSec!.accountingPlatforms![platformIndex!].id;
    }
    reqData.eodChartOfAccountPayments =
        allEodData!.eodChartOfAccountPayment; // []
    // if (allEodData?.eodChartOfAccountPayment != null) {
    //   for (int i = 0; i < allEodData!.eodChartOfAccountPayment!.length; i++) {
    //     _reqData.eodChartOfAccountPayments!
    //         .add(allEodData!.eodChartOfAccountPayment![i]);
    //     _reqData.eodChartOfAccountPayments![i].sortOrder = i;
    //   }
    // }
    reqData.emailModel = EmailModel(
      to: emailList,
      message: messageCltr.text,
      subject: subCltr.text,
    );

    reqData.isSendMail = finalizeAction == FinalizeAction.SendEmail;
    reqData.isFinalize = finalizeAction == FinalizeAction.Finalize;
    reqData.isSendMailAndFinalize = finalizeAction == FinalizeAction.Both;

    loadFinalizeButton = true;
    notify;

    final status = await Handler.finalizeEod(reqData: reqData);

    if (status ?? false) {
      clearFinalizeDia();
    }

    loadFinalizeButton = false;
    notify;
  }

  void clearFinalizeDia() {
    subCltr.text = '${LN.eodOnDate} ${dateCltr.text}';
    messageCltr.text = '${LN.findEodReport} ${dateCltr.text}';
    finalizeAction = null;
    loadFinalizeButton = false;
    toBorderColor = Colors.black12;
    emailList.clear();
  }

  EodReportRes? eodReportRes;

  Future<void> printEod() async {
    String? taxTypeId = "";
    if (eodAddSec?.taxExclusiveInclusives != null &&
        eodAddSec!.taxExclusiveInclusives!.isNotEmpty) {
      taxTypeId = eodAddSec!.taxExclusiveInclusives![taxTypeIndex!].id;
    }
    screenLoad = true;
    notify;
    eodReportRes =
        await Handler.printEod(date: dateCltr.text, taxTypeId: taxTypeId);

    screenLoad = false;
    notify;
  }

  bool eodPreviewLoad = false;
}

class KeyValue {
  final String key;
  final String value;

  KeyValue({required this.key, required this.value});
}

enum FinalizeAction { SendEmail, Finalize, Both }
