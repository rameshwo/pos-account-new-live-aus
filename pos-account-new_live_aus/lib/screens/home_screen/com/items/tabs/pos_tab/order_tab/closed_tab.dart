import 'package:flutter/material.dart';
import 'package:pos_account/config/size_config.dart';
import 'package:pos_account/services/database/shared_pref.dart';
import 'package:pos_account/widgets/no_items_sec.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../../../../../../model/home/menu/place_order/order_tab/order_tab_req.dart';
import '../../../../../../../providers/menu/order_tab/order_tab_pro.dart';
import '../../../../../../../providers/menu/place_order_pro.dart';
import 'com/order_tab_item.dart';

class ClosedTabScreen extends StatefulWidget {
  final PlaceOrderPro placePro;
  final GlobalKey<ScaffoldState> scafKey;

  const ClosedTabScreen({
    super.key,
    required this.placePro,
    required this.scafKey,
  });

  @override
  State<ClosedTabScreen> createState() => _ClosedTabScreenState();
}

class _ClosedTabScreenState extends State<ClosedTabScreen> {
  OrderTabPro? _orderTabPro;
  OrderTabReq? orderTabData;
  final RefreshController _refreshController = RefreshController();
  final RefreshController _noDataRefreshController = RefreshController();
  dynamic curSym;

  @override
  void initState() {
    super.initState();
    _initializeData();
    getCurSym();
  }

  @override
  void dispose() {
    widget.placePro.orderTabLoading = false;
    _orderTabPro?.actionTapped = false;
    _orderTabPro?.isClosedTab = false;
    _refreshController.dispose();
    _noDataRefreshController.dispose();
    super.dispose();
  }

  Future<void> _initializeData() async {
    _orderTabPro = Provider.of<OrderTabPro>(context, listen: false);
    await _orderTabPro!.getOrderTabs(isClosed: true);
    _syncPlaceOrderData();
  }

  Future<void> getCurSym() async {
    curSym = await SharedPrefs.curSym;
    if (mounted) setState(() {});
  }

  Future<void> _refreshData() async {
    _orderTabPro?.loading = true;
    _orderTabPro!.notify;
    await _orderTabPro?.getOrderTabs(isClosed: true);
    _noDataRefreshController.refreshCompleted();
    _refreshController.refreshCompleted();
  }

  void _syncPlaceOrderData() {
    final placePro = widget.placePro;
    if ((placePro.orderTabId?.isNotEmpty ?? false) &&
        (_orderTabPro?.closedTabs?.any(
              (e) => e.id?.toLowerCase() == placePro.orderTabId?.toLowerCase(),
            ) ??
            false)) {
      orderTabData = _orderTabPro?.closedTabs?.firstWhere(
        (element) =>
            element.id?.toLowerCase() == placePro.orderTabId?.toLowerCase(),
      );
      _orderTabPro!.notify;
    }
  }

  @override
  Widget build(BuildContext context) {
    final tabPro = Provider.of<OrderTabPro>(context);
    final size = Ssize(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: size.getW(12)),
            child: _buildContent(tabPro, size),
          ),
        ),
      ],
    );
  }

  Widget _buildContent(OrderTabPro tabPro, Ssize size) {
    return Column(
      children: [
        _buildListHeader(tabPro, size),
        SizedBox(height: size.getH(8.0)),
        Expanded(child: _buildOrderTabList(tabPro, size)),
      ],
    );
  }

  Widget _buildListHeader(OrderTabPro tabPro, Ssize size) {
    return Padding(
      padding: EdgeInsets.all(size.getS(8.0)),
      child: Row(
        children: [
          _buildHeaderCell("Name", size, flex: 2),
          _buildHeaderCell("Total Items", size, flex: 1),
          _buildHeaderCell("No. of Customers", size, flex: 1),
          _buildHeaderCell("Tab Limit", size, flex: 1, align: TextAlign.right),
        ],
      ),
    );
  }

  Widget _buildHeaderCell(String text, Ssize size,
      {int flex = 1, TextAlign align = TextAlign.start}) {
    return Expanded(
      flex: flex,
      child: Text(
        text,
        textAlign: align,
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: size.getS(16)),
      ),
    );
  }

  Widget _buildOrderTabList(OrderTabPro tabPro, Ssize size) {
    return SmartRefresher(
      controller: tabPro.closedTabs?.isEmpty ?? true
          ? _noDataRefreshController
          : _refreshController,
      onRefresh: _refreshData,
      child: (tabPro.closedTabs?.isEmpty ?? true) && tabPro.loading
          ? Container()
          : tabPro.closedTabs?.isEmpty ?? true
              ? NoItemsSec(size: Ssize(context), title: "No Closed Tabs Found")
              : ListView.separated(
                  itemCount: tabPro.closedTabs?.length ?? 0,
                  separatorBuilder: (context, index) => const Divider(),
                  itemBuilder: (context, index) {
                    return OrderTabItem(
                      ticket: tabPro.closedTabs![index],
                      tabPro: tabPro,
                      size: size,
                      curSym: curSym,
                      onTap: null,
                      onCheckboxChanged: (ticket, value) =>
                          tabPro.onSelectTabCheckBox(ticket, value),
                    );
                  },
                ),
    );
  }
}
