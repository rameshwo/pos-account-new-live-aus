import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:pos_account/config/size_config.dart';
import 'package:pos_account/constant/constant.dart';
import 'package:pos_account/model/home/setting/table_layout/layout_design_model.dart';
import 'package:pos_account/widgets/image/image_error.dart';

class StatTable extends StatelessWidget {
  const StatTable({
    super.key,
    required this.pData,
  });

  final PData pData;

  @override
  Widget build(BuildContext context) {
    final size = Ssize(context);
    return Material(
      elevation: 20,
      shadowColor: Colors.black38,
      borderRadius: BorderRadius.circular(100),
      color: Colors.transparent,
      child: Column(
        children: [
          pData.image != null
              ? CachedNetworkImage(
                  imageUrl: pData.image!,
                  width: size.getS(80),
                  height: size.getS(80),
                  fit: BoxFit.fitWidth,
                  placeholder: ImageError.load,
                  errorWidget: (ctx, _, __) => ImageError.table(size.getS(80)),
                )
              : SizedBox.shrink(),
          Container(
            margin: EdgeInsets.only(top: 2),
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(5)),
            padding: EdgeInsets.symmetric(horizontal: 12),
            child: Text(
              pData.title ?? '',
              style: TextStyle(
                fontSize: size.getS(15),
                fontFamily: kFontFMedium,
                color: Colors.black,
              ),
            ),
          )
        ],
      ),
    );
  }
}
