import 'package:flutter/material.dart';
import 'package:pos_account/config/size_config.dart';
import 'package:pos_account/config/utils/utils.dart';
import 'package:pos_account/ln.dart';
import 'package:pos_account/model/common/res_datum.dart';
import 'package:pos_account/providers/setting/general/quick_note_pro.dart';
import 'package:pos_account/screens/home_screen/com/items/tabs/setting_tab/com/general/common/add_new_sec.dart';
import 'package:pos_account/screens/home_screen/com/items/tabs/setting_tab/com/general/common/table_data.dart';
import 'package:pos_account/screens/home_screen/com/items/tabs/setting_tab/com/general/general_set.dart';
import 'package:pos_account/widgets/input/text_form/text_form_widget.dart';
import 'package:pos_account/widgets/loading.dart';
import 'package:pos_account/widgets/no_items_sec.dart';
import 'package:provider/provider.dart';

class QuickNoteSet extends StatefulWidget {
  final PageController pageController;
  const QuickNoteSet({super.key, required this.pageController});

  @override
  State<QuickNoteSet> createState() => _QuickNoteSetState();
}

class _QuickNoteSetState extends State<QuickNoteSet>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();

  QuickNotePro? _pro;

  late TabController _tabController;

  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this);
    setData();
    super.initState();
  }

  setData() async {
    _pro = Provider.of<QuickNotePro>(context, listen: false);
    if (_pro != null) {
      _pro!.init();
      await _pro!.getData(page: 1);
    }
  }

  paginate(int page) {
    if (_pro != null) {
      _pro!.loading = true;
      _pro!.notify;
      _pro!.getData(page: page);
    }
  }

  @override
  void dispose() {
    _pro?.loading = true;
    _pro?.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final pro = Provider.of<QuickNotePro>(context);
    final size = Ssize(context);
    return Processing(
      loading: pro.loading,
      child: DefaultTabController(
        length: 2,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SettingsTabRow(
              addTitle: "Add Quick Note",
              viewTitle: "Quick Note List",
              tabController: _tabController,
              pageController: widget.pageController,
              onTap: (int i) {
                if (i == 0) {
                  pro.clear();
                }
                Future.delayed(Duration(milliseconds: 300), () {
                  if (i == 0) {
                    pro.getData();
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
                      cltr: pro.searchCltr,
                      hintText: LN.search,
                      onChanged: (p0) {
                        if (p0 == null) return;

                        Utils.handleSearch(callback: () async {
                          pro.loading = true;
                          pro.notify;
                          pro.getData();
                        });
                      },
                      suffixIcon: pro.searchCltr.text.isEmpty
                          ? null
                          : InkWell(
                              onTap: () {
                                pro.searchCltr.clear();
                                pro.getData();
                                pro.notify;
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
                  if (pro.loading || pro.tableList.tableDataList.isNotEmpty)
                    Flexible(
                      child: SingleChildScrollView(
                        child: TableData(
                            tableData: pro.tableList,
                            popUpMenuItems: (int i) => [
                                  LN.edit,
                                  LN.delete,
                                ],
                            paginate: paginate,
                            total: pro.getAllNotes?.total,
                            page: pro.pageNum,
                            onAction: (p0, moreFun) {
                              final data = pro.getAllNotes!.data!
                                  .firstWhere((e) => e.id == p0.id);
                              if (moreFun == MoreFun.Edit) {
                                pro.tableData[0].tableCltr.text =
                                    data.name ?? '';
                                pro.quickNoteId = data.id ?? "";
                                pro.isActiveStatus = data.isActive ?? false;
                                pro.notify;
                                _tabController.animateTo(1);
                                Future.delayed(Duration(milliseconds: 500), () {
                                  pro.notify;
                                });
                              }
                            },
                            deleteItem: (val) {
                              if (val.isEmpty) return;

                              pro.deleteNote(
                                  dataList: [SRDatum(id: val.first.id)]);
                            }),
                      ),
                    )
                  else
                    Center(
                      child: NoItemsSec(
                          size: size,
                          title: 'No quick notes have been added yet.'),
                    )
                ],
              ),
              SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: AddNewSection(
                    // showSaveBtn:
                    //     GlobalCVP.viewWidget.viewCategoryTypeSaveButton,
                    tableTitle: LN.catType,
                    tableList: pro.tableData,
                    statusClass: [
                      StatusClass(
                          activeText: LN.active,
                          getStatus: pro.isActiveStatus,
                          inActiveText: LN.inActive,
                          setStatus: (val) {
                            pro.isActiveStatus = val;
                            pro.notify;
                          })
                    ],
                    onAdd: pro.loading
                        ? null
                        : () async {
                            if (_formKey.currentState!.validate()) {
                              await pro.addUpData();
                            }
                          },
                    isNew: pro.quickNoteId.isEmpty ? true : false,
                    onCancel: () {
                      pro.clear();
                      pro.notify;
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
