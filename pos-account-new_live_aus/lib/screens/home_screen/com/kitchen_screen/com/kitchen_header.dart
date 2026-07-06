import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pos_account/config/responsive.dart';
import 'package:pos_account/config/size_config.dart';
import 'package:pos_account/config/utils/utils.dart';
import 'package:pos_account/constant/constant.dart';
import 'package:pos_account/ln.dart';
import 'package:pos_account/providers/kitchen/kitchen_pro.dart';
import 'package:pos_account/widgets/input/dropdown/title_drop_down.dart';
import 'package:pos_account/widgets/input/text_form/text_form_widget.dart';
import 'package:pos_account/widgets/refresh_btn.dart';

class KitchenHeader extends StatelessWidget {
  final KitchenPro kitPro;
  const KitchenHeader({super.key, required this.kitPro});

  @override
  Widget build(BuildContext context) {
    final size = Ssize(context);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        SizedBox(
          width: size.getW(24),
        ),
        if (kitPro.orderDetailSecRes?.orderStatus != null)
          ...List.generate(
            kitPro.orderDetailSecRes!.orderStatus!.length,
            (index) => Padding(
              padding:
                  EdgeInsets.only(right: size.getW(12.0), bottom: size.getH(0)),
              child: ElevatedButton(
                  style: ButtonStyle(
                      backgroundColor: WidgetStateProperty.all(
                          kitPro.channelStatusIndex == index
                              ? kSecondaryColor
                              : kTempColor),
                      padding: WidgetStateProperty.all(EdgeInsets.symmetric(
                          horizontal: size.getW(12), vertical: size.getH(9)))),
                  onPressed: () {
                    kitPro.channelStatusIndex = index;
                    kitPro.orderList.clear();
                    kitPro.setDefaultDate();
                    kitPro.loading = true;
                    kitPro.notify;
                    kitPro.getData();
                  },
                  child: Text(
                    kitPro.orderDetailSecRes!.orderStatus![index].value ?? '',
                    style: TextStyle(
                      fontSize: size.getS(16),
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  )),
            ),
          ),
        Expanded(
          child: Align(
            alignment: Alignment.centerRight,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  SizedBox(
                    width: size.getW(150),
                    child: TitleDropDown(
                      title: "Order Channel",
                      titleFontSize: 16,
                      titleGap: 4,
                      hintText: LN.orderChannel,
                      indexVal: kitPro.channelIndex,
                      list: kitPro.orderDetailSecRes?.orderChannels == null
                          ? []
                          : kitPro.orderDetailSecRes!.orderChannels!
                              .map((e) => e.name ?? '')
                              .toList(),
                      borderRadius: 5,
                      borderColor: Colors.black26,
                      fontWeight: FontWeight.bold,
                      onChanged: (p0) {
                        kitPro.channelIndex = p0;
                        // kitPro.orderTypeIndex = 0;
                        // kitPro.channelStatusIndex = 0;
                        kitPro.loading = true;
                        kitPro.notify;
                        kitPro.getData();
                      },
                    ),
                  ),
                  SizedBox(
                    width: size.getW(12),
                  ),
                  SizedBox(
                    width: size.getW(150),
                    child: TitleDropDown(
                      title: "Order Type",
                      titleFontSize: 16,
                      titleGap: 4,
                      hintText: LN.orderType,
                      indexVal: kitPro.orderTypeIndex,
                      list: kitPro.orderDetailSecRes?.orderTypes == null
                          ? []
                          : kitPro.orderDetailSecRes!.orderTypes!
                              .map((e) => e.name ?? '')
                              .toList(),
                      borderRadius: 5,
                      fontWeight: FontWeight.bold,
                      borderColor: Colors.black26,
                      onChanged: (p0) {
                        kitPro.orderTypeIndex = p0;
                        kitPro.loading = true;
                        kitPro.notify;
                        kitPro.getData();
                      },
                      // hPad: 0,
                    ),
                  ),
                  SizedBox(
                    width: size.getW(12),
                  ),
                  // if (!kitPro.isRetail)
                  SizedBox(
                    width: size.getW(150),
                    child: TitleDropDown(
                      title: "Table",
                      titleFontSize: 16,
                      titleGap: 4,
                      hintText: LN.tableNumber,
                      indexVal: kitPro.tableIndex,
                      list: kitPro.orderDetailSecRes == null ||
                              kitPro.orderDetailSecRes!.tables == null
                          ? []
                          : kitPro.orderDetailSecRes!.tables!
                              .map((e) => e.value ?? '')
                              .toList(),
                      borderRadius: 5,
                      fontWeight: FontWeight.bold,
                      borderColor: Colors.black26,
                      onChanged: (p0) {
                        kitPro.tableIndex = p0;
                        kitPro.loading = true;
                        kitPro.notify;
                        kitPro.getData();
                      },
                    ),
                  ),
                  // SizedBox(
                  //   width: size.width * 0.077,
                  // ),

                  SizedBox(
                    width: size.getW(12),
                  ),
                  SizedBox(
                    width: size.getW(160),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text.rich(
                          TextSpan(
                            text: kitPro.kitOrderStatus ==
                                    KitOrderStatusEnum.Completed
                                ? LN.preparedDate
                                : LN.orderedDate,
                            style: TextStyle(
                              fontSize: size.getS(16),
                              color: Colors.black,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: size.getH(4),
                        ),
                        TextFormWidget(
                          isReq: false,
                          readOnly: true,
                          borderRadius: 5,
                          borderColor: Colors.black12,
                          cltr: kitPro.dateCltr,
                          hintText: LN.chooseDate,
                          vPad: Responsive.isDesktop(context) ? 10 : 8,
                          onTap: () {
                            Utils.datePick(context,
                                    initDate: kitPro.dateCltr.text.isNotEmpty
                                        ? DateFormat(kitPro.dateFormat
                                                ?.split(' ')
                                                .first)
                                            .parse(kitPro.dateCltr.text)
                                        : null)
                                .then((date) {
                              if (date == null) return;
                              kitPro.dateCltr.text = DateFormat(
                                      kitPro.dateFormat?.split(' ').first)
                                  .format(date);
                              kitPro.loading = true;
                              kitPro.notify;
                              kitPro.getData();
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    width: size.getW(12),
                  ),
                  SizedBox(
                    width: size.getW(240),
                    child: TextFormWidget(
                      borderColor: Colors.black12,
                      borderRadius: 5,
                      prefixIcon: Icon(
                        Icons.search,
                        color: Colors.grey,
                        size: size.getS(24),
                      ),
                      vPad: Responsive.isDesktop(context) ? 10 : 12.5,
                      cltr: kitPro.searchCltr,
                      hintText: LN.orderNumber,
                      onChanged: (p0) {
                        Utils.handleSearch(callback: () async {
                          kitPro.loading = true;
                          kitPro.notify;
                          await kitPro.getData();
                        });
                      },
                    ),
                  ),
                  SizedBox(
                    width: size.getW(12),
                  ),
                  // if (GlobalCVP.viewWidget.viewOrdersRefreshButton))
                  RefreshBtn(
                    size: size,
                    onTap: kitPro.loading
                        ? null
                        : () {
                            kitPro.loading = true;
                            kitPro.channelIndex = 0;
                            kitPro.orderTypeIndex = 0;
                            kitPro.tableIndex = 0;
                            // kitPro.channelStatusIndex = 0;
                            kitPro.searchCltr.clear();
                            kitPro.setDefaultDate();

                            // orderPro.isRefresh = true;
                            // kitPro.orderList.clear();
                            kitPro.notify;
                            kitPro.getData();
                          },
                  )
                ],
              ),
            ),
          ),
        ),
        SizedBox(
          width: size.getW(24),
        ),
      ],
    );
  }
}
