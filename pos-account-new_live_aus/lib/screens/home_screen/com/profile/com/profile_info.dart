import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pos_account/config/size_config.dart';
import 'package:pos_account/constant/constant.dart';
import 'package:pos_account/constant/text_formatter.dart';
import 'package:pos_account/ln.dart';
import 'package:pos_account/model/ui_model/screen_time_model.dart';
import 'package:pos_account/providers/cus_val_pro.dart';
import 'package:pos_account/providers/profile/profile_pro.dart';
import 'package:pos_account/services/database/database/db_local_data.dart';
import 'package:pos_account/widgets/image/network_image_sec.dart';
import 'package:pos_account/widgets/input/dropdown/dropdown_with_text_form.dart';
import 'package:pos_account/widgets/input/dropdown/title_drop_down.dart';
import 'package:pos_account/widgets/input/text_form/title_text_form.dart';
import 'package:pos_account/widgets/load_btn.dart';
import 'package:pos_account/widgets/switch_adap.dart';

class ProfileInfoSec extends StatelessWidget {
  const ProfileInfoSec({
    super.key,
    required this.size,
    required this.pro,
  });

  final Ssize size;
  final ProfilePro pro;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: pro.formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Text(
                LN.editProfile,
                style: TextStyle(
                  color: Colors.black38,
                  fontFamily: kFontFMedium,
                  fontSize: size.getS(24),
                ),
              ),
              Spacer(),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SwitchAdap(
                      size: size,
                      value: pro.pushNotificationEnable,
                      onChanged: (val) {
                        pro.pushNotificationEnable = val;
                        pro.notify;
                      }),
                  SizedBox(
                    width: size.getW(12),
                  ),
                  Text(
                    LN.pushNoti,
                    style: TextStyle(
                      color: Colors.black,
                      fontFamily: kFontFMedium,
                      fontSize: size.getS(16),
                    ),
                  ),
                ],
              ),
              SizedBox(width: size.getW(120))
            ],
          ),
          SizedBox(
            height: size.getH(12),
          ),
          Wrap(
            spacing: size.getW(32),
            runSpacing: size.getH(16),
            children: [
              TitleTextForm(
                title: LN.fullName,
                isReq: true,
                hintText: LN.fullname,
                textCltr: pro.nameCltr,
                borderColor: Colors.black12,
                pWidth: 0.20,
              ),
              TitleTextForm(
                title: LN.email,
                isReq: false,
                readOnly: true,
                hintText: LN.emailAddress,
                textCltr: pro.emailCltr,
                borderColor: Colors.black12,
                pWidth: 0.20,
                fillColor: Colors.grey.shade100,
              ),
              SearchTitleDropDown(
                title: LN.country,
                isReq: true,
                list: pro.userAddSec?.countryCityStates == null
                    ? []
                    : pro.userAddSec!.countryCityStates!
                        .map((e) => e.name ?? '')
                        .toList(),
                indexVal: pro.countryIndex,
                onChanged: (p0) {
                  pro.countryIndex = p0;
                  pro.phoneCodeIndex = p0;
                  pro.stateIndex = null;
                  pro.cityIndex = null;
                  pro.suburbIndex = null;
                  pro.notify;
                },
                borderColor: Colors.black12,
                pWidth: 0.20,
              ),
              SearchTitleDropDown(
                title: LN.state,
                pWidth: 0.20,
                isReq: true,
                borderColor: Colors.black12,
                indexVal: pro.stateIndex,
                list: pro.countryIndex == null ||
                        pro.userAddSec?.countryCityStates?[pro.countryIndex!]
                                .states ==
                            null ||
                        pro.userAddSec!.countryCityStates![pro.countryIndex!]
                            .states!.isEmpty
                    ? []
                    : pro.userAddSec!.countryCityStates![pro.countryIndex!]
                        .states!
                        .map((e) => e.name ?? '')
                        .toList(),
                onChanged: (p0) {
                  pro.stateIndex = p0;
                  pro.cityIndex = null;
                  pro.suburbIndex = null;
                  pro.notify;
                },
              ),
              SearchTitleDropDown(
                title: LN.city,
                pWidth: 0.20,
                isReq: true,
                borderColor: Colors.black12,
                indexVal: pro.cityIndex,
                list: pro.countryIndex == null ||
                        pro.stateIndex == null ||
                        pro.userAddSec?.countryCityStates?[pro.countryIndex!]
                                .states?[pro.stateIndex!].cities ==
                            null ||
                        pro.userAddSec!.countryCityStates![pro.countryIndex!]
                            .states![pro.stateIndex!].cities!.isEmpty
                    ? []
                    : pro.userAddSec!.countryCityStates![pro.countryIndex!]
                        .states![pro.stateIndex!].cities!
                        .map((e) => e.name ?? '')
                        .toList(),
                onChanged: (p0) {
                  pro.cityIndex = p0;
                  pro.suburbIndex = null;
                  pro.notify;
                },
              ),
              SearchTitleDropDown(
                title: "Suburb",
                pWidth: 0.20,
                isReq: true,
                borderColor: Colors.black12,
                indexVal: pro.suburbIndex,
                list: pro.countryIndex == null ||
                        pro.stateIndex == null ||
                        pro.cityIndex == null ||
                        pro
                                .userAddSec
                                ?.countryCityStates?[pro.countryIndex!]
                                .states?[pro.stateIndex!]
                                .cities?[pro.cityIndex!]
                                .suburbs ==
                            null ||
                        pro
                            .userAddSec!
                            .countryCityStates![pro.countryIndex!]
                            .states![pro.stateIndex!]
                            .cities![pro.cityIndex!]
                            .suburbs!
                            .isEmpty
                    ? []
                    : pro
                        .userAddSec!
                        .countryCityStates![pro.countryIndex!]
                        .states![pro.stateIndex!]
                        .cities![pro.cityIndex!]
                        .suburbs!
                        .map((e) => e.name ?? '')
                        .toList(),
                onChanged: (p0) {
                  pro.suburbIndex = p0;
                  pro.notify;
                },
              ),

              DropDownWiTextForm(
                title: LN.phoneNumber,
                isReq: true,
                pWidth: 0.20,
                borderColor: Colors.black12,
                indexVal: pro.phoneCodeIndex,
                list: pro.userAddSec == null ||
                        pro.userAddSec!.countryCityStates == null
                    ? []
                    : pro.userAddSec!.countryCityStates!
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
                  pro.phoneCodeIndex = p0;
                  pro.notify;
                },
                textCltr: pro.phoneCltr,
              ),
              TitleTextForm(
                title: LN.postalCode,
                isReq: true,
                hintText: "",
                textCltr: pro.postalCltr,
                borderColor: Colors.black12,
                pWidth: 0.20,
              ),

              // AutoCompleteText(
              //   title: LN.address,
              //   textCltr: pro.addressCltr,
              //   hintText: LN.address,
              //   borderColor: Colors.black12,
              //   onChanged: (String val) {
              //     if (val.length > 2)
              //       Future.delayed(Duration(milliseconds: 500), () {
              //         pro.getPlaces(
              //           input: val,
              //           country: pro.countryIndex == null
              //               ? null
              //               : pro.userAddSec
              //                   ?.countryCityStates?[pro.countryIndex!].name,
              //         );
              //       });
              //   },
              //   suggestion: (pro.getAutoPlaces == null ||
              //           pro.getAutoPlaces!.predictions == null)
              //       ? []
              //       : pro.getAutoPlaces!.predictions!
              //           .map((e) => e.description!)
              //           .toSet()
              //           .toList(),
              //   onSubmit: (val) {
              //     if (pro.getAutoPlaces!.predictions!
              //         .any((e) => e.description == val)) {
              //       final _pId = pro.getAutoPlaces!.predictions!
              //           .firstWhere((e) => e.description == val)
              //           .placeId;
              //       pro.setPlaceId = _pId;
              //     }
              //   },
              // ),
            ],
          ),
          SizedBox(height: size.getH(24)),

          Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.black26)),
            width: double.infinity,
            padding: EdgeInsets.all(size.getS(16)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Account Information",
                  style: TextStyle(
                    fontSize: size.getS(16),
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                Divider(),
                SizedBox(height: size.getH(12)),
                Wrap(
                  spacing: size.getW(24),
                  runSpacing: size.getH(16),
                  children: [
                    TitleDropDown(
                        title: "POS Tab Default Screen Name",
                        list: pro.userAddSec?.posTabDefaultScreens == null
                            ? []
                            : pro.userAddSec!.posTabDefaultScreens!
                                .map((e) => e.name ?? '')
                                .toList(),
                        borderColor: Colors.black12,
                        pWidth: 0.20,
                        indexVal: pro.defaultScreenIndex,
                        onChanged: (p0) {
                          pro.defaultScreenIndex = p0;
                          pro.notify;
                        },
                        sufIcon: InkWell(
                            onTap: () {
                              pro.defaultScreenIndex = null;
                              pro.notify;
                            },
                            child: Icon(Icons.close, size: size.getS(24)))),
                    TitleTextForm(
                      title: "Login Pin",
                      isReq: false,
                      hintText: "Pin code",
                      textCltr: pro.pinCltr,
                      borderColor: Colors.black12,
                      pWidth: 0.20,
                      textInputType: TextInputType.number,
                      inputFormatters: [
                        NonNegativeTextInputFormatter(),
                        FilteringTextInputFormatter.digitsOnly,
                        LengthLimitingTextInputFormatter(4),
                      ],
                      suffix: InkWell(
                        onTap: () {
                          pro.generatePin();
                        },
                        child: Row(
                          children: [
                            Icon(Icons.key, size: size.getS(18)),
                            Text(
                              "Generate random 4 digit",
                              style: TextStyle(
                                fontSize: size.getS(14),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    TitleTextForm(
                      title: " Confirm Login Pin",
                      isReq: false,
                      hintText: "Confirm Pin code",
                      textCltr: pro.confirmPinCltr,
                      borderColor: Colors.black12,
                      pWidth: 0.22,
                      textInputType: TextInputType.number,
                      inputFormatters: [
                        NonNegativeTextInputFormatter(),
                        FilteringTextInputFormatter.digitsOnly,
                        LengthLimitingTextInputFormatter(4),
                      ],
                    ),
                    TitleDropDown(
                      title: LN.screenTime,
                      list: ScreenTimeOut.map((e) => e.title).toList(),
                      indexVal: pro.intervalIndex,
                      onChanged: (p0) {
                        pro.intervalIndex = p0;
                        pro.notify;
                      },
                      borderColor: Colors.black12,
                      pWidth: 0.20,
                    ),
                    SizedBox(
                      width: size.width * 0.20,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text("Login Pin Code Popup Screen",
                              style: TextStyle(
                                fontSize: size.getS(18),
                                color: Colors.black,
                              )),
                          SizedBox(
                            height: size.getH(12),
                          ),
                          SwitchAdap(
                              height: 32,
                              size: size,
                              value: pro.enablePinCode,
                              onChanged: (val) {
                                pro.enablePinCode = val;
                                pro.notify;
                              }),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: size.getH(4)),
              ],
            ),
          ),

          SizedBox(height: size.getH(32)),

          LoadButton(
            btnText: LN.save,
            btnColor: kUserColor,
            loading: pro.updateLoad,
            onsave: () async {
              if (pro.formKey.currentState!.validate()) {
                final status = await pro.updateUser();
                if (status ?? false) {
                  final loginRes = await DbLocalData.getLoginData();
                  if (loginRes != null) {
                    loginRes.name = pro.userInfo?.name;
                    loginRes.email = pro.userInfo?.email;
                    loginRes.image = pro.userInfo?.image;
                    await DbLocalData.updateLoginData(loginRes: loginRes);
                    GlobalCVP.notify;
                  }
                }
              }
            },
          ),

          SizedBox(
            height: size.getH(16),
          ),

          // Padding(
          //   padding: EdgeInsets.only(top: size.getH(32)),
          //   child: SingleChildScrollView(
          //     scrollDirection: Axis.horizontal,
          //     child: Row(
          //       mainAxisSize: MainAxisSize.min,
          //       children: [
          //         Text(
          //           LN.screenTime,
          //           style: TextStyle(
          //             color: Colors.black,
          //             fontFamily: kFontFMedium,
          //             fontSize: size.getS(18),
          //           ),
          //         ),
          //         SizedBox(
          //           width: size.getW(32),
          //         ),
          //         SizedBox(
          //           width: size.getW(240),
          //           child: DropDownList(
          //             borderColor: Colors.black12,
          //             vPad: 8,
          //             list: ScreenTimeOut.map((e) => e.title).toList(),
          //             onChange: (p0) {
          //               if (p0 == null) return;
          //               _ssPro.setScreenSaver = ScreenTimeOut[p0];
          //               // ..isAppLockEnable =
          //               //     _ssPro.isEnableScreenSaver.isAppLockEnable;
          //             },
          //             indexValue: ScreenTimeOut.any((e) =>
          //                     e.title == _ssPro.isEnableScreenSaver.title)
          //                 ? ScreenTimeOut.indexWhere((e) =>
          //                     e.title == _ssPro.isEnableScreenSaver.title)
          //                 : null,
          //           ),
          //         ),
          // if (_ssPro.isEnableScreenSaver.enable) ...[
          //   SizedBox(
          //     width: size.getW(32),
          //   ),
          //   SwitchAdap(
          //       height: 32,
          //       size: size,
          //       value: _ssPro.isEnableScreenSaver.isAppLockEnable,
          //       onChanged: (val) {
          //         final _data = _ssPro.isEnableScreenSaver;
          //         _data.isAppLockEnable = val;
          //         _ssPro.setScreenSaver = _data;
          //       }),
          //   SizedBox(
          //     width: size.getW(12),
          //   ),
          //   Text(
          //     LN.enableAppLock,
          //     style: TextStyle(
          //       color: Colors.black,
          //       fontFamily: kFontFMedium,
          //       fontSize: size.getS(16),
          //     ),
          //   )
          // ]
          //       ],
          //     ),
          //   ),
          // ),
        ],
      ),
    );
  }
}
