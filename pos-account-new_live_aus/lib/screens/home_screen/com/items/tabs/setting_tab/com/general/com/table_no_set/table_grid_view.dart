import 'dart:typed_data';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pos_account/constant/constant.dart';
import 'package:pos_account/widgets/no_items_sec.dart';

import '../../../../../../../../../../config/size_config.dart';
import '../../../../../../../../../../ln.dart';
import '../../../../../../../../../../model/home/setting/general/category/restro_table_model.dart';
import '../../../../../../../../../../providers/setting/general/all_table_no_pro.dart';
import '../../../../../../../../../../widgets/image/image_error.dart';
import '../../../../../../../../../../widgets/paginate_sec.dart';
import 'com/show_table_qr_dia.dart';

// ignore: must_be_immutable
class TableGridView extends StatelessWidget {
  final RTableData tableData;
  AllTableNumPro atnp;
  TabController tabController;
  dynamic page;
  final Function() onsave;
  dynamic total;

  // A cache map to hold already decoded images (optional, for memory cache management)
  final Map<String, Uint8List> imageCache = {};

  TableGridView({
    super.key,
    required this.tableData,
    required this.atnp,
    this.page = 0,
    required this.tabController,
    this.total = 0,
    required this.onsave,
  });

  showTableQRDia({required BuildContext ctx}) {
    return showDialog(
        context: ctx,
        builder: (builder) => SimpleDialog(
              backgroundColor: kBackgroundColor,
              titlePadding: EdgeInsets.zero,
              contentPadding: EdgeInsets.symmetric(horizontal: 24, vertical: 0),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15)),
              children: [ShowTableQRDia()],
            ));
  }

  @override
  Widget build(BuildContext context) {
    final size = Ssize(context);
    return Padding(
      padding: const EdgeInsets.all(2.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          // Text(
          //   LN.tables,
          //   style: TextStyle(
          //     fontSize: size.getW(22),
          //     fontWeight: FontWeight.bold,
          //   ),
          // ),
          // SizedBox(height: size.getH(20)),
          tableData.tableDataList.isEmpty
              ? NoItemsSec(
                  title: "No Table",
                  size: size,
                )
              : GridView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: size.isProt ? 2 : 3,
                      crossAxisSpacing: 20,
                      mainAxisSpacing: 20,
                      childAspectRatio: 2),
                  itemBuilder: (context, index) {
                    final table = tableData.tableDataList[index];

                    // Check if the image is already in cache
                    // String imageKey = table.id
                    //     .toString(); // Use a unique key (e.g., table ID)
                    // Uint8List bytes = imageCache[imageKey] ?? Uint8List(0);

                    // if (bytes.isEmpty && table.itemList.last != "") {
                    //   bytes = base64Decode(table.itemList.last);
                    //   imageCache[imageKey] = bytes; // Cache the decoded image
                    // }

                    return Card(
                      elevation: 5,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.white,
                        ),
                        child: Column(
                          children: [
                            Expanded(
                              flex: 3,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 15, vertical: 15),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      flex: 3,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            table.itemList.first,
                                            style: TextStyle(
                                              fontSize: size.getW(16),
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          SizedBox(height: size.getH(5)),
                                          Text(
                                            table.statusList.first ==
                                                    TableStatus.Active
                                                ? LN.active
                                                : LN.inActive,
                                            style: TextStyle(
                                              fontSize: size.getW(12),
                                              color: table.statusList.first ==
                                                      TableStatus.Active
                                                  ? Colors.green
                                                  : table.statusList.first ==
                                                          TableStatus.Inactive
                                                      ? Colors.red
                                                      : Colors.amber,
                                            ),
                                          ),
                                          SizedBox(height: size.getH(2)),
                                          Text.rich(
                                            TextSpan(
                                              text: "${LN.adult}: ",
                                              style: TextStyle(
                                                fontSize: size.getW(13),
                                                color: Colors.grey,
                                              ),
                                              children: [
                                                TextSpan(
                                                  text: table.itemList[
                                                      table.itemList.length -
                                                          3],
                                                  style: TextStyle(
                                                    fontSize: size.getW(13),
                                                    color: Colors.black,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          SizedBox(height: size.getH(5)),
                                          Text.rich(
                                            TextSpan(
                                              text: "${LN.child}: ",
                                              style: TextStyle(
                                                fontSize: size.getW(13),
                                                color: Colors.grey,
                                              ),
                                              children: [
                                                TextSpan(
                                                  text: table.itemList[
                                                      table.itemList.length -
                                                          2],
                                                  style: TextStyle(
                                                    fontSize: size.getW(13),
                                                    color: Colors.black,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Expanded(
                                        flex: 2,
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 10.0),
                                          child: InkWell(
                                            onTap: atnp.loading
                                                ? null
                                                : () {
                                                    atnp
                                                        .getTableQr(
                                                            tableId: table.id)
                                                        .then((_) {
                                                      if (atnp.tableQrList !=
                                                          null)
                                                        showTableQRDia(
                                                            ctx: context);
                                                    });
                                                  },
                                            child: Card(
                                              elevation: 2,
                                              margin: EdgeInsets.zero,
                                              child: Container(
                                                  height: double.maxFinite,
                                                  width: double.maxFinite,
                                                  decoration: BoxDecoration(
                                                    border: Border.all(
                                                      color: Colors.grey[200]!,
                                                    ),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            5),
                                                  ),
                                                  child: CachedNetworkImage(
                                                    imageUrl:
                                                        table.itemList.last,
                                                    height: size.getH(160),
                                                    width: double.infinity,
                                                    fit: BoxFit.cover,
                                                    placeholder:
                                                        ImageError.load,
                                                    errorWidget: ImageError
                                                        .notSupportIcon,
                                                  )

                                                  //  Image.memory(bytes,
                                                  //     fit: BoxFit.contain,
                                                  //     // key: ValueKey(imageKey),
                                                  //     gaplessPlayback: true,
                                                  //     errorBuilder: (context,
                                                  //         error, stackTrace) {
                                                  //   return ImageError.icon(
                                                  //       context, "", "");
                                                  // }),
                                                  ),
                                            ),
                                          ),
                                        ))
                                  ],
                                ),
                              ),
                            ),
                            Divider(
                              color: Colors.grey[300],
                              thickness: 0.5,
                              height: 0,
                            ),
                            Expanded(
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.grey[100],
                                  borderRadius: BorderRadius.only(
                                    bottomLeft: Radius.circular(10),
                                    bottomRight: Radius.circular(10),
                                  ),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      CustomIconBtn(
                                        icon: "edit",
                                        onTap: () {
                                          atnp
                                              .getEditData(id: table.id)
                                              .then((val) {
                                            if (val ?? false) {
                                              tabController.animateTo(1);
                                              Future.delayed(
                                                  Duration(milliseconds: 500),
                                                  () {
                                                atnp.notify();
                                              });
                                            }
                                          });
                                        },
                                        color: kSecondaryColor,
                                      ),
                                      CustomIconBtn(
                                        icon: "qr-code",
                                        onTap: () {
                                          atnp
                                              .getTableQr(tableId: table.id)
                                              .then((_) {
                                            if (atnp.tableQrList != null)
                                              showTableQRDia(ctx: context);
                                          });
                                        },
                                        color: kSecondaryColor,
                                      ),
                                      CustomIconBtn(
                                        icon: "generate",
                                        onTap: () {
                                          atnp
                                              .generateQr(tableId: table.id)
                                              .then(((value) {
                                            atnp
                                                .getData()
                                                .then((value) => atnp.notify());
                                          }));
                                        },
                                        color: kSecondaryColor,
                                      ),
                                      CustomIconBtn(
                                        icon: "delete 2",
                                        onTap: () {
                                          // showDialog(
                                          //     context: context,
                                          //     builder: (builder) => ConfirmDialog(
                                          //           title: table.itemList.first,
                                          //           onDelete: () async {
                                          //             atnp.deleteData(
                                          //                 dataList:
                                          //                     List<SRDatum>.from([
                                          //               table
                                          //                   .itemList[index]
                                          //             ]));
                                          //             return null;
                                          //           },
                                          //         ));
                                        },
                                        color: kTempColor,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                  itemCount: tableData.tableDataList.length),
          SizedBox(height: size.getH(20)),
          Visibility(
            visible: tableData.tableDataList.length < total,
            child: Center(
              child: PaginateButton(
                total: total,
                prev: () {
                  atnp
                      .getData(
                        page: page - 1,
                      )
                      .then((_) => atnp.notify());
                },
                pageIndex: page,
                pageSize: 9,
                next: () {
                  atnp
                      .getData(
                        page: page + 1,
                      )
                      .then((_) => atnp.notify());
                },
              ),
            ),
          )
        ],
      ),
    );
  }
}

Widget CustomIconBtn(
    {required dynamic icon,
    required Function() onTap,
    Color color = Colors.grey}) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 5),
    child: InkWell(
      onTap: onTap,
      child: SvgPicture.asset("assets/svg/icons/$icon.svg",
          // height: 30,
          // width: 30,
          color: color),
    ),
  );
}
