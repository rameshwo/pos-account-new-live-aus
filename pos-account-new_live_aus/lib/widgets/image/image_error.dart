import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:pos_account/config/size_config.dart';
import 'package:pos_account/ln.dart';
import 'package:pos_account/providers/cus_val_pro.dart';
import 'package:pos_account/widgets/loading.dart';

class ImageError {
  //   placeholder: ImageError.load
  static Widget load(BuildContext ctx, String _) {
    return Loading();
  }

  // errorWidget: ImageError.text
  static Widget text(BuildContext ctx, String _, __) {
    final size = Ssize(ctx);
    return Center(
      child: Text(
        LN.noImage,
        style: TextStyle(
            fontSize: size.getS(18),
            fontStyle: FontStyle.italic,
            color: Colors.black45),
        textAlign: TextAlign.center,
      ),
    );
  }

  // errorWidget: ImageError.icon
  static Widget icon(BuildContext ctx, String _, __) {
    return Icon(
      Icons.error,
      size: 24,
      // color: Colors.black54,
    );
  }

  //   errorWidget: ImageError.notSupportIcon
  static Widget notSupportIcon(BuildContext ctx, String _, __) {
    final size = Ssize(ctx);
    return Container(
        height: size.getW(48),
        width: size.getW(48),
        color: Colors.grey[200],
        child: Icon(
          Icons.image_not_supported_outlined,
          size: size.getS(24),
          color: Colors.grey,
        ));
  }

  static Widget noItemImage(BuildContext ctx, double? height, double? width) {
    return CachedNetworkImage(
      imageUrl: GlobalCVP.storeInfo?.noProductImageUrl ?? '',
      height: height,
      width: width,
      fit: BoxFit.cover,
      placeholder: (_, __) =>
          ImageError.notSupportIcon(_, '', null), // ImageError.load,
      errorWidget: (context, url, error) =>
          ImageError.notSupportIcon(context, '', null),
    );
  }

  // errorWidget: ImageError.table
  static Widget table(double iconSize) {
    return Icon(
      Icons.table_bar_outlined,
      size: iconSize,
      color: Colors.grey,
    );
  }
}
