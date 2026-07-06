import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pos_account/config/size_config.dart';
import 'package:pos_account/config/utils/utils.dart';
import 'package:pos_account/constant/constant.dart';
import 'package:pos_account/ln.dart';
import 'package:pos_account/providers/eod/cash_inout_pro.dart';
import 'package:pos_account/screens/home_screen/com/items/tabs/setting_tab/com/general/common/add_new_sec.dart';
import 'package:pos_account/screens/home_screen/com/items/tabs/setting_tab/com/general/common/table_data.dart';
import 'package:pos_account/widgets/input/text_form/text_form_widget.dart';
import 'package:pos_account/widgets/loading.dart';
import 'package:pos_account/widgets/no_items_sec.dart';
import 'package:provider/provider.dart';

class CashInOutDia extends StatefulWidget {
  const CashInOutDia({super.key});

  @override
  State<CashInOutDia> createState() => _CashInOutDiaState();
}

class _CashInOutDiaState extends State<CashInOutDia> {
  final _formKey = GlobalKey<FormState>();

  EodCashInOutPro? _eodPro;

  @override
  void initState() {
    super.initState();
    getData();
  }

  void getData() {
    _eodPro = Provider.of<EodCashInOutPro>(context, listen: false);
    if (_eodPro != null) {
      _eodPro!.getDateFor().then((_) => _eodPro!.getData());
    }
  }

  paginate(int page) {
    if (_eodPro != null) {
      _eodPro!.loadCashInOut = true;
      _eodPro!.notify;
      _eodPro!.getData(page: page);
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = Ssize(context);
    final pro = Provider.of<EodCashInOutPro>(context);
    return Processing(
      loading: pro.loadCashInOut,
      child: Container(
        constraints: BoxConstraints(
          maxHeight: size.height / 1.3,
          minHeight: size.height / 5,
        ),
        width: size.width / 1.4,
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: size.getH(24),
                ),
                AddNewSection(
                  tableTitle: LN.cashInOut,
                  saveText: LN.save,
                  saveBtnWidth: 180,
                  tableList: pro.tableData,
                  onAdd: pro.loadCashInOut
                      ? null
                      : () async {
                          if (_formKey.currentState!.validate()) {
                            await pro.addUpData();
                          }
                        },
                  isNew: pro.itemId.isEmpty ? true : false,
                  onCancel: () {
                    pro.clear();
                    pro.notify;
                  },
                  newWidget: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(left: size.getW(0)),
                        child: Text(
                          LN.type,
                          style: TextStyle(
                            fontSize: size.getS(16),
                            fontFamily: kFontFMedium,
                            color: Colors.black,
                          ),
                        ),
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Radio(
                              value: true,
                              groupValue: pro.cashType == CashType.CashIn,
                              onChanged: (val) {
                                pro.cashType = CashType.CashIn;
                                pro.notify;
                              }),
                          InkWell(
                            onTap: () {
                              pro.cashType = CashType.CashIn;
                              pro.notify;
                            },
                            child: Text(
                              LN.cashIn,
                              style: TextStyle(
                                fontSize: size.getS(16),
                                fontFamily: kFontFMedium,
                                color: Colors.black,
                              ),
                            ),
                          ),
                          SizedBox(
                            width: size.getW(16),
                          ),
                          Radio(
                              value: true,
                              groupValue: pro.cashType == CashType.CashOut,
                              onChanged: (val) {
                                pro.cashType = CashType.CashOut;
                                pro.notify;
                              }),
                          InkWell(
                            onTap: () {
                              pro.cashType = CashType.CashOut;
                              pro.notify;
                            },
                            child: Text(
                              LN.cashOut,
                              style: TextStyle(
                                fontSize: size.getS(16),
                                fontFamily: kFontFMedium,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: size.getH(12),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: size.getH(24),
                ),
                Row(
                  children: [
                    SizedBox(
                      width: size.getW(6),
                    ),
                    Expanded(
                      child: Wrap(
                        runSpacing: 12,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                                color: Colors.green.withAlpha(60),
                                borderRadius: BorderRadius.circular(5)),
                            padding: EdgeInsets.symmetric(
                                vertical: size.getH(6),
                                horizontal: size.getW(24)),
                            child: Text(
                              "${LN.totalCashIn}: ${pro.curSym}${pro.totalCashIn}",
                              style: TextStyle(
                                fontSize: size.getS(16),
                                fontFamily: kFontFMedium,
                                color: Colors.green.shade700,
                              ),
                            ),
                          ),
                          SizedBox(
                            width: size.getW(24),
                          ),
                          Container(
                            decoration: BoxDecoration(
                                color: Colors.red.withAlpha(60),
                                borderRadius: BorderRadius.circular(5)),
                            padding: EdgeInsets.symmetric(
                                vertical: size.getH(6),
                                horizontal: size.getW(24)),
                            child: Text(
                              "${LN.totalCashOut}: ${pro.curSym}${pro.totalCashOut}",
                              style: TextStyle(
                                fontSize: size.getS(16),
                                fontFamily: kFontFMedium,
                                color: Colors.red.shade700,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Row(
                      children: [
                        Text(
                          LN.chooseDate,
                          style: TextStyle(
                            fontSize: size.getS(16),
                            color: Colors.black,
                          ),
                        ),
                        SizedBox(
                          width: size.getW(12),
                        ),
                        SizedBox(
                          width: size.getW(160),
                          child: TextFormWidget(
                            isReq: false,
                            readOnly: true,
                            borderRadius: 5,
                            borderColor: Colors.black12,
                            cltr: TextEditingController(
                                text: pro.dateCltr.text.split(' ').first),
                            hintText: LN.chooseDate,
                            onTap: () {
                              Utils.datePick(context,
                                      initDate: pro.dateCltr.text.isNotEmpty
                                          ? DateFormat(pro.dateFormat)
                                              .parse(pro.dateCltr.text)
                                          : null)
                                  .then((date) {
                                if (date == null) return;
                                pro.dateCltr.text =
                                    DateFormat(pro.dateFormat).format(date);
                                pro.loadCashInOut = true;
                                pro.notify;
                                pro.getData(page: pro.pageIndex);
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      width: size.getW(4),
                    )
                  ],
                ),
                if (pro.tableList.tableDataList.isEmpty)
                  NoItemsSec(
                    size: size,
                    title: LN.noCashInOut,
                    iconHeight: 200,
                  )
                else
                  TableData(
                    popUpMenuItems: (int _) => [
                      LN.edit,
                    ],
                    showDeleteBtn: false,
                    tableData: pro.tableList,
                    paginate: paginate,
                    pageSize: 100,
                    total: pro.allCashInOut?.total,
                    page: pro.pageIndex,
                    onAction: (p0, moreFun) {
                      if (moreFun == MoreFun.Edit) {
                        pro.itemId = p0.id ?? '';
                        pro.editData();
                      }
                    },
                  ),
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
