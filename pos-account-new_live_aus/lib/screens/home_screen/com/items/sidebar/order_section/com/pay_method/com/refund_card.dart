import 'package:flutter/material.dart';
import 'package:pos_account/config/size_config.dart';
import 'package:pos_account/config/utils/order_utils.dart';
import 'package:pos_account/config/utils/utils.dart';
import 'package:pos_account/config/validator.dart';
import 'package:pos_account/constant/constant.dart';
import 'package:pos_account/ln.dart';
import 'package:pos_account/model/ui_model/amount_class.dart';
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
import 'package:pos_account/services/printer/com/refund_print.dart';
import 'package:pos_account/widgets/input/text_form/text_fwtw.dart';
import 'package:pos_account/widgets/loading.dart';
import 'package:provider/provider.dart';
import 'choose_eft_pay_dia.dart';

class RefundSection extends StatefulWidget {
  final Ssize size;
  final PaymentPro payPro;
  final GlobalKey<FormState>? formKey;
  final Function(PaySummary?)? payNow;
  final EFTReturnValue? eftReturnValue;
  const RefundSection({
    super.key,
    required this.size,
    required this.payPro,
    this.formKey,
    this.payNow,
    this.eftReturnValue,
  });

  @override
  State<RefundSection> createState() => _RefundSectionState();
}

class _RefundSectionState extends State<RefundSection> {
  Future<void> _refund(BuildContext context,
      {required AmountClass amountClass}) async {
    final amount = amountClass.totalPrice.nonNan();
    if (widget.formKey?.currentState == null ||
        !widget.formKey!.currentState!.validate()) {
      return;
    }

    final double _phSurchargeAmountValue =
        widget.payPro.isCheckPubHoCharge ? amountClass.pHSurCharge : 0.0;

    final double _ccSurchargeAmountValue =
        widget.payPro.isCheckCreCarCharge ? amountClass.ccSurCharge : 0.0;

    final double _serviceChargeAmountValue =
        widget.payPro.isCheckServiceCharge ? amountClass.serviceCharge : 0.0;

    EFTReturnValue? eftValue;

    // TODO: EFTPOS setup: remove comment to make it work

    //
    if (GlobalCVP.eftPosEnable && _isEFTPOSPayment) {
      // choose pay method
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
              totalAmount: amount,
              // surAmount: _surchargeAmountValue,
              mxPayType: MxPayType.Refund,
              orderId:
                  widget.payPro.orderDetailById?.orderDetailsViewModel?.orderId,
            ));

        if (_mxRes == null) {
          return;
        }

        eftValue = EFTReturnValue(
          refId: _mxRes.data?.id,
          merchantReceipt: _mxRes.data?.merchantReceipt,
          customerReceipt: _mxRes.data?.customerReceipt,
          merchantType: EftPayMethod.Mx51.name,
          serialNumber: _mxRes.terminal?.serialNumber,
          terminalId: _mxRes.terminal?.id,
          merchantSurcharge:
              (_mxRes.data?.resultAmounts?.surchargeAmount ?? 0) / 100,
        );

        // final _terminalData = _mx
        //     ?.map((e) => MxPairModel(
        //           posId: e.name,
        //           serialNumber: e.serialNumber,
        //           isDefault: e.isDefault,
        //         ).toJson())
        //     .toList();

        // _eftValue = await EFTPayment.eftPayDiaLog(
        //   context,
        //   payUrl:
        //       "${AppEnviro.eftposPay}?amount=$_amount&transactionType=REFUND_TRANSACTION&terminals=${Utils.encodebase64(_terminalData)}",
        //   orderId: widget.payPro.orderId,
        // );

        // _eftValue?.terminalId = (_mx
        //             ?.any((e) => e.serialNumber == _eftValue?.serialNumber) ??
        //         false)
        //     ? _mx
        //         ?.firstWhere((e) => e.serialNumber == _eftValue?.serialNumber)
        //         .id
        //     : null;

        // if (_eftValue == null)
        //   return;
        // else if (_eftValue.refId?.isNotEmpty ?? false) {
        //   DbLocalData.updateRefundRequestData();
        // }
      } else if (_eftMethod == EftPayMethod.VisionPay) {
        //   final _res = await VisionPayEftDia.showDia(context,
        //       amount: _amount, type: VisionPayType.Refund);

        //   if (_res != null) {
        //     _eftValue = EFTReturnValue(
        //       refId: _res.externalReference,
        //       // merchantReceipt: json.encode(_res.toJson()),
        //       merchantType: Strings.visionMerchant,
        //  serialNumber:
        //             "${USBServiceEFt.connectedUsb?.productName}:${USBServiceEFt.connectedUsb?.pid}"
        //     );
        //   } else {
        //     return;
        //   }
      } else if (_eftMethod == EftPayMethod.WindcavePay) {
        final payDetails = widget
            .payPro
            .orderDetailById
            ?.orderPaymentDetailsWithPaymentStatusViewModel
            ?.orderPaymentsDetailsViewModels;
        final itemTotalWithoutTax = widget.payPro.orderDetailById
                ?.orderDetailsViewModel?.totalWithoutTaxAmount?.inDouble ??
            0;

        final isMatchRefund = widget.payPro.orderDetailById
                    ?.orderDetailsViewModel?.eftPosMerchantType ==
                EftPayMethod.WindcavePay.name &&
            (payDetails?.isNotEmpty ?? false) &&
            payDetails!.length == 1 &&
            (amountClass.finalItemPriceWithOutTax - itemTotalWithoutTax)
                    .abs() <=
                0.02;

        // print(
        //     "$_isMatchRefund =  ${amountClass.finalItemPriceWithOutTax} - $_itemTotalWithoutTax || ${_payDetails?.first.eftPosTransactionRefId?.split('-').last}");

        final dpsTaxRef = isMatchRefund
            ? payDetails.first.eftPosTransactionRefId?.split('-').last
            : null;

        final refId = Utils.getRandomString(15);

        double amtPurchase = widget.payPro.paidAmountCltr.text.inDouble +
            (_phSurchargeAmountValue +
                _ccSurchargeAmountValue +
                _serviceChargeAmountValue) +
            widget.payPro.tipCltr.text.inDouble;

        if (widget.payPro.paymentType == PaymentType.PartialPayment &&
            widget.payPro.isSplitPerPerson) {
          amtPurchase = widget.payPro.readOnlyPaidAmount.inDouble;
        } else if (widget.payPro.isCompletePayAfterSplit) {
          amtPurchase = widget.payPro.remainingAmount!;
        }

        final storeDetail = GlobalCVP.currentStore;

        final req = WcTransactionReq(
          // user: WindcaveApi.username,
          // key: WindcaveApi.key,
          // station: await WindcaveApi.station,
          // cur: _storeDetail?.currencyCode ?? "AUD",
          // posName: "POSApt",
          amount: amtPurchase.roundToNString(),
          txnType: TxnType.Refund,
          txnRef: refId,
          deviceId: await SupportHandler.getDeviceId,
          vendorId: storeDetail?.storeId?.replaceAll('-', ''),
          mRef: storeDetail?.name,
          dpsTxnRef: dpsTaxRef,
        );

        final _status = await WindcaveEftPayDia.showDia(
          context,
          req: req,
          type: WindcavePayType.Refund,
          terminal: _wind,
          orderId:
              widget.payPro.orderDetailById?.orderDetailsViewModel?.orderId,
        );
        EFTPayment.sendWindCaveLog(
            orderId:
                widget.payPro.orderDetailById?.orderDetailsViewModel?.orderId);

        if (_status != null) {
          // final _eftPro = Provider.of<EftPro>(context, listen: false);
          eftValue = EFTReturnValue(
            refId: refId,
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
        return;
      }
    }

    // log("RefID:  $_refID");

    _refundSum = PaySummary(
      paidAmountByUser: widget.payPro.amountPaidByUserCltr.text,
      payMethod: widget.payPro.PAY_METHOD ?? PayMethodEnum.None,
      totalAmount: widget.payPro.payableAmount.formatDouble,
    );

    widget.payPro.refundPayment(eftValue: eftValue).then((_) {
      eftPro.removePayReqData('_refund');
      eftPro.removeRefundReqData();
      setDataOnRefund();
    });
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

  PaySummary? _refundSum;

  late EftPro eftPro;

  @override
  void initState() {
    super.initState();

    eftPro = Provider.of<EftPro>(context, listen: false);
    if (GlobalCVP.eftPosEnable && GlobalCVP.recoverEftPOSEnable)
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        if (widget.eftReturnValue?.refId?.isNotEmpty ?? false) {
          _eftPendingRefund(eftReturnValue: widget.eftReturnValue);
        }
        _listenRefundRecover();
      });
  }

  void _listenRefundRecover() {
    int i = 0;
    widget.payPro.addListener(() async {
      // log("Oorder ID time to update--------------${widget.payPro.doPayOrRefundFlag}----------------$i");

      if (i == 0 && widget.payPro.doPayOrRefundFlag == "do_refund_recover") {
        // log("Refund recovery------------------------------");
        widget.payPro.doPayOrRefundFlag = null;
        i++;
        widget.payPro.notify;
        if (widget.payPro.eftReturnValue?.refId?.isNotEmpty ?? false) {
          await _eftPendingRefund(eftReturnValue: widget.payPro.eftReturnValue);
        }
      }
    });
  }

  Future<void> _eftPendingRefund({
    required EFTReturnValue? eftReturnValue,
  }) async {
    if (widget.payPro.onPayScreenFor == OnPayScreenFor.Refund) {
      widget.payPro.loadingPay = true;
      widget.payPro.notify;
      await Future.delayed(Duration(seconds: 1), () {});

      final _status = await widget.payPro.refundPayment(
        eftValue: eftReturnValue,
        isEftIncomplete: true,
      );
      if (_status == null) return;

      eftPro.removePayReqData('_eftPendingRefund');
      eftPro.removeRefundReqData();

      _refundSum = PaySummary(
        paidAmountByUser: widget.payPro.amountPaidByUserCltr.text,
        payMethod: widget.payPro.PAY_METHOD ?? PayMethodEnum.None,
        totalAmount: (widget.payPro.refundPaymentRes
                    ?.printingRefundDetailsResponseViewModels?.isNotEmpty ??
                false)
            ? (widget
                    .payPro
                    .refundPaymentRes
                    ?.printingRefundDetailsResponseViewModels
                    ?.first
                    .totalAmount ??
                "")
            : widget.payPro.payableAmount.formatDouble,
      );

      setDataOnRefund();
    }
  }

  void setDataOnRefund() {
    if (widget.payPro.refundPaymentRes == null) return;

    final ctx = mounted ? context : CUS_CTX!;

    if (widget.payPro.refundPaymentRes!
                .printingRefundDetailsResponseViewModels ==
            null ||
        widget.payPro.refundPaymentRes!.printingRefundDetailsResponseViewModels!
            .isEmpty) {
      // showToast(widget.payPro.refundPaymentRes?.message ?? '');
      Navigator.of(ctx).pop();
    } else {
      final invoicePro = Provider.of<InvoicePro>(ctx, listen: false);
      // get model invoice to show print reciept on screen after payment
      invoicePro.printInvoice = RefundPrint.cRefundInvoice(
        widget.payPro.refundPaymentRes!.printingRefundDetailsResponseViewModels!
            .first,
        curSym: widget.payPro.curSym ?? '',
        url: widget.payPro.refundPaymentRes!.url,
      );

      invoicePro.invoiceType = InvoiceType.Refund;

      if (widget.payNow != null) widget.payNow!(_refundSum);
    }
  }

  @override
  Widget build(BuildContext context) {
    final amountClass = widget.payPro.getAllAmount;
    final price = amountClass.totalPrice.nonNan();

    return Processing(
      loading: widget.payPro.refundLoad,
      child: Card(
        color: kPrimaryColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: SizedBox(
          width: double.infinity,
          child: Padding(
            padding: EdgeInsets.symmetric(
                vertical: widget.size.getH(8.0),
                horizontal: widget.size.getW(12)),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFWTWidget(
                  textCltr: (!widget.payPro.isCheckCreCarCharge &&
                          !widget.payPro.isCheckPubHoCharge)
                      ? widget.payPro.refundTextCltr
                      : TextEditingController(text: price.roundToNString()),
                  readOnly: true,
                  fillColor: Colors.grey.shade300,
                  title: LN.refundAmt,
                  titleColor: Colors.white,
                  hintText: LN.refundAmt,
                  inputType: TextInputType.number,
                  autoValidation: true,
                  // onChanged: (val) {},
                  prefix: Text(
                    "${widget.payPro.curSym ?? ''} ",
                    style: TextStyle(
                      fontSize: widget.size.getS(16),
                      color: Colors.black,
                      fontFamily: kFontFMedium,
                    ),
                  ),
                  validator: (p0) {
                    if (p0 == null || p0.isEmpty) return LN.fieldEmpty;
                    if (double.tryParse(p0) == null) {
                      return LN.invalidAmt;
                    }
                    final _val = double.parse(p0);
                    if (double.parse(price.roundToNString()) < _val) {
                      return LN.amtExtsive;
                    }
                    return null;
                  },
                ),
                SizedBox(
                  height: widget.size.getH(16),
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: widget.size.getH(12)),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            // "Refundable Amount",
                            LN.refundAmt,
                            style: TextStyle(
                              fontSize: widget.size.getS(18),
                              color: Colors.white,
                              fontFamily: kFontFMedium,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: Text(
                            "${widget.payPro.curSym}${price.roundToNString()}",
                            style: TextStyle(
                              fontSize: widget.size.getS(18),
                              color: Colors.white,
                              fontFamily: kFontFMedium,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: widget.size.getH(16),
                ),
                Center(
                  child: SizedBox(
                    width: widget.size.getW(148),
                    child: ElevatedButton(
                        style: ButtonStyle(
                            backgroundColor: WidgetStateProperty.all(
                                widget.payPro.refundLoad || price == 0
                                    ? Colors.grey.shade400
                                    : Colors.amber.shade400),
                            padding: WidgetStateProperty.all(
                                EdgeInsets.symmetric(
                                    horizontal: widget.size.getW(8),
                                    vertical: widget.size.getH(12)))),
                        onPressed: widget.payPro.refundLoad || price == 0
                            ? null
                            : () => _refund(context, amountClass: amountClass),
                        child: Text(
                          LN.refund,
                          style: TextStyle(
                            fontSize: widget.size.getS(16),
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        )),
                  ),
                ),
                SizedBox(
                  height: widget.size.getH(16),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
