import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:pos_account/config/size_config.dart';
import 'package:pos_account/widgets/dialog/cus_poup_menu.dart';
import 'package:pos_account/widgets/input/text_form/text_form_widget.dart';

class ColorPickerSection extends StatelessWidget {
  final Function(Color) onColorChanged;
  final TextEditingController textCltr;
  final Color selectedColor;
  final double colorSize;
  const ColorPickerSection({
    super.key,
    required this.onColorChanged,
    required this.textCltr,
    required this.selectedColor,
    this.colorSize = 40,
  });

  @override
  Widget build(BuildContext context) {
    final size = Ssize(context);
    return SizedBox(
      width: size.getW(260),
      child: TextFormWidget(
        cltr: textCltr,
        isReq: false,
        borderColor: Colors.black38,
        hintText: '',
        suffixIcon: CusPopupMenuButton(
          offset: Offset(-size.getW(120), -size.getH(360)),
          itemBuilder: (BuildContext context) {
            return [
              CusPopupMenuItem(
                child: ColorPicker(
                  pickerColor: selectedColor,
                  portraitOnly: true,
                  onColorChanged: onColorChanged,
                  colorPickerWidth: 400,
                  pickerAreaHeightPercent: 0.8,
                  labelTypes: [],
                ),
              ),
            ];
          },
          child: Container(
            width: size.getS(colorSize),
            height: size.getS(colorSize),
            margin: EdgeInsets.all(size.getS(8)),
            decoration: BoxDecoration(
              color: selectedColor,
              borderRadius: BorderRadius.circular(5),
              border: Border.all(color: Colors.black38),
            ),
          ),
        ),
        suffixIconWidth: size.getS(colorSize),
      ),
    );
  }
}
