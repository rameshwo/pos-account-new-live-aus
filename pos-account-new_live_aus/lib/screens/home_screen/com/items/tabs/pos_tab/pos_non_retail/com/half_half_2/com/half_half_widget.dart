import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:pos_account/config/size_config.dart';
import 'package:pos_account/constant/constant.dart';
import 'package:pos_account/model/home/menu/place_order/pos_res/com/feature_product.dart';
import 'package:pos_account/providers/menu/place_order_pro.dart';
import 'package:pos_account/widgets/image/image_error.dart';

class HalfnHalfWidget {
  static const double _radius = 1000;
  static const double _titleFontSize = 18; //24

  static Widget newHalfItem(
    Ssize size, {
    required PlaceOrderPro placeOrderPro,
    required HalfItemTypeEnum halfEnum,
    ModifierItem? halfItem,
    Function()? customize,
    Function()? onTapItem,
  }) {
    return Expanded(
      child: Material(
        color: halfItem == null ? const Color(0xFF9CA3AF) : Colors.transparent,
        borderRadius: halfEnum == HalfItemTypeEnum.first
            ? BorderRadius.only(
                topLeft: Radius.circular(_radius),
                bottomLeft: Radius.circular(_radius),
              )
            : BorderRadius.only(
                topRight: Radius.circular(_radius),
                bottomRight: Radius.circular(_radius),
              ),
        child: InkWell(
          splashColor: kSecondaryColor,
          highlightColor: kSecondaryColor.withOpacity(0.1),
          borderRadius: halfEnum == HalfItemTypeEnum.first
              ? BorderRadius.only(
                  topLeft: Radius.circular(_radius),
                  bottomLeft: Radius.circular(_radius),
                )
              : BorderRadius.only(
                  topRight: Radius.circular(_radius),
                  bottomRight: Radius.circular(_radius),
                ),
          onTap: onTapItem,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: halfEnum == HalfItemTypeEnum.first
                  ? BorderRadius.only(
                      topLeft: Radius.circular(_radius),
                      bottomLeft: Radius.circular(_radius),
                    )
                  : BorderRadius.only(
                      topRight: Radius.circular(_radius),
                      bottomRight: Radius.circular(_radius),
                    ),
              border: Border.all(
                color: placeOrderPro.selectedHalfEnum == halfEnum
                    ? kSecondaryColor
                    : Colors.black12,
                width: placeOrderPro.selectedHalfEnum == halfEnum ? 4 : 2,
              ),
            ),
            padding: EdgeInsets.all(
                placeOrderPro.selectedHalfEnum == halfEnum ? size.getS(3) : 0),
            child: halfItem != null
                ? ClipRRect(
                    borderRadius: halfEnum == HalfItemTypeEnum.first
                        ? BorderRadius.only(
                            topLeft: Radius.circular(_radius),
                            bottomLeft: Radius.circular(_radius),
                          )
                        : BorderRadius.only(
                            topRight: Radius.circular(_radius),
                            bottomRight: Radius.circular(_radius),
                          ),
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        CachedNetworkImage(
                          imageUrl: halfItem.imageUrl ?? '',
                          fit: BoxFit.cover,
                          placeholder: ImageError.load,
                          errorWidget: (ctx, _, __) => Container(),
                        ),
                        Container(
                          color: Colors.black.withOpacity(0.4),
                        ),
                        Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                halfItem.productName ?? '',
                                style: TextStyle(
                                  fontSize: size.getS(_titleFontSize),
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              // SizedBox(height: size.getH(8)),
                              // ElevatedButton.icon(
                              //   onPressed: customize,
                              //   icon: Icon(
                              //     Icons.restaurant,
                              //     size: size.getS(16),
                              //     color: Colors.white,
                              //   ),
                              //   label: Text(
                              //     'Customize',
                              //     style: TextStyle(
                              //         color: Colors.white,
                              //         fontFamily: kFontFMedium,
                              //         fontSize: size.getS(13)),
                              //   ),
                              //   style: ElevatedButton.styleFrom(
                              //     primary: kSecondaryColor,
                              //     padding: EdgeInsets.symmetric(
                              //       horizontal: size.getW(16),
                              //       vertical: size.getH(8),
                              //     ),
                              //     shape: RoundedRectangleBorder(
                              //       borderRadius: BorderRadius.circular(24),
                              //     ),
                              //   ),
                              // ),
                              // SizedBox(height: size.getH(12)),
                              // ElevatedButton.icon(
                              //   onPressed: () {
                              //     if (halfEnum == HalfEnum.First) {
                              //       clearOnRemove(placeOrderPro.firstHalf);
                              //       placeOrderPro.firstHalf = null;
                              //     } else if (halfEnum == HalfEnum.Second) {
                              //       clearOnRemove(placeOrderPro.secondHalf);
                              //       placeOrderPro.secondHalf = null;
                              //     }

                              //     placeOrderPro.notify;
                              //   },
                              //   icon: Icon(
                              //     Icons.close,
                              //     size: size.getS(16),
                              //     color: Colors.white,
                              //   ),
                              //   label: Text(
                              //     'Remove',
                              //     style: TextStyle(
                              //         color: Colors.white,
                              //         fontSize: size.getS(13)),
                              //   ),
                              //   style: ElevatedButton.styleFrom(
                              //     primary: Colors.red,
                              //     padding: EdgeInsets.symmetric(
                              //       horizontal: size.getW(16),
                              //       vertical: size.getH(8),
                              //     ),
                              //     shape: RoundedRectangleBorder(
                              //       borderRadius: BorderRadius.circular(24),
                              //     ),
                              //   ),
                              // ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  )
                : Center(
                    child: Text(
                      halfItem == null
                          ? "${halfEnum == HalfItemTypeEnum.first ? 'First' : 'Second'}\nHalf"
                          : "",
                      style: TextStyle(
                        fontSize: size.getS(_titleFontSize),
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
          ),
        ),
      ),
    );
  }

  static Widget newQuarterItem(
    Ssize size, {
    required HalfItemTypeEnum quarterEnum,
    ModifierItem? quarterItem,
    Function()? customize,
    required PlaceOrderPro placeOrderPro,
    Function()? onTapItem,
  }) {
    BorderRadius _borderRadius;
    EdgeInsetsGeometry _titlePadding;
    Alignment _titleAlign;
    MainAxisAlignment _titleAxis;
    TextAlign _titleTextAlign;

    switch (quarterEnum) {
      case HalfItemTypeEnum.first:
        _borderRadius = BorderRadius.only(
          topLeft: Radius.circular(_radius),
        );
        _titlePadding =
            EdgeInsets.only(bottom: size.getH(24), right: size.getW(24));
        _titleAlign = Alignment.bottomRight;
        _titleAxis = MainAxisAlignment.end;
        _titleTextAlign = TextAlign.right;
        break;
      case HalfItemTypeEnum.second:
        _borderRadius = BorderRadius.only(
          topRight: Radius.circular(_radius),
        );
        _titlePadding =
            EdgeInsets.only(bottom: size.getH(24), left: size.getW(24));
        _titleAlign = Alignment.bottomLeft;
        _titleAxis = MainAxisAlignment.end;
        _titleTextAlign = TextAlign.left;
        break;
      case HalfItemTypeEnum.third:
        _borderRadius = BorderRadius.only(
          bottomLeft: Radius.circular(_radius),
        );
        _titlePadding =
            EdgeInsets.only(top: size.getH(24), right: size.getW(24));
        _titleAlign = Alignment.topRight;
        _titleAxis = MainAxisAlignment.start;
        _titleTextAlign = TextAlign.right;
        break;
      case HalfItemTypeEnum.fourth:
        _borderRadius = BorderRadius.only(
          bottomRight: Radius.circular(_radius),
        );
        _titlePadding =
            EdgeInsets.only(top: size.getH(24), left: size.getW(24));
        _titleAlign = Alignment.topLeft;
        _titleAxis = MainAxisAlignment.start;
        _titleTextAlign = TextAlign.left;
        break;
    }

    return Expanded(
      child: Material(
        color:
            quarterItem == null ? const Color(0xFF9CA3AF) : Colors.transparent,
        borderRadius: _borderRadius,
        child: InkWell(
          splashColor: kSecondaryColor,
          highlightColor: kSecondaryColor.withOpacity(0.1),
          borderRadius: _borderRadius,
          onTap: onTapItem,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: _borderRadius,
              border: Border.all(
                color: placeOrderPro.selectedHalfEnum == quarterEnum
                    ? kSecondaryColor
                    : Colors.black12,
                width: placeOrderPro.selectedHalfEnum == quarterEnum ? 4 : 2,
              ),
            ),
            padding: EdgeInsets.all(
                placeOrderPro.selectedHalfEnum == quarterEnum
                    ? size.getS(3)
                    : 0),
            child: quarterItem != null
                ? ClipRRect(
                    borderRadius: _borderRadius,
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        CachedNetworkImage(
                          imageUrl: quarterItem.imageUrl ?? '',
                          fit: BoxFit.cover,
                          placeholder: ImageError.load,
                          errorWidget: (ctx, _, __) => Container(),
                        ),
                        Container(color: Colors.black.withOpacity(0.4)),
                        Container(
                          padding: _titlePadding,
                          alignment: _titleAlign,
                          child: Column(
                            mainAxisAlignment: _titleAxis,
                            children: [
                              SizedBox(
                                width: size.getW(100),
                                child: Text(
                                  (quarterItem.productName ?? ''),
                                  style: TextStyle(
                                    fontSize: size.getS(_titleFontSize),
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                  textAlign: _titleTextAlign,
                                  maxLines: 5,
                                ),
                              ),
                              // SizedBox(height: size.getH(8)),
                              // ElevatedButton.icon(
                              //   onPressed: customize,
                              //   icon: Icon(Icons.restaurant,
                              //       size: size.getS(14), color: Colors.white),
                              //   label: Text(
                              //     'Customize',
                              //     style: TextStyle(
                              //         color: Colors.white,
                              //         fontFamily: kFontFMedium,
                              //         fontSize: size.getS(12)),
                              //   ),
                              //   style: ElevatedButton.styleFrom(
                              //     primary: kSecondaryColor,
                              //     padding: EdgeInsets.symmetric(
                              //       horizontal: size.getW(12),
                              //       vertical: size.getH(6),
                              //     ),
                              //     shape: RoundedRectangleBorder(
                              //       borderRadius: BorderRadius.circular(24),
                              //     ),
                              //   ),
                              // ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  )
                : Container(
                    padding: _titlePadding,
                    alignment: _titleAlign,
                    child: Text(
                      "${quarterEnum.name[0].toUpperCase() + quarterEnum.name.substring(1)}\nQuarter",
                      style: TextStyle(
                        fontSize: size.getS(_titleFontSize),
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
          ),
        ),
      ),
    );
  }
}
