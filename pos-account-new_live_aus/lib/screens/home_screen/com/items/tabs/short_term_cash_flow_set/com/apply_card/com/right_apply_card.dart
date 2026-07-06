import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:pos_account/config/size_config.dart';
import 'package:pos_account/config/validator.dart';
import 'package:pos_account/constant/constant.dart';
import 'package:pos_account/ln.dart';
import 'package:pos_account/providers/cus_val_pro.dart';
import 'package:pos_account/providers/stcf/short_tcf_pro.dart';
import 'package:pos_account/widgets/input/text_form/text_form_widget.dart';
import 'package:pos_account/widgets/load_btn.dart';
import 'package:pos_account/widgets/loading.dart';

class RightApplyCard extends StatelessWidget {
  const RightApplyCard({
    super.key,
    required this.size,
    required this.pageCltr,
    required this.pro,
  });

  final Ssize size;
  final PageController pageCltr;
  final StcfPro pro;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: size.getW(72)),
          child: PageView(
            physics: NeverScrollableScrollPhysics(),
            // scrollDirection: Axis.vertical,
            controller: pageCltr,
            children: [
              Processing(
                loading: pro.submitLoad,
                child: Form(
                  key: pro.formKey,
                  child: LucaFormSection(
                    size: size,
                    pro: pro,
                    onSubmit: () {
                      if (pro.formKey.currentState!.validate()) {
                        pro.applyStcf().then((value) {
                          if (value) {
                            pageCltr.animateToPage(
                              1,
                              duration: Duration(milliseconds: 600),
                              curve: Curves.easeOutQuart,
                            );
                          }
                        });
                      }
                    },
                  ),
                ),
              ),
              LucaFormSuccessSec(size: size),
            ],
          ),
        ),
        Positioned(
          right: 0,
          child: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Icon(
                Icons.close,
                size: size.getS(24),
                color: Colors.white,
              )),
        ),
      ],
    );
  }
}

class LucaFormSuccessSec extends StatelessWidget {
  const LucaFormSuccessSec({
    super.key,
    required this.size,
  });

  final Ssize size;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: size.getH(12),
          ),
          Text(
            LN.thankYou,
            style: TextStyle(
              fontSize: size.getS(40),
              fontFamily: kFontFMedium,
              color: Colors.white,
            ),
          ),
          SizedBox(
            height: size.getH(16),
          ),
          Text(
            LN.formSent,
            style: TextStyle(
              fontSize: size.getS(21),
              fontFamily: kFontFRegular,
              color: Colors.white,
            ),
          ),
          SizedBox(
            height: size.getH(16),
          ),
          Text(
            LN.goBackFromLuca,
            style: TextStyle(
              fontSize: size.getS(21),
              fontFamily: kFontFRegular,
              color: Colors.white,
            ),
          ),
          Align(
            alignment: Alignment.centerRight,
            child: SizedBox(
              width: size.getW(300),
              child: Lottie.asset(
                "assets/json/lucapay_sent.json",
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class LucaFormSection extends StatelessWidget {
  const LucaFormSection({
    super.key,
    required this.size,
    this.onSubmit,
    required this.pro,
  });

  final Ssize size;
  final Function()? onSubmit;
  final StcfPro pro;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: size.getH(24),
          ),
          Text(
            LN.getStarted,
            style: TextStyle(
              fontSize: size.getS(32),
              fontFamily: kFontFMedium,
              color: Colors.white,
            ),
          ),
          SizedBox(
            height: size.getH(12),
          ),
          Text(
            LN.fillDetailsLuca,
            style: TextStyle(
              fontSize: size.getS(16),
              fontFamily: kFontFRegular,
              color: Colors.white,
            ),
          ),
          SizedBox(
            height: size.getH(24),
          ),
          TextFormWidget(
            cltr: pro.nameCltr,
            hintText: LN.contactPerson,
            borderColor: Colors.black12,
          ),
          SizedBox(
            height: size.getH(16),
          ),
          TextFormWidget(
            cltr: pro.numberCltr,
            hintText: LN.contactNum,
            textInputType: TextInputType.number,
            borderColor: Colors.black12,
          ),
          SizedBox(
            height: size.getH(16),
          ),
          TextFormWidget(
            cltr: pro.emailCltr,
            hintText: LN.busEmailAdd,
            textInputType: TextInputType.emailAddress,
            validator: emailValidator,
            borderColor: Colors.black12,
          ),
          SizedBox(
            height: size.getH(16),
          ),
          TextFormWidget(
            cltr: pro.abnCltr,
            hintText: LN.abn,
            borderColor: Colors.black12,
          ),
          SizedBox(
            height: size.getH(16),
          ),
          TextFormWidget(
            cltr: pro.accSoftCltr,
            hintText: LN.accSoft,
            borderColor: Colors.black12,
          ),
          SizedBox(
            height: size.getH(32),
          ),
          Wrap(
            spacing: size.getW(12),
            runSpacing: size.getH(12),
            children: [
              if (GlobalCVP.viewWidget.viewPayBillsSaveButton)
                LoadButton(
                  btnText: LN.submit,
                  btnColor: kUserColor,
                  onsave: onSubmit,
                ),
              if (GlobalCVP.viewWidget.viewPayBillsCancelButton)
                LoadButton(
                  btnText: LN.clearForm,
                  btnColor: Colors.transparent,
                  onsave: () {
                    Navigator.pop(context);
                  },
                ),
            ],
          ),
          SizedBox(
            height: size.getH(16),
          ),
        ],
      ),
    );
  }
}
