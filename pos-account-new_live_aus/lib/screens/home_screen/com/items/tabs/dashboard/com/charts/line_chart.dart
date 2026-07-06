import 'dart:math';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:pos_account/config/size_config.dart';
import 'package:pos_account/model/home/dashboard/dashboard_res.dart';
import 'com/month_data.dart';

class _LineChart extends StatelessWidget {
  final List<SalesChannelModel>? sales;
  const _LineChart(
      {required this.isShowingMainData, required this.size, this.sales});

  final bool isShowingMainData;
  final Ssize size;

  @override
  Widget build(BuildContext context) {
    return LineChart(
      isShowingMainData ? sampleData1 : sampleData2,
    );
  }

  LineChartData get sampleData1 => LineChartData(
        lineTouchData: lineTouchData1,
        gridData: gridData,
        titlesData: titlesData1,
        borderData: borderData,
        lineBarsData: lineChartData1,
        minX: 0,
        maxX: MonthData.allMonths.length - 1,
        maxY: _maxValue,
        minY: 0,
      );

  LineChartData get sampleData2 => LineChartData(
        lineTouchData: lineTouchData2,
        gridData: gridData,
        titlesData: titlesData1,
        borderData: borderData,
        lineBarsData: lineChartData2,
        minX: 0,
        maxX: MonthData.allMonths.length - 1,
        maxY: _maxValue,
        minY: 0,
      );

  LineTouchData get lineTouchData1 => LineTouchData(
        handleBuiltInTouches: true,
        touchTooltipData: LineTouchTooltipData(),
      );

  FlTitlesData get titlesData1 => FlTitlesData(
        bottomTitles: AxisTitles(
          sideTitles: bottomTitles,
          axisNameWidget: Wrap(
            children: [
              if (sales != null)
                ...List.generate(
                    sales!.length,
                    (i) => Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              height: size.getS(16),
                              width: size.getS(16),
                              color: _colorList[i % _colorList.length],
                            ),
                            SizedBox(
                              width: size.getW(4),
                            ),
                            Text(
                              sales![i].channelName ?? "",
                              style: TextStyle(
                                fontSize: size.getS(18),
                              ),
                            ),
                            SizedBox(
                              width: size.getW(24),
                            )
                          ],
                        ))
            ],
          ),
        ),
        rightTitles: AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        topTitles: AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        leftTitles: AxisTitles(
          sideTitles: leftTitles(),
        ),
      );

  LineTouchData get lineTouchData2 => LineTouchData(
        enabled: false,
      );

  Widget leftTitleWidgets(double value, TitleMeta meta) {
    final style = TextStyle(
      color: Color(0xff75729e),
      fontWeight: FontWeight.bold,
      fontSize: size.getS(14),
    );

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

    return Text(value0, style: style, textAlign: TextAlign.center);
  }

  SideTitles leftTitles() => SideTitles(
        getTitlesWidget: leftTitleWidgets,
        showTitles: true,
        interval: _horizontalInterval,
        reservedSize: size.getS(48),
      );

  SideTitles get bottomTitles => SideTitles(
        showTitles: true,
        reservedSize: size.getS(48),
        interval: 1,
        getTitlesWidget: bottomTitleWidgets,
      );

  FlGridData get gridData => FlGridData(
        show: true,
        drawVerticalLine: true,
        verticalInterval: 1,
        horizontalInterval: _horizontalInterval,
      );

  FlBorderData get borderData => FlBorderData(
        show: true,
        border: Border(
          bottom: BorderSide(color: Color(0xff4e4965), width: size.getH(2)),
          left: BorderSide(color: Color(0xff4e4965).withAlpha(110)),
          right: BorderSide(color: Color(0xff4e4965).withAlpha(110)),
          top: BorderSide(color: Colors.transparent),
        ),
      );

  double get _maxValue {
    double maxCurrent = 0.0;

    if (sales != null)
      for (final a in sales!) {
        if (a.salesChannelMonthModel != null &&
            a.salesChannelMonthModel!.isNotEmpty) {
          final valCurrent = a.salesChannelMonthModel!
              .map((e) {
                if (e.month?.isNotEmpty ?? false) {
                  return double.tryParse(e.totalSales ?? '0') ?? 0;
                } else {
                  return 0.0;
                }
              })
              .toList()
              .reduce(max);
          if (valCurrent > maxCurrent) {
            maxCurrent = valCurrent;
          }
        }
      }
    int maxValue = maxCurrent.round();

    final firstDigit = int.parse(maxValue.toString()[0]);
    if (firstDigit.isEven) {
      return ((firstDigit + 2) * pow(10, maxValue.toString().length - 1))
          .toDouble();
    } else {
      return ((firstDigit + 1) * pow(10, maxValue.toString().length - 1))
          .toDouble();
    }
  }

  double get _horizontalInterval => (_maxValue / 4).round().toDouble();

  static final _colorList = [
    Colors.blue,
    Colors.green,
    Colors.indigo,
    Colors.pink,
    Colors.amber,
    Colors.orange,
    Colors.teal,
    Colors.cyan,
    Colors.lime,
    Colors.red,
    Colors.yellow,
    Colors.purple,
  ];

//Ediatable

  static final _months = MonthData.getMonths("Jan");

  Widget bottomTitleWidgets(double value, TitleMeta meta) {
    return SideTitleWidget(
      meta: meta,
      space: 10,
      child: Text(
        _months[value.toInt()].title,
        style: TextStyle(
          color: Color(0xff72719b),
          fontWeight: FontWeight.bold,
          fontSize: size.getS(16),
        ),
      ),
    );
  }

  List<List<FlSpot>> _spotList() {
    final spotsList = <List<FlSpot>>[];
    final allMonths = _months;
    if (sales != null)
      for (final e in sales!) {
        if (e.salesChannelMonthModel != null) {
          // double? _overFlowSpotX;
          final spots = List<FlSpot?>.generate(
            e.salesChannelMonthModel!.length,
            (i) {
              if (e.salesChannelMonthModel?[i].month != null) {
                final m = allMonths
                    .firstWhere((f) => f.name.contains(
                        e.salesChannelMonthModel![i].month!.toLowerCase()))
                    .id
                    .toDouble();

                // final _overFlowId = _Months._allMonths
                //     .firstWhere((a) =>
                //         e.salesChannelMonthModel![i].month!.contains(a.title))
                //     .id;
                // if (_allMonths.last.id <= _overFlowId &&
                //     e.salesChannelMonthModel!.length - 1 != i) {
                //   _overFlowSpotX = _m;
                // }

                return FlSpot(
                    m,
                    double.tryParse(e.salesChannelMonthModel![i].totalSales!) ??
                        0);
              } else
                return null;
            },
          );
          final nonNullableSpots = <FlSpot>[];
          for (final a in spots) {
            if (a != null) {
              nonNullableSpots.add(a);
              // if (a.x == _overFlowSpotX) {
              //   _nonNullableSpots.clear();
              // }
            }
          }
          spotsList.add(nonNullableSpots);
        }
      }
    return spotsList;
  }

  List<LineChartBarData> get lineChartData1 {
    final spots = _spotList();
    return List.generate(spots.length, (i) {
      return LineChartBarData(
        isCurved: true,
        color: _colorList[i % _colorList.length],
        barWidth: size.getS(6),
        isStrokeCapRound: true,
        dotData: FlDotData(show: true),
        belowBarData: BarAreaData(show: false),
        spots: spots[i],
      );
    });
  }

  List<LineChartBarData> get lineChartData2 {
    final spots = _spotList();
    return List.generate(spots.length, (i) {
      return LineChartBarData(
        isCurved: true,
        curveSmoothness: i % 2 == 0 ? 0 : 0.5,
        color: _colorList[i % _colorList.length],
        barWidth: size.getS(4),
        isStrokeCapRound: true,
        dotData: FlDotData(show: true),
        belowBarData: BarAreaData(
            show: i % 2 != 0,
            color: i % 2 != 0
                ? _colorList[i % _colorList.length].withAlpha(110)
                : null),
        spots: spots[i],
      );
    });
  }
}

class LineChartSample1 extends StatefulWidget {
  final Ssize size;
  final List<SalesChannelModel>? sales;
  const LineChartSample1({super.key, required this.size, this.sales});

  @override
  State<StatefulWidget> createState() => LineChartSample1State();
}

class LineChartSample1State extends State<LineChartSample1> {
  late bool isShowingMainData;

  @override
  void initState() {
    super.initState();
    isShowingMainData = true;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(0, 0, 16, 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Align(
            alignment: Alignment.topRight,
            child: InkWell(
              child: Icon(
                Icons.refresh,
                color: Colors.black.withAlpha(
                  isShowingMainData ? 100 : 50,
                ),
                size: widget.size.getS(28),
              ),
              onTap: () {
                setState(() {
                  isShowingMainData = !isShowingMainData;
                });
              },
            ),
          ),
          Expanded(
            child: _LineChart(
              isShowingMainData: isShowingMainData,
              size: widget.size,
              sales: widget.sales,
            ),
          ),
        ],
      ),
    );
  }
}
