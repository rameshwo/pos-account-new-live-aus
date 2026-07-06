// TextForm With Title Widget
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pos_account/config/size_config.dart';
import 'package:pos_account/constant/constant.dart';

import 'text_form_widget.dart';

class TextFWTWidget extends StatelessWidget {
  final String title;
  final TextEditingController textCltr;
  final String hintText;
  final TextInputType inputType;
  final bool readOnly;
  final Function(String?)? onChanged;
  final Widget? prefix;
  final bool isReq;
  final String? Function(String?)? validator;
  final bool autoValidation;
  final List<TextInputFormatter>? inputFormatters;
  final int? maxLength;
  final Color fillColor;
  final FontWeight titleFontWeight;
  final int maxLines;
  final int? minLines;
  final Widget? suffixIcon;
  final FocusNode? focusNode;
  final Function()? onTap;
  final Color titleColor;

  const TextFWTWidget({
    super.key,
    required this.title,
    required this.textCltr,
    this.hintText = "",
    this.inputType = TextInputType.text,
    this.readOnly = false,
    this.onChanged,
    this.prefix,
    this.isReq = true,
    this.validator,
    this.autoValidation = false,
    this.inputFormatters,
    this.maxLength,
    this.fillColor = Colors.white,
    this.titleFontWeight = FontWeight.bold,
    this.maxLines = 1,
    this.minLines,
    this.suffixIcon,
    this.focusNode,
    this.onTap,
    this.titleColor = Colors.black,
  });

  @override
  Widget build(BuildContext context) {
    final size = Ssize(context);
    return Padding(
      padding: EdgeInsets.symmetric(vertical: size.getH(8.0)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: size.getS(18),
              color: titleColor,
              fontFamily: kFontFMedium,
              // fontWeight: titleFontWeight,
            ),
          ),
          SizedBox(
            height: size.getH(6),
          ),
          TextFormWidget(
            focusNode: focusNode,
            prefix: prefix,
            borderRadius: 5,
            hPad: 12,
            cltr: textCltr,
            textInputType: inputType,
            hintText: hintText,
            readOnly: readOnly,
            onChanged: onChanged,
            isReq: isReq,
            validator: validator,
            initValidate: autoValidation,
            inputFormatters: inputFormatters,
            maxLength: maxLength,
            fillColor: fillColor,
            maxLines: maxLines,
            minLines: minLines,
            suffixIcon: suffixIcon,
            borderColor: Colors.black38,
            onTap: onTap,
            suffixIconWidth: suffixIcon == null ? 60 : size.getW(48),
          ),
        ],
      ),
    );
  }
}
