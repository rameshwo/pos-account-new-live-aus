import 'package:flutter/material.dart';
import 'package:pos_account/config/size_config.dart';
import 'package:pos_account/constant/constant.dart';
import 'package:pos_account/providers/product/new_product_pro.dart';
import '../variant/add_icon_b.dart';
import 'label_sec.dart';

class LabelListSec extends StatelessWidget {
  final Ssize size;
  final String title;
  final Function()? onAdd;
  final List<LabelModel> labelList;
  final Function(int)? remove;
  final GlobalKey<AnimatedListState> listKey;
  final Function()? onChanged;

  const LabelListSec({
    super.key,
    required this.size,
    required this.title,
    this.onAdd,
    required this.labelList,
    this.remove,
    required this.listKey,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      // width: size.getW(348),
      margin: EdgeInsets.only(
        top: size.getH(12),
      ),
      decoration: BoxDecoration(
          color: kBackgroundColor, borderRadius: BorderRadius.circular(10)),
      padding: EdgeInsets.symmetric(
          vertical: size.getH(8), horizontal: size.getW(24)),
      child: Column(
        children: [
          Row(
            children: [
              Text.rich(
                TextSpan(
                    text: title,
                    style: TextStyle(
                      fontSize: size.getS(18),
                      color: Colors.black,
                    ),
                    children: [
                      // TextSpan(
                      //   text: " *",
                      //   style: TextStyle(
                      //     fontSize: size.getS(18),
                      //     color: Colors.red,
                      //   ),
                      // )
                    ]),
              ),
              Spacer(),
              AddIconB(
                size: size,
                onTap: onAdd,
              )
            ],
          ),
          AnimatedList(
              key: listKey,
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              initialItemCount: labelList.length,
              itemBuilder: (ctx, i, animation) {
                return LabelSection(
                  animation: animation,
                  height: size.getH(300),
                  remove: remove == null ? null : () => remove!(i),
                  labelModel: labelList[i],
                  onChanged: onChanged,
                );
              }),
        ],
      ),
    );
  }
}
