import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:pos_account/config/size_config.dart';
import 'package:pos_account/config/utils/utils.dart';
import 'package:pos_account/constant/constant.dart';
import 'package:pos_account/ln.dart';
import 'package:pos_account/providers/cus_val_pro.dart';
import 'package:pos_account/providers/setting/general/tax_ie_pro.dart';
import 'package:pos_account/screens/home_screen/com/items/tabs/setting_tab/com/general/common/add_new_sec.dart';
import 'package:pos_account/screens/home_screen/com/items/tabs/setting_tab/com/general/common/table_data.dart';
import 'package:pos_account/widgets/dialog/confirm_dialog.dart';
import 'package:pos_account/widgets/input/dropdown/title_drop_down.dart';
import 'package:pos_account/widgets/input/text_form/text_form_widget.dart';
import 'package:pos_account/widgets/input/text_form/title_text_form.dart';
import 'package:pos_account/widgets/load_btn.dart';
import 'package:pos_account/widgets/loading.dart';
import 'package:pos_account/widgets/no_items_sec.dart';
import 'package:provider/provider.dart';

import '../general_set.dart';

class TaxIESet extends StatefulWidget {
  final PageController pageController;

  const TaxIESet({super.key, required this.pageController});

  // const TaxIESet({super.key, required this.pageController});

  @override
  State<TaxIESet> createState() => _TaxIESetState();
}

class _TaxIESetState extends State<TaxIESet>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();

  TaxIEPro? _taxIEPro;

  late TabController _tabController;

  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this);
    setData();
    super.initState();
  }

  setData() async {
    _taxIEPro = Provider.of<TaxIEPro>(context, listen: false);
    if (_taxIEPro != null) {
      _taxIEPro!.init();
      await _taxIEPro!.getAddSec();
      await _taxIEPro!.getData(page: 1);
    }
  }

  paginate(int page) {
    if (_taxIEPro != null) {
      _taxIEPro!.getData(page: page);
    }
  }

  @override
  void dispose() {
    _taxIEPro?.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = Ssize(context);
    final taxIEPro = Provider.of<TaxIEPro>(context);
    return Processing(
      loading: taxIEPro.loading,
      child: DefaultTabController(
        length: 2,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SettingsTabRow(
              addTitle: "Add Taxes",
              viewTitle: "Taxes List",
              tabController: _tabController,
              pageController: widget.pageController,
              onTap: (int i) {
                if (i == 0) {
                  taxIEPro.clear();
                }
                Future.delayed(Duration(milliseconds: 300), () {
                  if (i == 0) {
                    taxIEPro.getData();
                  }
                });
              },
            ),
            SizedBox(
              height: size.getH(6),
            ),
            Expanded(
                child: TabBarView(controller: _tabController, children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  SizedBox(
                    width: size.getW(400),
                    child: TextFormWidget(
                      isReq: false,
                      vPad: 10,
                      prefixIcon: Icon(
                        Icons.search,
                        size: size.getS(32),
                      ),
                      borderRadius: 5,
                      borderColor: Colors.black12,
                      cltr: taxIEPro.searchCltr,
                      hintText: LN.search,
                      onChanged: (p0) {
                        if (p0 == null) return;

                        Utils.handleSearch(callback: () async {
                          taxIEPro.loading = true;
                          taxIEPro.notify;
                          taxIEPro.getData();
                        });
                      },
                      suffixIcon: taxIEPro.searchCltr.text.isEmpty
                          ? null
                          : InkWell(
                              onTap: () {
                                taxIEPro.searchCltr.clear();
                                taxIEPro.getData();
                                taxIEPro.notify;
                              },
                              child: Icon(
                                Icons.close,
                                size: size.getS(28),
                                color: Colors.black,
                              ),
                            ),
                    ),
                  ),
                  SizedBox(
                    height: size.getH(6),
                  ),
                  if (taxIEPro.loading ||
                      taxIEPro.getTableList.tableDataList.isNotEmpty)
                    Flexible(
                      child: SingleChildScrollView(
                        child: TableData(
                          popUpMenuItems: (int _) => [
                            if (GlobalCVP.viewWidget.viewTaxEdit) LN.edit,
                            if (GlobalCVP.viewWidget.viewTaxDelete) LN.delete,
                          ],
                          showDeleteBtn: GlobalCVP.viewWidget.viewTaxBulkDelete,
                          tableData: taxIEPro.getTableList,
                          deleteItem: (items) {
                            showDialog(
                                context: context,
                                builder: (builder) => ConfirmDialog(
                                      title: items.length > 1
                                          ? "${items.length} ${LN.taxTypes}"
                                          : "${items[0].name}",
                                      onDelete: () async {
                                        taxIEPro.deleteData(dataList: items);
                                        return null;
                                      },
                                    ));
                          },
                          selectItem: (count) {
                            taxIEPro.setCount = count;
                          },
                          paginate: paginate,
                          total: taxIEPro.getAllTaxIE?.total,
                          page: taxIEPro.getPage,
                          onAction: taxIEPro.loading
                              ? null
                              : (p0, moreFun) {
                                  taxIEPro.getEditData(id: p0.id!).then((val) {
                                    if (val ?? false) {
                                      _tabController.animateTo(1);
                                      Future.delayed(
                                          Duration(milliseconds: 500), () {
                                        taxIEPro.notify();
                                      });
                                    }
                                  });
                                },
                        ),
                      ),
                    )
                  else
                    Center(
                        child: NoItemsSec(
                            size: size, title: 'No taxes have been added yet.'))
                ],
              ),
              SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: AddNewSection(
                    showSaveBtn: GlobalCVP.viewWidget.viewTaxSaveButton,
                    tableTitle: LN.addTax,
                    tableList: taxIEPro.tableData,
                    statusClass: [
                      StatusClass(
                          activeText: LN.active,
                          getStatus: taxIEPro.getStatus,
                          inActiveText: LN.inActive,
                          setStatus: (val) {
                            taxIEPro.setStatus = val;
                          }),
                      StatusClass(
                          activeText: LN.defaultText,
                          getStatus: taxIEPro.getDefault,
                          inActiveText: LN.defaultText,
                          setStatus: (val) {
                            taxIEPro.setDefault = val;
                          })
                    ],
                    onAdd: taxIEPro.loading
                        ? null
                        : () async {
                            if (_formKey.currentState!.validate()) {
                              await taxIEPro.addUpData();
                            }
                          },
                    isNew: taxIEPro.itemId.isEmpty ? true : false,
                    onCancel: () {
                      taxIEPro.clear();
                      taxIEPro.notify();
                    },
                    newWidget: SizedBox(
                      width: size.getW(300),
                      child: TitleDropDown(
                        borderColor: Colors.black54,
                        hintText: LN.chooseTaxType,
                        // pWidth: 0.21,
                        title: LN.taxTypeU,
                        list: taxIEPro.taxInExAddSec == null ||
                                taxIEPro.taxInExAddSec!.taxTypes == null
                            ? []
                            : taxIEPro.taxInExAddSec!.taxTypes!
                                .map((e) => e.value ?? "")
                                .toList(),
                        indexVal: taxIEPro.taxTypeIndex,
                        onChanged: (p0) {
                          taxIEPro.taxTypeIndex = p0;
                          taxIEPro.notify();
                        },
                      ),
                    ),
                    bottomWidget: Column(
                      children: [
                        SizedBox(
                          height: size.getH(24),
                        ),
                        ...List.generate(taxIEPro.taxRuleList.length, (index) {
                          final _taxRule = taxIEPro.taxRuleList[index];
                          return Card(
                            margin:
                                EdgeInsets.symmetric(vertical: size.getH(6)),
                            shape: RoundedRectangleBorder(
                                side: BorderSide(color: Colors.black12)),
                            child: Padding(
                              padding: EdgeInsets.all(size.getS(8)),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        "Tax Rule ${index + 1}",
                                        style: TextStyle(
                                          fontSize: size.getS(16),
                                          color: Colors.black,
                                          fontFamily: kFontFMedium,
                                        ),
                                      ),
                                      Spacer(),
                                      IconButton(
                                          onPressed: () {
                                            taxIEPro.removeTaxRule(index);
                                          },
                                          icon: Icon(
                                            Icons.delete_outline,
                                            color: Colors.red,
                                            size: size.getS(25),
                                          ))
                                    ],
                                  ),
                                  Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Flexible(
                                          flex: 1,
                                          child: TitleTextForm(
                                            title: "Rule Name",
                                            isReq: true,
                                            textCltr: _taxRule.ruleNameCltr,
                                            hintText: "Rule Name",
                                            borderColor: Colors.black26,
                                            pWidth: 0.24,
                                          ),
                                        ),
                                        SizedBox(width: size.getW(24)),
                                        Expanded(
                                          flex: 2,
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                "Conditions",
                                                style: TextStyle(
                                                  fontSize: size.getS(18),
                                                  color: Colors.black,
                                                ),
                                              ),
                                              ...List.generate(
                                                  _taxRule.taxConditionSection
                                                      .length, (index2) {
                                                final _taxRuleData = _taxRule
                                                        .taxConditionSection[
                                                    index2];
                                                return Card(
                                                  elevation: 4,
                                                  margin: EdgeInsets.symmetric(
                                                      vertical: size.getH(6),
                                                      horizontal:
                                                          size.getW(12)),
                                                  shape: RoundedRectangleBorder(
                                                      side: BorderSide(
                                                          color:
                                                              Colors.black12)),
                                                  child: Container(
                                                    width: double.infinity,
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                            vertical:
                                                                size.getS(16),
                                                            horizontal:
                                                                size.getS(12)),
                                                    child: Row(
                                                      children: [
                                                        Expanded(
                                                          child: Text(
                                                            _taxRuleData
                                                                .orderTypeName,
                                                            style: TextStyle(
                                                              fontSize:
                                                                  size.getS(16),
                                                              color:
                                                                  Colors.black,
                                                              fontFamily:
                                                                  kFontFMedium,
                                                            ),
                                                          ),
                                                        ),
                                                        SizedBox(
                                                            width:
                                                                size.getW(24)),
                                                        Expanded(
                                                          child: TitleTextForm(
                                                            title: "Value",
                                                            isReq: true,
                                                            textCltr:
                                                                _taxRuleData
                                                                    .value,
                                                            hintText: "Value",
                                                            borderColor:
                                                                Colors.black26,
                                                            textInputType:
                                                                TextInputType
                                                                    .number,
                                                            pWidth: 0.24,
                                                          ),
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                );
                                              })
                                            ],
                                          ),
                                        )
                                      ]),
                                ],
                              ),
                            ),
                          );
                        }),
                        SizedBox(
                          height: size.getH(16),
                        ),
                        DottedBorder(
                          borderType: BorderType.RRect,
                          radius: Radius.circular(10),
                          dashPattern: [12, 4],
                          color: Colors.black45,
                          child: LoadButton(
                            width: double.infinity,
                            hPad: 4,
                            vPad: 6,
                            textColor: Colors.black,
                            btnColor: Colors.white,
                            btnText: "Add Tax Rule",
                            icon: Padding(
                              padding: EdgeInsets.only(right: size.getW(12)),
                              child: Icon(
                                Icons.add,
                                color: Colors.black,
                                size: size.getS(22),
                              ),
                            ),
                            onsave: () {
                              taxIEPro.addTaxRule();
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ]))
          ],
        ),
      ),
    );
  }
}
