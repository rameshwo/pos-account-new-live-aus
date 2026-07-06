import 'package:flutter/material.dart';
import 'package:pos_account/config/size_config.dart';
import 'package:pos_account/ln.dart';
import 'package:pos_account/providers/kitchen/kitchen_pro.dart';
import 'package:pos_account/widgets/dialog/confirm_dialog.dart';
import 'package:pos_account/widgets/loading.dart';
import 'package:pos_account/widgets/no_items_sec.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'kit_order_tile.dart';

class KitchenBody extends StatefulWidget {
  const KitchenBody({super.key});

  @override
  State<KitchenBody> createState() => _KitchenBodyState();
}

class _KitchenBodyState extends State<KitchenBody> {
  List<KitOrderItem> get _items => _kitPro?.orderList ?? [];

  final _scrollCltr = ScrollController();
  KitchenPro? _kitPro;

  // smart refresh
  final refreshCltr = RefreshController(initialRefresh: false);

  void paginate(int page) {
    _kitPro?.getData(page: page).then((_) {
      if (page == 1) {
        refreshCltr.refreshCompleted();
      } else {
        refreshCltr.loadComplete();
      }
    });
  }

  @override
  void dispose() {
    _scrollCltr.dispose();
    refreshCltr.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = Ssize(context);
    _kitPro = Provider.of<KitchenPro>(context);

    final kitOrderStatus = _kitPro!.kitOrderStatus;

    // return Processing(
    //   loading: _kitPro?.loading ?? false,
    //   align: Alignment.topLeft,
    //   child: SizedBox(
    //     width: double.infinity,
    //     child: (_items.isEmpty && !(_kitPro?.loading ?? false))
    //         ? NoItemsSec(size: size, title: "No Order Found")
    //         : Scrollbar(
    //             controller: _scrollCltr,
    //             isAlwaysShown: true,
    //             showTrackOnHover: true,
    //             trackVisibility: true,
    //             thickness: 12,
    //             radius: Radius.circular(5),
    //             interactive: true,
    //             child: SmartRefresher(
    //               controller: refreshCltr,
    //               scrollController: _scrollCltr,
    //               enablePullUp: true,
    //               onLoading: () {
    //                 paginate(_kitPro!.pageIndex + 1);
    //               },
    //               onRefresh: () {
    //                 paginate(1);
    //               },
    //               child: ReorderableGridView.count(
    //                 shrinkWrap: true,
    //                 controller: _scrollCltr,
    //                 padding: EdgeInsets.fromLTRB(
    //                     size.getW(12), 0, size.getW(12), size.getH(12)),
    //                 crossAxisCount: 4,
    //                 childAspectRatio: 0.5,
    //                 mainAxisSpacing: 0,
    //                 crossAxisSpacing: 0,
    //                 onReorder: (oldIndex, newIndex) {
    //                   final _data = _items.removeAt(oldIndex);
    //                   // _data.orderData.prioritizeSortOrder = "1";
    //                   _items.insert(newIndex, _data);
    //                   _kitPro!.notify;
    //                   _kitPro?.priorOrder(false);
    //                 },
    //                 children: List.generate(
    //                   _items.length,
    //                   (index) {
    //                     final _key =
    //                         "${_items[index].orderData.id}_${_items[index].tempId}";
    //                     return AnimatedOpacity(
    //                       key: ValueKey("$index _$_key"),
    //                       duration: Duration(milliseconds: 200),
    //                       opacity: _items[index].showOpa ? 1 : 0,
    //                       child: AnimatedContainer(
    //                         key: ValueKey("$_key _$index"),
    //                         width: _items[index].show
    //                             ? size.getW(size.isProt ? 320 : 352)
    //                             : 0,
    //                         duration: Duration(milliseconds: 400),
    //                         curve: Curves.easeInOut,
    //                         child: KitOrderTile(
    //                           // key: ValueKey(index),
    //                           // i: index,
    //                           kitPro: _kitPro,
    //                           data: _items[index].orderData,
    //                           priotize: _kitOrderStatus ==
    //                                   KitOrderStatusEnum.Preparing
    //                               ? (bool val) async {
    //                                   if (_kitPro!.isPriotizing) return;
    //                                   final _temp = KitOrderItem.fromJson(
    //                                       _items[index].toJson());

    //                                   if (!val) {
    //                                     _temp.orderData.prioritizeSortOrder =
    //                                         "1";
    //                                     if (index == 0) {
    //                                       _items[index]
    //                                           .orderData
    //                                           .prioritizeSortOrder = "1";
    //                                       _kitPro!.notify;
    //                                     } else {
    //                                       await _kitPro!.removeItem(index);
    //                                       await _kitPro!.addItem(_temp);
    //                                     }
    //                                     _kitPro?.priorOrder(val);
    //                                   } else {
    //                                     showDialog(
    //                                         context: context,
    //                                         builder: (builder) => ConfirmDialog(
    //                                               title:
    //                                                   "UnPrioritize ${_items[index].orderData.orderNumber}",
    //                                               subTitle:
    //                                                   "Are you sure you want to unpriotize order?",
    //                                               actionText: LN.yes,
    //                                               cancelText: LN.no,
    //                                               onDelete: () async {
    //                                                 await _kitPro!
    //                                                     .removeItem(index);
    //                                                 _temp.orderData
    //                                                         .prioritizeSortOrder =
    //                                                     "0";
    //                                                 final _lastZeroIndex = _items
    //                                                         .any((e) =>
    //                                                             (double.tryParse(e
    //                                                                         .orderData
    //                                                                         .prioritizeSortOrder ??
    //                                                                     '') ??
    //                                                                 0) ==
    //                                                             0)
    //                                                     ? _items.indexWhere((e) =>
    //                                                         (double.tryParse(e
    //                                                                     .orderData
    //                                                                     .prioritizeSortOrder ??
    //                                                                 '') ??
    //                                                             0) ==
    //                                                         0)
    //                                                     : _items.length;

    //                                                 await _kitPro!.addItem(
    //                                                     _temp,
    //                                                     index: _lastZeroIndex);
    //                                                 _kitPro?.priorOrder(val,
    //                                                     orderId:
    //                                                         _temp.orderData.id);
    //                                                 return null;
    //                                               },
    //                                             ));
    //                                   }
    //                                 }
    //                               : null,
    //                           //  _onReorder(index, 0),
    //                           kitStatus: _kitPro!.kitOrderStatus,
    //                           onStart: _kitPro?.loadingId ==
    //                                   _items[index].orderData.id
    //                               ? null
    //                               : (_kitPro?.loading ?? false)
    //                                   ? () {}
    //                                   : () async {
    //                                       if (_kitPro!.kitOrderStatus ==
    //                                           KitOrderStatusEnum.NewOrders) {
    //                                         final _status = await _kitPro
    //                                             ?.updateOrderStatus(
    //                                           _items[index].orderData.id,
    //                                           kitOrSt:
    //                                               KitOrderStatusEnum.Preparing,
    //                                         );
    //                                         if (_status ?? false) {
    //                                           await _kitPro!.removeItem(index);
    //                                         }
    //                                       } else if (_kitPro!.kitOrderStatus ==
    //                                           KitOrderStatusEnum.Preparing) {
    //                                         final _status = await _kitPro
    //                                             ?.updateOrderStatus(
    //                                           _items[index].orderData.id,
    //                                           kitOrSt:
    //                                               KitOrderStatusEnum.Completed,
    //                                         );
    //                                         if (_status ?? false) {
    //                                           await _kitPro!.removeItem(index);
    //                                         }
    //                                       } else if (_kitPro!.kitOrderStatus ==
    //                                           KitOrderStatusEnum.Completed) {
    //                                         showDialog(
    //                                             context: context,
    //                                             builder: (builder) =>
    //                                                 ConfirmDialog(
    //                                                   title:
    //                                                       "Recall ${_items[index].orderData.orderNumber}",
    //                                                   subTitle:
    //                                                       "You can recall order if the order is not completed yet.",
    //                                                   actionText: "Preparing",
    //                                                   cancelText: LN.cancel,
    //                                                   onDelete: () async {
    //                                                     final _status =
    //                                                         await _kitPro
    //                                                             ?.updateOrderStatus(
    //                                                       _items[index]
    //                                                           .orderData
    //                                                           .id,
    //                                                       kitOrSt:
    //                                                           KitOrderStatusEnum
    //                                                               .Preparing,
    //                                                     );
    //                                                     if (_status ?? false) {
    //                                                       await _kitPro!
    //                                                           .removeItem(
    //                                                               index);
    //                                                     }
    //                                                     return null;
    //                                                   },
    //                                                 ));
    //                                       }
    //                                     },
    //                         ),
    //                       ),
    //                     );
    //                   },
    //                 ),
    //               ),
    //             ),
    //           ),
    //   ),
    // );

    return Processing(
      loading: _kitPro?.loading ?? false,
      align: Alignment.topLeft,
      child: SizedBox(
        width: double.infinity,
        child: (_items.isEmpty && !(_kitPro?.loading ?? false))
            ? NoItemsSec(size: size, title: "No Order Found")
            : Scrollbar(
                controller: _scrollCltr,
                thumbVisibility: true,
                trackVisibility: true,
                thickness: 12,
                radius: Radius.circular(5),
                interactive: true,
                child: SmartRefresher(
                  controller: refreshCltr,
                  scrollController: _scrollCltr,
                  enablePullUp: true,
                  onLoading: () {
                    paginate(_kitPro!.pageIndex + 1);
                  },
                  onRefresh: () {
                    paginate(1);
                  },
                  child: ListView(
                    shrinkWrap: true,
                    controller: _scrollCltr,
                    children: [
                      // ElevatedButton(
                      //     onPressed: () {
                      //       final _temp = KitOrderItem.fromJson(_items.last.toJson());
                      //       _addItem(_temp);
                      //     },
                      //     child: Text('Add')),

                      Wrap(
                        children: List.generate(
                          _items.length,
                          (index) {
                            final key =
                                "${_items[index].orderData.id}_${_items[index].tempId}";
                            return AnimatedOpacity(
                              key: ValueKey("$index _$key"),
                              duration: Duration(milliseconds: 200),
                              opacity: _items[index].showOpa ? 1 : 0,
                              child: AnimatedContainer(
                                key: ValueKey("$key _$index"),
                                width: _items[index].show
                                    ? size.getW(size.isProt ? 320 : 352)
                                    : 0,
                                duration: Duration(milliseconds: 400),
                                curve: Curves.easeInOut,
                                child: KitOrderTile(
                                  // key: ValueKey(index),
                                  kitPro: _kitPro,
                                  data: _items[index].orderData,
                                  priotize: kitOrderStatus ==
                                          KitOrderStatusEnum.Preparing
                                      ? (bool val) async {
                                          if (_kitPro!.isPriotizing) return;
                                          final temp = KitOrderItem.fromJson(
                                              _items[index].toJson());

                                          if (!val) {
                                            temp.orderData.prioritizeSortOrder =
                                                "1";
                                            if (index == 0) {
                                              _items[index]
                                                  .orderData
                                                  .prioritizeSortOrder = "1";
                                              _kitPro!.notify;
                                            } else {
                                              await _kitPro!.removeItem(index);
                                              await _kitPro!.addItem(temp);
                                            }
                                            _kitPro?.priorOrder(val);
                                          } else {
                                            showDialog(
                                                context: context,
                                                builder: (builder) =>
                                                    ConfirmDialog(
                                                      title:
                                                          "UnPrioritize ${_items[index].orderData.orderNumber}",
                                                      subTitle:
                                                          "Are you sure you want to unpriotize order?",
                                                      actionText: LN.yes,
                                                      cancelText: LN.no,
                                                      onDelete: () async {
                                                        await _kitPro!
                                                            .removeItem(index);
                                                        temp.orderData
                                                                .prioritizeSortOrder =
                                                            "0";
                                                        final lastZeroIndex = _items
                                                                .any((e) =>
                                                                    (double.tryParse(e.orderData.prioritizeSortOrder ??
                                                                            '') ??
                                                                        0) ==
                                                                    0)
                                                            ? _items.indexWhere((e) =>
                                                                (double.tryParse(e
                                                                            .orderData
                                                                            .prioritizeSortOrder ??
                                                                        '') ??
                                                                    0) ==
                                                                0)
                                                            : _items.length;

                                                        await _kitPro!.addItem(
                                                            temp,
                                                            index:
                                                                lastZeroIndex);
                                                        _kitPro?.priorOrder(val,
                                                            orderId: temp
                                                                .orderData.id);
                                                        return null;
                                                      },
                                                    ));
                                          }
                                        }
                                      : null,
                                  //  _onReorder(index, 0),
                                  kitStatus: kitOrderStatus,
                                  onStart: _kitPro?.loadingId ==
                                          _items[index].orderData.id
                                      ? null
                                      : (_kitPro?.loading ?? false)
                                          ? () {}
                                          : () async {
                                              if (kitOrderStatus ==
                                                  KitOrderStatusEnum
                                                      .NewOrders) {
                                                final status = await _kitPro
                                                    ?.updateOrderStatus(
                                                  _items[index].orderData.id,
                                                  kitOrSt: KitOrderStatusEnum
                                                      .Preparing,
                                                );
                                                if (status ?? false) {
                                                  await _kitPro!
                                                      .removeItem(index);
                                                }
                                              } else if (kitOrderStatus ==
                                                  KitOrderStatusEnum
                                                      .Preparing) {
                                                final status = await _kitPro
                                                    ?.updateOrderStatus(
                                                  _items[index].orderData.id,
                                                  kitOrSt: KitOrderStatusEnum
                                                      .Completed,
                                                );
                                                if (status ?? false) {
                                                  await _kitPro!
                                                      .removeItem(index);
                                                }
                                              } else if (kitOrderStatus ==
                                                  KitOrderStatusEnum
                                                      .Completed) {
                                                showDialog(
                                                    context: context,
                                                    builder: (builder) =>
                                                        ConfirmDialog(
                                                          title:
                                                              "Recall ${_items[index].orderData.orderNumber}",
                                                          subTitle:
                                                              "You can recall order if the order is not completed yet.",
                                                          actionText:
                                                              "Preparing",
                                                          cancelText: LN.cancel,
                                                          onDelete: () async {
                                                            final status =
                                                                await _kitPro
                                                                    ?.updateOrderStatus(
                                                              _items[index]
                                                                  .orderData
                                                                  .id,
                                                              kitOrSt:
                                                                  KitOrderStatusEnum
                                                                      .Preparing,
                                                            );
                                                            if (status ??
                                                                false) {
                                                              await _kitPro!
                                                                  .removeItem(
                                                                      index);
                                                            }
                                                            return null;
                                                          },
                                                        ));
                                              }
                                            },
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
      ),
    );
  }

  // void _onReorder(int oldIndex, int newIndex) {
  //   setState(() {
  //     if (newIndex > oldIndex) {
  //       newIndex -= 1;
  //     }
  //     final item = _items.removeAt(oldIndex);
  //     _items.insert(newIndex, item);
  //   });
  // }
}
