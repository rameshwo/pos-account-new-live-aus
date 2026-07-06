import 'package:flutter/material.dart';
import 'package:pos_account/config/size_config.dart';
import 'package:pos_account/constant/constant.dart';
import 'package:pos_account/ln.dart';
import 'package:pos_account/providers/menu/gift_card/gift_card_check_pro.dart';
import 'package:pos_account/widgets/input/text_form/title_text_form.dart';
import 'package:pos_account/widgets/load_btn.dart';
import 'package:provider/provider.dart';
import '../../../../../../services/database/shared_pref.dart';

class GiftCardEnquirySec extends StatefulWidget {
  const GiftCardEnquirySec({super.key});

  @override
  State<GiftCardEnquirySec> createState() => _GiftCardEnquirySecState();
}

class _GiftCardEnquirySecState extends State<GiftCardEnquirySec> {
  final _formKey = GlobalKey<FormState>();
  late GiftCardCheckPro giftCardCheckPro;
  dynamic curSym = "";

  getCurSym() async {
    curSym = await SharedPrefs.curSym;
    if (mounted) setState(() {});
    giftCardCheckPro.giftCardNoCltr.clear();
    giftCardCheckPro.giftCardCheckModel = null;
  }

  @override
  void initState() {
    giftCardCheckPro = Provider.of<GiftCardCheckPro>(context, listen: false);
    getCurSym();
    super.initState();
  }

  @override
  void dispose() {
    giftCardCheckPro.giftCardNoCltr.clear();
    giftCardCheckPro.giftCardCheckModel = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = Ssize(context);
    final giftPro = Provider.of<GiftCardCheckPro>(context);

    return Card(
      child: Padding(
        padding: EdgeInsets.symmetric(
            horizontal: size.getW(24), vertical: size.getH(12)),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                LN.checkGiftCardAmount,
                style: TextStyle(
                  fontSize: size.getS(18),
                  fontFamily: kFontFMedium,
                  color: Colors.black,
                ),
              ),
              SizedBox(
                height: size.getH(16),
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TitleTextForm(
                    title: LN.giftCardNo,
                    pWidth: 0.24,
                    borderColor: Colors.black38,
                    textCltr: giftPro.giftCardNoCltr,
                    onChanged: (val) {
                      giftPro.giftCardCheckModel = null;
                      giftPro.notify;
                    },
                    // fillColor: Colors.grey.shadse100,
                  ),
                  SizedBox(
                    width: size.getW(20),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 28.0),
                    child: LoadButton(
                      fontSize: size.getS(16),
                      vPad: 10,
                      hPad: 2,
                      width: 200,
                      btnText: LN.checkBalance,
                      loading: giftPro.loading,
                      onsave: () {
                        FocusScope.of(context).unfocus();
                        if (_formKey.currentState?.validate() ?? false) {
                          giftPro.checkBalance();
                        }
                      },
                    ),
                  )
                ],
              ),
              SizedBox(
                height: size.getH(16),
              ),
              Visibility(
                visible: giftPro.giftCardCheckModel != null &&
                    giftPro.giftCardCheckModel?.amount != "",
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "${LN.yourGiftCardBalance} : ",
                      style: TextStyle(
                        fontSize: size.getS(18),
                        fontFamily: kFontFMedium,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(
                      height: size.getH(8),
                    ),
                    Text(
                      "$curSym ${giftPro.giftCardCheckModel?.amount}",
                      style: TextStyle(
                        fontSize: size.getS(18),
                        fontFamily: kFontFMedium,
                        color: Colors.green,
                      ),
                    ),
                  ],
                ),
              ),
              Visibility(
                visible: giftPro.giftCardCheckModel != null &&
                    giftPro.giftCardCheckModel?.message != "",
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      giftPro.giftCardCheckModel?.message ?? "",
                      style: TextStyle(
                        fontSize: size.getS(18),
                        fontFamily: kFontFMedium,
                        color: Colors.red,
                      ),
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
