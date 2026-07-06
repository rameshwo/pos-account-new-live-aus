import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:pos_account/config/size_config.dart';
import 'package:pos_account/constant/constant.dart';
import 'package:pos_account/ln.dart';
import 'package:pos_account/providers/auth/auth_pro.dart';
import 'package:pos_account/widgets/image/network_image_sec.dart';
import 'package:pos_account/widgets/input/dropdown/dropdown_with_text_form.dart';
import 'package:pos_account/widgets/input/dropdown/title_drop_down.dart';
import 'package:pos_account/widgets/input/text_form/title_text_form.dart';
import 'package:pos_account/widgets/load_btn.dart';

class RegisterScreen extends StatefulWidget {
  final PageController pageCltr;
  final Ssize size;
  final AuthProvider authPro;
  const RegisterScreen(
      {super.key,
      required this.pageCltr,
      required this.size,
      required this.authPro});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final int _otpLength = 6;
  // final newOtpCltr = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    widget.authPro.getCountryData();
    widget.authPro.onBackPageState = AuthPageState.Register;
  }

  @override
  Widget build(BuildContext context) {
    final size = Ssize(context);
    return Form(
      key: _formKey,
      child: Stack(
        children: [
          Center(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: size.getW(12)),
              child: SingleChildScrollView(
                physics: BouncingScrollPhysics(),
                child: Column(
                  children: [
                    SizedBox(
                      height: size.getH(32),
                    ),
                    Text(
                      LN.registerNow,
                      style: TextStyle(
                        fontSize: widget.size.getS(28),
                        fontFamily: kFontFMedium,
                        fontWeight: FontWeight.w900,
                        color: kPrimaryColor,
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(
                          vertical: widget.size.getH(12),
                          horizontal: widget.size.getW(16)),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: Color(0xffcff4fc),
                      ),
                      child: Column(
                        children: [
                          Text.rich(TextSpan(
                              text: '${LN.sendVeriTitle} ',
                              style: TextStyle(
                                fontSize: widget.size.getS(18),
                                fontFamily: kFontFRegular,
                                color: Colors.teal.shade800,
                              ),
                              children: [
                                TextSpan(
                                  text: LN.resendOtp,
                                  style: TextStyle(
                                    fontSize: widget.size.getS(18),
                                    fontFamily: kFontFRegular,
                                    color: Colors.red.shade700,
                                    decoration: TextDecoration.underline,
                                  ),
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () {
                                      widget.authPro.sendOtpToMailRegister(
                                          email: widget.authPro.emailCltr.text);
                                    },
                                )
                              ])),
                          SizedBox(
                            height: widget.size.getH(4),
                          ),
                          Text(
                            LN.otpCodeExpired5Min,
                            style: TextStyle(
                              fontSize: widget.size.getS(18),
                              fontFamily: kFontFRegular,
                              color: Colors.teal.shade800,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: widget.size.getH(16),
                    ),
                    SizedBox(
                      width: widget.size.getW(400),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text.rich(TextSpan(
                              text: "* ",
                              style: TextStyle(
                                fontSize: widget.size.getS(18),
                                fontFamily: kFontFMedium,
                                color: Colors.red.shade800,
                              ),
                              children: [
                                TextSpan(
                                  text: LN.veriCode,
                                  style: TextStyle(
                                    fontSize: widget.size.getS(18),
                                    fontFamily: kFontFMedium,
                                    color: Colors.black,
                                  ),
                                )
                              ])),
                          SizedBox(
                            height: widget.size.getH(8),
                          ),
                          PinCodeTextField(
                            appContext: context,
                            length: _otpLength,
                            pastedTextStyle: TextStyle(
                              fontSize: widget.size.getS(18),
                              color: Colors.black87,
                              // height: 1,
                            ),
                            autovalidateMode:
                                widget.authPro.initvalidateOtpOnRegister
                                    ? AutovalidateMode.onUserInteraction
                                    : AutovalidateMode.disabled,
                            animationType: AnimationType.none,
                            pinTheme: PinTheme(
                              shape: PinCodeFieldShape.box,
                              borderRadius: BorderRadius.circular(5),
                              fieldHeight: widget.size.getS(50),
                              fieldWidth: widget.size.getW(50),
                              activeFillColor: kBackgroundColor,
                              inactiveFillColor: kBackgroundColor,
                              selectedFillColor: kBackgroundColor,
                              activeColor: Colors.black26,
                              selectedColor: Colors.black26,
                              inactiveColor:
                                  widget.authPro.initvalidateOtpOnRegister
                                      ? null
                                      : Colors.black26,
                              errorBorderColor: Colors.yellow,
                              borderWidth: 1,
                            ),
                            // controller: newOtpCltr,
                            keyboardType: TextInputType.number,
                            onChanged: (String value) {
                              widget.authPro.otpCode = value;
                            },
                            enableActiveFill: true,
                            errorTextSpace: size.getH(24),
                            validator: (val) {
                              if (val == null || val.isEmpty) {
                                return LN.fieldEmpty;
                              } else if (val.length != _otpLength)
                                return LN.invalidOtp;
                              else
                                return null;
                            },
                          ),
                        ],
                      ),
                    ),
                    Wrap(
                      spacing: widget.size.getW(16),
                      runSpacing: widget.size.getH(16),
                      children: [
                        SizedBox(
                          width: size.getW(340),
                          child: TitleTextForm(
                            title: LN.fullName,
                            textCltr: widget.authPro.fullNameCltr,
                            hintText: LN.fullName,
                            borderColor: Colors.black26,
                          ),
                        ),
                        SizedBox(
                          width: size.getW(340),
                          child: SearchTitleDropDown(
                            isReq: true,
                            list: widget.authPro.countryList == null
                                ? []
                                : widget.authPro.countryList!
                                    .map((e) => e.name ?? '')
                                    .toList(),
                            indexVal: widget.authPro.countryIndex,
                            title: LN.country,
                            borderColor: Colors.black26,
                            onChanged: (int? p0) {
                              widget.authPro.countryIndex = p0;
                              widget.authPro.phoneCodeIndex = p0;
                              widget.authPro.stateIndex = null;
                              widget.authPro.cityIndex = null;
                              widget.authPro.suburbIndex = null;
                              widget.authPro.notify;
                            },
                          ),
                        ),
                        SizedBox(
                          width: size.getW(340),
                          child: SearchTitleDropDown(
                            title: LN.state,
                            isReq: true,
                            list: widget.authPro.countryList == null ||
                                    widget.authPro.countryIndex == null ||
                                    widget
                                            .authPro
                                            .countryList![
                                                widget.authPro.countryIndex!]
                                            .states ==
                                        null
                                ? []
                                : widget
                                    .authPro
                                    .countryList![widget.authPro.countryIndex!]
                                    .states!
                                    .map((e) => e.name ?? '')
                                    .toList(),
                            indexVal: widget.authPro.stateIndex,
                            onChanged: (p0) {
                              widget.authPro.stateIndex = p0;
                              widget.authPro.cityIndex = null;
                              widget.authPro.suburbIndex = null;
                              widget.authPro.notify;
                            },
                            borderColor: Colors.black26,
                          ),
                        ),
                        SizedBox(
                          width: size.getW(340),
                          child: SearchTitleDropDown(
                            title: LN.city,
                            isReq: true,
                            list: widget.authPro.countryList == null ||
                                    widget.authPro.countryIndex == null ||
                                    widget.authPro.stateIndex == null ||
                                    widget
                                            .authPro
                                            .countryList![
                                                widget.authPro.countryIndex!]
                                            .states?[widget.authPro.stateIndex!]
                                            .cities ==
                                        null
                                ? []
                                : widget
                                    .authPro
                                    .countryList![widget.authPro.countryIndex!]
                                    .states![widget.authPro.stateIndex!]
                                    .cities!
                                    .map((e) => e.name ?? '')
                                    .toList(),
                            indexVal: widget.authPro.cityIndex,
                            onChanged: (p0) {
                              widget.authPro.cityIndex = p0;
                              widget.authPro.suburbIndex = null;
                              widget.authPro.notify;
                            },
                            borderColor: Colors.black26,
                          ),
                        ),
                        SizedBox(
                          width: size.getW(340),
                          child: SearchTitleDropDown(
                            title: "Suburb",
                            isReq: true,
                            list: widget.authPro.countryList == null ||
                                    widget.authPro.countryIndex == null ||
                                    widget.authPro.stateIndex == null ||
                                    widget.authPro.cityIndex == null ||
                                    widget
                                            .authPro
                                            .countryList![
                                                widget.authPro.countryIndex!]
                                            .states?[widget.authPro.stateIndex!]
                                            .cities?[widget.authPro.cityIndex!]
                                            .suburbs ==
                                        null
                                ? []
                                : widget
                                    .authPro
                                    .countryList![widget.authPro.countryIndex!]
                                    .states![widget.authPro.stateIndex!]
                                    .cities![widget.authPro.cityIndex!]
                                    .suburbs!
                                    .map((e) => e.name ?? '')
                                    .toList(),
                            indexVal: widget.authPro.suburbIndex,
                            onChanged: (p0) {
                              widget.authPro.suburbIndex = p0;
                              widget.authPro.notify;
                            },
                            borderColor: Colors.black26,
                          ),
                        ),
                        DropDownWiTextForm(
                          title: LN.phoneNumber,
                          isReq: true,
                          pWidth: size.isProt ? 0.36 : 0.235,
                          indexVal: widget.authPro.phoneCodeIndex,
                          borderColor: Colors.black26,
                          list: widget.authPro.countryList == null
                              ? []
                              : widget.authPro.countryList!
                                  .map((e) => Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          NetworkImageSec(
                                            image: e.image,
                                            height: size.isProt
                                                ? size.getW(12)
                                                : size.getW(16),
                                            width: size.isProt
                                                ? size.getW(12)
                                                : size.getW(16),
                                          ),
                                          if (e.additionalValue is String)
                                            Flexible(
                                              child: Align(
                                                alignment:
                                                    Alignment.centerRight,
                                                child: Text(
                                                  e.additionalValue ?? '',
                                                  style: TextStyle(
                                                    fontSize: size.isProt
                                                        ? size.getW(12)
                                                        : size.getS(16),
                                                    color: Colors.black,
                                                  ),
                                                ),
                                              ),
                                            )
                                        ],
                                      ))
                                  .toList(),
                          onChanged: (p0) {
                            widget.authPro.phoneCodeIndex = p0;
                            widget.authPro.notify;
                          },
                          textCltr: widget.authPro.phoneCltr,
                        ),
                        SizedBox(
                          width: size.getW(340),
                          child: TitleTextForm(
                            title: LN.password,
                            textCltr: widget.authPro.passwordCltr,
                            hintText: LN.password,
                            borderColor: Colors.black26,
                            textInputType: TextInputType.visiblePassword,
                            obsecure: widget.authPro.getShowPass,
                            suffixIcon: InkWell(
                              onTap: () {
                                widget.authPro.setShowPass =
                                    !widget.authPro.getShowPass;
                              },
                              child: Icon(
                                widget.authPro.getShowPass
                                    ? Icons.visibility
                                    : Icons.visibility_off_outlined,
                                size: size.getS(24),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: size.getW(340),
                          child: TitleTextForm(
                            title: LN.confirmNewPassword,
                            textCltr: widget.authPro.confirmPasswordCltr,
                            hintText: LN.confirmNewPassword,
                            borderColor: Colors.black26,
                            obsecure: widget.authPro.getShowPass,
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
                                size: size.getS(24),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                    SizedBox(
                      height: size.getH(32),
                    ),
                    LoadButton(
                      width: 300,
                      hPad: 4,
                      btnText: LN.register,
                      loading: widget.authPro.registerBtnLoad,
                      onsave: widget.authPro.registerBtnLoad
                          ? null
                          : () {
                              widget.authPro.initvalidateOtpOnRegister = true;
                              widget.authPro.notify;

                              if (_formKey.currentState!.validate()) {
                                widget.authPro.registerUser().then((value) {
                                  if (value ?? false) {
                                    widget.authPro.onBackPageState =
                                        AuthPageState.Login;
                                    widget.authPro.clearRegisteredUserData();

                                    widget.pageCltr.animateToPage(0,
                                        duration: Duration(milliseconds: 300),
                                        curve: Curves.easeInOut);
                                  }
                                });
                              }
                            },
                    ),
                    SizedBox(
                      height: size.getH(24),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Row(
            children: [
              IconButton(
                  onPressed: () {
                    widget.pageCltr.animateToPage(0,
                        duration: Duration(milliseconds: 400),
                        curve: Curves.easeInOut);
                  },
                  icon: Icon(
                    Icons.arrow_back,
                    size: size.getS(25),
                  )),
              Text(
                LN.back,
                style: TextStyle(
                  fontSize: widget.size.getS(18),
                  // fontFamily: ,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}
