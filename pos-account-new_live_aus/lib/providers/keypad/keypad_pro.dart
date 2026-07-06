import 'package:flutter/material.dart';
import 'package:pos_account/model/home/menu/place_order/pos_res/com/feature_product.dart';
import 'package:pos_account/providers/menu/place_order_pro.dart';
import '../../model/home/booking/all_customer.dart';
import '../../model/home/menu/place_order/all_cus_add_sec.dart';
import '../../model/keypad/keypad_checkout_model.dart';
import '../../services/database/shared_pref.dart';

class KeyPadPro extends ChangeNotifier {
  void get notify => notifyListeners();

  final creditSurCltr = TextEditingController();
  final holidayCltr = TextEditingController();
  final discountCltr = TextEditingController();

  bool isCreditSurChecked = false;
  bool isHolidayChecked = false;
  String curSym = "";
  int num = 0;
  String expression = "";
  String total = "0";
  bool keyPadSubmit = false;
  final notesCltr = TextEditingController();
  var request = KeyPadCheckOutRequestModel();

  void getCurSym() async {
    curSym = await SharedPrefs.curSym;
    notify;
  }

  void onNumTap(String num) {
    if (total == "0") {
      total = num.toString();
    } else {
      if (total.contains('.') && num == '.') {
        return;
      } else {
        total += num.toString();
      }
    }
    notify;
  }

  void onDotTap() {
    if (!total.contains('.')) {
      total += '.';
      notify;
    }
  }

  void onCTap() {
    if (total.isNotEmpty) {
      if (total.length == 1) {
        total = "0";
      } else {
        total = total.substring(0, total.length - 1);
      }
    }
    notify;
  }

  void onClear() {
    total = "0";
    notesCltr.clear();
    notify;
  }

  void onLongTap() {
    total = "0";
    notify;
  }

  FeaturedProduct product = FeaturedProduct();

  void selectProduct({required FeaturedProduct featuredProduct}) {
    product = featuredProduct;
    notify;
  }

  void onAddTapped({required PlaceOrderPro placeOrderPro}) {
    if (product.id != null) {
      if (double.parse(total.toString()) > 0) {
        product.variablePrice = total;
      }
      if (product.productVariations?.isNotEmpty ?? false) {
        // product.productVariations![0].unitPrice = total;
        product.productVariations![0].actualPrice = total;
        product.productVariations![0].discount = null;
        product.productVariations![0].discountPercentage = null;
        // product.productVariations![0].discountedPromotions = null;
      }

      placeOrderPro.updateOrderCart(
        product: product,
        customPrice: total,
        customDesc: notesCltr.text,
        variation: (product.productVariations?.isNotEmpty ?? false)
            ? product.productVariations![0]
            : ProductVariation(),
      );
    }
    total = "0";
    notesCltr.clear();
    notify;
    // placeOrderPro.notify;
  }

  CusData? cusData;
  String? dateFormat;
  CustomerAddSecRes? customerAddSecRes;
  bool loadingCusAddSec = true;

  bool keyPadLoading = true;
  List<FeaturedProduct>? keyPadProducts = [];

  Future<void> getKeyPadProducts(
      {Future<List<FeaturedProduct>>? products}) async {
    // keyPadLoading = true;
    keyPadProducts = [];
    keyPadProducts = await products; // await Handler.getKeypadProducts();
    if (keyPadProducts != null && keyPadProducts!.isNotEmpty) {
      List<FeaturedProduct> updatedProducts = [];

      for (var originalProduct in keyPadProducts!) {
        if (originalProduct.productVariations == null ||
            originalProduct.productVariations!.isEmpty) {
          updatedProducts.add(originalProduct);
        } else {
          for (var variation in originalProduct.productVariations!) {
            variation.actualPrice = total.toString();
            // variation.unitPrice = total.toString();
            updatedProducts.add(
              FeaturedProduct(
                id: originalProduct.id,
                name: originalProduct.name,
                imageUrl: originalProduct.imageUrl,
                productVariations: [variation],
                categoryId: originalProduct.categoryId,
                // categoryTypeId: originalProduct.categoryTypeId,
                productType: originalProduct.productType,
                // isHalfCategory: originalProduct.isHalfCategory,
                salesTax: originalProduct.salesTax,
                docketGroupName: originalProduct.docketGroupName,
                docketGroupSort: originalProduct.docketGroupSort,
                enableDocketGroupSpliter:
                    originalProduct.enableDocketGroupSpliter,
                productDescription: originalProduct.productDescription,
              ),
            );
          }
        }
      }

      keyPadProducts = updatedProducts;
      selectProduct(featuredProduct: keyPadProducts![0]);
    }

    keyPadLoading = false;
    notify;
  }

  bool isProductSelected(FeaturedProduct? data) {
    if (data == null ||
        data.productVariations == null ||
        data.productVariations!.isEmpty ||
        product.productVariations == null ||
        product.productVariations!.isEmpty) {
      return false;
    }
    return data.productVariations!.first.id ==
        product.productVariations!.first.id;
  }

  void clearAll() {
    creditSurCltr.clear();
    holidayCltr.clear();
    discountCltr.clear();
    isCreditSurChecked = false;
    isHolidayChecked = false;
    keyPadProducts = [];
    // keyPadLoading = true;
    product = FeaturedProduct();
    num = 0;
    expression = "";
    total = "0";
    notesCltr.clear();
  }
}
