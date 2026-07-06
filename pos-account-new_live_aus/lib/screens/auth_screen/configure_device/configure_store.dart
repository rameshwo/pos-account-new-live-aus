import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pos_account/config/size_config.dart';
import 'package:pos_account/constant/constant.dart';
import 'package:pos_account/providers/auth/auth_pro.dart';
import 'package:pos_account/widgets/input/text_form/text_form_widget.dart';
import 'package:pos_account/widgets/input/text_form/title_text_form.dart';
import 'package:pos_account/widgets/load_btn.dart';
import 'package:pos_account/widgets/switch_adap.dart';
import 'package:provider/provider.dart';
import '../../custom_drawer/com/logo_sec.dart';

class ConfigureStoreScreen extends StatefulWidget {
  const ConfigureStoreScreen({
    super.key,
  });

  @override
  State<ConfigureStoreScreen> createState() => _ConfigureStoreScreenState();
}

class _ConfigureStoreScreenState extends State<ConfigureStoreScreen> {
  final _pageCltr = PageController();

  final _searchCltr = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();

    // final _authPro = Provider.of<AuthProvider>(context, listen: false);

    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   _authPro.getDeviceList();
    // });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = Ssize(context);
    final authPro = Provider.of<AuthProvider>(context);
    final _storeList = authPro.userStoreRes?.userStores;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: EdgeInsets.symmetric(
            horizontal: size.getW(24), vertical: size.getH(12)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                LogoSection(size: size, isAuth: false),
                Spacer(),
                LoadButton(
                  icon: Padding(
                    padding: EdgeInsets.only(right: size.getW(6)),
                    child: Icon(Icons.logout, size: size.getS(25)),
                  ),
                  btnText: "Logout",
                  btnColor: Colors.white,
                  textColor: kSecondaryColor,
                  shape: RoundedRectangleBorder(
                      side: BorderSide(color: kSecondaryColor, width: 2),
                      borderRadius: BorderRadiusGeometry.circular(10)),
                  onsave: () {
                    authPro.logOut();
                  },
                ),
              ],
            ),
            Expanded(
              child: PageView(
                controller: _pageCltr,
                physics: NeverScrollableScrollPhysics(),
                children: [
                  if ((_storeList?.isNotEmpty ?? false) &&
                      _storeList!.length > 1)
                    _storeSelection(size, authPro),
                  _deviceSelection(size, authPro),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _storeSelection(
    Ssize size,
    AuthProvider authPro,
  ) {
    final _storeList = authPro.userStoreRes?.userStores;
    final _filteredStoreList = _storeList
        ?.where((a) =>
            a.name?.toLowerCase().contains(_searchCltr.text.toLowerCase()) ??
            false)
        .toList();
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: size.width * 0.2),
      child: Column(
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Expanded(
                child: TextFormWidget(
                  isReq: false,
                  vPad: 14,
                  prefixIcon: Icon(
                    Icons.search,
                    size: size.getS(32),
                  ),
                  borderRadius: 5,
                  borderColor: Colors.black12,
                  cltr: _searchCltr,
                  hintText: "Search Store",
                  onChanged: (p0) {
                    if (p0 == null) return;
                    authPro.notify;
                  },
                  suffixIcon: _searchCltr.text.isEmpty
                      ? null
                      : InkWell(
                          onTap: () {
                            _searchCltr.clear();
                            authPro.notify;
                          },
                          child: Icon(
                            Icons.close,
                            size: size.getS(28),
                            color: Colors.black,
                          ),
                        ),
                ),
              ),
            ],
          ),
          SizedBox(height: size.getH(16.0)),
          if (_filteredStoreList != null)
            Flexible(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: _filteredStoreList.length,
                itemBuilder: (context, index) {
                  final store = _filteredStoreList[index];
                  return Padding(
                    padding: EdgeInsets.symmetric(vertical: size.getH(8)),
                    child: CupertinoButton(
                      padding: EdgeInsets.zero,
                      onPressed: () {
                        authPro.selectedStoreIndex = index;
                        authPro.notify;
                        // _changeStore(CUS_CTX!,
                        //     p0: index, placeOrderPro: placeOrderPro);
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: authPro.selectedStoreIndex == index
                              ? kSecondaryColor
                              : Colors.white,
                          border: Border.all(color: Colors.grey[300]!),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: size.getW(8.0),
                            vertical: size.getH(
                                authPro.selectedStoreIndex == index ? 12 : 8),
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: size.getS(50),
                                height: size.getS(50),
                                decoration: BoxDecoration(
                                  color: Colors.grey[200],
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Center(
                                  child: Text(
                                    store.name?.substring(0, 2).toUpperCase() ??
                                        'NA',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: size.getS(18),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(width: size.getW(16)),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      store.name ?? 'Unnamed Store',
                                      style: TextStyle(
                                        fontSize: size.getS(20),
                                        fontWeight: FontWeight.w500,
                                        color:
                                            authPro.selectedStoreIndex == index
                                                ? Colors.white
                                                : Colors.black,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              // Action icon
                              Container(
                                width: size.getS(40),
                                height: size.getS(40),
                                decoration: BoxDecoration(
                                  border: Border.all(
                                      color: authPro.selectedStoreIndex == index
                                          ? Colors.white
                                          : Colors.grey[300]!),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Icon(
                                  CupertinoIcons.forward,
                                  color: authPro.selectedStoreIndex == index
                                      ? Colors.white
                                      : Colors.black54,
                                  size: size.getS(24),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          SizedBox(height: size.getH(16)),
          LoadButton(
            width: 868,
            btnText: "Continue",
            fontSize: 20,
            btnColor: Colors.white,
            textColor: authPro.selectedStoreIndex != null
                ? kSecondaryColor
                : Colors.grey,
            shape: RoundedRectangleBorder(
                side: BorderSide(
                    color: authPro.selectedStoreIndex != null
                        ? kSecondaryColor
                        : Colors.grey,
                    width: 2),
                borderRadius: BorderRadiusGeometry.circular(10)),
            onsave: authPro.selectedStoreIndex != null
                ? () {
                    _pageCltr.animateToPage(1,
                        duration: Duration(milliseconds: 300),
                        curve: Curves.easeInOut);
                  }
                : null,
          ),
          // SizedBox(height: size.getH(24))
        ],
      ),
    );
  }

  Widget _deviceSelection(Ssize size, AuthProvider authPro) {
    // final _isPosDevice = (authPro.deviceTypeRes?.deviceTypes?.isNotEmpty ??
    //         false) &&
    //     authPro.selectedDeviceType != null &&
    //     (authPro.deviceTypeRes?.deviceTypes?[authPro.selectedDeviceType!].value
    //             ?.toLowerCase()
    //             .contains('pos') ??
    //         false);
    final _storeList = authPro.userStoreRes?.userStores;
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: size.getW(12)),
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: size.getH(24)),
              //   Text(
              //     "Select POS Device",
              //     style: TextStyle(
              //       fontSize: size.getS(19),
              //       fontFamily: kFontFRegular,
              //       color: Colors.black,
              //     ),
              //   ),
              //   SizedBox(height: size.getH(12)),
              //   if (authPro.deviceTypeRes?.deviceTypes != null)
              //     Row(
              //       children: List.generate(
              //           authPro.deviceTypeRes!.deviceTypes!.length, (i) {
              //         return Expanded(
              //           child: Card(
              //             color: authPro.selectedDeviceType == i
              //                 ? kSecondaryColor
              //                 : null,
              //             margin:
              //                 EdgeInsets.only(left: i == 0 ? 0 : size.getW(24)),
              //             shape: RoundedRectangleBorder(
              //                 borderRadius: BorderRadius.circular(10),
              //                 side: BorderSide(color: Colors.black38)),
              //             child: SizedBox(
              //               height: size.getH(60),
              //               child: InkWell(
              //                 borderRadius: BorderRadius.circular(10),
              //                 onTap: () {
              //                   authPro.selectedDeviceType = i;
              //                   authPro.notify;
              //                 },
              //                 child: Center(
              //                   child: Padding(
              //                     padding: EdgeInsets.symmetric(
              //                         vertical: size.getH(4.0),
              //                         horizontal: size.getW(24)),
              //                     child: Text(
              //                       authPro.deviceTypeRes!.deviceTypes![i]
              //                               .name ??
              //                           '',
              //                       style: TextStyle(
              //                         fontSize: size.getS(24),
              //                         fontFamily: kFontFMedium,
              //                         color: authPro.selectedDeviceType == i
              //                             ? Colors.white
              //                             : Colors.black,
              //                       ),
              //                       textAlign: TextAlign.center,
              //                     ),
              //                   ),
              //                 ),
              //               ),
              //             ),
              //           ),
              //         );
              //       }),
              //     ),
              // SizedBox(height: size.getH(24)),
              TitleTextForm(
                title: "POS Device Name",
                textCltr: authPro.deviceNameCltr,
                hintText: "Device Name",
                borderColor: Colors.black38,
                vPad: 16,
                borderRadius: 15,
                pWidth: 1,
                fontSize: 20,
              ),
              SizedBox(height: size.getH(24)),
              // if (_isPosDevice)
              Card(
                margin: EdgeInsets.zero,
                color: Colors.grey.shade50,
                shape: RoundedRectangleBorder(
                    side: BorderSide(color: Colors.black12),
                    borderRadius: BorderRadius.circular(5)),
                child: Padding(
                  padding: EdgeInsets.all(size.getS(24)),
                  child: Row(
                    children: [
                      Icon(Icons.devices, size: size.getS(25)),
                      SizedBox(width: size.getW(12)),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                "Main POS Device",
                                style: TextStyle(
                                  fontSize: size.getS(19),
                                  fontFamily: kFontFRegular,
                                  color: Colors.black,
                                ),
                              ),
                              SizedBox(width: size.getW(12)),
                              SwitchAdap(
                                size: size,
                                value: authPro.isMainDevice,
                                onChanged: (val) {
                                  authPro.isMainDevice = val;
                                  authPro.notify;
                                },
                              ),
                            ],
                          ),
                          Text(
                            "Enable this device as main pos to receive realtime notification, automatic and fast print. If configured as main pos this device should always open and have power turned off.",
                            style: TextStyle(
                              fontSize: size.getS(14),
                              color: Colors.black54,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: size.getH(60)),
              Row(
                children: [
                  if ((_storeList?.isNotEmpty ?? false) &&
                      _storeList!.length > 1)
                    Padding(
                      padding: EdgeInsets.only(right: size.getW(12)),
                      child: LoadButton(
                        btnText: "Back",
                        fontSize: 20,
                        icon: Padding(
                          padding: EdgeInsets.only(right: size.getW(8)),
                          child: Icon(Icons.arrow_back, size: size.getS(25)),
                        ),
                        btnColor: Colors.white,
                        textColor: kSecondaryColor,
                        shape: RoundedRectangleBorder(
                            side: BorderSide(color: kSecondaryColor, width: 2),
                            borderRadius: BorderRadiusGeometry.circular(10)),
                        onsave: () {
                          _pageCltr.animateToPage(0,
                              duration: Duration(milliseconds: 300),
                              curve: Curves.easeInOut);
                        },
                      ),
                    ),
                  Expanded(
                    child: LoadButton(
                      btnText: "Configure",
                      loading: authPro.configureLoad,
                      fontSize: 20,
                      btnColor: Colors.white,
                      textColor: kSecondaryColor,
                      shape: RoundedRectangleBorder(
                          side: BorderSide(color: kSecondaryColor, width: 2),
                          borderRadius: BorderRadiusGeometry.circular(10)),
                      onsave: () {
                        if (_formKey.currentState?.validate() ?? false) {
                          authPro.configureDevice();
                        }
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
