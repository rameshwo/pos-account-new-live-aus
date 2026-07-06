import 'package:flutter/material.dart';
import 'package:pos_account/config/size_config.dart';
import 'package:pos_account/constant/constant.dart';
import 'package:pos_account/providers/product/new_product_pro.dart';
import 'package:pos_account/screens/home_screen/com/items/tabs/product_tab/com/new_product/com/macros/macro_sec.dart';

import '../variant/add_icon_b.dart';

class MacroListSec extends StatelessWidget {
  final Ssize size;
  final String title;
  final Function()? onAdd;
  final List<Macros> marcoList;
  final Function(int)? remove;
  final GlobalKey<AnimatedListState> listKey;

  const MacroListSec({
    super.key,
    required this.size,
    required this.title,
    this.onAdd,
    required this.marcoList,
    this.remove,
    required this.listKey,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size.getW(500),
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
                      TextSpan(
                        text: " *",
                        style: TextStyle(
                          fontSize: size.getS(18),
                          color: Colors.red,
                        ),
                      )
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
              initialItemCount: marcoList.length,
              itemBuilder: (ctx, i, animation) {
                return MacroSection(
                  animation: animation,
                  remove: remove == null ? null : () => remove!(i),
                  macros: marcoList[i],
                );
              }),
        ],
      ),
    );
  }
}
