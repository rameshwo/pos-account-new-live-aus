import 'package:flutter/material.dart';
import 'package:pos_account/config/size_config.dart';
import 'package:pos_account/ln.dart';
import 'package:pos_account/providers/setting/pay_method_pro.dart';
import 'package:pos_account/widgets/load_btn.dart';
import 'package:pos_account/widgets/loading.dart';
import 'package:provider/provider.dart';
import '../general/common/common_header.dart';
import 'com/payment_com.dart';

class PaymentMethod extends StatefulWidget {
  final Function()? onBack;
  const PaymentMethod({super.key, this.onBack});

  @override
  State<PaymentMethod> createState() => _PaymentMethodState();
}

class _PaymentMethodState extends State<PaymentMethod> {
  PayMethodPro? _payMethodPro;

  @override
  void initState() {
    getData();
    super.initState();
  }

  @override
  void dispose() {
    _payMethodPro?.clear();
    super.dispose();
  }

  getData() {
    _payMethodPro = Provider.of<PayMethodPro>(context, listen: false);
    _payMethodPro?.getAllPayMethod();
  }

  @override
  Widget build(BuildContext context) {
    final size = Ssize(context);
    final payMethodPro = Provider.of<PayMethodPro>(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CommonHeader(
          child: Row(
            children: [
              IconButton(
                  onPressed: widget.onBack,
                  icon: Icon(Icons.arrow_back, size: size.getS(24))),
              SizedBox(width: size.getW(8)),
              Text(
                LN.payMethodSetting,
                style: TextStyle(
                  fontSize: size.getS(18),
                  // fontFamily: ,ph
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              Spacer(),
              LoadButton(
                onsave: payMethodPro.addUpPayMethod,
                loading: payMethodPro.updateLoad,
                width: 160,
                vPad: 8,
              ),
            ],
          ),
        ),
        SizedBox(height: size.getH(8)),
        if (payMethodPro.loading)
          Expanded(child: Loading())
        else
          Flexible(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: size.getW(12)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (payMethodPro.getAllPaymentMethod != null &&
                      payMethodPro.getAllPaymentMethod!.data != null &&
                      payMethodPro.getAllPaymentMethod!.data!.isNotEmpty)
                    SizedBox(
                      width: double.infinity,
                      child: Padding(
                          padding: EdgeInsets.symmetric(
                              vertical: size.getH(12.0),
                              horizontal: size.getW(12)),
                          child: Wrap(
                            spacing: size.getW(12),
                            runSpacing: size.getH(12),
                            // alignment: WrapAlignment.center,
                            children: List.generate(
                                payMethodPro.getAllPaymentMethod!.data!.length,
                                (index) {
                              return PaymentComponent(
                                index: index,
                                payMethodPro: payMethodPro,
                              );
                            }),
                          )),
                    ),
                  SizedBox(
                    height: size.getH(24),
                  ),
                  // Row(
                  //   mainAxisAlignment: MainAxisAlignment.end,
                  //   children: [
                  //     LoadButton(
                  //       btnColor: Colors.red.shade700,
                  //       onsave: widget.onBack,
                  //       btnText: LN.cancel,
                  //       width: 160,
                  //     ),
                  //     SizedBox(
                  //       width: size.getW(12),
                  //     ),
                  //     LoadButton(
                  //       onsave: payMethodPro.addUpPayMethod,
                  //       loading: payMethodPro.updateLoad,
                  //       width: 160,
                  //     ),
                  //   ],
                  // )
                ],
              ),
            ),
          ),
      ],
    );
  }
}
