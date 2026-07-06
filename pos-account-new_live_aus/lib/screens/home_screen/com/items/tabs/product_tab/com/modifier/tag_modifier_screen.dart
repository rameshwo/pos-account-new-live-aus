import 'package:flutter/material.dart';
import 'package:pos_account/config/utils/utils.dart';
import 'package:pos_account/constant/constant.dart';
import 'package:pos_account/ln.dart';
import 'package:pos_account/model/home/product/modifier/prod_with_variation_res.dart';
import 'package:pos_account/providers/product/modifier_pro.dart';
import 'package:pos_account/widgets/input/dropdown/tree_dropdown/tree_dropdown.dart';
import 'package:pos_account/widgets/input/text_form/title_text_form.dart';
import 'package:pos_account/widgets/no_items_sec.dart';
import 'package:pos_account/widgets/refresh_btn.dart';
import 'package:provider/provider.dart';
import '../../../../../../../../config/size_config.dart';
import '../../../../../../../../widgets/loading.dart';
import '../../../../../../../../widgets/title_pop.dart';
import '../../../setting_tab/com/general/common/common_header.dart';
import '../../../setting_tab/com/general/common/table_data.dart';

class TagModifierScreen extends StatefulWidget {
  final Function()? onBackMain;
  final Function(List<ProdWithVarData> data) assignModifier;
  const TagModifierScreen({
    super.key,
    this.onBackMain,
    required this.assignModifier,
  });

  @override
  State<TagModifierScreen> createState() => _TagModifierScreenState();
}

class _TagModifierScreenState extends State<TagModifierScreen> {
  late ModifierPro _modiPro;
  @override
  void initState() {
    super.initState();
    _modiPro = Provider.of<ModifierPro>(context, listen: false);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _getData();
    });
  }

  void _getData() {
    _modiPro.init();
    _modiPro.getAddSec();
    _modiPro.getData(
        size: size, actionWidget: (val, isEdit) => _actionWidget(val, isEdit));
  }

  void paginate(int page) {
    _modiPro.pageLoad = true;
    _modiPro.notify;
    _modiPro.getData(
      page: page,
      size: size,
      actionWidget: (val, isEdit) => _actionWidget(val, isEdit),
    );
  }

  @override
  void dispose() {
    _modiPro.clear();
    super.dispose();
  }

  late Ssize size;

  int _selectedItems = 0;

  late ModifierPro modiPro;

  @override
  Widget build(BuildContext context) {
    size = Ssize(context);
    modiPro = _modiPro = Provider.of<ModifierPro>(context);

    final _selectedIds = modiPro.tableList.tableDataList
        .where((a) => a.selected)
        .map((b) => b.id.toLowerCase())
        .toList();

    final _varList = modiPro.allProdWithVariation?.data
        ?.where((c) => _selectedIds.contains(c.id?.toLowerCase()))
        .toList();

    final _showEdit = (_varList?.fold<int>(
                0,
                (iV, e) =>
                    iV +
                    (e.productVariations?.fold<int>(
                            0, (pV, e) => pV + (e.modifierCount ?? 0)) ??
                        0)) ??
            0) >
        0;
    return Processing(
      loading: modiPro.pageLoad,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CommonHeader(
            child: TitlePop(
              title: "Tag Modifiers",
              size: size,
              onTap: () {
                if (widget.onBackMain != null) {
                  widget.onBackMain!();
                }
              },
            ),
          ),
          Expanded(
              child: Card(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(
                  horizontal: size.getW(24), vertical: size.getH(12)),
              child: Column(
                children: [
                  TitlePop.infoSection(size,
                      title: "Tag Modifiers to Products",
                      subTitle:
                          "Assign modifiers to your products to allow customization options during ordering. Select a product and add modifiers or raw ingredients."),
                  SizedBox(height: size.getH(8)),
                  Card(
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: size.getW(24), vertical: size.getH(12)),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          TreeDropWidget(
                            isReq: false,
                            vPad: 10,
                            width: size.width * 0.25,
                            dialogWidth: size.width / 2,
                            mode: Mode.DIALOG,
                            selectedColor: kSecondaryColor,
                            title: LN.category,
                            borderColor: Colors.black12,
                            hintText: LN.chooseCategory,
                            categoryList: modiPro.categoryList,
                            selectedId: modiPro.selectedCatId,
                            onChanged: (p0) {
                              modiPro.selectedCatId = p0;
                              paginate(1);
                            },
                          ),
                          SizedBox(width: size.getW(32)),
                          TitleTextForm(
                            title: LN.search,
                            pWidth: 0.20,
                            isReq: false,
                            vPad: 10,
                            hintText: LN.search,
                            borderRadius: 5,
                            borderColor: Colors.black12,
                            textCltr: modiPro.searchProdCltr,
                            suffixIcon: modiPro.searchProdCltr.text.isNotEmpty
                                ? InkWell(
                                    onTap: () {
                                      modiPro.searchProdCltr.clear();
                                      paginate(1);
                                    },
                                    child: Icon(
                                      Icons.close,
                                      size: size.getS(32),
                                    ),
                                  )
                                : Icon(
                                    Icons.search,
                                    size: size.getS(32),
                                  ),
                            onChanged: (p0) {
                              Utils.handleSearch(callback: () async {
                                paginate(1);
                              });
                            },
                          ),
                          SizedBox(width: size.getW(32)),
                          RefreshBtn(
                            size: size,
                            onTap: modiPro.pageLoad
                                ? null
                                : () {
                                    modiPro.pageLoad = true;
                                    modiPro.selectedCatId = null;
                                    modiPro.searchProdCltr.clear();
                                    paginate(1);
                                  },
                          )
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: size.getH(8)),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Left section (Title + subtitle)
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: size.getW(12), vertical: size.getH(12)),
                        child: Row(
                          children: [
                            Icon(Icons.inventory_2_outlined,
                                color: kSecondaryColor, size: size.getS(20)),
                            SizedBox(width: size.getW(8)),
                            RichText(
                              text: TextSpan(
                                children: [
                                  TextSpan(
                                    text: 'Products ',
                                    style: TextStyle(
                                      fontSize: size.getS(16),
                                      fontWeight: FontWeight.w600,
                                      color: Colors.black,
                                    ),
                                  ),
                                  if (_selectedItems != 0)
                                    TextSpan(
                                      text:
                                          '($_selectedItems variations selected)',
                                      style: TextStyle(
                                        fontSize: size.getS(16),
                                        color: Colors.black54,
                                      ),
                                    ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Right section (Buttons)
                      if (_selectedItems != 0)
                        Row(
                          children: [
                            _actionButton(
                              size,
                              icon: Icons.add,
                              label: 'Assign Modifiers',
                              onTap: () {
                                if (_varList != null) {
                                  widget.assignModifier(_varList);
                                }
                              },
                            ),

                            if (_showEdit)
                              Padding(
                                padding: EdgeInsets.only(left: size.getW(12)),
                                child: _actionButton(
                                  size,
                                  icon: Icons.edit_outlined,
                                  label: 'Edit Selected',
                                  onTap: () {
                                    if (_varList != null) {
                                      widget.assignModifier(_varList);
                                    }
                                  },
                                ),
                              ),
                            // SizedBox(width: size.getW(12)),
                            // _actionButton(
                            //   size,
                            //   icon: Icons.edit,
                            //   label: 'Edit Selected',
                            //   onTap: () {},
                            // ),
                          ],
                        ),
                    ],
                  ),
                  if (modiPro.tableList.tableDataList.isEmpty &&
                      !modiPro.pageLoad)
                    Align(
                      alignment: Alignment.topCenter,
                      child: NoItemsSec(
                        size: size,
                        title: LN.noProductFound,
                      ),
                    )
                  else
                    TableData(
                      showDeleteBtn: false,
                      tableData: modiPro.tableList,
                      paginate: paginate,
                      total: modiPro.allProdWithVariation?.total,
                      page: modiPro.pageIndex,
                      selectItem: (v) {
                        _selectedItems = v;
                        // kPrint(
                        //     "$v ${modiPro.tableList.tableDataList.first.selected}");

                        modiPro.notify;
                      },
                    ),
                ],
              ),
            ),
          )),
        ],
      ),
    );
  }

  Widget _actionWidget(String? val, bool isEdit) {
    return Row(
      children: [
        Spacer(),
        Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              border: Border.all(
                color: Colors.black38,
              )),
          child: InkWell(
            onTap: () {
              try {
                final _modiData = modiPro.allProdWithVariation?.data
                    ?.firstWhere(
                        (a) => a.id?.toLowerCase() == val?.toLowerCase());

                // kPrint("$val ${_modiData?.name}");

                if (_modiData != null) {
                  widget.assignModifier([_modiData]);
                }
              } catch (e) {
                //
              }
            },
            child: Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: size.getW(16), vertical: size.getH(4)),
              child: isEdit
                  ? Row(
                      children: [
                        Icon(
                          Icons.edit_outlined,
                          size: size.getS(15),
                        ),
                        Text(' Edit',
                            style: TextStyle(
                              fontSize: size.getS(15),
                              color: Colors.black,
                            )),
                      ],
                    )
                  : Text('+ Add',
                      style: TextStyle(
                        fontSize: size.getS(15),
                        color: Colors.black,
                      )),
            ),
          ),
        ),
        SizedBox(width: size.getW(32)),
      ],
    );
  }

  Widget _actionButton(
    Ssize size, {
    required IconData icon,
    required String label,
    required Function() onTap,
  }) {
    return OutlinedButton.icon(
      onPressed: onTap,
      icon: Icon(
        icon,
        size: size.getS(18),
        color: Colors.black,
      ),
      label: Text(
        label,
        style: TextStyle(
          fontSize: size.getS(16),
          color: Colors.black,
        ),
      ),
      style: OutlinedButton.styleFrom(
        padding: EdgeInsets.symmetric(
            horizontal: size.getW(14), vertical: size.getH(8)),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        side: const BorderSide(color: Colors.grey),
      ),
    );
  }
}
