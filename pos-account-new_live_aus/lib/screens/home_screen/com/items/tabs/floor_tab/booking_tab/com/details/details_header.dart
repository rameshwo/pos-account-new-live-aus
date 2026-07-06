import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pos_account/config/size_config.dart';
import 'package:pos_account/config/utils/utils.dart';
import 'package:pos_account/constant/constant.dart';
import 'package:pos_account/ln.dart';
import 'package:pos_account/providers/booking/table_resv_pro.dart';
import 'package:pos_account/providers/cus_val_pro.dart';
import 'package:pos_account/widgets/input/dropdown/title_drop_down.dart';
import 'package:pos_account/widgets/input/text_form/text_form_widget.dart';
import 'package:pos_account/widgets/refresh_btn.dart';

import '../../booking_tab.dart';

class DetailsHeader extends StatelessWidget {
  final Ssize size;
  final TableResvPro tableResv;
  final GlobalKey<ScaffoldState>? scafKey;
  const DetailsHeader(
      {super.key, required this.size, required this.tableResv, this.scafKey});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Expanded(
          child: Row(
            // alignment: WrapAlignment.end,
            // spacing: size.getW(12),
            // runSpacing: size.getW(12),
            // crossAxisAlignment: WrapCrossAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              // Flexible(
              //   child: SizedBox(
              //     width: size.getW(160),
              //     child: TitleDropDown(
              //       title: "Order Channel",
              //       titleFontSize: 16,
              //       titleGap: 4,
              //       vPad: 10,
              //       // hPad: 0,
              //       hintText: LN.channel,
              //       indexVal: tableResv.deOrderChIndex,
              //       list: (tableResv.tableResvAddSec == null ||
              //               tableResv.tableResvAddSec!.orderChannels == null)
              //           ? []
              //           : tableResv.tableResvAddSec!.orderChannels!
              //               .map((e) => e.value ?? '')
              //               .toList(),
              //       borderRadius: 5,
              //       // textColor: Colors.white,
              //       // fillColor: kPrimaryColor,
              //       // dropDownColor: kPrimaryColor,
              //       borderColor: Colors.black26,
              //       // iconEnableColor: Colors.white,
              //       // hintTextColor: Colors.white,
              //       fontWeight: FontWeight.bold,
              //       onChanged: (p0) {
              //         tableResv.deOrderChIndex = p0;
              //         tableResv.loadiing = true;
              //         tableResv.notify;
              //         tableResv.getAllTableResv();
              //       },
              //     ),
              //   ),
              // ),
              // SizedBox(width: size.getW(12)),
              Flexible(
                child: SizedBox(
                  width: size.getW(160),
                  child: TitleDropDown(
                    title: "Table",
                    titleFontSize: 16,
                    titleGap: 4,
                    vPad: 10,
                    hintText: LN.tables,
                    indexVal: tableResv.deTableIndex,
                    list: (tableResv.tableResvAddSec == null ||
                            tableResv.tableResvAddSec!.tables == null)
                        ? []
                        : tableResv.tableResvAddSec!.tables!
                            .map((e) => e.name ?? '')
                            .toList(),
                    borderRadius: 5,
                    // textColor: Colors.white,
                    // fillColor: kPrimaryColor,
                    // dropDownColor: kPrimaryColor,
                    borderColor: Colors.black26,
                    // iconEnableColor: Colors.white,
                    // hintTextColor: Colors.white,
                    fontWeight: FontWeight.bold,
                    onChanged: (p0) {
                      tableResv.deTableIndex = p0;
                      tableResv.loadiing = true;
                      tableResv.notify;
                      tableResv.getAllTableResv();
                    },
                  ),
                ),
              ),
              SizedBox(width: size.getW(12)),
              Flexible(
                child: SizedBox(
                  width: size.getW(160),
                  child: TitleDropDown(
                    title: "Table Status",
                    titleFontSize: 16,
                    titleGap: 4,
                    vPad: 10,
                    hintText: LN.status,
                    indexVal: tableResv.deStatusIndex,
                    list: (tableResv.tableResvAddSec == null ||
                            tableResv.tableResvAddSec!.tableReservationStatus ==
                                null)
                        ? []
                        : tableResv.tableResvAddSec!.tableReservationStatus!
                            .map((e) => e.value ?? '')
                            .toList(),
                    borderRadius: 5,
                    // textColor: Colors.white,
                    // fillColor: kPrimaryColor,
                    // dropDownColor: kPrimaryColor,
                    borderColor: Colors.black26,
                    // iconEnableColor: Colors.white,
                    // hintTextColor: Colors.white,
                    fontWeight: FontWeight.bold,
                    onChanged: (p0) {
                      tableResv.deStatusIndex = p0;
                      tableResv.loadiing = true;
                      tableResv.notify;
                      tableResv.getAllTableResv();
                    },
                  ),
                ),
              ),
              SizedBox(width: size.getW(12)),
              Flexible(
                child: SizedBox(
                  width: size.getW(160),
                  child: TextFormWidget(
                    vPad: 10,
                    isReq: false,
                    readOnly: true,
                    borderRadius: 5,
                    borderColor: Colors.black12,
                    cltr: tableResv.dateCltr,
                    hintText: LN.chooseDate,
                    onTap: () {
                      Utils.datePick(context).then((_date) {
                        if (_date == null) return;
                        tableResv.dateCltr.text =
                            DateFormat(tableResv.dateFormat?.split(' ').first)
                                .format(_date);
                        tableResv.loadiing = true;
                        tableResv.notify;
                        tableResv.getAllTableResv();
                      });
                    },
                  ),
                ),
              ),
              SizedBox(width: size.getW(12)),
              Flexible(
                child: SizedBox(
                  width: size.getW(200),
                  child: TextFormWidget(
                    vPad: 10,
                    isReq: false,
                    prefixIcon: Icon(
                      Icons.search,
                      size: size.getS(32),
                    ),
                    borderRadius: 5,
                    borderColor: Colors.black12,
                    cltr: tableResv.searchCltr,
                    hintText: LN.search,
                    onChanged: (p0) {
                      Utils.handleSearch(callback: () async {
                        tableResv.loadiing = true;
                        tableResv.notify;
                        await tableResv.getAllTableResv();
                      });
                    },
                  ),
                ),
              ),
              SizedBox(width: size.getW(12)),
              if (GlobalCVP.viewWidget.viewTableBookingRefreshButton)
                RefreshBtn(
                  size: size,
                  onTap: () {
                    tableResv.clear2();
                    tableResv.loadiing = true;
                    tableResv.notify;
                    tableResv.getAllTableResv();
                  },
                ),
            ],
          ),
        ),
        ElevatedButton(
            style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(kSecondaryColor),
                padding: MaterialStateProperty.all(EdgeInsets.symmetric(
                    horizontal: size.getW(24), vertical: size.getH(8)))),
            onPressed: tableResv.loadiing
                ? null
                : () {
                    // BookingTab.showTableLayoutDia(context,
                    //         size: size)
                    //     .then((value) {
                    //   if (value != null && value is String) {
                    tableResv.clear();
                    tableResv.getCountryList();

                    // if (tableResv.tables.any((e) =>
                    //     e.id?.toLowerCase() ==
                    //     value.toLowerCase())) {
                    //   tableResv.tableNoIndex =
                    //       tableResv.tables.indexWhere((e) =>
                    //           e.id?.toLowerCase() ==
                    //           value.toLowerCase());
                    // }
                    BookingTab.showBookingDia(
                      context,
                      size: size,
                      scafKey: scafKey,
                    );
                    //   }
                    // });
                  },
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.add,
                  size: size.getS(25),
                  color: Colors.white,
                ),
                SizedBox(
                  width: size.getW(8),
                ),
                Text(
                  LN.newBooking,
                  style: TextStyle(
                    fontSize: size.getS(16),
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                )
              ],
            ))
      ],
    );
  }
}
