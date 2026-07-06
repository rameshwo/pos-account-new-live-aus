import 'package:flutter/material.dart';
import 'package:oktoast/oktoast.dart';
import 'package:pos_account/config/size_config.dart';
import 'package:pos_account/constant/constant.dart';
import 'package:pos_account/ln.dart';
import 'package:pos_account/providers/menu/gift_card/new_gift_card_pro.dart';
import 'package:pos_account/screens/home_screen/com/dialogs/cus_list_dia.dart';
import 'package:pos_account/widgets/image/network_image_sec.dart';
import 'package:pos_account/widgets/image/p_image_sec.dart';
import 'package:pos_account/widgets/input/dropdown/dropdown_with_text_form.dart';
import 'package:pos_account/widgets/input/dropdown/title_drop_down.dart';
import 'package:pos_account/widgets/input/text_form/title_text_form.dart';
import 'package:pos_account/widgets/load_btn.dart';
import 'package:pos_account/widgets/loading.dart';
import 'package:provider/provider.dart';
import 'com/gift_card_image_dia.dart';
import 'com/make_pay_dia.dart';

class NewGiftCardPage extends StatefulWidget {
  const NewGiftCardPage({
    super.key,
  });

  @override
  State<NewGiftCardPage> createState() => _NewGiftCardPageState();
}

class _NewGiftCardPageState extends State<NewGiftCardPage> {
  final _formKey = GlobalKey<FormState>();

  void showMakePayDia() {
    showDialog(
        context: context,
        builder: (_) {
          return SimpleDialog(
            backgroundColor: Colors.white,
            titlePadding: EdgeInsets.zero,
            contentPadding: EdgeInsets.symmetric(horizontal: 12),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
            children: [
              MakePayDia(),
            ],
          );
        });
  }

  void showImageDia() {
    showDialog(
        context: context,
        builder: (builder) => SimpleDialog(
              backgroundColor: Colors.white,
              titlePadding: EdgeInsets.zero,
              contentPadding: EdgeInsets.symmetric(horizontal: 24, vertical: 0),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15)),
              children: [GiftCardImageDia()],
            ));
  }

  @override
  void initState() {
    getData();
    super.initState();
  }

  NewGiftCardPro? _giftPro;

  void getData() {
    _giftPro = Provider.of<NewGiftCardPro>(context, listen: false);
    _giftPro?.getData();
  }

  @override
  void dispose() {
    _giftPro?.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = Ssize(context);
    final giftPro = Provider.of<NewGiftCardPro>(context);
    return Processing(
      loading: giftPro.pageLoad,
      align: Alignment.topLeft,
      child: Form(
        key: _formKey,
        child: Card(
          child: Padding(
            padding: EdgeInsets.symmetric(
                horizontal: size.getW(24), vertical: size.getH(12)),
            child: SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Wrap(
                              spacing: size.getW(24),
                              children: [
                                TitleTextForm(
                                  title: LN.giftCardNo,
                                  pWidth: 0.20,
                                  borderColor: Colors.black26,
                                  textCltr: giftPro.giftCardNoCltr,
                                  readOnly: true,
                                  fillColor: Colors.grey.shade100,
                                ),
                                TitleTextForm(
                                  title: LN.amtOnGift,
                                  pWidth: 0.20,
                                  textInputType: TextInputType.number,
                                  borderColor: Colors.black38,
                                  hintText: '0.00',
                                  textCltr: giftPro.giftCardAmountCltr,
                                )
                              ],
                            ),
                            Padding(
                              padding:
                                  EdgeInsets.symmetric(vertical: size.getH(12)),
                              child: Divider(
                                color: Colors.black54,
                              ),
                            ),
                            _titleSection(
                              title: LN.senderDetails,
                              size: size,
                              onTap: () {
                                FocusScope.of(context).unfocus();
                                CustomerList.show(context).then((value) {
                                  giftPro.setSenderCustomerData(value);
                                });
                              },
                            ),
                            SizedBox(
                              height: size.getH(12),
                            ),
                            Wrap(
                              spacing: size.getW(24),
                              runSpacing: size.getH(18),
                              crossAxisAlignment: WrapCrossAlignment.start,
                              children: [
                                TitleTextForm(
                                  title: LN.name,
                                  pWidth: 0.20,
                                  borderColor: Colors.black38,
                                  textCltr: giftPro.senderNameCltr,
                                  textInputType: TextInputType.name,
                                ),
                                DropDownWiTextForm(
                                  title: LN.phoneNumber,
                                  isReq: true,
                                  pWidth: 0.20,
                                  indexVal: giftPro.senderPhoneCodeIndex,
                                  list: giftPro.addSec?.countries == null
                                      ? []
                                      : giftPro.addSec!.countries!
                                          .map((e) => Row(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  NetworkImageSec(
                                                    image: e.image,
                                                    height: size.isProt
                                                        ? size.getW(12)
                                                        : size.getW(16),
                                                    width: size.isProt
                                                        ? size.getW(12)
                                                        : size.getW(16),
                                                  ),
                                                  if (e.additionalValue
                                                      is String)
                                                    Flexible(
                                                      child: Align(
                                                        alignment: Alignment
                                                            .centerRight,
                                                        child: Text(
                                                          e.additionalValue ??
                                                              '',
                                                          style: TextStyle(
                                                            fontSize: size
                                                                    .isProt
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
                                    giftPro.senderPhoneCodeIndex = p0;
                                    giftPro.notify;
                                  },
                                  textCltr: giftPro.senderPhoneCltr,
                                  borderColor: Colors.black26,
                                ),
                                TitleTextForm(
                                  title: LN.email,
                                  pWidth: 0.20,
                                  isReq: false,
                                  borderColor: Colors.black38,
                                  textInputType: TextInputType.emailAddress,
                                  textCltr: giftPro.senderEmailCltr,
                                ),
                                SearchTitleDropDown(
                                  pWidth: 0.20,
                                  title: LN.country,
                                  isReq: true,
                                  list: giftPro.addSec?.countries == null
                                      ? []
                                      : giftPro.addSec!.countries!
                                          .map((e) => e.name ?? '')
                                          .toList(),
                                  indexVal: giftPro.senderCountryIndex,
                                  onChanged: (p0) {
                                    giftPro.senderCountryIndex = p0;
                                    giftPro.senderPhoneCodeIndex = p0;
                                    giftPro.notify;
                                  },
                                  borderColor: Colors.black26,
                                ),
                                TitleTextForm(
                                  title: LN.postalCode,
                                  pWidth: 0.20,
                                  borderColor: Colors.black38,
                                  textCltr: giftPro.senderPostalCltr,
                                  textInputType: TextInputType.number,
                                ),
                                TitleTextForm(
                                  title: LN.message,
                                  pWidth: 0.63,
                                  maxLines: 2,
                                  hintText: LN.yourMsgHere,
                                  borderColor: Colors.black38,
                                  textCltr: giftPro.senderMessageCltr,
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                      SizedBox(
                        width: size.getW(12),
                      ),
                      SizedBox(
                        width: size.width * 0.2, //size.getW(328),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            PImageSection(
                              backgroundColor: kSecondaryColor.withAlpha(40),
                              imagePath: giftPro.selectedGiftCardImage,
                            ),
                            SizedBox(
                              height: size.getH(12),
                            ),
                            SizedBox(
                              width: double.infinity,
                              height: size.getH(44),
                              child: ElevatedButton(
                                onPressed: showImageDia,
                                style: ButtonStyle(
                                    backgroundColor:
                                        WidgetStateProperty.all(kPrimaryColor)),
                                child: Text(
                                  LN.chooseGiftCard,
                                  style: TextStyle(
                                    fontSize: size.getS(18),
                                    fontFamily: kFontFMedium,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: size.getH(12)),
                    child: Divider(
                      color: Colors.black54,
                    ),
                  ),
                  _titleSection(
                    title: LN.receiverDetails,
                    size: size,
                    onTap: () {
                      FocusScope.of(context).unfocus();
                      CustomerList.show(context).then((value) {
                        giftPro.setReceiverCustomerData(value);
                      });
                    },
                  ),
                  SizedBox(
                    height: size.getH(12),
                  ),
                  Wrap(
                    spacing: size.getW(24),
                    runSpacing: size.getH(18),
                    crossAxisAlignment: WrapCrossAlignment.start,
                    children: [
                      TitleTextForm(
                        title: LN.name,
                        pWidth: 0.20,
                        borderColor: Colors.black38,
                        textCltr: giftPro.receiveNameCltr,
                        textInputType: TextInputType.name,
                      ),
                      DropDownWiTextForm(
                        title: LN.phoneNumber,
                        isReq: true,
                        pWidth: 0.20,
                        indexVal: giftPro.recPhoneCodeIndex,
                        list: giftPro.addSec?.countries == null
                            ? []
                            : giftPro.addSec!.countries!
                                .map((e) => Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        NetworkImageSec(
                                          image: e.image,
                                          height: size.isProt
                                              ? size.getW(12)
                                              : size.getW(16),
                                          width: size.isProt
                                              ? size.getW(12)
                                              : size.getW(16),
                                        ),
                                        if (e.additionalValue is String)
                                          Flexible(
                                            child: Align(
                                              alignment: Alignment.centerRight,
                                              child: Text(
                                                e.additionalValue ?? '',
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
                          giftPro.recPhoneCodeIndex = p0;
                          giftPro.notify;
                        },
                        textCltr: giftPro.receivePhoneCltr,
                        borderColor: Colors.black26,
                      ),
                      TitleTextForm(
                        title: LN.email,
                        pWidth: 0.20,
                        isReq: false,
                        borderColor: Colors.black38,
                        textCltr: giftPro.receiveEmailCltr,
                        textInputType: TextInputType.emailAddress,
                      ),
                      SearchTitleDropDown(
                        pWidth: 0.20,
                        title: LN.country,
                        isReq: true,
                        list: giftPro.addSec?.countries == null
                            ? []
                            : giftPro.addSec!.countries!
                                .map((e) => e.name ?? '')
                                .toList(),
                        indexVal: giftPro.recCountryIndex,
                        onChanged: (p0) {
                          giftPro.recCountryIndex = p0;
                          giftPro.recPhoneCodeIndex = p0;
                          giftPro.notify;
                        },
                        borderColor: Colors.black26,
                      ),
                      TitleTextForm(
                        title: LN.postalCode,
                        pWidth: 0.20,
                        borderColor: Colors.black38,
                        textCltr: giftPro.receivePostalCltr,
                        textInputType: TextInputType.number,
                      ),
                    ],
                  ),
                  SizedBox(
                    height: size.getH(24),
                  ),
                  LoadButton(
                    onsave: () {
                      FocusScope.of(context).unfocus();
                      if (_formKey.currentState!.validate()) {
                        if (giftPro.selectedGiftCardId == null) {
                          showToast(LN.pleaseChooseGift);
                        } else {
                          if (giftPro.paidAmountCltr.text.isEmpty) {
                            giftPro.paidAmountCltr.text =
                                giftPro.giftCardAmountCltr.text;
                          }
                          showMakePayDia();
                        }
                      }
                    },
                    btnText: LN.send,
                  ),
                  SizedBox(
                    height: size.getH(32),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Row _titleSection({
    required String title,
    Function()? onTap,
    required Ssize size,
  }) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: size.getS(18),
            fontFamily: kFontFMedium,
            color: Colors.black,
          ),
        ),
        SizedBox(
          width: size.getW(12),
        ),
        Card(
            margin: EdgeInsets.zero,
            color: kPrimaryColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5),
            ),
            child: InkWell(
              onTap: onTap,
              child: Padding(
                padding: EdgeInsets.all(size.getS(4)),
                child: Icon(
                  Icons.search,
                  color: Colors.white,
                  size: size.getS(24),
                ),
              ),
            ))
      ],
    );
  }
}
