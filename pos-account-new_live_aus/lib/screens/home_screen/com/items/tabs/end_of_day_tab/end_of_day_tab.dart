import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pos_account/config/size_config.dart';
import 'package:pos_account/config/utils/utils.dart';
import 'package:pos_account/config/validator.dart';
import 'package:pos_account/constant/constant.dart';
import 'package:pos_account/constant/strings.dart';
import 'package:pos_account/ln.dart';
import 'package:pos_account/providers/cus_val_pro.dart';
import 'package:pos_account/providers/eod/eod_pro.dart';
import 'package:pos_account/widgets/input/dropdown/drop_down.dart';
import 'package:pos_account/widgets/input/text_form/text_form_widget.dart';
import 'package:pos_account/widgets/load_btn.dart';
import 'package:pos_account/widgets/loading.dart';
import 'package:pos_account/widgets/no_items_sec.dart';
import 'package:pos_account/widgets/title_pop.dart';
import 'package:provider/provider.dart';
import '../setting_tab/com/general/common/common_header.dart';
import 'com/cash_dia.dart';
import 'com/cash_io_dia.dart';
import 'com/finalize_eod_dia.dart';

class EndOfDayTab extends StatefulWidget {
  final GlobalKey<ScaffoldState> scafKey;
  const EndOfDayTab({
    super.key,
    required this.scafKey,
  });

  @override
  State<EndOfDayTab> createState() => _EndOfDayTabState();
}

class _EndOfDayTabState extends State<EndOfDayTab> {
  final _formKey = GlobalKey<FormState>();
  final _scrollCltr = ScrollController();

  final _countedCash = <CountedCash>[
    CountedCash(money: 100, unitCltr: TextEditingController(text: "0")),
    CountedCash(money: 50, unitCltr: TextEditingController(text: "0")),
    CountedCash(money: 20, unitCltr: TextEditingController(text: "0")),
    CountedCash(money: 10, unitCltr: TextEditingController(text: "0")),
    CountedCash(money: 5, unitCltr: TextEditingController(text: "0")),
    CountedCash(money: 2, unitCltr: TextEditingController(text: "0")),
    CountedCash(money: 1, unitCltr: TextEditingController(text: "0")),
    CountedCash(money: 0.50, unitCltr: TextEditingController(text: "0")),
    CountedCash(money: 0.20, unitCltr: TextEditingController(text: "0")),
    CountedCash(money: 0.10, unitCltr: TextEditingController(text: "0")),
    CountedCash(money: 0.05, unitCltr: TextEditingController(text: "0")),
  ];

  void showcashInOutDia({required Ssize size}) {
    showDialog(
        context: context,
        builder: (ctx) => SimpleDialog(
              backgroundColor: kBackgroundColor,
              titlePadding: EdgeInsets.zero,
              contentPadding: EdgeInsets.symmetric(horizontal: size.getW(24)),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              children: [CashInOutDia()],
            ));
  }

  void showcashDia({required Ssize size}) {
    final calcuData = CalcuatedCashData();

    if (_pro?.allEodData?.eodChartOfAccountPayment != null)
      for (var e in _pro!.allEodData!.eodChartOfAccountPayment!) {
        if (e.chartOfAccountNameEnum?.toLowerCase() == Strings.cash) {
          calcuData.cash = e.formattedAmount;
        } else if (e.chartOfAccountNameEnum?.toLowerCase() == Strings.float) {
          calcuData.float = e.amount;
        } else if (e.chartOfAccountNameEnum?.toLowerCase() == "cashin") {
          calcuData.cashIn = e.amount;
        } else if (e.chartOfAccountNameEnum?.toLowerCase() == "cashout") {
          calcuData.cashOut = e.amount;
        }
      }

    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (ctx) => SimpleDialog(
              backgroundColor: kBackgroundColor,
              titlePadding: EdgeInsets.zero,
              contentPadding: EdgeInsets.symmetric(horizontal: size.getW(24)),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              children: [
                CashDialog(
                  cashData: calcuData,
                  countedCash: _countedCash,
                )
              ],
            )).then((value) {
      if (value != null && value is double) {
        final _val = value;
        final _cash = _pro!.allEodData!.eodChartOfAccountPayment!.firstWhere(
            (e) => e.chartOfAccountNameEnum?.toLowerCase() == Strings.cash);
        _cash.amount = _val.roundToNString();
        _cash.textCltr?.text = _val.abs().roundToNString();
        _pro?.setEodResult(_cash.name);
      }
    });
  }

  Future<void> _printEod() async {
    if (_pro?.screenLoad ?? false) return;

    await _pro?.printEod();

    GlobalCVP.setOrPath = PathOfOrder.MENUPATH;
    GlobalCVP.setEndDValue = 11;
    Future.delayed(Duration(milliseconds: 300), () {
      if (mounted) widget.scafKey.currentState!.openEndDrawer();
    });
    // if (mounted) {
    //   showDialog(
    //       context: context,
    //       builder: (ctx) {
    //         return ConfirmDialog(
    //           title: "${LN.printEod} ?",
    //           subTitle: LN.printEod,
    //           actionText: LN.print,
    //           onDelete: () async {
    // await EodPrint.printEodReport(e: _pro?.eodReportRes);
    //             return null;
    //           },
    //         );
    //       });
    // }
  }

  @override
  void initState() {
    super.initState();
    getData();
  }

  EodPro? _pro;

  void getData() async {
    _pro = Provider.of<EodPro>(context, listen: false);

    await _pro?.getDateFor();
    await _pro?.getAddSec();
    await _pro?.getData(page: 1);
  }

  @override
  void dispose() {
    _pro?.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // final _cvp = Provider.of<CusValuePro>(context);
    final size = Ssize(context);
    final pro = Provider.of<EodPro>(context);
    return Processing(
      loading: pro.screenLoad,
      child: Column(
        children: [
          CommonHeader(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TitlePop(
                  title: LN.endOfTheDay,
                  size: size,
                  onTap: () {
                    GlobalCVP.setMainPage = MainPage.ManagePage;
                  },
                ),
                Row(
                  children: [
                    ElevatedButton(
                        style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all(kSecondaryColor),
                            padding: MaterialStateProperty.all(
                                EdgeInsets.symmetric(
                                    horizontal: size.getW(12),
                                    vertical: size.getH(8)))),
                        onPressed: () {
                          showcashInOutDia(size: size);
                          // if (widget.scafKey.currentState != null) {
                          //   _cvp.setEndDValue = 0;
                          //   widget.scafKey.currentState!.openEndDrawer();
                          // }
                        },
                        child: Text(
                          LN.cashInOut,
                          style: TextStyle(
                            fontSize: size.getS(16),
                            color: Colors.white,
                          ),
                        )),
                    SizedBox(
                      width: size.getW(12),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Flexible(
            child: Scrollbar(
              controller: _scrollCltr,
              // isAlwaysShown: true,
              // showTrackOnHover: true,
              interactive: true,
              thickness: 7,
              radius: Radius.circular(40),
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(
                    vertical: size.getH(2.0), horizontal: size.getW(24)),
                child: SingleChildScrollView(
                  controller: _scrollCltr,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: size.getH(8)),
                        child: Form(
                          key: _formKey,
                          child: Wrap(
                            crossAxisAlignment: WrapCrossAlignment.center,
                            runSpacing: size.getH(12),
                            spacing: size.getW(18),
                            children: [
                              SizedBox(
                                  width: size.getW(200),
                                  child: DropDownList(
                                    isReq: true,
                                    vPad: 11,
                                    errH: 0,
                                    list: pro.eodAddSec?.accountingPlatforms ==
                                            null
                                        ? []
                                        : pro.eodAddSec!.accountingPlatforms!
                                            .map((e) => e.name ?? '')
                                            .toList(),
                                    indexValue:
                                        pro.eodAddSec?.accountingPlatforms ==
                                                null
                                            ? null
                                            : pro.platformIndex,
                                    borderColor: Colors.black26,
                                    hint: LN.choosePlatform,
                                    onChange: (p0) {
                                      pro.platformIndex = p0;
                                      pro.notify;
                                    },
                                  )),
                              SizedBox(
                                  width: size.getW(200),
                                  child: DropDownList(
                                    isReq: true,
                                    errH: 0,
                                    vPad: 11,
                                    list: pro.eodAddSec
                                                ?.taxExclusiveInclusives ==
                                            null
                                        ? []
                                        : pro.eodAddSec!.taxExclusiveInclusives!
                                            .map((e) => e.value ?? '')
                                            .toList(),
                                    indexValue:
                                        pro.eodAddSec?.taxExclusiveInclusives ==
                                                null
                                            ? null
                                            : pro.taxTypeIndex,
                                    borderColor: Colors.black26,
                                    hint: LN.chooseTaxType,
                                    onChange: (p0) {
                                      pro.taxTypeIndex = p0;
                                      pro.notify;
                                    },
                                  )),
                              SizedBox(
                                width: size.getW(140),
                                child: TextFormWidget(
                                  isReq: true,
                                  readOnly: true,
                                  borderRadius: 5,
                                  vPad: 11,
                                  errH: 0,
                                  borderColor: Colors.black26,
                                  cltr: TextEditingController(
                                      text: pro.dateCltr.text.split(' ').first),
                                  hintText: LN.chooseDate,
                                  onTap: () {
                                    Utils.datePick(context,
                                            initDate: pro.dateCltr.text.isEmpty
                                                ? null
                                                : DateFormat(pro.dateFormat)
                                                    .parse(pro.dateCltr.text))
                                        .then((_date) {
                                      if (_date == null) return;
                                      pro.dateCltr.text =
                                          DateFormat(pro.dateFormat)
                                              .format(_date);
                                      pro.notify;
                                    });
                                  },
                                ),
                              ),
                              if (GlobalCVP.viewWidget.viewCalculateEodButton)
                                LoadButton(
                                  vPad: 10,
                                  width: 172,
                                  hPad: 10,
                                  loading: false,
                                  btnColor: kSecondaryColor,
                                  btnText: LN.calculateEod,
                                  onsave: pro.screenLoad
                                      ? null
                                      : () {
                                          if (_formKey.currentState!
                                              .validate()) {
                                            pro.screenLoad = true;
                                            pro.allEodData = null;
                                            pro.keyValList.clear();
                                            pro.notify;
                                            pro.getData(page: pro.pageIndex);
                                          }
                                        },
                                ),
                              if (GlobalCVP.viewWidget.viewFinalizeEodButton)
                                LoadButton(
                                  vPad: 10,
                                  loading: false,
                                  btnColor: kTempColor,
                                  btnText: LN.finalizeEod,
                                  onsave: () {
                                    pro.clearFinalizeDia();
                                    showDialog(
                                        context: context,
                                        builder: (ctx) {
                                          return SimpleDialog(
                                            backgroundColor: kBackgroundColor,
                                            titlePadding: EdgeInsets.zero,
                                            contentPadding:
                                                EdgeInsets.symmetric(
                                                    horizontal: size.getW(24)),
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(15)),
                                            children: [FinalizeEodDia()],
                                          );
                                        });
                                  },
                                ),
                              LoadButton(
                                vPad: 10,
                                loading: false,
                                btnColor: kPrimaryColor,
                                btnText: LN.printEod,
                                onsave: pro.screenLoad
                                    ? null
                                    : () {
                                        _printEod();
                                      },
                              ),
                              // Material(
                              //   color: kSecondaryColor,
                              //   borderRadius: BorderRadius.circular(100),
                              //   child: InkWell(
                              //       onTap: () {},
                              //       highlightColor: kPrimaryColor,
                              //       borderRadius: BorderRadius.circular(100),
                              //       child: Container(
                              //         decoration: BoxDecoration(
                              //           shape: BoxShape.circle,
                              //           border: Border.all(color: kSecondaryColor),
                              //         ),
                              //         child: Padding(
                              //           padding: EdgeInsets.all(size.getS(4)),
                              //           child: Icon(
                              //             Icons.file_download_outlined,
                              //             color: Colors.white,
                              //             size: size.getS(36),
                              //           ),
                              //         ),
                              //       )),
                              // )
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        height: size.getH(4),
                      ),
                      if (pro.allEodData?.message != null &&
                          pro.allEodData!.message!.isNotEmpty)
                        NoItemsSec(
                          size: size,
                          title: pro.allEodData?.message ?? "",
                        )
                      else ...[
                        Wrap(
                          spacing: 0, // size.getW(16),
                          runSpacing: 0, // size.getH(12),
                          children:
                              List.generate(pro.keyValList.length, (index) {
                            if (pro.keyValList[index].key
                                    .toLowerCase()
                                    .contains("uber") ||
                                pro.keyValList[index].key
                                    .toLowerCase()
                                    .contains("door") ||
                                pro.keyValList[index].key
                                    .toLowerCase()
                                    .contains("menu"))
                              return SizedBox.shrink();
                            else
                              return Padding(
                                padding: EdgeInsets.only(
                                    right: size.getW(16),
                                    bottom: size.getH(12)),
                                child: Card(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10)),
                                  color: kPrimaryColor,
                                  child: SizedBox(
                                    width: size.getW(222),
                                    child: Padding(
                                      padding: EdgeInsets.symmetric(
                                          vertical: size.getH(16.0),
                                          horizontal: size.getW(12)),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            ((pro.curSym ?? '') +
                                                    pro.keyValList[index].value)
                                                .negPrice(),
                                            style: TextStyle(
                                              fontSize: size.getS(22),
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                              fontFamily: kFontFMedium,
                                            ),
                                          ),
                                          Text(
                                            pro.keyValList[index].key,
                                            style: TextStyle(
                                              fontSize: size.getS(16),
                                              color: Colors.white,
                                              fontFamily: kFontFMedium,
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              );
                          }),
                        ),
                        SizedBox(
                          height: size.getH(24),
                        ),
                        if (pro.allEodData?.eodChartOfAccountPayment != null)
                          Card(
                            child: SizedBox(
                              width: double.infinity,
                              // height: 400,
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                    vertical: size.getH(48.0),
                                    horizontal: size.getW(24)),
                                child: Table(
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
                                                vertical: size.getH(12),
                                                horizontal: size.getW(8)),
                                            child: Text(
                                              LN.payWithEodRecon,
                                              style: TextStyle(
                                                fontSize: size.getS(16),
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.symmetric(
                                                vertical: size.getH(12),
                                                horizontal: size.getW(8)),
                                            child: Text(
                                              LN.amount,
                                              style: TextStyle(
                                                fontSize: size.getS(16),
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          )
                                        ]),
                                    ...List.generate(
                                      pro.allEodData!.eodChartOfAccountPayment!
                                          .length,
                                      (index) {
                                        if (pro.allEodData
                                                ?.eodChartOfAccountPayment ==
                                            null) return TableRow();

                                        final _payment = pro.allEodData!
                                            .eodChartOfAccountPayment![index];
                                        final bool _isBold = pro
                                                    .allEodData!
                                                    .eodChartOfAccountPayment!
                                                    .length -
                                                3 <
                                            index;

                                        final _prefixSym = _payment.amount ==
                                                    null ||
                                                ((double.tryParse(
                                                            _payment.amount!) ??
                                                        0) >=
                                                    0) ||
                                                (_payment.textCltr != null &&
                                                    _payment.textCltr!.text
                                                        .contains('-'))
                                            ? '   '
                                            : '- ';

                                        return TableRow(
                                            decoration: BoxDecoration(
                                              border: Border.all(
                                                width: _isBold ? 1 : 0.5,
                                                color: Colors.black,
                                              ),
                                            ),
                                            children: [
                                              Padding(
                                                padding: EdgeInsets.all(
                                                    size.getW(8)),
                                                child: Text(
                                                  _payment.name ?? '',
                                                  style: TextStyle(
                                                      fontSize: size.getS(16),
                                                      color: Colors.black,
                                                      fontWeight: _isBold
                                                          ? FontWeight.bold
                                                          : null),
                                                ),
                                              ),
                                              TextFormWidget(
                                                readOnly: _payment
                                                            .chartOfAccountNameEnum
                                                            ?.toLowerCase() ==
                                                        Strings.cash ||
                                                    _payment.readOnly,
                                                borderRadius: 0,
                                                borderColor: _isBold
                                                    ? Colors.black
                                                    : Colors.black26,
                                                textAlign: TextAlign.start,
                                                textInputType:
                                                    TextInputType.number,
                                                textStyle: TextStyle(
                                                    fontSize: size.getS(16),
                                                    fontWeight: _isBold
                                                        ? FontWeight.bold
                                                        : null),
                                                vPad: 7,
                                                prefix: Text.rich(TextSpan(
                                                    text: _prefixSym,
                                                    style: TextStyle(
                                                      fontSize: size.getS(16),
                                                      color: Colors.black,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                    children: [
                                                      TextSpan(
                                                        text: pro.allEodData
                                                                ?.currencySymbol ??
                                                            '',
                                                        style: TextStyle(
                                                          fontSize:
                                                              size.getS(16),
                                                          color: Colors.black,
                                                          fontWeight:
                                                              FontWeight.normal,
                                                        ),
                                                      )
                                                    ])),
                                                suffixIcon: SizedBox.shrink(),
                                                suffix: _payment.readOnly
                                                    ? null
                                                    : Icon(
                                                        Icons.edit,
                                                        size: size.getS(16),
                                                        color: Colors.black54,
                                                      ),
                                                // suffixIconWidth: size.getW(
                                                //     _payment.readOnly ? 360 : 340),
                                                cltr: _payment.textCltr!,
                                                hintText: '',
                                                onChanged: (p0) {
                                                  if (p0 == null) return;
                                                  pro
                                                      .allEodData!
                                                      .eodChartOfAccountPayment![
                                                          index]
                                                      .amount = _prefixSym
                                                              .contains('-') ||
                                                          p0.contains('-')
                                                      ? ('-${p0.replaceFirst('-', '')}')
                                                      : p0;
                                                  pro.setEodResult(pro
                                                      .allEodData!
                                                      .eodChartOfAccountPayment![
                                                          index]
                                                      .name);
                                                },
                                                onSubmitted: (p0) {
                                                  pro.setEodResult(null);
                                                },
                                                onTap: () {
                                                  if (_payment
                                                          .chartOfAccountNameEnum
                                                          ?.toLowerCase() ==
                                                      Strings.cash)
                                                    showcashDia(size: size);
                                                },
                                              )
                                            ]);
                                      },
                                    )
                                  ],
                                ),
                              ),
                            ),
                          )
                      ],
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
