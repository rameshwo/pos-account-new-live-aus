import 'dart:async';
import 'package:flutter/material.dart';
import 'package:oktoast/oktoast.dart';
import 'package:pos_account/config/size_config.dart';
import 'package:pos_account/constant/constant.dart';
import 'package:pos_account/providers/cus_val_pro.dart';
import 'package:pos_account/widgets/input/text_form/title_text_form.dart';
import 'package:pos_account/widgets/load_btn.dart';

class CashAmountDialog extends StatefulWidget {
  final double chargeAmount;
  final Function onSubmit;
  const CashAmountDialog({
    super.key,
    required this.chargeAmount,
    required this.onSubmit,
  });

  static Future showDia(
    BuildContext context, {
    required double chargeAmount,
    required Function() onSubmit,
  }) {
    return showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
            backgroundColor: kBackgroundColor,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
            actions: [
              CashAmountDialog(
                chargeAmount: chargeAmount,
                onSubmit: onSubmit,
              ),
            ]);
      },
    );
  }

  @override
  State<CashAmountDialog> createState() => _CashAmountDialogState();
}

class _CashAmountDialogState extends State<CashAmountDialog> {
  double cashAmount = 0.0;
  double changeAmount = 0.0;
  String number = "0";

  void load() {
    if (mounted) setState(() {});
  }

  void _onTapNumber(String value) {
    if (number.contains('.') && value == '.') return;

    final numVal1 = double.tryParse(number);
    if (numVal1 == null) number = "";

    if (numVal1 != null && numVal1 > 1000000) return;

    if (numVal1 == 0 && value != '.' && !number.contains('.')) {
      number = value;
    } else
      number += value;

    load();
    Future.delayed(Duration(milliseconds: 50), () {
      _scrollCltr.animateTo(_scrollCltr.position.maxScrollExtent,
          duration: Duration(milliseconds: 100), curve: Curves.linearToEaseOut);
    });

    cashCltr.text = number;
    final parsedNumber = double.tryParse(number);
    changeAmount =
        (parsedNumber != null ? parsedNumber - widget.chargeAmount : 0.0);
    changeCltr.text = changeAmount.toString();
  }

  void _onBackSpace() {
    // print("is back");
    if (number.isNotEmpty && number.length > 1) {
      number = number.substring(0, number.length - 1);
      cashCltr.text = number;
      final parsedNumber = double.tryParse(number);
      changeAmount =
          (parsedNumber != null ? parsedNumber - widget.chargeAmount : 0.0);
      changeCltr.text = changeAmount.toString();
    } else {
      number = "0";
      cashCltr.text = number;
      changeAmount = 0.0;
      changeCltr.text = changeAmount.toString();
    }

    load();
  }

  Timer? timer;
  final _scrollCltr = ScrollController();

  @override
  void initState() {
    load();
    super.initState();
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  void _onTapCashAmount(int amount, int index) {
    setState(() {
      selectedIndex = index;
      cashCltr.text = amount.toString();
      number = amount.toString();
      cashAmount = amount.toDouble();
      changeAmount = amount - widget.chargeAmount;
      changeCltr.text = (amount - widget.chargeAmount).toString();
    });
  }

  void _onSubmit() {
    if (changeAmount >= 0) {
      Navigator.pop(context);
      widget.onSubmit();
    } else {
      showToast(
        "Cash amount is less than charge amount",
        position: ToastPosition.bottom,
        backgroundColor: Colors.red,
        radius: 5,
      );
    }
  }

  final changeCltr = TextEditingController();
  final cashCltr = TextEditingController();

  int selectedIndex = -1;

  @override
  Widget build(BuildContext context) {
    final size = Ssize(context);
    final cashAmounts = [10, 20, 50, 100, 500, 1000];
    final numberList = [7, 8, 9, 4, 5, 6, 1, 2, 3, 0, -1, -2];

    return SizedBox(
      height: size.height * 0.75,
      width: size.width * 0.4,
      child: Column(
        children: [
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(
                horizontal: size.getW(12), vertical: size.getH(12)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Choose Cash Received",
                  style: TextStyle(
                    fontSize: size.getS(32),
                    fontFamily: kFontFMedium,
                    color: Colors.black,
                  ),
                ),
                Row(
                  children: [
                    SizedBox(width: size.getW(15)),
                    InkWell(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Icon(
                        Icons.close,
                        size: size.getS(32),
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    alignment: WrapAlignment.start,
                    children: [
                      TitleTextForm(
                        isReq: false,
                        textCltr: TextEditingController(
                            text: widget.chargeAmount.toString()),
                        pWidth: 0.15,
                        title: 'Charge Amount',
                        readOnly: true,
                      ),
                      SizedBox(height: size.getH(10)),
                      TitleTextForm(
                          isReq: false,
                          textCltr: cashCltr,
                          pWidth: 0.15,
                          title: 'Cash Amount: ',
                          readOnly: true),
                      SizedBox(height: size.getH(10)),
                      TitleTextForm(
                        isReq: false,
                        textCltr: changeCltr,
                        pWidth: 0.15,
                        title: 'Change Amount: ',
                        readOnly: true,
                        borderColor:
                            changeAmount >= 0 ? Colors.green : Colors.red,
                      ),
                    ],
                  ),
                  SizedBox(height: size.getH(10)),
                  SizedBox(
                    height: 50,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      separatorBuilder: (_, __) =>
                          SizedBox(width: size.getW(10)),
                      itemCount: cashAmounts.length,
                      itemBuilder: (_, index) {
                        final amount = cashAmounts[index];
                        return _cashAmountButton(
                            amount: amount,
                            size: size,
                            onTap: () => _onTapCashAmount(
                                  amount,
                                  index,
                                ),
                            index: index);
                      },
                    ),
                  ),
                  SizedBox(height: size.getH(20)),
                  Expanded(
                    child: Row(
                      children: [
                        Expanded(
                          flex: 7,
                          child: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 10.0),
                            child: Column(
                              children: [
                                Expanded(
                                  flex: 3,
                                  child: MediaQuery.removePadding(
                                    context: context,
                                    removeBottom: true,
                                    child: GridView.builder(
                                      gridDelegate:
                                          SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 3,
                                        mainAxisSpacing: 5,
                                        crossAxisSpacing: 10,
                                        childAspectRatio: 2.7,
                                        // mainAxisExtent: size.getH(100),
                                      ),
                                      scrollDirection: Axis.vertical,
                                      physics: NeverScrollableScrollPhysics(),
                                      itemBuilder: (_, index) => _numKeySection(
                                        title: index == 10
                                            ? "."
                                            : index == 11
                                                ? "C"
                                                : "${numberList[index]}",
                                        size: size,
                                        onTap: () => index == 11 ||
                                                numberList[index] == -2
                                            ? _onBackSpace()
                                            : _onTapNumber(
                                                "${numberList[index]}"),
                                      ),
                                      itemCount: numberList.length,
                                    ),
                                  ),
                                ),
                                SizedBox(height: size.getH(10)),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          LoadButton(
            btnText: "Pay",
            onsave: () {
              _onSubmit();
            },
          ),
        ],
      ),
    );
  }

  Widget _cashAmountButton({
    required int amount,
    required Ssize size,
    Function()? onTap,
    int index = -1,
  }) {
    return InkWell(
      highlightColor: Colors.grey.shade400,
      onTap: onTap,
      child: Container(
        width: 100,
        height: 50,
        decoration: BoxDecoration(
          color: selectedIndex == index ? kSecondaryColor : Colors.white,
          borderRadius: BorderRadius.circular(5),
        ),
        child: Center(
          child: Text(
            '${GlobalCVP.storeInfo?.currencySymbol ?? '\$'}$amount',
            style: TextStyle(
              fontSize: size.getS(20),
              color: selectedIndex == index ? Colors.white : Colors.black,
            ),
          ),
        ),
      ),
    );
  }

  Widget _numKeySection({
    required String title,
    required Ssize size,
    Function()? onTap,
  }) {
    return InkWell(
      highlightColor: Colors.grey.shade400,
      onTap: onTap,
      onLongPress: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey.shade400,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Center(
          child: Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: size.getS(40),
              color: Colors.black,
            ),
          ),
        ),
      ),
    );
  }
}
