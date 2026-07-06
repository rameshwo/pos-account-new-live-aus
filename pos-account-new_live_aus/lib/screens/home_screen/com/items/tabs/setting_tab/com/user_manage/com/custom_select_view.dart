// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:pos_account/config/size_config.dart';
import 'package:pos_account/constant/constant.dart';
import 'package:pos_account/ln.dart';
import 'package:pos_account/widgets/input/text_form/text_form_widget.dart';
import 'package:pos_account/widgets/load_btn.dart';
import 'package:pos_account/widgets/loading.dart';
import 'package:pos_account/widgets/no_items_sec.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../../../../../../../../model/home/product/setmenu/prod_by_prod_res.dart';
import '../../../../../../../../../model/home/setting/pos_device/printer_product/printer_prod_detail_res.dart';
import '../../../../../../../../../model/profile/assign_service_model.dart';

class CustomSelectView extends StatefulWidget {
  final ProductCategoryVariationList? catVars;
  final List<ParentProductCategory> servicesTypesList;
  final bool loading;
  final TextEditingController searchCltr;
  final TextEditingController filterCltr;
  final Function(String) onTapCategory;
  final Function(int) onTapSubCategory;
  final Function(String id, bool isSelected) onTapProduct;
  final Function() onChangeFilter;
  final Function() onChangeSearch;
  final Function(String id, String categoryId)? onTapAssignedProduct;
  final Function(bool) selectAll;
  int? selectedSubCatIndex;
  List<ProductCategoryVariationList>? selectedList;
  List<PrinterProductVariation>? allAssignedList;
  final ProdByProdCatRes? subCatServList;
  final ProdByProdCatRes? catServList;
  final Function() onSave;
  final Function()? onTapViewAssignedItems;
  final String type;
  final Widget topWidget;
  final bool disable;
  final String? title;
  dynamic selectedCatId;
  bool? isSelected;
  bool? noSecFound;
  String? noSecFoundText;
  String? printerName;
  bool? showAssignedItems;
  final String? catTitle;
  CustomSelectView({
    super.key,
    required this.catVars,
    required this.loading,
    required this.servicesTypesList,
    required this.searchCltr,
    required this.filterCltr,
    required this.onTapCategory,
    required this.onTapSubCategory,
    required this.onTapProduct,
    required this.onChangeFilter,
    this.printerName,
    this.onTapAssignedProduct,
    required this.onChangeSearch,
    required this.selectAll,
    required this.onSave,
    required this.selectedCatId,
    required this.selectedList,
    required this.subCatServList,
    required this.catServList,
    required this.selectedSubCatIndex,
    this.allAssignedList,
    this.disable = false,
    required this.title,
    required this.type,
    required this.topWidget,
    this.isSelected = false,
    this.noSecFound = false,
    this.showAssignedItems = false,
    this.onTapViewAssignedItems,
    this.noSecFoundText,
    this.catTitle,
  });

  @override
  State<CustomSelectView> createState() => _PrinterProductSetState();
}

class _PrinterProductSetState extends State<CustomSelectView> {
  final refreshController = RefreshController(initialRefresh: false);
  final _pageController = PageController();

  @override
  Widget build(BuildContext context) {
    // final pro = UserManagePro();
    final size = Ssize(context);
    return Processing(
      loading: widget.loading,
      child: Container(
        constraints: BoxConstraints(
          maxHeight: size.height / 1.14,
          minHeight: size.height / 5,
        ),
        width: size.width / 1.15,
        child: PageView(
          physics: NeverScrollableScrollPhysics(),
          controller: _pageController,
          children: [
            _AssignItemTab(size: size),
            _ShowAssignedTab(size: size),
          ],
        ),
      ),
    );
  }

  Widget _AssignItemTab({required Ssize size}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              widget.title ?? "Setup",
              style: TextStyle(
                fontSize: size.getS(18),
                // fontFamily: ,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: Icon(Icons.close, size: size.getS(24)))
          ],
        ),
        widget.topWidget,
        widget.noSecFound ?? false
            ? NoItemsSec(
                size: size,
                title: widget.noSecFoundText ?? 'No section found',
              )
            : Expanded(
                child: _disableSection(
                  readOnly: widget.disable,
                  child: Card(
                    child: SizedBox(
                      width: double.infinity,
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: size.getW(12), vertical: size.getH(4)),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        SizedBox(
                                          height: size.getH(8),
                                        ),
                                        if (widget.catTitle != null)
                                          Text(
                                            widget.catTitle!,
                                            style: TextStyle(
                                              fontSize: size.getS(16),
                                              color: Colors.black,
                                              fontFamily: kFontFMedium,
                                            ),
                                          )
                                        else
                                          Text(
                                            "${widget.type} Types :",
                                            style: TextStyle(
                                              fontSize: size.getS(16),
                                              color: Colors.black,
                                              fontFamily: kFontFMedium,
                                            ),
                                          ),
                                        if (widget.servicesTypesList.isNotEmpty)
                                          Expanded(
                                            child: SingleChildScrollView(
                                                physics:
                                                    BouncingScrollPhysics(),
                                                child:
                                                    Builder(builder: (context) {
                                                  final list = widget
                                                      .servicesTypesList
                                                      .where((e) =>
                                                          e.name
                                                              ?.toLowerCase()
                                                              .contains(widget
                                                                  .filterCltr
                                                                  .text
                                                                  .toLowerCase()) ??
                                                          true)
                                                      .toList();
                                                  return Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: List.generate(
                                                          list.length, (index) {
                                                        final prod =
                                                            list[index];

                                                        final int noOfSelected = (widget
                                                                .servicesTypesList
                                                                .any((e) =>
                                                                    e.id?.toLowerCase() ==
                                                                    prod.id
                                                                        ?.toLowerCase()))
                                                            ? widget.selectedList
                                                                    ?.firstWhere(
                                                                      (e) =>
                                                                          e.categoryId
                                                                              ?.toLowerCase() ==
                                                                          prod.id
                                                                              ?.toLowerCase(),
                                                                      orElse: () =>
                                                                          ProductCategoryVariationList(
                                                                        categoryId:
                                                                            prod.id,
                                                                        productVariationIds: [],
                                                                      ),
                                                                    )
                                                                    .productVariationIds
                                                                    ?.length ??
                                                                0
                                                            : 0;

                                                        return TextButton(
                                                            onPressed: () {
                                                              widget
                                                                  .onTapCategory(
                                                                      list[index]
                                                                          .id!);
                                                            },
                                                            child: Row(
                                                              children: [
                                                                if (noOfSelected >
                                                                    0)
                                                                  Icon(
                                                                    Icons.check,
                                                                    size: size
                                                                        .getS(
                                                                            18),
                                                                    color: widget.selectedCatId ==
                                                                            list[index]
                                                                                .id
                                                                        ? kSecondaryColor
                                                                        : Colors
                                                                            .black,
                                                                  ),
                                                                SizedBox(
                                                                    width: size
                                                                        .getW(
                                                                            4)),
                                                                Flexible(
                                                                  child: Row(
                                                                    children: [
                                                                      Flexible(
                                                                        child:
                                                                            Text(
                                                                          (prod.name ??
                                                                              ''),
                                                                          style:
                                                                              TextStyle(
                                                                            fontSize:
                                                                                size.getS(16),
                                                                            color: widget.selectedCatId == list[index].id
                                                                                ? kSecondaryColor
                                                                                : Colors.black,
                                                                            fontFamily:
                                                                                kFontFMedium,
                                                                          ),
                                                                        ),
                                                                      ),
                                                                      Text(
                                                                          (noOfSelected == 0
                                                                              ? ''
                                                                              : ' ($noOfSelected)'),
                                                                          style:
                                                                              TextStyle(
                                                                            fontSize:
                                                                                size.getS(14),
                                                                            color: widget.selectedCatId == list[index].id
                                                                                ? kSecondaryColor
                                                                                : Colors.black,
                                                                            fontFamily:
                                                                                kFontFMedium,
                                                                          ))
                                                                    ],
                                                                  ),
                                                                ),
                                                              ],
                                                            ));
                                                      }));
                                                })),
                                          ),
                                        SizedBox(
                                          width: size.getW(200),
                                          child: TextFormWidget(
                                            vPad: 8,
                                            borderColor: Colors.black38,
                                            cltr: widget.filterCltr,
                                            hintText: 'Filter',
                                            suffixIconWidth: 40,
                                            onChanged: (val) {
                                              widget.onChangeFilter();
                                            },
                                            suffixIcon: widget
                                                    .filterCltr.text.isNotEmpty
                                                ? InkWell(
                                                    onTap: () {
                                                      widget.filterCltr.clear();
                                                      widget.onChangeFilter();
                                                    },
                                                    child: Icon(
                                                      Icons.close,
                                                      size: size.getS(24),
                                                    ))
                                                : Icon(
                                                    Icons.search,
                                                    size: size.getS(24),
                                                  ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  VerticalDivider(
                                    thickness: 1,
                                    color: Colors.black26,
                                  ),
                                  Expanded(
                                    flex: 6,
                                    child: Padding(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: size.getW(12),
                                          vertical: size.getH(12)),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    "Select ${widget.type}${widget.catVars?.productVariationIds?.isNotEmpty ?? false ? ' (${widget.catVars!.productVariationIds!.length})' : ''}",
                                                    style: TextStyle(
                                                      fontSize: size.getS(18),
                                                      color: Colors.black,
                                                      fontFamily: kFontFMedium,
                                                    ),
                                                  ),
                                                  if (widget.subCatServList !=
                                                          null &&
                                                      (widget
                                                              .subCatServList
                                                              ?.productVariations
                                                              ?.isNotEmpty ??
                                                          false))
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                          "Available ${widget.type}: ${widget.subCatServList?.productVariations?.length ?? 0}",
                                                          style: TextStyle(
                                                            fontSize:
                                                                size.getS(14),
                                                            color: Colors.black,
                                                          ),
                                                        ),
                                                        SizedBox(
                                                          width: size.getW(12),
                                                        ),
                                                        Text(
                                                          "Selected ${widget.type}: ${widget.subCatServList?.productVariations?.where((e) => widget.catVars?.productVariationIds?.contains(e.id) ?? false).length ?? 0}",
                                                          style: TextStyle(
                                                            fontSize:
                                                                size.getS(14),
                                                            color: Colors.black,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                ],
                                              ),
                                              Spacer(),
                                              if (widget.showAssignedItems ??
                                                  false)
                                                TextButton.icon(
                                                  onPressed: () {
                                                    _pageController
                                                        .jumpToPage(1);
                                                    widget.onTapViewAssignedItems !=
                                                            null
                                                        ? widget
                                                            .onTapViewAssignedItems!()
                                                        : null;
                                                  },
                                                  icon: Icon(
                                                    Icons.visibility,
                                                    size: size.getS(24),
                                                  ),
                                                  label: Text(
                                                    "View Assigned Products",
                                                    style: TextStyle(
                                                        fontSize:
                                                            size.getS(16)),
                                                  ),
                                                ),
                                              SizedBox(
                                                width: size.getW(300),
                                                child: TextFormWidget(
                                                  vPad: 10,
                                                  borderColor: Colors.black38,
                                                  cltr: widget.searchCltr,
                                                  hintText:
                                                      'Search ${widget.type}',
                                                  suffixIconWidth: 40,
                                                  // prefixIcon:
                                                  //     Icon(Icons.search),
                                                  onChanged: (val) {
                                                    widget.onChangeSearch();
                                                  },
                                                  suffixIcon: widget.searchCltr
                                                          .text.isNotEmpty
                                                      ? InkWell(
                                                          onTap: () {
                                                            widget.searchCltr
                                                                .clear();
                                                            widget
                                                                .onChangeSearch();
                                                          },
                                                          child: Icon(
                                                            Icons.close,
                                                            size: size.getS(24),
                                                          ))
                                                      : Icon(
                                                          Icons.search,
                                                          size: size.getS(24),
                                                        ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          Divider(
                                            height: 4,
                                          ),
                                          widget.selectedCatId == null ||
                                                  widget.selectedCatId == ""
                                              ? SizedBox.shrink()
                                              : SizedBox(
                                                  height: 45,
                                                  child: Row(
                                                    children: [
                                                      Expanded(
                                                        child: ListView.builder(
                                                          shrinkWrap: true,
                                                          scrollDirection:
                                                              Axis.horizontal,
                                                          itemCount: (widget
                                                                      .subCatServList
                                                                      ?.subCategories
                                                                      ?.length ??
                                                                  0) +
                                                              1,
                                                          itemBuilder:
                                                              (context, index) {
                                                            return Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .only(
                                                                      right: 8),
                                                              child: Container(
                                                                decoration:
                                                                    BoxDecoration(
                                                                  //border on bottom
                                                                  border: widget
                                                                              .selectedSubCatIndex ==
                                                                          index
                                                                      ? Border(
                                                                          bottom: BorderSide(
                                                                              color: kSecondaryColor,
                                                                              width: 2.0))
                                                                      : Border(
                                                                          bottom:
                                                                              BorderSide(
                                                                            color:
                                                                                Colors.transparent,
                                                                            width:
                                                                                2.0,
                                                                          ),
                                                                        ),
                                                                ),
                                                                child: Row(
                                                                  children: [
                                                                    TextButton(
                                                                      onPressed:
                                                                          () {
                                                                        widget.onTapSubCategory(
                                                                            index);
                                                                      },
                                                                      child:
                                                                          Text(
                                                                        index ==
                                                                                0
                                                                            ? 'All'
                                                                            : widget.subCatServList?.subCategories?[index - 1].name ??
                                                                                '',
                                                                        style:
                                                                            TextStyle(
                                                                          fontSize:
                                                                              size.getS(14),
                                                                          color:
                                                                              Colors.black,
                                                                          fontFamily:
                                                                              kFontFMedium,
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                            );
                                                          },
                                                        ),
                                                      ),
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .end,
                                                        children: [
                                                          Text('Select All',
                                                              style: TextStyle(
                                                                  fontSize: size
                                                                      .getS(14),
                                                                  color: Colors
                                                                      .black,
                                                                  fontFamily:
                                                                      kFontFMedium)),
                                                          Checkbox(
                                                              value: widget
                                                                          .catVars
                                                                          ?.productVariationIds !=
                                                                      null &&
                                                                  widget.subCatServList
                                                                          ?.productVariations !=
                                                                      null &&
                                                                  widget
                                                                      .subCatServList!
                                                                      .productVariations!
                                                                      .every((e) => widget
                                                                          .catVars!
                                                                          .productVariationIds!
                                                                          .contains(e
                                                                              .id)),
                                                              activeColor:
                                                                  kSecondaryColor,
                                                              onChanged: (va) {
                                                                widget.selectAll(
                                                                    va ??
                                                                        false);
                                                              }),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                          SizedBox(
                                            height: size.getH(8),
                                          ),
                                          (widget.selectedCatId == null ||
                                                  widget.selectedCatId == "")
                                              ? NoItemsSec(
                                                  size: size,
                                                  title:
                                                      "Please select a ${widget.type} category")
                                              : (widget.selectedCatId != null ||
                                                          widget.selectedCatId !=
                                                              "") &&
                                                      (widget
                                                              .subCatServList
                                                              ?.productVariations
                                                              ?.isEmpty ??
                                                          true)
                                                  ? NoItemsSec(
                                                      size: size,
                                                      title:
                                                          "No ${widget.type} available")
                                                  : Expanded(
                                                      child: _ProdView(
                                                        size: size,
                                                        catVars: widget.catVars,
                                                      ),
                                                    ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
        widget.noSecFound ?? false
            ? SizedBox.shrink()
            : Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  LoadButton(
                    // vPad: 0,
                    hPad: 0,
                    btnText: LN.cancel,
                    onsave: () {
                      Navigator.pop(context);
                    },
                    btnColor: Colors.white,
                    textColor: Colors.red,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5),
                        side: BorderSide(color: Colors.red)),
                  ),
                  SizedBox(
                    width: size.getW(24),
                  ),
                  LoadButton(
                    // vPad: 0,
                    hPad: 0,
                    loading: widget.loading,
                    btnText: LN.save,
                    onsave: () {
                      widget.onSave();
                    },
                  ),
                ],
              ),
        SizedBox(
          height: size.getH(18),
        ),
      ],
    );
  }

  Widget _ShowAssignedTab({required Ssize size}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                IgnorePointer(
                  ignoring: widget.disable,
                  child: IconButton(
                      onPressed: () {
                        _pageController.animateToPage(0,
                            duration: Duration(milliseconds: 300),
                            curve: Curves.easeIn);
                      },
                      icon: Icon(Icons.arrow_back)),
                ),
                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: "All Assigned ${widget.type} ",
                        style: TextStyle(
                          fontSize: size.getS(18),
                          // fontFamily: ,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      TextSpan(
                        text: "(${widget.printerName})",
                        style: TextStyle(
                          fontSize: size.getS(18),
                          // fontFamily: ,
                          fontWeight: FontWeight.bold,
                          color: kSecondaryColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            IconButton(
              onPressed: () {
                widget.allAssignedList = [];
                Navigator.pop(context);
              },
              icon: Icon(Icons.close),
            ),
          ],
        ),
        SizedBox(
          height: size.getH(18),
        ),
        (widget.allAssignedList == null || widget.allAssignedList!.isEmpty) &&
                !widget.loading
            ? Expanded(
                child: NoItemsSec(
                  size: size,
                  title: "No assigned ${widget.type} found",
                ),
              )
            : Expanded(
                child: Card(
                  child: SizedBox(
                    width: double.infinity,
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: size.getW(12), vertical: size.getH(4)),
                      child: SmartRefresher(
                        controller: refreshController,
                        enablePullDown: true,
                        onRefresh: () async {
                          widget.onTapViewAssignedItems != null
                              ? widget.onTapViewAssignedItems!()
                              : null;
                          refreshController.refreshCompleted();
                        },
                        child: SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Wrap(
                                spacing: size.getW(16),
                                runSpacing: size.getH(16),
                                children: List.generate(
                                  widget.allAssignedList?.length ?? 0,
                                  (i) {
                                    final data = widget.allAssignedList?[i];
                                    final isSelected = widget.selectedList?.any(
                                            (e) =>
                                                e.productVariationIds?.any(
                                                    (e) =>
                                                        e.toLowerCase() ==
                                                        data?.id
                                                            ?.toLowerCase()) ??
                                                false) ??
                                        false;

                                    return _productSec(
                                      size,
                                      title: data?.name,
                                      subtitle: data?.productCategoryName ?? '',
                                      isCheck: isSelected,
                                      onTap: () {
                                        if (data?.id == null ||
                                            data!.id!.isEmpty) return;
                                        widget.onTapAssignedProduct != null
                                            ? widget.onTapAssignedProduct!(
                                                data.id!,
                                                data.productCategoryId ?? '')
                                            : null;
                                      },
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
        SizedBox(
          height: size.getH(46),
        ),
        // Row(
        //   mainAxisAlignment: MainAxisAlignment.end,
        //   children: [
        //     LoadButton(
        //       vPad: 0,
        //       hPad: 0,
        //       btnText: LN.cancel,
        //       onsave: () {
        //         Navigator.pop(context);
        //       },
        //       btnColor: Colors.white,
        //       textColor: Colors.red,
        //       shape: RoundedRectangleBorder(
        //           borderRadius: BorderRadius.circular(5),
        //           side: BorderSide(color: Colors.red)),
        //     ),
        //     SizedBox(
        //       width: size.getW(24),
        //     ),
        //     LoadButton(
        //       vPad: 0,
        //       hPad: 0,
        //       loading: widget.loading,
        //       btnText: LN.save,
        //       onsave: () {
        //         widget.onSave();
        //         widget.onTapViewAssignedItems != null
        //             ? widget.onTapViewAssignedItems!()
        //             : null;
        //       },
        //     ),
        //   ],
        // ),
      ],
    );
  }

  double getTextWidth(String text, TextStyle style) {
    final TextPainter textPainter = TextPainter(
      text: TextSpan(text: text, style: style),
      textDirection: TextDirection.ltr,
    )..layout();
    return textPainter.size.width;
  }

  Widget _ProdView({
    required Ssize size,
    required ProductCategoryVariationList? catVars,
  }) {
    return SingleChildScrollView(
      physics: BouncingScrollPhysics(),
      child: Builder(builder: (context) {
        final list = widget.subCatServList == null
            ? []
            : (widget.subCatServList?.productVariations ?? [])
                .where((e) =>
                    e.name
                        ?.toLowerCase()
                        .contains(widget.searchCltr.text.toLowerCase()) ??
                    true)
                .toList();
        return Wrap(
          spacing: size.getW(16),
          runSpacing: size.getH(16),
          children: List.generate(list.length, (i) {
            final data = list[i];
            final isSelected = catVars?.productVariationIds
                    ?.any((e) => e.toLowerCase() == data.id?.toLowerCase()) ??
                false;
            return _productSec(
              size,
              title: data.name,
              subtitle: data.productCategoryName ?? '',
              isCheck: isSelected,
              onTap: () {
                if (data.id == null || data.id!.isEmpty) return;
                widget.onTapProduct(
                  data.id,
                  !isSelected,
                );
              },
            );
          }),
        );
      }),
    );
  }

  Widget _productSec(
    Ssize size, {
    String? title,
    bool isCheck = false,
    Function()? onTap,
    String? subtitle,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(5),
      child: Stack(
        children: [
          Container(
            // height: size.getH(100),
            width: size.getW(232),
            alignment: Alignment.centerLeft,
            decoration: BoxDecoration(
                border: Border.all(
                  color: kSecondaryColor,
                ),
                borderRadius: BorderRadius.circular(5)),
            padding: EdgeInsets.symmetric(
                vertical: size.getH(12), horizontal: size.getW(12)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title ?? '',
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: size.getS(16),
                    color: Colors.black,
                  ),
                ),
                Text(
                  subtitle ?? '',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: size.getS(12),
                    color: Colors.grey.shade700,
                  ),
                ),
              ],
            ),
          ),
          if (isCheck)
            Positioned(
              top: 4,
              right: 4,
              child: Icon(
                Icons.check_circle,
                color: kSecondaryColor,
              ),
            )
        ],
      ),
    );
  }

  Widget _disableSection({bool readOnly = false, required Widget child}) {
    return IgnorePointer(
      ignoring: readOnly,
      child: Opacity(
        opacity: readOnly ? 0.3 : 1,
        child: child,
      ),
    );
  }
}
