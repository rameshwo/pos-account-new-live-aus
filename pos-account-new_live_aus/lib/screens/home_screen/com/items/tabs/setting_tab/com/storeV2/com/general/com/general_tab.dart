import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:html_editor_enhanced/html_editor.dart';
import 'package:pos_account/config/size_config.dart';
import 'package:pos_account/config/validator.dart';
import 'package:pos_account/constant/constant.dart';
import 'package:pos_account/ln.dart';
import 'package:pos_account/providers/setting/store/store_pro_v2.dart';
import 'package:pos_account/screens/home_screen/com/items/tabs/setting_tab/com/storeV2/com/widgets/store_card.dart';
import 'package:pos_account/widgets/description_view.dart';
import 'package:pos_account/widgets/image/network_image_sec.dart';
import 'package:pos_account/widgets/input/dropdown/dropdown_with_text_form.dart';
import 'package:pos_account/widgets/input/dropdown/title_drop_down.dart';
import 'package:pos_account/widgets/input/text_form/title_text_form.dart';
import 'package:pos_account/widgets/load_btn.dart';
import 'package:pos_account/widgets/switch_adap.dart';
import 'package:provider/provider.dart';

class GeneralTab extends StatefulWidget {
  const GeneralTab({super.key});

  @override
  State<GeneralTab> createState() => _GeneralTabState();
}

class _GeneralTabState extends State<GeneralTab> {
  final _htmlController = HtmlEditorController();

  @override
  Widget build(BuildContext context) {
    final size = Ssize(context);
    final storePro = Provider.of<StoreProV2>(context);
    return GestureDetector(
      onTap: () {
        _htmlController.clearFocus();
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: SingleChildScrollView(
        child: Column(
          children: [
            StoreCardUI(
                title: "Store Information",
                iconData: Icons.store_outlined,
                child: Padding(
                  padding: EdgeInsets.only(top: size.getH(12)),
                  child: GridView(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 4,
                      crossAxisSpacing: size.getW(24),
                      mainAxisSpacing: size.getH(16),
                      childAspectRatio: 4.5,
                    ),
                    children: [
                      TitleTextForm(
                        title: LN.storeName,
                        pWidth: 0.20,
                        textCltr: storePro.storeNameCltr,
                      ),
                      TitleTextForm(
                        title: LN.abnNum,
                        pWidth: 0.20,
                        textCltr: storePro.abnNumCltr,
                      ),
                      TitleTextForm(
                        title: LN.email,
                        isReq: false,
                        pWidth: 0.20,
                        textCltr: storePro.emailCltr,
                        validator: emailValidator,
                        textInputType: TextInputType.emailAddress,
                        suffixIcon: Tooltip(
                          message: LN.emailAddress,
                          child: Icon(
                            Icons.email_outlined,
                            color: Colors.black54,
                            size: size.getS(24),
                          ),
                        ),
                        suffixIconWidth: 40,
                      ),
                      DropDownWiTextForm(
                        title: LN.phoneNumber,
                        isReq: true,
                        pWidth: 0.24,
                        indexVal: storePro.phoneCodeIndex,
                        list: storePro.storeRes?.countryCityStates == null
                            ? []
                            : storePro.storeRes!.countryCityStates!
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
                          storePro.phoneCodeIndex = p0;
                          storePro.notify;
                        },
                        textCltr: storePro.phoneCltr,
                      ),
                      TitleDropDown(
                        pWidth: 0.20,
                        list: (storePro.storeRes == null ||
                                storePro.storeRes!.languages == null)
                            ? []
                            : storePro.storeRes!.languages!
                                .map((e) => e.value ?? '')
                                .toList(),
                        indexVal: storePro.langIndex,
                        title: LN.language,
                        onChanged: storePro.onChangeLang,
                      ),
                      TitleDropDown(
                        pWidth: 0.20,
                        list: (storePro.storeRes == null ||
                                storePro.storeRes!.franchises == null)
                            ? []
                            : storePro.storeRes!.franchises!
                                .map((e) => e.value ?? '')
                                .toList(),
                        indexVal: storePro.franchIndex,
                        title: LN.franchise,
                        onChanged: (int? p0) {
                          storePro.franchIndex = p0;
                          storePro.notify;
                        },
                      ),
                      TitleDropDown(
                        pWidth: 0.20,
                        list: storePro.storeRes
                                    ?.businessTypeCategoriesWithBussinessTypes ==
                                null
                            ? []
                            : storePro.storeRes!
                                .businessTypeCategoriesWithBussinessTypes!
                                .map((e) => e.value ?? '')
                                .toList(),
                        indexVal: storePro.businessTypeCatIndex,
                        title: LN.businessTypeCat,
                        onChanged: (int? p0) {
                          storePro.businessTypeCatIndex = p0;
                          storePro.businessTypeIndex = null;
                          storePro.notify;
                        },
                        isReq: true,
                      ),
                      TitleDropDown(
                        pWidth: 0.20,
                        list: (storePro.storeRes
                                        ?.businessTypeCategoriesWithBussinessTypes ==
                                    null ||
                                storePro.businessTypeCatIndex == null ||
                                storePro
                                        .storeRes
                                        ?.businessTypeCategoriesWithBussinessTypes?[
                                            storePro.businessTypeCatIndex!]
                                        .businessTypes ==
                                    null)
                            ? []
                            : storePro
                                .storeRes!
                                .businessTypeCategoriesWithBussinessTypes![
                                    storePro.businessTypeCatIndex!]
                                .businessTypes!
                                .map((e) => e.value ?? '')
                                .toList(),
                        indexVal: storePro.businessTypeIndex,
                        title: LN.businessType,
                        onChanged: (int? p0) {
                          storePro.businessTypeIndex = p0;
                          storePro.notify;
                        },
                        isReq: true,
                      ),
                    ],
                  ),
                )),
            StoreCardUI(
                title: "Secondary Email",
                iconData: Icons.email_outlined,
                child: Column(
                  children: [
                    SizedBox(height: size.getH(12)),
                    if (storePro.secondaryEmailList.isEmpty)
                      _helperMessage(size,
                          text:
                              'You can add secondary emails here to receive notifications or as alternate contacts for your store.')
                    else
                      ...List.generate(storePro.secondaryEmailList.length, (i) {
                        return Padding(
                          padding: EdgeInsets.symmetric(
                              vertical: size.getH(12),
                              horizontal: size.getW(24)),
                          child: Row(
                            children: [
                              TitleTextForm(
                                title: "${LN.email} (${i + 1})",
                                isReq: true,
                                pWidth: 0.20,
                                textCltr:
                                    storePro.secondaryEmailList[i].emailCltr,
                                validator: emailValidator,
                                textInputType: TextInputType.emailAddress,
                                hintText: "Enter Secondary Email",
                                suffixIcon: Tooltip(
                                  message: LN.emailAddress,
                                  child: Icon(
                                    Icons.email_outlined,
                                    color: Colors.black54,
                                    size: size.getS(24),
                                  ),
                                ),
                                suffixIconWidth: 40,
                              ),
                              SizedBox(width: size.getW(36)),
                              Column(
                                children: [
                                  Text(
                                    "Status",
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontFamily: kFontFMedium,
                                        fontSize: size.getS(16)),
                                  ),
                                  SwitchAdap(
                                    size: size,
                                    value:
                                        storePro.secondaryEmailList[i].isActive,
                                    onChanged: (val) {
                                      storePro.secondaryEmailList[i].isActive =
                                          val;
                                      storePro.notify;
                                    },
                                  ),
                                ],
                              ),
                              SizedBox(width: size.getW(100)),
                              IconButton(
                                  onPressed: () {
                                    if (storePro
                                        .secondaryEmailList[i].id.isNotEmpty) {
                                      storePro.deletedSecondaryEmailIds.add(
                                          storePro.secondaryEmailList[i].id);
                                    }
                                    storePro.secondaryEmailList.removeAt(i);
                                    storePro.notify;
                                  },
                                  icon: Icon(
                                    Icons.delete_outline,
                                    color: Colors.red,
                                    size: size.getS(28),
                                  ))
                            ],
                          ),
                        );
                      }),
                    SizedBox(height: size.getH(12)),
                    DottedBorder(
                      borderType: BorderType.RRect,
                      radius: Radius.circular(10),
                      dashPattern: [12, 4],
                      color: Colors.black45,
                      child: LoadButton(
                        width: double.infinity,
                        hPad: 4,
                        vPad: 8,
                        textColor: Colors.black,
                        btnColor: Colors.white,
                        fontSize: 14,
                        btnText: "Add Secondary Email",
                        icon: Padding(
                          padding: EdgeInsets.only(right: size.getW(12)),
                          child: Icon(
                            Icons.add,
                            color: Colors.black,
                            size: size.getS(22),
                          ),
                        ),
                        onsave: () {
                          storePro.addSecondaryEmail();
                        },
                      ),
                    ),
                  ],
                )),
            StoreCardUI(
                title: "Store Description",
                iconData: Icons.email_outlined,
                child: Column(
                  children: [
                    SizedBox(
                      height: size.getH(12),
                    ),
                    Container(
                      margin: EdgeInsets.only(
                          bottom: size.getH(12), right: size.getW(12)),
                      decoration: BoxDecoration(
                          color: kBackgroundColor,
                          borderRadius: BorderRadius.circular(10)),
                      padding: EdgeInsets.symmetric(
                          vertical: size.getH(8), horizontal: size.getW(24)),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Main Description",
                            style: TextStyle(
                              fontSize: size.getS(18),
                              color: Colors.black,
                            ),
                          ),
                          SizedBox(
                            height: size.getH(8),
                          ),
                          DescriptionHtmlView(
                            height: 100,
                            size: size,
                            onSave: (st) {
                              storePro.storeMainDesc = st;
                              storePro.notify;
                            },
                            htmlController: _htmlController,
                            descriptionText: storePro.storeMainDesc ?? "",
                          ),
                          SizedBox(
                            height: size.getH(12),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(
                          bottom: size.getH(12), right: size.getW(12)),
                      decoration: BoxDecoration(
                          color: kBackgroundColor,
                          borderRadius: BorderRadius.circular(10)),
                      padding: EdgeInsets.symmetric(
                          vertical: size.getH(8), horizontal: size.getW(24)),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Alert Description",
                            style: TextStyle(
                              fontSize: size.getS(18),
                              color: Colors.black,
                            ),
                          ),
                          SizedBox(
                            height: size.getH(8),
                          ),
                          DescriptionHtmlView(
                            height: 100,
                            size: size,
                            onSave: (st) {
                              storePro.storeAlertDesc = st;
                              storePro.notify;
                            },
                            htmlController: _htmlController,
                            descriptionText: storePro.storeAlertDesc ?? "",
                          ),
                          SizedBox(
                            height: size.getH(12),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(
                          bottom: size.getH(12), right: size.getW(12)),
                      decoration: BoxDecoration(
                          color: kBackgroundColor,
                          borderRadius: BorderRadius.circular(10)),
                      padding: EdgeInsets.symmetric(
                          vertical: size.getH(8), horizontal: size.getW(24)),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Footer Description",
                            style: TextStyle(
                              fontSize: size.getS(18),
                              color: Colors.black,
                            ),
                          ),
                          SizedBox(
                            height: size.getH(8),
                          ),
                          DescriptionHtmlView(
                            height: 100,
                            size: size,
                            onSave: (st) {
                              storePro.storefooterDesc = st;
                              storePro.notify;
                            },
                            htmlController: _htmlController,
                            descriptionText: storePro.storefooterDesc ?? "",
                          ),
                          SizedBox(
                            height: size.getH(12),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                          top: size.getH(12), right: size.getW(12)),
                      child: TitleTextForm(
                        title: "Google Pinned Location",
                        isReq: false,
                        pWidth: 1,
                        textCltr: storePro.pinLocationCltr,
                        validator: emailValidator,
                        textInputType: TextInputType.text,
                        preTitleIcon: Padding(
                          padding: EdgeInsets.only(right: size.getW(4)),
                          child: Tooltip(
                            message: "Google Pinned Location",
                            child: Icon(
                              Icons.link_sharp,
                              color: Colors.black54,
                              size: size.getS(24),
                            ),
                          ),
                        ),
                        suffixIconWidth: 40,
                        minLines: 2,
                        maxLines: 3,
                      ),
                    ),
                  ],
                )),
            SizedBox(
              height: size.getH(48),
            ),
          ],
        ),
      ),
    );
  }

  Container _helperMessage(
    Ssize size, {
    required String text,
  }) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
          color: kSecondaryColor.withOpacity(0.05),
          borderRadius: BorderRadius.circular(20)),
      padding: EdgeInsets.symmetric(
          horizontal: size.getW(16), vertical: size.getH(24)),
      child: Row(
        children: [
          Icon(
            Icons.info_outline,
            size: size.getS(18),
            color: kSecondaryColor,
          ),
          SizedBox(width: size.getW(8)),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                color: kSecondaryColor,
                fontSize: size.getS(14),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
