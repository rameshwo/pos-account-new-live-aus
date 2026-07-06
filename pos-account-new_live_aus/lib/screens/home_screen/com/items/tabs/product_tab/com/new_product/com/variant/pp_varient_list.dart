import 'package:flutter/material.dart';
import 'package:pos_account/config/size_config.dart';
import 'package:pos_account/providers/product/new_product_pro.dart';
import 'package:pos_account/widgets/input/text_form/text_form_widget.dart';
import '../../../../../../../../../../ln.dart';
import 'add_icon_b.dart';
import 'prod_varient.dart';

class PPVarientsList extends StatelessWidget {
  const PPVarientsList({
    super.key,
    required this.size,
    required this.titleCltr,
    this.onAdd,
    required this.ppvList,
    this.remove,
    this.changeDefault,
    required this.listKey,
    this.isService = false,
  });

  final Ssize size;
  final TextEditingController titleCltr;
  final Function()? onAdd;
  final List<PPVarient> ppvList;
  final Function(int)? remove;
  final Function(int, {bool? val})? changeDefault;
  final GlobalKey<AnimatedListState> listKey;
  final bool isService;

  @override
  Widget build(BuildContext context) {
    return Container(
      // width: size.getW(38) * 2 + size.width * 0.72,
      margin: EdgeInsets.only(top: size.getH(12), right: size.getW(2)),
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.black38)),
            padding: EdgeInsets.symmetric(
                vertical: size.getH(8), horizontal: size.getW(24)),
            child: Row(
              children: [
                SizedBox(
                  width: size.getW(320),
                  child: TextFormWidget(
                    cltr: titleCltr,
                    hintText: LN.variations,
                    borderColor: Colors.black54,
                    vPad: 8,
                  ),
                ),
                // Text.rich(
                //   TextSpan(
                //       text: title,
                //       style: TextStyle(
                //         fontSize: size.getS(18),
                //         color: Colors.black,
                //       ),
                //       children: isReq
                //           ? [
                //               TextSpan(
                //                 text: " *",
                //                 style: TextStyle(
                //                   fontSize: size.getS(18),
                //                   color: Colors.red,
                //                 ),
                //               )
                //             ]
                //           : null),
                // ),
                Spacer(),
                AddIconB(
                  size: size,
                  onTap: onAdd,
                )
              ],
            ),
          ),
          AnimatedList(
              key: listKey,
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              initialItemCount: ppvList.length,
              itemBuilder: (ctx, j, animation) {
                return Column(
                  children: [
                    if (j != 0)
                      Divider(
                        color: Colors.black54,
                      ),
                    SizedBox(
                      height: size.getH(8),
                    ),
                    ProductVarient(
                      index: j,
                      size: size,
                      animation: animation,
                      remove: remove == null ? null : () => remove!(j),
                      changeDefault: (bool? val) {
                        if (changeDefault != null) changeDefault!(j, val: val);
                      },
                      ppVarient: ppvList[j],
                      num: j + 1,
                      isService: isService,
                    ),
                  ],
                );
              }),
        ],
      ),
    );
  }
}
