import 'package:flutter/material.dart';
import 'package:pos_account/config/size_config.dart';
import 'package:pos_account/constant/constant.dart';
import 'package:pos_account/ln.dart';
import 'package:pos_account/providers/eod/eod_pro.dart';
import 'package:pos_account/widgets/input/text_form/multi_text_form.dart';
import 'package:pos_account/widgets/input/text_form/title_text_form.dart';
import 'package:pos_account/widgets/load_btn.dart';
import 'package:provider/provider.dart';

class FinalizeEodDia extends StatefulWidget {
  const FinalizeEodDia({super.key});

  @override
  State<FinalizeEodDia> createState() => _FinalizeEodDiaState();
}

class _FinalizeEodDiaState extends State<FinalizeEodDia> {
  final _formKey = GlobalKey<FormState>();
  final focusNode = FocusNode();
  final emailCltr = TextEditingController();

  late EodPro pro;

  Widget _checkboxSection(
    Ssize size, {
    bool? isChecked,
    Function(bool?)? onChanged,
    required String title,
  }) {
    return Row(
      children: [
        Checkbox(
          visualDensity: VisualDensity.compact,
          value: isChecked,
          onChanged: onChanged,
          activeColor: kSecondaryColor,
        ),
        Text(
          title,
          style: TextStyle(
            fontSize: size.getS(16),
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    pro.clearFinalizeDia();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = Ssize(context);
    pro = Provider.of<EodPro>(context);
    return Container(
      constraints: BoxConstraints(
        maxHeight: size.height / 1.14,
        minHeight: size.height / 5,
      ),
      width: size.width / 1.6,
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: size.getH(12),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    LN.finalizeEod,
                    style: TextStyle(
                      fontSize: size.getS(18),
                      // fontFamily: ,
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
              Divider(
                color: Colors.black54,
              ),
              MultiTextWidget(
                focusNode: focusNode,
                size: size,
                textCltr: emailCltr,
                title: LN.to,
                isReq: pro.finalizeAction == FinalizeAction.SendEmail ||
                    pro.finalizeAction == FinalizeAction.Both,
                textList: pro.emailList,
                borderColor: pro.toBorderColor,
                onAdd: (String? val) {
                  if (val == null) return;
                  if (val.contains(" ")) {
                    pro.emailList.add(val.trim());
                    emailCltr.clear();
                  }
                  pro.notify;
                },
                onSubmit: (p0) {
                  if (p0 == null) return;
                  pro.emailList.add(p0.trim());
                  emailCltr.clear();
                  pro.notify;
                },
                onRemove: (int i) {
                  pro.emailList.removeAt(i);
                  pro.notify;
                },
              ),
              SizedBox(
                height: size.getH(12),
              ),
              TitleTextForm(
                pWidth: 1,
                title: LN.subject,
                isReq: false,
                borderColor: Colors.black12,
                textCltr: pro.subCltr,
              ),
              SizedBox(
                height: size.getH(12),
              ),
              TitleTextForm(
                title: LN.yourMessage,
                pWidth: 1,
                isReq: false,
                borderColor: Colors.black12,
                textCltr: pro.messageCltr,
                maxLines: 5,
              ),
              SizedBox(
                height: size.getH(24),
              ),
              _checkboxSection(size,
                  title: LN.sendEmail,
                  isChecked: pro.finalizeAction == FinalizeAction.SendEmail,
                  onChanged: (val) {
                if (val == null) return;
                if (val)
                  pro.finalizeAction = FinalizeAction.SendEmail;
                else
                  pro.finalizeAction = null;
                pro.toBorderColor = Colors.black12;
                pro.notify;
              }),
              _checkboxSection(size,
                  title: LN.finalize,
                  isChecked: pro.finalizeAction == FinalizeAction.Finalize,
                  onChanged: (val) {
                if (val == null) return;
                if (val)
                  pro.finalizeAction = FinalizeAction.Finalize;
                else
                  pro.finalizeAction = null;
                pro.toBorderColor = Colors.black12;
                pro.notify;
              }),
              _checkboxSection(size,
                  title: LN.sendEmailAndFinalize,
                  isChecked: pro.finalizeAction == FinalizeAction.Both,
                  onChanged: (val) {
                if (val == null) return;
                if (val)
                  pro.finalizeAction = FinalizeAction.Both;
                else
                  pro.finalizeAction = null;
                pro.toBorderColor = Colors.black12;
                pro.notify;
              }),
              SizedBox(
                height: size.getH(12),
              ),
              Row(
                children: [
                  LoadButton(
                    btnText: LN.confirm,
                    btnColor: pro.finalizeAction == null
                        ? Colors.grey.shade400
                        : kUserColor,
                    vPad: 8,
                    loading: pro.loadFinalizeButton,
                    onsave: pro.finalizeAction == null
                        ? null
                        : () {
                            if (_formKey.currentState!.validate() &&
                                pro.emailList.isNotEmpty) {
                              pro.toBorderColor = Colors.black12;
                              pro.notify;
                              pro.finalizeEod();
                            } else {
                              pro.toBorderColor = Colors.red;
                              pro.notify;
                            }
                          },
                  ),
                  SizedBox(
                    width: size.getW(12),
                  ),
                  LoadButton(
                    btnText: LN.cancel,
                    btnColor: Colors.red.shade600,
                    vPad: 8,
                    onsave: () {
                      Navigator.pop(context);
                    },
                  )
                ],
              ),
              SizedBox(
                height: size.getH(24),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
