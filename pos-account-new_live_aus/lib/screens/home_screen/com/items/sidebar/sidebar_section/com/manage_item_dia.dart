import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:pos_account/config/utils/order_utils.dart';
import 'package:pos_account/config/size_config.dart';
import 'package:pos_account/constant/constant.dart';
import 'package:pos_account/ln.dart';
import 'package:pos_account/model/home/menu/place_order/place_order_req.dart';
import 'package:pos_account/providers/menu/place_order_pro.dart';
import 'package:pos_account/widgets/image/image_error.dart';
import 'package:pos_account/widgets/load_btn.dart';
import 'package:provider/provider.dart';

class ManageItemsPage extends StatefulWidget {
  const ManageItemsPage({super.key});

  @override
  State<ManageItemsPage> createState() => _ManageItemsPageState();
}

class _ManageItemsPageState extends State<ManageItemsPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _setData();
    });
  }

  final Map<String, List<OrderDetail>> _grouped = {};
  String? _releaseId;
  String? _holdId;

  void _setData() {
    final _placeOr = Provider.of<PlaceOrderPro>(context, listen: false);
    _grouped.clear();

    _releaseId = OrderUtils.getStatusId(OrderStatusEnum.release);
    _holdId = OrderUtils.getStatusId(OrderStatusEnum.hold);

    final List<OrderDetail> _noDocket = [];

    for (var item in _placeOr.orderList) {
      item.groupSelect = _holdId != null &&
          item.statusId?.toLowerCase() == _holdId?.toLowerCase();

      final dn = (item.docketGroupName ?? "").toString().trim();

      if (dn.isEmpty) {
        _noDocket.add(item);
      } else {
        _grouped.putIfAbsent(dn, () => []);
        _grouped[dn]!.add(item);
      }
    }

    if (_noDocket.isNotEmpty) {
      _grouped["Others"] = _noDocket; // You can rename this key as you want
    }

    _placeOr.notify;
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Color get primaryColor => kSecondaryColor;

  void toggleItemSelection(OrderDetail item) {
    item.groupSelect = !item.groupSelect;
    placeOrderPro.notify;
  }

  void toggleGroupSelection(List<OrderDetail> group) {
    final allSelected = group.every((item) => item.groupSelect);

    if (allSelected) {
      group.forEach((a) => a.groupSelect = false);
    } else {
      group.forEach((a) => a.groupSelect = true);
    }

    placeOrderPro.notify;
  }

  void handleCreateOrder() {
    placeOrderPro.orderList.forEach((a) {
      if (a.groupSelect) {
        a.statusId = _holdId;
      } else {
        a.statusId = _releaseId;
      }
      a.groupSelect = false;
    });

    Navigator.of(context).pop(true);
  }

  void handleClose() {
    placeOrderPro.orderList.forEach((a) => a.groupSelect = false);
    Navigator.of(context).pop();
  }

  late PlaceOrderPro placeOrderPro;

  @override
  Widget build(BuildContext context) {
    final size = Ssize(context);
    placeOrderPro = Provider.of<PlaceOrderPro>(context);
    return SimpleDialog(
      titlePadding: EdgeInsets.zero,
      contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      children: [
        Container(
          constraints: BoxConstraints(
            maxHeight: size.height / 1.14,
            minHeight: size.height / 5,
          ),
          width: size.width / 1.2,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: EdgeInsets.all(size.getS(8)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text.rich(
                      TextSpan(text: 'Manage Items', children: [
                        TextSpan(
                          text: ' (Click an item to place it on hold)',
                          style: TextStyle(
                            fontSize: size.getS(16),
                            fontWeight: FontWeight.normal,
                          ),
                        )
                      ]),
                      style: TextStyle(
                        fontSize: size.getS(20),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.close, size: size.getS(25)),
                      onPressed: handleClose,
                    ),
                  ],
                ),
              ),
              TabBar(
                indicatorColor: Colors.transparent,
                labelColor: Colors.white,
                isScrollable: true,
                controller: _tabController,
                unselectedLabelColor: Colors.black,
                indicator: BoxDecoration(
                  color: kPrimaryColor,
                ),
                labelStyle: TextStyle(
                  fontSize: size.getS(16),
                  fontFamily: kFontFMedium,
                ),
                labelPadding: EdgeInsets.zero,
                indicatorPadding: EdgeInsets.zero,
                padding: EdgeInsets.only(left: size.getW(8)),
                tabs: ['Items', 'Group Items']
                    .map((group) => _tabWidget(size, title: group))
                    .toList(),
              ),
              Flexible(
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    _buildItemsTab(size),
                    _buildGroupItemsTab(size),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  border: Border(
                    top: BorderSide(color: Colors.grey.shade300, width: 1),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    LoadButton(
                      btnText: LN.close,
                      btnColor: Colors.red.shade600,
                      onsave: handleClose,
                    ),
                    SizedBox(
                      width: size.getW(12),
                    ),
                    LoadButton(
                      btnText: 'Confirm',
                      onsave: handleCreateOrder,
                    ),
                  ],
                ),
              ),
            ],
          ),
        )
      ],
    );
  }

  Widget _tabWidget(Ssize size, {String? title}) {
    return Container(
      decoration: BoxDecoration(
        border: Border.symmetric(
          vertical: BorderSide(
            color: Colors.white,
            width: 2,
          ),
        ),
      ),
      padding: EdgeInsets.symmetric(
        horizontal: size.getW(16),
      ),
      child: Tab(
        iconMargin: EdgeInsets.zero,
        child: Text(
          title ?? '',
        ),
      ),
    );
  }

  Widget _buildItemsTab(Ssize size) {
    return Padding(
      padding: EdgeInsets.all(size.getS(8)),
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 5,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: 3.1,
        ),
        itemCount: placeOrderPro.orderList.length,
        itemBuilder: (context, index) {
          final item = placeOrderPro.orderList[index];

          return _itemWidget(size, item: item);
        },
      ),
    );
  }

  Widget _buildGroupItemsTab(Ssize size) {
    return ListView.builder(
      padding: EdgeInsets.all(size.getS(8)),
      itemCount: _grouped.entries.toList().length,
      itemBuilder: (context, groupIndex) {
        final entries = _grouped.entries.toList()[groupIndex];
        final allSelected = entries.value.every((_item) => _item.groupSelect);

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GestureDetector(
              onTap: () => toggleGroupSelection(entries.value),
              child: Row(
                children: [
                  Container(
                    width: size.getS(20),
                    height: size.getS(20),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color:
                            allSelected ? primaryColor : Colors.grey.shade400,
                        width: 2,
                      ),
                      borderRadius: BorderRadius.circular(4),
                      color: allSelected ? primaryColor : Colors.transparent,
                    ),
                    child: allSelected
                        ? Icon(Icons.check,
                            color: Colors.white, size: size.getS(14))
                        : null,
                  ),
                  SizedBox(width: size.getW(8)),
                  Text(
                    entries.key,
                    style: TextStyle(
                      fontSize: size.getS(18),
                      fontWeight: FontWeight.bold,
                      color: allSelected ? primaryColor : Colors.black,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: size.getS(8)),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 5,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 3.1,
              ),
              itemCount: entries.value.length,
              itemBuilder: (context, itemIndex) {
                final item = entries.value[itemIndex];

                return _itemWidget(size, item: item);
              },
            ),
            SizedBox(height: size.getH(24)),
          ],
        );
      },
    );
  }

  Widget _itemWidget(Ssize size, {required OrderDetail item}) {
    return GestureDetector(
      onTap: () => toggleItemSelection(item),
      child: Stack(
        children: [
          Container(
            margin: EdgeInsets.only(top: size.getH(8), right: size.getW(8)),
            decoration: BoxDecoration(
              border: Border.all(
                color: item.groupSelect ? primaryColor : Colors.grey.shade300,
                width: 2,
              ),
              borderRadius: BorderRadius.circular(8),
              color: item.groupSelect
                  ? primaryColor.withOpacity(0.1)
                  : Colors.white,
            ),
            alignment: Alignment.center,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: CachedNetworkImage(
                    imageUrl: item.imgPath ?? '',
                    height: size.getS(60),
                    width: size.getS(60),
                    fit: BoxFit.cover,
                    placeholder: ImageError.load,
                    errorWidget: ImageError.icon,
                  ),
                ),
                // Container(
                //   width: size.getS(60),
                //   height: size.getS(60),
                //   decoration: BoxDecoration(
                //     color: Colors.grey.shade200,
                //     borderRadius: BorderRadius.circular(8),
                //   ),
                //   child: Icon(Icons.image,
                //       size: size.getS(40), color: Colors.grey),
                // ),
                SizedBox(width: size.getW(8)),
                Expanded(
                  child: Text(
                    item.productName ?? '',
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      fontSize: size.getS(16),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
          if (item.groupSelect)
            Positioned(
                top: 0,
                right: 0,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.amber.shade800,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  padding: EdgeInsets.symmetric(
                      horizontal: size.getW(12), vertical: size.getH(2)),
                  child: Text(
                    "Hold",
                    style: TextStyle(
                      fontSize: size.getS(14),
                      color: Colors.white,
                      fontFamily: kFontFMedium,
                    ),
                  ),
                )

                // Container(
                //   width: size.getS(24),
                //   height: size.getS(24),
                //   decoration: BoxDecoration(
                //     color: primaryColor,
                //     shape: BoxShape.circle,
                //   ),
                //   child: Icon(
                //     Icons.check,
                //     color: Colors.white,
                //     size: size.getS(16),
                //   ),
                // ),
                ),
        ],
      ),
    );
  }
}
