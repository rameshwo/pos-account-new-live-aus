import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pos_account/config/size_config.dart';
import 'package:pos_account/constant/constant.dart';
import 'package:pos_account/ln.dart';
import 'package:pos_account/providers/menu/orders_pro.dart';
import 'package:pos_account/providers/menu/payment_pro.dart';
import 'package:pos_account/screens/home_screen/com/items/sidebar/order_section/com/pay_method/com/card_button.dart';
import 'package:pos_account/widgets/load_btn.dart';
import 'package:provider/provider.dart';

class ChangePayMethodDia extends StatelessWidget {
  final String? id;
  const ChangePayMethodDia({
    super.key,
    this.id,
  });

  static Future<dynamic> show({String? id}) {
    return showCupertinoDialog(
        context: CUS_CTX!,
        builder: (_) {
          return SimpleDialog(
            titlePadding: EdgeInsets.zero,
            contentPadding: EdgeInsets.zero,
            insetPadding: EdgeInsets.zero,
            children: [ChangePayMethodDia(id: id)],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    final size = Ssize(context);
    final orderPro = Provider.of<OrderPro>(context);
    final payMethodList = orderPro.payMethodList ?? [];
    return Container(
      width: size.getW(400),
      padding: EdgeInsets.fromLTRB(
          size.getW(24), size.getH(16), size.getW(24), size.getH(24)),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Update Payment Method',
                style: TextStyle(
                  fontSize: size.getS(20),
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),
              IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: Icon(
                    Icons.close,
                    size: size.getS(25),
                  ))
            ],
          ),
          SizedBox(
            height: size.getH(12.0),
          ),
          if (payMethodList.isNotEmpty)
            Row(
              children: [
                ...List.generate(payMethodList.length, (index) {
                  final _payMethod =
                      PayMethodClass.getMethod(payMethodList[index].name);

                  if (_payMethod != PayMethodEnum.Cash &&
                      _payMethod != PayMethodEnum.FPOS) {
                    return SizedBox.shrink();
                  } else
                    return Expanded(
                      child: CardButton(
                        title: payMethodList[index].name ?? '',
                        tileColor: TileColor.getColor(
                          backColor:
                              payMethodList[index].defaultBackGroundColor,
                          textColor: payMethodList[index].defaultTextColor,
                          selectedBackColor:
                              payMethodList[index].onFocusBackGroundColor,
                          selectedTextColor:
                              payMethodList[index].onFocusTextColor,
                        ),
                        // imgPath: widget.payPro.paySecListRes!
                        //     .paymentMethods![index].image,
                        onTap: _payMethod == PayMethodEnum.Loyalty
                            ? null
                            : () {
                                for (final e in payMethodList) {
                                  e.isSelected = false;
                                }
                                payMethodList[index].isSelected = true;
                                orderPro.notify;
                              },
                        isSelected: payMethodList[index].isSelected ?? false,
                      ),
                    );
                }),
              ],
            ),
          SizedBox(
            height: size.getH(24.0),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              // LoadButton(
              //   btnText: LN.cancel,
              //   hPad: 2,
              //   btnColor: Colors.white,
              //   textColor: Colors.red,
              //   shape: RoundedRectangleBorder(
              //       borderRadius: BorderRadius.circular(5),
              //       side: BorderSide(color: Colors.red)),
              //   // vPad: 4,
              //   onsave: () {},
              // ),
              Expanded(
                child: LoadButton(
                  btnText: LN.update,
                  hPad: 2,
                  vPad: 10,
                  // vPad: 4,
                  loading: orderPro.updatePayLoad,
                  loadingText: "Updating",
                  onsave: () async {
                    final _status = await orderPro.updatePayMethod(id);
                    if (_status) Navigator.pop(context, true);
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
