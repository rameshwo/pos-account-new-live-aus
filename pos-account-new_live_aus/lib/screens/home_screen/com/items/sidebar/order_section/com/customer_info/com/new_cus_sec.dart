import 'package:flutter/material.dart';
import 'package:pos_account/config/size_config.dart';
import 'package:pos_account/config/validator.dart';
import 'package:pos_account/constant/constant.dart';
import 'package:pos_account/ln.dart';
import 'package:pos_account/providers/menu/payment_pro.dart';
import 'package:pos_account/widgets/image/network_image_sec.dart';
import 'package:pos_account/widgets/input/dropdown/dropdown_with_text_form.dart';
import 'package:pos_account/widgets/input/dropdown/title_drop_down.dart';
import 'package:pos_account/widgets/input/text_form/title_text_form.dart';
import 'package:pos_account/widgets/switch_adap.dart';

class NewCusSec extends StatelessWidget {
  final PaymentPro payPro;
  final Ssize size;
  const NewCusSec({
    super.key,
    required this.payPro,
    required this.size,
  });

  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TitleTextForm(
              title: LN.name,
              textCltr: payPro.cusNameCltr,
              pWidth: 0.28,
              borderColor: Colors.black26,
            ),
            SizedBox(
              height: size.getH(12),
            ),
            DropDownWiTextForm(
              title: LN.phoneNumber,
              isReq: true,
              pWidth: 0.28,
              indexVal: payPro.phoneCodeIndex,
              list: payPro.customerAddSecRes?.countries == null
                  ? []
                  : payPro.customerAddSecRes!.countries!
                      .map((e) => Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              NetworkImageSec(
                                image: e.image,
                                height:
                                    size.isProt ? size.getW(12) : size.getW(16),
                                width:
                                    size.isProt ? size.getW(12) : size.getW(16),
                              ),
                              if (e.additionalValue is String)
                                Flexible(
                                  child: Align(
                                    alignment: Alignment.centerRight,
                                    child: Text(
                                      e.additionalValue,
                                      style: TextStyle(
                                        fontSize: size.isProt
                                            ? size.getW(12)
                                            : size.getS(16),
                                        color: Colors.black,
                                      ),
                                    ),
                                  ),
                                )
                            ],
                          ))
                      .toList(),
              onChanged: (p0) {
                payPro.phoneCodeIndex = p0;
                payPro.notify;
              },
              textCltr: payPro.cusPhoneCltr,
              borderColor: Colors.black26,
            ),
            SizedBox(
              height: size.getH(12),
            ),
            TitleTextForm(
              title: LN.email,
              textCltr: payPro.cusEmailCltr,
              isReq: false,
              pWidth: 0.28,
              borderColor: Colors.black26,
              validator: emailValidator,
              textInputType: TextInputType.emailAddress,
            ),
            SizedBox(
              height: size.getH(12),
            ),
            SearchTitleDropDown(
              pWidth: 0.28,
              title: LN.country,
              isReq: true,
              list: payPro.customerAddSecRes?.countries == null
                  ? []
                  : payPro.customerAddSecRes!.countries!
                      .map((e) => e.name ?? '')
                      .toList(),
              indexVal: payPro.countryIndex,
              onChanged: (p0) {
                payPro.countryIndex = p0;
                payPro.phoneCodeIndex = p0;
                payPro.notify;
              },
              borderColor: Colors.black26,
            ),
            SizedBox(
              height: size.getH(12),
            ),
            TitleTextForm(
              title: LN.postalCode,
              textCltr: payPro.postalCodeCltr,
              isReq: false,
              pWidth: 0.28,
              borderColor: Colors.black26,
              textInputType: TextInputType.number,
            ),
            SizedBox(
              height: size.getH(12),
            ),
            TitleDropDown(
              pWidth: 0.28,
              title: LN.customerType,
              hintText: LN.customerType,
              isReq: true,
              list: payPro.customerAddSecRes == null ||
                      payPro.customerAddSecRes!.customerType == null
                  ? []
                  : payPro.customerAddSecRes!.customerType!
                      .map((e) => e.name ?? '')
                      .toList(),
              indexVal: payPro.customerTypeIndex,
              onChanged: (p0) {
                payPro.customerTypeIndex = p0;
                payPro.notify;
              },
              borderColor: Colors.black26,
            ),
            SizedBox(
              height: size.getH(12),
            ),
            TitleDropDown(
              pWidth: 0.28,
              title: "Customer Group",
              hintText: "Customer Group",
              isReq: false,
              list: payPro.customerAddSecRes == null ||
                      payPro.customerAddSecRes!.customerGroups == null
                  ? []
                  : payPro.customerAddSecRes!.customerGroups!
                      .map((e) => e.name ?? '')
                      .toList(),
              indexVal: payPro.customerGroupIndex,
              onChanged: (p0) {
                payPro.customerGroupIndex = p0;
                payPro.notify;
              },
              borderColor: Colors.black26,
            ),
            SizedBox(
              height: size.getH(24),
            ),
            InkWell(
              onTap: () {
                payPro.recieveMarketMat = !payPro.recieveMarketMat;
                payPro.notify;
              },
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IgnorePointer(
                    ignoring: true,
                    child: SwitchAdap(
                        activeColor: kSecondaryColor,
                        value: payPro.recieveMarketMat,
                        size: size,
                        onChanged: (val) {}),
                  ),
                  SizedBox(width: size.getW(12)),
                  Text(
                    LN.receiveMarMat,
                    style: TextStyle(
                      fontSize: size.getS(16),
                      color: payPro.recieveMarketMat
                          ? kSecondaryColor
                          : Colors.black,
                      fontFamily: kFontFMedium,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: size.getH(12),
            ),
            InkWell(
              onTap: () {
                payPro.loyalityEnable = !payPro.loyalityEnable;
                if (payPro.cusForLoyalityRes != null)
                  payPro.cusForLoyalityRes!.loyaltyEnabled =
                      payPro.loyalityEnable;
                payPro.notify;
              },
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IgnorePointer(
                    ignoring: true,
                    child: SwitchAdap(
                        activeColor: kSecondaryColor,
                        value: payPro.loyalityEnable,
                        size: size,
                        onChanged: (val) {
                          // paymentPro.loyalityEnable = val;
                          // if (paymentPro.cusForLoyalityRes != null)
                          //   paymentPro.cusForLoyalityRes!
                          //       .loyaltyEnabled = val;
                          // paymentPro.notify;
                        }),
                  ),
                  SizedBox(width: size.getW(12)),
                  Text(
                    LN.enableLoyal,
                    style: TextStyle(
                      fontSize: size.getS(16),
                      color: payPro.loyalityEnable
                          ? kSecondaryColor
                          : Colors.black,
                      fontFamily: kFontFMedium,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: size.getH(24),
            ),
          ],
        ),
      ),
    );
  }
}
