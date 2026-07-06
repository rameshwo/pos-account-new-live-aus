import 'package:flutter/material.dart';
import 'package:oktoast/oktoast.dart';
import 'package:pos_account/config/size_config.dart';
import 'package:pos_account/constant/constant.dart';
import 'package:pos_account/ln.dart';
import 'package:pos_account/providers/cus_val_pro.dart';
import 'package:pos_account/providers/product/set_menu_pro.dart';
import 'package:pos_account/screens/home_screen/com/items/tabs/setting_tab/com/general/common/common_header.dart';
import 'package:pos_account/widgets/input/dropdown/tree_dropdown/tree_dropdown.dart';
import 'package:pos_account/widgets/load_btn.dart';
import 'package:pos_account/widgets/loading.dart';
import 'package:pos_account/widgets/image/p_image_sec.dart';
import 'package:pos_account/widgets/input/dropdown/title_drop_down.dart';
import 'package:pos_account/widgets/input/text_form/title_text_form.dart';
import 'package:pos_account/widgets/switch_adap.dart';
import 'package:pos_account/widgets/title_pop.dart';
import 'package:provider/provider.dart';
import 'com/all_set_menu.dart';
import 'com/check_box_sec.dart';
import 'com/set_menu_product.dart';

class CreateSetMenu extends StatefulWidget {
  final Function()? onBack;
  const CreateSetMenu({super.key, this.onBack});

  @override
  State<CreateSetMenu> createState() => _CreateSetMenuState();
}

class _CreateSetMenuState extends State<CreateSetMenu>
    with TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();

  TabController? _tabCltr;

  void _tabCltrSetup({int index = 0}) {
    if (_setMenuPro?.productList?.isNotEmpty ?? false) {
      final index0 = _setMenuPro!.productList!.length > index
          ? index
          : _setMenuPro!.productList!.length - 1;

      _tabCltr = TabController(
          initialIndex: index0,
          length: _setMenuPro!.productList!.length,
          vsync: this);
    }
  }

  @override
  void initState() {
    getData();
    super.initState();
    _parentController.addListener(_handleParentScroll);
    _childController.addListener(_handleChildScroll);
  }

  void _handleParentScroll() {
    if (_parentController.position.pixels >=
        _parentController.position.maxScrollExtent) {
      // Parent scroll reaches bottom -> Enable child scroll
      if (_isChildScrollable() && mounted)
        setState(() {
          isChildScrolling = true;
        });
    }
  }

  void _handleChildScroll() {
    if (_childController.position.pixels <= 0 && mounted) {
      // Child reaches top -> Enable parent scroll
      setState(() {
        isChildScrolling = false;
      });
    }
  }

  SetMenuPro? _setMenuPro;

  getData() {
    _setMenuPro = Provider.of<SetMenuPro>(context, listen: false);
    _setMenuPro?.getData();
  }

  //TODO:

  // addDescription(
  //     {required Ssize size,
  //     required SetMenuPro setMenuPro,
  //     required int index}) {
  //   return showDialog(
  //       context: context,
  //       builder: (builder) => AddSingleDataDia(
  //             size: size,
  //             desCltr: setMenuPro.prodCatDesList[index].desCltr,
  //             countCltr: setMenuPro.prodCatDesList[index].countCltr,
  //             onAdd: () {
  //               final _count = double.tryParse(
  //                   setMenuPro.prodCatDesList[index].countCltr.text);
  //               if (setMenuPro.prodCatDesList[index].desCltr.text.isEmpty) {
  //                 showToast("Description is empty");
  //                 return;
  //               } else if (_count != null &&
  //                   _count != 0 &&
  //                   _count >
  //                       setMenuPro
  //                           .productList![index].productVariations!.length) {
  //                 showToast("Max count is greater than product list");
  //                 return;
  //               }
  //               Navigator.pop(context);
  //             },
  //           ));
  // }

  showAllSetMenu() {
    return showDialog(
        context: context,
        builder: (builder) => SimpleDialog(
              backgroundColor: kBackgroundColor,
              titlePadding: EdgeInsets.zero,
              contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 0),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15)),
              children: [
                AllSetMenu(
                  onEdit: () => _tabCltrSetup(index: 0),
                )
              ],
            ));
  }

  @override
  void dispose() {
    _setMenuPro?.clear();
    _setMenuPro?.loading = true;
    _setMenuPro?.setMenuRes = null;
    _setMenuPro?.setCatList.clear();
    if (_tabCltr != null) _tabCltr!.dispose();
    _parentController.dispose();
    _childController.dispose();
    super.dispose();
  }

  final _parentController = ScrollController();
  final _childController = ScrollController();
  bool isChildScrolling = false;

  bool _isChildScrollable() {
    // Check if child ListView is scrollable
    return _childController.hasClients &&
        _childController.position.maxScrollExtent > 0;
  }

  @override
  Widget build(BuildContext context) {
    final size = Ssize(context);
    final setMenuPro = Provider.of<SetMenuPro>(context);
    final prodCatList = setMenuPro.setMenuRes?.productCategories
        ?.where((e) => e.isActive ?? true)
        .toList();
    return Processing(
      loading: setMenuPro.loading,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CommonHeader(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TitlePop(
                  title: setMenuPro.editSetMenu == null
                      ? LN.createSetMenuCom
                      : LN.updateSetMenuCom,
                  size: size,
                  onTap: () {
                    setMenuPro.clear();
                    setMenuPro.setMenuRes = null;
                    _setMenuPro?.loading = true;
                    _setMenuPro?.setCatList.clear();
                    if (widget.onBack != null) {
                      widget.onBack!();
                    }
                  },
                ),
                if (GlobalCVP.viewWidget.viewSetMenuListButton)
                  ElevatedButton(
                      style: ButtonStyle(
                          backgroundColor: WidgetStateProperty.all(kTempColor),
                          padding: WidgetStateProperty.all(EdgeInsets.symmetric(
                              horizontal: size.getW(48),
                              vertical: size.getH(8)))),
                      onPressed: () {
                        showAllSetMenu();
                      },
                      child: Text(
                        LN.allSetMenu,
                        style: TextStyle(
                          fontSize: size.getS(16),
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      )),
              ],
            ),
          ),
          SizedBox(height: size.getH(8)),
          Flexible(
            child: Form(
              key: _formKey,
              child: SingleChildScrollView(
                controller: _parentController,
                physics: isChildScrolling
                    ? NeverScrollableScrollPhysics()
                    : BouncingScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Card(
                      child: SizedBox(
                        width: double.infinity,
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                              vertical: size.getH(12.0),
                              horizontal: size.getW(24)),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                height: size.getH(12),
                              ),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Flexible(
                                    child: Wrap(
                                      spacing: size.getW(24),
                                      runSpacing: size.getH(32),
                                      crossAxisAlignment:
                                          WrapCrossAlignment.start,
                                      children: [
                                        TitleTextForm(
                                          title: LN.nameOfSetMenu,
                                          textCltr: setMenuPro.nameCltr,
                                          pWidth: 0.20,
                                        ),
                                        TreeDropWidget(
                                          vPad: 8,
                                          isReq: true,
                                          width: size.width * 0.20,
                                          dialogWidth: size.width / 2,
                                          mode: Mode.DIALOG,
                                          selectedColor: kSecondaryColor,
                                          title: LN.category,
                                          borderColor: Colors.black,
                                          hintText: LN.chooseCategory,
                                          categoryList: setMenuPro.setCatList,
                                          selectedId:
                                              setMenuPro.selectedSetCatId,
                                          onChanged: (p0) {
                                            setMenuPro.selectedSetCatId = p0;
                                            setMenuPro.notify();
                                          },
                                        ),
                                        TitleTextForm(
                                          title: LN.price,
                                          textCltr: setMenuPro.priceCltr,
                                          textInputType: TextInputType.number,
                                          pWidth: 0.20,
                                        ),
                                        TitleDropDown(
                                          title: LN.salesTax,
                                          pWidth: 0.20,
                                          isReq: true,
                                          list: setMenuPro
                                                      .setMenuRes?.salesTaxes ==
                                                  null
                                              ? []
                                              : setMenuPro
                                                  .setMenuRes!.salesTaxes!
                                                  .map((e) => e.value ?? '')
                                                  .toList(),
                                          indexVal: setMenuPro.taxTypeIndex,
                                          onChanged: (p0) {
                                            setMenuPro.taxTypeIndex = p0;
                                            setMenuPro.notify();
                                          },
                                        ),
                                        TitleTextForm(
                                          title: '${LN.discountPercent}(%)',
                                          isReq: false,
                                          textCltr: setMenuPro.discountPerCltr,
                                          textInputType: TextInputType.number,
                                          pWidth: 0.20,
                                          suffixIcon: Text("%"),
                                          suffixIconWidth: 32,
                                        ),
                                        TitleTextForm(
                                          title: LN.description,
                                          textCltr: setMenuPro.descCltr,
                                          pWidth: 0.20,
                                          isReq: false,
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    width: size.getW(48),
                                  ),
                                  SizedBox(
                                    width: size.width * 0.22, //size.getW(328),
                                    height: size.getH(170),
                                    child: PImageSection(
                                      hintText: LN.addSetMenuImage,
                                      imagePath: setMenuPro.getFilePath,
                                      onTap: () {
                                        setMenuPro.getFilePick();
                                      },
                                    ),
                                  )
                                ],
                              ),
                              SizedBox(
                                height: size.getH(24),
                              ),
                              Wrap(
                                spacing: size.getW(24),
                                runSpacing: size.getH(32),
                                crossAxisAlignment: WrapCrossAlignment.start,
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        LN.setMenuStatus,
                                        style: TextStyle(
                                          fontSize: size.getS(16),
                                          fontFamily: kFontFMedium,
                                          color: Colors.black,
                                        ),
                                      ),
                                      SizedBox(
                                        height: size.getH(12),
                                      ),
                                      Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          SwitchAdap(
                                            value: setMenuPro.activeStatus,
                                            size: size,
                                            onChanged: (val) {
                                              setMenuPro.activeStatus = val;
                                              setMenuPro.notify();
                                            },
                                          ),
                                          SizedBox(
                                            width: size.getW(12),
                                          ),
                                          Text(
                                            setMenuPro.activeStatus
                                                ? LN.active
                                                : LN.inActive,
                                            style: TextStyle(
                                              fontSize: size.getS(16),
                                              color: setMenuPro.activeStatus
                                                  ? kSecondaryColor
                                                  : Colors.red.shade700,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  )
                                ],
                              ),
                              SizedBox(
                                height: size.getH(24),
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    LN.categories,
                                    style: TextStyle(
                                      fontSize: size.getS(18),
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                    ),
                                  ),
                                  SizedBox(
                                    height: size.getH(12),
                                  ),
                                  (prodCatList?.isNotEmpty ?? false)
                                      ? GridView.count(
                                          crossAxisCount: size.isProt ? 4 : 4,
                                          childAspectRatio: 5,
                                          shrinkWrap: true,
                                          physics:
                                              NeverScrollableScrollPhysics(),
                                          mainAxisSpacing: size.getW(20),
                                          crossAxisSpacing: size.getH(10),
                                          children: List.generate(
                                              prodCatList!.length,
                                              (index) => CheckBoxSection(
                                                    size: size,
                                                    checked: prodCatList[index]
                                                            .isSelected ??
                                                        false,
                                                    title: prodCatList[index]
                                                            .value ??
                                                        "",
                                                    onChanged: setMenuPro
                                                            .loading
                                                        ? null
                                                        : (val) async {
                                                            prodCatList[index]
                                                                    .isSelected =
                                                                val;
                                                            setMenuPro.notify();
                                                            final List<String>
                                                                ids =
                                                                prodCatList
                                                                    .where((e) =>
                                                                        e.isSelected !=
                                                                            null &&
                                                                        e
                                                                            .isSelected! &&
                                                                        e.id !=
                                                                            null)
                                                                    .map((f) =>
                                                                        f.id!)
                                                                    .toList();
                                                            await setMenuPro
                                                                .getAllProdByProd(
                                                                    ids: ids);
                                                            _tabCltrSetup(
                                                                index: _tabCltr
                                                                        ?.index ??
                                                                    0);
                                                          },
                                                  )),
                                        )
                                      : SizedBox.shrink(),
                                ],
                              ),
                              SizedBox(
                                height: size.getH(24),
                              ),
                              Row(
                                children: [
                                  if (GlobalCVP
                                      .viewWidget.viewCreateSetMenuButton)
                                    LoadButton(
                                      onsave: setMenuPro.addButtonLoad
                                          ? null
                                          : () {
                                              if (setMenuPro.productList !=
                                                      null &&
                                                  setMenuPro
                                                      .productList!
                                                      .any((a) =>
                                                          a.productVariations !=
                                                              null &&
                                                          a.productVariations!
                                                              .any((b) => b
                                                                  .isSelected))) {
                                                // print(_formKey.currentState!
                                                //     .validate());
                                                if (_formKey.currentState!
                                                    .validate()) {
                                                  setMenuPro.addUpSetMenu();
                                                }
                                              } else {
                                                showToast(
                                                    'Please select at least one category and their product');
                                              }
                                            },
                                      loading: setMenuPro.addButtonLoad,
                                      btnText: setMenuPro.editSetMenu == null
                                          ? LN.createSetMenu
                                          : LN.updateSetMenu,
                                      width: 210,
                                      vPad: 12,
                                      hPad: 12,
                                    ),
                                  // ElevatedButton(
                                  //     style: ButtonStyle(
                                  //         backgroundColor: MaterialStateProperty.all(
                                  //             setMenuPro.loading
                                  //                 ? Colors.grey
                                  //                 : kSecondaryColor),
                                  //         padding: MaterialStateProperty.all(
                                  //             EdgeInsets.symmetric(
                                  //                 horizontal: size.getW(16),
                                  //                 vertical: size.getH(12)))),
                                  //     onPressed: setMenuPro.loading
                                  //         ? null
                                  //         : () {
                                  //             if (_formKey.currentState!.validate()) {
                                  //               setMenuPro.addUpSetMenu();
                                  //             }
                                  //           },
                                  //     child: Row(
                                  //       mainAxisSize: MainAxisSize.min,
                                  //       children: [
                                  //         Icon(Icons.add),
                                  //         SizedBox(
                                  //           width: size.getW(6),
                                  //         ),
                                  //         Text(
                                  //           setMenuPro.editSetMenu == null
                                  //               ? LN.createSetMenu
                                  //               : LN.updateSetMenu,
                                  //           style: TextStyle(
                                  //             fontSize: size.getS(16),
                                  //             color: Colors.white,
                                  //             fontWeight: FontWeight.bold,
                                  //           ),
                                  //         ),
                                  //       ],
                                  //     )),
                                  SizedBox(
                                    width: size.getW(12),
                                  ),
                                  if (setMenuPro.editSetMenu != null)
                                    ElevatedButton(
                                        style: ButtonStyle(
                                            backgroundColor:
                                                MaterialStateProperty.all(
                                                    Colors.red.shade600),
                                            padding: MaterialStateProperty.all(
                                                EdgeInsets.symmetric(
                                                    horizontal: size.getW(16),
                                                    vertical: size.getH(12)))),
                                        onPressed: () {
                                          setMenuPro.clear();
                                          setMenuPro.notify();
                                        },
                                        child: Text(
                                          LN.cancel,
                                          style: TextStyle(
                                            fontSize: size.getS(16),
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        )),
                                ],
                              ),
                              SizedBox(
                                height: size.getH(12),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    SetMenuProducts(
                      tabCltr: _tabCltr,
                      childScrollCltr: _childController,
                      isChildScrolling:
                          (_isChildScrollable() && isChildScrolling),
                      onTapCat: () {
                        _childController.animateTo(0,
                            duration: Duration(milliseconds: 200),
                            curve: Curves.easeInOut);
                        isChildScrolling = false;
                        setState(() {});
                      },
                    )
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
