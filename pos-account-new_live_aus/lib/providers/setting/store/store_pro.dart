import 'package:flutter/material.dart';
import 'package:flutter_google_places_sdk/flutter_google_places_sdk.dart';
import 'package:pos_account/config/utils/map_utils.dart';
import 'package:pos_account/ln.dart';
import 'package:pos_account/model/home/setting/store/store_data.dart';
import 'package:pos_account/model/home/setting/store/store_res.dart';
import 'package:pos_account/providers/cus_val_pro.dart';
import 'package:pos_account/providers/menu/place_order_pro.dart';
// import 'package:pos_account/providers/menu/pos_retail_pro.dart';
import 'package:pos_account/repository/handler.dart';
import 'package:pos_account/repository/if_exception.dart';
import 'package:pos_account/services/database/shared_pref.dart';
import 'package:pos_account/services/image/image_service.dart';
import 'package:pos_account/services/language/translate.dart';
import 'package:provider/provider.dart';

import '../../../model/ui_model/store_ui_model.dart';

TabController? StoreTabCltr;

class StorePro extends ChangeNotifier {
  Function()? tabCltrFunction;

  String? curSym;

  StoreRes? _storeRes;
  StoreData? _storeEditData;

  StoreRes? get storeRes => _storeRes;

  StoreData? get editData => _storeEditData;

  bool loading = true;
  bool updateLoad = false;

  final formKey = GlobalKey<FormState>();

  final storeNameCltr = TextEditingController();
  final abnNumCltr = TextEditingController();
  final emailCltr = TextEditingController();
  final phoneCltr = TextEditingController();

  final urlCltr = TextEditingController();
  final holisurCltr = TextEditingController(text: "0");
  bool isEnableHoliDay = false;
  final creCardsurCltr = TextEditingController(text: "0");
  bool isEnableCredit = false;

  final weekendSurCltr = TextEditingController(text: "0");
  bool isEnableWeekend = false;

  int? franchIndex;
  int? templateIndex;
  int? templateCategoryIndex;
  int? businessTypeCatIndex;
  int? businessTypeIndex;
  int? storeTypeIndex;
  int? countryIndex;
  int? stateIndex;
  int? cityIndex;
  int? suburbIndex;
  int? phoneCodeIndex;

  final addressCltr = TextEditingController();
  final latCltr = TextEditingController();
  final longCltr = TextEditingController();

  int? timeZoneIndex;
  int? taxInExIndex;
  int? langIndex;
  int? dateForIndex;

  final descriptionCltr = TextEditingController();
  final webUrlCltr = TextEditingController();
  final qrUrlCltr = TextEditingController();

  // bool enableLoyalty = true;

  final maxClaimAmountCltr = TextEditingController();
  final maxClaimPointsCltr = TextEditingController();
  bool enableUnitPrice = false;

  final cusSpendAmountCltr = TextEditingController();
  final cusEarnPointsCltr = TextEditingController();
  bool cusSpendEarnEnable = false;

  // final claimAmountList = <ToFromData>[
  //   ToFromData(
  //       fromCltr: TextEditingController(),
  //       toCltr: TextEditingController(),
  //       dataCltr: TextEditingController()),
  // ];

  int? distanceTypeIndex;

  final distanceAmountList = <ToFromData>[
    ToFromData(
        fromCltr: TextEditingController(),
        toCltr: TextEditingController(),
        dataCltr: TextEditingController()),
  ];

  final pickHourList = <OpenWeekModel>[];
  final deliveryHourList = <OpenWeekModel>[];

  final deletedPickIds = <String>[];
  final deletedDeliIds = <String>[];

  // final promoOffDiscountPerCltr = TextEditingController();
  // final promoOffAmtCltr = TextEditingController();
  // String? promoFilePath;

// General
  final updateOrChCltr = TextEditingController();
  bool enableMaintain = false;
  // bool isRetailScreen = false;
  bool enableGuestCheckout = false;
  bool enableCopyRightFoot = false;
  // bool orderPrintAutomatically = false;
  // bool printBillAutomatically = false;
  String? copyRightFootDesc;
  // bool isLiveModeEnable = false;

  // Hospitality Online
  final tableQrOrChCltr = TextEditingController();
  bool showReserveTable = false;
  bool showPaymentOnPickUp = false;
  bool showPaymentOnDine = false;
  bool showPaymentonDeli = false;
  bool autoSendToKitOnline = false;
  bool enablePayWithPairing = false;
  bool enableAuSeToKitDisOnOr = false;
  bool enablePaymentOnQrOrder = false;
  bool kioskEnablePayAtCounter = false;

  // Retail Online
  bool enableOrderGiftReFo = false;
  bool enableFooter = false;
  bool enableUberDelivery = false;

  // holiday Settings
  final holidayList = <HolidayModel>[
    HolidayModel(
      titleCltr: TextEditingController(),
      valueCltr: TextEditingController(),
    ),
  ];

  final weekendList = <WeekendModel>[];

  final _holidayDeletedIds = <String>[];

  // final pickUpHours = <HoursSettingsAddViewModel>[];
  // final deliveryHours = <HoursSettingsAddViewModel>[];

  Future<void> getCurSym() async {
    curSym = await SharedPrefs.curSym;
    notify();
  }

  Future<void> getAllData() async {
    _storeRes = await Handler.getAllStoreList();
    _storeEditData = await Handler.editStore();
    _setData();
    loading = false;
    notifyListeners();
  }

  void _setData() async {
    if (editData == null) return;

    storeNameCltr.text = editData!.name ?? '';
    abnNumCltr.text = editData!.abnNumber ?? '';
    emailCltr.text = editData!.email ?? '';
    phoneCltr.text = editData!.phoneNumber ?? '';
    urlCltr.text = editData!.url ?? '';
    webUrlCltr.text = editData!.websiteUrl ?? '';
    qrUrlCltr.text = editData!.qrUrl ?? '';
    //
    holisurCltr.text = editData!.holidaySurgePercentage ?? '';
    isEnableHoliDay = editData!.autoEnableHoliaySurchargePercentage ?? false;
    //
    creCardsurCltr.text = editData!.creditCardSurgePercentage ?? '';
    isEnableCredit = editData!.autoEnableCreditCardSurgePercentage ?? false;
    //
    weekendSurCltr.text = editData!.weekendSurgePercentage ?? '';
    isEnableWeekend = editData!.autoEnableWeekendSurgePercentage ?? false;
    //
    descriptionCltr.text = editData!.description ?? '';
    // isRetailScreen = editData!.isRetailScreen ?? false;
    // promoOffDiscountPerCltr.text =
    //     editData!.promotionalOfferDiscountPercentage ?? '';
    // promoOffAmtCltr.text =
    //     editData!.promotionalOfferDiscountAmountThreshold ?? '';
    // promoFilePath =
    //     (await ImageService.base64ImageFile(editData!.promotionalImageBase64))
    //         ?.path;

    if (_storeRes?.franchises != null &&
        editData!.franchiseId != null &&
        _storeRes!.franchises!.any((e) => e.id == editData!.franchiseId))
      franchIndex = _storeRes!.franchises!
          .indexWhere((e) => e.id == editData!.franchiseId);

    // if (_storeRes?.templates != null &&
    //     editData!.templateId != null &&
    //     editData!.templateId!.isNotEmpty)
    //   templateIndex =
    //       _storeRes?.templates!.indexWhere((e) => e.id == editData!.templateId);

    //template category
    if (_storeRes?.templateCategoriesWithTemplates != null &&
        editData!.templateCategoryId != null &&
        _storeRes!.templateCategoriesWithTemplates!
            .any((e) => e.id == editData!.templateCategoryId)) {
      templateCategoryIndex = _storeRes!.templateCategoriesWithTemplates!
          .indexWhere((e) => e.id == editData!.templateCategoryId);

      //templates

      if (_storeRes?.templateCategoriesWithTemplates?[templateCategoryIndex!]
                  .templates !=
              null &&
          _storeRes!.templateCategoriesWithTemplates![templateCategoryIndex!]
              .templates!
              .any((e) => e.id == editData!.templateId)) {
        templateIndex = _storeRes!
            .templateCategoriesWithTemplates![templateCategoryIndex!].templates!
            .indexWhere((e) => e.id == editData!.templateId);
      }
    }

    if (_storeRes?.businessTypeCategoriesWithBussinessTypes != null &&
        editData?.businessTypeCategoryId != null &&
        _storeRes!.businessTypeCategoriesWithBussinessTypes!
            .any((a) => a.id == editData!.businessTypeCategoryId)) {
      businessTypeCatIndex = _storeRes!
          .businessTypeCategoriesWithBussinessTypes!
          .indexWhere((a) => a.id == editData!.businessTypeCategoryId);

      if (_storeRes
                  ?.businessTypeCategoriesWithBussinessTypes?[
                      businessTypeCatIndex!]
                  .businessTypes !=
              null &&
          editData?.businessTypeId != null &&
          _storeRes!
              .businessTypeCategoriesWithBussinessTypes![businessTypeCatIndex!]
              .businessTypes!
              .any((b) => b.id == editData!.businessTypeId)) {
        businessTypeIndex = _storeRes!
            .businessTypeCategoriesWithBussinessTypes![businessTypeCatIndex!]
            .businessTypes!
            .indexWhere((b) => b.id == editData!.businessTypeId);
      }
    }

    if (editData!.countryId != null &&
        (_storeRes?.countryCityStates?.any((e) =>
                e.id?.toLowerCase() == editData!.countryId?.toLowerCase()) ??
            false)) {
      countryIndex = _storeRes?.countryCityStates!.indexWhere(
          (e) => e.id?.toLowerCase() == editData!.countryId?.toLowerCase());
      phoneCodeIndex = _storeRes!.countryCityStates!.indexWhere(
          (e) => e.id?.toLowerCase() == editData!.countryId?.toLowerCase());

      if (editData?.stateId != null &&
          (_storeRes?.countryCityStates?[countryIndex!].states?.any((e) =>
                  e.id?.toLowerCase() == editData?.stateId?.toLowerCase()) ??
              false)) {
        stateIndex = _storeRes?.countryCityStates?[countryIndex!].states!
            .indexWhere(
                (e) => e.id?.toLowerCase() == editData?.stateId?.toLowerCase());

        if (editData?.cityId != null &&
            (_storeRes?.countryCityStates?[countryIndex!].states?[stateIndex!]
                    .cities
                    ?.any((e) =>
                        e.id?.toLowerCase() ==
                        editData?.cityId?.toLowerCase()) ??
                false)) {
          cityIndex = _storeRes
              ?.countryCityStates?[countryIndex!].states?[stateIndex!].cities
              ?.indexWhere((e) =>
                  e.id?.toLowerCase() == editData?.cityId?.toLowerCase());

          if (editData?.suburbId != null &&
              (_storeRes?.countryCityStates?[countryIndex!].states?[stateIndex!]
                      .cities?[cityIndex!].suburbs
                      ?.any((e) =>
                          e.id?.toLowerCase() ==
                          editData?.suburbId?.toLowerCase()) ??
                  false)) {
            suburbIndex = _storeRes?.countryCityStates?[countryIndex!]
                .states?[stateIndex!].cities?[cityIndex!].suburbs
                ?.indexWhere((e) =>
                    e.id?.toLowerCase() == editData?.suburbId?.toLowerCase());
          }
        }
      }
    }

    addressCltr.text = _storeEditData?.address ?? '';

    latCltr.text = (editData?.latitude ?? '').toString();
    longCltr.text = (editData?.longitude ?? '').toString();

    if (_storeRes?.timeZones != null &&
        editData!.timeZoneId != null &&
        editData!.timeZoneId!.isNotEmpty)
      timeZoneIndex =
          _storeRes!.timeZones!.indexWhere((e) => e.id == editData!.timeZoneId);

    if (_storeRes?.taxExclusiveInclusiveTypes != null &&
        editData!.taxExclusiveInclusiveTypeId != null &&
        editData!.taxExclusiveInclusiveTypeId!.isNotEmpty)
      taxInExIndex = _storeRes!.taxExclusiveInclusiveTypes!
          .indexWhere((e) => e.id == editData!.taxExclusiveInclusiveTypeId);

    if (_storeRes?.languages != null &&
        editData!.languageId != null &&
        editData!.languageId!.isNotEmpty)
      langIndex =
          _storeRes!.languages!.indexWhere((e) => e.id == editData!.languageId);

    if (_storeRes?.dateFormats != null &&
        editData!.dateFormatId != null &&
        editData!.dateFormatId!.isNotEmpty)
      dateForIndex = _storeRes!.dateFormats!
          .indexWhere((e) => e.id == editData!.dateFormatId);

    // enableLoyalty = editData!.isLoyaltyEnabled ?? false;

    setFilepath = editData!.imagePath;

    if (editData!.loyaltyClaimsSettingsAddViewModel != null) {
      maxClaimAmountCltr.text =
          editData!.loyaltyClaimsSettingsAddViewModel!.maxClaimAmount ?? '';
      maxClaimPointsCltr.text =
          editData!.loyaltyClaimsSettingsAddViewModel!.maxClaimPoint ?? '';
      enableUnitPrice = editData!
              .loyaltyClaimsSettingsAddViewModel!.enableAmountToUnitPoint ??
          false;
    }

    if (editData?.loyaltySettingsViewModel != null) {
      cusSpendAmountCltr.text =
          editData!.loyaltySettingsViewModel!.amountSpend ?? '';
      cusEarnPointsCltr.text =
          editData!.loyaltySettingsViewModel!.accuredPoints ?? '';
      cusSpendEarnEnable =
          editData!.loyaltySettingsViewModel!.isActive ?? false;
    }

    // if (editData!.loyaltySettingsAddViewModels != null) {
    //   final _cAList = editData!.loyaltySettingsAddViewModels!;
    //   if (_cAList.isNotEmpty) {
    //     claimAmountList.clear();
    //     for (var e in _cAList)
    //       claimAmountList.add(
    //         ToFromData(
    //             id: e.id,
    //             fromCltr: TextEditingController(text: e.amountFrom ?? ''),
    //             toCltr: TextEditingController(text: e.amountTo ?? ''),
    //             dataCltr: TextEditingController(text: e.points ?? '')),
    //       );
    //   }
    // }

    if (storeRes?.distanceKmsMiles != null &&
        editData!.deliveryDistanceCostSettingsAddViewModels != null &&
        editData!.deliveryDistanceCostSettingsAddViewModels!.isNotEmpty) {
      if (editData!.deliveryDistanceCostSettingsAddViewModels![0].mileKmId !=
              null &&
          editData!.deliveryDistanceCostSettingsAddViewModels![0].mileKmId!
              .isNotEmpty)
        distanceTypeIndex = storeRes!.distanceKmsMiles!.indexWhere((e) =>
            e.id ==
            editData!.deliveryDistanceCostSettingsAddViewModels![0].mileKmId);

      final dAList = editData!.deliveryDistanceCostSettingsAddViewModels!;
      distanceAmountList.clear();
      for (var e in dAList)
        distanceAmountList.add(
          ToFromData(
              id: e.id,
              fromCltr: TextEditingController(text: e.distanceFrom ?? ''),
              toCltr: TextEditingController(text: e.distanceTo ?? ''),
              dataCltr: TextEditingController(text: e.price ?? '')),
        );
    }

    tableQrOrChCltr.text =
        editData?.otherInformationViewModels?.tableQrOrderChannel ?? '';
    updateOrChCltr.text =
        editData?.otherInformationViewModels?.updateOrderChannel ?? '';
    // isRetailScreen =
    //     editData?.otherInformationViewModels?.enablePosRetailScreen ?? false;
    showReserveTable =
        editData?.otherInformationViewModels?.enableReserveTable ?? false;
    showPaymentOnPickUp =
        editData?.otherInformationViewModels?.enablePaymentOnPickUp ?? false;
    showPaymentOnDine =
        editData?.otherInformationViewModels?.enablePaymentOnDineIn ?? false;
    showPaymentonDeli =
        editData?.otherInformationViewModels?.enablePaymentOnDelivery ?? false;
    autoSendToKitOnline = editData
            ?.otherInformationViewModels?.enableAutoSendToKitchenOnlineOrder ??
        false;
    enablePayWithPairing =
        editData?.otherInformationViewModels?.enablePayWithPairing ?? false;
    enableAuSeToKitDisOnOr = editData?.otherInformationViewModels
            ?.enableAutoSendToKitchenDisplayOnlineOrder ??
        false;
    enablePaymentOnQrOrder =
        editData?.otherInformationViewModels?.enablePaymentOnQrOrder ?? false;
    kioskEnablePayAtCounter =
        editData?.otherInformationViewModels?.kioskEnablePayAtCounter ?? false;
    // isLiveModeEnable =
    //     editData?.otherInformationViewModels?.enableStripeLivePaymentMode ??
    //         false;
    enableMaintain =
        editData?.otherInformationViewModels?.enableUnderMaintenance ?? false;
    enableGuestCheckout =
        editData?.otherInformationViewModels?.enableGuestCheckout ?? false;
    enableOrderGiftReFo =
        editData?.otherInformationViewModels?.enableOrderGiftReceiverForm ??
            false;
    enableCopyRightFoot =
        editData?.otherInformationViewModels?.enableCopyRightFooter ?? false;
    // orderPrintAutomatically =
    //     editData?.otherInformationViewModels?.orderPrintAutomatically ?? false;
    // printBillAutomatically =
    //     editData?.otherInformationViewModels?.printBillAutomatically ?? false;
    enableFooter = editData?.otherInformationViewModels?.enableFooter ?? false;
    enableUberDelivery =
        editData?.otherInformationViewModels?.enableUberDelivery ?? false;
    copyRightFootDesc =
        editData?.otherInformationViewModels?.copyRightFooterDescription ?? '';

    if (editData?.publicHolidayViewModels?.isNotEmpty ?? false) {
      final calList = editData!.publicHolidayViewModels!;
      holidayList.clear();
      for (var e in calList)
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
    if (editData?.weekendSurchageViewModels?.isNotEmpty ?? false) {
      final calList = editData!.weekendSurchageViewModels!;
      weekendList.clear();
      for (var e in calList)
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
      final hourSet = editData?.pickUpHoursSettingsAddViewModels
              ?.where((b) => b.weekDayId == a.weekId)
              .toList() ??
          [];

      if (hourSet.isNotEmpty) {
        hourSet.forEach((c) {
          a.openHourList.add(OpenHoursModel(
            id: c.id,
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
      final hourSet = editData?.deliveryHoursSettingsAddViewModels
              ?.where((b) => b.weekDayId == a.weekId)
              .toList() ??
          [];

      if (hourSet.isNotEmpty) {
        hourSet.forEach((c) {
          a.openHourList.add(OpenHoursModel(
            id: c.id,
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
    _storeEditData?.channelCreditCardSurchargePercentageViewModels ??= [];
    final _channels =
        _storeEditData?.channelCreditCardSurchargePercentageViewModels;
    if (_storeRes?.posChannels?.isNotEmpty ?? false) {
      for (final e in _storeRes!.posChannels!) {
        if ((_channels?.any(
                (f) => f.channelId?.toLowerCase() == e.id?.toLowerCase()) ??
            false)) {
          _channels
              ?.firstWhere(
                  (f) => f.channelId?.toLowerCase() == e.id?.toLowerCase())
              .channelName = e.name;
        } else {
          _channels?.add(ChannelCreditCardSurchargePercentageViewModel(
            id: "",
            channelId: e.id,
            channelName: e.name,
            creditCardSurchargePercentage: TextEditingController(),
          ));
        }
      }
    }
  }

  Future<void> addData(BuildContext ctx) async {
    if (storeRes == null) return;

    if (!formKey.currentState!.validate()) {
      IfException.showMessage(message: LN.someFieldIsEmpty);
      return;
    }

    final storeData = StoreData()
      ..id = editData!.id
      ..name = storeNameCltr.text
      ..email = emailCltr.text
      ..phoneNumber = phoneCltr.text
      ..url = urlCltr.text
      ..websiteUrl = webUrlCltr.text
      ..qrUrl = qrUrlCltr.text
      ..holidaySurgePercentage = holisurCltr.text
      ..autoEnableHoliaySurchargePercentage = isEnableHoliDay
      ..address = addressCltr.text
      ..latitude = double.tryParse(latCltr.text)
      ..longitude = double.tryParse(longCltr.text)
      // ..isLoyaltyEnabled = enableLoyalty
      ..abnNumber = abnNumCltr.text
      ..description = descriptionCltr.text
      // ..isRetailScreen = isRetailScreen
      // ..promotionalOfferDiscountPercentage = promoOffDiscountPerCltr.text
      // ..promotionalOfferDiscountAmountThreshold = promoOffAmtCltr.text
      ..creditCardSurgePercentage = creCardsurCltr.text
      ..autoEnableCreditCardSurgePercentage = isEnableCredit
      ..weekendSurgePercentage = weekendSurCltr.text
      ..autoEnableWeekendSurgePercentage = isEnableWeekend
      ..taxPercentage = editData!.taxPercentage
      ..otherInformationViewModels = OtherInformationViewModels(
        tableQrOrderChannel: tableQrOrChCltr.text,
        updateOrderChannel: updateOrChCltr.text,
        // enablePosRetailScreen: isRetailScreen,
        enableReserveTable: showReserveTable,
        enablePaymentOnPickUp: showPaymentOnPickUp,
        enablePaymentOnDineIn: showPaymentOnDine,
        enablePaymentOnDelivery: showPaymentonDeli,
        enableAutoSendToKitchenOnlineOrder: autoSendToKitOnline,
        enablePayWithPairing: enablePayWithPairing,
        enablePaymentOnQrOrder: enablePaymentOnQrOrder,
        kioskEnablePayAtCounter: kioskEnablePayAtCounter,
        enableAutoSendToKitchenDisplayOnlineOrder: enableAuSeToKitDisOnOr,
        // enableStripeLivePaymentMode: isLiveModeEnable,
        enableUnderMaintenance: enableMaintain,
        enableGuestCheckout: enableGuestCheckout,
        enableOrderGiftReceiverForm: enableOrderGiftReFo,
        enableCopyRightFooter: enableCopyRightFoot,
        // orderPrintAutomatically: orderPrintAutomatically,
        // printBillAutomatically: printBillAutomatically,
        enableFooter: enableFooter,
        enableUberDelivery: enableUberDelivery,
        copyRightFooterDescription: copyRightFootDesc,
      );

    if (storeRes?.businessTypeCategoriesWithBussinessTypes != null &&
        businessTypeCatIndex != null) {
      storeData.businessTypeCategoryId = storeRes!
          .businessTypeCategoriesWithBussinessTypes![businessTypeCatIndex!].id;

      if (storeRes
                  ?.businessTypeCategoriesWithBussinessTypes?[
                      businessTypeCatIndex!]
                  .businessTypes !=
              null &&
          businessTypeIndex != null) {
        storeData.businessTypeId = storeRes!
            .businessTypeCategoriesWithBussinessTypes![businessTypeCatIndex!]
            .businessTypes![businessTypeIndex!]
            .id;
      }
    }

    if (storeTypeIndex != null)
      storeData.storeTypeId = storeRes!.storeTypes![storeTypeIndex!].id;

    if (storeRes!.countryCityStates != null &&
        storeRes!.countryCityStates!.isNotEmpty) {
      if (countryIndex != null) {
        storeData.countryId = storeRes!.countryCityStates![countryIndex!].id;

        if (stateIndex != null) {
          storeData.stateId = storeRes!
              .countryCityStates![countryIndex!].states![stateIndex!].id;

          if (cityIndex != null) {
            storeData.cityId = storeRes!.countryCityStates![countryIndex!]
                .states![stateIndex!].cities![cityIndex!].id;

            if (suburbIndex != null) {
              storeData.suburbId = storeRes!
                  .countryCityStates![countryIndex!]
                  .states![stateIndex!]
                  .cities![cityIndex!]
                  .suburbs![suburbIndex!]
                  .id;
            }
          }
        }
      }

      if (phoneCodeIndex != null) {
        storeData.countryPhoneNumberPrefixId =
            storeRes!.countryCityStates![phoneCodeIndex!].id;
      }
    }

    // if (templateIndex != null)
    //   _storeData.templateId = storeRes!.templates![templateIndex!].id;

    if ((storeRes?.templateCategoriesWithTemplates?.isNotEmpty ?? false) &&
        templateCategoryIndex != null) {
      storeData.templateCategoryId =
          storeRes!.templateCategoriesWithTemplates![templateCategoryIndex!].id;

      if ((storeRes?.templateCategoriesWithTemplates?[templateCategoryIndex!]
                  .templates?.isNotEmpty ??
              false) &&
          templateIndex != null) {
        storeData.templateId = storeRes!
            .templateCategoriesWithTemplates![templateCategoryIndex!]
            .templates![templateIndex!]
            .id;
      }
    }

    if (franchIndex != null)
      storeData.franchiseId = storeRes!.franchises![franchIndex!].id;

    if (timeZoneIndex != null)
      storeData.timeZoneId = storeRes!.timeZones![timeZoneIndex!].id;

    if (taxInExIndex != null)
      storeData.taxExclusiveInclusiveTypeId =
          storeRes!.taxExclusiveInclusiveTypes![taxInExIndex!].id;

    if (langIndex != null)
      storeData.languageId = storeRes!.languages![langIndex!].id;

    if (dateForIndex != null)
      storeData.dateFormatId = storeRes!.dateFormats![dateForIndex!].id;

    storeData.loyaltyClaimsSettingsAddViewModel =
        maxClaimAmountCltr.text.isEmpty && maxClaimPointsCltr.text.isEmpty
            ? null
            // LoyaltyClaimsSettingsAddViewModel(
            //     id: "",
            //     maxClaimAmount: "",
            //     maxClaimPoint: "",
            //     enableAmountToUnitPoint: false)
            : LoyaltyClaimsSettingsAddViewModel(
                id: editData!.loyaltyClaimsSettingsAddViewModel != null
                    ? editData!.loyaltyClaimsSettingsAddViewModel!.id
                    : "",
                maxClaimAmount: maxClaimAmountCltr.text.isEmpty
                    ? null
                    : maxClaimAmountCltr.text,
                maxClaimPoint: maxClaimPointsCltr.text.isEmpty
                    ? null
                    : maxClaimPointsCltr.text,
                enableAmountToUnitPoint: enableUnitPrice);

    storeData.loyaltySettingsViewModel = LoyaltySettingsViewModel(
      id: editData?.loyaltySettingsViewModel?.id ?? '',
      amountSpend: cusSpendAmountCltr.text,
      accuredPoints: cusEarnPointsCltr.text,
      isActive: cusSpendEarnEnable,
    );

    // if (claimAmountList.length == 1 &&
    //     claimAmountList.first.fromCltr.text.isEmpty &&
    //     claimAmountList.first.toCltr.text.isEmpty &&
    //     claimAmountList.first.dataCltr.text.isEmpty) {
    //   _storeData.loyaltySettingsAddViewModels = null;
    // } else {
    //   _storeData.loyaltySettingsAddViewModels ??=
    //       <LoyaltySettingsAddViewModel>[];
    //   for (var e in claimAmountList) {
    //     _storeData.loyaltySettingsAddViewModels!
    //         .add(LoyaltySettingsAddViewModel(
    //       id: e.id,
    //       amountFrom: e.fromCltr.text.isEmpty ? null : e.fromCltr.text,
    //       amountTo: e.toCltr.text.isEmpty ? null : e.toCltr.text,
    //       points: e.dataCltr.text.isEmpty ? null : e.dataCltr.text,
    //     ));
    //   }
    // }

    // _storeData.loyaltySettingsDeletedIds ??= <String>[];
    // if (editData!.loyaltySettingsAddViewModels != null &&
    //     editData!.loyaltySettingsAddViewModels!.isNotEmpty) {
    //   for (final e in editData!.loyaltySettingsAddViewModels!) {
    //     if (!claimAmountList.map((f) => f.id).toList().contains(e.id)) {
    //       _storeData.loyaltySettingsDeletedIds!.add(e.id);
    //     }
    //   }
    // }

    if (distanceAmountList.length == 1 &&
        distanceAmountList.first.fromCltr.text.isEmpty &&
        distanceAmountList.first.toCltr.text.isEmpty &&
        distanceAmountList.first.dataCltr.text.isEmpty) {
      storeData.deliveryDistanceCostSettingsAddViewModels = null;
    } else {
      storeData.deliveryDistanceCostSettingsAddViewModels ??=
          <DeliveryDistanceCostSettingsAddViewModel>[];
      for (var e in distanceAmountList) {
        storeData.deliveryDistanceCostSettingsAddViewModels!
            .add(DeliveryDistanceCostSettingsAddViewModel(
          id: e.id,
          mileKmId:
              storeRes!.distanceKmsMiles != null && distanceTypeIndex != null
                  ? storeRes!.distanceKmsMiles![distanceTypeIndex!].id
                  : null,
          distanceFrom: e.fromCltr.text,
          distanceTo: e.toCltr.text,
          price: e.dataCltr.text.isEmpty ? null : e.dataCltr.text,
        ));
      }
    }

    storeData.deliveryDistanceCostSettingsDeletedIds ??= <String>[];
    if (editData!.deliveryDistanceCostSettingsAddViewModels != null &&
        editData!.deliveryDistanceCostSettingsAddViewModels!.isNotEmpty) {
      for (final e in editData!.deliveryDistanceCostSettingsAddViewModels!) {
        if (!distanceAmountList.map((f) => f.id).toList().contains(e.id)) {
          storeData.deliveryDistanceCostSettingsDeletedIds!.add(e.id);
        }
      }
    }

    storeData.pickUpHoursSettingsAddViewModels = <HoursSettingsAddViewModel>[];

    for (final d in pickHourList)
      for (final e in d.openHourList) {
        if (e.openTime.isNotEmpty && e.closeTime.isNotEmpty)
          storeData.pickUpHoursSettingsAddViewModels!
              .add(HoursSettingsAddViewModel(
            id: e.id,
            weekDayId: d.weekId,
            weekDayName: d.weekName,
            openHour: e.openTime,
            closeHour: e.closeTime,
            isOpened: e.isOpen,
          ));
      }

    storeData.pickUpHoursDeletedIds = deletedPickIds;
    // if (editData!.pickUpHoursSettingsAddViewModels != null)
    //   for (final e in editData!.pickUpHoursSettingsAddViewModels!) {
    //     _storeData.pickUpHoursSettingsAddViewModels!
    //         .add(HoursSettingsAddViewModel(
    //       id: e.id,
    //       weekDayId: e.weekDayId,
    //       weekDayName: e.weekDayName,
    //       openHour: e.openHour,
    //       closeHour: e.closeHour,
    //       isOpened: e.isOpened,
    //     ));
    //   }

    storeData.deliveryHoursSettingsAddViewModels =
        <HoursSettingsAddViewModel>[];

    for (final d in deliveryHourList)
      for (final e in d.openHourList) {
        if (e.openTime.isNotEmpty && e.closeTime.isNotEmpty)
          storeData.deliveryHoursSettingsAddViewModels!
              .add(HoursSettingsAddViewModel(
            id: e.id,
            weekDayId: d.weekId,
            weekDayName: d.weekName,
            openHour: e.openTime,
            closeHour: e.closeTime,
            isOpened: e.isOpen,
          ));
      }

    storeData.deliveryHoursDeletedIds = deletedDeliIds;

    // if (editData!.deliveryHoursSettingsAddViewModels != null)
    //   for (final e in editData!.deliveryHoursSettingsAddViewModels!) {
    //     _storeData.deliveryHoursSettingsAddViewModels!
    //         .add(HoursSettingsAddViewModel(
    //       id: e.id,
    //       weekDayId: e.weekDayId,
    //       weekDayName: e.weekDayName,
    //       openHour: e.openHour,
    //       closeHour: e.closeHour,
    //       isOpened: e.isOpened,
    //     ));
    //   }

    if (getFilePath != null &&
        getFilePath!.isEmpty &&
        editData?.imagePath != null &&
        editData!.imagePath!.isNotEmpty) {
      storeData.isImageDeleted = true;
    }

    // _storeData.promotionalImageFileName = promoFilePath;
    // _storeData.promotionalImageBase64 =
    //     ImageService.base64ImageString(promoFilePath);

    storeData.weekendSurchageViewModels = <WeekendSurchageViewModels>[];

    for (var e in weekendList) {
      storeData.weekendSurchageViewModels!.add(WeekendSurchageViewModels(
        id: e.id,
        name: e.titleCltr.text,
        weekDayId: e.weekDayId,
        weekendSurchargePercentage: e.valueCltr.text,
        autoEnableWeekendSurcharge: e.isEnable,
      ));
    }

    storeData.publicHolidayViewModels ??= <PublicHolidayViewModel>[];
    if (holidayList.length == 1 &&
        holidayList.first.titleCltr.text.isEmpty &&
        holidayList.first.date.isEmpty &&
        holidayList.first.valueCltr.text.isEmpty) {
      if (holidayList.first.id.isNotEmpty) {
        _holidayDeletedIds.add(holidayList.first.id);
      }
    } else {
      for (var e in holidayList) {
        if (e.date == "") {
          if (e.id.isNotEmpty) {
            _holidayDeletedIds.add(e.id);
          }
        } else {
          storeData.publicHolidayViewModels!.add(PublicHolidayViewModel(
            id: e.id,
            name: e.titleCltr.text,
            date: e.date,
            holidaySurchargePercentage: e.valueCltr.text,
            autoEnableHolidaySurcharge: e.isEnable,
          ));
        }
      }
    }
    storeData.publicHolidaysDeletedIds = _holidayDeletedIds;
    storeData.channelCreditCardSurchargePercentageViewModels =
        editData?.channelCreditCardSurchargePercentageViewModels;

    updateLoad = true;
    notify();

    final status = await Handler.addUpStore(
        storeData: storeData,
        filePath: (getFilePath == null || getFilePath!.contains("http"))
            ? null
            : getFilePath);

    if (status ?? false) {
      if (storeRes?.dateFormats != null && dateForIndex != null) {
        await SharedPrefs.setDateFormat(
            storeRes!.dateFormats![dateForIndex!].value ?? '');
      }
      final placeOr = Provider.of<PlaceOrderPro>(ctx, listen: false);

      if (GlobalCVP.currentStore != null)
        placeOr
            .onChangeStore(storeId: storeData.id)
            .then((_) => GlobalCVP.getStoreDataServer().then((_) {
                  final index = GlobalCVP.tabs
                      .indexWhere((element) => element.title == "Manage");
                  GlobalCVP.setCurrentPage(index != -1 ? index : 0);
                  placeOr.clear();
                  placeOr.clearInitData();

                  // if (isRetailScreen) {
                  //   final _posRetail =
                  //       Provider.of<PosRetailPro>(ctx, listen: false);
                  //   _posRetail.getData();
                  // } else {
                  placeOr.init();
                  // }
                }));
      reset();
      getAllData();
      // GlobalCVP.isRetailScreen = isRetailScreen;
      deletedPickIds.clear();
      deletedDeliIds.clear();
    }
    updateLoad = false;
    notify();
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

//file picker section
  String? _filePath;
  String? get getFilePath => _filePath;

  set setFilepath(String? val) {
    _filePath = val;
  }

  void getFilePick() async {
    final file = await ImageService.filePick(
        showRemoveTile: getFilePath != null &&
            getFilePath!.isNotEmpty &&
            editData?.imagePath != null &&
            editData!.imagePath!.isNotEmpty);
    if (file != null) {
      setFilepath = file;
      notify();
    }
  }

  // void getPromoFile() async {
  //   final _file = await ImageService.filePick(
  //       imgAspectRatio: ImgAspectRatio(
  //           ratio: 25 / 9, ratioEnum: AspectRatioEnum.R_25_9, title: "25:9"));
  //   if (_file != null) {
  //     promoFilePath = _file;
  //     notify();
  //   }
  // }

  // claim amount point functions

  // void addClaimAP() {
  //   claimAmountList.add(ToFromData(
  //       fromCltr: TextEditingController(),
  //       toCltr: TextEditingController(),
  //       dataCltr: TextEditingController()));
  //   notifyListeners();
  // }

  // void removeClaimAP({required int index}) {
  //   claimAmountList.removeAt(index);
  //   notifyListeners();
  // }

  // distance amount functions

  void addDistAmount() {
    distanceAmountList.add(ToFromData(
        fromCltr: TextEditingController(),
        toCltr: TextEditingController(),
        dataCltr: TextEditingController()));
    notifyListeners();
  }

  void removeDistAmount({required int index}) {
    distanceAmountList.removeAt(index);
    notifyListeners();
  }

  // void setIsClosed({required int index, required bool isPicked}) {
  //   if (editData == null) return;

  //   if (isPicked)
  //     editData!.pickUpHoursSettingsAddViewModels![index].isOpened =
  //         !(editData!.pickUpHoursSettingsAddViewModels![index].isOpened ??
  //             true);
  //   else
  //     editData!.deliveryHoursSettingsAddViewModels![index].isOpened =
  //         !(editData!.deliveryHoursSettingsAddViewModels![index].isOpened ??
  //             true);
  //   notifyListeners();
  // }

  bool pickSelectAll = false;
  bool deliSelectAll = false;

  //langauge update
  Future<void> onChangeLang(int? index) async {
    if (index == null) return;
    int? tempIndex = langIndex;
    langIndex = index;
    loading = true;
    notify();
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
    notify();
  }

  set resetLangIndex(int? index) {
    langIndex = index;
    notify();
  }

  // calender update

  void addCalenderData() {
    holidayList.add(
      HolidayModel(
        titleCltr: TextEditingController(),
        valueCltr: TextEditingController(),
      ),
    );
    notify();
  }

  void removeCalenderData({required int index}) {
    if (holidayList[index].id.isNotEmpty) {
      _holidayDeletedIds.add(holidayList[index].id);
    }
    holidayList.removeAt(index);
    notify();
  }

  void notify() => notifyListeners();

  void reset() {
    _storeRes = null;
    _storeEditData = null;
    loading = true;
    updateLoad = false;
    storeNameCltr.clear();
    abnNumCltr.clear();
    emailCltr.clear();
    phoneCltr.clear();
    urlCltr.clear();
    holisurCltr.text = '0';
    franchIndex = null;
    templateIndex = null;
    templateCategoryIndex = null;
    businessTypeCatIndex = null;
    businessTypeIndex = null;
    storeTypeIndex = null;
    countryIndex = null;
    stateIndex = null;
    cityIndex = null;
    suburbIndex = null;
    addressCltr.clear();
    latCltr.clear();
    longCltr.clear();
    timeZoneIndex = null;
    taxInExIndex = null;
    langIndex = null;
    dateForIndex = null;
    descriptionCltr.clear();
    webUrlCltr.clear();
    qrUrlCltr.clear();
    maxClaimAmountCltr.clear();
    maxClaimPointsCltr.clear();
    enableUnitPrice = false;

    cusSpendAmountCltr.clear();
    cusEarnPointsCltr.clear();
    cusSpendEarnEnable = false;

    // claimAmountList.clear();
    // claimAmountList.addAll(<ToFromData>[
    //   ToFromData(
    //       fromCltr: TextEditingController(),
    //       toCltr: TextEditingController(),
    //       dataCltr: TextEditingController()),
    // ]);

    distanceTypeIndex = null;

    distanceAmountList.clear();
    distanceAmountList.addAll(<ToFromData>[
      ToFromData(
          fromCltr: TextEditingController(),
          toCltr: TextEditingController(),
          dataCltr: TextEditingController()),
    ]);

    _placeId = null;
    _filePath = null;
    pickSelectAll = false;
    deliSelectAll = false;
    // promoOffDiscountPerCltr.clear();
    // promoOffAmtCltr.clear();
    // promoFilePath = null;
    copyRightFootDesc = null;

    holidayList.clear();
    holidayList.addAll(<HolidayModel>[
      HolidayModel(
        titleCltr: TextEditingController(),
        valueCltr: TextEditingController(),
      ),
    ]);
    weekendList.clear();
    _holidayDeletedIds.clear();
    deletedPickIds.clear();
    deletedDeliIds.clear();
  }
}
