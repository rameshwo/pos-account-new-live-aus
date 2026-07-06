import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pos_account/config/size_config.dart';
import 'package:pos_account/constant/constant.dart';
import 'package:pos_account/providers/setting/store/store_pro_v2.dart';
import 'package:pos_account/widgets/image/network_image_sec.dart';
import 'package:provider/provider.dart';
import 'package:path/path.dart' as path;
import '../../../../../../../sidebar/pay_receipt/com/view_image.dart';
import '../../widgets/store_card.dart';

class LogoImageTab extends StatelessWidget {
  const LogoImageTab({super.key});

  @override
  Widget build(BuildContext context) {
    final storePro = Provider.of<StoreProV2>(context);
    final size = Ssize(context);
    return SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: size.getH(12)),
            StoreCardUI(
              title: "Store Logo & Favicon",
              iconData: Icons.image_outlined,
              child: _logoFaviconSection(size, context, storePro),
            ),
            StoreCardUI(
              title: "Online Thumbnail Image",
              iconData: Icons.image_outlined,
              child: _onlineThumbnailSection(size, context, storePro),
            ),
            StoreCardUI(
              title: "Centralized Thumbnail Image",
              iconData: Icons.image_outlined,
              child: _centralizedThumbnailSection(size, context, storePro),
            ),
          ],
        ));
  }

  void _viewImage(
    BuildContext context, {
    required String title,
    String? image,
  }) {
    if (image == null || image.isEmpty) return;

    showCupertinoDialog(
        context: context,
        barrierDismissible: true,
        builder: (_) {
          return SimpleDialog(
            titlePadding: EdgeInsets.zero,
            contentPadding: EdgeInsets.zero,
            insetPadding: EdgeInsets.zero,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            children: [
              ImageFullScreen(
                imageUrl: image,
                title: title,
              )
            ],
          );
        });
  }

  Widget _logoFaviconSection(
      Ssize size, BuildContext context, StoreProV2 storePro) {
    return Padding(
      padding: EdgeInsets.only(top: size.getH(16)),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _fieldLabel(size, label: "Logo"),
                SizedBox(height: size.getH(8)),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        children: [
                          _uploadBox(size, onTap: () async {
                            final _fileData = await storePro.uploadImage(
                                identifier: "StoreLogo");
                            if (_fileData != null) {
                              storePro.storeLogoImageS3 = _fileData;
                              storePro.notify;
                            }
                          }),
                          if (storePro.storeLogoImageS3?.filePath?.isNotEmpty ??
                              false)
                            Padding(
                              padding: EdgeInsets.only(top: size.getH(4)),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      path.basename(
                                          storePro.storeLogoImageS3?.filePath ??
                                              ''),
                                      style: TextStyle(
                                        fontSize: size.getS(14),
                                        color: Colors.black54,
                                      ),
                                    ),
                                  ),
                                  InkWell(
                                    onTap: () {
                                      storePro.storeLogoImageS3?.filePath = "";
                                      storePro.notify;
                                    },
                                    child: Icon(
                                      Icons.delete_outline,
                                      size: size.getS(20),
                                      color: Colors.black54,
                                    ),
                                  )
                                ],
                              ),
                            )
                        ],
                      ),
                    ),
                    if (storePro.storeLogoImageS3?.filePath?.isNotEmpty ??
                        false)
                      Padding(
                        padding: EdgeInsets.only(left: size.getW(12)),
                        child: InkWell(
                          onTap: () => _viewImage(context,
                              title: 'Store Logo',
                              image: storePro.storeLogoImageS3?.filePath),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: NetworkImageSec(
                              image: storePro.storeLogoImageS3?.filePath,
                              width: 40,
                              height: 40,
                              boxFit: BoxFit.cover,
                              errWidget: SizedBox.shrink(),
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(width: size.getW(24)),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _fieldLabel(size, label: "Favicon"),
                SizedBox(height: size.getH(8)),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                        child: Column(
                      children: [
                        _uploadBox(size, onTap: () async {
                          final _fileData = await storePro.uploadImage(
                              identifier: "StoreFavicon");
                          if (_fileData != null) {
                            storePro.storeFavImageS3 = _fileData;
                            storePro.notify;
                          }
                        }),
                        if (storePro.storeFavImageS3?.filePath?.isNotEmpty ??
                            false)
                          Padding(
                            padding: EdgeInsets.only(top: size.getH(4)),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    path.basename(
                                        storePro.storeFavImageS3?.filePath ??
                                            ''),
                                    style: TextStyle(
                                      fontSize: size.getS(14),
                                      color: Colors.black54,
                                    ),
                                  ),
                                ),
                                InkWell(
                                  onTap: () {
                                    storePro.storeFavImageS3?.filePath = "";
                                    storePro.notify;
                                  },
                                  child: Icon(
                                    Icons.delete_outline,
                                    size: size.getS(20),
                                    color: Colors.black54,
                                  ),
                                )
                              ],
                            ),
                          )
                      ],
                    )),
                    if (storePro.storeFavImageS3?.filePath?.isNotEmpty ?? false)
                      Padding(
                        padding: EdgeInsets.only(left: size.getW(12)),
                        child: InkWell(
                          onTap: () => _viewImage(context,
                              title: 'Store Favicon',
                              image: storePro.storeFavImageS3?.filePath),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: NetworkImageSec(
                              image: storePro.storeFavImageS3?.filePath,
                              width: 40,
                              height: 40,
                              boxFit: BoxFit.cover,
                              errWidget: SizedBox.shrink(),
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _onlineThumbnailSection(
      Ssize size, BuildContext context, StoreProV2 storePro) {
    return Padding(
      padding: EdgeInsets.only(top: size.getH(16)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _fieldLabel(size, label: "No Product Thumbnail Image"),
          SizedBox(height: size.getH(8)),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  children: [
                    _uploadBox(size, trailingIcon: Icons.tune, onTap: () async {
                      final _fileData = await storePro.uploadImage(
                          identifier: "NoProductImage");
                      if (_fileData != null) {
                        storePro.noProdImageS3 = _fileData;
                        storePro.notify;
                      }
                    }),
                    if (storePro.noProdImageS3?.filePath?.isNotEmpty ?? false)
                      Padding(
                        padding: EdgeInsets.only(top: size.getH(4)),
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                path.basename(
                                    storePro.noProdImageS3?.filePath ?? ''),
                                style: TextStyle(
                                  fontSize: size.getS(14),
                                  color: Colors.black54,
                                ),
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                storePro.noProdImageS3?.filePath = "";
                                storePro.notify;
                              },
                              child: Icon(
                                Icons.delete_outline,
                                size: size.getS(20),
                                color: Colors.black54,
                              ),
                            )
                          ],
                        ),
                      )
                  ],
                ),
              ),
              if (storePro.noProdImageS3?.filePath?.isNotEmpty ?? false)
                Padding(
                  padding: EdgeInsets.only(left: size.getW(12)),
                  child: InkWell(
                    onTap: () => _viewImage(context,
                        title: 'No Product Thumbnail',
                        image: storePro.noProdImageS3?.filePath),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: NetworkImageSec(
                        image: storePro.noProdImageS3?.filePath,
                        width: 40,
                        height: 40,
                        boxFit: BoxFit.cover,
                        errWidget: SizedBox.shrink(),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _centralizedThumbnailSection(
      Ssize size, BuildContext context, StoreProV2 storePro) {
    return Padding(
      padding: EdgeInsets.only(top: size.getH(16)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _fieldLabel(size, label: "Thumbnail Images"),
          SizedBox(height: size.getH(12)),
          Text(
            "Upload thumbnail images for different sections of your store. These images will be displayed in various locations on your website.",
            style: TextStyle(
              fontSize: size.getS(14),
              color: Colors.black54,
            ),
          ),
          SizedBox(height: size.getH(16)),
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            childAspectRatio: 6.5,
            mainAxisSpacing: size.getH(12),
            crossAxisSpacing: size.getW(24),
            physics: NeverScrollableScrollPhysics(),
            children: [
              ...List.generate(storePro.centralizedImageList.length, (i) {
                final _imageData = storePro.centralizedImageList[i];
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _fieldLabel(size,
                        label: "${_imageData.name} Thumbnail",
                        showInfoIcon: false),
                    SizedBox(height: size.getH(8)),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(
                            children: [
                              _uploadBox(size, onTap: () async {
                                final _fileData = await storePro.uploadImage(
                                    identifier: "${_imageData.name}Thumbnail");
                                if (_fileData != null) {
                                  _imageData.uploadImageS3Res = _fileData;
                                  storePro.notify;
                                }
                              }),
                              if (_imageData
                                      .uploadImageS3Res.filePath?.isNotEmpty ??
                                  false)
                                Padding(
                                  padding: EdgeInsets.only(top: size.getH(4)),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          path.basename(_imageData
                                                  .uploadImageS3Res.filePath ??
                                              ''),
                                          style: TextStyle(
                                            fontSize: size.getS(14),
                                            color: Colors.black54,
                                          ),
                                        ),
                                      ),
                                      InkWell(
                                        onTap: () {
                                          if (_imageData.id.isNotEmpty) {
                                            storePro.centralizedDeletedIds
                                                .add(_imageData.id);
                                          }
                                          _imageData.uploadImageS3Res.filePath =
                                              "";
                                          storePro.notify;
                                        },
                                        child: Icon(
                                          Icons.delete_outline,
                                          size: size.getS(20),
                                          color: Colors.black54,
                                        ),
                                      )
                                    ],
                                  ),
                                )
                            ],
                          ),
                        ),
                        if (_imageData.uploadImageS3Res.filePath?.isNotEmpty ??
                            false)
                          Padding(
                            padding: EdgeInsets.only(left: size.getW(12)),
                            child: InkWell(
                              onTap: () => _viewImage(context,
                                  title: "${_imageData.name} Thumbnail",
                                  image: _imageData.uploadImageS3Res.filePath),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: NetworkImageSec(
                                  image: _imageData.uploadImageS3Res.filePath,
                                  width: 40,
                                  height: 40,
                                  boxFit: BoxFit.cover,
                                  errWidget: SizedBox.shrink(),
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ],
                );
              })
            ],
          ),
        ],
      ),
    );
  }

  Widget _fieldLabel(
    Ssize size, {
    required String label,
    bool showInfoIcon = true,
  }) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(Icons.image_outlined, size: size.getS(16), color: Colors.black87),
        SizedBox(width: size.getW(6)),
        Text(
          label,
          style: TextStyle(
            fontSize: size.getS(14),
            color: Colors.black87,
            fontFamily: kFontFMedium,
          ),
        ),
        if (showInfoIcon) ...[
          SizedBox(width: size.getW(4)),
          Icon(Icons.info_outline, size: size.getS(16), color: Colors.black45),
        ],
      ],
    );
  }

  Widget _uploadBox(
    Ssize size, {
    Function()? onTap,
    IconData? trailingIcon,
  }) {
    return DottedBorder(
      color: Colors.grey.shade400,
      strokeWidth: 1.5,
      dashPattern: [6, 4],
      radius: Radius.circular(8),
      borderType: BorderType.RRect,
      padding: EdgeInsets.zero,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        splashColor: kSecondaryColor.withAlpha(30),
        child: Container(
          height: size.getH(46),
          width: double.infinity,
          padding: EdgeInsets.symmetric(horizontal: size.getW(14)),
          child: Row(
            children: [
              Icon(Icons.upload_outlined,
                  color: Colors.black38, size: size.getS(18)),
              SizedBox(width: size.getW(8)),
              Text(
                "Click or drag to upload",
                style: TextStyle(
                  fontSize: size.getS(14),
                  color: Colors.black38,
                ),
              ),
              if (trailingIcon != null) ...[
                const Spacer(),
                Icon(trailingIcon, color: Colors.black38, size: size.getS(20)),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
