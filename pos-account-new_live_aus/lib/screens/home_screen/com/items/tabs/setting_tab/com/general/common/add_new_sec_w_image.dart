import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pos_account/config/size_config.dart';
import 'package:pos_account/constant/constant.dart';
import 'package:pos_account/ln.dart';
import 'package:pos_account/model/home/setting/general/category/pro_cat_image.dart';
import 'package:pos_account/model/ui_model/tablelist_model.dart';
import 'package:pos_account/widgets/image/image_error.dart';
import 'package:pos_account/widgets/image/svg_image_sec.dart';
import 'package:pos_account/widgets/input/text_form/text_form_widget.dart';
import 'package:pos_account/widgets/load_btn.dart';
import 'package:pos_account/widgets/switch_adap.dart';
import 'choose_icon_img.dart';

class AddNewSectionWImage extends StatelessWidget {
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
  final Function()? callBack;

  final bool showSaveBtn;
  final String? imageUrl;
  final Function()? uploadImage;
  final Widget? bottomWidget;
  final double width;
  const AddNewSectionWImage({
    super.key,
    this.callBack,
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
    this.width = 300,
  });

  @override
  Widget build(BuildContext context) {
    final size = Ssize(context);
    final String? _imageUrl = imageUrl ??
        ((imageList != null &&
                imageList!
                    .any((f) => f.isDefaultImage != null && f.isDefaultImage!))
            ? imageList!
                .firstWhere(
                    (e) => e.isDefaultImage != null && e.isDefaultImage!)
                .imageUrl
            : null);

    // final _inputLength = onSelectImage == null || uploadImage == null
    //     ? tableList.length
    //     : size.isProt
    //         ? 3
    //         : 1;
    // final _isStatusAtUp =
    //     tableList.length < 3 && (onSelectImage == null || uploadImage == null);
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
                  // IconButton(
                  //     onPressed: () {
                  //       Navigator.pop(context);
                  //       onCancel!();
                  //     },
                  //     icon: Icon(Icons.close))
                ],
              ),
              SizedBox(
                height: size.getH(12),
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Wrap(
                      spacing: size.getW(24),
                      runSpacing: size.getH(24),
                      crossAxisAlignment: WrapCrossAlignment.end,
                      children: [
                        if (newWidget != null) newWidget!,
                        ...inputFields(tableList.toList(), size: size),
                        // if (_isStatusAtUp)
                        _statusSection(size: size)
                      ],
                    ),
                  ),
                  SizedBox(width: size.getW(12)),
                  Row(
                    children: [
                      if (onSelectImage != null)
                        Padding(
                          padding: EdgeInsets.only(right: size.getW(24)),
                          child: _imageAddSec(
                            size,
                            imagePath: _imageUrl,
                            title: LN.addImage,
                            onAdd: () {
                              ChooseImage.showTableDia(
                                ctx: context,
                                imageList: imageList,
                                onSelectImage: onSelectImage,
                              );
                            },
                          ),
                        ),
                      if (uploadImage != null)
                        Padding(
                          padding: EdgeInsets.only(right: size.getW(24)),
                          child: _imageAddSec(
                            size,
                            imagePath: _imageUrl,
                            isImageUpload: true,
                            title: _imageUrl == null || _imageUrl.isEmpty
                                ? LN.uploadImage
                                : LN.removeImg,
                            onAdd: uploadImage,
                          ),
                        ),
                    ],
                  )
                ],
              ),
              // SizedBox(
              //   height: size.getH(12),
              // ),
              // Wrap(
              //   spacing: size.getW(24),
              //   runSpacing: size.getH(24),
              //   crossAxisAlignment: WrapCrossAlignment.end,
              //   children: [
              //     if (tableList.length >= _inputLength)
              //       ...inputFields(
              //           tableList
              //               .getRange(_inputLength, tableList.length)
              //               .toList(),
              //           size: size),
              //     if (!_isStatusAtUp) _statusSection(size: size)
              //   ],
              // ),
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
              SizedBox(
                height: size.getH(24),
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
    return SizedBox(
      width: size.getW(width),
      child: Column(
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
      ),
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
                  width: size.getW(width),
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

  Widget _imageAddSec(
    Ssize size, {
    String? imagePath,
    Function()? onAdd,
    required String title,
    bool isImageUpload = false,
  }) {
    return Column(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: _imageSection(size,
              imageSecPath: imagePath, isImageUpload: isImageUpload),
        ),
        SizedBox(
          height: size.getH(12),
        ),
        SizedBox(
          width: size.getW(200),
          child: ElevatedButton(
              style: ButtonStyle(
                  visualDensity: VisualDensity.comfortable,
                  backgroundColor: WidgetStateProperty.all(kTempColor),
                  padding: WidgetStateProperty.all(EdgeInsets.symmetric(
                      horizontal: size.getW(12), vertical: size.getH(8)))),
              onPressed: onAdd,
              child: Text(
                title,
                style: TextStyle(
                  fontSize: size.getS(16),
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              )),
        )
      ],
    );
  }

  Widget _imageSection(
    Ssize size, {
    String? imageSecPath,
    bool isImageUpload = false,
  }) {
    final _imageUrl = imageSecPath;
    if (_imageUrl == null || _imageUrl.isEmpty) {
      if (isImageUpload) {
        return SizedBox(
          height: size.getS(140),
          width: size.getS(140),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset(
                "assets/svg/others/product_image.svg",
                height: size.getS(140),
                width: size.getS(140),
              ),
            ],
          ),
        );
      } else {
        return Container(
          height: size.getS(140),
          width: size.getS(140),
          decoration: BoxDecoration(
              border: Border.all(
                color: kTempColor,
              ),
              borderRadius: BorderRadius.circular(10)),
          child: Icon(
            Icons.category_outlined,
            color: kTempColor,
            size: size.getS(60),
          ),
        );
      }
    } else if (_imageUrl.contains('http')) {
      if (_imageUrl.contains('svg')) {
        return SvgImageSection(
          imageUrl: _imageUrl,
          height: size.getS(140),
          width: size.getS(140),
        );
      } else {
        return CachedNetworkImage(
            imageUrl: _imageUrl,
            height: size.getH(140),
            width: size.getW(140),
            placeholder: ImageError.load,
            errorWidget: ImageError.icon
            // fit: BoxFit.cover,
            );
      }
    } else {
      return Image.file(
        File(_imageUrl),
        height: size.getH(140),
        width: size.getW(140),
        // fit: BoxFit.cover,
      );
    }
  }
}
