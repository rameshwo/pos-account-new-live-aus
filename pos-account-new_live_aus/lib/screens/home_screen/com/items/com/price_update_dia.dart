// ignore_for_file: must_be_immutable

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:pos_account/config/size_config.dart';
import 'package:pos_account/config/validator.dart';
import 'package:pos_account/constant/constant.dart';
import '../../../../../ln.dart';

class PriceUpdateDia<T> extends StatefulWidget {
  String value;
  final String? title;
  final double max;
  final PriceDiaProperty? property;

  PriceUpdateDia(
      {this.value = "0",
      this.title,
      this.max = 1000000,
      this.property,
      super.key});

  static Future<double> showDia<T>(
    BuildContext context, {
    double? number,
    String? title,
    double max = 1000000,
  }) async {
    final _num = T == int
        ? number?.floor()
        : number == 0
            ? 0
            : number.formatDouble;
    final _val = await showDialog<T?>(
        context: context,
        builder: (_) {
          return SimpleDialog(
            backgroundColor: kBackgroundColor,
            titlePadding: EdgeInsets.zero,
            contentPadding: EdgeInsets.symmetric(horizontal: 0),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
            children: [
              PriceUpdateDia<T>(
                title: title,
                value: '${_num ?? '0'}',
                max: max,
              ),
            ],
          );
        });
    if (_val != null) {
      if (_val is int && _val != 0)
        return _val.toDouble();
      else if (_val is double) return _val;
    }

    return number ?? 0.0;
  }

  @override
  State<PriceUpdateDia> createState() => _PriceUpdateDiaState<T>();
}

class _PriceUpdateDiaState<T> extends State<PriceUpdateDia> {
  // String number = "0";

  void load({bool isInit = false}) {
    if (!isInit && property.onTap != null) property.onTap!(widget.value);
    if (mounted) setState(() {});
  }

  void _onTapNumber(String val) {
    if (widget.value.contains('.') && val == '.') return;

    final numVal1 = double.tryParse(widget.value);
    if (numVal1 == null) widget.value = "";

    if (numVal1 != null && numVal1 > widget.max) return;

    if (!property.isPhoneNum &&
        numVal1 == 0 &&
        val != '.' &&
        !widget.value.contains('.')) {
      widget.value = val;
    } else if ((widget.value + val).inDouble <= widget.max) {
      widget.value += val;
    } else {
      return;
    }

    load();
    if (property.isDia)
      Future.delayed(Duration(milliseconds: 50), () {
        _scrollCltr.animateTo(_scrollCltr.position.maxScrollExtent,
            duration: Duration(milliseconds: 100),
            curve: Curves.linearToEaseOut);
      });
  }

  void _onBackSpace() {
    if (widget.value.length > 1)
      widget.value = widget.value.substring(0, widget.value.length - 1);
    else if (property.isPhoneNum) {
      widget.value = "";
    } else
      widget.value = "0";

    load();
  }

  void _onTapC() {
    widget.value = "0";
    load();
  }

  void _onOK() {
    final data =
        T == int ? int.tryParse(widget.value) : double.tryParse(widget.value);
    if (property.isDia)
      Navigator.of(context).pop(data);
    else if (property.onOk != null) property.onOk!(widget.value);
  }

  Timer? timer;
  final _scrollCltr = ScrollController();

  void _qtyUpdate(bool val) {
    int? qty = int.tryParse(widget.value);
    if (qty == null) return;

    if (val) {
      qty++;
    } else if (qty > 1) {
      qty--;
    }

    widget.value = qty.toString();
    load();
  }

  late PriceDiaProperty property;

  @override
  void initState() {
    // number = widget.value;
    load(isInit: true);

    super.initState();
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var numberList = [];

    final size = Ssize(context);
    property = widget.property ?? PriceDiaProperty();

    property.isPayKeyPad
        ? {
            numberList = [
              1,
              2,
              3,
              4,
              5,
              6,
              7,
              8,
              9,
              ".",
              0,
              "X",
            ]
          }
        : T == int
            ? {
                numberList = [
                  1,
                  2,
                  3,
                  "X",
                  4,
                  5,
                  6,
                  0,
                  7,
                  8,
                  9,
                  "OK",
                ]
              }
            : {
                numberList = [1, 2, 3, 4, 5, 6, 7, 8, 9, 0, "00", "."]
              };
    return Container(
      height: (T == int) ? size.height * 0.65 : size.height * 0.78,
      width: size.width / 2.2,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (property.isDia)
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(
                  horizontal: size.getW(16), vertical: size.getH(20)),
              decoration: BoxDecoration(
                color: kSecondaryColor,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(5),
                  topRight: Radius.circular(5),
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    widget.title ?? LN.changePrice,
                    style: TextStyle(
                      fontSize: size.getS(32),
                      fontFamily: kFontFMedium,
                      color: Colors.white,
                    ),
                  ),
                  Spacer(),
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
          if (property.isDia)
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
                  mainAxisAlignment: (T == int)
                      ? MainAxisAlignment.spaceBetween
                      : MainAxisAlignment.end,
                  children: [
                    if (T == int)
                      InkWell(
                        onTap: () {
                          _qtyUpdate(false);
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: size.getW(24),
                              vertical: size.getW(9)),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            border:
                                Border.all(color: kSecondaryColor, width: 4),
                          ),
                          child: Text(
                            "-",
                            style: TextStyle(
                                fontSize: size.getS(32),
                                color: kSecondaryColor,
                                fontWeight: FontWeight.bold,
                                fontFamily: kFontFBold),
                          ),
                        ),
                      ),
                    Expanded(
                      child: Align(
                        alignment:
                            T == int ? Alignment.center : Alignment.centerLeft,
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
                    if (T == int)
                      InkWell(
                        onTap: () {
                          _qtyUpdate(true);
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: size.getW(24),
                              vertical: size.getW(9)),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            border:
                                Border.all(color: kSecondaryColor, width: 4),
                          ),
                          child: Text(
                            "+",
                            style: TextStyle(
                                fontSize: size.getS(32),
                                color: kSecondaryColor,
                                fontWeight: FontWeight.bold,
                                fontFamily: kFontFBold),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          Flexible(
            child: Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: property.isDia ? size.getW(10) : 0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Flexible(
                    flex: 3,
                    child: GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: T == int ? 4 : 3,
                        mainAxisSpacing: property.padding,
                        crossAxisSpacing: property.padding,
                        mainAxisExtent: size.getH(property.height),
                      ),
                      scrollDirection: Axis.vertical,
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: numberList.length,
                      itemBuilder: (context, index) {
                        return _numKeySection(
                          title: "${numberList[index]}",
                          size: size,
                          onTap: () => numberList[index] == "X"
                              ? _onBackSpace()
                              : numberList[index] == "OK"
                                  ? _onOK()
                                  : numberList[index] == "C"
                                      ? _onTapC()
                                      : _onTapNumber("${numberList[index]}"),
                        );
                      },
                    ),
                  ),
                  if (!property.isPayKeyPad && T != int)
                    Flexible(
                        child: Padding(
                      padding: const EdgeInsets.only(left: 10.0),
                      child: Column(
                        children: [
                          _numKeySection(
                              height: size.getH(100),
                              title: "X",
                              size: size,
                              onTap: () {
                                _onBackSpace();
                              }),
                          SizedBox(height: 10),
                          _numKeySection(
                              height: size.getH(100),
                              title: "C",
                              size: size,
                              onTap: () {
                                _onTapC();
                              }),
                          SizedBox(height: 10),
                          Expanded(
                            child: _numKeySection(
                                height: size.getH(210),
                                title: "OK",
                                size: size,
                                onTap: () {
                                  _onOK();
                                }),
                          ),
                          SizedBox(height: 10),
                        ],
                      ),
                    ))
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  String? _glow;

  Widget _numKeySection({
    required String title,
    required Ssize size,
    Function()? onTap,
    final double? height,
  }) {
    return GestureDetector(
      // highlightColor: Colors.grey.shade400,
      onTap: onTap == null
          ? null
          : () {
              _glow = title;
              load();
              onTap();
              Future.delayed(Duration(milliseconds: 300), () {
                _glow = null;
                load();
              });
            },
      onLongPress: () {
        if (title == "X") {
          timer = Timer.periodic(Duration(milliseconds: 100), (_) {
            _onBackSpace();
          });
        }
      },
      onLongPressStart: (_) {
        _glow = title;
        load();
      },
      onLongPressEnd: (_) {
        if (title == "X") {
          timer?.cancel();
        }
        _glow = null;
        load();
      },
      child: AnimatedContainer(
        duration: Duration(milliseconds: 400),
        height: height,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          color: _glow == title
              ? kSecondaryColor.withOpacity(0.4)
              : title == "OK"
                  ? kSecondaryColor
                  : Color(0xffEBEDF0),
          border: Border.all(color: Colors.grey.shade300, width: 1),
          boxShadow: _glow == title
              ? [
                  BoxShadow(
                    color: kSecondaryColor.withOpacity(0.6),
                    blurRadius: 20,
                    spreadRadius: 4,
                  ),
                ]
              : [],
        ),
        child: Center(
          child: title == "X"
              ? Icon(
                  Icons.backspace_outlined,
                  size: size.getS(property.fontSize),
                  color: Colors.red.shade700,
                )
              : Text(
                  title,
                  style: TextStyle(
                    fontSize: size.getS(property.fontSize),
                    color: title == "OK" ? Colors.white : Colors.black,
                  ),
                ),
        ),
      ),
    );
  }
}

class PriceDiaProperty {
  final bool isDia;
  final double padding;
  final double height;
  final double fontSize;
  final Function(String)? onTap;
  final Function(String)? onOk;
  final bool isPhoneNum;
  final bool isPayKeyPad;
  final ScrollController? scrollCltr;

  PriceDiaProperty({
    this.isDia = true,
    this.padding = 10,
    this.height = 100,
    this.fontSize = 40,
    this.onTap,
    this.onOk,
    this.isPhoneNum = false,
    this.isPayKeyPad = false,
    this.scrollCltr,
  });
}
