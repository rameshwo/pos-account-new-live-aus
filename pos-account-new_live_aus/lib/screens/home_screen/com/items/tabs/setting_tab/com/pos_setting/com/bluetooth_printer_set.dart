import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:pos_account/config/size_config.dart';
import 'package:pos_account/constant/constant.dart';
import 'package:pos_account/ln.dart';
import 'package:pos_account/services/printer/bluetooth/bluetooth_service.dart';
import 'package:pos_account/widgets/load_btn.dart';
import 'package:pos_account/widgets/no_items_sec.dart';
import 'package:thermal_printer_plus/thermal_printer.dart';

class BluetoothPrinterSetup extends StatelessWidget {
  final Function(PrinterDevice?)? onScanDone;
  const BluetoothPrinterSetup({super.key, this.onScanDone});

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
                if (onScanDone != null)
                  onScanDone!(BluetoothService.connectedDevice);
              }
            });
          },
          child: Padding(
            padding: EdgeInsets.symmetric(
                horizontal: size.getW(12), vertical: size.getH(12)),
            child: Text(
              LN.scanBluetoothDevices,
              style: TextStyle(
                fontSize: size.getS(16),
                fontFamily: kFontFMedium,
                color: Colors.white,
              ),
            ),
          ),
        ));
  }

  Future<dynamic> showDeviceList(BuildContext context) async {
    return await showDialog(
        context: context,
        builder: (_) {
          return SimpleDialog(
            backgroundColor: kBackgroundColor,
            titlePadding: EdgeInsets.zero,
            contentPadding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            children: [BlueDeviceDia()],
          );
        });
  }
}

class BlueDeviceDia extends StatefulWidget {
  const BlueDeviceDia({super.key});

  @override
  State<BlueDeviceDia> createState() => _BlueDeviceDiaState();
}

class _BlueDeviceDiaState extends State<BlueDeviceDia> {
  bool isScanning = true;
  List<PrinterDevice>? get _devices => BluetoothService.deviceList;
  String? connectingID;

  void load() {
    if (mounted) setState(() {});
  }

  @override
  void initState() {
    super.initState();
    _getDevices();
  }

  Future<void> _getDevices() async {
    await BluetoothService.getBluetoothDevices(fun: () {
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
                        'Scan',
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
          if (_devices == null)
            Center(child: Text("${LN.searchingDevice}.."))
          else if (_devices!.isEmpty)
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
                  children: List.generate(_devices!.length, (index) {
                    return ListTile(
                      leading: Icon(Icons.print),
                      dense: true,
                      contentPadding:
                          EdgeInsets.symmetric(vertical: size.getH(4)),
                      title: Text(
                        _devices?[index].name ?? 'N/A',
                        style: TextStyle(
                          color: Colors.black,
                          fontFamily: kFontFMedium,
                          fontSize: size.getS(16),
                        ),
                      ),
                      subtitle: Text(
                        _devices?[index].address ?? 'N/A',
                        style: TextStyle(
                          color: Colors.black54,
                          fontSize: size.getS(16),
                        ),
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          _devices![index].address ==
                                  BluetoothService.connectedDevice?.address
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
                                  loading:
                                      connectingID == _devices![index].address,
                                  loadingText: "Connecting",
                                  onsave: () async {
                                    connectingID = _devices![index].address;
                                    load();
                                    await BluetoothService.setConnect(
                                        _devices![index]);
                                    connectingID = null;
                                    load();
                                  },
                                  btnText: LN.connect),
                          if (_devices![index].address ==
                              BluetoothService.connectedDevice?.address)
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
                                        BluetoothService.disconnect()
                                            .then((value) => load());
                                      },
                                    )
                                  ];
                                },
                                child: Icon(Icons.more_vert))
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
                  btnText: LN.save),
            )
          ]
        ],
      ),
    );
  }
}
