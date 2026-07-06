import 'package:flutter/material.dart';
import 'package:pos_account/config/size_config.dart';
import 'package:pos_account/constant/constant.dart';
import 'text_form_widget.dart';

class MultiTextWidget extends StatelessWidget {
  final Ssize size;
  final FocusNode focusNode;
  final String? title;
  final List<String> textList;
  final Function(String?)? onAdd;
  final Function(int)? onRemove;
  final TextEditingController textCltr;
  final bool isReq;
  final Color borderColor;
  final Function(String?)? onSubmit;

  const MultiTextWidget({
    super.key,
    required this.size,
    required this.focusNode,
    this.title,
    this.textList = const [],
    this.onAdd,
    this.onRemove,
    required this.textCltr,
    this.isReq = false,
    this.borderColor = Colors.black45,
    this.onSubmit,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (title != null)
          Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Text.rich(
              TextSpan(
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
                      : null),
            ),
          ),
        InkWell(
          onTap: () => focusNode.requestFocus(),
          child: Container(
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(5),
                border: Border.all(
                  color: borderColor,
                )),
            constraints: BoxConstraints(minHeight: size.getH(48)),
            alignment: Alignment.topLeft,
            child: Wrap(
              children: [
                ...List.generate(
                    textList.length,
                    (index) => Container(
                          margin: EdgeInsets.symmetric(
                              vertical: size.getW(6), horizontal: size.getW(4)),
                          padding: EdgeInsets.symmetric(
                              vertical: size.getH(4),
                              horizontal: size.getW(12)),
                          decoration: BoxDecoration(
                              color: Colors.grey.withAlpha(200),
                              borderRadius: BorderRadius.circular(19)),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                textList[index],
                                style: TextStyle(
                                  color: Colors.black,
                                  fontFamily: kFontFMedium,
                                  fontSize: size.getS(15),
                                ),
                              ),
                              SizedBox(
                                width: size.getW(4),
                              ),
                              InkWell(
                                  onTap: onRemove == null
                                      ? null
                                      : () => onRemove!(index),
                                  child: Icon(Icons.close))
                            ],
                          ),
                        )),
                SizedBox(
                  width: size.getW(textCltr.text.length < 5
                      ? 100
                      : (100 + textCltr.text.length * 10)),
                  child: TextFormWidget(
                    cltr: textCltr,
                    borderRadius: 5,
                    borderColor: Colors.white,
                    errH: 0,
                    vPad: 11,
                    isDense: true,
                    hintText: "",
                    focusNode: focusNode,
                    onChanged:
                        onAdd, // need to set states everytime to increase length of text field
                    isReq: false,
                    onSubmitted: onSubmit,
                    textInputType: TextInputType.emailAddress,
                    focusBorderColor: Colors.transparent,
                  ),
                )
              ],
            ),
          ),
        ),
      ],
    );
  }
}
