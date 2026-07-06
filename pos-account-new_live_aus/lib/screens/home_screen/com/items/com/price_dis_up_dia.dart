import 'package:flutter/material.dart';
import 'package:pos_account/config/size_config.dart';
import 'package:pos_account/config/validator.dart';
import 'package:pos_account/constant/constant.dart';
import 'package:pos_account/constant/text_formatter.dart';
import 'package:pos_account/ln.dart';
import 'package:pos_account/repository/if_exception.dart';
import 'package:pos_account/screens/home_screen/com/items/sidebar/order_section/com/order_detail_sec.dart';
import 'package:pos_account/services/database/shared_pref.dart';
import 'package:pos_account/widgets/input/text_form/text_form_widget.dart';
import 'package:pos_account/widgets/load_btn.dart';

import 'price_update_dia.dart';

enum PriceDisEnum { Price, Discount }

class PriceDiscountReturner {
  final PriceDisEnum priceDisEnum;
  final double value;
  final String? disPercent;
  final String? disAmount;

  PriceDiscountReturner({
    required this.priceDisEnum,
    required this.value,
    this.disPercent,
    this.disAmount,
  });
}

// ignore_for_file: must_be_immutable
class PriceDisUpDia extends StatefulWidget {
  String value;
  final String? title;
  final double max;
  final String? disPercent;
  final String? actualPrice;
  PriceDisUpDia({
    super.key,
    this.value = "0",
    this.title,
    this.max = 1000000,
    this.disPercent,
    this.actualPrice,
  });

  static Future<PriceDiscountReturner?> showDia(
    BuildContext context, {
    double? number,
    String? disPercent,
    String? actualPrice,
    String? title,
    double max = 1000000,
  }) async {
    final _num = number == 0 ? 0 : number?.formatDouble;
    final _val = await showDialog(
        context: context,
        builder: (_) {
          return SimpleDialog(
            backgroundColor: kBackgroundColor,
            titlePadding: EdgeInsets.zero,
            contentPadding: EdgeInsets.symmetric(horizontal: 0),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
            children: [
              PriceDisUpDia(
                title: title,
                value: '${_num ?? '0'}',
                max: max,
                disPercent: disPercent,
                actualPrice: actualPrice,
              ),
            ],
          );
        });
    if (_val != null) {
      if (_val is PriceDiscountReturner) return _val;
    }

    return null;

    // return PriceDiscountReturner(
    //     priceDisEnum: PriceDisEnum.Price, value: number ?? 0.0);
  }

  @override
  State<PriceDisUpDia> createState() => _PriceDisUpDiaState();
}

class _PriceDisUpDiaState extends State<PriceDisUpDia>
    with SingleTickerProviderStateMixin {
  final _scrollCltr = ScrollController();

  void load() {
    if (mounted) setState(() {});
  }

  @override
  void initState() {
    super.initState();
    setUp();
  }

  final _tabList = <String>[LN.changePrice, "Add Discount"];
  TabController? _tabCltr;

  String curSym = '\$';

  void setUp() {
    _tabCltr = TabController(length: _tabList.length, vsync: this);
    if (widget.disPercent != null) {
      discountPercentCltr.text = widget.disPercent ?? '';
      _discountText = (discountPercentCltr.text.inDouble *
              (widget.actualPrice ?? widget.value).inDouble /
              100)
          .formatDouble;

      load();
      SharedPrefs.curSym.then((value) {
        curSym = value;
        load();
      });
    }
  }

  @override
  void dispose() {
    if (_tabCltr != null) _tabCltr!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = Ssize(context);
    return Container(
      height: size.height * 0.78,
      width: size.width / 2.2,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
      ),
      child: DefaultTabController(
        length: _tabList.length,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(
                  horizontal: size.getW(16), vertical: size.getH(8)),
              decoration: BoxDecoration(
                // color: kSecondaryColor,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(5),
                  topRight: Radius.circular(5),
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Spacer(
                    flex: 3,
                  ),
                  SizedBox(
                    height: size.getH(72),
                    child: TabBar(
                      tabs: List.generate(
                          _tabList.length,
                          (index) => Tab(
                                iconMargin: EdgeInsets.zero,
                                child: Padding(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: size.getW(16),
                                  ),
                                  child: Text(
                                    _tabList[index],
                                  ),
                                ),
                              )),
                      indicatorColor: Colors.transparent,
                      labelColor: Colors.white,
                      controller: _tabCltr,
                      isScrollable: true,
                      indicator: BoxDecoration(
                        color: kSecondaryColor,
                      ),
                      labelStyle: TextStyle(
                        fontSize: size.getS(26),
                        fontFamily: kFontFMedium,
                      ),
                      padding: EdgeInsets.zero,
                      unselectedLabelColor: Colors.black54,
                    ),
                  ),
                  Spacer(flex: 2),
                  InkWell(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Container(
                      padding: EdgeInsets.all(size.getW(8)),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.close,
                        size: size.getS(32),
                        color: Colors.red.shade700,
                      ),
                    ),
                  )
                ],
              ),
            ),
            if (_tabCltr != null)
              Flexible(
                child: TabBarView(
                  controller: _tabCltr,
                  physics: NeverScrollableScrollPhysics(),
                  children: [
                    __priceTab(size),
                    _discountTab(size),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget __priceTab(Ssize size) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Container(
            decoration: BoxDecoration(
              color: kBackgroundColor,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.grey.shade300, width: 1),
            ),
            alignment: Alignment.centerRight,
            width: double.infinity,
            padding: EdgeInsets.symmetric(
                horizontal: size.getW(12), vertical: size.getH(4)),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Expanded(
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: SingleChildScrollView(
                      controller: _scrollCltr,
                      scrollDirection: Axis.horizontal,
                      child: Text(
                        widget.value,
                        textAlign: TextAlign.end,
                        style: TextStyle(
                          fontSize: size.getS(60),
                          color: Colors.black,
                        ),
                        maxLines: 1,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        Flexible(
          child: PriceUpdateDia(
            value: widget.value,
            title: widget.title,
            max: widget.max,
            property: PriceDiaProperty(
              isDia: false,
              scrollCltr: _scrollCltr,
              onTap: (val) {
                widget.value = val;

                Future.delayed(Duration(milliseconds: 50), () {
                  if (_scrollCltr.hasClients &&
                      _scrollCltr.positions.isNotEmpty)
                    _scrollCltr.animateTo(_scrollCltr.position.maxScrollExtent,
                        duration: Duration(milliseconds: 100),
                        curve: Curves.linearToEaseOut);
                });
                load();
              },
              onOk: (val) {
                final data = double.tryParse(val);
                if (data != null)
                  Navigator.of(context).pop(PriceDiscountReturner(
                      priceDisEnum: PriceDisEnum.Price, value: data));
              },
            ),
          ),
        )
      ],
    );
  }

  bool isDisPercentTab = true;
  final discountPercentCltr = TextEditingController();
  String? _discountText;

  Widget _discountTab(Ssize size) {
    final _percentList = ["5", "10", "20", "25", "50", "75", "100"];
    final _price = widget.actualPrice ?? widget.value;
    return Padding(
      padding: EdgeInsets.symmetric(
          horizontal: size.getW(24), vertical: size.getH(12)),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          PercentageDollarToggle(
            size: size,
            value: isDisPercentTab,
            leftText: '%',
            rightText: curSym,
            onToggle: (value) {
              isDisPercentTab = !isDisPercentTab;
              load();
            },
          ),
          SizedBox(height: size.getH(12)),
          TextFormWidget(
            vPad: 12,
            borderRadius: 5,
            borderColor: Colors.black26,
            isReq: false,
            readOnly: true,
            initValidate: true,
            fillColor: Colors.white,
            cltr: isDisPercentTab
                ? discountPercentCltr
                : TextEditingController(text: _discountText),
            hintText: "0.00",
            textInputType: TextInputType.number,
            textAlign: TextAlign.right,
            focusBorderColor: Colors.black12,
            inputFormatters: [Between0And100TextInputFormatter()],
            errH: 0,
            suffix: isDisPercentTab
                ? Text(
                    "%",
                    style: TextStyle(
                      fontSize: size.getS(16),
                      color: Colors.black,
                      fontFamily: kFontFMedium,
                    ),
                  )
                : null,
            prefix: isDisPercentTab
                ? null
                : Text(
                    "$curSym ",
                    style: TextStyle(
                      fontSize: size.getS(16),
                      color: Colors.black,
                      fontFamily: kFontFMedium,
                    ),
                  ),
            onTap: () async {
              if (isDisPercentTab) {
                final _discountPer = await PriceUpdateDia.showDia(
                  context,
                  number: double.tryParse(discountPercentCltr.text),
                  title: "Discount Percent(%)",
                  max: 100,
                );
                discountPercentCltr.text = _discountPer.roundToNString();

                _discountText =
                    (_price.inDouble * _discountPer / 100).formatDouble;

                load();
              } else {
                final _discount = await PriceUpdateDia.showDia(
                  context,
                  number: _discountText.inDouble,
                  title: "Discount Amount",
                );
                final _amount = _price.inDouble;

                if (_discount > _amount) {
                  IfException.showMessage(message: "Discount Amount is Higher");
                  return;
                }

                _discountText = _discount.formatDouble;
                discountPercentCltr.text =
                    (_discount * 100 / _price.inDouble).formatDouble;

                load();
              }
            },
          ),
          SizedBox(height: size.getH(12)),
          if (isDisPercentTab)
            Center(
              child: Wrap(
                alignment: WrapAlignment.center,
                spacing: size.getW(12),
                runSpacing: size.getH(10),
                children: _percentList.map((percent) {
                  return InkWell(
                    onTap: () {
                      discountPercentCltr.text = percent;
                      _discountText = (_price.inDouble * percent.inDouble / 100)
                          .formatDouble;
                      load();
                    },
                    child: Container(
                      width: size.getW(60),
                      height: size.getH(50),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(
                          color: discountPercentCltr.text == percent
                              ? kSecondaryColor
                              : Colors.grey.shade400,
                          width: 1,
                        ),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Center(
                        child: Text(
                          "$percent%",
                          style: TextStyle(
                            color: kPrimaryColor,
                            fontSize: size.getS(18),
                            fontFamily: kFontFMedium,
                          ),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          SizedBox(height: size.getH(12)),
          if (discountPercentCltr.text.isNotEmpty &&
              discountPercentCltr.text != "0.00")
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Discount(%): ${discountPercentCltr.text}%",
                  style: TextStyle(
                    fontSize: size.getS(18),
                    color: Colors.black,
                    fontFamily: kFontFMedium,
                  ),
                ),
                SizedBox(height: size.getH(6)),
                Text(
                  "Discount Amount: $curSym$_discountText",
                  style: TextStyle(
                    fontSize: size.getS(18),
                    color: Colors.black,
                    fontFamily: kFontFMedium,
                  ),
                ),
              ],
            ),
          SizedBox(height: size.getH(24)),
          Padding(
            padding: EdgeInsets.only(right: size.getH(20.0)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                LoadButton(
                  width: 160,
                  btnText: "${LN.clear} ${LN.discount}",
                  hPad: 4,
                  btnColor: Colors.red.shade700,
                  textColor: Colors.white,
                  onsave: () {
                    discountPercentCltr.text = "0.00";
                    _discountText = "";
                    load();
                  },
                ),
                SizedBox(
                  width: size.getW(20),
                ),
                LoadButton(
                  width: 200,
                  btnText: LN.ok,
                  hPad: 4,
                  btnColor: kSecondaryColor,
                  textColor: Colors.white,
                  onsave: () {
                    Navigator.of(context).pop(PriceDiscountReturner(
                        priceDisEnum: PriceDisEnum.Discount,
                        value: _price.inDouble - _discountText.inDouble,
                        disAmount: _discountText,
                        disPercent: discountPercentCltr.text));
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
