import 'package:flutter/material.dart';
import 'package:pos_account/config/size_config.dart';
import 'package:pos_account/constant/constant.dart';
import 'package:pos_account/ln.dart';

class ConfirmDialog extends StatelessWidget {
  final String? title;
  final String? subTitle;
  final Future<bool?> Function()? onDelete;
  final void Function()? onCancel;
  final String actionText;
  final String cancelText;
  final double titleSize;
  final Widget? bottomRightWidget;
  const ConfirmDialog({
    super.key,
    required this.title,
    this.subTitle,
    this.onDelete,
    this.actionText = "Delete",
    this.cancelText = "Cancel",
    this.titleSize = 22,
    this.onCancel,
    this.bottomRightWidget,
  });

  @override
  Widget build(BuildContext context) {
    final size = Ssize(context);
    return SimpleDialog(
      titlePadding: EdgeInsets.zero,
      contentPadding: EdgeInsets.symmetric(
          horizontal: size.getW(24), vertical: size.getH(24)),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      children: [
        Container(
          constraints: BoxConstraints(
            maxHeight: size.height / 5,
            minHeight: size.height / 7,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title ?? "${LN.delete} $title",
                style: TextStyle(
                  fontSize: size.getS(titleSize),
                  fontFamily: kFontFMedium,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              SizedBox(
                height: size.getH(6),
              ),
              Text(
                subTitle ?? "${LN.wantToDelete} $title?",
                style: TextStyle(
                  fontSize: size.getS(16),
                  fontFamily: kFontFMedium,
                  color: Colors.black,
                ),
              ),
              SizedBox(
                height: size.getH(16),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                      style: ButtonStyle(
                          shape: WidgetStateProperty.all(RoundedRectangleBorder(
                              side: BorderSide(),
                              borderRadius: BorderRadius.circular(5))),
                          padding: WidgetStateProperty.all(EdgeInsets.symmetric(
                              horizontal: size.getW(12),
                              vertical: size.getH(8)))),
                      onPressed: onCancel ??
                          () => context.mounted ? Navigator.pop(context) : null,
                      child: Text(
                        cancelText,
                        style: TextStyle(
                          fontSize: size.getS(15),
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      )),
                  SizedBox(
                    width: size.getS(12),
                  ),
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red.shade700,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5)),
                          textStyle: TextStyle(
                            fontSize: size.getS(15),
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                          padding: EdgeInsets.symmetric(
                              horizontal: size.getW(12),
                              vertical: size.getH(8))),
                      onPressed: onDelete == null
                          ? null
                          : () {
                              final stat = onDelete!();
                              if (context.mounted) Navigator.pop(context, stat);
                            },
                      child: Text(
                        actionText,
                        style: TextStyle(
                          fontSize: size.getS(15),
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      )),
                  if (bottomRightWidget != null) ...[
                    SizedBox(
                      width: size.getS(12),
                    ),
                    bottomRightWidget!,
                  ],
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
