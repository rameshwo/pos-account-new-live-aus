import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:pos_account/config/size_config.dart';
import 'package:pos_account/constant/constant.dart';
import 'package:pos_account/ln.dart';
import 'package:pos_account/model/home/setting/general/category/pro_cat_image.dart';
import 'package:pos_account/widgets/image/image_error.dart';
import 'package:pos_account/widgets/image/svg_image_sec.dart';
import 'package:pos_account/widgets/input/text_form/text_form_widget.dart';

class ChooseImage extends StatefulWidget {
  final List<ProductCategoriesImage>? imageList;
  final Function(String?)? onSelect;
  const ChooseImage({super.key, this.imageList, this.onSelect});

  static Future showTableDia({
    required BuildContext ctx,
    List<ProductCategoriesImage>? imageList,
    Function(String?)? onSelectImage,
  }) {
    return showDialog(
        context: ctx,
        builder: (builder) => SimpleDialog(
              backgroundColor: kBackgroundColor,
              titlePadding: EdgeInsets.zero,
              contentPadding: EdgeInsets.symmetric(horizontal: 24, vertical: 0),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15)),
              children: [
                ChooseImage(
                  imageList: imageList,
                  onSelect: onSelectImage,
                )
              ],
            ));
  }

  @override
  State<ChooseImage> createState() => _ChooseImageState();
}

class _ChooseImageState extends State<ChooseImage> {
  load() {
    if (mounted) setState(() {});
  }

  final _searchCltr = TextEditingController();

  List<ProductCategoriesImage>? imageList;
  int? selectedIndex;

  @override
  void initState() {
    setData();
    super.initState();
  }

  setData() {
    imageList = widget.imageList;
    selectedIndex = imageList
        ?.indexWhere((e) => e.isDefaultImage != null && e.isDefaultImage!);
    load();
  }

  @override
  Widget build(BuildContext context) {
    final size = Ssize(context);
    return Container(
      constraints: BoxConstraints(
        maxHeight: size.height / 1.14,
        minHeight: size.height / 5,
      ),
      width: size.width / 1.4,
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: size.getH(24),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  LN.defaultImages,
                  style: TextStyle(
                    fontSize: size.getS(24),
                    // fontFamily: ,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: Icon(Icons.close))
              ],
            ),
            SizedBox(
              height: size.getH(18),
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: size.getH(18.0)),
              child: SizedBox(
                width: size.width / 3,
                child: TextFormWidget(
                  isReq: false,
                  vPad: 12,
                  prefixIcon: Icon(
                    Icons.search,
                    size: size.getS(32),
                  ),
                  borderColor: Colors.black12,
                  cltr: _searchCltr,
                  hintText: LN.searchMenuImages,
                  onChanged: (String? val) {
                    if (val == null) return;
                    load();
                  },
                  suffixIcon: InkWell(
                      onTap: () {
                        _searchCltr.clear();
                        load();
                      },
                      child: Icon(Icons.close)),
                ),
              ),
            ),
            if (imageList != null)
              Wrap(
                children: [
                  ...List.generate(imageList!.length, (index) {
                    final imageData = imageList![index];
                    if (_searchCltr.text.isEmpty ||
                        (_searchCltr.text.isNotEmpty &&
                            imageData.name!
                                .toLowerCase()
                                .contains(_searchCltr.text)))
                      return Container(
                        width: size.getW(190),
                        height: size.getH(200),
                        decoration: BoxDecoration(
                            border: Border.all(
                              color: selectedIndex == index
                                  ? kTempColor
                                  : Colors.grey.shade400,
                              width: selectedIndex == index ? 1.5 : 1,
                            ),
                            borderRadius: BorderRadius.circular(5)),
                        margin: EdgeInsets.symmetric(
                            vertical: size.getH(8), horizontal: size.getW(8)),
                        child: InkWell(
                          onTap: () {
                            selectedIndex = index;
                            load();
                          },
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                                vertical: size.getH(8),
                                horizontal: size.getW(8)),
                            child: Column(
                              children: [
                                if (imageData.imageUrl != null &&
                                    imageData.imageUrl!.isNotEmpty)
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: imageData.imageUrl!.contains('svg')
                                        ? SvgImageSection(
                                            imageUrl: imageData.imageUrl!,
                                            height: size.getH(140),
                                            width: size.getW(160),
                                          )
                                        : CachedNetworkImage(
                                            imageUrl: imageData.imageUrl!,
                                            height: size.getH(140),
                                            width: size.getW(160),
                                            placeholder: ImageError.load,
                                            errorWidget: ImageError.text,
                                            // fit: BoxFit.fitHeight,
                                          ),
                                  ),
                                // SizedBox(
                                //   height: size.getH(8),
                                // ),
                                Expanded(
                                  child: Center(
                                    child: Text(
                                      imageData.name ?? '',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: size.getS(15),
                                        color: selectedIndex == index
                                            ? kTempColor
                                            : Colors.black,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      );
                    else
                      return SizedBox.shrink();
                  })
                ],
              ),
            SizedBox(height: size.getH(12)),
            Row(
              children: [
                SizedBox(width: size.getW(16)),
                ElevatedButton(
                    style: ButtonStyle(
                        backgroundColor:
                            WidgetStateProperty.all(kSecondaryColor),
                        padding: WidgetStateProperty.all(EdgeInsets.symmetric(
                            horizontal: size.getW(24),
                            vertical: size.getH(8)))),
                    onPressed: () {
                      if (widget.onSelect != null && selectedIndex != null) {
                        if (imageList != null &&
                            imageList!.any((e) =>
                                e.isDefaultImage != null &&
                                e.isDefaultImage!)) {
                          imageList!
                              .firstWhere((e) =>
                                  e.isDefaultImage != null && e.isDefaultImage!)
                              .isDefaultImage = false;
                        }
                        imageList![selectedIndex!].isDefaultImage = true;

                        widget.onSelect!(imageList![selectedIndex!].id);
                        Navigator.pop(context);
                      }
                    },
                    child: Text(
                      LN.confirm,
                      style: TextStyle(
                        fontSize: size.getS(16),
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    )),
                SizedBox(
                  width: size.getW(24),
                ),
                ElevatedButton(
                    style: ButtonStyle(
                        backgroundColor:
                            WidgetStateProperty.all(Colors.red.shade700),
                        padding: WidgetStateProperty.all(EdgeInsets.symmetric(
                            horizontal: size.getW(24),
                            vertical: size.getH(8)))),
                    onPressed: () {
                      Navigator.pop(context);
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
              height: size.getH(24),
            ),
          ],
        ),
      ),
    );
  }
}
