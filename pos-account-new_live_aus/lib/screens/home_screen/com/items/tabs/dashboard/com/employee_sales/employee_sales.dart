import 'package:flutter/material.dart';
import 'package:pos_account/config/size_config.dart';
import 'package:pos_account/config/validator.dart';
import 'package:pos_account/constant/constant.dart';
import 'package:pos_account/model/home/dashboard/dashboard_res.dart';
import 'package:pos_account/providers/dashboard/dashboard_pro.dart';

class EmployeeSales extends StatefulWidget {
  final DashboardPro dashPro;
  const EmployeeSales({
    super.key,
    required this.dashPro,
  });

  @override
  State<EmployeeSales> createState() => _EmployeeSalesState();
}

class _EmployeeSalesState extends State<EmployeeSales> {
  final ScrollController _scrollController = ScrollController();

  bool _scrollingDown = true;

  @override
  void initState() {
    super.initState();
    _scroll();
  }

  void _scroll() async {
    while (true) {
      await Future.delayed(Duration(seconds: 3));
      if (_scrollingDown) {
        if (_scrollController.hasClients)
          await _scrollController.animateTo(
            _scrollController.position.maxScrollExtent,
            duration: Duration(seconds: 10),
            curve: Curves.linear,
          );
      } else {
        if (_scrollController.hasClients)
          await _scrollController.animateTo(
            _scrollController.position.minScrollExtent,
            duration: Duration(seconds: 2),
            curve: Curves.easeInOut,
          );
      }
      _scrollingDown = !_scrollingDown;
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = Ssize(context);
    final sales = widget.dashPro.dashboardRes?.employeeSalesModel;
    return SingleChildScrollView(
      padding: EdgeInsets.only(top: size.getH(16)),
      physics: BouncingScrollPhysics(),
      scrollDirection: Axis.horizontal,
      controller: _scrollController,
      child: Row(
        children: [
          if (sales != null)
            ...List.generate(sales.length,
                (index) => _salesSection(size, sale: sales[index]))
        ],
      ),
    );
  }

  Widget _salesSection(
    Ssize size, {
    EmployeeSalesModel? sale,
  }) {
    return Container(
      margin: EdgeInsets.only(right: size.getW(24)),
      width: size.getW(260),
      height: size.getH(240),
      decoration: BoxDecoration(
        color: kSecondaryColor.withOpacity(0.02),
        border: Border.all(color: Colors.black12),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          SizedBox(
            width: size.getW(12),
          ),
          CircleAvatar(
            backgroundColor: kSecondaryColor,
            radius: size.getS(32),
            child: Padding(
                padding: EdgeInsets.all(size.getS(2)),
                child: Text(
                  (sale?.employeeName?.isNotEmpty ?? false)
                      ? (sale?.employeeName?[0].toUpperCase() ?? '')
                      : '',
                  style: TextStyle(
                    fontSize: size.getS(32),
                    fontFamily: kFontFRegular,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                  maxLines: 1,
                  textAlign: TextAlign.center,
                )),
          ),
          SizedBox(width: size.getW(12)),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                sale?.employeeName ?? '',
                style: TextStyle(
                  fontSize: size.getS(20),
                  fontFamily: kFontFRegular,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                widget.dashPro.curSym + (sale?.netSales ?? '0.00'),
                style: TextStyle(
                  fontSize: size.getS(32),
                  fontFamily: kFontFRegular,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                '${sale?.orderItemCount?.inDouble == 0 ? 'No' : (sale?.orderItemCount ?? 'No')} service today',
                style: TextStyle(
                  fontSize: size.getS(20),
                  fontFamily: kFontFMedium,
                  color: Colors.black54,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
