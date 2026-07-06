import 'package:flutter/material.dart';
import 'package:html_editor_enhanced/html_editor.dart';
import 'package:pos_account/config/size_config.dart';
import 'package:pos_account/constant/constant.dart';
import 'package:pos_account/ln.dart';
import 'package:pos_account/providers/cus_val_pro.dart';
import 'package:pos_account/providers/setting/store/store_pro.dart';
import 'package:pos_account/widgets/description_view.dart';
import 'package:pos_account/widgets/input/text_form/title_text_form.dart';
import 'package:pos_account/widgets/switch_adap.dart';
import 'package:provider/provider.dart';

class StoreOtherSetting extends StatefulWidget {
  // final StorePro storePro;
  final void Function()? cancel;
  const StoreOtherSetting({
    super.key,
    // required this.storePro,
    this.cancel,
  });

  @override
  State<StoreOtherSetting> createState() => _StoreOtherSettingState();
}

class _StoreOtherSettingState extends State<StoreOtherSetting> {
  final _scrollCltr = ScrollController();

  final _htmlController = HtmlEditorController();

  @override
  void initState() {
    super.initState();
  }

  void setData() {
    Future.delayed(Duration(milliseconds: 400), () {
      _scrollCltr.animateTo(0,
          duration: Duration(milliseconds: 300), curve: Curves.easeInOut);
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = Ssize(context);
    final storePro = Provider.of<StorePro>(context);
    return GestureDetector(
      onTap: () {
        _htmlController.clearFocus();
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: SingleChildScrollView(
        controller: _scrollCltr,
        physics: BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: size.getH(12),
            ),
            Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              child: SizedBox(
                width: double.infinity,
                child: Padding(
                  padding: EdgeInsets.symmetric(
                      vertical: size.getH(24.0), horizontal: size.getW(24)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _titleDataSection(
                        size,
                        title: LN.general,
                        children: [
                          SizedBox(
                            width: size.getW(260),
                            child: TitleTextForm(
                              title: GlobalCVP.isServiceStore
                                  ? "Update Service Channel"
                                  : LN.updateOrderChannel,
                              isReq: false,
                              textCltr: storePro.updateOrChCltr,
                            ),
                          ),
                          _switchTitle(
                            size,
                            title: LN.enableUnderMaintain,
                            value: storePro.enableMaintain,
                            onChanged: (val) {
                              storePro.enableMaintain = val;
                              storePro.notify();
                            },
                          ),
                          // if (!GlobalCVP.isServiceStore)
                          //   _switchTitle(
                          //     size,
                          //     title: "Enable Retail Screen",
                          //     value: storePro.isRetailScreen,
                          //     onChanged: (val) {
                          //       storePro.isRetailScreen = val;
                          //       storePro.notify();
                          //     },
                          //   ),
                          _switchTitle(
                            size,
                            title: LN.enableGuestCheckout,
                            value: storePro.enableGuestCheckout,
                            onChanged: (val) {
                              storePro.enableGuestCheckout = val;
                              storePro.notify();
                            },
                          ),
                          // _switchTitle(
                          //   size,
                          //   title: LN.livePaymentMode,
                          //   value: storePro.isLiveModeEnable,
                          //   onChanged: (val) {
                          //     storePro.isLiveModeEnable = val;
                          //     storePro.notify();
                          //   },
                          // ),
                          _switchTitle(
                            size,
                            title: LN.enableCopyrightFooter,
                            value: storePro.enableCopyRightFoot,
                            onChanged: (val) {
                              storePro.enableCopyRightFoot = val;
                              storePro.notify();
                            },
                          ),
                          // _switchTitle(
                          //   size,
                          //   title: LN.orPrintAuto,
                          //   value: storePro.orderPrintAutomatically,
                          //   onChanged: (val) {
                          //     storePro.orderPrintAutomatically = val;
                          //     storePro.notify();
                          //   },
                          // ),
                          // _switchTitle(
                          //   size,
                          //   title: LN.autoInvoicePrint,
                          //   value: storePro.printBillAutomatically,
                          //   onChanged: (val) {
                          //     storePro.printBillAutomatically = val;
                          //     storePro.notify();
                          //   },
                          // ),
                          Container(
                            margin: EdgeInsets.only(
                                top: size.getH(12),
                                bottom: size.getH(12),
                                right: size.getW(40)),
                            decoration: BoxDecoration(
                                color: kBackgroundColor,
                                borderRadius: BorderRadius.circular(10)),
                            padding: EdgeInsets.symmetric(
                                vertical: size.getH(8),
                                horizontal: size.getW(24)),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Copyright Footer Description",
                                  style: TextStyle(
                                    fontSize: size.getS(18),
                                    color: Colors.black,
                                  ),
                                ),
                                SizedBox(
                                  height: size.getH(12),
                                ),
                                DescriptionHtmlView(
                                  height: 200,
                                  size: size,
                                  onSave: (st) {
                                    storePro.copyRightFootDesc = st;
                                    storePro.notify();
                                  },
                                  htmlController: _htmlController,
                                  descriptionText:
                                      storePro.copyRightFootDesc ?? "",
                                ),
                                SizedBox(
                                  height: size.getH(12),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      _titleDataSection(
                        size,
                        title: LN.hospitalityOnline,
                        children: [
                          SizedBox(
                            width: size.getW(260),
                            child: TitleTextForm(
                              title: LN.tableQrOrderChannel,
                              isReq: false,
                              textCltr: storePro.tableQrOrChCltr,
                            ),
                          ),
                          _switchTitle(
                            size,
                            title: LN.showReserveTable,
                            value: storePro.showReserveTable,
                            onChanged: (val) {
                              storePro.showReserveTable = val;
                              storePro.notify();
                            },
                          ),
                          _switchTitle(
                            size,
                            title: LN.showPaymentPickup,
                            value: storePro.showPaymentOnPickUp,
                            onChanged: (val) {
                              storePro.showPaymentOnPickUp = val;
                              storePro.notify();
                            },
                          ),
                          _switchTitle(
                            size,
                            title: LN.showPaymentDine,
                            value: storePro.showPaymentOnDine,
                            onChanged: (val) {
                              storePro.showPaymentOnDine = val;
                              storePro.notify();
                            },
                          ),
                          _switchTitle(
                            size,
                            title: LN.showPaymentDelivery,
                            value: storePro.showPaymentonDeli,
                            onChanged: (val) {
                              storePro.showPaymentonDeli = val;
                              storePro.notify();
                            },
                          ),
                          _switchTitle(
                            size,
                            title: LN.enAutoSendKit,
                            value: storePro.autoSendToKitOnline,
                            onChanged: (val) {
                              storePro.autoSendToKitOnline = val;
                              storePro.notify();
                            },
                          ),
                          _switchTitle(
                            size,
                            title: LN.enPayPair,
                            value: storePro.enablePayWithPairing,
                            onChanged: (val) {
                              storePro.enablePayWithPairing = val;
                              storePro.notify();
                            },
                          ),
                          _switchTitle(
                            size,
                            title: LN.enAutoSendKitDisplay,
                            value: storePro.enableAuSeToKitDisOnOr,
                            onChanged: (val) {
                              storePro.enableAuSeToKitDisOnOr = val;
                              storePro.notify();
                            },
                          ),
                          _switchTitle(
                            size,
                            title: "Enable Payment on QR Order",
                            value: storePro.enablePaymentOnQrOrder,
                            onChanged: (val) {
                              storePro.enablePaymentOnQrOrder = val;
                              storePro.notify();
                            },
                          ),
                        ],
                      ),
                      _titleDataSection(
                        size,
                        title: LN.retailOnline,
                        children: [
                          _switchTitle(
                            size,
                            title: LN.enableOrderGiftForm,
                            value: storePro.enableOrderGiftReFo,
                            onChanged: (val) {
                              storePro.enableOrderGiftReFo = val;
                              storePro.notify();
                            },
                          ),
                          _switchTitle(
                            size,
                            title: LN.enableFooter,
                            value: storePro.enableFooter,
                            onChanged: (val) {
                              storePro.enableFooter = val;
                              storePro.notify();
                            },
                          ),
                        ],
                      ),
                      _titleDataSection(
                        size,
                        title: "KIOSK",
                        children: [
                          _switchTitle(
                            size,
                            title: "Enable Pay at Counter",
                            value: storePro.kioskEnablePayAtCounter,
                            onChanged: (val) {
                              storePro.kioskEnablePayAtCounter = val;
                              storePro.notify();
                            },
                          ),
                        ],
                      ),
                      // Wrap(
                      //   spacing: size.getW(24),
                      //   runSpacing: size.getH(24),
                      //   children: [

                      //   ],
                      // ),
                      // SizedBox(
                      //   height: size.getH(32),
                      // ),
                      Wrap(
                        spacing: size.getW(12),
                        runSpacing: size.getH(24),
                        children: [],
                      ),
                      SizedBox(
                        height: size.getH(24),
                      ),
                      // Row(
                      //   mainAxisSize: MainAxisSize.min,
                      //   children: [
                      //     if (GlobalCVP
                      //         .viewWidget.viewStoreGeneralTabSaveButton)
                      //       LoadButton(
                      //         loading: storePro.updateLoad,
                      //         onsave: storePro.updateLoad
                      //             ? null
                      //             : () => storePro.addData(context),
                      //       ),
                      //     SizedBox(
                      //       width: size.getW(24),
                      //     ),
                      //     if (GlobalCVP
                      //         .viewWidget.viewStoreGeneralTabCancelButton)
                      //       ElevatedButton(
                      //           style: ButtonStyle(
                      //               backgroundColor: MaterialStateProperty.all(
                      //                   Colors.red.shade800),
                      //               padding: MaterialStateProperty.all(
                      //                   EdgeInsets.symmetric(
                      //                       horizontal: size.getW(48),
                      //                       vertical: size.getH(8)))),
                      //           onPressed: widget.cancel,
                      //           child: Text(
                      //             LN.cancel,
                      //             style: TextStyle(
                      //               fontSize: size.getS(16),
                      //               color: Colors.white,
                      //               fontWeight: FontWeight.bold,
                      //             ),
                      //           )),
                      //   ],
                      // ),
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _titleDataSection(
    Ssize size, {
    String title = "",
    required List<Widget> children,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(title,
            style: TextStyle(
              fontSize: size.getS(21),
              color: Colors.black,
              // fontFamily: kFontFBold,
              fontWeight: FontWeight.bold,
            )),
        SizedBox(
          height: size.getH(16),
          child: Divider(
            color: Colors.black45,
          ),
        ),
        Wrap(
            spacing: size.getW(12),
            runSpacing: size.getH(24),
            children: children),
        SizedBox(
          height: size.getH(28),
        ),
      ],
    );
  }

  Widget _switchTitle(
    Ssize size, {
    String title = "",
    bool value = false,
    Function(bool)? onChanged,
  }) {
    return SizedBox(
      width: size.getW(260),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style: TextStyle(
                fontSize: size.getS(18),
                color: Colors.black,
              )),
          SizedBox(
            width: size.getW(16),
          ),
          SwitchAdap(
            size: size,
            value: value,
            activeColor: kPrimaryColor,
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }
}
