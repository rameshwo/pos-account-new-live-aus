import 'package:flutter/material.dart';
import 'package:oktoast/oktoast.dart';
import 'package:pos_account/config/size_config.dart';
import 'package:pos_account/config/validator.dart';
import 'package:pos_account/constant/constant.dart';
import 'package:pos_account/model/ui_model/amount_class.dart';
import 'package:pos_account/providers/menu/payment_pro.dart';
import 'package:pos_account/screens/home_screen/com/items/com/price_update_dia.dart';
import 'package:provider/provider.dart';

class AddDiscountAmtSec extends StatelessWidget {
  const AddDiscountAmtSec({super.key});

  Future<void> _onPressed(BuildContext context, Ssize size) async {
    final payPro = Provider.of<PaymentPro>(context, listen: false);

    final _allAmount = payPro.getAllAmount;

    final _discountText = _allAmount.discount == 0
        ? ""
        : (_allAmount.taxType == TaxType.Inclusive
            ? _allAmount.discountWithTax.roundToNString()
            : _allAmount.discount.roundToNString());

    final _discount = await PriceUpdateDia.showDia(
      context,
      number: _discountText.inDouble,
      title: "Discount Amount",
    );
    // final _val = await showDialog(
    //     context: context,
    //     builder: (_) {
    //       return SimpleDialog(
    //         contentPadding: EdgeInsets.symmetric(
    //             horizontal: size.getW(24), vertical: size.getH(24)),
    //         children: [
    //           TitleTextForm(
    //             title: LN.discountAmt,
    //             isReq: true,
    //             hintText: "0",
    //             pWidth: 0.24,
    //             textCltr: _textCltr,
    //             textInputType: TextInputType.number,
    //             inputFormatters: [NonNegativeTextInputFormatter()],
    //             prefixText: Text(
    //               "${_payPro.curSym}",
    //               style: TextStyle(
    //                 color: Colors.black,
    //               ),
    //             ),
    //             suffix: InkWell(
    //                 onTap: () {
    //                   Navigator.pop(context);
    //                 },
    //                 child: Icon(Icons.close)),
    //           ),
    //           SizedBox(
    //             height: size.getH(12),
    //           ),
    //           Row(
    //             children: [
    //               Expanded(
    //                 child: LoadButton(
    //                   btnColor: Colors.red,
    //                   btnText: LN.cancel,
    //                   hPad: 12,
    //                   vPad: 8,
    //                   onsave: () {
    //                     Navigator.pop(context);
    //                   },
    //                 ),
    //               ),
    //               SizedBox(
    //                 width: size.getW(8),
    //               ),
    //               Expanded(
    //                 child: LoadButton(
    //                   btnText: LN.confirm,
    //                   hPad: 12,
    //                   vPad: 8,
    //                   onsave: () {
    //                     Navigator.pop(context, _textCltr.text);
    //                   },
    //                 ),
    //               ),
    //             ],
    //           ),
    //         ],
    //       );
    //     });

    // final double _discount = double.tryParse(_val) ?? 0.0;
    final double _deliveryAmount = payPro.isOrderTypeDelivery
        ? (double.tryParse(payPro.deliveryTextCltr.text) ?? 0)
        : 0;

    final _itemPrice = _allAmount.itemPrice + _deliveryAmount;
    // print("_itemPrice : $_itemPrice | _discount: $_discount ");
    // print("Discount Edit for item Amount $_deliveryAmount");
    if (_discount <= _itemPrice) {
      _allAmount.discount = _discount;
      payPro.discountPercentCltr.text =
          (_discount * 100 / _itemPrice).roundToNString();
      // print("1. discount % : ${_payPro.discountPercentCltr.text}");
      payPro.onChangedPayAmount(
        isUpdatePaidAmount: payPro.paymentType != PaymentType.PartialPayment,
        hasDiscountOnPartial: payPro.paymentType == PaymentType.PartialPayment,
      );
    } else {
      showToast("Discount amount is higher than total Amount");
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = Ssize(context);
    return TextButton(
        style: ButtonStyle(visualDensity: VisualDensity.compact),
        onPressed: () => _onPressed(context, size),
        child: Row(
          children: [
            Icon(
              Icons.edit_outlined,
              color: kSecondaryColor,
              size: size.getS(22),
            ),
            Text(
              "(Edit DA)",
              style: TextStyle(
                fontSize: size.getS(14),
                color: kSecondaryColor,
              ),
            ),
          ],
        ));
  }
}
