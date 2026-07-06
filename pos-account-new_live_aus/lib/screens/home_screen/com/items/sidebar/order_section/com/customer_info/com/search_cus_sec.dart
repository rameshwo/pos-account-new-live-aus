import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_listener/flutter_barcode_listener.dart';
import 'package:pos_account/config/size_config.dart';
import 'package:pos_account/constant/constant.dart';
import 'package:pos_account/ln.dart';
import 'package:pos_account/model/home/booking/all_customer.dart';
import 'package:pos_account/providers/menu/payment_pro.dart';
import 'package:pos_account/screens/home_screen/com/dialogs/cus_list_dia.dart';
import 'package:pos_account/screens/home_screen/com/items/com/price_update_dia.dart';
import 'package:pos_account/widgets/input/text_form/text_form_widget.dart';
import 'package:pos_account/widgets/loading.dart';

class SearchCusSec extends StatelessWidget {
  final PaymentPro payPro;
  final Ssize size;
  const SearchCusSec({
    super.key,
    required this.payPro,
    required this.size,
  });

  void showCusList(BuildContext context) {
    CustomerList.show(context).then((value) async {
      if (value != null && value is CusData) {
        await payPro.searchCustomer("", cusId: value.id);

        // if (value.email != null && value.email!.isNotEmpty) {
        //   await payPro.searchCustomer(value.email!);
        // } else if (value.phoneNumber != null && value.phoneNumber!.isNotEmpty) {
        //   await payPro.searchCustomer(value.phoneNumber!);
        // }
        if (payPro.cusForLoyalityRes != null) {
          payPro.showCusKeyPad = false;
          payPro.notify;
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: BarcodeKeyboardListener(
        bufferDuration: Duration(milliseconds: 400),
        onBarcodeScanned: (String val) async {
          if (FocusManager.instance.primaryFocus?.hasFocus ?? false) {
            SystemChannels.textInput.invokeMethod('TextInput.hide');
          }

          await payPro.scanCusQr(cusId: val);

//
        },
        child: Processing(
          loading: payPro.searchLoad,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormWidget(
                isReq: false,
                borderColor: Colors.black26,
                cltr: payPro.searchCusCltr,
                fillColor: Colors.grey.shade100,
                hintText: 'Search with phone number',
                focusNode: payPro.KeyPadfocusNode,
                readOnly: true,
                hintStyle: TextStyle(
                  fontFamily: kFontFMedium,
                  fontWeight: FontWeight.normal,
                  color: Colors.grey,
                ),
                textStyle: TextStyle(
                    fontWeight: FontWeight.bold, fontSize: size.getS(18)),
                suffixIcon: InkWell(
                  onTap: () {
                    showCusList(context);
                  },
                  child: Icon(
                    Icons.manage_search_outlined,
                    color: kSecondaryColor,
                    size: size.getS(40),
                  ),
                ),
                suffixIconWidth: 40,
                onTap: () {
                  if (payPro.showCusKeyPad &&
                      payPro.cusForLoyalityRes != null) {
                    payPro.showCusKeyPad = false;
                    payPro.KeyPadfocusNode?.unfocus();
                  } else {
                    payPro.showCusKeyPad = true;
                  }
                  payPro.notify;
                },
              ),
              SizedBox(height: size.getH(12)),
              AnimatedContainer(
                duration: Duration(milliseconds: 400),
                height: payPro.showCusKeyPad ? size.height * 0.25 : 0,
                child: PriceUpdateDia<int>(
                  // key: ValueKey(payPro.showCusKeyPad),
                  value: payPro.searchCusCltr.text,
                  max: 100000000000000,
                  property: PriceDiaProperty(
                      isDia: false,
                      isPhoneNum: true,
                      padding: 12,
                      height: 60,
                      fontSize: 28,
                      onTap: (val) {
                        payPro.searchCusCltr.text = val;
                        payPro.notify;
                      },
                      onOk: payPro.searchLoad
                          ? null
                          : (val) async {
                              payPro.searchLoad = true;
                              payPro.notify;

                              await payPro.searchCustomer(
                                  payPro.searchCusCltr.text,
                                  showMsg: true);

                              payPro.searchLoad = false;
                              payPro.notify;
                            }),
                ),
              ),
              // SizedBox(height: size.getH(12)),

              Flexible(
                  child: SingleChildScrollView(
                      physics: BouncingScrollPhysics(),
                      child: payPro.cusForLoyalityRes != null
                          ? MemberProfileScreen(payPro: payPro)
                          : Container(
                              width: double.maxFinite,
                              height: size.getH(240),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  border:
                                      Border.all(color: Colors.grey.shade300)),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.person_search_outlined,
                                    size: size.getS(140),
                                    color: Colors.grey.shade300,
                                  ),
                                  Text(
                                    "Seach for Customers",
                                    style: TextStyle(
                                      fontSize: size.getS(18),
                                      color: Colors.grey.shade300,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            )))
            ],
          ),
        ),
      ),
    );
  }
}

class MemberProfileScreen extends StatelessWidget {
  const MemberProfileScreen({
    super.key,
    this.isLoyaltyEnabled = true,
    required this.payPro,
  });

  final bool isLoyaltyEnabled;
  final PaymentPro payPro;

  @override
  Widget build(BuildContext context) {
    final size = Ssize(context);
    // final _paySec = payPro.paySecListRes;
    // final _selected =
    //     _paySec?.paymentMethods?.any((e) => e.isSelected ?? false) ?? false
    //         ? _paySec!.paymentMethods!
    //             .firstWhere((e) => e.isSelected != null && e.isSelected!)
    //         : null;
    // final _isVoucher = _selected == null
    //     ? false
    //     : [PayMethodEnum.Cash, PayMethodEnum.FPOS]
    //         .any((e) => e == PayMethodClass.getMethod(_selected.name));

    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.black38),
            borderRadius: BorderRadius.circular(10),
          ),
          padding: EdgeInsets.symmetric(horizontal: size.getW(12.0)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Profile header with avatar and name
              Row(
                children: [
                  CircleAvatar(
                      radius: size.getS(16),
                      backgroundColor: kSecondaryColor.withOpacity(0.15),
                      child: Text(
                        payPro.cusForLoyalityRes!.customerName?.isNotEmpty ??
                                false
                            ? payPro.cusForLoyalityRes!.customerName![0]
                            : '',
                        style: TextStyle(
                          fontSize: size.getS(14),
                          color: kSecondaryColor,
                        ),
                      )),
                  SizedBox(width: size.getW(12)),
                  Expanded(
                    child: Text(
                      payPro.cusForLoyalityRes!.customerName ?? '',
                      style: TextStyle(
                        fontSize: size.getS(16),
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF333333),
                      ),
                    ),
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.close,
                      color: Colors.grey,
                      size: size.getS(24),
                    ),
                    onPressed: () {
                      payPro.searchCusCltr.clear();
                      payPro.cusForLoyalityRes = null;
                      payPro.loyalityEnable = false;
                      payPro.showCusKeyPad = true;
                      if (payPro.uniByPayRes != null) {
                        // DIS_REMOVE
                        // if (_isVoucher &&
                        //     (payPro.uniByPayRes?.isDiscount ?? false))
                        //   payPro.discountPercentCltr.clear();
                        payPro.unicodeCltr.clear();
                        payPro.searchCusCltr.clear();
                        payPro.uniByPayRes = null;
                        payPro.cusForLoyalityRes = null;
                        payPro.onChangedPayAmount();
                      }
                      payPro.notify;
                    },
                  ),
                ],
              ),

              const Divider(),

              // Contact information
              Row(
                children: [
                  Expanded(
                    flex: 3,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          LN.email,
                          style: TextStyle(
                            fontSize: size.getS(14),
                            color: Color(0xFF666666),
                          ),
                        ),
                        SizedBox(height: size.getH(4)),
                        Text(
                          payPro.cusForLoyalityRes!.email ?? LN.na,
                          style: TextStyle(
                            fontSize: size.getS(16),
                            color: Color(0xFF333333),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          LN.phoneNumber,
                          style: TextStyle(
                            fontSize: size.getS(14),
                            color: Color(0xFF666666),
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          payPro.cusForLoyalityRes!.phoneNumber ?? LN.na,
                          style: TextStyle(
                            fontSize: size.getS(16),
                            color: Color(0xFF333333),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              SizedBox(height: size.getH(8)),

              // Redeem Loyalty Button
              // if (payPro.cusForLoyalityRes != null)
              //   Align(
              //     alignment: Alignment.centerRight,
              //     child: ElevatedButton.icon(
              //       onPressed: () => _redeemLoyalty(context, size: size),
              //       icon: Image.asset(
              //         "assets/png/loyalty.png",
              //         fit: BoxFit.cover,
              //         width: size.getW(25),
              //         height: size.getW(25),
              //       ),
              //       label: Text(
              //         'Redeem Loyalty',
              //         style: TextStyle(
              //           color: kSecondaryColor,
              //           fontSize: size.getS(14),
              //           fontFamily: kFontFMedium,
              //         ),
              //       ),
              //       style: ElevatedButton.styleFrom(
              //         primary: Colors.white,
              //         side: const BorderSide(color: Color(0xFF4AADA9)),
              //         shape: RoundedRectangleBorder(
              //           borderRadius: BorderRadius.circular(8),
              //         ),
              //       ),
              //     ),
              //   ),

              _showPointVal(
                size,
                points: [
                  ShowPoints(
                    title: LN.eligibleAmount,
                    value:
                        "${payPro.curSym}${payPro.cusForLoyalityRes!.eligibleAmount}",
                  ),
                  ShowPoints(
                    title: LN.balPoint,
                    icon: Icon(
                      Icons.balance,
                      size: size.getS(16),
                      color: Color(0xFF4AADA9),
                    ),
                    value:
                        payPro.cusForLoyalityRes?.totalRemainingPoints ?? '0',
                  )
                ],
              ),

              SizedBox(height: size.getS(12)),

              // Stats row
              _showPointVal(
                size,
                points: [
                  ShowPoints(
                    title: 'Net Sales',
                    value:
                        "${payPro.curSym}${payPro.cusForLoyalityRes?.orderSummary?.netSales ?? '0.00'}",
                  ),
                  ShowPoints(
                    title: LN.discounts,
                    value:
                        "${payPro.curSym}${payPro.cusForLoyalityRes?.orderSummary?.discounts ?? '0.00'}",
                  ),
                  ShowPoints(
                      title: LN.totalOrders,
                      value:
                          payPro.cusForLoyalityRes?.orderSummary?.totalOrders ??
                              '0')
                ],
              ),
              SizedBox(height: size.getH(12)),

              // Enable Loyalty Toggle
              Container(
                padding: EdgeInsets.all(size.getS(16)),
                decoration: BoxDecoration(
                  color: const Color(0xFFF0F6FF),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: InkWell(
                  onTap: () {
                    if (payPro.cusForLoyalityRes != null)
                      payPro.cusForLoyalityRes!.loyaltyEnabled =
                          !(payPro.cusForLoyalityRes!.loyaltyEnabled ?? false);
                    payPro.loyalityEnable =
                        payPro.cusForLoyalityRes!.loyaltyEnabled ?? false;
                    payPro.notify;
                  },
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              LN.enableLoyal,
                              style: TextStyle(
                                fontSize: size.getS(16),
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF333333),
                              ),
                            ),
                            SizedBox(height: size.getH(4)),
                            Text(
                              "*${payPro.cusForLoyalityRes!.message ?? ''}",
                              style: TextStyle(
                                fontSize: size.getS(13),
                                color: Colors.red.shade600,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Row(
                        children: [
                          Text(
                            LN.active,
                            style: TextStyle(
                              color: payPro.cusForLoyalityRes?.loyaltyEnabled ??
                                      false
                                  ? Color(0xFF4AADA9)
                                  : Colors.red,
                              fontWeight: FontWeight.w500,
                              fontSize: size.getS(14),
                            ),
                          ),
                          // SizedBox(width: size.getW(8)),
                          IgnorePointer(
                            ignoring: true,
                            child: Switch(
                              value: payPro.cusForLoyalityRes?.loyaltyEnabled ??
                                  false,
                              onChanged: (value) {
                                // setState(() {
                                //   isLoyaltyEnabled = value;
                                // });
                              },
                              // activeColor: kSecondaryColor,
                              // activeTrackColor: kSecondaryColor,
                              inactiveThumbColor: Colors.white,
                              trackOutlineColor:
                                  WidgetStateProperty.all(Colors.black12),
                              inactiveTrackColor: Colors.grey.shade300,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: size.getH(12)),
            ],
          ),
        ),
        if (payPro.uniByPayRes != null) ...[
          SizedBox(height: size.getH(12)),
          GiftCardInterface(size: size, payPro: payPro),

          // Promo Code
          // Container(
          //   decoration: BoxDecoration(
          //     border: Border.all(color: Colors.grey.shade300),
          //     borderRadius: BorderRadius.circular(8),
          //   ),
          //   child: Row(
          //     children: [
          //       Container(
          //         padding: EdgeInsets.symmetric(
          //           horizontal: size.getW(24),
          //           vertical: size.getH(12),
          //         ),
          //         decoration: const BoxDecoration(
          //           color: Color(0xFFEF7E7B),
          //           borderRadius: BorderRadius.only(
          //             topLeft: Radius.circular(8),
          //             bottomLeft: Radius.circular(8),
          //           ),
          //         ),
          //         child: Text(
          //           'Code',
          //           style: TextStyle(
          //             color: Colors.white,
          //             fontWeight: FontWeight.bold,
          //             fontSize: size.getS(16),
          //           ),
          //         ),
          //       ),
          //       Expanded(
          //         child: Padding(
          //           padding: EdgeInsets.symmetric(horizontal: size.getW(12)),
          //           child: Text(
          //             'NEWWYEAR20',
          //             style: TextStyle(
          //               color: Colors.grey.shade700,
          //               fontSize: size.getS(16),
          //             ),
          //           ),
          //         ),
          //       ),
          //     ],
          //   ),
          // ),

          // SizedBox(height: size.getH(12)),

          // // Gift Card and Remaining Amount
          // Row(
          //   mainAxisAlignment: MainAxisAlignment.center,
          //   children: [
          //     Container(
          //       width: size.getS(140),
          //       height: size.getS(120),
          //       padding: EdgeInsets.all(size.getS(4)),
          //       decoration: BoxDecoration(
          //         color: const Color(0xFFF0F6FF),
          //         borderRadius: BorderRadius.circular(8),
          //       ),
          //       child: Column(
          //         mainAxisAlignment: MainAxisAlignment.center,
          //         children: [
          //           Container(
          //             padding: EdgeInsets.all(size.getS(8)),
          //             decoration: const BoxDecoration(
          //               color: Color(0xFF4AADA9),
          //               shape: BoxShape.circle,
          //             ),
          //             child: Icon(
          //               Icons.card_giftcard,
          //               color: Colors.white,
          //               size: size.getS(20),
          //             ),
          //           ),
          //           SizedBox(height: size.getH(4)),
          //           Text(
          //             '100.00',
          //             style: TextStyle(
          //               fontSize: size.getS(18),
          //               fontWeight: FontWeight.bold,
          //               color: Color(0xFF4AADA9),
          //             ),
          //           ),
          //           // SizedBox(height: size.getH(4)),
          //           Text(
          //             'Gift Card Amount',
          //             style: TextStyle(
          //               fontSize: size.getS(12),
          //               color: Color(0xFF4AADA9),
          //               height: 1.1,
          //             ),
          //             textAlign: TextAlign.center,
          //           ),
          //         ],
          //       ),
          //     ),
          //     SizedBox(width: size.getW(12)),
          //     Container(
          //       width: size.getS(140),
          //       height: size.getS(120),
          //       padding: EdgeInsets.all(size.getS(4)),
          //       decoration: BoxDecoration(
          //         color: const Color(0xFFF0F6FF),
          //         borderRadius: BorderRadius.circular(8),
          //       ),
          //       child: Column(
          //         mainAxisAlignment: MainAxisAlignment.center,
          //         children: [
          //           Container(
          //             padding: EdgeInsets.all(size.getS(8)),
          //             decoration: const BoxDecoration(
          //               color: Color(0xFF4AADA9),
          //               shape: BoxShape.circle,
          //             ),
          //             child: Icon(
          //               Icons.account_balance_wallet,
          //               color: Colors.white,
          //               size: size.getS(20),
          //             ),
          //           ),
          //           SizedBox(height: size.getH(4)),
          //           Text(
          //             '100.00',
          //             style: TextStyle(
          //               fontSize: size.getS(18),
          //               fontWeight: FontWeight.bold,
          //               color: Color(0xFF4AADA9),
          //             ),
          //           ),
          //           // SizedBox(height: size.getH(4)),
          //           Text(
          //             'Remaining Amount',
          //             style: TextStyle(
          //               fontSize: size.getS(12),
          //               color: Color(0xFF4AADA9),
          //               height: 1.1,
          //             ),
          //             textAlign: TextAlign.center,
          //           ),
          //         ],
          //       ),
          //     ),
          //   ],
          // )
        ],
        SizedBox(height: size.getH(48)),
      ],
    );
  }

  Widget _showPointVal(
    Ssize size, {
    required List<ShowPoints> points,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF0F6FF),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          for (int i = 0; i < points.length; i++) ...[
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: size.getH(12)),
                child: Column(
                  children: [
                    Text(
                      points[i].title,
                      style: TextStyle(
                        fontSize: size.getS(14),
                        color: Color(0xFF666666),
                      ),
                    ),
                    SizedBox(height: size.getH(4)),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        if (points[i].icon != null) ...[
                          points[i].icon!,
                          SizedBox(width: size.getW(4))
                        ],
                        Text(
                          points[i].value,
                          style: TextStyle(
                            fontSize: size.getS(18),
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF4AADA9),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            if (i != points.length - 1)
              Container(
                width: size.getW(1),
                height: size.getH(48),
                color: Colors.black26,
              ),
          ],
        ],
      ),
    );
  }
}

class GiftCardInterface extends StatelessWidget {
  final Ssize size;
  final PaymentPro payPro;

  const GiftCardInterface(
      {super.key, required this.size, required this.payPro});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black38),
        borderRadius: BorderRadius.circular(10),
      ),
      padding: EdgeInsets.symmetric(
          horizontal: size.getW(12.0), vertical: size.getH(12)),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Code section
          if (payPro.uniByPayRes?.uniqueCode?.isNotEmpty ?? false)
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(
                  horizontal: size.getW(16), vertical: size.getH(8)),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFFFFF1F2), Color(0xFFFFE4E6)],
                ),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFFFECDD3)),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    LN.code,
                    style: TextStyle(
                      fontSize: size.getS(14),
                      fontWeight: FontWeight.w500,
                      color: Colors.grey,
                    ),
                  ),
                  // const SizedBox(width: 8),
                  Spacer(),
                  Text(
                    payPro.uniByPayRes!.uniqueCode!,
                    style: TextStyle(
                      fontSize: size.getS(16),
                      fontWeight: FontWeight.bold,
                      color: kTempColor,
                    ),
                  ),
                  SizedBox(width: size.getW(8)),
                  Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.green.withOpacity(0.1),
                    ),
                    child: Icon(
                      Icons.check,
                      size: size.getS(14),
                      color: Colors.green,
                    ),
                  ),
                ],
              ),
            ),
          SizedBox(height: size.getH(8)),

          // Gift card header with amount
          Container(
            padding: EdgeInsets.all(size.getS(12)),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFFE6FFFA), Color(0xFFCFFAFE)],
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: (payPro.uniByPayRes?.isDiscount ?? false)
                ? Row(
                    children: [
                      Icon(Icons.discount_outlined,
                          size: size.getS(12), color: Color(0xFF14B8A6)),
                      SizedBox(width: size.getW(4)),
                      Text('${LN.discount}(%)',
                          style: TextStyle(
                            fontSize: size.getS(14),
                            color: Colors.grey,
                          )),
                      Spacer(),
                      Text(
                        '${payPro.uniByPayRes!.discountPercentage!}%',
                        style: TextStyle(
                          fontSize: size.getS(18),
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF0F766E),
                        ),
                      ),
                    ],
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      if (payPro.uniByPayRes?.actualAmount != null)
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(Icons.card_giftcard,
                                    size: size.getS(12),
                                    color: Color(0xFF14B8A6)),
                                SizedBox(width: size.getW(4)),
                                Text(
                                  LN.giftAmt,
                                  style: TextStyle(
                                    fontSize: size.getS(14),
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                            Text(
                              (payPro.curSym ?? '') +
                                  (payPro.uniByPayRes!.actualAmount ?? ''),
                              style: TextStyle(
                                fontSize: size.getS(18),
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF0F766E),
                              ),
                            ),
                          ],
                        ),
                      if (payPro.uniByPayRes?.amount != null)
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Row(
                              children: [
                                Icon(Icons.credit_card,
                                    size: size.getS(12),
                                    color: Color(0xFF14B8A6)),
                                SizedBox(width: size.getW(4)),
                                Text(
                                  LN.remainAmt,
                                  style: TextStyle(
                                    fontSize: size.getS(14),
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                            Text(
                              (payPro.curSym ?? '') +
                                  (payPro.uniByPayRes!.amount ?? ''),
                              style: TextStyle(
                                fontSize: size.getS(18),
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF0F766E),
                              ),
                            ),
                          ],
                        ),
                    ],
                  ),
          ),

          SizedBox(height: size.getH(8)),

          Container(
            width: double.infinity,
            padding: EdgeInsets.all(size.getS(10)),
            decoration: BoxDecoration(
              color: Colors.grey[50],
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.person,
                        size: size.getS(12), color: Color(0xFF0F766E)),
                    SizedBox(width: size.getW(4)),
                    Text(
                      LN.sendDetails,
                      style: TextStyle(
                        fontSize: size.getS(12),
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF0F766E),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: size.getH(8)),
                Row(
                  children: [
                    Icon(Icons.person, size: size.getS(12), color: Colors.grey),
                    SizedBox(width: size.getW(4)),
                    Text(
                      LN.name,
                      style: TextStyle(
                        fontSize: size.getS(14),
                        color: Colors.grey,
                      ),
                    ),
                    Expanded(
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: Text(
                          payPro.uniByPayRes!.senderName ?? '',
                          style: TextStyle(
                            fontSize: size.getS(15),
                            fontWeight: FontWeight.w500,
                          ),
                          textAlign: TextAlign.right,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: size.getH(6)),
                Row(
                  children: [
                    Icon(Icons.phone, size: size.getS(12), color: Colors.grey),
                    SizedBox(width: size.getW(4)),
                    Text(
                      LN.phone,
                      style: TextStyle(
                        fontSize: size.getS(14),
                        color: Colors.grey,
                      ),
                    ),
                    Expanded(
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: Text(
                          payPro.uniByPayRes!.senderPhoneNumber ?? '',
                          style: TextStyle(
                            fontSize: size.getS(15),
                            fontWeight: FontWeight.w500,
                          ),
                          textAlign: TextAlign.right,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(height: size.getH(8)),
          Container(
            padding: EdgeInsets.all(size.getS(10)),
            decoration: BoxDecoration(
              color: Colors.grey[50],
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.person,
                        size: size.getS(12), color: Color(0xFF0F766E)),
                    SizedBox(width: size.getW(4)),
                    Text(
                      LN.recieverDetails,
                      style: TextStyle(
                        fontSize: size.getS(12),
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF0F766E),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: size.getH(8)),
                Row(
                  children: [
                    Icon(Icons.person, size: size.getS(12), color: Colors.grey),
                    SizedBox(width: size.getW(4)),
                    Text(
                      LN.name,
                      style: TextStyle(
                        fontSize: size.getS(14),
                        color: Colors.grey,
                      ),
                    ),
                    Expanded(
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: Text(
                          payPro.uniByPayRes!.receiverName ?? '',
                          style: TextStyle(
                            fontSize: size.getS(15),
                            fontWeight: FontWeight.w500,
                          ),
                          textAlign: TextAlign.right,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: size.getH(4)),
                Row(
                  children: [
                    Icon(Icons.phone, size: size.getS(12), color: Colors.grey),
                    SizedBox(width: size.getW(4)),
                    Text(
                      LN.phone,
                      style: TextStyle(
                        fontSize: size.getS(14),
                        color: Colors.grey,
                      ),
                    ),
                    Expanded(
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: Text(
                          payPro.uniByPayRes!.receiverPhoneNumber ?? '',
                          style: TextStyle(
                            fontSize: size.getS(15),
                            fontWeight: FontWeight.w500,
                          ),
                          textAlign: TextAlign.right,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: size.getH(6)),
                Row(
                  children: [
                    Icon(Icons.email, size: size.getS(12), color: Colors.grey),
                    SizedBox(width: size.getW(4)),
                    Text(
                      LN.email,
                      style: TextStyle(
                        fontSize: size.getS(14),
                        color: Colors.grey,
                      ),
                    ),
                    Expanded(
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: Text(
                          payPro.uniByPayRes!.receiverEmail ?? '',
                          style: TextStyle(
                            fontSize: size.getS(15),
                            fontWeight: FontWeight.w500,
                            // overflow: TextOverflow.ellipsis,
                          ),
                          textAlign: TextAlign.right,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ShowPoints {
  final String title;
  final String value;
  final Widget? icon;

  ShowPoints({
    required this.title,
    required this.value,
    this.icon,
  });
}
