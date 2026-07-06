import 'package:flutter/material.dart';
import 'package:pos_account/config/size_config.dart';
import 'package:pos_account/constant/constant.dart';
import 'package:pos_account/widgets/load_btn.dart';

class VisionPayPair extends StatelessWidget {
  const VisionPayPair({super.key});

  @override
  Widget build(BuildContext context) {
    final size = Ssize(context);
    return SimpleDialog(
      backgroundColor: kBackgroundColor,
      titlePadding: EdgeInsets.zero,
      contentPadding: EdgeInsets.symmetric(
          horizontal: size.getW(12), vertical: size.getH(12)),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      children: [
        USBConnectSec(),
      ],
    );
  }
}

class USBConnectSec extends StatefulWidget {
  const USBConnectSec({super.key});

  @override
  State<USBConnectSec> createState() => _USBConnectSecState();
}

class _USBConnectSecState extends State<USBConnectSec> {
  bool loading = false;
  int? connectingIndex;

  void load() {
    if (mounted) setState(() {});
  }

  @override
  void initState() {
    super.initState();
    _scan();
  }

  Future<void> _scan() async {
    loading = true;
    load();
    // await USBServiceEFt.scanDevice();
    loading = false;
    load();
  }

  @override
  Widget build(BuildContext context) {
    final size = Ssize(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text.rich(
              TextSpan(text: "Vision Pay Connection", children: [
                TextSpan(
                    text: "\nSelect the USB terminal for this POS",
                    style: TextStyle(
                      fontSize: size.getS(16),
                      color: Colors.black54,
                    )),
              ]),
              style: TextStyle(
                fontSize: size.getS(22),
                fontWeight: FontWeight.bold,
                color: Colors.black,
                height: 1.4,
              ),
            ),
            SizedBox(width: size.getW(24)),
            LoadButton(
              btnText: "Scan",
              vPad: 0,
              hPad: 4,
              loading: loading,
              loadingText: "Scanning",
              onsave: _scan,
            ),
            Spacer(),
            Container(
                decoration: BoxDecoration(
                  color: Colors.red.shade800,
                  shape: BoxShape.circle,
                ),
                child: InkWell(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: size.getS(8), vertical: size.getS(8)),
                    child: Icon(
                      Icons.close,
                      color: Colors.white,
                    ),
                  ),
                )),
          ],
        ),
        Divider(),
        Text(
          "USB Devices",
          style: TextStyle(
            fontSize: size.getS(16),
            color: Colors.black,
            height: 1.4,
          ),
        ),
        // SizedBox(
        //   height: size.getH(740),
        //   width: size.width / 2,
        //   child: USBServiceEFt.usbDevices.isEmpty
        //       ? NoItemsSec(size: size, title: "No USB Devices")
        //       : ListView.builder(
        //           itemCount: USBServiceEFt.usbDevices.length,
        //           itemBuilder: (_, index) {
        //             final device = USBServiceEFt.usbDevices[index];
        //             final connected = USBServiceEFt.connectedUsb == device;
        //             return ListTile(
        //               selectedColor: Colors.green.shade700,
        //               selected: connected,
        //               leading: Text("${index + 1}."),
        //               title: Text(
        //                 "${device.productName}",
        //                 style: TextStyle(
        //                   fontWeight: FontWeight.bold,
        //                 ),
        //               ),
        //               subtitle: Text("${device.manufacturerName}"),
        //               trailing: ElevatedButton(
        //                 onPressed: connectingIndex == index
        //                     ? null
        //                     : () async {
        //                         connectingIndex = index;
        //                         load();

        //                         if (connected) {
        //                           await USBServiceEFt.disconnectDevice();
        //                         } else {
        //                           await USBServiceEFt.connectDevice(index);
        //                         }

        //                         connectingIndex = null;
        //                         load();
        //                       },
        //                 style: ButtonStyle(
        //                   backgroundColor: connected && connectingIndex != index
        //                       ? WidgetStateProperty.all(Colors.red.shade700)
        //                       : null,
        //                 ),
        //                 child: connected
        //                     ? Text(connectingIndex == index
        //                         ? "Disconnecting"
        //                         : "Disconnect")
        //                     : Text(connectingIndex == index
        //                         ? "Connecting"
        //                         : "Connect"),
        //               ),
        //             );
        //           }),
        // )
      ],
    );
  }
}
