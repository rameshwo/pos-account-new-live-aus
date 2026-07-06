import 'package:flutter/material.dart';
import 'package:pos_account/model/home/menu/place_order/place_order_req.dart';
import 'package:pos_account/model/home/menu/place_order/pos_res/com/feature_product.dart';
import 'package:pos_account/providers/cus_val_pro.dart';
import 'package:pos_account/screens/home_screen/com/items/tabs/pos_tab/variance_3/variance_3.dart';
import 'variance/variance.dart';

class ProductDetailDia extends StatelessWidget {
  final FeaturedProduct? product;
  final String curSym;
  final int? orderDetailIndex;
  final double? quantity;
  final String? uniqueKey;
  final List<OrderItemSelectOptionsViewModels>? filterTypeList;
  final bool isPosTab;
  final String? productType;
  const ProductDetailDia({
    super.key,
    required this.curSym,
    this.orderDetailIndex,
    this.uniqueKey,
    this.filterTypeList,
    this.isPosTab = false,
    this.productType,
    required this.product,
    this.quantity,
  });

  @override
  Widget build(BuildContext context) {
    if (GlobalCVP.storeInfo?.productDetailScreen
            ?.toLowerCase()
            .contains('list') ??
        false)
      return Variance3(
        product: product,
        curSym: curSym,
        orderDetailIndex: orderDetailIndex,
        quantity: quantity,
        uniqueKey: uniqueKey,
        filterTypeList: filterTypeList,
        isPosTab: isPosTab,
        productType: productType,
      );
    else
      return Variance(
        product: product,
        curSym: curSym,
        orderDetailIndex: orderDetailIndex,
        quantity: quantity,
        uniqueKey: uniqueKey,
        filterTypeList: filterTypeList,
        isPosTab: isPosTab,
        productType: productType,
      );
  }
}
