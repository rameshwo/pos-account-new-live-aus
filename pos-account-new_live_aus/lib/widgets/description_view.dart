import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:html_editor_enhanced/html_editor.dart';
import '../config/size_config.dart';
import '../constant/constant.dart';
import '../ln.dart';
import '../screens/home_screen/com/items/tabs/product_tab/com/new_product/com/html_edit_sec.dart';
import 'load_btn.dart';

class DescriptionHtmlView extends StatefulWidget {
  final HtmlEditorController htmlController;
  final Function(String) onSave;
  final double? height;
  final String descriptionText;
  final Ssize size;
  const DescriptionHtmlView({
    super.key,
    required this.size,
    required this.onSave,
    this.height = 100,
    required this.htmlController,
    required this.descriptionText,
  });

  @override
  State<DescriptionHtmlView> createState() => _DescriptionHtmlViewState();
}

class _DescriptionHtmlViewState extends State<DescriptionHtmlView> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        showDialog(
            context: context,
            builder: (context) => DescDialog(
                onSave: (val) {
                  widget.onSave(val);
                },
                size: widget.size,
                htmlController: widget.htmlController,
                descriptionText: widget.descriptionText));
      },
      child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(5),
          ),
          height: widget.height,
          width: double.maxFinite,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(8.0),
            physics: BouncingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                widget.descriptionText.isEmpty
                    ? Text(
                        LN.addDescription,
                        style: TextStyle(
                          fontSize: widget.size.getS(16),
                          fontFamily: kFontFMedium,
                          color: Colors.grey,
                        ),
                      )
                    : HtmlWidget(
                        widget.descriptionText,
                        textStyle: TextStyle(
                          fontSize: widget.size.getS(16),
                          fontFamily: kFontFMedium,
                          color: Colors.black,
                        ),
                      ),
              ],
            ),
          )),
    );
  }
}

class DescDialog extends StatefulWidget {
  final HtmlEditorController htmlController;
  final Function(String) onSave;
  final String descriptionText;
  final Ssize size;

  const DescDialog({
    super.key,
    required this.size,
    required this.onSave,
    required this.htmlController,
    required this.descriptionText,
  });

  @override
  State<DescDialog> createState() => _DescDialogState();
}

class _DescDialogState extends State<DescDialog> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        widget.htmlController.clearFocus();
        FocusScope.of(context).unfocus();
      },
      child: SimpleDialog(
        title: Padding(
          padding: EdgeInsets.fromLTRB(widget.size.getW(24),
              widget.size.getH(12), widget.size.getW(12), 0),
          child: Row(
            children: [
              Text(
                LN.description,
                style: TextStyle(
                  fontSize: widget.size.getS(18),
                  color: Colors.black,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: LoadButton(
                  vPad: 10,
                  onsave: () async {
                    final text = await widget.htmlController.getText();
                    widget.htmlController.clearFocus();
                    FocusScope.of(context).unfocus();
                    Navigator.pop(context);
                    widget.onSave(text);
                  },
                  btnText: LN.save,
                  width: 150,
                ),
              ),
              Spacer(),
              IconButton(
                visualDensity: VisualDensity.compact,
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: Icon(
                  Icons.close,
                  color: Colors.black,
                  size: widget.size.getS(24),
                ),
              ),
            ],
          ),
        ),
        titlePadding: EdgeInsets.zero,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: widget.size.getW(24)),
            child: SizedBox(
              width: widget.size.width * 0.8,
              child: HtmlEditSec(
                onInit: () async {
                  widget.htmlController.setText(widget.descriptionText);
                },
                controller: widget.htmlController,
                height: widget.size.getH(600),
              ),
            ),
          ),
          SizedBox(
            height: widget.size.getH(12),
          ),
          // Align(
          //   alignment: Alignment.centerRight,
          //   child: Padding(
          //     padding: const EdgeInsets.symmetric(horizontal: 20.0),
          //     child: LoadButton(
          //       onsave: () async {
          //         final text = await widget.htmlController.getText();
          //         widget.htmlController.clearFocus();
          //         FocusScope.of(context).unfocus();
          //         Navigator.pop(context);
          //         widget.onSave(text);
          //       },
          //       btnText: LN.save,
          //       width: 150,
          //     ),
          //   ),
          // ),
          // SizedBox(
          //   width: widget.size.getW(12),
          // )
        ],
      ),
    );
  }
}
