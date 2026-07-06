import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:pos_account/config/size_config.dart';
import 'package:pos_account/constant/constant.dart';
import 'package:pos_account/ln.dart';
import 'package:pos_account/providers/setting/notification/notify_pro.dart';
import 'package:pos_account/widgets/input/text_form/title_text_form.dart';
import 'package:pos_account/widgets/load_btn.dart';
import 'package:pos_account/widgets/loading.dart';
import 'package:pos_account/widgets/switch_adap.dart';
import 'package:provider/provider.dart';

class SMSSetting extends StatefulWidget {
  const SMSSetting({super.key});

  @override
  State<SMSSetting> createState() => _SMSSettingState();
}

class _SMSSettingState extends State<SMSSetting> {
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    getData();
    super.initState();
  }

  NotifyPro? _notifyPro;

  Future<void> getData() async {
    _notifyPro = Provider.of<NotifyPro>(context, listen: false);
    await _notifyPro?.getSmsData();
  }

  @override
  void dispose() {
    _notifyPro?.smsClear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = Ssize(context);
    final notifyPro = Provider.of<NotifyPro>(context);
    // print("${notifyPro.loading} ${notifyPro.smsList.isEmpty}");
    if (notifyPro.smsLoading && notifyPro.smsList.isEmpty)
      return Loading();
    else
      return Processing(
        loading: notifyPro.smsLoading,
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
                        ...List.generate(notifyPro.smsList.length, (i) {
                          return Padding(
                            padding: EdgeInsets.only(bottom: size.getH(16)),
                            child: _smsAddSec(
                              size,
                              clientIdCltr: notifyPro.smsList[i].clientId!,
                              clientSecCltr: notifyPro.smsList[i].clientSecret!,
                              fromNumCltr: notifyPro.smsList[i].fromNumber!,
                              isActive: notifyPro.smsList[i].isActive ?? false,
                              onUpdate: (val, flag) {
                                if (flag == 0) {
                                  notifyPro.smsList[i].isActive = val;
                                }
                                notifyPro.notify;
                              },
                            ),
                          );
                        }),
                        SizedBox(
                          height: size.getH(16),
                        ),
                        LoadButton(
                          btnText: LN.save,
                          loading: notifyPro.smsUpdateLoad,
                          onsave: notifyPro.smsUpdateLoad
                              ? null
                              : () {
                                  if (_formKey.currentState?.validate() ??
                                      false) notifyPro.updateSms();
                                },
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      );
  }

  DottedBorder _smsAddSec(
    Ssize size, {
    required TextEditingController clientIdCltr,
    required TextEditingController clientSecCltr,
    required TextEditingController fromNumCltr,
    required bool isActive,
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
                    // width: size.getW(300),
                    child: TitleTextForm(
                      title: LN.clientId,
                      textCltr: clientIdCltr,
                      borderColor: Colors.black26,
                    ),
                  ),
                  SizedBox(
                    // width: size.getW(300),
                    child: TitleTextForm(
                      title: LN.clientSecret,
                      textCltr: clientSecCltr,
                      borderColor: Colors.black26,
                    ),
                  ),
                  SizedBox(
                    // width: size.getW(240),
                    child: TitleTextForm(
                      title: LN.fromNum,
                      isReq: false,
                      textCltr: fromNumCltr,
                      borderColor: Colors.black26,
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
