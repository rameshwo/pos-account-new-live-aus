import 'package:flutter/material.dart';
import 'package:pos_account/config/size_config.dart';
import 'package:pos_account/constant/constant.dart';
import 'package:pos_account/ln.dart';
import 'package:pos_account/providers/menu/orders_pro.dart';
import 'package:pos_account/widgets/image/network_image_sec.dart';
import 'package:pos_account/widgets/input/dropdown/dropdown_with_text_form.dart';
import 'package:pos_account/widgets/input/text_form/title_text_form.dart';
import 'package:pos_account/widgets/load_btn.dart';
import 'package:provider/provider.dart';

class SendSmsDia extends StatefulWidget {
  const SendSmsDia({super.key});

  @override
  State<SendSmsDia> createState() => _SendSmsDiaState();
}

class _SendSmsDiaState extends State<SendSmsDia> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final size = Ssize(context);
    final orderPro = Provider.of<OrderPro>(context);
    return Container(
      constraints: BoxConstraints(
        maxHeight: size.height / 1.15,
        minHeight: size.height / 5,
      ),
      // width: size.getW(500),
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            children: [
              Stack(
                children: [
                  Center(
                    child: Text(
                      LN.sendSms,
                      style: TextStyle(
                        fontSize: size.getS(24),
                        color: Colors.black,
                        fontFamily: kFontFMedium,
                      ),
                    ),
                  ),
                  Align(
                      alignment: Alignment.topRight,
                      child: InkWell(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Icon(
                          Icons.close,
                          size: size.getS(28),
                        ),
                      ))
                ],
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: size.getW(12)),
                child: Column(
                  children: [
                    SizedBox(
                      height: size.getH(12),
                    ),
                    TitleTextForm(
                      title: LN.name,
                      hintText: LN.enterName,
                      textCltr: orderPro.smsNameCltr,
                      borderColor: Colors.black26,
                      vPad: 14,
                    ),
                    SizedBox(
                      height: size.getH(16),
                    ),
                    DropDownWiTextForm(
                      pWidth: 0.33,
                      title: LN.phoneNumber,
                      isReq: true,
                      borderColor: Colors.black26,
                      indexVal: orderPro.selectedCountryCode,
                      vPad: 14,
                      list: (orderPro.countryList?.isNotEmpty ?? false)
                          ? orderPro.countryList!
                              .map((a) => Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      NetworkImageSec(
                                        image: a.image,
                                        height: size.isProt
                                            ? size.getW(12)
                                            : size.getW(16),
                                        width: size.isProt
                                            ? size.getW(12)
                                            : size.getW(16),
                                      ),
                                      Flexible(
                                        child: Align(
                                          alignment: Alignment.centerRight,
                                          child: Text(
                                            a.additionalValue ?? '',
                                            style: TextStyle(
                                              fontSize: size.isProt
                                                  ? size.getW(12)
                                                  : size.getS(16),
                                              color: Colors.black,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ))
                              .toList()
                          : [],
                      onChanged: (p0) {
                        orderPro.selectedCountryCode = p0 ?? 0;
                        orderPro.notify;
                      },
                      textCltr: orderPro.smsPhoneCltr,
                    ),
                    SizedBox(
                      height: size.getH(12),
                    ),
                    TitleTextForm(
                      title: LN.message,
                      hintText: LN.enterMsg,
                      textCltr: orderPro.smsMessageCltr,
                      borderColor: Colors.black26,
                      vPad: 14,
                      maxLines: 5,
                    ),
                    SizedBox(
                      height: size.getH(24),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: size.getW(6)),
                      child: LoadButton(
                        width: double.infinity,
                        btnText: LN.sendSms,
                        vPad: 14,
                        loading: orderPro.sendSmsBtnLoad,
                        onsave: () {
                          if (_formKey.currentState?.validate() ?? false) {
                            orderPro.sendSmsOrderReady(context);
                          }
                        },
                      ),
                    ),
                    SizedBox(
                      height: size.getH(24),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
