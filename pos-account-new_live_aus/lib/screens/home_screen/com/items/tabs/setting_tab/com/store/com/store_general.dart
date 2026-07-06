import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:oktoast/oktoast.dart';
import 'package:pos_account/config/size_config.dart';
import 'package:pos_account/config/validator.dart';
import 'package:pos_account/ln.dart';
import 'package:pos_account/providers/setting/store/store_pro.dart';
import 'package:pos_account/widgets/image/network_image_sec.dart';
import 'package:pos_account/widgets/input/text_form/auto_complete_text_field.dart';
import 'package:pos_account/widgets/input/dropdown/dropdown_with_text_form.dart';
import 'package:pos_account/widgets/image/p_image_sec.dart';
import 'package:pos_account/widgets/input/dropdown/title_drop_down.dart';
import 'package:pos_account/widgets/input/text_form/title_text_form.dart';
import 'package:provider/provider.dart';

class StoreGeneral extends StatelessWidget {
  // final StorePro storePro;
  final void Function()? cancel;
  const StoreGeneral({
    super.key,
    // required this.storePro,
    this.cancel,
  });

  @override
  Widget build(BuildContext context) {
    final storePro = Provider.of<StorePro>(context);
    final size = Ssize(context);
    return SingleChildScrollView(
      physics: BouncingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: size.getH(12),
          ),
          Card(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            child: SizedBox(
              width: double.infinity,
              child: Padding(
                padding: EdgeInsets.symmetric(
                    vertical: size.getH(24.0), horizontal: size.getW(24)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Flexible(
                          child: Wrap(
                            spacing: size.getW(32),
                            runSpacing: size.getH(24),
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
                              DropDownWiTextForm(
                                title: LN.phoneNumber,
                                isReq: true,
                                pWidth: 0.20,
                                borderColor: Colors.black,
                                indexVal: storePro.phoneCodeIndex,
                                list: storePro.storeRes?.countryCityStates ==
                                        null
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
                                                      alignment:
                                                          Alignment.centerRight,
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
                              // TitleTextForm(
                              //   title: LN.phoneNumber,
                              //   pWidth: 0.24,
                              //   textCltr: storePro.phoneCltr,
                              //   textInputType: TextInputType.number,
                              // ),
                              SearchTitleDropDown(
                                isReq: true,
                                pWidth: 0.20,
                                list: storePro.storeRes?.countryCityStates
                                        ?.map((e) => e.name ?? '')
                                        .toList() ??
                                    [],
                                indexVal: (storePro.storeRes?.countryCityStates
                                            ?.isNotEmpty ??
                                        false)
                                    ? storePro.countryIndex
                                    : null,
                                title: LN.country,
                                borderColor: Colors.black,
                                onChanged: (int? p0) {
                                  storePro.countryIndex = p0;
                                  storePro.phoneCodeIndex = p0;
                                  storePro.stateIndex = null;
                                  storePro.cityIndex = null;
                                  storePro.suburbIndex = null;
                                  storePro.notify();
                                },
                              ),
                              SearchTitleDropDown(
                                title: LN.state,
                                pWidth: 0.20,
                                isReq: true,
                                borderColor: Colors.black,
                                indexVal: storePro.stateIndex,
                                list: storePro.countryIndex != null &&
                                        storePro
                                                .storeRes
                                                ?.countryCityStates?[
                                                    storePro.countryIndex!]
                                                .states !=
                                            null
                                    ? storePro
                                        .storeRes!
                                        .countryCityStates![
                                            storePro.countryIndex!]
                                        .states!
                                        .map((e) => e.name ?? '')
                                        .toList()
                                    : [],
                                onChanged: (p0) {
                                  storePro.stateIndex = p0;
                                  storePro.cityIndex = null;
                                  storePro.suburbIndex = null;
                                  storePro.notify();
                                },
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          width: size.getW(32),
                        ),
                        SizedBox(
                            width: size.width * 0.20,
                            height: size.getH(170),
                            child: PImageSection(
                              hintText: LN.storeImage,
                              imagePath: storePro.getFilePath,
                              onTap: () {
                                storePro.getFilePick();
                              },
                            )),
                      ],
                    ),
                    SizedBox(
                      height: size.getH(24),
                    ),
                    Wrap(
                      spacing: size.getW(32),
                      runSpacing: size.getH(24),
                      crossAxisAlignment: WrapCrossAlignment.start,
                      children: [
                        SearchTitleDropDown(
                          title: LN.city,
                          pWidth: 0.20,
                          isReq: true,
                          borderColor: Colors.black,
                          indexVal: storePro.cityIndex,
                          list: storePro.countryIndex == null ||
                                  storePro.stateIndex == null ||
                                  storePro
                                          .storeRes
                                          ?.countryCityStates?[
                                              storePro.countryIndex!]
                                          .states?[storePro.stateIndex!]
                                          .cities ==
                                      null
                              ? []
                              : storePro
                                  .storeRes!
                                  .countryCityStates![storePro.countryIndex!]
                                  .states![storePro.stateIndex!]
                                  .cities!
                                  .map((e) => e.name ?? '')
                                  .toList(),
                          onChanged: (p0) {
                            storePro.cityIndex = p0;
                            storePro.suburbIndex = null;
                            storePro.notify();
                          },
                        ),
                        SearchTitleDropDown(
                          title: "Suburb",
                          pWidth: 0.20,
                          isReq: true,
                          borderColor: Colors.black,
                          indexVal: storePro.suburbIndex,
                          list: storePro.countryIndex == null ||
                                  storePro.stateIndex == null ||
                                  storePro.cityIndex == null ||
                                  storePro
                                          .storeRes
                                          ?.countryCityStates?[
                                              storePro.countryIndex!]
                                          .states?[storePro.stateIndex!]
                                          .cities?[storePro.cityIndex!]
                                          .suburbs ==
                                      null ||
                                  storePro
                                      .storeRes!
                                      .countryCityStates![
                                          storePro.countryIndex!]
                                      .states![storePro.stateIndex!]
                                      .cities![storePro.cityIndex!]
                                      .suburbs!
                                      .isEmpty
                              ? []
                              : storePro
                                  .storeRes!
                                  .countryCityStates![storePro.countryIndex!]
                                  .states![storePro.stateIndex!]
                                  .cities![storePro.cityIndex!]
                                  .suburbs!
                                  .map((e) => e.name ?? '')
                                  .toList(),
                          onChanged: (p0) {
                            storePro.suburbIndex = p0;
                            storePro.notify();
                          },
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
                        TitleTextForm(
                          title: LN.storeUrl,
                          pWidth: 0.20,
                          isReq: false,
                          textCltr: storePro.urlCltr,
                          textInputType: TextInputType.url,
                          suffix: InkWell(
                              onTap: () {
                                Clipboard.setData(ClipboardData(
                                        text: storePro.urlCltr.text))
                                    .then((_) => showToast(LN.copiedToClip));
                              },
                              child: Icon(
                                Icons.copy_outlined,
                                size: size.getS(22),
                              )),
                        ),
                        TitleTextForm(
                          title: LN.webUrl,
                          pWidth: 0.20,
                          isReq: false,
                          textCltr: storePro.webUrlCltr,
                          textInputType: TextInputType.url,
                          suffix: InkWell(
                              onTap: () {
                                Clipboard.setData(ClipboardData(
                                        text: storePro.webUrlCltr.text))
                                    .then((_) => showToast(LN.copiedToClip));
                              },
                              child: Icon(
                                Icons.copy_outlined,
                                size: size.getS(22),
                              )),
                        ),
                        TitleTextForm(
                          title: "QR Url",
                          pWidth: 0.20,
                          isReq: false,
                          textCltr: storePro.qrUrlCltr,
                          textInputType: TextInputType.url,
                          suffix: InkWell(
                              onTap: () {
                                Clipboard.setData(ClipboardData(
                                        text: storePro.qrUrlCltr.text))
                                    .then((_) => showToast(LN.copiedToClip));
                              },
                              child: Icon(
                                Icons.copy_outlined,
                                size: size.getS(22),
                              )),
                        ),
                        TitleDropDown(
                          pWidth: 0.20,
                          list: (storePro.storeRes == null ||
                                  storePro.storeRes!
                                          .taxExclusiveInclusiveTypes ==
                                      null)
                              ? []
                              : storePro.storeRes!.taxExclusiveInclusiveTypes!
                                  .map((e) => e.value ?? '')
                                  .toList(),
                          indexVal: storePro.taxInExIndex,
                          title: LN.tax,
                          onChanged: (int? p0) {
                            storePro.taxInExIndex = p0;
                            storePro.notify();
                          },
                        ),
                        // TitleTextForm(
                        //   title: "${LN.publicHolidaySc}(%)",
                        //   pWidth: 0.24,
                        //   isReq: true,
                        //   textInputType: TextInputType.number,
                        //   textCltr: storePro.holisurCltr,
                        //   hintText: "0",
                        //   // inputFormatters: [
                        //   //   FilteringTextInputFormatter.digitsOnly,
                        //   //   LengthLimitingTextInputFormatter(2),
                        //   // ],
                        //   validator: (p0) {
                        //     if (p0 != null) {
                        //       final val = int.tryParse(p0);
                        //       if (val != null && val >= 0 && val >= 100) {
                        //         return LN.invalidNumber;
                        //       }
                        //     }
                        //     return null;
                        //   },
                        //   suffixIcon: Text(
                        //     "%",
                        //     style: TextStyle(
                        //       fontSize: size.getS(18),
                        //       color: Colors.black,
                        //       fontFamily: kFontFRegular,
                        //     ),
                        //   ),
                        //   suffixIconWidth: 24,
                        //   suffix: Tooltip(
                        //     message: LN.autoEnHoliSur,
                        //     child: Row(
                        //       children: [
                        //         // Text(
                        //         //   "(Auto)",
                        //         //   style: TextStyle(
                        //         //     fontSize: size.getS(16),
                        //         //     color: Colors.black,
                        //         //     fontFamily: kFontFRegular,
                        //         //   ),
                        //         // ),
                        //         SwitchAdap(
                        //           size: size,
                        //           height: 28,
                        //           value: storePro.isEnableHoliDay,
                        //           onChanged: (val) {
                        //             storePro.isEnableHoliDay = val;
                        //             storePro.notify();
                        //           },
                        //         ),
                        //       ],
                        //     ),
                        //   ),
                        // ),
                        // TitleTextForm(
                        //   title: "${LN.weekendSur}(%)",
                        //   pWidth: 0.24,
                        //   isReq: true,
                        //   textInputType: TextInputType.number,
                        //   textCltr: storePro.weekendSurCltr,
                        //   hintText: "0",
                        //   // inputFormatters: [
                        //   //   FilteringTextInputFormatter.digitsOnly,
                        //   //   LengthLimitingTextInputFormatter(2),
                        //   // ],
                        //   validator: (p0) {
                        //     if (p0 != null) {
                        //       final val = int.tryParse(p0);
                        //       if (val != null && val < 0 && val > 100) {
                        //         return LN.invalidNumber;
                        //       }
                        //     }
                        //     return null;
                        //   },
                        //   suffixIcon: Text(
                        //     "%",
                        //     style: TextStyle(
                        //       fontSize: size.getS(18),
                        //       color: Colors.black,
                        //       fontFamily: kFontFRegular,
                        //     ),
                        //   ),
                        //   suffixIconWidth: 24,
                        //   suffix: Tooltip(
                        //     message: LN.autoEnWeekSur,
                        //     child: SwitchAdap(
                        //       size: size,
                        //       height: 28,
                        //       value: storePro.isEnableWeekend,
                        //       onChanged: (val) {
                        //         storePro.isEnableWeekend = val;
                        //         storePro.notify();
                        //       },
                        //     ),
                        //   ),
                        // ),
                        // TitleTextForm(
                        //   title: "${LN.creditCardSurcharge}(%)",
                        //   pWidth: 0.24,
                        //   isReq: true,
                        //   textInputType: TextInputType.number,
                        //   textCltr: storePro.creCardsurCltr,
                        //   hintText: "0",
                        //   // inputFormatters: [
                        //   //   FilteringTextInputFormatter.digitsOnly,
                        //   //   LengthLimitingTextInputFormatter(2),
                        //   // ],
                        //   validator: (p0) {
                        //     if (p0 != null) {
                        //       final val = int.tryParse(p0);
                        //       if (val != null && val < 0 && val > 100) {
                        //         return LN.invalidNumber;
                        //       }
                        //     }
                        //     return null;
                        //   },
                        //   suffixIcon: Text(
                        //     "%",
                        //     style: TextStyle(
                        //       fontSize: size.getS(18),
                        //       color: Colors.black,
                        //       fontFamily: kFontFRegular,
                        //     ),
                        //   ),
                        //   suffixIconWidth: 24,
                        //   suffix: Tooltip(
                        //     message: LN.autoEnCreSur,
                        //     child: SwitchAdap(
                        //       size: size,
                        //       height: 28,
                        //       value: storePro.isEnableCredit,
                        //       onChanged: (val) {
                        //         storePro.isEnableCredit = val;
                        //         storePro.notify();
                        //       },
                        //     ),
                        //   ),
                        // ),

                        // TitleDropDown(
                        //   pWidth: 0.24,
                        //   list: (storePro.storeRes == null ||
                        //           storePro.storeRes!
                        //                   .templateCategoriesWithTemplates ==
                        //               null)
                        //       ? []
                        //       : storePro
                        //           .storeRes!.templateCategoriesWithTemplates!
                        //           .map((e) => e.value ?? '')
                        //           .toList(),
                        //   indexVal: storePro.templateCategoryIndex,
                        //   title: LN.templateCategory,
                        //   onChanged: (int? p0) {
                        //     storePro.templateCategoryIndex = p0;
                        //     storePro.templateIndex = null;
                        //     storePro.notify();
                        //   },
                        // ),
                        // TitleDropDown(
                        //   pWidth: 0.24,
                        //   list: (storePro.storeRes
                        //                   ?.templateCategoriesWithTemplates ==
                        //               null ||
                        //           storePro.templateCategoryIndex == null ||
                        //           storePro
                        //                   .storeRes!
                        //                   .templateCategoriesWithTemplates![
                        //                       storePro.templateCategoryIndex!]
                        //                   .templates ==
                        //               null)
                        //       ? []
                        //       :
                        //       // storePro.templateList!
                        //       //     .map((e) => e.value!)
                        //       //     .toList(),
                        //       storePro
                        //           .storeRes!
                        //           .templateCategoriesWithTemplates![
                        //               storePro.templateCategoryIndex!]
                        //           .templates!
                        //           .map((e) => e.value!)
                        //           .toList(),
                        //   indexVal: storePro.templateIndex,
                        //   title: LN.template,
                        //   onChanged: (int? p0) {
                        //     storePro.templateIndex = p0;
                        //     storePro.notify();
                        //   },
                        // ),

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
                            storePro.notify();
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
                            storePro.notify();
                          },
                          isReq: true,
                        ),
                        TitleDropDown(
                          pWidth: 0.20,
                          list: (storePro.storeRes == null ||
                                  storePro.storeRes!.storeTypes == null)
                              ? []
                              : storePro.storeRes!.storeTypes!
                                  .map((e) => e.value ?? '')
                                  .toList(),
                          indexVal: storePro.storeTypeIndex,
                          title: LN.storeType,
                          onChanged: (int? p0) {
                            storePro.storeTypeIndex = p0;
                            storePro.notify();
                          },
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
                            storePro.notify();
                          },
                        ),
                        AutoCompleteText(
                          pWidth: 0.20,
                          title: LN.address,
                          textCltr: storePro.addressCltr,
                          hintText: LN.address,
                          suffixIcon: storePro.addressCltr.text.isEmpty
                              ? null
                              : InkWell(
                                  onTap: () {
                                    storePro.addressCltr.clear();
                                  },
                                  child: Icon(Icons.close, size: size.getS(32)),
                                ),
                          asyncSuggestions: (String val) async {
                            if (val.isNotEmpty)
                              await storePro.getPlaces(input: val);

                            return storePro.getAutoPlaces?.predictions == null
                                ? []
                                : storePro.getAutoPlaces!.predictions
                                    .map((e) => e.fullText)
                                    .toSet()
                                    .toList();
                          },
                          onSubmit: (val) {
                            if (storePro.getAutoPlaces!.predictions
                                .any((e) => e.fullText == val)) {
                              final pId = storePro.getAutoPlaces!.predictions
                                  .firstWhere((e) => e.fullText == val)
                                  .placeId;
                              storePro.setPlaceId = pId;
                            }
                          },
                        ),
                        TitleTextForm(
                          pWidth: 0.20,
                          title: LN.latitude,
                          readOnly: true,
                          isReq: false,
                          textCltr: storePro.latCltr,
                        ),
                        TitleTextForm(
                          title: LN.longitude,
                          pWidth: 0.20,
                          readOnly: true,
                          isReq: false,
                          textCltr: storePro.longCltr,
                        ),
                        SearchTitleDropDown(
                          vPad: 8,
                          pWidth: 0.20,
                          list: (storePro.storeRes == null ||
                                  storePro.storeRes!.timeZones == null)
                              ? []
                              : storePro.storeRes!.timeZones!
                                  .map((e) => e.value ?? '')
                                  .toList(),
                          indexVal: storePro.timeZoneIndex,
                          title: LN.timezone,
                          borderColor: Colors.black,
                          onChanged: (int? p0) {
                            storePro.timeZoneIndex = p0;
                            storePro.notify();
                          },
                        ),

                        TitleDropDown(
                          pWidth: 0.20,
                          list: (storePro.storeRes == null ||
                                  storePro.storeRes!.dateFormats == null)
                              ? []
                              : storePro.storeRes!.dateFormats!
                                  .map((e) => e.value ?? '')
                                  .toList(),
                          indexVal: storePro.dateForIndex,
                          title: LN.dateFormat,
                          onChanged: (int? p0) {
                            storePro.dateForIndex = p0;
                            storePro.notify();
                          },
                        ),
                        TitleTextForm(
                          title: LN.description,
                          pWidth: 0.20,
                          isReq: false,
                          textCltr: storePro.descriptionCltr,
                        ),
                        // TitleTextForm(
                        //   title: "${LN.promtOffDis}(%)",
                        //   pWidth: 0.24,
                        //   isReq:
                        //       storePro.promoOffDiscountPerCltr.text.isNotEmpty,
                        //   hintText: LN.discountPercent,
                        //   textCltr: storePro.promoOffDiscountPerCltr,
                        //   textInputType: TextInputType.number,
                        //   // inputFormatters: [
                        //   //   FilteringTextInputFormatter.digitsOnly,
                        //   //   LengthLimitingTextInputFormatter(2),
                        //   // ],
                        //   suffixIcon: Text(
                        //     "%",
                        //     style: TextStyle(
                        //       fontSize: size.getS(18),
                        //       color: Colors.black,
                        //       fontFamily: kFontFRegular,
                        //     ),
                        //   ),
                        //   suffixIconWidth: 24,
                        //   validator: (p0) {
                        //     if (p0 != null) {
                        //       final val = int.tryParse(p0);
                        //       if (val != null && val >= 0 && val >= 100) {
                        //         return LN.invalidNumber;
                        //       }
                        //     }
                        //     return null;
                        //   },
                        // ),
                        // TitleTextForm(
                        //   title: LN.promOfferThres,
                        //   pWidth: 0.24,
                        //   isReq: false,
                        //   hintText: LN.discountAmt,
                        //   textCltr: storePro.promoOffAmtCltr,
                        //   textInputType: TextInputType.number,
                        // ),
                        // Padding(
                        //   padding: EdgeInsets.only(right: size.getW(60)),
                        //   child: UploadContainer(
                        //     title: LN.promImage,
                        //     // bottomText: storePro.promoFilePath ?? "",
                        //     imageUrl: storePro.promoFilePath,
                        //     onTap: () {
                        //       storePro.getPromoFile();
                        //     },
                        //     remove: () {
                        //       storePro.promoFilePath = null;
                        //       storePro.notify();
                        //     },
                        //   ),
                        // ),
                        // Row(
                        //   mainAxisSize: MainAxisSize.min,
                        //   children: [
                        //     Checkbox(
                        //         value: storePro.isRetailScreen,
                        //         activeColor: kPrimaryColor,
                        //         onChanged: (val) {
                        //           if (val == null) return;
                        //           storePro.isRetailScreen = val;
                        //           storePro.notify();
                        //         }),
                        //     SizedBox(
                        //       width: size.getW(4),
                        //     ),
                        //     InkWell(
                        //       onTap: () {
                        //         storePro.isRetailScreen =
                        //             !storePro.isRetailScreen;
                        //         storePro.notify();
                        //       },
                        //       child: Text(
                        //         LN.enableRetailScreen,
                        //         style: TextStyle(
                        //           color: kPrimaryColor,
                        //           fontFamily: kFontFMedium,
                        //           fontWeight: FontWeight.bold,
                        //           fontSize: size.getS(18),
                        //         ),
                        //       ),
                        //     ),
                        //   ],
                        // )
                      ],
                    ),
                    SizedBox(
                      height: size.getH(24),
                    ),
                    // Row(
                    //   mainAxisSize: MainAxisSize.min,
                    //   children: [
                    //     if (GlobalCVP.viewWidget.viewStoreGeneralTabSaveButton)
                    //       LoadButton(
                    //         loading: storePro.updateLoad,
                    //         onsave: storePro.updateLoad
                    //             ? null
                    //             : () {
                    //                 FocusScope.of(context).unfocus();
                    //                 storePro.addData(context);
                    //               },
                    //       ),
                    //     SizedBox(
                    //       width: size.getW(24),
                    //     ),
                    //     if (GlobalCVP
                    //         .viewWidget.viewStoreGeneralTabCancelButton)
                    //       ElevatedButton(
                    //           style: ButtonStyle(
                    //               backgroundColor: MaterialStateProperty.all(
                    //                   Colors.red.shade800),
                    //               padding: MaterialStateProperty.all(
                    //                   EdgeInsets.symmetric(
                    //                       horizontal: size.getW(48),
                    //                       vertical: size.getH(8)))),
                    //           onPressed: cancel,
                    //           child: Text(
                    //             LN.cancel,
                    //             style: TextStyle(
                    //               fontSize: size.getS(16),
                    //               color: Colors.white,
                    //               fontWeight: FontWeight.bold,
                    //             ),
                    //           )),
                    //   ],
                    // ),
                  ],
                ),
              ),
            ),
          ),
          SizedBox(
            height: size.getH(24),
          ),
        ],
      ),
    );
  }
}
