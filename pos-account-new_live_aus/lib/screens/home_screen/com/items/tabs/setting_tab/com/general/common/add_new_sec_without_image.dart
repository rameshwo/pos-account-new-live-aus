import 'package:flutter/material.dart';
import 'package:pos_account/config/size_config.dart';
import 'package:pos_account/constant/constant.dart';
import 'package:pos_account/ln.dart';
import 'package:pos_account/model/home/setting/general/category/pro_cat_image.dart';
import 'package:pos_account/model/ui_model/tablelist_model.dart';
import 'package:pos_account/widgets/input/text_form/text_form_widget.dart';
import 'package:pos_account/widgets/load_btn.dart';
import 'package:pos_account/widgets/switch_adap.dart';

class AddNewSectionWithoutImage extends StatelessWidget {
  final String tableTitle;
  final List<TLModel> tableList;
  final bool getStatus;
  final Function(bool)? setStatus;
  final Function()? onAdd;
  final Widget? newWidget;
  final List<ProductCategoriesImage>? imageList;
  final Function(String?)? onSelectImage;
  final bool isNew;
  final Function()? onCancel;
  final bool showSaveBtn;
  final String? imageUrl;
  final Function()? uploadImage;
  final Widget? bottomWidget;
  const AddNewSectionWithoutImage({
    super.key,
    required this.tableTitle,
    required this.tableList,
    required this.getStatus,
    this.setStatus,
    this.onAdd,
    this.newWidget,
    this.imageList,
    this.onSelectImage,
    this.isNew = true,
    this.onCancel,
    this.showSaveBtn = true,
    this.imageUrl,
    this.uploadImage,
    this.bottomWidget,
  });

  @override
  Widget build(BuildContext context) {
    final size = Ssize(context);

    final isStatusAtUp =
        tableList.length < 3 && (onSelectImage == null || uploadImage == null);

    final inputLength = onSelectImage == null || uploadImage == null
        ? tableList.length
        : size.isProt
            ? 3
            : 1;
    return Card(
      child: SizedBox(
        width: double.infinity,
        child: Padding(
          padding: EdgeInsets.symmetric(
              vertical: size.getH(8.0), horizontal: size.getW(24)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    tableTitle,
                    style: TextStyle(
                      fontSize: size.getS(18),
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                        onCancel!();
                      },
                      icon: Icon(Icons.close))
                ],
              ),
              SizedBox(
                height: size.getH(12),
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Wrap(
                          spacing: size.getW(48),
                          runSpacing: size.getH(24),
                          children: [
                            if (newWidget != null) newWidget!,
                            ...inputFields(
                                tableList
                                    .getRange(
                                        0,
                                        tableList.length <= inputLength
                                            ? tableList.length
                                            : inputLength)
                                    .toList(),
                                size: size),
                            if (isStatusAtUp) _statusSection(size: size)
                          ],
                        ),
                      ],
                    ),
                  ),
                  size.isProt
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [],
                        )
                      : Row(
                          children: [],
                        )
                ],
              ),
              SizedBox(
                height: size.getH(12),
              ),
              Wrap(
                spacing: size.getW(24),
                runSpacing: size.getH(24),
                children: [
                  if (tableList.length >= inputLength)
                    ...inputFields(
                        tableList
                            .getRange(inputLength, tableList.length)
                            .toList(),
                        size: size),
                  if (!isStatusAtUp) _statusSection(size: size)
                ],
              ),
              if (bottomWidget != null) bottomWidget!,
              SizedBox(
                height: size.getH(18),
              ),
              Row(
                children: [
                  if (showSaveBtn)
                    LoadButton(
                      onsave: onAdd,
                      loading: onAdd == null,
                      btnText: isNew ? LN.saveNAddAnother : LN.update,
                      width: 240,
                    ),
                  SizedBox(
                    width: size.getW(12),
                  ),
                  if (!isNew)
                    LoadButton(
                      onsave: onCancel,
                      btnText: LN.cancel,
                      textColor: Colors.white,
                      btnColor: Colors.red.shade700,
                    ),
                  // ElevatedButton(
                  //     style: ButtonStyle(
                  //         backgroundColor:
                  //             WidgetStateProperty.all(Colors.red.shade700),
                  //         padding: WidgetStateProperty.all(
                  //             EdgeInsets.symmetric(
                  //                 horizontal: size.getW(12),
                  //                 vertical: size.getH(8)))),
                  //     onPressed: onCancel,
                  //     child: Text(
                  //       LN.cancel,
                  //       style: TextStyle(
                  //         fontSize: size.getS(16),
                  //         color: Colors.white,
                  //       ),
                  //     ))
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _statusSection({
    required Ssize size,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          LN.status,
          style: TextStyle(
            fontSize: size.getS(16),
            fontFamily: kFontFMedium,
            color: Colors.black,
          ),
        ),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            SwitchAdap(
              value: getStatus,
              size: size,
              onChanged: setStatus,
            ),
            SizedBox(
              width: size.getW(12),
            ),
            Text(
              getStatus ? LN.active : LN.inActive,
              style: TextStyle(
                fontSize: size.getS(16),
                color: getStatus ? kSecondaryColor : Colors.red.shade700,
              ),
            ),
          ],
        ),
      ],
    );
  }

  List<Widget> inputFields(List<TLModel> tableList, {required Ssize size}) {
    return List.generate(
        tableList.length,
        (index) => Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text.rich(
                  TextSpan(
                      text: tableList[index].title,
                      style: TextStyle(
                        fontSize: size.getS(16),
                        color: Colors.black,
                        fontFamily: kFontFMedium,
                      ),
                      children: tableList[index].isReq
                          ? [
                              TextSpan(
                                text: " *",
                                style: TextStyle(
                                  fontSize: size.getW(16),
                                  color: Colors.red,
                                ),
                              )
                            ]
                          : null),
                ),
                SizedBox(
                  height: size.getH(6),
                ),
                SizedBox(
                  width: size.getW(300),
                  child: TextFormWidget(
                    borderColor: Colors.black54,
                    borderRadius: 5,
                    cltr: tableList[index].tableCltr,
                    hintText: tableList[index].hintText,
                    textInputType: tableList[index].textInputType,
                    isReq: tableList[index].isReq,
                  ),
                )
              ],
            ));
  }
}
