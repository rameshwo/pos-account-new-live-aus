import 'package:flutter/material.dart';
import 'package:pos_account/config/size_config.dart';
import 'package:pos_account/constant/constant.dart';
import 'package:pos_account/providers/auth/auth_pro.dart';
import 'package:pos_account/widgets/loading.dart';
import 'package:provider/provider.dart';
import 'com/login_sec.dart';
import 'com/register/register_screen.dart';
import 'com/two_fa/two_fa_screen.dart';

class LoginScreen extends StatefulWidget {
  static const String routeName = '/login-screen';
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _pageCltr = PageController();

  @override
  void initState() {
    super.initState();
    getData();
  }

  getData() {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    authProvider.getBannerImages();
    // _authProvider.getCountryList();
  }

  @override
  void dispose() {
    _pageCltr.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = Ssize(context);
    final authProvider = Provider.of<AuthProvider>(context);
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
          child: Processing(
        loading: authProvider.loading,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Row(
              //   crossAxisAlignment: CrossAxisAlignment.start,
              //   children: [
              //     SizedBox(
              //       width: size.getW(12),
              //     ),
              //     Container(
              //         color: Colors.transparent,
              //         child: Image.asset(
              //           "assets/png/pos-logo.png",
              //           width: size.getW(72),
              //           height: size.getW(72),
              //         )),
              //     SizedBox(
              //       width: size.getW(32),
              //     ),
              //     Column(
              //       crossAxisAlignment: CrossAxisAlignment.start,
              //       children: [
              //         HeaderLogo(),
              //         Text(
              //           DATE_FORMAT.format(DateTime.now()),
              //           style: TextStyle(
              //             color: kPrimaryColor,
              //             fontSize: size.getS(15),
              //           ),
              //         ),
              //       ],
              //     ),
              //   ],
              // ),
              // SizedBox(height: size.getH(28)),
              Container(
                constraints: BoxConstraints(
                  minHeight: size.getH(10),
                  maxHeight: size.getH(80),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    AnimatedContainer(
                      duration: Duration(milliseconds: 400),
                      width: size.width * 0.85,
                      constraints: BoxConstraints(
                        minHeight: authProvider.errorMessage != null
                            ? size.getH(40)
                            : 0,
                        maxHeight: authProvider.errorMessage != null
                            ? size.getH(80)
                            : 0,
                      ),
                      padding: EdgeInsets.symmetric(
                          horizontal: size.getW(12), vertical: size.getH(8)),
                      decoration: BoxDecoration(
                          color: Colors.red.withAlpha(60),
                          borderRadius: BorderRadius.circular(10)),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              authProvider.errorMessage ?? '',
                              style: TextStyle(
                                fontSize: size.getS(18),
                                fontFamily: kFontFRegular,
                                color: Colors.red.shade900,
                              ),
                            ),
                          ),
                          if (authProvider.errorMessage != null)
                            InkWell(
                                onTap: () {
                                  authProvider.errorMessage = null;
                                  authProvider.notify;
                                },
                                child: Icon(Icons.close))
                        ],
                      ),
                    ),
                    AnimatedContainer(
                      duration: Duration(milliseconds: 400),
                      width: size.width * 0.85,
                      constraints: BoxConstraints(
                        minHeight: authProvider.succMessage != null
                            ? size.getH(40)
                            : 0,
                        maxHeight: authProvider.succMessage != null
                            ? size.getH(80)
                            : 0,
                      ),
                      padding: EdgeInsets.symmetric(
                          horizontal: size.getW(12), vertical: size.getH(8)),
                      decoration: BoxDecoration(
                          color: Colors.green.withAlpha(60),
                          borderRadius: BorderRadius.circular(10)),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              authProvider.succMessage ?? '',
                              style: TextStyle(
                                fontSize: size.getS(18),
                                fontFamily: kFontFRegular,
                                color: Colors.green.shade900,
                              ),
                            ),
                          ),
                          if (authProvider.succMessage != null)
                            InkWell(
                                onTap: () {
                                  authProvider.succMessage = null;
                                  authProvider.notify;
                                },
                                child: Icon(Icons.close))
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Flexible(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      SizedBox(
                        width: size.width * 0.85,
                        height: size.isProt ? size.getH(760) : size.getH(675),
                        child: PageView(
                          physics: NeverScrollableScrollPhysics(),
                          controller: _pageCltr,
                          children: [
                            Card(
                              shape: RoundedRectangleBorder(
                                  side: BorderSide(
                                    color: kSecondaryColor,
                                    width: 1,
                                  ),
                                  borderRadius: BorderRadius.circular(10)),
                              child: LoginSection(
                                authPro: authProvider,
                                size: size,
                                pageCltr: _pageCltr,
                              ),
                            ),
                            authProvider.authPageState == AuthPageState.Login
                                ? Card(
                                    shape: RoundedRectangleBorder(
                                        side: BorderSide(
                                          color: kSecondaryColor,
                                          width: 1,
                                        ),
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    child: TwoFaScreen(
                                      authPro: authProvider,
                                      pageCltr: _pageCltr,
                                      size: size,
                                    ),
                                  )
                                : Card(
                                    color: Colors.white,
                                    shape: RoundedRectangleBorder(
                                        side: BorderSide(
                                          color: kSecondaryColor,
                                          width: 1,
                                        ),
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    child: RegisterScreen(
                                      authPro: authProvider,
                                      pageCltr: _pageCltr,
                                      size: size,
                                    ),
                                  )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // SizedBox(
              //   height: size.getH(100),
              // ),
            ],
          ),
        ),
      )),
    );
  }
}
