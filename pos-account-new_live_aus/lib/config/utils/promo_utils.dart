import 'package:flutter/foundation.dart';
import 'package:pos_account/config/validator.dart';
import 'package:pos_account/constant/constant.dart';
import 'package:pos_account/constant/date_format_keys.dart';
import 'package:pos_account/model/home/menu/place_order/promotion_res.dart';
import 'package:pos_account/repository/if_exception.dart';

class PromoUtils {
  static AllPromotionRes? promotionRes;
  static String? dateFormatString;
  static List<Promotion>? currentPromotion;

  static void clear() {
    promotionRes = null;
    dateFormatString = null;
    currentPromotion = null;
  }

  static PromoModel? get({
    required String? productId,
    required String? variationId,
    String? promoId,
  }) {
    if (promotionRes == null || dateFormatString == null) return null;

    final _productList = promotionRes?.promotionProducts ?? [];

    final _promoList = promotionRes?.promotions ?? [];

    try {
      if (_productList.any((a) =>
          (a.promotionConditionProducts?.isNotEmpty ?? false) &&
          (promoId == null ||
              a.promotionId?.toLowerCase() == promoId.toLowerCase()))) {
        //
        // kPrint("1. promotionConditionProducts: Not Empty $productId");

        final _nowData = DateTime.now();

        final _dateFormat = GET_DATE_FORMAT(dateFormatString!);

        if (_productList.any((a) =>
            a.promotionConditionProducts
                ?.any((b) => b.id?.toLowerCase() == productId?.toLowerCase()) ??
            false)) {
          // kPrint("2. HAS PRODUCT ID: ------------ ${productId}");
          final _promoCondList = _productList.where((a) {
            if (a.promotionConditionProducts?.any(
                    (b) => b.id?.toLowerCase() == productId?.toLowerCase()) ??
                false) {
              final _temp1 = a.promotionConditionProducts?.firstWhere(
                  (b) => b.id?.toLowerCase() == productId?.toLowerCase());
              return _temp1?.id?.toLowerCase() == productId?.toLowerCase();
            }
            return false;
          }).toList();

          if (_promoCondList.length == 1) {
            final _promData = _promoList.firstWhere((c) =>
                c.id?.toLowerCase() ==
                _promoCondList.first.promotionId?.toLowerCase());

            if (_promData.conditionProductIncludeExcludeType ==
                ProductIncludeExcludeTypeEnum.INCLUDE.name) {
              if (_promData.promotionType?.contains(PromoTypeEnum.BASIC.name) ??
                  false) {
                //basic

                return _getPromoOnMatch(
                    _promData, _promoCondList.first, productId, variationId);
              } else if (_promData.promotionType
                      ?.contains(PromoTypeEnum.ADVANCE.name) ??
                  false) {
                //advance
              }
            }
          } else if (_promoCondList.isNotEmpty) {
            final _promDataList = _promoList
                .where((c) => _promoCondList.any(
                    (f) => f.promotionId?.toLowerCase() == c.id?.toLowerCase()))
                .toList();

            if (_promDataList.any((b) {
              final _startDate = b.startDate?.isNotEmpty ?? false
                  ? _dateFormat.parse(b.startDate ?? '')
                  : null;
              final _endDate = b.endDate?.isNotEmpty ?? false
                  ? _dateFormat.parse(b.endDate ?? '')
                  : null;
              if (_startDate != null &&
                  _endDate != null &&
                  _nowData.isAfter(_startDate) &&
                  _nowData.isBefore(_endDate)) {
                return true;
              } else {
                return false;
              }
            })) {
              final _promData = _promDataList.firstWhere((b) {
                final _startDate = b.startDate?.isNotEmpty ?? false
                    ? _dateFormat.parse(b.startDate ?? '')
                    : null;
                final _endDate = b.endDate?.isNotEmpty ?? false
                    ? _dateFormat.parse(b.endDate ?? '')
                    : null;
                if (_startDate != null &&
                    _endDate != null &&
                    _nowData.isAfter(_startDate) &&
                    _nowData.isBefore(_endDate)) {
                  return true;
                } else {
                  return false;
                }
              });

              if (_promData.conditionProductIncludeExcludeType ==
                  ProductIncludeExcludeTypeEnum.INCLUDE.name) {
                if (_promData.promotionType
                        ?.contains(PromoTypeEnum.BASIC.name) ??
                    false) {
                  //basic

                  return _getPromoOnMatch(
                      _promData, _promoCondList.first, productId, variationId);
                } else if (_promData.promotionType
                        ?.contains(PromoTypeEnum.ADVANCE.name) ??
                    false) {
                  //advance
                }
              }
            }
          }
        } else {
          // print("2. NO PRODUCT ID: ------------ ${productId}");

          if (_promoList.any((b) {
            final _startDate = b.startDate?.isNotEmpty ?? false
                ? _dateFormat.parse(b.startDate ?? '')
                : null;
            final _endDate = b.endDate?.isNotEmpty ?? false
                ? _dateFormat.parse(b.endDate ?? '')
                : null;
            if (_startDate != null &&
                _endDate != null &&
                _nowData.isAfter(_startDate) &&
                _nowData.isBefore(_endDate)) {
              return true;
            } else {
              return false;
            }
          })) {
            final _promData = _promoList.firstWhere((b) {
              final _startDate = b.startDate?.isNotEmpty ?? false
                  ? _dateFormat.parse(b.startDate ?? '')
                  : null;
              final _endDate = b.endDate?.isNotEmpty ?? false
                  ? _dateFormat.parse(b.endDate ?? '')
                  : null;
              if (_startDate != null &&
                  _endDate != null &&
                  _nowData.isAfter(_startDate) &&
                  _nowData.isBefore(_endDate)) {
                return true;
              } else {
                return false;
              }
            });

            if (_productList.any((a) =>
                _promData.id?.toLowerCase() == a.promotionId?.toLowerCase())) {
              final _promCondData = _productList.firstWhere((a) =>
                  _promData.id?.toLowerCase() == a.promotionId?.toLowerCase());

              if (_promData.conditionProductIncludeExcludeType ==
                  ProductIncludeExcludeTypeEnum.EXCLUDE.name) {
                if (_promData.promotionType
                        ?.contains(PromoTypeEnum.BASIC.name) ??
                    false) {
                  //basic
                  if (_promCondData.promotionConditionProducts?.isNotEmpty ??
                      false) {
                    final _pId =
                        _promCondData.promotionConditionProducts?.first.id;

                    return _getPromoOnMatch(
                        _promData, _promCondData, _pId, variationId);
                  }
                } else {}
              }
            }
          }
        }
      }
      if (_productList.isNotEmpty) {
        // if promo cond action products empty and all products has promotions

        final _emptyProdList = _productList
            .where((a) =>
                (a.promotionConditionProducts == null ||
                    a.promotionConditionProducts!.isEmpty) &&
                (promoId == null ||
                    promoId.toLowerCase() == a.promotionId?.toLowerCase()))
            .toList();

        // kPrint("_emptyProd: ${_emptyProd.promotionId}");

        for (final a in _emptyProdList) {
          if (_promoList.any(
              (b) => b.id?.toLowerCase() == a.promotionId?.toLowerCase())) {
            final _promData = _promoList.firstWhere(
                (b) => b.id?.toLowerCase() == a.promotionId?.toLowerCase());

            //

            final _matchPromo =
                _getPromoOnMatch(_promData, a, productId, variationId);

            // kPrint("_promData: ${_promData.name} ${_matchPromo != null}");
            if (_matchPromo != null) return _matchPromo;
          }
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print("Prmotion condition issue: $e");
        IfException.showMessage(message: "Prmotion condition issue: $e");
      }
    }

    //
    return null;
  }

  static PromoModel? _getPromoOnMatch(
    Promotion _promData,
    PromotionProduct _promoCondData,
    String? productId,
    String? variationId,
  ) {
    PromoModel? _promModel;

    if (_promData.conditionProductGroupType ==
        SpecificOrAllProductEnum.SPECIFICPRODUCT.name) {
      try {
        final _condProduct = _promoCondData.promotionConditionProducts
            ?.firstWhere(
                (d) => d.id?.toLowerCase() == productId?.toLowerCase());

        _promModel = PromoModel(
          promoId: _promData.id ?? '',
          name: _promData.name,
        );

        try {
          if ((_condProduct?.productVariations?.isNotEmpty ?? false) &&
              variationId != null &&
              _condProduct!.productVariations!.any(
                  (f) => f.id?.toLowerCase() == variationId.toLowerCase())) {
            final _condVariation = _condProduct.productVariations?.firstWhere(
                (f) => f.id?.toLowerCase() == variationId.toLowerCase());

            if (_condVariation?.discountType ==
                FreeOrDiscountEnum.DISCOUNTAMOUNT.name) {
              _promModel.discountAmount = _condVariation?.amountDiscountValue;
            } else if (_condVariation?.discountType ==
                FreeOrDiscountEnum.DISCOUNTPERCENTAGE.name) {
              _promModel.discountPercent = _condVariation?.amountDiscountValue;
            } else if (_condVariation?.discountType ==
                FreeOrDiscountEnum.FREE.name) {
              _promModel.isFree = true;
              _promModel.discountPercent = '100';
            }
          }
          // else {
          //   if (_condProduct?.discountType ==
          //       FreeOrDiscountEnum.DISCOUNTAMOUNT.name) {
          //     _promModel.discountAmount = _condProduct?.amountDiscountValue;
          //   } else if (_condProduct?.discountType ==
          //       FreeOrDiscountEnum.DISCOUNTPERCENTAGE.name) {
          //     _promModel.discountPercent = _condProduct?.amountDiscountValue;
          //   } else if (_condProduct?.discountType ==
          //       FreeOrDiscountEnum.FREE.name) {
          //     _promModel.isFree = true;
          //     _promModel.discountPercent = '100';
          //   }
          // }
        } catch (e) {
          kPrint("1. ${_promModel.name} $e");
        }
      } catch (e) {
        kPrint("2. ${_promModel?.name} $e");
      }
    } else if (_promData.conditionProductGroupType ==
        SpecificOrAllProductEnum.ALLPRODUCTS.name) {
      if (_promData.conditionDiscountType ==
          FreeOrDiscountEnum.DISCOUNTAMOUNT.name) {
        _promModel = PromoModel(
            promoId: _promData.id ?? '',
            name: _promData.name,
            discountAmount: _promData.conditionAmountQuantityDiscountValue);
      } else if (_promData.conditionDiscountType ==
          FreeOrDiscountEnum.DISCOUNTPERCENTAGE.name) {
        _promModel = PromoModel(
            promoId: _promData.id ?? '',
            name: _promData.name,
            discountPercent: _promData.conditionAmountQuantityDiscountValue);
      } else if (_promData.conditionDiscountType ==
          FreeOrDiscountEnum.FREE.name) {
        _promModel = PromoModel(
          promoId: _promData.id ?? '',
          name: _promData.name,
          isFree: true,
          discountPercent: '100',
        );
      }
    }

    final _nowData = DateTime.now();

    final _dateFormat = GET_DATE_FORMAT(dateFormatString!);

    final _startDate = _promData.startDate?.isNotEmpty ?? false
        ? _dateFormat.parse(_promData.startDate ?? '')
        : null;
    final _endDate = _promData.endDate?.isNotEmpty ?? false
        ? _dateFormat.parse(_promData.endDate ?? '')
        : null;

    if (_startDate != null &&
        _endDate != null &&
        _nowData.isAfter(_startDate) &&
        _nowData.isBefore(_endDate)) {
      //if between start and end date
      if (_promData.promotionScheduleType
              ?.contains(PromoScheduleTypeEnum.ONETIME.name) ??
          false) {
        // onetime

        if (_promData.conditionName
                ?.contains(PromoConditionEnum.BASICDISCOUNT.name) ??
            false) {
          // basic discount
          return _promModel;
        } else {
          // other discount
        }
      } else if (_promData.promotionScheduleType
              ?.contains(PromoScheduleTypeEnum.RECURRING.name) ??
          false) {
        // recurring
        final _dayName = DAY_NAME.format(DateTime.now());

        final _currentTimeStr = GET_TIME.format(DateTime.now());
        final _currentTime =
            _currentTimeStr.isNotEmpty ? GET_TIME.parse(_currentTimeStr) : null;

        if (_promoCondData.promotionSchedules?.any((f) {
              final _isDayMatch = f.scheduledDay
                      ?.toLowerCase()
                      .contains(_dayName.toLowerCase()) ??
                  false;

              final _timeFrom = f.timeFrom?.isNotEmpty ?? false
                  ? GET_TIME.parse(f.timeFrom ?? '')
                  : null;
              final _timeTo = f.timeTo?.isNotEmpty ?? false
                  ? GET_TIME.parse(f.timeTo ?? '')
                  : null;

              final _isWithInTime = _currentTime != null &&
                  _timeFrom != null &&
                  _timeTo != null &&
                  _currentTime.isAfter(_timeFrom) &&
                  _currentTime.isBefore(_timeTo);

              return _isDayMatch && _isWithInTime;
            }) ??
            false) {
          return _promModel;
        }
      }
    }

    return null;
  }

  static String getPromoDisPercent({String? disValue, String? price}) {
    final _disValue = disValue?.inDouble ?? 0;
    final _price = price?.inDouble ?? 0;
    if (_price == 0) return "0";
    return (_disValue * 100 / _price).formatDouble;
  }

  static String getPromoDisAmount({String? disPercent, String? price}) {
    final _disPercent = disPercent?.inDouble ?? 0;
    final _price = price?.inDouble ?? 0;
    if (_price == 0) return "0";
    return (_price * _disPercent / 100).formatDouble;
  }

  static List<Promotion>? getPromoTitle() {
    try {
      final _nowData = DateTime.now();
      final _dayName = DAY_NAME.format(DateTime.now());
      final _dateFormat = GET_DATE_FORMAT(dateFormatString!);

      final _currentTimeStr = GET_TIME.format(DateTime.now());
      final _currentTime =
          _currentTimeStr.isNotEmpty ? GET_TIME.parse(_currentTimeStr) : null;

      final _promoList = promotionRes?.promotions?.where((a) {
        final _startDate = a.startDate?.isNotEmpty ?? false
            ? _dateFormat.parse(a.startDate ?? '')
            : null;
        final _endDate = a.endDate?.isNotEmpty ?? false
            ? _dateFormat.parse(a.endDate ?? '')
            : null;

        bool _isConditionFine() {
          if (a.conditionProductGroupType ==
              SpecificOrAllProductEnum.ALLPRODUCTS.name) {
            return true;
          } else if (a.conditionProductGroupType ==
              SpecificOrAllProductEnum.SPECIFICPRODUCT.name) {
            // kPrint('message');
            try {
              //TODO: setup this for only recurring

              final _condProduct =
                  promotionRes?.promotionProducts?.firstWhere((b) {
                return b.promotionId?.toLowerCase() == a.id?.toLowerCase();
              });

              if (_condProduct?.promotionSchedules?.isNotEmpty ?? false) {
                return _condProduct?.promotionSchedules?.any((c) {
                      final _isDayMatch = c.scheduledDay
                              ?.toLowerCase()
                              .contains(_dayName.toLowerCase()) ??
                          false;

                      final _timeFrom = c.timeFrom?.isNotEmpty ?? false
                          ? GET_TIME.parse(c.timeFrom ?? '')
                          : null;
                      final _timeTo = c.timeTo?.isNotEmpty ?? false
                          ? GET_TIME.parse(c.timeTo ?? '')
                          : null;

                      final _isWithInTime = _currentTime != null &&
                          _timeFrom != null &&
                          _timeTo != null &&
                          _currentTime.isAfter(_timeFrom) &&
                          _currentTime.isBefore(_timeTo);

                      return _isDayMatch && _isWithInTime;
                    }) ??
                    false;
              } else {
                return true;
              }
            } catch (e) {
              //
            }
          }
          return false;
        }

        // kPrint(
        //     "message: ${_startDate.isAfter(_nowData)} : ${_startDate.difference(_nowData).inSeconds}");

        if (_startDate != null && _endDate != null) {
          if (_nowData.isAfter(_startDate) && _nowData.isBefore(_endDate)) {
            return _isConditionFine();
          } else if (_startDate.isAfter(_nowData) &&
              _startDate.difference(_nowData).inHours < 13) {
            return _isConditionFine();
          }
        }
        return false;
      }).toList();

      if (_promoList?.isNotEmpty ?? false)
        return _promoList;
      else
        return null;
    } catch (e) {
      kPrint("getPromoTitle Issue: $e");
      return null;
    }
  }

  static PromoModel? promoOnTotalOrder;

  static void orderPromoAdvance({required double totalPrice}) {
    promoOnTotalOrder = null;

    if (promotionRes == null || dateFormatString == null) return;
    try {
      final _promoList = promotionRes?.promotions ?? [];

      if (_promoList.isNotEmpty) {
        final _nowData = DateTime.now();

        final _dateFormat = GET_DATE_FORMAT(dateFormatString!);

        final _promDateList = _promoList.where((b) {
          DateTime? _startDate;
          DateTime? _endDate;
          try {
            _startDate = b.startDate?.isNotEmpty ?? false
                ? _dateFormat.parse(b.startDate ?? '')
                : null;
            _endDate = b.endDate?.isNotEmpty ?? false
                ? _dateFormat.parse(b.endDate ?? '')
                : null;
          } catch (e) {
            kPrint("orderPromoAdvance Error: $e");
          }
          if (_startDate != null &&
              _endDate != null &&
              _nowData.isAfter(_startDate) &&
              _nowData.isBefore(_endDate)) {
            final _isAdvance =
                b.promotionType?.contains(PromoTypeEnum.ADVANCE.name) ?? false;
            final _allCustomer = b.customerTargetGroup
                    ?.contains(PromoTargetCustomerGroupEnum.ALLCUSTOMER.name) ??
                false;

            final _condInclude = b.conditionProductIncludeExcludeType
                    ?.contains(ProductIncludeExcludeTypeEnum.INCLUDE.name) ??
                false;

            final _condName = b.conditionName?.contains(
                    PromoConditionEnum.SPENDSTHEFOLLOWINGAMOUNT.name) ??
                false;

            final _actionName = b.actionName
                    ?.contains(PromoActionEnum.SAVECERTAINAMOUNT.name) ??
                false;

            final _actionInclude = b.actionProductIncludeExcludeType
                    ?.contains(ProductIncludeExcludeTypeEnum.INCLUDE.name) ??
                false;

            final _condAmount =
                (b.conditionAmountQuantityDiscountValue?.inDouble ?? 0) <=
                    totalPrice;

            return _isAdvance &&
                _allCustomer &&
                _condInclude &&
                _condName &&
                _actionName &&
                _actionInclude &&
                _condAmount;
          } else {
            return false;
          }
        }).toList();

        if (_promDateList.isNotEmpty) {
          //advance

          for (final _promoDate in _promDateList) {
            final _promoModel = PromoModel(
              promoId: _promoDate.id ?? '',
              name: _promoDate.name,
            );

            if (_promoDate.actionDiscountType ==
                FreeOrDiscountEnum.DISCOUNTAMOUNT.name) {
              final _disPer = PromoUtils.getPromoDisPercent(
                disValue: _promoDate.actionAmountDiscountValue,
                price: totalPrice.formatDouble,
              );
              _promoModel.discountAmount = _promoDate.actionAmountDiscountValue;
              _promoModel.discountPercent = _disPer;
            } else if (_promoDate.actionDiscountType ==
                FreeOrDiscountEnum.DISCOUNTPERCENTAGE.name) {
              final _disAmount = PromoUtils.getPromoDisAmount(
                disPercent: _promoDate.actionAmountDiscountValue,
                price: totalPrice.formatDouble,
              );

              _promoModel.discountPercent =
                  _promoDate.actionAmountDiscountValue;
              _promoModel.discountAmount = _disAmount;
            }

            // return _promoModel;
            promoOnTotalOrder = _promoModel;
          }
        }
      }
    } catch (e) {
      kPrint("orderPromoAdvance Error #2: $e");
    }
  }

  static Duration? promoDuration;

  static void setNearestPromoDuration() {
    if (currentPromotion == null || currentPromotion!.isEmpty) return;

    final dateFormat = GET_DATE_FORMAT(dateFormatString!);
    final now = DateTime.now();

    Duration? minDuration;
    bool _onePromoisRunning = false;

    for (final promo in currentPromotion!) {
      final startDate = promo.startDate?.isNotEmpty ?? false
          ? dateFormat.parse(promo.startDate ?? '')
          : null;
      final endDate = promo.endDate?.isNotEmpty ?? false
          ? dateFormat.parse(promo.endDate ?? '')
          : null;

      if (startDate != null && endDate != null) {
        if (now.isAfter(startDate) && now.isBefore(endDate)) {
          _onePromoisRunning = true;
        } else if (startDate.isAfter(now) && now.isBefore(endDate)) {
          final diff = now.difference(startDate).abs();

          if (minDuration == null || diff < minDuration) {
            minDuration = diff;
          }
        }
      }
    }

    if (!_onePromoisRunning) promoDuration = minDuration;
  }

  static String? getNearestPromoId() {
    if (currentPromotion == null || currentPromotion!.isEmpty) return null;

    final dateFormat = GET_DATE_FORMAT(dateFormatString!);
    final now = DateTime.now();

    Duration? minDuration;
    String? _nearestPromoId;

    for (final promo in currentPromotion!) {
      if ((promo.startDate?.isNotEmpty ?? false) &&
          (promo.endDate?.isNotEmpty ?? false)) {
        final startDate = dateFormat.parse(promo.startDate!);

        final endDate = dateFormat.parse(promo.endDate ?? '');

        if (now.isAfter(startDate) && now.isBefore(endDate)) {
          return promo.id;
        } else if (startDate.isAfter(now) && now.isBefore(endDate)) {
          final diff = now.difference(startDate).abs();

          if (minDuration == null || diff < minDuration) {
            minDuration = diff;
            _nearestPromoId = promo.id;
          }
        }
      }
    }

    return _nearestPromoId;
  }
}

enum PromoTypeEnum { BASIC, ADVANCE }

enum PromoScheduleTypeEnum { ONETIME, RECURRING }

enum PromoTargetCustomerGroupEnum { ALLCUSTOMER, SPECIFICCUSTOMERGROUP }

enum PromoConditionEnum {
  BASICDISCOUNT,
  // advance
  MAXORDERREACH,
  SPENDSTHEFOLLOWINGAMOUNT,
  BUYTHEFOLLOWINGPRODUCTS
}

enum PromoActionEnum {
  GETHEFOLLOWINGITEMS,
  SAVECERTAINAMOUNT,
  PAYFIXEDAMOUNT,
  EARNEXTRALOYALTY
}

enum SpecificOrAllProductEnum { ALLPRODUCTS, SPECIFICPRODUCT }

enum FreeOrDiscountEnum { FREE, DISCOUNTPERCENTAGE, DISCOUNTAMOUNT }

enum ActionEligibilityEnum { ONENTIRESELL, ONCONDITIONITEMS }

enum ConditionActionItemTypeEnum { ActionItems, ConditionItems }

enum ProductIncludeExcludeTypeEnum { INCLUDE, EXCLUDE }

class PromoModel {
  final String? name;
  String? discountPercent;
  String? discountAmount;
  bool isFree;
  final String promoId;
  //recurring : TODO will get data from order utils : commented
  // final Duration? offerStartsIn;
  // final Duration? offerEndsIn;
  String? discountedPrice;
  // final String? message;
  // final String? tsCount; //thresold count
  // final bool isOfferStart;

  PromoModel({
    this.name,
    this.discountPercent,
    this.discountAmount,
    this.isFree = false,
    required this.promoId,
    //
    // this.offerStartsIn,
    // this.offerEndsIn,
    this.discountedPrice,
    // this.message,
    // this.tsCount,
    // this.isOfferStart = false,
  });
}



//case : single product on multiple promotion case