import 'package:flutter/material.dart';
import 'package:pos_account/config/size_config.dart';
import 'package:pos_account/constant/constant.dart';
import 'package:pos_account/ln.dart';
import 'package:pos_account/providers/setting/pay_method_pro.dart';
import 'package:pos_account/widgets/input/text_form/title_text_form.dart';
import 'package:pos_account/widgets/switch_adap.dart';

class PaymentComponent extends StatelessWidget {
  final int index;
  final PayMethodPro payMethodPro;
  const PaymentComponent({
    super.key,
    required this.index,
    required this.payMethodPro,
  });

  @override
  Widget build(BuildContext context) {
    final size = Ssize(context);
    final payMethodData = payMethodPro.getAllPaymentMethod?.data?[index];

    final _name = payMethodData?.paymentMethodName;

    return SizedBox(
      width: size.width / 2.2,
      child: Card(
        child: Padding(
          padding: EdgeInsets.symmetric(
              horizontal: size.getW(16), vertical: size.getH(12)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    decoration: BoxDecoration(
                        shape: BoxShape.circle, color: Colors.grey.shade100),
                    padding: EdgeInsets.all(size.getS(16)),
                    child: Icon(
                      Icons.payment,
                      size: size.getS(25),
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(width: size.getW(24)),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          payMethodData?.paymentMethodName ?? '',
                          style: TextStyle(
                            fontSize: size.getS(21),
                            fontFamily: kFontFMedium,
                            color: Colors.black,
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(
                              color: payMethodData?.isActive == true
                                  ? Colors.green.shade700
                                  : Colors.grey.shade200,
                              borderRadius: BorderRadius.circular(20)),
                          padding: EdgeInsets.symmetric(
                              horizontal: size.getW(12),
                              vertical: size.getH(4)),
                          child: Text(
                            payMethodData?.isActive == true
                                ? "Active"
                                : "InActive",
                            style: TextStyle(
                              fontSize: size.getS(13),
                              fontWeight: FontWeight.bold,
                              color: payMethodData?.isActive == true
                                  ? Colors.white
                                  : Colors.black,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    'Enable',
                    style: TextStyle(
                      fontSize: size.getS(16),
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(width: size.getW(16)),
                  SwitchAdap(
                    size: size,
                    value: payMethodData?.isActive ?? false,
                    onChanged: (val) {
                      payMethodData?.isActive =
                          !(payMethodData.isActive ?? false);
                      payMethodPro.notify;
                    },
                  )
                ],
              ),
              SizedBox(height: size.getH(12)),
              Card(
                color: Colors.grey.shade50,
                child: Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: size.getW(16), vertical: size.getH(16)),
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        TitleTextForm(
                            pWidth: 0.6,
                            isReq: false,
                            borderColor: Colors.black26,
                            title: _name == PayMethodEnum.GooglePay.name
                                ? "Merchant ID"
                                : _name == PayMethodEnum.Paypal.name
                                    ? "Client ID"
                                    : _name == PayMethodEnum.WindCavePay.name
                                        ? "Username"
                                        : _name == PayMethodEnum.Stripe.name
                                            ? "Publishable Key"
                                            : "",
                            hintText: _name == PayMethodEnum.GooglePay.name
                                ? "Enter Merchant ID"
                                : _name == PayMethodEnum.Paypal.name
                                    ? "Enter Client ID"
                                    : _name == PayMethodEnum.WindCavePay.name
                                        ? "Enter Username"
                                        : _name == PayMethodEnum.Stripe.name
                                            ? "Enter Publishable Key"
                                            : "",
                            preTitleIcon: Padding(
                              padding: EdgeInsets.only(right: size.getW(12)),
                              child: Icon(
                                Icons.key,
                                size: size.getS(24),
                                color: Colors.black,
                              ),
                            ),
                            textCltr:
                                payMethodData?.paymentCredentials?.keyOrId ??
                                    TextEditingController()),
                        if (_name == PayMethodEnum.WindCavePay.name ||
                            _name == PayMethodEnum.Stripe.name) ...[
                          SizedBox(height: size.getH(12)),
                          TitleTextForm(
                              pWidth: 0.6,
                              isReq: false,
                              borderColor: Colors.black26,
                              title: "Secret Key",
                              hintText: "Enter Secret Key",
                              preTitleIcon: Padding(
                                padding: EdgeInsets.only(right: size.getW(12)),
                                child: Icon(
                                  Icons.lock_outline,
                                  size: size.getS(24),
                                  color: Colors.black,
                                ),
                              ),
                              textCltr:
                                  payMethodData?.paymentCredentials?.secret ??
                                      TextEditingController()),
                          SizedBox(height: size.getH(12)),
                          Card(
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: size.getW(16),
                                  vertical: size.getH(16)),
                              child: Row(
                                children: [
                                  TitleTextForm(
                                      title: "Surcharge",
                                      borderColor: Colors.black26,
                                      pWidth: 0.20,
                                      textInputType: TextInputType.number,
                                      preTitleIcon: Padding(
                                        padding: EdgeInsets.only(
                                            right: size.getW(12)),
                                        child: Icon(
                                          Icons.percent,
                                          size: size.getS(24),
                                          color: Colors.black,
                                        ),
                                      ),
                                      textCltr:
                                          payMethodData?.surchargePercentage ??
                                              TextEditingController()),
                                  SizedBox(
                                    width: size.getW(24),
                                  ),
                                  InkWell(
                                    onTap: () {
                                      payMethodData?.enableSurcharge =
                                          !(payMethodData.enableSurcharge ??
                                              false);
                                      payMethodPro.notify;
                                    },
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          LN.isActive,
                                          style: TextStyle(
                                            fontSize: size.getS(18),
                                            color: Colors.black,
                                            fontWeight: FontWeight.normal,
                                          ),
                                        ),
                                        IgnorePointer(
                                          ignoring: true,
                                          child: SwitchAdap(
                                            size: size,
                                            value: payMethodData
                                                    ?.enableSurcharge ??
                                                false,
                                            activeColor: kSecondaryColor,
                                            onChanged: (_) {},
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                          )
                        ]
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
