import 'package:flutter/material.dart';
import 'package:pos_account/config/size_config.dart';
import 'package:pos_account/constant/constant.dart';
import 'package:pos_account/providers/menu/gift_card/new_gift_card_pro.dart';
import 'package:pos_account/widgets/image/svg_image_sec.dart';
import 'package:pos_account/widgets/input/text_form/title_text_form.dart';
import 'package:pos_account/widgets/load_btn.dart';
import 'package:provider/provider.dart';
import '../../../../../../../ln.dart';

class MakePayDia extends StatelessWidget {
  const MakePayDia({super.key});

  static final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final size = Ssize(context);
    final pro = Provider.of<NewGiftCardPro>(context);
    return Container(
      constraints: BoxConstraints(
        maxHeight: size.height / 1.5,
        minHeight: size.height / 5,
      ),
      width: size.width / 2,
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                height: size.getH(12),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Make Payment",
                    style: TextStyle(
                      fontSize: size.getS(18),
                      fontFamily: kFontFMedium,
                      color: Colors.black,
                    ),
                  ),
                  IconButton(
                      padding: EdgeInsets.zero,
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: Icon(
                        Icons.close,
                        size: size.getS(24),
                      ))
                ],
              ),
              Divider(
                color: Colors.black54,
              ),
              if (pro.addSec?.paymentMethods != null)
                SizedBox(
                  height: size.getH(180),
                  child: Wrap(
                    spacing: size.getW(16),
                    runSpacing: size.getH(12),
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      ...List.generate(
                        pro.addSec!.paymentMethods!.length,
                        (index) => _payOptionSection(
                          size: size,
                          asset: pro.addSec!.paymentMethods![index].image ?? '',
                          title: pro.addSec!.paymentMethods![index].value ?? '',
                          isSelected: pro.payOptionIndex == index,
                          onTap: () {
                            pro.payOptionIndex = index;
                            pro.notify;
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              SizedBox(
                height: size.getH(24),
              ),
              Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(
                    horizontal: size.getW(12), vertical: size.getH(24)),
                decoration: BoxDecoration(
                  color: kBackgroundColor,
                ),
                child: Wrap(
                  spacing: size.getW(24),
                  children: [
                    TitleTextForm(
                      title: LN.amount,
                      pWidth: 0.16,
                      borderColor: Colors.black38,
                      textCltr: pro.paidAmountCltr,
                      textInputType: TextInputType.number,
                      hintText: '0.00',
                    ),
                    //TODO
                    // Column(
                    //   mainAxisSize: MainAxisSize.min,
                    //   children: [
                    //     Text(
                    //       "Scheduled For Future",
                    //       style: TextStyle(
                    //         fontSize: size.getS(18),
                    //         fontFamily: kFontFMedium,
                    //         color: Colors.black,
                    //       ),
                    //     ),
                    //     SizedBox(
                    //       height: size.getH(12),
                    //     ),
                    //     SwitchAdap(
                    //       size: size,
                    //       value: pro.isScheduledForFuture,
                    //       activeColor: kPrimaryColor,
                    //       height: 36,
                    //       onChanged: (p0) {
                    //         pro.isScheduledForFuture = p0;
                    //         pro.makePayDateCltr.clear();
                    //         pro.notify;
                    //       },
                    //     )
                    //   ],
                    // ),
                    // if (pro.isScheduledForFuture)
                    //   TitleTextForm(
                    //     title: "Date",
                    //     pWidth: 0.16,
                    //     isReq: true,
                    //     readOnly: true,
                    //     borderColor: Colors.black38,
                    //     textCltr: TextEditingController(
                    //         text: pro.makePayDateCltr.text.split(' ').isNotEmpty
                    //             ? pro.makePayDateCltr.text.split(' ').first
                    //             : ''),
                    //     hintText: 'dd/mm/yyyy',
                    //     suffixIcon: Icon(Icons.calendar_today),
                    //     onTap: () {
                    //       datePick(context).then((_date) {
                    //         if (_date == null) return;
                    //         final _dateTime = DateTime(
                    //           _date.year,
                    //           _date.month,
                    //           _date.day,
                    //         );
                    //         pro.makePayDateCltr.text =
                    //             DateFormat(pro.dateFormat).format(_dateTime);
                    //         pro.notify;
                    //       });
                    //     },
                    //   ),
                  ],
                ),
              ),
              Divider(
                color: Colors.black54,
              ),
              SizedBox(
                height: size.getH(8),
              ),
              Row(
                children: [
                  LoadButton(
                    btnText: LN.pay,
                    btnColor: kSecondaryColor,
                    loading: pro.payLoad,
                    onsave: () {
                      FocusScope.of(context).unfocus();
                      if (_formKey.currentState!.validate()) {
                        pro.addUpData();
                      }
                    },
                  ),
                  SizedBox(
                    width: size.getW(16),
                  ),
                  LoadButton(
                    btnText: LN.cancel,
                    btnColor: Colors.red.shade600,
                    width: 140,
                    onsave: () {
                      Navigator.pop(context);
                    },
                  ),
                ],
              ),
              SizedBox(
                height: size.getH(32),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _payOptionSection({
    required Ssize size,
    Function()? onTap,
    required String asset,
    required String title,
    bool isSelected = false,
  }) {
    final double inc = isSelected ? 1.12 : 1;
    return Container(
      decoration: BoxDecoration(
          color: isSelected ? kSecondaryColor : Colors.transparent,
          border: Border.all(
            color: kSecondaryColor,
            width: 2.5,
          ),
          borderRadius: BorderRadius.circular(5)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(5),
        child: Padding(
          padding: EdgeInsets.symmetric(
              horizontal: size.getS(32), vertical: size.getS(16)),
          child: Column(
            children: [
              AnimatedContainer(
                duration: Duration(milliseconds: 300),
                curve: Curves.linear,
                height: size.getS(100 * inc),
                width: size.getS(100 * inc),
                child: SvgImageSection(
                  imageUrl: asset,
                  color: isSelected ? Colors.white : null,
                ),
              ),
              SizedBox(
                height: size.getH(4),
              ),
              Text(
                title,
                style: TextStyle(
                  fontSize: size.getS(18 * inc),
                  fontFamily: kFontFBold,
                  color: isSelected ? Colors.white : Colors.black,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
