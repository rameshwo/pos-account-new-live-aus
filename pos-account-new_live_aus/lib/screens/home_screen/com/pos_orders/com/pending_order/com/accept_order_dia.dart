import 'package:flutter/material.dart';
import 'package:pos_account/config/size_config.dart';
import 'package:pos_account/ln.dart';
import 'package:pos_account/model/home/menu/orders/all_orders_res.dart';
import 'package:pos_account/providers/menu/orders_pro.dart';
import 'package:pos_account/widgets/load_btn.dart';
import 'pending_order_tile.dart';

class AcceptOrderDia extends StatelessWidget {
  final AllOrderData? allOrder;
  final Function()? onTapBtn;
  final bool isRetail;
  final OrderPro? orderPro;
  const AcceptOrderDia({
    super.key,
    this.allOrder,
    this.onTapBtn,
    required this.isRetail,
    this.orderPro,
  });

  @override
  Widget build(BuildContext context) {
    final size = Ssize(context);
    return Container(
      constraints: BoxConstraints(
        maxHeight: size.height / 1.8,
        minHeight: size.height / 5,
      ),
      // width: size.width / 1.6,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          PendingOrderTile(
            allOrder: allOrder,
            orderPro: orderPro,
            viewOnly: true,
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: size.getW(24)),
            child: LoadButton(
              vPad: 10,
              hPad: 8,
              btnText: isRetail ? LN.processOrder : LN.sentTKtchn,
              width: double.infinity,
              onsave: onTapBtn,
            ),
          ),
        ],
      ),
    );
  }
}
