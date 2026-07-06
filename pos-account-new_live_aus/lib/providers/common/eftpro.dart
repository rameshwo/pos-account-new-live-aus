import 'dart:async';
// import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:pos_account/config/utils/internet_utils.dart';
import 'package:pos_account/config/utils/utils.dart';
import 'package:pos_account/config/validator.dart';
import 'package:pos_account/ln.dart';
import 'package:pos_account/model/home/integration/plat_inte_conn_model.dart';
import 'package:pos_account/model/home/menu/payment/eftpos/merchant_log.dart';
import 'package:pos_account/model/home/menu/payment/make_pay_res.dart';
import 'package:pos_account/model/home/menu/place_order/po_pay_sec_list_res.dart';
import 'package:pos_account/providers/cus_val_pro.dart';
import 'package:pos_account/providers/menu/payment_pro.dart';
import 'package:pos_account/repository/handler.dart';
import 'package:pos_account/repository/mx/model/mx_pay_data.dart';
import 'package:pos_account/repository/mx/model/trans_req.dart';
import 'package:pos_account/repository/mx/model/trans_res.dart';
import 'package:pos_account/repository/mx/mx_handler.dart';
import 'package:pos_account/repository/windcave/model/button_req.dart';
import 'package:pos_account/repository/windcave/model/button_res.dart';
import 'package:pos_account/repository/windcave/model/receipt_req.dart';
import 'package:pos_account/repository/windcave/model/receipt_res.dart';
import 'package:pos_account/repository/windcave/model/tran_req.dart';
import 'package:pos_account/repository/windcave/model/tran_res.dart';
import 'package:pos_account/repository/windcave/windcave_handler.dart';
import 'package:pos_account/screens/home_screen/com/items/sidebar/order_section/com/pay_method/com/choose_eft_pay_dia.dart';
import 'package:pos_account/services/database/database/db_local_data.dart';
import 'package:pos_account/services/database/shared_pref.dart';
import 'package:pos_account/services/printer/com/merchant_print.dart';
import 'package:pos_account/services/printer/com/signature_print.dart';
import 'package:provider/provider.dart';

import '../../model/home/product/gen_barcode/invoice_printer_detail.dart';

class EftPro extends ChangeNotifier {
  void get notify => notifyListeners();

  // String payUrl = AppEnviro.eftposPay;

  // String? orderId;
  bool isOnPayScreen = false;

  // EFTReturnValue? eftReturnValue;

  // bool eftPayInit_Mx51 = false;

  bool showEftPay_Mx51 = false;
  // bool runEftPay_Mx51 = true;

  // InAppWebViewController? webCltr;

  // void loadUrl(String url) {
  //   if (webCltr != null && url.isNotEmpty)
  //     webCltr!.loadUrl(urlRequest: URLRequest(url: Uri.parse(url)));
  // }

  void onPayClicked({
    required String eftMerchantType,
    String? serialNo,
    String? refId,
    String? terminalId,
  }) {
    final _ctx = CUS_CTX;
    if (_ctx == null || !_ctx.mounted) return;

    final _payPro = Provider.of<PaymentPro>(_ctx, listen: false);
    final _data = _payPro.getPaymentRequest;
    _data?.eftPosMerchantType = eftMerchantType;
    _data?.eftposSerialNumber = serialNo;
    _data?.integrationPlatformTerminalId = terminalId;

    if (refId != null) _data?.transactionRefId = refId;

    DbLocalData.updatePaymentRequestData(data: _data);
  }

  void onRefundClicked({
    required String eftMerchantType,
    String? serialNo,
    String? refId,
    String? terminalId,
  }) {
    final _ctx = CUS_CTX;
    if (_ctx == null || !_ctx.mounted) return;

    final _payPro = Provider.of<PaymentPro>(_ctx, listen: false);
    final _data = _payPro.getRefundRequest;
    _data?.eftPosMerchantType = eftMerchantType;
    _data?.eftposSerialNumber = serialNo;
    _data?.integrationPlatformTerminalId = terminalId;

    if (refId != null) _data?.transactionRefId = refId;

    DbLocalData.updateRefundRequestData(data: _data);
  }

  void removePayReqData(String path) {
    // kPrint('remove pay request ---------------------$path');
    if (GlobalCVP.eftPosEnable) DbLocalData.updatePaymentRequestData();
  }

  void removeRefundReqData() {
    // log('remove refund request ---------------------');
    if (GlobalCVP.eftPosEnable) DbLocalData.updateRefundRequestData();
  }

  // Future<void> get waitForCondition async {
  //   while (showEftPay_Mx51) {
  //     await Future.delayed(Duration(seconds: 1));
  //   }
  // }

  bool pageLoad = false;

  bool payloading = false;
  bool visionPayDiaOn = false;

  void payClear() {
    pageLoad = false;
    payloading = false;
    // linkyTranRes = null;
    visionPayDiaOn = false;
  }

  /// [VisionPay]

  // Future<VisionPayTransactionMessage?> visionPay(
  //     {required double amount,
  //     VisionPayType type = VisionPayType.Purchase}) async {
  //   payloading = true;
  //   notify;

  //   final res = await VisionPayEFT.processPayment(amount: amount, type: type);

  // payloading = false;
  // notify;

  //   return res;
  // }

  // Future<bool?> cancelTransaction({
  //   required double amount,
  // }) async {
  //   return await VisionPayEFT.cancelTransaction(amount: amount);
  // }

  ///[WINDCAVE]

  bool buttonLoad = false;

  void windcaveEftClear() {
    pageLoad = false;
    payloading = false;
    buttonLoad = false;
    windTranRes = null;
    wcButtonRes = null;
    isPaymentStart = false;
    windcavePayDiaOn = false;
    cancelForceTranButtonTimer();
    InternetUtils.getInterNetStatus.then((value) {
      if (value) {
        setWindCaveReq();
        removePayReqData('windcaveEftClear');
        removeRefundReqData();
      }
    });
  }

  bool isPaymentStart = false;

  WcTransactionRes? windTranRes;

  Future<WcTransactionRes?> windpay({
    WcTransactionReq? windRequest,
    bool isStatus = false,
  }) async {
    if (!isStatus) {
      windTranRes = null;
    }
    payloading = true;
    eftPayInit_Windcave = false;
    notify;

    windRequest?.posVersion = await Utils.getVersion();

    final statusReq = WcTransactionReq(
      user: windRequest?.user,
      key: windRequest?.key,
      station: windRequest?.station,
      txnType: TxnType.Status,
      txnRef: windRequest?.txnRef,
    );

    windTranRes = await WindcaveHandler.transaction(
        req: isStatus ? statusReq : windRequest,
        onNoSocket: () {
          eftPayInit_Windcave = true;
          // log("eftPayInit_Windcave : $eftPayInit_Windcave");
          windTranRes = null;
        });

    _startForceTranButtonTimer();

    if (!isPaymentStart) {
      payloading = false;
      windTranRes = null;
      return null;
    }

    if (windTranRes?.complete == "0") {
      notify;
      await Future.delayed(Duration(seconds: 2));
      if (!isPaymentStart) {
        payloading = false;
        windTranRes = null;
        return null;
      }
      return await windpay(windRequest: windRequest, isStatus: true);
    }

    payloading = false;

    notify;

    await Future.delayed(Duration(seconds: 2));

    if (windTranRes?.complete == "1" &&
        windTranRes?.statusId == "6" &&
        (windTranRes?.rcpt?.isNotEmpty ?? false)) {
      if (windTranRes?.result?.rt?.contains("DECLINED") ?? false) {
        return null;
      }

      SharedPrefs.setWindLastTrans = windTranRes?.txnRef ?? '';
      return windTranRes?..station = windRequest?.station;
    } else {
      return null;
    }
  }

  WcButtonRes? wcButtonRes;

  Future<void> clickWindpayButton({
    WcTransactionReq? windRequest,
    B1? bn,
    required String bnName,
  }) async {
    wcButtonRes = null;
    payloading = true;
    notify;

    final req = WcButtonReq(
      user: windRequest?.user,
      key: windRequest?.key,
      station: windRequest?.station,
      txnType: "UI",
      uiType: "Bn",
      name: bnName,
      val: bn?.text,
      txnRef: windRequest?.txnRef,
    );

    wcButtonRes = await WindcaveHandler.clickButton(req: req);
    if (wcButtonRes?.success == "1" && bn?.text == "CANCEL") {
      isPaymentStart = false;
    }

    payloading = false;

    notify;
  }

  // to print last transaction receipt

  WcReceiptRes? wcReceiptRes;
  int dupliReceipt = 0;
  int receiptType = 2;

  Future<bool> getReceipt({
    IntegrationPlatformConnectionCredential? termiData,
  }) async {
    wcReceiptRes = null;
    buttonLoad = true;
    notify;

    final txnRef = await SharedPrefs.getWindLastTran;

    final req = WcReceiptReq(
      user: termiData?.customerId,
      key: termiData?.keyOrId,
      station: termiData?.serialNumber,
      txnRef: txnRef,
      txnType: "Receipt",
      duplicateFlag: dupliReceipt.toString(),
      receiptType: receiptType.toString(),
    );

    wcReceiptRes = await WindcaveHandler.getReceipt(req: req);

    buttonLoad = false;

    notify;

    return wcReceiptRes?.rcpt != null;
  }

  // windcave eft pay no internet case
  bool eftPayInit_Windcave = false;
  bool windcavePayDiaOn = false;

  Future<void> setWindCaveReq({WcTransactionReq? req}) async {
    await DbLocalData.updateWindcaveRequestData(data: req);
  }

  Timer? _timer;
  bool showForceTranButton = false;
  bool isCountDownStart = false;

  void _startForceTranButtonTimer() {
    final _txnStatusId = windTranRes?.txnStatusId?.inDouble.toInt(); //5
    final _statusId = windTranRes?.statusId.inDouble.toInt(); //4

    if (_txnStatusId == 5 &&
        (_statusId == 3 || _statusId == 4) &&
        !isCountDownStart) {
      isCountDownStart = true;

      _timer = Timer(Duration(seconds: 10), () {
        showForceTranButton = true;
        notify;
      });
    }
  }

  void cancelForceTranButtonTimer() {
    showForceTranButton = false;
    isCountDownStart = false;
    _timer?.cancel();
  }

  // windcave list

  // mx51

  void setMerchant(
    EftposMerchant merchant,
  ) {
    MxHandler.setMerchant(
        sciApiBaseUrl: merchant.customerId,
        keyId: merchant.keyOrId,
        signingSecret: merchant.secret);
  }

  MxTransRes? mxTransRes;

  Future<void> mxPurchase({
    required EftposMerchant merchant,
    required MxPayData payData,
  }) async {
    setMerchant(merchant);

    final _transReq = MxTransReq(
      printMerchantReceipt: false,
      promptCustomerReceipt: false,
      verifySignatureOnTerminal: false,
      posAutoPrintSignatureReceipt: false,
    );

    if (payData.mxPayType == MxPayType.Purchase) {
      _transReq.purchaseDetails = PurchaseDetails(
        purchaseAmount: (payData.totalAmount * 100).formatInt,
        tipAmount: (payData.tipAmount * 100).formatInt,
        surchargeAmount: (payData.surAmount * 100).formatInt,
      );
    } else if (payData.mxPayType == MxPayType.Refund) {
      _transReq.refundDetails = RefundDetails(
        refundAmount: (payData.totalAmount * 100).formatInt,
      );
    }

    isPaymentStart = true;
    payloading = true;
    notify;

    mxTransRes = await MxHandler.transaction(
        transReq: _transReq,
        onNoSocket: () {
          showEftPay_Mx51 = true;
          mxTransRes = null;
        });

    if (mxTransRes != null) {
      setMxReqDb(req: _transReq);

      if (payData.mxPayType == MxPayType.Purchase) {
        onPayClicked(
          eftMerchantType: EftPayMethod.Mx51.name,
          serialNo: merchant.serialNumber,
          refId: mxTransRes?.data?.id,
          terminalId: merchant.id,
        );
      } else if (payData.mxPayType == MxPayType.Refund) {
        onRefundClicked(
          eftMerchantType: EftPayMethod.Mx51.name,
          serialNo: merchant.serialNumber,
          refId: mxTransRes?.data?.id,
          terminalId: merchant.id,
        );
      }
    }

    notify;

    await _checkMxData(payData);

    ///
  }

  bool mxPayTimeOut = false;

  Future<void> _checkMxData(MxPayData payData) async {
    DateTime _startTime = DateTime.now();
    mxPayTimeOut = false;
    String _tranMessage = "";

    while (mxTransRes?.data?.status?.isPending ?? false) {
      if (_tranMessage.isNotEmpty &&
          _tranMessage != mxTransRes?.data?.message) {
        _startTime = DateTime.now();
      }

      _tranMessage = mxTransRes?.data?.message ?? '';

      // Check timeout (1 minute)
      final _elapsed = DateTime.now().difference(_startTime);
      if (_elapsed.inSeconds >= 30) {
        mxPayTimeOut = true;
        notify;
        // kPrint('⏱️ MX data check timed out after 1 minute.');
        break;
      }

      if (mxTransRes?.data?.status?.isPending ?? false)
        await Future.delayed(Duration(seconds: 2));

      if ((mxTransRes?.data?.message.isCancelled ?? false) ||
          (mxTransRes?.data?.message.isDeclined ?? false) ||
          (mxTransRes?.data?.message.isBusy ?? false) ||
          (mxTransRes?.data?.resultFinancialStatus.isDeclined ?? false) ||
          (mxTransRes?.data?.message.isInvalid ?? false) ||
          !isPaymentStart) break;

      await getMxData();

      notify;
      if (!(mxTransRes?.data?.status?.isPending ?? false) ||
          (mxTransRes?.data?.message.isCancelled ?? false) ||
          (mxTransRes?.data?.message.isDeclined ?? false) ||
          (mxTransRes?.data?.message.isBusy ?? false) ||
          (mxTransRes?.data?.resultFinancialStatus.isDeclined ?? false) ||
          (mxTransRes?.data?.message.isInvalid ?? false) ||
          !isPaymentStart) break;
    }

    if (!(mxTransRes?.data?.status.isAwaiting ?? false)) {
      payloading = false;
      notify;
    }

    // kPrint('------ ${mxTransRes?.data?.status} | ${mxTransRes?.data?.message}');

    if (mxTransRes?.data?.message.isApproved ?? false) {
      await Future.delayed(Duration(milliseconds: 500));
    } else if (mxTransRes?.data?.status.isAwaiting ?? false) {
      await SignaturePrint.printSignature(
          data: mxTransRes?.data?.merchantReceipt, orderId: payData.orderId);
    } else {
      mxMerchantLog(orderId: payData.orderId, data: mxTransRes);
    }
  }

  Future<void> getMxData({String? id, int? version}) async {
    // Prefer provided params, otherwise fall back to existing data
    final txId = id ?? mxTransRes?.data?.id;
    final txVersion = version ?? mxTransRes?.data?.version;

    if (txId == null || txVersion == null) return;

    mxTransRes = await MxHandler.getTransaction(
        id: txId,
        version: txVersion,
        onNoSocket: () {
          showEftPay_Mx51 = true;
          mxTransRes = null;
        });
  }

  Map<String, dynamic>? testPayloadData;

  Future<void> onClickButtonMx(
      {required String? submitUrl, required MxPayData payData}) async {
    if (submitUrl == null) return;

    final _actionForm = mxTransRes?.data?.posInstructions?.actionForm;

    final Map<String, dynamic> _body = {};

    if (_actionForm?.properties != null) {
      for (final a in _actionForm!.properties!.entries.toList()) {
        if (a.value != null && a.value is Map) {
          final _val = a.value as Map;
          if (_val['type'] == 'input') {
            _body.addAll({
              '${_val['name']}': '${_val['data'] ?? ''}',
            });
          }
        }
      }
    }
    testPayloadData = _body;

    pageLoad = true;
    notify;

    mxTransRes = await MxHandler.onClickButton(
      url: submitUrl,
      body: _body,
    );
    // TODO : change only here to quick show changes
    // if (mxTransRes != null && submitUrl.toLowerCase().contains('cancel')) {
    //   mxTransRes?.data?.status = "FINALISED";
    //   mxTransRes?.data?.message = 'USER CANCELLED';
    // }
    pageLoad = false;
    notify;

    if (submitUrl.toLowerCase().contains('signature') &&
        (mxTransRes?.data?.status.isPending ?? false)) {
      _checkMxData(payData);
    }
  }

  Future<bool?> pairingInfoCheck({
    required EftposMerchant mxMerchant,
  }) async {
    if (mxMerchant.keyOrId == null || mxMerchant.keyOrId!.isEmpty) return false;

    pageLoad = true;
    notify;
    bool _isUnpaired = false;

    setMerchant(mxMerchant);

    final _status = await MxHandler.pairingInfo();

    if (_status == MXDeviceStatus.unpair) {
      // do unpair
      _isUnpaired = await _doMxAutoUnPair(mxMerchant);
    }

    pageLoad = false;
    notify;
    if (_status == MXDeviceStatus.unpair)
      return _isUnpaired;
    else if (_status == MXDeviceStatus.pair)
      return false;
    else
      return null;
  }

  Future<bool> _doMxAutoUnPair(EftposMerchant _merchant) async {
    bool? _status;
    try {
      final _platInteConnById = await Handler.getPlatIntegConnById(
          _merchant.integrationPlatformId ?? '');
      final _mxMerchantData = _platInteConnById
          ?.integrationPlatformConnectionCredentials
          ?.firstWhere(
              (a) => a.id?.toLowerCase() == _merchant.id?.toLowerCase());
      _mxMerchantData?.customerId = "";
      _mxMerchantData?.keyOrId = "";
      _mxMerchantData?.secret = "";
      _mxMerchantData?.serialNumber = "";

      _status = await Handler.addUpPlatIntegConn(
        platInteConnById: _platInteConnById!,
        showToast: false,
      );
    } catch (e) {
      //
    }
    return _status ?? false;
  }

  void mxEftClear() {
    pageLoad = false;
    payloading = false;
    buttonLoad = false;
    isPaymentStart = false;
    _printerDetails = null;
    mxPayTimeOut = false;
    testPayloadData = null;
    // mxTransRes = null;
  }

  Future<void> setMxReqDb({MxTransReq? req}) async {
    await DbLocalData.updateMxRequestData(data: req);
  }

  Future<void> clearMXDbData() async {
    final _status = await InternetUtils.getInterNetStatus;
    if (_status) {
      removePayReqData('clearMXDbData');
      removeRefundReqData();
      setMxReqDb();
    }
  }

  InvoicePrinterDetail? _printerDetails;

  Future<void> printReceipt(String? action) async {
    if (action != 'PRINT_MERCHANT_RECEIPT' &&
        action != 'PRINT_CUSTOMER_RECEIPT') return;

    if (pageLoad) return;

    pageLoad = true;
    notify;

    _printerDetails ??= await Handler.getInvoicePrinterDetail();

    // InvoicePrinterDetail? _printerDetails;

    // if (_printerRes?.isNotEmpty ?? false) {
    //   _printerDetails = _printerRes?.first;
    // }

    pageLoad = false;
    notify;

    final _a = PrintingMerchantInvoiceDetailsResponseViewModel(
      storeName: GlobalCVP.currentStore?.name,
      storeAddress: GlobalCVP.currentStore?.address,
      ipAddress: _printerDetails?.ipAddress,
      port: _printerDetails?.port,
      printerType: _printerDetails?.printerType,
      merchantInvoiceData: mxTransRes?.data?.merchantReceipt,
      customerInvoiceData: mxTransRes?.data?.customerReceipt,
    );
    final _pIMx = MerchantPrint.cIPrintMerchant(
      _a,
      invoiceData: action == 'PRINT_MERCHANT_RECEIPT'
          ? MerchantDetails.Merchant
          : MerchantDetails.Customer,
    );

    await MerchantPrint.printMerchant(pI: _pIMx);
  }

  Future<void> mxMerchantLog({String? orderId, MxTransRes? data}) async {
    if (orderId == null ||
        (data?.data?.merchantReceipt == null &&
            data?.data?.customerReceipt == null)) return;

    final _data = MerchantLog(
        orderId: orderId,
        transactionRefId: data?.data?.id,
        merchantInvoiceRequestViewModel: MerchantInvoiceRequestViewModel(
          merchantInvoiceData: data?.data?.merchantReceipt,
          customerInvoiceData: data?.data?.customerReceipt,
        ));

    Handler.eftPosMerchantLogs(data: _data);
  }
}

extension ApprovalCheck on String? {
  bool get isPending => this?.toLowerCase().contains('pending') ?? false;
  bool get isAwaiting => this?.toLowerCase().contains('awaiting') ?? false;
  bool get isApproved => this?.toLowerCase().contains('approve') ?? false;
  bool get isCancelled => this?.toLowerCase().contains('cancel') ?? false;
  bool get isDeclined => this?.toLowerCase().contains('decline') ?? false;
  bool get isBusy => this?.toLowerCase().contains('busy') ?? false;
  bool get isInvalid => this?.toLowerCase().contains('invalid') ?? false;
}
