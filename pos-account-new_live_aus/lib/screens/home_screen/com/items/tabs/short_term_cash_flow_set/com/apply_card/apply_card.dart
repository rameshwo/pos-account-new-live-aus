import 'package:flutter/material.dart';
import 'package:pos_account/config/size_config.dart';
import 'package:pos_account/providers/stcf/short_tcf_pro.dart';
import 'package:provider/provider.dart';
import 'com/left_apply_card.dart';
import 'com/right_apply_card.dart';

class ApplyCard extends StatelessWidget {
  const ApplyCard({super.key});

  static final _pageCltr = PageController();

  @override
  Widget build(BuildContext context) {
    final size = Ssize(context);
    final pro = Provider.of<StcfPro>(context);
    return Container(
      constraints: BoxConstraints(
        maxHeight: size.height / 1.5,
        minHeight: size.height / 5,
      ),
      width: size.width / 1.2,
      // decoration: BoxDecoration(
      //     borderRadius: BorderRadius.circular(10),
      //     border: Border.all(
      //       color: Color(0xff50e3c2),
      //       width: 1.2,
      //     )),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: LeftApplyCard(size: size),
          ),
          Expanded(
            child: Container(
              width: double.infinity,
              height: double.infinity,
              decoration: BoxDecoration(
                color: Color(0xff364470),
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(10),
                  bottomRight: Radius.circular(10),
                ),
              ),
              child: RightApplyCard(
                size: size,
                pageCltr: _pageCltr,
                pro: pro,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
