import 'package:flutter/material.dart';
import 'package:pos_account/config/size_config.dart';
import 'package:pos_account/constant/constant.dart';
import 'package:pos_account/model/ui_model/tag_modifier_model.dart';
import 'package:pos_account/providers/product/edit_modifier_pro.dart';
import 'package:pos_account/widgets/load_btn.dart';
import 'package:provider/provider.dart';

class CopyConfigDialog extends StatefulWidget {
  const CopyConfigDialog({super.key});

  @override
  State<CopyConfigDialog> createState() => _CopyConfigDialogState();
}

class _CopyConfigDialogState extends State<CopyConfigDialog> {
  @override
  void initState() {
    super.initState();
    final _editModiPro = Provider.of<EditModiPro>(context, listen: false);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _listData = _editModiPro.productItemList.where((e) {
        if (e.id.toLowerCase() !=
            _editModiPro.selectedModiItemId?.toLowerCase())
          return true;
        else {
          _selectedId = e.id;
          _selectedItem =
              "${e.prodMame}${(e.modiName?.trim().isNotEmpty ?? false) ? ' (${e.modiName})' : ''}";

          return false;
        }
      }).toList();
      _editModiPro.notify;
    });
  }

  List<ProductItemModel>? _listData;
  String _selectedItem = "";
  String _selectedId = "";

  final _listOfId = <String>[];

  @override
  Widget build(BuildContext context) {
    final size = Ssize(context);
    final editModiPro = Provider.of<EditModiPro>(context);

    return Dialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(size.getS(12))),
      child: Container(
        padding: EdgeInsets.all(size.getS(16)),
        constraints: BoxConstraints(
          maxHeight: size.height / 2,
          minHeight: size.height / 7,
        ),
        width: size.width * 0.7,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// HEADER
            Row(
              children: [
                Icon(
                  Icons.copy,
                  color: kSecondaryColor,
                  size: size.getS(25),
                ),
                SizedBox(width: size.getW(8)),
                Expanded(
                  child: Text(
                    "Copy configuration to other tabs",
                    style: TextStyle(
                      fontSize: size.getS(18),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                InkWell(
                  onTap: () => Navigator.pop(context),
                  child: Icon(
                    Icons.close,
                    size: size.getS(25),
                  ),
                )
              ],
            ),

            SizedBox(height: size.getH(12)),

            /// DESCRIPTION
            Text.rich(TextSpan(
              text: "Copy all modifier configurations from ",
              children: [
                TextSpan(
                  text: _selectedItem,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: size.getS(14),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextSpan(
                  text:
                      " to the selected tabs. This will overwrite their existing configuration.",
                )
              ],
              style:
                  TextStyle(color: Colors.grey[700], fontSize: size.getS(14)),
            )),

            SizedBox(height: size.getH(12)),

            /// LABEL + SELECT ALL
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Target variations",
                  style: TextStyle(
                      fontWeight: FontWeight.w600, fontSize: size.getS(16)),
                ),
                TextButton(
                  onPressed: () {
                    if (_listData == null) return;

                    final _allSelected = _listOfId.length == _listData?.length;

                    _listOfId.clear();

                    if (!_allSelected) {
                      _listOfId.addAll(_listData!.map((a) => a.id).toList());
                    }
                    editModiPro.notify;
                  },
                  child: Text(
                    _listOfId.length == _listData?.length
                        ? "Deselect All"
                        : "Select All",
                    style: TextStyle(
                        fontWeight: FontWeight.w600, fontSize: size.getS(16)),
                  ),
                )
              ],
            ),

            SizedBox(height: size.getH(12)),

            /// MULTI SELECT
            if (_listData?.isNotEmpty ?? false)
              Flexible(
                child: GridView.count(
                  crossAxisCount: 4,
                  childAspectRatio: 3,
                  shrinkWrap: true,
                  children: List.generate(_listData!.length, (i) {
                    final _isSelected = _listOfId.contains(_listData![i].id);
                    return Card(
                      color: _isSelected ? kSecondaryColor : null,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                          side: BorderSide(
                              color: _isSelected
                                  ? kSecondaryColor
                                  : Colors.black38)),
                      child: SizedBox(
                        height: size.getH(60),
                        child: InkWell(
                          borderRadius: BorderRadius.circular(10),
                          onTap: () {
                            if (_isSelected) {
                              _listOfId.remove(_listData![i].id);
                            } else {
                              _listOfId.add(_listData![i].id);
                            }
                            editModiPro.notify;
                          },
                          child: Center(
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                  vertical: size.getH(4.0),
                                  horizontal: size.getW(4)),
                              child: Text(
                                "${_listData![i].prodMame}${(_listData![i].modiName?.trim().isNotEmpty ?? false) ? ' (${_listData![i].modiName})' : ''}",
                                style: TextStyle(
                                  fontSize: size.getS(16),
                                  fontFamily: kFontFMedium,
                                  color:
                                      _isSelected ? Colors.white : Colors.black,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  }),
                ),
              ),

            SizedBox(height: size.getH(24)),

            /// BUTTONS
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                LoadButton(
                  btnText: "Cancel",
                  fontSize: 16,
                  vPad: 10,
                  btnColor: Colors.white,
                  textColor: kSecondaryColor,
                  shape: RoundedRectangleBorder(
                      side: BorderSide(color: kSecondaryColor, width: 2),
                      borderRadius: BorderRadiusGeometry.circular(10)),
                  onsave: () {
                    Navigator.pop(context);
                  },
                ),
                SizedBox(width: size.getW(12)),
                LoadButton(
                  btnText: "Apply Copy",
                  fontSize: 16,
                  vPad: 10,
                  shape: RoundedRectangleBorder(
                      side: BorderSide(color: kSecondaryColor, width: 2),
                      borderRadius: BorderRadiusGeometry.circular(10)),
                  onsave: () {
                    editModiPro.copyToOthers(_selectedId, _listOfId);
                    editModiPro.notify;
                    Navigator.pop(context);
                  },
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
