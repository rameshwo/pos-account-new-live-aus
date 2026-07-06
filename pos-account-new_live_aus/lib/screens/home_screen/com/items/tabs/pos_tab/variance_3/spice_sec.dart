import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:pos_account/config/size_config.dart';
import 'package:pos_account/constant/constant.dart';
import 'package:pos_account/model/home/menu/place_order/pos_res/com/feature_product.dart';
import 'package:pos_account/widgets/image/image_error.dart';

class SpiceSection extends StatelessWidget {
  final bool isItem;
  final List<ProductVariationModifier>? spiceList;
  final Function()? onChanged;
  const SpiceSection({
    super.key,
    this.spiceList,
    this.onChanged,
    this.isItem = true,
  });

  @override
  Widget build(BuildContext context) {
    final size = Ssize(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (spiceList?.isNotEmpty ?? false)
          ...List.generate(spiceList!.length, (i) {
            if (spiceList![i].modifierItems?.isNotEmpty ?? false)
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(height: size.getH(12)),
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.grey.withOpacity(0.15),
                    ),
                    padding: EdgeInsets.symmetric(
                        horizontal: size.getW(24), vertical: size.getH(12)),
                    child: Text(
                      spiceList![i].name ?? '',
                      style: TextStyle(
                        fontSize: size.getS(18),
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: size.getH(8),
                  ),
                  GridView.count(
                    crossAxisCount: 4,
                    childAspectRatio: isItem ? 3 : 2,
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    mainAxisSpacing: 10,
                    crossAxisSpacing: 10,
                    padding: EdgeInsets.symmetric(horizontal: size.getW(16)),
                    children: [
                      ...List.generate(spiceList![i].modifierItems!.length,
                          (j) {
                        final _spice = spiceList![i].modifierItems![j];
                        return SizedBox(
                          width: size.getW(140),
                          child: SpiceWidget(
                            name: _spice.productName ?? '',
                            imgPath: _spice.imageUrl,
                            isChecked: _spice.isActive ?? false,
                            size: size,
                            onChanged: (val) {
                              for (final e in spiceList![i].modifierItems!) {
                                if (e.id?.toLowerCase() ==
                                    _spice.id?.toLowerCase()) {
                                  e.isActive = !(e.isActive ?? false);
                                } else {
                                  e.isActive = false;
                                }
                              }
                              // _placeOr!.notify;
                              if (onChanged != null) onChanged!();
                            },
                          ),
                        );
                      }),
                    ],
                  ),
                ],
              );
            else
              return SizedBox.shrink();
          })
      ],
    );
  }
}

class SpiceWidget extends StatelessWidget {
  final String? imgPath;
  final String name;
  final String? price;
  final bool isChecked;
  final Function(bool?)? onChanged;
  final Ssize size;
  const SpiceWidget({
    super.key,
    this.imgPath,
    required this.name,
    this.price,
    required this.isChecked,
    this.onChanged,
    required this.size,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: isChecked ? kSecondaryColor.withOpacity(0.2) : null,
        border: Border.all(
          color: isChecked ? kSecondaryColor : Colors.black26,
        ),
        borderRadius: BorderRadius.circular(10),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(10),
        onTap: onChanged != null ? () => onChanged!(!isChecked) : null,
        child: Padding(
          padding: EdgeInsets.symmetric(
              vertical: size.getH(6), horizontal: size.getW(4)),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (imgPath?.isNotEmpty ?? false) ...[
                Center(
                  child: ClipRRect(
                      borderRadius: BorderRadius.circular(100),
                      child: CachedNetworkImage(
                          imageUrl: imgPath ?? '',
                          height: size.getW(32),
                          width: size.getW(32),
                          fit: BoxFit.fitHeight,
                          placeholder: ImageError.load,
                          errorWidget: ImageError.notSupportIcon)),
                ),
                SizedBox(
                  width: size.getW(8),
                )
              ],
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      name,
                      style: TextStyle(
                        fontSize: size.getS(18),
                        color: isChecked ? kSecondaryColor : Colors.black,
                        fontFamily: kFontFMedium,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (price != null)
                      Text(
                        price!,
                        style: TextStyle(
                          fontSize: size.getS(18),
                          color: Colors.black,
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
