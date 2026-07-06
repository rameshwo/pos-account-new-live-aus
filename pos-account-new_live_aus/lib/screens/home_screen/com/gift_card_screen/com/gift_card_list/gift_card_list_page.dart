import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pos_account/config/size_config.dart';
import 'package:pos_account/constant/constant.dart';
import 'package:pos_account/ln.dart';
import 'package:pos_account/model/home/menu/gift_card/gift_card_res.dart';
import 'package:pos_account/model/home/setting/general/category/restro_table_model.dart';
import 'package:pos_account/providers/menu/gift_card/gift_card_list_pro.dart';
import 'package:pos_account/screens/home_screen/com/items/tabs/setting_tab/com/general/common/table_data.dart';
import 'package:pos_account/widgets/input/dropdown/title_drop_down.dart';
import 'package:pos_account/widgets/input/text_form/title_text_form.dart';
import 'package:pos_account/widgets/load_btn.dart';
import 'package:pos_account/widgets/loading.dart';
import 'package:pos_account/widgets/no_items_sec.dart';
import 'package:pos_account/widgets/refresh_btn.dart';
import 'package:provider/provider.dart';

import 'com/redeem_history_dia.dart';

class GiftCardListPage extends StatefulWidget {
  const GiftCardListPage({
    super.key,
  });

  @override
  State<GiftCardListPage> createState() => _GiftCardListPageState();

  static List<Widget>? actionWidget(GiftCardData e) {
    return [
      if (e.status != null)
        Container(
          width: 100,
          decoration: BoxDecoration(
              color: getStatusColor(e.statusEnum == "4"
                      ? TableStatus.Active
                      : TableStatus.Inactive)
                  .backColor,
              borderRadius: BorderRadius.circular(5)),
          padding: EdgeInsets.symmetric(horizontal: 4, vertical: 4),
          child: Text(
            e.status ?? '',
            style: TextStyle(
              color: getStatusColor(e.statusEnum == "4"
                      ? TableStatus.Active
                      : TableStatus.Inactive)
                  .textColor,
              fontFamily: kFontFMedium,
              fontSize: 12,
            ),
            textAlign: TextAlign.center,
          ),
        )
      else
        SizedBox.shrink(),
      Builder(builder: (context) {
        return IconButton(
            onPressed: () {
              if (e.id == null) return;
              showRedeemDia(context, id: e.id ?? '');
            },
            icon: Icon(
              Icons.history,
            ));
      })
    ];
  }

  static void showRedeemDia(BuildContext ctx, {required String id}) {
    showDialog(
        context: ctx,
        builder: (builder) => SimpleDialog(
              backgroundColor: kBackgroundColor,
              titlePadding: EdgeInsets.zero,
              contentPadding: EdgeInsets.symmetric(horizontal: 24),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15)),
              children: [
                RedeemHistoryDia(
                  giftId: id,
                ),
              ],
            ));
  }
}

class _GiftCardListPageState extends State<GiftCardListPage> {
  @override
  void initState() {
    getData();
    super.initState();
  }

  GiftCardListPro? _giftCardListPro;

  void getData() {
    _giftCardListPro = Provider.of<GiftCardListPro>(context, listen: false);
    _giftCardListPro?.init();
    _giftCardListPro?.getSearchData();
    _giftCardListPro?.getData();
  }

  void pagination(int page) {
    if (_giftCardListPro != null) {
      _giftCardListPro!.pageLoad = true;
      _giftCardListPro!.notify;

      _giftCardListPro!.getData(page: page);
    }
  }

  @override
  void dispose() {
    _giftCardListPro?.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final pro = Provider.of<GiftCardListPro>(context);
    final size = Ssize(context);
    return Processing(
      loading: pro.pageLoad,
      child: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: double.infinity,
              child: Card(
                child: Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: size.getW(18), vertical: size.getH(24)),
                  child: Wrap(
                    spacing: size.getW(18),
                    runSpacing: size.getH(16),
                    crossAxisAlignment: WrapCrossAlignment.end,
                    children: [
                      TitleTextForm(
                        title: LN.giftCardNo,
                        pWidth: 0.10,
                        isReq: false,
                        borderColor: Colors.black38,
                        textCltr: pro.giftCardCltr,
                      ),
                      TitleTextForm(
                        title: LN.receiverName,
                        pWidth: 0.15,
                        isReq: false,
                        borderColor: Colors.black38,
                        textCltr: pro.receiverNameCltr,
                      ),
                      TitleDropDown(
                        pWidth: 0.15,
                        borderColor: Colors.black38,
                        title: LN.status,
                        list: pro.giftCardSearchSec?.giftCardStatus == null
                            ? []
                            : pro.giftCardSearchSec!.giftCardStatus!
                                .map((e) => e.value ?? '')
                                .toList(),
                        indexVal: pro.giftStatusIndex,
                        onChanged: (p0) {
                          pro.giftStatusIndex = p0;
                          pro.notify;
                        },
                      ),
                      _expiryDateSec(pro, context),
                      LoadButton(
                        vPad: 11,
                        width: 160,
                        hPad: 2,
                        btnText: LN.search,
                        loading: pro.isSearching,
                        loadingText: LN.searching,
                        onsave: pro.isSearching
                            ? null
                            : () {
                                pro.isSearching = true;
                                pro.pageLoad = true;
                                pro.notify;
                                pro.getData();
                              },
                      ),
                      RefreshBtn(
                        size: size,
                        onTap: pro.pageLoad
                            ? null
                            : () {
                                pro.clear();
                                pro.notify;
                                pro.init();
                                pro.getSearchData();
                                pro.getData();
                              },
                      )
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(
              width: double.infinity,
              child: Card(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(
                          left: size.getW(12), top: size.getH(12)),
                      child: Text(
                        LN.giftCardList,
                        style: TextStyle(
                          fontSize: size.getS(18),
                          fontFamily: kFontFMedium,
                          color: kPrimaryColor,
                        ),
                      ),
                    ),
                    if (pro.tableList.tableDataList.isEmpty && !pro.pageLoad)
                      Align(
                        alignment: Alignment.topCenter,
                        child: NoItemsSec(
                          size: size,
                          title: LN.noGiftFound,
                        ),
                      )
                    else
                      TableData(
                        tableData: pro.tableList,
                        paginate: pagination,
                        total: pro.allGiftCardRes?.total,
                        page: pro.pageIndex,
                        sortColumnIndex: 1,
                        showDeleteBtn: false,
                      ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  ///DateRange Picker

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

  String _getDateonly(String val) {
    return DateFormat(_giftCardListPro?.dateFormat?.onlyDate())
        .format(DateFormat(_giftCardListPro?.dateFormat).parse(val));
  }

  TitleTextForm _expiryDateSec(GiftCardListPro pro, BuildContext context) {
    final showText = pro.expiryDateCltr.text;
    final textCltr = TextEditingController(
        text: showText.isEmpty || showText.split(' - ').isEmpty
            ? null
            : '${_getDateonly(showText.split(' - ').first)} - ${_getDateonly(showText.split(' - ').last)}');

    return TitleTextForm(
      title: LN.expiryDate,
      pWidth: 0.16,
      isReq: false,
      borderColor: Colors.black38,
      textCltr: textCltr,
      readOnly: true,
      onTap: () {
        final text = pro.expiryDateCltr.text;

        datePick(context,
                initialDateRange: text.isEmpty || text.split(' - ').isEmpty
                    ? null
                    : DateTimeRange(
                        start: DateFormat(pro.dateFormat)
                            .parse(text.split(' - ').first),
                        end: DateFormat(pro.dateFormat).parse(
                          text.split(' - ').last,
                        )))
            .then((value) {
          if (value == null) return;

          pro.expiryDateCltr.text =
              "${DateFormat(pro.dateFormat).format(value.start)} - ${DateFormat(pro.dateFormat).format(value.end)}";
          pro.notify;
        });
      },
    );
  }
}

extension StringExtension on String {
  String onlyDate() {
    if (isEmpty) {
      return this;
    }
    return replaceAll('HH:mm:ss', '').trim();
  }
}
