import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:pos_account/config/responsive.dart';
import 'package:pos_account/config/size_config.dart';
import 'package:pos_account/constant/constant.dart';
import 'package:pos_account/ln.dart';

class DropDownList extends StatelessWidget {
  const DropDownList({
    super.key,
    this.indexValue,
    this.hint = "",
    required this.list,
    this.onChange,
    this.borderColor = Colors.black,
    this.borderRadius = 5,
    this.dropDownColor,
    this.fillColor = Colors.white,
    this.textColor = Colors.black,
    this.iconEnableColor,
    this.fontWeight,
    this.hintTextColor = Colors.black54,
    this.isReq = false,
    this.validator,
    this.errH,
    this.vPad = 8,
    this.hPad = 0,
    this.isDense = true,
    this.fontSize = 16,
    this.fontFamily = kFontFRegular,
    this.sufIcon,
    this.itemHeight,
  });

  final int? indexValue;
  final String hint;
  final List<dynamic> list;
  final Function(int?)? onChange;
  final Color borderColor;
  final double borderRadius;
  //new added
  final Color? dropDownColor;
  final Color fillColor;
  final Color textColor;
  final Color hintTextColor;
  final Color? iconEnableColor;
  final FontWeight? fontWeight;
  final bool isReq;
  final String? Function(int?)? validator;
  final double? errH;
  final double vPad;
  final double hPad;
  final bool isDense;
  final double fontSize;
  final String? fontFamily;
  final Widget? sufIcon;
  final double? itemHeight;

  @override
  Widget build(BuildContext context) {
    final size = Ssize(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        DropdownButtonHideUnderline(
          child: ButtonTheme(
            alignedDropdown: true,
            child: DropdownButtonFormField<int>(
              iconSize: size.getS(24),
              decoration: InputDecoration(
                fillColor: fillColor,
                filled: true,
                isDense: isDense,
                contentPadding: EdgeInsets.symmetric(
                    horizontal: size.getW(hPad),
                    vertical: size
                        .getH(Responsive.isDesktop(context) ? vPad : vPad - 2)),
                enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: borderColor),
                    borderRadius:
                        BorderRadius.circular(size.getW(borderRadius))),
                focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: borderColor, width: 1.6),
                    borderRadius:
                        BorderRadius.circular(size.getW(borderRadius))),
                focusedErrorBorder: OutlineInputBorder(
                    borderSide:
                        BorderSide(color: Colors.red.withAlpha(60), width: 1.6),
                    borderRadius:
                        BorderRadius.circular(size.getW(borderRadius))),
                errorBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.red.withAlpha(60)),
                    borderRadius:
                        BorderRadius.circular(size.getW(borderRadius))),
                errorStyle: TextStyle(
                  fontSize: size.getS(13),
                  height: errH,
                ),
                errorMaxLines: 2,
                suffixIcon: sufIcon,
                suffixIconConstraints: BoxConstraints(minWidth: size.getW(40)),
              ),
              validator: isReq
                  ? (validator ??
                      (val) {
                        if (val == null) {
                          if (errH != null && errH == 0)
                            return "";
                          else
                            return LN.fieldMustNotBeEmpty;
                        } else
                          return null;
                      })
                  : (val) {
                      return null;
                    },
              isExpanded: true,
              iconEnabledColor: iconEnableColor,
              dropdownColor: dropDownColor,
              value:
                  (indexValue != null && indexValue! < 0) ? null : indexValue,
              style: TextStyle(
                fontSize: size.getS(fontSize),
                color: textColor,
                fontWeight: fontWeight,
                fontFamily: fontFamily,
              ),
              itemHeight: itemHeight,
              items: list.map((item) {
                final value = list.indexWhere((e) => e == item);
                return DropdownMenuItem<int>(
                  value: value,
                  child: item is String
                      ? Text(
                          item,
                          style: TextStyle(
                            fontSize: size.getS(fontSize),
                            color: textColor,
                            fontWeight: fontWeight,
                            height: 1.1,
                          ),
                          overflow: TextOverflow.visible,
                          maxLines: 2,
                        )
                      : item is Widget
                          ? item
                          : SizedBox.shrink(),
                );
              }).toList(),
              hint: Text(
                hint,
                style: TextStyle(
                    fontSize: size.getS(fontSize), color: hintTextColor),
              ),
              onChanged: onChange,
            ),
          ),
        ),
      ],
    );
  }
}

enum SearchMode { Dialog, Menu }

class SearchDropDown extends StatelessWidget {
  const SearchDropDown({
    super.key,
    this.indexValue,
    this.hint = "",
    required this.list,
    this.onChange,
    this.borderColor = Colors.grey,
    this.borderRadius = 25,
    this.height = 52,
    this.vPad = 8,
    this.fontSize = 14,
    this.mode = SearchMode.Dialog,
  });

  final int? indexValue;
  final String hint;
  final List<String> list;
  final Function(int)? onChange;
  final Color borderColor;
  final double borderRadius;
  final double height;
  final double vPad;
  final double fontSize;
  final SearchMode mode;

  @override
  Widget build(BuildContext context) {
    final maxHeight = 64 + (60 * list.length);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height: height,
          decoration: BoxDecoration(
              border: Border.all(width: 1, color: borderColor),
              borderRadius: BorderRadius.circular(borderRadius)),
          child: DropdownSearch<String>(
            mode: mode == SearchMode.Menu ? Mode.MENU : Mode.DIALOG,
            showSearchBox: true,
            items: list,
            selectedItem: indexValue == null || list.length < indexValue!
                ? hint
                : list[indexValue!],
            dropdownSearchDecoration: InputDecoration(
              fillColor: Colors.white,
              filled: true,
              border: InputBorder.none,
              hintText: hint,
              contentPadding:
                  EdgeInsets.symmetric(horizontal: 12, vertical: vPad),
            ),
            dropdownBuilder: (context, selectedItem) {
              return Text(
                selectedItem ?? '',
                style: TextStyle(
                    fontSize: fontSize,
                    color: indexValue == null ? Colors.black54 : null),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              );
            },
            onChanged: onChange == null
                ? null
                : (String? val) {
                    if (val == null) return;
                    if (list.contains(val)) onChange!(list.indexOf(val));
                  },
            showSelectedItems: true,
            maxHeight: maxHeight > 600 ? 600 : maxHeight.toDouble(),
          ),
        ),
      ],
    );
  }
}

class SearchMultiSelectDropDown extends StatelessWidget {
  const SearchMultiSelectDropDown({
    super.key,
    required this.list,
    this.selectedValues = const [],
    this.onChange,
    this.hint = "",
    this.borderColor = Colors.black12,
    this.borderRadius = 25,
    this.height = 52,
    this.vPad = 12,
    this.fontSize = 14,
    this.showCheckBox = true,
    this.onDeleted,
  });

  final List<String> list;
  final List<String> selectedValues;
  final Function(List<String>)? onChange;
  final String hint;
  final Color borderColor;
  final double borderRadius;
  final double height;
  final double vPad;
  final double fontSize;
  final Function(String)? onDeleted;
  final bool showCheckBox;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: DropdownSearch<String>.multiSelection(
        mode: Mode.MENU,
        showSearchBox: false,
        showCheckBox: showCheckBox,
        // showClearButton: true,
        items: list,
        selectedItems: selectedValues,
        dropdownSearchDecoration: InputDecoration(
          fillColor: Colors.white,
          labelStyle: TextStyle(
            color: Colors.black,
            fontSize: fontSize,
          ),
          filled: true,
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: borderColor,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: borderColor,
            ),
          ),
          border: OutlineInputBorder(
              borderSide: BorderSide(
            color: borderColor,
          )),
          hintText: hint,
          contentPadding: EdgeInsets.symmetric(horizontal: 12),
        ),
        popupItemBuilder: (context, item, isSelected) {
          return ListTile(
            title: Text(item),
            trailing: isSelected
                ? Icon(
                    Icons.check,
                    color: Colors.green,
                  )
                : null,
          );
        },
        dropdownBuilder: (context, selectedItems) {
          return Wrap(
            spacing: 2.0,
            runSpacing: 1.0,
            children: selectedItems.map((item) {
              return Chip(
                label: Text(item),
                deleteIcon: const Icon(Icons.clear, size: 18),
                onDeleted: () {
                  onDeleted != null ? onDeleted!(item) : null;
                  selectedItems.remove(item);
                  onChange!(selectedItems);
                },
              );
            }).toList(),
          );
        },
        onChanged: onChange,
        showSelectedItems: true,
        maxHeight: 300,
      ),
    );
  }
}
