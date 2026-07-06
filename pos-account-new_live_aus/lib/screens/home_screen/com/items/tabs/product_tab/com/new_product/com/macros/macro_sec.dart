import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pos_account/config/size_config.dart';
import 'package:pos_account/constant/constant.dart';
import 'package:pos_account/ln.dart';
import 'package:pos_account/providers/product/new_product_pro.dart';
import 'package:pos_account/widgets/input/text_form/text_form_widget.dart';

class MacroSection extends StatelessWidget {
  final Function()? remove;
  final Animation<double> animation;
  final Macros? macros;

  const MacroSection(
      {super.key, this.remove, required this.animation, this.macros});

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
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        LN.name,
                        style: TextStyle(
                          fontSize: size.getS(14),
                          color: Colors.black,
                        ),
                      ),
                      SizedBox(
                        height: size.getH(4),
                      ),
                      TextFormWidget(
                          isDense: true,
                          isReq: false,
                          vPad: 6,
                          errH: 0,
                          borderColor: Colors.black54,
                          borderRadius: 5,
                          cltr: macros == null
                              ? TextEditingController()
                              : macros!.name,
                          hintText: ""),
                    ],
                  ),
                ),
                SizedBox(
                  width: size.getW(18),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        LN.value,
                        style: TextStyle(
                          fontSize: size.getS(14),
                          color: Colors.black,
                        ),
                      ),
                      SizedBox(
                        height: size.getH(4),
                      ),
                      TextFormWidget(
                        isDense: true,
                        vPad: 6,
                        errH: 0,
                        isReq: false,
                        borderColor: Colors.black54,
                        borderRadius: 5,
                        cltr: macros == null
                            ? TextEditingController()
                            : macros!.value,
                        hintText: "",
                        textInputType: TextInputType.number,
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  width: size.getW(18),
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
          ],
        ),
      ),
    );
  }
}
