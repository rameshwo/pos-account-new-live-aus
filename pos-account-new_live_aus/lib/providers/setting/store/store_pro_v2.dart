import 'package:flutter/material.dart';
import 'package:flutter_google_places_sdk/flutter_google_places_sdk.dart';
import 'package:pos_account/config/utils/map_utils.dart';
import 'package:pos_account/config/validator.dart';
import 'package:pos_account/model/home/setting/store/store_open_hour_model.dart';
import 'package:pos_account/model/home/setting/store/store_res.dart';
import 'package:pos_account/model/ui_model/store_ui_model.dart';
import 'package:pos_account/repository/handler.dart';
import 'package:pos_account/services/database/shared_pref.dart';
import 'package:pos_account/services/image/image_service.dart';
import 'package:pos_account/services/language/translate.dart';
import '../../../model/home/setting/general/upload_image_s3_res.dart';
import '../../../model/home/setting/store/store_charge_model.dart';
import '../../../model/home/setting/store/store_color_model.dart';
import '../../../model/home/setting/store/store_deli_dis_model.dart';
import '../../../model/home/setting/store/store_general_model.dart';
import '../../../model/home/setting/store/store_other_set_model.dart';

class StoreProV2 extends ChangeNotifier {
  void get notify => notifyListeners();

  String? curSym;
  String? dateFormat;
  StoreRes? storeRes;

  Future<void> getAddSec() async {
    curSym ??= await SharedPrefs.curSym;
    dateFormat ??= await SharedPrefs.dateFormat;
    storeRes ??= await Handler.getAllStoreList();
  }

  ////////////////---------------General------------------//////////////////
// store info
  final storeNameCltr = TextEditingController();
  final abnNumCltr = TextEditingController();
  final emailCltr = TextEditingController();
  int? phoneCodeIndex; //
  final phoneCltr = TextEditingController();

  int? langIndex;
  int? franchIndex;
  int? businessTypeCatIndex;
  int? businessTypeIndex;

//secondary email
  //secondary email
  final secondaryEmailList = <SecondaryEmailModel>[];
  final deletedSecondaryEmailIds = <String>[];

//store description
  String? storeMainDesc;
  String? storeAlertDesc;
  String? storefooterDesc;
  //google pin location
  final pinLocationCltr = TextEditingController();

  //-----------------Location------------------//
  // location info
  int? countryIndex;
  int? stateIndex;
  int? cityIndex;
  int? suburbIndex;
  final addressCltr = TextEditingController();
  final latCltr = TextEditingController();
  final longCltr = TextEditingController();

  // system locale setting
  int? timeZoneIndex;
  int? dateForIndex;

  //-----------------Tax------------------//
  // system tax setting
  int? taxInExIndex;
  final taxPercentCltr = TextEditingController();

  //-----------------Urls------------------//
  // url section
  final onlineUrlCltr = TextEditingController();
  final webUrlCltr = TextEditingController();
  final blogUrlCltr = TextEditingController();
  final bookingUrlCltr = TextEditingController();
  final qrUrlCltr = TextEditingController();
  final trackingUrlCltr = TextEditingController();
  final menuQrUrlCltr = TextEditingController();
  final sinageUrlCltr = TextEditingController();

  //-----------------Logo and images------------------//
  //store logo & favicon
  UploadImageS3Res? storeLogoImageS3;
  UploadImageS3Res? storeFavImageS3;
  UploadImageS3Res? noProdImageS3;
  final centralizedImageList = <CentralizedImage>[];
  final centralizedDeletedIds = <String>[];
  // UploadImageS3Res? centreDineImageS3;
  // UploadImageS3Res? eatsAptImageS3;

  //-----------------Others------------------//
  // channel notes
  final channelNotesList = <StoreChannelModel>[];

  // social media
  final socialMediaList = <SocialMediaModel>[];

  // delivery offer
  final freeDeliMessageCltr = TextEditingController();
  final freeDeliDiscountPerCltr = TextEditingController();
  final freeDeliMaxAmtThresoldCltr = TextEditingController();

  //scheduler

  bool loading = true;

  StoreGeneralModel? editGeneral;

  Future<void> getGeneralData() async {
    editGeneral = await Handler.getStoreGeneralSettings();
    _setGeneralData();
    loading = false;
    notify;
  }

  void _setGeneralData() {
    if (editGeneral == null) return;

    // store info

    storeNameCltr.text = editGeneral?.name ?? '';
    abnNumCltr.text = editGeneral!.abnNumber ?? '';
    emailCltr.text = editGeneral!.email ?? '';
    phoneCltr.text = editGeneral!.phoneNumber ?? '';

    if (editGeneral!.languageId != null &&
        (storeRes?.languages?.any((e) =>
                e.id?.toLowerCase() ==
                editGeneral!.languageId?.toLowerCase()) ??
            false))
      langIndex = storeRes!.languages!.indexWhere(
          (e) => e.id?.toLowerCase() == editGeneral!.languageId?.toLowerCase());

    if (storeRes?.franchises != null &&
        editGeneral!.franchiseId != null &&
        storeRes!.franchises!.any((e) =>
            e.id?.toLowerCase() == editGeneral!.franchiseId?.toLowerCase()))
      franchIndex = storeRes!.franchises!.indexWhere((e) =>
          e.id?.toLowerCase() == editGeneral!.franchiseId?.toLowerCase());

    if (storeRes?.businessTypeCategoriesWithBussinessTypes != null &&
        editGeneral?.businessTypeCategoryId != null &&
        storeRes!.businessTypeCategoriesWithBussinessTypes!.any((a) =>
            a.id?.toLowerCase() ==
            editGeneral!.businessTypeCategoryId?.toLowerCase())) {
      businessTypeCatIndex = storeRes!.businessTypeCategoriesWithBussinessTypes!
          .indexWhere((a) =>
              a.id?.toLowerCase() ==
              editGeneral!.businessTypeCategoryId?.toLowerCase());

      if (storeRes
                  ?.businessTypeCategoriesWithBussinessTypes?[
                      businessTypeCatIndex!]
                  .businessTypes !=
              null &&
          editGeneral?.businessTypeId != null &&
          storeRes!
              .businessTypeCategoriesWithBussinessTypes![businessTypeCatIndex!]
              .businessTypes!
              .any((b) =>
                  b.id?.toLowerCase() ==
                  editGeneral!.businessTypeId?.toLowerCase())) {
        businessTypeIndex = storeRes!
            .businessTypeCategoriesWithBussinessTypes![businessTypeCatIndex!]
            .businessTypes!
            .indexWhere((b) =>
                b.id?.toLowerCase() ==
                editGeneral!.businessTypeId?.toLowerCase());
      }
    }
    secondaryEmailList.clear();

    if (editGeneral?.secondaryEmailAddViewModels != null)
      for (final a in editGeneral!.secondaryEmailAddViewModels!) {
        secondaryEmailList.add(SecondaryEmailModel(
          id: a.id ?? '',
          emailCltr: TextEditingController(text: a.email),
          isActive: a.isActive ?? false,
        ));
      }

    storeMainDesc = editGeneral?.description ?? '';
    storeAlertDesc = editGeneral?.alertDescription ?? '';
    storefooterDesc = editGeneral?.footerDescription ?? '';
    pinLocationCltr.text = editGeneral?.googlePinnedLocation ?? '';

    // location info

    if (editGeneral!.countryId != null &&
        (storeRes?.countryCityStates?.any((e) =>
                e.id?.toLowerCase() == editGeneral!.countryId?.toLowerCase()) ??
            false)) {
      countryIndex = storeRes?.countryCityStates!.indexWhere(
          (e) => e.id?.toLowerCase() == editGeneral!.countryId?.toLowerCase());
      phoneCodeIndex = storeRes!.countryCityStates!.indexWhere(
          (e) => e.id?.toLowerCase() == editGeneral!.countryId?.toLowerCase());

      if (editGeneral?.stateId != null &&
          (storeRes?.countryCityStates?[countryIndex!].states?.any((e) =>
                  e.id?.toLowerCase() == editGeneral?.stateId?.toLowerCase()) ??
              false)) {
        stateIndex = storeRes?.countryCityStates?[countryIndex!].states!
            .indexWhere((e) =>
                e.id?.toLowerCase() == editGeneral?.stateId?.toLowerCase());

        if (editGeneral?.cityId != null &&
            (storeRes?.countryCityStates?[countryIndex!].states?[stateIndex!]
                    .cities
                    ?.any((e) =>
                        e.id?.toLowerCase() ==
                        editGeneral?.cityId?.toLowerCase()) ??
                false)) {
          cityIndex = storeRes
              ?.countryCityStates?[countryIndex!].states?[stateIndex!].cities
              ?.indexWhere((e) =>
                  e.id?.toLowerCase() == editGeneral?.cityId?.toLowerCase());

          if (editGeneral?.suburbId != null &&
              (storeRes?.countryCityStates?[countryIndex!].states?[stateIndex!]
                      .cities?[cityIndex!].suburbs
                      ?.any((e) =>
                          e.id?.toLowerCase() ==
                          editGeneral?.suburbId?.toLowerCase()) ??
                  false)) {
            suburbIndex = storeRes?.countryCityStates?[countryIndex!]
                .states?[stateIndex!].cities?[cityIndex!].suburbs
                ?.indexWhere((e) =>
                    e.id?.toLowerCase() ==
                    editGeneral?.suburbId?.toLowerCase());
          }
        }
      }
    }

    addressCltr.text = editGeneral!.address ?? '';
    latCltr.text = editGeneral!.latitude ?? '';
    longCltr.text = editGeneral!.longitude ?? '';

    if (editGeneral!.timeZoneId != null &&
        (storeRes?.timeZones?.any((e) =>
                e.id?.toLowerCase() ==
                editGeneral!.timeZoneId?.toLowerCase()) ??
            false))
      timeZoneIndex = storeRes!.timeZones!.indexWhere(
          (e) => e.id?.toLowerCase() == editGeneral!.timeZoneId?.toLowerCase());

    if (storeRes?.dateFormats != null &&
        editGeneral!.dateFormatId != null &&
        storeRes!.dateFormats!.any((e) =>
            e.id?.toLowerCase() == editGeneral!.dateFormatId?.toLowerCase()))
      dateForIndex = storeRes!.dateFormats!.indexWhere((e) =>
          e.id?.toLowerCase() == editGeneral!.dateFormatId?.toLowerCase());

    // system tax setting
    if (storeRes?.taxExclusiveInclusiveTypes != null &&
        editGeneral!.taxExclusiveInclusiveTypeId != null &&
        storeRes!.taxExclusiveInclusiveTypes!.any((e) =>
            e.id?.toLowerCase() ==
            editGeneral!.taxExclusiveInclusiveTypeId?.toLowerCase()))
      taxInExIndex = storeRes!.taxExclusiveInclusiveTypes!.indexWhere((e) =>
          e.id?.toLowerCase() ==
          editGeneral!.taxExclusiveInclusiveTypeId?.toLowerCase());

    taxPercentCltr.text = editGeneral!.taxPercentage ?? '';

    // url section

    onlineUrlCltr.text = editGeneral!.url ?? '';
    webUrlCltr.text = editGeneral!.websiteUrl ?? '';
    blogUrlCltr.text = editGeneral!.blogUrl ?? '';
    bookingUrlCltr.text = editGeneral!.bookingUrl ?? '';
    qrUrlCltr.text = editGeneral!.qrUrl ?? '';
    trackingUrlCltr.text = editGeneral!.trackingUrl ?? '';
    menuQrUrlCltr.text = editGeneral!.menuQrUrl ?? '';
    sinageUrlCltr.text = editGeneral!.signageUrl ?? '';

    //store logo & favicon
    storeLogoImageS3 = UploadImageS3Res(
      filePath: editGeneral!.storeImageUrl,
      fileName: editGeneral!.storeImageFileName,
    );
    storeFavImageS3 = UploadImageS3Res(
      filePath: editGeneral!.favIconImageUrl,
      fileName: editGeneral!.favIconImageFileName,
    );
    noProdImageS3 = UploadImageS3Res(
      filePath: editGeneral!.noProductImageUrl,
      fileName: editGeneral!.noProductImageFileName,
    );

    // general others
    channelNotesList.clear();
    centralizedImageList.clear();
    if (storeRes?.centralizedChannels != null)
      for (final a in storeRes!.centralizedChannels!) {
        final _channelNote = (editGeneral?.channelNoteAddViewModels?.any(
                    (b) => b.channelId?.toLowerCase() == a.id?.toLowerCase()) ??
                false)
            ? editGeneral?.channelNoteAddViewModels?.firstWhere(
                (b) => b.channelId?.toLowerCase() == a.id?.toLowerCase())
            : null;
        channelNotesList.add(StoreChannelModel(
          id: _channelNote?.id ?? '',
          name: a.name ?? '',
          channelId: _channelNote?.channelId ?? '',
          noteCltr: TextEditingController(text: _channelNote?.description),
        ));

        final _channelImage = (editGeneral?.channelThumbNailImageAddViewModels
                    ?.any((b) =>
                        b.channelId?.toLowerCase() == a.id?.toLowerCase()) ??
                false)
            ? editGeneral?.channelThumbNailImageAddViewModels?.firstWhere(
                (b) => b.channelId?.toLowerCase() == a.id?.toLowerCase())
            : null;

        centralizedImageList.add(CentralizedImage(
          id: _channelImage?.id ?? '',
          channelId: _channelImage?.channelId ?? '',
          name: a.name ?? '',
          fileName: _channelImage?.fileName,
          uploadImageS3Res: UploadImageS3Res(
            filePath: _channelImage?.imageUrl,
            fileName: _channelImage?.fileName,
          ),
        ));
      }

    socialMediaList.clear();

    if (storeRes?.socialMedias != null)
      for (final a in storeRes!.socialMedias!) {
        final _socialData = (editGeneral?.socialMediasAddViewModels?.any((b) =>
                    b.socialMediaId?.toLowerCase() == a.id?.toLowerCase()) ??
                false)
            ? editGeneral?.socialMediasAddViewModels?.firstWhere(
                (b) => b.socialMediaId?.toLowerCase() == a.id?.toLowerCase())
            : null;
        socialMediaList.add(SocialMediaModel(
            id: _socialData?.id ?? '',
            name: a.name ?? '',
            socialId: _socialData?.socialMediaId ?? '',
            linkCltr: TextEditingController(text: _socialData?.link)));
      }

    // fbLinkCltr.text = editGeneral!.socialMediasAddViewModels.first ?? '';
    // instaLinkCltr.text = editGeneral!.socialMediasAddViewModels ?? '';
    // twitterLinkCltr.text = editGeneral!.socialMediasAddViewModels ?? '';
    // pintrestLinkCltr.text = editGeneral!.socialMediasAddViewModels ?? '';

    freeDeliMessageCltr.text = editGeneral!.freeDeliveryMessage ?? '';
    freeDeliDiscountPerCltr.text =
        editGeneral!.freeDeliveryDiscountPercentage ?? '';
    freeDeliMaxAmtThresoldCltr.text =
        editGeneral!.freeDeliveryDiscountAmountThreshold ?? '';
  }

  //langauge update
  Future<void> onChangeLang(int? index) async {
    if (index == null) return;
    int? tempIndex = langIndex;
    langIndex = index;
    loading = true;
    notify;
    final lnCode = storeRes!.languages![index].additionalValue;

    if (lnCode is String) {
      await Translate.translate(langCode: lnCode).then((status) async {
        if (status != null &&
            status &&
            storeRes!.languages![index].id != null) {
          await Handler.changeLanguage(langId: storeRes!.languages![index].id!);
        } else {
          resetLangIndex = tempIndex;
        }
      });
    } else {
      resetLangIndex = tempIndex;
    }
    loading = false;
    notify;
  }

  set resetLangIndex(int? index) {
    langIndex = index;
    notify;
  }

  void addSecondaryEmail() {
    secondaryEmailList
        .add(SecondaryEmailModel(emailCltr: TextEditingController()));
    notify;
  }

//google places section

  FindAutocompletePredictionsResponse? _autoCompleteRes;

  FindAutocompletePredictionsResponse? get getAutoPlaces => _autoCompleteRes;

  Future<void> getPlaces({required String input}) async {
    _autoCompleteRes = await MapUtils.getPlaces(
      input: input,
      region: countryIndex == null
          ? null
          : storeRes?.countryCityStates?[countryIndex!].value,
    );
    notifyListeners();
  }

  String? _placeId;
  String? get getPlaceId => _placeId;

  set setPlaceId(String? val) {
    _placeId = val;
    _getLocation().then((value) {
      if (value == null) return;
      final lat = value.place?.latLng?.lat;
      final long = value.place?.latLng?.lng;
      latCltr.text = lat.toString();
      longCltr.text = long.toString();
      notifyListeners();
    });
  }

  //get location section
  Future<FetchPlaceResponse?> _getLocation() async {
    if (getPlaceId == null) return null;
    return await MapUtils.getLocation(_placeId);
  }

  // logo & images
  Future<UploadImageS3Res?> uploadImage({required String identifier}) async {
    final _filePath = await ImageService.filePick();
    if (_filePath != null) {
      final _uploadImageS3Res = await Handler.uploadUrls3(
        fileName: storeRes?.fileUploadFolderName ?? 'StoreImages',
        identifier: identifier,
      );
      _uploadImageS3Res?.filePath = _filePath;
      return _uploadImageS3Res;
    }

    return null;
  }

  bool updateLoadGeneral = false;

  Future<void> updateGeneral() async {
    final _storeData = StoreGeneralModel(
        id: editGeneral?.id,
        isActive: editGeneral?.isActive,
        name: storeNameCltr.text,
        abnNumber: abnNumCltr.text,
        email: emailCltr.text,
        phoneNumber: phoneCltr.text,
        languageId:
            langIndex != null ? storeRes!.languages![langIndex!].id : "",
        franchiseId:
            franchIndex != null ? storeRes!.franchises![franchIndex!].id : null,
        description: storeMainDesc,
        alertDescription: storeAlertDesc,
        footerDescription: storefooterDesc,
        googlePinnedLocation: pinLocationCltr.text,
        address: addressCltr.text,
        latitude: latCltr.text,
        longitude: longCltr.text,
        timeZoneId: timeZoneIndex != null
            ? storeRes!.timeZones![timeZoneIndex!].id
            : "",
        dateFormatId: dateForIndex != null
            ? storeRes!.dateFormats![dateForIndex!].id
            : "",
        taxExclusiveInclusiveTypeId: taxInExIndex != null
            ? storeRes!.taxExclusiveInclusiveTypes![taxInExIndex!].id
            : "",
        taxPercentage: taxPercentCltr.text,
        url: onlineUrlCltr.text,
        websiteUrl: webUrlCltr.text,
        blogUrl: blogUrlCltr.text,
        bookingUrl: bookingUrlCltr.text,
        qrUrl: qrUrlCltr.text,
        trackingUrl: trackingUrlCltr.text,
        menuQrUrl: menuQrUrlCltr.text,
        signageUrl: sinageUrlCltr.text,
        freeDeliveryMessage: freeDeliMessageCltr.text,
        freeDeliveryDiscountPercentage: freeDeliDiscountPerCltr.text,
        freeDeliveryDiscountAmountThreshold: freeDeliMaxAmtThresoldCltr.text,
        isFreeDelivery: editGeneral?.isFreeDelivery
// ,storeImageUrl :
// ,storeImageFileName :
// ,favIconImageFileName :
// ,noProductImageFileName :
// ,favIconImageUrl :
// ,noProductImageUrl :
// ,channelThumbNailImageAddViewModels :
// ,deliveryDistancePriceDeletedIds :
// ,onlineThemeColorDeletedIds :
// ,publicHolidaysDeletedIds :
// ,picKUpHoursDeletedIds :
// ,deliveryHoursDeletedIds :
// ,secondaryEmailDeletedIds :
        );

    if (storeRes?.businessTypeCategoriesWithBussinessTypes != null &&
        businessTypeCatIndex != null) {
      _storeData.businessTypeCategoryId = storeRes!
          .businessTypeCategoriesWithBussinessTypes![businessTypeCatIndex!].id;

      if (storeRes
                  ?.businessTypeCategoriesWithBussinessTypes?[
                      businessTypeCatIndex!]
                  .businessTypes !=
              null &&
          businessTypeIndex != null) {
        _storeData.businessTypeId = storeRes!
            .businessTypeCategoriesWithBussinessTypes![businessTypeCatIndex!]
            .businessTypes![businessTypeIndex!]
            .id;
      }
    }

    _storeData.secondaryEmailAddViewModels = [];

    for (final a in secondaryEmailList) {
      if (a.emailCltr.text.isNotEmpty) {
        _storeData.secondaryEmailAddViewModels!.add(SecondaryEmailAddViewModel(
          id: a.id,
          email: a.emailCltr.text,
          isActive: a.isActive,
        ));
      }
    }
    _storeData.secondaryEmailDeletedIds = deletedSecondaryEmailIds;

    if (storeRes!.countryCityStates != null &&
        storeRes!.countryCityStates!.isNotEmpty) {
      if (countryIndex != null) {
        _storeData.countryId = storeRes!.countryCityStates![countryIndex!].id;

        if (stateIndex != null) {
          _storeData.stateId = storeRes!
              .countryCityStates![countryIndex!].states![stateIndex!].id;

          if (cityIndex != null) {
            _storeData.cityId = storeRes!.countryCityStates![countryIndex!]
                .states![stateIndex!].cities![cityIndex!].id;

            if (suburbIndex != null) {
              _storeData.suburbId = storeRes!
                  .countryCityStates![countryIndex!]
                  .states![stateIndex!]
                  .cities![cityIndex!]
                  .suburbs![suburbIndex!]
                  .id;
            }
          }
        }
      }

      // if (phoneCodeIndex != null) {
      //   _storeData.countryPhoneNumberPrefixId =
      //       storeRes!.countryCityStates![phoneCodeIndex!].id;
      // }
    }

    _storeData.channelNoteAddViewModels = [];

    for (final a in channelNotesList) {
      if (a.channelId.isNotEmpty) {
        _storeData.channelNoteAddViewModels!.add(ChannelNoteAddViewModel(
          id: a.id,
          channelId: a.channelId,
          description: a.noteCltr.text,
        ));
      }
    }

    _storeData.socialMediasAddViewModels = [];

    for (final a in socialMediaList) {
      if (a.socialId.isNotEmpty) {
        _storeData.socialMediasAddViewModels!.add(SocialMediasAddViewModel(
          id: a.id,
          socialMediaId: a.socialId,
          link: a.linkCltr.text,
          isActive: a.isActive,
        ));
      }
    }

    _storeData.scheduleReportJobAddViewModels =
        editGeneral?.scheduleReportJobAddViewModels;

    _storeData.storeTypeId = editGeneral?.storeTypeId;
    _storeData.templateCategoryId = editGeneral?.templateCategoryId;
    _storeData.channel = editGeneral?.channel;
    _storeData.currencySymbol = editGeneral?.currencySymbol;
    _storeData.isImageDeleted = editGeneral?.isImageDeleted;

    // logo & images
    if (storeLogoImageS3?.filePath?.isNotEmpty ?? false) {
      if (!(storeLogoImageS3?.filePath?.contains('https://') ?? false)) {
        final _compressedFile = await ImageService.compressFileFors3(
            storeLogoImageS3?.filePath ?? '');

        final _imageUploadStatus = await Handler.uploadImageOnUrl(
          contentType: storeLogoImageS3?.contentType,
          url: storeLogoImageS3?.uploadUrl,
          filepath: _compressedFile,
        );

        if (_imageUploadStatus ?? false) {
          _storeData.storeImageFileName = storeLogoImageS3?.fileName ?? '';
        }
      } else {
        _storeData.storeImageFileName = editGeneral?.storeImageFileName ?? '';
      }
    } else {
      _storeData.storeImageFileName = '';
    }

    if (storeFavImageS3?.filePath?.isNotEmpty ?? false) {
      if (!(storeFavImageS3?.filePath?.contains('https://') ?? false)) {
        final _compressedFile = await ImageService.compressFileFors3(
            storeFavImageS3?.filePath ?? '');

        final _imageUploadStatus = await Handler.uploadImageOnUrl(
          contentType: storeFavImageS3?.contentType,
          url: storeFavImageS3?.uploadUrl,
          filepath: _compressedFile,
        );

        if (_imageUploadStatus ?? false) {
          _storeData.favIconImageFileName = storeFavImageS3?.fileName ?? '';
        }
      } else {
        _storeData.favIconImageFileName =
            editGeneral?.favIconImageFileName ?? '';
      }
    } else {
      _storeData.favIconImageFileName = '';
    }

    if (noProdImageS3?.filePath?.isNotEmpty ?? false) {
      if (!(noProdImageS3?.filePath?.contains('https://') ?? false)) {
        final _compressedFile =
            await ImageService.compressFileFors3(noProdImageS3?.filePath ?? '');

        final _imageUploadStatus = await Handler.uploadImageOnUrl(
          contentType: noProdImageS3?.contentType,
          url: noProdImageS3?.uploadUrl,
          filepath: _compressedFile,
        );

        if (_imageUploadStatus ?? false) {
          _storeData.noProductImageFileName = noProdImageS3?.fileName ?? '';
        }
      } else {
        _storeData.noProductImageFileName =
            editGeneral?.noProductImageFileName ?? '';
      }
    } else {
      _storeData.noProductImageFileName = '';
    }
    _storeData.channelThumbNailImageAddViewModels = [];
    for (final a in centralizedImageList) {
      String _cenFileName = "";
      if (a.uploadImageS3Res.filePath?.isNotEmpty ?? false) {
        if (!(a.uploadImageS3Res.filePath?.contains('https://') ?? false)) {
          final _compressedFile = await ImageService.compressFileFors3(
              a.uploadImageS3Res.filePath ?? '');

          final _imageUploadStatus = await Handler.uploadImageOnUrl(
            contentType: a.uploadImageS3Res.contentType,
            url: a.uploadImageS3Res.uploadUrl,
            filepath: _compressedFile,
          );

          if (_imageUploadStatus ?? false) {
            _cenFileName = a.uploadImageS3Res.fileName ?? '';
          }
        } else {
          _cenFileName = a.fileName ?? '';
        }
      } else {
        _cenFileName = '';
      }

      _storeData.channelThumbNailImageAddViewModels!
          .add(ChannelThumbNailImageAddViewModel(
        id: a.id,
        channelId: a.channelId,
        fileName: _cenFileName,
      ));
    }
    //TODO
    // _storeData.channelThumbNailImageDeletedIds = centralizedDeletedIds;

    updateLoadGeneral = true;
    notify;

    await Handler.upStoreGeneral(storeData: _storeData);

    updateLoadGeneral = false;
    notify;
  }

  ////////////////---------------Opening Hours------------------//////////////////

  bool pickSelectAll = false;
  bool deliSelectAll = false;

  final pickHourList = <OpenWeekModel>[];
  final deliveryHourList = <OpenWeekModel>[];

  final deletedPickIds = <String>[];
  final deletedDeliIds = <String>[];

  StoreOpenHourModel? openHourData;

  bool updateLoadOpenHour = false;

  Future<void> getOpenHourData() async {
    openHourData = await Handler.getStoreOpenHours();
    _setOpenHourData();
    loading = false;
    notify;
  }

  _setOpenHourData() {
    pickHourList.clear();
    deliveryHourList.clear();

    deletedPickIds.clear();
    deletedDeliIds.clear();

    if (storeRes?.weekDays != null)
      for (final weekDay in storeRes!.weekDays!) {
        pickHourList.add(OpenWeekModel(
          weekId: weekDay.id ?? '',
          weekName: weekDay.name ?? '',
          openHourList: [],
        ));
        deliveryHourList.add(OpenWeekModel(
          weekId: weekDay.id ?? '',
          weekName: weekDay.name ?? '',
          openHourList: [],
        ));
      }

    pickHourList.forEach((a) {
      final hourSet = openHourData?.pickUpHoursAddViewModels
              ?.where(
                  (b) => b.weekDayId?.toLowerCase() == a.weekId.toLowerCase())
              .toList() ??
          [];

      if (hourSet.isNotEmpty) {
        hourSet.forEach((c) {
          a.openHourList.add(OpenHoursModel(
            id: c.id ?? '',
            closeTime: c.closeHour ?? '',
            openTime: c.openHour ?? '',
            isOpen: c.isOpened ?? false,
          ));
        });
      } else {
        a.openHourList.add(OpenHoursModel(
          id: "",
          closeTime: '',
          openTime: '',
          isOpen: false,
        ));
      }
    });

    deliveryHourList.forEach((a) {
      final hourSet = openHourData?.deliveryHoursAddViewModels
              ?.where(
                  (b) => b.weekDayId?.toLowerCase() == a.weekId.toLowerCase())
              .toList() ??
          [];

      if (hourSet.isNotEmpty) {
        hourSet.forEach((c) {
          a.openHourList.add(OpenHoursModel(
            id: c.id ?? '',
            closeTime: c.closeHour ?? '',
            openTime: c.openHour ?? '',
            isOpen: c.isOpened ?? false,
          ));
        });
      } else {
        a.openHourList.add(OpenHoursModel(
          id: "",
          closeTime: '',
          openTime: '',
          isOpen: false,
        ));
      }
    });
  }

  Future<void> updateOpenHour() async {
    if (storeRes == null) return;

    final _openHourReq = StoreOpenHourModel(id: openHourData?.id ?? '');
    _openHourReq.pickUpHoursAddViewModels = <HoursAddViewModel>[];

    for (final d in pickHourList)
      for (final e in d.openHourList) {
        if (e.openTime.isNotEmpty && e.closeTime.isNotEmpty)
          _openHourReq.pickUpHoursAddViewModels!.add(HoursAddViewModel(
            id: e.id,
            weekDayId: d.weekId,
            weekDayName: d.weekName,
            openHour: e.openTime,
            closeHour: e.closeTime,
            isOpened: e.isOpen,
          ));
      }

    _openHourReq.picKUpHoursDeletedIds = deletedPickIds;

    _openHourReq.deliveryHoursAddViewModels = <HoursAddViewModel>[];

    for (final d in deliveryHourList)
      for (final e in d.openHourList) {
        if (e.openTime.isNotEmpty && e.closeTime.isNotEmpty)
          _openHourReq.deliveryHoursAddViewModels!.add(HoursAddViewModel(
            id: e.id,
            weekDayId: d.weekId,
            weekDayName: d.weekName,
            openHour: e.openTime,
            closeHour: e.closeTime,
            isOpened: e.isOpen,
          ));
      }

    _openHourReq.deliveryHoursDeletedIds = deletedDeliIds;

    updateLoadOpenHour = true;
    notify;

    await Handler.upStoreOpenHour(storeData: _openHourReq);

    updateLoadOpenHour = false;
    notify;
  }

  ////////////////---------------Delivery Distance------------------//////////////////

  int? distanceTypeIndex;
  bool enableUberDelivery = false;

  final distanceAmountList = <ToFromData>[];
  final _deletedDeliveryDisIds = <String>[];

  bool updateLoadDeliDis = false;

  StoreDeliDistanceModel? deliDistanceData;

  void addDistAmount() {
    distanceAmountList.add(ToFromData(
        fromCltr: TextEditingController(),
        toCltr: TextEditingController(),
        dataCltr: TextEditingController()));
    notify;
  }

  void removeDistAmount({required int index}) {
    if (distanceAmountList[index].id.isNotEmpty) {
      _deletedDeliveryDisIds.add(distanceAmountList[index].id);
    }
    distanceAmountList.removeAt(index);
    notify;
  }

  Future<void> getDeliDisData() async {
    deliDistanceData = await Handler.getStoreDeliDistance();
    _setDeliDisData();
    loading = false;
    notify;
  }

  _setDeliDisData() {
    enableUberDelivery = deliDistanceData?.enableUberDelivery ?? false;

    distanceTypeIndex = null;
    distanceAmountList.clear();

    if (deliDistanceData!.deliveryDistancePriceAddViewModels?.isNotEmpty ??
        false) {
      if (storeRes?.distanceKmsMiles?.any((e) =>
              e.id?.toLowerCase() ==
              deliDistanceData!
                  .deliveryDistancePriceAddViewModels!.first.mileKmId
                  ?.toLowerCase()) ??
          false) {
        distanceTypeIndex = storeRes!.distanceKmsMiles!.indexWhere((e) =>
            e.id?.toLowerCase() ==
            deliDistanceData!.deliveryDistancePriceAddViewModels!.first.mileKmId
                ?.toLowerCase());
      }

      final dAList = deliDistanceData!.deliveryDistancePriceAddViewModels!;
      distanceAmountList.clear();
      for (var e in dAList)
        distanceAmountList.add(
          ToFromData(
              id: e.id ?? '',
              fromCltr: TextEditingController(text: e.distanceFrom ?? ''),
              toCltr: TextEditingController(text: e.distanceTo ?? ''),
              dataCltr: TextEditingController(text: e.price ?? '')),
        );
    }
  }

  Future<void> updateDeliDis() async {
    if (storeRes == null) return;

    final _deliDisReq = StoreDeliDistanceModel(
      id: deliDistanceData?.id ?? '',
      enableUberDelivery: enableUberDelivery,
    );

    if (distanceAmountList.isEmpty) {
      _deliDisReq.deliveryDistancePriceAddViewModels = null;
    } else {
      _deliDisReq.deliveryDistancePriceAddViewModels ??=
          <DeliveryDistancePriceAddViewModel>[];
      for (var e in distanceAmountList) {
        _deliDisReq.deliveryDistancePriceAddViewModels!
            .add(DeliveryDistancePriceAddViewModel(
          id: e.id,
          mileKmId:
              storeRes!.distanceKmsMiles != null && distanceTypeIndex != null
                  ? storeRes!.distanceKmsMiles![distanceTypeIndex!].id
                  : null,
          distanceFrom: e.fromCltr.text,
          distanceTo: e.toCltr.text,
          price: e.dataCltr.text,
        ));
      }
    }
    _deliDisReq.deliveryDistancePriceDeletedIds = _deletedDeliveryDisIds;

    updateLoadDeliDis = true;
    notify;
    await Handler.upStoreDeliDis(storeData: _deliDisReq);

    updateLoadDeliDis = false;
    notify;
  }

  ////////////////---------------Extra Charge------------------//////////////////

  bool updateLoadExtraCharge = false;

  // holiday Settings
  final holidayList = <HolidayModel>[];
  final weekendList = <WeekendModel>[];

  final _holidayDeletedIds = <String>[];

  StoreExtraChargeModel? extChargeData;

  Future<void> getExtChargeData() async {
    extChargeData = await Handler.getStoreExtraCharges();
    _setExtChargeData();
    loading = false;
    notify;
  }

  _setExtChargeData() {
    extChargeData?.posCreditCardSurchargeAddViewModels ??= [];
    final _channels = extChargeData?.posCreditCardSurchargeAddViewModels;
    if (storeRes?.posChannels?.isNotEmpty ?? false) {
      for (final e in storeRes!.posChannels!) {
        if ((_channels?.any(
                (f) => f.channelId?.toLowerCase() == e.id?.toLowerCase()) ??
            false)) {
          _channels
              ?.firstWhere(
                  (f) => f.channelId?.toLowerCase() == e.id?.toLowerCase())
              .channelName = e.name;
        } else {
          _channels?.add(PosCreditCardSurchargeAddViewModel(
            id: "",
            channelId: e.id,
            channelName: e.name,
            creditCardSurchargePercentage: TextEditingController(),
          ));
        }
      }
    }

    if (extChargeData?.publicHolidayViewModels?.isNotEmpty ?? false) {
      final _calList = extChargeData!.publicHolidayViewModels!;
      holidayList.clear();
      for (var e in _calList)
        holidayList.add(
          HolidayModel(
            id: e.id ?? '',
            titleCltr: TextEditingController(text: e.name ?? ''),
            date: e.date ?? '',
            valueCltr:
                TextEditingController(text: e.holidaySurchargePercentage ?? ''),
            isEnable: e.autoEnableHolidaySurcharge ?? false,
          ),
        );
    }

    if (extChargeData?.weekendSurchageViewModels?.isNotEmpty ?? false) {
      final _calList = extChargeData!.weekendSurchageViewModels!;
      weekendList.clear();
      for (var e in _calList)
        weekendList.add(
          WeekendModel(
            id: e.id ?? '',
            weekDayId: e.weekDayId ?? '',
            titleCltr: TextEditingController(text: e.name ?? ''),
            valueCltr:
                TextEditingController(text: e.weekendSurchargePercentage ?? ''),
            isEnable: e.autoEnableWeekendSurcharge ?? false,
          ),
        );
    }
  }

  void addHoliday() {
    holidayList.add(
      HolidayModel(
        titleCltr: TextEditingController(),
        valueCltr: TextEditingController(),
      ),
    );
    notify;
  }

  void removeHoliday({required int index}) {
    if (holidayList[index].id.isNotEmpty) {
      _holidayDeletedIds.add(holidayList[index].id);
    }
    holidayList.removeAt(index);
    notify;
  }

  Future<void> updateExtCharge() async {
    if (storeRes == null) return;

    final _extChargeReq = StoreExtraChargeModel(
      id: extChargeData?.id ?? '',
      posCreditCardSurchargeAddViewModels:
          extChargeData?.posCreditCardSurchargeAddViewModels,
      serviceChargeAddViewModel: extChargeData?.serviceChargeAddViewModel,
      publicHolidayViewModels: [],
      weekendSurchageViewModels: [],
    );
    for (var e in holidayList) {
      if (e.date == "") {
        if (e.id.isNotEmpty) {
          _holidayDeletedIds.add(e.id);
        }
      } else {
        _extChargeReq.publicHolidayViewModels!.add(PublicHolidayViewModel(
          id: e.id,
          name: e.titleCltr.text,
          date: e.date,
          holidaySurchargePercentage: e.valueCltr.text,
          autoEnableHolidaySurcharge: e.isEnable,
        ));
      }
    }

    for (var e in weekendList) {
      _extChargeReq.weekendSurchageViewModels!.add(WeekendSurchageViewModel(
        id: e.id,
        name: e.titleCltr.text,
        weekDayId: e.weekDayId,
        weekendSurchargePercentage: e.valueCltr.text,
        autoEnableWeekendSurcharge: e.isEnable,
      ));
    }

    _extChargeReq.publicHolidaysDeletedIds = _holidayDeletedIds;

    updateLoadExtraCharge = true;
    notify;
    await Handler.upStoreSurcharge(storeData: _extChargeReq);

    updateLoadExtraCharge = false;
    notify;
  }

  ////////////////---------------Color Settings------------------//////////////////

  bool updateLoadColorSet = false;

  bool resetLoadColorSet = false;

  StoreColorModel? storeColorData;

  final _colorDeletedIds = <String>[];

  Future<void> getStoreColorData() async {
    storeColorData = await Handler.getStoreColorSettings();
    // _setStoreColorData();
    loading = false;
    notify;
  }

  // _setStoreColorData() {}

  void addColor() {
    storeColorData?.themeColorAddViewModels ??= [];

    storeColorData?.themeColorAddViewModels?.add(ThemeColorAddViewModel(
        id: "",
        name: TextEditingController(),
        displayName: TextEditingController(),
        value: TextEditingController()));

    notify;
  }

  void removeColor({required int index}) {
    if (storeColorData?.themeColorAddViewModels == null) return;

    if (storeColorData!.themeColorAddViewModels!.length < index) return;

    if (storeColorData?.themeColorAddViewModels?[index].id?.isNotEmpty ??
        false) {
      _colorDeletedIds
          .add(storeColorData?.themeColorAddViewModels?[index].id ?? '');
    }
    storeColorData?.themeColorAddViewModels?.removeAt(index);
    notify;
  }

  Future<void> updateStoreColor() async {
    if (storeRes == null) return;

    final _storeColorReq = StoreColorModel(
      id: storeColorData?.id ?? '',
      themeColorAddViewModels: storeColorData?.themeColorAddViewModels,
      onlineThemeColorDeletedIds: _colorDeletedIds,
    );

    updateLoadColorSet = true;
    notify;
    await Handler.upStoreColors(storeData: _storeColorReq);

    updateLoadColorSet = false;
    notify;
  }

  Future<void> resetStoreColor() async {
    if (storeRes == null || storeColorData?.id == null) return;

    resetLoadColorSet = true;
    notify;
    final _status =
        await Handler.resetStoreColors(id: storeColorData?.id ?? '');

    if (_status ?? false) {
      await getStoreColorData();
    }

    resetLoadColorSet = false;
    notify;
  }

  ////////////////---------------Other Settings------------------//////////////////

//general
  bool enableMaintain = false;
  bool enableGuestCheckout = false;
  bool enableCopyRightFoot = false;
  int? prodDetailScreenIndex;
  String? copyRightFootDesc;

  //hospitality
  bool showPaymentOnPickUp = false;
  bool showPaymentonDeli = false;
  bool autoSendToKitOnline = false;
  bool enablePayWithPairing = false;
  bool showReserveTable = false;
  bool enableGoogleLogin = false;
  bool enablePhoneVerification = false;
  bool enableDocketGrpSplitPrint = false;
  int? pickDeliIntervalIndex;

  //qr order
  bool enablePaymentOnQrOrder = false;

  //kiosk
  bool kioskEnablePayAtCounter = false;

  //retail online
  bool enableOrderGiftReFo = false;
  bool enableFooter = false;

  bool updateLoadOtherSetting = false;

  StoreOtherSettingModel? otherSettingData;

  Future<void> getOtherSettingData() async {
    otherSettingData = await Handler.getStoreOtherSettings();
    _setOtherSettingData();
    loading = false;
    notify;
  }

  _setOtherSettingData() {
    enableMaintain = otherSettingData?.enableUnderMaintenance ?? false;
    enableGuestCheckout = otherSettingData?.enableGuestCheckout ?? false;
    enableCopyRightFoot = otherSettingData?.enableCopyRightFooter ?? false;

    if (storeRes?.posProductDetailScreenTypes?.any((a) =>
            a.value?.toLowerCase() ==
            otherSettingData?.productDetailScreen?.toLowerCase()) ??
        false) {
      prodDetailScreenIndex = storeRes?.posProductDetailScreenTypes?.indexWhere(
          (a) =>
              a.value?.toLowerCase() ==
              otherSettingData?.productDetailScreen?.toLowerCase());
    }
    copyRightFootDesc = otherSettingData?.copyRightFooterDescription ?? '';
//
    showPaymentOnPickUp = otherSettingData?.enablePaymentOnPickUp ?? false;
    showPaymentonDeli = otherSettingData?.enablePaymentOnDelivery ?? false;
    autoSendToKitOnline =
        otherSettingData?.enableAutoSendToKitchenOnlineOrder ?? false;
    enablePayWithPairing = otherSettingData?.enablePayWithPairing ?? false;
    showReserveTable = otherSettingData?.enableReserveTable ?? false;
    enableGoogleLogin = otherSettingData?.enableGoogleLogin ?? false;
    enablePhoneVerification =
        otherSettingData?.enablePhoneNumberVerification ?? false;
    enableDocketGrpSplitPrint =
        otherSettingData?.enableDocketGroupSplitPrint ?? false;

    if (storeRes?.pickUpDeliveryTimeIntervals?.any((a) =>
            a.value.inDouble == otherSettingData?.pickUpDeliveryTimeInterval) ??
        false) {
      pickDeliIntervalIndex = storeRes?.pickUpDeliveryTimeIntervals?.indexWhere(
          (a) =>
              a.value.inDouble == otherSettingData?.pickUpDeliveryTimeInterval);
    }

//
    enablePaymentOnQrOrder = otherSettingData?.enablePaymentOnQrOrder ?? false;

//
    kioskEnablePayAtCounter =
        otherSettingData?.kioskEnablePayAtCounter ?? false;
//
    enableOrderGiftReFo =
        otherSettingData?.enableOrderGiftReceiverForm ?? false;
    enableFooter = otherSettingData?.enableFooter ?? false;
  }

  Future<bool?> updateOtherSetting() async {
    if (storeRes == null) return null;

    final _otherSettingReq = StoreOtherSettingModel(
      id: otherSettingData?.id ?? '',
      enableUnderMaintenance: enableMaintain,
      enableGuestCheckout: enableGuestCheckout,
      enableCopyRightFooter: enableCopyRightFoot,
      copyRightFooterDescription: copyRightFootDesc,
      enablePaymentOnPickUp: showPaymentOnPickUp,
      enablePaymentOnDelivery: showPaymentonDeli,
      enableAutoSendToKitchenOnlineOrder: autoSendToKitOnline,
      enablePayWithPairing: enablePayWithPairing,
      enableReserveTable: showReserveTable,
      enableGoogleLogin: enableGoogleLogin,
      enablePhoneNumberVerification: enablePhoneVerification,
      enableDocketGroupSplitPrint: enableDocketGrpSplitPrint,
      enablePaymentOnQrOrder: enablePaymentOnQrOrder,
      kioskEnablePayAtCounter: kioskEnablePayAtCounter,
      enableOrderGiftReceiverForm: enableOrderGiftReFo,
      enableFooter: enableFooter,
    );

    if (prodDetailScreenIndex != null) {
      _otherSettingReq.productDetailScreen =
          storeRes?.posProductDetailScreenTypes?[prodDetailScreenIndex!].value;
    }

    _otherSettingReq.pickUpDeliveryTimeInterval = pickDeliIntervalIndex != null
        ? (storeRes?.pickUpDeliveryTimeIntervals?[pickDeliIntervalIndex!].value
            .inDouble
            .floor())
        : 0;

    updateLoadOtherSetting = true;
    notify;
    final _status =
        await Handler.upStoreOtherSettings(storeData: _otherSettingReq);

    updateLoadOtherSetting = false;
    notify;

    return _status;
  }

  ////////////////---------------Reset------------------//////////////////

  void reset() {
    curSym = null;
    dateFormat = null;
    storeRes = null;
    loading = true;
    _generalReset();
    _openHourReset();
    _deliveryDisReset();
    _chargeReset();
    _colorReset();
    _othersReset();
  }

  void _generalReset() {
    //
    storeNameCltr.clear();
    abnNumCltr.clear();
    emailCltr.clear();
    phoneCodeIndex = null;
    phoneCltr.clear();
    langIndex = null;
    franchIndex = null;
    businessTypeCatIndex = null;
    businessTypeIndex = null;
    secondaryEmailList.clear();
    deletedSecondaryEmailIds.clear();
    storeMainDesc = null;
    storeAlertDesc = null;
    storefooterDesc = null;
    pinLocationCltr.clear();
    //
    countryIndex = null;
    stateIndex = null;
    cityIndex = null;
    suburbIndex = null;
    addressCltr.clear();
    latCltr.clear();
    longCltr.clear();
    timeZoneIndex = null;
    dateForIndex = null;
//
    taxInExIndex = null;
    taxPercentCltr.clear();
//
    onlineUrlCltr.clear();
    webUrlCltr.clear();
    blogUrlCltr.clear();
    bookingUrlCltr.clear();
    qrUrlCltr.clear();
    trackingUrlCltr.clear();
    menuQrUrlCltr.clear();
    sinageUrlCltr.clear();
//
    storeLogoImageS3 = null;
    storeFavImageS3 = null;
    noProdImageS3 = null;
    centralizedImageList.clear();
    centralizedDeletedIds.clear();
//
    channelNotesList.clear();
    socialMediaList.clear();
    freeDeliMessageCltr.clear();
    freeDeliDiscountPerCltr.clear();
    freeDeliMaxAmtThresoldCltr.clear();
    _autoCompleteRes = null;
    _placeId = null;
    updateLoadGeneral = false;
  }

  void _openHourReset() {
    pickSelectAll = false;
    deliSelectAll = false;
    pickHourList.clear();
    deliveryHourList.clear();
    deletedPickIds.clear();
    deletedDeliIds.clear();
    openHourData = null;
    updateLoadOpenHour = false;
  }

  void _deliveryDisReset() {
    distanceTypeIndex = null;
    enableUberDelivery = false;
    distanceAmountList.clear();
    _deletedDeliveryDisIds.clear();
    updateLoadDeliDis = false;
    deliDistanceData = null;
  }

  void _chargeReset() {
    updateLoadExtraCharge = false;
    holidayList.clear();
    weekendList.clear();
    _holidayDeletedIds.clear();
    extChargeData = null;
  }

  void _colorReset() {
    updateLoadColorSet = false;
    resetLoadColorSet = false;
    storeColorData = null;
    _colorDeletedIds.clear();
  }

  void _othersReset() {
    enableMaintain = false;
    enableGuestCheckout = false;
    enableCopyRightFoot = false;
    prodDetailScreenIndex = null;
    copyRightFootDesc = null;
    showPaymentOnPickUp = false;
    showPaymentonDeli = false;
    autoSendToKitOnline = false;
    enablePayWithPairing = false;
    showReserveTable = false;
    enableGoogleLogin = false;
    enablePhoneVerification = false;
    enableDocketGrpSplitPrint = false;
    pickDeliIntervalIndex = null;
    enablePaymentOnQrOrder = false;
    kioskEnablePayAtCounter = false;
    enableOrderGiftReFo = false;
    enableFooter = false;
    updateLoadOtherSetting = false;
    otherSettingData = null;
  }
}

class CentralizedImage {
  final String id;
  final String channelId;
  final String name;
  final String? fileName;
  UploadImageS3Res uploadImageS3Res;

  CentralizedImage({
    this.id = "",
    this.channelId = "",
    this.name = "",
    this.fileName,
    required this.uploadImageS3Res,
  });
}
