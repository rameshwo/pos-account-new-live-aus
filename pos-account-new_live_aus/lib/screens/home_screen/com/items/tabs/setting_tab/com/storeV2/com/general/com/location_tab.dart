import 'package:flutter/material.dart';
import 'package:pos_account/config/size_config.dart';
import 'package:pos_account/ln.dart';
import 'package:pos_account/providers/setting/store/store_pro_v2.dart';
import 'package:pos_account/widgets/input/dropdown/title_drop_down.dart';
import 'package:pos_account/widgets/input/text_form/auto_complete_text_field.dart';
import 'package:pos_account/widgets/input/text_form/title_text_form.dart';
import 'package:provider/provider.dart';

import '../../widgets/store_card.dart';

class LocationTab extends StatelessWidget {
  const LocationTab({super.key});

  @override
  Widget build(BuildContext context) {
    final size = Ssize(context);
    final storePro = Provider.of<StoreProV2>(context);
    return SingleChildScrollView(
      child: Column(
        children: [
          StoreCardUI(
              title: "Location Information",
              iconData: Icons.location_on_outlined,
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
                    SearchTitleDropDown(
                      isReq: true,
                      pWidth: 0.20,
                      list: storePro.storeRes?.countryCityStates
                              ?.map((e) => e.name ?? '')
                              .toList() ??
                          [],
                      indexVal:
                          (storePro.storeRes?.countryCityStates?.isNotEmpty ??
                                  false)
                              ? storePro.countryIndex
                              : null,
                      title: LN.country,
                      onChanged: (int? p0) {
                        storePro.countryIndex = p0;
                        storePro.phoneCodeIndex = p0;
                        storePro.stateIndex = null;
                        storePro.cityIndex = null;
                        storePro.suburbIndex = null;
                        storePro.notify;
                      },
                    ),
                    SearchTitleDropDown(
                      title: LN.state,
                      pWidth: 0.20,
                      isReq: true,
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
                              .countryCityStates![storePro.countryIndex!]
                              .states!
                              .map((e) => e.name ?? '')
                              .toList()
                          : [],
                      onChanged: (p0) {
                        storePro.stateIndex = p0;
                        storePro.cityIndex = null;
                        storePro.suburbIndex = null;
                        storePro.notify;
                      },
                    ),
                    SearchTitleDropDown(
                      title: LN.city,
                      pWidth: 0.20,
                      isReq: true,
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
                        storePro.notify;
                      },
                    ),
                    SearchTitleDropDown(
                      title: "Suburb",
                      pWidth: 0.20,
                      isReq: true,
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
                                  .countryCityStates![storePro.countryIndex!]
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
                        storePro.notify;
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
                  ],
                ),
              )),
          StoreCardUI(
              title: "System Locale Settings",
              iconData: Icons.settings_outlined,
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
                      onChanged: (int? p0) {
                        storePro.timeZoneIndex = p0;
                        storePro.notify;
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
                        storePro.notify;
                      },
                    ),
                  ],
                ),
              )),
        ],
      ),
    );
  }
}
