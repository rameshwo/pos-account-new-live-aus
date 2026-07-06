import 'package:flutter/material.dart';
import 'package:pos_account/config/size_config.dart';
import 'package:pos_account/config/utils/utils.dart';
import 'package:pos_account/ln.dart';
import 'package:pos_account/providers/cus_val_pro.dart';
import 'package:pos_account/providers/setting/general/product_brand_pro.dart';
import 'package:pos_account/screens/home_screen/com/items/tabs/setting_tab/com/general/common/add_new_sec_w_image.dart';
import 'package:pos_account/services/image/image_service.dart';
import 'package:pos_account/widgets/dialog/confirm_dialog.dart';
import 'package:pos_account/widgets/input/text_form/text_form_widget.dart';
import 'package:pos_account/widgets/loading.dart';
import 'package:pos_account/widgets/no_items_sec.dart';
import 'package:provider/provider.dart';
import '../../common/table_data.dart';
import '../../general_set.dart';

class BrandSet extends StatefulWidget {
  final PageController pageController;
  const BrandSet({super.key, required this.pageController});

  @override
  State<BrandSet> createState() => _BrandSetState();
}

class _BrandSetState extends State<BrandSet>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();

  ProductBrandPro? _prodBrand;

  late TabController _tabController;

  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this);
    super.initState();
    setData();
  }

  setData() async {
    _prodBrand = Provider.of<ProductBrandPro>(context, listen: false);
    if (_prodBrand != null) {
      _prodBrand!.init();
      await _prodBrand!.getData(page: 1);
    }
  }

  paginate(int page) {
    if (_prodBrand != null) {
      _prodBrand!.loading = true;
      _prodBrand!.notify();
      _prodBrand!.getData(page: page);
    }
  }

  @override
  void dispose() {
    _prodBrand?.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = Ssize(context);
    final prodBrand = Provider.of<ProductBrandPro>(context);
    return Processing(
      loading: prodBrand.loading,
      child: DefaultTabController(
        length: 2,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SettingsTabRow(
              addTitle: "Add Brands",
              viewTitle: "Brands List",
              tabController: _tabController,
              pageController: widget.pageController,
              onTap: (int i) {
                if (i == 0) {
                  prodBrand.clear();
                }
                Future.delayed(Duration(milliseconds: 300), () {
                  if (i == 0) {
                    prodBrand.getData();
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
                      cltr: prodBrand.searchCltr,
                      hintText: LN.search,
                      onChanged: (p0) {
                        if (p0 == null) return;

                        Utils.handleSearch(callback: () async {
                          prodBrand.loading = true;
                          prodBrand.notify;
                          prodBrand.getData();
                        });
                      },
                      suffixIcon: prodBrand.searchCltr.text.isEmpty
                          ? null
                          : InkWell(
                              onTap: () {
                                prodBrand.searchCltr.clear();
                                prodBrand.getData();
                                prodBrand.notify;
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
                  if (prodBrand.loading ||
                      prodBrand.tableList.tableDataList.isNotEmpty)
                    Flexible(
                      child: SingleChildScrollView(
                        child: TableData(
                          popUpMenuItems: (int _) => [
                            if (GlobalCVP.viewWidget.viewBrandEdit) LN.edit,
                            if (GlobalCVP.viewWidget.viewBrandDelete) LN.delete,
                          ],
                          showDeleteBtn:
                              GlobalCVP.viewWidget.viewBrandBulkDelete,
                          tableData: prodBrand.tableList,
                          deleteItem: (items) {
                            showDialog(
                                context: context,
                                builder: (builder) => ConfirmDialog(
                                      title: items.length > 1
                                          ? "${items.length} ${LN.brand}"
                                          : "${items[0].name}",
                                      onDelete: () async {
                                        prodBrand.deleteData(prodBrands: items);
                                        return null;
                                      },
                                    ));
                          },
                          selectItem: (count) {
                            prodBrand.setCountSBrI = count;
                          },
                          paginate: paginate,
                          total: prodBrand.getPBrands?.total,
                          page: prodBrand.getPage,
                          onAction: prodBrand.loading
                              ? null
                              : (p0, moreFun) {
                                  prodBrand.editBrand(p0.id ?? '').then((val) {
                                    if (val ?? false) {
                                      _tabController.animateTo(1);
                                      Future.delayed(
                                          Duration(milliseconds: 500), () {
                                        prodBrand.notify();
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
                          size: size, title: 'No brands have been added yet.'),
                    )
                ],
              ),
              SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: AddNewSectionWImage(
                    showSaveBtn: GlobalCVP.viewWidget.viewBrandSaveButton,
                    tableTitle: LN.addNewBrand,
                    tableList: prodBrand.tableData,
                    getStatus: prodBrand.getStatusBrand,
                    setStatus: (p0) {
                      prodBrand.setStatusBrand = p0;
                    },
                    imageUrl: prodBrand.uploadImageUrl,
                    uploadImage: () {
                      if (prodBrand.uploadImageUrl != null &&
                          prodBrand.uploadImageUrl!.isNotEmpty) {
                        prodBrand.uploadImageUrl = null;
                        prodBrand.notify();
                      } else
                        ImageService.filePick().then((value) {
                          prodBrand.uploadImageUrl = value;
                          prodBrand.notify();
                        });
                    },
                    onAdd: prodBrand.loading
                        ? null
                        : () async {
                            if (_formKey.currentState!.validate()) {
                              await prodBrand.addUpData();
                            }
                          },
                    onCancel: () {
                      prodBrand.clear();
                      prodBrand.notify();
                    },
                    isNew: prodBrand.itemId.isEmpty ? true : false,
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
