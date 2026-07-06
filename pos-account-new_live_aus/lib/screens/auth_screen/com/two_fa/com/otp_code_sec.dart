import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:pos_account/config/size_config.dart';
import 'package:pos_account/constant/constant.dart';
import 'package:pos_account/ln.dart';
import 'package:pos_account/widgets/load_btn.dart';

class OtpCodeSec extends StatefulWidget {
  final Function(String)? onTap;
  final String? otpMessage;
  final Function()? onCancel;
  final bool isExpire;
  final bool loading;
  final int otpLength;
  final double width;
  final Size? fsize;
  final void Function(String)? onChanged;
  const OtpCodeSec({
    super.key,
    this.onTap,
    this.otpMessage,
    this.onCancel,
    this.isExpire = false,
    this.loading = false,
    this.otpLength = 6,
    this.width = 400,
    this.fsize,
    this.onChanged,
  });

  @override
  State<OtpCodeSec> createState() => _OtpCodeSecState();
}

class _OtpCodeSecState extends State<OtpCodeSec> {
  final _formKey = GlobalKey<FormState>();

  final _otpCltr = TextEditingController();

  bool initValidate = false;

  final focusNode = FocusNode();

  load() {
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    focusNode.requestFocus();
  }

  @override
  void dispose() {
    focusNode.unfocus();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = Ssize(context);

    return Form(
      key: _formKey,
      child: Padding(
        padding: EdgeInsets.symmetric(
            horizontal: size.getW(12.0), vertical: size.getH(16)),
        child: Column(
          children: [
            SizedBox(
              width: size.getW(widget.width),
              child: PinCodeTextField(
                focusNode: focusNode,
                appContext: context,
                length: widget.otpLength,
                pastedTextStyle: TextStyle(
                  fontSize: size.getS(18),
                  color: Colors.black87,
                  // height: 1,
                ),
                autovalidateMode: initValidate
                    ? AutovalidateMode.onUserInteraction
                    : AutovalidateMode.disabled,
                animationType: AnimationType.none,
                pinTheme: PinTheme(
                  shape: PinCodeFieldShape.box,
                  borderRadius: BorderRadius.circular(5),
                  fieldHeight: size.getS(widget.fsize?.height ?? 50),
                  fieldWidth: size.getW(widget.fsize?.width ?? 40),
                  activeFillColor:
                      widget.isExpire ? Colors.white : kBackgroundColor,
                  inactiveFillColor:
                      widget.isExpire ? Colors.white : kBackgroundColor,
                  selectedFillColor:
                      widget.isExpire ? Colors.white : kBackgroundColor,
                  activeColor:
                      widget.isExpire ? Colors.black38 : Colors.transparent,
                  selectedColor:
                      widget.isExpire ? Colors.black38 : Colors.transparent,
                  inactiveColor:
                      widget.isExpire ? Colors.black38 : Colors.transparent,
                  errorBorderColor: Colors.yellow,
                  borderWidth: 1,
                ),
                controller: _otpCltr,
                keyboardType: TextInputType.number,
                errorTextSpace: size.getH(24),
                onChanged: widget.onChanged ?? (_) {},
                enableActiveFill: true,
                validator: (val) {
                  if (val == null || val.isEmpty) {
                    return LN.fieldEmpty;
                  } else if (val.length != widget.otpLength)
                    return LN.invalidOtp;
                  else
                    return null;
                },
              ),
            ),
            if (widget.otpMessage != null) ...[
              SizedBox(
                height: size.getH(8),
              ),
              Text(
                widget.otpMessage!,
                style: TextStyle(
                  fontSize: size.getS(16),
                  fontFamily: kFontFRegular,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              SizedBox(
                height: size.getH(12),
              )
            ],
            if (widget.onTap != null) ...[
              SizedBox(
                height: size.getH(8),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  LoadButton(
                    btnText: LN.submit,
                    btnColor: kSecondaryColor,
                    vPad: 12,
                    loading: widget.loading,
                    onsave: widget.loading
                        ? null
                        : () {
                            initValidate = true;
                            load();

                            if (_formKey.currentState!.validate()) {
                              if (widget.onTap != null)
                                widget.onTap!(_otpCltr.text);
                            }
                          },
                  ),
                  if (widget.onCancel != null) ...[
                    SizedBox(
                      width: size.getW(12),
                    ),
                    LoadButton(
                      btnText: LN.cancel,
                      btnColor: kTempColor,
                      vPad: 12,
                      onsave: widget.onCancel,
                      width: 120,
                    )
                  ],
                ],
              )
            ]
          ],
        ),
      ),
    );
  }
}
