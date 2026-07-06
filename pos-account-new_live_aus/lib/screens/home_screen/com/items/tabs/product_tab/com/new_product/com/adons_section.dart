import 'package:flutter/material.dart';
import 'package:pos_account/config/size_config.dart';
import 'package:pos_account/constant/constant.dart';
import 'package:pos_account/services/easy_auto_complete/auto_complete_text_f.dart';

class AdonsSection extends StatelessWidget {
  final TextEditingController textCltr;
  final Function(String)? onSubmit;
  final Function(int)? onRemove;
  final List<String> itemList;
  final Function(String)? onChanged;
  final List<String>? suggestion;
  final FocusNode focusNode;
  final String title;
  final double textWidth;

  const AdonsSection(
      {super.key,
      required this.textCltr,
      this.onSubmit,
      this.onRemove,
      this.itemList = const <String>[],
      this.onChanged,
      this.suggestion,
      required this.focusNode,
      required this.title,
      this.textWidth = 140});

  @override
  Widget build(BuildContext context) {
    final size = Ssize(context);
    return Container(
      decoration: BoxDecoration(
          color: kBackgroundColor, borderRadius: BorderRadius.circular(10)),
      padding: EdgeInsets.symmetric(
          vertical: size.getH(8), horizontal: size.getW(16)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: size.getS(20),
              fontFamily: kFontFMedium,
              color: Colors.black,
            ),
          ),
          SizedBox(
            height: size.getH(8),
          ),
          InkWell(
            onTap: () => focusNode.requestFocus(),
            child: Container(
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(5),
                  border: Border.all(
                    color: Colors.grey.shade600,
                  )),
              constraints: BoxConstraints(minHeight: size.getH(72)),
              alignment: Alignment.topLeft,
              padding: EdgeInsets.symmetric(
                  vertical: size.getW(8), horizontal: size.getW(8)),
              child: Wrap(
                spacing: size.getW(10),
                runSpacing: size.getH(8),
                children: [
                  ...List.generate(
                      itemList.length,
                      (index) => Container(
                            padding: EdgeInsets.symmetric(
                                vertical: size.getH(4),
                                horizontal: size.getW(4)),
                            decoration: BoxDecoration(
                                color: kTempColor,
                                borderRadius: BorderRadius.circular(5)),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  itemList[index],
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontFamily: kFontFMedium,
                                    fontSize: size.getS(16),
                                  ),
                                ),
                                InkWell(
                                    onTap: onRemove == null
                                        ? null
                                        : () => onRemove!(index),
                                    child: Padding(
                                      padding: const EdgeInsets.only(left: 4.0),
                                      child: Icon(
                                        Icons.close,
                                        color: Colors.white,
                                        size: size.getS(16),
                                      ),
                                    ))
                              ],
                            ),
                          )),
                  SizedBox(
                    width: size.getW(textWidth),
                    child: EasyAutocomplete(
                      controller: textCltr,
                      inputTextStyle: TextStyle(
                        color: Colors.black,
                        height: size.getH(1.75),
                        fontSize: size.getS(16),
                      ),
                      focusNode: focusNode,
                      decoration: InputDecoration(
                        hintText: "",
                        isCollapsed: true,
                        focusedBorder: InputBorder.none,
                        enabledBorder: InputBorder.none,
                      ),
                      onChanged: onChanged,
                      onSubmitted: onSubmit,
                      suggestions: suggestion,
                      suggestionTextStyle: TextStyle(
                        fontSize: size.getS(16),
                      ),
                      maxSuggestionHeight: 240,
                      maxSuggestionWidth: 400,
                    ),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
