import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pos_account/config/size_config.dart';
import 'package:pos_account/constant/constant.dart';
import 'package:pos_account/ln.dart';
import 'package:pos_account/providers/history/history_pro.dart';
import 'package:pos_account/screens/home_screen/com/items/tabs/setting_tab/com/general/common/table_data.dart';
import 'package:pos_account/widgets/input/dropdown/title_drop_down.dart';
import 'package:pos_account/widgets/input/text_form/title_text_form.dart';
import 'package:pos_account/widgets/load_btn.dart';
import 'package:pos_account/widgets/loading.dart';
import 'package:pos_account/widgets/no_items_sec.dart';
import 'package:provider/provider.dart';

class HIstoryTab extends StatefulWidget {
  const HIstoryTab({super.key});

  @override
  State<HIstoryTab> createState() => _HIstoryTabState();
}

class _HIstoryTabState extends State<HIstoryTab> {
  final _formKey = GlobalKey<FormState>();

  HistoryPro? _historyPro;

  @override
  void initState() {
    super.initState();
    getData();
  }

  getData() {
    _historyPro = Provider.of<HistoryPro>(context, listen: false);
    Future.delayed(Duration(milliseconds: 200), () {
      _historyPro?.clear();
      _historyPro?.getData();
    });
  }

  Future<DateTimeRange?> datePick(BuildContext context,
      {DateTimeRange? initialDateRange}) async {
    return await showDateRangePicker(
      context: context,
      firstDate: DateTime.now().subtract(Duration(days: 365)),
      lastDate: DateTime.now().add(Duration(days: 60)),
      currentDate: DateTime.now(),
      initialDateRange: initialDateRange,
    );
  }

  paginate(int page) {
    if (_historyPro == null) return;
    _historyPro!.loading = true;
    _historyPro!.notify;

    _historyPro!.searchHistory(page: page);
  }

  @override
  Widget build(BuildContext context) {
    final size = Ssize(context);
    final historyPro = Provider.of<HistoryPro>(context);
    return Padding(
      padding: EdgeInsets.symmetric(
          vertical: size.getH(8.0), horizontal: size.getW(24)),
      child: Processing(
        loading: historyPro.loading,
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      LN.history,
                      style: TextStyle(
                        fontSize: size.getS(18),
                        // fontFamily: ,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    // ElevatedButton(
                    //     style: ButtonStyle(
                    //         backgroundColor:
                    //             WidgetStateProperty.all(kPrimaryColor),
                    //         padding: WidgetStateProperty.all(EdgeInsets.symmetric(
                    //             horizontal: size.getW(12),
                    //             vertical: size.getH(8)))),
                    //     onPressed: () {},
                    //     child: Row(
                    //       mainAxisSize: MainAxisSize.min,
                    //       children: [
                    //         Icon(
                    //           Icons.keyboard_arrow_down,
                    //           color: Colors.white,
                    //           size: size.getS(24),
                    //         ),
                    //         SizedBox(
                    //           width: size.getW(6),
                    //         ),
                    //         Text(
                    //           LN.pastDays,
                    //           style: TextStyle(
                    //             fontSize: size.getS(16),
                    //             color: Colors.white,
                    //           ),
                    //         ),
                    //       ],
                    //     )),
                  ],
                ),
                SizedBox(
                  height: size.getH(12),
                ),
                Card(
                  child: SizedBox(
                    width: double.infinity,
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                          vertical: size.getH(8.0), horizontal: size.getW(24)),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Wrap(
                            spacing: size.getW(30),
                            runSpacing: size.getH(16),
                            children: [
                              TitleTextForm(
                                pWidth: 0.24,
                                title: LN.startEndDate,
                                textCltr: historyPro.startEndDateCltr,
                                borderColor: Colors.black38,
                                readOnly: true,
                                onTap: () {
                                  final _splitDate = historyPro
                                      .startEndDateCltr.text
                                      .split(' - ');
                                  if (_splitDate.first.isNotEmpty &&
                                      _splitDate.last.isNotEmpty)
                                    datePick(context,
                                        initialDateRange: DateTimeRange(
                                            start: DateFormat(
                                                    historyPro.dateOnlyFormat)
                                                .parse(_splitDate.first),
                                            end: DateFormat(
                                                    historyPro.dateOnlyFormat)
                                                .parse(
                                              _splitDate.last,
                                            ))).then((value) {
                                      if (value == null) return;

                                      historyPro.startEndDateCltr.text =
                                          "${DateFormat(historyPro.dateOnlyFormat).format(value.start)} - ${DateFormat(historyPro.dateOnlyFormat).format(value.end)}";
                                    });
                                },
                                isReq: true,
                              ),
                              TitleDropDown(
                                title: LN.paymentMethod,
                                list: historyPro.reportAddSec == null ||
                                        historyPro.reportAddSec!
                                                .paymentMethodStore ==
                                            null
                                    ? []
                                    : historyPro
                                        .reportAddSec!.paymentMethodStore!
                                        .map((e) => e.value ?? '')
                                        .toList(),
                                pWidth: 0.24,
                                indexVal: historyPro.payMethodIndex,
                                borderColor: Colors.black38,
                                isReq: true,
                                onChanged: (p0) {
                                  historyPro.payMethodIndex = p0;
                                  historyPro.notify;
                                },
                              ),
                              TitleDropDown(
                                title: LN.storeChannel,
                                list: historyPro.reportAddSec == null ||
                                        historyPro
                                                .reportAddSec!.storeChannelId ==
                                            null
                                    ? []
                                    : historyPro.reportAddSec!.storeChannelId!
                                        .map((e) => e.value ?? '')
                                        .toList(),
                                pWidth: 0.24,
                                indexVal: historyPro.storeChannelIndex,
                                borderColor: Colors.black38,
                                isReq: true,
                                onChanged: (p0) {
                                  historyPro.storeChannelIndex = p0;
                                  historyPro.notify;
                                },
                              )
                            ],
                          ),
                          Padding(
                            padding:
                                EdgeInsets.symmetric(vertical: size.getH(24.0)),
                            child: LoadButton(
                              btnText: LN.searchNow,
                              btnColor: kSecondaryColor,
                              loading: historyPro.searchLoad,
                              onsave: () {
                                if (_formKey.currentState!.validate())
                                  historyPro.searchHistory(page: 1);
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: size.getH(24),
                ),
                Text(
                  LN.historyReport,
                  style: TextStyle(
                    fontSize: size.getS(18),
                    // fontFamily: ,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                SizedBox(
                  height: size.getH(12),
                ),
                if (!historyPro.loading &&
                    historyPro.tableList.tableDataList.isEmpty)
                  NoItemsSec(size: size, title: LN.noHistoryReport)
                else
                  TableData(
                    pageSize: historyPro.pageSize,
                    tableData: historyPro.tableList,
                    paginate: paginate,
                    total: historyPro.report?.total,
                    page: historyPro.pagiPage,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
