import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:pos_account/config/size_config.dart';
import 'package:pos_account/config/validator.dart';
import 'package:pos_account/constant/constant.dart';
import 'package:pos_account/ln.dart';
import 'package:pos_account/providers/setting/notification/notify_pro.dart';
import 'package:pos_account/widgets/input/text_form/title_text_form.dart';
import 'package:pos_account/widgets/load_btn.dart';
import 'package:pos_account/widgets/loading.dart';
import 'package:pos_account/widgets/switch_adap.dart';
import 'package:provider/provider.dart';

class EmailSettings extends StatefulWidget {
  const EmailSettings({super.key});

  @override
  State<EmailSettings> createState() => _EmailSettingsState();
}

class _EmailSettingsState extends State<EmailSettings> {
  final _formKey = GlobalKey<FormState>();
  @override
  void initState() {
    getData();
    super.initState();
  }

  NotifyPro? _notifyPro;

  Future<void> getData() async {
    _notifyPro = Provider.of<NotifyPro>(context, listen: false);
    await _notifyPro?.getAllEmails();
  }

  @override
  void dispose() {
    _notifyPro?.emailClear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = Ssize(context);
    final notifyPro = Provider.of<NotifyPro>(context);
    if (notifyPro.emailLoading && notifyPro.emailList.isEmpty)
      return Loading();
    else
      return Processing(
        loading: notifyPro.emailLoading,
        align: Alignment.topLeft,
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: size.getH(12),
                ),
                Card(
                  margin: EdgeInsets.zero,
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: size.getW(16), vertical: size.getH(12)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: size.getH(12),
                        ),
                        ...List.generate(notifyPro.emailList.length, (i) {
                          return Padding(
                            padding: EdgeInsets.only(bottom: size.getH(16)),
                            child: _emailAddSec(
                              size,
                              mailServerCltr:
                                  notifyPro.emailList[i].mailServer!,
                              senderNameCltr:
                                  notifyPro.emailList[i].senderName!,
                              emailCltr: notifyPro.emailList[i].email!,
                              passwordCltr: notifyPro.emailList[i].password!,
                              showPassword: notifyPro.emailList[i].showPassword,
                              portCltr: notifyPro.emailList[i].port!,
                              isActive:
                                  notifyPro.emailList[i].isActive ?? false,
                              enTls: notifyPro.emailList[i].enableTls ?? false,
                              enSsi:
                                  notifyPro.emailList[i].enableSSlOnCOnnect ??
                                      false,
                              onUpdate: (bool val, int flag) {
                                if (flag == 0) {
                                  notifyPro.emailList[i].isActive = val;
                                } else if (flag == 1) {
                                  notifyPro.emailList[i].enableTls = val;
                                } else if (flag == 2) {
                                  notifyPro.emailList[i].enableSSlOnCOnnect =
                                      val;
                                } else if (flag == 3) {
                                  // delete
                                  notifyPro.emailList.removeAt(i);
                                  notifyPro.notify;
                                } else if (flag == 4) {
                                  notifyPro.emailList[i].showPassword = val;
                                }
                                notifyPro.notify;
                              },
                            ),
                          );
                        }),
                        SizedBox(
                          height: size.getH(16),
                        ),
                        // DottedBorder(
                        //   dashPattern: [3, 2],
                        //   strokeWidth: 1.5,
                        //   radius: Radius.circular(10),
                        //   color: kSecondaryColor,
                        //   borderType: BorderType.RRect,
                        //   child: InkWell(
                        //     onTap: () {
                        //       notifyPro.emailList.add(EmailSetupData(
                        //         id: "",
                        //         mailServer: TextEditingController(),
                        //         senderName: TextEditingController(),
                        //         email: TextEditingController(),
                        //         password: TextEditingController(),
                        //         port: TextEditingController(),
                        //         isActive: true,
                        //         enableTls: true,
                        //         enableSSlOnCOnnect: true,
                        //       ));
                        //       notifyPro.notify;
                        //     },
                        //     highlightColor: kPrimaryColor.withAlpha(40),
                        //     child: Padding(
                        //       padding: EdgeInsets.symmetric(
                        //           horizontal: size.getW(12),
                        //           vertical: size.getH(8)),
                        //       child: Row(
                        //         mainAxisSize: MainAxisSize.min,
                        //         children: [
                        //           Icon(
                        //             Icons.add,
                        //             color: kSecondaryColor,
                        //             size: size.getS(20),
                        //           ),
                        //           Text(
                        //             "Add Email Setting",
                        //             style: TextStyle(
                        //               fontSize: size.getS(16),
                        //               fontFamily: kFontFMedium,
                        //               color: kSecondaryColor,
                        //             ),
                        //           ),
                        //         ],
                        //       ),
                        //     ),
                        //   ),
                        // ),
                        // SizedBox(
                        //   height: size.getH(20),
                        // ),
                        LoadButton(
                          btnText: LN.save,
                          loading: notifyPro.emailUpdateLoad,
                          onsave: notifyPro.emailUpdateLoad
                              ? null
                              : () {
                                  if (_formKey.currentState?.validate() ??
                                      false) notifyPro.updateEmail();
                                },
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
  }

  DottedBorder _emailAddSec(
    Ssize size, {
    required TextEditingController mailServerCltr,
    required TextEditingController senderNameCltr,
    required TextEditingController emailCltr,
    required TextEditingController passwordCltr,
    bool showPassword = false,
    required TextEditingController portCltr,
    required bool isActive,
    required bool enTls,
    required bool enSsi,
    required Function(bool, int) onUpdate,
  }) {
    return DottedBorder(
        dashPattern: [3, 2],
        strokeWidth: 1.5,
        radius: Radius.circular(10),
        color: kSecondaryColor,
        borderType: BorderType.RRect,
        child: SizedBox(
          width: double.infinity,
          child: Padding(
            padding: EdgeInsets.symmetric(
                horizontal: size.getW(24), vertical: size.getH(18)),
            child: AutofillGroup(
              child: Wrap(
                spacing: size.getW(24),
                runSpacing: size.getH(24),
                children: [
                  SizedBox(
                    width: size.getW(240),
                    child: TitleTextForm(
                      title: LN.mailServer,
                      textCltr: mailServerCltr,
                      borderColor: Colors.black26,
                    ),
                  ),
                  SizedBox(
                    width: size.getW(240),
                    child: TitleTextForm(
                      title: LN.port,
                      textCltr: portCltr,
                      borderColor: Colors.black26,
                    ),
                  ),
                  SizedBox(
                    width: size.getW(240),
                    child: TitleTextForm(
                      title: LN.senderName,
                      isReq: false,
                      textCltr: senderNameCltr,
                      borderColor: Colors.black26,
                    ),
                  ),
                  SizedBox(
                    width: size.getW(240),
                    child: TitleTextForm(
                      title: LN.email,
                      isReq: false,
                      textCltr: emailCltr,
                      borderColor: Colors.black26,
                      validator: emailValidator,
                      textInputType: TextInputType.emailAddress,
                      autofillHints: const [AutofillHints.email],
                    ),
                  ),
                  SizedBox(
                    width: size.getW(240),
                    child: TitleTextForm(
                      title: LN.password,
                      suffixIconWidth: 40,
                      isReq: false,
                      textCltr: passwordCltr,
                      borderColor: Colors.black26,
                      textInputType: TextInputType.visiblePassword,
                      suffixIcon: InkWell(
                        onTap: () => onUpdate(!showPassword, 4),
                        child: Icon(
                          showPassword
                              ? Icons.visibility
                              : Icons.visibility_off_outlined,
                          size: size.getS(24),
                        ),
                      ),
                      obsecure: !showPassword,
                      validator: passwordValidator,
                      autofillHints: const [AutofillHints.password],
                    ),
                  ),

                  SizedBox(
                    width: size.getW(200),
                    child: _titleSwitch(
                      size,
                      title: LN.isActive,
                      value: isActive,
                      onChanged: (val) => onUpdate(val, 0),
                    ),
                  ),
                  SizedBox(
                    width: size.getW(200),
                    child: _titleSwitch(
                      size,
                      title: LN.enTls,
                      value: enTls,
                      onChanged: (val) => onUpdate(val, 1),
                    ),
                  ),
                  SizedBox(
                    width: size.getW(240),
                    child: _titleSwitch(
                      size,
                      title: LN.enSsi,
                      value: enSsi,
                      onChanged: (val) => onUpdate(val, 2),
                    ),
                  ),
                  // InkWell(
                  //   onTap: () => onUpdate(false, 3),
                  //   splashColor: Colors.red.withAlpha(110),
                  //   highlightColor: kTempColor.withAlpha(60),
                  //   borderRadius: BorderRadius.circular(40),
                  //   child: Container(
                  //     decoration: BoxDecoration(
                  //         shape: BoxShape.circle,
                  //         color: Colors.red.withAlpha(200)),
                  //     child: Padding(
                  //       padding: EdgeInsets.all(size.getS(12)),
                  //       child: Icon(
                  //         Icons.delete_outline,
                  //         color: Colors.red.shade700,
                  //         size: size.getS(36),
                  //       ),
                  //     ),
                  //   ),
                  // )
                ],
              ),
            ),
          ),
        ));
  }

  Widget _titleSwitch(
    Ssize size, {
    required String title,
    required bool value,
    Function(bool)? onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: size.getS(18),
            color: Colors.black,
          ),
        ),
        SizedBox(
          height: size.getH(8),
        ),
        SwitchAdap(
          size: size,
          value: value,
          onChanged: onChanged,
        ),
      ],
    );
  }
}
