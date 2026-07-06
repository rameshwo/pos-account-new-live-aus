import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:html_editor_enhanced/html_editor.dart';
import 'package:pos_account/config/size_config.dart';
import 'package:pos_account/constant/constant.dart';
import 'package:pos_account/ln.dart';
import 'package:pos_account/providers/product/new_product_pro.dart';
import 'package:pos_account/widgets/input/text_form/title_text_form.dart';
import 'package:pos_account/widgets/switch_adap.dart';
import '../../../../../../../../../../widgets/description_view.dart';

class LabelSection extends StatelessWidget {
  final LabelModel? labelModel;
  final double height;
  final Function()? remove;
  final Animation<double> animation;
  final Function()? onChanged;
  const LabelSection({
    super.key,
    this.height = 300,
    this.remove,
    required this.animation,
    this.labelModel,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final size = Ssize(context);
    return SizeTransition(
      sizeFactor: animation,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: size.getH(8)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Divider(
              color: Colors.black87,
            ),
            SizedBox(
              height: size.getH(4),
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Wrap(
                    spacing: size.getW(24),
                    runSpacing: size.getH(24),
                    children: [
                      SizedBox(
                        width: size.getW(300),
                        child: TitleTextForm(
                          title: LN.labelName,
                          isReq: false,
                          borderColor: Colors.black54,
                          textCltr: labelModel == null
                              ? TextEditingController()
                              : labelModel!.titleCltr,
                        ),
                      ),
                      SizedBox(
                        width: size.getW(100),
                        child: TitleTextForm(
                          title: LN.sortOrder,
                          isReq: false,
                          borderColor: Colors.black54,
                          textInputType: TextInputType.number,
                          textCltr: labelModel == null
                              ? TextEditingController()
                              : labelModel!.sortOrderCltr,
                        ),
                      ),
                      SizedBox(
                        width: size.getW(300),
                        child: TitleTextForm(
                          title: LN.identifier,
                          isReq: false,
                          borderColor: Colors.black54,
                          textCltr: labelModel == null
                              ? TextEditingController()
                              : labelModel!.identCltr,
                        ),
                      ),
                      if (labelModel != null)
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              LN.isActive,
                              style: TextStyle(
                                fontSize: size.getS(16),
                                fontFamily: kFontFMedium,
                                color: Colors.black,
                              ),
                            ),
                            SizedBox(
                              height: size.getH(8),
                            ),
                            SwitchAdap(
                              value: labelModel!.isActive,
                              size: size,
                              onChanged: (val) {
                                labelModel!.isActive = val;
                                if (onChanged != null) onChanged!();
                              },
                            ),
                          ],
                        ),
                      // SizedBox(
                      //     width: size.getW(300),
                      //     child: TextFormWidget(
                      //       isReq: false,
                      //       cltr: labelModel == null
                      //           ? TextEditingController()
                      //           : labelModel!.titleCltr,
                      //       hintText: hintText,
                      //       borderColor: Colors.black54,
                      //     )),
                      // Spacer(),
                    ],
                  ),
                ),
                Card(
                  elevation: 4,
                  margin: EdgeInsets.zero,
                  shadowColor: Colors.grey[200],
                  color: kIconBackColor,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5)),
                  child: InkWell(
                    onTap: remove,
                    child: Padding(
                      padding: EdgeInsets.all(size.getW(11.0)),
                      child: SvgPicture.asset(
                        "assets/svg/icons/Delete.svg",
                        width: size.getW(17),
                        height: size.getW(18),
                      ),
                    ),
                  ),
                )
              ],
            ),
            SizedBox(
              height: size.getH(8),
            ),
            //add description

            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  LN.description,
                  style: TextStyle(
                    fontSize: size.getS(16),
                    fontFamily: kFontFMedium,
                    color: Colors.black,
                  ),
                ),
                SizedBox(
                  height: size.getH(8),
                ),
                DescriptionHtmlView(
                  size: size,
                  htmlController: labelModel == null
                      ? HtmlEditorController()
                      : labelModel!.htmlCltr,
                  height: 100,
                  descriptionText:
                      labelModel == null ? "" : labelModel!.description ?? "",
                  onSave: (val) {
                    if (labelModel != null) labelModel!.description = val;
                    if (onChanged != null) onChanged!();
                  },
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
