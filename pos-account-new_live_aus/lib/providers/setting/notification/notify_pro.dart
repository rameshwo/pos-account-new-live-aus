import 'package:flutter/material.dart';
import 'package:pos_account/model/home/setting/notification/email_setup_res.dart';
import 'package:pos_account/model/home/setting/notification/notification_type.dart';
import 'package:pos_account/model/home/setting/notification/sms_setup_res.dart';
import 'package:pos_account/repository/handler.dart';

class NotifyPro extends ChangeNotifier {
  void get notify => notifyListeners();

  NotificationType? notificationType;
  bool generalLoad = true;

  Future<void> getData() async {
    notificationType = await Handler.getNotifyType(page: 1);
    generalLoad = false;
    notify;
  }

  Future<void> addUpdate({required NotifyData notifyData}) async {
    await Handler.addUpNotifyType(notifyData: [notifyData]);
  }

  void generalClear() {
    notificationType = null;
    generalLoad = true;
  }

  //////////////

  int pageIndex = 1;
  final int _pageSize = 10;
  int _totalPage = 0;

  // email setting //

  void emailClear() {
    emailLoading = true;
    emailList.clear();

    pageIndex = 1;
    _totalPage = 0;
    emailSearchCltr.clear();
    emailUpdateLoad = false;
  }

  bool emailLoading = true;

  final emailSearchCltr = TextEditingController();

  final emailList = <EmailSetupData>[];

  Future<void> getAllEmails({int page = 1}) async {
    if (page == 1 || pageIndex * _pageSize < _totalPage) {
      pageIndex = page;
      final res = await Handler.getAllEmailSetting(
        page: page,
        pageSize: _pageSize,
        searchKey: emailSearchCltr.text,
      );
      if (page == 1) {
        emailList.clear();
      }
      if (res?.data != null) {
        _totalPage = res?.total ?? 0;
        emailList.addAll(res!.data!);
      }

      if (emailList.isEmpty) {
        emailList.add(EmailSetupData(
          id: "",
          mailServer: TextEditingController(),
          senderName: TextEditingController(),
          email: TextEditingController(),
          password: TextEditingController(),
          port: TextEditingController(),
          isActive: true,
          enableTls: true,
          enableSSlOnCOnnect: true,
        ));
      }
    }
    emailLoading = false;
    notify;
  }

  bool emailUpdateLoad = false;

  Future<void> updateEmail() async {
    emailLoading = true;
    emailUpdateLoad = true;
    notify;
    await Handler.createUpEmailSettings(setupReqList: emailList);
    emailLoading = false;
    emailUpdateLoad = false;
    notify;
  }

  // sms settings //

  void smsClear() {
    smsLoading = true;
    smsList.clear();
    pageIndex = 1;
    _totalPage = 0;
    smsSearchCltr.clear();
    smsUpdateLoad = false;
  }

  bool smsLoading = true;
  final smsSearchCltr = TextEditingController();

  final smsList = <SmsSetupData>[];

  Future<void> getSmsData({int page = 1}) async {
    if (page == 1 || pageIndex * _pageSize < _totalPage) {
      pageIndex = page;
      final res = await Handler.getAllSmsSetting(
        page: page,
        pageSize: _pageSize,
        searchKey: smsSearchCltr.text,
      );
      if (page == 1) {
        smsList.clear();
      }
      if (res?.data != null) {
        _totalPage = res?.total ?? 0;
        smsList.addAll(res!.data!);
      }
      if (smsList.isEmpty) {
        smsList.add(SmsSetupData(
          id: "",
          clientId: TextEditingController(),
          clientSecret: TextEditingController(),
          fromNumber: TextEditingController(),
          isActive: true,
        ));
      }
    }
    smsLoading = false;
    notify;
  }

  bool smsUpdateLoad = false;

  Future<void> updateSms() async {
    if (smsList.isEmpty) return;

    smsLoading = true;
    smsUpdateLoad = true;
    notify;
    await Handler.createUpSmsSettings(reqData: smsList.first);
    smsLoading = false;
    smsUpdateLoad = false;
    notify;
  }
}
