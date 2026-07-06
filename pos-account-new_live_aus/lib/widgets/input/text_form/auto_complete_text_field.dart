import 'package:flutter/material.dart';
import 'package:pos_account/config/size_config.dart';
import 'package:pos_account/constant/constant.dart';
import 'package:pos_account/ln.dart';
import 'package:pos_account/services/easy_auto_complete/auto_complete_text_f.dart';

class AutoCompleteText extends StatelessWidget {
  final String? title;
  final bool isReq;
  final double pWidth;
  final TextEditingController textCltr;
  final Function(String)? onChanged;
  final Function(String)? onSubmit;
  final List<String>? suggestion;
  final String hintText;
  final Color borderColor;
  final double vPad;
  final bool isDense;
  final double borderRadius;
  final bool hasError;
  final Future<List<String>> Function(String)? asyncSuggestions;
  final Duration debounceDuration;
  final Widget? suffixIcon;

  const AutoCompleteText({
    super.key,
    this.title,
    required this.textCltr,
    this.onChanged,
    this.suggestion,
    this.hintText = "",
    this.onSubmit,
    this.isReq = true,
    this.pWidth = 0.24,
    this.borderColor = Colors.black38,
    this.vPad = 8,
    this.isDense = true,
    this.borderRadius = 5,
    this.hasError = false,
    this.asyncSuggestions,
    this.debounceDuration = const Duration(milliseconds: 300),
    this.suffixIcon,
  });

  @override
  Widget build(BuildContext context) {
    final size = Ssize(context);
    final errorColor = Colors.red.shade800;
    return SizedBox(
      width: size.width * pWidth,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (title != null)
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Text.rich(TextSpan(
                  text: title,
                  style: TextStyle(
                    fontSize: size.getS(18),
                    color: Colors.black,
                  ),
                  children: isReq
                      ? [
                          TextSpan(
                            text: " *",
                            style: TextStyle(
                              fontSize: size.getS(18),
                              color: Colors.red,
                            ),
                          )
                        ]
                      : null)),
            ),
          EasyAutocomplete(
            controller: textCltr,
            suggestionBackgroundColor: Colors.white,
            decoration: InputDecoration(
              isDense: isDense,
              hintText: hintText,
              suffixIcon: suffixIcon,
              suffixIconConstraints: BoxConstraints(minWidth: 40),
              contentPadding: EdgeInsets.symmetric(
                  horizontal: size.getW(16), vertical: size.getH(vPad)),
              enabledBorder: OutlineInputBorder(
                  borderSide:
                      BorderSide(color: hasError ? errorColor : borderColor),
                  borderRadius: BorderRadius.circular(borderRadius)),
              focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                      color: hasError ? errorColor : borderColor, width: 1.6),
                  borderRadius: BorderRadius.circular(borderRadius)),
            ),
            onChanged: onChanged,
            onSubmitted: onSubmit,
            suggestions: suggestion,
            asyncSuggestions: asyncSuggestions,
            debounceDuration: debounceDuration,
            suggestionTextStyle: TextStyle(
              fontSize: size.getS(16),
            ),
            inputTextStyle: TextStyle(
              fontSize: size.getS(16),
              fontFamily: kFontFRegular,
            ),
          ),
          if (hasError)
            Padding(
              padding: EdgeInsets.symmetric(
                  vertical: size.getH(4), horizontal: size.getW(4)),
              child: Text(
                LN.fieldMustNotBeEmpty,
                style: TextStyle(
                    color: Colors.red.shade700, fontSize: size.getS(13)),
                maxLines: 2,
              ),
            )
        ],
      ),
    );
  }
}
