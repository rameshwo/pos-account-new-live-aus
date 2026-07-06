import 'package:flutter/material.dart';
import 'package:flutter_google_places_sdk/flutter_google_places_sdk.dart';
import 'package:pos_account/config/utils/map_utils.dart';
import 'package:pos_account/ln.dart';
import 'package:pos_account/model/common/table_location.dart';
import 'package:pos_account/model/new_org/board_add_sec.dart';
import 'package:pos_account/model/new_org/board_store_req.dart';
import 'package:pos_account/repository/handler.dart';

class NewOrgPro extends ChangeNotifier {
  void get notify => notifyListeners();

  int? selectedChannelIndex = 0;

  final bNameCltr = TextEditingController();
  final bEmailCltr = TextEditingController();
  final phoneCltr = TextEditingController();
  final addressCltr = TextEditingController();
  final abnNumCltr = TextEditingController();
  int? phoneCodeIndex;
  int? businessTypeCatIndex;
  int? businessTypeIndex;
  int? timezoneIndex;
  int? countryIndex;
  int? stateIndex;
  int? cityIndex;
  int? subUrbIndex;
  bool acceptTerm = false;

  List<TableLocation> get channelList => <TableLocation>[
        TableLocation(
          name: LN.pointOfSale,
          additionalValue: "assets/png/pointofsale.png",
          value: 'POS',
          isSelected: true,
        ),
        TableLocation(
          name: LN.onlineOrSys,
          additionalValue: "assets/png/onlineorder.png",
          value: 'OnlineOrder',
          isSelected: true,
        ),
        TableLocation(
          name: LN.posOnlineOrderSys,
          additionalValue: "assets/png/pos_online.png",
          value: 'POSAndOnline',
          isSelected: true,
        )
      ];

  BoardStoreAddSec? addSec;
  bool loading = true;

  Future<void> getAddSec() async {
    addSec = await Handler.boardAddSec();
    setData();
    loading = false;
    notify;
  }

  void setData() {
    if (addSec?.countries != null &&
        addSec!.countries!.any((e) => e.isSelected ?? false)) {
      final selected =
          addSec!.countries!.indexWhere((e) => e.isSelected ?? false);
      countryIndex = selected;
      phoneCodeIndex = selected;
    }
  }

  bool btnLoad = false;

  Future<bool?> addNew() async {
    final req = BoardStoreReq()
      ..name = bNameCltr.text
      ..email = bEmailCltr.text
      ..phoneNumber = phoneCltr.text
      ..address = addressCltr.text
      ..abnNumber = abnNumCltr.text;

    if (addSec?.countries != null && addSec!.countries!.isNotEmpty) {
      if (phoneCodeIndex != null) {
        req.countryPhoneNumberPrefixId = addSec!.countries![phoneCodeIndex!].id;
      }
      if (countryIndex != null) {
        req.countryId = addSec!.countries![countryIndex!].id;
        if (stateIndex != null) {
          req.stateId =
              addSec!.countries![countryIndex!].states![stateIndex!].id;
          if (cityIndex != null) {
            req.cityId = addSec!.countries![countryIndex!].states![stateIndex!]
                .cities![cityIndex!].id;

            if (subUrbIndex != null) {
              req.suburbId = addSec!
                  .countries![countryIndex!]
                  .states![stateIndex!]
                  .cities![cityIndex!]
                  .suburbs![subUrbIndex!]
                  .id;
            }
          }
        }
      }
    }
    if (addSec?.businessTypeCategoriesWithBussinessTypes != null &&
        businessTypeCatIndex != null) {
      req.businessTypeCategoryId = addSec!
          .businessTypeCategoriesWithBussinessTypes![businessTypeCatIndex!].id;

      if (addSec
                  ?.businessTypeCategoriesWithBussinessTypes?[
                      businessTypeCatIndex!]
                  .businessTypes !=
              null &&
          businessTypeIndex != null) {
        req.businessTypeId = addSec!
            .businessTypeCategoriesWithBussinessTypes![businessTypeCatIndex!]
            .businessTypes![businessTypeIndex!]
            .id;
      }
    }

    // if (addSec?.businessTypes != null && businessTypeIndex != null) {
    //   _req.businessTypeId = addSec!.businessTypes![businessTypeIndex!].id;
    // }

    if (addSec?.timeZones != null && timezoneIndex != null) {
      req.timeZoneId = addSec!.timeZones![timezoneIndex!].id;
    }
    req.isTermsAndConditionsAccepted = acceptTerm;
    req.isPrivacyPolicyAccepted = acceptTerm;
    if (selectedChannelIndex != null) {
      req.channelType = channelList[selectedChannelIndex!].value;
    }

    final location = await _getLocation();
    final lat = location?.place?.latLng?.lat;
    final long = location?.place?.latLng?.lng;
    req.latitude = lat.toString();
    req.longitude = long.toString();

    btnLoad = true;
    notify;

    final status = await Handler.boardStore(req: req);

    if (status ?? false) {
      clear();
    }

    btnLoad = false;
    notify;
    return status;
  }

  void clear() {
    selectedChannelIndex = 0;
    bNameCltr.clear();
    bEmailCltr.clear();
    phoneCltr.clear();
    addressCltr.clear();
    abnNumCltr.clear();
    phoneCodeIndex = null;
    businessTypeCatIndex = null;
    businessTypeIndex = null;
    timezoneIndex = null;
    countryIndex = null;
    stateIndex = null;
    cityIndex = null;
    subUrbIndex = null;
    acceptTerm = false;
  }

  //google places section
  FindAutocompletePredictionsResponse? getAutoPlaces;

  Future<void> getPlaces({required String input}) async {
    getAutoPlaces = await MapUtils.getPlaces(
      input: input,
      region:
          countryIndex == null ? null : addSec?.countries?[countryIndex!].value,
    );
    notify;
  }

  Future<FetchPlaceResponse?> _getLocation() async {
    if (getAutoPlaces!.predictions.any((e) => e.fullText == addressCltr.text)) {
      // final _pId = getAutoPlaces!.predictions
      //     .firstWhere((e) => e.description == addressCltr.text)
      //     .placeId;
      // if (_pId == null) return null;
      // return await _getLatLng(_pId);

      final pId = getAutoPlaces!.predictions
          .firstWhere((e) => e.fullText == addressCltr.text)
          .placeId;
      return await _getLatLng(pId);
    }
    return null;
  }

//get location section
  Future<FetchPlaceResponse?> _getLatLng(String placeId) async {
    return await MapUtils.getLocation(placeId);
  }
}
