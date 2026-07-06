import 'package:flutter/material.dart';
import 'package:html_editor_enhanced/html_editor.dart';
import 'package:pos_account/config/size_config.dart';
import 'package:pos_account/constant/constant.dart';
import 'package:pos_account/ln.dart';
import 'package:pos_account/providers/menu/place_order_pro.dart';
import 'package:pos_account/providers/setting/store/store_pro_v2.dart';
import 'package:pos_account/widgets/description_view.dart';
import 'package:pos_account/widgets/input/dropdown/title_drop_down.dart';
import 'package:pos_account/widgets/load_btn.dart';
import 'package:pos_account/widgets/loading.dart';
import 'package:pos_account/widgets/switch_adap.dart';
import 'package:provider/provider.dart';
import '../../general/common/common_header.dart';
import 'widgets/store_card.dart';

class OtherSetStoreV2 extends StatefulWidget {
  final PageController pageController;
  const OtherSetStoreV2({super.key, required this.pageController});

  @override
  State<OtherSetStoreV2> createState() => _OtherSetStoreV2State();
}

class _OtherSetStoreV2State extends State<OtherSetStoreV2> {
  @override
  void initState() {
    super.initState();
    setData();
  }

  void setData() {
    final _storePro = Provider.of<StoreProV2>(context, listen: false);
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await _storePro.getAddSec();
      _storePro.getOtherSettingData();
    });
  }

  @override
  void dispose() {
    storePro.loading = true;
    super.dispose();
  }

  late StoreProV2 storePro;
  final _htmlController = HtmlEditorController();

  @override
  Widget build(BuildContext context) {
    final size = Ssize(context);
    storePro = Provider.of<StoreProV2>(context);
    return Processing(
      loading: storePro.updateLoadOtherSetting || storePro.loading,
      child: GestureDetector(
        onTap: () {
          _htmlController.clearFocus();
          FocusManager.instance.primaryFocus?.unfocus();
        },
        child: Column(
          children: [
            CommonHeader(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  IconButton(
                      onPressed: () {
                        widget.pageController.jumpToPage(0);
                      },
                      icon: Icon(Icons.arrow_back)),
                  Text(
                    LN.otherSettings,
                    style: TextStyle(
                      fontSize: size.getS(18),
                      fontFamily: kFontFMedium,
                    ),
                  ),
                  Spacer(),
                  // if (GlobalCVP.viewWidget.viewStorec)
                  LoadButton(
                    vPad: 10,
                    hPad: 4,
                    loading: storePro.updateLoadOtherSetting,
                    btnText: "Update",
                    loadingText: "Updating",
                    onsave: storePro.updateLoadOtherSetting
                        ? null
                        : () async {
                            FocusScope.of(context).unfocus();
                            final _status = await storePro.updateOtherSetting();
                            if (_status ?? false) {
                              final _placePro = Provider.of<PlaceOrderPro>(
                                  context,
                                  listen: false);
                              _placePro.getStoreInfo();
                            }
                          },
                  ),
                  SizedBox(width: size.getW(12)),
                ],
              ),
            ),
            SizedBox(
              height: size.getH(12),
            ),
            Expanded(
                child: SingleChildScrollView(
                    physics: BouncingScrollPhysics(),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: size.getH(12),
                          ),
                          StoreCardUI(
                              title: 'General Settings',
                              iconData: Icons.settings_outlined,
                              child: Padding(
                                  padding: EdgeInsets.only(
                                    top: size.getH(24),
                                  ),
                                  child: Wrap(
                                      spacing: size.getW(12),
                                      runSpacing: size.getH(24),
                                      children: [
                                        _switchTitle(
                                          size,
                                          title: LN.enableUnderMaintain,
                                          value: storePro.enableMaintain,
                                          onChanged: (val) {
                                            storePro.enableMaintain = val;
                                            storePro.notify;
                                          },
                                        ),
                                        _switchTitle(
                                          size,
                                          title: LN.enableGuestCheckout,
                                          value: storePro.enableGuestCheckout,
                                          onChanged: (val) {
                                            storePro.enableGuestCheckout = val;
                                            storePro.notify;
                                          },
                                        ),
                                        _switchTitle(
                                          size,
                                          title: LN.enableCopyrightFooter,
                                          value: storePro.enableCopyRightFoot,
                                          onChanged: (val) {
                                            storePro.enableCopyRightFoot = val;
                                            storePro.notify;
                                          },
                                        ),
                                        TitleDropDown(
                                          pWidth: 0.24,
                                          title: "Product Detail Screen",
                                          list: storePro.storeRes
                                                  ?.posProductDetailScreenTypes
                                                  ?.map((a) => a.name ?? '')
                                                  .toList() ??
                                              [],
                                          indexVal:
                                              storePro.prodDetailScreenIndex,
                                          onChanged: (val) {
                                            storePro.prodDetailScreenIndex =
                                                val;
                                            storePro.notify;
                                          },
                                        ),
                                        Container(
                                          margin: EdgeInsets.only(
                                              bottom: size.getH(12),
                                              right: size.getW(40)),
                                          decoration: BoxDecoration(
                                              color: kBackgroundColor,
                                              borderRadius:
                                                  BorderRadius.circular(10)),
                                          padding: EdgeInsets.symmetric(
                                              vertical: size.getH(8),
                                              horizontal: size.getW(24)),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
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
                                                height: 100,
                                                size: size,
                                                onSave: (st) {
                                                  storePro.copyRightFootDesc =
                                                      st;
                                                  storePro.notify;
                                                },
                                                htmlController: _htmlController,
                                                descriptionText: storePro
                                                        .copyRightFootDesc ??
                                                    "",
                                              ),
                                              SizedBox(
                                                height: size.getH(12),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ]))),
                          StoreCardUI(
                              title: 'Hospitality Online Settings',
                              iconData: Icons.hotel_outlined,
                              child: Padding(
                                  padding: EdgeInsets.only(
                                    top: size.getH(24),
                                  ),
                                  child: Wrap(
                                    spacing: size.getW(12),
                                    runSpacing: size.getH(24),
                                    children: [
                                      _switchTitle(
                                        size,
                                        title: "Enable Payment On PickUp",
                                        value: storePro.showPaymentOnPickUp,
                                        onChanged: (val) {
                                          storePro.showPaymentOnPickUp = val;
                                          storePro.notify;
                                        },
                                      ),
                                      _switchTitle(
                                        size,
                                        title: "Enable Payment On Delivery",
                                        value: storePro.showPaymentonDeli,
                                        onChanged: (val) {
                                          storePro.showPaymentonDeli = val;
                                          storePro.notify;
                                        },
                                      ),
                                      _switchTitle(
                                        size,
                                        title: "Auto Send To Kitchen",
                                        value: storePro.autoSendToKitOnline,
                                        onChanged: (val) {
                                          storePro.autoSendToKitOnline = val;
                                          storePro.notify;
                                        },
                                      ),
                                      _switchTitle(
                                        size,
                                        title: LN.enPayPair,
                                        value: storePro.enablePayWithPairing,
                                        onChanged: (val) {
                                          storePro.enablePayWithPairing = val;
                                          storePro.notify;
                                        },
                                      ),
                                      _switchTitle(
                                        size,
                                        title: "Enable Reserve Table",
                                        value: storePro.showReserveTable,
                                        onChanged: (val) {
                                          storePro.showReserveTable = val;
                                          storePro.notify;
                                        },
                                      ),
                                      _switchTitle(
                                        size,
                                        title: "Enable Google Login",
                                        value: storePro.enableGoogleLogin,
                                        onChanged: (val) {
                                          storePro.enableGoogleLogin = val;
                                          storePro.notify;
                                        },
                                      ),
                                      _switchTitle(
                                        size,
                                        title:
                                            "Enable Phone Number Verification",
                                        value: storePro.enablePhoneVerification,
                                        onChanged: (val) {
                                          storePro.enablePhoneVerification =
                                              val;
                                          storePro.notify;
                                        },
                                      ),
                                      _switchTitle(
                                        size,
                                        title:
                                            "Enable Docket Group Split Print",
                                        value:
                                            storePro.enableDocketGrpSplitPrint,
                                        onChanged: (val) {
                                          storePro.enableDocketGrpSplitPrint =
                                              val;
                                          storePro.notify;
                                        },
                                      ),
                                      TitleDropDown(
                                        pWidth: 0.24,
                                        title:
                                            "Pick Up / Delivery Time Interval",
                                        list: storePro.storeRes
                                                ?.pickUpDeliveryTimeIntervals
                                                ?.map((a) => a.name ?? '')
                                                .toList() ??
                                            [],
                                        indexVal:
                                            storePro.pickDeliIntervalIndex,
                                        onChanged: (val) {
                                          storePro.pickDeliIntervalIndex = val;
                                          storePro.notify;
                                        },
                                      ),
                                    ],
                                  ))),
                          StoreCardUI(
                              title: 'QR Order Settings',
                              iconData: Icons.qr_code,
                              child: Padding(
                                  padding: EdgeInsets.only(
                                    top: size.getH(24),
                                  ),
                                  child: Wrap(
                                      spacing: size.getW(12),
                                      runSpacing: size.getH(24),
                                      children: [
                                        _switchTitle(
                                          size,
                                          title: "Enable Payment on QR Order",
                                          value:
                                              storePro.enablePaymentOnQrOrder,
                                          onChanged: (val) {
                                            storePro.enablePaymentOnQrOrder =
                                                val;
                                            storePro.notify;
                                          },
                                        ),
                                      ]))),
                          StoreCardUI(
                              title: 'Kiosk',
                              iconData: Icons.desktop_mac_outlined,
                              child: Padding(
                                  padding: EdgeInsets.only(
                                    top: size.getH(24),
                                  ),
                                  child: Wrap(
                                      spacing: size.getW(12),
                                      runSpacing: size.getH(24),
                                      children: [
                                        _switchTitle(
                                          size,
                                          title: "Enable Pay at Counter",
                                          value:
                                              storePro.kioskEnablePayAtCounter,
                                          onChanged: (val) {
                                            storePro.kioskEnablePayAtCounter =
                                                val;
                                            storePro.notify;
                                          },
                                        ),
                                      ]))),
                          StoreCardUI(
                              title: 'Retail Online Settings',
                              iconData: Icons.shopping_cart,
                              child: Padding(
                                  padding: EdgeInsets.only(
                                    top: size.getH(24),
                                  ),
                                  child: Wrap(
                                      spacing: size.getW(12),
                                      runSpacing: size.getH(24),
                                      children: [
                                        _switchTitle(
                                          size,
                                          title: LN.enableOrderGiftForm,
                                          value: storePro.enableOrderGiftReFo,
                                          onChanged: (val) {
                                            storePro.enableOrderGiftReFo = val;
                                            storePro.notify;
                                          },
                                        ),
                                        _switchTitle(
                                          size,
                                          title: LN.enableFooter,
                                          value: storePro.enableFooter,
                                          onChanged: (val) {
                                            storePro.enableFooter = val;
                                            storePro.notify;
                                          },
                                        ),
                                      ]))),
                          SizedBox(
                            height: size.getH(48),
                          )
                        ])))
          ],
        ),
      ),
    );
  }

  Widget _switchTitle(
    Ssize size, {
    String title = "",
    bool value = false,
    Function(bool)? onChanged,
  }) {
    return SizedBox(
      width: size.getW(320),
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
