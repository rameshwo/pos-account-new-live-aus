import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pos_account/config/size_config.dart';
import 'package:pos_account/config/utils/order_utils.dart';
import 'package:pos_account/config/validator.dart';
import 'package:pos_account/constant/constant.dart';
import 'package:pos_account/constant/text_formatter.dart';
import 'package:pos_account/ln.dart';
import 'package:pos_account/providers/cus_val_pro.dart';
import 'package:pos_account/providers/menu/payment_pro.dart';
import 'package:pos_account/screens/home_screen/com/items/com/price_update_dia.dart';
import 'package:pos_account/screens/home_screen/com/items/sidebar/order_section/com/pay_method/com/cash_tab_section.dart';
import 'package:pos_account/widgets/input/text_form/text_form_widget.dart';
import 'package:pos_account/widgets/loading.dart';
import 'package:pos_account/widgets/input/text_form/text_fwtw.dart';

class PayMethod extends StatelessWidget {
  final void Function(bool)? onTapPay;
  final Function()? onPrint;
  final PaymentPro paymentPro;
  const PayMethod({
    super.key,
    this.onTapPay,
    required this.paymentPro,
    this.onPrint,
  });

  _TitleBody _returnSection() {
    final _returnAmount =
        (double.tryParse(paymentPro.amountPaidByUserCltr.text) ?? 0.0) -
            paymentPro.payableAmount;
    return _TitleBody(
      title: "Change to Customer",
      color: Colors.black,
      body: (paymentPro.curSym ?? '') +
          (_returnAmount <= 0 ? "0.00" : _returnAmount.roundToNString()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = Ssize(context);
    final amtDetail = <_TitleBody>[
      _TitleBody(
          title: "Final Payable Amount",
          subTitle:
              paymentPro.isCheckPubHoCharge || paymentPro.isCheckCreCarCharge
                  ? "\n* (Surcharges applied)"
                  : null,
          color: Colors.black,
          body: (paymentPro.curSym ?? '') +
              paymentPro.payableAmount.roundToNString()),
      if (paymentPro.remainingAmount != null && paymentPro.remainingAmount != 0)
        _TitleBody(
            title: LN.remainAmt,
            color: Colors.black,
            body: (paymentPro.curSym ?? '') +
                (paymentPro.remainingAmount! +
                        (double.tryParse(paymentPro.tipCltr.text) ?? 0))
                    .roundToNString()),
      if (paymentPro.PAY_METHOD == PayMethodEnum.Cash) _returnSection(),
    ];

    final _hasPaidOnce = (paymentPro.remainingAmount ?? 0) != 0 &&
        paymentPro.onPayScreenFor == OnPayScreenFor.Payment;

    return SizedBox(
      width: double.infinity,
      child: Padding(
        padding: EdgeInsets.symmetric(
            vertical: size.getH(8.0), horizontal: size.getW(12)),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (paymentPro.PAY_METHOD == PayMethodEnum.Cash) ...[
              if (paymentPro.paySecListRes?.availiableCurrencies != null &&
                  paymentPro.paySecListRes!.availiableCurrencies!.isNotEmpty)
                CashTabSection(
                  availiableCurrencies:
                      paymentPro.paySecListRes?.availiableCurrencies,
                  cashIndex: paymentPro.cashIndex,
                  onTapCash: (index) {
                    paymentPro.amountPaidByUser = paymentPro
                        .paySecListRes!.availiableCurrencies![index].value!;
                    paymentPro.setCashIndex = index;
                    paymentPro.keyPadValue = paymentPro
                        .paySecListRes!.availiableCurrencies![index].value!;
                    paymentPro.focusKeyPad = FocusKeyPad.PaidByUser;
                    paymentPro.notify;
                  },
                ),
              TextFWTWidget(
                // focusNode: paymentPro.focusNode1,
                textCltr: paymentPro.amountPaidByUserCltr,
                title: "Amount to be Paid By Customer",
                hintText: "0.00",
                autoValidation: true,
                inputType: TextInputType.number,
                readOnly: true,
                onTap: () async {
                  // paymentPro.focusKeyPad = FocusKeyPad.PaidByUser;
                  // paymentPro.keyPadValue = paymentPro.amountPaidByUserCltr.text;
                  final val = await PriceUpdateDia.showDia(
                    context,
                    number: paymentPro.amountPaidByUserCltr.text.inDouble,
                    title: LN.amountPaid,
                  );
                  paymentPro.amountPaidByUserCltr.text = val.roundToNString();
                  paymentPro.cashIndex = null;
                  paymentPro.notify;
                },
                isReq: true,
                prefix: Text(
                  "${paymentPro.curSym ?? ''} ",
                  style: TextStyle(
                    fontSize: size.getS(16),
                    color: Colors.black,
                    fontFamily: kFontFMedium,
                  ),
                ),
                validator: (p0) {
                  if (paymentPro.loading) return null;

                  if (p0 == null || p0.isEmpty) return LN.fieldEmpty;
                  if (double.tryParse(p0) == null) {
                    return LN.invalidAmt;
                  }
                  final val = double.parse(p0);
                  if (val < paymentPro.payableAmount.roundToN()) {
                    return LN.insufficientAmount;
                  }
                  return null;
                },
              ),
            ],

            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: //!paymentPro.isCheckCreCarCharge &&
                      !paymentPro.isSplitPayFinal &&
                              // !paymentPro.isCheckPubHoCharge &&
                              paymentPro.paymentType ==
                                  PaymentType.PartialPayment &&
                              // !paymentPro.isCompletePayAfterSplit &&
                              !paymentPro.isSplitPerPerson
                          ? TextFWTWidget(
                              readOnly: true,
                              // focusNode: paymentPro.focusNode2,
                              //  paymentPro.paymentType !=
                              //     PaymentType.PartialPayment,
                              onTap: paymentPro.paymentType !=
                                      PaymentType.PartialPayment
                                  ? null
                                  : () async {
                                      // if (paymentPro.PAY_METHOD ==
                                      //     PayMethodEnum.Cash) {
                                      //   paymentPro.focusKeyPad =
                                      //       FocusKeyPad.PaidAmount;
                                      //   paymentPro.keyPadValue =
                                      //       paymentPro.paidAmountCltr.text;
                                      //   paymentPro.notify;
                                      // } else {
                                      final val = await PriceUpdateDia.showDia(
                                        context,
                                        number: paymentPro
                                            .paidAmountCltr.text.inDouble,
                                        title: LN.paidAmount,
                                      );

                                      paymentPro.paidAmountCltr.text =
                                          val.roundToNString();

                                      paymentPro.onChangedPayAmount(
                                          isUpdatePaidAmount: false);
                                      // }
                                    },
                              fillColor: paymentPro.paymentType !=
                                      PaymentType.PartialPayment
                                  ? Colors.grey.shade300
                                  : Colors.white,
                              textCltr: paymentPro.paidAmountCltr,
                              title: "Enter Split Amount",
                              hintText: "0.00",
                              inputType: TextInputType.number,
                              autoValidation: true,
                              // suffixIcon: paymentPro.paymentType ==
                              //         PaymentType.PartialPayment
                              //     ? InkWell(
                              //         onTap: () {
                              //           paymentPro.paidAmountCltr.clear();
                              //           // paymentPro.paidAmountDouble = 0;
                              //         },
                              //         child: Icon(
                              //           Icons.close,
                              //           size: size.getS(28),
                              //         ),
                              //       )
                              //     : null,

                              onChanged: (val) {
                                // paymentPro.paidAmountDouble =
                                //     double.tryParse(val ?? '') ?? 0;
                                paymentPro.onChangedPayAmount(
                                    isUpdatePaidAmount: false);
                              },
                              prefix: Text(
                                "${paymentPro.curSym ?? ''} ",
                                style: TextStyle(
                                  fontSize: size.getS(16),
                                  color: Colors.black,
                                  fontFamily: kFontFMedium,
                                ),
                              ),
                              validator: (p0) {
                                if (p0 == null || p0.isEmpty)
                                  return LN.fieldEmpty;

                                final _val = double.tryParse(p0);
                                if (_val == null) {
                                  return LN.invalidAmt;
                                }

                                if (paymentPro.uniByPayRes?.amount != null) {
                                  final _amt = double.tryParse(
                                          paymentPro.uniByPayRes!.amount!) ??
                                      0;
                                  if (_val.toStringAsFixed(1) !=
                                          _amt.toStringAsFixed(1) &&
                                      _val > _amt) return LN.payAmtHigherGift;
                                }

                                if (paymentPro.remainingAmount == null) {
                                  if (_val.roundToN() >
                                      paymentPro.getAllAmount.totalPrice
                                          .roundToN())
                                    // if (_val.toStringAsFixed(1) !=
                                    //         (paymentPro.totalPayableAmount ?? 0)
                                    //             .toStringAsFixed(1) &&
                                    //     _val > (paymentPro.totalPayableAmount ?? 0))
                                    return LN.amtExtsive;
                                } else {
                                  if (_val.toStringAsFixed(1) !=
                                          (paymentPro.remainingAmount ?? 0)
                                              .toStringAsFixed(1) &&
                                      _val >
                                          ((paymentPro.remainingAmount ?? 0)))
                                    return LN.amtExtsive;
                                }
                                return null;
                              },
                            )
                          : TextFWTWidget(
                              readOnly: true,
                              fillColor: Colors.grey.shade300,
                              textCltr: TextEditingController(
                                  text: paymentPro.readOnlyPaidAmount),
                              title: "Total Amount",
                              hintText: "0.00",
                              prefix: Text(
                                "${paymentPro.curSym ?? ''} ",
                                style: TextStyle(
                                  fontSize: size.getS(16),
                                  color: Colors.black,
                                  fontFamily: kFontFMedium,
                                ),
                              ),
                            ),
                ),
                // if (paymentPro.getPayMethod != PayMethodEnum.Loyalty) ...[
                SizedBox(
                  width: size.getW(12),
                ),
                Expanded(
                  child: TextFWTWidget(
                    // focusNode: paymentPro.focusNode3,
                    textCltr: paymentPro.tipCltr,
                    readOnly: true,
                    onTap: paymentPro.getPayMethod == PayMethodEnum.Loyalty
                        ? null
                        : () async {
                            // if (paymentPro.PAY_METHOD == PayMethodEnum.Cash) {
                            //   paymentPro.focusKeyPad = FocusKeyPad.TipAmount;
                            //   paymentPro.keyPadValue = paymentPro.tipCltr.text;
                            //   paymentPro.notify;
                            // } else {
                            final val = await PriceUpdateDia.showDia(
                              context,
                              number: paymentPro.tipCltr.text.inDouble,
                              title: LN.tipAmount,
                            );

                            paymentPro.tipCltr.text = val.roundToNString();
                            paymentPro.onChangedPayAmount(
                                isUpdatePaidAmount: false);
                            // }
                          },
                    fillColor: paymentPro.getPayMethod == PayMethodEnum.Loyalty
                        ? Colors.grey.shade300
                        : Colors.white,
                    title: LN.tipAmount,
                    hintText: "0.00",
                    inputType: TextInputType.number,
                    onChanged: (val) {
                      paymentPro.onChangedPayAmount(isUpdatePaidAmount: false);
                    },
                    isReq: false,
                    prefix: Text(
                      "${paymentPro.curSym ?? ''} ",
                      style: TextStyle(
                        fontSize: size.getS(16),
                        color: Colors.black,
                        fontFamily: kFontFMedium,
                      ),
                    ),
                  ),
                )
                // ],
              ],
            ),
            if (paymentPro.paymentType == PaymentType.PartialPayment &&
                (!_hasPaidOnce ||
                    (_hasPaidOnce && paymentPro.isSplitPerPerson)))
              Padding(
                padding: EdgeInsets.only(top: size.getH(4)),
                child: Row(
                  children: [
                    _disableSection(
                      readOnly: _hasPaidOnce,
                      child: Row(
                        children: [
                          Transform.scale(
                            scale: 1.2,
                            child: Checkbox(
                                visualDensity: VisualDensity.compact,
                                // fillColor:
                                //     MaterialStateProperty.all(kSecondaryColor),
                                checkColor: Colors.white,
                                value: paymentPro.isSplitPerPerson,
                                onChanged: (bool? val) {
                                  if (val == null) return;

                                  paymentPro.isSplitPerPerson = val;
                                  paymentPro.onChangedPayAmount(
                                      isUpdatePaidAmount: false);
                                  paymentPro.notify;
                                }),
                          ),
                          InkWell(
                            onTap: () {
                              paymentPro.isSplitPerPerson =
                                  !paymentPro.isSplitPerPerson;
                              paymentPro.onChangedPayAmount(
                                  isUpdatePaidAmount: false);
                              paymentPro.notify;
                            },
                            child: Text(
                              "Split amount per person",
                              style: TextStyle(
                                fontSize: size.getS(18),
                                fontFamily: kFontFMedium,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: size.getW(10)),
                    if (paymentPro.isSplitPerPerson)
                      SizedBox(
                        width: size.getW(60),
                        child: TextFormWidget(
                          // focusNode: paymentPro.focusNode4,
                          borderRadius: 5,
                          borderColor: Colors.black12,
                          isReq: true,
                          readOnly: true,
                          initValidate: true,
                          fillColor: kBackgroundColor,
                          cltr: paymentPro.splitPerPersonCltr,
                          hintText: "1",
                          textInputType: TextInputType.number,
                          inputFormatters: [
                            NonNegativeTextInputFormatter(),
                            FilteringTextInputFormatter.digitsOnly
                          ],
                          onTap: () async {
                            // if (paymentPro.PAY_METHOD ==
                            //     PayMethodEnum.Cash) {
                            //   paymentPro.focusKeyPad = FocusKeyPad.NoOfUser;
                            //   paymentPro.keyPadValue =
                            //       paymentPro.splitPerPersonCltr.text;
                            //   paymentPro.notify;
                            // } else {
                            final val = await PriceUpdateDia.showDia<int>(
                              context,
                              number:
                                  paymentPro.splitPerPersonCltr.text.inDouble,
                              title: LN.tipAmount,
                            );
                            if (val <= 0) return;

                            paymentPro.splitPerPersonCltr.text =
                                val.formatDouble;
                            paymentPro.onChangedPayAmount(
                                isUpdatePaidAmount: false);
                            paymentPro.notify;
                            // }
                          },
                          // onChanged: (_) {
                          //   paymentPro.onChangedPayAmount(
                          //       isUpdatePaidAmount: false);
                          //   paymentPro.notify;
                          // },
                          textAlign: TextAlign.center,
                          errH: 0,
                        ),
                      ),
                  ],
                ),
              )
            else if (_hasPaidOnce &&
                paymentPro.paymentType == PaymentType.PartialPayment)
              InkWell(
                onTap: () {
                  paymentPro.isSplitPayFinal = !paymentPro.isSplitPayFinal;
                  paymentPro.onChangedPayAmount(isUpdatePaidAmount: true);
                  paymentPro.notify;
                },
                child: Padding(
                  padding: EdgeInsets.only(top: size.getH(4)),
                  child: Row(
                    children: [
                      IgnorePointer(
                        ignoring: true,
                        child: Transform.scale(
                          scale: 1.2,
                          child: Checkbox(
                              visualDensity: VisualDensity.compact,
                              // fillColor:
                              //     MaterialStateProperty.all(kSecondaryColor),
                              checkColor: Colors.white,
                              value: paymentPro.isSplitPayFinal,
                              onChanged: (bool? val) {}),
                        ),
                      ),
                      Text(
                        "Pay remaining amount",
                        style: TextStyle(
                          fontSize: size.getS(18),
                          // color: Colors.white,
                          fontFamily: kFontFMedium,
                        ),
                      ),
                      SizedBox(width: size.getW(10)),
                    ],
                  ),
                ),
              ),
            // TextFWTWidget(
            //   textCltr: paymentPro.discountCltr,
            //   title: 'Discount Amount',
            //   hintText: "discount amount",
            //   inputType: TextInputType.number,
            //   onChanged: paymentPro.onChangedPayAmount,
            // ),
            // SizedBox(
            //   height: size.getH(4),
            // ),
            // Padding(
            //   padding: EdgeInsets.only(top: size.getH(4)),
            //   child: Row(
            //     children: [
            //       Checkbox(
            //           visualDensity: VisualDensity.compact,
            //           fillColor: WidgetStateProperty.all(Colors.white),
            //           checkColor: kSecondaryColor,
            //           value: paymentPro.isCheckPubHoCharge,
            //           onChanged: (bool? val) {
            //             if (val == null) return;
            //             paymentPro.isCheckPubHoCharge = val;
            //             paymentPro.onChangedPayAmount(
            //                 isUpdatePaidAmount: false);
            //           }),
            //       Text(
            //         LN.publicHolidaySc,
            //         style: TextStyle(
            //           fontSize: size.getS(16),
            //           color: Colors.white,
            //         ),
            //       ),
            //       if (paymentPro.isCheckPubHoCharge)
            //         Expanded(
            //           child: SizedBox(
            //             width: size.getW(102),
            //             child: Text(
            //               (paymentPro.curSym ?? '') +
            //                   paymentPro.getAllAmount.pHSurCharge
            //                       .roundToNString(),
            //               style: TextStyle(
            //                 fontSize: size.getS(16),
            //                 color: Colors.white,
            //                 fontFamily: kFontFMedium,
            //               ),
            //               textAlign: TextAlign.right,
            //             ),
            //           ),
            //         ),
            //     ],
            //   ),
            // ),
            // SizedBox(height: size.getH(4)),
            // Row(
            //   children: [
            //     Checkbox(
            //         visualDensity: VisualDensity.compact,
            //         fillColor: WidgetStateProperty.all(Colors.white),
            //         checkColor: kSecondaryColor,
            //         value: paymentPro.isCheckCreCarCharge,
            //         onChanged: (bool? val) {
            //           if (val == null) return;
            //           paymentPro.isCheckCreCarCharge = val;
            //           paymentPro.onChangedPayAmount(isUpdatePaidAmount: false);
            //         }),
            //     Text(
            //       "${LN.creditCardSc} ",
            //       style: TextStyle(
            //         fontSize: size.getS(16),
            //         color: Colors.white,
            //       ),
            //     ),
            //     SizedBox(
            //       width: size.getW(84),
            //       child: TextFormWidget(
            //         borderRadius: 5,
            //         borderColor: Colors.black12,
            //         isReq: true,
            //         initValidate: true,
            //         fillColor: kBackgroundColor,
            //         cltr: paymentPro.creCardCltr,
            //         hintText: "0",
            //         textInputType: TextInputType.number,
            //         inputFormatters: [Between0And100TextInputFormatter()],
            //         onChanged: (_) => paymentPro.onChangedPayAmount(
            //             isUpdatePaidAmount: false),
            //         textAlign: TextAlign.right,
            //         errH: 0,
            //         suffix: Text(
            //           "%",
            //           style: TextStyle(
            //             fontSize: size.getS(16),
            //             color: Colors.black,
            //             fontFamily: kFontFMedium,
            //           ),
            //         ),
            //         validator: (p0) {
            //           if (p0 == null || p0.isEmpty) return null;
            //           final _data = double.tryParse(p0);
            //           if (_data == null || _data > 100) {
            //             showToast(LN.invalidCardSurchargePer);
            //             return '';
            //           }
            //           return null;
            //         },
            //       ),
            //     ),
            //     if (paymentPro.isCheckCreCarCharge)
            //       Expanded(
            //         child: SizedBox(
            //           width: size.getW(102),
            //           child: Text(
            //             (paymentPro.curSym ?? '') +
            //                 paymentPro.getAllAmount.ccSurCharge
            //                     .roundToNString(),
            //             style: TextStyle(
            //               fontSize: size.getS(16),
            //               color: Colors.white,
            //               fontFamily: kFontFMedium,
            //             ),
            //             textAlign: TextAlign.right,
            //           ),
            //         ),
            //       ),
            //   ],
            // ),
            // SizedBox(height: size.getH(12)),

            // if (paymentPro.PAY_METHOD == PayMethodEnum.Cash &&
            //     (paymentPro.paySecListRes?.availiableCurrencies?.isNotEmpty ??
            //         false)) ...[
            //   CashTabSection(
            //     availiableCurrencies:
            //         paymentPro.paySecListRes?.availiableCurrencies,
            //     cashIndex: paymentPro.cashIndex,
            //     onTapCash: (index) {
            //       paymentPro.amountPaidByUser = paymentPro
            //           .paySecListRes!.availiableCurrencies![index].value!;
            //       paymentPro.setCashIndex = index;
            //       paymentPro.keyPadValue = paymentPro
            //           .paySecListRes!.availiableCurrencies![index].value!;
            //       paymentPro.focusKeyPad = FocusKeyPad.PaidByUser;
            //       paymentPro.notify;
            //     },
            //   ),
            //   SizedBox(height: size.getH(12))
            // ],
            // AnimatedContainer(
            //   duration: Duration(milliseconds: 300),
            //   height: paymentPro.PAY_METHOD == PayMethodEnum.Cash
            //       ? size.height * 0.30
            //       : 0,
            //   child: PriceUpdateDia<double>(
            //     // key: ValueKey(paymentPro.PAY_METHOD),
            //     value: paymentPro.keyPadValue,
            //     max: 100000000000000,
            //     property: PriceDiaProperty(
            //       isDia: false,
            //       isPayKeyPad: true,
            //       padding: 12,
            //       height: 50,
            //       fontSize: 28,
            //       onTap: (val) {
            //         if (paymentPro.focusKeyPad == FocusKeyPad.PaidByUser) {
            //           paymentPro.amountPaidByUserCltr.text = val;
            //           paymentPro.cashIndex = null;
            //         } else if (paymentPro.focusKeyPad ==
            //             FocusKeyPad.PaidAmount) {
            //           paymentPro.paidAmountCltr.text = val;
            //           paymentPro.onChangedPayAmount(isUpdatePaidAmount: false);
            //         } else if (paymentPro.focusKeyPad ==
            //             FocusKeyPad.TipAmount) {
            //           paymentPro.tipCltr.text = val;
            //           paymentPro.onChangedPayAmount(isUpdatePaidAmount: false);
            //         } else if (paymentPro.focusKeyPad == FocusKeyPad.NoOfUser) {
            //           paymentPro.splitPerPersonCltr.text =
            //               val.replaceAll('.', '').inDouble.formatDouble;
            //           paymentPro.onChangedPayAmount(isUpdatePaidAmount: false);
            //         }
            //         paymentPro.keyPadValue = val;

            //         paymentPro.notify;
            //       },
            //     ),
            //   ),
            // ),
            SizedBox(
              height: size.getH(16),
            ),
            ...List.generate(
                amtDetail.length,
                (index) => Padding(
                      padding: EdgeInsets.only(bottom: size.getH(12)),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            flex: 2,
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text.rich(
                                TextSpan(
                                    text: amtDetail[index].title,
                                    children: [
                                      if (amtDetail[index].subTitle != null)
                                        TextSpan(
                                          text: amtDetail[index].subTitle,
                                          style: TextStyle(
                                            fontSize: size.getS(14),
                                            color: Colors.red,
                                            fontFamily: kFontFMedium,
                                          ),
                                        ),
                                    ]),
                                style: TextStyle(
                                  fontSize: size.getS(18),
                                  color: amtDetail[index].color ?? Colors.white,
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
                                amtDetail[index].body,
                                style: TextStyle(
                                  fontSize: size.getS(18),
                                  // color: Colors.white,
                                  fontFamily: kFontFMedium,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    )),

            // SizedBox(
            //   height: size.getH(16),
            // ),

            // Row(
            //   mainAxisAlignment: MainAxisAlignment.spaceAround,
            //   children: [
            //     if (GlobalCVP.viewWidget.viewPrintReceiptButton))
            //       Expanded(
            //         // width: size.getW(148),
            //         child: ElevatedButton(
            //             style: ButtonStyle(
            //                 backgroundColor: WidgetStateProperty.all(
            //                     onPrint == null
            //                         ? Colors.grey.shade400
            //                         : kSecondaryColor),
            //                 padding: WidgetStateProperty.all(
            //                     EdgeInsets.symmetric(
            //                         horizontal: size.getW(4),
            //                         vertical: size.getH(12)))),
            //             onPressed: onPrint,
            //             child: Text(
            //               LN.printReceipt,
            //               style: TextStyle(
            //                 fontSize: size.getS(16),
            //                 color: Colors.white,
            //                 fontWeight: FontWeight.bold,
            //               ),
            //             )),
            //       ),
            //     if (GlobalCVP.viewWidget.viewPrintReceiptButton) &&
            //         GlobalCVP.viewWidget.viewPayNowButton))
            //       SizedBox(
            //         width: size.getW(18),
            //       ),
            //     if (GlobalCVP.viewWidget.viewPayNowButton))
            //       Expanded(
            //         // width: size.getW(148),
            //         child: ElevatedButton(
            //             style: ButtonStyle(
            //                 backgroundColor: WidgetStateProperty.all(
            //                     onTapPay == null
            //                         ? Colors.grey.shade400
            //                         : Colors.amber.shade400),
            //                 padding: WidgetStateProperty.all(
            //                     EdgeInsets.symmetric(
            //                         horizontal: size.getW(8),
            //                         vertical: size.getH(12)))),
            //             onPressed: paymentPro.loadingPay || onTapPay == null
            //                 ? null
            //                 : () => onTapPay!(false),
            //             child: paymentPro.loadingPay
            //                 ? Loading()
            //                 : Text(
            //                     LN.payNow,
            //                     style: TextStyle(
            //                       fontSize: size.getS(16),
            //                       color: Colors.black,
            //                       fontWeight: FontWeight.bold,
            //                     ),
            //                   )),
            //       ),
            //   ],
            // ),

            // if (!GlobalCVP.isRetailStore &&
            //     GlobalCVP.viewWidget(
            //         Strings.ViewPayAndSendToKitchenButton)) ...[
            //   SizedBox(
            //     height: size.getH(8),
            //   ),
            //   SizedBox(
            //     width: double.infinity,
            //     child: ElevatedButton(
            //         style: ButtonStyle(
            //             backgroundColor: WidgetStateProperty.all(
            //                 onTapPay == null
            //                     ? Colors.grey.shade400
            //                     : Colors.green.shade600),
            //             padding: WidgetStateProperty.all(EdgeInsets.symmetric(
            //                 horizontal: size.getW(8),
            //                 vertical: size.getH(12)))),
            //         onPressed: paymentPro.loadingPayStk || onTapPay == null
            //             ? null
            //             : () => onTapPay!(true),
            //         child: paymentPro.loadingPayStk
            //             ? Loading()
            //             : Text(
            //                 "Pay & Send To Kitchen",
            //                 style: TextStyle(
            //                   fontSize: size.getS(16),
            //                   color: Colors.white,
            //                   fontWeight: FontWeight.bold,
            //                 ),
            //               )),
            //   )
            // ],
          ],
        ),
      ),
    );
  }

  Widget _disableSection({bool readOnly = false, required Widget child}) {
    return IgnorePointer(
      ignoring: readOnly,
      child: Opacity(
        opacity: readOnly ? 0.5 : 1,
        child: child,
      ),
    );
  }

  static Widget buttons(
    Ssize size, {
    final void Function(bool)? onTapPay,
    final Function()? onPrint,
    bool loadingPay = false,
    bool loadingPayStk = false,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 4),
      child: Card(
        margin: EdgeInsets.zero,
        // color: Colors.transparent,
        // shadowColor: Colors.transparent,
        color: kBackgroundColor,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(10),
                bottomRight: Radius.circular(10))),
        child: Padding(
          padding: EdgeInsets.symmetric(
              vertical: size.getH(8.0), horizontal: size.getW(0)),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  if (GlobalCVP.viewWidget.viewPrintReceiptButton)
                    Expanded(
                      // width: size.getW(148),
                      child: ElevatedButton(
                          style: ButtonStyle(
                              backgroundColor: WidgetStateProperty.all(
                                  onPrint == null
                                      ? Colors.grey.shade400
                                      : kSecondaryColor),
                              padding: WidgetStateProperty.all(
                                  EdgeInsets.symmetric(
                                      horizontal: size.getW(4),
                                      vertical: size.getH(12)))),
                          onPressed: onPrint,
                          child: Text(
                            LN.printReceipt,
                            style: TextStyle(
                              fontSize: size.getS(16),
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          )),
                    ),
                  if (GlobalCVP.viewWidget.viewPrintReceiptButton &&
                      GlobalCVP.viewWidget.viewPaymentPayButton)
                    SizedBox(
                      width: size.getW(18),
                    ),
                  if (GlobalCVP.viewWidget.viewPaymentPayButton) //TODO: payment
                    Expanded(
                      // width: size.getW(148),
                      child: ElevatedButton(
                          style: ButtonStyle(
                              backgroundColor: WidgetStateProperty.all(
                                  onTapPay == null
                                      ? Colors.grey.shade400
                                      : Colors.amber.shade400),
                              padding: WidgetStateProperty.all(
                                  EdgeInsets.symmetric(
                                      horizontal: size.getW(8),
                                      vertical: size.getH(12)))),
                          onPressed: loadingPay || onTapPay == null
                              ? null
                              : () => onTapPay(false),
                          child: loadingPay
                              ? Loading()
                              : Text(
                                  LN.payNow,
                                  style: TextStyle(
                                    fontSize: size.getS(16),
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                  ),
                                )),
                    ),
                ],
              ),
              if (!GlobalCVP.isRetailStore &&
                  GlobalCVP.viewWidget.viewPayAndSendToKitchenButton) ...[
                SizedBox(
                  height: size.getH(8),
                ),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                      style: ButtonStyle(
                          shape: MaterialStateProperty.all(
                              RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5),
                                  side: BorderSide(color: Colors.transparent))),
                          backgroundColor: MaterialStateProperty.all(
                              onTapPay == null
                                  ? Colors.grey.shade400
                                  : Colors.green.shade700),
                          padding: MaterialStateProperty.all(
                              EdgeInsets.symmetric(
                                  horizontal: size.getW(8),
                                  vertical: size.getH(12)))),
                      onPressed: loadingPayStk || onTapPay == null
                          ? null
                          : () => onTapPay(true),
                      child: loadingPayStk
                          ? Loading()
                          : Text(
                              "Pay & Send To Kitchen",
                              style: TextStyle(
                                fontSize: size.getS(16),
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            )),
                )
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _TitleBody {
  final String title;
  final String? subTitle;
  final String body;
  final Color? color;

  _TitleBody({
    required this.title,
    this.subTitle,
    required this.body,
    this.color,
  });
}
