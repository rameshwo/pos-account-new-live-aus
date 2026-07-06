import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pos_account/config/size_config.dart';
import 'package:pos_account/constant/constant.dart';
import 'package:pos_account/model/home/dashboard/dashboard_res.dart';
import '../../../../../../../../widgets/image/image_error.dart';

class ProductListChart extends StatelessWidget {
  final Ssize size;
  final List<RecommendedProductsModel>? recomProduct;
  const ProductListChart({
    super.key,
    required this.size,
    this.recomProduct,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          if (recomProduct != null)
            ...List.generate(
                recomProduct!.length,
                (index) => ProdChartTile(
                      image: recomProduct?[index].imageUrl == null ||
                              recomProduct?[index].imageUrl?.isEmpty == true
                          ? null
                          : recomProduct?[index].imageUrl,
                      size: size,
                      leadText: "${index + 1}.",
                      title: recomProduct?[index].productName ?? '',
                      trail: recomProduct?[index].count ?? '',
                      color: Colors.blue,
                    )),
        ],
      ),
    );
  }
}

class ProdChartTile extends StatelessWidget {
  const ProdChartTile({
    super.key,
    required this.size,
    required this.leadText,
    required this.title,
    required this.trail,
    this.image,
    this.isHeader = false,
    this.color,
  });

  final Ssize size;
  final String leadText;
  final String title;
  final String trail;
  final Color? color;
  final String? image;
  final bool isHeader;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      dense: true,
      contentPadding: EdgeInsets.symmetric(vertical: 6),
      minLeadingWidth: 0,
      // horizontalTitleGap: 8,
      minVerticalPadding: 0,
      visualDensity: VisualDensity.compact,
      leading: DashImageChart(
        size: size,
        image: image ?? '',
      ),
      title: Text(
        title,
        style: TextStyle(
          fontSize: size.getS(16),
          fontFamily: kFontFRegular,
          color: Colors.black54,
        ),
      ),
      trailing: Text(
        trail,
        style: TextStyle(
          fontSize: size.getS(16),
          fontFamily: kFontFRegular,
          color: Colors.black54,
        ),
      ),
    );
  }
}

class DashImageChart extends StatelessWidget {
  const DashImageChart({
    super.key,
    required this.size,
    required this.image,
  });

  final Ssize size;
  final String image;

  @override
  Widget build(BuildContext context) {
    if (image.contains('.svg'))
      return ClipRRect(
        borderRadius: BorderRadius.circular(5),
        child: SvgPicture.network(image,
            height: size.getW(40),
            width: size.getW(40),
            fit: BoxFit.cover,
            placeholderBuilder: (context) => ImageError.load(context, ""),
            errorBuilder: (context, url, error) => Container(
                  height: size.getW(40),
                  width: size.getW(40),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color: Colors.grey.shade200,
                  ),
                  child: Icon(
                    Icons.image_outlined,
                    size: size.getS(28),
                    color: Colors.black38,
                  ),
                )),
      );
    else
      return ClipRRect(
        borderRadius: BorderRadius.circular(5),
        child: CachedNetworkImage(
            imageUrl: image,
            height: size.getW(40),
            width: size.getW(40),
            fit: BoxFit.cover,
            placeholder: (context, url) => ImageError.load(context, url),
            errorWidget: (context, url, error) => Container(
                  height: size.getW(40),
                  width: size.getW(40),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color: Colors.grey.shade200,
                  ),
                  child: Icon(
                    Icons.image_outlined,
                    size: size.getS(28),
                    color: Colors.black38,
                  ),
                )),
      );
  }
}
