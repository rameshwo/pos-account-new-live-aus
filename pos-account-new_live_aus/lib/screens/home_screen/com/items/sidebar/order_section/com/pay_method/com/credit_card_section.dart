import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pos_account/config/credit_card_validator.dart';
import 'package:pos_account/config/size_config.dart';
import 'package:pos_account/constant/constant.dart';
import 'package:pos_account/providers/menu/payment_pro.dart';
import 'package:pos_account/screens/home_screen/com/subscription/billing_subs/billing_subs_screen.dart';
import 'package:pos_account/widgets/input/text_form/text_fwtw.dart';
import '../../../../../../../../../ln.dart';

class CreditCardSection extends StatelessWidget {
  const CreditCardSection({
    super.key,
    required this.paymentPro,
  });

  final PaymentPro paymentPro;

  @override
  Widget build(BuildContext context) {
    final size = Ssize(context);
    return Card(
        color: kPrimaryColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: Padding(
          padding: EdgeInsets.symmetric(
              vertical: size.getH(8.0), horizontal: size.getW(12)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFWTWidget(
                textCltr: paymentPro.nameOnCardCltr,
                title: LN.fullName,
                hintText: LN.nameOnCard,
                autoValidation: true,
                inputType: TextInputType.name,
                isReq: true,
              ),
              TextFWTWidget(
                textCltr: paymentPro.cardNumberCltr,
                title: LN.cardNum,
                hintText: LN.yourCardNum,
                autoValidation: true,
                inputType: TextInputType.number,
                isReq: true,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(16),
                  CardNumberInputFormatter()
                ],
                validator: (val) =>
                    CreditCValidator.validateCreditCaardNum(val!),
              ),
              Row(
                children: [
                  Expanded(
                    child: TextFWTWidget(
                      textCltr: paymentPro.expiryMonthCltr,
                      title: LN.expiryMonth,
                      hintText: "MM",
                      maxLength: 2,
                      autoValidation: true,
                      inputType: TextInputType.number,
                      isReq: true,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    ),
                  ),
                  SizedBox(
                    width: size.getW(12),
                  ),
                  Expanded(
                    child: TextFWTWidget(
                      textCltr: paymentPro.expiryYearCltr,
                      title: LN.expiryYear,
                      hintText: "YY",
                      maxLength: 4,
                      autoValidation: true,
                      inputType: TextInputType.number,
                      isReq: true,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    ),
                  ),
                  SizedBox(
                    width: size.getW(12),
                  ),
                  Expanded(
                    child: TextFWTWidget(
                      textCltr: paymentPro.cVCNumberCltr,
                      title: LN.cvv,
                      hintText: LN.cvv,
                      autoValidation: true,
                      maxLength: 3,
                      inputType: TextInputType.number,
                      isReq: true,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    ),
                  )
                ],
              ),
            ],
          ),
        ));
  }
}
