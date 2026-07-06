import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:oktoast/oktoast.dart';
import 'package:pos_account/config/size_config.dart';
import 'package:pos_account/constant/constant.dart';
import 'package:pos_account/ln.dart';
import 'package:pos_account/providers/cus_val_pro.dart';
import 'package:pos_account/providers/menu/payment_pro.dart';
import 'package:pos_account/widgets/input/text_form/multi_text_form.dart';
import 'package:pos_account/widgets/input/text_form/text_form_widget.dart';
import 'package:pos_account/widgets/loading.dart';
import 'package:provider/provider.dart';

class DoEmailDia extends StatelessWidget {
  final String? orderId;

  const DoEmailDia({super.key, required this.orderId});

  static final _formKey = GlobalKey<FormState>();

  static final focusNode1 = FocusNode();
  static final focusNode2 = FocusNode();

  @override
  Widget build(BuildContext context) {
    final size = Ssize(context);
    final payPro = Provider.of<PaymentPro>(context);
    return KeyboardListener(
      focusNode: FocusNode(),
      onKeyEvent: (value) {
        if (value is KeyDownEvent &&
            value.logicalKey == LogicalKeyboardKey.backspace) {
          if (focusNode1.hasFocus && payPro.toEmailList.isNotEmpty) {
            payPro.toEmailList.removeLast();
            payPro.notify;
          } else if (focusNode2.hasFocus && payPro.ccEmailList.isNotEmpty) {
            payPro.ccEmailList.removeLast();
            payPro.notify;
          }
        }
      },
      child: Processing(
        loading: payPro.loadEmail,
        child: Container(
          constraints: BoxConstraints(
            // maxHeight: size.height / 1.3,
            minHeight: size.height / 6,
          ),
          width: size.width / 1.5,
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      LN.sendInvoiceDe,
                      style: TextStyle(
                        fontSize: size.getS(18),
                        fontFamily: kFontFMedium,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: Icon(Icons.close))
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Divider(
                    color: Colors.black,
                    thickness: 0.5,
                  ),
                ),
                SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(
                        height: size.getH(12),
                      ),
                      EmailTextForm(
                        size: size,
                        title: payPro.loadEmail
                            ? LN.from
                            : "${LN.from} (${GlobalCVP.storeInfo?.name ?? ''})",
                        hintText: "",
                        textCltr: payPro.fromCltr,
                        readOnly: true,
                      ),
                      SizedBox(
                        height: size.getH(24),
                      ),
                      MultiTextWidget(
                        focusNode: focusNode1,
                        size: size,
                        textCltr: payPro.toCltr,
                        title: LN.to,
                        textList: payPro.toEmailList,
                        onAdd: (String? val) {
                          if (val == null) return;
                          if (val.contains(" ")) {
                            payPro.toEmailList.add(val.trim());
                            payPro.toCltr.clear();
                          }
                          payPro.notify;
                        },
                        onRemove: (int i) {
                          payPro.toEmailList.removeAt(i);
                          payPro.notify;
                        },
                        onSubmit: (p0) {
                          if (p0 == null) return;
                          payPro.toEmailList.add(p0.trim());
                          payPro.toCltr.clear();
                          payPro.notify;
                        },
                      ),
                      SizedBox(
                        height: size.getH(24),
                      ),
                      MultiTextWidget(
                        focusNode: focusNode2,
                        size: size,
                        textCltr: payPro.ccCltr,
                        title: LN.cc,
                        textList: payPro.ccEmailList,
                        onAdd: (String? val) {
                          if (val == null) return;
                          if (val.contains(" ")) {
                            payPro.ccEmailList.add(val.trim());
                            payPro.ccCltr.clear();
                          }
                          payPro.notify;
                        },
                        onRemove: (int i) {
                          payPro.ccEmailList.removeAt(i);
                          payPro.notify;
                        },
                        onSubmit: (p0) {
                          if (p0 == null) return;
                          payPro.ccEmailList.add(p0.trim());
                          payPro.ccCltr.clear();
                          payPro.notify;
                        },
                      ),
                      SizedBox(
                        height: size.getH(24),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          color: Color(0XFFd3dbe0),
                        ),
                        padding: EdgeInsets.symmetric(
                            vertical: size.getH(24), horizontal: size.getW(24)),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              LN.subject,
                              style: TextStyle(
                                fontSize: size.getS(18),
                                color: Colors.black,
                                fontFamily: kFontFBold,
                              ),
                            ),
                            SizedBox(
                              height: size.getH(12),
                            ),
                            TextFormWidget(
                                cltr: payPro.subCltr,
                                isReq: true,
                                borderRadius: 5,
                                borderColor: Colors.black45,
                                hintText: ""),
                            SizedBox(
                              height: size.getH(24),
                            ),
                            Text(
                              LN.yourMessage,
                              style: TextStyle(
                                fontSize: size.getS(18),
                                color: Colors.black,
                                fontFamily: kFontFBold,
                              ),
                            ),
                            SizedBox(
                              height: size.getH(12),
                            ),
                            TextFormWidget(
                              cltr: payPro.msgCltr,
                              textInputType: TextInputType.multiline,
                              isReq: false,
                              borderRadius: 5,
                              borderColor: Colors.black45,
                              hintText: "",
                              minLines: 8,
                              maxLines: 16,
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: size.getH(24),
                      ),
                      Row(
                        children: [
                          ElevatedButton(
                              style: ButtonStyle(
                                  backgroundColor: WidgetStateProperty.all(
                                      Color(0xFF1572a4)),
                                  padding: WidgetStateProperty.all(
                                      EdgeInsets.symmetric(
                                          horizontal: size.getW(24),
                                          vertical: size.getH(8)))),
                              onPressed: () async {
                                if (_formKey.currentState!.validate()) {
                                  if (payPro.toEmailList.isEmpty) {
                                    showToast(LN.emailNotEmpty);
                                  }
                                  final _status =
                                      await payPro.sendEmail(orderId: orderId);
                                  if (_status ?? false) {
                                    Navigator.pop(context);
                                  }
                                }
                              },
                              child: Text(
                                LN.send,
                                style: TextStyle(
                                  fontSize: size.getS(16),
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              )),
                          SizedBox(
                            width: size.getW(16),
                          ),
                          ElevatedButton(
                              style: ButtonStyle(
                                  backgroundColor: WidgetStateProperty.all(
                                      Color(0xFFe63a48)),
                                  padding: WidgetStateProperty.all(
                                      EdgeInsets.symmetric(
                                          horizontal: size.getW(24),
                                          vertical: size.getH(8)))),
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: Text(
                                LN.cancel,
                                style: TextStyle(
                                  fontSize: size.getS(16),
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              )),
                        ],
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class EmailTextForm extends StatelessWidget {
  final Ssize size;
  final TextEditingController textCltr;
  final String title;
  final String hintText;
  final bool readOnly;
  final bool isReq;
  const EmailTextForm({
    super.key,
    required this.size,
    required this.textCltr,
    required this.title,
    this.hintText = "",
    this.readOnly = false,
    this.isReq = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: size.getS(18),
            color: Colors.black,
            fontFamily: kFontFBold,
          ),
        ),
        SizedBox(
          height: size.getH(8),
        ),
        TextFormWidget(
            cltr: textCltr,
            borderColor: Colors.black45,
            isReq: isReq,
            borderRadius: 5,
            readOnly: readOnly,
            fillColor: readOnly ? Colors.grey.withAlpha(200) : Colors.white,
            hintText: hintText),
      ],
    );
  }
}
