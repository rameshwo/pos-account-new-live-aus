import 'package:flutter/material.dart';
import 'package:pos_account/config/size_config.dart';
import 'package:pos_account/config/utils/utils.dart';
import 'package:pos_account/ln.dart';
import 'package:pos_account/providers/setting/general/docket_group_pro.dart';
import 'package:pos_account/widgets/input/text_form/text_form_widget.dart';
import 'package:pos_account/widgets/loading.dart';
import 'package:pos_account/widgets/no_items_sec.dart';
import 'package:provider/provider.dart';
import '../../common/add_new_sec.dart';
import '../../common/table_data.dart';
import '../../general_set.dart';
import 'docket_assign_product.dart';

class DocketGroupSet extends StatefulWidget {
  final PageController pageController;
  const DocketGroupSet({super.key, required this.pageController});

  @override
  State<DocketGroupSet> createState() => _DocketGroupSetState();
}

class _DocketGroupSetState extends State<DocketGroupSet>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();

  DocketGroupPro? _docketPro;

  late TabController _tabController;

  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this);
    setData();
    super.initState();
  }

  setData() async {
    _docketPro = Provider.of<DocketGroupPro>(context, listen: false);
    if (_docketPro != null) {
      _docketPro!.init();
      await _docketPro!.getData(page: 1);
    }
  }

  paginate(int page) {
    if (_docketPro != null) {
      _docketPro!.getData(page: page);
    }
  }

  @override
  void dispose() {
    _docketPro?.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = Ssize(context);
    final docketPro = Provider.of<DocketGroupPro>(context);
    return Processing(
      loading: docketPro.loading,
      child: DefaultTabController(
        length: 2,
        child: Column(
          children: [
            SettingsTabRow(
              addTitle: "Add Docket Groups",
              viewTitle: "Docket Group List",
              tabController: _tabController,
              pageController: widget.pageController,
              onTap: (int i) {
                if (i == 0) {
                  docketPro.clear();
                }
                Future.delayed(Duration(milliseconds: 300), () {
                  if (i == 0) {
                    docketPro.getData();
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
                      cltr: docketPro.searchCltr,
                      hintText: LN.search,
                      onChanged: (p0) {
                        if (p0 == null) return;

                        Utils.handleSearch(callback: () async {
                          docketPro.loading = true;
                          docketPro.notify;
                          docketPro.getData();
                        });
                      },
                      suffixIcon: docketPro.searchCltr.text.isEmpty
                          ? null
                          : InkWell(
                              onTap: () {
                                docketPro.searchCltr.clear();
                                docketPro.getData();
                                docketPro.notify;
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
                  if (docketPro.loading ||
                      docketPro.tableList.tableDataList.isNotEmpty)
                    Flexible(
                      child: SingleChildScrollView(
                        child: TableData(
                          popUpMenuItems: (int _) => [
                            LN.edit,
                            "Tag Products",
                          ],
                          showDeleteBtn: false,
                          tableData: docketPro.tableList,
                          // deleteItem: (items) {
                          //   showDialog(
                          //       context: context,
                          //       builder: (builder) => ConfirmDialog(
                          //             title: items.length > 1
                          //                 ? "${items.length} ${LN.taxTypes}"
                          //                 : "${items[0].name}",
                          //             onDelete: () {
                          //               docketPro.deleteData(dataList: items);
                          //             },
                          //           ));
                          // },
                          // selectItem: (count) {
                          //   docketPro.setCount = count;
                          // },
                          paginate: paginate,
                          total: docketPro.docketAllData?.total,
                          page: docketPro.pageIndex,
                          onAction: docketPro.loading
                              ? null
                              : (p0, moreFun) async {
                                  if (moreFun == MoreFun.Edit) {
                                    docketPro
                                        .getEditData(id: p0.id!)
                                        .then((val) {
                                      if (val ?? false) {
                                        _tabController.animateTo(1);
                                        Future.delayed(
                                            Duration(milliseconds: 500), () {
                                          docketPro.notify;
                                        });
                                      }
                                    });
                                  } else if (moreFun == MoreFun.Assign) {
                                    if (p0.id != null) {
                                      docketPro.loading = true;

                                      showDialog(
                                          context: context,
                                          builder: (builder) => SimpleDialog(
                                                backgroundColor: Colors.white,
                                                titlePadding: EdgeInsets.zero,
                                                contentPadding:
                                                    EdgeInsets.symmetric(
                                                        horizontal: 12,
                                                        vertical: 12),
                                                shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            15)),
                                                children: [
                                                  DocketAssignProduct(
                                                    id: p0.id!,
                                                  )
                                                ],
                                              )).then((value) {
                                        if (docketPro.loading) {
                                          docketPro.loading = false;
                                          docketPro.notify;
                                        }
                                      });
                                    }
                                  }
                                },
                        ),
                      ),
                    )
                  else
                    Center(
                      child: NoItemsSec(
                          size: size,
                          title: 'No docket groups have been added yet.'),
                    )
                ],
              ),
              SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: AddNewSection(
                    showSaveBtn: true,
                    tableTitle: LN.docGroup,
                    tableList: docketPro.tableData,
                    statusText: LN.enDocGroupSpliter,
                    statusClass: [
                      StatusClass(
                          activeText: LN.active,
                          getStatus: docketPro.enableDocketGroupSpliter,
                          inActiveText: LN.inActive,
                          setStatus: (val) {
                            docketPro.enableDocketGroupSpliter = val;
                            docketPro.notify;
                          }),
                    ],
                    onAdd: docketPro.loading
                        ? null
                        : () async {
                            if (_formKey.currentState!.validate()) {
                              await docketPro.addUpData();
                            }
                          },
                    isNew: docketPro.itemId.isEmpty ? true : false,
                    onCancel: () {
                      docketPro.clear();
                      docketPro.notify;
                    },
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
