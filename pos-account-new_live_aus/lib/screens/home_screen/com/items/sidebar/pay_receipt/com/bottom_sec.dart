import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pos_account/config/size_config.dart';
import 'package:pos_account/constant/constant.dart';
import 'package:pos_account/constant/date_format_keys.dart';
import 'package:pos_account/ln.dart';
import 'package:pos_account/model/ui_model/asset_title.dart';
import 'package:pos_account/repository/if_exception.dart';
import 'package:pos_account/services/image/image_service.dart';
import 'package:share_plus/share_plus.dart';
import 'email_dia.dart';

class PayReBottomSec extends StatelessWidget {
  final GlobalKey? downloadKey;
  final String receiptName;
  final Function(bool)? loadFun;
  final Function()? getEmailDetail;
  final String? orderId;

  const PayReBottomSec({
    super.key,
    this.downloadKey,
    this.loadFun,
    this.getEmailDetail,
    this.receiptName = "POSAPT_FILE",
    required this.orderId,
  });

  onTap(AssetTitle aT, {required BuildContext context}) async {
    switch (aT.id) {
      case 0: // share
        {
          await download(isForShare: true).then((filePath) async {
            await share(filePath: filePath);
          });
          // print("share");
          break;
        }
      case 1: //download
        {
          await download().then((filePath) async {
            await openFile(context, filePath: filePath);
          });

          // final RenderBox renderBox =
          //     downloadKey?.currentContext?.findRenderObject() as RenderBox;

          // final _height = renderBox.size.height * 525 / renderBox.size.width;

          // log("${renderBox.size.height} X ${renderBox.size.width}");
          // // return;

          // if (downloadKey != null) {
          //   final _filePath = await ImageService.getTempImagePathFromKey(
          //       globalKey: downloadKey, title: "test_p_5645");
          //   if (_filePath != null)
          //     await PrinterService.checkDevice(
          //       ip: "192.168.1.100",
          //       port: 9100,
          //       paperSize: 'mm80',
          //       doPrint: true,
          //       run: ({required NetworkPrinter printer}) async {
          //         print("run functio working");
          //         await ImagePrint.printImage(
          //           printer: printer,
          //           imagePath: _filePath,
          //           height: _height.floor(), // 1250/525
          //           width: 525,
          //         );
          //       },
          //     );
          // print("download: $_filePath");
          // } else {
          //   log("no key");
          // }

          break;
        }
      case 2: //email
        {
          showEmailD(context);
          break;
        }
      // case 3: // print receipt
      //   {
      //     printReceipt(context);
      //     // print("print receipt");
      //     break;
      //   }
      // case 4:
      //   {
      //     await printViaBluetooth(context);
      //     break;
      //   }

      default:
        {
          // print("default");
          break;
        }
    }
  }

  // Future<void> printViaBluetooth(BuildContext context) async {
  //   payPro.loadingInvoice = true;
  //   payPro.notify;
  //   final byte = await ImageService.capture(key: downloadKey);
  //   payPro.loadingInvoice = false;
  //   payPro.notify;
  //   if (byte != null) {
  //     final _status = BluetoothService.connectedDevice;

  //     if (_status != null) {
  //       BluetoothService.printImage(imageBytes: byte);
  //     } else {
  //       BluetoothPrinterSetup().showDeviceList(context).then((_) {
  //         if (_ != null && _ is bool && _) {
  //           BluetoothService.printImage(imageBytes: byte);
  //         }
  //       });
  //     }
  //   }
  // }

  Future<String?> download({bool isForShare = false}) async {
    if (loadFun == null) return null;

    loadFun!(true);
    final byte = await ImageService.capture(key: downloadKey);
    if (byte != null) {
      // final filePath = await ImageService.downloadFile(
      //     data: byte,
      //     fileName: "POSAPT_INVOICE ${YMD_T_FORMAT.format(DateTime.now())}",
      //     isForShare: isForShare);

      final filePath = await ImageService.saveFile(
          byte, "${receiptName}_${YMD_T_FORMAT.format(DateTime.now())}.jpg",
          saveType: isForShare ? ImageSaveType.share : ImageSaveType.download);

      loadFun!(false);
      return filePath;
    } else {
      loadFun!(false);
    }
    return null;
  }

  Future<void> openFile(BuildContext context, {String? filePath}) async {
    if (filePath != null) {
      IfException.showMessage(message: LN.downloadCmpt, isError: false);
      // await showDialog(
      //     context: context,
      //     builder: (builder) => SuggestDia(
      //           description: LN.doYouWantOpenRcpt,
      //           // oK: () async {
      //           //   await ImageService.openFile(filePath);
      //           //   Navigator.pop(context);
      //           // },
      //         ));
    }
  }

  Future<void> share({String? filePath}) async {
    if (filePath == null) return;
    try {
      await Share.shareXFiles(
        [XFile(filePath)],
        text: LN.payReceipt,
        subject: LN.payReceipt,
      );
    } catch (_) {
      // print("Error in share $_");
    }
  }

  Future<void> showEmailD(BuildContext context) {
    if (getEmailDetail != null) getEmailDetail!();

    return showDialog(
        context: context,
        builder: (builder) => SimpleDialog(
              titlePadding: EdgeInsets.zero,
              contentPadding:
                  EdgeInsets.symmetric(horizontal: 24, vertical: 24),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15)),
              children: [DoEmailDia(orderId: orderId)],
            ));
  }

  @override
  Widget build(BuildContext context) {
    final assetPayReceiptList = <AssetTitle>[
      //TODO: will active when it works as expected
      AssetTitle(
          assetPath: "assets/svg/others/share.svg", title: LN.share, id: 0),
      AssetTitle(
          assetPath: "assets/svg/others/download.svg",
          title: LN.download,
          id: 1),
      if (getEmailDetail != null)
        AssetTitle(assetPath: "", title: LN.email, id: 2),
      // AssetTitle(
      //     assetPath: "assets/svg/icons/bluetooth.svg",
      //     title: "Print via Bluetooth",
      //     id: 4),
      // AssetTitle(assetPath: "", title: LN.printReceipt, id: 3),
      // AssetTitle(assetPath: "assets/svg/others/fav.svg", title: "Favourite", id: 4),
    ];
    final Ssize size = Ssize(context);

    return Wrap(
      spacing: size.getW(12),
      runSpacing: size.getH(16),
      alignment: WrapAlignment.center,
      children: [
        ...List.generate(
            assetPayReceiptList.length,
            (index) => Container(
                  decoration: BoxDecoration(
                      color: Colors.transparent,
                      border: Border.all(
                          color: Color.fromARGB(255, 255 - index * 20,
                              100 + index * 60, (index) * 20),
                          width: 2),
                      borderRadius: BorderRadius.circular(10)),
                  child: Material(
                    color: kPrimaryColor,
                    borderRadius: BorderRadius.circular(10),
                    child: InkWell(
                      onTap: () {
                        onTap(
                          assetPayReceiptList[index],
                          context: context,
                        );
                      },
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: size.getW(12), vertical: size.getH(8)),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            assetPayReceiptList[index].assetPath.isNotEmpty
                                ? Padding(
                                    padding:
                                        EdgeInsets.only(right: size.getW(12.0)),
                                    child: SvgPicture.asset(
                                      assetPayReceiptList[index].assetPath,
                                      width: size.getS(21),
                                      height: size.getS(21),
                                    ),
                                  )
                                : SizedBox.shrink(),
                            Text(
                              assetPayReceiptList[index].title,
                              style: TextStyle(
                                fontSize: size.getS(14),
                                color: Colors.white,
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ))
      ],
    );
  }
}
