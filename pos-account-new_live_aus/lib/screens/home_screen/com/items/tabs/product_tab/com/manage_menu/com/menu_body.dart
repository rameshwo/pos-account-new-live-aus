import 'package:flutter/material.dart';
import 'package:pos_account/config/size_config.dart';
import 'package:pos_account/constant/constant.dart';
import 'package:pos_account/widgets/loading.dart';
import 'package:pos_account/widgets/no_items_sec.dart';
import 'package:provider/provider.dart';
import 'package:reorderable_grid_view/reorderable_grid_view.dart';
import '../../../../../../../../../providers/product/manage_prod_pro.dart';
import '../../../../../../../../custom_drawer/custom_drawer.dart';
import '../../../../pos_tab/pos_non_retail/com/item_tile.dart';

class MenuBody extends StatefulWidget {
  const MenuBody({super.key});

  @override
  State<MenuBody> createState() => _MenuBodyState();
}

class _MenuBodyState extends State<MenuBody> {
  late ManageProdPro _manageProdPro;

  @override
  void initState() {
    super.initState();
    _manageProdPro = Provider.of<ManageProdPro>(context, listen: false);

    WidgetsBinding.instance.addPostFrameCallback((_) => _getData());
  }

  void _getData() {
    _manageProdPro.getParentCats();
  }

  @override
  void dispose() {
    _manageProdPro.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = Ssize(context);
    final manageProdPro = Provider.of<ManageProdPro>(context);
    return Processing(
      loading: manageProdPro.loading,
      child: Column(
        children: [
          if (manageProdPro.sortedDataList.isNotEmpty)
            Expanded(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 2,
                    child: ReorderableGridView.builder(
                      shrinkWrap: true,
                      padding: EdgeInsets.only(bottom: size.getH(24)),
                      // physics: BouncingScrollPhysics(),
                      dragStartDelay: Duration(milliseconds: 300),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 4.0,
                        mainAxisSpacing: 4.0,
                        childAspectRatio: 1,
                      ),
                      itemCount: manageProdPro.sortedDataList.length,
                      itemBuilder: (ctx, index) {
                        final _cat = manageProdPro.sortedDataList[index];
                        return DrawerTile(
                          key: ValueKey("${_cat.name}-${_cat.id}"),
                          size: size,
                          catName: _cat.name,
                          isSelected:
                              manageProdPro.selectedCatId?.toLowerCase() ==
                                  _cat.id?.toLowerCase(),
                          isDrawerFocus: true,
                          onTap: () {
                            manageProdPro.selectedCatId = _cat.id;
                            manageProdPro.notify;
                            manageProdPro.getAllAssignedProd(catId: _cat.id);
                          },
                          overlay: _cat.isProdSorted
                              ? Positioned(
                                  top: size.getH(4),
                                  right: size.getW(4),
                                  child: CircleAvatar(
                                    radius: size.getS(4),
                                    backgroundColor: Colors.amber,
                                  ),
                                )
                              : null,
                        );
                      },
                      onReorder: (int oldIndex, int newIndex) {
                        final element =
                            manageProdPro.sortedDataList.removeAt(oldIndex);
                        manageProdPro.sortedDataList.insert(newIndex, element);

                        element.isCatSorted = true;

                        manageProdPro.catSort();
                        manageProdPro.notify;
                      },
                    ),
                  ),
                  Expanded(
                    flex: 11,
                    child: (manageProdPro
                                .productList?.productVariations?.isNotEmpty ??
                            false)
                        ? Card(
                            margin:
                                EdgeInsets.symmetric(horizontal: size.getW(12)),
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: size.getW(12),
                                  vertical: size.getH(8)),
                              child: Column(
                                children: [
                                  Padding(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: size.getW(12)),
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: Text(
                                            manageProdPro.productList
                                                    ?.categoryName ??
                                                '',
                                            style: TextStyle(
                                              fontSize: size.getS(18),
                                              color: Colors.black,
                                              fontFamily: kFontFMedium,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                        Text(
                                          "${manageProdPro.productList?.productVariations?.length ?? ''} products - drag to order",
                                          style: TextStyle(
                                            fontSize: size.getS(14),
                                            color: Colors.black54,
                                          ),
                                        ),
                                        SizedBox(
                                          width: size.getW(12),
                                        ),
                                        Card(
                                          margin: EdgeInsets.zero,
                                          child: InkWell(
                                            onTap: () {
                                              manageProdPro.sortAlpha();
                                            },
                                            child: Padding(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: size.getW(8),
                                                  vertical: size.getH(4)),
                                              child: Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                  Icon(Icons.arrow_downward,
                                                      size: size.getS(18)),
                                                  Column(
                                                    children: [
                                                      SizedBox(
                                                          height: size.getH(4)),
                                                      Text(
                                                        manageProdPro.isAToZ
                                                            ? "a"
                                                            : "z",
                                                        style: TextStyle(
                                                          fontSize:
                                                              size.getS(10),
                                                          height: 0.1,
                                                        ),
                                                      ),
                                                      Text(
                                                        manageProdPro.isAToZ
                                                            ? "z"
                                                            : "a",
                                                        style: TextStyle(
                                                          fontSize:
                                                              size.getS(10),
                                                        ),
                                                      ),
                                                    ],
                                                  )
                                                ],
                                              ),
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    height: size.getH(12),
                                  ),
                                  Expanded(
                                    child: ReorderableGridView.builder(
                                      shrinkWrap: true,
                                      dragStartDelay:
                                          Duration(milliseconds: 300),
                                      padding: EdgeInsets.only(
                                          bottom: size.getH(24),
                                          right: size.getW(12),
                                          left: size.getW(12)),
                                      // physics: BouncingScrollPhysics(),
                                      gridDelegate:
                                          SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 6,
                                        crossAxisSpacing: size.getW(12),
                                        mainAxisSpacing: size.getH(12),
                                        childAspectRatio: 1,
                                      ),
                                      itemCount: manageProdPro.productList!
                                          .productVariations!.length,
                                      itemBuilder: (ctx, index) {
                                        final _product = manageProdPro
                                            .productList!
                                            .productVariations![index];
                                        return Card(
                                          margin: EdgeInsets.zero,
                                          key: ValueKey(
                                              "${_product.name}-${_product.id}"),
                                          child: ItemTile(
                                            size: size,
                                            name: _product.name ?? '',
                                            imgPath: _product.image,
                                            topRight: Container(
                                              margin: EdgeInsets.only(
                                                  right: size.getW(4),
                                                  top: size.getH(4)),
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: size.getW(8),
                                                  vertical: size.getH(4)),
                                              decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  borderRadius:
                                                      BorderRadius.circular(5)),
                                              child: Text(
                                                "${index + 1}",
                                                style: TextStyle(
                                                  fontSize: size.getS(15),
                                                  color: Colors.black,
                                                  fontFamily: kFontFMedium,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                                textAlign: TextAlign.center,
                                              ),
                                            ),
                                          ),
                                        );
                                      },
                                      onReorder: (int oldIndex, int newIndex) {
                                        final element = manageProdPro
                                            .productList!.productVariations!
                                            .removeAt(oldIndex);

                                        manageProdPro
                                            .productList!.productVariations!
                                            .insert(newIndex, element);

                                        manageProdPro.productSort();

                                        manageProdPro.notify;
                                      },
                                    ),
                                  )
                                ],
                              ),
                            ),
                          )
                        : NoItemsSec(size: size, title: "No Product Found"),
                  ),
                ],
              ),
            )
        ],
      ),
    );
  }
}
