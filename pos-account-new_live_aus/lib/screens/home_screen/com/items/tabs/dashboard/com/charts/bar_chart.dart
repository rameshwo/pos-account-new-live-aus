import 'dart:math';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:pos_account/config/size_config.dart';
import 'package:pos_account/model/home/dashboard/dashboard_res.dart';
import 'com/month_data.dart';

class BarChartSection extends StatelessWidget {
  final Ssize size;
  final DashboardRes? dashboardRes;
  final double aspectRatio;
  const BarChartSection({
    super.key,
    required this.size,
    this.dashboardRes,
    this.aspectRatio = 2.6,
  });

  double get maxValue {
    final data = dashboardRes;
    double maxofCurrentYear = 0.0;
    double maxofPreviousYear = 0.0;

    if (data?.salesByCurrentYear != null &&
        data!.salesByCurrentYear!.isNotEmpty) {
      maxofCurrentYear = data.salesByCurrentYear!
          .map((e) {
            if (e.month?.isNotEmpty ?? false)
              return double.tryParse(e.totalSales ?? '0') ?? 0;
            else
              return 0.0;
          })
          .toList()
          .reduce(max);
    }

    if (data?.salesByPreviousYear != null &&
        data!.salesByPreviousYear!.isNotEmpty) {
      maxofPreviousYear = data.salesByPreviousYear!
          .map((e) {
            if (e.month?.isNotEmpty ?? false)
              return double.tryParse(e.totalSales ?? '0') ?? 0;
            else
              return 0.0;
          })
          .toList()
          .reduce(max);
    }
    int maxValue = 0;
    if (maxofCurrentYear > maxofPreviousYear)
      maxValue = maxofCurrentYear.round();
    else
      maxValue = maxofPreviousYear.round();
    final firstDigit = int.parse(maxValue.toString()[0]);

    if (firstDigit.isEven) {
      return ((firstDigit + 1) * pow(10, maxValue.toString().length - 1))
          .toDouble();
    } else {
      return ((firstDigit + 1) * pow(10, maxValue.toString().length - 1))
          .toDouble();
    }
  }

  static final _months = MonthData.getMonths("Jan");

  @override
  Widget build(BuildContext context) {
    final data = dashboardRes;
    final showingBarGroups = <BarChartGroupData>[
      ...List.generate(_months.length, (i) {
        String? currentTotalSales = data?.salesByCurrentYear != null &&
                data!.salesByCurrentYear!.any(
                    (a) => _months[i].name.contains(a.month!.toLowerCase()))
            ? data.salesByCurrentYear!
                .firstWhere(
                    (a) => _months[i].name.contains(a.month!.toLowerCase()))
                .totalSales
            : null;

        String? prevTotalSales = data?.salesByPreviousYear != null &&
                data!.salesByPreviousYear!.any(
                    (b) => _months[i].name.contains(b.month!.toLowerCase()))
            ? data.salesByPreviousYear!
                .firstWhere(
                    (b) => _months[i].name.contains(b.month!.toLowerCase()))
                .totalSales
            : null;

        return makeGroupData(i, double.tryParse(currentTotalSales ?? '0') ?? 0,
            double.tryParse(prevTotalSales ?? '0') ?? 0);
      })
    ];

    return AspectRatio(
      aspectRatio: aspectRatio,
      child: Padding(
        padding: EdgeInsets.only(top: size.getH(24)),
        child: maxValue == 0
            ? SizedBox.shrink()
            : BarChart(
                BarChartData(
                  maxY: maxValue,
                  // alignment:BarChartAlignment.center,
                  barTouchData: BarTouchData(
                    enabled: true,
                    touchTooltipData: BarTouchTooltipData(),
                  ),
                  titlesData: FlTitlesData(
                    show: true,
                    rightTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    topTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: bottomTitles,
                        reservedSize: size.getS(40),
                      ),
                    ),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: size.getS(52),
                        interval: maxValue < 5 ? 1 : (maxValue / 5).toDouble(),
                        getTitlesWidget: leftTitles,
                      ),
                    ),
                  ),
                  borderData: FlBorderData(
                    show: false,
                  ),
                  barGroups: showingBarGroups,
                  gridData: FlGridData(
                    show: true,
                  ),
                ),
              ),
      ),
    );
  }

  Widget leftTitles(double value, TitleMeta meta) {
    String value0 = value.round().toString();
    if (value > pow(10, 9)) {
      value0 =
          '${(value / pow(10, 9)).toStringAsFixed((value % pow(10, 9)) == 0 ? 0 : 1)}B';
    } else if (value > pow(10, 6)) {
      value0 =
          '${(value / pow(10, 6)).toStringAsFixed((value % pow(10, 6)) == 0 ? 0 : 1)}M';
    } else if (value > pow(10, 3)) {
      value0 =
          '${(value / pow(10, 3)).toStringAsFixed((value % pow(10, 3)) == 0 ? 0 : 1)}K';
    }

    final style = TextStyle(
      color: Color(0xff7589a2),
      fontWeight: FontWeight.bold,
      fontSize: size.getS(14),
    );

    return SideTitleWidget(
      space: 4,
      meta: meta,
      child: Text(
        value0,
        style: style,
        textAlign: TextAlign.end,
      ),
    );
  }

  Widget bottomTitles(double value, TitleMeta meta) {
    if (dashboardRes?.salesByCurrentYear == null &&
        dashboardRes?.salesByPreviousYear == null) return SizedBox.shrink();

    List<String> titles = _months.map((e) => e.title).toList();

    Widget text = Text(
      titles[value.toInt()],
      style: TextStyle(
        color: Color(0xff7589a2),
        fontWeight: FontWeight.bold,
        fontSize: size.getS(14),
      ),
    );

    return SideTitleWidget(
      space: 12,
      meta: meta, //margin top
      child: text,
      // angle: 45,
    );
  }

  BarChartGroupData makeGroupData(int x, double y1, double y2) {
    return BarChartGroupData(
      barsSpace: 4,
      // groupVertically: true,
      x: x,
      barRods: [
        BarChartRodData(
          toY: y1,
          color: Colors.green,
          width: size.getW(8),
        ),
        BarChartRodData(
          toY: y2,
          color: Colors.red,
          width: size.getW(8),
        ),
      ],
    );
  }
}
