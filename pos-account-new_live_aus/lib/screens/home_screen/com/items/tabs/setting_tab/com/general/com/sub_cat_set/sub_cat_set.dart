import 'package:flutter/material.dart';
import 'package:pos_account/config/size_config.dart';
import 'package:pos_account/config/utils/utils.dart';
import 'package:pos_account/constant/constant.dart';
import 'package:pos_account/ln.dart';
import 'package:pos_account/providers/setting/general/sub_cat_pro.dart';
import 'package:pos_account/screens/home_screen/com/items/tabs/setting_tab/com/general/common/add_new_sec_w_image.dart';
import 'package:pos_account/screens/home_screen/com/items/tabs/setting_tab/com/general/common/table_data.dart';
import 'package:pos_account/screens/home_screen/com/items/tabs/setting_tab/com/general/general_set.dart';
import 'package:pos_account/services/image/image_service.dart';
import 'package:pos_account/widgets/dialog/confirm_dialog.dart';
import 'package:pos_account/widgets/input/dropdown/tree_dropdown/tree_dropdown.dart';
import 'package:pos_account/widgets/input/text_form/text_form_widget.dart';
import 'package:pos_account/widgets/loading.dart';
import 'package:pos_account/widgets/no_items_sec.dart';
import 'package:provider/provider.dart';

class SubCatSet extends StatefulWidget {
  final PageController pageController;
  const SubCatSet({super.key, required this.pageController});

  @override
  State<SubCatSet> createState() => _SubCatSetState();
}

class _SubCatSetState extends State<SubCatSet>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  SubCatPro? _pro;

  late TabController _tabController;

  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this);
    setData();
    super.initState();
  }

  void setData() {
    _pro = Provider.of<SubCatPro>(context, listen: false);
    _pro?.init();

    _pro?.getImageList();
    _pro?.getAddSec();
    _pro?.getData(page: 1);
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
    _pro?.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = Ssize(context);
    final pro = Provider.of<SubCatPro>(context);
    return Processing(
      loading: pro.loading,
      child: DefaultTabController(
        length: 2,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SettingsTabRow(
              addTitle: "Add Sub-Category",
              viewTitle: "Sub-Category List",
              tabController: _tabController,
              pageController: widget.pageController,
              onTap: (int i) {
                if (i == 0) {
                  pro.clear();
                }
                Future.delayed(Duration(milliseconds: 300), () {
                  if (i == 0) {
                    pro.getData(page: 1);
                  }
                });
              },
            ),
            SizedBox(
              height: size.getH(12),
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
                          pro.getData(page: 1);
                        });
                      },
                      suffixIcon: pro.searchCltr.text.isEmpty
                          ? null
                          : InkWell(
                              onTap: () {
                                pro.searchCltr.clear();
                                pro.getData(page: 1);
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
                          deleteItem: (p0) {
                            showDialog(
                                context: context,
                                builder: (builder) => ConfirmDialog(
                                      title: p0.length > 1
                                          ? "${p0.length} ${LN.subCats}"
                                          : "${p0.first.name}",
                                      onDelete: () async {
                                        pro.deleteData(dataList: p0);
                                        return null;
                                      },
                                    ));
                          },
                          selectItem: (p0) {
                            pro.countSelected = p0;
                            pro.notify;
                          },
                          paginate: paginate,
                          total: pro.allSubCat?.total,
                          page: pro.pageIndex,
                          onAction: pro.loading
                              ? null
                              : (p0, moreFun) {
                                  if (moreFun == MoreFun.Edit) {
                                    pro.editData(id: p0.id).then((val) {
                                      if (val ?? false) {
                                        _tabController.animateTo(1);
                                        Future.delayed(
                                            Duration(milliseconds: 500), () {
                                          pro.notify;
                                        });
                                      }
                                    });
                                  }
                                },
                        ),
                      ),
                    )
                  else
                    Center(
                      child: NoItemsSec(
                          size: size,
                          title: 'No sub-categories have been added yet.'),
                    )
                ],
              ),
              SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: AddNewSectionWImage(
                    width: 270,
                    tableTitle: LN.addNewSubCat,
                    tableList: pro.tableData,
                    // imageList: pro.addSection?.productCategoriesImages,
                    // onSelectImage: (String? imageId) {
                    //   pro.imageId = imageId;
                    //   pro.notify;
                    // },
                    getStatus: pro.isActive,
                    setStatus: (p0) {
                      pro.isActive = p0;
                      pro.notify;
                    },
                    onAdd: pro.loading
                        ? null
                        : () {
                            if (_formKey.currentState!.validate()) {
                              pro.addUpData();
                            }
                          },
                    isNew: pro.itemId.isEmpty,
                    onCancel: () {
                      pro.clear();
                      pro.notify;
                    },
                    imageUrl: pro.uploadImageUrl,
                    uploadImage: () {
                      if (pro.uploadImageUrl != null &&
                          pro.uploadImageUrl!.isNotEmpty) {
                        pro.uploadImageUrl = null;
                        pro.notify;
                      } else {
                        pro.uploadImage();
                        ImageService.filePick().then((value) {
                          pro.uploadImageUrl = value;
                          pro.notify;
                        });
                      }
                    },
                    newWidget: Wrap(
                      spacing: size.getW(24),
                      runSpacing: size.getH(24),
                      children: [
                        SizedBox(
                          width: size.getW(270),
                          child: GSTextSection(
                            title: LN.catType,
                            isReq: true,
                            indexVal: pro.catTypeIndex,
                            list: pro.addSection?.categoryTypes == null
                                ? []
                                : pro.addSection!.categoryTypes!
                                    .map((e) => e.value ?? '')
                                    .toList(),
                            onChanged: (int? val) {
                              pro.catTypeIndex = val;
                              pro.notify;
                            },
                            hintText: LN.chooseCatType,
                          ),
                        ),
                        TreeDropWidget(
                          vPad: 8,
                          width: size.getW(270),
                          dialogWidth: size.width / 2,
                          mode: Mode.DIALOG,
                          title: LN.category,
                          borderColor: Colors.black54,
                          hintText: LN.chooseCategory,
                          categoryList: pro.catList,
                          selectedId: pro.selectedCatId,
                          selectedColor: kSecondaryColor,
                          onChanged: (p0) {
                            pro.selectedCatId = p0;
                            pro.notify;
                          },
                        ),
                      ],
                    ),
                    bottomWidget: Card(
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: size.getW(8), vertical: size.getH(12)),
                        child: SizedBox(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    LN.filterTypes,
                                    style: TextStyle(
                                      fontSize: size.getS(18),
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                    ),
                                  ),
                                  SizedBox(width: size.getW(16)),
                                  if (pro.addSection?.filterTypes != null)
                                    InkWell(
                                      onTap: () {
                                        if (!pro.addSection!.filterTypes!.any(
                                            (e) =>
                                                e.isSelected != null &&
                                                !e.isSelected!)) {
                                          for (final e
                                              in pro.addSection!.filterTypes!) {
                                            e.isSelected = false;
                                          }
                                        } else {
                                          for (final e
                                              in pro.addSection!.filterTypes!) {
                                            e.isSelected = true;
                                          }
                                        }
                                        pro.notify;
                                      },
                                      child: Row(
                                        children: [
                                          IgnorePointer(
                                            ignoring: true,
                                            child: Checkbox(
                                              activeColor: kSecondaryColor,
                                              visualDensity:
                                                  VisualDensity.compact,
                                              value: !pro
                                                  .addSection!.filterTypes!
                                                  .any((e) =>
                                                      e.isSelected != null &&
                                                      !e.isSelected!),
                                              onChanged: (val) {},
                                            ),
                                          ),
                                          Text(
                                            LN.selectAll,
                                            style: TextStyle(
                                              fontSize: size.getS(18),
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black,
                                            ),
                                          ),
                                        ],
                                      ),
                                    )
                                ],
                              ),
                              if (pro.addSection?.filterTypes != null)
                                Wrap(
                                  children: List.generate(
                                      pro.addSection!.filterTypes!.length,
                                      (index) => Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Checkbox(
                                                value: pro
                                                    .addSection!
                                                    .filterTypes![index]
                                                    .isSelected,
                                                visualDensity:
                                                    VisualDensity.compact,
                                                activeColor: kSecondaryColor,
                                                onChanged: (value) {
                                                  pro
                                                      .addSection!
                                                      .filterTypes![index]
                                                      .isSelected = value;
                                                  pro.notify;
                                                },
                                              ),
                                              InkWell(
                                                onTap: () {
                                                  pro
                                                      .addSection!
                                                      .filterTypes![index]
                                                      .isSelected = !(pro
                                                          .addSection!
                                                          .filterTypes![index]
                                                          .isSelected ??
                                                      false);
                                                  pro.notify;
                                                },
                                                child: Text(
                                                  pro
                                                          .addSection!
                                                          .filterTypes![index]
                                                          .value ??
                                                      "",
                                                  style: TextStyle(
                                                    fontSize: size.getS(16),
                                                    color: Colors.black,
                                                  ),
                                                ),
                                              ),
                                              SizedBox(
                                                width: size.getW(12),
                                              ),
                                            ],
                                          )),
                                ),
                              SizedBox(
                                height: size.getH(16),
                              ),
                              Row(
                                children: [
                                  Text(
                                    LN.channel,
                                    style: TextStyle(
                                      fontSize: size.getS(18),
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                    ),
                                  ),
                                  SizedBox(width: size.getW(40)),
                                  if (pro.addSection?.channels != null)
                                    InkWell(
                                      onTap: () {
                                        if (!pro.addSection!.channels!.any(
                                            (e) =>
                                                e.isSelected != null &&
                                                !e.isSelected!)) {
                                          for (final e
                                              in pro.addSection!.channels!) {
                                            e.isSelected = false;
                                          }
                                        } else {
                                          for (final e
                                              in pro.addSection!.channels!) {
                                            e.isSelected = true;
                                          }
                                        }
                                        pro.notify;
                                      },
                                      child: Row(
                                        children: [
                                          IgnorePointer(
                                            ignoring: true,
                                            child: Checkbox(
                                              activeColor: kSecondaryColor,
                                              visualDensity:
                                                  VisualDensity.compact,
                                              value: !pro.addSection!.channels!
                                                  .any((e) =>
                                                      e.isSelected != null &&
                                                      !e.isSelected!),
                                              onChanged: (val) {},
                                            ),
                                          ),
                                          Text(
                                            LN.selectAll,
                                            style: TextStyle(
                                              fontSize: size.getS(18),
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                ],
                              ),
                              if (pro.addSection?.channels != null)
                                Wrap(
                                  children: List.generate(
                                      pro.addSection!.channels!.length,
                                      (index) => Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Checkbox(
                                                value: pro
                                                    .addSection!
                                                    .channels![index]
                                                    .isSelected,
                                                visualDensity:
                                                    VisualDensity.compact,
                                                activeColor: kSecondaryColor,
                                                onChanged: (value) {
                                                  pro
                                                      .addSection!
                                                      .channels![index]
                                                      .isSelected = value;
                                                  pro.notify;
                                                },
                                              ),
                                              InkWell(
                                                onTap: () {
                                                  pro
                                                      .addSection!
                                                      .channels![index]
                                                      .isSelected = !(pro
                                                          .addSection!
                                                          .channels![index]
                                                          .isSelected ??
                                                      false);
                                                  pro.notify;
                                                },
                                                child: Text(
                                                  pro
                                                          .addSection!
                                                          .channels![index]
                                                          .value ??
                                                      "",
                                                  style: TextStyle(
                                                    fontSize: size.getS(16),
                                                    color: Colors.black,
                                                  ),
                                                ),
                                              ),
                                              SizedBox(
                                                width: size.getW(12),
                                              ),
                                            ],
                                          )),
                                ),
                            ],
                          ),
                        ),
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
