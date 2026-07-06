import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:pos_account/config/size_config.dart';
import 'package:pos_account/constant/constant.dart';
import 'package:pos_account/ln.dart';
import 'package:pos_account/services/printer/usb/usb_service.dart';
import 'package:pos_account/widgets/load_btn.dart';
import 'package:pos_account/widgets/no_items_sec.dart';
import 'package:thermal_printer_plus/thermal_printer.dart';

class UsbPrinterSet extends StatelessWidget {
  final Function(PrinterDevice?)? onScanDone;
  const UsbPrinterSet({super.key, this.onScanDone});

  @override
  Widget build(BuildContext context) {
    final size = Ssize(context);
    return Container(
      decoration: BoxDecoration(
          color: kPrimaryColor, borderRadius: BorderRadius.circular(5)),
      child: InkWell(
        onTap: () {
          showDeviceList(context).then((val) {
            if (val ?? false) {
              if (onScanDone != null) onScanDone!(UsbService.connectedDevice);
            }
          });
        },
        child: Padding(
          padding: EdgeInsets.symmetric(
              horizontal: size.getW(12), vertical: size.getH(12)),
          child: Text(
            "Scan USB Printers",
            style: TextStyle(
              fontSize: size.getS(16),
              fontFamily: kFontFMedium,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }

  static Future<dynamic> showDeviceList(BuildContext context) async {
    return await showDialog(
        context: context,
        builder: (_) {
          return SimpleDialog(
            backgroundColor: kBackgroundColor,
            titlePadding: EdgeInsets.zero,
            contentPadding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            children: [USBDeviceDia()],
          );
        });
  }
}

class USBDeviceDia extends StatefulWidget {
  const USBDeviceDia({super.key});

  @override
  State<USBDeviceDia> createState() => _USBDeviceDiaState();
}

class _USBDeviceDiaState extends State<USBDeviceDia> {
  bool isScanning = true;
  String? connectingID;

  void load() {
    if (mounted) setState(() {});
  }

  @override
  void initState() {
    _getDevices();
    super.initState();
  }

  Future<void> _getDevices() async {
    await UsbService.getDevicelist(fun: () {
      load();
    });

    isScanning = false;
    load();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = Ssize(context);
    return Container(
      constraints: BoxConstraints(
        maxHeight: size.height / 2,
        minHeight: size.height / 4,
      ),
      width: size.width / 3,
      padding: EdgeInsets.symmetric(vertical: size.getH(8)),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                LN.devicesFound,
                style: TextStyle(
                  fontSize: size.getS(18),
                  // fontFamily: ,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              SizedBox(width: size.getW(24)),
              isScanning
                  ? LoadingAnimationWidget.waveDots(
                      color: kSecondaryColor,
                      size: size.getS(24),
                    )
                  : TextButton(
                      onPressed: () {
                        isScanning = true;
                        load();
                        _getDevices();
                      },
                      child: Text(
                        'Refresh',
                        style: TextStyle(
                            color: kSecondaryColor, fontSize: size.getS(16)),
                      )),
              Spacer(),
              IconButton(
                visualDensity: VisualDensity.compact,
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: Icon(Icons.close, size: size.getS(24)),
              )
            ],
          ),
          if (UsbService.deviceList == null)
            Center(child: Text("${LN.searchingDevice}.."))
          else if (UsbService.deviceList!.isEmpty)
            Center(
                child: NoItemsSec(
              size: size,
              title: LN.noDeviceFound,
              iconHeight: 100,
            ))
          else ...[
            Flexible(
              child: SingleChildScrollView(
                child: Column(
                  children:
                      List.generate(UsbService.deviceList!.length, (index) {
                    return ListTile(
                      leading: Icon(Icons.print),
                      dense: true,
                      contentPadding:
                          EdgeInsets.symmetric(vertical: size.getH(4)),
                      title: Text(
                        UsbService.deviceList?[index].name ?? 'N/A',
                        style: TextStyle(
                          color: Colors.black,
                          fontFamily: kFontFMedium,
                          fontSize: size.getS(16),
                        ),
                      ),
                      // subtitle: Text(
                      //    UsbService.deviceList?[index].deviceName ?? 'N/A',
                      //   style: TextStyle(
                      //     color: Colors.black54,
                      //     fontSize: size.getS(16),
                      //   ),
                      // ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          UsbService.deviceList![index].productId ==
                                  UsbService.connectedDevice?.productId
                              ? Container(
                                  decoration: BoxDecoration(
                                    color: Colors.green,
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  padding: EdgeInsets.symmetric(
                                      vertical: size.getH(4),
                                      horizontal: size.getW(12)),
                                  child: Text(
                                    LN.connected,
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: size.getS(16)),
                                  ),
                                )
                              : LoadButton(
                                  vPad: 8,
                                  hPad: 4,
                                  loading: connectingID ==
                                      UsbService.deviceList![index].productId,
                                  loadingText: "Connecting",
                                  onsave: () async {
                                    connectingID =
                                        UsbService.deviceList![index].productId;
                                    load();
                                    await UsbService.connect(
                                        device: UsbService.deviceList![index]);
                                    connectingID = null;
                                    load();
                                  },
                                  btnText: LN.connect),
                          if (UsbService.deviceList![index].productId ==
                              UsbService.connectedDevice?.productId)
                            PopupMenuButton(
                                itemBuilder: (context) {
                                  return [
                                    PopupMenuItem(
                                      child: Text(
                                        'Disconnect',
                                        style:
                                            TextStyle(fontSize: size.getS(16)),
                                      ),
                                      onTap: () {
                                        UsbService.close();
                                        load();
                                      },
                                    )
                                  ];
                                },
                                child: Icon(
                                  Icons.more_vert,
                                  size: size.getS(28),
                                ))
                          else
                            SizedBox(
                              width: size.getW(28),
                            )
                        ],
                      ),
                    );
                  }),
                ),
              ),
            ),
            SizedBox(height: size.getH(24)),
            Center(
              child: LoadButton(
                onsave: () {
                  Navigator.pop(context, true);
                },
                btnText: LN.save,
              ),
            )
          ]
          ////// Test
          ,
          // SizedBox(height: size.getH(24)),
          // Center(
          //   child: LoadButton(
          //     onsave: () async {
          //       try {
          //         final bytes = await BlueReceipt.getPrinterConnect(
          //             paperSize: PaperSize.mm72);
          //         final _status = await UsbService.print(bytes: bytes!);
          //         showToast("Print Success : $_status");
          //       } catch (e) {
          //         showToast("Print Error : $e");
          //       }
          //     },
          //     btnText: 'Test',
          //   ),
          // )
        ],
      ),
    );
  }
}
