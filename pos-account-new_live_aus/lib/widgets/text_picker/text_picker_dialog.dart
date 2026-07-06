import 'package:flutter/material.dart';
import 'package:pos_account/config/size_config.dart';
import 'package:pos_account/constant/constant.dart';
import 'package:pos_account/ln.dart';
import 'text_picker.dart';

class TextPickerDialog extends StatelessWidget {
  const TextPickerDialog(
      {super.key,
      this.title,
      required this.onChanged,
      required this.list,
      required this.selectedIndexCltr,
      this.onCancel,
      this.onSet});

  final String? title;
  final ValueChanged<int> onChanged;
  final List<String> list;
  final TextEditingController selectedIndexCltr;
  final Function()? onCancel;
  final Function()? onSet;

  @override
  Widget build(BuildContext context) {
    final size = Ssize(context);
    return SimpleDialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(size.getS(10))),
      contentPadding: EdgeInsets.fromLTRB(
          size.getW(12.0), size.getH(12.0), size.getW(12.0), size.getH(16.0)),
      titlePadding: EdgeInsets.fromLTRB(
          size.getW(24.0), size.getH(24.0), size.getW(24.0), size.getH(12.0)),
      title: title != null
          ? Center(
              child: Text(title ?? '',
                  style: TextStyle(
                    fontSize: size.getS(18),
                    fontFamily: kFontFMedium,
                  )))
          : null,
      children: [
        Stack(
          alignment: Alignment.center,
          children: [
            Container(
              margin: EdgeInsets.symmetric(horizontal: size.getW(48)),
              height: size.getH(40),
              decoration: BoxDecoration(
                  color: Colors.transparent,
                  border: Border.symmetric(
                      vertical: BorderSide.none, horizontal: BorderSide())),
            ),
            StatefulBuilder(builder: (context, setS) {
              return TextPicker(
                  selectedTextStyle: TextStyle(
                    color: kTempColor,
                    fontSize: size.getS(18),
                    fontFamily: kFontFMedium,
                  ),
                  onChanged: (int index) {
                    onChanged(index);
                    setS(() {});
                  },
                  list: list,
                  selectedInt: selectedIndexCltr.text.isNotEmpty
                      ? int.parse(selectedIndexCltr.text)
                      : 10);
            }),
          ],
        ),
        SizedBox(height: size.getH(12)),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            TextButton(
                onPressed: () {
                  if (onCancel != null) onCancel!();
                  Navigator.of(context).pop(false);
                },
                child: Text(LN.cancel,
                    style: TextStyle(
                        color: Colors.black54, fontSize: size.getS(16)))),
            TextButton(
                onPressed: () {
                  if (onSet != null) onSet!();
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
