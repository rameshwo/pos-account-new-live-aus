import 'package:flutter/material.dart';
import 'package:pos_account/config/size_config.dart';
import 'package:pos_account/constant/constant.dart';
import 'package:pos_account/providers/menu/orders_pro.dart';

class OrderHeader extends StatelessWidget {
  final Function(int)? onTapOrder;
  final OrderPro orderPro;
  const OrderHeader({
    super.key,
    this.onTapOrder,
    required this.orderPro,
  });

  @override
  Widget build(BuildContext context) {
    final size = Ssize(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: size.getH(12),
        ),

        if (orderPro.orderDetailSecRes != null &&
            orderPro.orderDetailSecRes!.orderStatus != null)
          Flexible(
            child: SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              scrollDirection: Axis.horizontal,
              child: Row(
                children: List.generate(
                  orderPro.orderDetailSecRes!.orderStatus!.length,
                  (index) => Padding(
                    padding: EdgeInsets.only(
                        right: size.getW(12.0), bottom: size.getH(12)),
                    child: ElevatedButton(
                        style: ButtonStyle(
                            backgroundColor: WidgetStateProperty.all(
                                orderPro.channelStatusIndex == index
                                    ? kSecondaryColor
                                    : kTempColor),
                            padding: WidgetStateProperty.all(
                                EdgeInsets.symmetric(
                                    horizontal: size.getW(12),
                                    vertical: size.getH(4)))),
                        onPressed: onTapOrder != null
                            ? () => onTapOrder!(index)
                            : null,
                        child: Center(
                          child: Text(
                            orderPro.orderDetailSecRes!.orderStatus![index]
                                    .value ??
                                '',
                            style: TextStyle(
                              fontSize: size.getS(14),
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                            overflow: TextOverflow.visible,
                            textAlign: TextAlign.center,
                          ),
                        )),
                  ),
                ),
              ),
            ),
          ),
        // SizedBox(
        //   height: size.getH(12),
        // ),
      ],
    );
  }
}
