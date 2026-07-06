import 'package:flutter/material.dart';
import 'package:pos_account/config/size_config.dart';
import 'package:pos_account/config/validator.dart';
import 'package:pos_account/constant/constant.dart';
import 'package:pos_account/ln.dart';
import 'package:pos_account/model/home/dashboard/dashboard_res.dart';
import 'product_list_chart.dart';

class ItemListChart extends StatelessWidget {
  final Ssize size;
  final List<PaymentMethodModel>? payList;
  final String curSym;
  const ItemListChart({
    super.key,
    required this.size,
    this.payList,
    required this.curSym,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ItemChartTile(
          isHeader: true,
          size: size,
          leadText: "#",
          title: LN.payMethod,
          trail: LN.sales,
        ),
        if (payList != null)
          Flexible(
            child: SingleChildScrollView(
              child: Column(
                children: List.generate(
                    payList!.length,
                    (index) => ItemChartTile(
                          size: size,
                          image: payList?[index].imageUrl == null ||
                                  payList?[index].imageUrl?.isEmpty == true
                              ? null
                              : payList?[index].imageUrl,
                          leadText: "${index + 1}",
                          title: payList?[index].paymentMethodName ?? '',
                          trail: (curSym + (payList?[index].totalSales ?? ''))
                              .negPrice(),
                          color: Colors.black,
                        )),
              ),
            ),
          )
      ],
    );
  }
}

class ItemChartTile extends StatelessWidget {
  final Ssize size;
  final String leadText;
  final String title;
  final String trail;
  final bool isHeader;
  final Color? color;
  final String? image;

  const ItemChartTile(
      {required this.size,
      required this.leadText,
      required this.title,
      required this.trail,
      this.image,
      this.color,
      this.isHeader = false,
      super.key});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      dense: true,
      visualDensity: VisualDensity.compact,
      contentPadding: EdgeInsets.symmetric(vertical: 6),
      minLeadingWidth: size.getW(10),
      minVerticalPadding: 0,
      leading: isHeader
          ? null
          : DashImageChart(
              image: image ?? "",
              size: size,
            ),
      title: Text(
        title,
        style: TextStyle(
          fontSize: size.getS(16),
          fontFamily: kFontFMedium,
          color: Colors.black54,
        ),
      ),
      trailing: Container(
        // width: color == null ? null : size.getW(60),
        margin: EdgeInsets.only(right: size.getW(4)),
        padding: EdgeInsets.symmetric(
            horizontal: size.getW(4), vertical: size.getH(4)),
        // decoration: BoxDecoration(
        //     borderRadius: BorderRadius.circular(10),
        //     color: color?.withAlpha(50),
        //     border: color == null ? null : Border.all(color: color!)),
        child: Text(
          trail,
          style: TextStyle(
            fontSize: size.getS(16),
            fontFamily: kFontFMedium,
            color: color ?? Colors.black54,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
