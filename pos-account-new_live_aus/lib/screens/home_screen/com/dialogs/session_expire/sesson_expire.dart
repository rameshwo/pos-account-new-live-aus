import 'package:flutter/material.dart';
import 'package:pos_account/config/size_config.dart';
import 'package:pos_account/constant/constant.dart';
import 'package:pos_account/ln.dart';
import 'package:pos_account/providers/auth/auth_pro.dart';
import 'package:pos_account/providers/auth/db_login_req.dart';
import 'package:pos_account/providers/cus_val_pro.dart';
import 'package:pos_account/providers/z_multi_pro.dart';
import 'package:pos_account/services/database/database/db_local_data.dart';
import 'package:pos_account/services/database/shared_pref.dart';
import 'package:provider/provider.dart';

import 'com/d_2fa_sec.dart';
import 'com/d_login_sec.dart';

class SessionExpireSec extends StatefulWidget {
  final Function(bool)? closeDia;
  const SessionExpireSec({super.key, this.closeDia});

  static Future<void> show() async {
    if (CUS_CTX == null) return;

    GlobalCVP.authorize = Authorize.No;

    await Future.delayed(Duration(seconds: 1));

    if (!GlobalCVP.isSessionDialogOpen) {
      GlobalCVP.isSessionDialogOpen = true;

      showDialog(
          context: CUS_CTX!,
          barrierDismissible: false,
          builder: (ctx) {
            final size = Ssize(ctx);
            return WillPopScope(
              onWillPop: () async {
                return false;
              },
              child: SimpleDialog(
                backgroundColor: kBackgroundColor,
                titlePadding: EdgeInsets.zero,
                contentPadding: EdgeInsets.fromLTRB(
                    size.getW(24), size.getH(8), size.getW(24), size.getH(24)),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15)),
                children: [
                  SessionExpireSec(
                    closeDia: (p0) async {
                      if (p0) {
                        Navigator.pop(ctx);
                        GlobalCVP.isSessionDialogOpen = false;
                        await DbLocalData.deleteOrderNotify();
                        // await DbLocalData.deleteMenuRes();
                        MultiPro.reset;
                        Future.delayed(Duration(milliseconds: 200), () {
                          Navigator.pushNamedAndRemoveUntil(
                              CUS_CTX!, '/screen-cltr', (route) => false);
                        });
                      }
                    },
                  )
                ],
              ),
            );
          });
    }
  }

  @override
  State<SessionExpireSec> createState() => _SessionExpireSecState();
}

class _SessionExpireSecState extends State<SessionExpireSec> {
  final _formKey = GlobalKey<FormState>();

  final pageCltr = PageController();

  Future<bool?> _login({
    required AuthProvider ap,
    required String email,
    required String password,
  }) async {
    return await ap.doLogin(
      email: email,
      password: password,
      twofaFun: () async {
        await pageCltr.animateToPage(1,
            duration: Duration(milliseconds: 300), curve: Curves.easeInOut);
        ap.notify;
      },
    );
    // if (ap.loginRess != null) {
    //   if (ap.loginRess!.isEmailConfirmed != null &&
    //       ap.loginRess!.isEmailConfirmed!) {
    //     GlobalCVP.authorize = Authorize.Yes;
    //     ap.setAuthStatus = AuthStatus.AUTHENTICATE;

    //     ap.emailCltr.clear();
    //     ap.passCltr.clear();
    //     return true;
    //   } else {
    //     ap.errorMessage = ap.loginRess!.message;
    //     ap.setAuthStatus = AuthStatus.UNAUTHENTICATED;
    //     return false;
    //   }
    // }
  }

  bool initPage = true;

  load() {
    if (mounted) setState(() {});
  }

  DbLoginReq? _loginReq;

  @override
  void initState() {
    _getData();
    super.initState();
  }

  Future<void> _getData() async {
    _loginReq = await EncryptSharedPref.getLoginReq;
    load();
  }

  @override
  Widget build(BuildContext context) {
    final size = Ssize(context);
    final authPro = Provider.of<AuthProvider>(context);
    return Container(
      constraints: BoxConstraints(
        maxHeight: size.height / 1.5,
        minHeight: size.height / 4,
      ),
      width: size
          .getW(pageCltr.positions.isEmpty || pageCltr.page == 0 ? 560 : 800),
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            // crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  !initPage
                      ? IconButton(
                          onPressed: () async {
                            await pageCltr.animateToPage(0,
                                duration: Duration(milliseconds: 400),
                                curve: Curves.easeInOut);
                            authPro.notify;
                          },
                          icon: Icon(Icons.arrow_back))
                      : Container(),
                  // initPage
                  //     ?
                  //  TextButton(
                  //     onPressed: () {
                  //       Navigator.of(context).pop();
                  //       authPro.logOut();
                  //     },
                  //     style: ButtonStyle(
                  //         shape: MaterialStateProperty.all(
                  //           RoundedRectangleBorder(
                  //             side: BorderSide(color: kPrimaryColor),
                  //             borderRadius: BorderRadius.circular(5),
                  //           ),
                  //         ),
                  //         padding: MaterialStateProperty.all(
                  //             EdgeInsets.symmetric(
                  //                 vertical: size.getH(4),
                  //                 horizontal: size.getW(12)))),
                  //     child: Row(
                  //       mainAxisSize: MainAxisSize.min,
                  //       children: [
                  //         Text(
                  //           LN.logout,
                  //           style: TextStyle(
                  //               fontSize: size.getS(16),
                  //               fontFamily: kFontFRegular,
                  //               color: kPrimaryColor),
                  //         ),
                  //         SizedBox(
                  //           width: size.getW(4),
                  //         ),
                  //         Icon(
                  //           Icons.close,
                  //           size: size.getS(21),
                  //           color: kPrimaryColor,
                  //         )
                  //       ],
                  //     ))
                  // :
                  Container(),
                ],
              ),
              if (authPro.succMessage != null)
                Container(
                  width: size.getW(400),
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  margin: EdgeInsets.only(bottom: size.getH(12)),
                  decoration: BoxDecoration(
                      color: Colors.green.withAlpha(60),
                      borderRadius: BorderRadius.circular(10)),
                  child: Text(
                    authPro.succMessage!,
                    style: TextStyle(
                      fontSize: size.getS(18),
                      fontFamily: kFontFRegular,
                      color: Colors.green.shade900,
                    ),
                  ),
                )
              else if (authPro.errorMessage != null)
                Container(
                  width: size.getW(400),
                  padding: EdgeInsets.symmetric(
                      horizontal: size.getW(12), vertical: size.getH(8)),
                  margin: EdgeInsets.only(bottom: size.getH(12)),
                  decoration: BoxDecoration(
                      color: Colors.red.withAlpha(60),
                      borderRadius: BorderRadius.circular(10)),
                  child: Text(
                    authPro.errorMessage ?? '',
                    style: TextStyle(
                      fontSize: size.getS(18),
                      fontFamily: kFontFRegular,
                      color: Colors.red.shade900,
                    ),
                  ),
                ),
              AnimatedContainer(
                duration: Duration(milliseconds: 400),
                height: size.getH(
                    pageCltr.positions.isEmpty || pageCltr.page == 0
                        ? 300
                        : 420),
                child: PageView(
                  controller: pageCltr,
                  physics: NeverScrollableScrollPhysics(),
                  onPageChanged: (value) {
                    if (value == 0)
                      initPage = true;
                    else
                      initPage = false;
                    load();
                  },
                  children: [
                    DiaLoginSec(
                      loading: _loginReq == null ? null : authPro.loading,
                      onLogin: (bool val) async {
                        if (authPro.loading) return;

                        authPro.emailCltr.text = _loginReq?.email ?? '';

                        // authPro.emailCltr.text = authPro.emailCltr.text.trim();
                        // if (_formKey.currentState!.validate()) {
                        // if (WidgetsBinding.instance != null &&
                        //     WidgetsBinding
                        //             .instance!.window.viewInsets.bottom >
                        //         0.0) {
                        //   FocusManager.instance.primaryFocus?.unfocus();
                        // }

                        if (val) {
                          final status = await _login(
                            ap: authPro,
                            email: _loginReq?.email ?? '',
                            password: _loginReq?.password ?? '',
                          );
                          if (widget.closeDia != null) {
                            if (status ?? false) {
                              widget.closeDia!(true);
                            } else {
                              widget.closeDia!(false);
                            }
                          }
                        } else {
                          Navigator.of(context).pop();
                          authPro.logOut();
                        }
                        // }
                      },
                    ),
                    Dia2faSec(
                      authPro: authPro,
                      closeDia: widget.closeDia,
                      onCancel: () async {
                        await pageCltr.animateToPage(0,
                            duration: Duration(milliseconds: 400),
                            curve: Curves.easeInOut);
                        authPro.notify;
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
