import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pos_account/config/size_config.dart';
import 'drop_down.dart';
import '../text_form/text_form_widget.dart';

class DropDownWiTextForm extends StatelessWidget {
  final List<dynamic> list;
  final double pWidth;
  final bool isReq;
  final String title;
  final Function(int?)? onChanged;
  final TextEditingController textCltr;
  final int? indexVal;
  final Color borderColor;
  final double vPad;
  final double borderRadius;
  final double fontSize;
  final bool? isBold;
  final double ratio;

  const DropDownWiTextForm({
    super.key,
    required this.list,
    this.pWidth = 0.24,
    this.isReq = false,
    required this.title,
    this.onChanged,
    required this.textCltr,
    this.indexVal,
    this.borderColor = Colors.black38,
    this.vPad = 8,
    this.borderRadius = 5,
    this.fontSize = 18,
    this.isBold,
    this.ratio = 0.3125,
  });

  @override
  Widget build(BuildContext context) {
    final size = Ssize(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text.rich(
          TextSpan(
              text: title,
              style: TextStyle(
                fontSize: size.getS(fontSize),
                color: Colors.black,
                fontWeight:
                    isBold == true ? FontWeight.bold : FontWeight.normal,
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
                  : null),
        ),
        SizedBox(
          height: size.getH(2),
        ),
        SizedBox(
          width: size.width * pWidth,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                  width: size.width * pWidth * ratio,
                  child: DropDownList(
                    list: list,
                    borderRadius: borderRadius,
                    borderColor: borderColor,
                    hPad: 0,
                    vPad: vPad,
                    isReq: isReq,
                    errH: 0,
                    indexValue: indexVal,
                    onChange: onChanged,
                  )),
              SizedBox(
                width: size.getW(8),
              ),
              Expanded(
                  child: TextFormWidget(
                cltr: textCltr,
                hintText: "",
                isReq: isReq,
                borderColor: borderColor,
                borderRadius: borderRadius,
                textInputType: TextInputType.number,
                vPad: vPad,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              ))
            ],
          ),
        )
      ],
    );
  }
}
