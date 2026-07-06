import 'package:flutter/material.dart';
import 'package:flutter_google_places_sdk/flutter_google_places_sdk.dart';
import 'package:location/location.dart';
import 'package:pos_account/constant/keys.dart';
import 'package:pos_account/ln.dart';
import 'package:pos_account/repository/if_exception.dart';
import 'package:pos_account/widgets/dialog/confirm_dialog.dart';

class MapUtils {
  //google places section
  static final _googlePlace = FlutterGooglePlacesSdk(Keys.gMapKey);

  // static String? storeLat;
  // static String? storeLong;

  // static LatLon? get _getStoreLatLong {
  //   final _lat = double.tryParse(storeLat ?? '') ?? 0.0;
  //   final _long = double.tryParse(storeLong ?? '') ?? 0.0;
  //   if (_lat == 0 || _long == 0) return null;

  //   final _latLong = LatLon(_lat, _long);

  //   return _latLong;
  // }

  static Future<FindAutocompletePredictionsResponse?> getPlaces({
    required String input,
    String? postalCode,
    String? region,
    double? orginLat,
    double? orginLng,
  }) async {
    final autoCompleteRes = await _googlePlace.findAutocompletePredictions(
        "$input${(postalCode?.isNotEmpty ?? false) ? ' $postalCode' : ''}",
        origin: orginLat != null && orginLng != null
            ? LatLng(lat: orginLat, lng: orginLng)
            : null,
        countries: region != null ? [region] : null);

    return autoCompleteRes;
  }

//get location section
  static Future<FetchPlaceResponse?> getLocation(String? placeId) async {
    if (placeId == null) return null;
    try {
      final details = await _googlePlace.fetchPlace(placeId, fields: [
        PlaceField.Address,
        PlaceField.Location,
      ]);
      return details;
    } catch (_) {
      //
    }

    return null;
  }

  // get Address from latlong
  // static Future<GoogleGeocodingResponse?> getAddress(
  //     {double? lat, double? lon}) async {
  //   if (lat == null || lon == null) return null;
  //   final api = GoogleGeocodingApi(Keys.gMapKey, isLogged: kDebugMode);

  //   final res = await api.reverse(
  //     '$lat,$lon',
  //     language: 'en',
  //   );
  //   return res;
  // }

  static LocData? _latlongData;

  static Future<LocData?> getCurrentLocation() async {
    if (_latlongData != null) return _latlongData;

    final _location = Location();
    try {
      bool serviceEnabled = await _location.serviceEnabled();
      if (!serviceEnabled && CUS_CTX != null) {
        await showDialog(
            context: CUS_CTX!,
            builder: (_) {
              return ConfirmDialog(
                title: LN.enableLocationService,
                subTitle: LN.toConDevLocAcc,
                actionText: LN.openLocSet,
                cancelText: LN.noThanks,
                onDelete: () async {
                  serviceEnabled = await _location.requestService();
                  return true;
                },
              );
            });

        if (!serviceEnabled) {
          IfException.showMessage(message: LN.pleaseTurnOnLocation);
          return null;
        }
      }

      PermissionStatus permission = await _location.hasPermission();

      if (permission == PermissionStatus.denied) {
        permission = await _location.requestPermission();
        if (permission == PermissionStatus.denied) {
          IfException.showMessage(message: LN.locationPermissionDenied);
          return null;
        }
      }

      final _loc = await _location.getLocation();

      _latlongData =
          LocData(latitude: _loc.latitude, longitude: _loc.longitude);

      Future.delayed(Duration(minutes: 5), () {
        _latlongData = null;
      });

      // kPrint("${_loc.latitude},${_loc.longitude}");

      return _latlongData;
    } catch (e) {
      IfException.showMessage(message: "Location service is not available");
      return null;
    }
  }
}

class LocData {
  final double? latitude;
  final double? longitude;

  LocData({required this.latitude, required this.longitude});
}
