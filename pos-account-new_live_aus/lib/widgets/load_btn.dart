import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:pos_account/config/size_config.dart';
import 'package:pos_account/constant/constant.dart';
import 'package:pos_account/ln.dart';

class LoadButton extends StatelessWidget {
  final Function()? onsave;
  final bool loading;
  final String? btnText;
  final double width;
  final double vPad;
  final double hPad;
  final Color btnColor;
  final Color textColor;
  final String? loadingText;
  final double fontSize;
  final RoundedRectangleBorder? shape;
  final Widget? icon;
  final Widget? suffix;

  const LoadButton({
    super.key,
    this.onsave,
    this.loading = false,
    this.btnText,
    this.width = 160,
    this.vPad = 12,
    this.hPad = 24,
    this.btnColor = kSecondaryColor,
    this.textColor = Colors.white,
    this.loadingText,
    this.fontSize = 16,
    this.icon,
    this.shape,
    this.suffix,
  });

  @override
  Widget build(BuildContext context) {
    final size = Ssize(context);
    return SizedBox(
      width: size.getW(width),
      child: ElevatedButton(
        style:
            // ElevatedButton.styleFrom(
            //       backgroundColor: btnColor,
            //       shape: shape ??
            //           RoundedRectangleBorder(
            //             borderRadius: BorderRadius.circular(borderRadius),
            //           ),
            //       padding: EdgeInsets.symmetric(
            //         horizontal: size.getW(hPad),
            //         vertical: size.getH(vPad),
            //       ),
            //     ),

            ButtonStyle(
                backgroundColor: WidgetStateProperty.all(btnColor),
                shadowColor: btnColor == Colors.transparent
                    ? WidgetStateProperty.all(Colors.transparent)
                    : null,
                shape: shape == null ? null : WidgetStateProperty.all(shape),
                padding: WidgetStateProperty.all(EdgeInsets.symmetric(
                  horizontal: size.getW(hPad),
                  vertical: size.getH(vPad),
                ))),
        onPressed: loading ? null : onsave
        //// To hideKeyboard
        //  == null
        //     ? null
        //     : () {
        //         if (MediaQuery.of(context).viewInsets.bottom != 0)
        //           FocusManager.instance.primaryFocus?.unfocus();
        //         onsave!();
        //       }
        ,
        child: loading
            ? Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    loadingText ?? LN.loading,
                    style: TextStyle(
                      fontSize: size.getS(16),
                      color: textColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(
                    width: size.getW(12),
                  ),
                  LoadingAnimationWidget.waveDots(
                    color: textColor,
                    size: size.getS(24),
                  ),
                ],
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (icon != null) icon!,
                  if (suffix == null)
                    Flexible(child: saveText(size))
                  else ...[
                    Expanded(child: saveText(size)),
                    suffix!,
                  ]
                ],
              ),
      ),
    );
  }

  Widget saveText(Ssize size) {
    return Text(
      btnText ?? LN.save,
      style: TextStyle(
        fontSize: size.getS(fontSize),
        color: textColor,
        fontWeight: FontWeight.bold,
      ),
      textAlign: TextAlign.center,
      maxLines: 1,
      overflow: TextOverflow.visible,
    );
  }
}
