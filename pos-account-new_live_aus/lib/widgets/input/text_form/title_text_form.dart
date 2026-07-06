import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pos_account/config/size_config.dart';
import 'text_form_widget.dart';

class TitleTextForm extends StatelessWidget {
  final String? title;
  final TextEditingController textCltr;
  final Function(String?)? onChanged;
  final String? Function(String?)? validator;
  final bool isReq;
  final bool readOnly;
  final double pWidth;
  final TextInputType textInputType;
  final Color borderColor;
  final double borderRadius;
  final double vPad;
  final double hPad;
  final Widget? suffix;
  final double? errH;
  final String hintText;
  final Function()? onTap;
  final Widget? suffixIcon;
  final bool obsecure;
  final Color fillColor;
  final bool isDense;
  final double suffixIconWidth;
  final FocusNode? focusNode;
  final int maxLines;
  final int? minLines;
  final List<TextInputFormatter>? inputFormatters;
  final Widget? prefixText;
  final Iterable<String>? autofillHints;
  final double fontSize;
  final bool isBold;
  final Widget? prefix;
  final String? subTitle;
  final Widget? preTitleIcon;
  final TextStyle? textStyle;
  final TextStyle? hintStyle;

  const TitleTextForm({
    super.key,
    this.title,
    required this.textCltr,
    this.onChanged,
    this.validator,
    this.isReq = true,
    this.readOnly = false,
    this.pWidth = 0.33,
    this.textInputType = TextInputType.text,
    this.borderColor = Colors.black38,
    this.vPad = 8,
    this.hPad = 16,
    this.suffix,
    this.isBold = false,
    this.errH,
    this.hintText = "",
    this.onTap,
    this.suffixIcon,
    this.obsecure = false,
    this.fillColor = Colors.white,
    this.borderRadius = 5,
    this.isDense = true,
    this.suffixIconWidth = 60,
    this.focusNode,
    this.maxLines = 1,
    this.minLines,
    this.inputFormatters,
    this.prefixText,
    this.autofillHints,
    this.fontSize = 18,
    this.prefix,
    this.subTitle,
    this.preTitleIcon,
    this.hintStyle,
    this.textStyle,
  });

  @override
  Widget build(BuildContext context) {
    final size = Ssize(context);
    return SizedBox(
      width: size.width * pWidth,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (title != null) ...[
            Row(
              children: [
                if (preTitleIcon != null) preTitleIcon!,
                Expanded(
                  child: Row(
                    children: [
                      Flexible(
                        child: Text.rich(
                          TextSpan(
                              text: title,
                              style: TextStyle(
                                fontSize: size.getS(fontSize),
                                color: Colors.black,
                                fontWeight: isBold
                                    ? FontWeight.bold
                                    : FontWeight.normal,
                              ),
                              children: isReq
                                  ? [
                                      TextSpan(
                                        text: " *",
                                        style: TextStyle(
                                          fontSize: size.getS(fontSize),
                                          color: Colors.red,
                                        ),
                                      )
                                    ]
                                  : null),
                        ),
                      ),
                      if (prefix != null) prefix!,
                    ],
                  ),
                ),
                // Spacer(),

                if (suffix != null) suffix!
              ],
            ),
            SizedBox(
              height: size.getH(4),
            )
          ],
          TextFormWidget(
            cltr: textCltr,
            hintText: hintText,
            borderColor: borderColor,
            borderRadius: borderRadius,
            vPad: vPad,
            hPad: hPad,
            onChanged: onChanged,
            validator: validator,
            isReq: isReq,
            readOnly: readOnly,
            textInputType: textInputType,
            errH: errH,
            onTap: onTap,
            suffixIcon: suffixIcon,
            obsecure: obsecure,
            fillColor: fillColor,
            isDense: isDense,
            suffixIconWidth: suffixIconWidth,
            focusNode: focusNode,
            maxLines: maxLines,
            minLines: minLines,
            inputFormatters: inputFormatters,
            prefix: prefixText,
            autofillHints: autofillHints,
            textStyle: textStyle,
            hintStyle: hintStyle,
          ),
          if (subTitle != null)
            Padding(
              padding: EdgeInsets.only(top: size.getH(8)),
              child: Text(
                subTitle!,
                style: TextStyle(
                  fontSize: size.getS(16),
                  color: errH == 0 ? Colors.red.shade700 : Colors.black,
                ),
              ),
            )
        ],
      ),
    );
  }
}
