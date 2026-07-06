import 'dart:async';

import 'package:flutter/material.dart';
import 'package:pos_account/config/dual_display/dual_display_config.dart';
import 'package:pos_account/config/size_config.dart';
import 'package:pos_account/config/utils/utils.dart';
import 'package:pos_account/constant/constant.dart';
import 'package:pos_account/ln.dart';
import 'package:pos_account/providers/menu/payment_pro.dart';
import 'package:pos_account/repository/if_exception.dart';
import 'package:pos_account/screens/home_screen/com/items/tabs/setting_tab/com/pos_setting/com/pos_device_qr_dia.dart';
import 'package:pos_account/widgets/input/text_form/text_form_widget.dart';
import 'package:pos_account/widgets/load_btn.dart';

class UniqueNumSec extends StatelessWidget {
  final Ssize size;
  final PaymentPro payPro;
  final FocusNode? focusNode;
  const UniqueNumSec(
      {super.key, required this.size, required this.payPro, this.focusNode});

  // This function hits api every 2 seconds until valid data is received
  Timer? fetchDataUntilValid(BuildContext ctx) {
    Timer? _timer;

    payPro.qrLoading = true;
    payPro.notify;

    _timer = Timer.periodic(Duration(seconds: 2), (_) async {
      final _status = await payPro.listenQrScanData();
      if (_status) {
        // print("Valid data received:");

        payPro.qrLoading = false;
        payPro.notify;
        _timer!.cancel(); // Stop the timer
        Navigator.pop(ctx);
      } else {
        // print("Invalid data, retrying...");
      }
    });

    return _timer;
  }

  void _redeemLoyalty(BuildContext context, {required Ssize size}) {
    showDialog(
        context: context,
        builder: (_) {
          return SimpleDialog(
            backgroundColor: kPrimaryColor,
            contentPadding: EdgeInsets.symmetric(
                horizontal: size.getW(12), vertical: size.getH(12)),
            children: [
              Align(
                alignment: Alignment.topRight,
                child: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.red.shade700,
                    ),
                    padding: EdgeInsets.symmetric(
                        vertical: size.getS(4), horizontal: size.getS(4)),
                    child: InkWell(
                      onTap: () {
                        Navigator.pop(_);
                      },
                      child: Icon(
                        Icons.close,
                        color: Colors.white,
                        size: size.getS(28),
                      ),
                    )),
              ),
              SizedBox(height: size.getH(48)),
              Center(
                child: Text(
                  LN.totalLoyaltyAmt,
                  style: TextStyle(
                    fontSize: size.getS(20),
                    color: Colors.white,
                    fontFamily: kFontFMedium,
                  ),
                ),
              ),
              SizedBox(height: size.getH(12)),
              Center(
                child: Text(
                  "${payPro.curSym}${payPro.cusForLoyalityRes!.eligibleAmount}",
                  style: TextStyle(
                    fontSize: size.getS(28),
                    color: Colors.white,
                    fontFamily: kFontFBold,
                  ),
                ),
              ),
              SizedBox(height: size.getH(24)),
              LoadButton(
                btnText: LN.redeemLoyalty,
                btnColor: Colors.amber.shade400,
                textColor: Colors.black,
                onsave: () {
                  for (final e in payPro.paySecListRes!.paymentMethods!) {
                    e.isSelected = false;
                  }

                  if (payPro.paySecListRes?.paymentMethods?.any((e) =>
                          PayMethodClass.getMethod(e.name) ==
                          PayMethodEnum.Loyalty) ??
                      false) {
                    payPro.paySecListRes!.paymentMethods!
                        .firstWhere((e) =>
                            PayMethodClass.getMethod(e.name) ==
                            PayMethodEnum.Loyalty)
                        .isSelected = true;
                  }
//DIS_REMOVE
                  // if (payPro.uniByPayRes != null)
                  //   payPro.discountPercentCltr.clear();

                  payPro.unicodeCltr.clear();
                  payPro.amountPaidByUserCltr.clear();
                  payPro.tipCltr.clear();

                  payPro.uniByPayRes = null;

                  payPro.loyaltyRedeem = true;

                  payPro.setUniSearchData(isUpdatePaidAmt: false);
                  payPro.onChangedPayAmount(isUpdatePaidAmount: false);

                  payPro.notify;
                  Navigator.pop(_);
                },
              ),
              SizedBox(height: size.getH(48)),
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    final paySec = payPro.paySecListRes;
    if (paySec?.paymentMethods == null ||
        !paySec!.paymentMethods!
            .any((e) => e.isSelected != null && e.isSelected!))
      return SizedBox.shrink();
    else {
      final _selected = paySec.paymentMethods!
          .firstWhere((e) => e.isSelected != null && e.isSelected!);

      final _show = [
        PayMethodEnum.GiftCard,
        PayMethodEnum.Cash,
        PayMethodEnum.FPOS
      ].any((e) => e == PayMethodClass.getMethod(_selected.name));

      final _isLoyalty =
          PayMethodClass.getMethod(_selected.name) == PayMethodEnum.Loyalty;

      if (_isLoyalty)
        return Padding(
          padding: EdgeInsets.only(
              bottom: size.getH(12), right: size.getW(4), left: size.getW(4)),
          child: Row(
            children: [
              // Expanded(
              //   child: ElevatedButton.icon(
              //     onPressed: () {}, // => _redeemLoyalty(context, size: size),
              //     icon: Image.asset(
              //       "assets/png/loyalty.png",
              //       fit: BoxFit.cover,
              //       width: size.getW(25),
              //       height: size.getW(25),
              //     ),
              //     label: Text(
              //       'Redeem Loyalty',
              //       style: TextStyle(
              //         color: kSecondaryColor,
              //         fontSize: size.getS(14),
              //         fontFamily: kFontFMedium,
              //       ),
              //     ),
              //     style: ElevatedButton.styleFrom(
              //       primary: Colors.white,
              //       side: const BorderSide(color: Color(0xFF4AADA9)),
              //       shape: RoundedRectangleBorder(
              //         borderRadius: BorderRadius.circular(8),
              //       ),
              //     ),
              //   ),
              // ),
              if (payPro.cusForLoyalityRes?.loyaltyPaymentAllowed ?? false) ...[
                Expanded(
                    child: LoadButton(
                  vPad: 8,
                  btnText: 'Redeem Loyalty',
                  btnColor: Colors.white,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                      side: BorderSide(color: kSecondaryColor)),
                  textColor: kSecondaryColor,
                  icon: Padding(
                    padding: EdgeInsets.only(right: size.getW(4)),
                    child: Image.asset(
                      "assets/png/loyalty.png",
                      fit: BoxFit.cover,
                      width: size.getW(25),
                      height: size.getW(25),
                    ),
                  ),
                  onsave: () => _redeemLoyalty(context, size: size),
                )),
                SizedBox(width: size.getW(12))
              ],
              Expanded(
                child: LoadButton(
                  vPad: 8,
                  hPad: 4,
                  btnColor: Colors.white,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                      side: BorderSide(color: kSecondaryColor)),
                  textColor: kSecondaryColor,
                  icon: Padding(
                    padding: EdgeInsets.only(right: size.getW(8)),
                    child: Icon(
                      Icons.qr_code_2_outlined,
                      size: size.getS(24),
                      color: kSecondaryColor,
                    ),
                  ),
                  btnText: 'Scan QR',
                  onsave: () {
                    if (payPro.paySecListRes?.posQrImageUrl == null ||
                        payPro.paySecListRes!.posQrImageUrl!.isEmpty) {
                      IfException.showMessage(message: LN.npQrFound);
                      return;
                    }
                    DualDisplayConfig.sendData(
                        isPayScreen: true,
                        qrImage: payPro.paySecListRes?.posQrImageUrl);

                    final _timer = fetchDataUntilValid(context);

                    PosDeviceQrShow.showQRDia(
                            ctx: context,
                            diaName: "POS Device QR",
                            // title: "POS Device QR",
                            image: payPro.paySecListRes?.posQrImageUrl ?? '',
                            loading: LoadButton(
                                loading: true,
                                loadingText: "Retrieving Data",
                                width: 240))
                        .then((_) {
                      if (_timer != null) {
                        payPro.qrLoading = false;
                        payPro.notify;
                        _timer.cancel();
                      }
                      DualDisplayConfig.sendData(isPayScreen: true);
                    });
                  },
                ),
              ),
              // Divider(
              //   color: Colors.black,
              //   thickness: 1,
              // ),
            ],
          ),
        );
      else if (!_show)
        return SizedBox.shrink();
      else {
        final _isVoucher = [PayMethodEnum.Cash, PayMethodEnum.FPOS]
            .any((e) => e == PayMethodClass.getMethod(_selected.name));
        final _hintText = _isVoucher ? LN.voucherRedeemCode : LN.giftRedeemCode;
        return Column(
          children: [
            SizedBox(
              height: size.getH(4.0),
            ),
            TextFormWidget(
              focusNode: focusNode,
              isReq: !_isVoucher,
              initValidate: true,
              prefixIcon: Padding(
                padding: EdgeInsets.all(size.getS(4)),
                child: Image.asset(
                  "assets/png/qr_code.png",
                  width: size.getW(24),
                  height: size.getW(24),
                ),
              ),
              vPad: 12,
              borderRadius: 5,
              borderColor: Colors.black12,
              fillColor: Colors.white,
              cltr: payPro.unicodeCltr,
              hintText: _hintText,
              onSubmitted: payPro.uniCodeSearch,
              suffixIcon: InkWell(
                  onTap: () {
                    payPro.uniCodeSearch(payPro.unicodeCltr.text);
                    Utils.hideKeyBoard();
                  },
                  child: Icon(
                    Icons.manage_search_outlined,
                    size: size.getS(40),
                    color: kSecondaryColor,
                  )),
            ),
            SizedBox(
              height: size.getH(8),
            ),
            // if (payPro.uniByPayRes != null)
            //   Stack(
            //     children: [
            //       Card(
            //         color: Colors.teal.withOpacity(0.12),
            //         shadowColor: Colors.transparent,
            //         child: Padding(
            //           padding: const EdgeInsets.symmetric(
            //               vertical: 8.0, horizontal: 12),
            //           child: Column(
            //             children: [
            //               Row(
            //                 crossAxisAlignment: CrossAxisAlignment.start,
            //                 children: [
            //                   Expanded(
            //                     child: Column(
            //                       crossAxisAlignment: CrossAxisAlignment.start,
            //                       children: [
            //                         Text(LN.sendDetails,
            //                             style: TextStyle(
            //                               fontSize: size.getS(16),
            //                               color: Colors.black,
            //                               fontFamily: kFontFMedium,
            //                             )),
            //                         SizedBox(
            //                           height: size.getH(4),
            //                         ),
            //                         Text(
            //                             "${LN.name}: " +
            //                                 (payPro.uniByPayRes!.senderName ??
            //                                     ''),
            //                             style: TextStyle(
            //                               fontSize: size.getS(14),
            //                               color: Colors.black,
            //                               fontFamily: kFontFMedium,
            //                             )),
            //                         SizedBox(
            //                           height: size.getH(4),
            //                         ),
            //                         Text(
            //                             "${LN.phone}: " +
            //                                 (payPro.uniByPayRes!
            //                                         .senderPhoneNumber ??
            //                                     ''),
            //                             style: TextStyle(
            //                               fontSize: size.getS(14),
            //                               color: Colors.black,
            //                               fontFamily: kFontFMedium,
            //                             )),
            //                       ],
            //                     ),
            //                   ),
            //                   Expanded(
            //                     child: Column(
            //                       crossAxisAlignment: CrossAxisAlignment.start,
            //                       children: [
            //                         Text(LN.recieverDetails,
            //                             style: TextStyle(
            //                               fontSize: size.getS(16),
            //                               color: Colors.black,
            //                               fontFamily: kFontFMedium,
            //                             )),
            //                         SizedBox(
            //                           height: size.getH(4),
            //                         ),
            //                         Text(
            //                             "${LN.name}: " +
            //                                 (payPro.uniByPayRes!.receiverName ??
            //                                     ''),
            //                             style: TextStyle(
            //                               fontSize: size.getS(14),
            //                               color: Colors.black,
            //                               fontFamily: kFontFMedium,
            //                             )),
            //                         SizedBox(
            //                           height: size.getH(4),
            //                         ),
            //                         Text(
            //                             "${LN.phone}: " +
            //                                 (payPro.uniByPayRes!
            //                                         .receiverPhoneNumber ??
            //                                     ''),
            //                             style: TextStyle(
            //                               fontSize: size.getS(14),
            //                               color: Colors.black,
            //                               fontFamily: kFontFMedium,
            //                             )),
            //                         SizedBox(
            //                           height: size.getH(4),
            //                         ),
            //                         Text(
            //                             "${LN.email}: " +
            //                                 (payPro.uniByPayRes!
            //                                         .receiverEmail ??
            //                                     ''),
            //                             style: TextStyle(
            //                               fontSize: size.getS(14),
            //                               color: Colors.black,
            //                               fontFamily: kFontFMedium,
            //                             )),
            //                       ],
            //                     ),
            //                   ),
            //                 ],
            //               ),
            //               SizedBox(
            //                 height: size.getH(12),
            //               ),
            //               if (payPro.uniByPayRes!.uniqueCode != null &&
            //                   payPro.uniByPayRes!.uniqueCode!.isNotEmpty)
            //                 Text.rich(
            //                   TextSpan(
            //                       text: "${LN.code}: ",
            //                       style: TextStyle(
            //                         fontSize: size.getS(14),
            //                         color: Colors.black,
            //                         fontFamily: kFontFMedium,
            //                       ),
            //                       children: [
            //                         TextSpan(
            //                           text: payPro.uniByPayRes!.uniqueCode,
            //                           style: TextStyle(
            //                             fontSize: size.getS(14),
            //                             color: kTempColor,
            //                             fontFamily: kFontFMedium,
            //                           ),
            //                         )
            //                       ]),
            //                 ),
            //               SizedBox(
            //                 height: size.getH(4),
            //               ),
            //               if (payPro.uniByPayRes?.isDiscount ?? false) ...[
            //                 if (payPro.uniByPayRes?.discountPercentage != null)
            //                   Text(
            //                     "${LN.discount}(%): " +
            //                         (payPro.uniByPayRes!.discountPercentage!) +
            //                         '%',
            //                     style: TextStyle(
            //                       fontSize: size.getS(14),
            //                       color: Colors.black,
            //                       fontFamily: kFontFMedium,
            //                     ),
            //                   )
            //               ] else ...[
            //                 if (payPro.uniByPayRes?.actualAmount != null)
            //                   Text(
            //                     "${LN.giftAmt}: " +
            //                         (payPro.curSym ?? '') +
            //                         (payPro.uniByPayRes!.actualAmount ?? ''),
            //                     style: TextStyle(
            //                       fontSize: size.getS(14),
            //                       color: Colors.black,
            //                       fontFamily: kFontFMedium,
            //                     ),
            //                   ),
            //                 if (payPro.uniByPayRes?.amount != null)
            //                   Text(
            //                     "${LN.remainAmt}: " +
            //                         (payPro.curSym ?? '') +
            //                         (payPro.uniByPayRes!.amount ?? ''),
            //                     style: TextStyle(
            //                       fontSize: size.getS(14),
            //                       color: Colors.black,
            //                       fontFamily: kFontFMedium,
            //                     ),
            //                   )
            //               ]
            //             ],
            //           ),
            //         ),
            //       ),
            //       Align(
            //           alignment: Alignment.topRight,
            //           child: IconButton(
            //               onPressed: () {
            //                 if (_isVoucher &&
            //                     (payPro.uniByPayRes?.isDiscount ?? false))
            //                   payPro.discountPercentCltr.clear();

            //                 payPro.unicodeCltr.clear();
            //                 payPro.searchCusCltr.clear();
            //                 payPro.uniByPayRes = null;
            //                 payPro.cusForLoyalityRes = null;
            //                 payPro.onChangedPayAmount();
            //                 payPro.notify;
            //               },
            //               icon: Icon(
            //                 Icons.close,
            //                 size: size.getS(21),
            //               ))),
            //     ],
            //   ),
            // Divider(
            //   color: Colors.black,
            //   thickness: 1,
            // ),
          ],
        );
      }
    }
  }
}
