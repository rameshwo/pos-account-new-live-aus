import 'package:flutter/material.dart';
import 'package:pos_account/config/size_config.dart';
import 'package:pos_account/constant/constant.dart';
import 'package:pos_account/constant/strings.dart';
import 'package:pos_account/ln.dart';
import 'package:pos_account/providers/cus_val_pro.dart';
import 'package:pos_account/providers/new_org/new_org_pro.dart';
import 'package:pos_account/screens/home_screen/com/subscription/change_plan/bill_subs_plan.dart';
import 'package:pos_account/services/web_view/inapp_web_screen.dart';
// import 'package:pos_account/services/web_view/webview_screen.dart';
import 'package:pos_account/widgets/agreement_sec.dart';
import 'package:pos_account/widgets/image/network_image_sec.dart';
import 'package:pos_account/widgets/input/text_form/auto_complete_text_field.dart';
import 'package:pos_account/widgets/input/dropdown/dropdown_with_text_form.dart';
import 'package:pos_account/widgets/input/dropdown/title_drop_down.dart';
import 'package:pos_account/widgets/input/text_form/title_text_form.dart';
import 'package:pos_account/widgets/load_btn.dart';
import 'package:pos_account/widgets/loading.dart';
import 'package:provider/provider.dart';
import '../header_section.dart';

class AddNewOrg extends StatefulWidget {
  final CusValuePro cvp;
  const AddNewOrg({
    super.key,
    required this.cvp,
  });

  @override
  State<AddNewOrg> createState() => _AddNewOrgState();
}

class _AddNewOrgState extends State<AddNewOrg> {
  final _formKey = GlobalKey<FormState>();
  @override
  void initState() {
    super.initState();
    getData();
  }

  void getData() {
    final orgPro = Provider.of<NewOrgPro>(context, listen: false);
    orgPro.getAddSec();
  }

  @override
  Widget build(BuildContext context) {
    final size = Ssize(context);
    final orgPro = Provider.of<NewOrgPro>(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        HeaderSection(
          cvp: widget.cvp,
          // showEndDrawer: false,
        ),
        Flexible(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: size.getW(60)),
            child: Processing(
              loading: orgPro.loading,
              align: Alignment.topLeft,
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      children: [
                        Text(
                          LN.addUrOrg,
                          style: TextStyle(
                            color: kPrimaryColor,
                            fontFamily: kFontFMedium,
                            fontSize: size.getS(24),
                          ),
                        ),
                        Spacer(),
                        IconButton(
                            padding: EdgeInsets.zero,
                            onPressed: () {
                              widget.cvp.setupStoreInfo();
                            },
                            icon: Icon(
                              Icons.close,
                              size: size.getS(28),
                            ))
                      ],
                    ),
                    Flexible(
                      child: Card(
                        margin: EdgeInsets.zero,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: size.getW(24),
                          ),
                          child: SingleChildScrollView(
                            physics: BouncingScrollPhysics(),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                SizedBox(
                                  height: size.getH(16),
                                ),
                                SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  physics: BouncingScrollPhysics(),
                                  child: Row(
                                    children: [
                                      ...List.generate(
                                          orgPro.channelList.length,
                                          (index) => Stack(
                                                children: [
                                                  Padding(
                                                    padding: EdgeInsets.only(
                                                        right: size.getW(32)),
                                                    child: Material(
                                                      color: kUserColor
                                                          .withAlpha(50),
                                                      shape:
                                                          RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          15)),
                                                      child: InkWell(
                                                        onTap: () {
                                                          orgPro.selectedChannelIndex =
                                                              index;
                                                          orgPro.notify;
                                                        },
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(15),
                                                        highlightColor:
                                                            kUserColor
                                                                .withAlpha(60),
                                                        splashColor: kUserColor
                                                            .withAlpha(200),
                                                        child: Container(
                                                          width: size.getW(364),
                                                          height:
                                                              size.getH(236),
                                                          padding: EdgeInsets
                                                              .symmetric(
                                                                  horizontal:
                                                                      size.getW(
                                                                          12),
                                                                  vertical:
                                                                      size.getH(
                                                                          12)),
                                                          decoration: BoxDecoration(
                                                              color: Colors
                                                                  .transparent,
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          15)),
                                                          child: Column(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .center,
                                                            children: [
                                                              Image.asset(
                                                                orgPro
                                                                        .channelList[
                                                                            index]
                                                                        .additionalValue ??
                                                                    '',
                                                                height: size
                                                                    .getH(120),
                                                              ),
                                                              SizedBox(
                                                                height: size
                                                                    .getH(16),
                                                              ),
                                                              Flexible(
                                                                child: Text(
                                                                  orgPro.channelList[index]
                                                                          .name ??
                                                                      '',
                                                                  style:
                                                                      TextStyle(
                                                                    color: Colors
                                                                        .black,
                                                                    fontFamily:
                                                                        kFontFMedium,
                                                                    fontSize:
                                                                        size.getS(
                                                                            21),
                                                                  ),
                                                                  textAlign:
                                                                      TextAlign
                                                                          .center,
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  Positioned(
                                                    top: size.getH(12),
                                                    left: size.getW(12),
                                                    child: CustomCheckBtn(
                                                      size: size,
                                                      iconSize: 32,
                                                      checked: index ==
                                                          orgPro
                                                              .selectedChannelIndex,
                                                      uncheckedBackColor:
                                                          Colors.white,
                                                    ),
                                                  ),
                                                ],
                                              )),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  height: size.getH(16),
                                ),
                                Wrap(
                                  spacing: size.getW(32),
                                  runSpacing: size.getH(16),
                                  children: [
                                    TitleTextForm(
                                      title: LN.businessName,
                                      textCltr: orgPro.bNameCltr,
                                      pWidth: 0.24,
                                      borderColor: Colors.black38,
                                    ),
                                    TitleTextForm(
                                      title: LN.businessEmail,
                                      textCltr: orgPro.bEmailCltr,
                                      pWidth: 0.24,
                                      borderColor: Colors.black38,
                                    ),
                                    SearchTitleDropDown(
                                      title: LN.country,
                                      pWidth: 0.24,
                                      isReq: true,
                                      borderColor: Colors.black38,
                                      indexVal: orgPro.countryIndex,
                                      list: orgPro.addSec?.countries == null ||
                                              orgPro.addSec!.countries!.isEmpty
                                          ? []
                                          : orgPro.addSec!.countries!
                                              .map((e) => e.name ?? '')
                                              .toList(),
                                      onChanged: (p0) {
                                        orgPro.countryIndex = p0;
                                        orgPro.phoneCodeIndex = p0;
                                        orgPro.stateIndex = null;
                                        orgPro.cityIndex = null;
                                        orgPro.subUrbIndex = null;
                                        orgPro.notify;
                                      },
                                    ),
                                    SearchTitleDropDown(
                                      title: LN.state,
                                      pWidth: 0.24,
                                      isReq: true,
                                      borderColor: Colors.black38,
                                      indexVal: orgPro.stateIndex,
                                      list: orgPro.countryIndex == null ||
                                              orgPro
                                                      .addSec
                                                      ?.countries?[
                                                          orgPro.countryIndex!]
                                                      .states ==
                                                  null ||
                                              orgPro
                                                  .addSec!
                                                  .countries![
                                                      orgPro.countryIndex!]
                                                  .states!
                                                  .isEmpty
                                          ? []
                                          : orgPro
                                              .addSec!
                                              .countries![orgPro.countryIndex!]
                                              .states!
                                              .map((e) => e.name ?? '')
                                              .toList(),
                                      onChanged: (p0) {
                                        orgPro.stateIndex = p0;
                                        orgPro.cityIndex = null;
                                        orgPro.subUrbIndex = null;
                                        orgPro.notify;
                                      },
                                    ),
                                    SearchTitleDropDown(
                                      title: LN.city,
                                      pWidth: 0.24,
                                      isReq: true,
                                      borderColor: Colors.black38,
                                      indexVal: orgPro.cityIndex,
                                      list: orgPro.countryIndex == null ||
                                              orgPro.stateIndex == null ||
                                              orgPro
                                                      .addSec
                                                      ?.countries?[
                                                          orgPro.countryIndex!]
                                                      .states?[
                                                          orgPro.stateIndex!]
                                                      .cities ==
                                                  null ||
                                              orgPro
                                                  .addSec!
                                                  .countries![
                                                      orgPro.countryIndex!]
                                                  .states![orgPro.stateIndex!]
                                                  .cities!
                                                  .isEmpty
                                          ? []
                                          : orgPro
                                              .addSec!
                                              .countries![orgPro.countryIndex!]
                                              .states![orgPro.stateIndex!]
                                              .cities!
                                              .map((e) => e.name ?? '')
                                              .toList(),
                                      onChanged: (p0) {
                                        orgPro.cityIndex = p0;
                                        orgPro.subUrbIndex = null;
                                        orgPro.notify;
                                      },
                                    ),
                                    SearchTitleDropDown(
                                      title: "Suburb",
                                      pWidth: 0.24,
                                      isReq: true,
                                      borderColor: Colors.black38,
                                      indexVal: orgPro.subUrbIndex,
                                      list: orgPro.countryIndex == null ||
                                              orgPro.stateIndex == null ||
                                              orgPro.cityIndex == null ||
                                              orgPro
                                                      .addSec
                                                      ?.countries?[
                                                          orgPro.countryIndex!]
                                                      .states?[
                                                          orgPro.stateIndex!]
                                                      .cities?[
                                                          orgPro.cityIndex!]
                                                      .suburbs ==
                                                  null ||
                                              orgPro
                                                  .addSec!
                                                  .countries![
                                                      orgPro.countryIndex!]
                                                  .states![orgPro.stateIndex!]
                                                  .cities![orgPro.cityIndex!]
                                                  .suburbs!
                                                  .isEmpty
                                          ? []
                                          : orgPro
                                              .addSec!
                                              .countries![orgPro.countryIndex!]
                                              .states![orgPro.stateIndex!]
                                              .cities![orgPro.cityIndex!]
                                              .suburbs!
                                              .map((e) => e.name ?? '')
                                              .toList(),
                                      onChanged: (p0) {
                                        orgPro.subUrbIndex = p0;
                                        orgPro.notify;
                                      },
                                    ),
                                    DropDownWiTextForm(
                                      title: LN.businessPhone,
                                      isReq: true,
                                      indexVal: orgPro.phoneCodeIndex,
                                      borderColor: Colors.black38,
                                      list: orgPro.addSec?.countries == null ||
                                              orgPro.addSec!.countries!.isEmpty
                                          ? []
                                          : orgPro.addSec!.countries!
                                              .map((e) => Row(
                                                    mainAxisSize:
                                                        MainAxisSize.min,
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
                                                                  ? size
                                                                      .getW(12)
                                                                  : size
                                                                      .getS(16),
                                                              color:
                                                                  Colors.black,
                                                            ),
                                                          ),
                                                        ),
                                                      )
                                                    ],
                                                  ))
                                              .toList(),
                                      onChanged: (p0) {
                                        orgPro.phoneCodeIndex = p0;
                                        orgPro.notify;
                                      },
                                      textCltr: orgPro.phoneCltr,
                                    ),
                                    TitleDropDown(
                                      pWidth: 0.24,
                                      borderColor: Colors.black38,
                                      list: orgPro.addSec
                                                  ?.businessTypeCategoriesWithBussinessTypes ==
                                              null
                                          ? []
                                          : orgPro.addSec!
                                              .businessTypeCategoriesWithBussinessTypes!
                                              .map((e) => e.value ?? '')
                                              .toList(),
                                      indexVal: orgPro.businessTypeCatIndex,
                                      title: LN.businessTypeCat,
                                      onChanged: (int? p0) {
                                        orgPro.businessTypeCatIndex = p0;
                                        orgPro.businessTypeIndex = null;
                                        orgPro.notify;
                                      },
                                      isReq: true,
                                    ),
                                    TitleDropDown(
                                      pWidth: 0.24,
                                      borderColor: Colors.black38,
                                      list: (orgPro.addSec?.businessTypeCategoriesWithBussinessTypes ==
                                                  null ||
                                              orgPro.businessTypeCatIndex ==
                                                  null ||
                                              orgPro
                                                      .addSec
                                                      ?.businessTypeCategoriesWithBussinessTypes?[
                                                          orgPro
                                                              .businessTypeCatIndex!]
                                                      .businessTypes ==
                                                  null)
                                          ? []
                                          : orgPro
                                              .addSec!
                                              .businessTypeCategoriesWithBussinessTypes![
                                                  orgPro.businessTypeCatIndex!]
                                              .businessTypes!
                                              .map((e) => e.value ?? '')
                                              .toList(),
                                      indexVal: orgPro.businessTypeIndex,
                                      title: LN.businessType,
                                      onChanged: (int? p0) {
                                        orgPro.businessTypeIndex = p0;
                                        orgPro.notify;
                                      },
                                      isReq: true,
                                    ),
                                    SearchTitleDropDown(
                                      isReq: true,
                                      pWidth: 0.24,
                                      list: orgPro.addSec?.timeZones == null ||
                                              orgPro.addSec!.timeZones!.isEmpty
                                          ? []
                                          : orgPro.addSec!.timeZones!
                                              .map((e) => e.value ?? '')
                                              .toList(),
                                      indexVal: orgPro.timezoneIndex,
                                      title: LN.timezone,
                                      borderColor: Colors.black38,
                                      onChanged: (int? p0) {
                                        orgPro.timezoneIndex = p0;
                                        orgPro.notify;
                                      },
                                    ),
                                    AutoCompleteText(
                                      title: LN.address,
                                      textCltr: orgPro.addressCltr,
                                      hintText: LN.address,
                                      borderColor: Colors.black38,
                                      suffixIcon:
                                          orgPro.addressCltr.text.isEmpty
                                              ? null
                                              : InkWell(
                                                  onTap: () {
                                                    orgPro.addressCltr.clear();
                                                  },
                                                  child: Icon(Icons.close,
                                                      size: size.getS(32)),
                                                ),
                                      asyncSuggestions: (String val) async {
                                        if (val.isNotEmpty)
                                          await orgPro.getPlaces(input: val);

                                        return orgPro.getAutoPlaces
                                                    ?.predictions ==
                                                null
                                            ? []
                                            : orgPro.getAutoPlaces!.predictions
                                                .map((e) => e.primaryText)
                                                .toSet()
                                                .toList();
                                      },
                                      onSubmit: (val) {
                                        // if (orgPro.getAutoPlaces!.predictions!
                                        //     .any((e) => e.description == val)) {
                                        // final _pId = orgPro
                                        //     .getAutoPlaces!.predictions!
                                        //     .firstWhere(
                                        //         (e) => e.description == val)
                                        //     .placeId;
                                        // orgPro.setPlaceId = _pId;
                                        // }
                                      },
                                    ),
                                    TitleTextForm(
                                      title: LN.abnNum,
                                      textCltr: orgPro.abnNumCltr,
                                      pWidth: 0.24,
                                      borderColor: Colors.black38,
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: size.getH(16),
                                ),
                                Row(
                                  children: [
                                    Checkbox(
                                      value: orgPro.acceptTerm,
                                      onChanged: (val) {
                                        if (val == null) return;
                                        orgPro.acceptTerm = val;
                                        orgPro.notify;
                                      },
                                      activeColor: kSecondaryColor,
                                    ),
                                    Flexible(
                                        child: AgreementSec(
                                      text: LN.agreeTermsOnBilling,
                                      fontSize: 16,
                                      onTap: (p0) {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (ctx) =>
                                                    InAppWebViewScreen(
                                                        transparentBackground:
                                                            false,
                                                        showBackButton: true,
                                                        webContent: WebContent(
                                                          title:
                                                              LN.termOfService,
                                                          url: Strings
                                                              .termsOfServiceUrl,
                                                        ))));
                                      },
                                    )),
                                  ],
                                ),
                                SizedBox(
                                  height: size.getH(12),
                                ),
                                Row(
                                  children: [
                                    LoadButton(
                                      width: 240,
                                      hPad: 4,
                                      btnText: LN.addNewOrg,
                                      btnColor: kUserColor,
                                      loading: orgPro.btnLoad,
                                      onsave: orgPro.btnLoad
                                          ? null
                                          : () {
                                              if (_formKey.currentState!
                                                  .validate()) {
                                                orgPro.addNew().then((value) {
                                                  if (value ?? false) {
                                                    GlobalCVP
                                                        .getStoreListServer();
                                                  }
                                                });
                                              }
                                            },
                                    ),
                                    SizedBox(
                                      width: size.getW(24),
                                    ),
                                    LoadButton(
                                      btnText: LN.cancel,
                                      btnColor: Colors.red.shade700,
                                      onsave: () {
                                        widget.cvp.setupStoreInfo();
                                      },
                                    )
                                  ],
                                ),
                                SizedBox(
                                  height: size.getH(24),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
