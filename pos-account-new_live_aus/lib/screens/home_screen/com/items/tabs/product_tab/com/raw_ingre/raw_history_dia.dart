import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:oktoast/oktoast.dart';
import 'package:pos_account/config/size_config.dart';
import 'package:pos_account/config/utils/utils.dart';
import 'package:pos_account/config/validator.dart';
import 'package:pos_account/ln.dart';
import 'package:pos_account/providers/product/new_product_pro.dart';
import 'package:pos_account/screens/home_screen/com/items/tabs/setting_tab/com/general/common/table_data.dart';
import 'package:pos_account/widgets/loading.dart';
import 'package:pos_account/widgets/no_items_sec.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../../../../../../../providers/cus_val_pro.dart';
import '../../../../../../../../services/database/shared_pref.dart';
import '../../../../../../../../widgets/input/text_form/title_text_form.dart';
import '../../../../../../../../widgets/load_btn.dart';

class RawHistoryDia extends StatefulWidget {
  final Function()? onEdit;
  final String ingreName;
  final String unit;
  const RawHistoryDia(
      {super.key, this.onEdit, required this.ingreName, required this.unit});

  @override
  State<RawHistoryDia> createState() => _RawHistoryDiaState();
}

class _RawHistoryDiaState extends State<RawHistoryDia> {
  NewProductPro? _newProdPro;
  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  final ScrollController _scrollCltr = ScrollController();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    getDateFormat().then((value) {
      getData();
    });

    super.initState();
  }

  String? _dateFormat;
  getDateFormat() async {
    _dateFormat = await SharedPrefs.dateFormat;
  }

  Future<void> getData() {
    _newProdPro = Provider.of<NewProductPro>(context, listen: false);
    if (_newProdPro != null) _newProdPro!.getAllRawIngreHistory(page: 1);
    _newProdPro?.hisDateCltr.text =
        DateFormat(_dateFormat!).format(DateTime.now());
    return Future.value();
  }

  paginate(int page) {
    if (_newProdPro != null) {
      _newProdPro!.getAllRawIngreHistory(page: page).then((value) {
        _refreshController.loadComplete();
        _refreshController.refreshCompleted();
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
    _newProdPro?.clearRawHistorySec();
    _newProdPro?.clearIngreSec();
  }

  @override
  Widget build(BuildContext context) {
    final size = Ssize(context);
    final newProdPro = Provider.of<NewProductPro>(context);
    return Processing(
      loading: newProdPro.rawIngreHistoryLoad,
      child: Container(
        constraints: BoxConstraints(
          maxHeight: size.height / 1.14,
          minHeight: size.height / 5,
        ),
        width: size.width / 1.2,
        child: Padding(
          padding: EdgeInsets.symmetric(
              horizontal: size.width * 0.01, vertical: size.height * 0.02),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: size.getH(12),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      widget.ingreName,
                      style: TextStyle(
                        fontSize: size.getS(24),
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: Icon(Icons.close))
                  ],
                ),
                Expanded(
                  child: Container(
                    width: size.width,
                    padding: EdgeInsets.symmetric(
                        horizontal: size.width * 0.01,
                        vertical: size.height * 0.02),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius:
                          BorderRadius.vertical(top: Radius.circular(8)),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 1,
                          blurRadius: 7,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Scrollbar(
                      controller: _scrollCltr,
                      // isAlwaysShown: true,
                      // showTrackOnHover: true,
                      interactive: true,
                      thickness: 8,
                      radius: Radius.circular(40),
                      child: SingleChildScrollView(
                        controller: _scrollCltr,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Wrap(
                              spacing: size.getW(24),
                              runSpacing: size.getH(24),
                              alignment: WrapAlignment.start,
                              crossAxisAlignment: WrapCrossAlignment.start,
                              children: [
                                TitleTextForm(
                                  title: 'Actual Stock',
                                  pWidth: 0.22,
                                  isReq: true,
                                  textInputType: TextInputType.number,
                                  textCltr: newProdPro.rawHisActualStockCltr,
                                  borderColor: Colors.black26,
                                  suffix: widget.unit.isNotEmpty
                                      ? Container(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: size.getW(12)),
                                          child: Text(
                                            widget.unit,
                                            style: TextStyle(
                                              fontSize: size.getS(14),
                                              color: Colors.black54,
                                            ),
                                          ),
                                        )
                                      : null,
                                  onChanged: (val) {
                                    if (val!.isEmpty) return;
                                    newProdPro.rawHisWastageStockCltr
                                        .text = (newProdPro
                                                .rawHisActualStockCltr
                                                .text
                                                .inDouble *
                                            (newProdPro
                                                    .rawHisWastagePercentageCltr
                                                    .text
                                                    .inDouble /
                                                100))
                                        .roundToNString();
                                  },
                                ),
                                TitleTextForm(
                                  title: 'Wastage %',
                                  pWidth: 0.22,
                                  isReq: true,
                                  textInputType: TextInputType.number,
                                  textCltr:
                                      newProdPro.rawHisWastagePercentageCltr,
                                  borderColor: Colors.black26,
                                  onChanged: (val) {
                                    if (val!.isEmpty) return;
                                    newProdPro.rawHisWastageStockCltr.text =
                                        (newProdPro.rawHisActualStockCltr.text
                                                    .inDouble *
                                                (double.parse(val) / 100))
                                            .roundToNString();
                                    newProdPro.notify;
                                  },
                                ),
                                TitleTextForm(
                                  title: 'Wastage Stock',
                                  pWidth: 0.22,
                                  isReq: false,
                                  readOnly: true,
                                  textInputType: TextInputType.number,
                                  textCltr: newProdPro.rawHisWastageStockCltr,
                                  borderColor: Colors.black26,
                                  suffix: widget.unit.isNotEmpty
                                      ? Container(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: size.getW(12)),
                                          child: Text(
                                            widget.unit,
                                            style: TextStyle(
                                              fontSize: size.getS(14),
                                              color: Colors.black54,
                                            ),
                                          ),
                                        )
                                      : null,
                                ),
                                TitleTextForm(
                                  title: LN.date,
                                  isDense: true,
                                  isReq: true,
                                  readOnly: true,
                                  errH: 0,
                                  borderColor: Colors.black54,
                                  borderRadius: 5,
                                  textCltr: TextEditingController(
                                    text: newProdPro.hisDateCltr.text.isEmpty
                                        ? DateFormat(_dateFormat)
                                            .format(DateTime.now())
                                            .toString()
                                            .split(" ")[0]
                                        : newProdPro.hisDateCltr.text
                                            .toString()
                                            .split(" ")[0],
                                  ),
                                  hintText: LN.chooseDate,
                                  textInputType: TextInputType.text,
                                  suffixIcon:
                                      Icon(Icons.calendar_month_outlined),
                                  suffixIconWidth: 36,
                                  // hintStyle: TextStyle(fontSize: size.getS(14)),
                                  onTap: () async {
                                    final _dateFormat =
                                        await SharedPrefs.dateFormat;
                                    Utils.datePick(
                                      context,
                                      initDate: DateTime.now(),
                                    ).then((_date) {
                                      if (_date == null) return;
                                      newProdPro.hisDateCltr.text =
                                          DateFormat(_dateFormat).format(_date);
                                      newProdPro.notify;
                                    });
                                  },
                                ),
                                TitleTextForm(
                                  title: LN.description,
                                  pWidth: 0.22,
                                  isReq: false,
                                  textInputType: TextInputType.text,
                                  textCltr: newProdPro.rawHisDescriptionCltr,
                                  borderColor: Colors.black26,
                                ),

                                //unit
                              ],
                            ),
                            SizedBox(
                              height: size.getH(24),
                            ),
                            Row(
                              children: [
                                if (GlobalCVP.viewWidget.viewAddProductButton)
                                  LoadButton(
                                    hPad: 2,
                                    onsave: newProdPro.loading
                                        ? null
                                        : () {
                                            if (_formKey.currentState!
                                                .validate()) {
                                              newProdPro
                                                  .addRawLooseIngredientStockHistory();
                                            } else {
                                              FocusScope.of(context).unfocus();
                                              showToast(LN.invalidInput);
                                            }
                                          },
                                    loading: newProdPro.loading,
                                    btnText: LN.save,
                                    width: 230,
                                  ),
                                SizedBox(
                                  width: size.getW(12),
                                ),
                                LoadButton(
                                  width: 120,
                                  hPad: 2,
                                  btnColor: Colors.red.shade700,
                                  onsave: () {
                                    newProdPro.clearRawHistorySec(all: false);
                                    newProdPro.notify;
                                    newProdPro.rawIngreHistoryLoad = false;
                                    Navigator.pop(context);
                                  },
                                  loading: newProdPro.loading,
                                  btnText: LN.cancel,
                                ),
                              ],
                            ),
                            SizedBox(
                              height: size.getH(24),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                    child: SmartRefresher(
                        controller: _refreshController,
                        enablePullDown: true,
                        onRefresh: () {
                          newProdPro.rawIngreHistoryLoad = true;
                          newProdPro.notify;
                          paginate(1);
                        },
                        child: ListView(
                          padding:
                              EdgeInsets.symmetric(horizontal: size.getW(12)),
                          children: [
                            SizedBox(
                              height: size.getH(12),
                            ),
                            newProdPro.rawIngreHistoryTableList.tableDataList
                                        .isEmpty &&
                                    !newProdPro.rawIngreHistoryLoad
                                ? NoItemsSec(
                                    size: size,
                                    title:
                                        "${LN.no} ${LN.rawIngre} ${LN.history}",
                                  )
                                : TableData(
                                    paginate: paginate,
                                    tableData:
                                        newProdPro.rawIngreHistoryTableList,
                                    total: newProdPro
                                            .allRawIngreHistoryRes?.total ??
                                        0,
                                    page: newProdPro.getRawHisPage,
                                    pageSize: newProdPro.getRawHisPageSize,
                                    sortColumnIndex: 1,
                                  )
                          ],
                        ))),
                SizedBox(
                  height: size.getH(24),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
