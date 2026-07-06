import 'package:flutter/material.dart';
import 'package:oktoast/oktoast.dart';
import 'package:pos_account/config/size_config.dart';
import 'package:pos_account/constant/constant.dart';
import 'package:pos_account/ln.dart';
import 'package:pos_account/providers/cus_val_pro.dart';
import 'package:pos_account/providers/menu/orders_pro.dart';
import 'package:pos_account/screens/home_screen/com/items/tabs/setting_tab/com/general/common/table_data.dart';
import 'package:pos_account/services/printer/com/send_to_kitchen_print.dart';
import 'package:pos_account/widgets/input/dropdown/title_drop_down.dart';
import 'package:pos_account/widgets/load_btn.dart';
import 'package:pos_account/widgets/loading.dart';
import 'package:pos_account/widgets/no_items_sec.dart';
import 'package:provider/provider.dart';

class NewOrderDia extends StatefulWidget {
  const NewOrderDia({super.key});

  @override
  State<NewOrderDia> createState() => _NewOrderDiaState();
}

class _NewOrderDiaState extends State<NewOrderDia> {
  OrderPro? _orderP;
  @override
  void initState() {
    getData();
    super.initState();
  }

  getData() {
    _orderP = Provider.of<OrderPro>(context, listen: false);
    if (_orderP != null)
      Future.delayed(Duration(milliseconds: 300), () {
        _orderP!.getAllTableData(page: 1);
      });
  }

  paginate(int page) {
    if (_orderP != null) {
      _orderP!.getAllTableData(page: page);
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = Ssize(context);
    final orderP = Provider.of<OrderPro>(context);
    return Processing(
      align: Alignment.topLeft,
      loading: orderP.loadNewOrder,
      child: Container(
        constraints: BoxConstraints(
          maxHeight: size.height / 1.2,
          minHeight: size.height / 5,
        ),
        width: size.width / 1.2,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                height: size.getH(12),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "${LN.newOrders}(${orderP.tableList.tableDataList.length})",
                    style: TextStyle(
                      fontSize: size.getS(18),
                      fontFamily: kFontFMedium,
                      color: Colors.black,
                    ),
                  ),
                  IconButton(
                      padding: EdgeInsets.zero,
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: Icon(
                        Icons.close,
                        size: size.getS(24),
                      ))
                ],
              ),
              Divider(
                color: Colors.black54,
              ),
              SizedBox(
                height: size.getH(12),
              ),
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Color(0xffc9deea),
                  borderRadius: BorderRadius.circular(5),
                ),
                padding: EdgeInsets.symmetric(
                    vertical: size.getH(24), horizontal: size.getW(16)),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  // alignment: WrapAlignment.end,
                  // runSpacing: size.getH(12),
                  // spacing: size.getW(12),
                  children: [
                    TitleDropDown(
                      pWidth: 0.24,
                      title: LN.orderChannel,
                      list: orderP.orderDetailSecRes?.orderChannels == null
                          ? []
                          : orderP.orderDetailSecRes!.orderChannels!
                              .map((e) => e.name ?? '')
                              .toList(),
                      indexVal: orderP.newOrderChannelIndex,
                      onChanged: (p0) {
                        orderP.newOrderChannelIndex = p0!;
                        orderP.notify;
                        orderP.getAllTableData(page: 1);
                      },
                      borderColor: Colors.black12,
                      borderRadius: 5,
                    ),
                    // TitleDropDown(
                    //   pWidth: 0.24,
                    //   title: LN.status,
                    //   list: orderP.newOrderStatusList.isEmpty
                    //       ? []
                    //       : orderP.newOrderStatusList
                    //           .map((e) => e.name ?? '')
                    //           .toList(),
                    //   indexVal: orderP.newOrderStatusIndex,
                    //   onChanged: (p0) {
                    //     orderP.newOrderStatusIndex = p0;
                    //     orderP.notify;
                    //   },
                    //   borderColor: Colors.black12,
                    //   borderRadius: 5,
                    // ),
                    // if (GlobalCVP.viewWidget("ViewUpdateBulkStatusButton"))
                    //   LoadButton(
                    //     btnColor: kPrimaryColor,
                    //     btnText: LN.update,
                    //     onsave: orderP.updateNewOrderStatus,
                    //   ),
                    // show only if retail is false
                    // if (orderP.newOrderStatusIndex != null &&
                    //     orderP.orderStatusList[orderP.newOrderStatusIndex!]
                    //             .name !=
                    //         null &&
                    //     orderP
                    //         .orderStatusList[orderP.newOrderStatusIndex!].name!
                    //         .toLowerCase()
                    //         .contains('going'))
                    if (
                        //!orderP.isRetail &&
                        GlobalCVP.viewWidget.viewBulkPrintToKitchenButton)
                      LoadButton(
                        width: 200,
                        btnColor: kSecondaryColor,
                        btnText: (GlobalCVP.isRetailStore)
                            ? LN.acceptAll
                            : LN.sentTKtchn,
                        onsave: orderP.tableList.tableDataList.isEmpty
                            ? () {
                                showToast(LN.noItemFound);
                              }
                            : () {
                                if (GlobalCVP.isRetailStore)
                                  orderP.acceptAllOrder();
                                else
                                  orderP.updateOrderSendToKit().then((value) {
                                    if (value != null) {
                                      SendToKitchenPrint.stkPos(context,
                                          order: value,
                                          runSuccessFun: () async {
                                        orderP.confirmOrderStk(
                                            orderId: value.orderId);
                                      });
                                    }
                                  });
                              },
                      ),
                  ],
                ),
              ),
              SizedBox(
                height: size.getH(12),
              ),
              !orderP.loadNewOrder && orderP.tableList.tableDataList.isEmpty
                  ? NoItemsSec(
                      size: size,
                      title: LN.noItemFound,
                      backColor: Colors.transparent,
                    )
                  : TableData(
                      tableData: orderP.tableList,
                      page: orderP.newOrderPage,
                      paginate: paginate,
                      showDeleteBtn: false,
                      total: orderP.allOrdersForNew?.total,
                    ),
              SizedBox(
                height: size.getH(24),
              )
            ],
          ),
        ),
      ),
    );
  }
}
