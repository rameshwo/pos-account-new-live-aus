import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
// import 'package:pos_account/widgets/image/image_error.dart';

class SvgImageSection extends StatelessWidget {
  final String imageUrl;
  final double? height;
  final double? width;
  final Color? color;
  final Widget Function(BuildContext)? placeholder;
  final Widget? errorWidget;
  const SvgImageSection(
      {super.key,
      required this.imageUrl,
      this.height,
      this.width,
      this.placeholder,
      this.errorWidget,
      this.color});

  @override
  Widget build(BuildContext context) {
    // try {
    return SvgPicture.network(
      imageUrl,
      width: width,
      height: height,
      color: color,
      placeholderBuilder:
          placeholder, // ?? ((_) => ImageError.load(context, "")),
      errorBuilder: (context, error, stackTrace) => Container(),
    );
    // } catch (_) {
    //   print(
    //       "Exception on svg : $imageUrl --------------------------------------------");
    //   return errorWidget ?? ImageError.icon(context, "", "");
    // }
  }
}
