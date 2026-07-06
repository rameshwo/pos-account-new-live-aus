import 'package:flutter/material.dart';
import 'package:pos_account/config/size_config.dart';
import 'package:pos_account/config/validator.dart';
import 'package:pos_account/screens/home_screen/com/items/tabs/pos_tab/order_tab/com/order_tab_item.dart';
import 'package:pos_account/services/database/shared_pref.dart';
import 'package:pos_account/widgets/dialog/custom_dialog.dart';
import 'package:pos_account/widgets/no_items_sec.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../../../../../../constant/text_formatter.dart';
import '../../../../../../../ln.dart';
import '../../../../../../../model/home/menu/place_order/order_tab/order_tab_req.dart';
import '../../../../../../../providers/menu/order_tab/order_tab_pro.dart';
import '../../../../../../../providers/menu/place_order_pro.dart';
import '../../../../../../../widgets/input/text_form/title_text_form.dart';
import '../../../../../../../widgets/load_btn.dart';
import '../../../../pos_orders/com/pending_order/pending_order.dart';
import '../../../com/price_update_dia.dart';

class OpenTabScreen extends StatefulWidget {
  final PlaceOrderPro placePro;
  final GlobalKey<ScaffoldState> scafKey;

  const OpenTabScreen({
    super.key,
    required this.placePro,
    required this.scafKey,
  });

  @override
  State<OpenTabScreen> createState() => _OpenTabScreenState();
}

class _OpenTabScreenState extends State<OpenTabScreen> {
  OrderTabPro? _orderTabPro;
  OrderTabReq? orderTabData;
  final _formKey = GlobalKey<FormState>();
  final RefreshController _refreshController = RefreshController();
  final RefreshController _actionRefreshController = RefreshController();
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
    _refreshController.dispose();
    _actionRefreshController.dispose();
    _noDataRefreshController.dispose();
    super.dispose();
  }

  Future<void> _initializeData() async {
    _orderTabPro = Provider.of<OrderTabPro>(context, listen: false);
    await _orderTabPro!.getOrderTabs();
    _syncPlaceOrderData();
  }

  Future<void> getCurSym() async {
    curSym = await SharedPrefs.curSym;
    if (mounted) setState(() {});
  }

  Future<void> _refreshData() async {
    _orderTabPro?.loading = true;
    _orderTabPro!.notify;
    _orderTabPro?.selectedTabs?.clear();
    await _orderTabPro?.getOrderTabs();
    _noDataRefreshController.refreshCompleted();
    _actionRefreshController.refreshCompleted();
    _refreshController.refreshCompleted();
  }

  void _syncPlaceOrderData() {
    final placePro = widget.placePro;
    if ((placePro.orderTabId?.isNotEmpty ?? false) &&
        (_orderTabPro?.openTabs?.any(
              (e) => e.id?.toLowerCase() == placePro.orderTabId?.toLowerCase(),
            ) ??
            false)) {
      orderTabData = _orderTabPro?.openTabs?.firstWhere(
        (element) =>
            element.id?.toLowerCase() == placePro.orderTabId?.toLowerCase(),
      );
      _orderTabPro!.notify;
    }
  }

  @override
  Widget build(BuildContext context) {
    final tabPro = Provider.of<OrderTabPro>(context);
    final placeOrderPro = Provider.of<PlaceOrderPro>(context);
    final size = Ssize(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: size.getW(12)),
            child: _buildContent(tabPro, size, placeOrderPro),
          ),
        ),
      ],
    );
  }

  Widget _buildContent(
      OrderTabPro tabPro, Ssize size, PlaceOrderPro placeOrderPro) {
    return Column(
      children: [
        _buildListHeader(tabPro, size),
        SizedBox(height: size.getH(8.0)),
        Expanded(child: _buildOrderTabList(tabPro, size, placeOrderPro)),
      ],
    );
  }

  Widget _buildListHeader(OrderTabPro tabPro, Ssize size) {
    return Padding(
      padding: EdgeInsets.all(size.getS(8.0)),
      child: Row(
        children: [
          if (tabPro.actionTapped) _buildHeaderCell("Select", size, flex: 1),
          if (tabPro.actionTapped) SizedBox(width: size.getW(12)),
          _buildHeaderCell("Name", size, flex: 2),
          _buildHeaderCell("Total Items", size, flex: 1),
          _buildHeaderCell("No. of Customers", size, flex: 1),
          _buildHeaderCell("Total Amount", size,
              flex: 1, align: TextAlign.right),
          if (!tabPro.actionTapped)
            _buildHeaderCell("Actions", size, flex: 2, align: TextAlign.center),
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

  Widget _buildOrderTabList(
      OrderTabPro tabPro, Ssize size, PlaceOrderPro placeOrderPro) {
    return SmartRefresher(
      controller: tabPro.actionTapped
          ? _actionRefreshController
          : tabPro.openTabs?.isEmpty ?? true
              ? _noDataRefreshController
              : _refreshController,
      onRefresh: _refreshData,
      child: (tabPro.openTabs?.isEmpty ?? true) && tabPro.loading
          ? Container()
          : tabPro.openTabs?.isEmpty ?? true
              ? NoItemsSec(size: Ssize(context), title: "No Open Tabs Found")
              : ListView.separated(
                  itemCount: tabPro.openTabs?.length ?? 0,
                  separatorBuilder: (context, index) => const Divider(),
                  itemBuilder: (context, index) {
                    return OrderTabItem(
                      ticket: tabPro.openTabs![index],
                      tabPro: tabPro,
                      size: size,
                      placeOrderPro: placeOrderPro,
                      curSym: curSym,
                      onTap: (ticket) => _handleTicketTap(ticket, tabPro),
                      onCheckboxChanged: (ticket, value) =>
                          tabPro.onSelectTabCheckBox(ticket, value),
                      onPayPressed: (orderId) =>
                          _handlePayAction(orderId, tabPro),
                      onEditPressed: (id, tabPro, size) =>
                          _handleEditAction(id, tabPro, size),
                    );
                  },
                ),
    );
  }

  void _showAddTabDialog(OrderTabPro tabPro, Ssize size, bool isAdd) {
    if (isAdd) {
      tabPro.clear();
      tabPro.notify;
    }

    CustomDialog.showCustomDialog(
      context: context,
      title: "Order Tab",
      content: SizedBox(
        width: size.getW(400),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: size.getW(16.0)),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                _buildTabIdentifierField(tabPro),
                SizedBox(height: size.getH(8)),
                if (widget.placePro.isDine) _buildCustomerCountField(),
                SizedBox(height: size.getH(8)),
                _buildTabLimitField(tabPro),
                SizedBox(height: size.getH(8)),
                _buildActionButtonsForDialog(tabPro, size),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTabIdentifierField(OrderTabPro tabPro) {
    return TitleTextForm(
      vPad: 10,
      title: "Tab Identifier",
      textCltr: tabPro.tableIdCltr,
      borderColor: Colors.black26,
      isReq: true,
    );
  }

  Widget _buildCustomerCountField() {
    return TitleTextForm(
      title: "No. of Customers",
      hintText: "0",
      vPad: 10,
      isReq: false,
      textCltr: widget.placePro.noOfCustomer,
      textInputType: TextInputType.number,
      inputFormatters: [NonNegativeTextInputFormatter()],
      readOnly: true,
      borderColor: Colors.black26,
      onTap: () => _showCustomerCountDialog(),
    );
  }

  Widget _buildTabLimitField(OrderTabPro tabPro) {
    return TitleTextForm(
      title: "Tab Limit",
      vPad: 10,
      textCltr: tabPro.tabLimitCltr,
      borderColor: Colors.black26,
      textInputType: TextInputType.number,
      inputFormatters: [NonNegativeTextInputFormatter()],
      prefixText: Text("${curSym ?? ""}"),
      readOnly: true,
      isReq: false,
      onTap: () => _showTabLimitDialog(tabPro),
    );
  }

  Widget _buildActionButtonsForDialog(OrderTabPro tabPro, Ssize size) {
    return Row(
      children: [
        LoadButton(
          btnText: tabPro.editId.isEmpty ? LN.save : LN.update,
          onsave: () => _saveTab(tabPro),
        ),
        if (tabPro.editId.isNotEmpty) ...[
          SizedBox(width: size.getW(12)),
          LoadButton(
            btnColor: Colors.red.shade700,
            btnText: LN.clear,
            onsave: () {
              widget.placePro.noOfCustomer.clear();
              tabPro.clear();
              tabPro.notify;
            },
          ),
        ],
      ],
    );
  }

  void _showCustomerCountDialog() {
    PriceUpdateDia.showDia<int>(
      context,
      title: LN.noOfCustomers,
      number: widget.placePro.noOfCustomer.text.inDouble,
      max: 1000,
    ).then((value) {
      widget.placePro.noOfCustomer.text = value.formatDouble;
      widget.placePro.notify;
    });
  }

  void _showTabLimitDialog(OrderTabPro tabPro) {
    PriceUpdateDia.showDia<double>(
      context,
      title: "Tab Limit",
      number: tabPro.tabLimitCltr.text.inDouble,
      max: 1000000000,
    ).then((value) {
      tabPro.tabLimitCltr.text = value.formatDouble;
      tabPro.notify;
    });
  }

  void _saveTab(OrderTabPro tabPro) {
    if (_formKey.currentState!.validate()) {
      tabPro.loading = true;
      tabPro.notify;
      Navigator.of(context).pop();
      _orderTabPro?.addTab(
          noOfCus: widget.placePro.noOfCustomer.text,
          action: () {
            if (tabPro.editId.toLowerCase() ==
                widget.placePro.orderTabId?.toLowerCase()) {
              widget.placePro.orderTabLimit = tabPro.tabLimitCltr.text;
            }
          });
    }
  }

  void _handleTicketTap(OrderTabReq ticket, OrderTabPro tabPro) async {
    if (tabPro.actionTapped) {
      tabPro.onSelectTabCheckBox(
          ticket, !(tabPro.selectedTabs?.contains(ticket) ?? false));
    } else {
      widget.placePro.notify;
      widget.placePro.showManageTab = false;

      if (ticket.orderId != null && ticket.orderId!.isNotEmpty) {
        widget.placePro.orderTabLoading = true;
        PendingOrder.updateOrder(
          context,
          orderId: ticket.orderId ?? "",
          fromOrderTab: true,
          orderTabReq: ticket,
        );
      } else {
        if (widget.placePro.orderTabName.toLowerCase() !=
            ticket.tabIdentification?.toLowerCase()) {
          widget.placePro.clear();
          widget.placePro.reOrder = null;
        } else {}

        widget.placePro.orderTabId = ticket.id ?? '';
        widget.placePro.orderTabLimit = ticket.tabLimit ?? '';
        widget.placePro.orderTabName = ticket.tabIdentification ?? '';
        // widget.placePro.tableId = null;
        // widget.placePro.tableName = "";
      }
    }
  }

  Future<void> _handlePayAction(String? orderId, OrderTabPro tabPro) async {
    if (tabPro.loading) return;
    await Future.delayed(const Duration(milliseconds: 400));
    PendingOrder.payNow(
      context,
      orderId: orderId ?? "",
      scaffKey: widget.scafKey,
    );
    widget.placePro.showManageTab = false;
  }

  void _handleEditAction(String? orderId, OrderTabPro tabPro, Ssize size) {
    if (tabPro.loading) return;
    if (orderId == null) return;
    tabPro.editTab(orderId).then((value) {
      widget.placePro.noOfCustomer.text = value ?? '';
      tabPro.notify;
      _showAddTabDialog(tabPro, size, false);
    });
  }
}
