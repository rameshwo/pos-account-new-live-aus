import 'package:flutter/material.dart';
import 'package:pos_account/config/size_config.dart';
import 'package:pos_account/config/validator.dart';
import 'package:pos_account/constant/constant.dart';
import 'package:pos_account/ln.dart';
import 'package:pos_account/services/database/shared_pref.dart';
import 'package:pos_account/widgets/input/text_form/text_form_widget.dart';
import 'package:pos_account/widgets/load_btn.dart';

class CalcuatedCashData {
  String? cash;
  String? float;
  String? cashOut;
  String? cashIn;

  CalcuatedCashData({this.cash, this.float, this.cashOut, this.cashIn});
}

class CountedCash {
  final double money;
  final TextEditingController unitCltr;

  CountedCash({required this.money, required this.unitCltr});
}

class CashDialog extends StatefulWidget {
  final CalcuatedCashData cashData;
  final List<CountedCash> countedCash;
  const CashDialog(
      {super.key, required this.cashData, required this.countedCash});

  @override
  State<CashDialog> createState() => _CashDialogState();
}

class _CashDialogState extends State<CashDialog> {
  double _getTotal1(List<String?> allValue) {
    double total = 0.0;
    for (final e in allValue) {
      total += double.tryParse(e ?? '') ?? 0;
    }
    return total;
  }

  double _getTotal2(List<CountedCash> cashData) {
    double total = 0.0;
    for (final e in cashData) {
      total += e.money * (double.tryParse(e.unitCltr.text) ?? 0);
    }
    return total;
  }

  void load() {
    if (mounted) setState(() {});
  }

  String curSym = "";

  Future<void> getData() async {
    curSym = await SharedPrefs.curSym;
    load();
  }

  @override
  void initState() {
    getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final size = Ssize(context);
    final countedCash = widget.countedCash;
    final cashData = widget.cashData;
    final total1 = _getTotal1(
        [cashData.cash, cashData.float, cashData.cashOut, cashData.cashIn]);
    final total2 = _getTotal2(countedCash);

    final variance = total1 + total2;
    final actualCash = _getTotal1([cashData.cash]) - variance;
    return Container(
      constraints: BoxConstraints(
        maxHeight: size.height / 1.15,
        minHeight: size.height / 5,
      ),
      width: size.width / 1.4,
      child: Column(
        children: [
          Stack(
            children: [
              Padding(
                padding: EdgeInsets.only(top: size.getH(12)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      LN.eodCasPay,
                      style: TextStyle(
                        fontSize: size.getS(18),
                        // fontFamily: ,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
              Align(
                alignment: Alignment.topRight,
                child: IconButton(
                    visualDensity: VisualDensity.compact,
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: Icon(Icons.close)),
              )
            ],
          ),
          Flexible(
            child: SingleChildScrollView(
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: size.getH(12),
                  ),
                  Table(
                    defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                    border: TableBorder.all(
                      width: 0.7,
                      color: Colors.black54,
                    ),
                    children: [
                      TableRow(
                          decoration: BoxDecoration(
                              border: Border.all(
                                width: 0.5,
                                color: Colors.black54,
                              ),
                              color: Colors.grey[200]),
                          children: [
                            Padding(
                              padding: EdgeInsets.symmetric(
                                  vertical: size.getH(8),
                                  horizontal: size.getW(8)),
                              child: Text(
                                LN.calculatedCash,
                                style: TextStyle(
                                  fontSize: size.getS(16),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            Container()
                          ]),
                      _tableRow1(size, title: "Cash", value: cashData.cash),
                      _tableRow1(size, title: "Float", value: cashData.float),
                      _tableRow1(
                        size,
                        title: "Cash out",
                        value: cashData.cashOut,
                        isRedValue: true,
                      ),
                      _tableRow1(size,
                          title: "Cash In", value: cashData.cashIn),
                      _tableRow1(
                        size,
                        title: "Total",
                        value: total1.roundToNString(),
                        isBold: true,
                      )
                    ],
                  ),
                  SizedBox(
                    height: size.getH(24),
                  ),
                  Table(
                    defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                    border: TableBorder.all(
                      width: 0.7,
                      color: Colors.black54,
                    ),
                    children: [
                      TableRow(
                          decoration: BoxDecoration(
                              border: Border.all(
                                width: 0.5,
                                color: Colors.black54,
                              ),
                              color: Colors.grey[200]),
                          children: [
                            Padding(
                              padding: EdgeInsets.symmetric(
                                  vertical: size.getH(8),
                                  horizontal: size.getW(8)),
                              child: Text(
                                "Counted Cash",
                                style: TextStyle(
                                  fontSize: size.getS(16),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            Container(),
                            Container()
                          ]),
                      TableRow(children: [
                        Padding(
                          padding: EdgeInsets.symmetric(
                              vertical: size.getH(8), horizontal: size.getW(8)),
                          child: Text(
                            "Money",
                            style: TextStyle(
                              fontSize: size.getS(15),
                              fontFamily: kFontFMedium,
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(
                              vertical: size.getH(8), horizontal: size.getW(8)),
                          child: Text(
                            "No of unit",
                            style: TextStyle(
                              fontSize: size.getS(15),
                              fontFamily: kFontFMedium,
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(
                              vertical: size.getH(8), horizontal: size.getW(8)),
                          child: Text(
                            "Total",
                            style: TextStyle(
                              fontSize: size.getS(15),
                              fontFamily: kFontFMedium,
                            ),
                          ),
                        ),
                      ]),
                      ...List.generate(
                          countedCash.length,
                          (i) => _tableRow2(
                                size,
                                title: "$curSym${countedCash[i].money}",
                                unitCltr: countedCash[i].unitCltr,
                                total: "$curSym${_getTotal2([
                                      countedCash[i]
                                    ]).roundToNString()}",
                                onChanged: () {
                                  load();
                                },
                              )),
                      _tableRow2(
                        size,
                        title: "",
                        unitCltr: TextEditingController(),
                        total: "-",
                      ),
                      _tableRow2(
                        size,
                        title: "",
                        unitCltr: TextEditingController(),
                        total: "-",
                      ),
                      _tableRow2(
                        size,
                        isBold: true,
                        title: "Total",
                        unitCltr: TextEditingController(),
                        total: "$curSym${total2.roundToNString()}",
                      ),
                      _tableRow2(
                        size,
                        title: "",
                        unitCltr: TextEditingController(),
                        total: "",
                      ),
                      _tableRow2(
                        size,
                        title: "Variance",
                        unitCltr: TextEditingController(),
                        total: "$curSym${variance.roundToNString()}".negPrice(),
                        isRedValue: total1 < total2,
                        isBold: true,
                      ),
                      _tableRow2(
                        size,
                        title: "",
                        unitCltr: TextEditingController(),
                        total: "",
                      ),
                      _tableRow2(
                        size,
                        title: "Actual Cash",
                        unitCltr: TextEditingController(),
                        total:
                            "$curSym${actualCash.roundToNString()}".negPrice(),
                        isBold: true,
                      ),
                    ],
                  ),
                  SizedBox(
                    height: size.getH(40),
                  ),
                  Center(
                    child: LoadButton(
                      btnText: LN.langModelContinue,
                      onsave: () {
                        Navigator.of(context).pop(actualCash);
                      },
                    ),
                  ),
                  SizedBox(
                    height: size.getH(100),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  TableRow _tableRow1(
    Ssize size, {
    String? title,
    String? value,
    bool isBold = false,
    bool isRedValue = false,
  }) {
    final textCltr = TextEditingController(text: value?.replaceAll('-', ''));
    return TableRow(
        decoration: BoxDecoration(
          border: Border.all(
            width: 0.5,
            color: Colors.black,
          ),
        ),
        children: [
          Padding(
            padding: EdgeInsets.symmetric(
                vertical: size.getW(6), horizontal: size.getW(8)),
            child: Text(
              title ?? "",
              style: TextStyle(
                fontSize: size.getS(16),
                color: Colors.black,
                fontWeight: isBold ? FontWeight.bold : null,
              ),
            ),
          ),
          TextFormWidget(
            cltr: textCltr,
            readOnly: true,
            borderRadius: 0,
            borderColor: isRedValue ? Colors.red.withAlpha(50) : Colors.black26,
            fillColor: isRedValue ? Colors.red.withAlpha(40) : Colors.white,
            textAlign: TextAlign.start,
            textInputType: TextInputType.number,
            textStyle: TextStyle(
              fontWeight: isBold ? FontWeight.bold : null,
              color: isRedValue ? Colors.red.shade900 : Colors.black,
            ),
            vPad: 7,
            prefix: Text.rich(TextSpan(
                text: value != null && value.contains('-') ? "- " : "   ",
                style: TextStyle(
                  fontSize: size.getS(16),
                  color: isRedValue ? Colors.red.shade700 : Colors.black,
                  fontWeight: isBold ? FontWeight.bold : null,
                ),
                children: [
                  TextSpan(
                    text: curSym,
                    style: TextStyle(
                      fontSize: size.getS(16),
                      color: isRedValue ? Colors.red.shade900 : Colors.black,
                      fontWeight: isBold ? FontWeight.bold : null,
                    ),
                  )
                ])),
            suffixIcon: SizedBox.shrink(),
            // suffixIconWidth: size.getW(440),
            hintText: '',
          )
        ]);
  }

  TableRow _tableRow2(
    Ssize size, {
    required String title,
    required TextEditingController unitCltr,
    required String total,
    Function()? onChanged,
    bool isBold = false,
    bool isRedValue = false,
  }) {
    return TableRow(
        decoration: BoxDecoration(
          border: Border.all(
            width: 0.5,
            color: Colors.black,
          ),
        ),
        children: [
          Padding(
            padding: EdgeInsets.symmetric(
                vertical: size.getW(6), horizontal: size.getW(8)),
            child: Text(
              title,
              style: TextStyle(
                fontSize: size.getS(16),
                color: Colors.black,
                fontWeight: isBold ? FontWeight.bold : null,
              ),
            ),
          ),
          TextFormWidget(
            cltr: unitCltr,
            readOnly: onChanged == null,
            borderRadius: 0,
            borderColor: Colors.black26,
            textAlign: TextAlign.start,
            textInputType: TextInputType.number,
            textStyle: TextStyle(),
            vPad: 7,
            suffixIcon: SizedBox.shrink(),
            suffix: onChanged == null
                ? null
                : Icon(
                    Icons.edit,
                    size: size.getS(16),
                    color: Colors.black54,
                  ),
            hintText: '',
            onChanged: (p0) {
              if (p0 == null || onChanged == null) return;
              onChanged();
            },
          ),
          Container(
            decoration: BoxDecoration(
                color: isRedValue ? Colors.red.withAlpha(40) : Colors.white),
            padding: EdgeInsets.symmetric(
                vertical: size.getW(6), horizontal: size.getW(8)),
            child: Text(
              total,
              style: TextStyle(
                fontSize: size.getS(16),
                color: isRedValue ? Colors.red.shade900 : Colors.black,
                fontWeight: isBold ? FontWeight.bold : null,
              ),
            ),
          ),
        ]);
  }
}
