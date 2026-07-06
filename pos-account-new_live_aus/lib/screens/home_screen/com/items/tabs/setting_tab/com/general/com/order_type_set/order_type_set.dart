import 'package:flutter/material.dart';
import 'package:pos_account/config/size_config.dart';
import 'package:pos_account/config/utils/utils.dart';
import 'package:pos_account/constant/constant.dart';
import 'package:pos_account/ln.dart';
import 'package:pos_account/model/home/setting/general/order_type/order_type_add_req.dart';
import 'package:pos_account/providers/cus_val_pro.dart';
import 'package:pos_account/providers/setting/general/order_type_pro.dart';
import 'package:pos_account/screens/home_screen/com/items/tabs/setting_tab/com/general/common/add_new_sec.dart';
import 'package:pos_account/screens/home_screen/com/items/tabs/setting_tab/com/general/common/table_data.dart';
import 'package:pos_account/widgets/dialog/confirm_dialog.dart';
import 'package:pos_account/widgets/input/dropdown/title_drop_down.dart';
import 'package:pos_account/widgets/input/text_form/text_form_widget.dart';
import 'package:pos_account/widgets/loading.dart';
import 'package:pos_account/widgets/no_items_sec.dart';
import 'package:provider/provider.dart';

import '../../general_set.dart';

class OrderTypeSet extends StatefulWidget {
  final PageController pageController;
  const OrderTypeSet({super.key, required this.pageController});

  @override
  State<OrderTypeSet> createState() => _OrderTypeSetState();
}

class _OrderTypeSetState extends State<OrderTypeSet>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();

  OrderTypePro? _orderTypePro;

  late TabController _tabController;

  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this);
    setData();
    super.initState();
  }

  setData() async {
    _orderTypePro = Provider.of<OrderTypePro>(context, listen: false);
    if (_orderTypePro != null) {
      _orderTypePro!.init();
      await _orderTypePro!.getOrderTypeAddSec();
      await _orderTypePro!.getData(page: 1);
    }
  }

  paginate(int page) {
    if (_orderTypePro != null) {
      _orderTypePro!.loading = true;
      _orderTypePro!.notify();
      _orderTypePro!.getData(page: page);
    }
  }

  @override
  void dispose() {
    _orderTypePro?.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = Ssize(context);
    final orderTypePro = Provider.of<OrderTypePro>(context);
    return Processing(
      loading: orderTypePro.loading,
      child: DefaultTabController(
        length: 2,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SettingsTabRow(
              addTitle: "Add Order Types",
              viewTitle: "Order Types List",
              tabController: _tabController,
              pageController: widget.pageController,
              onTap: (int i) {
                if (i == 0) {
                  orderTypePro.clear();
                }
                Future.delayed(Duration(milliseconds: 300), () {
                  if (i == 0) {
                    orderTypePro.getData();
                  }
                });
              },
            ),
            SizedBox(
              height: size.getH(6),
            ),
            Expanded(
                child: TabBarView(
              controller: _tabController,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    SizedBox(
                      width: size.getW(400),
                      child: TextFormWidget(
                        isReq: false,
                        vPad: 10,
                        prefixIcon: Icon(
                          Icons.search,
                          size: size.getS(32),
                        ),
                        borderRadius: 5,
                        borderColor: Colors.black12,
                        cltr: orderTypePro.searchCltr,
                        hintText: LN.search,
                        onChanged: (p0) {
                          if (p0 == null) return;

                          Utils.handleSearch(callback: () async {
                            orderTypePro.loading = true;
                            orderTypePro.notify;
                            orderTypePro.getData();
                          });
                        },
                        suffixIcon: orderTypePro.searchCltr.text.isEmpty
                            ? null
                            : InkWell(
                                onTap: () {
                                  orderTypePro.searchCltr.clear();
                                  orderTypePro.getData();
                                  orderTypePro.notify;
                                },
                                child: Icon(
                                  Icons.close,
                                  size: size.getS(28),
                                  color: Colors.black,
                                ),
                              ),
                      ),
                    ),
                    SizedBox(
                      height: size.getH(6),
                    ),
                    if (orderTypePro.loading ||
                        orderTypePro.getTableList.tableDataList.isNotEmpty)
                      Flexible(
                        child: SingleChildScrollView(
                          child: TableData(
                            popUpMenuItems: (int _) => [
                              if (GlobalCVP.viewWidget.viewOrderTypeEdit)
                                LN.edit,
                              if (GlobalCVP.viewWidget.viewOrderTypeDelete)
                                LN.delete,
                            ],
                            showDeleteBtn:
                                GlobalCVP.viewWidget.viewOrderTypeBulkDelete,
                            tableData: orderTypePro.getTableList,
                            deleteItem: (items) {
                              showDialog(
                                  context: context,
                                  builder: (builder) => ConfirmDialog(
                                        title: items.length > 1
                                            ? "${items.length} ${LN.orderTypes}"
                                            : "${items[0].name}",
                                        onDelete: () async {
                                          orderTypePro.deleteData(
                                              dataList: items);
                                          return null;
                                        },
                                      ));
                            },
                            selectItem: (count) {
                              orderTypePro.setCount = count;
                            },
                            paginate: paginate,
                            total: orderTypePro.getAllOrderTypes?.total,
                            page: orderTypePro.getPage,
                            onAction: orderTypePro.loading
                                ? null
                                : (p0, moreFun) async {
                                    orderTypePro.loading = true;
                                    orderTypePro.notify();

                                    await orderTypePro.editData(id: p0.id!);

                                    orderTypePro.loading = false;
                                    orderTypePro.notify();

                                    if (orderTypePro.editOrderData != null) {
                                      orderTypePro.itemId =
                                          orderTypePro.editOrderData!.id ?? "";
                                      if (orderTypePro.getAddSec!.channels!.any(
                                          (e) =>
                                              e.id?.toLowerCase() ==
                                              orderTypePro
                                                  .editOrderData!.storeChannelId
                                                  ?.toLowerCase()))
                                        orderTypePro.setChannelIndex =
                                            orderTypePro.getAddSec!.channels!
                                                .indexWhere((e) =>
                                                    e.id?.toLowerCase() ==
                                                    orderTypePro.editOrderData!
                                                        .storeChannelId
                                                        ?.toLowerCase());

                                      if (orderTypePro.getAddSec!.channels!.any(
                                          (e) =>
                                              e.id?.toLowerCase() ==
                                              orderTypePro.editOrderData!
                                                  .productChannelId
                                                  ?.toLowerCase()))
                                        orderTypePro.channelTypeIndex =
                                            orderTypePro
                                                .getAddSec!.channels!
                                                .indexWhere((e) =>
                                                    e.id?.toLowerCase() ==
                                                    orderTypePro.editOrderData!
                                                        .productChannelId
                                                        ?.toLowerCase());

                                      if (orderTypePro.getAddSec!.orderTypes!
                                          .any((e) =>
                                              e.id?.toLowerCase() ==
                                              orderTypePro
                                                  .editOrderData!.orderTypeId
                                                  ?.toLowerCase()))
                                        orderTypePro.setOTIndex = orderTypePro
                                            .getAddSec!.orderTypes!
                                            .indexWhere((e) =>
                                                e.id?.toLowerCase() ==
                                                orderTypePro
                                                    .editOrderData!.orderTypeId
                                                    ?.toLowerCase());
                                      orderTypePro.status = orderTypePro
                                              .editOrderData!.isActive ??
                                          false;
                                      orderTypePro.enableCusPopUp = orderTypePro
                                              .editOrderData!
                                              .enableCustomerPopUpScreen ??
                                          false;
                                      orderTypePro.enableTableSelection =
                                          orderTypePro.editOrderData!
                                                  .enableTableSelection ??
                                              false;
                                      orderTypePro.tableData[0].tableCltr.text =
                                          orderTypePro.editOrderData!.sortOrder
                                                  ?.toString() ??
                                              '';
                                      orderTypePro.tableData[1].tableCltr.text =
                                          orderTypePro
                                                  .editOrderData!.displayName ??
                                              '';
                                      // orderTypePro.tableData[2].tableCltr.text =
                                      //     orderTypePro.editOrderData!.channel ?? '';
                                      // orderTypePro.isPosOrderType =
                                      //     orderTypePro.editOrderData!.isPosOrderType ?? false;
                                      // orderTypePro.isOnlineOrderType =
                                      //     orderTypePro.editOrderData!.isOnlineOrderType ?? false;
                                      orderTypePro.notify();
                                      // orderTypePro.setDefault =
                                      //     orderTypePro.editOrderData!.isDefault ?? false;

                                      _tabController.animateTo(1);
                                      Future.delayed(
                                          Duration(milliseconds: 500), () {
                                        orderTypePro.notify();
                                      });
                                    }
                                  },
                          ),
                        ),
                      )
                    else
                      Center(
                        child: NoItemsSec(
                            size: size,
                            title: 'No order types have been added yet.'),
                      )
                  ],
                ),
                SingleChildScrollView(
                  child: Form(
                    key: _formKey,
                    child: AddNewSection(
                      showSaveBtn: GlobalCVP.viewWidget.viewOrderTypeSaveButton,
                      tableTitle: LN.addNewOrderType,
                      tableList: orderTypePro.tableData,
                      statusClass: [
                        StatusClass(
                            activeText: LN.active,
                            getStatus: orderTypePro.status,
                            inActiveText: LN.inActive,
                            setStatus: (val) {
                              orderTypePro.status = val;
                              orderTypePro.notify();
                            }),
                        StatusClass(
                            activeText: "Customer details mandatory",
                            getStatus: orderTypePro.enableCusPopUp,
                            inActiveText: "Customer details not mandatory",
                            setStatus: (val) {
                              orderTypePro.enableCusPopUp = val;
                              orderTypePro.notify();
                            }),
                        StatusClass(
                            activeText: "Enable Table Selection",
                            getStatus: orderTypePro.enableTableSelection,
                            inActiveText: "Enable Table Selection",
                            setStatus: (val) {
                              orderTypePro.enableTableSelection = val;
                              orderTypePro.notify();
                            })
                      ],
                      onAdd: orderTypePro.loading
                          ? null
                          : () async {
                              if (_formKey.currentState!.validate()) {
                                await orderTypePro.addUpData(
                                  tableList: [
                                    OrderTypeAddReq(
                                      id: orderTypePro.itemId,
                                      storeChannelId:
                                          orderTypePro.getChannelIndex != null
                                              ? orderTypePro
                                                  .getAddSec!
                                                  .channels![orderTypePro
                                                      .getChannelIndex!]
                                                  .id
                                              : null,
                                      productChannelId:
                                          orderTypePro.channelTypeIndex != null
                                              ? orderTypePro
                                                  .getAddSec!
                                                  .channels![orderTypePro
                                                      .channelTypeIndex!]
                                                  .id
                                              : "",
                                      orderTypeId:
                                          orderTypePro.getOTIndex != null
                                              ? orderTypePro
                                                  .getAddSec!
                                                  .orderTypes![
                                                      orderTypePro.getOTIndex!]
                                                  .id
                                              : null,
                                      isActive: orderTypePro.status,
                                      enableCustomerPopUpScreen:
                                          orderTypePro.enableCusPopUp,
                                      enableTableSelection:
                                          orderTypePro.enableTableSelection,
                                      // isDefault: orderTypePro.getDefault,
                                      sortOrder: int.tryParse(orderTypePro
                                          .tableData[0].tableCltr.text),
                                      displayName: orderTypePro
                                          .tableData[1].tableCltr.text,
                                      // channel: orderTypePro
                                      //     .tableData[2].tableCltr.text
                                      // isPosOrderType: orderTypePro.isPosOrderType,
                                      // isOnlineOrderType:
                                      //     orderTypePro.isOnlineOrderType,
                                    )
                                  ],
                                );
                                orderTypePro.clear();
                                orderTypePro.notify();
                              }
                            },
                      isNew: orderTypePro.itemId.isEmpty ? true : false,
                      onCancel: () {
                        orderTypePro.clear();
                        orderTypePro.notify();
                      },
                      newWidget: Wrap(
                        spacing: size.getW(size.isProt ? 24 : 24),
                        runSpacing: size.getH(16),
                        crossAxisAlignment: WrapCrossAlignment.end,
                        children: [
                          SizedBox(
                            width: size.getW(300),
                            child: TitleDropDown(
                              borderColor: Colors.black54,
                              hintText: LN.chooseChannel,
                              // pWidth: 0.21,
                              title: LN.channel,
                              isReq: true,
                              list: orderTypePro.getAddSec?.channels != null
                                  ? orderTypePro.getAddSec!.channels!
                                      .map((e) => e.value ?? '')
                                      .toList()
                                  : [],
                              indexVal: orderTypePro.getChannelIndex,
                              onChanged: (p0) {
                                orderTypePro.setChannelIndex = p0;
                              },
                            ),
                          ),
                          SizedBox(
                            width: size.getW(300),
                            child: TitleDropDown(
                              borderColor: Colors.black54,
                              hintText: LN.chooseOrderType,
                              // pWidth: 0.21,
                              isReq: true,
                              title: LN.orderType,
                              list: orderTypePro.getAddSec?.orderTypes != null
                                  ? orderTypePro.getAddSec!.orderTypes!
                                      .map((e) => e.value ?? '')
                                      .toList()
                                  : [],
                              indexVal: orderTypePro.getOTIndex,
                              onChanged: (p0) {
                                orderTypePro.setOTIndex = p0;
                                orderTypePro
                                    .tableData[1].tableCltr.text = orderTypePro
                                        .getAddSec!
                                        .orderTypes![orderTypePro.getOTIndex!]
                                        .value ??
                                    '';
                              },
                            ),
                          ),
                        ],
                      ),
                      bottomWidget: Container(
                        margin: EdgeInsets.only(top: size.getH(16)),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade50,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: Colors.black12),
                        ),
                        padding: EdgeInsets.symmetric(
                            horizontal: size.getW(24), vertical: size.getH(24)),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Icons.print_outlined,
                                  size: size.getS(32),
                                  color: Colors.black,
                                ),
                                SizedBox(width: size.getW(12)),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Configure Product Channel for Order Type",
                                      style: TextStyle(
                                        fontSize: size.getS(18),
                                        fontFamily: kFontFMedium,
                                      ),
                                    ),
                                    Text(
                                        "Select the product channel to adjust the price based on the chosen configuration.",
                                        style: TextStyle(
                                          fontSize: size.getS(16),
                                          fontFamily: kFontFRegular,
                                        ))
                                  ],
                                )
                              ],
                            ),
                            SizedBox(height: size.getH(16)),
                            TitleDropDown(
                              title: "Product Channel",
                              borderColor: Colors.black26,
                              isReq: true,
                              list: orderTypePro.getAddSec?.channels != null
                                  ? orderTypePro.getAddSec!.channels!
                                      .map((e) => e.value ?? '')
                                      .toList()
                                  : [],
                              indexVal: orderTypePro.channelTypeIndex,
                              onChanged: (p0) {
                                orderTypePro.channelTypeIndex = p0;
                                orderTypePro.notify();
                              },
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ))
          ],
        ),
      ),
    );
  }
}
