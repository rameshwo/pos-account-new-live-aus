import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:pos_account/config/size_config.dart';
import 'package:pos_account/config/validator.dart';
import 'package:pos_account/model/home/dashboard/dashboard_res.dart';
import 'com/indicator.dart';

class PieChartSample2 extends StatefulWidget {
  final Ssize size;
  final List<SalesByCategoryModel>? sales;
  const PieChartSample2({super.key, required this.size, this.sales});

  @override
  State<StatefulWidget> createState() => PieChart2State();
}

class PieChart2State extends State<PieChartSample2> {
  int touchedIndex = -1;

  final _colorList = [
    Colors.amber,
    Colors.purple,
    Colors.green,
    Colors.blue,
    Colors.cyan,
    Colors.brown,
    Colors.orange,
    Colors.indigo,
  ];

  @override
  Widget build(BuildContext context) {
    final size = widget.size;
    final sales = widget.sales;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        if (sales != null && sales.isNotEmpty)
          Flexible(
            flex: 3,
            child: PieChart(
              PieChartData(
                  pieTouchData: PieTouchData(
                      touchCallback: (FlTouchEvent event, pieTouchResponse) {
                    setState(() {
                      if (!event.isInterestedForInteractions ||
                          pieTouchResponse == null ||
                          pieTouchResponse.touchedSection == null) {
                        touchedIndex = -1;
                        return;
                      }
                      touchedIndex =
                          pieTouchResponse.touchedSection!.touchedSectionIndex;
                    });
                  }),
                  borderData: FlBorderData(
                    show: false,
                  ),
                  sectionsSpace: size.getS(2),
                  centerSpaceRadius: size.getS(28),
                  sections: showingSections(
                    sales: sales,
                  )),
            ),
          ),
        SizedBox(
          width: size.getW(12),
        ),
        Flexible(
          flex: 2,
          child: SingleChildScrollView(
            child: Column(
              // spacing: size.getW(24),
              // runSpacing: size.getH(12),
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                if (sales != null)
                  ...List.generate(
                      sales.length,
                      (index) => Padding(
                            padding: const EdgeInsets.only(bottom: 4.0),
                            child: Indicator(
                              color: _colorList[index % _colorList.length],
                              text:
                                  "${sales[index].categoryName ?? ''} (${sales[index].totalSales})",
                              isSquare: true,
                              size: size.getS(16),
                              fontSize: size.getS(13),
                            ),
                          )),
                // Indicator(
                //   color: Color(0xff0293ee),
                //   text: 'First',
                //   isSquare: true,
                //   size: size.getS(16),
                //   fontSize: size.getS(16),
                // ),
                // Indicator(
                //   color: Color(0xfff8b250),
                //   text: 'Second',
                //   isSquare: true,
                //   size: size.getS(16),
                //   fontSize: size.getS(16),
                // ),
                // Indicator(
                //   color: Color(0xff845bef),
                //   text: 'Third',
                //   isSquare: true,
                //   size: size.getS(16),
                //   fontSize: size.getS(16),
                // ),
                // Indicator(
                //   color: Color(0xff13d38e),
                //   text: 'Fourth',
                //   isSquare: true,
                //   size: size.getS(16),
                //   fontSize: size.getS(16),
                // ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  List<PieChartSectionData> showingSections({
    required List<SalesByCategoryModel> sales,
  }) {
    final size = widget.size;
    final _totalSales =
        sales.fold<double>(0, (pV, e) => pV + (e.totalSales?.inDouble ?? 0));
    return List.generate(sales.length, (i) {
      final isTouched = i == touchedIndex;
      final fontSize = size.getS(isTouched ? 25.0 : 16.0);
      final radius = size.getS(isTouched ? 124.0 : 104.0);

      final _value = _totalSales == 0
          ? 0.0
          : ((sales[i].totalSales?.inDouble ?? 0) * 100 / _totalSales);
      return PieChartSectionData(
        color: _colorList[i % _colorList.length],
        value: _value,
        title: '${_value.toStringAsFixed(1)}%',
        radius: radius,
        borderSide: BorderSide(
          width: 0.5,
          color: Colors.white,
        ),
        titleStyle: TextStyle(
            fontSize: fontSize,
            fontWeight: FontWeight.bold,
            color: const Color(0xffffffff)),
      );
      // switch (i) {
      //   case 0:
      //     return PieChartSectionData(
      //       color: const Color(0xff0293ee),
      //       value: 40,
      //       title: '40%',
      //       radius: radius,
      //       titleStyle: TextStyle(
      //           fontSize: fontSize,
      //           fontWeight: FontWeight.bold,
      //           color: const Color(0xffffffff)),
      //     );
      //   case 1:
      //     return PieChartSectionData(
      //       color: const Color(0xfff8b250),
      //       value: 30,
      //       title: '30%',
      //       radius: radius,
      //       titleStyle: TextStyle(
      //           fontSize: fontSize,
      //           fontWeight: FontWeight.bold,
      //           color: const Color(0xffffffff)),
      //     );
      //   case 2:
      //     return PieChartSectionData(
      //       color: const Color(0xff845bef),
      //       value: 15,
      //       title: '15%',
      //       radius: radius,
      //       titleStyle: TextStyle(
      //           fontSize: fontSize,
      //           fontWeight: FontWeight.bold,
      //           color: const Color(0xffffffff)),
      //     );
      //   case 3:
      //     return PieChartSectionData(
      //       color: const Color(0xff13d38e),
      //       value: 15,
      //       title: '15%',
      //       radius: radius,
      //       titleStyle: TextStyle(
      //           fontSize: fontSize,
      //           fontWeight: FontWeight.bold,
      //           color: const Color(0xffffffff)),
      //     );
      //   default:
      //     throw Error();
      // }
    });
  }
}
