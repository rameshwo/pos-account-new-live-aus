import 'package:flutter/material.dart';
import 'package:pos_account/config/utils/utils.dart';
import 'package:pos_account/constant/constant.dart';
import 'package:pos_account/ln.dart';
import 'package:pos_account/model/common/res_datum.dart';
import 'package:pos_account/providers/cus_val_pro.dart';
import 'package:pos_account/providers/setting/general/all_table_loc_pro.dart';
import 'package:pos_account/widgets/dialog/confirm_dialog.dart';
import 'package:pos_account/widgets/input/text_form/text_form_widget.dart';
import 'package:pos_account/widgets/loading.dart';
import 'package:pos_account/widgets/no_items_sec.dart';
import 'package:provider/provider.dart';
import '../../../../../../../../../config/size_config.dart';
import '../../table_layout/view_table_layout.dart';
import '../common/add_new_sec.dart';
import '../common/table_data.dart';
import '../general_set.dart';

class TableLocationSet extends StatefulWidget {
  final PageController pageController;

  const TableLocationSet({super.key, required this.pageController});

  @override
  State<TableLocationSet> createState() => _TableLocationSetState();
}

class _TableLocationSetState extends State<TableLocationSet>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();

  AllTableLocPro? _atlp;

  late TabController _tabController;

  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this);
    setData();
    super.initState();
  }

  setData() async {
    _atlp = Provider.of<AllTableLocPro>(context, listen: false);
    if (_atlp != null) {
      _atlp!.init();
      await _atlp!.getData(page: 1);
    }
  }

  paginate(int page) {
    if (_atlp != null) {
      _atlp!.loading = true;
      _atlp!.notify();
      _atlp!.getData(page: page);
    }
  }

  @override
  void dispose() {
    _atlp?.clear();
    super.dispose();
  }

  Future viewDialog(
      {BuildContext? ctx,
      required Widget child,
      double horizontal = 0.0}) async {
    if (ctx == null) return;

    return showDialog(
        context: ctx,
        builder: (builder) => SimpleDialog(
              backgroundColor: kBackgroundColor,
              titlePadding: EdgeInsets.zero,
              contentPadding: EdgeInsets.symmetric(horizontal: horizontal),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15)),
              children: [child],
            ));
  }

  @override
  Widget build(BuildContext context) {
    final size = Ssize(context);
    final atlp = Provider.of<AllTableLocPro>(context);
    return Processing(
      loading: atlp.loading,
      child: DefaultTabController(
        length: 2,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SettingsTabRow(
              addTitle: "Add Table Location",
              viewTitle: "Table Location List",
              tabController: _tabController,
              pageController: widget.pageController,
              onTap: (int i) {
                if (i == 0) {
                  atlp.clear();
                }
                Future.delayed(Duration(milliseconds: 300), () {
                  if (i == 0) {
                    atlp.getData();
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
                      cltr: atlp.searchCltr,
                      hintText: LN.search,
                      onChanged: (p0) {
                        if (p0 == null) return;

                        Utils.handleSearch(callback: () async {
                          atlp.loading = true;
                          atlp.notify;
                          atlp.getData();
                        });
                      },
                      suffixIcon: atlp.searchCltr.text.isEmpty
                          ? null
                          : InkWell(
                              onTap: () {
                                atlp.searchCltr.clear();
                                atlp.getData();
                                atlp.notify;
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
                  if (atlp.loading ||
                      atlp.getTableList.tableDataList.isNotEmpty)
                    Flexible(
                      child: SingleChildScrollView(
                        child: TableData(
                          popUpMenuItems: (int val) => [
                            if ((atlp.getATLData?.data?.isNotEmpty ?? false) &&
                                (atlp.getATLData?.data?[val].tableLayoutId
                                        ?.isNotEmpty ??
                                    false))
                              LN.viewLayout
                            else
                              LN.createLayout,
                            if (GlobalCVP.viewWidget.viewTableLocationEdit)
                              LN.edit,
                            if (GlobalCVP.viewWidget.viewTableLocationDelete)
                              LN.delete,
                          ],
                          showDeleteBtn:
                              GlobalCVP.viewWidget.viewTableLocationBulkDelete,
                          tableData: atlp.getTableList,
                          deleteItem: (items) {
                            showDialog(
                                context: context,
                                builder: (builder) => ConfirmDialog(
                                      title: items.length > 1
                                          ? "${items.length} ${LN.tableLocations}"
                                          : "${items[0].name}",
                                      onDelete: () async {
                                        atlp.deleteData(dataList: items);
                                        return null;
                                      },
                                    ));
                          },
                          selectItem: (count) {
                            atlp.setCount = count;
                          },
                          paginate: paginate,
                          total: atlp.getATLData?.total,
                          page: atlp.getPage,
                          onAction: (p0, moreFun) {
                            if (p0.id == null) return;
                            if (moreFun == MoreFun.Edit) {
                              final data = atlp.getATLData!.data!
                                  .firstWhere((e) => e.id == p0.id);
                              atlp.tableData[0].tableCltr.text =
                                  data.name ?? '';
                              atlp.tableData[1].tableCltr.text =
                                  data.description ?? '';
                              atlp.itemId = data.id ?? "";
                              atlp.setStatus = data.isActive ?? false;
                              _tabController.animateTo(1);
                              Future.delayed(Duration(milliseconds: 500), () {
                                atlp.notify();
                              });
                            } else if (moreFun == MoreFun.View) {
                              viewDialog(
                                  ctx: CUS_CTX,
                                  horizontal: size.getW(12),
                                  child: ViewTableLayout(
                                    floorId: p0.id!,
                                    floorName: p0.name ?? '',
                                  )).then((val) {
                                if (val == null || (val is bool && val)) {
                                  viewDialog(
                                      ctx: CUS_CTX,
                                      child: TableLocationSet(
                                        pageController: widget.pageController,
                                      ),
                                      horizontal: size.getW(12));
                                }
                              });
                            } else if (moreFun == MoreFun.Connect) {
                              showDialog(
                                  context: context,
                                  builder: (builder) => ConfirmDialog(
                                        title:
                                            "${LN.createLayoutFor} ${p0.name}",
                                        subTitle: "",
                                        actionText: LN.create,
                                        onDelete: () async {
                                          atlp.createTableLayout(
                                              tableLocationId: p0.id);
                                          return null;
                                        },
                                      ));
                            }
                          },
                        ),
                      ),
                    )
                  else
                    Center(
                        child: NoItemsSec(
                            size: size,
                            title: 'No tables have been added yet.'))
                ],
              ),
              SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: AddNewSection(
                    showSaveBtn:
                        GlobalCVP.viewWidget.viewTableLocationSaveButton,
                    tableTitle: LN.addNewLoc,
                    tableList: atlp.tableData,
                    statusClass: [
                      StatusClass(
                          activeText: LN.active,
                          getStatus: atlp.getStatus,
                          inActiveText: LN.inActive,
                          setStatus: (val) {
                            atlp.setStatus = val;
                          })
                    ],
                    onAdd: atlp.loading
                        ? null
                        : () async {
                            if (_formKey.currentState!.validate()) {
                              await atlp.addData(tableList: [
                                SRDatum(
                                  id: atlp.itemId,
                                  name: atlp.tableData[0].tableCltr.text,
                                  description: atlp.tableData[1].tableCltr.text,
                                  isActive: atlp.getStatus,
                                )
                              ]);
                              for (var e in atlp.tableData) {
                                e.tableCltr.clear();
                              }
                              atlp.itemId = "";
                            }
                          },
                    isNew: atlp.itemId.isEmpty ? true : false,
                    onCancel: () {
                      atlp.clear();
                      atlp.notify();
                    },
                  ),
                ),
              ),
            ])),
          ],
        ),
      ),
    );
  }
}
