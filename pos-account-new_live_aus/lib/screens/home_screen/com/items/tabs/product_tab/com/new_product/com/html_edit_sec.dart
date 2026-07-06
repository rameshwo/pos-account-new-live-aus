import 'package:flutter/material.dart';
import 'package:html_editor_enhanced/html_editor.dart';

class HtmlEditSec extends StatelessWidget {
  final HtmlEditorController controller;
  final double height;
  final Function(String?)? onChangeContent;
  final Function()? onInit;
  const HtmlEditSec({
    super.key,
    required this.controller,
    this.height = 300,
    this.onChangeContent,
    this.onInit,
  });

  @override
  Widget build(BuildContext context) {
    return HtmlEditor(
      controller: controller,
      callbacks: Callbacks(
        onChangeContent: onChangeContent,
        onInit: onInit,
      ),
      htmlEditorOptions: HtmlEditorOptions(
        // hint: "",
        // initialText: initText,
        autoAdjustHeight: false,
        adjustHeightForKeyboard: false,
        shouldEnsureVisible: false,
      ),
      htmlToolbarOptions: HtmlToolbarOptions(
        defaultToolbarButtons: [
          StyleButtons(),
          FontSettingButtons(fontName: false, fontSizeUnit: false),
          FontButtons(clearAll: false, superscript: false, subscript: false),
          ColorButtons(
            foregroundColor: false,
            highlightColor: false,
          ),
          ListButtons(listStyles: false),
          ParagraphButtons(
              increaseIndent: false,
              decreaseIndent: false,
              textDirection: false,
              lineHeight: false,
              caseConverter: false),
          InsertButtons(
              link: true,
              picture: true,
              video: false,
              audio: false,
              table: true,
              hr: false,
              otherFile: false),
        ],
      ),
      otherOptions: OtherOptions(
        height: height,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(5)),
            border: Border.fromBorderSide(
                BorderSide(color: Colors.black54, width: 1))),
      ),
    );
  }
}
