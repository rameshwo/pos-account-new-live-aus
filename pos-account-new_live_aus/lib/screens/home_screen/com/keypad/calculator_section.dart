import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pos_account/config/size_config.dart';
import 'package:pos_account/providers/keypad/keypad_pro.dart';
import 'package:pos_account/repository/if_exception.dart';
import 'package:pos_account/widgets/dialog/custom_dialog.dart';
import 'package:pos_account/widgets/loading.dart';
import 'package:provider/provider.dart';

import '../../../../constant/constant.dart';
import '../../../../ln.dart';
import '../../../../providers/menu/place_order_pro.dart';
import '../../../../widgets/input/text_form/text_form_widget.dart';
import '../../../../widgets/load_btn.dart';

class CalculatorSection extends StatefulWidget {
  final PlaceOrderPro placeOrderPro;
  final Ssize size;

  const CalculatorSection({
    super.key,
    required this.size,
    required this.placeOrderPro,
  });

  @override
  State<CalculatorSection> createState() => _CalculatorSectionState();
}

class _CalculatorSectionState extends State<CalculatorSection> {
  final _scrollController = ScrollController();
  late KeyPadPro _pro;
  Timer? timer;

  @override
  void initState() {
    super.initState();
    _getData();
  }

  Future<void> _getData() async {
    _pro = Provider.of<KeyPadPro>(context, listen: false);
    _pro.getCurSym();
    // _pro.keyPadLoading = true;
    if (widget.placeOrderPro.initAddSec == null) {
      await widget.placeOrderPro.getOrderAddSection();
    }
    _pro
        .getKeyPadProducts(products: widget.placeOrderPro.getVariableProducts())
        .then((value) => widget.placeOrderPro.notify);
  }

  void _scrollToEnd() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _pro.clearAll();
    super.dispose();
  }

  showNotesDialog({
    required Ssize size,
    required KeyPadPro pro,
  }) {
    showDialog(
      context: CUS_CTX!,
      builder: (context) {
        return SimpleDialog(children: [
          IntrinsicHeight(
            child: SizedBox(
              width: size.width * 0.5,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    LN.notes,
                    style: TextStyle(
                      fontSize: Ssize(context).getS(20),
                      fontFamily: kFontFBold,
                    ),
                  ),
                  SizedBox(height: Ssize(context).getH(10)),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormWidget(
                      borderColor: Colors.grey.shade300,
                      cltr: pro.notesCltr,
                      hintText: "Enter Notes",
                      maxLines: 5,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "Note: This note will be saved with the transaction.",
                      style: TextStyle(
                        fontSize: Ssize(context).getS(14),
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 18.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        LoadButton(
                          btnText: LN.save,
                          onsave: () {
                            Navigator.pop(context, pro.notesCltr.text);
                          },
                        ),
                        SizedBox(width: Ssize(context).getW(10)),
                        LoadButton(
                          btnText: LN.cancel,
                          onsave: () {
                            Navigator.pop(context);
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ]);
      },
    );
  }

  bool keyBoardVisible = false;

  @override
  Widget build(BuildContext context) {
    // keyBoardVisible = MediaQuery.of(CUS_CTX!).viewInsets.bottom != 0;
    final placePro = Provider.of<PlaceOrderPro>(context);
    final pro = Provider.of<KeyPadPro>(context);
    final size = Ssize(context);
    final numberList = [1, 2, 3, 4, 5, 6, 7, 8, 9, 0, "00", "."];
    return Processing(
      loading: pro.keyPadLoading,
      child: Card(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Container(),
            Expanded(
              flex: 3,
              child: SingleChildScrollView(
                physics: NeverScrollableScrollPhysics(),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // customBack(
                    //   size: widget.size,
                    //   onPressed: () {
                    //     placePro.showKeypad = false;
                    //     placePro.notify;
                    //   },
                    //   width: widget.size.getW(100),
                    // ),
                    Container(
                      height: widget.size.getH(120),
                      alignment: Alignment.bottomLeft,
                      width: double.maxFinite,
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: SingleChildScrollView(
                        controller: _scrollController,
                        scrollDirection: Axis.horizontal,
                        child: Text(
                          "${pro.curSym} ${pro.total}",
                          style: TextStyle(
                            fontSize: widget.size.getS(60),
                          ),
                        ),
                      ),
                    ),
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          height: widget.size.getH(50),
                          decoration: BoxDecoration(
                            color: kBackgroundColor,
                            border: Border.all(
                                color: Colors.grey.shade300, width: 1),
                          ),
                          child: InkWell(
                              onTap: () => CustomDialog.showNotesDialog(
                                    context: context,
                                    descCltr: pro.notesCltr,
                                    title: LN.addNote,
                                    onChangedDesc: (p0) {},
                                  ),
                              child: Center(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.add,
                                        color: Colors.grey.shade600),
                                    SizedBox(width: widget.size.getW(5)),
                                    Text(
                                      LN.notes,
                                      style: TextStyle(
                                        fontSize: widget.size.getS(18),
                                        color: Colors.grey.shade600,
                                        fontFamily: kFontFBold,
                                      ),
                                    ),
                                  ],
                                ),
                              )),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            pro.notesCltr.text.isEmpty
                                ? "No Note"
                                : pro.notesCltr.text,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: Ssize(context).getS(14),
                              color: Colors.grey.shade600,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10.0, vertical: 4),
                      child: Row(
                        children: [
                          Expanded(
                            flex: 3,
                            child: GridView.builder(
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 3,
                                mainAxisSpacing: 10,
                                crossAxisSpacing: 10,
                                mainAxisExtent: size.getH(100),
                              ),
                              scrollDirection: Axis.vertical,
                              physics: NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: numberList.length,
                              itemBuilder: (context, index) {
                                return _numKeySection(
                                    title: "${numberList[index]}",
                                    size: size,
                                    onTap: () =>
                                        pro.onNumTap("${numberList[index]}"));
                              },
                            ),
                          ),
                          Expanded(
                              child: Padding(
                            padding: const EdgeInsets.only(left: 10.0),
                            child: Column(
                              children: [
                                _numKeySection(
                                    height: size.getH(100),
                                    title: "X",
                                    size: size,
                                    onTap: () {
                                      pro.onCTap();
                                    }),
                                SizedBox(height: 10),
                                _numKeySection(
                                    height: size.getH(100),
                                    title: "C",
                                    size: size,
                                    onTap: () {
                                      pro.onClear();
                                    }),
                                SizedBox(height: 10),
                                _numKeySection(
                                    height: size.getH(210),
                                    title: "OK",
                                    size: size,
                                    onTap: () {
                                      if ((pro.keyPadProducts?.length ?? 0) ==
                                          0) {
                                        IfException.showMessage(
                                            message: "No Product to add");
                                        return;
                                      }

                                      final _amt =
                                          double.tryParse(pro.total.toString());

                                      if (_amt != null && _amt >= 0) {
                                        pro.onAddTapped(
                                            placeOrderPro: placePro);
                                      } else {
                                        IfException.showMessage(
                                            message:
                                                "Please enter valid amount");
                                      }
                                    }),
                              ],
                            ),
                          ))
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget customBack({
    required Ssize size,
    required Function onPressed,
    String? title,
    double? width,
    // CupertinoButtonSize? sizeStyle,
  }) {
    return CupertinoButton(
        // sizeStyle: sizeStyle ?? CupertinoButtonSize.medium,
        borderRadius: BorderRadius.circular(5),
        child: SizedBox(
          width: width ?? double.maxFinite,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.arrow_back,
                color: Colors.black,
              ),
              SizedBox(width: widget.size.getW(5)),
              Text(
                title ?? "Close",
                style: TextStyle(
                  fontSize: widget.size.getS(20),
                  color: Colors.black,
                ),
              ),
            ],
          ),
        ),
        onPressed: () {
          onPressed();
        });
  }

  Widget KeyPadButton({
    required String text,
    required Function onPressed,
    bool isAdd = false,
    bool isCT = false,
    required KeyPadPro pro,
  }) {
    final size = Ssize(context);
    return Container(
      width: size.getW(50),
      height: size.getH(50),
      decoration: BoxDecoration(
        border: Border.all(color: kBackgroundColor, width: 2),
      ),
      child: TextButton(
        onLongPress: () {
          if (isCT) {
            pro.onLongTap();
            _scrollToEnd();
          }
        },
        onPressed: () {
          onPressed();
          _scrollToEnd();
        },
        child: Text(
          text,
          style: TextStyle(
            fontSize: size.getS(40),
            color: isAdd ? kSecondaryColor : Colors.black,
            fontFamily: kFontFMedium,
          ),
        ),
      ),
    );
  }
}

Widget _numKeySection({
  required String title,
  required Ssize size,
  Function()? onTap,
  final double? height,
  final Function()? onBackSpace,
  Timer? timer,
}) {
  return GestureDetector(
    // highlightColor: Colors.grey.shade400,
    onTap: onTap,
    onLongPress: title == "X"
        ? () {
            timer = Timer.periodic(Duration(milliseconds: 100), (_) {
              if (onBackSpace != null) onBackSpace();
            });
          }
        : null,
    onLongPressEnd: title == "X"
        ? (_) {
            timer?.cancel();
          }
        : null,
    child: Container(
      height: height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        color: title == "OK" ? kSecondaryColor : Color(0xffEBEDF0),
        border: Border.all(color: Colors.grey.shade300, width: 1),
      ),
      child: Center(
        child: title == "X"
            ? Icon(
                Icons.backspace_outlined,
                size: size.getS(40),
                color: Colors.red.shade700,
              )
            : Text(
                title,
                style: TextStyle(
                  fontSize: size.getS(40),
                  color: title == "OK" ? Colors.white : Colors.black,
                ),
              ),
      ),
    ),
  );
}
