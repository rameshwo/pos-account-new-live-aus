import 'package:flutter/material.dart';
import 'package:pos_account/config/size_config.dart';
import 'package:pos_account/constant/constant.dart';
import 'package:pos_account/env.dart';
import 'package:pos_account/providers/integration/terminal_pro.dart';
import 'package:pos_account/screens/home_screen/com/items/tabs/integration_tab/com/eftpos/windcave/console_log_windcave.dart';
import 'package:pos_account/screens/home_screen/com/items/tabs/short_term_cash_flow_set/com/setting_card_img.dart';
import '../../../integration_tab/com/eftpos/terminal_add_up.dart';
// import 'com/console_log.dart';

class EftposPairingSec extends StatefulWidget {
  final Function()? onBack;
  const EftposPairingSec({super.key, this.onBack});

  @override
  State<EftposPairingSec> createState() => _EftposPairingSecState();
}

class _EftposPairingSecState extends State<EftposPairingSec> {
  // late EftPro _eftPro;

  @override
  void initState() {
    super.initState();
    // _eftPro = Provider.of<EftPro>(context, listen: false);
    // _getData();
  }

  // void _getData() {
  //   _eftPro.getData();
  // }

  @override
  void dispose() {
    _eftCall();
    super.dispose();
  }

  void _eftCall() {
    // _eftPro.loadUrl(AppEnviro.eftposPay);
  }

  @override
  Widget build(BuildContext context) {
    final size = Ssize(context);
    return SingleChildScrollView(
      physics: BouncingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              if (widget.onBack != null)
                IconButton(
                    visualDensity: VisualDensity.compact,
                    onPressed: widget.onBack,
                    icon: Icon(Icons.arrow_back)),
              Text(
                "Merchant Integration",
                style: TextStyle(
                  fontSize: size.getS(18),
                  // fontFamily: ,ph
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              // TODO: WINDCAVE TEST
              // Text(
              //   "  (Select Default Terminal)",
              //   style: TextStyle(
              //     fontSize: size.getS(16),
              //     // fontFamily: ,ph
              //     color: Colors.black54,
              //   ),
              // ),
              // Spacer(),
              // if (eftPro.defaultEFT != eftPro.prevEFT)
              //   LoadButton(
              //     vPad: 0,
              //     onsave: () async {
              //       await eftPro.setEft();
              //       GlobalCVP.checkStore();
              //     },
              //     btnText: "Update",
              //   ),
              // SizedBox(
              //   width: size.getW(92),
              // ),
            ],
          ),
          SizedBox(height: size.getH(8)),
          Wrap(
            children: [
              // TODO: WINDCAVE TEST
              // SettingImageCard(
              //   size: size,
              //   title: "MX-51",
              //   subTitle: "Pair with Mx-51 Terminal",
              //   image: "assets/png/mx.png",
              //   isSelected: _eftPro.defaultEFT == Strings.mx51Merchant,
              //   onTap: () {
              //     eftPro.defaultEFT = Strings.mx51Merchant;
              //     eftPro.notify;
              //   },
              //   button: [
              //     BtnClass(
              //       title: LN.pair,
              //       onTap: () {
              //         showDialog(
              //             barrierDismissible: false,
              //             context: context,
              //             builder: (_) => Mx51Pairing());
              //       },
              //       color: kSecondaryColor,
              //     )
              //   ],
              //   // moreOption: AppEnviro.enviroment == Enviroment.PROD
              //   //     ? null
              //   //     : PopupMenuButton(
              //   //         padding: EdgeInsets.zero,
              //   //         itemBuilder: (_) {
              //   //           return [
              //   //             PopupMenuItem(
              //   //               child: Row(
              //   //                 mainAxisSize: MainAxisSize.min,
              //   //                 children: [
              //   //                   Icon(
              //   //                     Icons.print_outlined,
              //   //                     color: kPrimaryColor,
              //   //                     size: size.getS(28),
              //   //                   ),
              //   //                   SizedBox(
              //   //                     width: size.getW(12),
              //   //                   ),
              //   //                   Text(
              //   //                     "View Console Logs",
              //   //                     style: TextStyle(
              //   //                       color: Colors.black,
              //   //                       fontSize: size.getS(18),
              //   //                     ),
              //   //                   )
              //   //                 ],
              //   //               ),
              //   //               onTap: () async {
              //   //                 await Future.delayed(Duration(seconds: 2));
              //   //                 showDialog(
              //   //                   context: context,
              //   //                   builder: (_) => ConsoleLogsEft(),
              //   //                 );
              //   //               },
              //   //             ),
              //   //           ];
              //   //         },
              //   //         child: Icon(Icons.more_vert),
              //   //       ),
              // ),
              // SettingImageCard(
              //   size: size,
              //   title: "Vision Pay",
              //   image: "assets/png/vision_pay.png",
              //   subTitle: "Connect with Vision Pay Terminal",
              //   isSelected: _eftPro.defaultEFT == Strings.visionMerchant,
              //   onTap: () {
              //     eftPro.defaultEFT = Strings.visionMerchant;
              //     eftPro.notify;
              //   },
              //   button: [
              //     BtnClass(
              //       title: LN.connect,
              //       onTap: () {
              //         showDialog(
              //             barrierDismissible: false,
              //             context: context,
              //             builder: (_) => VisionPayPair());
              //       },
              //       color: kSecondaryColor,
              //     )
              //   ],
              // ),
              SettingImageCard(
                size: size,
                title: "Windcave",
                image: "assets/png/windcave.png",
                subTitle: "Connect with Windcave Pay Terminal",
                // isSelected: _eftPro.defaultEFT == Strings.windcaveMerchant,
                // onTap: () {
                //   eftPro.defaultEFT = Strings.windcaveMerchant;
                //   eftPro.notify;
                // },
                button: [
                  BtnClass(
                    title: "Set up",
                    onTap: () {
                      showDialog(
                          barrierDismissible: false,
                          context: context,
                          builder: (_) =>
                              TerminalAddUpDia(inteEnum: InteEnum.WindCave));
                    },
                    color: kSecondaryColor,
                  )
                ],
                moreOption: AppEnviro.enviroment == Enviroment.PROD
                    ? null
                    : PopupMenuButton(
                        padding: EdgeInsets.zero,
                        itemBuilder: (_) {
                          return [
                            PopupMenuItem(
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.print_outlined,
                                    color: kPrimaryColor,
                                    size: size.getS(28),
                                  ),
                                  SizedBox(
                                    width: size.getW(12),
                                  ),
                                  Text(
                                    "View Console Logs",
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: size.getS(18),
                                    ),
                                  )
                                ],
                              ),
                              onTap: () async {
                                await Future.delayed(Duration(seconds: 1));
                                showDialog(
                                  context: context,
                                  builder: (_) => ConsoleLogsWindCave(),
                                );
                              },
                            ),
                          ];
                        },
                        child: Icon(Icons.more_vert),
                      ),
              ),
            ],
          )
          // Expanded(
          //   child: SingleChildScrollView(
          //     padding: EdgeInsets.zero,
          //     child: Column(
          //       mainAxisAlignment: MainAxisAlignment.start,
          //       children: [
          //         SizedBox(
          //           height: size.getH(700),
          //           child: InAppWebViewScreen(
          //               webContent: WebContent(
          //             title: "EFTPOS Payment",
          //             url: "${AppEnviro.eftposPay}pair-terminal-mx51",
          //           )),
          //         )
          //       ],
          //     ),
          //   ),
          // )
        ],
      ),
    );
  }
}
