import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pos_account/config/size_config.dart';
import 'package:pos_account/constant/constant.dart';
import 'package:pos_account/ln.dart';

class TextFormWidget extends StatelessWidget {
  final TextEditingController cltr;
  final String hintText;
  final bool obsecure;
  final String? Function(String?)? validator;
  final TextInputType textInputType;
  final bool initValidate;
  final bool isReq;
  final Widget? prefixIcon;
  final Widget? prefix;
  final Widget? suffix;
  final Widget? suffixIcon;
  final int maxLines;
  final int? minLines;
  final bool readOnly;
  final Function()? onTap;
  final bool isError;
  final Iterable<String>? autofillHints;
  final Color fillColor;
  final Function(String?)? onChanged;
  final Function(String?)? onSubmitted;
  final double borderRadius;
  final Color borderColor;
  final bool isDense;
  final double vPad;
  final double hPad;
  final TextStyle? textStyle;
  final double? errH;
  final TextAlign textAlign;
  final FocusNode? focusNode;
  final List<TextInputFormatter>? inputFormatters;
  final double suffixIconWidth;
  final int? maxLength;
  final TextStyle? hintStyle;
  final String? labelText;
  final Color focusBorderColor;

  const TextFormWidget({
    super.key,
    required this.cltr,
    required this.hintText,
    this.obsecure = false,
    this.validator,
    this.textInputType = TextInputType.text,
    this.initValidate = false,
    this.isReq = true,
    this.prefixIcon,
    this.maxLines = 1,
    this.readOnly = false,
    this.onTap,
    this.isError = false,
    this.suffixIcon,
    this.autofillHints,
    this.fillColor = Colors.white,
    this.onChanged,
    this.borderRadius = 5,
    this.borderColor = Colors.black38,
    this.isDense = true,
    this.vPad = 8,
    this.hPad = 8,
    this.minLines,
    this.textStyle,
    this.errH,
    this.textAlign = TextAlign.start,
    this.onSubmitted,
    this.prefix,
    this.suffix,
    this.focusNode,
    this.inputFormatters,
    this.suffixIconWidth = 60,
    this.maxLength,
    this.hintStyle,
    this.labelText,
    this.focusBorderColor = kSecondaryColor,
  });

  @override
  Widget build(BuildContext context) {
    final size = Ssize(context);
    return TextFormField(
      controller: cltr,
      obscureText: obsecure,
      keyboardType: textInputType,
      autovalidateMode: initValidate
          ? AutovalidateMode.onUserInteraction
          : AutovalidateMode.disabled,
      maxLines: maxLines,
      minLines: maxLines != 1 ? minLines : null,
      readOnly: readOnly,
      onTap: onTap,
      autofillHints: autofillHints,
      onChanged: onChanged,
      onFieldSubmitted: onSubmitted,
      maxLength: maxLength,
      style: textStyle ??
          TextStyle(
            color: Colors.black,
            fontSize: size.getS(16),
          ),
      textAlign: textAlign,
      focusNode: focusNode,
      inputFormatters: inputFormatters,
      decoration: InputDecoration(
        labelText: labelText,
        floatingLabelAlignment: FloatingLabelAlignment.start,
        counterText: maxLength != null ? "" : null,
        hintText: hintText,
        hintStyle: hintStyle ??
            TextStyle(
              color: Colors.black38,
              fontSize: size.getS(16),
            ),
        prefixIconConstraints: BoxConstraints(minWidth: size.getW(60)),
        suffixIconConstraints:
            BoxConstraints(minWidth: size.getW(suffixIconWidth)),
        prefixIcon: prefixIcon,
        suffixIcon: suffixIcon,
        prefix: prefix,
        suffix: suffix,
        fillColor: fillColor,
        filled: true,
        isDense: isDense,
        contentPadding: EdgeInsets.symmetric(
            horizontal: size.getW(hPad), vertical: size.getH(vPad)),
        enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
                color: isError
                    ? Colors.red
                    : focusBorderColor == kSecondaryColor
                        ? borderColor
                        : focusBorderColor),
            borderRadius: BorderRadius.circular(borderRadius)),
        focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
                color: isError ? Colors.red : focusBorderColor, width: 1.6),
            borderRadius: BorderRadius.circular(borderRadius)),
        focusedErrorBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.red.withAlpha(60), width: 1.6),
            borderRadius: BorderRadius.circular(borderRadius)),
        errorBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.red.withAlpha(60)),
            borderRadius: BorderRadius.circular(borderRadius)),
        errorStyle: TextStyle(
          fontSize: size.getS(13), // size.getS(13),
          height: errH,
          overflow: TextOverflow.visible,
        ),
        errorMaxLines: 3,
      ),
      validator: isReq
          ? (validator ??
              (val) {
                if (val!.isEmpty) {
                  if (errH != null && errH == 0)
                    return "";
                  else
                    return LN.fieldMustNotBeEmpty;
                } else
                  return null;
              })
          : (val) {
              return null;
            },
    );
  }
}
