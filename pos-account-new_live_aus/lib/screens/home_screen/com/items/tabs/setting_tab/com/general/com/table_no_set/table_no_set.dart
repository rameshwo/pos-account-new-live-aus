import 'package:flutter/material.dart';
import 'package:oktoast/oktoast.dart';
import 'package:pos_account/config/utils/utils.dart';
import 'package:pos_account/ln.dart';
import 'package:pos_account/model/home/setting/general/table_number/au_table_list.dart';
import 'package:pos_account/providers/cus_val_pro.dart';
import 'package:pos_account/providers/setting/general/all_table_no_pro.dart';
import 'package:pos_account/screens/home_screen/com/items/tabs/setting_tab/com/general/com/table_no_set/table_grid_view.dart';
import 'package:pos_account/screens/home_screen/com/items/tabs/setting_tab/com/general/common/add_new_sec_w_image.dart';
import 'package:pos_account/widgets/input/text_form/text_form_widget.dart';
import 'package:pos_account/widgets/loading.dart';
import 'package:pos_account/widgets/no_items_sec.dart';
import 'package:provider/provider.dart';
import '../../../../../../../../../../config/size_config.dart';
import '../../general_set.dart';

class TableNumberSet extends StatefulWidget {
  final PageController pageController;

  const TableNumberSet({
    super.key,
    required this.pageController,
  });

  @override
  State<TableNumberSet> createState() => _TableNumberSetState();
}

class _TableNumberSetState extends State<TableNumberSet>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();

  AllTableNumPro? _atnp;

  late TabController _tabController;

  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this);
    setData();
    super.initState();
  }

  setData() async {
    _atnp = Provider.of<AllTableNumPro>(context, listen: false);
    if (_atnp != null) {
      _atnp!.init();
      await _atnp!.getAddSecData();
      await _atnp!.getData(page: 1);
    }
  }

  paginate(int page) {
    if (_atnp != null) {
      _atnp!.loading = true;
      _atnp!.notify();
      _atnp!.getData(page: page);
    }
  }

  @override
  void dispose() {
    _atnp?.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = Ssize(context);
    final atnp = Provider.of<AllTableNumPro>(context);
    return Processing(
      loading: atnp.loading,
      child: DefaultTabController(
        length: 2,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SettingsTabRow(
              addTitle: "Add Table Numbers",
              viewTitle: "Table Numbers List",
              tabController: _tabController,
              pageController: widget.pageController,
              onTap: (int i) {
                if (i == 0) {
                  atnp.clear();
                }
                Future.delayed(Duration(milliseconds: 300), () {
                  if (i == 0) {
                    atnp.getData();
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
                      cltr: atnp.searchCltr,
                      hintText: LN.search,
                      onChanged: (p0) {
                        if (p0 == null) return;

                        Utils.handleSearch(callback: () async {
                          atnp.loading = true;
                          atnp.notify;
                          atnp.getData();
                        });
                      },
                      suffixIcon: atnp.searchCltr.text.isEmpty
                          ? null
                          : InkWell(
                              onTap: () {
                                atnp.searchCltr.clear();
                                atnp.getData();
                                atnp.notify;
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
                  if (atnp.loading ||
                      atnp.getTableList.tableDataList.isNotEmpty)
                    Flexible(
                      child: SingleChildScrollView(
                        child: TableGridView(
                            tabController: _tabController,
                            page: atnp.getPage,
                            tableData: atnp.getTableList,
                            atnp: atnp,
                            total: atnp.getTableData?.total ?? 0,
                            onsave: () {
                              paginate(atnp.getPage);
                            }),
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
                  child: AddNewSectionWImage(
                    showSaveBtn: GlobalCVP.viewWidget.viewTableSaveButton,
                    tableTitle: LN.addNewTable,
                    tableList: atnp.tableData,
                    getStatus: atnp.getStatus,
                    setStatus: (val) {
                      atnp.setStatus = val;
                    },
                    onAdd: atnp.btnLoading
                        ? null
                        : () async {
                            if (atnp.tableAddSecList == null ||
                                atnp.tableAddSecList!.tableLocations == null ||
                                atnp.tableLocIndex == null) {
                              showToast(LN.tableLocEmpty);
                              return;
                            }
                            if (_formKey.currentState!.validate()) {
                              await atnp.addUpData(allTableNoL: [
                                AllTableNoList(
                                    id: atnp.itemId,
                                    name: atnp.tableData[0].tableCltr.text,
                                    tableImageId: atnp.selectedTImgId,
                                    adultCapacity:
                                        atnp.tableData[1].tableCltr.text,
                                    childCapacity:
                                        atnp.tableData[2].tableCltr.text,
                                    description:
                                        atnp.tableData[3].tableCltr.text,
                                    isActive: atnp.getStatus,
                                    tableLocationId: atnp
                                        .tableAddSecList!
                                        .tableLocations![atnp.tableLocIndex!]
                                        .id)
                              ]);
                              for (var e in atnp.tableData) {
                                e.tableCltr.clear();
                              }
                              atnp.itemId = "";
                            }
                          },
                    onCancel: () {
                      atnp.clear();
                      atnp.notify();
                    },
                    imageList: atnp.imageList,
                    onSelectImage: (String? imageId) {
                      atnp.selectImageId = imageId;
                      atnp.notify();
                    },
                    isNew: atnp.itemId.isEmpty ? true : false,
                    newWidget: SizedBox(
                      width: size.getW(300),
                      child: GSTextSection(
                        title: LN.tableLocation,
                        isReq: true,
                        indexVal: atnp.tableLocIndex,
                        list: atnp.tableAddSecList == null ||
                                atnp.tableAddSecList!.tableLocations == null
                            ? []
                            : atnp.tableAddSecList!.tableLocations!
                                .map((e) => e.value ?? '')
                                .toList(),
                        onChanged: (int? val) {
                          atnp.tableLocIndex = val;
                          atnp.notify();
                        },
                        hintText: LN.chooseTableLoc,
                      ),
                    ),
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
