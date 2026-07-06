import 'package:flutter/material.dart';
import 'package:pos_account/config/size_config.dart';
import 'package:pos_account/constant/constant.dart';
import 'package:pos_account/ln.dart';
import 'package:pos_account/providers/integration/terminal_pro.dart';
import 'package:pos_account/widgets/input/dropdown/title_drop_down.dart';
import 'package:pos_account/widgets/input/text_form/title_text_form.dart';
import 'package:pos_account/widgets/load_btn.dart';
import 'package:pos_account/widgets/loading.dart';
import 'package:provider/provider.dart';

class TerminalAddUpDia extends StatefulWidget {
  final String? id;
  final InteEnum inteEnum;
  const TerminalAddUpDia({
    super.key,
    this.id,
    required this.inteEnum,
  });

  @override
  State<TerminalAddUpDia> createState() => _TerminalAddUpDiaState();
}

class _TerminalAddUpDiaState extends State<TerminalAddUpDia> {
  final _formKey = GlobalKey<FormState>();
  @override
  void initState() {
    _get();
    super.initState();
  }

  TerminalPro? _initTerPro;

  void _get() {
    _initTerPro = Provider.of<TerminalPro>(context, listen: false);
    // _initPairingCodeMx = terPro?.serialCltr.text ?? '';

    _initTerPro?.getData(platId: widget.id);
    if (widget.inteEnum == InteEnum.VisionPay) {
      // USBServiceEFt.scanDevice().then((value) {
      //   if (mounted) terPro!.notify;
      // });
    }
  }

  // String _initPairingCodeMx = "";

  @override
  void dispose() {
    if (_initTerPro != null) _initTerPro!.clearWind(id: widget.id);
    // _initPairingCodeMx = "";
    super.dispose();
  }

  // mx
  // MxPairResponse? mxPairResponse;
  // bool mxPairing = false;

  @override
  Widget build(BuildContext context) {
    final size = Ssize(context);
    final _terPro = Provider.of<TerminalPro>(context);
    final _title = widget.inteEnum == InteEnum.WindCave
        ? "Windcave Terminal Setup"
        : widget.inteEnum == InteEnum.Mx
            ? "Simple Cloud Integration Setup"
            : widget.inteEnum == InteEnum.VisionPay
                ? "Vision Pay Terminal Setup"
                : "";
    final _subTitle = widget.inteEnum == InteEnum.WindCave
        ? "Enter Windcave details for this POS"
        : widget.inteEnum == InteEnum.Mx
            ? "Enter Terminal details for this POS"
            : widget.inteEnum == InteEnum.VisionPay
                ? "Enter Vision Pay details for this POS"
                : "";

    return SimpleDialog(
        backgroundColor: kBackgroundColor,
        titlePadding: EdgeInsets.zero,
        contentPadding: EdgeInsets.symmetric(
            horizontal: size.getW(12), vertical: size.getH(12)),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        children: [
          Processing(
            loading: _terPro.pageLoad,
            child: Container(
              constraints: BoxConstraints(
                maxHeight: size.height / 1.14,
                minHeight: size.height / 5,
              ),
              width: size.width / 2.5,
              child: Form(
                  key: _formKey,
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: size.getW(24),
                              vertical: size.getH(24)),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text.rich(
                                TextSpan(
                                  text: _title,
                                  children: [
                                    TextSpan(
                                        text: "\n$_subTitle",
                                        style: TextStyle(
                                          fontSize: size.getS(16),
                                          color: Colors.black54,
                                        )),
                                  ],
                                ),
                                style: TextStyle(
                                  fontSize: size.getS(22),
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                  height: 1.4,
                                ),
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
                                          horizontal: size.getS(8),
                                          vertical: size.getS(8)),
                                      child: Icon(
                                        Icons.close,
                                        color: Colors.white,
                                      ),
                                    ),
                                  )),
                            ],
                          ),
                        ),
                        // if (widget.inteEnum == InteEnum.Mx &&
                        //     mxPairResponse != null)
                        //   _buildPairingConfirmation(size, confirm: () async {
                        //     await _terPro.saveWind(diaCtx: context).then((value) {
                        //       // Navigator.pop(context);
                        //     });
                        //   })
                        // else
                        SingleChildScrollView(
                          physics: BouncingScrollPhysics(),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              TitleTextForm(
                                title: "Terminal Name",
                                hintText: "Enter terminal name",
                                isReq: widget.inteEnum != InteEnum.Mx,
                                textCltr: _terPro.terminalCltr,
                                borderColor: Colors.black26,
                                vPad: 16,
                                validator: (val) {
                                  if (val == null || val.isEmpty)
                                    return LN.fieldEmpty;
                                  if (val.length > 16)
                                    return "Name should be less than 16 character";
                                  else if (val.contains(' '))
                                    return "Invalid name, remove space";
                                  else
                                    return null;
                                },
                              ),

                              if (widget.inteEnum == InteEnum.WindCave) ...[
                                SizedBox(
                                  height: size.getH(24),
                                ),
                                Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    TitleTextForm(
                                      title: "Username",
                                      hintText: "Enter username",
                                      textCltr: _terPro.usernameCltr,
                                      borderColor: Colors.black26,
                                      vPad: 16,
                                    ),
                                    SizedBox(
                                      height: size.getH(24),
                                    ),
                                    TitleTextForm(
                                      title: "Key",
                                      hintText: "Enter key",
                                      textCltr: _terPro.keyCltr,
                                      borderColor: Colors.black26,
                                      vPad: 16,
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: size.getH(24),
                                ),
                                TitleTextForm(
                                  title: "Station",
                                  hintText: "Enter station number",
                                  textCltr: _terPro.serialCltr,
                                  borderColor: Colors.black26,
                                  // textInputType: TextInputType.number,
                                  vPad: 16,
                                ),
                                SizedBox(
                                  height: size.getH(24),
                                ),
                                TitleDropDown(
                                  pWidth: 0.33,
                                  isReq: true,
                                  vPad: 14,
                                  title: "POS Device",
                                  hintText: "Choose POS Device",
                                  borderColor: Colors.black26,
                                  indexVal: _terPro.posNameIndex,
                                  list: _terPro.posDevices == null
                                      ? []
                                      : _terPro.posDevices!
                                          .map((e) => e.name ?? '')
                                          .toList(),
                                  onChanged: (p0) {
                                    if (p0 == null) return;
                                    _terPro.posNameIndex = p0;
                                    _terPro.notify;
                                  },
                                ),
                              ] else if (widget.inteEnum == InteEnum.Mx) ...[
                                // Column(
                                //   crossAxisAlignment: CrossAxisAlignment.start,
                                //   children: [
                                //     TitleTextForm(
                                //       title: "Pairing code",
                                //       hintText: "Pairing code",
                                //       textCltr: _terPro.serialCltr,
                                //       borderColor: Colors.black26,
                                //       textInputType: TextInputType.number,
                                //       vPad: 16,
                                //       onChanged: (val) {
                                //         Utils.handleSearch(callback: () async {
                                //           _terPro.notify;
                                //         });
                                //       },
                                //     ),
                                //     SizedBox(height: size.getH(4)),
                                //     Text(
                                //       "You can get the pairing code from the terminals pairing setup",
                                //       style: TextStyle(
                                //         fontSize: size.getS(14),
                                //         color: Colors.black54,
                                //       ),
                                //     )
                                //   ],
                                // ),
                              ]
                              // TitleTextForm(
                              //   title: "Serial Number",
                              //   hintText: "Enter serial number",
                              //   textCltr: _terPro.serialCltr,
                              //   borderColor: Colors.black26,
                              //   // textInputType: TextInputType.number,
                              //   vPad: 16,
                              // )
                              else if (widget.inteEnum ==
                                  InteEnum.VisionPay) ...[
                                // TitleDropDown(
                                //   pWidth: 0.33,
                                //   isReq: true,
                                //   vPad: 14,
                                //   title: "Terminal Device",
                                //   hintText: "Choose Deivce",
                                //   borderColor: Colors.black26,
                                //   indexVal: _terPro.visionPayDeIndex,
                                //   list: USBServiceEFt.usbDevices
                                //       .map((e) => e.productName ?? '')
                                //       .toList(),
                                //   onChanged: (p0) {
                                //     if (p0 == null) return;
                                //     _terPro.visionPayDeIndex = p0;
                                //     _terPro.notify;
                                //   },
                                // ),
                                // TitleTextForm(
                                //   title: "Vender Id",
                                //   hintText: "Enter vender id",
                                //   textCltr: _terPro.usernameCltr,
                                //   borderColor: Colors.black26,
                                //   vPad: 16,
                                // ),
                                // SizedBox(
                                //   height: size.getH(24),
                                // ),
                                // TitleTextForm(
                                //   title: "Product Id",
                                //   hintText: "Enter Product id",
                                //   textCltr: _terPro.serialCltr,
                                //   borderColor: Colors.black26,
                                //   vPad: 16,
                                // ),
                              ],

                              // SizedBox(
                              //   height: size.getH(24),
                              // ),
                              // TitleDropDown(
                              //   pWidth: 0.33,
                              //   isReq: true,
                              //   vPad: 14,
                              //   title: "POS Device",
                              //   hintText: "Choose POS Device",
                              //   borderColor: Colors.black26,
                              //   indexVal: _terPro.posNameIndex,
                              //   list: _terPro.posDevices == null
                              //       ? []
                              //       : _terPro.posDevices!
                              //           .map((e) => e.name ?? '')
                              //           .toList(),
                              //   onChanged: (p0) {
                              //     if (p0 == null) return;
                              //     _terPro.posNameIndex = p0;
                              //     _terPro.notify;
                              //   },
                              // ),
                              // TitleTextForm(
                              //   title: "Pos Name",
                              //   hintText: "Enter pos name",
                              //   textCltr: _terPro.posNameCltr,
                              //   borderColor: Colors.black26,
                              //   vPad: 16,
                              // ),
                              // SizedBox(
                              //   height: size.getH(24),
                              // ),
                              // Padding(
                              //   padding: EdgeInsets.symmetric(
                              //       horizontal: size.getW(48)),
                              //   child: Row(
                              //     crossAxisAlignment: CrossAxisAlignment.center,
                              //     children: [
                              //       Text(
                              //         "Is Default",
                              //         style: TextStyle(
                              //           fontSize: size.getS(18),
                              //           color: Colors.black,
                              //         ),
                              //       ),
                              //       SizedBox(
                              //         width: size.getW(8),
                              //       ),
                              //       SwitchAdap(
                              //         size: size,
                              //         value: _terPro.isDefault,
                              //         onChanged: (val) {
                              //           _terPro.isDefault = val;
                              //           _terPro.notify;
                              //         },
                              //       ),
                              //     ],
                              //   ),
                              // ),
                              SizedBox(
                                height: size.getH(48),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  LoadButton(
                                    btnText: "Cancel",
                                    btnColor: Colors.red.shade700,
                                    onsave: () {
                                      Navigator.pop(context);
                                    },
                                  ),
                                  SizedBox(
                                    width: size.getW(24),
                                  ),
                                  LoadButton(
                                    btnText:
                                        //  widget.inteEnum == InteEnum.Mx &&
                                        //         _initPairingCodeMx !=
                                        //             terPro?.serialCltr.text
                                        //     ? LN.pair
                                        //     :
                                        _terPro.updateId.isNotEmpty
                                            ? "Update"
                                            : "Add",
                                    btnColor: Colors.green.shade700,
                                    loading: _terPro.buttonLoad,
                                    onsave: () async {
                                      if (_formKey.currentState!.validate()) {
                                        // if (widget.inteEnum == InteEnum.Mx &&
                                        //     _initPairingCodeMx !=
                                        //         terPro?.serialCltr.text) {
                                        //   mxPairResponse =
                                        //       await _terPro.pairMx();
                                        // } else {
                                        await _terPro
                                            .saveWind(
                                                diaCtx: context,
                                                inteEnum: widget.inteEnum)
                                            .then((value) {
                                          // Navigator.pop(context);
                                        });
                                        // }
                                      }
                                    },
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: size.getH(24),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  )),
            ),
          ),
        ]);
  }

  // Widget _buildPairingConfirmation(
  //   Ssize size, {
  //   required Function() confirm,
  // }) {
  //   return Card(
  //     elevation: 1,
  //     shape: RoundedRectangleBorder(
  //       borderRadius: BorderRadius.circular(8),
  //       side: BorderSide(color: Color(0xFFE5E7EB)),
  //     ),
  //     child: Padding(
  //       padding: EdgeInsets.all(size.getS(12)),
  //       child: Row(
  //         crossAxisAlignment: CrossAxisAlignment.start,
  //         children: [
  //           Container(
  //             width: size.getS(48),
  //             height: size.getS(48),
  //             decoration: BoxDecoration(
  //               color: Color(0xFFFEF3C7),
  //               borderRadius: BorderRadius.circular(24),
  //             ),
  //             child: Center(
  //               child: Row(
  //                 mainAxisAlignment: MainAxisAlignment.center,
  //                 children: [
  //                   Container(
  //                       width: size.getW(6),
  //                       height: size.getW(6),
  //                       decoration: BoxDecoration(
  //                           color: Color(0xFFF59E0B),
  //                           borderRadius: BorderRadius.circular(3))),
  //                   SizedBox(width: 2),
  //                   Container(
  //                       width: size.getW(6),
  //                       height: size.getW(6),
  //                       decoration: BoxDecoration(
  //                           color: Color(0xFFF59E0B),
  //                           borderRadius: BorderRadius.circular(3))),
  //                   SizedBox(width: 2),
  //                   Container(
  //                       width: size.getW(6),
  //                       height: size.getW(6),
  //                       decoration: BoxDecoration(
  //                           color: Color(0xFFF59E0B),
  //                           borderRadius: BorderRadius.circular(3))),
  //                 ],
  //               ),
  //             ),
  //           ),
  //           SizedBox(width: size.getS(16)),
  //           Flexible(
  //             child: Column(
  //               crossAxisAlignment: CrossAxisAlignment.start,
  //               mainAxisSize: MainAxisSize.min,
  //               children: [
  //                 Text(
  //                   'Pairing',
  //                   style: TextStyle(
  //                     fontSize: size.getS(20),
  //                     fontWeight: FontWeight.w600,
  //                     color: Color(0xFF1F2937),
  //                   ),
  //                 ),
  //                 SizedBox(height: size.getH(8)),
  //                 Text(
  //                   'Confirm that the following Code is showing on the Terminal',
  //                   style: TextStyle(
  //                     fontSize: size.getS(16),
  //                     color: Color(0xFF6B7280),
  //                   ),
  //                 ),
  //                 SizedBox(height: size.getH(24)),
  //                 Text(
  //                   'Code:',
  //                   style: TextStyle(
  //                     fontSize: size.getS(14),
  //                     fontWeight: FontWeight.w500,
  //                     color: Color(0xFF374151),
  //                   ),
  //                 ),
  //                 SizedBox(height: size.getH(8)),
  //                 Text(
  //                   mxPairResponse?.data?.confirmationCode ?? '',
  //                   style: TextStyle(
  //                     fontSize: size.getS(64),
  //                     fontWeight: FontWeight.bold,
  //                     color: Color(0xFF1F2937),
  //                   ),
  //                 ),
  //                 SizedBox(height: size.getH(32)),
  //                 Row(
  //                   mainAxisAlignment: MainAxisAlignment.end,
  //                   children: [
  //                     OutlinedButton(
  //                       onPressed: () {
  //                         Navigator.pop(context);
  //                       },
  //                       style: OutlinedButton.styleFrom(
  //                         padding: EdgeInsets.symmetric(
  //                             horizontal: size.getW(24),
  //                             vertical: size.getH(8)),
  //                         shape: RoundedRectangleBorder(
  //                           borderRadius: BorderRadius.circular(8),
  //                         ),
  //                         side: BorderSide(color: Color(0xFFE5E7EB)),
  //                       ),
  //                       child: Text(
  //                         'Cancel Pairing',
  //                         style: TextStyle(
  //                             color: Color(0xFF374151),
  //                             fontSize: size.getS(16)),
  //                       ),
  //                     ),
  //                     SizedBox(width: size.getW(16)),
  //                     ElevatedButton(
  //                       onPressed: confirm,
  //                       style: ElevatedButton.styleFrom(
  //                         padding: EdgeInsets.symmetric(
  //                             horizontal: size.getW(24),
  //                             vertical: size.getH(8)),
  //                         shape: RoundedRectangleBorder(
  //                           borderRadius: BorderRadius.circular(8),
  //                         ),
  //                       ),
  //                       child: Text(
  //                         'Confirm',
  //                         style: TextStyle(
  //                             color: Colors.white, fontSize: size.getS(16)),
  //                       ),
  //                     ),
  //                   ],
  //                 ),
  //               ],
  //             ),
  //           ),
  //         ],
  //       ),
  //     ),
  //   );
  // }
}
