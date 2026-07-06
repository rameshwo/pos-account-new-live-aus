import 'package:flutter/material.dart';
import 'package:pos_account/config/size_config.dart';
import 'package:pos_account/config/validator.dart';
import 'package:pos_account/constant/constant.dart';
import 'package:pos_account/screens/custom_drawer/com/logo_sec.dart';
import 'package:pos_account/services/database/shared_pref.dart';
import 'package:pos_account/widgets/dialog/confirm_dialog.dart';
import 'package:pos_account/widgets/dialog/custom_dialog.dart';
import 'package:pos_account/widgets/loading.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import '../../../../../../../constant/text_formatter.dart';
import '../../../../../../../ln.dart';
import '../../../../../../../model/home/menu/place_order/order_tab/order_tab_req.dart';
import '../../../../../../../providers/menu/order_tab/order_tab_pro.dart';
import '../../../../../../../providers/menu/place_order_pro.dart';
import '../../../../../../../widgets/input/text_form/title_text_form.dart';
import '../../../../../../../widgets/load_btn.dart';
import '../../../com/price_update_dia.dart';
import 'closed_tab.dart';
import 'com/complimentory_dia.dart';
import 'open_tab.dart';

class OrderTabManageScreen extends StatefulWidget {
  final PlaceOrderPro placePro;
  final GlobalKey<ScaffoldState> scafKey;

  const OrderTabManageScreen({
    super.key,
    required this.placePro,
    required this.scafKey,
  });

  @override
  State<OrderTabManageScreen> createState() => _OrderTabManageScreenState();
}

class _OrderTabManageScreenState extends State<OrderTabManageScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  OrderTabPro? _orderTabPro;
  OrderTabReq? orderTabData;
  final _formKey = GlobalKey<FormState>();
  final RefreshController _refreshController = RefreshController();
  final RefreshController _actionRefreshController = RefreshController();
  final RefreshController _noDataRefreshController = RefreshController();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: 2,
      vsync: this,
    );
    _initializeData();
    getCursym();
  }

  @override
  void dispose() {
    widget.placePro.orderTabLoading = false;
    _orderTabPro?.actionTapped = false;
    _orderTabPro?.isClosedTab = false;
    _orderTabPro?.clear();
    _orderTabPro?.cDispose();
    _tabController.dispose();
    _refreshController.dispose();
    super.dispose();
  }

  Future<void> _initializeData() async {
    _orderTabPro = Provider.of<OrderTabPro>(context, listen: false);
    await _orderTabPro!.init();
  }

  dynamic curSym;

  Future<void> getCursym() async {
    curSym = await SharedPrefs.curSym;
  }

  @override
  Widget build(BuildContext context) {
    final tabPro = Provider.of<OrderTabPro>(context);
    final size = Ssize(context);
    return Processing(
      loading: tabPro.loading,
      align: Alignment.topLeft,
      child: Container(
        color: Colors.white,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(tabPro, size),
            if (!tabPro.actionTapped &&
                (tabPro.orderStatusList?.isNotEmpty ?? false))
              Padding(
                padding: EdgeInsets.symmetric(horizontal: size.getW(12)),
                child: _buildTabBar(tabPro),
              ),
            if (tabPro.actionTapped)
              Padding(
                padding: EdgeInsets.symmetric(horizontal: size.getW(12)),
                child: _buildActionButtons(size, tabPro),
              ),
            Expanded(
              child: TabBarView(
                physics: const NeverScrollableScrollPhysics(),
                controller: _tabController,
                children: [
                  OpenTabScreen(
                    placePro: widget.placePro,
                    scafKey: widget.scafKey,
                  ),
                  ClosedTabScreen(
                    placePro: widget.placePro,
                    scafKey: widget.scafKey,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(OrderTabPro tabPro, Ssize size) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: kFlexLeft,
          child: LogoSection(
            size: size,
            onTap: () {
              widget.placePro.showManageTab = false;
            },
          ),
        ),
        Expanded(
          flex: kFlexMiddleLand,
          child: Row(
            children: [
              _buildBackButton(size, tabPro),
              const Spacer(),
              tabPro.actionTapped
                  ? Padding(
                      padding: EdgeInsets.only(top: size.getH(8)),
                      child: _buildDoneButton(size, tabPro),
                    )
                  : Padding(
                      padding: EdgeInsets.only(top: size.getH(8)),
                      child: Row(
                        children: [
                          if (!tabPro.isClosedTab)
                            _buildActionsButton(tabPro, size),
                          SizedBox(width: size.getW(8)),
                          _buildAddTabButton(tabPro, size),
                        ],
                      ),
                    ),
              SizedBox(width: size.getW(12)),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildBackButton(Ssize size, OrderTabPro tabPro) {
    return InkWell(
      onTap: () => _handleBackPress(tabPro),
      child: Row(
        children: [
          Icon(
            Icons.arrow_back,
            color: Colors.black,
            size: size.getS(25),
          ),
          SizedBox(width: size.getW(8)),
          Text(
            tabPro.actionTapped ? 'Actions' : 'Order Tab',
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontFamily: kFontFRegular,
                fontSize: size.getS(18)),
          ),
        ],
      ),
    );
  }

  void _handleBackPress(OrderTabPro tabPro) {
    if (tabPro.actionTapped) {
      setState(() => tabPro.actionTapped = false);
      tabPro.selectedTabs = [];
      // tabPro.selectedComp = null;
    } else {
      widget.placePro.showManageTab = false;
      widget.placePro.notify;
    }
  }

  Widget _buildDoneButton(Ssize size, OrderTabPro tabPro) {
    return ElevatedButton(
      onPressed: () => setState(() => tabPro.actionTapped = false),
      style: ElevatedButton.styleFrom(
          backgroundColor: kPrimaryColor,
          padding: EdgeInsets.symmetric(
              vertical: size.getH(6), horizontal: size.getW(16))),
      child: Text('Done',
          style: TextStyle(color: Colors.white, fontSize: size.getS(16))),
    );
  }

  Widget _buildActionsButton(OrderTabPro tabPro, Ssize size) {
    return ElevatedButton(
      onPressed: () => _toggleActionMode(tabPro),
      style: ElevatedButton.styleFrom(
          backgroundColor: Colors.grey[200],
          padding: EdgeInsets.symmetric(
              vertical: size.getH(6), horizontal: size.getW(16))),
      child: Text('Actions',
          style: TextStyle(color: kPrimaryColor, fontSize: size.getS(16))),
    );
  }

  Future<void> _toggleActionMode(OrderTabPro tabPro) async {
    // tabPro.loading = true;
    // tabPro.closedTabs = null;
    // tabPro.openTabs = null;
    // tabPro.notify;
    setState(() => tabPro.actionTapped = true);
    // await tabPro.getOrderTabs();
  }

  Widget _buildAddTabButton(OrderTabPro tabPro, Ssize size) {
    return ElevatedButton(
      onPressed: () => _showAddTabDialog(tabPro, size, true),
      style: ElevatedButton.styleFrom(
          backgroundColor: kPrimaryColor,
          padding: EdgeInsets.symmetric(vertical: size.getH(6))),
      child: Icon(
        Icons.add,
        color: Colors.white,
        size: size.getS(25),
      ),
    );
  }

  Widget _buildTabBar(OrderTabPro tabPro) {
    final size = Ssize(context);
    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: TabBar(
                labelColor: kSecondaryColor,
                unselectedLabelColor: Colors.black,
                indicatorColor: kSecondaryColor,
                indicatorWeight: 3,
                isScrollable: true,
                labelStyle: TextStyle(
                    fontWeight: FontWeight.w600, fontSize: size.getH(18)),
                controller: _tabController,
                tabs: [
                  Tab(
                    text: "Open",
                  ),
                  Tab(
                    text: "Closed",
                  ),
                ],
                onTap: (index) => _handleTabSelection(tabPro, index),
              ),
            ),
            _buildTotalAmount(tabPro, size),
          ],
        ),
        const Divider(
          color: Colors.black12,
          thickness: 1,
        ),
      ],
    );
  }

  Widget _buildTotalAmount(OrderTabPro tabPro, Ssize size) {
    final total = tabPro.isClosedTab
        ? tabPro.closedTabs?.fold<double>(0.0,
                (sum, ticket) => sum + (ticket.tabLimit?.inDouble ?? 0.0)) ??
            0.0
        : tabPro.openTabs?.fold<double>(0.0,
                (sum, ticket) => sum + (ticket.tabLimit?.inDouble ?? 0.0)) ??
            0.0;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Text(
        'Total Limit : ${curSym ?? ""}${total.roundToNString()}',
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: size.getS(18)),
      ),
    );
  }

  void _handleTabSelection(OrderTabPro tabPro, int index) async {
    tabPro.orderStatusId = tabPro.orderStatusList![index].id;
    if (index == 1) {
      tabPro.isClosedTab = true;
      tabPro.openTabs = null;
    } else {
      tabPro.isClosedTab = false;
      tabPro.closedTabs = null;
    }
    tabPro.loading = true;
    tabPro.openTabs = null;
    tabPro.notify;
    _refreshController.refreshCompleted();
    _actionRefreshController.refreshCompleted();
    _noDataRefreshController.refreshCompleted();
    tabPro.notify;
  }

  Widget _buildActionButtons(Ssize size, OrderTabPro tabPro) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: size.getW(16.0)),
      child: Row(
        children: [
          // _buildActionButton(
          //     'Assign',
          //     (tabPro.selectedTabs?.isNotEmpty ?? false) ? () {} : null,
          //     tabPro),
          // SizedBox(width: size.getS(8)),
          _buildActionButton(
              'Void',
              (tabPro.selectedTabs?.isNotEmpty ?? false) &&
                      (tabPro.selectedTabs?.first.orderId?.isNotEmpty ?? false)
                  ? () async {
                      await showDialog(
                          context: context,
                          builder: (builder) {
                            return ConfirmDialog(
                              title:
                                  "Cancel Order of ${tabPro.selectedTabs?.first.tabIdentification ?? ''}",
                              subTitle:
                                  "Are you sure you want to cancel this order?",
                              onDelete: () async {
                                tabPro
                                    .cancelorder(
                                        orderId: tabPro
                                                .selectedTabs?.first.orderId ??
                                            '')
                                    .then((value) => tabPro.getOrderTabs());
                                return null;
                              },
                              actionText: LN.yes,
                              cancelText: LN.no,
                            );
                          });
                    }
                  : null,
              tabPro),
          SizedBox(width: size.getS(8)),
          _buildActionButton(
              'Comp',
              (tabPro.selectedTabs?.isNotEmpty ?? false) &&
                      (tabPro.selectedTabs?.first.orderId?.isNotEmpty ?? false)
                  ? () => _handleCompAction(tabPro)
                  : null,
              tabPro),
        ],
      ),
    );
  }

  Widget _buildActionButton(
      String text, VoidCallback? onPressed, OrderTabPro tabPro) {
    return LoadButton(
      textColor: onPressed != null ? Colors.white : Colors.grey.shade500,
      btnColor: onPressed != null ? kSecondaryColor : Colors.grey.shade200,
      onsave: onPressed,
      btnText: text,
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
        width: Ssize(context).getW(400),
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
      _orderTabPro?.addTab(noOfCus: widget.placePro.noOfCustomer.text);
    }
  }

  // void _handleAssignAction() {
  //   // Implement assign action
  // }

  // void _handleVoidAction() {
  //   // Implement void action
  // }

  void _handleCompAction(OrderTabPro tabPro) async {
    final size = Ssize(context);
    if (_orderTabPro?.loading ??
        false || (tabPro.selectedTabs?.isEmpty ?? true)) return;

    final _hasOrder = (tabPro.selectedTabs?.isNotEmpty ?? false) &&
        (tabPro.selectedTabs?.first.orderId?.isNotEmpty ?? false);
    final _status = await CustomDialog.showCustomDialog(
        titleSize: 20,
        context: context,
        title: "Comp Tab",
        content: SizedBox(
          width: size.width * (!_hasOrder ? 0.45 : 0.75),
          height: size.height * (!_hasOrder ? 0.6 : 0.8),
          child: ComplimentorySection(
            size: size,
            curSym: curSym,
            scafKey: widget.scafKey,
          ),
        ));
    if (_status != null && _status is bool && _status) {
      // print('object');
      await _orderTabPro!.getOrderTabs();
    }
  }
}
