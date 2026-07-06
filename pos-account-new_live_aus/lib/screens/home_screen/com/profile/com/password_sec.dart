import 'package:flutter/material.dart';
import 'package:pos_account/config/size_config.dart';
import 'package:pos_account/config/validator.dart';
import 'package:pos_account/constant/constant.dart';
import 'package:pos_account/ln.dart';
import 'package:pos_account/providers/auth/auth_pro.dart';
import 'package:pos_account/providers/auth/change_pass_pro.dart';
import 'package:pos_account/widgets/dialog/confirm_dialog.dart';
import 'package:pos_account/widgets/dialog/msg_dialog.dart';
import 'package:pos_account/widgets/input/text_form/title_text_form.dart';
import 'package:pos_account/widgets/load_btn.dart';
import 'package:pos_account/widgets/loading.dart';
import 'package:pos_account/widgets/switch_adap.dart';
import 'package:provider/provider.dart';

class PasswordSec extends StatefulWidget {
  final bool? is2faEnabled;
  final Function()? refreshInfo;
  const PasswordSec({
    super.key,
    this.is2faEnabled,
    this.refreshInfo,
  });

  @override
  State<PasswordSec> createState() => _PasswordSecState();
}

class _PasswordSecState extends State<PasswordSec> {
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    setData();
    super.initState();
  }

  ChangePassPro? _cpPro;

  setData() {
    _cpPro = Provider.of<ChangePassPro>(context, listen: false);
    _cpPro?.setData(
      is2faEnabled: widget.is2faEnabled,
    );
  }

  @override
  void dispose() {
    _cpPro?.clear();
    super.dispose();
  }

  late ChangePassPro cpPro;

  void _changePassword() {
    cpPro.changePassword().then((val) {
      if (val ?? false) {
        if (!cpPro.staySignedIn) {
          final authProvider =
              Provider.of<AuthProvider>(context, listen: false);
          authProvider.logOut();
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    cpPro = Provider.of<ChangePassPro>(context);
    final size = Ssize(context);
    return Form(
      key: _formKey,
      child: Processing(
        loading: cpPro.loading,
        child: SingleChildScrollView(
          physics: NeverScrollableScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    LN.passAndSec,
                    style: TextStyle(
                      color: Colors.black38,
                      fontFamily: kFontFMedium,
                      fontSize: size.getS(24),
                    ),
                  ),
                  LoadButton(
                    btnText: LN.sendDeviceId,
                    width: 240,
                    hPad: 12,
                    loading: cpPro.emailSendLoad,
                    onsave: () {
                      cpPro.sendDeviceIdEmail().then((value) {
                        if (value ?? false) {
                          MsgDia.show(
                            context,
                            headerAnimation: false,
                            diaType: DiaType.success,
                            // title: LN.success,
                            title: LN.emailSuccess,
                            autoHideSecond: 2,
                          );
                        }
                      });
                    },
                  )
                  // Text(
                  //   "${LN.lastUpOn} Aug 1",
                  //   style: TextStyle(
                  //     color: Colors.black38,
                  //     fontFamily: kFontFMedium,
                  //     fontSize: size.getS(16),
                  //   ),
                  // ),
                ],
              ),
              AnimatedContainer(
                duration: Duration(milliseconds: 400),
                width: size.width * 0.5,
                height: cpPro.errMessage != null ? size.getH(40) : 0,
                margin: EdgeInsets.only(
                    top: cpPro.errMessage != null ? size.getH(16) : 0),
                padding: EdgeInsets.symmetric(
                    horizontal: size.getW(12), vertical: size.getH(8)),
                decoration: BoxDecoration(
                    color: Colors.red.withAlpha(60),
                    borderRadius: BorderRadius.circular(10)),
                alignment: Alignment.centerLeft,
                child: Text(
                  cpPro.errMessage ?? '',
                  style: TextStyle(
                    fontSize: size.getS(18),
                    fontFamily: kFontFRegular,
                    color: Colors.red.shade900,
                  ),
                ),
              ),
              AnimatedContainer(
                duration: Duration(milliseconds: 400),
                width: size.width * 0.5,
                height: cpPro.successMessage != null ? size.getH(40) : 0,
                margin: EdgeInsets.only(
                    top: cpPro.successMessage != null ? size.getH(16) : 0),
                padding: EdgeInsets.symmetric(
                    horizontal: size.getW(12), vertical: size.getH(8)),
                decoration: BoxDecoration(
                    color: Colors.green.withAlpha(60),
                    borderRadius: BorderRadius.circular(10)),
                alignment: Alignment.centerLeft,
                child: Text(
                  cpPro.successMessage ?? '',
                  style: TextStyle(
                    fontSize: size.getS(18),
                    fontFamily: kFontFRegular,
                    color: Colors.green.shade900,
                  ),
                ),
              ),
              SizedBox(
                height: size.getH(8),
              ),
              Row(
                children: [
                  TitleTextForm(
                    title: LN.email,
                    isReq: false,
                    readOnly: true,
                    hintText: LN.enterEmail,
                    textCltr: cpPro.emailCltr,
                    borderColor: Colors.black12,
                    pWidth: 0.24,
                    validator: emailValidator,
                    fillColor: Colors.grey.shade100,
                  ),
                  SizedBox(width: size.getW(32)),
                  TitleTextForm(
                    title: LN.oldPassword,
                    isReq: true,
                    hintText: LN.oldPassword,
                    textCltr: cpPro.oldPassCltr,
                    borderColor: Colors.black12,
                    pWidth: 0.24,
                    suffixIcon: InkWell(
                      onTap: () {
                        cpPro.showOldPass = !cpPro.showOldPass;
                        cpPro.notify;
                      },
                      child: Icon(
                        cpPro.showOldPass
                            ? Icons.visibility
                            : Icons.visibility_off_outlined,
                        size: size.getS(24),
                      ),
                    ),
                    obsecure: !cpPro.showOldPass,
                    validator: passwordValidator,
                  ),
                  Spacer(),
                ],
              ),
              SizedBox(
                height: size.getH(16),
              ),
              Wrap(
                spacing: size.getW(32),
                runSpacing: size.getH(16),
                children: [
                  TitleTextForm(
                    title: LN.newPassword,
                    isReq: true,
                    hintText: LN.newPassword,
                    textCltr: cpPro.newPassCltr,
                    borderColor: Colors.black12,
                    pWidth: 0.24,
                    suffixIcon: InkWell(
                      onTap: () {
                        cpPro.showNewPass = !cpPro.showNewPass;
                        cpPro.notify;
                      },
                      child: Icon(
                        cpPro.showNewPass
                            ? Icons.visibility
                            : Icons.visibility_off_outlined,
                        size: size.getS(24),
                      ),
                    ),
                    obsecure: !cpPro.showNewPass,
                    validator: passwordValidator,
                  ),
                  TitleTextForm(
                    title: LN.confirmNewPassword,
                    isReq: true,
                    hintText: LN.confirmNewPassword,
                    textCltr: cpPro.conNewPassCltr,
                    borderColor: Colors.black12,
                    pWidth: 0.24,
                    suffixIcon: InkWell(
                      onTap: () {
                        cpPro.showNewPass = !cpPro.showNewPass;
                        cpPro.notify;
                      },
                      child: Icon(
                        cpPro.showNewPass
                            ? Icons.visibility
                            : Icons.visibility_off_outlined,
                        size: size.getS(24),
                      ),
                    ),
                    obsecure: !cpPro.showNewPass,
                    validator: (String? val) =>
                        confirmPasswordValidator(val, cpPro.newPassCltr.text),
                  ),
                  Tooltip(
                    message: LN.willAutoLogoutDevices,
                    child: Padding(
                      padding: EdgeInsets.only(top: size.getH(32)),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SwitchAdap(
                              size: size,
                              value: cpPro.staySignedIn,
                              onChanged: (val) async {
                                // if (!val) {
                                //   showDialog(
                                //       context: context,
                                //       builder: (builder) => ConfirmDialog(
                                //             title: "Logout from all the devices",
                                //             subTitle:
                                //                 "Are you sure you want to logout from all devices?",
                                //             actionText: LN.yes,
                                //             cancelText: LN.no,
                                //             onDelete: () {
                                //               cpPro.staySignedIn = val;
                                //               cpPro.notify;
                                //             },
                                //           ));
                                // } else {
                                cpPro.staySignedIn = val;
                                cpPro.notify;
                                // }
                              }),
                          SizedBox(
                            width: size.getW(12),
                          ),
                          Text(
                            LN.staySignedIn,
                            style: TextStyle(
                              color: kPrimaryColor,
                              fontFamily: kFontFMedium,
                              fontWeight: FontWeight.bold,
                              fontSize: size.getS(16),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: size.getH(16),
              ),
              LoadButton(
                btnColor: kUserColor,
                onsave: cpPro.loading
                    ? null
                    : () {
                        if (_formKey.currentState!.validate()) {
                          if (!cpPro.staySignedIn) {
                            showDialog(
                                context: context,
                                builder: (builder) => ConfirmDialog(
                                      title: "${LN.changePassword}?",
                                      subTitle:
                                          LN.confirmLogoutDeviceCheckSignin,
                                      actionText: LN.yes,
                                      cancelText: LN.no,
                                      onDelete: () async {
                                        _changePassword();
                                        return null;
                                      },
                                    ));
                          } else {
                            _changePassword();
                          }
                        }
                      },
                loading: cpPro.loading,
                btnText: LN.save,
                vPad: 8,
              ),
              SizedBox(
                height: size.getH(12),
              ),
              Divider(
                color: Colors.black38,
                thickness: 0.5,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    LN.en2FaAccReadyText,
                    style: TextStyle(
                      color: kPrimaryColor,
                      fontSize: size.getS(16),
                    ),
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SwitchAdap(
                          size: size,
                          value: cpPro.enable2fa,
                          onChanged: (val) async {
                            cpPro.enable2fa = val;
                            cpPro.notify;
                            final status = await cpPro.enableDis2fa();
                            if (status ?? false) {
                              if (widget.refreshInfo != null) {
                                widget.refreshInfo!();
                              }
                            }
                          }),
                      SizedBox(
                        width: size.getW(12),
                      ),
                      Text(
                        LN.enable2Fa,
                        style: TextStyle(
                          color: kPrimaryColor,
                          fontFamily: kFontFMedium,
                          fontWeight: FontWeight.bold,
                          fontSize: size.getS(16),
                        ),
                      ),
                    ],
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
