import 'package:flutter/material.dart';
import 'package:pos_account/config/size_config.dart';
import 'package:pos_account/constant/constant.dart';
import 'package:pos_account/ln.dart';
import 'package:pos_account/model/ui_model/tag_modifier_model.dart';
import 'package:pos_account/providers/cus_val_pro.dart';
import 'package:pos_account/providers/product/edit_modifier_pro.dart';
import 'package:pos_account/widgets/input/dropdown/title_drop_down.dart';
import 'package:pos_account/widgets/input/text_form/text_form_widget.dart';
import 'package:pos_account/widgets/input/text_form/title_text_form.dart';
import 'package:pos_account/widgets/load_btn.dart';
import 'package:pos_account/widgets/title_pop.dart';
import 'package:provider/provider.dart';
import 'package:reorderable_grid_view/reorderable_grid_view.dart';
import '../../../../../../../../widgets/loading.dart';
import '../../../setting_tab/com/general/common/common_header.dart';
import 'copy_modifier_dia.dart';

class EditModiferSec extends StatefulWidget {
  final Function() onBack;
  const EditModiferSec({
    super.key,
    required this.onBack,
  });

  @override
  State<EditModiferSec> createState() => _EditModiferSecState();
}

class _EditModiferSecState extends State<EditModiferSec> {
  late EditModiPro _editModiPro;

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _editModiPro = Provider.of<EditModiPro>(context, listen: false);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _getData();
    });
  }

  Future<void> _getData() async {
    await _editModiPro.getAddSec();
    _editModiPro.editModifier();
  }

  @override
  void dispose() {
    _editModiPro.clear();
    super.dispose();
  }

  late EditModiPro editModiPro;
  late Ssize size;
  bool _showExtraSection = true;

  @override
  Widget build(BuildContext context) {
    size = Ssize(context);
    editModiPro = Provider.of<EditModiPro>(context);
    return Processing(
      loading: editModiPro.pageLoad,
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _header(),
            _editSelectitem(),
            SizedBox(height: size.getH(12)),
            Expanded(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _leftPanel(),
                  SizedBox(width: size.getW(12)),
                  Expanded(child: _rightPanel()),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _editSelectitem() {
    return Container(
      color: Colors.white,
      child: Row(
        children: [
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Card(
                child: Row(
                  children: [
                    ...List.generate(editModiPro.productItemList.length, (i) {
                      final _modiItem = editModiPro.productItemList[i];
                      final _isSelected = _modiItem.id.toLowerCase() ==
                          editModiPro.selectedModiItemId?.toLowerCase();
                      final _count = _modiItem.groupList.fold<int>(
                          0,
                          (pV, e) =>
                              pV +
                              (e.modiItemList.fold<int>(0,
                                  (pV2, e2) => pV2 + (e2.isSelected ? 1 : 0))));
                      return Container(
                        decoration: BoxDecoration(
                            border: Border(
                                bottom: BorderSide(
                          width: _isSelected ? 2 : 0.5,
                          color: _isSelected ? kSecondaryColor : Colors.black54,
                        ))),
                        child: InkWell(
                          onTap: () {
                            editModiPro.selectedModiItemId = _modiItem.id;
                            editModiPro.notify;
                          },
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: size.getW(16),
                                vertical: size.getH(8)),
                            child: Row(
                              children: [
                                Text(
                                  "${_modiItem.prodMame}${(_modiItem.modiName?.trim().isNotEmpty ?? false) ? ' (${_modiItem.modiName})' : ''}",
                                  style: TextStyle(
                                    fontSize: size.getS(15),
                                    color: _isSelected
                                        ? kSecondaryColor
                                        : Colors.black,
                                    fontWeight: _isSelected
                                        ? FontWeight.bold
                                        : FontWeight.normal,
                                    fontFamily: _isSelected
                                        ? kFontFMedium
                                        : kFontFRegular,
                                  ),
                                ),
                                if (_count != 0)
                                  Container(
                                    height: size.getH(20),
                                    margin: EdgeInsets.only(left: size.getW(2)),
                                    decoration: BoxDecoration(
                                      color: _isSelected
                                          ? kSecondaryColor
                                          : Colors.grey.shade100,
                                      borderRadius: BorderRadius.circular(50),
                                    ),
                                    padding: EdgeInsets.symmetric(
                                        horizontal: size.getW(4)),
                                    alignment: Alignment.center,
                                    child: Text(
                                      "$_count",
                                      style: TextStyle(
                                        fontSize: size.getS(12),
                                        color: _isSelected
                                            ? Colors.white
                                            : Colors.black,
                                        fontWeight: _isSelected
                                            ? FontWeight.bold
                                            : FontWeight.normal,
                                        fontFamily: _isSelected
                                            ? kFontFMedium
                                            : kFontFRegular,
                                      ),
                                    ),
                                  )
                              ],
                            ),
                          ),
                        ),
                      );
                    })
                  ],
                ),
              ),
            ),
          ),
          InkWell(
            onTap: () {
              showDialog(
                context: context,
                builder: (_) => CopyConfigDialog(),
              );
            },
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: size.getW(12)),
              child: Icon(
                Icons.file_copy_outlined,
                size: size.getS(25),
                color: Colors.black54,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// 🔹 HEADER
  Widget _header() {
    return CommonHeader(
      child: Row(
        children: [
          Expanded(
            child: TitlePop(
              title: "Edit Modifiers",
              size: size,
              onTap: () {
                widget.onBack();
              },
            ),
          ),
          LoadButton(
            onsave: () {
              widget.onBack();
            },
            btnText: "Cancel",
            btnColor: Colors.white,
            textColor: Colors.black,
            vPad: 10,
            fontSize: 15,
            width: 120,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadiusGeometry.circular(5),
                side: BorderSide(color: Colors.black38)),
          ),
          SizedBox(width: size.getW(16)),
          LoadButton(
            onsave: () async {
              if (_formKey.currentState?.validate() ?? false) {
                final _status = await editModiPro.updateData();
                if (_status) {
                  widget.onBack();
                }
              }
            },
            btnText: "Save Modifiers",
            vPad: 10,
            fontSize: 15,
            width: 200,
            loading: editModiPro.buttonLoad,
            icon: Padding(
              padding: EdgeInsets.only(right: size.getW(4)),
              child: Icon(
                Icons.save_outlined,
                color: Colors.white,
                size: size.getS(20),
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<ModiItemGroupModel> get _prodGroupList =>
      editModiPro.productItemList.any((a) =>
              a.id.toLowerCase() ==
              editModiPro.selectedModiItemId?.toLowerCase())
          ? editModiPro.productItemList
              .firstWhere((a) =>
                  a.id.toLowerCase() ==
                  editModiPro.selectedModiItemId?.toLowerCase())
              .groupList
          : <ModiItemGroupModel>[];

  /// 🔹 LEFT PANEL
  Widget _leftPanel() {
    return Container(
      width: size.getW(240),
      padding: EdgeInsets.all(size.getS(8)),
      decoration: _cardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                Icons.menu,
                size: size.getS(18),
                color: Colors.black,
              ),
              SizedBox(width: size.getW(4)),
              Expanded(
                child: Text("Modifier Groups",
                    style: TextStyle(
                        fontWeight: FontWeight.bold, fontSize: size.getS(15))),
              ),
            ],
          ),
          SizedBox(height: size.getH(8)),
          ...List.generate(_prodGroupList.length, (i) {
            final _data = _prodGroupList[i];
            return _menuItem(
              _data.name,
              count: _data.modiItemList.where((a) => a.isSelected).length,
              selected: _data.id.toLowerCase() ==
                  editModiPro.selectedModifierGroupId?.toLowerCase(),
              onTap: () {
                editModiPro.selectedModifierGroupId = _data.id;
                editModiPro.notify;
              },
            );
          }),
        ],
      ),
    );
  }

  Widget _menuItem(
    String title, {
    required int count,
    bool selected = false,
    required Function() onTap,
  }) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: size.getH(4)),
      decoration: BoxDecoration(
        color: selected ? const Color(0xffE6F4F1) : Colors.transparent,
        borderRadius: BorderRadius.circular(10),
      ),
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: EdgeInsets.all(size.getS(8)),
          child: Row(
            children: [
              Expanded(
                  child: Text(
                title,
                style: TextStyle(
                  fontSize: size.getS(14),
                ),
              )),
              if (count != 0)
                CircleAvatar(
                  radius: size.getS(12),
                  backgroundColor: Colors.teal,
                  child: Text("$count",
                      style: TextStyle(
                          fontSize: size.getS(14), color: Colors.white)),
                ),
              Icon(
                Icons.chevron_right,
                size: size.getS(20),
              )
            ],
          ),
        ),
      ),
    );
  }

  ModiItemGroupModel? get _modiGroup =>
      _prodGroupList.isNotEmpty && editModiPro.selectedModifierGroupId != null
          ? _prodGroupList.firstWhere((a) =>
              a.id.toLowerCase() ==
              editModiPro.selectedModifierGroupId?.toLowerCase())
          : null;

  /// 🔹 RIGHT PANEL
  Widget _rightPanel() {
    final _modiList = _modiGroup?.modiItemList;
    final _selectedCount =
        _modiList != null ? (_modiList.where((a) => a.isSelected).length) : 0;

    final _filteredModiList = _modiList
        ?.where((a) => a.nameCltr.text
            .toLowerCase()
            .contains(editModiPro.searchCltr.text.toLowerCase()))
        .toList();

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: _cardDecoration(),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _extraConfig(),
            _searchBar(),
            SizedBox(height: size.getH(12)),

            /// SELECTED HEADER
            if (_selectedCount != 0)
              _sectionHeader(
                  "SELECTED ($_selectedCount) - DRAG TO REORDER", true),

            // _selectedItem("Egg Fried", "Custom"),
            if (_filteredModiList != null)
              ReorderableGridView.count(
                dragStartDelay: Duration(milliseconds: 300),
                physics: NeverScrollableScrollPhysics(),
                padding: EdgeInsets.symmetric(
                    horizontal: size.getW(12), vertical: size.getH(8)),
                shrinkWrap: true,
                crossAxisCount: 4,
                childAspectRatio: 1.2,
                mainAxisSpacing: size.getW(16),
                crossAxisSpacing: size.getH(16),
                onReorder: (int oldIndex, int newIndex) {
                  final _element = _modiList!.firstWhere(
                      (a) => a.id == _filteredModiList[oldIndex].id);

                  final _newIndex = _modiList.indexWhere(
                      (a) => a.id == _filteredModiList[newIndex].id);

                  if (_newIndex < 0) return;

                  _modiList.removeWhere(
                      (a) => a.id == _filteredModiList[oldIndex].id);

                  _modiList.insert(_newIndex, _element);
                  editModiPro.notify;
                },
                children: List.generate(_filteredModiList.length, (i) {
                  return _itemCardSec(
                    key: ValueKey(
                        "${editModiPro.selectedModifierGroupId}-${_filteredModiList[i].nameCltr.text}-${_filteredModiList[i].id}"),
                    titleCltr: _filteredModiList[i].nameCltr,
                    priceCltr: _filteredModiList[i].priceCltr,
                    maxThQtyCltr: _filteredModiList[i].maxThredQtyCltr,
                    qtyCltr: _filteredModiList[i].qtyCltr,
                    type: _filteredModiList[i].type,
                    isSelected: _filteredModiList[i].isSelected,
                    // isActive: _filteredModiList[i].isActive,
                    onTap: () {
                      FocusManager.instance.primaryFocus?.unfocus();
                      // if (_filteredModiList[i].updatedId.isNotEmpty) {
                      //   return;
                      // }

                      _filteredModiList[i].isSelected =
                          !_filteredModiList[i].isSelected;
                      editModiPro.notify;
                    },
                    // onActive: (val) {
                    //   _filteredModiList[i].isActive = val;
                    //   editModiPro.notify;
                    // },
                  );
                }),
              ),
          ],
        ),
      ),
    );
  }

  Column _extraConfig() {
    return Column(
      children: [
        InkWell(
          onTap: () {
            _showExtraSection = !_showExtraSection;
            editModiPro.notify;
          },
          child: Padding(
            padding: EdgeInsets.only(bottom: size.getH(8)),
            child: Row(
              children: [
                Icon(Icons.settings_outlined, size: size.getS(17)),
                SizedBox(width: size.getW(8)),
                Expanded(
                  child: Text(
                    "Extra - Group Configuration",
                    style: TextStyle(
                      fontSize: size.getS(16),
                      color: Colors.black,
                      fontFamily: kFontFMedium,
                    ),
                  ),
                ),
                if (!_showExtraSection)
                  Text(
                    "Selection type set • Max: 1 • Order: 1 ",
                    style: TextStyle(
                      fontSize: size.getS(13),
                      color: Colors.black54,
                    ),
                  ),
                Icon(
                    _showExtraSection
                        ? Icons.keyboard_arrow_down
                        : Icons.keyboard_arrow_right,
                    size: size.getS(17)),
              ],
            ),
          ),
        ),
        if (_showExtraSection)
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                  child: TitleDropDown(
                isReq: true,
                title: "Selection Type",
                borderColor: Colors.black26,
                indexVal: _modiGroup?.selectionTypeIndex,
                list: editModiPro.addSec?.selectionTypes == null
                    ? []
                    : editModiPro.addSec!.selectionTypes!
                        .map((e) => e.name ?? '')
                        .toList(),
                onChanged: (int? i) {
                  _modiGroup?.selectionTypeIndex = i;
                  editModiPro.notify;
                },
              )),
              SizedBox(width: size.getW(24)),
              Expanded(
                child: TitleTextForm(
                  isReq: false,
                  title: "Max Threshold Quantity",
                  borderColor: Colors.black26,
                  textCltr: _modiGroup?.maxThQtyCltr ?? TextEditingController(),
                ),
              ),
              SizedBox(width: size.getW(24)),
              Expanded(
                child: TitleTextForm(
                  isReq: true,
                  title: "Sort Order",
                  borderColor: Colors.black26,
                  textCltr:
                      _modiGroup?.sortOrderCltr ?? TextEditingController(),
                  errH: 0,
                ),
              ),
            ],
          ),
        SizedBox(height: size.getH(12)),
      ],
    );
  }

  /// 🔹 SEARCH
  Widget _searchBar() {
    final _modiList = _modiGroup?.modiItemList;

    return Row(
      children: [
        Checkbox(
            value: (_modiList?.isNotEmpty ?? false) &&
                _modiList!.every((a) => a.isSelected),
            onChanged: (val) {
              _modiList!.forEach((a) {
                if (a.updatedId.isEmpty) {
                  a.isSelected = val ?? false;
                }
              });
              editModiPro.notify;
            }),
        Text(
          "Item",
          style: TextStyle(
            fontSize: size.getS(15),
            color: Colors.black,
          ),
        ),
        SizedBox(width: size.getW(12)),
        SizedBox(
          width: size.width * 0.52,
          child: TextFormWidget(
            isReq: false,
            vPad: 10,
            prefixIcon: Icon(
              Icons.search,
              size: size.getS(32),
            ),
            borderRadius: 5,
            borderColor: Colors.black12,
            cltr: editModiPro.searchCltr,
            hintText: LN.search,
            onChanged: (p0) {
              if (p0 == null) return;
              editModiPro.notify;
            },
            suffixIcon: editModiPro.searchCltr.text.isEmpty
                ? null
                : InkWell(
                    onTap: () {
                      editModiPro.searchCltr.clear();
                      editModiPro.notify;
                    },
                    child: Icon(
                      Icons.close,
                      size: size.getS(28),
                      color: Colors.black,
                    ),
                  ),
          ),
        ),
      ],
    );
  }

  /// 🔹 SECTION HEADER
  Widget _sectionHeader(String title, bool green) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(10),
      margin: const EdgeInsets.only(bottom: 6),
      decoration: BoxDecoration(
        color: green ? const Color(0xffE6F4F1) : Colors.grey[200],
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(title,
          style: TextStyle(
              fontWeight: FontWeight.bold,
              color: green ? Colors.teal : Colors.black)),
    );
  }

  BoxDecoration _cardDecoration() {
    return BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(10),
    );
  }

  Widget _itemCardSec({
    Key? key,
    TextEditingController? titleCltr,
    required Function() onTap,
    bool isSelected = false,
    // required Function(bool) onActive,
    // bool isActive = false,
    TextEditingController? priceCltr,
    TextEditingController? maxThQtyCltr,
    TextEditingController? qtyCltr,
    String? type,
  }) {
    final _noneWidget = SizedBox.shrink();

    return Container(
      key: key,
      width: size.getW(232),
      // height: size.getH(280),
      decoration: BoxDecoration(
        color: isSelected ? kSecondaryColor.withOpacity(0.25) : null,
        border:
            Border.all(color: isSelected ? kSecondaryColor : Colors.black26),
        borderRadius: BorderRadius.circular(10),
      ),
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: EdgeInsets.symmetric(
              horizontal: size.getW(12), vertical: size.getH(8)),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: type == ModiItemType.Custom.name
                        ? TextFormWidget(
                            hPad: 2,
                            borderColor: Colors.black26,
                            hintText: '',
                            isReq: false,
                            textInputType: TextInputType.number,
                            errH: 0,
                            cltr: titleCltr ?? TextEditingController(),
                            vPad: 4,
                            textStyle: TextStyle(
                              color: Colors.black,
                              fontSize: size.getS(14),
                            ),
                            hintStyle: TextStyle(
                              color: Colors.black54,
                              fontSize: size.getS(14),
                            ),
                          )
                        : Text(
                            titleCltr?.text ?? '',
                            style: TextStyle(
                              fontSize: size.getS(15),
                              fontFamily: kFontFMedium,
                              color: Colors.black,
                            ),
                          ),
                  ),
                  SizedBox(width: size.getW(8)),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.green.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(color: Colors.green),
                    ),
                    padding: EdgeInsets.symmetric(
                        horizontal: size.getW(8), vertical: size.getH(4)),
                    child: Text(
                      (type?.toLowerCase().contains('raw') ?? false)
                          ? "Raw"
                          : "$type",
                      style: TextStyle(
                        color: Colors.green.shade700,
                        fontSize: size.getS(12),
                      ),
                    ),
                  )
                  // Icon(
                  //   isSelected
                  //       ? Icons.check_box
                  //       : Icons.check_box_outline_blank,
                  //   color: isSelected ? kSecondaryColor : Colors.black45,
                  //   size: size.getS(25),
                  // )
                ],
              ),
              SizedBox(height: size.getH(8)),
              // Spacer(),
              if (type != ModiItemType.Products.name)
                TitleTextForm(
                  hPad: 2,
                  title: "Price",
                  fontSize: 14,
                  borderColor: Colors.black26,
                  hintText: '0.00',
                  isReq: false,
                  textInputType: TextInputType.number,
                  errH: 0,
                  vPad: 4,
                  textCltr: priceCltr ?? TextEditingController(),
                  prefixText: Text(
                    "     ${GlobalCVP.storeInfo?.currencySymbol ?? '\$'} ",
                    style: TextStyle(
                      fontSize: size.getS(16),
                      color: Colors.black45,
                    ),
                  ),
                  textStyle: TextStyle(
                    color: Colors.black,
                    fontSize: size.getS(14),
                  ),
                  hintStyle: TextStyle(
                    color: Colors.black54,
                    fontSize: size.getS(14),
                  ),
                )
              else
                _noneWidget,

              SizedBox(height: size.getH(12)),

              TitleTextForm(
                hPad: 2,
                title: "Max Threshold",
                fontSize: 14,
                isReq: false,
                borderColor: Colors.black26,
                hintText: 'quantity',
                textInputType: TextInputType.number,
                errH: 0,
                vPad: 4,
                textCltr: maxThQtyCltr ?? TextEditingController(),
                prefixText: Text(
                  "Qty. ",
                  style: TextStyle(
                    fontSize: size.getS(16),
                    color: Colors.black45,
                  ),
                ),
                textStyle: TextStyle(
                  color: Colors.black,
                  fontSize: size.getS(14),
                ),
                hintStyle: TextStyle(
                  color: Colors.black54,
                  fontSize: size.getS(14),
                ),
              ),
              SizedBox(height: size.getH(12)),
              if (type == ModiItemType.RawLooseIngredient.name)
                TitleTextForm(
                  hPad: 2,
                  title: "Quantity",
                  fontSize: 14,
                  borderColor: Colors.black26,
                  hintText: 'quantity',
                  isReq: false,
                  textInputType: TextInputType.number,
                  errH: 0,
                  vPad: 4,
                  textCltr: qtyCltr ?? TextEditingController(),
                  prefixText: Text(
                    "Qty. ",
                    style: TextStyle(
                      fontSize: size.getS(16),
                      color: Colors.black45,
                    ),
                  ),
                  textStyle: TextStyle(
                    color: Colors.black,
                    fontSize: size.getS(14),
                  ),
                  hintStyle: TextStyle(
                    color: Colors.black54,
                    fontSize: size.getS(14),
                  ),
                )
              else
                _noneWidget,
              SizedBox(height: size.getH(4)),
              // if (isSelected)
              //   Row(
              //     children: [
              //       Expanded(
              //         child: Text(
              //           "Status",
              //           style: TextStyle(
              //             fontSize: size.getS(16),
              //             color: Colors.black,
              //           ),
              //         ),
              //       ),
              //       SwitchAdap(
              //         value: isActive,
              //         size: size,
              //         onChanged: onActive,
              //       ),
              //     ],
              //   )
              // Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}
