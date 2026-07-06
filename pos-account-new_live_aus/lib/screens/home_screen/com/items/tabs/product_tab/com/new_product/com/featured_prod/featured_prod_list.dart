import 'package:flutter/material.dart';
import 'package:pos_account/config/size_config.dart';
import 'package:pos_account/config/utils/utils.dart';
import 'package:pos_account/ln.dart';
import 'package:pos_account/model/common/res_datum.dart';
import 'package:pos_account/providers/product/featured_product_pro.dart';
import 'package:pos_account/widgets/dialog/confirm_dialog.dart';
import 'package:pos_account/widgets/image/network_image_sec.dart';
import 'package:pos_account/widgets/input/text_form/text_form_widget.dart';
import 'package:pos_account/widgets/loading.dart';
import 'package:pos_account/widgets/no_items_sec.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class FeaturedProdList extends StatelessWidget {
  final RefreshController refreshController;
  final Function(bool)? onRefresh;
  const FeaturedProdList({
    super.key,
    required this.refreshController,
    this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    final size = Ssize(context);
    final featuredProd = Provider.of<FeaturedProductPro>(context);
    return Processing(
      loading: featuredProd.screenLoad,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Text(
                LN.productLists,
                style: TextStyle(
                  fontSize: size.getS(18),
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              Spacer(),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 0.0),
                child: SizedBox(
                  width: size.width / 4,
                  child: TextFormWidget(
                    isReq: false,
                    prefixIcon: Icon(
                      Icons.search,
                      size: size.getS(32),
                    ),
                    borderRadius: 5,
                    borderColor: Colors.black12,
                    cltr: featuredProd.searchCltr,
                    hintText: LN.searchFtProduct,
                    onChanged: (String? val) {
                      Utils.handleSearch(
                          callback: () async {
                            featuredProd.screenLoad = true;
                            featuredProd.notify;
                            featuredProd.getData(page: 1);
                          },
                          millisecond: 2000);
                    },
                    suffixIcon: InkWell(
                        onTap: () {
                          if (featuredProd.searchCltr.text.isEmpty) return;
                          featuredProd.searchCltr.clear();
                          featuredProd.screenLoad = true;
                          featuredProd.notify;
                          featuredProd.getData(page: 1);
                        },
                        child: Icon(Icons.close)),
                  ),
                ),
              ),
            ],
          ),
          AnimatedContainer(
            duration: Duration(milliseconds: 300),
            height: featuredProd.selectedIds.length > 1 ? 48 : 0,
            alignment: Alignment.centerRight,
            child: ElevatedButton(
                style: ButtonStyle(
                    backgroundColor:
                        WidgetStateProperty.all(Colors.red.shade700),
                    padding: WidgetStateProperty.all(EdgeInsets.symmetric(
                        horizontal: size.getW(24), vertical: size.getH(8)))),
                onPressed: () {
                  showDialog(
                      context: context,
                      builder: (builder) => ConfirmDialog(
                            title:
                                "${featuredProd.selectedIds.length} products",
                            onDelete: () async {
                              featuredProd.deleteData(
                                  dataList: featuredProd.selectedIds);
                              return null;
                            },
                          ));
                },
                child: Text(
                  LN.delete,
                  style: TextStyle(
                    fontSize: size.getS(16),
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                )),
          ),
          if (featuredProd.featuredList.isNotEmpty)
            Flexible(
              child: SmartRefresher(
                controller: refreshController,
                enablePullUp: true,
                onLoading: onRefresh == null
                    ? null
                    : () {
                        onRefresh!(true);
                      },
                onRefresh: onRefresh == null
                    ? null
                    : () {
                        onRefresh!(false);
                      },
                child: SingleChildScrollView(
                  child: Wrap(
                    children: [
                      ...List.generate(featuredProd.featuredList.length,
                          (index) {
                        final item = featuredProd.featuredList[index];
                        final isSelected = featuredProd.selectedIds
                            .map((e) => e.id)
                            .contains(item.id);

                        return Container(
                          width: size.getW(200),
                          height: size.getH(230),
                          decoration: BoxDecoration(
                              border: Border.all(
                                color: isSelected
                                    ? Colors.red.shade700
                                    : Colors.grey.shade400,
                                width: 2,
                              ),
                              borderRadius: BorderRadius.circular(10)),
                          margin: EdgeInsets.symmetric(
                              vertical: 12, horizontal: 12),
                          child: InkWell(
                            onTap: () {
                              if (item.id == null) return;

                              if (featuredProd.selectedIds
                                  .map((e) => e.id)
                                  .contains(item.id))
                                featuredProd.selectedIds
                                    .removeWhere((f) => f.id == item.id);
                              else
                                featuredProd.selectedIds.add(SRDatum(
                                  id: item.id,
                                  name: item.name,
                                ));
                              featuredProd.notify;
                            },
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                  vertical: 8, horizontal: 16),
                              child: Column(
                                children: [
                                  NetworkImageSec(
                                    image: item.image,
                                    height: 120,
                                  ),
                                  // SizedBox(
                                  //   height: size.getH(4),
                                  // ),
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 4.0),
                                      child: Text(
                                        item.name ?? '',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: size.getS(16),
                                          color: Colors.black,
                                        ),
                                        maxLines: 2,
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  ),
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    // mainAxisSize: MainAxisSize.min,
                                    children: [
                                      // SizedBox(
                                      //   width: size.getW(12),
                                      // ),
                                      ElevatedButton(
                                          style: ButtonStyle(
                                            // visualDensity:
                                            //     VisualDensity.compact,
                                            backgroundColor:
                                                WidgetStateProperty.all(
                                                    Colors.red),
                                          ),
                                          onPressed: () {
                                            // featuredProd.setData(
                                            //     i: index);
                                            final deletedData = SRDatum(
                                              id: item.id,
                                              name: item.name,
                                            );
                                            showDialog(
                                                context: context,
                                                builder: (builder) =>
                                                    ConfirmDialog(
                                                      title: deletedData.name ??
                                                          '',
                                                      onDelete: () async {
                                                        featuredProd.deleteData(
                                                            dataList: [
                                                              deletedData
                                                            ]);
                                                        return null;
                                                      },
                                                    ));
                                          },
                                          child: Text(
                                            LN.delete,
                                            style: TextStyle(
                                              fontSize: size.getS(16),
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          )),
                                      // IconButton(
                                      //     onPressed: () {
                                      //       final _deletedData = SRDatum(
                                      //         id: item.id,
                                      //         name: item.name,
                                      //       );
                                      //       showDialog(
                                      //           context: context,
                                      //           builder: (builder) =>
                                      //               ConfirmDialog(
                                      //                 title: _deletedData
                                      //                         .name ??
                                      //                     '',
                                      //                 onDelete: () {
                                      //                   featuredProd
                                      //                       .deleteData(
                                      //                           dataList: [
                                      //                         _deletedData
                                      //                       ]);
                                      //                 },
                                      //               ));
                                      //     },
                                      //     icon: Icon(
                                      //       Icons.delete_outline,
                                      //       color: Colors.red,
                                      //       size: size.getS(32),
                                      //     ))
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      })
                    ],
                  ),
                ),
              ),
            )
          else if (!featuredProd.screenLoad)
            Align(
              alignment: Alignment.topCenter,
              child: NoItemsSec(
                size: size,
                title: LN.noItemFound,
              ),
              // NotFoundWidget(size: size, title: "No Booking Found"),
            ),
        ],
      ),
    );
  }
}
