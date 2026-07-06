import 'package:flutter/material.dart';
import 'package:pos_account/config/size_config.dart';
import 'package:pos_account/constant/constant.dart';
import 'package:pos_account/ln.dart';
import 'package:pos_account/widgets/input/text_form/text_form_widget.dart';

class TextFieldDia extends StatelessWidget {
  final Ssize size;
  final String title;
  final TextEditingController textCltr;
  final Function()? onOk;
  const TextFieldDia({
    super.key,
    required this.size,
    required this.title,
    required this.textCltr,
    this.onOk,
  });

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(size.getS(10))),
      contentPadding: EdgeInsets.fromLTRB(
          size.getW(24.0), size.getH(12.0), size.getW(24.0), size.getH(16.0)),
      titlePadding: EdgeInsets.fromLTRB(
          size.getW(24.0), size.getH(24.0), size.getW(24.0), size.getH(12.0)),
      title: Center(
          child: Text(title,
              style: TextStyle(
                fontSize: size.getS(18),
                fontFamily: kFontFMedium,
              ))),
      children: [
        TextFormWidget(
          cltr: textCltr,
          hintText: '0',
          borderColor: Colors.black54,
          borderRadius: 5,
          textInputType: TextInputType.number,
        ),
        SizedBox(height: size.getH(12)),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text(LN.cancel,
                    style: TextStyle(
                        color: Colors.black54, fontSize: size.getS(16)))),
            TextButton(
                onPressed: () {
                  if (onOk != null) onOk!();
                  Navigator.of(context).pop(true);
                },
                child: Text(LN.confirm,
                    style: TextStyle(
                        color: kSecondaryColor, fontSize: size.getS(16)))),
          ],
        ),
      ],
    );
  }
}
