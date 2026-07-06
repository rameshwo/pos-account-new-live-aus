import 'package:flutter/material.dart';
import 'package:pos_account/config/size_config.dart';
import 'package:pos_account/config/utils/order_utils.dart';
import 'package:pos_account/config/utils/utils.dart';
import 'package:pos_account/config/validator.dart';
import 'package:pos_account/constant/constant.dart';
import 'package:pos_account/ln.dart';
import 'package:pos_account/model/home/menu/payment/make_pay_res.dart';
import 'package:pos_account/providers/common/eftpro.dart';
import 'package:pos_account/providers/common/invoice_pro.dart';
import 'package:pos_account/providers/cus_val_pro.dart';
import 'package:pos_account/providers/integration/terminal_pro.dart';
import 'package:pos_account/providers/menu/payment_pro.dart';
import 'package:pos_account/repository/handler.dart';
import 'package:pos_account/repository/if_exception.dart';
import 'package:pos_account/repository/mx/model/mx_pay_data.dart';
import 'package:pos_account/repository/windcave/model/tran_req.dart';
import 'package:pos_account/services/payment/mx/transaction/mx_trans_dia.dart';
import 'package:pos_account/services/payment/windcave/windcave_pay.dart';
import 'package:pos_account/services/payment/eft_payment.dart';
import 'package:pos_account/services/printer/com/invoice_print.dart';
import 'package:pos_account/widgets/input/text_form/text_form_widget.dart';
import 'package:pos_account/widgets/loading.dart';
import 'package:provider/provider.dart';
import '../../../../../../../../providers/common/review_pro.dart';
import '../../../../../../../../widgets/review_dialog.dart';
import 'com/choose_eft_pay_dia.dart';
import 'com/pay_method.dart';
import 'com/card_button.dart';
import 'com/refund_card.dart';
import 'com/unique_num_sec.dart';

class PaymentSection extends StatefulWidget {
  final Future<void> Function(PaySummary?)? payNow;
  final PaymentPro payPro;
  final GlobalKey<FormState>? formKey;
  final EFTReturnValue? eftReturnValue;

  const PaymentSection({
    super.key,
    this.payNow,
    required this.payPro,
    this.formKey,
    this.eftReturnValue,
  });

  @override
  State<PaymentSection> createState() => _PaymentSectionState();
}

class _PaymentSectionState extends State<PaymentSection> {
  // showAddCusDia(BuildContext context) {
  //   final size = Ssize(context);

  //   return showDialog(
  //       context: context,
  //       builder: (builder) => SimpleDialog(
  //             // backgroundColor: kBackgroundColor,
  //             titlePadding: EdgeInsets.zero,
  //             contentPadding: EdgeInsets.symmetric(
  //                 horizontal: size.getW(24), vertical: size.getH(24)),
  //             shape: RoundedRectangleBorder(
  //                 borderRadius: BorderRadius.circular(15)),
  //             children: [AddCustomer()],
  //           ));
  // }

  Future<void> _eftPendingPayment({
    required EFTReturnValue? eftReturnValue,
  }) async {
    // log("EFT values -------- ${eftReturnValue?.refId} ------- ${eftReturnValue?.merchantReceipt}");

    if (widget.payPro.onPayScreenFor == OnPayScreenFor.Payment) {
      widget.payPro.loadingPay = true;
      widget.payPro.notify;
      await Future.delayed(Duration(seconds: 1), () {});

      final _status = await widget.payPro.makePayment(
        eftValue: eftReturnValue,
        isEftIncomplete: true,
      );
      if (_status == null) return;

      eftPro.removePayReqData('_eftPendingPayment');
      eftPro.removeRefundReqData();

      final _isPayComplete =
          widget.payPro.makePaymentRes?.isPaymentCompleted ?? false;

      _paySum = PaySummary(
        paidAmountByUser: widget.payPro.amountPaidByUserCltr.text,
        payMethod: widget.payPro.PAY_METHOD ?? PayMethodEnum.None,
        totalAmount: (widget.payPro.makePaymentRes
                    ?.printingInvoiceDetailsResponseViewModels?.isNotEmpty ??
                false)
            ? (widget
                    .payPro
                    .makePaymentRes
                    ?.printingInvoiceDetailsResponseViewModels
                    ?.first
                    .totalAmount ??
                "")
            : widget.payPro.payableAmount.formatDouble,
        // isSendToKit: false,
      );

      if (_isPayComplete) {
        _paySum?.orderId = "${widget.payPro.makePaymentRes?.orderId}";
        widget.payPro.loading = false;
        widget.payPro.loadingPayStk = false;
        widget.payPro.notify;
      }

      if (!_isPayComplete) {
        widget.payPro.loadingPay = true;
        widget.payPro.notify;
      }

      await setDataOnPay();

      if (!_isPayComplete) {
        widget.payPro.loadingPay = false;
        widget.payPro.notify;
      }
    }
  }

  Future<void> _onPay(
    BuildContext context, {
    bool isSendToKit = false,
  }) async {
    if (widget.formKey == null ||
        (widget.formKey != null && !widget.formKey!.currentState!.validate())) {
      return;
    }

    EFTReturnValue? _eftReturnVal;

    //  EFTPOS setup: remove comment to make it work

    final _allAmount = widget.payPro.getAllAmount;

    final double _phSurchargeAmountValue =
        widget.payPro.isCheckPubHoCharge ? _allAmount.pHSurCharge : 0.0;

    final double _ccSurchargeAmountValue =
        widget.payPro.isCheckCreCarCharge ? _allAmount.ccSurCharge : 0.0;

    final double _serviceChargeAmountValue =
        widget.payPro.isCheckServiceCharge ? _allAmount.serviceCharge : 0.0;

    final _paidAmount = widget.payPro.paymentType == PaymentType.PartialPayment
        ? (widget.payPro.isSplitPerPerson
            ? "${widget.payPro.readOnlyPaidAmount.inDouble - (_phSurchargeAmountValue + _ccSurchargeAmountValue + _serviceChargeAmountValue).roundToN()}"
            : !widget.payPro.isCompletePayAfterSplit
                ? (widget.payPro.getSplitAmountTemp(
                        double.tryParse(widget.payPro.paidAmountCltr.text) ??
                            0.0))
                    .roundToNString()
                : widget.payPro.paidAmountCltr.text)
        : widget.payPro.paidAmountCltr.text;

    final _totalAmount = _paidAmount.inDouble +
        _phSurchargeAmountValue +
        _serviceChargeAmountValue +
        widget.payPro.tipCltr.text.inDouble;

    //
    if (GlobalCVP.eftPosEnable && _isEFTPOSPayment && _totalAmount > 0) {
      // choose pay method
      // TODO: WINDCAVE TEST
      final _merchants = widget.payPro.paySecListRes?.eftposMerchantList;

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

      final _vision =
          (_merchants?.any((e) => e.merchantType == InteEnum.VisionPay.name) ??
                  false)
              ? _merchants
                  ?.where((e) => e.merchantType == InteEnum.VisionPay.name)
                  .toList()
              : null;

      final _wind =
          (_merchants?.any((e) => e.merchantType == InteEnum.WindCave.name) ??
                  false)
              ? _merchants
                  ?.where((e) => e.merchantType == InteEnum.WindCave.name)
                  .toList()
              : null;

      final EftPayMethod? _eftMethod = (_mx?.isNotEmpty ?? false)
          ? EftPayMethod.Mx51
          : (_wind?.isNotEmpty ?? false)
              ? EftPayMethod.WindcavePay
              : (_vision?.isNotEmpty ?? false)
                  ? EftPayMethod.VisionPay
                  : null;

      if (_eftMethod == EftPayMethod.Mx51) {
        final _mxRes = await MxTransDia.show(context,
            merchantList: _mx!,
            payData: MxPayData(
              totalAmount: _paidAmount.inDouble +
                  _phSurchargeAmountValue +
                  _serviceChargeAmountValue,
              surAmount: _ccSurchargeAmountValue,
              tipAmount: widget.payPro.tipCltr.text.inDouble,
              mxPayType: MxPayType.Purchase,
              orderId:
                  widget.payPro.orderDetailById?.orderDetailsViewModel?.orderId,
            ));

        if (_mxRes == null) {
          return;
        }

        _eftReturnVal = EFTReturnValue(
          refId: _mxRes.data?.id,
          merchantReceipt: _mxRes.data?.merchantReceipt,
          customerReceipt: _mxRes.data?.customerReceipt,
          merchantType: EftPayMethod.Mx51.name,
          serialNumber: _mxRes.terminal?.serialNumber,
          terminalId: _mxRes.terminal?.id,
          merchantSurcharge:
              (_mxRes.data?.resultAmounts?.surchargeAmount ?? 0) / 100,
        );

        // _eftReturnVal = await EFTPayment.eftPayDiaLog(
        //   context,
        //   payUrl:
        //       "${AppEnviro.eftposPay}?amount=$_paidAmount$_surchargeAmount$_tipAmount&transactionType=PAYMENT_TRANSACTION&terminals=${Utils.encodebase64(_terminalData)}",
        //   orderId: widget.payPro.orderId,
        //   // onPayClicked: () {
        //   //   final _data = widget.payPro.getPaymentRequest();
        //   //   DbLocalData.updatePaymentRequestData(data: _data);
        //   // },
        // );

        // _eftReturnVal?.terminalId =
        //     (_mx?.any((e) => e.serialNumber == _eftReturnVal?.serialNumber) ??
        //             false)
        //         ? _mx
        //             ?.firstWhere(
        //                 (e) => e.serialNumber == _eftReturnVal?.serialNumber)
        //             .id
        //         : null;

        // if (_eftReturnVal == null)
        //   return;
        // else if (_eftReturnVal.refId?.isNotEmpty ?? false) {
        //   DbLocalData.updatePaymentRequestData();
        // }
      } else if (_eftMethod == EftPayMethod.VisionPay) {
        // double _amtPurchase = (widget.payPro.paidAmountCltr.text.inDouble +
        //         _surchargeAmountValue +
        //         widget.payPro.tipCltr.text.inDouble)
        //     .roundToN(n: 2);

        // final _res = await VisionPayEftDia.showDia(
        //   context,
        //   amount: _amtPurchase,
        //   type: VisionPayType.Purchase,
        //   terminal: _vision,
        // );

        // if (_res != null) {
        //   EftposMerchant? _selectedVision;

        //   if (_vision?.any((e) => e.isDefault ?? false) ?? false) {
        //     _selectedVision = _vision?.firstWhere((e) => e.isDefault ?? false);
        //   }

        //   _eftReturnVal = EFTReturnValue(
        //     refId: _res.externalReference,
        //     merchantReceipt: json.encode(_res.toJson()),
        //     merchantType: EftPayMethod.VisionPay.name,
        //     serialNumber: _selectedVision?.serialNumber,
        //     terminalId: _selectedVision?.id,
        //   );
        // } else {
        //   return;
        // }
      } else if (_eftMethod == EftPayMethod.WindcavePay) {
        final _refId = Utils.getRandomString(15);

        double _amtPurchase = widget.payPro.paidAmountCltr.text.inDouble +
            _phSurchargeAmountValue +
            _serviceChargeAmountValue +
            _ccSurchargeAmountValue +
            widget.payPro.tipCltr.text.inDouble;

        if (widget.payPro.paymentType == PaymentType.PartialPayment &&
            widget.payPro.isSplitPerPerson) {
          _amtPurchase = widget.payPro.readOnlyPaidAmount.inDouble;
        } else if (widget.payPro.isCompletePayAfterSplit) {
          _amtPurchase = widget.payPro.remainingAmount!;
        } else if (widget.payPro.paymentType == PaymentType.PartialPayment) {
          _amtPurchase = widget.payPro.paidAmountCltr.text.inDouble;
        }

        final _storeDetail = GlobalCVP.currentStore;

        final _req = WcTransactionReq(
          // user: WindcaveApi.username,
          // key: WindcaveApi.key,
          // station: await WindcaveApi.station,
          // cur: _storeDetail?.currencyCode ?? "AUD",
          // posName: "POSApt",
          amount: _amtPurchase.toStringAsFixed(2),
          txnType: TxnType.Purchase,
          txnRef: _refId,
          deviceId: await SupportHandler.getDeviceId,
          vendorId: _storeDetail?.storeId?.replaceAll('-', ''),
          mRef: _storeDetail?.name,
        );

        final _status = await WindcaveEftPayDia.showDia(
          context,
          req: _req,
          type: WindcavePayType.Purchase,
          terminal: _wind,
          orderId:
              widget.payPro.orderDetailById?.orderDetailsViewModel?.orderId,
        );
        EFTPayment.sendWindCaveLog(
            orderId:
                widget.payPro.orderDetailById?.orderDetailsViewModel?.orderId);

        if (_status != null) {
          // final _eftPro = Provider.of<EftPro>(context, listen: false);
          _eftReturnVal = EFTReturnValue(
            refId: "$_refId-${_status.result?.tr}",
            merchantType: EftPayMethod.WindcavePay.name,
            serialNumber: _status.station,
            customerReceipt: _status.rcpt,
            terminalId: (_wind?.any((e) => e.isSelected) ?? false)
                ? _wind?.firstWhere((e) => e.isSelected).id
                : null,
          );
        } else {
          return;
        }
        //
      } else {
        IfException.showMessage(
          message: "Card Payment Configuration Error",
          desc: "Please Configure EFTPOS Payment Integration",
          msg: Msg.Dialog,
          autoHideSecond: 5,
          seconds: 0,
          popNav: false,
        );
        // IfException.showMessage(
        //     message: "Please Configure EFTPOS Payment Integration");
        return;
      }
    }

    _paySum = PaySummary(
      paidAmountByUser: widget.payPro.amountPaidByUserCltr.text,
      payMethod: widget.payPro.PAY_METHOD ?? PayMethodEnum.None,
      totalAmount: widget.payPro.payableAmount.formatDouble,
      // isSendToKit: isSendToKit,
    );

    final _status = await widget.payPro
        .makePayment(eftValue: _eftReturnVal, isLoadStk: isSendToKit);
    if (_status == null || !_status) return;

    eftPro.removePayReqData('_onPay');
    eftPro.removeRefundReqData();

    final _isPayComplete =
        widget.payPro.makePaymentRes?.isPaymentCompleted ?? false;

    if (isSendToKit && _isPayComplete) {
      _paySum?.orderId = "${widget.payPro.makePaymentRes?.orderId}";
      // _paySum?.isSendToKit = widget.payPro.makePaymentRes?.sendToKitchenPrinter;
      // _paySum?.isSentToKitDisplay =
      //     widget.payPro.makePaymentRes?.sendToKitchenDisplay;
      widget.payPro.loading = false;
      widget.payPro.loadingPayStk = false;
      widget.payPro.notify;
    }

    if (!_isPayComplete) {
      widget.payPro.loadingPay = true;
      widget.payPro.notify;
    }

    await setDataOnPay();

    if (!_isPayComplete) {
      widget.payPro.loadingPay = false;
      widget.payPro.notify;
    }
  }

  PaySummary? _paySum;

  Future setDataOnPay() async {
    final _ctx = mounted ? context : CUS_CTX!;
    if (widget.payPro.makePaymentRes != null &&
        (widget.payPro.makePaymentRes!.isPaymentCompleted ?? false)) {
      if (widget.payPro.makePaymentRes!
                  .printingInvoiceDetailsResponseViewModels ==
              null ||
          widget.payPro.makePaymentRes!
              .printingInvoiceDetailsResponseViewModels!.isEmpty) {
        IfException.showMessage(
            message: widget.payPro.makePaymentRes?.message ?? 'Success',
            isError: false);
        Navigator.of(_ctx).pop();
        if ((widget.payPro.makePaymentRes?.reviewQuestionUserViewModel !=
                    null &&
                (widget.payPro.makePaymentRes?.reviewQuestionUserViewModel
                        ?.reviewQuestions?.isNotEmpty ??
                    false)) &&
            GlobalCVP.isHospitality == true) {
          final _revPro = Provider.of<ReviewPro>(_ctx, listen: false);
          _revPro.addReviewSec = ReviewQuestionUserViewModel.fromJson(
              GlobalCVP.reviewQuestionUserViewModel?.toJson() ?? {});
          showDialog(context: context, builder: (_) => ShowReviewDialog());
        }
      } else {
        final _invoicePro = Provider.of<InvoicePro>(_ctx, listen: false);
        if ((widget.payPro.makePaymentRes?.reviewQuestionUserViewModel !=
                    null &&
                (widget.payPro.makePaymentRes?.reviewQuestionUserViewModel
                        ?.reviewQuestions?.isNotEmpty ??
                    false)) &&
            GlobalCVP.isHospitality == true) {
          GlobalCVP.showReview = true;
          GlobalCVP.reviewQuestionUserViewModel =
              ReviewQuestionUserViewModel.fromJson(widget
                      .payPro.makePaymentRes?.reviewQuestionUserViewModel
                      ?.toJson() ??
                  ReviewQuestionUserViewModel().toJson());
        }
        // get model invoice to show print reciept on screen after payment
        _invoicePro.printInvoice = InvoicePrint.cIPrintInvoice(
          widget.payPro.makePaymentRes!
              .printingInvoiceDetailsResponseViewModels!.first,
          curSym: widget.payPro.curSym ?? '',
          url: widget.payPro.makePaymentRes!.url,
        );

        _invoicePro.invoiceType = InvoiceType.Payment;

        if (widget.payNow != null) await widget.payNow!(_paySum);
      }
    } else {
      if (widget.payNow != null) await widget.payNow!(null);
    }
  }

  Future<void> _onPrint(BuildContext context) async {
    final _payRes = await widget.payPro.printReceipt();

    if (_payRes == null) return;
    _payRes.isPaymentCompleted = true; // to print receipt only

    // to show Print receipt Screen

    // final _invoicePro = Provider.of<InvoicePro>(context, listen: false);
    // _invoicePro.printInvoice = InvoicePrint.cIPrintInvoice(
    //   _payRes.printingInvoiceDetailsResponseViewModels!.first,
    //   curSym: payPro.curSym ?? '',
    //   url: _payRes.url,
    // );

    // _invoicePro.invoiceType = InvoiceType.Payment;

    // to print receipt on printer

    InvoicePrint.spdPosInvoice(
      context,
      paymentRes: _payRes,
      receiptType: ReceiptType.Print,
    );
  }

  bool get _isEFTPOSPayment {
    final _payMethod = widget.payPro.paySecListRes!.paymentMethods != null &&
            widget.payPro.paySecListRes!.paymentMethods!.isNotEmpty &&
            widget.payPro.paySecListRes!.paymentMethods!
                .any((e) => e.isSelected ?? false)
        ? widget.payPro.paySecListRes!.paymentMethods!
            .firstWhere((e) => e.isSelected ?? false)
        : null;
    if (_payMethod?.name != null &&
        PayMethodClass.getMethod(_payMethod?.name) == PayMethodEnum.FPOS) {
      return true;
    } else {
      return false;
    }
  }

  late EftPro eftPro;

  @override
  void initState() {
    super.initState();
    eftPro = Provider.of<EftPro>(context, listen: false);
    // log("eftPosEnable: ${GlobalCVP.eftPosEnable} && ${GlobalCVP.recoverEftPOSEnable}");
    if (GlobalCVP.eftPosEnable && GlobalCVP.recoverEftPOSEnable)
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        // log("refId: ${widget.eftReturnValue?.refId}");
        if (widget.eftReturnValue?.refId?.isNotEmpty ?? false) {
          _eftPendingPayment(eftReturnValue: widget.eftReturnValue);
        }
        _listenPayRecover();
      });
  }

  // disconnect internet recovery
  void _listenPayRecover() {
    int i = 0;
    widget.payPro.addListener(() async {
      // log("Order ID time to update--------------${widget.payPro.doPayOrRefundFlag}----------------$i");

      if (i == 0 && widget.payPro.doPayOrRefundFlag == "do_pay_recover") {
        // log("Payment recovery------------------------------${widget.payPro.eftReturnValue?.refId?.isNotEmpty ?? false}");
        widget.payPro.doPayOrRefundFlag = null;
        i++;
        widget.payPro.notify;
        if (widget.payPro.eftReturnValue?.refId?.isNotEmpty ?? false) {
          await _eftPendingPayment(
              eftReturnValue: widget.payPro.eftReturnValue);
        }
      }
    });
  }

  // focusnode
  final focus1 = FocusNode();
  final focus2 = FocusNode();

  final _scrollCltr = ScrollController();

  @override
  void dispose() {
    focus1.dispose();
    focus2.dispose();
    _scrollCltr.dispose();
    super.dispose();
  }

  double _previousBottomInset = 0.0;

  void onTapPayMethod(int index, PayMethodEnum _payMethod) async {
    for (final e in widget.payPro.paySecListRes!.paymentMethods!) {
      e.isSelected = false;
    }
    widget.payPro.paySecListRes!.paymentMethods![index].isSelected = true;

    if (_payMethod == PayMethodEnum.FPOS ||
        _payMethod == PayMethodEnum.GiftCard ||
        _payMethod == PayMethodEnum.Loyalty ||
        _payMethod == PayMethodEnum.Bank) {
      widget.payPro.isCheckCreCarCharge = true;
    } else {
      widget.payPro.isCheckCreCarCharge = false;
    }

    if (_payMethod == PayMethodEnum.Cash) {
      // final _printSettingPro =
      //     Provider.of<PrinterSettingPro>(context, listen: false);
      // _printSettingPro.openCashDrawer();

      if (widget.payPro.onPayScreenFor != OnPayScreenFor.Refund) {
        widget.payPro.isCheckCreCarCharge = false;
      }
    }
//DIS_REMOVE
    // if (widget.payPro.uniByPayRes != null)
    //   widget.payPro.discountPercentCltr.clear();

    widget.payPro.unicodeCltr.clear();
    widget.payPro.amountPaidByUserCltr.clear();

    widget.payPro.uniByPayRes = null;

    if (_payMethod == PayMethodEnum.Loyalty) {
      widget.payPro.tipCltr.clear();
    }
    widget.payPro.loyaltyRedeem = true;

    widget.payPro.setUniSearchData(isUpdatePaidAmt: false);
    widget.payPro.onChangedPayAmount(
        // isUpdatePaidAmount:
        //     false
        );
    widget.payPro.notify;
  }

  @override
  Widget build(BuildContext context) {
    final size = Ssize(context);
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    // print("bottomInset: $bottomInset --- $_previousBottomInset");

    // Check if the keyboard visibility has changed
    if (bottomInset != _previousBottomInset) {
      _previousBottomInset = bottomInset;

      if (_previousBottomInset > bottomInset || bottomInset == 0) {
        // _scrollCltr.animateTo(
        //   0,
        //   duration: Duration(milliseconds: 300),
        //   curve: Curves.easeOut,
        // );
      } else if (bottomInset > 0 && !focus1.hasFocus && !focus2.hasFocus) {
        // Keyboard is open
        WidgetsBinding.instance.addPostFrameCallback((_) async {
          await Future.delayed(Duration(milliseconds: 200));

          if (_scrollCltr.hasClients) {
            final _maxScroll = _scrollCltr.position.maxScrollExtent;
            _scrollCltr.animateTo(
              _maxScroll - (_maxScroll > 100 ? 100 : 0),
              duration: Duration(milliseconds: 300),
              curve: Curves.easeOut,
            );
          }
        });
      }
    }

    final _isLoyaltyPayEnable =
        widget.payPro.cusForLoyalityRes?.loyaltyPaymentAllowed ?? true;

    final _isSpByItemNoItemSe = widget.payPro.paymentType ==
            PaymentType.SplitByItem &&
        !widget.payPro.setMenuList.any((a) => a.isSelected) &&
        !widget.payPro.orderList.any((a) => a.isSelected) &&
        !widget.payPro.ingreList
            .any((a) => a.isSelected); // is split by item and no item selected

    final _disablePayOnSPlitAmt =
        widget.payPro.paymentType == PaymentType.PartialPayment &&
            widget.payPro.paidAmountCltr.text.inDouble == 0 &&
            (widget.payPro.remainingAmount ?? 0) > 0.01;

    final _disablePay = _disablePayOnSPlitAmt ||
        widget.payPro.totalPayableAmount == null ||
        widget.payPro.isItemUpdated ||
        (_isSpByItemNoItemSe &&
            !(widget.payPro.payOnZeroSplitByItem == true)) ||
        widget.payPro.loadingPay ||
        widget.payPro.loadingPayStk ||
        widget.payPro.updateOrderLoad ||
        (widget.payPro.getPayMethod == PayMethodEnum.Loyalty &&
            (widget.payPro.cusForLoyalityRes?.eligibleAmount.inDouble ?? 0) <=
                0);

//     print("""_disablePay: $_disablePay
// _disablePayOnSPlitAmt: $_disablePayOnSPlitAmt
//    totalPayableAmount: ${widget.payPro.totalPayableAmount}
//    isItemUpdated: ${widget.payPro.isItemUpdated}
//    _isSpByItemNoItemSe: $_isSpByItemNoItemSe
//   payOnZeroSplitByItem: ${widget.payPro.payOnZeroSplitByItem}
//    loadingPay: ${widget.payPro.loadingPay}
//    loadingPayStk: ${widget.payPro.loadingPayStk}
//       updateOrderLoad: ${widget.payPro.updateOrderLoad}
//         """);

    return Processing(
      loading: widget.payPro.loading,
      backColor: Colors.white,
      child: Container(
        color: kBackgroundColor,
        padding: EdgeInsets.symmetric(horizontal: size.getW(16)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.payPro.onPayScreenFor == OnPayScreenFor.Refund
                          ? LN.refundPay
                          : LN.payment,
                      style: TextStyle(
                        fontSize: size.getS(20),
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    // if (widget.payPro.orderDetailById?.orderDetailsViewModel
                    //         ?.orderType?.isNotEmpty ??
                    //     false)
                    //   Container(
                    //     padding: EdgeInsets.symmetric(
                    //         horizontal: size.getW(8), vertical: size.getH(4)),
                    //     decoration: BoxDecoration(
                    //         color: Colors.grey,
                    //         borderRadius: BorderRadius.circular(5)),
                    //     child: Text(
                    //       widget.payPro.orderDetailById?.orderDetailsViewModel
                    //               ?.orderType ??
                    //           '',
                    //       style: TextStyle(
                    //         fontSize: size.getS(12),
                    //         color: Colors.white,
                    //         fontWeight: FontWeight.bold,
                    //       ),
                    //     ),
                    //   ),
                  ],
                ),
                // if (widget.payPro.onPayScreenFor != OnPayScreenFor.Refund)
                //   TextButton(
                //       onPressed: () {
                //         showAddCusDia(context);
                //       },
                //       child: Row(
                //         mainAxisAlignment: MainAxisAlignment.end,
                //         children: [
                //           Icon(
                //             Icons.add,
                //             color: kTempColor,
                //             size: size.getS(24),
                //           ),
                //           Text(LN.addCustomer,
                //               style: TextStyle(
                //                 fontSize: size.getS(16),
                //                 color: kTempColor,
                //                 fontFamily: kFontFMedium,
                //               )),
                //         ],
                //       )),
                if (widget.payPro.orderDetailById?.orderDetailsViewModel
                        ?.orderType?.isNotEmpty ??
                    false)
                  Container(
                    padding: EdgeInsets.symmetric(
                        horizontal: size.getW(8), vertical: size.getH(4)),
                    decoration: BoxDecoration(
                        color: kSecondaryColor,
                        borderRadius: BorderRadius.circular(5)),
                    child: Text(
                      widget.payPro.orderDetailById?.orderDetailsViewModel
                              ?.orderType ??
                          '',
                      style: TextStyle(
                        fontSize: size.getS(14),
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
              ],
            ),
            Divider(
              color: Colors.black38,
              thickness: 1,
            ),
            Flexible(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      controller: _scrollCltr,
                      physics: BouncingScrollPhysics(),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (widget.payPro.paySecListRes?.paymentMethods
                                  ?.isNotEmpty ??
                              false)
                            Row(
                              children: [
                                ...List.generate(
                                    widget.payPro.paySecListRes!.paymentMethods!
                                        .length, (index) {
                                  final _payMethod = PayMethodClass.getMethod(
                                      widget.payPro.paySecListRes!
                                          .paymentMethods![index].name);

                                  if (widget.payPro.onPayScreenFor ==
                                              OnPayScreenFor.Refund &&
                                          _payMethod != PayMethodEnum.Cash &&
                                          _payMethod != PayMethodEnum.FPOS
                                      // &&
                                      // _payMethod != PayMethodEnum.Bank
                                      ) {
                                    return SizedBox.shrink();
                                  } else
                                    return Expanded(
                                      child: CardButton(
                                        title: widget.payPro.paySecListRes!
                                                .paymentMethods![index].name ??
                                            '',
                                        tileColor: TileColor.getColor(
                                          backColor: widget
                                              .payPro
                                              .paySecListRes!
                                              .paymentMethods![index]
                                              .defaultBackGroundColor,
                                          textColor: widget
                                              .payPro
                                              .paySecListRes!
                                              .paymentMethods![index]
                                              .defaultTextColor,
                                          selectedBackColor: widget
                                              .payPro
                                              .paySecListRes!
                                              .paymentMethods![index]
                                              .onFocusBackGroundColor,
                                          selectedTextColor: widget
                                              .payPro
                                              .paySecListRes!
                                              .paymentMethods![index]
                                              .onFocusTextColor,
                                        ),
                                        // imgPath: widget.payPro.paySecListRes!
                                        //     .paymentMethods![index].image,
                                        onTap: (_payMethod ==
                                                        PayMethodEnum.Loyalty &&
                                                    !_isLoyaltyPayEnable) ||
                                                widget.payPro.updateOrderLoad
                                            ? null
                                            : () => onTapPayMethod(
                                                index, _payMethod),
                                        isSelected: widget
                                                .payPro
                                                .paySecListRes!
                                                .paymentMethods![index]
                                                .isSelected ??
                                            false,
                                      ),
                                    );
                                }),
                              ],
                            ),
                          SizedBox(
                            height: size.getH(8.0),
                          ),
                          // Divider(
                          //   color: Colors.black,
                          //   thickness: 1,
                          // ),
                          if (widget.payPro.onPayScreenFor ==
                              OnPayScreenFor.Refund)
                            RefundSection(
                              size: size,
                              payPro: widget.payPro,
                              formKey: widget.formKey,
                              payNow: widget.payNow,
                              eftReturnValue: widget.eftReturnValue,
                            )
                          else ...[
                            // SizedBox(
                            //   height: size.getH(12),
                            // ),
                            UniqueNumSec(
                              focusNode: focus1,
                              size: size,
                              payPro: widget.payPro,
                            ),
                            // CusLoyalitySec(
                            //   focusNode: focus2,
                            //   size: size,
                            //   payPro: widget.payPro,
                            //   // onEdit: () {
                            //   //   // payPro.customerTypeIndex = payPro.cusForLoyalityRes!.
                            //   //   widget.payPro.cusNameCltr.text = widget.payPro
                            //   //           .cusForLoyalityRes!.customerName ??
                            //   //       '';
                            //   //   // payPro.cusEmailCltr.text = "";
                            //   //   widget.payPro.cusPhoneCltr.text = widget.payPro
                            //   //           .cusForLoyalityRes!.phoneNumber ??
                            //   //       '';
                            //   //   // payPro.recieveMarketMat = ;
                            //   //   widget.payPro.loyalityEnable = widget.payPro
                            //   //           .cusForLoyalityRes!.loyaltyEnabled ??
                            //   //       false;
                            //   //   widget.payPro.notify;
                            //   //   showAddCusDia(context);
                            //   // },
                            // ),
                            // if (widget.payPro.PAY_METHOD ==
                            //     PayMethodEnum.Stripe) ...[
                            //   CreditCardSection(
                            //     paymentPro: widget.payPro,
                            //   ),
                            //   SizedBox(
                            //     height: size.getH(8),
                            //   ),
                            // ],

                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 4),
                              child: Card(
                                margin: EdgeInsets.zero,
                                color: Colors.white,
                                // shape: RoundedRectangleBorder(
                                //     borderRadius: BorderRadius.circular(10)),
                                shape: RoundedRectangleBorder(
                                    side: BorderSide(color: Colors.black45),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10))),
                                child: SizedBox(
                                  child: PayMethod(
                                    paymentPro: widget.payPro,
                                    // onTapPay: widget.payPro
                                    //                 .totalPayableAmount ==
                                    //             null ||
                                    //         widget.payPro.isItemUpdated ||
                                    //         widget.payPro.loadingPay ||
                                    //         widget.payPro.loadingPayStk ||
                                    //         widget.payPro.updateOrderLoad ||
                                    //         ((double.tryParse(widget
                                    //                         .payPro
                                    //                         .paidAmountCltr
                                    //                         .text) ==
                                    //                     0 ||
                                    //                 widget.payPro.getAllAmount
                                    //                         .totalPrice ==
                                    //                     0) &&
                                    //             (double.tryParse(widget
                                    //                         .payPro
                                    //                         .discountPercentCltr
                                    //                         .text) ??
                                    //                     0) <
                                    //                 100)
                                    //     ? null
                                    //     : (bool isStk) =>
                                    //         _onPay(context, isSendToKit: isStk),
                                    // onPrint: widget.payPro.loadReceiptPay ||
                                    //         widget.payPro.isItemUpdated ||
                                    //         widget.payPro.updateOrderLoad
                                    //     ? null
                                    //     : () => _onPrint(context),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: size.getH(8),
                            ),
                            Padding(
                              padding: EdgeInsets.all(size.getS(4.0)),
                              child: TextFormWidget(
                                cltr: widget.payPro.commentCltr,
                                hintText: '',
                                labelText: LN.comments,
                                borderColor: Colors.black38,
                                borderRadius: 10,
                                maxLines: 5,
                                textInputType: TextInputType.text,
                                isReq: false,
                              ),
                            ),
                            // TextFWTWidget(
                            //   textCltr: widget.payPro.commentCltr,
                            //   title: LN.comments,
                            //   hintText: "",
                            //   inputType: TextInputType.text,
                            //   isReq: false,
                            //   titleFontWeight: FontWeight.normal,
                            //   maxLines: 4,
                            //   minLines: 1,
                            // ),
                          ]
                        ],
                      ),
                    ),
                  ),
                  if (widget.payPro.onPayScreenFor == OnPayScreenFor.Payment)
                    PayMethod.buttons(
                      size,
                      loadingPay: widget.payPro.loadingPay,
                      loadingPayStk: widget.payPro.loadingPayStk,
                      onTapPay: _disablePay
                          // (
                          // (double.tryParse(
                          //           widget.payPro.paidAmountCltr.text) ==
                          //       0
                          //     ||
                          // widget.payPro.getAllAmount.totalPrice ==
                          //     0
                          // ) &&
                          // (double.tryParse(widget.payPro
                          //             .discountPercentCltr.text) ??
                          //         0) <
                          //     100) ||

                          ? null
                          : (bool isStk) => _onPay(context, isSendToKit: isStk),
                      onPrint: widget.payPro.loadReceiptPay ||
                              widget.payPro.isItemUpdated ||
                              widget.payPro.updateOrderLoad
                          ? null
                          : () => _onPrint(context),
                    )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
