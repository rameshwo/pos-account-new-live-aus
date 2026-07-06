import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pos_account/config/size_config.dart';
import 'package:pos_account/constant/constant.dart';
import 'package:pos_account/providers/product/new_product_pro.dart';
import 'package:pos_account/widgets/input/dropdown/drop_down.dart';
import 'package:pos_account/widgets/input/text_form/text_form_widget.dart';
import 'package:provider/provider.dart';

class VariantSupSec extends StatelessWidget {
  final Function()? remove;
  final Animation<double> animation;
  final Supplier? supplier;

  const VariantSupSec(
      {super.key, this.remove, required this.animation, this.supplier});

  @override
  Widget build(BuildContext context) {
    final pro = Provider.of<NewProductPro>(context);
    final size = Ssize(context);
    return SizeTransition(
      sizeFactor: animation,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: size.getH(0)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Divider(
              color: Colors.black38,
            ),
            SizedBox(
              height: size.getH(4),
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Text(
                      //   "Supplier",
                      //   style: TextStyle(
                      //     fontSize: size.getS(14),
                      //     color: Colors.black,
                      //   ),
                      // ),
                      // SizedBox(
                      //   height: size.getH(6),
                      // ),
                      DropDownList(
                        vPad: 6,
                        hint: "Choose Supplier",
                        isReq: false,
                        borderColor: Colors.black54,
                        indexValue: supplier?.supplierIndex,
                        list: pro.addSecRes?.suppliers == null
                            ? []
                            : pro.addSecRes!.suppliers!
                                .map((e) => e.name ?? '')
                                .toList(),
                        onChange: (int? i) {
                          supplier?.supplierIndex = i;

                          pro.notify;
                        },
                      ),
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
                      // Text(
                      //   "Supplier Code",
                      //   style: TextStyle(
                      //     fontSize: size.getS(14),
                      //     color: Colors.black,
                      //   ),
                      // ),
                      // SizedBox(
                      //   height: size.getH(6),
                      // ),
                      TextFormWidget(
                        isDense: true,
                        // vPad: 6,
                        errH: 0,
                        // validator: (val) {
                        //   if (batch?.batchNoCltr.text.isNotEmpty ?? false) {
                        //     if (val == null || val.isEmpty) {
                        //       return "Stock Count is required";
                        //     }
                        //   }
                        //   return null;
                        // },
                        isReq: false,
                        borderColor: Colors.black54,
                        borderRadius: 5,
                        cltr: supplier == null
                            ? TextEditingController()
                            : supplier!.codeCltr,
                        hintText: "Supplier Code",
                        hintStyle: TextStyle(color: Colors.black45),
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
                      padding: EdgeInsets.all(size.getW(6.0)),
                      child: SvgPicture.asset(
                        "assets/svg/icons/Delete.svg",
                        width: size.getW(17),
                        height: size.getW(18),
                      ),
                    ),
                  ),
                ),
                Expanded(flex: 2, child: Container()),
                SizedBox(
                  width: size.getW(18 * 2),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
