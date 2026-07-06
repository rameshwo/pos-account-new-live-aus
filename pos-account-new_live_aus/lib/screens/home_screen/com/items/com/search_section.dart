import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pos_account/config/utils/menu_schedule_utils.dart';
import 'package:pos_account/config/size_config.dart';
import 'package:pos_account/config/utils/utils.dart';
import 'package:pos_account/constant/constant.dart';
import 'package:pos_account/ln.dart';
import 'package:pos_account/providers/common/cus_list_pro.dart';
import 'package:pos_account/providers/cus_val_pro.dart';
import 'package:pos_account/providers/menu/place_order_pro.dart';
import 'package:pos_account/widgets/dialog/custom_dialog.dart';
import 'package:pos_account/widgets/input/text_form/text_form_widget.dart';
import 'package:pos_account/widgets/load_btn.dart';
import 'package:pos_account/widgets/refresh_btn.dart';
import 'package:provider/provider.dart';
import '../../../../initialize/screen_saver/pin_lock/pin_lock.dart';
import '../../dialogs/customer/customer_search.dart';
import '../sidebar/order_section/com/pay_method/com/cash_drawer_button.dart';

class SearchSection extends StatelessWidget {
  final PlaceOrderPro placeOrderPro;
  final GlobalKey<ScaffoldState> scafKey;
  const SearchSection({
    super.key,
    required this.placeOrderPro,
    required this.scafKey,
  });

  Future<void> customerHis(BuildContext ctx) async {
    await showDialog(
        context: ctx,
        builder: (builder) => SimpleDialog(
              titlePadding: EdgeInsets.zero,
              contentPadding: EdgeInsets.fromLTRB(12, 24, 12, 4),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15)),
              children: [
                ChangeNotifierProvider<CusListPro>(
                    create: (BuildContext context) => CusListPro(),
                    child: CustomerSearchDia())
              ],
            ));
  }

  // void showActiveDeviceDia(BuildContext context, {required Ssize size}) {
  //   showDialog(
  //       context: context,
  //       builder: (builder) => SimpleDialog(
  //             // backgroundColor: kPrimaryColor,
  //             titlePadding: EdgeInsets.zero,
  //             contentPadding: EdgeInsets.symmetric(
  //                 horizontal: size.getW(24), vertical: size.getH(24)),
  //             shape: RoundedRectangleBorder(
  //                 borderRadius: BorderRadius.circular(15)),
  //             children: [
  //               ActivateDevicePopup(
  //                 size: size,
  //                 isPopup: true,
  //               )
  //             ],
  //           ));
  // }

  @override
  Widget build(BuildContext context) {
    final size = Ssize(context);
    return Row(
      children: [
        // if (placeOrderPro.itemViewType == ItemViewType.product &&
        //     !GlobalCVP.isServiceStore) ...[
        //   SizedBox(
        //     width: size.getW(180),
        //     child: DropDownList(
        //       hint: LN.brand,
        //       isReq: false,
        //       vPad: 10,
        //       borderColor: Colors.black12,
        //       indexValue: placeOrderPro.brandIndex,
        //       list: placeOrderPro.initAddSec?.brands == null
        //           ? []
        //           : placeOrderPro.initAddSec!.brands!
        //               .map((e) => e.value ?? '')
        //               .toList(),
        //       onChange: (int? i) {
        //         placeOrderPro.brandIndex = i;
        //         placeOrderPro.loading = true;
        //         placeOrderPro.notify;
        //         placeOrderPro.getItemData();
        //       },
        //     ),
        //   ),
        //   SizedBox(width: size.getW(12))
        // ],
        Flexible(
          child: TextFormWidget(
            isReq: false,
            vPad: 10,
            prefixIcon: Icon(
              Icons.search,
              size: size.getS(32),
            ),
            borderRadius: 5,
            borderColor: Colors.black12,
            cltr: placeOrderPro.searchCltr,
            hintText: LN.search,
            onChanged: (p0) {
              if (p0 == null) return;

              Utils.handleSearch(callback: () async {
                placeOrderPro.loading = true;
                placeOrderPro.notify;
                placeOrderPro.getInitData(searchKey: p0);
              });
            },
            suffixIcon: placeOrderPro.searchCltr.text.isEmpty
                ? null
                : InkWell(
                    onTap: () {
                      placeOrderPro.searchCltr.clear();
                      placeOrderPro.getInitData(searchKey: '');
                      placeOrderPro.notify;
                    },
                    child: Icon(
                      Icons.close,
                      size: size.getS(28),
                      color: Colors.black,
                    ),
                  ),
          ),
        ),
        SizedBox(width: size.getW(12)),
        if (GlobalCVP.isHospitality) ...[
          LoadButton(
            btnText: placeOrderPro.orderTabName.isNotEmpty
                ? placeOrderPro.orderTabName
                : "Manage Tabs",
            hPad: 4,
            vPad: 8,
            suffix: placeOrderPro.orderTabName.isNotEmpty
                ? InkWell(
                    onTap: () {
                      placeOrderPro.orderTabName = "";
                      placeOrderPro.orderTabId = "";
                      placeOrderPro.orderTabLimit = null;
                      placeOrderPro.showManageTab = false;
                      placeOrderPro.reOrder = null;
                      placeOrderPro.clear();
                      placeOrderPro.notify;
                    },
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: size.getW(8), vertical: size.getH(2)),
                      child: Icon(
                        Icons.close,
                        color: Colors.white,
                        size: size.getS(26),
                      ),
                    ),
                  )
                : null,
            onsave: () async {
              // final _data = await manageTab(context);
              // if (_data != null && _data is OrderTabReq) {
              //   placeOrderPro.orderTabId = _data.id;
              //   placeOrderPro.orderTabName = _data.tabIdentification ?? '';
              //   placeOrderPro.notify;
              // }
              placeOrderPro.showManageTab = true;
              placeOrderPro.notify;
            },
            // width: 120,
            fontSize: 16,
          ),
          if (placeOrderPro.initAddSec?.menus?.isNotEmpty ?? false)
            Padding(
              padding: EdgeInsets.only(left: size.getW(8)),
              child: RefreshBtn(
                size: size,
                icon: SvgPicture.asset(
                  "assets/svg/icons/fork1.svg",
                  width: size.getW(32),
                  height: size.getW(32),
                  color: Colors.white,
                ),
                onTap: () async {
                  return showCupertinoDialog(
                    barrierDismissible: true,
                    context: context,
                    builder: (context) {
                      return _menuSection(
                        size,
                        context: context,
                      );
                    },
                  );
                },
              ),
            )
        ],
        // Padding(
        //   padding: EdgeInsets.only(left: size.getW(12)),
        //   child: RefreshBtn(
        //     size: size,
        //     icon: Icon(
        //       Icons.keyboard,
        //       color: Colors.white,
        //       size: size.getS(32),
        //     ),
        //     onTap: () async {
        //       placeOrderPro.showKeypad = true;
        //       placeOrderPro.notify;
        //     },
        //   ),
        // ),
        SizedBox(width: size.getW(8)),
        if (GlobalCVP.viewWidget.viewCashRegisterButton) CashDrawerButton(),
        if (GlobalCVP.userStoresRes?.enablePinCodePopUpScreen ?? false)
          Padding(
            padding: EdgeInsets.only(left: size.getW(8), right: size.getW(0)),
            child: RefreshBtn(
              size: size,
              icon: Icon(
                Icons.lock_outline,
                color: Colors.white,
                size: size.getS(32),
              ),
              onTap: () async {
                PinLockScreen.show();
              },
            ),
          ),
        // if (GlobalCVP.getMainPage != MainPage.SubscriptionPage &&
        //     GlobalCVP.getMainPage != MainPage.ActivatePosPage &&
        //     GlobalCVP.getMainPage != MainPage.NewOrgPage)
        //   Padding(
        //     padding: EdgeInsets.only(right: size.getW(16), top: size.getH(16)),
        //     child: InkWell(
        //       onTap: () {
        //         showActiveDeviceDia(context, size: size);
        //       },
        //       borderRadius: BorderRadius.circular(10),
        //       child: Image.asset(
        //         "assets/png/lock_icon.png",
        //         fit: BoxFit.cover,
        //         width: size.getW(44),
        //         height: size.getW(44),
        //       ),
        //     ),
        //   ),
        SizedBox(width: size.getW(8)),
        Tooltip(
          message: LN.cusSearch,
          child: InkWell(
            onTap: () => customerHis(context),
            borderRadius: BorderRadius.circular(100),
            child: CircleAvatar(
                radius: size.getS(24),
                backgroundColor: kSecondaryColor,
                child: Padding(
                  padding: EdgeInsets.all(size.getS(8)),
                  child: Icon(
                    Icons.person_search_outlined,
                    size: size.getS(28),
                    color: Colors.white,
                  ),
                )),
          ),
        ),
        // SizedBox(width: size.getW(8)),
        // if (GlobalCVP.viewWidget.viewProductRefreshButton)
        //   RefreshBtn(
        //     size: size,
        //     onTap: () async {
        //       placeOrderPro.loading = true;
        //       placeOrderPro.notify;
        //       placeOrderPro.selectedCatId = "";
        //       placeOrderPro.categoryTitle = null;
        //       placeOrderPro.selectedAlpha = null;
        //       placeOrderPro.selectedSubCatIndex = null;
        //       placeOrderPro.searchCltr.clear();
        //       placeOrderPro.brandIndex = null;
        //       placeOrderPro.promoId = null;
        //       Loading.dialog(
        //         context,
        //         title: "Retrieving Data",
        //         width: 200,
        //         height: 200,
        //       );

        //       // await GlobalCVP.getAllAddSection(isServerCall: true);

        //       await placeOrderPro.getAllProducts(isServerCall: true);
        //       MenuScheduleUtils.listen((slot) async {
        //         placeOrderPro.menuslot = slot;
        //         placeOrderPro.getItemData();
        //       });
        //       placeOrderPro
        //           .getOrderAddSection()
        //           .then((value) => placeOrderPro.getAllPromotions());
        //       placeOrderPro.setOrderNotes();
        //       placeOrderPro.getCusAddSec();

        //       final _payPro = Provider.of<PaymentPro>(context, listen: false);
        //       _payPro.getData(
        //           // initLoad: true
        //           );

        //       if (Navigator.canPop(context)) {
        //         Navigator.pop(context);
        //       }
        //       placeOrderPro.init();
        //     },
        //   ),
        // SizedBox(width: size.getW(4)),
        // RefreshBtn(
        //   icon: Icon(Icons.notifications),
        //   size: size,
        //   onTap: () async {
        //     // final _fcmToken = await FirebaseMessaging.instance.getToken();
        //     // print(_fcmToken);
        //     // NotificationApi.cancelNotification(NotificationApi.notiId!);
        //   },
        // )

        // SizedBox(width: size.getW(8)),
        // RefreshBtn(
        //   size: size,
        //   icon: Icon(
        //     Icons.textsms_sharp,
        //     size: size.getS(32),
        //     color: Colors.white,
        //   ),
        //   onTap: () async {
        //     for (int i = 0; i < 3; i++) {
        //       await Future.delayed(Duration(seconds: 1));
        //       CusNotifyDia.show(
        //         title: "New online order from Mallory Benton #${i + 1}",
        //         body:
        //             "New online order with order number 811220260428084604 from Mallory Benton with total amount 49.02",
        //         payLoad:
        //             "[{\"Name\":\"SendToKitchenPrinter\",\"Id\":\"945920cb-360e-4eac-a27b-01b9fcbc2401\"},{\"Name\":\"SendToKitchenDisplay\",\"Id\":\"945920cb-360e-4eac-a27b-01b9fcbc2401\"}]",
        //         // payload:
        //         //     "[{\"Title\":\"New order from Test\",\"Body\":\"New order with order number 946620260316103434 from Test with total amount 39.15\"}]",
        //       );
        //     }
        //     // Navigator.push(
        //     //   context,
        //     //   MaterialPageRoute(
        //     //     builder: (_) => PrinterTimingScreen(),
        //     //   ),
        //     // );
        //   },
        // )

        // SizedBox(
        //   width: size.getW(148),
        //   child: DropDownList(
        //     hint: GlobalCVP.isServiceStore ? LN.serviceType : LN.orderType,
        //     indexValue: placeOrderPro.orderTypeIndex,
        //     list: (placeOrderPro.initAddSec?.orderTypes == null)
        //         ? []
        //         : placeOrderPro.initAddSec!.orderTypes!
        //             .map((e) => e.value ?? '')
        //             .toList(),
        //     borderRadius: 5,
        //     textColor: Colors.white,
        //     fillColor: placeOrderPro.loading
        //         ? kPrimaryColor.withOpacity(0.6)
        //         : kPrimaryColor,
        //     dropDownColor: kPrimaryColor,
        //     borderColor:
        //         placeOrderPro.loading ? Colors.transparent : kPrimaryColor,
        //     iconEnableColor: Colors.white,
        //     hintTextColor: Colors.white,
        //     fontWeight: FontWeight.bold,
        //     fontFamily: '',
        //     fontSize: 14,
        //     vPad: 8,
        //     hPad: 0,
        //     onChange: placeOrderPro.loading
        //         ? null
        //         : (p0) {
        //             if (p0 == null) return;

        //             placeOrderPro.orderTypeIndex = p0;

        //             placeOrderPro.loading = true;
        //             placeOrderPro.notify;

        //             placeOrderPro.getInitData();
        //           },
        //   ),
        // )
      ],
    );
  }

  Widget _menuSection(
    Ssize size, {
    required BuildContext context,
  }) {
    final _placeOrder = Provider.of<PlaceOrderPro>(context);
    return CustomDialog(
      title: "Choose Menu",
      content: IntrinsicHeight(
        child: SizedBox(
          width: size.getW(400),
          child: Padding(
            padding: EdgeInsets.fromLTRB(
                size.getW(16), size.getW(4), size.getW(16), size.getW(16)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (_placeOrder.initAddSec?.menus != null)
                  ...List.generate(_placeOrder.initAddSec!.menus!.length,
                      (index) {
                    final _isSelected =
                        _placeOrder.initAddSec!.menus![index].isActive ?? false;
                    return Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: size.getW(4), vertical: size.getH(4)),
                      child: InkWell(
                        onTap: () {
                          for (final a in _placeOrder.initAddSec!.menus!) {
                            a.isActive = false;
                          }
                          _placeOrder.initAddSec!.menus![index].isActive = true;
                          _placeOrder.notify;
                        },
                        child: Container(
                          width: double.infinity,
                          padding: EdgeInsets.symmetric(
                              horizontal: size.getW(18),
                              vertical: size.getH(4)),
                          decoration: BoxDecoration(
                            color: _isSelected ? kUserColor : Colors.white,
                            border: Border.all(
                                color:
                                    _isSelected ? kUserColor : Colors.black54),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            _placeOrder.initAddSec!.menus![index].name ?? '',
                            style: TextStyle(
                              color: _isSelected ? Colors.white : kPrimaryColor,
                              fontSize: size.getH(22),
                              fontFamily: kFontFMedium,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    );
                  }),
                // Wrap(
                //   children: ,
                // ),
                SizedBox(height: size.getH(16)),
              ],
            ),
          ),
        ),
      ),
      actions: [
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Flexible(
              child: CupertinoButton(
                onPressed: () async {
                  for (final a in _placeOrder.initAddSec!.menus!) {
                    a.isActive = false;
                  }
                  Navigator.pop(context);
                  placeOrderPro.selectedCatId = "";
                  placeOrderPro.categoryTitle = null;
                  placeOrderPro.selectedAlpha = null;
                  placeOrderPro.selectedSubCatIndex = null;
                  placeOrderPro.searchCltr.clear();
                  placeOrderPro.brandIndex = null;
                  placeOrderPro.promoId = null;

                  // _placeOrder.menuslot = null;

                  // _placeOrder.getItemData();
                  MenuScheduleUtils.lastActiveKey = null;
                  await MenuScheduleUtils.runFun((slot) async {
                    _placeOrder.menuslot = slot;
                    _placeOrder.getItemData();
                  });

                  // if (MenuScheduleUtils.lastActiveKey == null) {
                  //   _placeOrder.menuslot = null;
                  //   _placeOrder.allCatFilter();
                  //   _placeOrder.getItemData();
                  // }
                },
                child: Text(
                  LN.clear,
                  style: TextStyle(
                    fontSize: size.getS(20),
                    color: Colors.red,
                    fontFamily: kFontFMedium,
                  ),
                ),
              ),
            ),
            SizedBox(width: size.getW(16)),
            Flexible(
                child: LoadButton(
              btnText: LN.confirm,
              vPad: 8,
              hPad: 4,
              fontSize: 20,
              onsave: () async {
                if (_placeOrder.initAddSec!.menus!
                    .any((a) => a.isActive ?? false)) {
                  final _menu = _placeOrder.initAddSec!.menus!
                      .firstWhere((a) => a.isActive ?? false);
                  if (_menu.id != null) {
                    Navigator.pop(context);
                    placeOrderPro.selectedCatId = "";
                    placeOrderPro.categoryTitle = null;
                    placeOrderPro.selectedAlpha = null;
                    placeOrderPro.selectedSubCatIndex = null;
                    placeOrderPro.searchCltr.clear();
                    placeOrderPro.brandIndex = null;
                    placeOrderPro.promoId = null;

                    try {
                      final _menuSchedule = MenuScheduleUtils.menuScheduleList
                          ?.firstWhere((a) =>
                              a.menuSchedule?.any((b) =>
                                  b.menuId?.toLowerCase() ==
                                  _menu.id?.toLowerCase()) ??
                              false);
                      final slot = _menuSchedule?.menuSchedule?.firstWhere(
                          (a) =>
                              a.menuId?.toLowerCase() ==
                              _menu.id?.toLowerCase());

                      // await _placeOrder.getAllProducts(isServerCall: true);
                      if (slot != null) {
                        _placeOrder.menuslot = [slot];
                        _placeOrder.getItemData();
                      }
                    } catch (e) {
                      //
                    }
                  }
                }
              },
            )),
            SizedBox(width: size.getW(16)),
          ],
        ),
      ],
    );
  }
}
