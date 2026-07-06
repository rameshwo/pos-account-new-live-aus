import 'package:flutter/material.dart';
import 'package:pos_account/config/size_config.dart';
import 'package:pos_account/config/utils/utils.dart';
import 'package:pos_account/ln.dart';
import 'package:pos_account/model/common/res_datum.dart';
import 'package:pos_account/providers/cus_val_pro.dart';
import 'package:pos_account/providers/setting/pos_device/department_pro.dart';
import 'package:pos_account/screens/home_screen/com/items/tabs/setting_tab/com/general/common/add_new_sec.dart';
import 'package:pos_account/screens/home_screen/com/items/tabs/setting_tab/com/general/common/table_data.dart';
import 'package:pos_account/widgets/dialog/confirm_dialog.dart';
import 'package:pos_account/widgets/input/text_form/text_form_widget.dart';
import 'package:pos_account/widgets/loading.dart';
import 'package:pos_account/widgets/no_items_sec.dart';
import 'package:provider/provider.dart';

import '../../general/general_set.dart';

class DepartmentSet extends StatefulWidget {
  final PageController pageController;

  const DepartmentSet({super.key, required this.pageController});

  @override
  State<DepartmentSet> createState() => _DepartmentSetState();
}

class _DepartmentSetState extends State<DepartmentSet>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();

  DepartmentPro? _prov;

  late TabController _tabController;

  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this);
    setData();
    super.initState();
  }

  setData() async {
    _prov = Provider.of<DepartmentPro>(context, listen: false);
    if (_prov != null) {
      _prov!.init();
      await _prov!.getData(page: 1);
    }
  }

  paginate(int page) {
    if (_prov != null) {
      _prov!.loading = true;
      _prov!.notify();
      _prov!.getData(page: page);
    }
  }

  @override
  void dispose() {
    _prov?.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = Ssize(context);
    final prov = Provider.of<DepartmentPro>(context);
    return Processing(
      loading: prov.loading,
      child: DefaultTabController(
        length: 2,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SettingsTabRow(
              addTitle: "Add Department",
              viewTitle: "Department List",
              tabController: _tabController,
              pageController: widget.pageController,
              onTap: (int i) {
                if (i == 0) {
                  prov.clear();
                }
                Future.delayed(Duration(milliseconds: 300), () {
                  if (i == 0) {
                    prov.getData();
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
                      cltr: prov.searchCltr,
                      hintText: LN.search,
                      onChanged: (p0) {
                        if (p0 == null) return;

                        Utils.handleSearch(callback: () async {
                          prov.loading = true;
                          prov.notify;
                          prov.getData();
                        });
                      },
                      suffixIcon: prov.searchCltr.text.isEmpty
                          ? null
                          : InkWell(
                              onTap: () {
                                prov.searchCltr.clear();
                                prov.getData();
                                prov.notify;
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
                  if (prov.loading ||
                      prov.getTableList.tableDataList.isNotEmpty)
                    Flexible(
                      child: SingleChildScrollView(
                        child: TableData(
                          popUpMenuItems: (int _) => [
                            if (GlobalCVP.viewWidget.viewDepartmentEdit)
                              LN.edit,
                            if (GlobalCVP.viewWidget.viewDepartmentDelete)
                              LN.delete,
                          ],
                          showDeleteBtn:
                              GlobalCVP.viewWidget.viewDepartmentBulkDelete,
                          tableData: prov.getTableList,
                          deleteItem: (items) {
                            showDialog(
                                context: context,
                                builder: (builder) => ConfirmDialog(
                                      title: items.length > 1
                                          ? "${items.length} ${LN.department}"
                                          : "${items[0].name}",
                                      onDelete: () async {
                                        prov.deleteData(dataList: items);
                                        return null;
                                      },
                                    ));
                          },
                          selectItem: (count) {
                            prov.setCountSelected = count;
                          },
                          paginate: paginate,
                          total: prov.getDepartRes?.total,
                          page: prov.getPage,
                          onAction: (p0, moreFun) {
                            final data = prov.getDepartRes!.data!
                                .firstWhere((e) => e.id == p0.id);
                            prov.tableData[0].tableCltr.text = data.name ?? '';
                            prov.tableData[1].tableCltr.text =
                                data.description ?? '';
                            prov.itemId = data.id ?? "";
                            prov.setActiveStatus = data.isActive ?? false;
                            _tabController.animateTo(1);
                            Future.delayed(Duration(milliseconds: 500), () {
                              prov.notify();
                            });
                          },
                        ),
                      ),
                    )
                  else
                    Center(
                      child: NoItemsSec(
                          size: size,
                          title: 'No departments have been added yet.'),
                    )
                ],
              ),
              SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: AddNewSection(
                    showSaveBtn: GlobalCVP.viewWidget.viewDepartmentSaveButton,
                    tableTitle: LN.addNewDepartment,
                    tableList: prov.tableData,
                    statusClass: [
                      StatusClass(
                          activeText: LN.active,
                          getStatus: prov.getActiveStatus,
                          inActiveText: LN.inActive,
                          setStatus: (val) {
                            prov.setActiveStatus = val;
                          })
                    ],
                    onAdd: prov.loading
                        ? null
                        : () async {
                            if (_formKey.currentState!.validate()) {
                              await prov.addUpData(tableList: [
                                SRDatum(
                                  id: prov.itemId,
                                  name: prov.tableData[0].tableCltr.text,
                                  description: prov.tableData[1].tableCltr.text,
                                  isActive: prov.getActiveStatus,
                                )
                              ]);
                              for (var e in prov.tableData) {
                                e.tableCltr.clear();
                              }
                              prov.itemId = "";
                            }
                          },
                    onCancel: () {
                      prov.clear();
                      prov.notify();
                    },
                    isNew: prov.itemId.isEmpty ? true : false,
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
