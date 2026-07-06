import 'package:flutter/material.dart';
import 'package:pos_account/config/size_config.dart';
import 'package:pos_account/constant/constant.dart';
import 'package:pos_account/constant/date_format_keys.dart';
import 'package:pos_account/ln.dart';
import 'package:pos_account/repository/if_exception.dart';
import 'package:pos_account/screens/home_screen/com/items/sidebar/pay_receipt/com/widget_to_image.dart';
import 'package:pos_account/services/image/image_service.dart';
import 'package:pos_account/widgets/dialog/confirm_dialog.dart';
import 'package:pos_account/widgets/image/network_image_sec.dart';
import 'package:pos_account/widgets/loading.dart';

class PosDeviceQrShow extends StatelessWidget {
  final String diaName;
  final String? title;
  final String image;
  final Widget? loading;

  const PosDeviceQrShow({
    super.key,
    required this.diaName,
    this.title,
    required this.image,
    this.loading,
  });

  static GlobalKey? _globalKey;

  static Future showQRDia({
    required BuildContext ctx,
    String? title,
    required String image,
    required String diaName,
    Widget? loading,
  }) async {
    return await showDialog(
        context: ctx,
        builder: (builder) => SimpleDialog(
              backgroundColor: kBackgroundColor,
              titlePadding: EdgeInsets.zero,
              contentPadding: EdgeInsets.symmetric(horizontal: 24, vertical: 0),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15)),
              children: [
                PosDeviceQrShow(
                  title: title,
                  image: image,
                  diaName: diaName,
                  loading: loading,
                )
              ],
            ));
  }

  Future<void> _downloadQR(BuildContext context,
      {GlobalKey? imageKey, required String name}) async {
    final byte = await ImageService.capture(key: imageKey);
    if (byte != null) {
      final filePath = await ImageService.saveFile(
          byte, "${name}_${YMD_T_FORMAT.format(DateTime.now())}.jpg");
      if (filePath != null)
        IfException.showMessage(message: LN.downloadCmpt, isError: false);
      // await showDialog(
      //     context: context,
      //     builder: (builder) => SuggestDia(
      //           description: "Do you want to open Device QR?",
      //           // oK: () async {
      //           //   await ImageService.openFile(filePath);
      //           //   Navigator.pop(context);
      //           // },
      //         ));
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = Ssize(context);
    return Container(
      constraints: BoxConstraints(
        maxHeight: size.height / 1.14,
        minHeight: size.height / 4,
      ),
      width: size.width / 2.7,
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          // crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: size.getH(24),
            ),
            Row(
              children: [
                Text(
                  diaName,
                  style: TextStyle(
                    fontSize: size.getS(24),
                    // fontFamily: ,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                if (title != null)
                  IconButton(
                      onPressed: () {
                        showDialog(
                            context: context,
                            builder: (_) {
                              return ConfirmDialog(
                                title: "Do you want to download QR Code?",
                                subTitle: "",
                                actionText: "Yes",
                                cancelText: "No",
                                onDelete: () async {
                                  _downloadQR(
                                    context,
                                    imageKey: _globalKey,
                                    name: title ?? '',
                                  );
                                  return null;
                                },
                              );
                            });
                      },
                      icon: Icon(
                        Icons.download,
                        color: Colors.black54,
                        size: size.getS(24),
                      ),
                      tooltip: "Download"),
                Spacer(),
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
            WidgetToImage(builder: (key) {
              _globalKey = key;

              return Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  // borderRadius: BorderRadius.circular(5),
                ),
                child: Column(
                  children: [
                    NetworkImageSec(
                      image: image,
                      height: size.height * 0.4,
                      width: size.height * 0.4,
                      placeHolder: Loading(),
                    ),
                    if (title != null)
                      Padding(
                        padding: EdgeInsets.only(
                            // top: size.getH(0),
                            bottom: size.getH(6)),
                        child: Text(
                          title ?? '',
                          style: TextStyle(
                            fontSize: size.getS(17),
                            color: Colors.black,
                            fontFamily: kFontFMedium,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                  ],
                ),
              );
            }),
            SizedBox(
              height: size.getH(16),
            ),
            if (loading != null) loading!,
            SizedBox(
              height: size.getH(24),
            ),
          ],
        ),
      ),
    );
  }
}
