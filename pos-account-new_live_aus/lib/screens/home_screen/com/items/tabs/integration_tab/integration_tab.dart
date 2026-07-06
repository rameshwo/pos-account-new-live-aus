import 'package:flutter/material.dart';
import 'package:pos_account/config/size_config.dart';
import 'package:pos_account/constant/constant.dart';
import 'package:pos_account/ln.dart';
import 'package:pos_account/model/home/integration/acc_integ_add_sec.dart';
import 'package:pos_account/providers/cus_val_pro.dart';
import 'package:pos_account/providers/integration/integration_pro.dart';
import 'package:pos_account/providers/integration/terminal_pro.dart';
import 'package:pos_account/screens/home_screen/com/items/tabs/integration_tab/com/uber_delivery/ud_set.dart';
import 'package:pos_account/screens/home_screen/com/items/tabs/setting_tab/com/general/common/common_header.dart';
import 'package:pos_account/screens/home_screen/com/items/tabs/short_term_cash_flow_set/com/setting_card_img.dart';
import 'package:pos_account/widgets/loading.dart';
import 'package:pos_account/widgets/title_pop.dart';
import 'package:provider/provider.dart';
import 'com/eftpos/windcave/console_log_windcave.dart';
import 'com/eftpos/windcave/print_last_trans.dart';
import 'com/eftpos/windcave/terminal_list.dart';
import 'com/eftpos/terminal_add_up.dart';
import 'com/xero/integration_setting.dart';
import 'inte_card.dart';

class IntegrationTab extends StatefulWidget {
  const IntegrationTab({super.key});

  @override
  State<IntegrationTab> createState() => _IntegrationTabState();
}

class _IntegrationTabState extends State<IntegrationTab> {
  final _pageCltr = PageController();
  final _tabCltr = PageController();
  late IntegrationPro intePro;

  @override
  void initState() {
    super.initState();
    intePro = Provider.of<IntegrationPro>(context, listen: false);
    WidgetsBinding.instance.addPostFrameCallback((_) => _getData());
  }

  Future<void> _getData() async {
    final _data = await intePro.getAddSec();
    final terminalPro = Provider.of<TerminalPro>(context, listen: false);
    terminalPro.setPosDevices(_data?.posDevices);
  }

  void onBack() {
    intePro.selectedTab = 0;
    _pageCltr.animateToPage(0,
        duration: Duration(milliseconds: 300), curve: Curves.easeInOut);
  }

  @override
  void dispose() {
    intePro.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = Ssize(context);
    final _intePro = Provider.of<IntegrationPro>(context);
    return Processing(
      loading: _intePro.loading,
      child: PageView(
        physics: NeverScrollableScrollPhysics(),
        controller: _pageCltr,
        children: [
          IntegrationSection(
            size: size,
            firstList: _intePro.firstInteList,
            secondList: _intePro.secondInteList,
            integrationPro: _intePro,
            // addSec: _intePro.addSec,
            onTap: (AccountingPlatForm i) {
              // _intePro.pageIndex = i;
              _intePro.selectedAccount = i;
              _intePro.notify;
              final _enum = intePro.selectedAccount?.integrationPlatformEnum;
              if (_enum == InteEnum.Xero.name ||
                  _enum == InteEnum.UberDelivery.name) {
                _pageCltr.animateToPage(1,
                    duration: Duration(milliseconds: 300),
                    curve: Curves.easeInOut);
              } else {}
            },
          ),
          if (_intePro.selectedAccount?.integrationPlatformEnum ==
              InteEnum.Xero.name)
            IntegrateSetting(
              onBack: onBack,
              size: size,
              intePro: _intePro,
              tabCltr: _tabCltr,
            )
          else if (_intePro.selectedAccount?.integrationPlatformEnum ==
              InteEnum.UberDelivery.name)
            UberDeliSet(
              onBack: onBack,
              intePro: _intePro,
            )
        ],
      ),
    );
  }
}

class IntegrationSection extends StatelessWidget {
  const IntegrationSection({
    super.key,
    required this.size,
    this.firstList,
    this.secondList,
    this.onTap,
    required this.integrationPro,
  });

  final Ssize size;
  final List<AccountingPlatForm>? firstList;
  final List<AccountingPlatForm>? secondList;
  final Function(AccountingPlatForm)? onTap;
  final IntegrationPro integrationPro;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CommonHeader(
          child: TitlePop(
              title: LN.integration,
              size: size,
              onTap: () {
                GlobalCVP.setMainPage = MainPage.ManagePage;
              }),
        ),
        SizedBox(
          height: size.getH(8),
        ),
        Flexible(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(
                vertical: size.getH(12.0), horizontal: size.getW(24)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (firstList?.isNotEmpty ?? false) ...[
                  Text(
                    "Account/Delivery ${LN.integration}",
                    style: TextStyle(
                      fontSize: size.getS(18),
                      // fontFamily: ,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(
                    height: size.getH(12),
                  ),
                  GridView.count(
                    mainAxisSpacing: size.getW(24),
                    crossAxisSpacing: size.getH(12),
                    crossAxisCount: 2,
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    childAspectRatio: 4.6,
                    children: [
                      ...List.generate(
                        firstList!.length,
                        (index) {
                          return IntegrationCard(
                            size: size,
                            title: firstList![index],
                            onTap: () {
                              if (onTap != null) onTap!(firstList![index]);
                            },
                          );
                        },
                      ),
                    ],
                  )
                ],

                if (secondList?.isNotEmpty ?? false) ...[
                  SizedBox(height: size.getH(24)),
                  Text(
                    "Merchant ${LN.integration}",
                    style: TextStyle(
                      fontSize: size.getS(18),
                      // fontFamily: ,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(
                    height: size.getH(12),
                  ),
                  GridView.count(
                    mainAxisSpacing: size.getW(24),
                    crossAxisSpacing: size.getH(12),
                    crossAxisCount: 2,
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    childAspectRatio: 4.6,
                    children: [
                      ...List.generate(
                        secondList!.length,
                        (index) {
                          final _enum =
                              secondList![index].integrationPlatformEnum;
                          // TODO: windcave
                          // if (_enum != InteEnum.WindCave.name)
                          //   return SizedBox.shrink();
                          // else
                          final _showButtons = _enum != InteEnum.Mx.name ||
                              (_enum ==
                                  InteEnum.Mx
                                      .name // && integrationPro.isMxMerchantSetup
                              );
                          return SettingImageCard(
                            size: size,
                            width: 800,
                            title: _enum == InteEnum.Mx.name
                                ? "Simple Cloud Integration"
                                : secondList![index].name,
                            subTitle: _enum == InteEnum.Mx.name
                                ? "Connect POSApt with Simple Cloud Integration"
                                : secondList![index].description,
                            image: _enum == InteEnum.Mx.name
                                ? "assets/svg/icons/mx.svg"
                                : secondList![index].image,
                            // onTap: () {
                            //   if (onTap != null) onTap!(secondList![index]);
                            // },
                            button: [
                              if (_showButtons)
                                BtnClass(
                                  title: "Add New",
                                  onTap: () {
                                    InteEnum? _inteEnum;

                                    if (_enum == InteEnum.WindCave.name) {
                                      _inteEnum = InteEnum.WindCave;
                                    } else if (_enum == InteEnum.Mx.name) {
                                      _inteEnum = InteEnum.Mx;
                                    } else if (_enum ==
                                        InteEnum.VisionPay.name) {
                                      _inteEnum = InteEnum.VisionPay;
                                    }

                                    if (_inteEnum != null) {
                                      showDialog(
                                          barrierDismissible: false,
                                          context: context,
                                          builder: (_) => TerminalAddUpDia(
                                                id: secondList![index].id,
                                                inteEnum: _inteEnum!,
                                              ));
                                    }
                                  },
                                  color: kSecondaryColor,
                                ),
                              if (_showButtons)
                                BtnClass(
                                  title: "View Terminals",
                                  onTap: () {
                                    showDialog(
                                        context: context,
                                        builder: (_) => TerminalList(
                                              id: secondList![index].id,
                                              merchantName: _enum ?? '',
                                            ));
                                  },
                                  color: kSecondaryColor,
                                ),
                              // if (_enum == InteEnum.Mx.name)
                              //   BtnClass(
                              //     title: "Merchant Setup",
                              //     onTap: () async {
                              //       final _status = await showDialog(
                              //           barrierDismissible: false,
                              //           context: context,
                              //           builder: (_) => MxMerchantSetup());

                              //       if (_status != null &&
                              //           _status is bool &&
                              //           _status) {
                              //         final _payPro = Provider.of<PaymentPro>(
                              //             context,
                              //             listen: false);
                              //         _payPro.getData();
                              //       }
                              //     },
                              //     color: kSecondaryColor,
                              //   ),
                              // BtnClass(
                              //   title: LN.connect,
                              //   onTap: () {
                              //     showDialog(
                              //         barrierDismissible: false,
                              //         context: context,
                              //         builder: (_) => VisionPayPair());
                              //   },
                              //   color: kSecondaryColor,
                              // )
                            ],
                            moreOption: _enum == InteEnum.WindCave.name
                                ? PopupMenuButton(
                                    padding: EdgeInsets.zero,
                                    itemBuilder: (_) {
                                      return [
                                        PopupMenuItem(
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Icon(
                                                Icons.code,
                                                color: kPrimaryColor,
                                                size: size.getS(28),
                                              ),
                                              SizedBox(
                                                width: size.getW(12),
                                              ),
                                              Expanded(
                                                child: Text(
                                                  "View Console Logs",
                                                  style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: size.getS(18),
                                                  ),
                                                ),
                                              )
                                            ],
                                          ),
                                          onTap: () async {
                                            await Future.delayed(
                                                Duration(seconds: 1));
                                            showDialog(
                                              context: context,
                                              builder: (_) =>
                                                  ConsoleLogsWindCave(),
                                            );
                                          },
                                        ),
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
                                              Expanded(
                                                child: Text(
                                                  LN.lastTransactionReceipt,
                                                  style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: size.getS(18),
                                                  ),
                                                ),
                                              )
                                            ],
                                          ),
                                          onTap: () async {
                                            await Future.delayed(
                                                Duration(seconds: 1));

                                            showDialog(
                                              context: context,
                                              builder: (_) =>
                                                  PrintLastTransReceipt(
                                                id: secondList![index].id,
                                              ),
                                            );
                                          },
                                        ),
                                      ];
                                    },
                                    child: Icon(Icons.more_vert),
                                  )
                                : null,
                          );
                        },
                      ),
                    ],
                  )
                ],
                // if ()
                // EftposPairingSec()
              ],
            ),
          ),
        ),
      ],
    );
  }
}
