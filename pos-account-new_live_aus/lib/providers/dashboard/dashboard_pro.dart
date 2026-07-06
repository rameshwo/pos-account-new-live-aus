import 'package:flutter/material.dart';
import 'package:pos_account/model/home/dashboard/dash_channel_filter_sec.dart';
import 'package:pos_account/model/home/dashboard/dash_channel_up_req.dart';
import 'package:pos_account/model/home/dashboard/dashboard_res.dart';
import 'package:pos_account/providers/cus_val_pro.dart';
import 'package:pos_account/repository/handler.dart';
import 'package:pos_account/services/database/shared_pref.dart';

class DashboardPro extends ChangeNotifier {
  void get notify => notifyListeners();

  String curSym = '';

  DashboardRes? dashboardRes;
  bool loading = true;

  Future<void> getDashboard() async {
    curSym = await SharedPrefs.curSym;
    // loading = true;
    // notify;
    dashboardRes ??= DashboardRes();

    dashboardRes?.dashBoardStatisticsToday =
        await Handler.getDashboardStatisticsToday();
    notify;

    dashboardRes?.salesByCategoryModel = await Handler.getSalesByCategory();
    notify;

    final _getSalesByChannel = await Handler.getSalesByChannelWithMonths();
    if (_getSalesByChannel != null) _salesByChannelGroup(_getSalesByChannel);

    dashboardRes?.availableChannels = await Handler.getAvailableChannels();
    notify;

    dashboardRes?.paymentMethodModel = await Handler.getSalesByPaymentMethod();
    notify;

    if (GlobalCVP.isServiceStore) {
      dashboardRes?.employeeSalesModel = await Handler.getEmployeeSales();
      notify;
    }

    dashboardRes?.recommendedProductsModel =
        await Handler.getRecommendedProducts();

    loading = false;
    notify;
  }

  void _salesByChannelGroup(List<SalesChannelMonthModel> _getSalesByChannel) {
    Map<String, List<SalesByYear>>? _groupSalesByRecentAndPreviousYear(
        List<SalesChannelMonthModel> data) {
      // Get unique years
      final years = data
          .map((e) => int.tryParse(e.year ?? '0') ?? 0)
          .toSet()
          .toList()
        ..sort();

      if (years.isEmpty) return null;

      final previousYear = years.first.toString();
      final thisYear = years.last.toString();

      List<SalesByYear> _build(String year) {
        final Map<String, double> monthTotals = {};

        for (final item in data) {
          if (item.year == year) {
            final month = item.month ?? '';
            final sales = double.tryParse(item.totalSales ?? '0') ?? 0;
            monthTotals[month] = (monthTotals[month] ?? 0) + sales;
          }
        }

        return monthTotals.entries
            .map(
              (e) => SalesByYear(
                month: e.key,
                totalSales: e.value.toStringAsFixed(2),
              ),
            )
            .toList();
      }

      return {
        'thisYear': _build(thisYear),
        'previousYear': _build(previousYear),
      };
    }

    List<SalesChannelModel> _groupSalesByChannelRecentYear(
        List<SalesChannelMonthModel> data) {
      // 1️⃣ Find most recent year
      final recentYear = data.isNotEmpty
          ? data
              .map((e) => int.tryParse(e.year ?? '0') ?? 0)
              .reduce((a, b) => a > b ? a : b)
          : DateTime.now().year;

      // 2️⃣ Filter only recent year data
      final filteredData =
          data.where((e) => e.year == recentYear.toString()).toList();

      // 3️⃣ Group by channel
      final Map<String, List<SalesChannelMonthModel>> grouped = {};

      for (final item in filteredData) {
        final channel = item.channelName ?? 'Unknown';

        grouped.putIfAbsent(channel, () => []);
        grouped[channel]?.add(item);
      }

      // 4️⃣ Map to model
      return grouped.entries
          .map(
            (e) => SalesChannelModel(
              channelName: e.key,
              salesChannelMonthModel: e.value,
            ),
          )
          .toList();
    }

    final salesByYear = _groupSalesByRecentAndPreviousYear(_getSalesByChannel);

    if (salesByYear != null) {
      dashboardRes?.salesByCurrentYear = salesByYear['thisYear'];
      dashboardRes?.salesByPreviousYear = salesByYear['previousYear'];
    }

    dashboardRes?.salesChannelModel =
        _groupSalesByChannelRecentYear(_getSalesByChannel);
    // log(json.encode(
    //     dashboardRes?.salesChannelModel?.map((a) => a.toJson()).toList()));
    notify;
  }

  void clear() {
    loading = false;
    dashboardRes = null;
    filterSec = null;
    // curSym = '';
  }

  DashChannelFilterSec? filterSec;
  bool diaLoading = false;

  Future<void> getChannelFiterSec(String? id) async {
    if (id == null) return;
    loading = true;
    notify;

    filterSec = await Handler.getDashChannelFilterSec(id: id);

    filterSec?.cuisineTypes?.forEach((e) {
      if (filterSec?.storeChannelCuisineTypes?.any(
              (f) => f.cuisineTypeId?.toLowerCase() == e.id?.toLowerCase()) ??
          false) {
        e.isSelected = true;
      } else {
        e.isSelected = false;
      }
    });

    filterSec?.channelFilters?.forEach((e) {
      e.channelFilterOptions?.forEach((f) {
        if (filterSec?.storeChannelFilterOptions?.any((g) =>
                g.channelFilterOptionId?.toLowerCase() ==
                f.id?.toLowerCase()) ??
            false) {
          f.isSelected = true;
        } else {
          f.isSelected = false;
        }
      });
    });

    loading = false;
    notify;
  }

  Future<bool> updateChannel({String? channelId}) async {
    final filterOption = <CuisineType>[];

    filterSec?.channelFilters?.forEach((e) {
      e.channelFilterOptions?.forEach((f) {
        if (f.isSelected ?? false) {
          filterOption.add(CuisineType(
            id: f.id,
            name: f.name,
          ));
        }
      });
    });

    final req = DashChannelUpdateReq(
      channelId: channelId,
      cuisineTypes: filterSec?.cuisineTypes
          ?.where((e) => e.isSelected ?? false)
          .map((e) => CuisineType(
                id: e.id,
                name: e.name,
              ))
          .toList(),
      filterOptions: filterOption,
      creditCardDetails: null,
    );

    diaLoading = true;
    notify;

    final status = await Handler.dashConnectChannel(req: req);
    if (status ?? false) {
      getDashboard();
    }

    diaLoading = false;
    notify;

    return status ?? false;
  }
}
