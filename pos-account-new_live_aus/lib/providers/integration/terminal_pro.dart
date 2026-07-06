import 'package:flutter/material.dart';
import 'package:pos_account/ln.dart';
import 'package:pos_account/model/common/res_datum.dart';
import 'package:pos_account/model/home/integration/plat_inte_conn_model.dart';
import 'package:pos_account/providers/cus_val_pro.dart';
import 'package:pos_account/repository/handler.dart';
import 'package:pos_account/repository/if_exception.dart';
import 'package:pos_account/repository/mx/model/pair_res.dart';
import 'package:pos_account/repository/mx/mx_api.dart';
import 'package:pos_account/repository/mx/mx_handler.dart';

import '../../model/common/table_location.dart';

class TerminalPro extends ChangeNotifier {
  void get notify => notifyListeners();

  ///[WINDCAVE]
  final usernameCltr = TextEditingController();
  final keyCltr = TextEditingController();
  final serialCltr = TextEditingController();
  final terminalCltr = TextEditingController();
  int? posNameIndex;
  // bool isDefault = false;
  int? visionPayDeIndex;

  bool buttonLoad = false;

  bool pageLoad = true;

  PlatInteConnById? platInteConnById;

  String updateId = "";

  Future<void> getData({String? platId}) async {
    if (platId == null) return;

    platInteConnById = await Handler.getPlatIntegConnById(platId);

    pageLoad = false;
    notify;
  }

  Future<bool> saveWind({
    BuildContext? diaCtx,
    bool isNew = true,
    bool showToast = true,
    bool checkMxTerminal = false,
    InteEnum inteEnum = InteEnum.Mx,
  }) async {
    platInteConnById?.integrationPlatformConnectionCredentials ??=
        <IntegrationPlatformConnectionCredential>[];

    // if (isDefault &&
    //     platInteConnById?.integrationPlatformConnectionCredentials != null) {
    //   for (final e
    //       in platInteConnById!.integrationPlatformConnectionCredentials!) {
    //     e.isDefault = false;
    //   }
    // }

    String? _posNameId;
    String? _posName;

    if (posDevices != null && posNameIndex != null) {
      _posNameId = posDevices![posNameIndex!].id;
      _posName = posDevices![posNameIndex!].name;
    }

    if (visionPayDeIndex != null) {
      // usernameCltr.text =
      //     USBServiceEFt.usbDevices[visionPayDeIndex!].productName ?? '';
      // keyCltr.text = USBServiceEFt.usbDevices[visionPayDeIndex!].vid.toString();
      // serialCltr.text =
      //     USBServiceEFt.usbDevices[visionPayDeIndex!].pid.toString();
    }

    final _updatedPlatInteConnById =
        PlatInteConnById.fromJson(platInteConnById!.toJson());

    IntegrationPlatformConnectionCredential? _data;

    if ((_updatedPlatInteConnById.integrationPlatformConnectionCredentials
            ?.any((e) => e.id?.toLowerCase() == updateId.toLowerCase()) ??
        false)) {
      _data = _updatedPlatInteConnById.integrationPlatformConnectionCredentials
          ?.firstWhere((e) => e.id?.toLowerCase() == updateId.toLowerCase());

      _data?.integrationPlatformId = platInteConnById?.integrationPlatFormId;
      _data?.customerId = usernameCltr.text;
      _data?.keyOrId = keyCltr.text;
      _data?.serialNumber = inteEnum == InteEnum.Mx ? _mxTid : serialCltr.text;
      _data?.posDeviceId = _posNameId;
      _data?.posNameOrId = _posName;
      _data?.name = terminalCltr.text;
      _data?.secret = _secretKey;
      // _data?.isDefault = isDefault;
      _data?.currency = GlobalCVP.currentStore?.currencyCode;
      _data?.merchantName = platInteConnById?.integrationPlatFormName;
      _data?.merchantType = platInteConnById?.integrationPlatFormName;
    } else if (isNew) {
      _data = IntegrationPlatformConnectionCredential(
        id: "",
        integrationPlatformId: platInteConnById?.integrationPlatFormId,
        customerId: usernameCltr.text,
        keyOrId: keyCltr.text,
        secret: _secretKey,
        serialNumber: inteEnum == InteEnum.Mx ? _mxTid : serialCltr.text,
        posDeviceId: _posNameId,
        posNameOrId: _posName,
        name: terminalCltr.text,
        // isDefault: isDefault,
        currency: GlobalCVP.currentStore?.currencyCode,
        merchantName: platInteConnById?.integrationPlatFormName,
        merchantType: platInteConnById?.integrationPlatFormName,
      );
      _updatedPlatInteConnById.integrationPlatformConnectionCredentials
          ?.add(_data);
    }

    bool? status;

    // log(json.encode(_updatedPlatInteConnById.toJson()));
    // return false;

    buttonLoad = true;
    pageLoad = true;
    notify;

    final _terminalStatus = checkMxTerminal
        ? (_data != null ? await terminalStatusCheck(_data) : false)
        : true;

    if (platInteConnById != null && (_terminalStatus ?? false)) {
      status = await Handler.addUpPlatIntegConn(
        platInteConnById: _updatedPlatInteConnById,
        diaCtx: diaCtx,
        showToast: showToast,
      );
      if (status ?? false) {
        platInteConnById = _updatedPlatInteConnById;
      }
    } else {
      if (!(_terminalStatus ?? false)) {
        IfException.showMessage(
            message: "Pairing not active",
            desc:
                "Check the terminal, confirm that the pairing code matches then try again.",
            msg: Msg.Dialog,
            seconds: 0,
            autoHideSecond: 3,
            popNav: false);
      } else {
        IfException.showMessage(message: LN.somethingWentWrong);
      }
    }
    buttonLoad = false;
    pageLoad = false;
    notify;

    return status ?? false;
  }

  Future<void> windSetup(int i) async {
    if (platInteConnById?.integrationPlatformConnectionCredentials == null)
      return;

    final _data =
        platInteConnById?.integrationPlatformConnectionCredentials?[i];
    if (_data != null) {
      updateId = _data.id ?? '';
      usernameCltr.text = _data.customerId ?? '';
      keyCltr.text = _data.keyOrId ?? '';
      if (platInteConnById?.integrationPlatFormName != InteEnum.Mx.name) {
        serialCltr.text = _data.serialNumber ?? '';
        _mxTid = _data.serialNumber ?? '';
        _secretKey = _data.secret ?? '';
      }
      terminalCltr.text = _data.name ?? '';

      if (posDevices?.any(
              (e) => e.id?.toLowerCase() == _data.posDeviceId?.toLowerCase()) ??
          false) {
        posNameIndex = posDevices!.indexWhere(
            (e) => e.id?.toLowerCase() == _data.posDeviceId?.toLowerCase());
      }

      final pId = int.tryParse(_data.serialNumber ?? '');

      if (platInteConnById?.integrationPlatFormName ==
              InteEnum.VisionPay.name &&
          pId != null) {
        // if (USBServiceEFt.usbDevices.isEmpty) {
        //   await USBServiceEFt.scanDevice();
        // }

        // if (USBServiceEFt.usbDevices.any((e) => e.pid == pId)) {
        //   visionPayDeIndex =
        //       USBServiceEFt.usbDevices.indexWhere((e) => e.pid == pId);
        // }
      }

      // isDefault = _data.isDefault ?? false;
    }
  }

  void clearWind({String? id}) {
    usernameCltr.clear();
    keyCltr.clear();
    serialCltr.clear();
    terminalCltr.clear();
    posNameIndex = null;
    visionPayDeIndex = null;
    buttonLoad = false;
    updateId = "";
    if (id != null) {
      // pageLoad = true;
      platInteConnById = null;
    }

    // isDefault = false;
    _secretKey = "";
    _mxTid = "";
  }

  Future<bool> deleteTerminal(int i) async {
    if (platInteConnById?.integrationPlatformConnectionCredentials == null)
      return false;

    final data = platInteConnById?.integrationPlatformConnectionCredentials?[i];

    pageLoad = true;
    notify;

    final status = await Handler.deleteIntegPlat(
        data: SRDatum(
      id: data?.id,
      name: data?.customerId,
    ));

    pageLoad = false;
    notify;

    return status ?? false;
  }

  List<TableLocation>? posDevices;

  void setPosDevices(List<TableLocation>? _devices) {
    posDevices = _devices;
  }

  String _secretKey = "";
  String _mxTid = "";

  //MX
  Future<MxPairResponse?> pairMx() async {
    buttonLoad = true;
    pageLoad = true;
    notify;

    final _isKiosk = isKioskDevice;

    final _res = await MxHandler.pair(
      nickName: terminalCltr.text,
      code: serialCltr.text,
      isKiosk: _isKiosk,
    );

    // if (_res != null) DbLocalData.setMxPairData(data: _res.toJson());

    keyCltr.text = _res?.data?.keyId ?? '';
    _secretKey =
        "${_isKiosk ? MxApi.kioskSecretKeyA : MxApi.posSecretKeyA}${_res?.data?.signingSecretPartB ?? ''}";
    usernameCltr.text = _res?.data?.sciApiBaseUrl ?? '';
    _mxTid = _res?.data?.tid ?? '';

    buttonLoad = false;
    pageLoad = false;
    notify;

    return _res;
  }

  bool terminalStausChecking = false;

  Future<bool> pairingInfoCheck() async {
    if (platInteConnById?.integrationPlatformConnectionCredentials == null)
      return false;

    pageLoad = true;
    terminalStausChecking = true;
    notify;
    bool _isChangeStatus = false;

    for (int i = 0;
        i < platInteConnById!.integrationPlatformConnectionCredentials!.length;
        i++) {
      final _data =
          platInteConnById!.integrationPlatformConnectionCredentials![i];
      if (_data.customerId?.isNotEmpty ?? false) {
        final _status = await terminalStatusCheck(_data);
        if (_status == false) {
          windSetup(i);
          _secretKey = "";
          _mxTid = "";
          keyCltr.clear();
          usernameCltr.clear();
          serialCltr.clear();
          _isChangeStatus = await saveWind(showToast: false);
        }
      }
    }

    terminalStausChecking = false;
    pageLoad = false;
    notify;

    return _isChangeStatus;
  }

  Future<bool?> terminalStatusCheck(
      IntegrationPlatformConnectionCredential _data) async {
    MxHandler.setMerchant(
      sciApiBaseUrl: _data.customerId,
      keyId: _data.keyOrId,
      signingSecret: _data.secret,
    );

    final _status = await MxHandler.pairingInfo();
    if (_status == MXDeviceStatus.pair)
      return true;
    else if (_status == MXDeviceStatus.unpair)
      return false;
    else
      return null;
  }

  Future<bool> unPairMx(int i) async {
    pageLoad = true;
    notify;

    if (platInteConnById?.integrationPlatformConnectionCredentials == null)
      return false;

    final _data =
        platInteConnById?.integrationPlatformConnectionCredentials?[i];

    MxHandler.setMerchant(
      sciApiBaseUrl: _data?.customerId,
      keyId: _data?.keyOrId,
      signingSecret: _data?.secret,
    );

    final _status = await MxHandler.unPair();

    if (_status) {
      windSetup(i);
      _secretKey = "";
      _mxTid = "";
      keyCltr.clear();
      usernameCltr.clear();
      serialCltr.clear();
      await saveWind();
    }

    pageLoad = false;
    notify;

    return _status;
  }

  bool get isKioskDevice =>
      posDevices != null &&
      posNameIndex != null &&
      (posDevices?[posNameIndex!]
              .additionalValue
              ?.toString()
              .toLowerCase()
              .contains('kios') ??
          false);

  // mx merchant setup
  // final mxApiKeyCltr = TextEditingController();
  // final mxScretCltr = TextEditingController();

  // PaymentCredentials? _mxCredentials;
  // bool showMxApi = false;
  // bool showMxSecret = false;

  // Future<void> getMxMerchantCred() async {
  //   _mxCredentials = await Handler.getMxMerchantCred();
  //   mxApiKeyCltr.text = _mxCredentials?.keyOrId?.text ?? '';
  //   mxScretCltr.text = _mxCredentials?.secret?.text ?? '';

  //   pageLoad = false;
  //   notify;
  // }

  // Future<void> updateMxMerchantCred(
  //     Function(bool, PaymentCredentials? data) onPop) async {
  //   pageLoad = true;
  //   buttonLoad = true;
  //   notify;

  //   _mxCredentials?.keyOrId?.text = mxApiKeyCltr.text;
  //   _mxCredentials?.secret?.text = mxScretCltr.text;

  //   await Handler.updateMxCred(
  //       data: _mxCredentials, onPop: (val) => onPop(val, _mxCredentials));

  //   pageLoad = false;
  //   buttonLoad = false;
  //   notify;
  // }

  // void mxMerchatClear() {
  //   _mxCredentials = null;
  //   pageLoad = true;
  //   buttonLoad = false;
  //   showMxApi = false;
  //   showMxSecret = false;
  //   mxApiKeyCltr.clear();
  //   mxScretCltr.clear();
  // }
}

// windcave: 7, mx 5, uber: UberDelivery, , xero : Xero, vision pay: 6
enum InteEnum { WindCave, Mx, UberDelivery, Xero, VisionPay }
