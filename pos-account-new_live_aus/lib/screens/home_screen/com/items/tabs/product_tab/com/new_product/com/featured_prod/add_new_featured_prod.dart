import 'package:flutter/material.dart';
import 'package:oktoast/oktoast.dart';
import 'package:pos_account/config/size_config.dart';
import 'package:pos_account/config/utils/utils.dart';
import 'package:pos_account/constant/constant.dart';
import 'package:pos_account/ln.dart';
import 'package:pos_account/providers/product/featured_product_pro.dart';
import 'package:provider/provider.dart';
import '../adons_section.dart';

class AddNewFeaturedProdSection extends StatelessWidget {
  final FocusNode focusNode;
  const AddNewFeaturedProdSection({super.key, required this.focusNode});

  @override
  Widget build(BuildContext context) {
    final size = Ssize(context);
    final featuredProd = Provider.of<FeaturedProductPro>(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          height: size.getH(12),
        ),
        Flexible(
          child: AdonsSection(
            title: LN.product,
            textWidth: 200,
            focusNode: focusNode,
            textCltr: featuredProd.adonTextCltr,
            itemList: featuredProd.adonList.map((e) => e.name).toList(),
            onSubmit: (p0) {
              if (p0.isEmpty || featuredProd.adonSuggestion == null) return;

              final addOnList = featuredProd.adonSuggestion!;
              // if (!_addOnList
              //     .map((e) => e.name)
              //     .toList()
              //     .contains(p0)) {
              //   featuredProd.adonTextCltr.clear();
              //   return;
              // }

              final addOn = addOnList.any((f) => f.name?.trim() == p0.trim())
                  ? addOnList.firstWhere((f) => f.name?.trim() == p0.trim())
                  : null;

              if (addOn == null ||
                  featuredProd.adonList.any((e) => e.productId == addOn.id)) {
                featuredProd.adonTextCltr.clear();
                showToast(LN.alreadyExists);
                return;
              }

              featuredProd.adonList.add(AdonsModel(
                name: addOn.name ?? '',
                productId: addOn.id ?? '',
              ));

              featuredProd.adonTextCltr.clear();
              featuredProd.adonSuggestion = null;
              featuredProd.notify;
            },
            onRemove: (i) {
              featuredProd.adonList.removeAt(i);
              featuredProd.notify;
            },
            onChanged: (p0) {
              Utils.handleSearch(callback: () async {
                await featuredProd.getAdonSuggest(keyWord: p0);
              });
            },
            suggestion: featuredProd.adonSuggestion == null ||
                    featuredProd.adonSuggestion!.isEmpty
                ? []
                : featuredProd.adonSuggestion!
                    .map((e) => e.name!)
                    .toSet()
                    .toList(),
          ),
        ),
        SizedBox(
          height: size.getH(12),
        ),
        Row(
          children: [
            ElevatedButton(
                style: ButtonStyle(
                    backgroundColor: WidgetStateProperty.all(kSecondaryColor),
                    padding: WidgetStateProperty.all(EdgeInsets.symmetric(
                        horizontal: size.getW(24), vertical: 8))),
                onPressed: () {
                  if (featuredProd.adonList.isEmpty) {
                    showToast(LN.emptyAdons);
                    return;
                  }

                  featuredProd.addData();
                },
                child: Text(
                  featuredProd.adonList.any((e) => e.id.isNotEmpty)
                      ? LN.update
                      : LN.save,
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                )),
            SizedBox(
              width: size.getW(12),
            ),
            if (featuredProd.adonList.any((e) => e.id.isNotEmpty))
              ElevatedButton(
                  style: ButtonStyle(
                      backgroundColor:
                          WidgetStateProperty.all(Colors.red.shade700),
                      padding: WidgetStateProperty.all(EdgeInsets.symmetric(
                          horizontal: size.getW(24), vertical: 8))),
                  onPressed: () {
                    featuredProd.clear();
                    featuredProd.notify;
                  },
                  child: Text(
                    LN.cancel,
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  )),
          ],
        ),
      ],
    );
  }
}
