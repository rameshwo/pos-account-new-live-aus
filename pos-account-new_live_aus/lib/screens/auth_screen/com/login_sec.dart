import 'package:flutter/material.dart';
import 'package:pos_account/config/responsive.dart';
import 'package:pos_account/config/size_config.dart';
import 'package:pos_account/config/utils/utils.dart';
import 'package:pos_account/config/validator.dart';
import 'package:pos_account/constant/constant.dart';
import 'package:pos_account/ln.dart';
import 'package:pos_account/providers/auth/auth_pro.dart';
import 'package:pos_account/widgets/header_logo.dart';
import 'package:pos_account/widgets/image/network_image_sec.dart';
import 'package:pos_account/widgets/input/text_form/text_form_widget.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:pos_account/widgets/load_btn.dart';
import 'package:pos_account/widgets/pin_lock/pin_lock_sec.dart';
import 'package:pos_account/widgets/switch_adap.dart';

class _TabData {
  final String title;
  final IconData icon;

  _TabData({
    required this.title,
    required this.icon,
  });
}

class LoginSection extends StatefulWidget {
  final AuthProvider authPro;
  final Ssize size;
  final PageController pageCltr;
  const LoginSection({
    super.key,
    required this.authPro,
    required this.size,
    required this.pageCltr,
  });

  @override
  State<LoginSection> createState() => _LoginSectionState();
}

class _LoginSectionState extends State<LoginSection>
    with TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _formKeyFP = GlobalKey<FormState>();
  final _formKeyRegister = GlobalKey<FormState>();
  PageController? _pageCltr;
  late TabController _tabCltr;

  final _kTabs = [
    _TabData(title: "Login with email", icon: Icons.email),
    _TabData(title: "Login with code", icon: Icons.pin),
  ];
  // String loginCode = "";

  @override
  void initState() {
    super.initState();

    _pageCltr = PageController(
        initialPage:
            widget.authPro.onBackPageState == AuthPageState.Login ? 1 : 0);
    _tabCltr = TabController(length: _kTabs.length, vsync: this);
    widget.authPro.onBackPageState = AuthPageState.Login;
  }

  _login({
    required AuthProvider ap,
    required String email,
    required String password,
  }) async {
    await ap.doLogin(
      email: email,
      password: password,
      twofaFun: () async {
        await widget.pageCltr.animateToPage(1,
            duration: Duration(milliseconds: 300), curve: Curves.easeInOut);
      },
    );
  }

  // Future<void> _loginWithCode() async {
  //   if (loginCode.length != 4) {
  //     showToast("Invalid login code");
  //     return;
  //   }
  //   await widget.authPro.doLoginWithCode(code: loginCode);
  // }

  Widget _loginSection(BuildContext context) {
    final size = Ssize(context);
    return Padding(
      padding: EdgeInsets.symmetric(
          horizontal: size.getW(16), vertical: size.getH(24)),
      child: DefaultTabController(
        length: _kTabs.length,
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                HeaderLogo(height: 60),
                LoadButton(
                  btnText: "Get Device Info",
                  btnColor: Colors.white,
                  textColor: kSecondaryColor,
                  vPad: 10,
                  hPad: 4,
                  width: 200,
                  // loading: widget.authPro.loading,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5),
                    side: BorderSide(color: kSecondaryColor),
                  ),
                  onsave: () {
                    widget.authPro.sendDeviceIdEmail();
                  },
                ),
              ],
            ),
            Divider(
              color: kSecondaryColor,
              thickness: 1.5,
            ),
            // Align(
            //   alignment: Alignment.topCenter,
            //   child: TextButton(
            //       style: ButtonStyle(visualDensity: VisualDensity.compact),
            //       onPressed: widget.authPro.loading
            //           ? null
            //           : () {
            //               widget.authPro.sendDeviceIdEmail();
            //             },
            //       child: Text(
            //         "Get Device Info",
            //         style: TextStyle(
            //           fontSize: widget.size.getS(16),
            //           color: kPrimaryColor,
            //           fontFamily: kFontFMedium,
            //         ),
            //       )),
            // ),
            // Align(
            //   alignment: Alignment.topRight,
            //   child: Padding(
            //     padding: EdgeInsets.only(
            //       top: widget.size.getH(24),
            //     ),
            //     child: Text.rich(TextSpan(
            //         text: LN.dontHaveAcc,
            //         style: TextStyle(
            //           fontSize: widget.size.getS(16),
            //           color: Colors.black,
            //         ),
            //         children: [
            //           TextSpan(
            //             text: " ${LN.register}",
            //             style: TextStyle(
            //               fontSize: widget.size.getS(16),
            //               color: kPrimaryColor,
            //               fontWeight: FontWeight.bold,
            //             ),
            //             recognizer: TapGestureRecognizer()
            //               ..onTap = () {
            //                 widget.authPro.authPageState = AuthPageState.Register;
            //                 widget.authPro.succMessage = null;
            //                 widget.authPro.errorMessage = null;
            //                 widget.authPro.notify;
            //                 _pageCltr?.animateToPage(0,
            //                     duration: Duration(milliseconds: 300),
            //                     curve: Curves.easeInOut);
            //               },
            //           )
            //         ])),
            //   ),
            // ),
            Flexible(
              child: Center(
                child: Form(
                  key: _formKey,
                  child: SizedBox(
                    width: Responsive.isMobile(context)
                        ? widget.size.getW(700)
                        : Responsive.isTablet(context)
                            ? widget.size.getW(540)
                            : double.infinity,
                    child: Column(
                      children: [
                        // Text(
                        //   LN.welcomeBack,
                        //   style: TextStyle(
                        //     fontSize: widget.size.getS(36),
                        //     color: Colors.black,
                        //     fontWeight: FontWeight.bold,
                        //   ),
                        // ),
                        // Text(
                        //   LN.loginAc,
                        //   style: TextStyle(
                        //     fontSize: widget.size.getS(20),
                        //     color: Colors.black,
                        //   ),
                        // ),
                        SizedBox(
                          height: widget.size.getH(20),
                        ),
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.grey.shade200,
                            borderRadius: BorderRadius.circular(5),
                          ),
                          padding: EdgeInsets.all(size.getS(4)),
                          child: TabBar(
                            controller: _tabCltr,
                            tabs: _kTabs
                                .map((e) => Row(
                                      children: [
                                        Icon(e.icon, size: size.getS(25)),
                                        SizedBox(width: size.getW(12)),
                                        Text(
                                          e.title,
                                          style: TextStyle(
                                            fontSize: size.getS(18),
                                            fontFamily: kFontFMedium,
                                          ),
                                        ),
                                      ],
                                    ))
                                .toList(),
                            indicatorColor: Colors.transparent,
                            labelColor: kSecondaryColor,
                            unselectedLabelColor: Colors.black54,
                            indicator: BoxDecoration(color: Colors.white),
                            labelStyle: TextStyle(
                              fontSize: size.getS(18),
                              fontFamily: kFontFMedium,
                            ),
                            labelPadding: EdgeInsets.symmetric(
                                horizontal: size.getW(24),
                                vertical: size.getH(8)),
                            onTap: (v) {
                              widget.authPro.notify;
                            },
                          ),
                        ),
                        SizedBox(
                          height: widget.size.getH(20),
                        ),
                        Flexible(
                          child: TabBarView(
                            controller: _tabCltr,
                            physics: NeverScrollableScrollPhysics(),
                            children: [
                              _emailPassLogin(),
                              _pinLogin(),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            // Align(
            //   alignment: Alignment.center,
            //   child: Text.rich(TextSpan(
            //       text: LN.dontHaveAcc,
            //       style: TextStyle(
            //         fontSize: widget.size.getS(16),
            //         color: Colors.black,
            //       ),
            //       children: [
            //         TextSpan(
            //           text: " ${LN.register}",
            //           style: TextStyle(
            //             fontSize: widget.size.getS(16),
            //             color: kPrimaryColor,
            //             fontWeight: FontWeight.bold,
            //           ),
            //           recognizer: TapGestureRecognizer()
            //             ..onTap = () {
            //               widget.authPro.authPageState = AuthPageState.Register;
            //               widget.authPro.succMessage = null;
            //               widget.authPro.errorMessage = null;
            //               widget.authPro.notify;
            //               _pageCltr?.animateToPage(0,
            //                   duration: Duration(milliseconds: 300),
            //                   curve: Curves.easeInOut);
            //             },
            //         )
            //       ])),
            // ),
          ],
        ),
      ),
    );
  }

  Widget _emailPassLogin() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: widget.size.getW(4)),
      child: Column(
        children: [
          AutofillGroup(
            child: Column(
              children: [
                TextFormWidget(
                  vPad: 16,
                  hPad: 16,
                  textStyle: TextStyle(fontSize: widget.size.getS(18)),
                  borderRadius: 10,
                  borderColor: Colors.black38,
                  cltr: widget.authPro.emailCltr,
                  hintText: LN.email,
                  validator: emailValidator,
                  textInputType: TextInputType.emailAddress,
                  autofillHints: const [AutofillHints.email],
                ),
                Padding(
                  padding: EdgeInsets.only(top: widget.size.getH(32)),
                  child: TextFormWidget(
                    vPad: 16,
                    hPad: 16,
                    borderColor: Colors.black38,
                    textStyle: TextStyle(fontSize: widget.size.getS(18)),
                    borderRadius: 10,
                    cltr: widget.authPro.passCltr,
                    hintText: LN.password,
                    textInputType: TextInputType.visiblePassword,
                    suffixIcon: InkWell(
                      onTap: () {
                        widget.authPro.setShowPass =
                            !widget.authPro.getShowPass;
                      },
                      child: Icon(
                        widget.authPro.getShowPass
                            ? Icons.visibility
                            : Icons.visibility_off_outlined,
                        size: widget.size.getS(24),
                      ),
                    ),
                    obsecure: !widget.authPro.getShowPass,
                    validator: passwordValidator,
                    autofillHints: const [AutofillHints.password],
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: widget.size.getH(32),
          ),
          // DropDownList(
          //   isReq: true,
          //   list: widget.authPro.initCountryList == null
          //       ? []
          //       : widget.authPro.initCountryList!
          //           .map((e) => e.name)
          //           .toList(),
          //   indexValue: widget.authPro.loginCountryIndex,
          //   hint: LN.country,
          //   borderRadius: 10,
          //   borderColor: Colors.white12,
          //   vPad: 20,
          //   hPad: 0,
          //   fontSize: 18,
          //   onChange: (int? val) {
          //     widget.authPro.loginCountryIndex = val;
          //     widget.authPro.notify;
          //     widget.authPro.onChangedCountry();
          //   },
          // ),
          // SizedBox(
          //   height: widget.size.getH(12),
          // ),
          Row(
            children: [
              SwitchAdap(
                size: widget.size,
                value: widget.authPro.getRM,
                onChanged: (val) {
                  widget.authPro.setRM = !widget.authPro.getRM;
                },
              ),
              SizedBox(
                width: widget.size.getW(12),
              ),
              Text(
                LN.rememberMe,
                style: TextStyle(
                  fontSize: widget.size.getS(16),
                  color: Colors.black,
                ),
              ),
              // Spacer(),
              // TextButton(
              //   onPressed: () {
              //     widget.authPro.succMessage = null;
              //     widget.authPro.errorMessage = null;
              //     widget.authPro.notify;
              //     _pageCltr?.animateToPage(2,
              //         duration: Duration(milliseconds: 300),
              //         curve: Curves.easeInOut);
              //   },
              //   child: Text(
              //     LN.forgotPassword,
              //     style: TextStyle(
              //       fontSize: widget.size.getS(16),
              //       color: kSecondaryColor,
              //     ),
              //   ),
              // ),
            ],
          ),
          SizedBox(
            height: widget.size.getH(28),
          ),
          _loginButton(
              onTap: widget.authPro.loading
                  ? null
                  : () {
                      widget.authPro.authPageState = AuthPageState.Login;
                      widget.authPro.emailCltr.text =
                          widget.authPro.emailCltr.text.trim();
                      if (_formKey.currentState!.validate()) {
                        Utils.hideKeyBoard();
                        _login(
                          ap: widget.authPro,
                          email: widget.authPro.emailCltr.text,
                          password: widget.authPro.passCltr.text,
                        );
                      }
                    }),
          SizedBox(
            height: widget.size.getH(32),
          ),
        ],
      ),
    );
  }

  Widget _pinLogin() {
    return Column(
      children: [
        Expanded(
          child: PinLockSection(
            validate: _validate,
            isSection: true,
            decoration: BoxDecoration(),
          ),
        )
        // OtpCodeSec(
        //   otpMessage: "Enter your 4-digit code",
        //   // onTap: oTpValidate,
        //   isExpire: true,
        //   // loading: loading,
        //   otpLength: 4,
        //   width: 240,
        //   fsize: Size(54, 60),
        //   onChanged: (val) {
        //     loginCode = val;
        //   },
        // ),
        // Row(children: [
        //   SwitchAdap(
        //     size: widget.size,
        //     value: widget.authPro.getRM,
        //     onChanged: (val) {
        //       widget.authPro.setRM =
        //           !widget.authPro.getRM;
        //     },
        //   ),
        //   SizedBox(
        //     width: widget.size.getW(12),
        //   ),
        //   Text(
        //     LN.rememberMe,
        //     style: TextStyle(
        //       fontSize: widget.size.getS(16),
        //       color: Colors.black,
        //     ),
        //   ),
        // ]),
        // SizedBox(
        //   height: widget.size.getH(28),
        // ),
        // _loginButton(
        //     onTap: widget.authPro.loading
        //         ? null
        //         : () {
        //             widget.authPro.authPageState =
        //                 AuthPageState.Login;

        //             _loginWithCode();
        //           }),
        // SizedBox(
        //   height: widget.size.getH(32),
        // ),
      ],
    );
  }

  Future<void> _validate(
      {required void Function() clear, required String pin}) async {
    widget.authPro.authPageState = AuthPageState.Login;

    final _status = await widget.authPro.doLoginWithCode(code: pin);

    if (_status ?? false) {
      // _gotoPage(1);
      // Navigator.pop(context, true);
      clear();
    } else {
      clear();
    }
  }

  Widget _loginButton({
    Function()? onTap,
  }) {
    return SizedBox(
      width: double.infinity,
      child: TextButton(
        onPressed: onTap,
        style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(kBackgroundColor),
            shape: MaterialStateProperty.all(RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
                side: BorderSide(
                  color: kSecondaryColor,
                ))),
            padding: MaterialStateProperty.all(EdgeInsets.symmetric(
              vertical: widget.size.getH(widget.size.isDesktop ? 24 : 12),
            ))),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              LN.logIn,
              style: TextStyle(
                fontSize: widget.size.getS(20),
                color: kSecondaryColor,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _forgotPassSec() {
    return Form(
      key: _formKeyFP,
      child: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: widget.size.getH(20),
            ),
            Row(
              children: [
                IconButton(
                    onPressed: () {
                      widget.authPro.succMessage = null;
                      widget.authPro.errorMessage = null;
                      widget.authPro.notify;
                      _pageCltr?.animateToPage(1,
                          duration: Duration(milliseconds: 300),
                          curve: Curves.easeInOut);
                    },
                    icon: Icon(Icons.arrow_back, size: widget.size.getS(32))),
              ],
            ),
            SizedBox(
              height: widget.size.getH(60),
            ),
            Text(
              LN.resetYourPass,
              style: TextStyle(
                fontSize: widget.size.getS(36),
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(
              width: widget.size.getW(640),
              child: Text(
                LN.resetPassSubtitle,
                style: TextStyle(
                  fontSize: widget.size.getS(20),
                  color: Colors.black,
                ),
              ),
            ),
            SizedBox(
              height: widget.size.getH(60),
            ),
            SizedBox(
              width: widget.size.getW(640),
              child: TextFormWidget(
                vPad: 16,
                hPad: 16,
                borderColor: Colors.black38,
                textStyle: TextStyle(fontSize: widget.size.getS(18)),
                borderRadius: 10,
                cltr: widget.authPro.forEmailCltr,
                hintText: LN.emailAddress,
                validator: emailValidator,
              ),
            ),
            SizedBox(
              height: widget.size.getH(28),
            ),
            SizedBox(
              width: widget.size.getW(640),
              child: TextButton(
                onPressed: () {
                  if (_formKeyFP.currentState!.validate()) {
                    widget.authPro.forgotPass();
                  }
                },
                style: ButtonStyle(
                    shape: WidgetStateProperty.all(RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                        side: BorderSide(
                          color: Colors.black87,
                        ))),
                    padding: WidgetStateProperty.all(EdgeInsets.symmetric(
                      vertical: widget.size.getH(16),
                    ))),
                child: Text(
                  LN.resetMyPass,
                  style: TextStyle(
                    fontSize: widget.size.getS(20),
                    color: Colors.black,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _registerNow() {
    return Form(
      key: _formKeyRegister,
      child: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: widget.size.getH(20),
            ),
            Row(
              children: [
                IconButton(
                    onPressed: () {
                      widget.authPro.authPageState = AuthPageState.Login;
                      widget.authPro.succMessage = null;
                      widget.authPro.errorMessage = null;
                      widget.authPro.notify;
                      _pageCltr?.animateToPage(1,
                          duration: Duration(milliseconds: 300),
                          curve: Curves.easeInOut);
                    },
                    icon: Icon(
                      Icons.arrow_back,
                      size: widget.size.getS(32),
                    )),
              ],
            ),
            SizedBox(
              height: widget.size.getH(60),
            ),
            Text(
              LN.registerNow,
              style: TextStyle(
                fontSize: widget.size.getS(36),
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
            // SizedBox(
            //   width: size.getW(540),
            //   child: Text(
            //     "Register subtitle text",
            //     style: TextStyle(
            //       fontSize: size.getS(20),
            //       color: Colors.black,
            //     ),
            //   ),
            // ),
            SizedBox(
              height: widget.size.getH(60),
            ),
            SizedBox(
              width: widget.size.getW(640),
              child: TextFormWidget(
                vPad: 16,
                hPad: 16,
                borderColor: Colors.black38,
                textStyle: TextStyle(fontSize: widget.size.getS(18)),
                borderRadius: 10,
                cltr: widget.authPro.emailCltr,
                hintText: LN.emailAddress,
                validator: emailValidator,
              ),
            ),
            SizedBox(
              height: widget.size.getH(28),
            ),
            SizedBox(
              width: widget.size.getW(640),
              child: TextButton(
                onPressed: () {
                  widget.authPro.initvalidateOtpOnRegister = false;
                  if (_formKeyRegister.currentState!.validate()) {
                    widget.authPro.loading = true;
                    widget.authPro.notify;
                    widget.authPro
                        .sendOtpToMailRegister(
                            email: widget.authPro.emailCltr.text)
                        .then((value) {
                      if (value ?? false) {
                        widget.pageCltr.animateToPage(1,
                            duration: Duration(milliseconds: 300),
                            curve: Curves.easeInOut);
                      }
                    });
                  }
                },
                style: ButtonStyle(
                    shape: WidgetStateProperty.all(RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                        side: BorderSide(
                          color: Colors.black87,
                        ))),
                    padding: WidgetStateProperty.all(EdgeInsets.symmetric(
                      vertical: widget.size.getH(16),
                    ))),
                child: Text(
                  "Send OTP",
                  style: TextStyle(
                    fontSize: widget.size.getS(20),
                    color: Colors.black,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _pageCltr?.dispose();
    _tabCltr.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: 1001,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: widget.size.getW(24)),
            child: PageView(
              physics: NeverScrollableScrollPhysics(),
              controller: _pageCltr,
              children: [
                _registerNow(),
                _loginSection(context),
                _forgotPassSec(),
              ],
            ),
          ),
        ),
        widget.size.isProt
            ? SizedBox.shrink()
            : Expanded(
                flex: 530,
                //w: 562.4421757322175 X h: 823.4644351464435 :: 0.6830193895
                child: LayoutBuilder(builder: (context, cons) {
                  // print("${cons.maxWidth / cons.maxHeight}");s
                  return ClipRRect(
                    borderRadius: BorderRadius.only(
                        topRight: Radius.circular(10),
                        bottomRight: Radius.circular(10)),
                    child: widget.authPro.bannerList != null &&
                            widget.authPro.bannerList!.isNotEmpty
                        ? CarouselSlider.builder(
                            itemCount: widget.authPro.bannerList!.length,
                            itemBuilder: (context, i, y) {
                              if (widget.authPro.bannerList?[i].image
                                      ?.isNotEmpty ??
                                  false)
                                return NetworkImageSec(
                                  image: widget.authPro.bannerList![i].image,
                                  height: double.infinity,
                                  width: double.infinity,
                                  boxFit: BoxFit.cover,
                                  errWidget: _errorImage(),
                                  placeHolder: Container(
                                    color: Colors.grey[350],
                                  ),
                                );
                              else
                                return _errorImage();
                            },
                            options: CarouselOptions(
                              height: double.infinity,
                              viewportFraction: 1,
                              autoPlay: widget.authPro.bannerList!.length > 1,
                            ),
                          )
                        : _errorImage(),
                  );
                }),
              )
      ],
    );
  }

  Widget _errorImage() {
    return Image.asset(
      "assets/png/login-image.png",
      height: double.infinity,
      fit: BoxFit.cover,
    );
  }
}
