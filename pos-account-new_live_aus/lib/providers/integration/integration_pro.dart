import 'package:flutter/material.dart';
import 'package:pos_account/model/home/integration/acc_contact_setting.dart';
import 'package:pos_account/model/home/integration/acc_integ_add_sec.dart';
import 'package:pos_account/model/home/integration/chart_acc_model.dart';
import 'package:pos_account/model/home/integration/plat_inte_conn_model.dart';
import 'package:pos_account/repository/handler.dart';
import 'terminal_pro.dart';

class IntegrationPro extends ChangeNotifier {
  void get notify => notifyListeners();

  bool loading = true;

  // connect xero

  // int pageIndex = 0;
  int selectedTab = 0;

  final cusIdCltr = TextEditingController();

  final cIdCltr = TextEditingController();
  final cSecretCltr = TextEditingController();

  // final serialCltr = TextEditingController();
  // final posNameCltr = TextEditingController();

  // AccIntegAddSec? addSec;
  final firstInteList = <AccountingPlatForm>[];
  final secondInteList = <AccountingPlatForm>[];

  AccountingPlatForm? selectedAccount;

  Future<AccIntegAddSec?> getAddSec() async {
    firstInteList.clear();
    secondInteList.clear();
    final addSec = await Handler.getAcIntegSec();
    if (addSec?.accountingPlatForms != null) {
      for (final e in addSec!.accountingPlatForms!) {
        final enumm = e.integrationPlatformEnum;
        if (enumm != null) {
          if (enumm == InteEnum.WindCave.name ||
              enumm == InteEnum.Mx.name ||
              enumm == InteEnum.VisionPay.name) {
            secondInteList.add(e);
          } else {
            firstInteList.add(e);
          }
        }
      }
    }
    // _tempAddUberData();
    loading = false;
    notify;

    return addSec;
  }

// uber TODO
  // void _tempAddUberData() {
  //   addSec?.accountingPlatForms?.add(AccountingPlatForm(
  //       id: "#uber_test_id",
  //       name: "Uber Delivery",
  //       image: "assets/png/uber_delivery.png",
  //       description: "Uber courier for pickup and deliveries"));
  // }

  PlatInteConnById? platInteConnById;
  bool accountLoad = false;

  Future<void> getAcPlatIntegConn() async {
    if (selectedAccount == null) return;
    accountLoad = true;
    notify;

    final String? platId = selectedAccount?.id;
    if (platId != null) {
      platInteConnById = await Handler.getPlatIntegConnById(platId);
      if (platInteConnById
              ?.integrationPlatformConnectionCredentials?.isNotEmpty ??
          false) {
        cusIdCltr.text = platInteConnById
                ?.integrationPlatformConnectionCredentials?.first.customerId ??
            '';
        cIdCltr.text = platInteConnById
                ?.integrationPlatformConnectionCredentials?.first.keyOrId ??
            '';
        cSecretCltr.text = platInteConnById
                ?.integrationPlatformConnectionCredentials?.first.secret ??
            '';
        // serialCltr.text = platInteConnById
        //         ?.integrationPlatformConnectionCredentials
        //         ?.first
        //         .serialNumber ??
        //     '';
        // posNameCltr.text = platInteConnById
        //         ?.integrationPlatformConnectionCredentials?.first.posNameOrId ??
        //     '';
      }
    }

    accountLoad = false;
    notify;
  }

  bool updateLoad = false;

  Future<void> updateConnect() async {
    updateLoad = true;
    notify;

    platInteConnById?.integrationPlatFormName =
        platInteConnById?.integrationPlatFormName;
    platInteConnById?.integrationPlatformConnectionCredentials ??=
        <IntegrationPlatformConnectionCredential>[];

    if (platInteConnById
            ?.integrationPlatformConnectionCredentials?.isNotEmpty ??
        false) {
      platInteConnById?.integrationPlatformConnectionCredentials?.first
          .customerId = cusIdCltr.text;
      platInteConnById?.integrationPlatformConnectionCredentials?.first
          .keyOrId = cIdCltr.text;
      platInteConnById?.integrationPlatformConnectionCredentials?.first.secret =
          cSecretCltr.text;

      // platInteConnById?.integrationPlatformConnectionCredentials?.first
      //     .serialNumber = serialCltr.text;
      // platInteConnById?.integrationPlatformConnectionCredentials?.first
      //     .posNameOrId = posNameCltr.text;
    } else {
      platInteConnById?.integrationPlatformConnectionCredentials
          ?.add(IntegrationPlatformConnectionCredential(
        id: "",
        customerId: cusIdCltr.text,
        keyOrId: cIdCltr.text,
        secret: cSecretCltr.text,
        // serialNumber: serialCltr.text,
        // posNameOrId: posNameCltr.text,
      ));
    }
    await Handler.addUpPlatIntegConn(platInteConnById: platInteConnById!);
    updateLoad = false;
    notify;
  }

  // chart of account mapping

  bool chartLoad = false;
  List<ChartOfAccModel>? charAccMapping;
  final chartNameTextCltrList = <TextEditingController>[];
  final chartCodeTextCltrList = <TextEditingController>[];

  Future<void> getChartOfAccInte() async {
    if (selectedAccount == null) return;
    chartLoad = true;
    notify;

    final String? platId = selectedAccount?.id;
    if (platId != null) {
      charAccMapping = await Handler.getChartOfAccInteById(platId);
    }
    chartLoad = false;
    notify;
  }

  Future<void> updateAccMapping() async {
    if (charAccMapping == null) return;
    updateLoad = true;
    notify;

    await Handler.addUpChartOfAcMap(
      accMap: charAccMapping!,
    );

    updateLoad = false;
    notify;
  }

  // contact section
  bool contactLoad = true;
  AccContactSetting? accContactSetting;

  Future<void> getAccContactSetting() async {
    if (selectedAccount?.id == null) return;
    contactLoad = true;
    notify;
    accContactSetting =
        await Handler.getAccContactSetting(id: selectedAccount?.id ?? '');
    contactLoad = false;
    notify;
  }

  bool contactBtnLoad = false;

  Future<void> createUpAccContactSetting() async {
    contactBtnLoad = true;
    notify;
    await Handler.createUpAccContactSetting(
        accContactSetting: accContactSetting);
    contactBtnLoad = false;
    notify;
  }

  void clear() {
    loading = true;
    // pageIndex = 0;
    selectedTab = 0;
    cusIdCltr.clear();
    cIdCltr.clear();
    cSecretCltr.clear();
    // addSec = null;
    firstInteList.clear();
    secondInteList.clear();
    selectedAccount = null;
    platInteConnById = null;
    accountLoad = false;
    updateLoad = false;
    chartLoad = false;
    charAccMapping = null;
    chartNameTextCltrList.clear();
    chartCodeTextCltrList.clear();
    contactLoad = true;
    accContactSetting = null;
    contactBtnLoad = false;
  }

  //MX
  // bool get isMxMerchantSetup =>
  //     MxApi.apiKey.isNotEmpty && MxApi.secretKeyA.isNotEmpty;
}
