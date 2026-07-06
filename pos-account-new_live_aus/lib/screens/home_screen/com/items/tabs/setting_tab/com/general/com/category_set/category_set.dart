import 'package:flutter/material.dart';
import 'package:oktoast/oktoast.dart';
import 'package:pos_account/config/size_config.dart';
import 'package:pos_account/config/utils/utils.dart';
import 'package:pos_account/constant/constant.dart';
import 'package:pos_account/ln.dart';
import 'package:pos_account/model/common/table_location.dart';
import 'package:pos_account/providers/cus_val_pro.dart';
import 'package:pos_account/providers/setting/general/product_cat_pro.dart';
import 'package:pos_account/screens/home_screen/com/items/tabs/setting_tab/com/general/common/add_new_sec_w_image.dart';
import 'package:pos_account/services/image/image_service.dart';
import 'package:pos_account/widgets/dialog/confirm_dialog.dart';
import 'package:pos_account/widgets/input/color_pick_sec.dart';
import 'package:pos_account/widgets/input/text_form/text_form_widget.dart';
import 'package:pos_account/widgets/loading.dart';
import 'package:pos_account/widgets/no_items_sec.dart';
import 'package:provider/provider.dart';
import '../../common/table_data.dart';
import '../../general_set.dart';

class CategorySet extends StatefulWidget {
  final PageController pageController;
  const CategorySet({super.key, required this.pageController});

  @override
  State<CategorySet> createState() => _CategorySetState();
}

class _CategorySetState extends State<CategorySet>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();

  ProductCatPro? _prodCat;

  late TabController _tabController;

  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this);
    setData();
    super.initState();
  }

  setData() async {
    _prodCat = Provider.of<ProductCatPro>(context, listen: false);
    if (_prodCat != null) {
      _prodCat!.loading = true;
      _prodCat!.init();
      _prodCat!.getImageList();
      await _prodCat!.getData(page: 1);
    }
  }

  paginate(int page) {
    if (_prodCat != null) {
      _prodCat!.loading = true;
      _prodCat!.notify();
      _prodCat!.getData(page: page);
    }
  }

  @override
  void dispose() {
    _prodCat?.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = Ssize(context);
    final prodCat = Provider.of<ProductCatPro>(context);

    return Processing(
      loading: prodCat.loading,
      child: DefaultTabController(
        length: 2,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SettingsTabRow(
              addTitle: "Add Category",
              viewTitle: "Category List",
              tabController: _tabController,
              pageController: widget.pageController,
              onTap: (int i) {
                if (i == 0) {
                  prodCat.clear();
                }
                Future.delayed(Duration(milliseconds: 300), () {
                  if (i == 0) {
                    prodCat.getData();
                  } else {
                    prodCat.notify();
                  }
                });
              },
            ),
            SizedBox(
              height: size.getH(6),
            ),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 20.0),
                    child: Column(
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
                            cltr: prodCat.searchCltr,
                            hintText: LN.search,
                            onChanged: (p0) {
                              if (p0 == null) return;

                              Utils.handleSearch(callback: () async {
                                prodCat.loading = true;
                                prodCat.notify;
                                prodCat.getData();
                              });
                            },
                            suffixIcon: prodCat.searchCltr.text.isEmpty
                                ? null
                                : InkWell(
                                    onTap: () {
                                      prodCat.searchCltr.clear();
                                      prodCat.getData();
                                      prodCat.notify;
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
                        if (prodCat.loading ||
                            prodCat.getTableList.tableDataList.isNotEmpty)
                          Flexible(
                            child: SingleChildScrollView(
                              child: TableData(
                                popUpMenuItems: (int _) => [
                                  if (GlobalCVP.viewWidget.viewCategoryEdit)
                                    LN.edit,
                                  if (GlobalCVP.viewWidget.viewCategoryDelete)
                                    LN.delete,
                                ],
                                showDeleteBtn:
                                    GlobalCVP.viewWidget.viewCategoryBulkDelete,
                                tableData: prodCat.getTableList,
                                deleteItem: (items) {
                                  showDialog(
                                      context: context,
                                      builder: (builder) => ConfirmDialog(
                                            title: items.length > 1
                                                ? "${items.length} ${LN.categories}"
                                                : "${items[prodCat.getTableList.nameIndex].name}",
                                            onDelete: () async {
                                              prodCat.deleteData(
                                                  prodCats: items);
                                              return null;
                                            },
                                          ));
                                  //
                                },
                                selectItem: (count) {
                                  prodCat.setCountSCatI = count;
                                },
                                paginate: paginate,
                                total: prodCat.getPCats?.total,
                                page: prodCat.getPage,
                                onAction: prodCat.loading
                                    ? null
                                    : (p0, moreFun) {
                                        prodCat
                                            .editProdCat(id: p0.id)
                                            .then((val) {
                                          if (val ?? false) {
                                            _tabController.animateTo(1);
                                            Future.delayed(
                                                Duration(milliseconds: 500),
                                                () {
                                              prodCat.notify();
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
                                size: size,
                                title: 'No categories have been added yet.'),
                          ),
                      ],
                    ),
                  ),
                  SingleChildScrollView(
                    physics: BouncingScrollPhysics(),
                    child: Form(
                      key: _formKey,
                      child: AddNewSectionWImage(
                        width: 270,
                        showSaveBtn:
                            GlobalCVP.viewWidget.viewCategorySaveButton,
                        tableTitle: LN.addNewCategory,
                        tableList: prodCat.tableData,
                        getStatus: prodCat.getStatusCat,
                        // imageList: prodCat.addSection?.productCategoriesImages,
                        // onSelectImage: (String? imageId) {
                        //   prodCat.imageId = imageId;
                        //   prodCat.notify();
                        // },
                        imageUrl: prodCat.uploadImageUrl,
                        uploadImage: () {
                          if (prodCat.uploadImageUrl != null &&
                              prodCat.uploadImageUrl!.isNotEmpty) {
                            prodCat.uploadImageUrl = null;
                            prodCat.notify();
                          } else {
                            ImageService.filePick().then((value) {
                              prodCat.uploadImage();
                              prodCat.uploadImageUrl = value;
                              prodCat.notify();
                            });
                          }
                        },
                        setStatus: (val) {
                          prodCat.setStatusCat = val;
                        },
                        onAdd: prodCat.loading
                            ? null
                            : () async {
                                if (_formKey.currentState!.validate()) {
                                  if (prodCat
                                      .tableData[2].tableCltr.text.isEmpty) {
                                    showToast(LN.invalidSortNumber);
                                    return;
                                  }
                                  await prodCat.addUpData();
                                }
                              },
                        onCancel: () {
                          prodCat.clear();
                          prodCat.notify();
                        },
                        isNew: prodCat.editData == null,
                        newWidget: SizedBox(
                          width: size.getW(270),
                          child: GSTextSection(
                            title: LN.catType,
                            isReq: true,
                            indexVal: prodCat.catTypeIndex,
                            list: prodCat.addSection?.categoryTypes == null
                                ? []
                                : prodCat.addSection!.categoryTypes!
                                    .map((e) => e.value ?? '')
                                    .toList(),
                            onChanged: (int? val) {
                              prodCat.catTypeIndex = val;
                              prodCat.notify();
                            },
                            hintText: LN.chooseCatType,
                          ),
                        ),
                        bottomWidget: _bottomWidget(size, prodCat: prodCat),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _bottomWidget(
    Ssize size, {
    required ProductCatPro prodCat,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: size.getH(12)),
        _cardSection(
          size,
          iconData: Icons.filter,
          title: LN.filterTypes,
          onTap: () => prodCat.notify(),
          list: prodCat.addSection?.filterTypes,
        ),
        SizedBox(
          height: size.getW(12),
        ),
        _cardSection(
          size,
          iconData: Icons.device_hub,
          title: LN.channel,
          onTap: () => prodCat.notify(),
          list: prodCat.addSection?.channels,
        ),
        SizedBox(
          height: size.getW(12),
        ),
        _cardSection(
          size,
          iconData: Icons.desktop_mac_outlined,
          title: LN.posDevice,
          onTap: () => prodCat.notify(),
          list: prodCat.addSection?.posDevices,
        ),
        SizedBox(
          height: size.getW(12),
        ),
        // ColorPickerSection(),
        Card(
          elevation: 1,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(color: Colors.black12),
          ),
          child: Padding(
            padding: EdgeInsets.all(size.getS(16)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: size.getS(32),
                      height: size.getS(32),
                      decoration: BoxDecoration(
                        color: kSecondaryColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        Icons.color_lens,
                        size: size.getS(20),
                        color: kSecondaryColor,
                      ),
                    ),
                    SizedBox(width: size.getW(16)),
                    Text(
                      "Category Color Setup",
                      style: TextStyle(
                        fontSize: size.getS(18),
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
                Padding(
                    padding: EdgeInsets.only(top: size.getH(12)),
                    child: Wrap(
                      spacing: size.getW(24),
                      runSpacing: size.getH(24),
                      children: [
                        _colorSec(
                          size,
                          title: "Default Background Color",
                          textCltr: prodCat.defaultBackgroundColorCltr,
                          color: prodCat.deBackcolor,
                          onColorChanged: (val) {
                            prodCat.deBackcolor = val;
                            prodCat.defaultBackgroundColorCltr.text =
                                Utils.hexCode(val);
                            prodCat.notify();
                          },
                        ),
                        _colorSec(
                          size,
                          title: "Default Text Color",
                          textCltr: prodCat.defaultTextColorCltr,
                          color: prodCat.deTextcolor,
                          onColorChanged: (val) {
                            prodCat.deTextcolor = val;
                            prodCat.defaultTextColorCltr.text =
                                Utils.hexCode(val);
                            prodCat.notify();
                          },
                        ),
                        _colorSec(
                          size,
                          title: "Focus Background Color",
                          textCltr: prodCat.onFocusBackgroundColorCltr,
                          color: prodCat.foBackcolor,
                          onColorChanged: (val) {
                            prodCat.foBackcolor = val;
                            prodCat.onFocusBackgroundColorCltr.text =
                                Utils.hexCode(val);
                            prodCat.notify();
                          },
                        ),
                        _colorSec(
                          size,
                          title: "Focus Text Color",
                          textCltr: prodCat.onFocusTextsColorCltr,
                          color: prodCat.foTextcolor,
                          onColorChanged: (val) {
                            prodCat.foTextcolor = val;
                            prodCat.onFocusTextsColorCltr.text =
                                Utils.hexCode(val);
                            prodCat.notify();
                          },
                        )
                      ],
                    ))
              ],
            ),
          ),
        ),
        SizedBox(
          height: size.getW(12),
        ),
      ],
    );
  }

  Widget _colorSec(
    Ssize size, {
    required String title,
    required TextEditingController textCltr,
    required Color color,
    required Function(Color color) onColorChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: size.getS(18),
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        SizedBox(height: size.getH(8)),
        ColorPickerSection(
            textCltr: textCltr,
            selectedColor: color,
            onColorChanged: onColorChanged)
      ],
    );
  }

  Widget _cardSection(
    Ssize size, {
    IconData? iconData,
    required String title,
    required Function() onTap,
    List<TableLocation>? list,
  }) {
    final _isAllSelected =
        !(list?.any((e) => e.isSelected != null && !e.isSelected!) ?? false);
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.black12),
      ),
      child: Padding(
        padding: EdgeInsets.all(size.getS(16)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (iconData != null)
                  Container(
                    width: size.getS(32),
                    height: size.getS(32),
                    decoration: BoxDecoration(
                      color: kSecondaryColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      iconData,
                      size: size.getS(20),
                      color: kSecondaryColor,
                    ),
                  ),
                SizedBox(width: size.getW(16)),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: size.getS(18),
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                SizedBox(width: size.getW(16)),
                if (list != null)
                  InkWell(
                    onTap: () {
                      if (!list
                          .any((e) => e.isSelected != null && !e.isSelected!)) {
                        for (final e in list) {
                          e.isSelected = false;
                        }
                      } else {
                        for (final e in list) {
                          e.isSelected = true;
                        }
                      }
                      onTap();
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(
                          vertical: size.getH(4), horizontal: size.getW(12)),
                      decoration: BoxDecoration(
                          color:
                              _isAllSelected ? kSecondaryColor : Colors.white,
                          borderRadius: BorderRadius.circular(5),
                          border: Border.all(color: kSecondaryColor)),
                      child: Row(
                        children: [
                          Text(
                            LN.selectAll,
                            style: TextStyle(
                              fontSize: size.getS(14),
                              fontWeight: FontWeight.bold,
                              color: _isAllSelected
                                  ? Colors.white
                                  : kSecondaryColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
              ],
            ),
            if (list != null)
              Padding(
                padding: EdgeInsets.only(top: size.getH(12)),
                child: Wrap(
                  spacing: size.getW(12),
                  runSpacing: size.getH(24),
                  children: List.generate(
                      list.length,
                      (index) => Container(
                            decoration: BoxDecoration(
                                color: (list[index].isSelected ?? false)
                                    ? kSecondaryColor.withOpacity(0.1)
                                    : Colors.white,
                                borderRadius: BorderRadius.circular(5),
                                border: Border.all(
                                    color: (list[index].isSelected ?? false)
                                        ? kSecondaryColor
                                        : Colors.grey)),
                            child: InkWell(
                              onTap: () {
                                list[index].isSelected =
                                    !(list[index].isSelected ?? false);
                                onTap();
                              },
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                    vertical: size.getH(6),
                                    horizontal: size.getW(16)),
                                child: Text(
                                  list[index].value ?? "",
                                  style: TextStyle(
                                    fontSize: size.getS(18),
                                    color: (list[index].isSelected ?? false)
                                        ? kSecondaryColor
                                        : Colors.black,
                                    fontWeight:
                                        (list[index].isSelected ?? false)
                                            ? FontWeight.bold
                                            : FontWeight.normal,
                                  ),
                                ),
                              ),
                            ),
                          )),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
