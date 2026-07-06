import 'package:flutter/material.dart';
import 'package:pos_account/config/size_config.dart';
import 'package:pos_account/ln.dart';
import '../../../../../../../../../../widgets/title_pop.dart';
import '../../../../../setting_tab/com/general/common/common_header.dart';
import 'com/product__gen_barcode.dart';

class BarCodeGenDia extends StatelessWidget {
  final Function() onBack;
  const BarCodeGenDia({super.key, required this.onBack});

  @override
  Widget build(BuildContext context) {
    final size = Ssize(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        CommonHeader(
          child: TitlePop(
            title: LN.generateBarcode,
            size: size,
            onTap: onBack,
          ),
        ),
        SizedBox(
          height: size.getH(12),
        ),
        Flexible(child: ProductSecGenBarCode()),
      ],
    );
  }
}
