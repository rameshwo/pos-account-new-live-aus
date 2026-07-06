import 'package:flutter/material.dart';
import 'package:pos_account/config/dual_display/dual_display_config.dart';
import 'package:pos_account/config/size_config.dart';
import 'package:pos_account/constant/constant.dart';
import 'package:pos_account/ln.dart';
import 'package:pos_account/providers/setting/pos_device/cus_display_pro.dart';
import 'package:pos_account/widgets/load_btn.dart';
import 'package:pos_account/widgets/loading.dart';
import 'package:provider/provider.dart';
import 'package:path/path.dart' as path;

import '../general/common/common_header.dart';

class CusDisplaySec extends StatefulWidget {
  final Function()? onBack;
  const CusDisplaySec({super.key, this.onBack});

  @override
  State<CusDisplaySec> createState() => _CusDisplaySecState();
}

class _CusDisplaySecState extends State<CusDisplaySec> {
  final _patterns = <DualDisplayModel>[
    DualDisplayModel(title: "None", pattern: DualDisPattern.none),
    DualDisplayModel(
        title: "Style 1 - ",
        subTitle: "slideshow",
        pattern: DualDisPattern.style1),
    DualDisplayModel(
        title: "Style 2 - ", subTitle: "video", pattern: DualDisPattern.style2),
    DualDisplayModel(
        title: "Style 3 - ",
        subTitle: "slideshow and video",
        pattern: DualDisPattern.style3),
    DualDisplayModel(
        title: "Style 4 - ",
        subTitle: "latest scanned product",
        pattern: DualDisPattern.style4)
  ];

  Function()? get _pickImage {
    if (_displayPro.imagePathList != null &&
        _displayPro.imagePathList!.length >= 5)
      return null;
    else
      return () {
        _displayPro.getPhotoPick();
      };
  }

  List<List<Object>>? get _getImgList {
    return _displayPro.imagePathList
        ?.map((e) => [
              path.basename(e),
              () {
                _displayPro.imagePathList?.remove(e);
                _displayPro.notify;
              }
            ])
        .toList();
  }

  Function()? get _pickVideo {
    if (_displayPro.videoPath != null)
      return null;
    else
      return () {
        _displayPro.getVideoPick();
      };
  }

  List<List<Object>>? get _getVideo {
    if (_displayPro.videoPath == null)
      return null;
    else
      return [
        [
          path.basename(_displayPro.videoPath ?? ''),
          () {
            _displayPro.videoPath = null;
            _displayPro.notify;
          }
        ]
      ];
  }

  late CustomerDisplayPro _displayPro;

  @override
  void initState() {
    _getData();
    super.initState();
  }

  void _getData() {
    final dPro = Provider.of<CustomerDisplayPro>(context, listen: false);
    dPro.getData();
  }

  @override
  void dispose() {
    _displayPro.pattern = DualDisPattern.none;
    _displayPro.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = Ssize(context);
    _displayPro = Provider.of<CustomerDisplayPro>(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CommonHeader(
          child: Row(
            children: [
              IconButton(
                  onPressed: widget.onBack,
                  icon: Icon(Icons.arrow_back),
                  visualDensity: VisualDensity.compact),
              SizedBox(width: size.getW(8)),
              Text(
                "Dual-display Settings",
                style: TextStyle(
                  fontSize: size.getS(18),
                  // fontFamily: ,ph
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ],
          ),
        ),
        Expanded(
            child: Card(
          child: Processing(
            loading: _displayPro.loading,
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: size.getW(48)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: size.getH(16),
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Pattern",
                              style: TextStyle(
                                fontSize: size.getS(18),
                                // fontFamily: kFontFMedium,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                            ...List.generate(
                              _patterns.length,
                              (i) => _radioText(
                                size,
                                value:
                                    _displayPro.pattern == _patterns[i].pattern,
                                onChanged: (_) {
                                  if (_displayPro.pattern ==
                                      _patterns[i].pattern) return;
                                  _displayPro.pattern = _patterns[i].pattern;
                                  _displayPro.clear();
                                  _displayPro.setPrevData();
                                  _displayPro.notify;
                                },
                                title: _patterns[i].title,
                                subTitle: _patterns[i].subTitle,
                              ),
                            ),
                          ],
                        ),
                      ),
                      if (_displayPro.pattern != DualDisPattern.none)
                        Expanded(child: _previewSection(size))
                    ],
                  ),
                  SizedBox(
                    height: size.getH(24),
                  ),
                  if (_displayPro.pattern == DualDisPattern.style1)
                    _style1bottomSection(
                      size,
                      onTap: _pickImage,
                      imageList: _getImgList,
                    )
                  else if (_displayPro.pattern == DualDisPattern.style2)
                    _style2bottomSection(
                      size,
                      onTap: _pickVideo,
                      video: _getVideo,
                    )
                  else if (_displayPro.pattern == DualDisPattern.style3) ...[
                    _style1bottomSection(
                      size,
                      onTap: _pickImage,
                      imageList: _getImgList,
                    ),
                    SizedBox(
                      height: size.getH(24),
                    ),
                    _style2bottomSection(
                      size,
                      onTap: _pickVideo,
                      video: _getVideo,
                    )
                  ],
                  SizedBox(
                    height: size.getH(36),
                  ),
                  Row(
                    children: [
                      LoadButton(
                        btnText: "Apply",
                        onsave: _displayPro.saveData,
                      ),
                      SizedBox(
                        width: size.getW(24),
                      ),
                      LoadButton(
                        btnText: LN.clear,
                        btnColor: Colors.red,
                        onsave: () {
                          _displayPro.clear();
                          _displayPro.notify;
                        },
                      ),
                    ],
                  ),
                  SizedBox(
                    height: size.getH(60),
                  ),
                ],
              ),
            ),
          ),
        ))
      ],
    );
  }

  //////
  ///Widgets

  Widget _style2bottomSection(
    Ssize size, {
    Function()? onTap,
    List<List<Object>>? video,
  }) {
    return _uploadSection(
      size,
      image: Icons.play_circle_outline,
      title: "Video",
      subTitle: "Selected video",
      uploadText: "Please pick a video file",
      onTap: onTap,
      fileList: video,
    );
  }

  Widget _style1bottomSection(
    Ssize size, {
    Function()? onTap,
    List<List<Object>>? imageList,
  }) {
    return _uploadSection(
      size,
      image: Icons.image,
      title: "Slideshow",
      subTitle: "Selected images (${imageList?.length ?? 0}/5)",
      uploadText: "Please pick an image file",
      onTap: onTap,
      fileList: imageList,
    );
  }

  Column _uploadSection(
    Ssize size, {
    required IconData image,
    required String title,
    required String subTitle,
    required String uploadText,
    Function()? onTap,
    List<List<Object>>? fileList,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(image),
            SizedBox(
              width: size.getW(12),
            ),
            Text(
              title,
              style: TextStyle(
                fontSize: size.getS(18),
                // fontFamily: ,ph
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ],
        ),
        SizedBox(
          height: size.getH(4),
        ),
        Text(
          subTitle,
          style: TextStyle(
            fontSize: size.getS(18),
            color: Colors.black,
          ),
        ),
        if (fileList != null)
          ...List.generate(fileList.length, (i) {
            if (fileList[i].length == 2)
              return Row(
                children: [
                  SizedBox(
                    width: size.getW(820),
                    height: size.getH(60),
                    child: Card(
                      elevation: 4,
                      color: Colors.grey.shade50,
                      child: Row(children: [
                        SizedBox(
                          width: size.getW(12),
                        ),
                        if (fileList[i].first is String)
                          Expanded(
                            child: Text(
                              fileList[i].first as String,
                              style: TextStyle(
                                fontSize: size.getS(16),
                                color: Colors.black,
                              ),
                            ),
                          ),
                        Container(
                          height: double.infinity,
                          width: size.getW(80),
                          decoration: BoxDecoration(
                              color: kSecondaryColor,
                              borderRadius: BorderRadius.only(
                                topRight: Radius.circular(5),
                                bottomRight: Radius.circular(5),
                              )),
                          child: Icon(
                            Icons.image,
                            color: Colors.white,
                            size: size.getS(36),
                          ),
                        )
                      ]),
                    ),
                  ),
                  if (fileList[i].last is Function()?)
                    IconButton(
                        onPressed: fileList[i].last as Function(),
                        icon: Container(
                            padding: EdgeInsets.all(size.getS(5)),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.grey.shade700,
                            ),
                            child: Icon(
                              Icons.close,
                              color: Colors.white,
                            )))
                ],
              );
            else
              return SizedBox.shrink();
          }),
        if (onTap != null)
          SizedBox(
            width: size.getW(820),
            height: size.getH(60),
            child: Card(
              elevation: 4,
              color: Colors.grey.shade50,
              child: InkWell(
                onTap: onTap,
                child: Row(children: [
                  SizedBox(
                    width: size.getW(12),
                  ),
                  Text(
                    uploadText,
                    style: TextStyle(
                      fontSize: size.getS(16),
                      color: Colors.black,
                    ),
                  ),
                  Spacer(),
                  Container(
                    height: double.infinity,
                    width: size.getW(80),
                    decoration: BoxDecoration(
                        color: kSecondaryColor,
                        borderRadius: BorderRadius.only(
                          topRight: Radius.circular(5),
                          bottomRight: Radius.circular(5),
                        )),
                    child: Icon(
                      Icons.upload_rounded,
                      color: Colors.white,
                      size: size.getS(36),
                    ),
                  )
                ]),
              ),
            ),
          ),
      ],
    );
  }

  Widget _radioText(
    Ssize size, {
    bool value = false,
    Function(bool?)? onChanged,
    required String title,
    String? subTitle,
  }) {
    return Row(
      children: [
        Radio(
          value: value,
          groupValue: true,
          onChanged: onChanged,
          visualDensity: VisualDensity.compact,
        ),
        InkWell(
          onTap: onChanged != null ? () => onChanged(true) : null,
          child: Text.rich(
            TextSpan(
              text: title,
              children: [
                if (subTitle != null)
                  TextSpan(
                      text: subTitle,
                      style: TextStyle(fontWeight: FontWeight.normal))
              ],
            ),
            style: TextStyle(
              fontSize: size.getS(18),
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        ),
      ],
    );
  }

  Column _previewSection(Ssize size) {
    final pattern = _displayPro.pattern;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Preview",
          style: TextStyle(
            fontSize: size.getS(18),
            // fontFamily: kFontFMedium,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        Card(
          margin: EdgeInsets.zero,
          elevation: 4,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          child: SizedBox(
            height: size.getH(180),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  width: size.getW(150),
                  child: Column(
                    children: [
                      SizedBox(height: size.getH(12)),
                      Text(
                        "Checkout list",
                        style: TextStyle(
                          fontSize: size.getS(16),
                          fontFamily: kFontFMedium,
                          color: Colors.black,
                        ),
                      ),
                      SizedBox(
                        height: size.getH(12),
                      ),
                      ...List.generate(
                          5,
                          (index) => Padding(
                                padding: EdgeInsets.only(bottom: size.getH(4)),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Container(
                                      height: size.getH(6),
                                      width: size.getW(18),
                                      color: Colors.grey.shade300,
                                    ),
                                    SizedBox(
                                      width: size.getW(12),
                                    ),
                                    Container(
                                      height: size.getH(6),
                                      width: size.getW(80),
                                      color: Colors.grey.shade300,
                                    )
                                  ],
                                ),
                              )),
                      Spacer(),
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.symmetric(
                            vertical: size.getH(4), horizontal: size.getW(12)),
                        decoration: BoxDecoration(
                            color: Colors.grey.shade300,
                            borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(10))),
                        child: Text(
                          "Total",
                          style: TextStyle(
                            fontSize: size.getS(16),
                            fontFamily: kFontFMedium,
                            color: Colors.black,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.grey.shade50,
                    borderRadius: BorderRadius.only(
                        topRight: Radius.circular(10),
                        bottomRight: Radius.circular(10)),
                  ),
                  width: size.getW(180),
                  child: pattern == DualDisPattern.style1
                      ? _style1_2(
                          size,
                          title: "Slideshow",
                          iconData: Icons.image_outlined,
                        )
                      : pattern == DualDisPattern.style2
                          ? _style1_2(
                              size,
                              title: "Video",
                              iconData: Icons.play_circle_outlined,
                            )
                          : pattern == DualDisPattern.style3
                              ? _style3(size)
                              : pattern == DualDisPattern.style4
                                  ? _style4(size)
                                  : SizedBox.shrink(),
                )
              ],
            ),
          ),
        )
      ],
    );
  }

  Column _style1_2(
    Ssize size, {
    required String title,
    required IconData iconData,
  }) {
    return Column(
      children: [
        Spacer(),
        Expanded(
          flex: 2,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.grey.shade500,
            ),
            alignment: Alignment.center,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  iconData,
                  size: size.getS(25),
                  color: Colors.white,
                ),
                SizedBox(
                  width: size.getW(6),
                ),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: size.getS(16),
                    fontFamily: kFontFMedium,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
        Spacer(),
      ],
    );
  }

  Column _style3(Ssize size) {
    return Column(
      children: [
        Expanded(
          child: Container(
            decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.only(topRight: Radius.circular(10))),
            alignment: Alignment.center,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.image_outlined,
                  size: size.getS(25),
                ),
                SizedBox(
                  width: size.getW(6),
                ),
                Text(
                  "Slideshow",
                  style: TextStyle(
                    fontSize: size.getS(16),
                    fontFamily: kFontFMedium,
                    color: Colors.black,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
        Expanded(
          child: Container(
            decoration: BoxDecoration(
                color: Colors.grey.shade500,
                borderRadius:
                    BorderRadius.only(bottomRight: Radius.circular(10))),
            alignment: Alignment.center,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.play_circle_outlined,
                  size: size.getS(25),
                  color: Colors.white,
                ),
                SizedBox(
                  width: size.getW(6),
                ),
                Text(
                  "Video",
                  style: TextStyle(
                    fontSize: size.getS(16),
                    fontFamily: kFontFMedium,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _style4(Ssize size) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: size.getH(12)),
      child: Column(
        children: [
          Text(
            "Latest Scanned",
            style: TextStyle(
              fontSize: size.getS(14),
              fontFamily: kFontFMedium,
              color: Colors.black54,
            ),
          ),
          SizedBox(
            height: size.getH(4),
          ),
          Container(
            width: size.getW(100),
            height: size.getH(80),
            padding: EdgeInsets.symmetric(
                vertical: size.getH(2), horizontal: size.getW(2)),
            decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(5)),
            alignment: Alignment.center,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Product\nImage",
                  style: TextStyle(
                    fontSize: size.getS(15),
                    fontFamily: kFontFMedium,
                    color: Colors.black,
                    height: 1.1,
                  ),
                  textAlign: TextAlign.center,
                ),
                Icon(
                  Icons.image_outlined,
                  size: size.getS(28),
                )
              ],
            ),
          ),
          SizedBox(
            height: size.getH(8),
          ),
          Text(
            "Product Title",
            style: TextStyle(
              fontSize: size.getS(16),
              fontFamily: kFontFMedium,
              color: Colors.black54,
            ),
          ),
        ],
      ),
    );
  }
}
