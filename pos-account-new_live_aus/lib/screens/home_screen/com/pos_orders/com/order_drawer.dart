import 'package:flutter/material.dart';
import 'package:pos_account/config/size_config.dart';
import 'package:pos_account/constant/constant.dart';
import 'package:pos_account/providers/menu/orders_pro.dart';
import 'package:provider/provider.dart';

class OrderDrawer extends StatelessWidget {
  const OrderDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final orderP = Provider.of<OrderPro>(context);
    final size = Ssize(context);
    return Container(
      decoration: BoxDecoration(
        color: kPrimaryColor,
        borderRadius: BorderRadius.all(
          Radius.circular(4),
        ),
      ),
      child: Column(
        children: [
          // ExpansionTile(
          //   initiallyExpanded: true,
          //   iconColor: Colors.white,
          //   collapsedIconColor: Colors.white,
          //   title: Text(
          //     GlobalCVP.isServiceStore ? LN.serviceChannel : LN.orderChannel,
          //     style: TextStyle(
          //       fontSize: size.getS(15),
          //       color: Colors.white,
          //       fontWeight: FontWeight.bold,
          //     ),
          //   ),
          //   tilePadding: EdgeInsets.symmetric(horizontal: size.getW(8)),
          //   children: [
          //     if (orderP.orderDetailSecRes?.channelWithOrderTypes?.isNotEmpty ??
          //         false)
          //       ...List.generate(
          //         orderP.orderDetailSecRes!.channelWithOrderTypes!.length,
          //         (index) => InkWell(
          //           onTap: () {
          //             orderP.channelIndex = index;
          //             orderP.orderTypeIndex = 0;
          //             orderP.channelStatusIndex = 0;
          //             orderP.tableIndex = 0;
          //             orderP.searchCltr.clear();
          //             orderP.loading = true;
          //             orderP.notify;
          //             orderP.getData();
          //           },
          //           child: Container(
          //             width: double.infinity,
          //             padding: EdgeInsets.symmetric(
          //                 horizontal: size.getW(12), vertical: size.getH(12)),
          //             decoration: BoxDecoration(
          //               color:
          //                   orderP.channelIndex == index ? kSecondaryColor : null,
          //               // border: Border.all(
          //               //   color: kSecondaryColor,
          //               // ),
          //             ),
          //             child: Text(
          //               orderP.orderDetailSecRes!.channelWithOrderTypes![index]
          //                       .channelName ??
          //                   '',
          //               style: TextStyle(
          //                 fontSize: size.getS(16),
          //                 color: orderP.channelIndex == index
          //                     ? Colors.white
          //                     : Colors.white,
          //                 fontWeight: FontWeight.bold,
          //               ),
          //             ),
          //           ),
          //         ),
          //       )
          //   ],
          // ),
          SizedBox(height: size.getH(16)),
          if (orderP.orderDetailSecRes?.orderChannels?.isNotEmpty ?? false)
            ...List.generate(
              orderP.orderDetailSecRes!.orderChannels!.length,
              (index) => InkWell(
                onTap: orderP.loading
                    ? null
                    : () {
                        orderP.channelIndex = index;
                        orderP.orderTypeIndex = null;
                        orderP.channelStatusIndex = 0;
                        orderP.tableIndex = 0;
                        orderP.searchCltr.clear();
                        orderP.loading = true;
                        orderP.notify;
                        orderP.getData();
                      },
                child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(
                      horizontal: size.getW(12), vertical: size.getH(12)),
                  decoration: BoxDecoration(
                    color:
                        orderP.channelIndex == index ? kSecondaryColor : null,
                    // border: Border.all(
                    //   color: kSecondaryColor,
                    // ),
                  ),
                  child: Text(
                    orderP.orderDetailSecRes!.orderChannels![index].name ?? '',
                    style: TextStyle(
                      fontSize: size.getS(20),
                      color: orderP.channelIndex == index
                          ? Colors.white
                          : Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          SizedBox(height: size.getH(16)),
          Divider(
            color: Colors.white,
            thickness: 1.2,
          ),
          SizedBox(height: size.getH(16)),
          if (orderP.orderDetailSecRes?.orderTypes?.isNotEmpty ?? false)
            ...List.generate(
              orderP.orderDetailSecRes!.orderTypes!.length,
              (index) => InkWell(
                onTap: orderP.loading
                    ? null
                    : () {
                        if (orderP.orderTypeIndex == index)
                          orderP.orderTypeIndex = null;
                        else
                          orderP.orderTypeIndex = index;
                        orderP.channelStatusIndex = 0;
                        orderP.tableIndex = 0;
                        orderP.searchCltr.clear();
                        orderP.loading = true;
                        orderP.notify;
                        orderP.getData();
                      },
                child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(
                      horizontal: size.getW(12), vertical: size.getH(12)),
                  decoration: BoxDecoration(
                    color: orderP.orderTypeIndex == index
                        ? Colors.green.shade700
                        : null,
                  ),
                  child: Text(
                    orderP.orderDetailSecRes!.orderTypes![index].value ?? '',
                    style: TextStyle(
                      fontSize: size.getS(20),
                      color: orderP.orderTypeIndex == index
                          ? Colors.white
                          : Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            )
          // ExpansionTile(
          //   initiallyExpanded: true,
          //   iconColor: Colors.white,
          //   collapsedIconColor: Colors.white,
          //   title: Text(
          //     GlobalCVP.isServiceStore ? LN.serviceType : LN.orderType,
          //     style: TextStyle(
          //       fontSize: size.getS(15),
          //       color: Colors.white,
          //       fontWeight: FontWeight.bold,
          //     ),
          //   ),
          //   tilePadding: EdgeInsets.symmetric(horizontal: size.getW(8)),
          //   children: [
          //     if (orderP
          //             .orderDetailSecRes
          //             ?.channelWithOrderTypes?[orderP.channelIndex!]
          //             .orderTypes
          //             ?.isNotEmpty ??
          //         false)
          //       ...List.generate(
          //         orderP
          //             .orderDetailSecRes!
          //             .channelWithOrderTypes![orderP.channelIndex!]
          //             .orderTypes!
          //             .length,
          //         (index) => InkWell(
          //           onTap: () {
          //             orderP.orderTypeIndex = index;
          //             orderP.channelStatusIndex = 0;
          //             orderP.tableIndex = 0;
          //             orderP.searchCltr.clear();
          //             orderP.loading = true;
          //             orderP.notify;
          //             orderP.getData();
          //           },
          //           child: Container(
          //             width: double.infinity,
          //             padding: EdgeInsets.symmetric(
          //                 horizontal: size.getW(12), vertical: size.getH(12)),
          //             decoration: BoxDecoration(
          //               color: orderP.orderTypeIndex == index
          //                   ? kSecondaryColor
          //                   : null,
          //             ),
          //             child: Text(
          //               orderP
          //                       .orderDetailSecRes!
          //                       .channelWithOrderTypes?[orderP.channelIndex!]
          //                       .orderTypes![index]
          //                       .name ??
          //                   '',
          //               style: TextStyle(
          //                 fontSize: size.getS(16),
          //                 color: orderP.orderTypeIndex == index
          //                     ? Colors.white
          //                     : Colors.white,
          //                 fontWeight: FontWeight.bold,
          //               ),
          //             ),
          //           ),
          //         ),
          //       )
          //   ],
          // ),
        ],
      ),
    );
  }
}
