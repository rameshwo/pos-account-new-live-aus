import 'package:flutter/material.dart';
import 'package:pos_account/config/responsive.dart';
import 'package:pos_account/config/size_config.dart';
import 'drop_down.dart';

class TitleDropDown extends StatelessWidget {
  final String title;
  final List<String> list;
  final String hintText;
  final int? indexVal;
  final Function(int?)? onChanged;
  final bool isReq;
  final double pWidth;
  final Color borderColor;
  final double vPad;
  final String? Function(int?)? validator;
  final double? errH;
  final Color fillColor;
  final double borderRadius;
  final bool isDense;
  final double titleFontSize;
  final double titleGap;
  final FontWeight? fontWeight;
  final Widget? sufIcon;
  final bool? isBold;
  final String? subTitle;

  const TitleDropDown({
    super.key,
    required this.title,
    required this.list,
    this.hintText = "",
    this.onChanged,
    this.indexVal,
    this.isReq = false,
    this.pWidth = 0.33,
    this.borderColor = Colors.black38,
    this.vPad = 8,
    this.validator,
    this.errH,
    this.fillColor = Colors.white,
    this.borderRadius = 5,
    this.isDense = true,
    this.titleFontSize = 18,
    this.titleGap = 8,
    this.fontWeight,
    this.sufIcon,
    this.isBold,
    this.subTitle,
  });

  @override
  Widget build(BuildContext context) {
    final size = Ssize(context);
    return SizedBox(
      width: size.width * pWidth,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text.rich(
            TextSpan(
                text: title,
                style: TextStyle(
                  fontSize: size.getS(titleFontSize),
                  color: Colors.black,
                  fontWeight:
                      isBold == true ? FontWeight.bold : FontWeight.normal,
                ),
                children: isReq
                    ? [
                        TextSpan(
                          text: " *",
                          style: TextStyle(
                            fontSize: size.getS(titleFontSize),
                            color: Colors.red,
                          ),
                        )
                      ]
                    : null),
          ),
          SizedBox(
            height: size.getH(4),
          ),
          DropDownList(
            list: list,
            borderRadius: borderRadius,
            hint: hintText,
            indexValue: indexVal,
            onChange: onChanged,
            borderColor: borderColor,
            vPad: Responsive.isDesktop(context) ? vPad + 2 : vPad,
            validator: validator,
            errH: errH,
            hPad: 12,
            fillColor: fillColor,
            isReq: isReq,
            isDense: isDense,
            fontWeight: fontWeight,
            sufIcon: sufIcon,
          ),
          if (subTitle != null)
            Padding(
              padding: EdgeInsets.only(top: size.getH(8)),
              child: Text(
                subTitle!,
                style: TextStyle(
                  fontSize: size.getS(16),
                  color: Colors.black,
                ),
              ),
            )
        ],
      ),
    );
  }
}

class SearchTitleDropDown extends StatelessWidget {
  final String title;
  final List<String> list;
  final String hintText;
  final int? indexVal;
  final Function(List<String>)? onChanged2;
  final Function(int?)? onChanged;
  final bool isReq;
  final double pWidth;
  final Color borderColor;
  final double borRadius;
  final double? vPad;
  final bool isMulipleSelect;
  final List<String>? selectedValues;
  final Function(String)? onDelete;
  final bool showCheckBox;
  final double fontSize;
  final bool isBold;
  const SearchTitleDropDown({
    super.key,
    required this.title,
    required this.list,
    this.hintText = "",
    this.onChanged,
    this.onChanged2,
    this.indexVal,
    this.isReq = false,
    this.showCheckBox = true,
    this.pWidth = 0.33,
    this.selectedValues,
    this.borderColor = Colors.black38,
    this.borRadius = 5,
    this.fontSize = 18,
    this.vPad,
    this.isMulipleSelect = false,
    this.onDelete,
    this.isBold = false,
  });

  @override
  Widget build(BuildContext context) {
    final size = Ssize(context);
    return SizedBox(
      width: size.width * pWidth,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text.rich(
            TextSpan(
                text: title,
                style: TextStyle(
                  fontSize: size.getS(fontSize),
                  color: Colors.black,
                  fontWeight:
                      isBold == true ? FontWeight.bold : FontWeight.normal,
                ),
                children: isReq
                    ? [
                        TextSpan(
                          text: " *",
                          style: TextStyle(
                            fontSize: size.getS(fontSize),
                            color: Colors.red,
                          ),
                        )
                      ]
                    : null),
          ),
          SizedBox(
            height: size.getH(2),
          ),
          isMulipleSelect
              ? SearchMultiSelectDropDown(
                  list: list,
                  hint: hintText,
                  showCheckBox: showCheckBox,
                  selectedValues: selectedValues ?? [],
                  onChange: onChanged2,
                  vPad: vPad ?? (Responsive.isDesktop(context) ? 4 : 0),
                  borderColor: borderColor,
                  fontSize: size.getS(fontSize),
                  onDeleted: onDelete,
                )
              : SearchDropDown(
                  list: list,
                  borderRadius: borRadius,
                  hint: hintText,
                  height: size.getH(44),
                  indexValue: indexVal,
                  onChange: onChanged,
                  vPad: vPad ?? (Responsive.isDesktop(context) ? 4 : 0),
                  borderColor: borderColor,
                  fontSize: size.getS(16),
                ),
        ],
      ),
    );
  }
}
