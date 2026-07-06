import 'package:flutter/material.dart';
import 'package:pos_account/config/size_config.dart';
import 'package:pos_account/constant/constant.dart';
import 'package:pos_account/providers/booking/table_resv_pro.dart';
import 'package:provider/provider.dart';

class BookingDrawer extends StatelessWidget {
  const BookingDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final size = Ssize(context);
    final tableResv = Provider.of<TableResvPro>(context);
    return Container(
      decoration: BoxDecoration(
        color: kPrimaryColor,
        borderRadius: BorderRadius.all(
          Radius.circular(4),
        ),
      ),
      child: Column(
        children: [
          SizedBox(height: size.getH(16)),
          if (tableResv.tableResvAddSec?.orderChannels?.isNotEmpty ?? false)
            ...List.generate(
              tableResv.tableResvAddSec!.orderChannels!.length,
              (index) => InkWell(
                onTap: tableResv.loadiing
                    ? null
                    : () {
                        tableResv.deOrderChIndex = index;
                        tableResv.loadiing = true;
                        tableResv.notify;
                        tableResv.getAllTableResv();
                      },
                child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(
                      horizontal: size.getW(12), vertical: size.getH(12)),
                  decoration: BoxDecoration(
                    color: tableResv.deOrderChIndex == index
                        ? kSecondaryColor
                        : null,
                    // border: Border.all(
                    //   color: kSecondaryColor,
                    // ),
                  ),
                  child: Text(
                    tableResv.tableResvAddSec!.orderChannels![index].name ?? '',
                    style: TextStyle(
                      fontSize: size.getS(20),
                      color: tableResv.deOrderChIndex == index
                          ? Colors.white
                          : Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          SizedBox(height: size.getH(16)),
          Divider(
            color: Colors.white,
            thickness: 1.2,
          ),
          SizedBox(height: size.getH(16)),
        ],
      ),
    );
  }
}
