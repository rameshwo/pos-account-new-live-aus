// import 'dart:convert';
// import 'dart:developer';

// import 'package:connectivity_plus/connectivity_plus.dart';
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:pos_account/config/utils/internet_utils.dart';
import 'package:pos_account/constant/constant.dart';
import 'package:pos_account/constant/strings.dart';
import 'package:pos_account/ln.dart';
import 'package:pos_account/providers/common/eftpro.dart';
import 'package:pos_account/providers/integration/terminal_pro.dart';
import 'package:pos_account/providers/menu/payment_pro.dart';
import 'package:pos_account/repository/mx/model/mx_pay_data.dart';
import 'package:pos_account/repository/windcave/windcave_handler.dart';
import 'package:pos_account/screens/home_screen/com/items/sidebar/order_section/com/pay_method/com/choose_eft_pay_dia.dart';
import 'package:pos_account/screens/home_screen/com/pos_orders/com/pending_order/pending_order.dart';
import 'package:pos_account/services/database/database/db_local_data.dart';
import 'package:pos_account/services/payment/mx/transaction/mx_trans_dia.dart';
import 'package:pos_account/widgets/dialog/msg_dialog.dart';
import 'package:provider/provider.dart';
import 'mx/incomplete_mx_pay.dart';
import 'windcave/incomplete_windcave_pay_dia.dart';
import 'windcave/windcave_pay.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

class EFTReturnValue {
  final String? refId;
  final String? merchantReceipt;
  final String? customerReceipt;
  final String? serialNumber;
  final String merchantType;
  String? terminalId;
  final double? merchantSurcharge;

  EFTReturnValue({
    this.refId,
    this.merchantReceipt,
    this.customerReceipt,
    this.serialNumber,
    required this.merchantType,
    this.terminalId,
    this.merchantSurcharge,
  });
}

class EFTPayment {
  static String? loadedString;

  // static void merchantLog({
  //   required Map<String, String> parameter,
  //   String? orderId,
  // }) {
  //   final _refId = parameter['posRefId'];

  //   if (_refId == null || orderId == null) return;

  //   final _data = MerchantLog(
  //       orderId: orderId,
  //       transactionRefId: _refId,
  //       merchantInvoiceRequestViewModel: MerchantInvoiceRequestViewModel(
  //           merchantInvoiceData: parameter['merchantReceipt'],
  //           // Utils.decodeAndFormatData(parameter['merchantReceipt']),
  //           customerInvoiceData: parameter['customerReceipt']
  //           // Utils.decodeAndFormatData(parameter['customerReceipt']),
  //           ));

  //   Handler.eftPosMerchantLogs(data: _data);
  // }

  static GlobalKey<ScaffoldState>? scaffKey;

  /// This key is used to check eft pay/refund recovery view only once at a time, since it may call multiple time while listening interet connection
  static bool _isEftCheckingOn = false;

  static Future<void> checkEftPendingPayment(
    BuildContext context, {
    bool isDisconnect = false,
  }) async {
    if (_isEftCheckingOn) return;

    _isEftCheckingOn = true;
    final payPro = Provider.of<PaymentPro>(context, listen: false);

    payPro.eftReturnValue = null;
    payPro.eftIncompletePayReqData = null;
    payPro.eftIncompleteRefundReqData = null;

    final _payData = await DbLocalData.getPaymentReqData();
    // log('2 --- ${json.encode(_payData?.toJson())}');

    if (_payData?.orderId?.isNotEmpty ?? false) {
      // kPrint(
      //     '------------------p a y m e n t----------------${_payData?.eftPosMerchantType}-------------- ');

      payPro.orderId = _payData?.orderId;
      if (_payData?.eftPosMerchantType == EftPayMethod.Mx51.name) {
        final eftPro = Provider.of<EftPro>(context, listen: false);

        final _merchants = payPro.paySecListRes?.eftposMerchantList;

        final _mx = (_merchants?.any((e) =>
                    e.merchantType == InteEnum.Mx.name &&
                    (e.keyOrId?.isNotEmpty ?? false)) ??
                false)
            ? _merchants
                ?.where((e) =>
                    e.merchantType == InteEnum.Mx.name &&
                    (e.keyOrId?.isNotEmpty ?? false))
                .toList()
            : null;

        // kPrint(
        //     '---${_mx == null}-- ${_mx?.isEmpty} -- ${_mx?.map((e) => e.serialNumber).toList()}  ${_payData?.eftposSerialNumber}');

        if (_mx == null ||
            _mx.isEmpty ||
            !_mx.any((a) => a.serialNumber == _payData?.eftposSerialNumber)) {
          return;
        }

        eftPro.setMerchant(_mx
            .firstWhere((a) => a.serialNumber == _payData?.eftposSerialNumber));

        await eftPro.getMxData(id: _payData?.transactionRefId, version: 3);

        final _continueTrans = await showDialog(
            barrierDismissible: false,
            context: context,
            builder: (_) => InCompleteMxPayDia());

        // kPrint(
        //     "_continueTrans: $_continueTrans $isDisconnect ${scaffKey != null} ${eftPro.isOnPayScreen} ${payPro.orderId}");

        if (_continueTrans == null ||
            _continueTrans is! bool ||
            !_continueTrans) {
          return;
        }

        // kPrint(
        //     "eftPro.mxTransRes: ${eftPro.mxTransRes?.data?.status} ${eftPro.mxTransRes?.data?.message}");

        // log(json.encode(eftPro.mxTransRes?.toJson()));

        if ((eftPro.mxTransRes?.data?.status?.isPending ?? false) ||
            (eftPro.mxTransRes?.data?.message?.isDeclined ?? false) ||
            (eftPro.mxTransRes?.data?.message?.isCancelled ?? false)) {
          final _mxPayReq = await DbLocalData.getMxReqData();

          // log(json.encode(_mxPayReq?.toJson()));

          final _mxRes = await MxTransDia.show(context,
              merchantList: _mx,
              payData: MxPayData(
                totalAmount:
                    (_mxPayReq?.purchaseDetails?.purchaseAmount ?? 0) / 100,
                surAmount:
                    (_mxPayReq?.purchaseDetails?.surchargeAmount ?? 0) / 100,
                tipAmount: (_mxPayReq?.purchaseDetails?.tipAmount ?? 0) / 100,
                mxPayType: MxPayType.Purchase,
                orderId: _payData?.orderId,
              ));

          if (_mxRes == null) {
            _isEftCheckingOn = false;
            return;
          }

          final _eftValue = EFTReturnValue(
            refId: _mxRes.data?.id,
            merchantReceipt: _mxRes.data?.merchantReceipt,
            customerReceipt: _mxRes.data?.customerReceipt,
            merchantType: EftPayMethod.Mx51.name,
            serialNumber: _mxRes.terminal?.serialNumber,
            terminalId: _mxRes.terminal?.id,
            merchantSurcharge:
                (_mxRes.data?.resultAmounts?.surchargeAmount ?? 0) / 100,
          );

          payPro.eftReturnValue = _eftValue
            ..terminalId = _payData?.integrationPlatformTerminalId;
          payPro.eftIncompletePayReqData = _payData;

          if (payPro.orderId?.isNotEmpty ?? false) {
            // internet disconnect & recover on payment screen
            if (isDisconnect && eftPro.isOnPayScreen) {
              payPro.doPayOrRefundFlag = "do_pay_recover";
              payPro.notify;
            } else if (scaffKey != null) {
              PendingOrder.payNow(
                context,
                orderId: _payData?.orderId ?? '',
                scaffKey: scaffKey!,
              );
            }
          }
        } else if (eftPro.mxTransRes?.data?.message.isApproved ?? false) {
          final _eftValue = EFTReturnValue(
            refId: eftPro.mxTransRes?.data?.id,
            merchantReceipt: eftPro.mxTransRes?.data?.merchantReceipt,
            customerReceipt: eftPro.mxTransRes?.data?.customerReceipt,
            merchantType: EftPayMethod.Mx51.name,
            serialNumber: eftPro.mxTransRes?.terminal?.serialNumber,
            terminalId: eftPro.mxTransRes?.terminal?.id,
            merchantSurcharge:
                (eftPro.mxTransRes?.data?.resultAmounts?.surchargeAmount ?? 0) /
                    100,
          );

          payPro.eftReturnValue = _eftValue
            ..terminalId = _payData?.integrationPlatformTerminalId;
          payPro.eftIncompletePayReqData = _payData;

          if (isDisconnect && eftPro.isOnPayScreen) {
            payPro.doPayOrRefundFlag = "do_pay_recover";
            payPro.notify;
          } else if (scaffKey != null) {
            PendingOrder.payNow(
              context,
              orderId: _payData?.orderId ?? '',
              scaffKey: scaffKey!,
            );
          }
        } else {
          eftPro.removePayReqData('checkEftPendingPayment: mx');
          _isEftCheckingOn = false;
          return;
        }

        // final _payDataInString = jsonEncode(_payData?.toJson());
        // final _eftValue = await EFTPayment.eftPayDiaLog(
        //   context,
        //   payUrl: "${AppEnviro.eftposPay}?transactionData=$_payDataInString}",
        //   orderId: _payData?.orderId,
        // );
        // // data clear from database when pay screen is opened

        // if (_eftValue != null) {
        //   payPro.eftReturnValue = _eftValue
        //     ..terminalId = _payData?.integrationPlatformTerminalId;
        //   payPro.eftIncompletePayReqData = _payData;

        //   if (payPro.orderId?.isNotEmpty ?? false) {
        //     payPro.doPayOrRefundFlag = "do_pay_recover";
        //     payPro.notify;
        //   } else if (scaffKey != null) {
        //     PendingOrder.payNow(
        //       context,
        //       orderId: _payData?.orderId ?? '',
        //       scaffKey: scaffKey!,
        //     );
        //   }
        // }
      } else if (_payData?.eftPosMerchantType ==
          EftPayMethod.WindcavePay.name) {
        // log('---------------3-------------');
        // windcave pay

        final _localData = await DbLocalData.getWindcaveReqData();

        final eftPro = Provider.of<EftPro>(context, listen: false);

        if (_localData?.txnRef == null || _localData!.txnRef!.isEmpty) {
          eftPro.removePayReqData('checkEftPendingPayment: windcave');

          return;
        }

        final _continueTrans = await showDialog(
            barrierDismissible: false,
            context: context,
            builder: (_) => InCompleteWindcavePayDia());

        // log('---------------3.5-----$_continueTrans--------');

        if (_continueTrans == null ||
            _continueTrans is! bool ||
            !_continueTrans) {
          return;
        }

        payPro.loading = true;
        payPro.loadingPay = true;
        payPro.notify;

        // log('---------------3.8-----${_localData.toJson()}--------');
        eftPro.windTranRes = null;
        eftPro.isPaymentStart = true;

        WindcaveEftPayDia.showDia(
          context,
          req: _localData,
          type: WindcavePayType.Purchase,
        ).then((value) => sendWindCaveLog(orderId: _payData?.orderId));

        final _payStatus =
            await eftPro.windpay(windRequest: _localData, isStatus: true);

        EFTReturnValue? eftWindVal;

        // log('---------------4-------$_payStatus------');

        eftPro.removePayReqData('checkEftPendingPayment: windcave');

        if (_payStatus != null) {
          Navigator.of(context).pop();
          eftWindVal = EFTReturnValue(
            refId: _localData.txnRef,
            merchantType: EftPayMethod.WindcavePay.name,
            serialNumber: _payStatus.station,
            customerReceipt: _payStatus.rcpt,
            terminalId: _payData?.integrationPlatformTerminalId,
            // merchantSurcharge: 0.00,
          );
        }

        payPro.loading = false;
        payPro.loadingPay = false;
        payPro.notify;

        if (eftWindVal != null) {
          payPro.eftReturnValue = eftWindVal;
          payPro.eftIncompletePayReqData = _payData;

          if (payPro.orderId?.isNotEmpty ?? false) {
            if (isDisconnect && eftPro.isOnPayScreen) {
              payPro.doPayOrRefundFlag = "do_pay_recover";
              payPro.notify;
            } else if (scaffKey != null) {
              PendingOrder.payNow(
                context,
                orderId: _payData?.orderId ?? '',
                scaffKey: scaffKey!,
              );
            }
          }
        }
      } else if (_payData?.eftPosMerchantType == EftPayMethod.VisionPay.name) {}
    } else {
      final _refundData = await DbLocalData.getRefundReqData();
      // log("refund ------- ${jsonEncode(_refundData)}");

      if (_refundData?.orderId?.isNotEmpty ?? false) {
        // log('------------------r e f u n d------------------------------ ');

        payPro.orderId = _refundData?.orderId;
        if (_refundData?.eftPosMerchantType == EftPayMethod.Mx51.name) {
          final eftPro = Provider.of<EftPro>(context, listen: false);
          final _merchants = payPro.paySecListRes?.eftposMerchantList;

          final _mx = (_merchants?.any((e) =>
                      e.merchantType == InteEnum.Mx.name &&
                      (e.keyOrId?.isNotEmpty ?? false)) ??
                  false)
              ? _merchants
                  ?.where((e) =>
                      e.merchantType == InteEnum.Mx.name &&
                      (e.keyOrId?.isNotEmpty ?? false))
                  .toList()
              : null;

          if (_mx == null ||
              _mx.isEmpty ||
              !_mx.any((a) => a.serialNumber == _payData?.eftposSerialNumber)) {
            return;
          }

          eftPro.setMerchant(_mx.firstWhere(
              (a) => a.serialNumber == _payData?.eftposSerialNumber));

          await eftPro.getMxData(id: _refundData?.transactionRefId, version: 3);

          final _continueTrans = await showDialog(
              barrierDismissible: false,
              context: context,
              builder: (_) => InCompleteMxPayDia());

          // log("_continueTrans: $_continueTrans");

          if (_continueTrans == null ||
              _continueTrans is! bool ||
              !_continueTrans) {
            return;
          }

          if ((eftPro.mxTransRes?.data?.status?.isPending ?? false) ||
              (eftPro.mxTransRes?.data?.message?.isDeclined ?? false) ||
              (eftPro.mxTransRes?.data?.message?.isCancelled ?? false)) {
            final _mxPayReq = await DbLocalData.getMxReqData();

            // log("Refund DB Data : ${json.encode(_mxPayReq?.toJson())}");

            final _mxRes = await MxTransDia.show(context,
                merchantList: _mx,
                payData: MxPayData(
                  totalAmount:
                      (_mxPayReq?.refundDetails?.refundAmount ?? 0) / 100,
                  mxPayType: MxPayType.Refund,
                  orderId: _refundData?.orderId,
                ));

            if (_mxRes == null) {
              _isEftCheckingOn = false;
              return;
            }

            final _eftValue = EFTReturnValue(
              refId: _mxRes.data?.id,
              merchantReceipt: _mxRes.data?.merchantReceipt,
              customerReceipt: _mxRes.data?.customerReceipt,
              merchantType: EftPayMethod.Mx51.name,
              serialNumber: _mxRes.terminal?.serialNumber,
              terminalId: _mxRes.terminal?.id,
              merchantSurcharge:
                  (_mxRes.data?.resultAmounts?.surchargeAmount ?? 0) / 100,
            );

            payPro.eftReturnValue = _eftValue
              ..terminalId = _refundData?.integrationPlatformTerminalId;

            payPro.eftIncompleteRefundReqData = _refundData;

            if (payPro.orderId?.isNotEmpty ?? false) {
              if (isDisconnect && eftPro.isOnPayScreen) {
                payPro.doPayOrRefundFlag = "do_refund_recover";
                payPro.notify;
              } else if (scaffKey != null) {
                PendingOrder.payNow(
                  context,
                  orderId: _refundData?.orderId ?? '',
                  scaffKey: scaffKey!,
                  isForRefund: true,
                );
              }
            }
          } else if (eftPro.mxTransRes?.data?.message.isApproved ?? false) {
            final _eftValue = EFTReturnValue(
              refId: eftPro.mxTransRes?.data?.id,
              merchantReceipt: eftPro.mxTransRes?.data?.merchantReceipt,
              customerReceipt: eftPro.mxTransRes?.data?.customerReceipt,
              merchantType: EftPayMethod.Mx51.name,
              serialNumber: eftPro.mxTransRes?.terminal?.serialNumber,
              terminalId: eftPro.mxTransRes?.terminal?.id,
              merchantSurcharge:
                  (eftPro.mxTransRes?.data?.resultAmounts?.surchargeAmount ??
                          0) /
                      100,
            );

            payPro.eftReturnValue = _eftValue
              ..terminalId = _refundData?.integrationPlatformTerminalId;

            payPro.eftIncompleteRefundReqData = _refundData;

            if (isDisconnect && eftPro.isOnPayScreen) {
              payPro.doPayOrRefundFlag = "do_refund_recover";
              payPro.notify;
            } else if (scaffKey != null) {
              PendingOrder.payNow(
                context,
                orderId: _refundData?.orderId ?? '',
                scaffKey: scaffKey!,
                isForRefund: true,
              );
            }
          } else {
            eftPro.removeRefundReqData();
            _isEftCheckingOn = false;
            return;
          }

          // final _refundDataInString = jsonEncode(_refundData?.toJson());
          // final _eftValue = await EFTPayment.eftPayDiaLog(
          //   context,
          //   payUrl:
          //       "${AppEnviro.eftposPay}?transactionData=$_refundDataInString}",
          //   orderId: _refundData?.orderId,
          // );

          // // log("eft value on home page ---------------------- ${_eftValue?.refId}");

          // if (_eftValue != null) {
          //   payPro.eftReturnValue = _eftValue
          //     ..terminalId = _refundData?.integrationPlatformTerminalId;
          //   payPro.eftIncompleteRefundReqData = _refundData;

          //   if (payPro.orderId?.isNotEmpty ?? false) {
          //     payPro.doPayOrRefundFlag = "do_refund_recover";
          //     payPro.notify;
          //   } else if (scaffKey != null) {
          //     PendingOrder.payNow(
          //       context,
          //       orderId: _refundData?.orderId ?? '',
          //       scaffKey: scaffKey!,
          //       isForRefund: true,
          //     );
          //   }
          // }
        } else if (_refundData?.eftPosMerchantType ==
            EftPayMethod.WindcavePay.name) {
          // windcave pay
          // log('---------------3.5-----windcave--refund------');

          final _localData = await DbLocalData.getWindcaveReqData();

          final eftPro = Provider.of<EftPro>(context, listen: false);

          if (_localData?.txnRef == null || _localData!.txnRef!.isEmpty) {
            eftPro.removeRefundReqData();
            return;
          }

          // log('---------------4-----${_localData.toJson()}--------');

          final _continueTrans = await showDialog(
              barrierDismissible: false,
              context: context,
              builder: (_) => InCompleteWindcavePayDia());

          if (_continueTrans == null ||
              _continueTrans is! bool ||
              !_continueTrans) {
            return;
          }

          // log('---------------5-----$_continueTrans--------');

          payPro.loading = true;
          payPro.loadingPay = true;
          payPro.notify;

          eftPro.windTranRes = null;
          eftPro.isPaymentStart = true;

          WindcaveEftPayDia.showDia(
            context,
            req: _localData,
            type: WindcavePayType.Refund,
          ).then((value) => sendWindCaveLog(orderId: _payData?.orderId));

          final _payStatus =
              await eftPro.windpay(windRequest: _localData, isStatus: true);

          EFTReturnValue? eftWindVal;

          eftPro.removeRefundReqData();

          if (_payStatus != null) {
            Navigator.of(context).pop();
            eftWindVal = EFTReturnValue(
              refId: _localData.txnRef,
              merchantType: EftPayMethod.WindcavePay.name,
              serialNumber: _payStatus.station,
              customerReceipt: _payStatus.rcpt,
              terminalId: _refundData?.integrationPlatformTerminalId,
              // merchantSurcharge: 0.00,
            );
          }

          payPro.loading = false;
          payPro.loadingPay = false;
          payPro.notify;

          if (eftWindVal != null) {
            payPro.eftReturnValue = eftWindVal;
            payPro.eftIncompleteRefundReqData = _refundData;

            if (payPro.orderId?.isNotEmpty ?? false) {
              if (isDisconnect && eftPro.isOnPayScreen) {
                payPro.doPayOrRefundFlag = "do_refund_recover";
                payPro.notify;
              } else if (scaffKey != null) {
                PendingOrder.payNow(
                  context,
                  orderId: _refundData?.orderId ?? '',
                  scaffKey: scaffKey!,
                  isForRefund: true,
                );
              }
            }
          }
        } else if (_refundData?.eftPosMerchantType ==
            EftPayMethod.VisionPay.name) {}
      }
    }
    _isEftCheckingOn = false;
  }

  // static bool _eftNoInternetPopUpOn = false;

  /// This key is used to check if there remains any payment or refund recovery when app restarts offline then it gets online
  // static bool _initCheckEft = false;

  static int _isDisplayNDCount = 0;

  static void checkEftOnInternetConnect() {
    final _context = CUS_CTX;
    if (_context == null) return;

    final eftPro = Provider.of<EftPro>(_context, listen: false);
    InternetUtils.connectionChecker.onStatusChange.listen((event) {
      // kPrint(
      //     'internet connectivity update ${event.name} --------------showEft = ${eftPro.showEftPay_Mx51}------eftChecking = $_isEftCheckingOn----- ');

      if (event == InternetConnectionStatus.disconnected) {
        if (MxTransDia.isDiaOpen) {
          eftPro.showEftPay_Mx51 = true;
          eftPro.mxTransRes = null;

          if (MxTransDia.context != null) {
            Navigator.pop(MxTransDia.context!);
          }

          if (_isDisplayNDCount == 0) {
            _isDisplayNDCount++;
            Future.delayed(Duration(milliseconds: 500), () {
              // kPrint("Display network connections count: $_isDisplayNDCount");
              MsgDia.show(
                CUS_CTX,
                headerAnimation: false,
                diaType: DiaType.warning,
                title: LN.noInternetConnection,
                autoHideSecond: 7,
                desc: Strings.noInternetOnTerminalConnection,
                onPop: () {
                  _isDisplayNDCount = 0;
                },
                onOkay: () {
                  _isDisplayNDCount = 0;
                },
                btnOkColor: kSecondaryColor,
              );
            });
          }
        }

        // if (!_eftNoInternetPopUpOn)
        //   MsgDia.show(_context,
        //       title: LN.noInternetConnection,
        //       desc:
        //           "If the payment has been done from EFTPOS device then it can be recovered whenever you are connected to internet. Else, proceed payment when you are online.",
        //       diaType: DiaType.warning,
        //       onPop: () => _eftNoInternetPopUpOn = false);
        // _eftNoInternetPopUpOn = true;
      } else {
        // if (_eftNoInternetPopUpOn) {
        //   Navigator.pop(_context);
        // }
        if (eftPro.showEftPay_Mx51) {
          eftPro.showEftPay_Mx51 = false;
          eftPro.notify;
          // kPrint('here');
          Future.delayed(
              Duration(milliseconds: 1000),
              () => EFTPayment.checkEftPendingPayment(
                    _context,
                    isDisconnect: true,
                  ));

          Future.delayed(Duration(milliseconds: 200), () => eftPro.notify);
        }
      }

      // log('---------------1--------${eftPro.eftPayInit_Windcave}-----');

      if (eftPro.eftPayInit_Windcave &&
          event == InternetConnectionStatus.connected) {
        // log('---------------2-------------');

        if (eftPro.windcavePayDiaOn) {
          eftPro.windcavePayDiaOn = false;
          Navigator.pop(_context);
        }
        eftPro.eftPayInit_Windcave = false;
        eftPro.notify;
        Future.delayed(
            Duration(milliseconds: 1000),
            () => EFTPayment.checkEftPendingPayment(
                  _context,
                  isDisconnect: true,
                ));
      }
    });
  }

  static void sendWindCaveLog({String? orderId}) {
    WindcaveHandler.sendLogs(orderId ?? '');
  }
}
